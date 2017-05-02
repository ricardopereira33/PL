%{
#include <stdio.h>
void yyerror (char const *s);
int yylex();
void trim(char*s);
%}
%token NUM ID
%union { char* s; int i; }
%type <s> ID
%type <i> NUM
%type <s> sexp
%type <s> lista
%%
lisp : sexp { printf("%s\n",$1); }

sexp : '(' ID lista ')' 	{ trim($3); asprintf(&$$,"%s(%s)",$2,$3); }
	 | NUM 					{ asprintf(&$$,"%d",$1); }
	 | ID 					{ asprintf(&$$,"%s",$1); }
	;
lista : 				{ asprintf(&$$, " "); }
	  | sexp 			{ asprintf(&$$, "%s", $1); }
	  | sexp lista 		{ asprintf(&$$, "%s, %s",$1, $2); } 
	;
%%
#include "lex.yy.c"

void trim (char* s){
	s[strlen(s)-3] = '\0';
}

void yyerror (char const *s){
	fprintf(stderr, "%d: %s -> %s", yylineno,s,yytext);
}

int main (int agrc, char* argv[]){

	yyparse();

	return 0;

} 