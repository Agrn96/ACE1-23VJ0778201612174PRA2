.MODEL SMALL
.RADIX 16
.STACK
;; PILA
.DATA
;;
tam_encabezado_html    db     0c
encabezado_html        db     "<html><body>"
tam_inicializacion_tabla   db   3e
inicializacion_tabla   db     '<table border="1"><tr><td>codigo</td><td>descripcion</td></tr>'
tam_cierre_tabla       db     8
cierre_tabla           db     "</table>"
tam_footer_html        db     0e
footer_html            db     "</body></html>"
td_html                db     "<td>"
tdc_html               db     "</td>"
tr_html                db     "<tr>"
trc_html               db     "</tr>"
;;
ceros          db     2  dup (0)
;; VARIABLES | MEMORIA RAM
numero           db   05 dup (30)
;;
usac       db    "Universidad de San Carlos de Guatemala",0a,"$"
facultad   db    "Facultad de Ingenieria",0a,"$"
curso      db    "Arquitectura de Computadoras y Ensambladores 1",0a,"$"
nombre     db    "Ronald Rodrigo Marin",0a,"$"
carne      db    "201902425",0a,"$"
productos  db    "(P)roductos",0a,"$"
ventas     db    "(V)entas",0a,"$"
herramientas db  "(H)erramientas",0a,"$"
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
;;; temps
cod_prod_temp    db    05 dup (0)
puntero_temp     dw    0000
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
;;
.CODE
.STARTUP
;; CODIGO
inicio:
		;;
		mov AX, 7e7
		call numAcadena
		mov BX, 01
		mov CX, 0005
		mov DX, offset numero
		mov AH, 40
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;; ENCABEZADO
		mov DX, offset usac
		mov AH, 09
		int 21
		mov DX, offset facultad
		mov AH, 09
		int 21
		mov DX, offset curso
		mov AH, 09
		int 21
		mov DX, offset nombre
		mov AH, 09
		int 21
		mov DX, offset carne
		mov AH, 09
		int 21
		;;
menu_principal:
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;; Menú
		mov DX, offset productos
		mov AH, 09
		int 21
		mov DX, offset ventas
		mov AH, 09
		int 21
		mov DX, offset herramientas
		mov AH, 09
		int 21
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		mov DX, offset prompt
		mov AH, 09
		int 21
		;; LEER 1 caracter
		mov AH, 08
		int 21
		;; AL = CARACTER LEIDO
		cmp AL, 70 ;; p minúscula ascii
		je menu_productos
		cmp AL, 76 ;; v minúscula ascii
		je menu_ventas 
		cmp AL, 68 ;; h minúscula ascii
		je generar_catalogo 
		jmp menu_principal
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
		je eliminar_producto_archivo
		cmp AL, 65 ;; editar
		cmp AL, 69 ;; insertar
		je ingresar_producto_archivo
		cmp AL, 6d ;; mostrar
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
copiar_codigo:	mov AL, [DI]
		mov [SI], AL
		inc SI
		inc DI
		loop copiar_codigo  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
		;;; la cadena ingresada en la estructura
		;;;
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
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
		mov [SI], AL
		inc SI
		inc DI
		loop copiar_nombre  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
		;;; la cadena ingresada en la estructura
		;;;
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
		mov AH, 3d
		mov DX, offset archivo_prods
		int 21
		;; si no lo cremos
		jc  crear_archivo_prod
		;; si abre escribimos
		jmp guardar_handle_prod
crear_archivo_prod:
		mov CX, 0000
		mov DX, offset archivo_prods
		mov AH, 3c
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
		jmp menu_productos
mostrar_productos_archivo:
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;
		mov AL, 02
		mov AH, 3d
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
		mov AH, 3f
		int 21
		;; puntero avanzó
		mov BX, [handle_prods]
		mov CX, 0004
		mov DX, offset num_price
		mov AH, 3f
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
eliminar_producto_archivo:
		mov DX, 0000
		mov [puntero_temp], DX
