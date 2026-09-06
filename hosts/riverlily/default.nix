{ config, disk, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ./disk.nix)
    (import ../../modules/partitions.nix {
      disk = disk.device;
      swapSize = "36G";
    })
  ];

  networking.hostName = "riverlily";

  # CPU
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # GPU
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelParams = [
    "i915.enable_guc=3"
    "i915.force_probe=7d55"
  ];
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
    libvpl
  ];
  environment.sessionVariables = {
    ANV_DEBUG = "video-decode,video-encode";
  };

  # SSD
  services.fstrim.enable = lib.mkDefault true;

  # Input
  hardware.trackpoint.enable = lib.mkDefault true;
  hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;
  hardware.trackpoint.device = "TPPS/2 Synaptics TrackPoint";

  # Biometrics
  services.fprintd.enable = true;

  # Power
  services.tlp.enable = true;
  environment.systemPackages = with pkgs; [ tlpui ];
}
