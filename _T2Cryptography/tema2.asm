extern puts
extern printf
extern strlen


%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

print_format: db "some %x",10,0
print: db "%x ", 0
print_newline: db 10,0
base32_alphapet: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
section .text
global main

;--------------------------------------------------------------------------------
;void print_contents(*adress)    
;--------------------------------------------------------------------------------
;helper print method that prints bytes from an adress untill byte 0
;it's just for testing purposes and it shouldn't be called in the final prgram
;uses pusha at at the begining so it can be easily used
;--------------------------------------------------------------------------------
print_contents:    
        enter 0, 0
        
        pusha                   
        mov esi, [ebp + 8]
        
        push esi
        call strlen             ;length in eax
        add esp, 4
                
        test eax, eax
        jz out_print
        
        mov ecx, eax
                
do_the_print:
        push ecx
        xor eax, eax
        lodsb
        push eax
        push print
        call printf
        add esp, 8 
        pop ecx
        loop do_the_print
                
        push print_newline
        call printf
        add esp, 4

out_print:                
        popa
        leave
        ret

;--------------------------------
;char convert_hex_bin_word(char a)
;--------------------------------
convert_hex_bin_word:
        enter 0, 0
        
        mov ax, [ebp + 8]
        
        sub ah, '0'
        cmp ah, 9
        jbe good1
        sub ah, 0x27            ;0x27 = 0x61 - 0x30 + 0xa ; 'a'-'0' + 10
good1:                     
        sub al, '0'
        cmp al, 9
        jbe good2
        sub al, 0x27   
good2: 
        shl al, 4               ;move lower nibble to upper nibble 
        or al, ah               ;merge nibbles in al

        leave
        ret
                
;--------------------------------
;void convert_hex_bin(*adress)
;--------------------------------
convert_hex_bin:
        enter 0, 0
        
        push edi
        push esi
        
        mov edi, [ebp + 8]      ;the adress of string to convert
        mov esi, edi
        
        push edi
        call strlen             ;length in eax
        add esp, 4
        
        mov ecx, eax
        shr ecx,1               ;we'll be going in 2's so ecx /= 2

do_the_convertion:              ;convert by translating byte to hex symbol then trasnlating the next one then merging the two
         
        lodsw                   ;load word from esi in ax
        
        push ax
        call convert_hex_bin_word
        add esp, 2
        
        stosb                   ;load al at edi
        loop do_the_convertion
        
        pop esi                 ;restore esi and edi
        pop edi
        leave
        ret
   
;----------------------------------------------------------------
;int contains(*substring, int length, *string)
;----------------------------------------------------------------        
contains:         
        enter 0,0
        
        push ebx                    ;save the register we use
        push esi                    ;so we can restore
        push edi
        
        mov edi, [ebp + 8]          ;the string we're looking for  
        mov esi, [ebp + 12]         ;the string we're searching in
       
        push esi
        call strlen                 ;compute string length
        add esp, 4
        
        test eax, eax               ;test if no string and just exit if so
        jz contains_out
                
        push eax                    ;save string length on stack, use eax for next strlen

        mov ebx, edi                ;substring base at ebx
               
        push edi
        call strlen                 ;substring length in eax
        add esp, 4
        
        pop edx                     ;string length in edx 
        
do_the_iteration:
        push esi
        mov edi, ebx                ;move edi back to substring address        
        xor ecx, ecx
        mov cl, al                  ;prepare cl for cmpsb(set it to substring length)
        repe cmpsb
        jne mismatch
match:
        add esp, 4                  ;release esi
        mov eax, 1                  ;return 1 if match
        jmp contains_out
mismatch:
        pop esi                     ;get start adress back
        inc esi                     ;add 1 so newxt we verify it from next char              
        dec dl                      ;always dec dl 1 since we inc esi with 1
        test dl, dl
        jnz do_the_iteration
        
        xor eax, eax                ;return 0 if mismatch

contains_out:       
        pop edi                     ;restore used registers
        pop esi 
        pop ebx
        leave
        ret
        
;--------------------------------
;int * get_key_address(*adress)
;--------------------------------
get_key_address:
        enter 0,0
        
        mov edi, [ebp + 8]
        
                                ;assume cld
        xor eax, eax            ;mov ax, 0
        mov ecx, 50             ;scan 50 bytes
        repne scasb             
        
        mov eax, edi
        leave
        ret

        
                        
