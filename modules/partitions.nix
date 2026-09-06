# Partition table AND its LUKS/TPM2 unlock policy, deliberately kept
# together: "cryptroot"/"cryptswap" below have to exactly match the
# `content.name` fields disko uses for those same partitions, and keeping
# that agreement across two separate files was a real, easy-to-miss
# coupling with no error until boot if it ever drifted. One file now, one
# place to change either side.
#
# `disk` and `swapSize` are the only two things that actually vary by
# machine. Hosts import this module from their default.nix files.
{ disk, swapSize }:
{
  disko.devices = {
    disk.main = {
      device = disk;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = swapSize;
            content = {
              type = "luks";
              name = "cryptswap";
              settings.allowDiscards = true;
              content = { type = "swap"; };
            };
          };
          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings.allowDiscards = true;
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-O" "encrypt" ]; # required for fscrypt on /home
              };
            };
          };
        };
      };
    };
  };

  # TPM2 auto-unlock, no PCR binding, on both devices declared above.
  # "cryptroot"/"cryptswap" here are the same two names used in the
  # `content.name` fields - that agreement is the whole reason this lives
  # in the same file now.
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."cryptroot".crypttabExtraOpts = [ "tpm2-device=auto" ];
  boot.initrd.luks.devices."cryptswap".crypttabExtraOpts = [ "tpm2-device=auto" ];
  boot.resumeDevice = "/dev/mapper/cryptswap";

  # ---- One-time manual step, after this file has actually run on the ----
  # ---- real machine (partitions must exist first):                    ----
  #   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= /dev/disk/by-partlabel/root
  #   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= /dev/disk/by-partlabel/swap
}
