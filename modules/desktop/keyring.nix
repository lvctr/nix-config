{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [ seahorse gnupg pinentry-qt ];

  security.pam.services.login.enableGnomeKeyring = true;

  # ~/.gnupg/gpg-agent.conf (Home Manager territory, not here):
  #   enable-ssh-support
  #   pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
  #
  # Then, per user, enable and start the sockets:
  #   systemctl --user enable --now gpg-agent.socket gpg-agent-ssh.socket
  #
  # And in ~/.bash_profile or equivalent, before Hyprland starts:
  #   export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  #
  # Hyprland config needs, so the keyring's D-Bus activation actually
  # reaches apps started inside the session:
  #   exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE
}
