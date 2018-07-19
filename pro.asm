.model small
.stack 100h
.data
;----------------Struct Start--------------
employee struct
ename DB 20 DUP(0)
empid DB 4 dup(0)
empSal DB 6 dup(0)
employee ENDs 
E1 employee <>
;----------------Struct end-----------------
;----------------Data------------------
BUFFER DB  512 DUP(?),"$"
newfile Db 'name.txt',0
handle DW  ?
again DB "Enter Employee Name Again: $"
AGAIN1 DB "Enter Employee Salary Again: $"
msg15 DB "File Created..!!$"
ERRor DB "Invalid Entry!$"
filename db "name.txt",0
handler dw '?'
linefeed db 13, 10
succ DB "Data written Successfully..!!$"
msg1 DB "Enter Employee Name: $"
msg2 DB "Enter Employee ID: $"
msg13 DB "Enter Employee Salary: $"
msg3 DB "Press 1 to Enter records.$"
msg4 DB "Press 2 to Delete file.$"
msg5 DB "Press 3 to Display record.$"
msg6 DB "Wrong choice!$"
msg7 DB "Do you Want to Continue?<y\n>$"
msg8 DB "                 ***************Exit Successful****************$"
msg9 DB "             ***************Employee Record System****************$"
msg10 DB "Enter File Name: $"
msg11 DB "File Delete Successfull..!!$"
msg12 DB "Press 5 to Exit.$"
msg14 DB "Press 4 to Create new file.$"
end1 DB 13

;------------------Data End------------------
.code          
main PROC
;LINECHANGE
linechange MACRO 
PUSH ax
PUSH bx
PUSH cx
PUSH dx
MOV ah,2
MOV dl,10
INT 21h
MOV ah,2
MOV dl,13
INT 21h
POP dx 
POP cx
POP bx
POP ax
ENDM 
mov  ax,@data
mov  ds,ax
MOV ES,AX 

MOV ah,9
MOV dx,offset MSG9
INT 21h
LINECHANGE 



;ClearScreen
clr MACRO
PUSH ax
PUSH bx
PUSH cx
push dx
Mov ax,0003h
Int 10h 
POP dx
POP cx
POP bx
POP ax
ENDM 
  
;Printing menu
start:


LINECHANGE 
MOV ah,9
MOV dx,offset MSG3  
INT 21h
LINECHANGE 

MOV ah,9
MOV dx,offset MSG4   
INT 21h
LINECHANGE

MOV ah,9
MOV dx,offset MSG5   
INT 21h
LINECHANGE

MOV ah,9
MOV dx,offset MSG14   
INT 21h
LINECHANGE

MOV ah,9
MOV dx,offset MSG12   
INT 21h
LINECHANGE


;--------------------Ask For Choice---------------------------
MOV ah,1
INT 21h
CLR 
MOV ah,9
MOV dx,offset MSG9
INT 21h
LINECHANGE 

cmp al,'1'
JE Ent
CLR 

cmp al,'2'
JE DELETE 

CMP al,'3'
JE DISP  

CMP al,'4'
JE create_file 

CMP al,'5'
je EXIT 

JNE wrong
;------------------End Asking Choice------------------


;-------------------Writing String In File------------------
Ent:

LEA DI,E1.ENAME
XOR AX,AX
MOV CX,20
REP STOSB


LEA DI,E1.Empid
XOR AX,AX
MOV CX,4
REP STOSB


LEA DI,E1.Empsal
XOR AX,AX
MOV CX,6
REP STOSB




;CREATE FILE.
mov  dx, offset filename
mov  ah, 3dh
;mov  cx, 0
MOV al,02h
int  21h    
mov  handler, ax

MOV ah,9
MOV dx,offset MSG1 
INT 21h
LINECHANGE
 
MOV DI,OFFSET E1.ename
MOV CX,LENGTHOF E1.ename
INPUTNAME:
MOV AH,1
INT 21H
CMP AL,13
JE emp 
CMP al,'A'
JL @JUMP1 
CMP al,'z'
JG @JUMP1 
STOSB
LOOP INPUTNAME

emp: 
INC di
MOV E1.ename[di]," "
MOV ah,9
MOV dx,offset MSG2  
INT 21h
LINECHANGE  

MOV DI,OFFSET E1.empid
MOV CX,LENGTHOF E1.empid

INPUTID:

MOV AH,1
INT 21H
CMP AL,13
JE EMP1  
STOSB
LOOP INPUTID  

emp1:
INC di
MOV E1.empid[di]," "
MOV ah,9
MOV dx,offset MSG13   
INT 21h
LINECHANGE 

MOV DI,OFFSET E1.empsal
MOV CX,LENGTHOF E1.empsal
INPUTSal:

MOV AH,1
INT 21H
CMP AL,13
JE WRITE  

CMP al,'0'
JL @JUMP 
CMP al,'9'
JG @JUMP 

STOSB
LOOP INPUTSAL 

;WRITE STRING.
write:
CALL SEEK_EOF ;move pointer to EOF 

mov  ah, 40h
mov  bx, handler
mov  cx, lengthof LINEFEED    
mov  dx,offset LINEFEED  
int  21h


