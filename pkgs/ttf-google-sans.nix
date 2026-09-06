{ stdenvNoCC, fetchgit }:
let
  rev = "43590e625ab1b07f6a5809287ce16f7e61d9e165";
in
stdenvNoCC.mkDerivation {
  pname = "ttf-google-sans";
  version = "unstable-2026-09-06";

  src = fetchgit {
    url = "https://flutter.googlesource.com/gallery-assets";
    inherit rev;
    hash = "sha256-/l1dYwkLlYIDnRrVZYXHeo1aFTMj4DQMV2Jkj7EgxXc=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    install -Dm644 lib/fonts/GoogleSans*.ttf -t $out/share/fonts/truetype/google-sans

    runHook postInstall
  '';

  meta.description = "Google's signature family of fonts";
}
