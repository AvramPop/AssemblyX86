bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db -10
    b db -25
    c db -70
    d db 20
    x db 0

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax
        mov al, [d]
        add al, [d]
        add al, [d]
        
        mov [d], ax
        
        xor eax, eax
        mov al, [a]
        sub al, [b]
        
        mov [a], al
        
        xor eax, eax
        mov al, [c]
        sub al, [d]
        add al, [a]
        
        mov [x], al
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
