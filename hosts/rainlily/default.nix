{ config, disk, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (import ./disk.nix)
    (import ../../modules/partitions.nix {
      disk = disk.device;
      swapSize = "40G";
    })
  ];

  networking.hostName = "rainlily";

  nixpkgs.config.allowUnfree = true;

  # CPU
  hardware.cpu.amd.updateMicrocode = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.kernelModules = [ "zenpower" ];

  # GPU
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [ vulkan-radeon ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };

  # SSD
  services.fstrim.enable = true;

  # Kernel Params
  boot.kernelParams = [
    "amd_pstate=active"
    "nvidia-drm.modeset=1"
  ];
}
