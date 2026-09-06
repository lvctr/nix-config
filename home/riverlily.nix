{ pkgs, ... }:
{
  imports = [
    (import ./common/desktop.nix { outputs = null; })
    ./common/development.nix
    ./common/theme.nix
    ./common/user.nix
  ];

  xdg.configFile."hypr/monitors.conf".text = ''
    monitor = eDP-1, preferred, 0x0, 1
  '';

  home.stateVersion = "24.11";
}
