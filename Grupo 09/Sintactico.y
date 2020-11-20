%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "funciones.h"


tabla tablaSimbolos;
t_lista polacaLista;
t_cola cola;
t_pila pila;
t_pila condicionesOR;
t_pila simbolosASS;
t_pila rellenar;
t_pila maximoPila;

t_pila pruMax;
char pruChr[200];
int pruNroMax = 0;
int bandRecienCerreMax = 0;
int pruCantArgsMax = 0;


char simboloComparacion[4];
int posicionPolaca = 0;

int condicionCompuesta = 0;
int posicionComparacion = 0;
int banderaOR = 0;
int siguientePolaca = 0;
int pilaTam = 0;
int condicionNot = 0;
int banderaMaxAnidado = 0;

int finmax = -1;
int posicionPolacaWhile = 0;

int yylex();
void yyerror(const char *);
void verificaCondicion();
void invertirSimbolo(char* );

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
%token FLOAT_T      
%token INTEGER_T    
%token STRING_T
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

%nonassoc IF_T  
%nonassoc ELSE_T


%%

programa_: programa {   printf("EL PROGRAMA ES VALIDO!! \n");
                        generarAssembler(&tablaSimbolos, &polacaLista, posicionPolaca);
                    }    
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


declaracion:  DIM_T OP_MENOR dupla_asig OP_MAYOR    {   printf("ES UNA LISTA DECLARACION\n");  
                                                        char id[100];
                                                        char auxString[100];
                                                        char tipoVar[20];
                                                        while(!pila_vacia(&pila) || !cola_vacia(&cola) ){
                                                            desapilar(&pila, id);
                                                            desacolar(&cola, tipoVar);
                                                        if(strcmp(tipoVar, "String") == 0)
                                                            insertar(id, ES_STRING, &tablaSimbolos,NO_ES_CONSTANTE, tipoVar );
                                                        else
                                                            insertar2(id, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE, tipoVar, auxString);

                                                        }
                                                    }
              ;   


dupla_asig:  ID_T SEPARADOR_T dupla_asig  SEPARADOR_T tipo   {  printf("ES UNA DUPLA ASIG RECURSIVA\n");    
                
                    apilar(&pila, $1);
                    }

            |ID_T OP_MAYOR AS_T OP_MENOR tipo   {  printf("ES UNA DUPLA ASIG\n");
                    
                    apilar(&pila, $1);
            }
            ;


tipo:   FLOAT_T {acolar(&cola, "Float"); printf("ES UN TIPO: FLOAT \n");}
      |INTEGER_T { acolar(&cola, "Integer"); printf("ES UN TIPO: INTEGER \n");}
      |STRING_T  { acolar(&cola, "String"); printf("ES UN TIPO: STRING \n");}
      ;


iteracion:    WHILE_T { posicionPolacaWhile = posicionPolaca; enlistar(&polacaLista, "WHILE", posicionPolaca); posicionPolaca++;} 
                                PARENT_A condicion PARENT_C LLAVE_A programa { if(posicionPolacaWhile > 0) {
                                                                                                                
                                                                                                                char cadena[15];
                                                                                                                
                                                                                                                enlistar(&polacaLista, "BI", posicionPolaca); posicionPolaca++;
                                                                                                                enlistar(&polacaLista, itoa(posicionPolacaWhile+1, cadena, 10), posicionPolaca); posicionPolaca++;
                                                                                                                
                                                                                                                
                                                                                                                                                                                                                                
                                                                                                                posicionPolacaWhile = 0;    
                                                                                                                    
                                                                                                                }
                                                                                                            } LLAVE_C {verificaCondicion(); printf("ES ITERACION: WHILE_T PROGRAMA \n");}
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




