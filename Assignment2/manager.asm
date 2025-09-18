;****************************************************************************************************************************
;Program name: "Arrays".  This program calculates for the third side of a triangle based on the user's input for the other two sides and the angle between them
; Copyright (C) 2024  Davielle Gilzean.          *
;                                                                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.  This program is distributed in the hope that it will be useful,   *
;but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See   *
;the GNU General Public License for more details A copy of the GNU General Public License v3 is available here:             *
;<https://www.gnu.org/licenses/>.                                                                                           *
;****************************************************************************************************************************




;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;Author information
;  Author name: Davielle Gilzean
;  Author email: daviellegilzean@csu.fullerton.edu
;  CWID: 885397638
;  Class: 240-15 Section 15
;
;Program information
;  Program name: Arrays
;  Programming languages: One module in C, one in X86, and one in bash.
;  Date program began: 2025-Sep-18
;  Date of last update: 2025-Sep-18
;  Files in this program: append.asm, input_array.asm, int_to_double.c, manager.asm, magnitude.asm, mean.asm, display_array.asm, main.c, Makefile, marco.inc
;  Testing: Alpha testing completed.  All functions are correct. TODO: UPDATE THIS
;  Status: Not Ready for release to customers
;
;Purpose
;  This program is a driving time, speed, and distance calculator based on the user's input
;
;This file:
;  File name: compute_triangle.asm
;  Language: X86-64
;  Max page width: 124 columns
;  Assemble (standard): nasm -f elf64 -l 
;  Assemble (debug): nasm -f elf64 -gdwarf -l 
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: 
; 
;
;
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**

; manager.asm
; double manager(void);
global manager
extern input_array
extern display_array
extern magnitude
extern mean
extern int_to_double   ; C helper to convert integer to double
extern printf
section .data
newline: db 10,0
append_msg: db "Arrays A and B have been appended and given the name A\xE2\x8A\x95B.", 10, 0
mag_msgA: db "The magnitude of array %s is %.6f", 10, 0
mag_msgAB: db "The magnitude of A\xE2\x8A\x95B is %.5f", 10,0
mean_msg: db "The mean of A\xE2\x8A\x95B is %.5f", 10, 0
disp_header: db "A\xE2\x8A\x95B contains", 10,0

section .bss
; reserve locals in stack instead of bss

section .text
manager:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    ; Reserve storage on stack:
    ; [rbp-8]  => arrA pointer (8)
    ; [rbp-16] => countA (8)
    ; [rbp-24] => arrB pointer
    ; [rbp-32] => countB
    ; [rbp-40] => saved magnitude
    mov qword [rbp-8], 0
    mov qword [rbp-16], 0
    mov qword [rbp-24], 0
    mov qword [rbp-32], 0

    ; Call input_array(&arrA, &countA, "A")
    lea rdi, [rbp-8]
    lea rsi, [rbp-16]
    lea rdx, [rel a_label]
    call input_array

    ; display_array(arrA, countA)
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    call display_array

    ; magnitude(arrA, countA)
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    call magnitude
    ; xmm0 has magnitude A — print it (6 decimal places as sample)
    mov rdi, mag_msgA
    lea rsi, [rel a_label]
    ; move xmm0 to stack for printf as parameter (printf expects double in xmm register automatically)
    ; call printf
    xor rax, rax
    call printf

    ; Input B
    lea rdi, [rbp-24]
    lea rsi, [rbp-32]
    lea rdx, [rel b_label]
    call input_array

    ; display B
    mov rdi, [rbp-24]
    mov rsi, [rbp-32]
    call display_array

    ; magnitude(B)
    mov rdi, [rbp-24]
    mov rsi, [rbp-32]
    call magnitude
    ; print magnitude B (reuse mag_msgA but label B)
    mov rdi, mag_msgA
    lea rsi, [rel b_label]
    xor rax, rax
    call printf

    ; Append B elements into A
    mov rcx, [rbp-32]      ; rcx = countB
    xor rdx, rdx           ; index = 0
.append_loop:
    cmp rdx, rcx
    jge .append_done
    mov rax, [rbp-24]      ; arrB base
    mov r8, rdx
    imul r8, 8
    add rax, r8
    movsd xmm0, [rax]      ; xmm0 = B[index]

    lea rdi, [rbp-8]       ; &arrA
    lea rsi, [rbp-16]      ; &countA
    call append

    inc rdx
    jmp .append_loop
.append_done:

    ; print append message
    mov rdi, append_msg
    xor rax, rax
    call printf

    ; print header "A⊕B contains"
    mov rdi, disp_header
    xor rax, rax
    call printf

    ; display A⊕B
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    call display_array

    ; magnitude(A⊕B)
    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    call magnitude
    ; save mag into stack area
    movsd [rbp-40], xmm0

    ; print magnitude (5 decimal)
    mov rdi, mag_msgAB
    xor rax, rax
    call printf

    ; compute mean: first produce double count via int_to_double
    mov rdi, [rbp-16]      ; arg to int_to_double (integer count)
    call int_to_double     ; returns double in xmm0

    ; now call mean(arrA, count_int) expecting integer count in rsi and double in xmm0
    mov rdi, [rbp-8]       ; arr
    mov rsi, [rbp-16]      ; integer count
    ; xmm0 currently has double count as returned by int_to_double
    call mean
    ; xmm0 -> mean (double)

    ; print mean
    mov rdi, mean_msg
    xor rax, rax
    call printf

    ; load saved magnitude into xmm0 to return to main
    movsd xmm0, [rbp-40]

    add rsp, 128
    pop rbp
    ret

section .rodata
a_label: db "A",0
b_label: db "B",0
