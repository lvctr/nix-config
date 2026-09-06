{ pkgs, ... }:
{
  # Mainline rofi (not the old rofi-wayland fork) - Wayland support was
  # merged upstream in 2025, this is the correct package now.
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = ./rofi-solarized.rasi;
  };
}
