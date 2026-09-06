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
- Disk device and swap size in each `hosts/<name>/disko.nix` (defaults to `/dev/nvme0n1` and `40G` — check `lsblk` and actual RAM size on each real machine)
- `username` in `flake.nix` (currently `"you"`)
- Monitor connector names/resolutions in `home/rainlily.nix`, `home/riverlily.nix`, `home/waterlily.nix` (check with `hyprctl monitors` after first boot)
- `system.stateVersion` / `home.stateVersion` — set to whatever NixOS release you actually install with, then never change it afterward

**Placeholder package hashes** (every `pkgs/*.nix` file, and `home/common/shell.nix`'s zinit fetch):
Each has a fake `sha256-AAAA...` hash. Run the build once; Nix will refuse and print the real hash in its error message — paste that in. This is the normal Nix workflow for a new `fetchFromGitHub`/`fetchFromGitLab` call, not a mistake to fix by hand.

**Genuinely unverified content, flagged in-file:**
- `pkgs/xcursor-simp1e-solarized-dark.nix` and `pkgs/ttf-google-sans.nix` — need their real build steps copied from the actual AUR PKGBUILDs, not just a source fetch
- `modules/desktop/theming.nix` — the `kdePackages.*` paths for plasma-integration/breeze/kde-cli-tools should be checked against your actual nixpkgs revision (this has moved around across KDE 5→6)
- `modules/fonts.nix` — several font package names are best-guesses, verify each with `nix search nixpkgs <name>`
- `modules/desktop/audio.nix` — check whether `pavoldcontrol` exists in nixpkgs, or whether nixpkgs' own `pavucontrol` is still pre-6.0/GTK3 (in which case you don't need a replacement at all)
- `home/common/gtk-theming.nix` — verify the exact filenames inside adw-colors' `adw-solarized` theme folder
- **`install.sh`'s disko step** — `modules/partitions.nix` now bundles the LUKS/TPM2 wiring (`boot.initrd.luks.devices.*`) alongside `disko.devices` in one file, since they share magic strings that need to stay in sync. Whether the standalone `disko --mode disko <file>` CLI invocation is happy evaluating a file with both kinds of option in it together is unverified - see the comment right above that line in `install.sh` for the fallback if it isn't.

## Bootstrap, per host

```
# on the minimal NixOS ISO
git clone <this-repo-url> /tmp/nix-config && cd /tmp/nix-config
./install.sh rainlily   # or riverlily / waterlily
```

`install.sh` runs the disko → TPM enrollment → hardware-configuration.nix
generation → `nixos-install` sequence for you. It deliberately still stops
for input at: the root LUKS passphrase, the swap LUKS passphrase, and the
one-time passphrase re-entry each TPM enrollment needs to authorize itself
— none of that belongs in a script argument or a file. It prints the
remaining one-time post-install steps (user password, fscrypt, restic,
Qt colour scheme) at the end.

If you'd rather run the steps by hand instead of trusting the script, they're:

1. `export NIX_CONFIG="experimental-features = nix-command flakes"`
2. `sudo nix run github:nix-community/disko -- --mode disko ./hosts/<hostname>/disko.nix`
3. `sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= /dev/disk/by-partlabel/root`
   and the same for `/dev/disk/by-partlabel/swap`
4. `sudo nixos-generate-config --no-filesystems --root /mnt` then copy the
   result into `hosts/<hostname>/hardware-configuration.nix`
5. `sudo nixos-install --root /mnt --flake .#<hostname>`
6. Reboot, remove install media. Limine boots, TPM unlocks silently. You
   land at a TTY — no display manager, on purpose. Log in, run
   `start-hyprland` yourself.
7. One-time, after first login: fscrypt setup (`modules/hardening.nix`),
   restic repo/password files (`modules/backup.nix`), Qt colour scheme
   application (`modules/desktop/theming.nix`) — each has the exact
   commands in a comment at its own module.

Repeat for each of the three hostnames.
