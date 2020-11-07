#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct l_nodo
{
    struct l_nodo* sig;
    char elemento[32];

}l_nodo;
typedef l_nodo* t_lista;


void crear_lista(t_lista*);
int lista_vacia(t_lista* );
int enlistar(t_lista* ,char* );
int desenlistar(t_lista *,char *);
int lista_llena(t_lista* );
int vaciar_lista_INTERMEDIO(t_lista* );




void crear_lista(t_lista* l)
{
    *l=NULL;
}

int lista_vacia(t_lista* l)
{
    return !*l;
}

int enlistar(t_lista* l,char* d)
{
    l_nodo* nuevo=(l_nodo*)malloc(sizeof(l_nodo));
    if(!nuevo)
        return 0;
    nuevo->sig=*l;
    strcpy(nuevo->elemento,d);
    *l=nuevo;
    return 1;
}

int desenlistar(t_lista *l,char *d)
{
    if(!*l)
        return 0;
    l_nodo* viejo;
    viejo=*l;
    strcpy(d,viejo->elemento);
    *l=viejo->sig;
    free(viejo);
    return 1;
}

int lista_llena(t_lista* l)
{
    l_nodo* aux=(l_nodo*)malloc(sizeof(l_nodo));
    return !aux;
}

int vaciar_lista_INTERMEDIO(t_lista* l)
{
    l_nodo* aux;
    FILE* pf = fopen("intermedia.txt","w+");
    if(!pf){
        printf("No se pudo abrir el archivo;\n");
        return 0;
    }
    while(*l)
    {
        aux=*l;
        *l=aux->sig;
        fprintf(pf,"%s   ", aux->elemento);
        free(aux);
    }
    fclose(pf);
    return 1;
}
