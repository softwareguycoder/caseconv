caseconv: caseconv.o
	ld -o caseconv caseconv.o
caseconv.o: caseconv.asm
	nasm -f elf64 -g -F stabs caseconv.asm -l caseconv.lst
clean:
	rm -f *.o *.lst caseconv
