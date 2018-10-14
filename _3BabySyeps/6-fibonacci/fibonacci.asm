%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ecx, 7       ; vrem sa aflam al N-lea numar; N = 7
    ; TODO: calculati al N-lea numar fibonacci (f(0) = 0, f(1) = 1)
    mov eax, 0 ;low
    mov ebx, 1 ;high
    ;sub ecx, 2 first two numbers are hardcoded
    
looop:    
    mov edx, ebx
    add ebx, eax ;hi = lo + hi
    mov eax, edx
    sub ecx, 1
    test ecx, ecx
    jnz looop
    

    PRINT_DEC 4, ebx
    NEWLINE
    ret