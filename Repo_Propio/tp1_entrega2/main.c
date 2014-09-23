#include "lista.h"
#include <stdio.h>

char* string_copiar(char* a);
bool string_iguales(char* a, char* b);
int string_comparar(char* a, char*b);

void f(void* v){
	void* v2;
	v2 = v;
	v = v2;
}

void g(void* v, FILE* f){
	void* v2;
	v2 = v;
	v = v2;
	FILE* f2;
	f2 = f;
	f = f2;	
}

bool c(void* v1, void* v2){
	v1 = v2;
	v2 = v1;
	return true;
}
	
int main(void) { 
	
//1)
FILE* fileA;
remove("salida.txt");
fileA = fopen("salida.txt","a");
fprintf(fileA, "\n Test 1: \n \n");
fclose (fileA); 

	lista* l1 = lista_crear();
	lista_imprimir(l1, "salida.txt", g);
	lista_borrar(l1, f); 

//2)


fileA = fopen("salida.txt","a");
fprintf(fileA, "\n Test 2: \n \n");
fclose (fileA); 
	lista* l2 = lista_crear();
	char* nom = "Agustina";
	char* pais = "Arg";
	char num = '&';
	unsigned int alt = 79;
	jugador* j2= crear_jugador(nom, pais, num, alt);
	insertar_ordenado(l2, j2, c);
	lista_imprimir(l2, "salida.txt", (tipo_funcion_imprimir) imprimir_jugador);
	lista_borrar(l2, (tipo_funcion_borrar) borrar_jugador); 
 
//3) 

	

fileA = fopen("salida.txt","a");
fprintf(fileA, "\n Test 3: \n \n");
fclose (fileA); 
	lista* l3 = lista_crear();
		char* nom3 = "Josefina";
		char* pais3 = "Esp";
		char num3 = '!';
		unsigned int alt3 = 23;
	jugador* j3= crear_jugador(nom3, pais3, num3, alt3);
	insertar_ordenado(l3, j3, (tipo_funcion_cmp) menor_jugador);	
	lista_imprimir(l3, "salida.txt", (tipo_funcion_imprimir) imprimir_jugador);
	lista_borrar(l3, (tipo_funcion_borrar) borrar_jugador);

//4) 

//A)
fileA = fopen("salida.txt","a");
fprintf(fileA, "\n Test 4a: \n \n");
fclose (fileA); 
	lista* l4a = lista_crear();

	char *pa4a = "Argentina";
	double altP4a = 34.0;
	lista *jug4a = lista_crear();
	seleccion* s4 = crear_seleccion(pa4a, altP4a, jug4a);
	
	insertar_ordenado(l4a, s4, c);

fileA = fopen("salida.txt","a");
	imprimir_seleccion(s4, fileA);
fclose (fileA); 


	lista_borrar(l4a, (tipo_funcion_borrar) borrar_seleccion);


//B)
fileA = fopen("salida.txt","a");
fprintf(fileA, "\n Test 4b: \n \n");
fclose (fileA); 
		char* nom4B1 = "Josefa";
		char* pais4B1 = "France";
		char num4B1 = '<';
		unsigned int alt4B1 = 63;
	jugador* j4B1 = crear_jugador(nom4B1, pais4B1, num4B1, alt4B1);
		char* nom4B2 = "Fede";
		char* pais4B2 = "Italy";
		char num4B2 = '0';
		unsigned int alt4B2 = 66;
	jugador* j4B2 = crear_jugador(nom4B2, pais4B2, num4B2, alt4B2); 
	lista* jugadores4B = lista_crear();
	insertar_ordenado(jugadores4B, j4B1, (tipo_funcion_cmp) menor_jugador);
	insertar_ordenado(jugadores4B, j4B2, (tipo_funcion_cmp) menor_jugador);

	seleccion* seleccion4B = crear_seleccion("Brasil", 4.0, jugadores4B);

fileA = fopen("salida.txt","a");
	imprimir_seleccion(seleccion4B, fileA);
fclose (fileA); 

	borrar_seleccion(seleccion4B);

//C)
fileA = fopen("salida.txt","a");
fprintf(fileA, "\n Test 4c: \n \n");
fclose (fileA); 	
		char* nom4C1 = "Josefa";
		char* pais4c1 = "France";
		char num4c1 = '<';
		unsigned int alt4c1 = 100;
	jugador* j4c1 = crear_jugador(nom4C1, pais4c1, num4c1, alt4c1);
		char* nom4c2 = "Fede";
		char* pais4c2 = "Italy";
		char num4c2 = '0';
		unsigned int alt4c2 = 50;
	jugador* j4c2 = crear_jugador(nom4c2, pais4c2, num4c2, alt4c2); 
	lista* jugadores4c = lista_crear();
	insertar_ordenado(jugadores4c, j4c1, (tipo_funcion_cmp) menor_jugador);
	insertar_ordenado(jugadores4c, j4c2, (tipo_funcion_cmp) menor_jugador);

	seleccion* seleccion4c = crear_seleccion("Belgica", 13.0, jugadores4c);

	lista* listita = lista_crear();
	insertar_ordenado(listita, seleccion4c, (tipo_funcion_cmp) menor_seleccion);

	lista_imprimir(listita, "salida.txt", (tipo_funcion_imprimir) imprimir_seleccion);
	lista_borrar(listita, (tipo_funcion_borrar) borrar_seleccion);

    return 0;
}

