{ pkgs, ... }:
{
  # ---- GTK ----
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "yet-another-monochrome-icon-set";
      package = pkgs.yamis-icon-theme;
    };

    cursorTheme = {
      name = "Simp1e-Solarized-Dark";
      package = pkgs.xcursor-simp1e-solarized-dark;
      size = 24;
    };

    font = {
      name = "Source Han Code JP";
      size = 12;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;

    gtk3.extraCss = ''
      @import url("${pkgs.adw-colors}/share/adw-colors/themes/adw-solarized/gtk3-dark.css");
    '';

    gtk4.extraCss = ''
      @import url("${pkgs.adw-colors}/share/adw-colors/themes/adw-solarized/gtk4-dark.css");
    '';
  };

  home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

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
