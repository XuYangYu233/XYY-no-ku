DATAS	SEGMENT
BBUF    EQU     THIS WORD
BUF     DD      -0A62B89F0H, -739066ABH,11112222H,88889999H
TEMP    DW      0,0
STROUT  DB      10 DUP(0),'D',13,10,'$'
STRUD   DB      'the unsigned decimal number is:','$'
STRD    DB      'the signed decimal number is:','$'
STRUH   DB      'the unsigned hexadecimal number is:','$'
STRH    DB      'the signed hexadecimal number is:','$'
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

PUTCHAR MACRO   X
        PUSH    AX
        PUSH    DX
        MOV     DX, X
        MOV     AH, 2
        INT     21H
        POP     DX
        POP     AX
        ENDM

CODES	SEGMENT
        ASSUME	CS:CODES, DS:DATAS, SS:STACKS
START:
        MOV	AX, DATAS
        MOV	DS, AX
        MOV     CX, 4
        MOV     BP, 0
LBL_MA:
        MOV     BX, 'D'
        MOV     STROUT[10], BL
        ASMOUT  STRUD
        MOV     AX, BBUF[BP]
        MOV     DX, BBUF[BP+2]
        MOV     DI, 10
        CALL    DOUT
        ASMOUT  STRD
        CMP     DX, 0
        JNL     LBL_NL
        NEG     DX
        DEC     DX
        NEG     AX
        PUTCHAR '-'
LBL_NL:
        CALL    DOUT
        MOV     BX, 'H'
        MOV     STROUT[10], BL
        ASMOUT  STRUH
        MOV     AX, BBUF[BP]
        MOV     DX, BBUF[BP+2]
        MOV     DI, 16
        CALL    DOUT
        ASMOUT  STRH
        CMP     DX, 0
        JNL     LBL_NL2
        NEG     DX
        DEC     DX
        NEG     AX
        PUTCHAR '-'
LBL_NL2:
        CALL    DOUT
        PUTCHAR 10
        ADD     BP, 4
        DEC     CX
        CMP     CX, 0
        JE      EXIT
        JMP     LBL_MA
EXIT:
        MOV	AH, 4CH
        INT	21H

DOUT    PROC
        PUSH    AX
        PUSH    DX
        PUSH    CX
        MOV     CX, 10
        MOV     TEMP, DX
        MOV     TEMP[2], AX
LBL_DT: 
        MOV     AX, TEMP
        MOV     BX, DI
        XOR     DX, DX
        DIV     BX
        MOV     TEMP, AX
        MOV     AX, TEMP[2]
        DIV     BX
        MOV     TEMP[2], AX
        MOV     SI, CX
        DEC     SI
        MOV     BL, DL
        CMP     BL, 9
        JNA     LBL_NA
        ADD     BL, 37H
        JMP     LBL_A
LBL_NA:
        ADD     BL, 30H
LBL_A:
        MOV     STROUT[SI], BL
        MOV     AX, TEMP
        MOV     BX, TEMP[2]
        OR      AX, BX
        CMP     AX, 0
        JE      EXITD
        LOOP    LBL_DT
EXITD:
        MOV     BX, CX
        DEC     BX
        ASMOUT  STROUT[BX]
        POP     CX
        POP     DX
        POP     AX
        RET
DOUT    ENDP

CODES	ENDS
        END	START