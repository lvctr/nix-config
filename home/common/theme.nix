{ pkgs, ... }:
{
  # ---- GTK ----
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

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import url("${pkgs.adw-colors}/share/adw-colors/themes/adw-solarized/gtk3-dark.css");
    * { font-family: "Source Han Code JP"; font-size: 12px; }
  '';
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import url("${pkgs.adw-colors}/share/adw-colors/themes/adw-solarized/gtk4-dark.css");
    * { font-family: "Source Han Code JP"; font-size: 12px; }
  '';

  # ---- Qt / KDE ----
  xdg.dataFile."color-schemes/BreezeSolarizedDark.colors".source =
    "${pkgs.kde-plasma-solarized}/share/color-schemes/BreezeSolarizedDark.colors";

  xdg.configFile."kdeglobals".text = ''
    [General]
    ColorScheme=BreezeSolarizedDark
    font=Source Han Code JP,-1,12,5,50,0,0,0,0,0

    [Icons]
    Theme=yet-another-monochrome-icon-set
  '';
}
