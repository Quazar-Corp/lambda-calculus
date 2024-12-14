open Parser
open Sedlexing.Utf8

type token = VAR of string | LAMBDA | DOT | LEFT_PARENS | RIGHT_PARENS | EOF
[@@deriving show]

exception Lexer_error

let whitespace = [%sedlex.regexp? Plus (' ' | '\t' | '\n')]
let variable = [%sedlex.regexp? 'a' .. 'z' | 'A' .. 'Z']
let lambda = [%sedlex.regexp? "λ" | "0x03BB" | "0xCE 0xBB" | "\\"]

let rec tokenizer buf =
  match%sedlex buf with
  | whitespace -> tokenizer buf
  | lambda -> LAMBDA
  | '.' -> DOT
  | '(' -> LEFT_PARENS
  | ')' -> RIGHT_PARENS
  | variable -> VAR (lexeme buf)
  | eof -> EOF
  | _ -> raise @@ Lexer_error

let buf_from_string = Sedlexing.Latin1.from_string

let tokenize input =
  let rec loop buf lexemes =
    let token = tokenizer buf in
    match token with
    | EOF -> lexemes |> List.rev
    | _ as t -> loop buf (t :: lexemes)
  in
  loop (input |> buf_from_string) []
