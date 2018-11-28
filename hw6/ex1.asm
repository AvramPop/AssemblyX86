; 17. A string of doublewords is given. 
; Order in decreasing order the string of the low words (least significant) from these doubleword. 
; The high words (most significant) remain unchanged.
; being given
; sir DD 12345678h 1256ABCDh, 12AB4344h
; the result will be
; 1234ABCDh, 12565678h, 12AB4344h
bits 32 ;assembling for the 32 bits architecture
; the start label will be the entry point in the program
global  start 

extern  exit ; we inform the assembler that the exit symbol is foreign, i.e. it exists even if we won't be defining it

import  exit msvcrt.dll; exit is a function that ends the process, it is defined in msvcrt.dll
        ; msvcrt.dll contains exit, printf the other important C-runtime functions
segment  data use32 class=data ; the data segment where the variables are declared 
    sir dd 12345678h, 1256ABCDh,12AB4344h
    len db ($ - sir) / 4

segment  code use32 class=code ; code segment
start:
    mov ESI, sir
    mov EBX, 0 ; i = EBX
    mov EDX, 0 ; j = EDX
    mov ECX, [len]
    
    outer_for: ; for EBX = 0; EBX < len - 1; EBX++
        sub ECX, 1
        cmp EBX, ECX
        jb outer_for_loop ; compare i to len - 1
        jmp finish ; if outer for done
        
            outer_for_loop:
                add ECX, 1 ; substracted and re added 1 to len so that i can be compared to len - 1
                add EBX, 1
                mov EDX, EBX
                sub EBX, 1
                
                inner_for: ; for EDX = EBX + 1; EDX < len; EDX++
                    cmp EDX, ECX
                    jb inner_for_loop
                    jmp go_on_outer_for ; if outer for is done
                    
                        inner_for_loop:
                            mov ax, [sir + EBX * 4]  ; ax = the lower word of sir[EBX]
                            push ECX
                            mov cx, [sir + EDX * 4]  ; cx = the lower word of sir[EDX]

                            cmp ax, cx
                            jb interchange
                            jmp go_on_inner_for
                            
                                interchange:
                                    ;interchange lower words of sir[EBX] and sir[EDX]
                                    mov word [sir + EDX * 4], ax
                                    mov word [sir + EBX * 4], cx
                            go_on_inner_for:
                                pop ECX
                                add EDX, 1
                                jmp inner_for
                            
            go_on_outer_for:
                add EBX, 1
                jmp outer_for
                
    finish:
        
    
	push dword 0 ;saves on stack the parameter of the function exit
	call [exit] ; function exit is called in order to end the execution of
