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
    (import ./common/waybar.nix { outputs = null; }) # single built-in panel - no need to target a specific connector
  ];

  xdg.configFile."hypr/monitors.conf".text = ''
    monitor = eDP-1, preferred, 0x0, 1
  '';

  home.stateVersion = "24.11";
}
