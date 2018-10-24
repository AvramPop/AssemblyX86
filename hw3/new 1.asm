; Write a program in the assembly language that computes the following arithmetic expression, considering the following data types for the variables:
; a - byte, b - word, c - double word, d - qword - Unsigned representation
; ((a + b) + (a + c) + (b + c)) - d
bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a db 10
	b dw 30
	c dd 40
	d dq 50
    i dw 0
segment  code use32 class=code ; code segment
start: 	
	mov al, [a]
    mov ah, 0            ; unsigned conversion al to ax
    add ax, [b]           ; ax = a + b
    mov bx, ax          ; bx = ax = a + b
    
    mov al, [a]
    mov ah, 0
    mov dx, 0               ;unsigned conversion al to ax to dx:ax = a
    add ax, word [c]
    adc dx, word [c + 2]        ; dx:ax = a + c
    
    mov cx, 0                   ;unsigned conversion bx to cx:bx
    add ax, bx
    adc dx, cx                  ; dx:ax = dx:ax + cx:bx = a + b + a + c
    
    push dx
    push ax
    
    mov ax, [i]
    push ax
    mov ax, [b]
    push ax
    pop eax                         ;eax = b
    ;mov eax, 0
    ;mov eax, word [b]
    mov edx, 0                  ;edx:eax = b
    mov ebx, dword [d]   
    mov ecx, dword [d + 4]   ;ecx:ebx = d
    add eax, ebx
    adc edx, ecx                    ;edx:eax = edx:eax + ecx:ebx = b + d
    
    pop ebx                             ; ebx = dx:ax = a + b + a + c
    mov ecx, 0                         
    
    add eax, ebx
    adc edx, ecx                    ;edx:eax = edx:eax + ecx:ebx = a + b + a + c + b + d
    
    sub eax, dword [d]
    sbb edx, dword [d + 4]      ;edx:eax = ((a + b) + (a + c) + (b + c)) - d
    
    
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of