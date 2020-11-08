%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "funciones.h"
#include "Cola.h"
#include "Pila.h"
#include "Lista.h"

tabla tablaSimbolos;
t_lista polacaLista;
t_cola cola;
t_pila pila;
t_pila posiciones;
t_pila rellenar;

char simboloComparacion[4];
int posicionPolaca = 0;

int condicionCompuesta = 0;
int posicionComparacion = 0;
int banderaOR = 0;


int yylex();
void yyerror(const char *s);
void verificaCondicion();

extern char* yytext;
extern int yylineno;


extern FILE* yyin;


%}


%union{
  
  int intVal;
  char* dataType;
  char* strVal;
  float floatVal;
  char charVal; 
}


%token <strVal> CONST_INT 	
%token <strVal> CONST_FLOAT 	
%token <strVal> CONST_STRING	
%token <strVal> ID_T      
%token ELSE_T			
%token IF_T			
%token OP_DISTINTO	
%token OP_COMP		
%token OP_MAYORIGUAL
%token OP_MAYOR		
%token OP_MENOR		
%token OP_MENORIGUAL
%token LLAVE_C		
%token LLAVE_A		
%token PARENT_C		
%token PARENT_A		
%token OP_DIVISION	
%token OP_AS		
%token OP_SUM		
%token OP_MENOS
%token OP_MUL		
%token WHILE_T		
%token SEP_LINEA	
%token SEPARADOR_T	
%token <strVal> FLOAT_T		
%token <strVal> INTEGER_T	
%token <strVal> STRING_T
%token DIM_T		
%token AS_T			
%token TOKEN_PUT	
%token GET_T		
%token CONST_T  	
%token TOKEN_AND	
%token TOKEN_OR		
%token TOKEN_NOT
%token MAX_TOKEN	
%token SALTO_LINEA



%left OP_SUM OP_MENOS
%left OP_MUL OP_DIVISION



%%

programa_: programa {printf("EL PROGRAMA ES VALIDO!! \n");}    
          ;



programa:   programa sentencia  {printf("ES UN PROGRAMA CON MAS DE UNA SENTENCIA \n");}
            |sentencia {printf("ES UNA SENTENCIA \n");}
            ;



sentencia:  iteracion {printf("ES UNA SENTENCIA: ITERACION \n");}
            |seleccion {printf("ES UNA SENTENCIA: SELECCION \n");}
            |asignacion {printf("ES UNA SENTENCIA: ASIGNACION \n");}
            |imprimir {printf("ES UNA SENTENCIA: IMPRIMIR \n");}
            |leer {printf("ES UNA SENTENCIA: LEER \n");}
            |declaracion {printf("ES UNA SENTENCIA: DECLARACION\n");}
            ;


declaracion:  DIM_T OP_MENOR dupla_asig OP_MAYOR  	{	printf("ES UNA LISTA DECLARACION\n");  
														char id[20];
 														char tipoVar[20];
 														while(!pila_vacia(&pila) || !cola_vacia(&cola) ){
															desapilar(&pila, id);
															desacolar(&cola, tipoVar);
														if(strcmp(tipoVar, "String") == 0)
															insertar(id, ES_STRING, &tablaSimbolos,NO_ES_CONSTANTE, tipoVar);
														else
															insertar(id, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE, tipoVar);

 														}
 													}
              ;   


dupla_asig:  ID_T SEPARADOR_T dupla_asig  SEPARADOR_T tipo   {  printf("ES UNA DUPLA ASIG RECURSIVA\n");  apilar(&pila, $1);}
            |ID_T OP_MAYOR AS_T OP_MENOR tipo   {  printf("ES UNA DUPLA ASIG\n"); apilar(&pila, $1);  }
            ;


tipo: 	FLOAT_T {acolar(&cola, "Float"); printf("ES UN TIPO: FLOAT \n");}
      |INTEGER_T { acolar(&cola, "Integer"); printf("ES UN TIPO: INTEGER \n");}
      |STRING_T  { acolar(&cola, "String"); printf("ES UN TIPO: STRING \n");}
      ;


