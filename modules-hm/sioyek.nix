{ lib', pkgs, ... }:
{
  programs.sioyek = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "sioyek-wrapped";
      paths = [ pkgs.sioyek ];
      buildInputs = [ pkgs.makeBinaryWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sioyek \
          --set QT_QPA_PLATFORM xcb
      '';
    };
  };
  xdg.configFile."sioyek/keys_user.config".source = lib'.mkConfig "sioyek/keys.config";
  xdg.configFile."sioyek/prefs_user.config".source = lib'.mkConfig "sioyek/prefs.config";
}