;---------------------------------
;void xor_strings(*key, *string)
;---------------------------------     
xor_strings:
                                ;TODO TASK 1
        push ebp
        mov ebp, esp
        
        push esi                ;save them before using them
        push edi
        
        mov esi, [ebp + 8]      ;the key
        mov edi, [ebp + 12]     ;the string 
                               
        push edi
        call strlen             ;length in eax
        add esp, 4
                                    
        mov ecx, eax

do_the_xor:
        mov dl, byte[esi]
        xor byte[edi], dl 
        inc edi
        inc esi      
        loop do_the_xor
          
        pop edi                 ;restore edi, esi
        pop esi  
        leave
        ret

;--------------------------------
;int rolling_xor(*string);
;--------------------------------
rolling_xor:
                                ;TODO TASK 2
        enter 0,0
        
        push esi
        mov esi, [ebp + 8]
        
        push esi
        call strlen             ;length in eax
        add esp, 4
        
        push eax
        mov ecx, eax
        dec ecx                 ;skip first one
        add esi, ecx
       
do_the_rolling:
        mov al, byte[esi - 1]
        xor byte[esi], al
        dec esi
        loop do_the_rolling
        
        pop eax                 ;return length
        pop esi
        leave
        ret

;----------------------------------------
;void xor_hex_strings(*key, *string);
;----------------------------------------
xor_hex_strings:
                                ;TODO TASK 3
        enter 0,0
        
        push edi                ;we're using them so save them
        push esi       
        
        mov esi, [ebp + 8]      ;the key
        mov edi, [ebp + 12]     ;the string
                
        
        push edi
        call convert_hex_bin    ;convert string 
                       
        push esi
        call convert_hex_bin    ;convert key
        
                                ;key and string already on stack
        call xor_strings        ;xor them
        add esp, 8
        
        pop esi                 ;restore esi and edi
        pop edi
        leave
        ret
        
;-----------------------------------------------------------------
;void base32decode(*string);    i am encoding binary --> text
;----------------------------------------------------------------
base32decode:
                                ;TODO TASK 4
        enter 0, 0
        
        push esi
        push ebx
        
        mov esi, [ebp + 8]
        
        push esi
        call strlen             ;length in eax
        add esp, 4
        
        mov ecx, eax
        mov ebx, base32_alphapet
        mov edi, ecx            ;save length also here, to create another address
        inc edi

compute_next_5:
        xor eax, eax
        mov edx, dword[esi]
        mov dl, byte[esi]
        
        push ecx
        mov ecx, 6
first_4_bytes:             
        mov al, dl              
        and al, 0x1F            ;discard upper 3 bits
        xlat
        push eax
        shr edx, 5
        loop first_4_bytes
        add esi, 4     
                                
                                ;need to compute last byte               
        xor cx, cx
        mov cl, byte[esi]       
        shl cx, 2
        xor dx, cx

        mov al, dl              
        and al, 0x1F            ;discard upper 3 bits
        xlat
        push eax
        shr edx, 5
        mov al, dl              
        and al, 0x1F            ;discard upper 3 bits
        xlat
        push eax
        shr edx, 5
        
put_them_in:
        sub esi,4
        pop eax
        mov edi, 6
retrieve: 
        shl eax,6
        pop edx
        or eax, edx
        dec edi
        cmp edi, 0
        jb retrieve       

        pop edx
        mov edi, edx
        xor edx, edx
        shl dl, 3
        shr dl, 8
        shl eax, 2
        or eax, edx
        mov dword[esi], eax
        xor eax, eax
        shl al, 5
        shr al, 8
        shl al, 8
        pop edx
        or eax, edx
        mov byte[esi+4], al
               
        pop ecx
        sub ecx, 5
        cmp ecx, 0
        jg compute_next_5
        
        not ecx                 ;attempt c2
        inc ecx        
        
add_padding:
        loop add_padding
                
        pop ebx
        pop esi
        leave
        ret

