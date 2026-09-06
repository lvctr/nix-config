# Always called explicitly from each host's home/<name>.nix, e.g.:
#   (import ../common/desktop.nix { outputs = null; })
#   (import ../common/desktop.nix { outputs = [ "DP-1" ]; })
{ outputs ? null }:
{ pkgs, ... }:
{
  # Plain-file symlinks rather than re-expressing native config syntaxes as
  # nested Nix attributes.
  xdg.configFile."hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
  xdg.configFile."hypr/hypridle.conf".source = ./config/hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".source = ./config/hypr/hyprlock.conf;
  xdg.configFile."dunst/dunstrc".source = ./config/dunst/dunstrc;

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  services.dunst.enable = true;

  # Mainline rofi (not the old rofi-wayland fork) - Wayland support was
  # merged upstream in 2025, this is the correct package now.
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = ./config/rofi/solarized.rasi;
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];
    } // (if outputs != null then { output = outputs; } else { });

    style = ''
      * {
        font-family: "Source Han Code JP";
        font-size: 12px;
      }
      window#waybar {
        background-color: #002b36;
        color: #839496;
      }
      #workspaces button.active {
        background-color: #268bd2;
      }
    '';
  };
}