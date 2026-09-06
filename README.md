# lvctr's nix configuration

### Specs

|  | rainlily | riverlily | waterlily |
|--|--|--|--|
| **Class** | Desktop | Laptop | Laptop |
| **Host** | GIGABYTE AORUS X570 | Lenovo ThinkPad X1 Carbon Gen 12 | Lenovo ThinkPad T480s |
| **CPU** | AMD Ryzen 9 7950X3D | Intel Core Ultra 7 155U | Intel Core i7-8650U |
| **GPU** | Nvidia GeForce RTX 4080 | Intel Arc Xe-LPG 64EU | Intel UHD 620 |
| **RAM** | 64GB DDR5-6000 | 32GB LPDDR5x-6400 | 24GB DDR4-2400 |

FUN FACT: waterlily's display died as I was installing Nix on it because I dropped it while trying to remove the USB stick... ToT

## Environment

### Shell
Main shell is `zsh` with the following plugins:

- `zsh-autosuggestions`
- `zsh-completions`
- `zsh-syntax-highlighting`
- `sudo`
- `git`
- `colored-man-pages`

managed with `zinit`.

### Desktop

I don't use a display manager. Enter with `start-hyprland`.

|||
|--|--|
| **wm** | `hyprland` |
| **bar** | `waybar` |
| **menu** | `rofi` |
| **notifs** | `dunst` |
| **lock** | `hyprlock` |
| **idle** | `hypridle` |
| **bg** | `hyprpaper` |
| **ime** | `fcitx5` with `fcitx5-mozc` |
|||

### Theme

I use [Solarized](https://ethanschoonover.com/solarized/) for everything.

|||
|--|--|
| **gtk** | `adw-gtk3` with `adw-colors` |
| **qt** | `kde-breeze-solarized` |
| **cursors** | `xcursor-simp1e-solarized-dark` |
| **icons** | `yet-another-monochrome-icon-set` with `papirus-icon-theme` |
|||

### Programs
|||
|--|--|
| **term** | `kitty` |
| **browser** | `librewolf` and `ungoogled-chromium` |
| **fm** | `pcmanfm` with `engrampa` |
| **video** | `vlc` and `mpv` with `svp` |
| **audio** | `spotify` |
| **images** | `viewnior` |
|||

### Hardening
- two-stage encryption with `LUKS` for the entire partition and `fscrypt` for the home folder
  - it's entirely unnecessary but I like it

### Others

- `tlp` on `riverlily` and `waterlily` for laptop power management
- `restic` for backups with hooks defined in `modules/backup.nix`
- `openrgb` and `i2c-tools` support for RGB control

## Installation

### Bootstrap

On the minimal NixOS ISO:

```bash
NIX_CONFIG="experimental-features = nix-command flakes" nix run nixpkgs#git -- clone https://github.com/lvctr/nix-config.git /tmp/nix-config
cd /tmp/nix-config
./install.sh rainlily
# or: ./install.sh riverlily
# or: ./install.sh waterlily
```

The installer handles the following flow automatically:

1. Ask for the target disk.
2. Write `hosts/<hostname>/disk.nix`.
3. Run `disko`.
4. Resolve the root and swap LUKS devices by partition label.
5. Enroll both devices into TPM2.
6. Generate `hardware-configuration.nix`.
7. Run `nixos-install`.
8. Prompt for the configured user password inside `/mnt`.

And it will deliberately ask for the following secrets interactively:

- the target disk device
- the swap and root LUKS passphrase
- the passphrase re-entry needed for TPM enrollment
- the root and user account password after install

This repo uses `path:$PWD#<hostname>` during install so generated local files like `hosts/<hostname>/disk.nix` are visible to flake evaluation.

### Post-Install

After first boot:

1. Log in on the TTY.
2. Start Hyprland with `start-hyprland`.
3. Do the one-time setup below.

#### One-time setup

For `fscrypt` home-directory encryption:

```bash
sudo fscrypt setup
sudo fscrypt encrypt /home/<username> --source=pam_passphrase
```

For `restic` backup secrets:

```bash
sudo mkdir -p /etc/restic
echo "rest:http://backupuser:PASSWORD@truenas.local:8000/home-backups" | sudo tee /etc/restic/repository
echo "YOUR-RESTIC-ENCRYPTION-PASSPHRASE" | sudo tee /etc/restic/password
sudo chmod 600 /etc/restic/repository /etc/restic/password
```

## Structure

The repo is split roughly like this:

- `hosts/` for per-machine hardware facts and swap sizing
- `modules/` for shared NixOS modules
- `home/` for Home Manager config
- `home/common/config/` for dotfiles
- `pkgs/` for custom packaged assets
- `overlays/` for exposing those custom packages to the system