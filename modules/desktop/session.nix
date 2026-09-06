{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  # No display manager, no autologin - `start-hyprland` (ships with the
  # hyprland package) is run manually from a TTY, by design.

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    rofi
    waybar
    hyprpaper
    dunst
    hyprlock
    hypridle
    hyprpicker
    brightnessctl
    playerctl
    grim
    slurp
    wl-clipboard
  ];
}