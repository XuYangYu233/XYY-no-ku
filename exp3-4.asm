DATAS	SEGMENT
ARY     DW      100H,250AH,0FF88H,8660H,40H,9500H,6000H,1200H,8008H,0A200H,2800H,0FF60H,0F50H
N       EQU     13
V       DW      1 DUP(0)
COUN    DB      1 DUP(0)
NUMBS   DB      'these numbers are:',13,10,'$'
AVR     DB      'the average is:',13,10,'$'
HIGHER  DB      'number of the numbers above average is:',13,10,'$'
ENDLINE DB      13,10,'$'
DATAS	ENDS

STACKS	SEGMENT
        DW      128 DUP(0)
STACKS	ENDS

PUTS    MACRO   X
        PUSH    AX
        PUSH    DX
        LEA     DX, X
        MOV     AH, 9
        INT     21H
        POP     DX
        POP     AX
        ENDM

PUTCAHR MACRO   X
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
        PUTS    NUMBS           ;第一部分
        MOV     CX, N
        MOV     DX, 0
        MOV     BX, 0
        LEA     SI, ARY
LABELA: 
        MOV     AX, [SI]
        ADD     BX, AX
        JNO     LBL_DIS
        CMP     AX, 0
        JNL     LBL_NL
        DEC     DX
        JMP     LBL_DIS
LBL_NL:
        INC     DX
LBL_DIS:
        CALL    DISP
        DEC     CX
        CMP     CX, 0
        JE      EXITM1
        PUTCAHR ','
        ADD     SI, 2
        JMP     LABELA
EXITM1:
        PUTS    ENDLINE
        PUTS    AVR             ;第二部分
        MOV     AX, BX
        MOV     BX, N
        IDIV    BX
        MOV     V, AX
        CALL    DISP
        PUTS    ENDLINE
        PUTS    HIGHER
        MOV     CX, N
        MOV     DX, V
        XOR     AX, AX
        LEA     SI, ARY
LABELB: 
        MOV     BX, [SI]
        CMP     BX, DX
        JNG     LBL_NG
        INC     AX
LBL_NG:
        ADD     SI, 2
        LOOP    LABELB
        CALL    DISP
        MOV	AH, 4CH
        INT	21H

DISP    PROC
        PUSH    DX
        PUSH    BX
        PUSH    CX
        MOV     BP, 0
        CMP     AX, 0
        JNL     ZHENG
        PUTCAHR '-'
        NEG	AX
ZHENG:  
        MOV     CX, 5
GEWEI: 
        CMP     AX, 0
        JE      EXITG
        XOR     DX, DX
        MOV     BX, 10
        DIV     BX
        ADD     DL, 30H
        PUSH    DX
        INC     BP
        LOOP    GEWEI
EXITG:
        MOV     CX, BP
        CMP     CX, 0
        JNE     SHUCHU
        PUTCAHR '0'
        JMP     EXITD
SHUCHU: 
        POP     AX
        PUTCAHR AX
        LOOP    SHUCHU
EXITD:
        POP     CX
        POP     BX
        POP     DX
        RET
DISP    ENDP

CODES	ENDS
        END	START