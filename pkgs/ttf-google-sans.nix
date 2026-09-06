{ stdenvNoCC, fetchFromGitHub }:
# You confirmed this exists at https://aur.archlinux.org/packages/ttf-google-sans
# Open that PKGBUILD and mirror its source= array here - swap owner/repo/rev
# for whatever it actually points at, then fix the installPhase glob to
# match the real font file names.
stdenvNoCC.mkDerivation {
  pname = "ttf-google-sans";
  version = "unstable-2026";

  src = fetchFromGitHub {
    owner = "REPLACE-ME";
    repo = "REPLACE-ME";
    rev = "REPLACE-ME";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/google-sans
    find . -iname '*.ttf' -o -iname '*.otf' | xargs -I{} cp {} $out/share/fonts/truetype/google-sans/
  '';

  meta.description = "Google Sans (via AUR ttf-google-sans source)";
}
