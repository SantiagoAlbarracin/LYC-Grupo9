@echo off

cls
echo Generando numbers.obj
tasm numbers.asm
pause
cls
echo Generando Final.obj
tasm Final.asm
pause
cls
echo Linkeando los .obj ..
tlink /3 Final.obj numbers.obj /v /s /m
pause
cls
echo Ejecutando Final.exe
echo --------------------------------------
Final.exe
echo.
echo --------------------------------------
pause
del Final.obj
del Final.map
del Final.exe
del numbers.obj
cls