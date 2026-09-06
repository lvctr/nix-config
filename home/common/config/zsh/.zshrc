# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zmodload zsh/complist
zstyle ':completion:*' menu select

autoload -Uz select-word-style
select-word-style bash

# Keybinds
bindkey	"^[[1;5D"	backward-word			    # Alt  + Left
bindkey	"^[[1;5C"	forward-word		      # Alt  + Right
bindkey	"^[[1;3D"	backward-word         # Ctrl + Left
bindkey	"^[[1;3C"	forward-word          # Ctrl + Right
bindkey	"^H"      backward-kill-word    # Alt  + Backspace
bindkey '^W'      backward-delete-word  # Ctrl + Backspace

bindkey -M menuselect '^[[Z' reverse-menu-complete
