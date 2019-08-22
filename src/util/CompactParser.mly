%token <string> PHRASE
%token WHITESPACE
%token EOF

%start <String> program

%%

program :
| items = list(item); EOF {String.concat items}

item :
| WHITESPACE {" "}
| item = PHRASE {item}
