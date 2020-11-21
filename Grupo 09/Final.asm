include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
;variables de la tabla de simbolos

_0_esddfloat	dd	0.0	;esddfloat
_10_esddfloat	dd	10.0	;esddfloat
_1_esddfloat	dd	1.0	;esddfloat
_2_esddfloat	dd	2.0	;esddfloat
_3_esddfloat	dd	3.0	;esddfloat
_4_esddfloat	dd	4.0	;esddfloat
_5_esddfloat	dd	5.0	;esddfloat
_7_esddfloat	dd	7.0	;esddfloat
_85_esddfloat	dd	85.0	;esddfloat
_8_esddfloat	dd	8.0	;esddfloat
_9_esddfloat	dd	9.0	;esddfloat
_actual_esddfloat	dd	?	;esddfloat
_actuales2y_0	db	"actual es > 2 y != 0" , '$' , 22 dup  (?)
_actualtiene	db	"actual tiene: " , '$' , 16 dup  (?)
_ahoracontadortiene	db	"ahora contador tiene:" , '$' , 23 dup  (?)
_aux_esddfloat	dd	?	;esddfloat
_chau	db	"chau" , '$' , 6 dup  (?)
_contador_esddfloat	dd	?	;esddfloat
_contadortiene	db	"contador tiene: " , '$' , 18 dup  (?)
_entrealwhile	db	"entre al while" , '$' , 16 dup  (?)
_hola	db	"hola" , '$' , 6 dup  (?)
_ingreseunenteroaactual	db	"ingrese un entero a actual: " , '$' , 30 dup  (?)
_noesiguala4	db	"no es igual a 4" , '$' , 17 dup  (?)
_noesmayorque2	db	"no es mayor que 2" , '$' , 19 dup  (?)
_nombre_esddfloat	dd	?	;esddfloat
_promedio_esddfloat	dd	?	;esddfloat
_prueba_txtlyctema3	db	"prueba.txt lyc tema 3!" , '$' , 24 dup  (?)
_suma_esddfloat	dd	?	;esddfloat
_sumaesiguala8ya4	db	"suma es igual a 8 y <> a 4" , '$' , 28 dup  (?)
_sumatiene	db	"suma tiene: " , '$' , 14 dup  (?)
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
_@aux	dd	?	;esddfloat
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
FLD _2_esddfloat
FLD _5_esddfloat
FMUL 
FSTP _varaux
FLD _varaux
FLD _5_esddfloat
FMUL 
FSTP _varaux
FLD _varaux
FSTP _actual_esddfloat
FLD _10_esddfloat
FSTP _suma_esddfloat
FLD _9_esddfloat
FSTP _@max1
FLD _3_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq38
FLD _@aux
FSTP _@max1
_Etiq38:
FLD _4_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq49
FLD _@aux
FSTP _@max1
_Etiq49:
FLD _@max1
FSTP _contador_esddfloat
displayString _contadortiene 
newline 1
DisplayFloat _contador_esddfloat , 2
newline 1
FLD _2_esddfloat
FSTP _contador_esddfloat
displayString _ahoracontadortiene 
newline 1
DisplayFloat _contador_esddfloat , 2
newline 1
_Etiq64:
FLD _3_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNA  _Etiq89
FLD _contador_esddfloat
FLD _4_esddfloat
FCOM
FSTSW AX
SAHF
JB  _Etiq89
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
JMP _Etiq64
_Etiq89:
displayString _sumatiene 
newline 1
DisplayFloat _suma_esddfloat , 2
newline 1
FLD _10_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JAE  _Etiq106
FLD _suma_esddfloat
FLD _8_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JA  _Etiq106
displayString _hola 
newline 1
_Etiq106:
FLD _8_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JE  _Etiq117
FLD _suma_esddfloat
FLD _4_esddfloat
FCOM
FSTSW AX
SAHF
JE  _Etiq119
_Etiq117:
displayString _chau 
newline 1
_Etiq119:
FLD _8_esddfloat
FSTP _suma_esddfloat
FLD _8_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JNE  _Etiq135
FLD _suma_esddfloat
FLD _4_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JE  _Etiq135
displayString _sumaesiguala8ya4 
newline 1
_Etiq135:
FLD _2_esddfloat
FSTP _suma_esddfloat
FLD _4_esddfloat
FLD _suma_esddfloat
FCOM
FSTSW AX
SAHF
JE  _Etiq145
displayString _noesiguala4 
newline 1
_Etiq145:
FLD _9_esddfloat
FSTP _@max3
FLD _8_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max3
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq159
FLD _@aux
FSTP _@max3
_Etiq159:
FLD _7_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max3
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq170
FLD _@aux
FSTP _@max3
_Etiq170:
FLD _@max3
FSTP _@max2
FLD _2_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max2
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq184
FLD _@aux
FSTP _@max2
_Etiq184:
FLD _4_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max2
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq195
FLD _@aux
FSTP _@max2
_Etiq195:
FLD _@max2
FSTP _@max1
FLD _3_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq209
FLD _@aux
FSTP _@max1
_Etiq209:
FLD _4_esddfloat
FSTP _@aux
FLD _@aux
FLD _@max1
FXCH
FCOM
FSTSW AX
SAHF
JNA  _Etiq220
FLD _@aux
FSTP _@max1
_Etiq220:
FLD _@max1
FSTP _suma_esddfloat
displayString _sumatiene 
newline 1
DisplayFloat _suma_esddfloat , 2
newline 1
FLD _2_esddfloat
FLD _actual_esddfloat
FCOM
FSTSW AX
SAHF
JNA  _Etiq243
FLD _actual_esddfloat
FLD _0_esddfloat
FXCH
FCOM
FSTSW AX
SAHF
JE  _Etiq243
displayString _actuales2y_0 
newline 1
FLD _2_esddfloat
FSTP _suma_esddfloat
_Etiq243:
FLD _5_esddfloat
FSTP _promedio_esddfloat
FLD _nombre_esddfloat
FLD _actual_esddfloat
FCOM
FSTSW AX
SAHF
JAE  _Etiq253
displayString _noesmayorque2 
newline 1
_Etiq253:
MOV EAX, 4c00h  ; termina la ejecucion
INT 21h
END start;
;
