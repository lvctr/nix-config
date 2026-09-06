{ lib, pkgs, ... }:
{
  home.sessionPath = [
    "$HOME/.scripts"
  ];

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      lightline-vim
      vim-gitgutter
      vim-polyglot
      vim-colors-solarized
    ];
    extraConfig = builtins.readFile ./config/vim/.vimrc;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    setOptions = [ "NO_BEEP" ];

    oh-my-zsh = {
      enable = true;
      custom = "${pkgs.zsh-powerlevel10k}/share/zsh/themes";
      plugins = [
        "sudo"
        "git"
        "colored-man-pages"
      ];
      theme = "powerlevel10k/powerlevel10k";
    };

    autosuggestion = {
      enable = true;
      highlight = "fg=60";
    };

    syntaxHighlighting.enable = true;

    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" "^[OA" "$terminfo[kcuu1]" ];
      searchDownKey = [ "^[[B" "^[OB" "$terminfo[kcud1]" ];
    };

    shellAliases = {
      ":q" = "exit";
      ":q!" = "exit";
      startw = "start-hyprland";
    };

    sessionVariables = {
      SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 (builtins.readFile ./config/zsh/.zshrc))
      (lib.mkOrder 950 ''
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '')
    ];
  };

  home.file = {
    ".p10k.zsh".source = ./config/zsh/.p10k.zsh;
  };

  xdg.configFile."kitty" = {
    source = ./config/kitty;
    recursive = true;
  };
}