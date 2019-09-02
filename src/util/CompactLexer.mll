{
open CompactParser

exception Error of String

}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

let valid = ['0' - '9' 'A' - 'Z' 'a' - 'z' '_' '+'
             ';' ':' '.' '|' '[' ']' '(' ')' '{'
             '}' ',' '=' '>' '-' '&' '<' '@' '"']+

let valid = ['0' - 'z']

rule read =
  parse
  | newline          { new_line lexbuf; read lexbuf }
  | "(*"             { comment 0 lexbuf }
  | white            { WHITESPACE }
  | eof              { EOF }
  (* | valid as phrase  { PHRASE phrase}
  | _                { raise (Error ("Unexpected character")) } *)

and comment depth =
  parse
  | "(*"    { comment (depth+1) lexbuf }
  | "*)"    { if depth = 0 then read lexbuf else comment (depth-1)}
  | newline { new_line lexbuf; comment depth lexbuf }
  | eof     { raise (Error ("Comment unfinished")) }
