{
  fetchFromGitLab,
  librsvg,
  python3,
  stdenvNoCC,
  xcursorgen,
}:
stdenvNoCC.mkDerivation {
  pname = "xcursor-simp1e-solarized-dark";
  version = "20250223";

  src = fetchFromGitLab {
    owner = "cursors";
    repo = "simp1e";
    rev = "20250223";
    hash = "sha256-clBfwor+3GKHl+Vt98diHDlkCnC/UQfIkObsUkUO7eg=";
  };

  cursorGenerator = fetchFromGitLab {
    owner = "cursors";
    repo = "cursor-generator";
    rev = "dd4a730c4a45c73c580220658bd1f21f141f8a55";
    hash = "sha256-6qF0IWwsNYrMPLG48UH8zX7YETQh+XIqYyUkcOh8PNg=";
  };

  nativeBuildInputs = [
    librsvg
    (python3.withPackages (pythonPackages: [ pythonPackages.pillow ]))
    xcursorgen
  ];

  postPatch = ''
    patchShebangs build.sh

    rm -rf cursor-generator
    cp -R $cursorGenerator cursor-generator
    chmod -R u+w cursor-generator
    patchShebangs cursor-generator
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/share/icons
    cp -a built_themes/Simp1e-Solarized-Dark $out/share/icons/

    runHook postInstall
  '';

  meta.description = "An aesthetic cursor theme, Solarized Dark variant";
}
