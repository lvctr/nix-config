{
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  lib,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "tlpui";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d4nj1";
    repo = "TLPUI";
    rev = "tlpui-${version}";
    hash = "sha256-PD00Siyj0UHuReIe8l/WuQhNRmVGysmOLqLon9DAMwM=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    pygobject3
    pyyaml
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  postInstall = ''
    install -Dm644 tlpui.desktop $out/share/applications/tlpui.desktop
    install -Dm644 tlpui/icons/OnBAT.svg $out/share/icons/hicolor/scalable/apps/tlpui.svg
  '';

  meta = {
    description = "GTK user interface for TLP";
    homepage = "https://github.com/d4nj1/TLPUI";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tlpui";
  };
}