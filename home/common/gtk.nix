{ pkgs, ... }:
{
  # Plain settings.ini - deliberately not gsettings/dconf (see
  # modules/desktop/theming.nix for why).
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=adw-gtk3-dark
    gtk-icon-theme-name=yet-another-monochrome-icon-set
    gtk-cursor-theme-name=Simp1e-Solarized-Dark
    gtk-application-prefer-dark-theme=1
  '';
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=adw-gtk3-dark
    gtk-icon-theme-name=yet-another-monochrome-icon-set
    gtk-cursor-theme-name=Simp1e-Solarized-Dark
    gtk-application-prefer-dark-theme=1
  '';

  # Layers the adw-colors Solarized palette on top of adw-gtk3's shape via
  # @import, rather than symlinking adw-colors' file directly - this way
  # the literal 12px font-size rule can sit in the same file without
  # touching (or being overwritten by) adw-colors itself on update.
  #
  # NOTE: verify the exact filenames inside adw-colors' adw-solarized
  # theme folder (gtk3-dark.css / gtk4-dark.css were the pattern shown in
  # their docs for other themes) before relying on this path.
  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import url("${pkgs.adw-colors}/share/adw-colors/themes/adw-solarized/gtk3-dark.css");
    * { font-family: "Source Han Code JP"; font-size: 12px; }
  '';
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import url("${pkgs.adw-colors}/share/adw-colors/themes/adw-solarized/gtk4-dark.css");
    * { font-family: "Source Han Code JP"; font-size: 12px; }
  '';
}
