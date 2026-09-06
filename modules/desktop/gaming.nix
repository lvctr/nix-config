{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    remotePlay.openFirewall = false; # flip to true if you want to stream to another device
  };

  programs.gamemode.enable = true;

  environment.systemPackages = [ pkgs.mangohud ];

  # UMU-launcher deliberately not included - it's only relevant for
  # Windows games launched outside Steam (via Heroic/Lutris for
  # Epic/GOG). Add `pkgs.heroic` here if that becomes wanted; it pulls in
  # UMU itself, no separate configuration needed.
}
