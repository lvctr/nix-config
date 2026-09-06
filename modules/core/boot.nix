{ ... }:
{
  # Limine generics only. Per-host LUKS/TPM2 wiring comes from the host's
  # modules/storage/partitions.nix import, not here.
  boot.loader.limine.enable = true;
  boot.loader.limine.maxGenerations = 10;
  boot.loader.timeout = 5;

  # zswap: compressed write-back cache in front of the real swap partition
  # each host imports from modules/storage/partitions.nix. Works alongside
  # hibernation, unlike zram.
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
  ];
}