extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XDrawPoint
extern XFillArc
extern XNextEvent
  
extern printf
extern exit

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16
%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1
%define NOMBRE 7

global main

section .bss
display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1
point:  resd    4
tab:    resd    10
D1:     resd    1
X2:     resd    1
X3:     resd    1
Y2:     resd    1
Y3:     resd    1
R1:     resd    1
R2:     resd    1
R3:     resd    1


section .data

couleurnb:    dd  0
event:		times	24 dq 0
nombre1:     db  NOMBRE

section .text

global aleatoire
aleatoire:
    push rbp
    
    coord_al:
        xor ax, ax
        rdrand ax 
        jnc coord_al 
    
    modulo:
        mov bx, di
        xor dx, dx
        div bx
        mov ax, dx

    stop:
    pop rbp
ret

global determinants
determinants:
    push rbp
    
        sub edx,edi
        mov dword[X2], edx 
        
        sub r8d,edi
        mov dword[X3], r8d 
        
        sub ecx,esi
        mov dword[Y2], ecx 
        
        sub r9d,esi
        mov dword[Y3], r9d
        

        mov eax, dword[Y3]
        mul dword[X2]
        mov dword[X2],eax
        
        mov eax, dword[Y2]
        mul dword[X3]
        mov dword[X3],eax
        
        mov eax, dword[X3]
        sub dword[X2], eax
        mov eax,dword[X2]
        
    arret:
    pop rbp
ret

global comparaison
comparaison:
    push rbp
        
        mov rax,1
        cmp ecx, 0
        jg indirect
        
        direct:
            cmp edi,0
            jl end
            cmp esi,0
            jl end
            cmp edx,0
            jl end
            mov rax,0
            jmp end
            
        indirect:
            cmp edi,0
            jg end
            cmp esi,0
            jg end
            cmp edx,0
            jg end
            mov rax,0
    
    end:
    pop rbp
ret

global couleur
couleur:
push rbp

    cmp r14d,4
    jge red
    
    cmp r14d,3
    jge green
    
    cmp r14d,2
    jge blue
    
    cmp r14d,1
    jge purple
    
    black:
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000
    call XSetForeground
    jmp ending
    
    purple:
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0xFF00FF
    call XSetForeground
    jmp ending

    blue:
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x0000FF
    call XSetForeground
    jmp ending
    
    green:
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x00FF00
    call XSetForeground
    jmp ending
    
    red:
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0xFF0000
    call XSetForeground

ending:
mov eax,r14d
pop rbp
ret

main:
xor     rdi,rdi
call    XOpenDisplay
mov     qword[display_name],rax

mov     rax,qword[display_name]
mov     eax,dword[rax+0xe0]
mov     dword[screen],eax

mov rdi,qword[display_name]
mov esi,dword[screen]
call XRootWindow
mov rbx,rax

mov rdi,qword[display_name]
mov rsi,rbx
mov rdx,10
mov rcx,10
mov r8,400
mov r9,400
push 0xFFFFFF
push 0x00FF00
push 1
call XCreateSimpleWindow
mov qword[window],rax

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,131077 
call XSelectInput

mov rdi,qword[display_name]
mov rsi,qword[window]
call XMapWindow

mov rsi,qword[window]
mov rdx,0
mov rcx,0
call XCreateGC
mov qword[gc],rax

mov rdi,qword[display_name]
mov rsi,qword[gc]
mov rdx,0x000000
call XSetForeground

boucle:
mov rdi,qword[display_name]
mov rsi,event
call XNextEvent

cmp dword[event],ConfigureNotify	
je dessin							

cmp dword[event],KeyPress			
je closeDisplay						
jmp boucle

dessin:

    mov r14d, dword[couleurnb]
    call couleur
    mov dword[couleurnb], eax
    
triangles:
    mov ecx,6
    mov esi, tab
    mov rdi,0
    mov rdi, 400

    boucle_al:
    call aleatoire
    mov word[esi],ax
    add esi,4
    loop boucle_al;

    
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000
    call XSetForeground
    

    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,[tab+0*DWORD]
    mov r8d,[tab+1*DWORD]	
    mov r9d,[tab+2*DWORD]	
    mov r12d,[tab+3*DWORD]	
    push r12	
    call XDrawLine


    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,[tab+0*DWORD]	
    mov r8d,[tab+1*DWORD]	
    mov r9d,[tab+4*DWORD]	
    mov r12d,[tab+5*DWORD]
    push r12		        
    call XDrawLine


    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,[tab+2*DWORD]
    mov r8d,[tab+3*DWORD]
    mov r9d,[tab+4*DWORD]
    mov r12d,[tab+5*DWORD]
    push r12		   
    call XDrawLine
    
    mov edi,[tab+0*DWORD]
    mov esi,[tab+1*DWORD]
    mov edx,[tab+2*DWORD]
    mov ecx,[tab+3*DWORD]
    mov r8d,[tab+4*DWORD]
    mov r9d,[tab+5*DWORD]
    call determinants
    
    mov dword[D1],eax


        mov dword[point+0*DWORD],0
        mov dword[point+1*DWORD],0

    
    passage0:
        mov dword[point+1*DWORD],0

    jump1:
        inc dword[point+1*DWORD]
        
            mov edi,[tab+0*DWORD] 
            mov esi,[tab+1*DWORD] 
            mov edx,[point+0*DWORD] 
            mov ecx,[point+1*DWORD] 
            mov r8d,[tab+2*DWORD] 
            mov r9d,[tab+3*DWORD]
            call determinants
            
            mov dword[R1], eax
            
            mov edi,[tab+4*DWORD] 
            mov esi,[tab+5*DWORD] 
            mov edx,[point+0*DWORD] 
            mov ecx,[point+1*DWORD] 
            mov r8d,[tab+0*DWORD] 
            mov r9d,[tab+1*DWORD] 
            call determinants
            
            mov dword[R2], eax
            
                        
            mov edi,[tab+2*DWORD] 
            mov esi,[tab+3*DWORD] 
            mov edx,[point+0*DWORD] 
            mov ecx,[point+1*DWORD] 
            mov r8d,[tab+4*DWORD] 
            mov r9d,[tab+5*DWORD] 
            call determinants
            
            mov dword[R3], eax
            
            mov edi, dword[R1]
            mov esi, dword[R2]
            mov edx, dword[R3]
            mov ecx, dword[D1]
            call comparaison
            
            cmp rax,1
            jge non_valide
            
            change_couleur:
            mov r14d, dword[couleurnb]
            call couleur
            mov dword[couleurnb], eax
            
            mov rdi,qword[display_name]
            mov rsi,qword[window]
            mov rdx,qword[gc]
            mov ecx,[point+0*DWORD]	
            mov r8d,[point+1*DWORD]	
            call XDrawPoint
            
        
        non_valide:
        cmp dword[point+1*DWORD], 400
        jl jump1
        
    
    jump2:
        inc dword[point+0*DWORD]

        cmp dword[point+0*DWORD], 400
        jge fin_boucle

        cmp dword[point+1*DWORD], 400
        jge passage0

        cmp dword[point+0*DWORD], 400
        jl jump2
    

    fin_boucle:
    cmp dword[couleurnb],4
    jge zero
    jmp suite
            
    zero:
    mov dword[couleurnb],0
            
    suite:
    inc dword[couleurnb]
    dec byte[nombre1]
    cmp byte[nombre1],0
    jg triangles

jmp flush




flush:
mov rdi,qword[display_name]
call XFlush
mov rax,34
syscall

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit
	
 
