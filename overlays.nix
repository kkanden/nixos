{ inputs, system }:
final: prev: {
  stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
  zen = inputs.zen-browser.packages.${system}.default;
  neovim-unwrapped = inputs.neovim.packages.${system}.default;
  hyprlandPlugins = prev.hyprlandPlugins // {
    csgo-vulkan-fix = prev.hyprlandPlugins.csgo-vulkan-fix.overrideAttrs {
      version = "0.54.0";
      src =
        let
          gh-src = prev.fetchFromGitHub {
            owner = "hyprwm";
            repo = "hyprland-plugins";
            rev = "b85a56b9531013c79f2f3846fd6ee2ff014b8960";
            hash = "sha256-xwNa+1D8WPsDnJtUofDrtyDCZKZotbUymzV/R5s+M0I=";
          };
        in
        "${gh-src}/csgo-vulkan-fix";
    };
  };
}
