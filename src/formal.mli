module Description : sig
  type expression =
    | Name of string
    | Function of string * expression
    | Application of expression * expression

  val to_string : expression -> string
end
