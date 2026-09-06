{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation {
  pname = "ttf-google-sans";
  version = "1-4";

  src = fetchurl {
    url = "https://flutter.googlesource.com/gallery-assets/+archive/refs/heads/master/lib/fonts.tar.gz";
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
