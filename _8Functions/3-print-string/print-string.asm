%include "io.inc"

section .data
    mystring db "This is my string", 10, 0

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    PRINT_STRING mystring

    ; TODO: call puts on string
    push mystring
    call puts
    add esp, 4
    leave
    ret
