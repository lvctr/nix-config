# System-hardening measures live here as they get added over time -
# fscrypt today, room for AppArmor, hardened_malloc, sysctl tightening,
# etc. later without renaming anything again.
{ pkgs, ... }:
{
  # ---- fscrypt: per-user home-directory encryption on top of LUKS ----
  environment.systemPackages = [ pkgs.fscrypt ];

  # Registers pam_fscrypt.so in the login/passwd PAM stacks, so a user's
  # /home directory unlocks on login and locks on logout using their
  # ordinary login password as the protector.
  security.pam.enableFscrypt = true;

  # ---- One-time manual setup, per host, after first boot ----
  # ext4 needs the `encrypt` feature flag at mkfs time for this to work at
  # all - modules/partitions.nix sets `extraArgs = [ "-O" "encrypt" ];` on
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

  # ---- future additions go here: AppArmor, hardened_malloc, sysctl, etc. ----
}
