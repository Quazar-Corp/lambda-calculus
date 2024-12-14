type token = VAR of string | LAMBDA | DOT | LEFT_PARENS | RIGHT_PARENS | EOF
[@@deriving show]

val show_token : token -> string

exception Lexer_error

val tokenize : string -> token list
