
global nodo_crear
global lista_crear
global lista_borrar
global lista_imprimir
global lista_imprimir_f
global crear_jugador
global menor_jugador
global normalizar_jugador
global pais_jugador
global borrar_jugador
global imprimir_jugador
global crear_seleccion
global menor_seleccion
global primer_jugador
global borrar_seleccion
global imprimir_seleccion
global insertar_ordenado
global mapear
global ordenar_lista_jugadores
global altura_promedio

;AUXILIARES

global string_copiar
global string_iguales
global string_comparar


extern filtrar_jugadores
extern insertar_ultimo
extern malloc
extern free
extern fopen
extern fclose
extern fprintf
extern toupper


; SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
%define NULL 0x00000000
%define TRUE 0x00000001
%define FALSE 0x00000000

%define NODO_SIZE      24
%define LISTA_SIZE     16 
%define JUGADOR_SIZE   21
%define SELECCION_SIZE 24

%define OFFSET_DATOS 0
%define OFFSET_SIG   8
%define OFFSET_ANT   16 

%define OFFSET_PRIMERO 0
%define OFFSET_ULTIMO  8 

%define OFFSET_NOMBRE_J 0
%define OFFSET_PAIS_J   8
%define OFFSET_NUMERO_J 16 
%define OFFSET_ALTURA_J 17

%define OFFSET_PAIS_S      0
%define OFFSET_ALTURA_S    8
%define OFFSET_JUGADORES_S 16


section .rodata

APPEND: db "a", 00
VACIA: db "<vacia>",10,00
PARAMETROS_PRINT_J: db "%s %s %d %d ",10,00
PARAMETROS_PRINT_S: db "%s %.2f ",10, 00
PIE: dq 0.030612245

section .data

section .text

; FUNCIONES OBLIGATORIAS. PUEDEN CREAR LAS FUNCIONES AUXILIARES QUE CREAN CONVENIENTES

nodo_crear:
	push rbp
	mov rbp, rsp
	push r12
	sub rsp, 8

	mov r12, rdi ;salvo el puntero a datos
	mov rdi, NODO_SIZE
	call malloc
	mov [rax + OFFSET_DATOS], r12
	mov qword [rax + OFFSET_SIG], 0
	mov qword [rax + OFFSET_ANT], 0

	add rsp, 8
	pop r12
	pop rbp
	ret
	

lista_crear:
	push rbp
	mov rbp, rsp

	mov rdi,LISTA_SIZE 
	call malloc
	mov qword [rax+OFFSET_PRIMERO], NULL
	mov qword [rax+OFFSET_ULTIMO], NULL

	pop rbp
	ret


lista_borrar:

	push RBP
	mov RBP, RSP
	sub rsp,8
	push r12
	push r13 
	push r14

	mov [rbp-8], rdi ; *lista 
	mov r14, rsi ; funcion 

	mov r12, rdi ; r12=*lista
	lea r12, [r12+OFFSET_PRIMERO]
	mov r12, [r12]
	cmp r12, NULL 
	JE .borrar_lista

	.ciclo_borrado: ;en r12 tengo al nodo actual 
	mov r13, [r12+OFFSET_SIG] ;en r13 tengo al nodo siguiente
	mov rdi, [r12+OFFSET_DATOS]
	call r14
	mov rdi, r12 
	call free
	mov r12, r13 ;ahora el actual es el siguiente
	cmp r12, NULL
	jne .ciclo_borrado

	.borrar_lista:
	mov rdi, [rbp-8]
	call free

	pop r14 
	pop r13 
	pop r12
	add rsp, 8
	pop rbp
	ret


lista_imprimir:

	push RBP
	mov RBP, RSP
	sub rsp, 24+8
	push r12 
	push r13

	xor r12, r12 
	mov [rbp-8], rdi ;*lista
	mov r12, rdi 
	xor r13, r13
	mov [rbp-16], rsi ;*nombre_archivo
	mov r13, rsi 
	xor r14, r14
	mov [rbp-24], rdx ;funcion
	mov r14, rdx

	mov rdi, rsi
	mov rsi, APPEND  
	call fopen
	cmp rax, NULL
	je .fin
	mov r13, rax

	mov rdi, r12
	mov rsi, rax
	mov rdx, r14
	call lista_imprimir_f

	mov rdi, r13
	call fclose

	.fin:
	pop r13
	pop r12 
	add rsp, 32
	pop rbp
	ret

