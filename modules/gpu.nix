{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.oliwia.gpu;
in
{
  options.oliwia.gpu = {
    amd.enable = lib.mkEnableOption "AMD GPU";
    amd.overdrive = lib.mkEnableOption "AMD GPU overclocking";
    nvidia.enable = lib.mkEnableOption "NVIDIA GPU";
  };
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.amd.enable && cfg.nvidia.enable);
          message = "Don't enable both AMD and NVIDIA GPU drivers.";
        }
      ];
    }

    (lib.mkIf cfg.amd.enable (
      lib.mkMerge [
        {
          environment.systemPackages = with pkgs; [
            mesa
            mesa-demos
            vulkan-tools
          ];
          # enable OpenGL
          hardware.graphics = {
            enable = true;
            enable32Bit = true;
          };
          hardware.amdgpu.initrd.enable = false;
          hardware.amdgpu.opencl.enable = true;
          services.xserver.videoDrivers = [ "amdgpu" ];
          nixpkgs.config.rocmSupport = true;
        }
        (lib.mkIf cfg.amd.overdrive {
          hardware.amdgpu.overdrive.enable = true;
        })
      ]
    ))

    (lib.mkIf cfg.nvidia.enable {
      # enable OpenGL
      hardware.graphics = {
        enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        open = true;
        nvidiaSettings = true;
        modesetting.enable = true;

        powerManagement = {
          enable = false;
          finegrained = false;
        };
      };

      nixpkgs.config.cudaSupport = true;

      boot =
        let
          mkNvidia =
            let
              at = lib.attrsets;
              concat = lib.flip lib.pipe [
                (lib.concatStringsSep " ")
                lib.trim
              ];
            in
            lib.flip lib.pipe [
              (at.mapAttrs (_: concat))
              (at.filterAttrs (_: v: v != ""))
              (at.mapAttrsToList (n: v: "options ${n} ${v}"))
              lib.concatLines
            ];
        in
        {
          blacklistedKernelModules = [ "nouveau" ];

          extraModprobeConfig = mkNvidia {
            nvidia = [
              "NVreg_UsePageAttributeTable=1"
              "NVreg_PreserveVideoMemoryAllocations=1"
            ];
            nvidia_drm = [
              "NVreg_EnableGpuFirmware=1"
            ];
          };
        };

      environment.sessionVariables = {
        # Required to run the correct GBM backend for nvidia GPUs on wayland
        GBM_BACKEND = "nvidia-drm";
        # Apparently, without this nouveau may attempt to be used instead
        # (despite it being blacklisted)
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # Hardware cursors are currently broken on nvidia
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
        __GL_THREADED_OPTIMIZATION = "1";
        __GL_SHADER_CACHE = "1";
      };

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
      };
    })
  ];
}