pedir_de_nuevo_codigo2:
		mov DX, offset prompt_code
		mov AH, 09
		int 21
		mov DX, offset buffer_entrada
		mov AH, 0a
		int 21
		;;
		mov DI, offset buffer_entrada
		inc DI
		mov AL, [DI]
		cmp AL, 00
		je  pedir_de_nuevo_codigo2
		cmp AL, 05
		jb  aceptar_tam_cod2  ;; jb --> jump if below
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		jmp pedir_de_nuevo_codigo2
		;;; mover al campo codigo en la estructura producto
aceptar_tam_cod2:
		mov SI, offset cod_prod_temp
		mov DI, offset buffer_entrada
		inc DI
		mov CH, 00
		mov CL, [DI]
		inc DI  ;; me posiciono en el contenido del buffer
copiar_codigo2:	mov AL, [DI]
		mov [SI], AL
		inc SI
		inc DI
		loop copiar_codigo2  ;; restarle 1 a CX, verificar que CX no sea 0, si no es 0 va a la etiqueta, 
		;;; la cadena ingresada en la estructura
		;;;
		mov DX, offset nueva_lin
		mov AH, 09
		int 21
		;;
		mov AL, 02              ;;;<<<<<  lectura/escritura
		mov DX, offset archivo_prods
		mov AH, 3d
		int 21
		mov [handle_prods], AX
		;;; TODO: revisar si existe
ciclo_encontrar:
		int 03
		mov BX, [handle_prods]
		mov CX, 26
		mov DX, offset cod_prod
		moV AH, 3f
		int 21
		mov BX, [handle_prods]
		mov CX, 4
		mov DX, offset num_price
		moV AH, 3f
		int 21
		cmp AX, 0000   ;; se acaba cuando el archivo se termina
		je finalizar_borrar
		mov DX, [puntero_temp]
		add DX, 2a
		mov [puntero_temp], DX
		;;; verificar si es producto válido
		mov AL, 00
		cmp [cod_prod], AL
		je ciclo_encontrar
		;;; verificar el código
		mov SI, offset cod_prod_temp
		mov DI, offset cod_prod
		mov CX, 0005
		call cadenas_iguales
		;;;; <<
		cmp DL, 0ff
		je borrar_encontrado
		jmp ciclo_encontrar
borrar_encontrado:
		mov DX, [puntero_temp]
		sub DX, 2a
		mov CX, 0000
		mov BX, [handle_prods]
		mov AL, 00
		mov AH, 42
		int 21
		;;; puntero posicionado
		mov CX, 2a
		mov DX, offset ceros
		mov AH, 40
		int 21
finalizar_borrar:
		mov BX, [handle_prods]
		mov AH, 3e
		int 21
		jmp menu_productos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
menu_ventas:
		mov DX, offset titulo_ventas
		mov AH, 09
		int 21
		mov DX, offset sub_vent
		mov AH, 09
		int 21
		jmp fin
menu_herramientas:
		mov DX, offset titulo_herras
		mov AH, 09
		int 21
		mov DX, offset sub_herr
		mov AH, 09
		int 21
		jmp fin
generar_catalogo:
		mov AH, 3c
		mov CX, 0000
		mov DX, offset nombre_rep1
		int 21
		mov [handle_reps], AX
		mov BX, AX
		mov AH, 40
		mov CH, 00
		mov CL, [tam_encabezado_html]
		mov DX, offset encabezado_html
		int 21
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, [tam_inicializacion_tabla]
		mov DX, offset inicializacion_tabla
		int 21
		;;
		mov AL, 02
		mov AH, 3d
		mov DX, offset archivo_prods
		int 21
		;;
		mov [handle_prods], AX
		;; leemos
