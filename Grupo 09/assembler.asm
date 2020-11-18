.include macros2.asm
.include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
;variables de la tabla de simbolos

_0	db	0.0
_02.5	db	02.5
_1	db	1.0
_100	db	100.0
_2	db	2.0
_3	db	3.0
_4	db	4.0
_5	db	5.0
_6	db	6.0
_7	db	7.0
_85	db	85.0
_9	db	9.0
_@aux	dd	?
_@max1	dd	?
_@max2	dd	?
_Ingrese un entero a actual: 	db	"Ingrese un entero a actual: " , '$' , 30 dup  (?)
_La suma es: 	db	"La suma es: " , '$' , 14 dup  (?)
_Prueba.txt LyC Tema 3!	db	"Prueba.txt LyC Tema 3!" , '$' , 24 dup  (?)
_a	dd	?
_actual	dd	?
_actual es > 2 y != 0	db	"actual es > 2 y != 0" , '$' , 22 dup  (?)
_b	dd	?
_contador	dd	?
_no es mayor que 2	db	"no es mayor que 2" , '$' , 19 dup  (?)
_nombre	dd	?
_promedio	dd	?
_suma	dd	?




.CODE
;comienzo de la zona de codigo


start:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX


FLD 85
FSTP nombre
mov dx, OFFSET _Prueba.txt LyC Tema 3!
mov ah, 9
int 21h
newline 1
mov dx, OFFSET _Ingrese un entero a actual: 
mov ah, 9
int 21h
newline 1
getFloat actual
FLD 0
FSTP contador
FLD 02.5
FLD nombre
FSUB
FSTP _aux1
FLD 3
FLD _aux1
FADD
FSTP _aux2
FLD _aux2
FSTP suma
_Etiq21:
FLD 9
FLD contador
FCOM
FSTFSW AX
SAHF
JNA _Etiq25
FLD 1
FLD contador
FADD
FSTP _aux3
FLD _aux3
FSTP contador
JMP _Etiq21
_Etiq25:
mov dx, OFFSET _La suma es: 
mov ah, 9
int 21h
newline 1
mov dx, OFFSET suma
mov ah, 9
int 21h
newline 1
FLD 2
FLD actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq41
FLD 0
FLD actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq46
mov dx, OFFSET _actual es > 2 y != 0
mov ah, 9
int 21h
newline 1
FLD 2
FSTP suma
_Etiq46:
FLD 5
FSTP promedio
FLD nombre
FLD actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq59
mov dx, OFFSET _no es mayor que 2
mov ah, 9
int 21h
newline 1
_Etiq59:
FLD b
FLD a
FADD
FSTP _aux4
FLD _aux4
FSTP @max1
FLD 5
FSTP @aux
FLD @aux
FLD @max1
FCOM
FSTFSW AX
SAHF
JNA _Etiq74
FLD @aux
FSTP @max1
_Etiq74:
FLD 4
FSTP @max2
FLD 6
FSTP @aux
FLD @aux
FLD @max2
FCOM
FSTFSW AX
SAHF
JNA _Etiq88
FLD @aux
FSTP @max2
_Etiq88:
FLD @max2
FSTP @aux
FLD @aux
FLD @max1
FCOM
FSTFSW AX
SAHF
JNA _Etiq99
FLD @aux
FSTP @max1
_Etiq99:
FLD @max1
FSTP contador
FLD 2
FLD actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq110
FLD 5
FLD actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq115
mov dx, OFFSET _actual es > 2 y != 0
mov ah, 9
int 21h
newline 1
FLD 2
FLD 5
FMUL 
FSTP _aux5
FLD _aux5
FSTP suma
_Etiq115:
FLD 100
FLD 7
FDIV 
FSTP _aux6
FLD _aux6
FSTP promedio
MOV EAX, 4c00h  ; termina la ejecucion
INT 21h
END start;
;
