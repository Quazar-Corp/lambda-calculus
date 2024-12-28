%{
open Semantic
%}

%token <string> VAR
%token LAMBDA
%token DOT
%token LEFT_PARENS 
%token RIGHT_PARENS

%token EOF

%start <unit> program 

%%

program : expr_lst = expression_list; EOF 
  { expr_lst 
    |> List.iter (fun expr -> 
        print_lambda expr (expr |> eval [])) }

variable : var  = VAR { Variable var }

abstraction : 
  LAMBDA; v = variable; DOT; expr = expression 
    { match v with 
      | Variable var -> Abstraction (var, expr)
      | _ -> raise Type_error }

application : 
  lexpr = expression; rexpr = expression { Application (lexpr, rexpr) } 

expression : 
  | v   = variable    { v } 
  | abs = abstraction { abs }
  | LEFT_PARENS expr = expression RIGHT_PARENS { expr }
  | a   = application { a } 

expression_list : 
  | expr = expression { [ expr ] }
  | expr = expression; expr_lst = expression_list { expr :: expr_lst }

