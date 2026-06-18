{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  libxkbcommon,
  wayland,
  libei,
  qt6,
}:
stdenv.mkDerivation {
  pname = "hypr-kdeconnect-fix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hypr-kdeconnect-fix";
    rev = "ea55f66c8238235983d60d381bf2abe1fed50043";
    hash = "sha256-OW18+pO92XvlTLrHo+S9/EVUophr5Dl1GdGJcmVAq/o=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libei
    libxkbcommon
    qt6.qtbase
    wayland
  ];
}
