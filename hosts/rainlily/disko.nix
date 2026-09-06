import ../../modules/partitions.nix {
  disk = "/dev/nvme0n1"; # verify with `lsblk` on rainlily
  swapSize = "40G";      # rainlily's RAM + headroom
}
