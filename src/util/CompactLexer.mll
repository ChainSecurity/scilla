{
open CompactParser

exception Error of String

}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

rule read =
  parse
  | newline          { new_line lexbuf; read lexbuf }
  | "(*"             { comment 0 lexbuf }
  | white            { WHITESPACE }
  | _ as phrase      { PHRASE phrase}
  | eof              { EOF }

and comment depth =
  parse
  | "(*"    { comment (depth+1) lexbuf }
  | "*)"    { if depth = 0 then read lexbuf else comment (depth-1)}
  | newline { new_line lexbuf; comment depth lexbuf }
  | eof     { raise (Error ("Comment unfinished")) }