lista_imprimir_f:
	
	push RBP
	mov RBP, RSP
	sub rsp, 24
	push r12 

	mov [rbp-8], rdi ;*lista 
	mov [rbp-16], rsi ;*FILE 
	mov [rbp-24], rdx ;funcion_imprimir

	mov r12, rdi ;tengo en r12 el *Lista 
	cmp r12, NULL
	JE .vacia_impr
	mov r12, [r12+OFFSET_PRIMERO] ;tengo al puntero del primero de la lista 
	cmp r12, NULL 
	JE .vacia_impr

	.ciclo_lista_imprimir:
	mov rdi, [r12+OFFSET_DATOS] ;en r12 esta el nodo actual
	mov rsi, [rbp-16] ;el puntero a file
	call [rbp-24]
	mov r12, [r12+OFFSET_SIG]
	cmp r12, NULL
	JNE .ciclo_lista_imprimir
	JMP .fin

	.vacia_impr:
	mov rdi, [rbp-16]
	mov rsi, VACIA
	mov rax,0
	call fprintf

	.fin:
	pop r12 
	add rsp, 24 
	pop rbp
	ret 


crear_jugador:

	push RBP
	mov RBP, RSP
	sub rsp, 32+8
	push r12

	mov [rbp-8], rdi ; *nombre 
	mov [rbp-16], rsi ; *pais 
	mov [rbp-24], rdx ; numero 
	mov [rbp-32], rcx ; altura 

	mov rdi, JUGADOR_SIZE
	call malloc
	mov r12, rax ; en r12 esta el puntero al nuevo jugador 

	mov rdi, [rbp-8]
	call string_copiar
	mov [r12+OFFSET_NOMBRE_J], rax
	mov rdi, [rbp-16]
	call string_copiar
	mov [r12+OFFSET_PAIS_J], rax 
	mov rdx, [rbp-24]
	mov [r12+OFFSET_NUMERO_J], dl
	mov rcx, [rbp-32]
	mov [r12+OFFSET_ALTURA_J], ecx 

	mov rax, r12 

	pop r12
	add rsp, 40
	pop rbp
	ret


menor_jugador:
	push RBP
	mov RBP, RSP
	sub rsp, 16

	mov [rbp-8], rdi
	mov [rbp-16], rsi

	mov rdi, [rdi+OFFSET_NOMBRE_J]
	mov rsi, [rsi+OFFSET_NOMBRE_J]
	call string_comparar ; devuelve neg si s1<s2 || 0 si s1=s2 || pos si s1>s2
	cmp eax, 0
	jl .es_true ;Jump short if below
	jg   .es_false ;Jump short if above

	mov rdi, [rbp-8]
	mov edi, [rdi+OFFSET_ALTURA_J]
	mov rsi, [rbp-16]
	mov esi, [rsi+OFFSET_ALTURA_J]
	cmp edi, esi 
	jle .es_true ;jump short if below or equal

	.es_false:
	mov rax, FALSE
	jmp .fin

	.es_true:
	mov rax, TRUE

	.fin:
	add rsp, 16
	pop rbp 
	ret


normalizar_jugador: 
	
	push rbp 
	mov rbp, rsp 
	sub rsp, 24
	push r12
	push r13 
	push r14 

   	mov r12, rdi ; *jugador

   	mov rdi, [r12+OFFSET_NOMBRE_J]
   	call string_copiar 
   	mov r13, rax ; el nuevo string que depsues tengo que borrar 
   	mov [rbp-8], r13 

   	.ciclo_mayusc:
	mov dil, [r13]
	call toupper
	mov [r13], al
	lea r13, [r13+1]
	cmp byte [r13], NULL
	jne .ciclo_mayusc

	xor r14, r14 
	mov r14d, [r12+OFFSET_ALTURA_J]
	pxor xmm0, xmm0
	pxor xmm1, xmm1 
	CVTSI2SD xmm0, R14d; convert signed int to double
	movsd xmm1, [PIE]
	mulsd xmm0, xmm1 
	CVTSD2SI r14d, xmm0 ; convert double to int 

	mov rdi, [rbp-8] 
	mov rsi, [r12+OFFSET_PAIS_J]
	mov dl, [r12+OFFSET_NUMERO_J]
	mov ecx, r14d 
	call crear_jugador
	mov r14, rax 

   	mov rdi, [rbp-8] 
  	call free ; libero el string creado para hacerlo MAYUSC 

   	mov rax, r14 

   	pop r14 
   	pop r13 
   	pop r12 
   	add rsp, 24 
   	pop rbp 
	ret 


