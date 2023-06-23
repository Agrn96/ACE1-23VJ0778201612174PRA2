print macro buffer ; Macro para imprimir una cadena de caracteres
PUSH AX 
PUSH DX 
    MOV AX, @DATA 
    MOV DS, AX 
    MOV AH, 9 
    MOV DX, OFFSET buffer 
    INT 21H 
POP DX 
POP AX 
ENDM ; Fin de la macro print

.MODEL SMALL
.STACK
.RADIX 16

.DATA
    ; Datos del encabezado
    encabezado1 db "Universidad de San Carlos de Guatemala", 0A
                db "Facultad de Ingenieria", 0A
                db "Escuela de Vacaciones", 0A, "$"
    encabezado2 db "Arquitectura de Computadoras y Ensambladores 1", 0A
                db "Nombre: Alberto Gabriel Reyes Ning", 0A
                db "Carne: 201612174", "$"
    ; Datos del menu principal
    menu1  db "1. Productos", 0A
           db "2. Ventas", 0A
           db "3. Herramientas", 0A
           db "4. Salir", 0A, "$"
    ;  Datos de los productos
    menu2  db "1. Ingreso de productos", 0A
           db "2. Eliminacion de productos", 0A
           db "3. Visualizacion de productos", 0A
           db "4. Regresar", 0A, "$"
    ;  Datos de las ventas
    menu3  db "1. Ingreso de ventas", 0A
           db "2. Eliminacion de ventas", 0A
           db "3. Visualizacion de ventas", 0A
           db "4. Regresar", 0A, "$"
    ;  Datos de las herramientas
    menu4  db "1. Generacion de catalogo completo", 0A
           db "2. Reporte alfabetico de productos", 0A
           db "3. Reporte de ventas", 0A
           db "4. Reporte de productos sin existencias", 0A
           db "5. Regresar", 0A, "$"
    ;  Datos de ingreso de productos
    menu5  db "1. Ingreso de productos", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de eliminacion de productos
    menu6  db "1. Eliminacion de productos", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de visualizacion de productos
    menu7  db "1. Visualizacion de productos", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de ingreso de ventas
    menu8  db "1. Ingreso de ventas", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de eliminacion de ventas
    menu9 db "1. Eliminacion de ventas", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de visualizacion de ventas
    menu10 db "1. Visualizacion de ventas", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de generacion de catalogo completo
    menu11 db "1. Generacion de catalogo completo", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de reporte alfabetico de productos
    menu12 db "1. Reporte alfabetico de productos", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de reporte de ventas
    menu13 db "1. Reporte de ventas", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de reporte de productos sin existencias
    menu14 db "1. Reporte de productos sin existencias", 0A
           db "2. Regresar", 0A, "$"
    ;  Datos de error
    error db 0a, "Opcion no valida", 0A, "$"
    ;  Datos adicionales
    test1 db "test1", 0A, "$"
    linea db 0A, "--------------------------------------------------", 0A, "$"

    ;; "ESTRUCTURA PRODUCTO"
cod_prod    db    05 dup (0)
cod_name    db    21 dup (0)
cod_price   db    05 dup (0)
cod_units   db    05 dup (0)
;; numéricos
num_price   dw    0000
num_units   dw    0000
;; archivo productos
archivo_prods    db   "PROD.BIN",00
handle_prods     dw   0000
;;
nombre_rep1      db   "CATALG.HTM",00
handle_reps      dw   0000

;;; temps
cod_prod_temp    db    05 dup (0)
puntero_temp     dw    0000


titulo_producto db  "PRODUCTOS",0a,"$"
sub_prod        db  "=========",0a,"$"
titulo_ventas   db  "VENTAS",0a,"$"
sub_vent        db  "======",0a,"$"
titulo_herras   db  "HERRAMIENTAS",0a,"$"
sub_herr        db  "============",0a,"$"
prompt     db    "Elija una opcion:",0a,"$"
prompt_code      db    "Codigo: ","$"
prompt_name      db    "Nombre: ","$"
prompt_price     db    "Precio: ","$"
prompt_units     db    "Unidades: ","$"
temp       db    00,"$"
nueva_lin  db    0a,"$"
numeroA    db    0ff
numeroB    db    50
numeros    db    20, 12, 24
buffer_entrada   db  20, 00
                 db  20 dup (0)
