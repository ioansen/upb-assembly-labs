%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;cele doua multimi se gasesc in eax si ebx
    mov eax, 139 
    mov ebx, 169
    PRINT_DEC 4, eax ; afiseaza prima multime
    NEWLINE
    PRINT_DEC 4, ebx ; afiseaza cea de-a doua multime
    NEWLINE

    ; TODO1: reuniunea a doua multimi
    mov ecx, eax
    or ecx,ebx
    PRINT_DEC 4,ecx
    NEWLINE

    ; TODO2: adaugarea unui element in multime
    add eax, 16

    ; TODO3: intersectia a doua multimi
    mov ecx, eax
    and ecx, ebx
    PRINT_DEC 4,ecx
    NEWLINE

    ; TODO4: complementul unei multimi
    mov ecx, eax
    not ecx
    PRINT_UDEC 4, ecx
    NEWLINE

    ; TODO5: eliminarea unui element
    sub eax, 16

    ; TODO6: diferenta de multimi EAX-EBX
    mov ecx, eax
    xor ecx, ebx
    PRINT_DEC 4, ecx
    NEWLINE


    xor eax, eax
    ret
