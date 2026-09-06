{ ... }:
{
  imports = [
    ./default.nix
  ];

  # Monitor layout is hardware, stays out of common/config/hypr/hyprland.lua - append
  # it here instead. Adjust connector names/resolutions to your actual
  # rainlily setup (check with `hyprctl monitors` once booted).
  xdg.configFile."hypr/monitors.lua".text = ''
    hl.monitor({
        output = "DP-1",
        mode = "2560x1440@144",
        position = "0x0",
        scale = 1,
    })

    hl.monitor({
        output = "DP-2",
        mode = "1920x1080@60",
        position = "2560x0",
        scale = 1,
    })
  '';
}
