%include "io.inc"

section .data

%define ARRAY_LEN 7

    input dd 122, 184, 199, 242, 263, 845, 911
    output times ARRAY_LEN dd 0

section .text
global CMAIN
CMAIN:

    ; TODO push the elements of the array on the stack
    mov ecx, ARRAY_LEN
    mov ebx, input
pushv:
    push dword[ebx +ecx*4-4]
    loop pushv
    ; TODO retrieve the elements (pop) from the stack into the output array
    
    mov ebx, output
    mov ecx, ARRAY_LEN
popv:
    pop dword[ebx + ecx*4-4]
    loop popv
    
    PRINT_STRING "Reversed array:"
    NEWLINE
    xor ecx, ecx
print_array:
    PRINT_UDEC 4, [output + 4 * ecx]
    NEWLINE
    inc ecx
    cmp ecx, ARRAY_LEN
    jb print_array

    xor eax, eax
    ret
