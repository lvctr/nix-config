{ pkgs, ... }:
{
  # NOTE: nixpkgs font package names shift more than most (splits,
  # renames, the whole nerd-fonts restructuring). Verify every name below
  # with `nix search nixpkgs <name>` against your actual nixpkgs revision
  # before first build - several are my best-current-guess, not verified
  # against nixpkgs directly in this session.
  fonts.packages = with pkgs; [
    # Latin
    noto-fonts
    ttf-google-sans

    # Monospace
    (pkgs.nerd-fonts.fira-code or pkgs.nerdfonts) # adjust to current nerd-fonts packaging in your nixpkgs revision
    otf-source-han-code-jp

    # Japanese
    source-han-sans
    source-han-serif
    noto-fonts-cjk-sans
    ipaexfont
    ttf-jigmo
    # sazanami / vlgothic / monapo: check current nixpkgs names, these move around
    vlgothic-fonts

    # Bengali (reading only, no IME configured for it)
    freebanglafont

    # Emoji - only this one, no others
    twemoji-color-font
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Source Han Code JP" ];
      emoji = [ "Twemoji" ];
    };
  };

  # UI font at a literal 12px (not 12pt) for GTK and Qt - see
  # modules/desktop/theme.nix for where this is actually applied
  # (gtk.css font-size rule + kdeglobals pixel-size font field).
}
