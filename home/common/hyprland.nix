{ config, pkgs, ... }:
{
  # Plain-file symlink rather than home-manager's programs.hyprland.settings -
  # Hyprland's native config syntax isn't worth re-expressing as nested Nix
  # attributes, and this avoids ever lagging behind a new Hyprland feature.
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  # Referenced from within hyprland.conf as exec-once lines:
  #   dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
  #   fcitx5 -d
  #
  # NOTE: hyprland.conf itself is not written by this repo - put your
  # actual keybinds/window rules/exec-once lines in
  # home/common/hyprland.conf (plain text, not Nix) and monitor= lines in
  # each host's own home/<name>.nix instead (see below).
}
