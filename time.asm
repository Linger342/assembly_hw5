dataseg segment
 	db 9,8,7,4,2,0
dataseg ends

code segment
	assume cs:code
start:
	mov ah, 15
	int 10h
	mov ah, 0
	int 10h

	mov bx,dataseg
	mov ds,bx
	mov si,0

	mov bx,0b800h
	mov es,bx
	mov di,160*12+30*2

	mov cx,6
s0:
	push cx
	mov al,ds:[si]
	push ax
	inc si
	out 70h,al
	in al,71h

	mov ah,al
	mov cl,4
	shr ah,cl
	and al,00001111b

	add ah,30h
	add al,30h

	mov byte ptr es:[di],ah
	add di,2
	mov byte ptr es:[di],al
	add di,2

	pop ax
	cmp al,0
	je over

	cmp al,7h
	je space
	
	ja slash

	jb comma

slash:
	mov ax,'/'
	jmp next
	
comma:
	mov ax,':'	
	jmp next
	
space:
	mov ax,' '
	jmp next
	
next:
	mov byte ptr es:[di],al
	add di,2
over:
	pop cx
	loop s0

	jmp start		;dead loop from beginning
	


mov ax,4c00h
int 21h
code ends
end start
