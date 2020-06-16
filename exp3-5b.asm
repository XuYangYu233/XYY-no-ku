PUTCAHR MACRO   X
        PUSH    AX
        PUSH    DX
        MOV     DX, X
        MOV     AH, 2
        INT     21H
        POP     DX
        POP     AX
        ENDM

PUBLIC  DISP
EXTRN   TEMP:BYTE

CODES	SEGMENT USE16 PARA PUBLIC
        ASSUME	CS:CODES, DS:SEG TEMP
DISP    PROC    FAR
        PUSH    DX
        PUSH    BX
        PUSH    CX
        SHL     AX, 1
        JNC     FUHAO
        PUTCAHR '-'
        NEG	AX
FUHAO:  
        SHR     AX, 1
        MOV     CX, 5
LABLEB: 
        CMP     AX, 0
        JE      OUTER
        XOR     DX, DX
        MOV     BX, 0AH
        DIV     BX
        ADD     DX, 30H
        MOV     BX, CX
        DEC     BX
        MOV     TEMP[BX], DL
        LOOP    LABLEB
OUTER:
        MOV     BX, CX
        LEA     DX, TEMP[BX]
        MOV     AH, 9
        INT     21H
        JMP     EXIT
EXIT:   
        POP     CX
        POP     BX
        POP     DX
        RET
DISP    ENDP
CODES	ENDS
        END