{ pkgs, ... }:
{
  # Registers zsh in /etc/shells so `users.users.<name>.shell = pkgs.zsh`
  # (in users.nix) is valid, and so the account's default shell is actually
  # zsh from first boot - no manual chsh needed.
  programs.zsh.enable = true;

  # The actual .zshrc content (zinit bootstrap, plugin list, prompt) is a
  # per-user dotfile concern, not a system one - see home/common/shell.nix.
}
