section .text

global get_max

get_max:
	push rbp
	mov rbp, rsp

	mov rbx, rdi
	mov rcx, rsi
	xor eax, eax

compare:
        cmp eax, [rbx+rcx*4-4]
        jge check_end
	mov eax, [rbx+rcx*4-4]
        mov [rdx], rcx
check_end:
	loopnz compare

	leave
	ret
