; mean.asm
; double mean(double *arr, long long count)  (caller must have count-as-double in xmm0)
global mean
section .rodata
zero_val2: dq 0.0

section .text
mean:
    push rbp
    mov rbp, rsp

    mov rax, rdi     ; array base
    mov rcx, rsi     ; integer count
    ; copy double count from xmm0 to xmm1 for later division
    movsd xmm1, xmm0

    ; sum in xmm0 := 0.0
    movsd xmm0, [rel zero_val2]

    xor rdx, rdx     ; index = 0

    cmp rcx, 0
    je .no_elements

.loop_mean:
    cmp rdx, rcx
    jge .done_mean

    mov rbx, rax
    mov r8, rdx
    imul r8, 8
    add rbx, r8
    movsd xmm2, [rbx]
    addsd xmm0, xmm2

    inc rdx
    jmp .loop_mean

.no_elements:
    ; divide: sum (xmm0) / count (xmm1)
    ; If count is 0, keep xmm0 as 0
    cmp rcx, 0
    je .done_mean
    divsd xmm0, xmm1  ; NOTE: syntax used below corrected in Intel: divsd xmm0, xmm1? (we must do xmm0 = xmm0 / xmm1)
    ; In NASM / Intel, instruction is DIVSD xmm_dest, xmm_src => xmm_dest = xmm_dest / xmm_src
    ; The line above matches that semantics (xmm0 = xmm0 / xmm1)

.done_mean:
    pop rbp
    ret
