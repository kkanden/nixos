{ inputs, system }:
final: prev: {
  stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
  zen = inputs.zen-browser.packages.${system}.default;
  nix = prev.lixPackageSets.latest.lix;
  vague-gtk = prev.callPackage ./pkgs/vague-gtk.nix { };
  openldap = prev.openldap.overrideAttrs {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  };
}
