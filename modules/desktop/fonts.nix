{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # Latin
    noto-fonts
    ttf-google-sans

    # Monospace
    (pkgs.nerd-fonts.fira-code or pkgs.nerdfonts) # adjust to current nerd-fonts packaging in your nixpkgs revision
    source-han-code-jp

    # Japanese
    source-han-sans
    source-han-serif
    noto-fonts-cjk-sans
    ipaexfont
    jigmo

    # Bengali (reading only, no IME configured for it)
    lohit-fonts.bengali

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