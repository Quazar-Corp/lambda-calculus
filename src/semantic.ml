exception Type_error

type expression =
  | Name of string
  | Function of string * expression
  | Application of expression * expression

let rec lambda_to_string = function
  | Name var -> var
  | Function (param, body) ->
      Printf.sprintf "λ%s -> %s" param (lambda_to_string body)
  | Application (func, argument) ->
      Printf.sprintf "(%s)(%s)" (lambda_to_string func)
        (lambda_to_string argument)

let rec substitute expr variable replacement =
  match expr with
  | Name variable' -> if variable = variable' then replacement else expr
  | Function (var, expr') ->
      if var = variable then expr
      else
        let expr' = substitute expr' variable replacement in
        Function (var, expr')
  | Application (func, argument) ->
      let func' = substitute func variable replacement in
      let argument' = substitute argument variable replacement in
      Application (func', argument')

let rec beta_reduce (expr : expression) =
  match expr with
  | Name _ as var -> var
  | Function (_, _) as func -> func
  | Application (func, argument) -> (
      let reduced_left = beta_reduce func in
      match reduced_left with
      | Function (param, body) ->
          let applied = substitute body param argument in
          beta_reduce applied
      | _ -> Application (reduced_left, beta_reduce argument))

let print_lambda lambda result =
  let showable_lambda = lambda |> lambda_to_string in
  let showable_result = result |> lambda_to_string in
  Printf.printf "Full lambda : %s\nResult: %s\n" showable_lambda showable_result
