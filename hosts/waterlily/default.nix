{ config, disk, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ./disk.nix)
    (import ../../modules/partitions.nix {
      disk = disk.device;
      swapSize = "16G";
    })
  ];

  networking.hostName = "waterlily";

  # CPU
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  services.throttled.enable = lib.mkDefault true;

  # GPU
  boot.initrd.kernelModules = [ "i915" ];
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  # SSD
  services.fstrim.enable = lib.mkDefault true;

  # Input
  hardware.trackpoint.enable = lib.mkDefault true;
  hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;

  # Biometrics
  services.fprintd.enable = true;

  # Power
  services.tlp.enable = true;
  environment.systemPackages = with pkgs; [ tlpui ];
}
