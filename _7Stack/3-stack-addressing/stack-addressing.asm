%include "io.inc"

%define NUM 5

section .text
global CMAIN
CMAIN:
    mov ebp, esp

    ; TODO 1: replace every push by an equivalent sequence of commands
    mov ecx, NUM
push_nums:
    sub esp, 4
    mov [esp], ecx
    loop push_nums

    sub esp, 16
    mov dword[esp+12], 0
    mov dword[esp+8], "mere"
    mov dword[esp+4], "are "
    mov dword[esp], "Ana "

    PRINT_STRING [esp]
    NEWLINE

    ; TODO 2: print the stack in "address: value" format in the range of [ESP:EBP]
    mov ecx, ebp
    sub ecx, esp
    mov ebx, esp
    
print:
    add ebx, 4
    PRINT_HEX 4, ebx
    mov eax, [ebx]
    PRINT_STRING ": "
    PRINT_HEX 4, eax
    NEWLINE
    sub ecx, 4
    test ecx, ecx
    jnz print
    
    ; TODO 3: print the string
    ; string-ul este pus la adresa de memorie reprezentata de esp
    ; la [esp] se afla valoarea
    ; stringul se opreste la terminatorul de sir 0,
    ;"mere", "are " si "Ana " se reprezinta pe cate un dword
    PRINT_STRING [esp]
    NEWLINE
    
    ; restore the previous value of the EBP (Base Pointer)
    mov esp, ebp

    ; exit without errors
    xor eax, eax
    ret
