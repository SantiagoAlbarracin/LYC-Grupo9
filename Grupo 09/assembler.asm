include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
;variables de la tabla de simbolos

_02_5_esddfloat	dd	02.5	;esddfloat
_1_esddfloat	dd	1.0	;esddfloat
_20_esddfloat	dd	20.0	;esddfloat
_2_esddfloat	dd	2.0	;esddfloat
_3_esddfloat	dd	3.0	;esddfloat
_4_esddfloat	dd	4.0	;esddfloat
_5_esddfloat	dd	5.0	;esddfloat
_6_esddfloat	dd	6.0	;esddfloat
_85_esddfloat	dd	85.0	;esddfloat
_@aux	dd	?	;esddfloat
__@max1	dd	?	;esddfloat
__@max2	dd	?	;esddfloat
_actual_esddfloat	dd	?	;esddfloat
_actualtiene	db	"actual tiene: " , '$' , 16 dup  (?)
_ahoraactualtiene	db	"ahora actual tiene:" , '$' , 21 dup  (?)
_aux_esddfloat	dd	?	;esddfloat
_contador_esddfloat	dd	?	;esddfloat
_contadortiene	db	"contador tiene: " , '$' , 18 dup  (?)
_entrealwhile	db	"entre al while" , '$' , 16 dup  (?)
_ingreseunenteroaactual	db	"ingrese un entero a actual: " , '$' , 30 dup  (?)
_nombre_esddfloat	dd	?	;esddfloat
_nombretiene	db	"nombre tiene: " , '$' , 16 dup  (?)
_promedio_esddfloat	dd	?	;esddfloat
_prueba_txtlyctema3	db	"prueba.txt lyc tema 3!" , '$' , 24 dup  (?)
_suma_esddfloat	dd	?	;esddfloat
_sumaesmenora2	db	"suma es menor a 2" , '$' , 19 dup  (?)
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
FLD _1_esddfloat
FSTP _contador_esddfloat
FLD _02_5_esddfloat
FSTP _nombre_esddfloat
displayString _nombretiene 
newline 1
DisplayFloat _nombre_esddfloat , 2
newline 1
FLD _02_5_esddfloat
FLD _nombre_esddfloat
FSUB
FSTP _varaux
FLD _20_esddfloat
FLD _2_esddfloat
FDIV 
FSTP _varaux
FLD _varaux
FLD _0_esddfloat
FADD
FSTP _varaux
FLD _varaux
FSTP _suma_esddfloat
displayString _contadortiene 
newline 1
DisplayFloat _contador_esddfloat , 2
newline 1
displayString _sumatiene 
newline 1
DisplayFloat _suma_esddfloat , 2
newline 1
FLD _5_esddfloat
FSTP _@max1
FLD _2_esddfloat
FSTP _@max2
FLD _6_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max2
FXCH
FCOM
FSTSW AX
SAHF
JNA _Etiq54
FLD _@aux
FSTP _@max2
_Etiq54:
FLD _@max2
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA _Etiq65
FLD _@aux
FSTP _@max1
_Etiq65:
FLD _@max1
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA _Etiq76
FLD _@aux
FSTP _@max1
_Etiq76:
FLD _3_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA _Etiq87
FLD _@aux
FSTP _@max1
_Etiq87:
FLD _@max1
FSTP _actual_esddfloat
displayString _ahoraactualtiene 
newline 1
DisplayFloat _actual_esddfloat , 2
newline 1
FLD _2_esddfloat
FSTP _aux_esddfloat
_Etiq102:
FLD _3_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNA _Etiq106
FLD _4_esddfloat
FLD _aux_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JNA _Etiq106
displayString _entrealwhile 
newline 1
FLD _suma_esddfloat
FLD _1_esddfloat
FSUB
FSTP _varaux
FLD _varaux
FSTP _suma_esddfloat
FLD _1_esddfloat
FLD _aux_esddfloat
FADD
FSTP _varaux
FLD _varaux
FSTP _aux_esddfloat
JMP _Etiq102
_Etiq106:
FLD _2_esddfloat
FSTP _suma_esddfloat
FLD _2_esddfloat
FLD _suma_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JNA _Etiq134
displayString _sumaesmenora2 
newline 1
_Etiq134:
MOV EAX, 4c00h  ; termina la ejecucion
INT 21h
END start;
;
