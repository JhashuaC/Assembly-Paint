.MODEL SMALL
.STACK 100H

.DATA
    X DW 38
    Y DW 38
    auxX DW 0
    auxY DW 0
    color DB 7
    auxColor DB 7
    borrar db 'borrar', '$'
    cargar db 'cargar', '$'
    guardar db 'guardar', '$'
    texto db '$                            ', 0
    colorFile db 'inter/color.txt', 0
    textIter dw 0
    fileHandle dw ?
    bytesRead dw ?
    fileChar db 1
    nameFile db 15 dup(0) 
    newline db 0Dh, 0Ah, '@'
    extension db ".txt", 0

PosCursor MACRO FIL, COL		
	mov AH, 02H
	mov BH, 00h
	mov DH, FIL
	mov DL, COL
	int 10h
ENDM

dibujar MACRO x, y, col
    mov AH, 0CH        
    mov AL, col
    mov BH, 00H      
    mov CX, x
    mov DX, y
    int 10h
ENDM

getPixel MACRO xCoord, yCoord
    mov AH, 0Dh
    mov AL, 00H
    mov BH, 00H
    mov CX, xCoord
    mov DX, yCoord
    int 10H
ENDM

.CODE
main proc FAR
    mov ax, @DATA
    mov ds, ax

    call interface

    mov AX, 0000H                 
    int 33H
    mov AX, 0001H                 
    int 33H

main_loop:
    call buttons
    call textArea
    call getMouse
    call checkLimit
    dibujar X, Y, color             

    mov AH, 01H                   
    int 16H
    jz main_loop                   
    
    call move
    call switchColor
    jmp main_loop
    
main endp



interface proc
    mov AH, 00H
    mov AL, 0Dh                     
    int 10h                         

interLoop1:
    dibujar X, Y, color
    inc X
    mov AX, X
    cmp AX, 240
    jbe interLoop1

    dec X
interLoop2:
    dibujar X, Y, color
    inc Y
    mov AX, Y
    cmp AX, 160
    jbe interLoop2

    dec Y
interLoop3:
    dibujar X, Y, color
    dec X
    mov AX, X
    cmp AX, 38
    jnb interLoop3

    inc X
interLoop4:
    dibujar X, Y, color
    dec Y
    mov AX, Y
    cmp AX, 38
    jnb interLoop4

    PosCursor 3, 5
	lea	DX, borrar
	mov	AH, 09H
	int	21H
    mov X, 38
    mov y, 22
    mov color, 04H
deleteLoop:
    getPixel X, Y
    cmp AL, 0FH
    je nextPixel1
    dibujar X, Y, color
nextPixel1:
    inc X
    cmp X, 88
    jng deleteLoop
    inc Y
    mov X, 38
    cmp Y, 32
    jng deleteLoop


    PosCursor 3, 14
    lea DX, cargar
    mov AH, 09H
    int 21H
    mov X, 110
    mov y, 22
    mov color, 01H
chargeLoop:
    getPixel X, Y
    cmp AL, 0FH
    je nextPixel2
    dibujar X, Y, color
nextPixel2:
    inc X
    cmp X, 160
    jng chargeLoop
    inc Y
    mov X, 110
    cmp Y, 32
    jng chargeLoop


    PosCursor 3, 23
    lea DX, guardar
    mov AH, 09H
    int 21H
    mov X, 182
    mov y, 22
    mov color, 02H
saveLoop:
    getPixel X, Y
    cmp AL, 0FH
    je nextPixel3
    dibujar X, Y, color
nextPixel3:
    inc X
    cmp X, 240
    jng saveLoop
    inc Y
    mov X, 182
    cmp Y, 32
    jng saveLoop


     posCursor 22, 5
    mov SI, textIter
    mov texto[SI], '$'
    lea DX, texto
    mov AH, 09H
    int 21H
    mov color, 7
    call text

    call colorsPalette

    mov X, 140
    mov Y, 100
    mov color, 01H
    ret
interface endp

