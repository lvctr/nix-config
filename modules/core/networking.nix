{ ... }:
{
  networking = {
    networkmanager.enable = true;

    # Default-deny inbound firewall. Open host/service ports explicitly where needed.
    # Keep the default backend so Docker/libvirt can install their own
    # forwarding and NAT rules if you add them later.
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}