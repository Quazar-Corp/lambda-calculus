exception Type_error

type expression =
  | Variable of string
  | Abstraction of string * expression
  | Application of expression * expression

type env = (string * expression) list

let rec lambda_to_string = function
  | Variable var -> var
  | Abstraction (param, body) ->
      Printf.sprintf "λ%s -> %s" param (lambda_to_string body)
  | Application (func, Variable argument) ->
      Printf.sprintf "(%s)%s" (func |> lambda_to_string) argument
  | Application (func, argument) ->
      Printf.sprintf "(%s)(%s)" (lambda_to_string func)
        (lambda_to_string argument)

let rec eval (env : env) = function
  | Variable var as variable -> (
      try List.assoc var env
      with _ ->
        let new_env = (var, variable) :: env in
        List.assoc var new_env)
  | Abstraction (_, _) as function_ -> function_
  | Application (function_, argument) -> (
      let function_ = eval env function_ in
      let argument = eval env argument in
      match function_ with
      | Abstraction (function_, body) ->
          let new_env = (function_, argument) :: env in
          eval new_env body
      | _ -> failwith "Application of non-function")

let print_lambda lambda result =
  let showable_lambda = lambda |> lambda_to_string in
  let showable_result = result |> lambda_to_string in
  Printf.printf "Full lambda : %s\nResult: %s\n" showable_lambda showable_result
