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

    hl.monitor({
        output = "HDMI-A-2",
        mode = "3840x2160@30",
        position = "0x0",
        scale = 2,
    })
  '';
}
