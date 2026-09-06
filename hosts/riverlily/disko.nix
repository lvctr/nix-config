import ../../modules/partitions.nix {
  disk = "/dev/nvme0n1"; # verify with `lsblk` on riverlily
  swapSize = "32G";      # riverlily's RAM + headroom
}
