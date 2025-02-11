{
  description = "Lambda Calculus Flake";

  inputs = {
    nixpkgs.url = "github:anmonteiro/nix-overlays";
    nix-filter.url = "github:numtide/nix-filter";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-filter, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = (nixpkgs.makePkgs {
        inherit system;
      }).extend (self: super: {
        ocamlPackages = super.ocaml-ng.ocamlPackages_5_2;
      }); in
      let lambda-calculus = pkgs.callPackage ./nix {
        inherit nix-filter;
        doCheck = true;
      }; in
      rec {
        packages = { inherit lambda-calculus; };
        devShell = import ./nix/shell.nix { inherit pkgs lambda-calculus; };
      });
}
