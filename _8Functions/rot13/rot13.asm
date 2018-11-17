%include "io.inc"
extern printf

section .data
    before_format db "before %s", 13, 10, 0
    after_format db "after %s", 13, 10, 0
    mystring db "abcCDEFG;*&^%$#efghij", 0

section .text
global CMAIN

rot:
    push ebp
    mov ebp, esp

    mov eax, dword[ebp + 8]
    xor ecx, ecx
again:
    mov dl, byte[eax+ecx]
    test dl, dl
    jz out
    cmp dl, 'A'
    jb do_it_again
    cmp dl, 'z'
    jg do_it_again
    add dl,13
    mov byte[eax+ecx], dl
do_it_again:
    inc ecx
    jmp again
    
out:
    leave
    ret

CMAIN:
    push ebp
    mov ebp, esp

    push mystring
    push before_format
    call printf
    add esp, 8

    push mystring
    call rot
    add esp, 4

    push mystring
    push after_format
    call printf
    add esp, 8

    leave
    ret
