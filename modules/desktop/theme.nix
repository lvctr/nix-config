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

  # Per-user GTK and Qt/KDE theme files are written declaratively by
  # home/common/theme.nix.
}
