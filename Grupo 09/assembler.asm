include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
;variables de la tabla de simbolos

_10_esddfloat	dd	10.0	;esddfloat
_1_esddfloat	dd	1.0	;esddfloat
_2_esddfloat	dd	2.0	;esddfloat
_3_esddfloat	dd	3.0	;esddfloat
_4_esddfloat	dd	4.0	;esddfloat
_85_esddfloat	dd	85.0	;esddfloat
_8_esddfloat	dd	8.0	;esddfloat
_actual_esddfloat	dd	?	;esddfloat
_actualtiene	db	"actual tiene: " , '$' , 16 dup  (?)
_aux_esddfloat	dd	?	;esddfloat
_chau	db	"chau" , '$' , 6 dup  (?)
_contador_esddfloat	dd	?	;esddfloat
_entrealwhile	db	"entre al while" , '$' , 16 dup  (?)
_hola	db	"hola" , '$' , 6 dup  (?)
_ingreseunenteroaactual	db	"ingrese un entero a actual: " , '$' , 30 dup  (?)
_nombre_esddfloat	dd	?	;esddfloat
_promedio_esddfloat	dd	?	;esddfloat
_prueba_txtlyctema3	db	"prueba.txt lyc tema 3!" , '$' , 24 dup  (?)
_suma_esddfloat	dd	?	;esddfloat
_sumaesdistintode4	db	"suma es distinto de  4" , '$' , 24 dup  (?)
_sumaesiguala4	db	"suma es igual a 4" , '$' , 19 dup  (?)
_sumaesiguala8ya4	db	"suma es igual a 8 y <> a 4" , '$' , 28 dup  (?)
_sumaesmayora4	db	"suma es mayor a 4" , '$' , 19 dup  (?)
_sumaesmayoriguala4	db	"suma es mayor igual a 4" , '$' , 25 dup  (?)
_sumaesmenora4	db	"suma es menor a 4" , '$' , 19 dup  (?)
_sumaesmenoriguala4	db	"suma es menor igual a 4" , '$' , 25 dup  (?)
_sumatiene	db	"suma tiene: " , '$' , 14 dup  (?)
_0_esddfloat	dd	0.0	;esddfloat
_@max1	dd	?	;esddfloat
_@max2	dd	?	;esddfloat
_@max3	dd	?	;esddfloat
_@max4	dd	?	;esddfloat
_@max5	dd	?	;esddfloat
_@max6	dd	?	;esddfloat
_@max7	dd	?	;esddfloat
_@max8	dd	?	;esddfloat
_@max9	dd	?	;esddfloat
_@max10	dd	?	;esddfloat
_varaux	dd	?	;esddfloat




.CODE
;comienzo de la zona de codigo


start:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX


FLD _85_esddfloat
FSTP _nombre_esddfloat
displayString _prueba_txtlyctema3 
newline 1
displayString _ingreseunenteroaactual 
newline 1
getFloat _actual_esddfloat
displayString _actualtiene 
newline 1
DisplayFloat _actual_esddfloat , 2
newline 1
FLD _10_esddfloat
FSTP _suma_esddfloat
FLD _2_esddfloat
FSTP _contador_esddfloat
_Etiq21:
FLD _3_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNA  _Etiq46
FLD _contador_esddfloat
FLD _4_esddfloat
FCOM
FSTSW AX
SAHF
JB  _Etiq46
displayString _entrealwhile 
newline 1
FLD _suma_esddfloat
FLD _1_esddfloat
FSUB
FSTP _varaux
FLD _varaux
FSTP _suma_esddfloat
FLD _1_esddfloat
FLD _contador_esddfloat
FADD
FSTP _varaux
FLD _varaux
FSTP _contador_esddfloat
JMP _Etiq21
_Etiq46:
displayString _sumatiene 
newline 1
DisplayFloat _suma_esddfloat , 2
newline 1
FLD _10_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JAE  _Etiq63
FLD _suma_esddfloat
FLD _8_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JA  _Etiq63
displayString _hola 
newline 1
_Etiq63:
FLD _8_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JE  _Etiq74
FLD _suma_esddfloat
FLD _4_esddfloat
FCOM
FSTSW AX
SAHF
JE  _Etiq76
_Etiq74:
displayString _chau 
newline 1
_Etiq76:
FLD _8_esddfloat
FSTP _suma_esddfloat
FLD _8_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNE  _Etiq92
FLD _suma_esddfloat
FLD _4_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JE  _Etiq92
displayString _sumaesiguala8ya4 
newline 1
_Etiq92:
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JE  _Etiq99
displayString _sumaesdistintode4 
newline 1
_Etiq99:
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNA  _Etiq106
displayString _sumaesmayora4 
newline 1
_Etiq106:
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JB  _Etiq113
displayString _sumaesmayoriguala4 
newline 1
_Etiq113:
FLD _4_esddfloat
FSTP _suma_esddfloat
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNE  _Etiq123
displayString _sumaesiguala4 
newline 1
_Etiq123:
FLD _2_esddfloat
FSTP _suma_esddfloat
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JAE  _Etiq133
displayString _sumaesmenora4 
newline 1
_Etiq133:
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JA  _Etiq140
displayString _sumaesmenoriguala4 
newline 1
_Etiq140:
MOV EAX, 4c00h  ; termina la ejecucion
INT 21h
END start;
;
