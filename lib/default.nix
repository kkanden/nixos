{
  lib,
  configPath,
  scriptsPath,
  ...
}:
let
  self = {
    mkConfigPath =
      path:
      assert lib.assertMsg (builtins.isString path)
        "Path to config must be a string: ${builtins.toString path}";
      configPath + "/${path}";

    readConfig = path: builtins.readFile (self.mkConfigPath path);

    mkScript =
      path:
      assert lib.assertMsg (builtins.isString path)
        "Path to config must be a string: ${builtins.toString path}";
      scriptsPath + "/${path}";
  };
in
self
