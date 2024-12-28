# Lambda Calculus in OCaml

The idea of this project is to study concepts of language engineering such as lexical analysis, syntax analysis and semantic analysis. The language was supposed to be the classic untyped lambda calculus.

## Dependencies
- Sedlex
- Menhir
- ppx_deriving
- Nix (You can try to build without it)

### Start nix shell
```
nix develop
```
You might need to enable `flake` and `nix-command`.

## How to run
### With source file
```bash
dune exec interpreter <filename>.lambda
```
### Interactive
```
dune exec interpreter
```


## References
Paper reference: [A Tutorial Introduction to the Lambda Calculus](https://personal.utdallas.edu/~gupta/courses/apl/lambda.pdf)
