{ config, lib, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    # nixos-hardware's lenovo-thinkpad-t480s module is imported at the
    # flake.nix level.
  ];

  networking.hostName = "waterlily";
  time.timeZone = "REPLACE-ME";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11";

  # ---- GPU: 8th-gen Kaby Lake R, UHD 620 ----
  # Deliberately NOT importing vpl-gpu-rt or setting ANV_DEBUG here - those
  # target the newer Xe Vulkan-video pipeline and do nothing on this much
  # older iGPU generation. intel-media-driver still applies broadly.
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  services.power-profiles-daemon.enable = true;
  powerManagement.enable = true;
}
