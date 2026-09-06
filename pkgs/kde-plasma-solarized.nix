{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "kde-plasma-solarized";
  version = "unstable-2023-01-26";

  src = fetchFromGitHub {
    owner = "ret2src";
    repo = "kde-plasma-solarized";
    rev = "4ef14b64a4603ae6c42ecb1ce02aaa330b335cb1";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/color-schemes
    cp BreezeSolarizedDark.colors $out/share/color-schemes/

    runHook postInstall
  '';

  meta.description = "Solarized Dark color scheme for KDE Plasma";
}
