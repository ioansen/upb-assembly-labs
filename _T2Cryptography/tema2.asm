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

print_format: db "%x",10,0
print: db "%x"
section .text
global main

;--------------------------------
;int * get_key_address(*adress)
;--------------------------------
get_key_address:
        enter 0,0
        
        mov edi, [ebp + 8]
        
                                ;assume cld
        xor al, al              ;mov ax, 0
        mov ecx, 50             ;scan 50 bytes
        repne scasb             
        
        mov eax, edi
        leave
        ret
        
;---------------------------------
;void xor_strings(*string, *key)   
;---------------------------------     
xor_strings:
                                ;TODO TASK 1
        push ebp
        mov ebp, esp
        
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
          
        leave
        ret

;--------------------------------
;void rolling_xor(*string);
;--------------------------------
rolling_xor:
                                ;TODO TASK 2
        enter 0,0
        
        mov edi, [ebp + 8]
        
        push edi
        call strlen             ;length in eax
        add esp,4
        
        push eax
        xor edx, edx
        mov ecx, eax
        mov dl, byte[edi]       ;save fisrt block (in this case byte)
        inc edi                 ;skip first block (no cyphering)
        dec ecx

do_the_rolling:
        xor byte[edi], dl
        mov dl, byte[edi]
        inc edi
        loop do_the_rolling
        
        pop eax
        leave
        ret

xor_hex_strings:
	; TODO TASK 3
	ret

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
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
        push ecx                    ;save address on stack for puts
        push ecx                    ;save again for xor_strings
        
        push ecx                    ;send as param to get_key_address
        call get_key_address        ;key address in eax
        add esp,4     
        
        
                                    ;TODO TASK 1: call the xor_strings function
        
                                    ;ecx already on stack
        push eax                    ;the key address
        call xor_strings
        add esp, 8
       
                                    ;ecx already on stack
        call puts                   ;print resulting string
        add esp, 4
        
	jmp task_done

task2:
                                    ;TASK 2: Rolling XOR

                                    ;TODO TASK 2: call the rolling_xor function
        push ecx                    ;save string address
        
        push ecx
        call rolling_xor
        add esp,4
        
                                    ;ecx already on stack
        call puts
        add esp, 4

        jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings

	; TODO TASK 1: find the addresses of both strings
	; TODO TASK 1: call the xor_hex_strings function

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function

	push ecx                    ;print resulting string
	call puts
	pop ecx

	push eax                    ;eax = key value
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
