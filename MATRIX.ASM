.model small
.stack 64
.data

matrix db 1  , 2  , 5
       db 55 , 12 , 65
       db 124, 222, 12
       db 124, 10 , 12
cols dw 3
rows dw 4
ans dw 0 ;result
ten db 10
endl db 10, 13, '$'
.code
start proc far
    mov ax, @data
    mov ds, ax

    mov cx, rows
    xor bx, bx
    xor si, si

mainLoop: call rowCheck
          cmp dl, 1
          jne cont
          xor si, si
          push cx
          mov cx, cols
loop4: mov al, matrix[bx][si]
       xor ah, ah
       add ans, ax
       mov ax, ans
       inc si
       loop loop4
       pop cx
cont: add bx, cols
      loop mainLoop

      mov ax, ans
      call printAx
      ret   

start endp

;print value in ax register
printAx proc
          push bx cx ax dx
          mov  bx, 10
          xor  cx, cx
dgs: xor  dx, dx
     div  bx
     push dx
     inc  cx
     cmp  ax, 0
     jne  dgs
dgs_print:pop  dx
         add  dx, 30h
         mov  ah, 6
         int  21h
         loop dgs_print
         mov  ah, 9
         lea  dx, endl
         int  21h
         pop  dx ax cx bx
         ret
printAx endp
; dl = 1 if there is symetric number in row
rowCheck proc
    push cx bx ax si
    mov cx, cols
    xor si, si
    xor dl, dl
loop1: mov al, matrix[bx][si]
       call isSym
       cmp dh, 1
       je ok_case
       inc si
       loop loop1
       jmp out_proc
ok_case: inc dl
out_proc: pop si ax bx cx
          ret
rowCheck endp

; dh = 1 if number in al register is symetric
isSym proc
    push cx ax bx
    mov bl, al
    xor cx, cx
    mov dh, 1

loop2: xor ah, ah
       idiv ten
       push ax
       inc cx
       cmp al, 0
       je end2
       jmp loop2
end2: mov al, bl
loop3: xor ah, ah
       idiv ten
       pop bx
       cmp ah, bh
       je isok
       xor dh, dh
isok:  loop loop3
       pop bx ax cx
       ret
isSym endp
end start