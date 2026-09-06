import ../../modules/partitions.nix {
  disk = "/dev/nvme0n1"; # verify with `lsblk` on waterlily
  swapSize = "16G";      # waterlily's RAM + headroom - it's an older T480s, adjust to its actual RAM
}
