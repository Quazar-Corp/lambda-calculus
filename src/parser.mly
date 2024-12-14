%{
%}

%token <string> VAR (* x *)
%token LAMBDA (* \ *)
%token DOT (* . *)
%token LEFT_PARENS (* ( *)
%token RIGHT_PARENS (* ) *)

%token EOF

%start <unit> program 

%%

program : expr = expression; EOF { Printf.printf "Full expression: %s\n" expr }

name : var = VAR { var }

func : LAMBDA; n = name; DOT; expr = expression { "λ" ^ n ^ "." ^ expr }

application : LEFT_PARENS; f = func; RIGHT_PARENS; expr = expression { "(" ^ f ^ ")" ^ expr }

expression : 
  | n = name { n } 
  | f = func { f }
  | a = application { a } 
