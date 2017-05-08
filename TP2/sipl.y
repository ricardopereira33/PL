%{
#include <stdio.h>
#include <stdio.h>
#include <glib.h>
void yyerror (char const *s);
int yylex();


%}

%union { 
	char* id; 
	int num; 
}

%token NUM ID

%type <s> ID
%type <i> NUM
%%

siplp: ints funcs BEGIN insts END   { }
     ;

ints: Int intIDs ';'               { }
    ;

intIDs: intID                      { }
      | intIDs ',' intID           { }
      ;

intID: ID                         { }
     | ID '=' NUM                 { }
     | ID '[' NUM ']'             { }
     | ID '[' NUM ']' '[' NUM ']' { }
	 ;

funcs: func                         { }
     | funcs func                   { }
     |                              { }
     ;

func: func STRING '{' insts '}'        { }
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

data: ID                           { }
    | ID '[' expr ']'              { }
    | ID '[' expr ']' '[' expr ']' { }
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
      | ID                 	{ }
      | ID '[' expr ']'    	{ }
      | ID '[' expr ']''[' expr ']' { }
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