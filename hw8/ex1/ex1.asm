; 27. A character string is given (defined in the data segment). Read one character from the keyboard, then count the number of occurences of that character in the given string and display the character along with its number of occurences.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf               ; tell nasm that exit exists even if we won't be defining it
import printf msvcrt.dll
import scanf msvcrt.dll
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    string db 'The quick fox jumps over the lazy turtle'
    len dd ($ - string)
    characterMessage db 'character =', 0
    occurencesMessage db 'character %c appears %d times in string', 0 
    char dd 0
    format db '%c', 0

; our code starts here
segment code use32 class=code
    start:
        push dword characterMessage
        call [printf]
        add esp, 4 * 1
        
        push dword char
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        mov esi, string
        mov ebx, 0
        mov ecx, [len]
        cld
        fori:
            lodsb
            cmp al, [char]
            je increase_ebx
            jne go_on
            increase_ebx:
                inc ebx
            
            go_on:
            dec cx
            cmp cx, 0
            ja fori
         
        push dword ebx
        push dword [char]
        push occurencesMessage
        call [printf]
            
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
