open Formal.Description

let () = print_endline "Hello, Lambda Calculus"
let identity = Function ("x", Name "x") |> to_string

let identity_applied =
  Application (Function ("x", Name "x"), Name "y") |> to_string

let () = Printf.printf "Identity function: %s\n" identity
let () = Printf.printf "Identity applied to y: %s\n" identity_applied

let () =
  Printf.printf "Tokenized Identity:\n";
  "λx.x" |> Lexer.tokenize
  |> List.iter (fun l -> Printf.printf "LEXEME: %s\n" (Lexer.show_token l))

let () =
  Printf.printf "Tokenized Identity Applied:\n";
  "(λx.x)y" |> Lexer.tokenize
  |> List.iter (fun l -> Printf.printf "LEXEME: %s\n" (Lexer.show_token l))
