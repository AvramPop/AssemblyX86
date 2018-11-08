; 8. Given the words A and B, compute the byte C as follows:
; the bits 0-5 are the same as the bits 5-10 of A
; the bits 6-7 are the same as the bits 1-2 of B.
; Compute the doubleword D as follows:
; the bits 8-15 are the same as the bits of C
; the bits 0-7 are the same as the bits 8-15 of B
; the bits 24-31 are the same as the bits 0-7 of A
; the bits 16-23 are the same as the bits 8-15 of A.
bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
    a dw 1101100001110010b
    b dw 1000111001100111b
    c db 0
    d dd 0
segment  code use32 class=code ; code segment
start:
    ; create C
	mov ax, [a] ;ax = A
    and ax, 0000011111100000b ;keep in ax just bits on 5-10 of A
    shr ax, 5 ;shift ax bits 5 positions right
    or [c], al ;5-10 of A become 0-5 of C  
    
    mov ax, [b] ; ax = B
    and ax, 0000000000000110b ;keep in ax bits 1-2 of B
    shl ax, 5; shift ax bits 5 positions left
    or [c], al ;1-2 of A become 6-7 of C 
    
    ;C done
    
    ;create D
    mov eax, 0
    mov al, [c] ; al = C
    shl eax, 8 ;shift eax bits 8 positions left
    or [d], eax ;  the bits 8-15 of D are the same as the bits of C
    
    mov eax, 0
    mov ax, [b] ;ax = B
    and ax, 1111111100000000b ; keep in ax just bits 8-15 of B
    shr ax, 8; shift ax 8 positions to right
    or [d], eax ; the bits 0-7 of D are the same as the bits 8-15 of B
    
    mov eax, 0
    mov ax, [a] ; ax = A
    and ax, 0000000011111111b ; keep in ax only bits 0-7 of A
    shl eax, 24 ; shift eax bits 24 positions left
    or [d], eax ; the bits 24-31 of D are the same as the bits 0-7 of A
    
    mov eax, 0
    mov ax, [a] ; ax = A
    and ax, 1111111100000000b ; keep in ax only bits 8 -15 of A
    shl eax, 8 ; shift eax 8 positions left
    or [d], eax
    ;D done 
    
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of
