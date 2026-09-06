{ config, lib, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    # nixos-hardware's lenovo-thinkpad-x1-12th-gen module is imported at
    # the flake.nix level, not here - it's already self-contained and
    # pulls in its own CPU/SSD generics internally.
  ];

  networking.hostName = "riverlily";
  time.timeZone = "REPLACE-ME";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11";

  # ---- GPU: Intel Core Ultra 155U (Meteor Lake / Xe-LPG) ----
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
    libvpl
  ];

  environment.sessionVariables = {
    ANV_DEBUG = "video-decode,video-encode";
  };

  # ---- Laptop-specific ----
  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
}