colorsPalette proc
    mov AH, 3DH                   
    mov AL, 0
    lea DX, colorFile
    int 21h

    jc colorsPalleteFinalJMP         
    mov fileHandle, AX

    mov auxX, 260
    mov auxY, 38

readColorFile:
    mov AH, 3FH                    
    mov BX, fileHandle
    lea DX, fileChar
    mov CX, 1
    int 21h

    mov bytesRead, AX
    cmp bytesRead, 0                
    je closeColorsFile

    cmp fileChar, '@'                 
    je nxtLine

    jmp CtoCol

nxtLine:
    mov auxX, 260
    inc auxY
    jmp readColorFile

colorsPalleteFinalJMP:
    jmp colorsPaletteFinal

CtoCol:
    mov AL, fileChar

 
    cmp AL, '0'
    jl readColorFile                        
    cmp AL, '9'
    jle digit                       

    
    cmp AL, 'A'
    jl readColorFile                        
    cmp AL, 'F'
    jg readColorFile                         

   
    sub AL, 'A'                         
    add AL, 0Ah                        
    dibujar auxX, auxY, AL
    jmp nxtFilePixel

digit:
    
    sub AL, '0'                     
    dibujar auxX, auxY, AL

nxtFilePixel:
    inc auxX
    jmp readColorFile

closeColorsFile:
    MOV AH, 3Eh                    
    MOV BX, fileHandle
    INT 21h

colorsPaletteFinal:
    ret
colorsPalette endp

text proc
    mov auxX, 38
    mov auxY, 173
textLoop1:
    getPixel auxX, auxY
    cmp AL, 0FH
    je nextPixelText1
    dibujar auxX, auxY, color

nextPixelText1:
    inc auxX
    mov AX, auxX
    cmp AX, 240
    jbe textLoop1

    dec auxX
textLoop2:
    getPixel auxX, auxY
    cmp AL, 0FH
    je nextPixelText2
    dibujar auxX, auxY, color

nextPixelText2:
    inc auxY
    mov AX, auxY
    cmp AX, 185
    jbe textLoop2

    dec auxY
textLoop3:
    getPixel auxX, auxY
    cmp AL, 0FH
    je nextPixelText3
    dibujar auxX, auxY, color

nextPixelText3:
    dec auxX
    mov AX, auxX
    cmp AX, 38
    jnb textLoop3

    inc auxX
textLoop4:
    getPixel auxX, auxY
    cmp AL, 0FH
    je nextPixelText4
    dibujar auxX, auxY, color

nextPixelText4:
    dec auxY
    mov AX, auxY
    cmp AX, 173
    jnb textLoop4

    ret
text endp



buttons proc
    mov AX, 0003H                   
    int 33H

    cmp BX, 1                      
    jne buttonsFinal                
    shr CX, 1

;detectar boton borrar
borrar1:                          
    cmp CX, 38
    jng cargar1
borrar2:
    cmp CX, 88
    jge cargar1
borrar3:                           
    cmp DX, 22
    jng cargar1
borrar4:
    cmp DX, 32
    jge cargar1
    call cleanPaint

;detectar boton cargar
cargar1:
    cmp CX, 110
    jng guardar1
cargar2:
    cmp CX, 160
    jge guardar1
cargar3:
    cmp DX, 22
    jng guardar1
cargar4:
    cmp DX, 32
    jge guardar1
    call chargePaint
;detectar boton guardar

guardar1:
    cmp CX, 182
    jng buttonsFinal
guardar2:
    cmp CX, 240
    jge buttonsFinal
guardar3:
    cmp DX, 22
    jng buttonsFinal
guardar4:
    cmp DX, 32
    jge buttonsFinal
    call safeSketch

buttonsFinal:
    ret
buttons endp


;detecectar acciones del area de texto grafico
textArea proc

    mov AX, 0003H                  
    int 33H
    
    cmp BX, 1                      
    jne jumpFinal                   
    shr CX, 1

