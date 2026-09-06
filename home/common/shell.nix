{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    initContent = ''
      source ${pkgs.zinit}/share/zinit/zinit.zsh

      # ---- your zinit plugin list goes here, e.g.: ----
      # zinit light zsh-users/zsh-autosuggestions
      # zinit light zsh-users/zsh-syntax-highlighting
    '';
  };
}
