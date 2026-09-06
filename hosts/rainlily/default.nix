{ config, lib, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "rainlily";
  time.timeZone = "REPLACE-ME"; # e.g. "Asia/Tokyo"
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11"; # set to whatever release you actually install with, then never change it

  # ---- CPU: 7950X3D ----
  hardware.cpu.amd.updateMicrocode = true;

  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.kernelModules = [ "zenpower" ];

  # ---- GPUs: AMD iGPU (video engine use) + NVIDIA 4080 (sole display GPU) ----
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ vulkan-radeon ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true; # Ada Lovelace - open kernel module is supported/recommended
    modesetting.enable = true;
  };
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # ---- Misc ----
  services.fstrim.enable = true;
}
