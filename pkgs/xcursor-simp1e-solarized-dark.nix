{ fetchFromGitLab, stdenvNoCC }:
# The upstream xcursor-simp1e AUR PKGBUILD splits many variants out of one
# gitlab.com/cursors/simp1e source tree. Point this at the exact variant
# you want and adjust the installPhase to match the built cursor theme's
# actual directory name once you've inspected a fetched checkout - AUR's
# PKGBUILD is the authoritative reference for the build steps.
stdenvNoCC.mkDerivation {
  pname = "xcursor-simp1e-solarized-dark";
  version = "unstable-2026";

  src = fetchFromGitLab {
    owner = "cursors";
    repo = "simp1e";
    rev = "main";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  # PLACEHOLDER: the real AUR PKGBUILD builds this from source (it's not a
  # pure copy job like the icon theme/color scheme). Check
  # https://aur.archlinux.org/packages/xcursor-simp1e-solarized-dark for the
  # exact build() steps before relying on this derivation.
  installPhase = ''
    mkdir -p $out/share/icons/Simp1e-Solarized-Dark
    echo "TODO: fill in real build steps from the AUR PKGBUILD" > $out/share/icons/Simp1e-Solarized-Dark/README
  '';

  meta.description = "Simp1e cursor theme, Solarized Dark variant";
}