pais_jugador:
	push rbp
	mov rbp, rsp

	mov rdi, [rdi+OFFSET_PAIS_J]
	mov rsi, [rsi+OFFSET_PAIS_J]
	call string_iguales

	pop rbp
	ret

borrar_jugador:
	push RBP
	mov RBP, RSP
	push r12 
	sub rsp, 8

	mov r12, rdi 
	mov rdi, [r12+OFFSET_NOMBRE_J]
	call free
	mov rdi, [r12+OFFSET_PAIS_J]
	call free 
	mov rdi, r12
	call free 

	add rsp, 8
	pop r12
	pop rbp 
	ret


imprimir_jugador:

	push RBP
	mov RBP, RSP
	push r13
	push r14 

	mov r13, rdi ; *jugador
	mov rdi, rsi ; *FILE

	mov rsi, PARAMETROS_PRINT_J
	mov rdx, [r13+OFFSET_NOMBRE_J]
	mov rcx, [r13+OFFSET_PAIS_J]
	xor r8, r8
	mov r8b,[r13+OFFSET_NUMERO_J] 
	xor r9, r9
	mov r9d,[r13+OFFSET_ALTURA_J]
	xor rax, rax
	mov rax,0
	call fprintf

	pop r14
	pop r13
	pop rbp
	ret 


crear_seleccion:
	
	push RBP
	mov RBP, RSP
	sub rsp, 32

	mov [rbp-8], rdi ; *pais 
	movq [rbp-16], xmm0 ; altura 
	mov [rbp-24], rsi ; *lista_jugadores 

	call string_copiar
	mov [rbp-32], rax ; *pais copia

	mov rdi, SELECCION_SIZE
	call malloc
	mov rdi, [rbp-32]
	mov [rax+OFFSET_PAIS_S], rdi
	movq xmm0, [rbp-16]
	movq [rax+OFFSET_ALTURA_S], xmm0
	mov rdi, [rbp-24]
	mov [rax+OFFSET_JUGADORES_S], rdi 

	add rsp, 32
	pop rbp 
	ret 


menor_seleccion:
	
	push rbp
	mov rbp, rsp 

	mov rdi, [rdi+OFFSET_PAIS_S]
	mov rsi, [rsi+OFFSET_PAIS_S]
	call string_comparar
	cmp eax, 0 ;si son iguales devuelvo true 
	jl .estrue
	mov rax, FALSE
	jmp .fin 

	.estrue:
	mov rax, TRUE
	.fin:
	pop rbp
	ret 

primer_jugador:
	
	push rbp 
	mov rbp, rsp 
	sub rsp, 8
	push r12
	;rdi tiene *seleccion 
	mov r12, [rdi+OFFSET_JUGADORES_S] ; r12 tiene *lista 
	mov r12, [r12+OFFSET_PRIMERO]	  ;r12 tiene *primer nodo
	mov r12, [r12+OFFSET_DATOS] 

	mov rdi, [r12+OFFSET_NOMBRE_J]
	mov rsi, [r12+OFFSET_PAIS_J]
	mov dl, [r12+OFFSET_NUMERO_J]
	mov ecx, [r12+OFFSET_ALTURA_J]
	call crear_jugador ;en rax esta el nuevo jugador 

	pop r12 
	add rsp, 8
	pop rbp 
	ret 


borrar_seleccion:
	
	push rbp
	mov rbp, rsp 
	sub rsp, 16

	mov [rbp-8], rdi ;*seleccion 

	mov rdi, [rdi+OFFSET_PAIS_S]
	call free

	mov rdi, [rbp-8]
	mov rdi, [rdi+OFFSET_JUGADORES_S]
	mov rsi, borrar_jugador
	call lista_borrar

	mov rdi, [rbp-8]
	call free

	add rsp, 16
	pop rbp 
	ret


imprimir_seleccion: 
	push rbp
	mov rbp, rsp 
	sub rsp, 16

	mov [rbp-8], rdi ; *seleccion
	mov [rbp-16], rsi ; *FILE

	mov rdx, [rdi+OFFSET_PAIS_S]
	movq xmm0, [rdi+OFFSET_ALTURA_S]
	mov rdi, rsi 
	mov rsi, PARAMETROS_PRINT_S
	mov rax,1
	call fprintf

	mov rdi, [rbp-8] 
	mov rdi, [rdi+OFFSET_JUGADORES_S]
	mov rsi, [rbp-16]
	mov rdx, imprimir_jugador
	call lista_imprimir_f

	add rsp, 16
	pop rbp 
	ret 

