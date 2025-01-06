exception Type_error

type expression =
  | Variable of string
  | Abstraction of string * expression
  | Application of expression * expression
[@@deriving show, eq]

type context = (string * expression) list

val expression_to_string : expression -> string 

val eval : context -> expression -> expression

val print_expression: expression -> expression -> unit
