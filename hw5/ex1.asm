; 26. Se da un sir de octeti S. Sa se determine maximul elementelor de pe pozitiile pare si minimul elementelor de pe pozitiile impare din S. 
; Exemplu:
; S: 1, 4, 2, 3, 8, 4, 9, 5
; max_poz_pare: 9
; min_poz_impare: 3
bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
    s db 1, 4, 2, 3, 8, 4, 9, 5
    lenS equ $-s
    max_even db 0
    min_odd db 0

segment  code use32 class=code ; code segment
start:
    mov ESI, 2 ; ESI = 2, will use ESI as index for the loop
                        ; first number goes as first max, second as first minimum, so we have what to compare to
    mov AL, [s]
    mov [max_even], AL
    mov AL, [s + 1]
    mov [min_odd], AL
    
    repeat:
        mov al, [s + esi] ; AL <- the byte from the offset s + ESI
        
        test ESI, 1 ; check whether ESI is odd (that is, the position we are currently at)
        jnz is_odd_position ;jump to is_odd_position label if index is odd
        jz is_even_position ;jump to is_even_position label if index is even
        
        is_odd_position:
            cmp al, [min_odd]
            jb assign_min_odd ;jump to assign_min_odd label if current value on odd index is smaller that the current minimum
            jmp go_on ;go to next iteration if didn't find new minimum
         
        is_even_position:
            cmp al, [max_even]
            ja assign_max_even ;jump to assign_max_even label if current value on even index is bigger that the current maximum
            jmp go_on ;go to next iteration if didn't find new maximum
            
        assign_min_odd:
            mov [min_odd], AL ; set the minumum to new minimum, which is in AL   
            jmp go_on ;go to next iteration
            
        assign_max_even:
            mov [max_even], AL ; set the minumum to new minimum, which is in AL
            jmp go_on ;go to next iteration 
        
        go_on: ; always execute this while iteration not done
            inc ESI ; ESI = ESI+1; move to the next index in string s
            cmp ESI, lenS
            jb repeat ;do until all s passed through
            
    ;the minimum on odd positions is stored in byte min_odd
    ;the maximum on even positions is stored in byte max_even    
    
	push   dword 0 ;saves on stack the parameter of the function exit
	call   [exit] ; function exit is called in order to end the execution of
