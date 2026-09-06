{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "adw-colors";
  version = "unstable-2026";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-colors";
    rev = "main";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/adw-colors
    cp -r themes $out/share/adw-colors/
  '';

  meta.description = "adw-colors theme collection - modules/desktop/theming.nix references themes/adw-solarized/*.css from this";
}
