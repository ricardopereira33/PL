%{
#include <stdio.h>
#include <stdio.h>
#include <glib.h>
void yyerror (char *s);
int yylex();
FILE* resutlado;
GHashTable* variaveis;
%}

%union { 
	char* id; 
	int num; 
}

%token BEGIN END Int F write read exec loop
%token NUM ID STR

%type <id> ID STR
%type <num> NUM
%%

siplp: ints funcs BEGIN insts END   { resutlado = fopen("output.vm","w");
                                      fprintf(resutlado,"%s\n%s\n%s\n",$1,$2,$4);
                                    }
     ;

ints: Int intIDs ';'               { asprintf(&$$,"codigo assembley");}
    ;

intIDs: intID                      { }
      | intIDs ',' intID           { }
      ;

intID: ID                         { }
     | ID '=' NUM                 { }
     | ID '[' NUM ']'             { }
     | ID '[' NUM ']' '[' NUM ']' { }
	 ;

funcs: func                         { $$ = $1; }
     | funcs func                   { }
     |                              { $$ = ""; }
     ;

func: F STRING '{' insts '}'        { }
    ;

insts: inst                         { }
     | insts inst                   { }
	 ;

inst: write '(' factor ')' ';'                                    { }
    | write '(' '"' STR '"' ')'';'                                { }
    | read '(' data ')' ';'                                       { }
    | data '=' expr ';'                                           { }
    | '?''('expr')' '{' insts '}'                                 { }
    | '?''('expr')''{' insts '}''!''?''{' insts '}' /* IF ELSE */ { }
    | loop '('expr')' '{' insts '}' /* WHILE */                   { }
    | exec STR ';'                                                { }
    |                                                             { }
    ;

data: ID                           { }
    | ID '[' expr ']'              { }
    | ID '[' expr ']' '[' expr ']' { }
	;

expr: parcel                 { $$ = $1; }
    | expr '+' parcel        { }
    | expr '-' parcel        { }
    ;

parcel: parcel '*' factor    { }
      | parcel '/' factor    { }
      | parcel '%' factor    { }
      | parcel '>' factor    { }
      | parcel '<' factor    { }
      | parcel '>''=' factor { }
      | parcel '<''=' factor { }
      | parcel '!''=' factor { }
      | parcel '=''=' factor { }
      | parcel '&' factor    { }
      | parcel '|' factor    { }
      | factor               { }
      ;

factor: NUM                         { }
      | ID                 	        { }
      | ID '[' expr ']'    	        { }
      | ID '[' expr ']''[' expr ']' { }
      | '(' expr ')'                { $$ = $2; }
      ;


%%
#include "lex.yy.c"

void yyerror (char const *s){
	fprintf(stderr, "%d: %s -> %s", yylineno,s,yytext);
}

int main (int agrc, char* argv[]){
  variaveis = g_hash_table_new(g_str_hash, g_int_equal);
	
  if(argc == 2)
    yyin = fopen(argv[1],"r");

  yyparse();

	return 0;

} 