%{
open Semantic
%}

%token <string> VAR
%token NEWLINE LAMBDA
%token DOT
%token LEFT_PARENS 
%token RIGHT_PARENS

%token EOF

%start <unit> program 

%%

program : expr_lst = expression_list; EOF 
  { expr_lst 
    |> List.iter (fun expr -> 
        print_lambda expr (beta_reduce expr)) }

name : var  = VAR { Name var }

func : 
  LAMBDA; n = name; DOT; expr = expression 
    { match n with 
      | Name name -> Function (name, expr)
      | _ -> raise Type_error }

application : 
  LEFT_PARENS; expr1 = expression; RIGHT_PARENS; LEFT_PARENS; expr2 = expression; RIGHT_PARENS 
    { Application (expr1, expr2) }
  | LEFT_PARENS; expr1 = expression; RIGHT_PARENS; expr2 = expression { Application (expr1, expr2) }

expression : 
  | n = name { n } 
  | f = func { f }
  | a = application { a } 

expression_list : 
  | expr = expression { [ expr ] }
  | expr = expression; expr_lst = expression_list { expr :: expr_lst }

