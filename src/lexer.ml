open Parser
open Sedlexing.Utf8

exception Lexer_error
exception Parser_error

let () =
  Printexc.register_printer @@ function
  | Lexer_error -> Some "lexer: symbol error"
  | Parser_error -> Some "parser: syntax error"
  | _ -> None

let whitespace = [%sedlex.regexp? Plus (' ' | '\t' | '\n')]
let number = [%sedlex.regexp? Plus '0' .. '9']
let boolean = [%sedlex.regexp? "true" | "false"]
let alphabet = [%sedlex.regexp? 'a' .. 'z' | 'A' .. 'Z']
let variable = [%sedlex.regexp? alphabet | Star alphabet]
let lambda = [%sedlex.regexp? "λ" | "0x03BB" | "0xCE 0xBB" | "\\"]

let rec tokenizer buf =
  match%sedlex buf with
  | whitespace -> tokenizer buf
  | number ->
      let literal = lexeme buf in
      let num = int_of_string literal in
      INT num
  | boolean ->
      let literal = lexeme buf in
      let boolean = bool_of_string literal in
      BOOL boolean
  | lambda -> LAMBDA
  | '.' -> DOT
  | '(' -> LEFT_PARENS
  | ')' -> RIGHT_PARENS
  | variable -> VAR (lexeme buf)
  | eof -> EOF
  | _ -> raise @@ Lexer_error

(* Sedlex docs: https://ocaml-community.github.io/sedlex/sedlex/Sedlexing/index.html#val-lexing_positions
   Sedlexing.lexing_positions lexbuf returns the start and end positions, 
   in code points, 
   of the current token, using a record of type Lexing.position. 
   This is intended for consumption by parsers like those generated by Menhir.
 * *)
let next_token lexbuf =
  let token = tokenizer lexbuf in
  let start, end_ = Sedlexing.lexing_positions lexbuf in
  (token, start, end_)

open Parser.MenhirInterpreter

(* Docs Reference: https://ocaml.org/manual/5.2/api/compilerlibref/CamlinternalMenhirLib.IncrementalEngine.INCREMENTAL_ENGINE.html*)
let rec loop lexbuf state =
  match state with
  | InputNeeded _env ->
      let token, start, end_ = next_token lexbuf in
      let state = offer state (token, start, end_) in
      loop lexbuf state
  | Shifting _ | AboutToReduce _ ->
      let state = resume state in
      loop lexbuf state
  | HandlingError _env ->
      let start = Sedlexing.lexing_position_start lexbuf in
      Printf.printf "Error at: %d-%d\n" start.Lexing.pos_lnum
        start.Lexing.pos_cnum;
      raise Parser_error
  | Accepted matched -> matched
  | Rejected -> failwith "Rejected"

(*
let tokenize input =
  let rec loop buf lexemes =
    let token = tokenizer buf in
    match token with
    | EOF -> lexemes |> List.rev
    | _ as t -> loop buf (t :: lexemes)
  in
  loop (input |> buf_from_string) []
*)

let parse input =
  let lexbuf = Sedlexing.Latin1.from_string input in
  let start = Sedlexing.lexing_position_start lexbuf in
  loop lexbuf @@ Parser.Incremental.program start
