{ pkgs, ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = [ pkgs.pavoldcontrol ];
  # NOTE: pavoldcontrol was an AUR package on Arch (GTK3 mixer, since
  # mainline pavucontrol moved to GTK4 in 6.0). Check whether it exists in
  # nixpkgs under this name before building - if not, package it under
  # pkgs/ the same way as the other custom derivations, or check whether
  # nixpkgs' own `pavucontrol` is still pinned pre-6.0 (in which case you
  # don't need a replacement at all).
}
