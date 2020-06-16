DATAS	SEGMENT
BUF     DW      6F80H, 98B0H, -74ABH, -0F88AH
N       EQU     $ - 0
TEMP    DB      5 DUP(0), 13, 10, '$'
UNDER   DB      2DH,'$'
DATAS	ENDS

STACKS	SEGMENT
        DW      128 DUP(0)
STACKS	ENDS

ASMOUT  MACRO   X
        PUSH    AX
        PUSH    DX
        LEA     DX, X
        MOV     AH, 9
        INT     21H
        POP     DX
        POP     AX
        ENDM

CODES	SEGMENT
        ASSUME	CS:CODES, DS:DATAS, SS:STACKS
START:
        MOV	AX, DATAS
        MOV	DS, AX
        MOV     AX, STACKS
        MOV     SS, AX
        MOV     AX, N
        MOV     CX, TYPE WORD
        DIV     CL
        MOV     CX, AX
        MOV     BX, OFFSET BUF
LABLEA: 
        MOV     AX, [BX]
        CALL    H2D
        ADD     BX, TYPE WORD
        LOOP    LABLEA
        MOV	AH, 4CH
        INT	21H

H2D     PROC
        PUSH    DX
        PUSH    BX
        SHL     AX, 1
        JNC     FUHAO
        ASMOUT  UNDER
        NEG	AX
FUHAO:  
        SHR     AX, 1
        PUSH    CX
        MOV     CX, 5
LABLEB: 
        XOR     DX, DX
        MOV     BX, 0AH
        DIV     BX
        ADD     DX, 30H
        MOV     BX, CX
        DEC     BX
        MOV     TEMP[BX], DL
        CMP     AX, 0
        JE      GCK
        LOOP    LABLEB
GCK:
        POP     CX
        ASMOUT  TEMP[BX]
EXIT:   
        POP     BX
        POP     DX
        RET
H2D     ENDP

CODES	ENDS
        END	START