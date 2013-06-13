as src\sort.s -o src\sort.o
ld -s -O3 --subsystem  windows src\sort.o %MinGw%\lib\libuser32.a %MinGw%\lib\libkernel32.a %MinGw%\lib\libmsvcrt.a %MinGw%\\lib\libkernel32.a -o src\sort.exe