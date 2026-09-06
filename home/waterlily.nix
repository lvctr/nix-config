{ pkgs, ... }:
{
  imports = [
    ./common/session.nix
    ./common/development.nix
    ./common/theme.nix
    ./common/user.nix
  ];

  xdg.configFile."hypr/monitors.lua".text = ''
    hl.monitor({
        output = "eDP-1",
        mode = "preferred",
        position = "0x0",
        scale = 1,
    })
  '';

  home.stateVersion = "24.11";
}
