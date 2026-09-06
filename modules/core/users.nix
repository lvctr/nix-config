{ pkgs, username, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
    # Password is set interactively during/after install
    # (`passwd ${username}` or `sudo nixos-install ... `'s prompt),
    # never declared here - same reasoning as the LUKS passphrases.
  };

  security.sudo.wheelNeedsPassword = true;
}