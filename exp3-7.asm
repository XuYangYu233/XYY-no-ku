DATAS	SEGMENT
WARY    EQU     THIS WORD
ARRAY   DD      20001008H,-20001002H,90001001H,10001005H
        DD      -80001000H,0AFFF8000H,0FFF6200H,-0F700500H
TEMP    DW      2 DUP(0)
STROUT  DB      10 DUP(0),'H ','$'
N       EQU     8
RESOR   DB      'the resource data is:','$'
SORTED  DB      'the sorted data is:','$'
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
        MOV     SI, 0
        ASMOUT  RESOR
LBL_BG:
        MOV     DI, 16
        MOV     CX, N
        MOV     BP, 0
LBL_OP: 
        MOV     AX, WARY[BP]
        MOV     DX, WARY[BP+2]
        CMP     DX, 0
        JNL     LBL_NL
        NEG     DX
        DEC     DX
        NEG     AX
        PUTCHAR '-'
LBL_NL:
        CALL    DOUT
        ADD     BP, 4
        LOOP    LBL_OP
        PUTCHAR 10
        CMP     SI ,1
        JE      EXIT
        MOV     CX, N-1
MAOPAO1:
        PUSH    CX
        MOV     BP, 0
        MOV     BX, 0
MAOPAO2: 
        MOV     AX, WARY[BP+2]
        MOV     DX, WARY[BP+6]
        CMP     DX, AX
        JL      M_L
        JG      M_PASS
        MOV     AX, WARY[BP]
        MOV     DX, WARY[BP+4]
        CMP     DX, AX
        JNL     M_PASS
M_L:
        INC     BX
        PUSH    WARY[BP]
        PUSH    WARY[BP+4]
        POP     WARY[BP]
        POP     WARY[BP+4]
        PUSH    WARY[BP+2]
        PUSH    WARY[BP+6]
        POP     WARY[BP+2]
        POP     WARY[BP+6]
M_PASS:
        ADD     BP, 4
        LOOP    MAOPAO2
        CMP     BX, 0
        JE      M_BRK
        POP     CX
        LOOP    MAOPAO1
M_BRK:
        ASMOUT  SORTED
        INC     SI
        JMP     LBL_BG
EXIT:
        MOV	AH, 4CH
        INT	21H

DOUT    PROC
        PUSH    SI
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
        POP     SI
        RET
DOUT    ENDP

CODES	ENDS
        END	START