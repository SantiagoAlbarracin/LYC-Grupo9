C:\GnuWin32\bin\flex Lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o TPFinal.exe
pause
pause
TPfinal.exe prueba.txt


del lex.yy.c
del TPFinal.exe
del y.tab.c
del y.tab.h
pause