mov  ah, 40h
mov  bx, handler
mov  cx, lengthof E1.ename   
mov  dx,offset E1.ename  
int  21h

        
mov  ah, 40h
mov  bx, handler
mov  cx, lengthof E1.empid   
mov  dx,offset E1.empid  
int  21h


mov  ah, 40h
mov  bx, handler
mov  cx, lengthof E1.empsal   
mov  dx,offset E1.empsal  
int  21h

MOV ah,3eh
MOV bx,handler
INT 21h
 
CLR
MOV ah,9
MOV dx,offset MSG9
INT 21h
LINECHANGE 

MOV ah,9
MOV dx,offset succ
INT 21h



JMP START   
;-----------------End Writing------------------ 

 
;-----------------Asking Continue or not------------                              
;ContinueCheck:
;MOV ah,9
;MOV dx,offset MSG7   
;INT 21h
;LINECHANGE
;
;MOV ah,1
;INT 21h
;CLR 
;
;MOV ah,9
;MOV dx,offset MSG9 
;INT 21h
;LINECHANGE 
;
;CMP al,'y'
;JE ENT  
;CLR 
;MOV ah,9
;MOV dx,offset MSG9
;INT 21h
;LINECHANGE 
;
;CMP al,'n'
;JE START  
;JMP WRONG 
;
@JUMP1:
CLR 
MOV DI,OFFSET E1.ename
MOV CX,LENGTHOF E1.ename
LINECHANGE
MOV ah,9
MOV dx,offset ERROR 
INT 21h
LINECHANGE
MOV ah,9
MOV dx,offset again
INT 21h 
JMP INPUTNAME        
@jump:
CLR 
LINECHANGE 
MOV ah,9
MOV dx,offset ERROR 
INT 21h
MOV DI,OFFSET E1.empsal
MOV CX,LENGTHOF E1.empsal

LINECHANGE 
MOV ah,9
MOV dx,offset again1
INT 21h 


JMP INPUTSAL  
;check:
;CMP al,'9'
;JG @jump    
;
wrong:
MOV ah,9
MOV dx,offset MSG6   
INT 21h
LINECHANGE
JMP START




;----------------create_file--------
create_file:
MOV ah,3ch
mov dx,offset FILENAME  
MOV cx,0
INT 21h
MOV HANDLER ,ax
JC PROMPT 
MOV ah,9
MOV dx,offset msg15
INT 21h
JMP START 




;-----------error--------
prompt:
MOV ah,9
MOV dx,offset ERRor
INT 21h
JMP START 
;--------------Delete File Function----------------
delete:

MOV ah,9
MOV dx,offset MSG10 
INT 21h

lea si, filename
mov ah, 01h      
char_input:
int 21h
cmp al, 0dh      
je zero_terminator
mov [si], al
inc si
jmp char_input
zero_terminator:
mov byte ptr [si], 0

mov ah,41h 
lea dx,filename 
int 21h 
LINECHANGE 
CLR 
MOV ah,9
MOV dx,offset MSG9
INT 21h
LINECHANGE 



MOV ah,9
MOV dx,offset MSG11
INT 21h  
LINECHANGE
JMP START
;---------------End Delete File Function---------------  


;-----------------Display Records---------------------
Disp:
JC PROMPT  
mov  ah, 3eh
mov  bx, handler
int  21h 
CALL OPEN_FILE_READING 
CALL READ_FROM_THE_FILE 
MOV ah,9
INT 21h
CALL CLOSE_FILE_READING 
JMP START 
;-----------End Display Records------------------------


;------------Exit-------------------------------
exit:
MOV ah,9
MOV dx,offset MSG8
INT 21h

mov  ah, 3eh
mov  bx, handler
int  21h 
mov  ax,4c00h
int  21h           
;--------------Exit End------------------------


MAIN ENDP


;---------------Move pointer to EOF Function---------------
SEEK_EOF PROC 
MOV AH,42H
MOV BX,HANDLER
XOR CX,CX
XOR DX,DX
MOV AL, 2
INT 21H 

RET 
SEEK_EOF ENDP 
;---------------------End of Function---------------------


;--------------------Open File For Reading------------------
OPEN_FILE_READING PROC 
MOV al,0     		
MOV ah,3dh   		
LEA dx, NEWFILE   
INT 21h
JC EXIT 
MOV HANDLE,ax
MOV BX, HANDLE  

EXIT:
RET 
OPEN_FILE_READING  ENDP
;----------------End of Function--------------------


;-----------------Read From File---------------------
READ_FROM_THE_FILE PROC 
MOV ah,3FH
MOV cx,LENGTHOF BUFFER
LEA DX,BUFFER 
MOV bx,HANDLE
INT 21H
 
RET
READ_FROM_THE_FILE ENDP
;----------------End of Function---------------------


;---------------------Close File For Reading----------------
Close_File_READING proc
MOV ah,3eh
MOV bx,handle
INT 21h
JC @CLOSE_ERROR

TEMP_JUMP:

RET
 
@CLOSE_ERROR:
JMP TEMP_JUMP 
 
CLOSE_FILE_READING  ENDP
;------------------End of function----------------------
END MAIN
;temp DW ?
;special DB  ?




