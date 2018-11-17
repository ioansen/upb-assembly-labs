%include "io.inc"
extern puts
extern printf

section .data
    mystring db "This is my string", 0
    length db "String length is %u", 10, 0

section .text
global CMAIN

CMAIN:
    push ebp
    mov ebp, esp

    mov eax, mystring
    xor ecx, ecx
test_one_byte:
    mov bl, byte [eax]
    test bl, bl
    je out
    inc eax
    inc ecx
    jmp test_one_byte

out:
    PRINT_DEC 4, ecx
    NEWLINE
    push ecx
    push length
    call printf
    add esp,8
    


    leave
    ret
