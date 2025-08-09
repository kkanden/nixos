{ lib', ... }:
{
  xdg.configFile."sioyek/keys_user.config".source = lib'.mkConfig "sioyek/keys.config";
  xdg.configFile."sioyek/prefs_user.config".source = lib'.mkConfig "sioyek/prefs.config";
}
