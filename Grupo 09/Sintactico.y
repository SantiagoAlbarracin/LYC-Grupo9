%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include "y.tab.h"
#include "funciones.h"



tabla tablaSimbolos;
tabla constantes;

t_lista polacaLista;
t_cola cola;
t_pila pilaSint;
t_pila condicionesOR;
t_pila simbolosASS;
t_pila rellenar;
t_pila maximoPila;

t_pila pruMax;
char pruChr[200];
int pruNroMax = 0;
int bandRecienCerreMax = 0;
void apilarPru(char*, void*);
void inicializarCantArg();
int pruCantArgsMax[50];

char simboloComparacion[4];
int posicionPolaca = 0;

int condicionCompuesta = 0;
int posicionComparacion = 0;
int banderaOR = 0;
int siguientePolaca = 0;
int pilaTam = 0;
int banderaMaxAnidado = 0;
int condicionNot = 0;
int esMax = 0;
int finmax = -1;
int posicionPolacaWhile = 0;
int cierraMax = 0;

char *prueba;

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

%nonassoc IF_T	
%nonassoc ELSE_T


%%

programa_: programa {   printf("EL PROGRAMA ES VALIDO!! \n");
                        generarAssembler(&tablaSimbolos, &polacaLista, posicionPolaca);
                    }    


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


declaracion:  DIM_T OP_MENOR dupla_asig OP_MAYOR  	{   printf("ES UNA LISTA DECLARACION\n");  
													    char id[100];
													    char auxString[100];
													    char tipoVar[20];
													    while(!pila_vacia(&pilaSint) || !cola_vacia(&cola) ){
													        desapilar(&pilaSint, id);
													        desacolar(&cola, tipoVar);
													    if(strcmp(tipoVar, "String") == 0)
													        insertar(id, ES_STRING, &tablaSimbolos,NO_ES_CONSTANTE, tipoVar );
													    else
													        insertar2(id, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE, tipoVar, auxString);
													    }
													}
              ;   


dupla_asig:  ID_T SEPARADOR_T dupla_asig  SEPARADOR_T tipo   {  printf("ES UNA DUPLA ASIG RECURSIVA\n");  apilar(&pilaSint, $1);}
            |ID_T OP_MAYOR AS_T OP_MENOR tipo   {  printf("ES UNA DUPLA ASIG\n"); apilar(&pilaSint, $1);  }
            ;


tipo: 	FLOAT_T {acolar(&cola, "Float"); printf("ES UN TIPO: FLOAT \n");}
      |INTEGER_T { acolar(&cola, "Integer"); printf("ES UN TIPO: INTEGER \n");}
      |STRING_T  { acolar(&cola, "String"); printf("ES UN TIPO: STRING \n");}
      ;


