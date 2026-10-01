# System-hardening measures live here as they get added over time -
# fscrypt today, room for AppArmor, hardened_malloc, sysctl tightening,
# etc. later without renaming anything again.
{ pkgs, ... }:
{
  # ---- fscrypt: per-user home-directory encryption on top of LUKS ----
  environment.systemPackages = [ pkgs.fscrypt-experimental ];

  # Registers pam_fscrypt.so in the login/passwd PAM stacks, so a user's
  # /home directory unlocks on login and locks on logout using their
  # ordinary login password as the protector.
  security.pam.enableFscrypt = true;

  # ---- One-time manual setup, per host, after first boot ----
  # ext4 needs the `encrypt` feature flag at mkfs time for this to work at
  # all - modules/storage/partitions.nix sets `extraArgs = [ "-O" "encrypt" ];` on
  # the root filesystem for exactly this reason. If that flag is missing,
  # `fscrypt encrypt` will fail outright.
  #
  #   sudo fscrypt setup                                  # once per filesystem
  #   sudo fscrypt encrypt /home/<username> --source=pam_passphrase
  #
  # The second command ties that specific user's home directory to their
  # login password. Run it once, as root, after the user account exists
  # and the user has logged in at least once (so PAM has a password to
  # bind the protector to).

  boot.kernel.sysctl = {
    # Enable kernel-level SYN flood mitigation.
    "net.ipv4.tcp_syncookies" = 1;

    # ICMP redirects are not useful on normal end-user hosts.
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Do not advertise this host as a better path for third-party traffic.
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
  };
}