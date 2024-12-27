open Frontend.Lexer
open Core

let extension = ".lambda"
let check_extension filename = Filename.check_suffix filename extension

let iter () =
  let rec aux = function
    | Some "q" -> ()
    | Some input ->
        parse input;
        print_endline "Input a lambda or q to quit.";
        aux (In_channel.input_line In_channel.stdin)
    | None -> aux (In_channel.input_line In_channel.stdin)
  in
  print_endline "Input a lambda or q to quit.";
  aux (In_channel.input_line In_channel.stdin)

let main args =
  if Array.length args = 1 then iter ()
  else
    let filename = args.(1) in
    if filename |> check_extension then
      let input = In_channel.read_all filename in
      parse input
    else
      Printf.eprintf
        "Invalid file! Please provide a valid lambda calculus file (.lambda)\n"

let () = Sys.get_argv () |> main