iteracion:    WHILE_T { posicionPolacaWhile = posicionPolaca; enlistar(&polacaLista, "WHILE", posicionPolaca); posicionPolaca++;} 
										 PARENT_A condicion PARENT_C LLAVE_A programa { if(posicionPolacaWhile > 0) {
																												
																												char cadena[15];
																												
																												enlistar(&polacaLista, "BI", posicionPolaca); posicionPolaca++;
																												enlistar(&polacaLista, itoa(posicionPolacaWhile+1, cadena, 10), posicionPolaca); posicionPolaca++;
																												
																												/* ============================= */
																												/* ========= MARIANO =========== */
																												/* ============================= */
																												
																												apilarPru("", "BI");
																												apilarPru("", itoa(posicionPolacaWhile+1, cadena, 10));
																												
																												/* ============================= */
																																																								
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

												/* ============================= */
												/* ========= MARIANO =========== */
												/* ============================= */
												/*apilarPru("", "-----EEEE");	*/
												char pruAux[8];
												char cadenaMax[15];
												
												
												/* VERIFICAR */
												if(pruNroMax > 0){
													strcpy(pruAux, "_@max");
													strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));
													enlistar(&polacaLista, pruAux, posicionPolaca);
													posicionPolaca++;
													apilarPru("", pruAux);																																
													
													
												}
													if(esMax == 0 && cierraMax > 0){
														strcpy(pruAux, "_@max");
														strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));
														
														enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
														cierraMax = 0;
													}

												enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

												char auxString[100];
                                                if(esta_en_Lista(&constantes,$1) == 1){
                               					 	insertar2($1, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString);  
              									}else{
            				 				 		strcpy(auxString, "_");
            				 				 		strcat(auxString, $1);
													strcat(auxString, "_esddfloat");
													prueba = str_replace(".", "_", auxString);
													strcpy(auxString, prueba);
              									}
                             				                   
                                                enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++;
												printf("ES ASIGNACION: ID_T OP_AS EXPRESION \n"); 
												

												cierraMax = 0;
												esMax = 0;
												pruNroMax = 0;
												bandRecienCerreMax = 0;
												banderaMaxAnidado = 0;
												finmax = -1;
											//	for(int fortam = 0; fortam < 50; fortam++){
											//		pruCantArgsMax[fortam] = -1;
											//	}


												/*agregado*/													
												
												apilarPru("", pruAux);
												
												
												apilarPru("*****APILO ASIGNACION ID", $1);
												apilarPru("", ":");
												if(pruNroMax==0){

                                                    pruNroMax = 0;
                                                    inicializarCantArg();
                                                    bandRecienCerreMax = 0;
                                                }
												/*apilarPru("", "-----EEEE");	*/
												/* ============================= */
											}


            |CONST_T  ID_T OP_AS expresion SEP_LINEA {  
            					            			enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

            											char auxString[100];
                                                        char auxConst[100];
                                                       //strcpy(auxConst, "const_");
                                                       //strcat(auxConst, $2);
                                                        insertar2($2, SIN_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 

                                                        tuplaTabla* nuevo;
														nuevo = (tuplaTabla*) malloc(sizeof(tuplaTabla));
														if(!nuevo){
																printf("Error, no hay memoria\n.");
																return -1;
															}
														strcpy(nuevo->constValor, $2);

                                                        enlistar_en_ordenValor(&constantes, nuevo );




                                                        enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++;
            											printf("ES ASIGNACION: CONST_T ID_T OP_AS EXPRESION \n"); 
            											
														
														/* ============================= */
														/* ========= MARIANO =========== */
														/* ============================= */
														
														apilarPru("*****APILO ASIGNACION CONST_T", $2);
														apilarPru("", ":");	
														
														/* ============================= */
													}
            ;


imprimir:   TOKEN_PUT {enlistar(&polacaLista, "PUT", posicionPolaca); posicionPolaca++; }  elemento  SEP_LINEA { 
											printf("ES IMPRIMIR: TOKEN_PUT CONST_STRING \n");
											
											/* ============================= */
											/* ========= MARIANO =========== */
											/* ============================= */
														
											apilarPru("*****APILO PUT", "PUT");
											
											/* ============================= */
														
										  }
            ;


leer:   GET_T ID_T  SEP_LINEA{  enlistar(&polacaLista, "GET", posicionPolaca); posicionPolaca++;
                                char auxString[100];
                                if(esta_en_Lista(&constantes,$2) == 1){
                               	 insertar2($2, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
              					} 
              					else{
            				  		strcpy(auxString, "_");
            				  		strcat(auxString, $2);
									strcat(auxString, "_esddfloat");
									prueba = str_replace(".", "_", auxString);
									strcpy(auxString, prueba);
              					}
                                enlistar(&polacaLista, auxString, posicionPolaca); posicionPolaca++; 
                                printf("ES LEER: GET_T ID_T \n"); 
                                
                                
                            }
        ;


condicion:  comparacion {printf("CONDICION: COMPARACION \n");}
            |condicion TOKEN_AND { condicionCompuesta++; enlistar(&polacaLista, "_TOKENAND_", posicionPolaca); posicionPolaca++; } 
            					comparacion 	{ printf("CONDICION: CONDICION TOKEN_AND COMPARACION \n"); }


            |condicion TOKEN_OR {  condicionCompuesta++; enlistar(&polacaLista, "_TOKENOR_", posicionPolaca); posicionPolaca++;} 
            					comparacion { banderaOR++; siguientePolaca = posicionPolaca+1; printf("CONDICION: CONDICION TOKEN_OR COMPARACION \n"); }

            |TOKEN_NOT {condicionNot ++;} comparacion {  printf("CONDICION: TOKEN_NOT COMPARACION \n");}
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
											
											/* ============================= */
											/* ========= MARIANO =========== */
											/* ============================= */
											
											apilarPru("*****APILO COMPARACION", "CMP");
											apilarPru("*****APILO COMPARACION", simboloComparacion);
											apilarPru("*****APILO COMPARACION", "  ");
											
											/* ============================= */
										   }




			|PARENT_A	expresion comparador termino	PARENT_C  {
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
										
										/* ============================= */
										/* ========= MARIANO =========== */
										/* ============================= */

										/*bandRecienCerreMax = 0;*/
										apilarPru("*******APILO SUMA:", "+");
										
										/* ============================= */
									}

      |expresion OP_MENOS termino {  
										enlistar(&polacaLista, "-", posicionPolaca); 
										posicionPolaca++; 
										printf("ES EXPRESION: EXPRESION OP_MENOS TERMINO \n");
										
										/* ============================= */
										/* ========= MARIANO =========== */
										/* ============================= */

										/*bandRecienCerreMax = 0;*/
										apilarPru("*******APILO RESTA:", "-");
										
										/* ============================= */
										
									}

      |termino {printf("ES EXPRESION: TERMINO \n");}

      ;


termino:    termino OP_MUL elemento {  
										enlistar(&polacaLista, "*", posicionPolaca); 
										posicionPolaca++; 
										printf("ES TERMINO: TERMINO OP_MUL ELEMENTO \n");
										
										/* ============================= */
										/* ========= MARIANO =========== */
										/* ============================= */
										
										/*bandRecienCerreMax = 0;*/
										apilarPru("*******APILO MULTIPLICACION:", "*");
										
										/* ============================= */
									}

      |termino OP_DIVISION elemento {  
										enlistar(&polacaLista, "/", posicionPolaca); 
										posicionPolaca++; 
      									printf("ES TERMINO: TERMINO OP_DIVISION ELEMENTO \n");
										
										/* ============================= */
										/* ========= MARIANO =========== */
										/* ============================= */

										/*bandRecienCerreMax = 0;		*/
										apilarPru("*******APILO DIVISION:", "/");
										
										/* ============================= */
									}

      |elemento {printf("ES TERMINO: ELEMENTO \n");  }
      ;


elemento:  PARENT_A expresion PARENT_C {printf("ES ELEMENTO: PARENT_A EXPRESION PARENT_C \n");}
      
      |MAX_TOKEN { esMax++; pilaTam++; banderaMaxAnidado++; pruNroMax++; /*pruCantArgsMax[pruNroMax] = 0;*/} 
			PARENT_A argumentos PARENT_C { 		
												cierraMax++;																								
												esMax--;
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


												/* ============================= */
												/* ========= MARIANO =========== */
												/* ============================= */
												char pruAux[8];
												
												/*pruNroMax--;
												
												if (pruNroMax > 0){*/
												
												if (pruNroMax > 1){
													/*apilarPru("", "-----AAAA");	*/
													
													bandRecienCerreMax = 1;
													
													strcpy(pruAux, "_@max");
													/*strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));*/
													strcat(pruAux,itoa(pruNroMax,cadenaMax,10));
																									
													enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
													apilarPru("", pruAux);
													
																										
													if(pruCantArgsMax[pruNroMax] > 0 && pruNroMax > 1) { /*solo cuando no es primer argumento */
														
														/*apilarPru("", "        +++++++++");																		
														apilarPru("", itoa(pruCantArgsMax[1],cadenaMax,10));														
														apilarPru("", itoa(bandRecienCerreMax,cadenaMax,10));													
														apilarPru("", "        ********");																
														apilarPru("", itoa(pruNroMax,cadenaMax,10));														
														apilarPru("", itoa(pruCantArgsMax[pruNroMax],cadenaMax,10));														
														apilarPru("", "        ********");
														*/
														
														pruNroMax--;
														
														if (bandRecienCerreMax = 0 && (pruCantArgsMax[1] > 1 || (pruCantArgsMax[1]= 1 && pruNroMax == 1))){
															enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;
								
															enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
															apilarPru("", "_@aux");
															apilarPru("", ":");
																														
															
															strcpy(pruAux, "_@max");
															strcat(pruAux,itoa(pruNroMax,cadenaMax,10));
															enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
															apilarPru("", pruAux);

															enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
															apilarPru("", "_@aux");
															
															
																						
															enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;													
															apilarPru("", "CMP");
															enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
															apilarPru("", "BLE");

															enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
															apilarPru("", "8888");

															enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
															apilarPru("", "_@aux");

															enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

															enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
															apilarPru("", max);

															
															apilarPru("", ":");	

															/*enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
															apilarPru("", max);*/
														}
													}

												}else{													
													/* HAY QUE DETECTAR SI LO QUE VINO FUE UN MAXIMO O NO */
													/* SI ES MAXIMO(1, 2, MAXIMO(3,4)) NO HAY QUE HACERLO */
													/* SI ES MAXIMO(1, MAXIMO(3,4), 5) SI */																								
													pruNroMax--;
													if(bandRecienCerreMax == 0){
														/*apilarPru("", "-----BBBB");	*/
													

														enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

														enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;												
														apilarPru("", "_@aux");
														
														
														apilarPru("", ":");

													
														strcpy(pruAux, "_@max");
														strcat(pruAux,itoa(pruNroMax+1,cadenaMax,10));
														/*strcat(pruAux,itoa(pruNroMax,cadenaMax,10));*/
														enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
														apilarPru("", pruAux);

														enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
														apilarPru("", "_@aux");
																						
																			
														enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;								
														apilarPru("", "CMP");

														enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
														apilarPru("", "BLE");


														enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
														apilarPru("", "8888");

														enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
														apilarPru("", "_@aux");

														enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;


														enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
														apilarPru("", max);

														
														apilarPru("", ":");

														/*enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
														apilarPru("", max);*/
														
														/*apilarPru("", "-----BBBB");	*/
														
													}
												}
												
												
												/* ============================= */
												
      										}


      |ID_T { 	
				char auxString[100];

				if(esta_en_Lista(&constantes,$1) == 1){
              	  insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
              	 } else{
              		strcpy(auxString, "_");
              		strcat(auxString, $1);
					strcat(auxString, "_esddfloat");
					prueba = str_replace(".", "_", auxString);
					strcpy(auxString, prueba);
              	}
                enlistar(&polacaLista, auxString, posicionPolaca); 
                posicionPolaca++;  
				printf("ES ELEMENTO: ID_T  %s\n",$1); 
      			
						

				/* ============================= */
				/* ========= MARIANO =========== */
				/* ============================= */							
				bandRecienCerreMax = 0;
				
				apilarPru("*******APILO ID:", $1);
				
				/* ============================= */
			}
			


      |CONST_INT { 
					char auxString[100];
                    insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                    enlistar(&polacaLista, auxString, posicionPolaca); 
                    posicionPolaca++; 
					printf("ES ELEMENTO: CONST INT \n");
						
					/* ============================= */
					/* ========= MARIANO =========== */
					/* ============================= */	
					
					bandRecienCerreMax = 0;
					
					apilarPru("*******APILO CONST_INT:", $1);																				
					
					/* ============================= */												
				}


      |CONST_FLOAT {  char auxString[100];
                        
                        insertar2($1, CON_VALOR, &tablaSimbolos,NO_ES_CONSTANTE,"-", auxString); 
                        enlistar(&polacaLista, auxString, posicionPolaca);  
                        posicionPolaca++;
                        printf("ES ELEMENTO: CONST FLOAT \n");
	  
						/* ============================= */
						/* ========= MARIANO =========== */
						/* ============================= */												
						
						bandRecienCerreMax = 0;
						
						apilarPru("*******APILO CONST_FLOAT:", $1);																				
						
						/* ============================= */												
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
      					printf("ES ELEMENTO: CONST STRING \n");
						
						/* ============================= */
						/* ========= MARIANO =========== */
						/* ============================= */												
						
						bandRecienCerreMax = 0;						
						
						apilarPru("*******APILO CONST_STRING:", $1);																				
						
						/* ============================= */		
					}

      ;

argumentos: argumentos 	SEPARADOR_T {	
															if(pruNroMax == 1 && pruCantArgsMax[pruNroMax] > 1 && bandRecienCerreMax == 0){
																
																/*apilarPru("", "-----CCCC");*/
																																
																char max[8];
																char cadenaMax[5];
																
																/*
																char pruAux[8];
																strcpy(pruAux, "_@max");
																strcat(pruAux,itoa(pruNroMax,cadenaMax,10));
																enlistar(&polacaLista, pruAux, posicionPolaca); posicionPolaca++;
																apilarPru("", pruAux);
																*/
																
																strcpy(max, "_@max");
																strcat(max,itoa(pilaTam,cadenaMax,10));
																
																enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

																enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;														
																apilarPru("", "_@aux");	

																
																apilarPru("", ":");
																
																enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
																apilarPru("", max);

																enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
																apilarPru("", "_@aux");

																

																enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
																apilarPru("", "CMP");

																enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
																apilarPru("", "BLE");

																enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
																apilarPru("", "9999"); //POSICIONPOLACA+5

																enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
																apilarPru("", "_@aux");

																enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;


																enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
																apilarPru("", max);

																
																apilarPru("", ":");
																
																/*apilarPru("", "-----CCCC");	*/
																
																}
															
														} 	expresion 	{ 
																		pruCantArgsMax[pruNroMax]++; 
																		
																		char cadenaMax[5];
																		char max[8];
																		strcpy(max, "_@max");
																		strcat(max,itoa(pilaTam,cadenaMax,10));
																		
																		
																		
																		//pruCantArgsMax[pruNroMax]++; 
																		
																	
																			
																		printf("ES ARGUMENTO: ARGUMENTOS SEPARADOR_T EXPRESION \n");																		
																		
																		/* ============================= */
																		/* ========= MARIANO =========== */
																		/* ============================= */

																		if (pruNroMax > 1){
																			/*apilarPru("", "-----DDDD");	*/

																			enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;


																			enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
																			apilarPru("", "_@aux");	

																			
																			apilarPru("", ":");
																			
																			enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
																			apilarPru("", max);

																			
																			enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
																			apilarPru("", "_@aux");



																			enlistar(&polacaLista, "CMP", posicionPolaca); posicionPolaca++;
																			apilarPru("", "CMP");

																			enlistar(&polacaLista, "BLE", posicionPolaca); posicionPolaca++;
																			apilarPru("", "BLE");

																			enlistar(&polacaLista, itoa(posicionPolaca+5, cadenaMax, 10), posicionPolaca); posicionPolaca++;
																			apilarPru("", "9999"); /*POSICIONPOLACA+5*/

																			enlistar(&polacaLista, "_@aux", posicionPolaca); posicionPolaca++;
																			apilarPru("", "_@aux");


																			enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;

																			enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
																			apilarPru("", max);

																			
																			apilarPru("", ":");
																		
																			/*apilarPru("", "-----DDDD");	*/
																		}
																		
																		/* ============================= */												
																	}



        	| expresion {  	
							char cadenaMax[5];
							char max[8];
							strcpy(max, "_@max");
							strcat(max,itoa(pilaTam,cadenaMax,10));
							apilar(&maximoPila, max);
        					
							printf("ES ARGUMENTO: EXPRESION \n"); 
							
							
							/* ============================= */
							/* ========= MARIANO =========== */
							/* ============================= */
							
							

							if (bandRecienCerreMax) {
								//printf ("*******ELEMENTO RECIEN CERRE EL MAXIMO \n");
							}
														
							
							
							enlistar(&polacaLista, ":", posicionPolaca); posicionPolaca++;	

							enlistar(&polacaLista, max, posicionPolaca); posicionPolaca++;
							apilarPru("*******APILO EXPRESION:", max);		

																						
							apilarPru("", ":");	
							/*apilarPru("", "-----FFFF");	*/
							/* ============================= */												
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
  	crearTabla(&constantes);
    crearTabla(&tablaSimbolos);
    crear_lista(&polacaLista);
    crear_pila(&pilaSint);
    crear_pila(&simbolosASS);
    crear_pila(&rellenar);
    crear_pila(&maximoPila);
    crear_cola(&cola);
	crear_pila(&condicionesOR);
	
	crear_pila(&pruMax);
	inicializarCantArg();
	
	
	yyparse();
  }
  fclose(yyin);
  
  while(!pila_vacia(&pruMax)){
	desapilar(&pruMax,pruChr);
	//printf("%s\n", pruChr);	
	}

  return 0;
}