;------------------------------------------------------------
;int bruteforce_singlebyte_xor(*string);
;------------------------------------------------------------
;a byte has 256 possible values
;just search them all
;so for every byte, generate key by multiplying byte
;then xor them strings, then check if string contains 'force'
;sounds like bruteforce
;------------------------------------------------------------
bruteforce_singlebyte_xor:
                                    ;TODO TASK 5
        enter 0,0
        
        push esi                    ;save used registers
        push edi
        push ebx
        
        mov esi, [ebp + 8]          ;string address in esi
               
        push esi
        call strlen                 ;length in eax
        add esp, 4
        
        mov ecx, eax                ;string length in ecx
        
        ;sub esp, ecx                ;reserve space on stack for key
        ;mov edi, esp
        
        sub esp, 6                  ;leave space to also put 'force' on stack ('force' should be param so we could mass use this method/procedure)
        mov byte[esp], 'f'
        mov byte[esp + 1], 'o'
        mov byte[esp + 2], 'r'
        mov byte[esp + 3], 'c'
        mov byte[esp + 4], 'e'
        mov byte[esp + 5], 0
        mov ebx, esp                ;'force' address in ebx, ebx saved by procedures so we won't have to push it everytime
        
        ;push ecx                    ;push length so we can restore stack later
        
        
        mov dl, 0xff                ;generate 255, the first tested key
        
do_the_bruteforce:           
        push edx                    ;save loop counter (and the key )
        push ecx                    ;save the string length
        
        ;push edi
        ;mov al, dl                  ;multiply key with stosb, store byte in al
        ;rep stosb                   ;repeat ecx time
        ;mov byte[edi], 0            ;set string terminator
        ;pop edi                     ;get edi back from rep stosb        
        ;pop ecx                     ;get ecx back from rep stosb

        ;push ecx                    ;push the registers affected by xor_them
        ;push edi
        push esi
        
xor_them:                           ;xor them like in xor_strings
                                    ;can't use xor_strings procedure
                                    ;because i want to xor them precisely ecx times (the original strlen)
                                    ;and not the temp strlen times
                                    ;since i need to revert this operation
        ;mov dl, byte[edi]
        xor byte[esi], dl 
        ;inc edi
        inc esi      
        loop xor_them
        
        pop esi                     ;get back registers used by xor_them
        ;pop edi
        pop ecx
        ;pop edx                     ;including edx
        
        ;push edx                    ;push registers before contains
        push ecx                                                  
        
        push esi                    
        push ebx
        call contains               ;eax contains boolean (0 if not found)
        add esp, 8
        
        pop ecx                     ;get back registers before contains
        pop edx

        test eax, eax               ;test if contains == true
        jnz found
        
        push edx                    ;push registers used by xor_the_back
        push ecx
        ;push edi
        push esi
        
xor_them_back:                      ;revert xor_them operation
                                    ;so we start next iteration with the initial string
        ;mov dl, byte[edi]
        xor byte[esi], dl 
        ;inc edi
        inc esi      
        loop xor_them_back
         
        pop esi                     ;get back registers used by xor_the_back
        ;pop edi
        pop ecx             
        pop edx
        
        dec dl                                                                                                  
        test dl, 0xff                ;also test algorithm for 0 key (leave when dl = -1 i.e when dl is back to 255)
        jnz do_the_bruteforce
        
found:
        ;pop ecx                      ;get string length and redo stack
        add esp, 6                   ;restore 'force' space
        ;add esp, ecx                 ;restore generated key sapce
        ;inc esp
        
        mov al,dl                    ;put key in al i.e return key
        pop ebx                      ;restore edi, esi, ebx
        pop edi                      
        pop esi                                                 
        leave
        ret

decode_vigenere:
        ; TODO TASK 6
        ret

