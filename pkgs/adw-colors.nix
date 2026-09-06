{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "adw-colors";
  version = "unstable-2026-03-06";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-colors";
    rev = "389dff2e6ae48438693473c97f0aac6a2fc019cf";
    hash = "sha256-WCG662t3EWk6FFJxm4rmz7h/d10il4YUvLKeTBK+Tvs=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/adw-colors
    mkdir -p $out/share/adw-colors/themes
    cp -r themes/adw-solarized $out/share/adw-colors/themes/

    runHook postInstall
  '';

  meta.description = "Solarized theme from adw-colors";
}
