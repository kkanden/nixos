{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "vague-gtk";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "vague-theme";
    repo = "vague-gtk";
    rev = "bf118ab3e47415e4c558475b241102abd55dad1f";
    hash = "sha256-e76bW8cKjiIwmb6e7/wbXfoB4Fwu8SOs1gLrtzqQRe4=";
  };

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r Vague $out/share/themes/Vague
  '';
}
