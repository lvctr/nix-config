{ ... }:
{
  # Limine generics only. Per-host LUKS/TPM2 crypttab wiring lives in
  # hosts/<name>/luks.nix, not here.
  boot.loader.limine.enable = true;
  boot.loader.limine.maxGenerations = 10;
  boot.loader.timeout = 5;

  # zswap: compressed write-back cache in front of the real swap partition
  # each host's disko.nix declares. Works alongside hibernation, unlike zram.
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
  ];
}
