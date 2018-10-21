%include "io.inc"

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    mov eax, 211    ; to be broken down into powers of 2
    mov ebx, 1      ; stores the current power

    ; TODO - print the powers of 2 that generate number stored in EAX
    
again:
    test eax, ebx
    jz skip
    PRINT_UDEC 4, ebx
    NEWLINE
    
skip:  
    shl ebx, 1
    cmp eax,ebx
    jg again


    
    leave
    ret
