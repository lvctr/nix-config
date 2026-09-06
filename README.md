# nix-config

NixOS flake for three hosts: `rainlily` (desktop, 7950X3D + RTX 4080),
`riverlily` (laptop, Intel Core Ultra 155U / ThinkPad X1 12th-gen), and
`waterlily` (test machine, ThinkPad T480s).

This is a first pass built from a long design conversation, not a
build-tested config — see the TODO list below before trusting it against
real hardware. Nothing here has actually been run through `nix build` or
`nixos-rebuild`, since that requires the real disks, the real TPMs, and a
NixOS/Nix environment this was not written from.

## Fill in before first use

**Secrets — none of these belong in git, ever:**
- User account password (set interactively via `passwd` post-install)
- Root/swap LUKS passphrases (typed interactively when `disko` runs)
- `/etc/restic/repository` and `/etc/restic/password` (created by hand per host, see `modules/backup.nix`)

**Per-host facts, currently placeholders:**
- `time.timeZone` in each `hosts/<name>/default.nix` (`"REPLACE-ME"`)
- Swap size in each `hosts/<name>/default.nix` (check actual RAM size on each real machine). `install.sh` asks for the disk device right before it runs disko and writes it to an untracked `hosts/<name>/disk.nix`.
- `username` in `flake.nix` (currently `"you"`)
- Monitor connector names/resolutions in `home/rainlily.nix`, `home/riverlily.nix`, `home/waterlily.nix` (check with `hyprctl monitors` after first boot)
- `system.stateVersion` / `home.stateVersion` — set to whatever NixOS release you actually install with, then never change it afterward

**Placeholder package hashes** (every `pkgs/*.nix` file, and `home/common/shell.nix`'s zinit fetch):
Each has a fake `sha256-AAAA...` hash. Run the build once; Nix will refuse and print the real hash in its error message — paste that in. This is the normal Nix workflow for a new fixed-output fetch, not a mistake to fix by hand. For Google Sans specifically, `scripts/update-ttf-google-sans-hash.sh` prefetches the upstream tarball and patches `pkgs/ttf-google-sans.nix` automatically.

**Genuinely unverified content, flagged in-file:**
- `modules/desktop/theme.nix` — the `kdePackages.*` paths for plasma-integration/breeze/kde-cli-tools should be checked against your actual nixpkgs revision (this has moved around across KDE 5→6)
- `modules/fonts.nix` — several font package names are best-guesses, verify each with `nix search nixpkgs <name>`
- `modules/desktop/audio.nix` — check whether `pavoldcontrol` exists in nixpkgs, or whether nixpkgs' own `pavucontrol` is still pre-6.0/GTK3 (in which case you don't need a replacement at all)

## Bootstrap, per host

```
# on the minimal NixOS ISO
git clone <this-repo-url> /tmp/nix-config && cd /tmp/nix-config
./install.sh rainlily   # or riverlily / waterlily
```

`install.sh` runs the disko → TPM enrollment → hardware-configuration.nix
generation → `nixos-install` sequence for you. It deliberately still stops
for input at: the target disk device, the root LUKS passphrase, the swap
LUKS passphrase, and the one-time passphrase re-entry each TPM enrollment
needs to authorize itself. The chosen disk is written to an untracked
`hosts/<hostname>/disk.nix`; the secrets still never belong in a
script argument or a file. It prints the
remaining one-time post-install steps (user password, fscrypt, restic,
Qt colour scheme) at the end.

If you'd rather run the steps by hand instead of trusting the script, they're:

1. `export NIX_CONFIG="experimental-features = nix-command flakes"`
2. `lsblk`, then write `hosts/<hostname>/disk.nix` with the real disk device
3. `sudo env NIX_CONFIG="$NIX_CONFIG" nix run github:nix-community/disko -- --mode disko --flake path:$PWD#<hostname>`
4. `sudo udevadm settle`
5. `sudo blkid -t PARTLABEL=disk-main-root -o device` and `sudo blkid -t PARTLABEL=disk-main-swap -o device`
   (fall back to `root` / `swap` if you ever rename the partition labels)
6. `sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= <root-device>`
   and the same for `<swap-device>`
7. `sudo nixos-generate-config --no-filesystems --root /mnt` then copy the
   result into `hosts/<hostname>/hardware-configuration.nix`
8. `sudo nixos-install --root /mnt --flake path:$PWD#<hostname>`
9. Reboot, remove install media. Limine boots, TPM unlocks silently. You
   land at a TTY — no display manager, on purpose. Log in, run
   `start-hyprland` yourself.
10. One-time, after first login: fscrypt setup (`modules/hardening.nix`),
   restic repo/password files (`modules/backup.nix`), Qt colour scheme
   application (`modules/desktop/theme.nix`) — each has the exact
   commands in a comment at its own module.

Repeat for each of the three hostnames.
