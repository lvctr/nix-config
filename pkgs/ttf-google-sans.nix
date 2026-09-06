{ stdenvNoCC, fetchurl }:
let
  rev = "43590e625ab1b07f6a5809287ce16f7e61d9e165";
in
stdenvNoCC.mkDerivation {
  pname = "ttf-google-sans";
  version = "unstable-2026-09-06";

  src = fetchurl {
    url = "https://flutter.googlesource.com/gallery-assets/+archive/${rev}/lib/fonts.tar.gz";
    hash = "sha256-7uttbYqcMHcZ92kBHhOKZ1wDmaByZT7Ngfv0eTpBC84=";
  };

  sourceRoot = ".";
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    install -Dm644 GoogleSans*.ttf -t $out/share/fonts/truetype/google-sans

    runHook postInstall
  '';

  meta.description = "Google's signature family of fonts";
}
