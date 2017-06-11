%{
#include <stdio.h>
#include <stdio.h>
#include <glib.h>
void yyerror (char *s);
int yylex();
void addVar(char* var);
int getVar(char* var);
void addArray(char* var, int l, int c);
int getArray(char* var);
int getColuns(char* var);

int labelInfo;

/*estrutura de dados para guardar informacao do apontador do inicio do array, como o tamanho das linhas e colunas*/
typedef struct Array{
    int point;
    int l;
    int c;
}Array;

/*estrutura para poder armazenar o output para o caso de o valor de ID ser um array, e ser necessario efectuar um push antecipadamente*/
typedef struct VarInfo{
    char* push;
    char* store; 
}VarInfo;
    
%}
  
%union { 
    char* id; 
    int num;
    VarInfo varinfo;
}

%token START END Int F iWrite iRead exe iLoop
%token NUM ID STR

%type <id> ID STR intIDs intID ints funcs func insts inst portion elem expr
%type <num> NUM
%type <varinfo> var 
%%

iPL: ints funcs START insts END   { printf("%sjump inic\n%sstart\ninic: %sstop\n",$1,$2,$4); } /*esqueleto do codigo assembley*/
   ;

ints: Int intIDs ';'               { $$ = $2; }
    ;

intIDs: intID                      { $$ = $1; }
      | intIDs ',' intID           { asprintf(&$$, "%s%s",$1,$3); }
      ;

intID: ID                         { asprintf(&$$, "\tpushi 0\n"); 
                                    addVar($1); }                           /*empilha o valor 0 a stack*/
     | ID '=' NUM                 { asprintf(&$$, "\tpushi %d\n", $3); 
                                    addVar($1); }                           /*empilha o valor NUM a stack*/
     | ID '[' NUM ']'             { asprintf(&$$, "\tpushn %d\n", $3); 
                                    addArray($1, $3, 0); }                  /*empilha NUM vezes o valor 0 a stack*/
     | ID '[' NUM ']' '[' NUM ']' { asprintf(&$$, "\tpushn %d\n", $3 * $6); 
                                    addArray($1, $3, $6); }                 /*empilha NUM*NUM vezes o valor 0 a stack*/
	 ;

funcs: func                         { $$ = $1; }
     | funcs func                   { asprintf(&$$,"%s%s",$1,$2); }
     |                              { $$ = ""; }
     ;

func: F STR '{' insts '}'           { asprintf(&$$, "%s: nop\n%s\treturn\n",$2,$4); }
    ;

insts: inst                         { $$ = $1; }
     | insts inst                   { asprintf(&$$, "%s%s", $1, $2); }
	   ;

inst: iWrite '(' elem ')' ';'                                      { asprintf(&$$, "%s\twritei\n", $3); }                                                                                                                  /*retira um inteiro da pilha e imprime*/
    | iWrite '(' '"' STR '"' ')'';'                                { asprintf(&$$, "\tpushs \"%s\"\n\twrites\n", $4); }                                                                                                    /*retira um endereço de uma string da pilha e impirme*/
    | iRead '(' var ')' ';'                                        { asprintf(&$$, "%s\tread\n\tatoi\n%s",$3.push,$3.store); }                                                                                             /*efectua um push, e por fim um store do que foi lido*/
    | var '=' expr ';'                                             { asprintf(&$$, "%s%s%s", $1.push, $3, $1.store); }                                                                                                     /*passar o valor para a variavel VAR*/
    | '?''('expr')' '{' insts '}'                   /*IF*/         { asprintf(&$$, "%s\tjz LABEL%d\n%sLABEL%d: ", $3, labelInfo, $6, labelInfo); labelInfo++; }                                                            /*IF*/
    | '?''('expr')''{' insts '}''!''?''{' insts '}' /*IF ELSE */   { asprintf(&$$, "%s\tjz LABEL%d\n%s\tjump LABEL%d\nLABEL%d: %sLABEL%d: ", $3, labelInfo, $6, labelInfo+1, labelInfo, $11, labelInfo+1); labelInfo+=2; } /*IF ELSE*/
    | iLoop '('expr')' '{' insts '}'                /*WHILE */     { asprintf(&$$, "LABEL%d: %s\n\tjz LABEL%d\n%s\tjump LABEL%d\nLABEL%d: ", labelInfo, $3, labelInfo+1, $6, labelInfo , labelInfo+1); labelInfo+=2; }     /*WHILE*/
    | exe STR ';'                                                  { asprintf(&$$, "\tpusha %s\n\tcall\n\tnop\n", $2); }                                                                                                   /*chamada de uma funcao*/
    |                                                              { $$ = ""; }
    ;

var: ID                           { asprintf(&$$.push, "");
                                    asprintf(&$$.store, "\tstoreg %d\n",getVar($1)); }
   | ID '[' expr ']'              { asprintf(&$$.push, "\tpushgp\n\tpushi %d\n\tpadd\n%s", getArray($1),$3);
                                    asprintf(&$$.store, "\tstoren\n"); }
   | ID '[' expr ']' '[' expr ']' { asprintf(&$$.push, "\tpushgp\n\tpushi %d\n\tpadd\n%s\tpushi %d\n\tmul\n%s\tadd\n", getArray($1), $3, getColuns($1),$6);
                                    asprintf(&$$.store, "\tstoren\n"); }

expr: portion                 { $$ = $1; }
    | expr '+' portion        { asprintf(&$$, "%s%s\tadd\n", $1, $3); }
    | expr '-' portion        { asprintf(&$$, "%s%s\tsub\n", $1, $3); }
    ;