iteracion:    WHILE_T PARENT_A condicion PARENT_C LLAVE_A programa LLAVE_C {verificaCondicion(); printf("ES ITERACION: WHILE_T PROGRAMA \n");}
              ;


seleccion:  seleccion_con_else { 

								printf("ES SELECCION:  SELECCION CON ELSE\n");}


            |seleccion_sin_else  { printf("ES SELECCION:  SELECCION SIN ELSE\n");}
            ;


seleccion_con_else:  IF_T PARENT_A condicion PARENT_C  argumento_sel  ELSE_T { printf("ES ITERACION: WHILE_T PROGRAMA \n"); 
												verificaCondicion();
											} 

											argumento_sel  


												{printf("ES SELECCION_CON_ELSE: IF ARGUMENTO_SEL ELSE ARGUMENTO_SEL \n");}
                ;

seleccion_sin_else: IF_T PARENT_A condicion PARENT_C  argumento_sel {
												
												verificaCondicion();
												printf("ES SELECCION_SIN_ELSE: IF ARGUMENTO_SEL \n");
												}
                    ;


argumento_sel:  LLAVE_A programa LLAVE_C  {  printf("ES ARGUMENTOS_SEL: PROGRAMA \n");}
                |sentencia  {printf("ES ARGUMENTOS_SEL: SENTENCIA \n");}
                ;




asignacion: ID_T OP_AS expresion SEP_LINEA { 	enlistar(&polacaLista, $1, posicionPolaca); posicionPolaca++;
											 	enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;
												printf("ES ASIGNACION: ID_T OP_AS EXPRESION \n"); 
												insertar($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE, "-");}


            |CONST_T  ID_T OP_AS expresion SEP_LINEA {  enlistar(&polacaLista, $2, posicionPolaca); posicionPolaca++;
            											enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;
            											printf("ES ASIGNACION: CONST_T ID_T OP_AS EXPRESION \n"); 
            											insertar($2, CON_VALOR, &tablaSimbolos,ES_CONSTANTE, "-");}
            ;


imprimir:   TOKEN_PUT elemento  SEP_LINEA { enlistar(&polacaLista, "PUT", posicionPolaca); posicionPolaca++;
														printf("ES IMPRIMIR: TOKEN_PUT CONST_STRING \n");}
            ;


