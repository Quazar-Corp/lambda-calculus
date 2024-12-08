open Sedlexing.Utf8

type alphabet =
  | VAR of string
  | LAMBDA
  | DOT
  | LEFT_PARENS
  | RIGHT_PARENS
  | EOF
[@@deriving show]

exception Lexer_error

let whitespace = [%sedlex.regexp? Plus (' ' | '\t' | '\n')]
let variable = [%sedlex.regexp? 'a' .. 'z' | 'A' .. 'Z']

let rec tokenizer buf =
  match%sedlex buf with
  | whitespace -> tokenizer buf
  | variable -> VAR (lexeme buf)
  | "λ" -> LAMBDA
  | "." -> DOT
  | "(" -> LEFT_PARENS
  | ")" -> RIGHT_PARENS
  | eof -> EOF
  | _ -> raise @@ Lexer_error

let buf_from_string string =
  let index = ref 0 in
  let len = String.length string in
  from_gen (fun () ->
      match !index < len with
      | true ->
          let char = String.get string !index in
          incr index;
          Some char
      | false -> None)

let next input =
  let buf = input |> buf_from_string in
  buf |> tokenizer