area1:
    cmp CX, 38
    jng jumpFinal
area2:
    cmp CX, 240
    jge jumpFinal
area3:
    cmp DX, 173
    jng jumpFinal
area4:
    cmp DX, 185
    jge jumpFinal

    mov CH, color                   
    mov auxColor, CH
    mov AX, 0002H                   
    int 33H

    mov color, 0BH
    call text

    mov AX, 0001H                  
    int 33H
    jmp writeChar

jumpFinal:
    jmp textAreaFinal               

writeChar:
    mov AH, 01H                    
    int 16H                       
    jz  noChar                     

    ; Si hay una tecla, leerla
    mov AH, 00H                     
    int 16H                         

    cmp AL, 13                     
    je  textAreaEnter              

    cmp AL, 8                       
    jne write
    
backSpace:
    cmp textIter, 0
    jbe writeChar                 

    mov SI, textIter
    mov texto[SI], 0
    mov texto[SI-1], '$'
    dec textIter
    jmp read

write:
    cmp textIter, 25               
    jae  writeChar                  

    ; Guardar la tecla en el buffer
    mov SI, textIter
    mov texto[SI+1], '$'            
    mov texto[SI], AL               
    inc textIter                   

read:
    call cleanText                 
    posCursor 22, 5
    lea DX, texto                   
    mov AH, 09H
    int 21h

noChar:
    jmp writeChar                  

textAreaEnter:
    mov color, 7
    mov AX, 0002H                   
    int 33H
    call text                      
    mov AX, 0001H                   
    int 33H
    mov CH, auxColor                
    mov color, CH

textAreaFinal:
    ret
textArea endp



cleanText proc
    mov CX, 25
    posCursor 22, 5
loopRead:
    mov AH, 0Eh
    mov AL, 00h
    int 10h
    dec CX
    cmp CX, 0
    jne loopRead
    ret
cleanText endp



cleanPaint proc
    mov auxX, 39
    mov auxY, 39

deletePaint:
    dibujar auxX, auxY, 00H
    inc auxX
    cmp auxX, 239
    jng deletePaint
    inc auxY
    mov auxX, 39
    cmp auxY, 159
    jng deletePaint

    ret
cleanPaint endp



chargePaint proc
    mov SI, textIter
    mov texto[SI], 0
    mov AH, 3DH                     
    mov AL, 0
    lea DX, texto
    int 21h

    jc chargePaintFinalJMP        
    mov fileHandle, AX

    mov BX, X
    mov auxX, BX
    mov BX, Y
    mov auxY, BX
    xor BX, BX

;ciclo para leer el archivo
readFile:
    mov AH, 3FH                  
    mov BX, fileHandle
    lea DX, fileChar
    mov CX, 1
    int 21h

    mov bytesRead, AX
    cmp bytesRead, 0              
    je closeFile

    cmp fileChar, '@'                
    je nextLine
    jmp charToColor

nextLine:
    mov BX, X
    mov auxX, BX
    inc auxY
    jmp readFile

chargePaintFinalJMP:
    jmp chargePaintFinal

charToColor:
    mov AL, fileChar
    cmp AL, '0'
    jl readFile                         
    cmp AL, '9'
    jle is_digit
   
    cmp AL, 'A'
    jl readFile                        
    cmp AL, 'F'
    jg readFile                       

    sub AL, 'A'                        
    add AL, 0Ah
    jmp paintPixel

is_digit:
    sub AL, '0'

paintPixel:
    cmp auxX, 240
    jge nextFilePixel
    cmp auxY, 160
    jge nextFilePixel
    cmp AL, 00h
    je nextFilePixel
    dibujar auxX, auxY, AL

nextFilePixel:
    inc auxX
    jmp readFile
closeFile:
    mov AH, 3Eh                    
    mov BX, fileHandle
    int 21h
    mov SI, textIter
    mov texto[SI], '$'

chargePaintFinal:
    ret
chargePaint endp