leer:   GET_T ID_T  SEP_LINEA{	enlistar(&polacaLista, $2, posicionPolaca); posicionPolaca++; 
								enlistar(&polacaLista, "GET", posicionPolaca); posicionPolaca++;
								printf("ES LEER: GET_T ID_T \n"); insertar($2, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-"); }
        ;


condicion:  comparacion {printf("CONDICION: COMPARACION \n");}
            |condicion TOKEN_AND { condicionCompuesta++; } comparacion 
            															{ 
            																printf("CONDICION: CONDICION TOKEN_AND COMPARACION \n");}


            |condicion TOKEN_OR {  condicionCompuesta++; banderaOR++; } comparacion 
            					
            					{ 
            						printf("CONDICION: CONDICION TOKEN_OR COMPARACION \n"); }

            |TOKEN_NOT comparacion {  printf("CONDICION: TOKEN_NOT COMPARACION \n");}
            ;
        


comparacion: expresion comparador termino { enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
											enlistar(&polacaLista, simboloComparacion, posicionPolaca); posicionPolaca++;
											enlistar(&polacaLista, "  ", posicionPolaca );  apilarEntero(&rellenar, posicionPolaca); posicionPolaca++;
											printf("EXPRESION COMPARADOR TERMINO \n");
											}




			|PARENT_A	expresion comparador termino	PARENT_C  {printf("PARENT_A EXPRESION COMPARADOR TERMINO PARENT_C\n");}
      ;


comparador:  OP_DISTINTO { strcpy(simboloComparacion, "BEQ"); printf(" ES COMPARADOR: OP_DISTINTO \n");}
    		 |OP_COMP { strcpy(simboloComparacion, "BNE");  printf("ES COMPARADOR: OP_COMP \n");}
    		 |OP_MAYORIGUAL { strcpy(simboloComparacion, "BLT");  printf("ES COMPARADOR: OP_MAYORIGUAL \n");}
    		 |OP_MAYOR { strcpy(simboloComparacion, "BLE"); printf("ES COMPARADOR: OP_MAYOR \n");}
    		 |OP_MENORIGUAL { strcpy(simboloComparacion, "BGT"); printf("ES COMPARADOR: OP_MENORIGUAL \n");}
    		 |OP_MENOR { strcpy(simboloComparacion, "BGE"); printf("ES COMPARADOR: OP_MENOR \n");}
       ;


expresion:  expresion OP_SUM termino {  enlistar(&polacaLista, "+", posicionPolaca); posicionPolaca++; printf("ES EXPRESION: EXPRESION OP_SUM TERMINO \n");}

      |expresion OP_MENOS termino {  enlistar(&polacaLista, "-", posicionPolaca); posicionPolaca++; printf("ES EXPRESION: EXPRESION OP_MENOS TERMINO \n");}

      |termino {printf("ES EXPRESION: TERMINO \n");}

      ;


termino:    termino OP_MUL elemento {  enlistar(&polacaLista, "*", posicionPolaca); posicionPolaca++; printf("ES TERMINO: TERMINO OP_MUL ELEMENTO \n");}

      |termino OP_DIVISION elemento {  enlistar(&polacaLista, "/", posicionPolaca); posicionPolaca++; printf("ES TERMINO: TERMINO OP_DIVISION ELEMENTO \n");}

      |elemento {printf("ES TERMINO: ELEMENTO \n");}
      ;


elemento:  PARENT_A expresion PARENT_C {printf("ES ELEMENTO: PARENT_A EXPRESION PARENT_C \n");}
      
      |MAX_TOKEN PARENT_A argumentos PARENT_C {printf("ES ELEMENTO: MAX_TOKEN PARENT_A ARGUMENTOS PARENT_C \n");}


      |ID_T { enlistar(&polacaLista, $1, posicionPolaca); posicionPolaca++;  printf("ES ELEMENTO: ID_T  %s\n",$1); insertar($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-"); }


      |CONST_INT { enlistar(&polacaLista, $1, posicionPolaca); posicionPolaca++; insertar($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-");  printf("ES ELEMENTO: CONST INT \n");}


      |CONST_FLOAT { enlistar(&polacaLista, $1, posicionPolaca); posicionPolaca++; insertar($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-");  printf("ES ELEMENTO: CONST FLOAT \n");}



      |CONST_STRING { enlistar(&polacaLista, $1, posicionPolaca); posicionPolaca++; insertar($1, ES_STRING, &tablaSimbolos,NO_ES_CONSTANTE,"-");   		
      					printf("ES ELEMENTO: CONST STRING \n");}

      ;

argumentos: argumentos SEPARADOR_T expresion {printf("ES ARGUMENTO: ARGUMENTOS SEPARADOR_T EXPRESION \n");}
        	|expresion {printf("ES ARGUMENTO: EXPRESION \n");}
        ;
%%



int main(int argc,char *argv[])
{

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
    printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
    crearTabla(&tablaSimbolos);
    crear_lista(&polacaLista);
    crear_pila(&pila);
    crear_pila(&posiciones);
    crear_pila(&rellenar);
    crear_cola(&cola);

	  yyparse();
  }
  fclose(yyin);
  vaciar_lista_TS(&tablaSimbolos);
  vaciar_lista_INTERMEDIO(&polacaLista, posicionPolaca);
  

  return 0;
}


void verificaCondicion(){
	if(condicionCompuesta){
		condicionCompuesta = 0;
		rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), posicionPolaca+1);
		rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), posicionPolaca+1);

	}
	else{
		rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), posicionPolaca+1);
	} 
}



void yyerror(const char* s)
     {
       printf("Error Sintactico\n");
	     system ("Pause");
	     exit (1);
     }