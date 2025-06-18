{
  config,
  lib,
  pkgs,
  ...
}:
let
  fish-pkg = pkgs.stable.fish;
in
{
  imports = map (m: ./modules-hm + "/${m}.nix") [
    "xdg"
    "neovim"
    "hyprland"
    "r"
    "python"
    "alacritty"
    "sioyek"
    "rofi"
    "hyprpanel"
    "kdeconnect"
    "keyd-app"
  ];

  home.username = "oliwia";
  home.homeDirectory = "/home/oliwia";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = builtins.attrValues {
    inherit (pkgs)
      # basic tools
      gcc
      diffutils
      which
      tree
      gnumake
      bat
      fontconfig
      wget
      unzip
      # additional tools
      fzf
      fd
      jq
      gh
      postgresql_17
      ffmpeg
      nix-prefetch-git
      tree-sitter
      pandoc
      texliveFull
      dust
      yarn
      # cosmetic
      cowsay
      lolcat
      fortune
      spotify-player
      # langs
      rustup
      nodejs_24
      jdk
      perl
      powershell
      php
      # lsp
      basedpyright
      bash-language-server
      fish-lsp
      ltex-ls
      lua-language-server
      vscode-langservers-extracted
      marksman
      nixd
      texlab
      yaml-language-server
      taplo
      hyprls
      # formatters
      alejandra
      nixfmt-rfc-style
      stylua
      tex-fmt
      air-formatter
      ;

    inherit (pkgs.rPackages)
      languageserver
      ;

    inherit (pkgs.stable.nodePackages)
      prettier
      ;

    inherit (pkgs.fishPlugins)
      gruvbox
      ;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".Rprofile".source = ./config/.Rprofile;
    "scripts/tmux-sessionizer.sh" = {
      source = ./scripts/tmux-sessionizer.sh;
      executable = true;
    };
    ".latexmkrc".source = ./config/latexmkrc;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
  };

  home.sessionPath = [ "$HOME/scripts" ];

  programs.bash = {
    enable = true;
    # enable fish shell as per https://nixos.wiki/wiki/Fish
    initExtra = ''
      source ${./config/ls_colors}
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${fish-pkg}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    package = fish-pkg;
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAliases = {
      r = "R";
      gs = "git status";
      la = "ls -la";
      nixh = "nvim ~/dotfiles/home.nix";
    };
    shellAbbrs = {
      tree = "tree -C";
    };
    functions = {
      nixos = {
        body =
          # fish
          ''
            trap popd EXIT

            if test (count $argv) -eq 0
              set argv[1] "switch"
            end
              pushd /etc/nixos
              sudo nixos-rebuild --flake . $argv[1]
          '';
      };
    };
    interactiveShellInit =
      # fish
      ''
        set fish_greeting

        bind \t accept-autosuggestion
        bind \cn complete-and-search

        bind \cf 'tmux-sessionizer.sh'

        source ${./config/fish/vague.fish}
        fortune | cowsay
      '';
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./config/tmux/tmux.conf;
    plugins = builtins.attrValues {
      inherit (pkgs.tmuxPlugins)
        yank
        resurrect
        continuum
        ;
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
    settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (
        builtins.readFile ./config/oh-my-posh/omp-vague.json # path relative to home.nix

      )
    );
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "oliwia";
    userEmail = "24637207+kkanden@users.noreply.github.com";
    aliases = {
      lg = "log --oneline --graph --all --decorate --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(yellow)%h%Creset - %C(blue)%an <%ae>%Creset - %C(green)%ad%Creset -%C(red)%d%Creset %s'";
      lgu = "log --oneline --graph origin..HEAD";
    };
    extraConfig = {
      init.defaultbranch = "main";
      core = {
        editor = "nvim";
        autocrlf = false;
      };
      status = {
        branch = true;
        short = true;
        showStash = true;
      };
      diff = {
        context = 3;
        renames = "copies";
        interHunkContext = 10;
      };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      pull = {
        rebase = true;
        default = "current";
      };
      rebase = {
        autoStash = true;
      };
      url = {
        "https://github.com/" = {
          insteadOf = "gh:";
        };
      };
      colors = {
        diff = {
          meta = "black bold";
          frag = "magenta";
          context = "white";
          whitespace = "yellow reverse";
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };

  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (builtins.readFile ./config/fastfetch/config.jsonc)
    );
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
