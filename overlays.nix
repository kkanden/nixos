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
  wayle = prev.wayle.overrideAttrs {
    patches = [
      (prev.fetchpatch {
        url = "https://github.com/kkanden/wayle/commit/f1284f31df7e8a1f0ca789df47ab80371e0f553a.patch";
        hash = "sha256-ftm1jXPD88HCfvUzdJHXzgfjgtadkYUjLFKomaiR0iM=";
      })
    ];
  };
}
