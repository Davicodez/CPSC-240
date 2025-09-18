; magnitude.asm
; double magnitude(double *arr, long long count);
global magnitude
section .rodata
zero_val: dq 0.0

section .text
magnitude:
    push rbp
    mov rbp, rsp

    mov rax, rdi     ; base pointer to array
    mov rcx, rsi     ; count
    xor rdx, rdx     ; index = 0

    movsd xmm0, [rel zero_val] ; sum = 0.0

    cmp rcx, 0
    je .done_loop

.loop:
    cmp rdx, rcx
    jge .done_loop

    ; addr = base + rdx*8
    mov rbx, rax
    mov r8, rdx
    imul r8, 8
    add rbx, r8
    movsd xmm1, [rbx]         ; xmm1 = arr[rdx]

    mulsd xmm1, xmm1          ; xmm1 = xmm1 * xmm1
    addsd xmm0, xmm1          ; sum += xmm1

    inc rdx
    jmp .loop

.done_loop:
    sqrtsd xmm0, xmm0         ; sqrt(sum)
    pop rbp
    ret
