{ pkgs, doCheck ? true, nix-filter }:

let inherit (pkgs) lib stdenv ocamlPackages; in

with ocamlPackages; buildDunePackage rec {
  pname = "lambda-calculus";
  version = "0.0.0-dev";

  src = with nix-filter.lib;
    filter {
      root = ./..;
      include = [
        "dune-project"
      ];
      exclude = [];
    };

  propagatedBuildInputs = [ core menhir menhirLib sedlex ppx_deriving ]
    # checkInputs are here because when cross compiling dune needs test dependencies
    # but they are not available for the build phase. The issue can be seen by adding strictDeps = true;.
    ++ checkInputs;

  checkInputs = [ alcotest ];
}
