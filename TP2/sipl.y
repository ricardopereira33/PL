%{
#include <stdio.h>
#include <stdio.h>
#include <glib.h>
void yyerror (char const *s);
int yylex();


%}

%union { 
	char* s; 
	int i; 
}

%token NUM ID

%type <s> ID
%type <i> NUM
%type <s> sexp
%type <s> lista
%%

siplp: ints funcs BEGIN insts END   { }
     ;

ints: Int intvars ';'               { }
    ;

intvars: intvar                     { }
       | intvars ',' intvar         { }
       ;

intvar: VAR                         { }
      | VAR '=' NUM                 { }
      | VAR '[' NUM ']'             { }
      | VAR '[' NUM ']' '[' NUM ']' { }
	  ;

funcs: func                         { }
     | funcs func                   { }
     |                              { }
     ;

func: f STRING '{' insts '}'        { }
   ;

insts: inst                         { }
     | insts inst                   { }
	 ;

inst: write '(' factor ')' ';'         { }
    | write '(' '"' STRING '"' ')'';'  { }
    | read '(' data ')' ';'           { }
    | data '=' expr ';'             { }
    | '?''('expr')' '{' insts '}'   { }
    | '?''('expr')''{' insts '}''!?''{' insts '}' /* IF ELSE */{ }
    | 'inLoop''('expr')' '{' insts '}' /* WHILE */ { }
    | call STRING ';'              { }
    |                              { }
    ;

data: VAR                           { }
    | VAR '[' expr ']'              { }
    | VAR '[' expr ']' '[' expr ']' { }
	;

expr: parcel                 { }
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

factor: NUM                 { }
      | VAR                 { }
      | VAR '[' expr ']'    { }
      | VAR '[' expr ']''[' expr ']' { }
      | '(' expr ')'        { }
      ;


%%
#include "lex.yy.c"

void yyerror (char const *s){
	fprintf(stderr, "%d: %s -> %s", yylineno,s,yytext);
}

int main (int agrc, char* argv[]){

	yyparse();

	return 0;

} 