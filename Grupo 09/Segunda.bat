C:\GnuWin32\bin\flex Lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Segunda.exe
pause
pause
Segunda.exe prueba.txt


del lex.yy.c
del Segunda.exe
del y.tab.c
del y.tab.h
pause