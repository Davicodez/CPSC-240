; append.asm
; void append(double **arr_ptr, long long *count_ptr, double value);
global append
extern realloc
extern puts
extern exit
section .data
oom_msg: db "Out of memory in append", 0

section .text
append:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp-8], rdi    ; save arr_ptr
    mov [rbp-16], rsi   ; save count_ptr
    movsd [rbp-24], xmm0 ; save double value

    ; load count
    mov rax, [rbp-16]
    mov rdx, [rax]      ; rdx = old count

    ; compute bytes = (rdx + 1) * 8
    mov rcx, rdx
    add rcx, 1
    imul rcx, 8         ; rcx = bytes

    ; prepare call realloc(ptr, size)
    mov rdi, [rbp-8]
    mov rdi, [rdi]      ; rdi = current pointer
    mov rsi, rcx
    call realloc

    test rax, rax
    je .oom

    ; store new pointer back into *arr_ptr
    mov rbx, [rbp-8]
    mov [rbx], rax

    ; compute &ptr[old_count] = rax + old_count*8
    mov rcx, rdx
    imul rcx, 8
    add rax, rcx        ; rax points to new element

    ; load saved double into xmm0 and store
    movsd xmm0, [rbp-24]
    movsd [rax], xmm0

    ; increment count
    mov rbx, [rbp-16]
    mov rcx, [rbx]
    inc rcx
    mov [rbx], rcx

    jmp .done

.oom:
    lea rdi, [rel oom_msg]
    call puts
    mov edi, 1
    call exit

.done:
    add rsp, 32
    pop rbp
    ret
