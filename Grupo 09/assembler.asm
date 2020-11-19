.include macros2.asm
.include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
;variables de la tabla de simbolos

_0	dd	0.0
_02_5	dd	02.5
_1	dd	1.0
_100	dd	100.0
_2	dd	2.0
_3	dd	3.0
_4	dd	4.0
_5	dd	5.0
_6	dd	6.0
_7	dd	7.0
_85	dd	85.0
_9	dd	9.0
_@aux	dd	?
_@max1	dd	?
_@max2	dd	?
_Ingreseunenteroaactual	db	"Ingrese un entero a actual: " , '$' , 30 dup  (?)
_Lasumaes	db	"La suma es: " , '$' , 14 dup  (?)
_Prueba_txtLyCTema3	db	"Prueba.txt LyC Tema 3!" , '$' , 24 dup  (?)
_a	dd	?
_actual	dd	?
_actuales2y_0	db	"actual es > 2 y != 0" , '$' , 22 dup  (?)
_b	dd	?
_contador	dd	?
_noesmayorque2	db	"no es mayor que 2" , '$' , 19 dup  (?)
_nombre	dd	?
_promedio	dd	?
_suma	dd	?
_varaux	dd	?




.CODE
;comienzo de la zona de codigo


start:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX


FLD _85
FSTP _nombre
mov dx, OFFSET _Prueba_txtLyCTema3
mov ah, 9
int 21h
newline 1
mov dx, OFFSET _Ingreseunenteroaactual
mov ah, 9
int 21h
newline 1
getFloat _actual
FLD _0
FSTP _contador
FLD _02_5
FLD _nombre
FSUB
FSTP _varaux
FLD _3
FLD _varaux
FADD
FSTP _varaux
FLD _varaux
FSTP _suma
_Etiq21:
FLD _9
FLD _contador
FCOM
FSTFSW AX
SAHF
JNA _Etiq25
FLD _1
FLD _contador
FADD
FSTP _varaux
FLD _varaux
FSTP _contador
JMP _Etiq21
_Etiq25:
mov dx, OFFSET _Lasumaes
mov ah, 9
int 21h
newline 1
mov dx, OFFSET _suma
mov ah, 9
int 21h
newline 1
FLD _2
FLD _actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq41
FLD _0
FLD _actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq46
mov dx, OFFSET _actuales2y_0
mov ah, 9
int 21h
newline 1
FLD _2
FSTP _suma
_Etiq46:
FLD _5
FSTP _promedio
FLD _nombre
FLD _actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq59
mov dx, OFFSET _noesmayorque2
mov ah, 9
int 21h
newline 1
_Etiq59:
FLD _b
FLD _a
FADD
FSTP _varaux
FLD _varaux
FSTP @max1
FLD _5
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
FLD _4
FSTP @max2
FLD _6
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
FSTP _contador
FLD _2
FLD _actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq110
FLD _5
FLD _actual
FCOM
FSTFSW AX
SAHF
JNA _Etiq115
mov dx, OFFSET _actuales2y_0
mov ah, 9
int 21h
newline 1
FLD _2
FLD _5
FMUL 
FSTP _varaux
FLD _varaux
FSTP _suma
_Etiq115:
FLD _100
FLD _7
FDIV 
FSTP _varaux
FLD _varaux
FSTP _promedio
MOV EAX, 4c00h  ; termina la ejecucion
INT 21h
END start;
;