mostrar_prod     db  "(M)ostrar productos",0a,"$"
ingresar_prod    db  "(I)ngresar producto",0a,"$"
editar_prod      db  "(E)ditar producto",0a,"$"
borrar_prod      db  "(B)orrar producto",0a,"$"
prods_registrados db "Productos registrados:",0a,"$"

ceros          db     2  dup (0)
numero           db   05 dup (30)
; Menu completo, siguiente procedimiento seria implementar el seccion de productos
; Implementacion faltante: Productos, Ventas, Herramientas y Acceso

.CODE

menu_productos:
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		mov DX, offset mostrar_prod
		mov AH, 09
		int 21
		mov DX, offset ingresar_prod
		mov AH, 09
		int 21
		mov DX, offset editar_prod
		mov AH, 09
		int 21
		mov DX, offset borrar_prod
		mov AH, 09
		int 21
		mov AH, 08
		int 21
		;;
		mov DX, offset prompt
		mov AH, 09
		int 21
		;; AL = CARACTER LEIDO
		cmp AL, 62 ;; borrar
        je ingresar_producto_archivo
		;je eliminar_producto_archivo
		cmp AL, 69 ;; insertar
		je ingresar_producto_archivo
		cmp AL, 34 ;; mostrar
		je mostrar_productos_archivo
		jmp menu_productos
		;;
ingresar_producto_archivo:
		mov DX, offset titulo_producto
		mov AH, 09
		int 21
		mov DX, offset sub_prod
		mov AH, 09
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;; PEDIR CODIGO
pedir_de_nuevo_codigo:
		mov DX, offset prompt_code
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;; verificar que el tamaño del codigo no sea mayor a 5
		mov DI, offset buffer_entrada
		inc DI
		mov AL, [DI]
		cmp AL, 00
		je  pedir_de_nuevo_codigo
		cmp AL, 05
		jb  aceptar_tam_cod  ;; jb --> jump if below
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		jmp pedir_de_nuevo_codigo
		;;; mover al campo codigo en la estructura producto
aceptar_tam_cod:
		mov SI, offset cod_prod
		mov DI, offset buffer_entrada
		inc DI
		mov CH, 00
		mov CL, [DI]
		inc DI  ;; me posiciono en el contenido del buffer
copiar_codigo:
    mov AL, [DI]
    cmp AL, 0D ; Check if the carriage return character is encountered
    je  fin_copiar_codigo ; If found, finish copying the code
    mov [SI], AL
    inc SI
    inc DI
    loop copiar_codigo

fin_copiar_codigo:
    mov byte ptr [SI], 0 ; Add null terminator to the code

    mov DX, offset nueva_lin
    mov AH, 09
    int 21

	; Clear the input buffer
    mov DI, offset buffer_entrada
    mov CX, 10 ; Set the number of characters to clear (adjust as needed)
    xor AL, AL ; Clear value
    rep stosb ; Repeat clearing the buffer
		;;; PEDIR NOMBRE
pedir_de_nuevo_nombre:
		mov DX, offset prompt_name
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;; verificar que el tamaño del codigo no sea mayor a 5
		mov DI, offset buffer_entrada
		inc DI
		mov AL, [DI]
		cmp AL, 00
		je  pedir_de_nuevo_nombre
		cmp AL, 20
		jb  aceptar_tam_nom
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		jmp pedir_de_nuevo_nombre
		;;; mover al campo codigo en la estructura producto
aceptar_tam_nom:
		mov SI, offset cod_name
		mov DI, offset buffer_entrada
		inc DI
		mov CH, 00
		mov CL, [DI]
		inc DI  ;; me posiciono en el contenido del buffer
copiar_nombre:	mov AL, [DI]
		mov AL, [DI]
		cmp AL, 0D ; Check if the carriage return character is encountered
		je  fin_copiar_nombre ; If found, finish copying the code
		mov [SI], AL
		inc SI
		inc DI
		loop copiar_nombre

fin_copiar_nombre:
		mov byte ptr [SI], 0 ; Add null terminator to the code

		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;
pedir_de_nuevo_precio:
		mov DX, offset prompt_price
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;; verificar que el tamaño del codigo no sea mayor a 5
		mov DI, offset buffer_entrada
		inc DI
		mov AL, [DI]
		cmp AL, 00
		je  pedir_de_nuevo_precio
		cmp AL, 06  ;; tamaño máximo del campo
		jb  aceptar_tam_precio ;; jb --> jump if below
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		jmp pedir_de_nuevo_precio
		;;; mover al campo codigo en la estructura producto
