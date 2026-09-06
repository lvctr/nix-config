{
  fetchFromGitLab,
  librsvg,
  python3,
  stdenvNoCC,
  xorg,
}:
stdenvNoCC.mkDerivation {
  pname = "xcursor-simp1e-solarized-dark";
  version = "20250223";

  src = fetchFromGitLab {
    owner = "cursors";
    repo = "simp1e";
    rev = "20250223";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  cursorGenerator = fetchFromGitLab {
    owner = "cursors";
    repo = "cursor-generator";
    rev = "master";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    librsvg
    (python3.withPackages (pythonPackages: [ pythonPackages.pillow ]))
    xorg.xcursorgen
  ];

  postPatch = ''
    rm -rf cursor-generator
    cp -R $cursorGenerator cursor-generator
    chmod -R u+w cursor-generator
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
