%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;cele doua numere se gasesc in eax si ebx
    mov eax, 1
    mov ebx, 4 
    ; TODO: aflati minimul
    cmp eax,ebx
    jl print_min
    xchg eax, ebx

print_min:
    PRINT_DEC 4, eax ; afiseaza minimul
    NEWLINE

    ret