codeseg segment  
	assume cs:codeseg
data:	
	db 9, 8, 7, 4, 2, 0		;sgn position
zero:   
	dw 0
start:	
	mov ah, 15
	int 10h
	mov ah, 0
	int 10h			;cls
	
	mov ax, cs
	mov ds, ax

	mov si, offset data
	mov di, 0

	mov dl, 47		;ASCII'/'
	mov cx, 6			;loop 6 times

s:	mov al, ds:[si]
	call show_what
	inc si
	cmp si, 3
	
	je hour
	cmp si, 6
	
	je null
	jmp year

null:	mov dl, 0
	jmp year

hour:	mov dl, 58 

year:	call show_how	
	add di, 6
	loop s
			
	mov ax, 4c00h
	int 21h   			;halt
			  
show_what:	
	push cx
	push ax 
	push si
			
	out 70h, al
	in al, 71h	
			
	mov ah, al
	mov cl, 4
	shr ah, cl			;right move
	and al, 00001111b
			
	add ah, 30h
	add al, 30h 
		
	mov si,offset zero		;dw 0
	mov ds:[si], ax  	    
			
	pop si 
	pop ax
	pop cx
	ret
			
show_how:
	push bx
	push ax
	push dx
	push di
	push si 
	
	mov bx, 0b800h
	mov es, bx 
	mov si, offset zero		;dw 0
	mov ax, ds:[si]
	mov byte ptr es:[160*24+di], ah
		
	;set green background
	mov ah, 2
	mov byte ptr es:[160*24+di+1], ah
		
	mov byte ptr es:[160*24+2+di], al 
	mov byte ptr es:[160*24+2+di+1], ah

	mov byte ptr es:[160*24+4+di], dl
	;mov byte ptr es:[160*24+4+di+1], ah
			 
	pop si
	pop di
	pop dx
	pop ax
	pop bx
	ret


codeseg ends
end start