insertar_ordenado: 
	
	push RBP
	mov RBP, RSP
	sub rsp, 24+8
	push r12
	push r13 
	push r14 
	push r15

	mov [rbp-8], rdi ; *lista 
	mov [rbp-16], rsi ; *datos 
	mov [rbp-24], rdx ; funcion
	mov r13, rdi ;en r13 tengo el *lista 

	mov rdi, rsi
	call nodo_crear
	mov r12, rax ;tengo el puntero al nuevo nodo 

	cmp qword [r13+OFFSET_PRIMERO], NULL
	je .insertar_solo

;	mov rdi, r12
;	mov rdi, [rdi+OFFSET_DATOS]
;	mov rsi, [r13+OFFSET_PRIMERO] 
;	mov rsi, [rsi+OFFSET_DATOS]
;	call [rbp-24]
;	cmp rax, TRUE
;	je .insertar_primero

	;mov rdi, [r13+OFFSET_ULTIMO]
	;mov rdi, [rdi+OFFSET_DATOS]
	;mov rsi, r12
	;mov rsi, [rsi+OFFSET_DATOS]
 	;call [rbp-24]
	;cmp rax, TRUE
	;je .insertar_ultimo ;comparo con false
	
	mov r15, [r13+OFFSET_PRIMERO] ;en r15 esta el primer nodo 
	.ciclo_insertar:

	mov r14, r15  ; en r14 esta el nodo actual 
	mov r15, [r14+OFFSET_SIG] ;en r15 esta el nodo siguiente 
	cmp r15, NULL
	je .insertar_ultimo
	mov rdi, r12 
	mov rdi, [rdi+OFFSET_DATOS]
	mov rsi, r15
	mov rsi, [rsi+OFFSET_DATOS]
	xor rax, rax
	call [rbp-24]
	cmp rax, FALSE 
	je .ciclo_insertar

	mov [r14+OFFSET_SIG], r12 
	mov [r12+OFFSET_ANT], r14 
	mov [r12+OFFSET_SIG], r15
	mov [r15+OFFSET_ANT], r12 
	jmp .fin

	.insertar_primero:
	mov qword [r12+OFFSET_ANT], NULL ;en r12 esta el puntero al nuevo nodo 
	mov r14, [r13+OFFSET_PRIMERO] ;en r14 tengo el puntero al primero 
	mov [r14+OFFSET_ANT], r12 
	mov [r12+OFFSET_SIG], r14
	mov [r13+OFFSET_PRIMERO], r12
	jmp .fin

	.insertar_ultimo:
	mov rdi, r13
	mov rsi, r12
	call insertar_ultimo
	;mov qword [r12+OFFSET_SIG], NULL
	;mov r14, [r13+OFFSET_ULTIMO] ;en r14 tengo el puntero al ultimo
	;mov [r14+OFFSET_SIG], r12
	;mov [r12+OFFSET_ANT], r14
	;mov [r13+OFFSET_ULTIMO], r12
	jmp .fin

	.insertar_solo:
	mov qword [r12+OFFSET_ANT], NULL
	mov qword [r12+OFFSET_SIG], NULL
	mov [r13+OFFSET_PRIMERO], r12 
	mov [r13+OFFSET_ULTIMO], r12

	.fin: 
	pop r15 
	pop r14
	pop r13 
	pop r12 
	add rsp, 32
	pop rbp
	ret


altura_promedio:

	push rbp 
	mov rbp, rsp 
	push r13 
	push r14 

	cmp rdi, NULL ;en rdi tengo *lista 
	je .Return_Cero

	mov rdi, [rdi+OFFSET_PRIMERO] ;en rdi tengo el puntero al primer nodo
	cmp rdi, NULL 
	je .Return_Cero

	xor r13, r13 ;suma 
	xor r14, r14 ;contador 
	.ciclo:
	mov rax, [rdi+OFFSET_DATOS] 
	add r13d, [rax+OFFSET_ALTURA_J] 
	inc r14d 
	mov rdi, [rdi+OFFSET_SIG]
	cmp rdi, NULL
	jne .ciclo 

	xorpd xmm0, xmm0; suma
	xorpd xmm1, xmm1 ;contador

	CVTSI2SD xmm0, R13d; convert signed int to double
	CVTSI2SD xmm1, R14d
	divsd xmm0, xmm1
	jmp .fin 

	.Return_Cero:
	xorpd xmm0, xmm0

	.fin:
	pop r14 
	pop r13 
	pop rbp 
	ret 