portion: portion '*' elem    { asprintf(&$$, "%s%s\tmul\n", $1, $3); }                     /*Mutiplicacao*/
       | portion '/' elem    { asprintf(&$$, "%s%s\tdiv\n", $1, $3); }                     /*Divisao*/
       | portion '%' elem    { asprintf(&$$, "%s%s\tmod\n", $1, $3); }                     /*Resto*/
       | portion '>' elem    { asprintf(&$$, "%s%s\tsup\n", $1, $3); }                     /*Maior*/
       | portion '<' elem    { asprintf(&$$, "%s%s\tinf\n", $1, $3); }                     /*Menor*/
       | portion '>''>' elem { asprintf(&$$, "%s%s\tsupeq\n", $1, $4); }                   /*Maior ou igual*/
       | portion '<''<' elem { asprintf(&$$, "%s%s\tinfeq\n", $1, $4); }                   /*Menor ou igual*/
       | portion '!''=' elem { asprintf(&$$, "%s%s\tequal\npushi 1\ninf\n", $1, $4); }     /*diferente*/
       | portion '=''=' elem { asprintf(&$$, "%s%s\tequal\n", $1, $4); }                   /*igual*/
       | portion '&' elem    { asprintf(&$$, "%s%s\tadd\n\tpushi 2\n\tequal\n", $1, $3); } /*conjuncao*/
       | portion '|' elem    { asprintf(&$$, "%s%s\tadd\n\tpushi 0\n\tsup\n", $1, $3); }   /*disjuncao*/
       | elem                { $$ = $1; }
       ;

elem: NUM                         { asprintf(&$$, "\tpushi %d\n", $1); }
    | ID                 	      { asprintf(&$$, "\tpushg %d\n", getVar($1)); }
    | ID '[' expr ']'    	      { asprintf(&$$, "\tpushgp\n\tpushi %d\n\tpadd\n%s\tloadn\n",getArray($1), $3); }
    | ID '[' expr ']''[' expr ']' { asprintf(&$$, "\tpushgp\n\tpushi %d\n\tpadd\n%s\tpushi %d\n\tmul\n%s\tadd\n\tloadn\n",getArray($1), $3, getColuns($1), $6); }
    | '(' expr ')'                { $$ = $2; }                                                                                                                      /*para agrupar de forma mais correta as expressoes*/
    ;

%%
#include "lex.yy.c"

GHashTable* vars;
GHashTable* arrays;
int globalPointer;

/*apresenta os error de sintaxe, e declaracao de variaveis*/
void yyerror (char *s){
    fprintf(stderr, "%d: %s\n", yylineno,s);
}

int main (int agrc, char* argv[]){
    vars = g_hash_table_new(g_str_hash, g_int_equal);
    arrays = g_hash_table_new(g_str_hash, g_int_equal);
    globalPointer = 0; /*pointer global*/
    labelInfo = 0;     /*valor da etiqueta da label*/

    yyparse();

	return 0;
} 

/* Adicionar variavel, e guardar apontador para ela*/
void addVar(char* var){
    int *point = (int *) g_hash_table_lookup(vars, var);
    Array *a = (Array *) g_hash_table_lookup(arrays, var);
  
    if(point==NULL && a==NULL){
        point = malloc(sizeof(int));
        *point = globalPointer;
        g_hash_table_insert(vars,var,point);
        globalPointer++;
    }
    else{
        char* error;
        asprintf(&error, "Variável (%s) já inicializada.", var);
        yyerror(error);
    }
}

/* Buscar apontador da variavel*/
int getVar(char* var){
    int *point = (int *) g_hash_table_lookup(vars, var);

    if(point!=NULL){
        return *point;
    }
    else{
        char* error;
        asprintf(&error, "Variável (%s) não se encontra inicializada.", var);
        yyerror(error);
    }
    return 0;
}

/*Adiciona um array, e guarda numa estrutura Array o apontador, tamanho de linhas e colunas (0 para array de 1 dimensao,n para matriz)*/
void addArray(char* var, int l, int c){
    int *point = (int *) g_hash_table_lookup(vars, var);
    Array *a = (Array *) g_hash_table_lookup(arrays, var);
    char* error;

    if(point==NULL && a==NULL){
        a = (Array *) malloc(sizeof(Array));
        a->point = globalPointer;
        a->l = l;
        a->c = c;
        g_hash_table_insert(arrays, var, a);
        globalPointer += l;
    }
    else if(l < 1){
        asprintf(&error, "Tamanho atribuido ao array (%s) inválido.[TamanhoMin >= 1]", var);
        yyerror(error);
    }
    else if(point != NULL || a != NULL){
        asprintf(&error, "Array (%s) não se encontra inicializado.", var);
        yyerror(error);
    }
}

/*retorna o apontador do array*/
int getArray(char* var){
    Array *a = (Array *) g_hash_table_lookup(arrays, var);

    if(a!=NULL){
        return a->point;
    }
    else{
        char* error;
        asprintf(&error, "Array (%s) não se encontra inicializado.", var);
        yyerror(error);
    }
    return 0;
}

/*devolve o tamanho das colunas de um array (matriz)*/
int getColuns(char* var){
    Array *a = (Array *) g_hash_table_lookup(arrays, var);

    if(a!=NULL){
        return a->c;
    }
    else{
        char* error;
        asprintf(&error, "Array (%s) não se encontra inicializado.", var);
        yyerror(error);
    }
    return 0;
}