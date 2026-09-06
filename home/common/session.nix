# Shared desktop config for all hosts. Hardware-specific monitor layout stays
# in each host's own monitors.lua.
{ pkgs, ... }:
{
  xdg.dataFile."wallpapers/default.png".source = ./assets/wallpapers/default.png;

  xdg.configFile = {
    # Keep raw app config files in their native formats and link each app as a
    # directory instead of maintaining one large per-file registry here.
    "hypr" = {
      source = ./config/hypr;
      recursive = true;
    };
    "dunst" = {
      source = ./config/dunst;
      recursive = true;
    };
    "rofi" = {
      source = ./config/rofi;
      recursive = true;
    };
    "waybar" = {
      source = ./config/waybar;
      recursive = true;
    };
  };

  # Session daemons and config-backed desktop programs.
  services.hypridle.enable = true;
  services.dunst.enable = true;
  programs.hyprlock.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = ./config/rofi/default.rasi;
  };

  programs.waybar = {
    enable = true;
  };
}