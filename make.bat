C:\MinGW\bin\as.exe src\sort.s -o src\sort.o


C:\MinGW\bin\ld.exe -s -O3 --subsystem  windows src\sort.o C:\MinGW\lib\libuser32.a C:\MinGW\lib\libkernel32.a C:\MinGW\lib\libmsvcrt.a C:\MinGW\lib\libkernel32.a -o src\sort.exe