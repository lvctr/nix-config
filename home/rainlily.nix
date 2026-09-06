{ pkgs, ... }:
{
  imports = [
    ./common/hyprland.nix
    ./common/hypridle.nix
    ./common/hyprlock.nix
    ./common/dunst.nix
    ./common/rofi.nix
    ./common/shell.nix
    ./common/theme.nix
    (import ./common/waybar.nix { outputs = [ "DP-1" ]; }) # bar only on primary monitor - adjust to your real connector name
  ];

  # Monitor layout is hardware, stays out of common/hyprland.conf - append
  # it here instead. Adjust connector names/resolutions to your actual
  # rainlily setup (check with `hyprctl monitors` once booted).
  xdg.configFile."hypr/monitors.conf".text = ''
    monitor = DP-1, 2560x1440@144, 0x0, 1
    monitor = DP-2, 1920x1080@60, 2560x0, 1
  '';

  home.stateVersion = "24.11";
}