asignacion: ID_T OP_AS expresion SEP_LINEA {    

                                            
                                                
                                                char pruAux[8];
                                                char cadenaMax[15];
                                                
                                            /**/
                                                if(pruNroMax > 0){
                                                    strcpy(pruAux, "_@max");
                                                    strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));
                                                    enlistar(&polacaLista, pruAux, posicionPolaca);
                                                    posicionPolaca++;
                                                                                                                                                                            
                                                }
                                                
                                                enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                char auxString[100];
                                                
                                                insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                                                enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++;
                                                printf("ES ASIGNACION: ID_T OP_AS EXPRESION \n"); 
                                            

                                        
                                            }


            |CONST_T  ID_T OP_AS expresion SEP_LINEA {  enlistar(&polacaLista, ":", posicionPolaca); 
                                                        posicionPolaca++;
                                                        char auxString[100];
                                                        
                                                        insertar2($2, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                                                        enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++;
                                                        printf("ES ASIGNACION: CONST_T ID_T OP_AS EXPRESION \n"); 
                                                        
                                                    
                                                    }
            ;


imprimir:   TOKEN_PUT { enlistar(&polacaLista, "PUT", posicionPolaca); posicionPolaca++; } elemento  SEP_LINEA { 
                                            printf("ES IMPRIMIR: TOKEN_PUT CONST_STRING \n");
                                            
                                            
                                          }
            ;


leer:   GET_T ID_T  SEP_LINEA{  enlistar(&polacaLista, "GET", posicionPolaca); posicionPolaca++;
                                char auxString[100];
                                
                                insertar2($2, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                                enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++; 
                                printf("ES LEER: GET_T ID_T \n"); 
                                
                                
                            }
        ;


condicion:  comparacion {printf("CONDICION: COMPARACION \n");}
            |condicion TOKEN_AND { condicionCompuesta++;  enlistar(&polacaLista, "_TOKENAND_", posicionPolaca); posicionPolaca++; } 
                            comparacion  { printf("CONDICION: CONDICION TOKEN_AND COMPARACION \n"); }


            |condicion TOKEN_OR {  condicionCompuesta++; enlistar(&polacaLista, "_TOKENOR_", posicionPolaca); posicionPolaca++;} 
                                        comparacion { banderaOR++; siguientePolaca = posicionPolaca+1; printf("CONDICION: CONDICION TOKEN_OR COMPARACION \n"); }

            |TOKEN_NOT {condicionNot ++;} comparacion {   printf("CONDICION: TOKEN_NOT COMPARACION \n");}
            ;
        


comparacion: expresion comparador termino { 
                                            enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
                                            if(condicionNot > 0){
                                                invertirSimbolo(simboloComparacion);
                                                condicionNot = 0;
                                            }
                                            enlistar(&polacaLista, simboloComparacion, posicionPolaca); 
                                            apilarEntero(&condicionesOR, posicionPolaca);
                                            apilar(&simbolosASS, simboloComparacion); posicionPolaca++;
                                            enlistar(&polacaLista, "  ", posicionPolaca );  
                                            apilarEntero(&rellenar, posicionPolaca);  posicionPolaca++;
                                            printf("EXPRESION COMPARADOR TERMINO \n");
                                            
                                        
                                           }




            |PARENT_A   expresion comparador termino    PARENT_C  {
                                                                    enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
                                                                    if(condicionNot > 0){
                                                                        invertirSimbolo(simboloComparacion);
                                                                        condicionNot = 0;
                                                                    }
                                                                    enlistar(&polacaLista, simboloComparacion, posicionPolaca); 
                                                                    apilarEntero(&condicionesOR, posicionPolaca);
                                                                    apilar(&simbolosASS, simboloComparacion); posicionPolaca++;
                                                                    enlistar(&polacaLista, "  ", posicionPolaca );  
                                                                    apilarEntero(&rellenar, posicionPolaca);  posicionPolaca++;
                                                                    printf("PARENT_A EXPRESION COMPARADOR TERMINO PARENT_C\n");
                                                                }
      ;


comparador:  OP_DISTINTO { strcpy(simboloComparacion, "BEQ"); printf(" ES COMPARADOR: OP_DISTINTO \n");}
             |OP_COMP { strcpy(simboloComparacion, "BNE");  printf("ES COMPARADOR: OP_COMP \n");}
             |OP_MAYORIGUAL { strcpy(simboloComparacion, "BLT");  printf("ES COMPARADOR: OP_MAYORIGUAL \n");}
             |OP_MAYOR { strcpy(simboloComparacion, "BLE"); printf("ES COMPARADOR: OP_MAYOR \n");}
             |OP_MENORIGUAL { strcpy(simboloComparacion, "BGT"); printf("ES COMPARADOR: OP_MENORIGUAL \n");}
             |OP_MENOR { strcpy(simboloComparacion, "BGE"); printf("ES COMPARADOR: OP_MENOR \n");}
       ;


expresion:  expresion OP_SUM termino {  
                                        enlistar(&polacaLista, "+", posicionPolaca); 
                                        posicionPolaca++; 
                                        printf("ES EXPRESION: EXPRESION OP_SUM TERMINO \n");
                                        
                                

                                        /*bandRecienCerreMax = 0;*/
                                
                                    }

      |expresion OP_MENOS termino {  
                                        enlistar(&polacaLista, "-", posicionPolaca); 
                                        posicionPolaca++; 
                                        printf("ES EXPRESION: EXPRESION OP_MENOS TERMINO \n");
                                

                                        /*bandRecienCerreMax = 0;*/
                                    
                                        
                                    }

      |termino {printf("ES EXPRESION: TERMINO \n");}

      ;


termino:    termino OP_MUL elemento {  
                                        enlistar(&polacaLista, "*", posicionPolaca); 
                                        posicionPolaca++; 
                                        printf("ES TERMINO: TERMINO OP_MUL ELEMENTO \n");
                                
                                        
                                        /*bandRecienCerreMax = 0;*/
                                    
                        
                                    }

      |termino OP_DIVISION elemento {  
                                        enlistar(&polacaLista, "/", posicionPolaca); 
                                        posicionPolaca++; 
                                        printf("ES TERMINO: TERMINO OP_DIVISION ELEMENTO \n");
                                        
                        
                            
                            

                                        /*bandRecienCerreMax = 0;       */
                                    
                                    }

      |elemento {printf("ES TERMINO: ELEMENTO \n");}
      ;


elemento:  PARENT_A expresion PARENT_C {printf("ES ELEMENTO: PARENT_A EXPRESION PARENT_C \n");}
      
      |MAX_TOKEN { pilaTam++; banderaMaxAnidado++; pruNroMax++; pruCantArgsMax = 0;} 
            PARENT_A argumentos PARENT_C {                                                                                                      
                                                char cadenaMax[5];
                                                char max[8];
                                                char maxAux[8];
                                                strcpy(max, "_@max");
                                                strcat(max,itoa(pilaTam,cadenaMax,10));
                                                printf("ES ELEMENTO: MAX_TOKEN PARENT_A ARGUMENTOS PARENT_C \n");
                                                if(pilaTam>1){
                                                    desapilar(&maximoPila, maxAux);
                                                    desapilar(&maximoPila, max);
                                                    pilaTam--;
                                                    
                                                    apilar(&maximoPila, max);
                                                    finmax=1;
                                                }  else{
                                                    pilaTam = 0;
                                                    finmax = -1;
                                                    banderaMaxAnidado = 0;
                                                }   


                                        
                                                char pruAux[8];
                                                
                                                pruNroMax--;
                                                                                                                                        
                                                if (pruNroMax > 0){
                                                    bandRecienCerreMax = 1;
                                                    
                                                    strcpy(pruAux, "_@max");
                                                    strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));
                                                    enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
                                                    
                                                    enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                    enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                    
                                                    
                                                
                                                    strcpy(pruAux, "_@max");
                                                    strcat(pruAux,itoa(pruNroMax,cadenaMax,10));
                                                    enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
                                            

                                                    enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                
                                                                                
                                                    enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;                                                    
                                            
                                                    enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
                                                
                                                    enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
                                                

                                                    enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                
                                                    enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                    enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                    

                                                    
                                            

                                                    enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                                                                        
                                                }else{                                                  
                                            
                                                    
                                                    if(bandRecienCerreMax == 0){
                                                        enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;
                                                        enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;                                              
                                                
                                                        

                                                    



                                                        strcpy(pruAux, "_@max");
                                                        strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));
                                                        enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
                                            

                                                        enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                        

                                                        


                                                    
                                                                            
                                                        enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;                                
                                                        

                                                        enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
                                                        


                                                        enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
                                                        

                                                        enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                    
                                                        enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                        enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                    

                                                    

                                                        enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                        
                                                        
                                                    }
                                                }
                                                                                            
                                                
                                                
                                            }


      |ID_T {   char auxString[100];
                insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString);  
                enlistar(&polacaLista, auxString, posicionPolaca); 
                posicionPolaca++;  
                printf("ES ELEMENTO: ID_T \n"); 
                        
                
                bandRecienCerreMax = 0;
            
            }
            


      |CONST_INT {  char auxString[100];
                    insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                    enlistar(&polacaLista, auxString, posicionPolaca); 
                    posicionPolaca++; 
                    printf("ES ELEMENTO: CONST INT \n");
                
                    
                    bandRecienCerreMax = 0;
                    
                                                                                    
                    
                                                                
                }


      |CONST_FLOAT {    char auxString[100];
                        
                        insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                        enlistar(&polacaLista, auxString, posicionPolaca);  
                        posicionPolaca++;
                        printf("ES ELEMENTO: CONST FLOAT  %s   %s\n",$1, auxString);
                        bandRecienCerreMax = 0;                         
                    }



      |CONST_STRING { char auxString[40];
                        char caditoa[40];
                        char aux[40];
                        //strcpy(aux, $1);
                        //strcat(aux, itoa(posicionPolaca, caditoa, 10));
                        

                    
                        strcpy(aux, $1);
                        for(int i = 0; aux[i]; i++){
                          aux[i] = tolower(aux[i]);
                        } 

                        insertar2(aux, ES_STRING, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 

                        for(int i = 0; auxString[i]; i++){
                          auxString[i] = tolower(auxString[i]);
                        } 
                        enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++;  

                        
                        printf("ES ELEMENTO: CONST STRING TIENE %s \n", auxString);

                                                            
                        
                        bandRecienCerreMax = 0;                     
                        
                        
                    }

      ;

argumentos: argumentos {pruCantArgsMax++;} SEPARADOR_T {
                                                            if(pruNroMax > 0 && pruCantArgsMax > 1){
                                                                char max[8];
                                                                char cadenaMax[5];
                                                                strcpy(max, "_@max");
                                                                strcat(max,itoa(pilaTam,cadenaMax,10));
                                                                
                                                                enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                                enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;                                                      

                                                                
                                                                enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;

                                                                insertar(max, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"Integer");

                                                                enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;

                                                                insertar("@aux", SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"Integer");

                                                                

                                                                enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
                                                                

                                                                enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
                                                                
                                                                enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
                                                                

                                                                enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                                
                                                                enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                                enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                                

                                                                
                                                                
                                                                }

                                                        }   expresion   { 
                                                                        char cadenaMax[5];
                                                                        char max[8];
                                                                        strcpy(max, "_@max");
                                                                        strcat(max,itoa(pilaTam,cadenaMax,10));
                                                                        
                                                                        
                                                                        printf("ES ARGUMENTO: ARGUMENTOS SEPARADOR_T EXPRESION \n");

                                                                        insertar(max, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"Integer");

                                                                        
                                                                

                                                                        if (pruNroMax > 1){

                                                                            enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;


                                                                            enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                                                


                                                                            
                                                                            enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                                            

                                                                            
                                                                            enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                                            



                                                                            enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
                                                                            

                                                                            enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
                                                                            

                                                                            enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
                                                                        

                                                                            enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
                                                                            
                                                                            enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

                                                                            enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                                                                            

                                                                            
                                                                            
                                                                        }
                                                                        
                                                                                                                
                                                                    }



            |expresion {    
                            char cadenaMax[5];
                            char max[8];
                            strcpy(max, "_@max");
                            strcat(max,itoa(pilaTam,cadenaMax,10));
                            apilar(&maximoPila, max);
                            

                            insertar(max, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"Integer");

                            printf("ES ARGUMENTO: EXPRESION \n"); 
                            
    
                            enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;                                                              


                            enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
                        

                                                        
                        }
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
    crear_pila(&simbolosASS);
    crear_pila(&rellenar);
    crear_pila(&maximoPila);
    crear_cola(&cola);
    crear_pila(&condicionesOR);
    
    
    
    yyparse();
  }
  fclose(yyin);

  return 0;
}


