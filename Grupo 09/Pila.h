#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct f_nodo
{
    struct f_nodo* ant;
    char dato[20];
}r_nodo;

typedef r_nodo* t_pila;


////////// PILA //////////
void crear_pila(t_pila*);
int apilar(t_pila*,char*);
int desapilar(t_pila*,char*);
int pila_vacia(t_pila*);
void vaciar_pila(t_pila*);
//////////////////////////


void crear_pila(t_pila* p)
{
    *p=NULL;
}

int apilar(t_pila* p,char* d)
{
	printf("Entre a apilar, %s\n", d);

    r_nodo* nuevo=(r_nodo*)malloc(sizeof(r_nodo));
    printf("Hice malloc\n");

    if(!nuevo){
    	printf("No se pudo reservar memoria\n");
        return 0;
    }
    printf("Reserve memoria\n");
    strcpy(nuevo->dato,d);
    printf("Asigne a nuevo el dato\n");
    nuevo->ant=*p;
    *p=nuevo;
    printf("Inserte en pila\n");

    return 1;
}

int desapilar(t_pila* p,char* d)
{
    r_nodo* viejo;
    if(!*p)
        return 0;
    viejo=(r_nodo*)malloc(sizeof(r_nodo));
    viejo=*p;
    strcpy(d,viejo->dato);
    *p=viejo->ant;
    free(viejo);
    return 1;
}

int pila_vacia(t_pila* p)
{
    return !*p;
}
