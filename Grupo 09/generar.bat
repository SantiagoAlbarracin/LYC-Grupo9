@echo off

cls
echo Generando el numbers.obj
tasm numbers.asm
pause
cls
echo Generando el final.obj
tasm final.asm
pause
cls
echo Linkeando..
tlink /3 final.obj numbers.obj /v /s /m
pause
cls
echo Ejecutando el exe
echo --------------------------------------
final.exe
echo.
echo --------------------------------------
pause
del final.obj
del final.map
del final.exe
del numbers.obj
cls