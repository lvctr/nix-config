{ pkgs, ... }:
{
  imports = [
    ./common/hyprland.nix
    ./common/hypridle.nix
    ./common/hyprlock.nix
    ./common/dunst.nix
    ./common/rofi.nix
    ./common/kitty.nix
    ./common/shell.nix
    ./common/theme.nix
    ./common/xdg.nix
    (import ./common/waybar.nix { outputs = null; })
  ];

  xdg.configFile."hypr/monitors.conf".text = ''
    monitor = eDP-1, preferred, 0x0, 1
  '';

  home.stateVersion = "24.11";
}
