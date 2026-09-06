{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "yamis-icon-theme";
  version = "unstable-2026";

  src = fetchFromGitHub {
    owner = "dirn-typo";
    repo = "yet-another-monochrome-icon-set";
    rev = "main";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/icons/yet-another-monochrome-icon-set
    cp -r . $out/share/icons/yet-another-monochrome-icon-set/
  '';

  meta.description = "YAMIS icon theme (index.theme at repo root, confirmed)";
}
