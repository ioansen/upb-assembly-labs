%include "io.inc"

section .data
    string db "Lorem ipsum dolor sit amet.", 0
    print_strlen db "strlen: ", 10, 0
    print_occ db "occurences of `i`:", 10, 0

    occurences dd 0
    length dd 0    
    char db 'i'

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    ; TODO1: compute the length of a string
    cld
    xor al, al          ;mov al, 0
    mov edi, string
    repne scasb
    

    ; TODO1: save the result in at address length
    sub edi, string
    dec edi
    mov dword[length], edi

    ; print the result of strlen
    PRINT_STRING print_strlen
    PRINT_UDEC 4, [length]
    NEWLINE

    ; TODO2: compute the number of occurences
    xor ebx, ebx            ;store apperences here

    mov al, byte[char]
    mov edi, string
    mov ecx, dword[length]

again:
    repne scasb
    inc ebx
    test ecx, ecx
    jnz again
    dec ebx                 ;ebx stores apperences + 1 so we dec

    
    ; TODO2: save the result in at address occurences
    mov dword[occurences], ebx

    ; print the number of occurences of the char
    PRINT_STRING print_occ
    PRINT_UDEC 4, [occurences]
    NEWLINE

    xor eax, eax
    leave
    ret
