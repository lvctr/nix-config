# Shared desktop config for all hosts. Hardware-specific monitor layout stays
# in each host's own monitors.lua.
{ pkgs, ... }:
let
  mkConfigSource = source: { inherit source; };
  mkExecutableConfig = source: {
    inherit source;
    executable = true;
  };

  hyprConfigDir = ./config/hypr;
  waybarConfigDir = ./config/waybar;
in
{
  xdg.dataFile."wallpapers/default.png".source = ./assets/wallpapers/default.png;

  xdg.configFile = {
    # Plain-file symlinks rather than re-expressing native config syntaxes as
    # nested Nix attributes.
    "hypr/hyprland.lua" = mkConfigSource (hyprConfigDir + /hyprland.lua);
    "hypr/hypridle.conf" = mkConfigSource (hyprConfigDir + /hypridle.conf);
    "hypr/hyprlock.conf" = mkConfigSource (hyprConfigDir + /hyprlock.conf);
    "hypr/hyprpaper.conf" = mkConfigSource (hyprConfigDir + /hyprpaper.conf);
    "hypr/xdph.conf" = mkConfigSource (hyprConfigDir + /xdph.conf);

    "dunst/dunstrc" = mkConfigSource ./config/dunst/dunstrc;
    "rofi/dunst.rasi" = mkConfigSource ./config/rofi/dunst.rasi;

    "waybar/config.jsonc" = mkConfigSource (waybarConfigDir + /config.jsonc);
    "waybar/style.css" = mkConfigSource (waybarConfigDir + /style.css);
    "waybar/scripts/cpu.sh" = mkExecutableConfig (waybarConfigDir + /scripts/cpu.sh);
    "waybar/scripts/openweathermap-simple.sh" = mkExecutableConfig (waybarConfigDir + /scripts/openweathermap-simple.sh);
    "waybar/scripts/power-usage.sh" = mkExecutableConfig (waybarConfigDir + /scripts/power-usage.sh);
    "waybar/scripts/system-cpu-frequency.sh" = mkExecutableConfig (waybarConfigDir + /scripts/system-cpu-frequency.sh);
  };

  # Session daemons and config-backed desktop programs.
  services.hypridle.enable = true;
  services.dunst.enable = true;
  programs.hyprlock.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = ./config/rofi/solarized.rasi;
  };

  programs.waybar = {
    enable = true;
  };
}