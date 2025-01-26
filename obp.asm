datasg SEGMENT PARA 'veri'
    n DW 4
    vize DB 77,85,64,96
    final DB 56,63,86,74
    obp DB 4 DUP(?)
datasg ENDS

stacksg SEGMENT PARA STACK 'yigin'
    DW 20 DUP(?)
stacksg ENDS

codesg SEGMENT PARA 'kod'
    ASSUME DS:datasg,SS:stacksg,CS:codesg
    MAIN PROC FAR
        PUSH DS
        XOR AX,AX
        PUSH AX
        MOV AX,datasg
        MOV DS,AX

    ;OBP DİZİSİNİN DEĞERLEİRİNİ BULMA
        XOR SI,SI ;kod içerisinde
        MOV CX,n 
    L1: XOR BX,BX
        XOR AX,AX
        MOV DL,4
        MOV AL,vize[SI]
        MUL DL ; BURASI VİZE İÇİN AĞIRLIKLI ÇARPMANIN YAPILDIĞI YER 
        ADD BX,AX
        MOV DL,6
        MOV AL,final[SI]
        MUL DL; BURASI FİNAL İÇİN AĞIRLIKLI ÇARPMANIN YAPILDIĞI YER
        ADD BX,AX
        XCHG AX,BX
        MOV DL,10
        DIV DL
        ;MOV DL,5
        CMP AH,5 
        JNA ortak
        INC AL
    ortak:MOV obp[SI],AL
        INC SI 
        LOOP L1

    ;OBP DİZİNİ SORTLAMA

        MOV DX, n          
        DEC DX            
    OUTER_LOOP:
        MOV CX, DX         
        MOV SI, 0         

    INNER_LOOP:
        MOV AL, obp[SI]   
        CMP AL,obp[SI+1]
        JAE NOSWAP        

        
        XCHG AL, obp[SI+1]
        MOV obp[SI], AL

    NOSWAP:
        INC SI             
        LOOP INNER_LOOP    

        DEC DX             
        JNZ OUTER_LOOP   

    MOV AX, 4C00h
    INT 21h
    MAIN ENDP
codesg ENDS
    END MAIN