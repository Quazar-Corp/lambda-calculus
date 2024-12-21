open Frontend.Lexer
open Core

let extension = ".lambda"
let check_extension filename = Filename.check_suffix filename extension

let main args =
  let filename = args.(1) in
  if filename |> check_extension then
    let input = In_channel.read_all filename in
    parse input
  else
    Printf.eprintf
      "Invalid file! Please provide a valid lambda calculus file (.lambda)\n"

let () = Sys.get_argv () |> main
