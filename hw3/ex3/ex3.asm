; Write a program in assembly language which computes one of the following arithmetic expressions, considering the following domains for the variables: 
; a-(7+x)/(b*b-c/d+2) - unsigned representation
; a-doubleword; b,c,d-byte; x-qword
bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
	a dd 100
	b db 2
	c db 50
	d db 20
    x dq 5
    i dw 0
	
segment  code use32 class=code ; code segment
start: 
	mov eax, [x]
    mov edx, [x + 4] ; edx:eax = x
    mov ebx, 7
    mov ecx, 0
    
    add eax, ebx
    adc edx, ecx ; edx:eax = x + 7
    
    push edx
    push eax
    
    mov eax, 0
    mov edx, 0
    mov al, [b]
    mul byte [b]
    mov bx, ax ; bx = b * b
    
    mov al, [c]
    mov ah, 0
    mov dl, [d]
    div dl ; al = c/d
    mov ah, 0
    
    sub bx, ax
    add bx, 2 ; bx = b * b - c/d + 2
    
    push word [i]
    push bx
    pop ebx
    
    pop eax
    pop edx
    div ebx ; eax = (x + 7) /  (b * b - c/d + 2)
    
    mov ebx, [a]
    sub ebx, eax ; ebx = a-(7+x)/(b*b-c/d+2) 
	
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of