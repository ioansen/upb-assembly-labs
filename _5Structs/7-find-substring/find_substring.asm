%include "io.inc"

section .data
source_text: db "ABCABCBABCBABCBBBABABCCBABCBAAACCCB", 0
substring: db "BABC", 0

source_length: dd 0
substr_length: dd 4

print_format: db "Substring found at index: ", 0

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    ; TODO: Fill source_length with the length of the source_text string.
    ; Find the length of the string using scasb.
    cld
    xor al, al          ;mov al, 0
    mov edi, source_text
    repne scasb
    

    ; TODO1: save the result in at address length
    sub edi, source_text
    dec edi
    mov ecx, edi                        ;save length
    mov dword[source_length], edi

    ; TODO: Print the start indices for all occurrences of the substring in source_text
    mov esi, source_text
    mov ebx, substring
    mov dl, cl                      ;dl will be the main counter
    mov ax, word[substr_length]     ;set ax to subsr length for quick reference

    cld
again:
    mov edi, ebx        ;move edi back to substring address
    mov cl, al          ;set cl for match test
    repe cmpsb
    jne mismatch
match:
    PRINT_STRING print_format
    PRINT_UDEC 1, dl
    NEWLINE
mismatch:
    sub si, ax      ;reset si from where is started
    add si, cx      ;(before cmpsb) with si -= al - cl
    inc si          ;add 1 so we verify it form next char
    dec dl          ;always dec dl 1 since we inc si with 1
    test dl, dl
    jnz again
    
    leave
    ret
