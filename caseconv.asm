; 
; FILENAME:     caseconv.asm
; CREATED BY:   Brian Hart
; DATE:         10 Dec 2018
; PURPOSE:      Convert any lowercase letter in an input data file into an uppercase letter
;

SYS_READ    EQU 3           ; Code for the sys_read syscall
SYS_WRITE   EQU 4           ; Code for the sys_write syscall
SYS_EXIT    EQU 1           ; Code for the sys_exit syscall
OK          EQU 0           ; Return code to Linux meaning program exited successfully
EOF         EQU 0           ; Value for end-of-file (EOF) from sys_read
STDIN       EQU 0           ; File Descriptor for Standard input
STDOUT      EQU 1           ; File Descriptor for Standard output
BUFFLEN     EQU 1           ; Length of the buffer that holds the current character, in bytes

section .bss                ; Uninitialized data
    Buff    resb    1                       ; Reserve an uninitialized buffer, Buff, 1 byte in size, to hold the current char
    
section .data               ; Initialized data
    ; There is no initialized data to add at this time
    
section .text               ; Program's code

    global _start           ; Tells the linker where the program's entry point is
    
_start:
    nop                     ; This no-op keeps the debugger happy
 
; the following set of instructions read one char at a time from stdin and checks whether we
; just read an EOF.   If we read an EOF, then we stop and jump to the Exit label; otherwise,
; execution continues.   
Read:
    mov eax, SYS_READ       ; Specify sys_read syscall
    mov ebx, STDIN          ; Specify File descriptor 0: Standard input
    mov ecx, Buff           ; Pass address of the buffer to read to
    mov edx, BUFFLEN        ; tell sys_read to read one char from stdin
    int 80h                 ; Call sys_read
    
    cmp eax,EOF             ; Look at sys_read's return value in EAX
    je  Exit                ; Jump If Equal to 0 (0 means EOF) to Exit
                            ; or fall through to test for lowercase
    cmp BYTE [Buff],61h     ; Test input char against lowercase 'a'
    jb  Write               ; If below 'a' in ASCII chart, not lowercase letter
    cmp BYTE [Buff],7AH     ; Test input char against lowercase 'z'
    ja  Write               ; If above 'z' in ASCII chart, not a lowercase letter 
    
    ; At this point, we are certain that we have a lowercase letter
    ; in the memory referenced by Buff
    
    sub BYTE [Buff],20h     ; Subtract 20h from the value in Buff to give an uppercase letter's ASCII code
    
    ; No matter what happened above, now we are ready to write the character out
Write:
    mov eax, SYS_WRITE      ; Specify sys_write syscall
    mov ebx, STDOUT         ; Specify File Descriptor 1: Standard output
    mov ecx, Buff           ; Pass address of the character to write
    mov edx, BUFFLEN        ; Pass number of chars to write
    int 80h                 ; Call sys_write...
    jmp Read                ; ...then go to the beginning to get another character
    
    ; When the Read label's code reads in an EOF from stdin for the first time, 
    ; it'll jump to the Exit label
Exit:
    mov eax, SYS_EXIT       ; Specify sys_exit syscall
    mov ebx, OK             ; Return a code of zero to Linux
    int 80h                 ; Make kernel call to exit program