ordenar_lista_jugadores:
	
	push rbp
	mov rbp, rsp 
	push r12 
	push r13 

	mov r12, rdi ;salvo el puntero a la lista vieja
	call lista_crear
	mov r13, rax ;salvo el puntero a la nueva lista 

	cmp dword [r12+OFFSET_PRIMERO], NULL
	je .fin 

	.ciclo: 
	mov rdi, r13
	mov rsi, [r12+OFFSET_DATOS]
	mov rdx, menor_jugador
	call insertar_ordenado
	mov r12, [r12+OFFSET_SIG]
	cmp r12, NULL 
	jne .ciclo

	.fin:
	mov rax, r13 
	pop r13
	pop r12 
	pop rbp 
	ret 


mapear:
	
	push rbp
	mov rbp, rsp 
	sub rsp, 16+8 
	push r12 

	mov r12, rdi ;*lista entrada
	mov [rbp-8], rsi ;*funcion 
	call lista_crear 
	mov [rbp-16], rax ;*lista nueva 
	cmp r12, NULL 
	je .final 

	mov r12, [r12+OFFSET_PRIMERO] ;en r12 tengo *prim nodo
	.ciclo: 
	mov rdi, [r12+OFFSET_DATOS] ;tengo los datos del nodo actual 
	call [rbp-8]
	mov rdi, rax 
	call nodo_crear	;crea un nuevo nodo con los datos mapeados 
	mov rdi, [rbp-16]
	mov rsi, rax 
	call insertar_ultimo ;inserta este nuevo nodo ultimo
	mov r12, [r12+OFFSET_SIG]
	cmp r12, NULL 
	jne .ciclo 

	.final:
	mov rax, [rbp-16]
	pop r12 
	add rsp, 24 
	pop rbp 
	ret 


; FUNCIONES AUXILIARES SUGERIDAS

string_copiar:

		push RBP
		mov RBP, RSP
		sub rsp, 8+8
		push r13
		push r12

		xor r13, r13 
		lea r13, [r13+1] ;esto suma al cero de fin de string, por eso arranca con 1
		mov [rbp-8], rdi ;*char a copiar
		mov r12, rdi 
		cmp rdi, 0
		je .fin
		cmp byte [rdi], 00
		JE .empezar_copia

		.ciclo_contar:

		lea rdi, [rdi+1] ;avanzo al siguiente char
		lea r13, [r13+1] ;sumo 1 al contador
		cmp byte [rdi],0
		JNE .ciclo_contar

		.empezar_copia:
		mov rdi, r13
		call malloc ; en rax esta la direccion del nuevo char
		mov rsi, r12
		mov r12, rax

		mov rcx, r13
		.ciclo_copiar:
		mov byte r13b, [rsi] 
		mov byte [rax], r13b
		add rax, 1
		add rsi, 1
		loop .ciclo_copiar
		mov rax, r12
		jmp .fin2

		.fin:
		mov rax, 0
		.fin2:	
		pop r12
		pop r13
		add rsp, 16
		pop rbp
		ret 


string_iguales:

		push RBP
		mov RBP, RSP
		;no muevo nada a rdi ni a  rsi porque ya estan cargados ahi
		call string_comparar
		cmp eax, 0x0000
		JE .iguales
		mov rax, FALSE
		jmp .fin 
		.iguales:
		mov rax, TRUE
		.fin:
		pop rbp
		ret

string_comparar: 

		push RBP
		mov RBP, RSP

		cmp rdi, 0
		jne .Sigo_comparando
		cmp rsi, 0
		jne .Ret_Neg
		jmp .Ret_Cero

		.Sigo_comparando:
		cmp rsi, 0
		je .Ret_Pos

		.ciclo:
		cmp Byte [rdi], 0
		jne .ciclo2
		cmp Byte [rsi], 0
		je .Ret_Cero
		jmp .Ret_Neg

		.ciclo2:
		cmp Byte [rsi], 0
		je .Ret_Pos
		mov cl, [rsi]
		cmp [rdi], cl 
		je .final_ciclo
		jae .Ret_Pos
		jmp .Ret_Neg

		.final_ciclo:
		lea rdi, [rdi+1]
		lea rsi, [rsi+1]
		jmp .ciclo 
		
		.Ret_Neg:
		xor rax, rax
		mov rax, 0xFFFFFFFF
		jmp .fin
		.Ret_Pos:
		xor rax, rax
		mov rax, 0x00000001
		jmp .fin 
		.Ret_Cero:
		xor rax, rax
		.fin: 
		pop rbp
		ret