safeSketch PROC
    mov AX,0002h
    int 33h

    call concatFileName
    mov AH, 3ch
    mov CX, 0
    mov DX, offset nameFile
    int 21h
    jc error                   
    mov fileHandle, AX      

    mov X, 39
    mov Y, 39

begin:
    call readPixel
    inc Y
    cmp Y, 240
    jne begin

write_newline:
    call resetRegisters

    mov AH, 40h
    mov BX, fileHandle
    mov DX, offset newline
    mov CX, 3
    int 21h
    jc error

    inc X                   
    mov Y, 39                 
    cmp X, 160
    jne begin

fin:
    mov AX,0001h
    int 33h
error:
    ret
safeSketch ENDP

concatFileName PROC
   
    mov SI, 0                 
    mov DI, 0                 

copyStoredText:
    mov AL,texto[SI]     
    cmp AL, '$'                
    je addExtension            

    mov nameFile[DI], AL       
    inc SI                    
    inc DI                    
    jmp copyStoredText        

addExtension:
    lea SI, extension         
copyExtension:
    mov AL, [SI]
    mov nameFile[DI], AL
    inc SI
    inc DI
    cmp AL, 0
    jne copyExtension
 
    ret
concatFileName ENDP

resetRegisters PROC
    xor AX, AX
    xor BX, BX
    xor CX, CX
    xor DX, DX
    ret
resetRegisters ENDP

readPixel PROC
    call resetRegisters

    mov AH, 0dh
    mov BH, 00h
    mov CX, Y
    mov DX, X
    int 10h

    mov fileChar, AL
    call getPixelValue
   
    mov AH, 40h
    mov BX, fileHandle
    mov CX, 1
    mov DX, offset fileChar
    int 21h     

    ret
readPixel ENDP

getPixelValue PROC
   
    cmp fileChar, 9h
    jbe minor10
    add fileChar, 37h
    jmp finalizar

minor10:
    add fileChar, 30h

finalizar:
    ret
getPixelValue ENDP



getMouse proc
    mov AX, 0003H                   
    int 33H

    cmp BX, 1                      
    jne getMouseFinal               
    shr CX, 1

XBigLimit:                          
    cmp CX, 240
    ja getMouseFinal
XSmallLimit:
    cmp CX, 39
    jb getMouseFinal
YBigLimit:                          
    cmp DX, 160
    ja getMouseFinal
YSmallLimit:
    cmp DX, 39
    jb getMouseFinal

    dec CX                          
    dec DX
    mov Y, DX                      
    mov X, CX                       

getMouseFinal:
    ret
getMouse endp



checkLimit proc ; 

Xsurpassed:
    cmp X, 239
    ja lessX
Xsubpassed:
    cmp X, 39
    jb moreX
Ysurpassed:
    cmp Y, 159
    ja lessY
Ysubpassed:
    cmp Y, 39
    jb moreY

    jmp checkLimitFinal ;

lessX:
    dec X
    jmp Xsurpassed
moreX:
    inc X
    jmp Xsubpassed
lessY:
    dec Y
    jmp Ysurpassed
moreY:
    inc Y
    jmp Ysubpassed

checkLimitFinal:
    ret
checkLimit endp



move proc
    mov AH, 00H                   
    int 16H

    CMP AL, 'w'                     
    je pressW
    CMP AL, 's'    
    je pressS
    CMP AL, 'a'    
    je pressA
    CMP AL, 'd'   
    je pressD
    jmp moveFinal

pressW:                            
    dec Y   
    jmp moveFinal
pressS:
    inc Y   
    jmp moveFinal
pressA:
    dec X   
    jmp moveFinal
pressD:
    inc X   
    jmp moveFinal

moveFinal:
    ret
move endp



switchColor proc
    cmp AL, '0'
    jl switchColorFinal
    cmp AL, '9'
    jg switchColorFinal

    sub AL, '0'

    cmp AL, 7
    jne transformColor
    mov AL, 0FH

transformColor:
    mov color, AL

switchColorFinal:
    ret
switchColor endp
end