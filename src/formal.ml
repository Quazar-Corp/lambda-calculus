module Description = struct
  type expression =
    | Name of string
    | Function of string * expression
    | Application of expression * expression

  let rec to_string = function
    | Name id -> id
    | Function (id, body) -> "λ" ^ id ^ "." ^ (body |> to_string)
    | Application (func, argument) ->
        "(" ^ (func |> to_string) ^ ")" ^ (argument |> to_string)
end
