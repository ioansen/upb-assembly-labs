%include "io.inc"

section .text
global CMAIN
CMAIN:
    ; cele doua numere se gasesc in eax si ebx
    mov eax, 1
    mov ebx, 4 

    ; TODO: aflati maximul folosind doar o instructiune de salt si push/pop
    cmp eax, ebx
    jg print_max
    ;eax smaller xchg
    push eax
    push ebx
    pop eax
    pop ebx
print_max:
    PRINT_DEC 4, eax ; afiseaza maximul
    NEWLINE

    ret
