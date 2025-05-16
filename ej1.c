#include "ej1.h"

list_t* listNew(){
  list_t* l = (list_t*) malloc(sizeof(list_t));
  l->first=NULL;
  l->last=NULL;
  return l;
}

void listAddLast(list_t* pList, pago_t* data){
    listElem_t* new_elem= (listElem_t*) malloc(sizeof(listElem_t));
    new_elem->data=data;
    new_elem->next=NULL;
    new_elem->prev=NULL;
    if(pList->first==NULL){
        pList->first=new_elem;
        pList->last=new_elem;
    } else {
        pList->last->next=new_elem;
        new_elem->prev=pList->last;
        pList->last=new_elem;
    }
}


void listDelete(list_t* pList){
    listElem_t* actual= (pList->first);
    listElem_t* next;
    while(actual != NULL){
        next=actual->next;
        free(actual);
        actual=next;
    }
    free(pList);
}

uint8_t contar_pagos_aprobados(list_t *pList, char *usuario) {
    uint8_t contador = 0;
    listElem_t *actual = pList->first;

    while (actual != NULL) {
        pago_t *pago = actual->data;
        if (pago->aprobado == 1 && strcmp(pago->cobrador, usuario) == 0) {
            contador++;
        }
        actual = actual->next;
    }

    return contador;
}


uint8_t contar_pagos_rechazados(list_t* pList, char* usuario){
    uint8_t contador = 0;
    listElem_t *actual = pList->first;

    while (actual != NULL) {
        pago_t *pago = actual->data;
        if (pago->aprobado == 0 && strcmp(pago->cobrador, usuario) == 0) {
            contador++;
        }
        actual = actual->next;
    }

    return contador;
}


pagoSplitted_t* split_pagos_usuario(list_t* pList, char* usuario) {
    // 1) Primer pase: cuento cuántos aprobados y rechazados
    uint8_t cap = contar_pagos_aprobados(pList, usuario);
    uint8_t cr  = contar_pagos_rechazados(pList, usuario);

    // 2) Reservo el struct y los dos arrays de punteros
    pagoSplitted_t* ps = malloc(sizeof(pagoSplitted_t));
    ps->cant_aprobados  = cap;
    ps->cant_rechazados = cr;
    ps->aprobados  = malloc(cap * sizeof(pago_t*));
    ps->rechazados = malloc(cr  * sizeof(pago_t*));

    // 3) Segundo pase: recorro otra vez la lista y voy llenando
    listElem_t* nodo = pList->first;
    uint8_t iA = 0, iR = 0;
    while (nodo) {
        pago_t* pago = nodo->data;
        if ( strcmp(pago->cobrador, usuario)==0 ) {
            if (pago->aprobado) {
                ps->aprobados[iA++] = pago;
            } else {
                ps->rechazados[iR++] = pago;
            }
        }
        nodo = nodo->next;
    }

    return ps;
}
