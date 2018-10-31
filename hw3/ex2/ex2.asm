; Write a program in assembly language which computes one of the following arithmetic expressions, considering the following domains for the variables: 
; a - byte, b - word, c - double word, d - qword - Signed representation
; (a + b + c) - d + (b - c)
bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a db 12
	b dw 2
	c dd 15
	d dq 20
	
segment  code use32 class=code ; code segment
start: 
	mov al, [a]
    cbw
    add ax, [b] ;ax = a + b
    cwd
    
    mov bx, word [c]
    mov cx, word [c + 2]
    
    add ax, bx
    adc dx, cx ;dx:ax = a + b + c
    
    push dx
    push ax
    pop eax
    cdq
    
    sub eax, dword [d]
    sbb edx, dword [d + 4] ;edx:eax = (a + b + c) - d
    
    push edx
    push eax
    
    mov ax, [b]
    cwd
    mov bx, word [c]
    mov cx, word [c + 2]
    
    sub ax, bx
    sbb dx, cx ;dx:ax = b - c
    
    push dx
    push ax
    pop ebx
    mov ecx, 0
    
    pop eax
    pop edx
    
    add eax, ebx
    adc edx, ecx ;edx:eax = (a + b + c) - d + (b - c)
	
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of