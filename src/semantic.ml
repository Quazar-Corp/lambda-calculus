exception Type_error

type expression =
  | Name of string
  | Abstraction of string * expression
  | Application of expression * expression
[@@deriving show]

let rec lambda_to_string = function
  | Name var -> var
  | Abstraction (param, body) ->
      Printf.sprintf "λ%s -> %s" param (lambda_to_string body)
  | Application (func, Name argument) ->
      Printf.sprintf "(%s)%s" (func |> lambda_to_string) argument
  | Application (func, argument) ->
      Printf.sprintf "(%s)(%s)" (lambda_to_string func)
        (lambda_to_string argument)

let rec substitute expr variable replacement =
  match expr with
  | Name var -> if var = variable then replacement else expr
  | Abstraction (param, body) ->
      if param = variable then expr
      else Abstraction (param, substitute body variable replacement)
  | Application (func, argument) ->
      Application
        ( substitute func variable replacement,
          substitute argument variable replacement )

let rec beta_reduce (expr : expression) =
  match expr with
  | Name _ as var -> var
  | Abstraction (_, _) as func -> func
  | Application (Abstraction (param, body), rexpr) ->
      let reduced_body = substitute body param rexpr in
      beta_reduce reduced_body
  | Application (lexpr, rexpr) -> (
      let reduced_left = beta_reduce lexpr in
      match reduced_left with
      | Abstraction (param, body) ->
          let applied = substitute body param rexpr in
          beta_reduce applied
      | _ -> Application (reduced_left, beta_reduce rexpr))

let print_lambda lambda result =
  let showable_lambda = lambda |> lambda_to_string in
  let showable_result = result |> lambda_to_string in
  Printf.printf "Full lambda : %s\nResult: %s\n" showable_lambda showable_result
