{ pkgs, ... }:
{
  imports = [
    (import ./common/desktop.nix { outputs = [ "DP-1" ]; })
    ./common/development.nix
    ./common/theme.nix
    ./common/user.nix
  ];

  # Monitor layout is hardware, stays out of common/config/hypr/hyprland.conf - append
  # it here instead. Adjust connector names/resolutions to your actual
  # rainlily setup (check with `hyprctl monitors` once booted).
  xdg.configFile."hypr/monitors.conf".text = ''
    monitor = DP-1, 2560x1440@144, 0x0, 1
    monitor = DP-2, 1920x1080@60, 2560x0, 1
  '';

  home.stateVersion = "24.11";
}
