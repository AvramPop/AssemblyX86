;27. A text file is given. The text file contains numbers (in base 10) separated by spaces. Read the content of the file, determine the minimum number (from the numbers that have been read) and write the result at the end of file.

bits 32 

global start        

extern exit, fopen, fclose, fread, printf, fprintf, fwrite
import exit msvcrt.dll 
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll
import fprintf msvcrt.dll
import fwrite msvcrt.dll

; our data is declared here 
segment data use32 class=data
file_name db "input.txt", 0   
    access_mode db "a", 0       
    file_descriptor dd -1      
min dd 0
    nume_fisier db "input.txt", 0 
nume_fisier_app db "input.txt", 0    
    mod_acces db "r", 0             
    appendMod db "a", 0
    descriptor_fis dd -1     
descriptor_fis_app dd -1     
    nr_car_citite dd 0              
    len equ 1        
one db 1    ;
    ten db 10
        hundred db 100
    formatmin db "min = %d ", 0
    format db "n = %d ", 0
    newline db " min = ", 0
    text db "", 0
    buffer resb len                 


; our code starts here
segment code use32 class=code
    start:
                ; open file reading mode
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
 ; if error jump to end
        cmp eax, 0                  
        je final
        
        mov [descriptor_fis], eax  
        mov ebx, 100000; ebx will hold the minimum
        mov edx, 0; edx will be the actual number read
        bucla:

            push edx ; save edx
            ; read first char in file
            push dword [descriptor_fis]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            
            pop edx ; retrieve edx
            cmp eax, 0   ; if final of file jump to end of loop          
            je end_loop

            mov [nr_car_citite], eax      
             ; save into eax the char read
            mov esi, buffer
            mov eax, 0 
            lodsb
            cmp eax, ' '
            ;if eax is space, compare the actual number to minimum, else buil the actual number
            je compare_to_min
            ; check if actual number  (in edx) is smaller than minimum (ebx). if true, assign_min
            jne build_actual_number
                
                compare_to_min:
                push edx ; save edx
            
                push dword edx
                push dword format 
                call [printf]     
                add esp, 4 * 2 
                
                pop edx ; retrieve edx
                
                cmp ebx, edx 
                
                ja assign_min
                mov edx, 0
                jmp bucla
                 ; append last digit read to actual number in edx
                    assign_min:
                    mov ebx, edx
                    mov edx, 0
                    jmp bucla
            
                build_actual_number:
                    sub eax, '0' ; eax = last digit read
                    mov ecx, eax ; save last digit read in ecx
                    mov eax, edx ; move into eax the number built until now
                    mul byte [ten] ; 
                    add eax, ecx ;eax = number build till now * 10 + last digit read
                    mov edx, eax ; save updated number in edx
                
            jmp bucla
        
            
        
      end_loop:
            push edx ; save edx
            
            push dword edx ;ebx holds min, edx holds actual number
            push dword format 
            call [printf]      
            add esp, 4 * 2 
            
            pop edx ; retrieve edx
            
            cmp ebx, edx ;ebx holds min, edx holds actual number
                
            ja assign_min1
            jmp cleanup
            
                assign_min1:
                mov ebx, edx
                jmp cleanup
        cleanup:
         ; close file reading mode
        
        push dword [descriptor_fis]
        call [fclose]
        add esp, 4
        ; open file append mode
                push dword ebx
            push dword formatmin 
            call [printf]      
            add esp, 4 * 2 

        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2              
        mov [file_descriptor], eax 
        cmp eax, 0
        je final
;print format for minimum in file
        push dword newline
                push dword [file_descriptor]
                call [fprintf]
                add esp, 4*2
                pop eax
        ;save minimum (ebx) into eax
        mov eax, ebx
        div byte [hundred]
         ;get hundreds digit of minimum. if existent, print to file
                        mov bh, ah
        cmp al, 0
        jne print_digit_in_al1
        jmp go_on1
            print_digit_in_al1:
         
                add al, '0'

                mov ah, 0
                mov [text], eax
                push eax
                push dword text
                push dword [file_descriptor]
                call [fprintf]
                add esp, 4*2
                pop eax
        
        go_on1:
        mov al, bh
        mov ah, 0
        div byte [ten]
          ;get tens digit of minimum. if existent, print to file
        mov bh, ah
        cmp al, 0
        jne print_digit_in_al2
        jmp go_on2
            print_digit_in_al2:
                add al, '0'

                mov ah, 0
                mov [text], eax
                push eax
                push dword text
                push dword [file_descriptor]
                call [fprintf]
                add esp, 4*2
                pop eax    
        go_on2:
        mov al, bh
        mov ah, 0
        div byte [one]
        ;get ones digit of minimum. if existent, print to file
        cmp al, 0
        jne print_digit_in_al3
        jmp go_on2
            print_digit_in_al3:
                add al, '0'
                mov ah, 0
                mov [text], eax
                push dword text
                push dword [file_descriptor]
                call [fprintf]
                add esp, 4*2
                 ; close file append mode
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

        
      final:  
        ; exit(0)
        push    dword 0      
        call    [exit]       