{ pkgs, lambda-calculus }:

with pkgs; with ocamlPackages; mkShell {
  inputsFrom = [ lambda-calculus ];
  packages = [
    # Make developer life easier
    # formatters
    nixfmt
    ocamlformat

    # OCaml developer tooling
    ocaml
    dune_3
    ocaml-lsp
  ];
}