void verificaCondicion(){
    if(condicionCompuesta){
        condicionCompuesta = 0;
        if(banderaOR){
                char aux1[10];
                char aux2[10];
                desapilar(&simbolosASS, aux1);
                desapilar(&simbolosASS, aux2);

                invertirSimbolo(aux2);
                
                banderaOR = 0;  
                
                rellenarPolacaChar(&polacaLista, desapilarEntero(&condicionesOR), aux1);
                rellenarPolacaChar(&polacaLista, desapilarEntero(&condicionesOR), aux2);
                rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), posicionPolaca+1);         
                rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), siguientePolaca);              
        }else{
        
        rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), posicionPolaca+1);
        rellenarPolaca(&polacaLista, desapilarEntero(&rellenar), posicionPolaca+1);
        }   
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


void invertirSimbolo(char* aux){
    
    if(strcmp(aux, "BEQ") == 0){
        strcpy(aux, "BNE");
    }else if(strcmp(aux, "BNE") == 0){
        strcpy(aux, "BEQ");
    } else if(strcmp(aux, "BLT") == 0){
        strcpy(aux, "BGE");
    }else  if(strcmp(aux, "BLE") == 0){
        strcpy(aux, "BGT");
    }else   if(strcmp(aux, "BGT") == 0){
        strcpy(aux, "BLE");
    }else{
        strcpy(aux, "BLT");
    }
}

