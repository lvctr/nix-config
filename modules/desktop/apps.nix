{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Web
    librewolf
    firefox
    spotify-launcher
    # vesktop, ungoogled-chromium, spicetify-cli: AUR-only on Arch. Check
    # nixpkgs first (some, like vesktop, are packaged); anything missing
    # needs a pkgs/ derivation the same way as the theming packages.

    # Files
    pcmanfm
    gvfs
    engrampa

    # Other
    fastfetch
    networkmanagerapplet
    openrgb
    i2c-tools
    viewnior
    earlyoom

    # IME - Japanese + English typing only, Bengali is read-only (fonts
    # only, no IME configured for it)
    fcitx5
    fcitx5-configtool
    fcitx5-gtk
    fcitx5-qt
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  services.udev.extraRules = ''
    # openrgb / i2c-dev permissions for RGB control without running as root
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  users.groups.i2c = { };
  boot.kernelModules = [ "i2c-dev" ];
}
