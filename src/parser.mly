%{
%}

%token <string> VAR (* x *)
%token <int> INT (* 1 *)
%token LAMBDA (* \ *)
%token DOT (* . *)
%token LEFT_PARENS (* ( *)
%token RIGHT_PARENS (* ) *)

%token EOF

%start <unit> program 

%%

program : expr = expression; EOF { Printf.printf "Output: %s\n" expr }

name : var  = VAR { var }
     | int_ = INT { int_ |> string_of_int }

func : LAMBDA; n = name; DOT; expr = expression { "lambda " ^ n ^ " -> " ^ expr }

application : LEFT_PARENS; f = func; RIGHT_PARENS; expr = expression { "( " ^ f ^ " )" ^ expr }

expression : 
  | n = name { n } 
  | f = func { f }
  | a = application { a } 
