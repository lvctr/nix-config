{ pkgs, config, ... }:
let
  zinit = pkgs.fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = "zinit";
    rev = "main"; # pin to a tag/commit for reproducibility once you've picked one
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
{
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Fetched declaratively via Nix (see the `zinit` let-binding above)
      # rather than zinit's usual self-installing `git clone` on first run -
      # keeps the whole shell setup reproducible instead of depending on a
      # runtime download the first time you open a terminal.
      source ${zinit}/zinit.zsh

      # ---- your zinit plugin list goes here, e.g.: ----
      # zinit light zsh-users/zsh-autosuggestions
      # zinit light zsh-users/zsh-syntax-highlighting
    '';
  };
}
