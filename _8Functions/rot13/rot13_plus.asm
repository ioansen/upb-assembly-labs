%include "io.inc"
extern printf

section .data
    strings db "ana are batoane de mere",10,0,"are",10,0,"mere",10,0,"multe peste tot",10,0
    len dd $-strings

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
    cmp dl, 'z'
    jbe fine
    sub dl, 26
fine:
    mov byte[eax+ecx], dl
do_it_again:
    inc ecx
    jmp again
    
out:
    mov eax, ecx
    leave
    ret

CMAIN:
    push ebp
    mov ebp, esp
    
    xor ecx, ecx
    mov ecx, dword[len]
    mov esi, strings

loop_rot:
    push ecx               ;save counter
    
    push esi
    call printf
    add esp, 4
    
    push esi
    call rot
    add esp, 4
    
    push eax                ;save strig length
    
    push esi
    call printf
    add esp, 4
    
    pop eax                ;retrieve string length
    inc eax                ;add strng terminator to length
    pop ecx                ;retrieve counter
    add esi, eax           ;advance to next string
    sub ecx, eax           ;decrement total length
    cmp ecx, 0
    jg loop_rot
   

    leave
    ret
