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

; Menu completo, siguiente procedimiento seria implementar el seccion de productos
; Implementacion faltante: Productos, Ventas, Herramientas y Acceso

.CODE
    ; Mostrar el encabezado
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
        JE ELIMINACION_PRODUCTOS
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
        JE INGRESO_PRODUCTOS ; change this, it will call a function that will run and then it will jump back to INGRESO_PRODUCTOS
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
