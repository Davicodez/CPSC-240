; input_array.asm
; void input_array(double **arr_ptr, long long *count_ptr, const char *label)
global input_array
extern printf
extern scanf
extern puts
extern isfloat
extern strtod
extern append

section .bss
; no globals

section .data
prompt1:     db "For array %s enter a sequence of 64-bit floats separated by white space.", 10, 0
prompt2:     db "After the last input press enter followed by Control+D:", 10, 0
invalid_msg: db "The last input was invalid and not entered into the array.", 10, 0
buf_fmt:     db "%1023s", 0
str_disp:    db "These number were received and placed into array %s:", 10, 0

section .text
input_array:
    push rbp
    mov rbp, rsp
    sub rsp, 1104           ; allocate local buffer area (~1024 + locals)

    mov [rbp-8], rdi        ; save arr_ptr
    mov [rbp-16], rsi       ; save count_ptr
    mov [rbp-24], rdx       ; save label

    ; print prompt1
    mov rdi, prompt1
    mov rsi, [rbp-24]       ; label
    xor rax, rax
    call printf

    mov rdi, prompt2
    xor rax, rax
    call puts

    ; buffer pointer at rbp-1104 (top of scratch)
    lea rbx, [rbp-1104]

.read_loop:
    ; scanf("%1023s", buf)
    mov rdi, buf_fmt
    lea rsi, [rbp-1104]
    xor rax, rax
    call scanf
    ; scanf returns number of items read in eax
    cmp eax, 1
    jne .done_read

    ; call isfloat with buffer
    lea rdi, [rbp-1104]
    call isfloat
    cmp rax, 0
    je .invalid

    ; valid: call strtod(buffer, NULL)
    lea rdi, [rbp-1104]
    mov rsi, 0
    call strtod          ; returns double in xmm0

    ; call append(&arr_ptr, &count_ptr, xmm0)
    mov rdi, [rbp-8]     ; arr_ptr
    mov rsi, [rbp-16]    ; count_ptr
    call append

    jmp .read_loop

.invalid:
    mov rdi, invalid_msg
    call puts
    jmp .read_loop

.done_read:
    ; print "These number were received..." line
    mov rdi, str_disp
    mov rsi, [rbp-24]
    xor rax, rax
    call printf

    ; cleanup
    add rsp, 1104
    pop rbp
    ret