void inicializarCantArg(){
	int x;
	
	for(x=0;x<50;x++)
		pruCantArgsMax[x]= 1;
}

void verificaCondicion(){
	if(condicionCompuesta){
		condicionCompuesta = 0;
		if(banderaOR){
				char aux1[10];
				char aux2[10];
				desapilar(&simbolosASS, aux1);
				desapilar(&simbolosASS, aux2);

				//printf("ENTRE A BANDERAOR\n");
				invertirSimbolo(aux2);
				
				banderaOR = 0;
				//printf("LLEGO\n");
				//printf("aux1: %s \n", aux1);				
				
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
		//printf("ENTRE A BEQ    SIMBOLOCOMPARACION TIENE %s\n", aux);
		strcpy(aux, "BGT");
		//printf("SALGO DE BEQ    SIMBOLOCOMPARACION TIENE %s\n", aux);
	}else	if(strcmp(aux, "BGT") == 0){
		strcpy(aux, "BLE");
	}else{
		strcpy(aux, "BLT");
	}
}


void apilarPru(char* texto, void* valor){
	char cadena[10];
	
	//printf("****APILANDO... p:%d t:%s v:%s\n", pruNroMax, texto, valor);
	
	strcat(pruChr, itoa(pruNroMax, cadena, 10));
	strcat(pruChr, ") ");
	strcat(pruChr, valor);
	apilar(&pruMax, pruChr);
	
	if(strlen(texto) > 0){
		//printf("%s %s\n", texto, pruChr);
	}
	
	strcpy(pruChr,"");							
}