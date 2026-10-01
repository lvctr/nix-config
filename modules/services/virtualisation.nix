{ config, lib, ... }:
let
  cfg = config.local.virtualisationHost;
in
{
  options.local.virtualisationHost.enable = lib.mkEnableOption "virtualisation host networking profile";

  config = lib.mkIf cfg.enable {
    networking = {
      nftables.enable = true;
      firewall.filterForward = true;
    };

    # Container and NATed VM networks need forwarding enabled on the host.
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = lib.mkDefault 1;
      "net.ipv6.conf.all.forwarding" = lib.mkDefault 1;
    };

    virtualisation = {
      docker.daemon.settings = {
        "firewall-backend" = "nftables";
      };

      libvirtd.firewallBackend = "nftables";
    };
  };
}