# PLACEHOLDER - this file is meant to be regenerated on the real machine
# during install and dropped in here, replacing this file entirely:
#
#   sudo nixos-generate-config --no-filesystems --root /mnt
#   cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/<this-host>/hardware-configuration.nix
#
# --no-filesystems is important: disko.nix already declares the
# filesystems for this host, and you don't want nixos-generate-config's
# guesses fighting with disko's explicit declarations.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