aceptar_tam_precio:
		mov SI, offset cod_price
		mov DI, offset buffer_entrada
		inc DI
		mov CH, 00
		mov CL, [DI]
		inc DI  ;; me posiciono en el contenido del buffer
copiar_precio:	mov AL, [DI]
		mov AL, [DI]
		cmp AL, 0D ; Check if the carriage return character is encountered
		je  fin_copiar_precio ; If found, finish copying the code
		mov [SI], AL
		inc SI
    	inc DI
		loop copiar_precio  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
		;;
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;
		mov DI, offset cod_price
		call cadenaAnum
		;; AX -> numero convertido
		mov [num_price], AX
		;;
		mov DI, offset cod_price
		mov CX, 0005
		call memset
		;;

fin_copiar_precio:
    mov byte ptr [SI], 0 ; Add null terminator to the code

    mov DX, offset nueva_lin
    mov AH, 09
    int 21

pedir_de_nuevo_unidades:
		mov DX, offset prompt_units
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;; verificar que el tamaño del codigo no sea mayor a 5
		mov DI, offset buffer_entrada
		inc DI
		mov AL, [DI]
		cmp AL, 00
		je  pedir_de_nuevo_unidades
		cmp AL, 06  ;; tamaño máximo del campo
		jb  aceptar_tam_unidades ;; jb --> jump if below
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		jmp pedir_de_nuevo_unidades
		;;; mover al campo codigo en la estructura producto
aceptar_tam_unidades:
		mov SI, offset cod_units
		mov DI, offset buffer_entrada
		inc DI
		mov CH, 00
		mov CL, [DI]
		inc DI  ;; me posiciono en el contenido del buffer
copiar_unidades:
		mov AL, [DI]
		cmp AL, 0D ; Check if the carriage return character is encountered
		je  fin_copiar_unidades ; If found, finish copying the code
		mov [SI], AL
		inc SI
		inc DI
		loop copiar_unidades  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
		;;
		mov DI, offset cod_units
		call cadenaAnum
		;; AX -> numero convertido
		mov [num_units], AX
		;;
		mov DI, offset cod_units
		mov CX, 0005
		call memset
		;; finalizó pedir datos de producto
		;;
		;;
		;;
		;;
		;; GUARDAR EN ARCHIVO
		;; probar abrirlo normal
		mov AL, 02
		mov AH, 3dh
		mov DX, offset archivo_prods
		int 21
		;; si no lo cremos
		jc  crear_archivo_prod
		;; si abre escribimos
		jmp guardar_handle_prod

fin_copiar_unidades:
		mov byte ptr [SI], 0 ; Add null terminator to the code

		mov DX, offset nueva_lin
		mov AH, 09
		int 21




crear_archivo_prod:
		mov CX, 0000
		mov DX, offset archivo_prods
		mov AH, 3ch
		int 21
		;; archivo abierto
guardar_handle_prod:
		;; guardamos handle
		mov [handle_prods], AX
		;; obtener handle
		mov BX, [handle_prods]
		;; vamos al final del archivo
		mov CX, 00
		mov DX, 00
		mov AL, 02
		mov AH, 42
		int 21
		;; escribir el producto en el archivo
		;; escribí los dos primeros campos
		mov CX, 26
		mov DX, offset cod_prod
		mov AH, 40
		int 21
		;; escribo los otros dos
		mov CX, 0004
		mov DX, offset num_price
		mov AH, 40
		int 21
		;; cerrar archivo
		mov AH, 3e
		int 21
		;;
		mov DI, offset cod_name
		mov CX, 0005
		call memset

		mov DI, offset cod_prod
		mov CX, 0005
		call memset
		jmp menu_productos

mostrar_productos_archivo: ; mostrar codigo y nombre, no precio ni unidades
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;
		mov AL, 02
		mov AH, 3dh
		mov DX, offset archivo_prods
		int 21
		;;
		mov [handle_prods], AX
		;; leemos
