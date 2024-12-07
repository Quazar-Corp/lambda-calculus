open Formal.Description

let () = print_endline "Hello, Lambda Calculus"
let identity = Function ("x", Name "x") |> to_string

let identity_applied =
  Application (Function ("x", Name "x"), Name "y") |> to_string

let () = Printf.printf "Identity function: %s\n" identity
let () = Printf.printf "Identity applied to y: %s\n" identity_applied