main:
        push ebp
        mov ebp, esp
        sub esp, 2300
    
        ; test argc
        mov eax, [ebp + 8]
        cmp eax, 2
        jne exit_bad_arg
    
        ; get task no
        mov ebx, [ebp + 12]
        mov eax, [ebx + 4]
        xor ebx, ebx
        mov bl, [eax]
        sub ebx, '0'
        push ebx
    
        ; verify if task no is in range
        cmp ebx, 1
        jb exit_bad_arg
        cmp ebx, 6
        ja exit_bad_arg
    
        ; create the filename
        lea ecx, [filename + 7]
        add bl, '0'
        mov byte [ecx], bl
    
        ; fd = open("./input{i}.dat", O_RDONLY):
        mov eax, 5
        mov ebx, filename
        xor ecx, ecx
        xor edx, edx
        int 0x80
        cmp eax, 0
        jl exit_no_input
    
        ; read(fd, ebp - 2300, inputlen):
        mov ebx, eax
        mov eax, 3
        lea ecx, [ebp-2300]
        mov edx, [inputlen]
        int 0x80
        cmp eax, 0
        jl exit_cannot_read
    
        ; close(fd):
        mov eax, 6
        int 0x80
    
            cld
            ; all input{i}.dat contents are now in ecx (address on stack)
        pop eax
        cmp eax, 1
        je task1
        cmp eax, 2
        je task2
        cmp eax, 3
        je task3
        cmp eax, 4
        je task4
        cmp eax, 5
        je task5
        cmp eax, 6
        je task6
        jmp task_done

task1:
                                    ;TASK 1: Simple XOR between two byte streams       
                                    ;TODO TASK 1: find the address for the string and the key
                                    
        
        push ecx                    ;send as param to get_key_address
        call get_key_address        ;key address in eax    
                                    ;leave ecx on stack    
        
                                    ;TODO TASK 1: call the xor_strings function
        
                                    ;ecx already on stack
        push eax                    ;the key address
        call xor_strings
        add esp, 4
       
                                    ;ecx already on stack
        call puts                   ;print resulting string
        add esp, 4                  ;release ecx
        
        jmp task_done

task2:
                                    ;TASK 2: Rolling XOR

                                    ;TODO TASK 2: call the rolling_xor function        
        push ecx                    ;save string address on stack
        call rolling_xor
        
                                    ;ecx already on stack
        call puts                   ;print resulting string
        add esp, 4                  ;release ecx

        jmp task_done

task3:
                                    ;TASK 3: XORing strings represented as hex strings
        
        mov ebx, ecx                ;save in ebx because strlen shouldn't modify it
        push ecx                    ;save adress and send as param        
        call strlen                 ;length in eax
        
        add ebx, eax                ;compute key address as base + length + 1 (1 from 00) 
        inc ebx
             
                                    ;ecx already on stack
        push ebx
        call xor_hex_strings
        add esp, 4
        
                                    ;ecx already on stack
        call puts                   ;print resulting string
        add esp, 4                  ;release ecx  
        
        
        jmp task_done

task4:
        ; TASK 4: decoding a base32-encoded string
    
        ; TODO TASK 4: call the base32decode function
        
        push ecx
        call puts                    ;print resulting string
        add esp,4
        
        jmp task_done

task5:
        ; TASK 5: Find the single-byte key used in a XOR encoding
    
        ; TODO TASK 5: call the bruteforce_singlebyte_xor function
    
        push ecx
        call bruteforce_singlebyte_xor      ;key in eax
        pop ecx
        
        push eax                    ;save key (before puts)
        
        push ecx
        call puts                   ;print resulting string
        add esp, 4
        
                                    ;eax = key value (eax alredy on stack)
        push fmtstr
        call printf                 ;print key value
        add esp, 8
        
        jmp task_done

task6:
        ; TASK 6: decode Vignere cipher
    
        ; TODO TASK 6: find the addresses for the input string and key
        ; TODO TASK 6: call the decode_vigenere function
    
        push ecx
        call strlen
        pop ecx
    
        add eax, ecx
        inc eax
    
        push eax
        push ecx                   ;ecx = address of input string 
        call decode_vigenere
        pop ecx
        add esp, 4
    
        push ecx
        call puts
        add esp, 4

task_done:
        xor eax, eax
        jmp exit

exit_bad_arg:
        mov ebx, [ebp + 12]
        mov ecx , [ebx]
        push ecx
        push usage
        call printf
        add esp, 8
        jmp exit

exit_no_input:
        push filename
        push error_no_file
        call printf
        add esp, 8
        jmp exit

exit_cannot_read:
        push filename
        push error_cannot_read
        call printf
        add esp, 8
        jmp exit

exit:
        mov esp, ebp
        pop ebp
        ret
