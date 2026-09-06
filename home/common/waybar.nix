# Always called explicitly from each host's home/<name>.nix, e.g.:
#   (import ../common/waybar.nix { outputs = null; })          # every connected output
#   (import ../common/waybar.nix { outputs = [ "DP-1" ]; })    # just this one
#
# (A bare `imports = [ ./waybar.nix ];` would NOT work here - this file is a
# function of `outputs`, not a module on its own, so it always needs to be
# called first. Keeping every host's call explicit, even the "no override"
# case, avoids the two calling conventions silently diverging.)
{ outputs ? null }:
{ pkgs, ... }:
{
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
