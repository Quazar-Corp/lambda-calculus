%{
%}

%token <string> VAR
%token <int> INT
%token <bool> BOOL
%token LAMBDA
%token DOT
%token LEFT_PARENS 
%token RIGHT_PARENS
%token PLUS MINUS DIVIDE MULT

%token EOF

%start <unit> program 

%%

program : expr_lst = expression_list; EOF { Printf.printf "%s" expr_lst }

name : var  = VAR { var }
     | int_ = INT { int_ |> string_of_int }
     | bool_ = BOOL { bool_ |> string_of_bool }

arithmetic_operator : MULT { * }  
                    | DIVIDE { / } 
                    | PLUS { + }
                    | MINUS { - }

arithmetic : n = name { n }
           | n = name; op = arithmetic_operator; ar = arithmetic { (op (int_of_string n) (int_of_string ar)) |> string_of_int } 

func : LAMBDA; n = name; DOT; expr = arithmetic { "lambda " ^ n ^ " -> " ^ expr }

application : LEFT_PARENS; f = func; RIGHT_PARENS; expr = expression { "(" ^ f ^ ")" ^ expr }

expression : 
  | n = name { n } 
  | f = func { f }
  | a = application { a } 

expression_list : expr = expression { Printf.sprintf "Output: %s\n" expr }
                | expr = expression; expr_lst = expression_list { Printf.sprintf "Output: %s\n%s" expr expr_lst  }

