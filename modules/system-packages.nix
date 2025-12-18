{
  inputs,
  pkgs,
  lib,
  config,
  repoPathStr,
  ...
}:
let
  tmux-plugins = with pkgs.tmuxPlugins; [
    yank
  ];
  cfg = config.oliwia.packages;
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.oliwia.packages = {
    core.enable = mkEnableOption "core packages" // {
      default = true;
    };
    extra = {
      enable = mkEnableOption "extra packages";
      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };
    };
  };
  config = lib.mkMerge [
    (lib.mkIf cfg.core.enable {
      environment.systemPackages =
        (with pkgs.stable; [
          # basic tools
          bat
          dust
          fd
          ffmpeg
          file
          fontconfig
          fzf
          gcc
          gh
          git
          gnumake
          jq
          killall
          man-pages # linux dev man pages
          neovim
          postgresql_17
          ripgrep
          tmux
          tree
          unrar
          unzip
          vim
          wget
          zip

          # cosmetic
          cowsay
          fortune
          lolcat
          oh-my-posh

          # desktop
        ])
        ++ (with pkgs; [
          #basic tool
          fastfetch
          btop-rocm

          # langs
          jdk
          nodejs_24
          perl
          php
          (python313.withPackages (
            p: with p; [
              black
              isort
            ]
          ))
          R
          rustup
          typst

          # lsp
          ty
          basedpyright
          bash-language-server
          ccls
          fish-lsp
          hyprls
          lua-language-server
          marksman
          nil
          nixd
          taplo
          texlab
          tinymist
          vscode-langservers-extracted
          yaml-language-server

          # formatters
          air-formatter
          alejandra
          clang-tools
          nixfmt-rfc-style
          shfmt
          stylua
          tex-fmt
          typstyle
          stable.nodePackages.prettier
        ])
        ++ tmux-plugins;

      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          dbus # libdbus-1.so.3
          fontconfig # libfontconfig.so.1
          freetype # libfreetype.so.6
          glib # libglib-2.0.so.0
          libGL # libGL.so.1
          libxkbcommon # libxkbcommon.so.0
          wayland
          xorg.libX11 # libX11.so.6
        ];
      };
      programs.nh = {
        enable = true;
        flake = repoPathStr;
      };

      programs.nix-index.enable = true;
      programs.command-not-found.enable = false;

      oliwia.scripts.scripts = {
        tmux-sessionizer = {
          dependencies = with pkgs.stable; [
            tmux
            coreutils
            fd
            fzf
            gnused
            procps
          ];
        };
        nix-search-tv = {
          name = "ns";
          dependencies = with pkgs; [
            stable.fzf
            nix-search-tv
          ];
        };
      };

      environment.sessionVariables = {
        TMUX_PLUGINS_CMD = lib.pipe tmux-plugins [
          (builtins.map (x: "tmux run-shell ${x.rtp}"))
          (builtins.concatStringsSep "\n")
        ];
      };
    })
    (lib.mkIf cfg.extra.enable {
      environment.systemPackages =
        cfg.extra.extraPackages
        ++ (with pkgs.stable; [
          # basic tools
          android-tools
          yarn
          yt-dlp

          # desktop
          (scrcpy.overrideAttrs (prev: {
            postInstall = prev.postInstall + ''
              wrapProgram $out/bin/scrcpy --set SDL_VIDEODRIVER x11
            '';
          }))
          cliphist
          groff # plain text to typeset
          inotify-tools
          libnotify
          libqalculate
          libreoffice-fresh
          mpv
          texliveFull
          nautilus
          pinta
          translate-shell
          tesseract
          vlc
          wl-clipboard
          wtype
          xdg-utils
          xdotool
        ])
        ++ (with pkgs; [
          # cosmetic
          cava

          # desktop
          alacritty
          discord
          firefox
          gimp3-with-plugins
          hyprpanel
          papirus-icon-theme
          (rofi.override { plugins = with pkgs; [ rofi-calc ]; })
          rofi-power-menu
          sioyek
          spotify
          spotify-player
          uxplay # apple airdrop server
          r2modman
          (qimgv.override {
            libsForQt5 = pkgs.kdePackages; # use qt6 instead of qt5
          })
          kdePackages.kimageformats # adds many image formats support to qt6 apps
          prismlauncher
          protonvpn-gui

          # hardware tools
          easyeffects
          hardinfo2
          imagemagick
          libratbag
          lm_sensors
          pavucontrol
          piper
          playerctl
          pulseaudio
          qpwgraph
          gparted

          #other
          rustlings
        ])
        ++ [
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

      programs.thunderbird.enable = true;
      programs.kdeconnect.enable = true;
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
        enableVirtualCamera = true;
      };

      # my scripts with their dependencies
      oliwia.scripts = {
        scripts = {
          focus-or-launch = {
            enable = config.oliwia.hyprland.enable;
            dependencies = with pkgs; [
              hyprland
              stable.jq
            ];
          };
          killactive-steamsafe = {
            enable = config.oliwia.hyprland.enable;
            dependencies = with pkgs; [
              hyprland
              stable.xdotool
            ];
          };
          rofi-open-filetype = {
            dependencies = with pkgs; [
              rofi
              stable.coreutils
              stable.fd
              stable.findutils
              stable.xdg-utils
            ];
          };
          rofi-tr = {
            dependencies = with pkgs; [
              rofi
              stable.translate-shell
              stable.wl-clipboard
              stable.libnotify
              stable.mpv
            ];
          };
          rofi-clipboard = {
            dependencies = with pkgs; [
              rofi
              cliphist
              hyprland
              wl-clipboard
            ];
          };
          screenshot = {
            dependencies = with pkgs; [
              grim
              hyprpicker
              procps
              slurp
              wl-clipboard
            ];
          };
          pinta-clipboard = {
            dependencies = with pkgs.stable; [
              coreutils
              libnotify
              wl-clipboard
              pinta
            ];
          };
          image-to-text = {
            dependencies = with pkgs.stable; [
              libnotify
              wl-clipboard
              tesseract
            ];
          };
        };
      };
    })
  ];
}
