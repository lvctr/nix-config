{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "kde-plasma-solarized";
  version = "unstable-2026";

  src = fetchFromGitHub {
    owner = "ret2src";
    repo = "kde-plasma-solarized";
    rev = "main";
    # Placeholder - `nix build` will fail on this and print the correct
    # hash to paste in. Same for every other lib.fakeHash below.
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/color-schemes
    cp *.colors $out/share/color-schemes/
  '';

  meta.description = "Solarized Dark/Light KDE Plasma colour schemes, used here to theme Qt via plasma-integration";
}
