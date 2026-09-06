{ pkgs, ... }:
{
  # NOTE: with the KDE Frameworks 6 transition, these three package paths
  # have moved around in nixpkgs more than once (plasma5Packages ->
  # libsForQt5 -> kdePackages depending on revision). Run
  # `nix search nixpkgs plasma-integration` /  `... breeze` / `... kde-cli-tools`
  # against your actual nixpkgs revision and fix these three lines before
  # building - do not trust the paths below as-is.
  environment.systemPackages = with pkgs; [
    adw-gtk3
    yamis-icon-theme
    xcursor-simp1e-solarized-dark
    adw-colors

    # Qt theming route: kdeglobals colour scheme + plasma-integration
    # platform theme, NOT qt6ct/kvantum - see kde-plasma-solarized.nix
    kde-plasma-solarized
    kdePackages.plasma-integration
    kdePackages.breeze
    kdePackages.kde-cli-tools
  ];

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "kde";
    XCURSOR_THEME = "Simp1e-Solarized-Dark";
    XCURSOR_SIZE = "24";
  };

  # ---- GTK ----
  # Plain settings.ini, deliberately NOT dconf/gsettings-desktop-schemas -
  # those are still GNOME-project packages and were ruled out on that
  # basis. Home Manager should write these two files per-user (see
  # home/common/ once written) with:
  #
  #   [Settings]
  #   gtk-theme-name=adw-gtk3-dark
  #   gtk-icon-theme-name=yet-another-monochrome-icon-set
  #   gtk-cursor-theme-name=Simp1e-Solarized-Dark
  #   gtk-application-prefer-dark-theme=1
  #
  # into ~/.config/gtk-3.0/settings.ini and ~/.config/gtk-4.0/settings.ini.
  #
  # The Solarized *colour* override (adw-colors' adw-solarized theme) is a
  # separate gtk.css file that @imports the adw-colors CSS and adds the
  # literal 12px font-size rule on top - also a Home Manager
  # xdg.configFile entry, not something set here at the system level.

  # ---- Qt colour scheme ----
  # One-time, after first boot (not declarative - plasma-apply-colorscheme
  # needs to run against the real session):
  #   mkdir -p ~/.local/share/color-schemes
  #   cp ${pkgs.kde-plasma-solarized}/share/color-schemes/BreezeSolarizedDark.colors \
  #     ~/.local/share/color-schemes/
  #   plasma-apply-colorscheme BreezeSolarizedDark
  #
  # Qt font at literal 12px goes in ~/.config/kdeglobals under [General],
  # using the pixel-size field of Qt's font string format, e.g.:
  #   kwriteconfig6 --file kdeglobals --group General \
  #     --key font "Source Han Code JP,-1,12,5,50,0,0,0,0,0"
}