ciclo_mostrar:
		;; puntero cierta posición
		mov BX, [handle_prods]
		mov CX, 0026     ;; leer 26h bytes
		mov DX, offset cod_prod
		;;
		mov AH, 3fh
		int 21
		;; puntero avanzó
		mov BX, [handle_prods]
		mov CX, 0004
		mov DX, offset num_price
		mov AH, 3fh
		int 21
		;; ¿cuántos bytes leímos?
		;; si se leyeron 0 bytes entonces se terminó el archivo...
		cmp AX, 0000
		je fin_mostrar
		;; ver si es producto válido
		mov AL, 00
		cmp [cod_prod], AL
		je ciclo_mostrar
		;; producto en estructura
		call imprimir_estructura
		jmp ciclo_mostrar
		;;
fin_mostrar:
		jmp menu_productos


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; imprimir_estructura - ...
;; ENTRADAS:
;; SALIDAS:
;;     o Impresión de estructura
imprimir_estructura:
		mov DI, offset cod_name
ciclo_poner_dolar_1:
		mov AL, [DI]
		cmp AL, 00
		je poner_dolar_1
		inc DI
		jmp ciclo_poner_dolar_1
poner_dolar_1:
		mov AL, 24  ;; dólar
		mov [DI], AL
		;; imprimir normal
		mov DX, offset cod_name
		mov AH, 09
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		mov AX, [num_price]
		call numAcadena
		;; [numero] tengo la cadena convertida
		mov BX, 0001
		mov CX, 0005
		mov DX, offset numero
		mov AH, 40
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		ret

cadenaAnum:
		mov AX, 0000    ; inicializar la salida
		mov CX, 0005    ; inicializar contador

seguir_convirtiendo:
		mov BL, [DI]
		cmp BL, 00
		je retorno_cadenaAnum
		sub BL, 30      ; BL es el valor numérico del caracter
		mov DX, 000a
		mul DX          ; AX * DX -> DX:AX
		mov BH, 00
		add AX, BX 
		inc DI          ; puntero en la cadena
		loop seguir_convirtiendo
retorno_cadenaAnum:
		ret

numAcadena:
		mov CX, 0005
		mov DI, offset numero
ciclo_poner30s:
		mov BL, 30
		mov [DI], BL
		inc DI
		loop ciclo_poner30s
		;; tenemos '0' en toda la cadena
		mov CX, AX    ; inicializar contador
		mov DI, offset numero
		add DI, 0004
		;;
ciclo_convertirAcadena:
		mov BL, [DI]
		inc BL
		mov [DI], BL
		cmp BL, 3a
		je aumentar_siguiente_digito_primera_vez
		loop ciclo_convertirAcadena
		jmp retorno_convertirAcadena
aumentar_siguiente_digito_primera_vez:
		push DI
aumentar_siguiente_digito:
		mov BL, 30     ; poner en '0' el actual
		mov [DI], BL
		dec DI         ; puntero a la cadena
		mov BL, [DI]
		inc BL
		mov [DI], BL
		cmp BL, 3a
		je aumentar_siguiente_digito
		pop DI         ; se recupera DI
		loop ciclo_convertirAcadena
retorno_convertirAcadena:
		ret
memset:
ciclo_memset:
		mov AL, 00
		mov [DI], AL
		inc DI
		loop ciclo_memset
		ret

cadenas_iguales:
ciclo_cadenas_iguales:
		mov AL, [SI]
		cmp [DI], AL
		jne no_son_iguales
		inc DI
		inc SI
		loop ciclo_cadenas_iguales
		;;;;; <<<
		mov DL, 0ff
		ret
