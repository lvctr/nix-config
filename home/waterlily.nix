{ ... }:
{
  imports = [
    ./default.nix
  ];

  xdg.configFile."hypr/monitors.lua".text = ''
    hl.monitor({
        output = "eDP-1",
        mode = "preferred",
        position = "0x0",
        scale = 1,
    })
  '';
}
