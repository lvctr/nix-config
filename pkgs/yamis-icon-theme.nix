{ fetchgit, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "yamis-icon-theme";
  version = "1.5.5";

  src = fetchgit {
    url = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set.git";
    rev = "ec97c1a2034634d464bcba4001bc9f77390f1256";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/yet-another-monochrome-icon-set
    cp -r . $out/share/icons/yet-another-monochrome-icon-set/

    runHook postInstall
  '';

  meta.description = "Yet Another Monochrome Icon Set for KDE Plasma";
}
