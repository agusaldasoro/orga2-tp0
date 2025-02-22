#include "lista.h"

bool string_iguales(char* a, char* b);
// Completar las funciones en C


void insertar_en_lista(jugador* j, lista* l){ //l es lista de selecciones
	bool encontre = false;
	jugador* j2 = crear_jugador(j->nombre, j->pais, j->numero, j->altura);
	nodo* nodo_selec = (*l).primero;	//Aca tengo la primer seleccion.
	while((nodo_selec != NULL) && !encontre){
		seleccion* selec = nodo_selec->datos;
		if(string_iguales((*selec).pais, (*j).pais)){
			lista* insertar = selec->jugadores;
			insertar_ordenado(insertar, j2, (tipo_funcion_cmp) menor_jugador);
			encontre = true;
		}
		nodo_selec = nodo_selec->sig;
	}
	if(!encontre){
		lista* jugadores = lista_crear();
		insertar_ordenado(jugadores, j2, (tipo_funcion_cmp) menor_jugador);
		seleccion* nueva = crear_seleccion(j->pais, j->altura, jugadores);
		insertar_ordenado(l, nueva, (tipo_funcion_cmp) menor_seleccion);
	}	
}

lista *generar_selecciones( lista *l ){
	lista* result = lista_crear();
	lista* mapeada = mapear(l, (tipo_funcion_mapear) normalizar_jugador); 
	nodo* nod = (*mapeada).primero;
	while(nod != NULL){
		jugador *jug = (*nod).datos;
		insertar_en_lista(jug, result); //result es lista de selecciones, jug se le pasa por referencia.
		nod = (*nod).sig;
	}
	nod = (*result).primero;
	while(nod != NULL){
		seleccion* selec = (*nod).datos;
		lista* jugs = (*selec).jugadores;
		(*selec).alturaPromedio = altura_promedio(jugs);
		//lista_borrar(jugs, (tipo_funcion_borrar) borrar_jugador);
		nod = (*nod).sig;
	}
	//free(nod);
	lista_borrar(mapeada, (tipo_funcion_borrar) borrar_jugador);
	return result;
} 




// Funciones ya implementadas en C 

lista *filtrar_jugadores (lista *l, tipo_funcion_cmp f, nodo *cmp){
	lista *res = lista_crear();
	nodo *n = l->primero;
    while(n != NULL){
		if (f (n->datos, cmp->datos)){
			jugador *j = (jugador *) n->datos;
			nodo *p = nodo_crear ( (void *) crear_jugador (j->nombre, j->pais, j->numero, j->altura) );
			insertar_ultimo (res, p);
		}
		n = n->sig;
	}
	return res;
}

void insertar_ultimo (lista *l, nodo *nuevo){
	nodo *ultimo = l->ultimo;
	if (ultimo == NULL){
		l->primero = nuevo;
	}
	else{
		ultimo->sig = nuevo;
	}
	nuevo->ant = l->ultimo;
	l->ultimo = nuevo;
}

