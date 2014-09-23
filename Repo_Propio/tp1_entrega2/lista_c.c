#include "lista.h"


// Completar las funciones en C

void insertar_en_lista(jugador* j, lista* l){
	bool encontre = false;
	nodo* nodo_subLista = (*l).primero;	//Aca tengo la primer lista.
	while((nodo_subLista != NULL) && !encontre){
		lista *subLista = (*nodo_subLista).datos;
		jugador *j2 = (*(*subLista).primero).datos;
		if(j2->pais == j->pais){
			insertar_ordenado(subLista, j, (tipo_funcion_cmp) menor_jugador);
			encontre = true;
		}
		nodo_subLista = nodo_subLista->sig;
	}
	if(!encontre){
		lista* jugadores = lista_crear();
		insertar_ordenado(jugadores, j, (tipo_funcion_cmp) menor_jugador);
	}
}

	/*while((nodo_subLista != NULL) && !encontre){ //mientras este parado en una lista valida y no haya encontrado la lista de mi equipo
	
		if((((nodo_subLista->datos)->primero)->datos)->pais == j->pais){

			lista* juglis = (*selec).jugadores;
			insertar_ordenado(juglis, j, (tipo_funcion_cmp) menor_jugador);

			encontre = true;
		}
		nodo_subLista = nodo_subLista->sig;
	}
*/


/*
	nodo* nod = (*l).primero;
	while(nod->sig != NULL){
		jugador *jug = (*nod).datos;
		insertar_en_lista(jug, nueva);
		nod = (*nod).sig;
	}
	nod = (*nueva).primero;
	while(nod->sig != NULL){
		seleccion* selec = (*nod).datos;
		lista* jugs = (*selec).jugadores;
		(*selec).alturaPromedio = altura_promedio(jugs);
	}*/





lista *generar_selecciones( lista *l ){
	lista* mapeada1 = mapear(l, (tipo_funcion_mapear) normalizar_jugador);	
	lista* mapeada2 = ordenar_lista_jugadores(mapeada1);	
	lista* listaDeListas = lista_crear();
	nodo* nod = mapeada2->primero;
	while(nod->sig != NULL){
		jugador *jug = (*nod).datos;
		insertar_en_lista(jug, listaDeListas);
		nod = (*nod).sig;
	}
	//hasta aca solamente tengo listas de jugadores en una lista.
	lista* result = lista_crear();
	nodo* nodo_lista_pais = listaDeListas->primero;
	while(nodo_lista_pais != NULL){
		lista *lista_pais = nodo_lista_pais->datos;
		jugador* first = lista_pais->primero->datos;
		char* p = (*first).pais;
		double a = altura_promedio(lista_pais);
		seleccion* selec = crear_seleccion(p, a, lista_pais);
		insertar_ordenado(result, selec, (tipo_funcion_cmp) menor_seleccion);
		nodo_lista_pais = nodo_lista_pais->sig;
	}

	//lista_borrar(mapeada1, (tipo_funcion_borrar) borrar_jugador);
	//lista_borrar(mapeada2, (tipo_funcion_borrar) borrar_jugador);
	//lista_borrar(listaDeListas, (tipo_funcion_borrar) lista_borrar);
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

