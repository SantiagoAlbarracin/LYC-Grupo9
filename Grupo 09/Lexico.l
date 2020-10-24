%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

FILE *yyin;



void tokenInvalido(char *s);
int errorLexico(void);

%}

%option noyywrap
%option yylineno


DIGITO 		[0-9]
LETRA		[a-zA-Z]
COMILLA_D	["]
SALTO_LINEA "\\n"

CONST_INT 			{DIGITO}+
CONST_FLOAT 		{DIGITO}+"."{DIGITO}+
CONST_STRING		\"(\\.|[^"\\])*\"
ELSE_T				"else"|"ELSE"|"Else"
IF_T				"if"|"IF"|"If"
OP_DISTINTO			"<"">"
OP_COMP				"=""="
OP_MAYORIGUAL		">""="
OP_MAYOR			">"
OP_MENOR			"<"
OP_MENORIGUAL		"<""="
LLAVE_C				"}"
LLAVE_A				"{"
PARENT_C			")"
PARENT_A			"("
OP_DIVISION			"/"
OP_AS				":"
OP_SUM				"+"
OP_MENOS			"-"
OP_MUL				"*"
WHILE_T				"while"|"WHILE"
SEP_LINEA			";"
SEPARADOR_T			","
FLOAT_T				"Float"|"float"|"FLOAT"
INTEGER_T			"Integer"|"integer"|"INTEGER"
STRING_T			"String"|"string"|"STRING"
DIM_T				"dim"|"DIM"
AS_T				"as"|"AS"
TOKEN_PUT			"put"|"PUT"
GET_T				"get"|"GET"	
CONST_T  			"const"|"CONST"
TOKEN_AND			"and"|"AND"
TOKEN_OR			"or"|"OR"
TOKEN_NOT			"not"|"NOT"
MAX_TOKEN			"máximo"|"maximo"
COMENTARIO			"*""-"({LETRA}|{DIGITO}|!|"*"|"/"|"("|")"|"-")*"-""*"
ID_T				{LETRA}.({LETRA}|{DIGITO})*

%%
{CONST_INT}			{if (atoi (yytext) < -32768 || atoi (yytext) > 32767){tokenInvalido(yytext);}else{yylval.strVal = strdup(yytext); return CONST_INT;} }
{CONST_FLOAT}		{if (atof (yytext) < -3.4E+38 || atof (yytext) > 3.4E+38){tokenInvalido(yytext);}else{yylval.strVal = strdup(yytext); return CONST_FLOAT;} }
{CONST_STRING}		{if(strlen(yytext)<=32){yylval.strVal = strdup(yytext); return CONST_STRING;}
						else{printf("\nCADENA MAYOR A 30 CARACTERES EN LA LINEA %d\n",yylineno); errorLexico();}}
{ELSE_T}			{return ELSE_T;}
{IF_T}				{return IF_T;}
{OP_DISTINTO}		{return OP_DISTINTO;}
{OP_COMP}			{return OP_COMP;}
{OP_MAYORIGUAL}		{return OP_MAYORIGUAL;}
{OP_MAYOR}			{return OP_MAYOR;}
{OP_MENOR}			{return OP_MENOR;}
{OP_MENORIGUAL}		{return OP_MENORIGUAL;}
{LLAVE_C}			{return LLAVE_C;}
{LLAVE_A}			{return LLAVE_A;}
{PARENT_C}			{return PARENT_C;}
{PARENT_A}			{return PARENT_A;}
{OP_DIVISION}		{return OP_DIVISION;}
{OP_SUM}			{return OP_SUM;}
{OP_MENOS}			{return OP_MENOS;}
{OP_AS}				{return OP_AS;}
{OP_MUL}			{return OP_MUL;}
{WHILE_T}			{return WHILE_T;}
{SEP_LINEA}			{return SEP_LINEA;}
{SEPARADOR_T}		{return SEPARADOR_T;}
{FLOAT_T}			{return FLOAT_T;}
{INTEGER_T}			{return INTEGER_T;}
{STRING_T}			{return STRING_T;}
{DIM_T}				{return DIM_T;}
{AS_T}				{return AS_T;}
{TOKEN_PUT}			{return TOKEN_PUT;}
{GET_T}				{return GET_T;}
{CONST_T}			{return CONST_T;}
{TOKEN_AND}			{return TOKEN_AND;}
{TOKEN_OR}			{return TOKEN_OR;}
{TOKEN_NOT}			{return TOKEN_NOT;}
{MAX_TOKEN}			{return MAX_TOKEN;}
{COMENTARIO}		printf("COMENTARIO EN LA LINEA %d\n",yylineno);
{ID_T}				{yylval.strVal = strdup(yytext); return ID_T;}
{SALTO_LINEA}		{yylineno++; return SALTO_LINEA;}
[.]					{tokenInvalido(yytext);}
"\t"
"\n"
" "
%%


int errorLexico(void){
printf("Error lexico\n");
	system("Pause");
	exit(1);
}

void tokenInvalido(char *s){
	printf("Error en la linea %d, token invalido %s .\n", yylineno, s);
}