no_son_iguales:	mov DL, 00
		ret
    ; Mostrar el encabezado
    .STARTUP
    INICIO PROC
        ; Imprimir el encabezado
        print linea
        print encabezado1
        print encabezado2
        print linea
        ; Mostrar el menu principal
        print menu1
        ; Leer la opcion seleccionada
        MOV AH, 1
        INT 21h
        ; Saltar a la opcion seleccionada
        CMP AL, 31
        JE PRODUCTOS
        CMP AL, 32
        JE VENTAS
        CMP AL, 33
        JE HERRAMIENTAS
        CMP AL, 34
        JE SALIR
        ; Si no se selecciona una opcion valida, mostrar un mensaje de error
        print error
        JMP INICIO

    ;Acceso

    ;Productos

    ;Ingreso de productos

    ;Eliminacion de productos

    ;Visualizacion de productos

    ;Ventas

    ;Herramientas

    ;Generacion de catalogo completo

    ;Reporte alfabetico de productos

    ;Reporte de ventas

    ;Reporte de productos sin existencias

    


        ; Continuar con el resto del programa...
        
        ; Aquí puedes agregar el código principal del programa de punto de venta

        ; Terminar el programa
        MOV AH, 4Ch
        INT 21h
    INICIO ENDP

    PRODUCTOS PROC
        print linea
        print menu2
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE INGRESO_PRODUCTOS
        CMP AL, 32
        JE mostrar_productos_archivo
        CMP AL, 33
        JE VISUALIZACION_PRODUCTOS
        CMP AL, 34
        JE INICIO
        print error
        JMP PRODUCTOS
    PRODUCTOS ENDP

    VENTAS PROC
        print linea
        print menu3
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE INGRESO_VENTAS
        CMP AL, 32
        JE ELIMINACION_VENTAS
        CMP AL, 33
        JE VISUALIZACION_VENTAS
        CMP AL, 34
        JE INICIO
        print error
        JMP VENTAS
    VENTAS ENDP

    HERRAMIENTAS PROC
        print linea
        print menu4
        MOV AH, 1
        INT 21h
        CMP AL, 31 
        JE GENERACION_CATALOGO
        CMP AL, 32
        JE REPORTE_ALFABETICO
        CMP AL, 33
        JE REPORTE_VENTAS
        CMP AL, 34
        JE REPORTE_PRODUCTOS
        CMP AL, 35
        JE INICIO
        print error
        JMP HERRAMIENTAS
    HERRAMIENTAS ENDP

    INGRESO_PRODUCTOS PROC
        print linea
        print menu5
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE ingresar_producto_archivo ; change this, it will call a function that will run and then it will jump back to INGRESO_PRODUCTOS
        CMP AL, 32
        JE PRODUCTOS
        print error
        JMP INGRESO_PRODUCTOS
    INGRESO_PRODUCTOS ENDP

    ELIMINACION_PRODUCTOS PROC
        print linea
        print menu6
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE ELIMINACION_PRODUCTOS
        CMP AL, 32
        JE PRODUCTOS
        print error
        JMP ELIMINACION_PRODUCTOS
    ELIMINACION_PRODUCTOS ENDP

    VISUALIZACION_PRODUCTOS PROC
        print linea
        print menu7
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE VISUALIZACION_PRODUCTOS
        CMP AL, 32
        JE PRODUCTOS
        print error
        JMP VISUALIZACION_PRODUCTOS
    VISUALIZACION_PRODUCTOS ENDP

    INGRESO_VENTAS PROC
        print linea
        print menu8
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE INGRESO_VENTAS
        CMP AL, 32
        JE VENTAS
        print error
        JMP INGRESO_VENTAS
    INGRESO_VENTAS ENDP

    ELIMINACION_VENTAS PROC
        print linea
        print menu9
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE ELIMINACION_VENTAS
        CMP AL, 32
        JE VENTAS
        print error
        JMP ELIMINACION_VENTAS
    ELIMINACION_VENTAS ENDP

    VISUALIZACION_VENTAS PROC
        print linea
        print menu10
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE VISUALIZACION_VENTAS
        CMP AL, 32
        JE VENTAS
        print error
        JMP VISUALIZACION_VENTAS
    VISUALIZACION_VENTAS ENDP

    GENERACION_CATALOGO PROC
        print linea
        print menu11
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE GENERACION_CATALOGO
        CMP AL, 32
        JE HERRAMIENTAS
        print error
        JMP GENERACION_CATALOGO
    GENERACION_CATALOGO ENDP

    REPORTE_ALFABETICO PROC
        print linea
        print menu12
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE REPORTE_ALFABETICO
        CMP AL, 32
        JE HERRAMIENTAS
        print error
        JMP REPORTE_ALFABETICO
    REPORTE_ALFABETICO ENDP

    REPORTE_VENTAS PROC
        print linea
        print menu13
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE REPORTE_VENTAS
        CMP AL, 32
        JE HERRAMIENTAS
        print error
        JMP REPORTE_VENTAS
    REPORTE_VENTAS ENDP

    REPORTE_PRODUCTOS PROC
        print linea
        print menu14
        MOV AH, 1
        INT 21h
        CMP AL, 31
        JE REPORTE_PRODUCTOS
        CMP AL, 32
        JE HERRAMIENTAS
        print error
        JMP REPORTE_PRODUCTOS
    REPORTE_PRODUCTOS ENDP

    SALIR PROC
        .EXIT
    SALIR ENDP
END
