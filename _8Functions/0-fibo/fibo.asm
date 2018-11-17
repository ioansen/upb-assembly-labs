%include "io.inc"

%define NUM_FIBO 10

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    xor eax, eax ;hi
    xor ebx, ebx ;lo
    ; TODO - replace below instruction with the algorithm for the Fibonacci sequence
    sub esp, NUM_FIBO * 4
    mov dword[esp], eax
    inc ebx
    mov dword[esp+4], ebx
    
    mov ecx, 2
add_fibo:
    mov edx, eax
    add eax, ebx
    mov ebx, edx
    mov dword[esp + (ecx - 1) * 4], eax
    inc ecx
    cmp ecx, NUM_FIBO
    jbe add_fibo
    
    
    mov ecx, NUM_FIBO
print:
    PRINT_UDEC 4, [esp + (ecx - 1) * 4]
    PRINT_STRING " "
    dec ecx
    cmp ecx, 0
    ja print

    mov esp, ebp
    xor eax, eax
    ret
