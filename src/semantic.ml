exception Type_error

type expression =
  | Variable of string
  | Abstraction of string * expression
  | Application of expression * expression
[@@deriving show, eq]

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

let rec beta_reduce (variable : string) (value : expression) = function
  | Variable var when var = variable -> value
  | Variable _ as var -> var
  | Abstraction (param, _) as abs when param = variable -> abs
  | Abstraction (param, body) ->
      Abstraction (param, beta_reduce variable value body)
  | Application (function_, argument) ->
      Application
        ( beta_reduce variable value function_,
          beta_reduce variable value argument )

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
      | Abstraction (param, body) ->
          let reduced_body = beta_reduce param argument body in
          let new_env = (param, reduced_body) :: env in
          eval new_env reduced_body
      | _ -> failwith "Application of non-function")

let print_lambda lambda result =
  let showable_lambda = lambda |> lambda_to_string in
  let showable_result = result |> lambda_to_string in
  Printf.printf "Full lambda : %s\nResult: %s\n" showable_lambda showable_result
