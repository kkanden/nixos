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

    mkHardened =
      x:
      {
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = "read-only";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      }
      // x;
  };

in
self