ciclo_mostrar_rep1:
		;; puntero cierta posición
		mov BX, [handle_prods]
		mov CX, 26     ;; leer 26h bytes
		mov DX, offset cod_prod
		;;
		mov AH, 3f
		int 21
		;; puntero avanzó
		mov BX, [handle_prods]
		mov CX, 0004
		mov DX, offset num_price
		mov AH, 3f
		int 21
		;; ¿cuántos bytes leímos?
		;; si se leyeron 0 bytes entonces se terminó el archivo...
		cmp AX, 00
		je fin_mostrar
		;; ver si es producto válido
		mov AL, 00
		cmp [cod_prod], AL
		je ciclo_mostrar_rep1
		;; producto en estructura
		call imprimir_estructura_html
		jmp ciclo_mostrar_rep1
		;;
fin_mostrar_rep1:
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, [tam_cierre_tabla]
		mov DX, offset cierre_tabla
		int 21
		;;
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, [tam_footer_html]
		mov DX, offset footer_html
		int 21
		;;
		mov AH, 3e
		int 21
		jmp menu_principal
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

;;; ENTRADA:
;;    BX -> handle
imprimir_estructura_html:
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, 04
		mov DX, offset tr_html
		int 21
		;;
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, 04
		mov DX, offset td_html
		int 21
		;;
		mov DX, offset cod_prod
		mov SI, 0000
ciclo_escribir_codigo:
		mov DI, DX
		mov AL, [DI]
		cmp AL, 00
		je escribir_desc
		cmp SI, 0006
		je escribir_desc
		mov CX, 0001
		mov BX, [handle_reps]
		mov AH, 40
		int 21
		inc DX
		inc SI
		jmp ciclo_escribir_codigo
escribir_desc:
		;;
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, 05
		mov DX, offset tdc_html
		int 21
		;;
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, 04
		mov DX, offset td_html
		int 21
		;;
		mov DX, offset cod_name
		mov SI, 0000
ciclo_escribir_desc:
		mov DI, DX
		mov AL, [DI]
		cmp AL, 00
		je cerrar_tags
		cmp SI, 0026
		je cerrar_tags
		mov CX, 0001
		mov BX, [handle_reps]
		mov AH, 40
		int 21
		inc DX
		inc SI
		jmp ciclo_escribir_desc
		;;
cerrar_tags:
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, 05
		mov DX, offset tdc_html
		int 21
		;;
		mov BX, [handle_reps]
		mov AH, 40
		mov CH, 00
		mov CL, 05
		mov DX, offset trc_html
		int 21
		;;
		ret


;; cadenaAnum
;; ENTRADA:
;;    DI -> dirección a una cadena numérica
;; SALIDA:
;;    AX -> número convertido
;
;
;
;;[31][32][33][00][00]
;;     ^
;;     |
;;     ----- DI
;;;;
;;AX = 0
;;10 * AX + *1*  = 1
;;;;
;;AX = 1
;;10 * AX + 2  = 12
;;;;
;;AX = 12
;;10 * AX + 3  = 123
;;;;
cadenaAnum:
		mov AX, 0000    ; inicializar la salida
		mov CX, 0005    ; inicializar contador
		;;
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

;; numAcadena
;; ENTRADA:
;;     AX -> número a convertir    
;; SALIDA:
;;    [numero] -> numero convertido en cadena
;;AX = 1500
;;CX = AX  <<<<<<<<<<<
;;[31][30][30][30][30]
;;                  ^
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

;; memset
;; ENTRADA:
;;    DI -> dirección de la cadena
;;    CX -> tamaño de la cadena
memset:
ciclo_memset:
		mov AL, 00
		mov [DI], AL
		inc DI
		loop ciclo_memset
		ret

;; cadenas_iguales -
;; ENTRADA:
;;    SI -> dirección a cadena 1
;;    DI -> dirección a cadena 2
;;    CX -> tamaño máximo
;; SALIDA:
;;    DL -> 00 si no son iguales

;;         0ff si si lo son
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
fin:
.EXIT
END
