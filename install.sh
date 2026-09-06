#!/usr/bin/env bash
#
# Run this FROM THE MINIMAL NIXOS ISO, from inside a clone of this repo.
#
#   ./install.sh rainlily
#   ./install.sh riverlily
#   ./install.sh waterlily
#
# What this does NOT automate, on purpose:
#   - The root and swap LUKS passphrases (typed interactively, twice, when
#     disko runs) - these are secrets and never touch a script argument
#     or a file.
#   - TPM2 enrollment's own passphrase prompt (systemd-cryptenroll needs
#     you to type the passphrase you just set, once per device, to
#     authorize adding the TPM keyslot).
#   - The user account password and the restic/fscrypt one-time setup
#     that only makes sense once you've actually logged in - see the
#     printed instructions at the end.
set -euo pipefail

HOSTNAME="${1:-}"
if [[ -z "$HOSTNAME" ]]; then
  echo "Usage: $0 <rainlily|riverlily|waterlily>" >&2
  exit 1
fi
if [[ ! -d "hosts/$HOSTNAME" ]]; then
  echo "No hosts/$HOSTNAME directory here - run this from the repo root." >&2
  exit 1
fi

export NIX_CONFIG="experimental-features = nix-command flakes"
FLAKE_REF="path:$PWD#$HOSTNAME"
INSTALL_USERNAME="$(nix eval --extra-experimental-features 'nix-command flakes' --impure --raw --expr '
  let
    flake = builtins.getFlake (toString ./.);
    users = builtins.attrNames flake.nixosConfigurations."'"$HOSTNAME"'".config.home-manager.users;
  in
    if builtins.length users == 1 then builtins.head users else
      builtins.throw "expected exactly one Home Manager user"
')"

echo "==> Available block devices"
lsblk
echo
read -r -p "Disk device to erase for $HOSTNAME (for example, /dev/nvme0n1): " DISKO_DEVICE
if [[ ! -b "$DISKO_DEVICE" ]]; then
  echo "Not a block device: $DISKO_DEVICE" >&2
  exit 1
fi

cat > "hosts/$HOSTNAME/disk.nix" <<EOF
{ ... }:
{
  _module.args.disk = {
    device = "$DISKO_DEVICE";
  };
}
EOF

echo "==> Partitioning + formatting $DISKO_DEVICE for $HOSTNAME"
echo "    (you'll be prompted for the swap LUKS passphrase first, then the root one)"
sudo env NIX_CONFIG="$NIX_CONFIG" \
  nix run github:nix-community/disko -- --mode disko --flake "$FLAKE_REF"

sudo udevadm settle

ROOT_LUKS_DEVICE="$({
  sudo blkid -t PARTLABEL=disk-main-root -o device || true
  sudo blkid -t PARTLABEL=root -o device || true
} | head -n1)"
SWAP_LUKS_DEVICE="$({
  sudo blkid -t PARTLABEL=disk-main-swap -o device || true
  sudo blkid -t PARTLABEL=swap -o device || true
} | head -n1)"

if [[ -z "$ROOT_LUKS_DEVICE" || -z "$SWAP_LUKS_DEVICE" ]]; then
  echo "Could not resolve one or both LUKS partition devices after disko." >&2
  echo "Current block devices:" >&2
  lsblk -o PATH,PARTLABEL,FSTYPE,MOUNTPOINTS >&2
  exit 1
fi

echo
echo "==> Enrolling TPM2 (no PCR binding) on both LUKS devices"
echo "    (you'll be asked for the passphrase you just set, once per device,"
echo "     to authorize the TPM enrollment)"
echo "    root: $ROOT_LUKS_DEVICE"
echo "    swap: $SWAP_LUKS_DEVICE"
echo "    enrolling root first, then swap"
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= "$ROOT_LUKS_DEVICE"
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= "$SWAP_LUKS_DEVICE"

echo
echo "==> Generating hardware-configuration.nix (filesystems skipped - disko already declared those)"
sudo nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix "hosts/$HOSTNAME/hardware-configuration.nix"

echo
echo "==> Installing NixOS for #$HOSTNAME"
sudo nixos-install --root /mnt --flake "$FLAKE_REF"

echo
echo "==> Setting password for $INSTALL_USERNAME"
sudo nixos-enter --root /mnt -c "passwd $INSTALL_USERNAME"

cat <<EOF

==> Install complete.

Next:
  1. Reboot and remove the install media.
  2. Limine boots, TPM unlocks both devices silently. You land at a TTY -
     no display manager, by design. Log in, then run: start-hyprland
  3. After first login, the one-time setup steps that only make sense on
     a running system - each has the exact commands in a comment at its
     own module:
       - modules/hardening.nix       (fscrypt setup + encrypt /home/<user>)
       - modules/backup.nix        (restic repository/password files)
       - modules/desktop/theming.nix (Qt colour scheme application)
EOF
