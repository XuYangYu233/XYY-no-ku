DATAS	SEGMENT
BUF     DW      100 DUP(0)
TEMP    DB      4
COUNT   DB      0
TMPSTR  DB      4 DUP(0),'$'
INPSTR  DB      'please input number(0-999):','$'
NCHSTR  DB      'non-numeric character found!',13,10,'$'
STCSTR  DB      'the statistics result is:',13,10,'$'
ENDL    DB      13,10,'$'
QUJIAN  DB      10 DUP(0)
QUJSTR  DB      '000<=~<=099:','$'
DATAS	ENDS

STACKS	SEGMENT
        DW      128 DUP(0)
STACKS	ENDS

INOUT   MACRO   X, Y
        LOCAL   LBL_2, LBL_910
        PUSH    AX
        PUSH    DX
        MOV     DL, 2
        CMP     DL, Y
        JE      LBL_2
        LEA     DX, X
        JMP     LBL_910
LBL_2:
        MOV     DL, X
LBL_910:
        MOV     AH, Y
        INT     21H
        POP     DX
        POP     AX
        ENDM

CODES	SEGMENT
        ASSUME	CS:CODES, DS:DATAS, SS:STACKS
START:
        MOV	AX, DATAS
        MOV	DS, AX
        MOV     BP, 0
        CALL    GETDT
        MOV     AX, 20H
        MOV     TMPSTR[3], AL
        CALL    PUTALL
        INOUT   ENDL, 9
        CALL    SELECT
        MOV	AH, 4CH
        INT	21H

GETDT   PROC 
        MOV     CX, 100
LGD_L:
        PUSH    CX
        INOUT   INPSTR, 9
        INOUT   TEMP, 10
        INOUT   ENDL, 9
        MOV     CX, 0
        MOV     CL, COUNT
        MOV     BX, 0
        MOV     AX, 0
LGD_M: 
        MOV     DX, 10
        MUL     DL
        MOV     DL, TMPSTR[BX]
        SUB     DL, 30H
        CMP     DL, 0
        JL      LGD_E
        CMP     DL, 9
        JG      LGD_E
        ADD     AX, DX
        INC     BX
        LOOP    LGD_M
        MOV     BUF[BP], AX
        ADD     BP, 2
        POP     CX
        LOOP    LGD_L
        JMP     LGD_OUT
LGD_E:
        INOUT   NCHSTR, 9
        POP     CX
        CMP     BP, 20
        JB      LGD_L
LGD_OUT:
        RET
GETDT   ENDP

PUTALL  PROC 
        MOV     AX, BP
        MOV     CX, 2
        DIV     CL
        MOV     CL, AL
        MOV     SI, 0
LPA_M: 
        PUSH    CX
        MOV     AX, BUF[SI]
        MOV     DX, 0
        MOV     CX, 3
LPA_W: 
        MOV     BX, 10
        DIV     BX
        MOV     BX, CX
        ADD     DL, 30H
        MOV     TMPSTR[BX-1], DL
        MOV     DL, 0
        CMP     AX, 0
        JE      LPA_E
        LOOP    LPA_W
LPA_E:
        INOUT   TMPSTR[BX-1], 9
        ADD     SI, 2
        POP     CX
        LOOP    LPA_M
        RET
PUTALL  ENDP

SELECT  PROC 
        INOUT   STCSTR, 9
        MOV     AX, BP
        MOV     CX, 2
        DIV     CL
        MOV     CX, AX
        MOV     SI, 0
LSC_M: 
        XOR     DX, DX
        MOV     AX, BUF[SI]
        MOV     BX, 100
        DIV     BX
        MOV     BX, AX
        MOV     AL, QUJIAN[BX]
        INC     AX
        MOV     QUJIAN[BX], AL
        ADD     SI, 2
        LOOP    LSC_M
        XOR     BX, BX
        MOV     CX, 10
LSC_P: 
        INOUT   QUJSTR, 9
        MOV     AL,QUJSTR
        INC     AL
        MOV     QUJSTR,AL
        MOV     AL,QUJSTR[8]
        INC     AL
        MOV     QUJSTR[8],AL
        PUSH    CX
        MOV     CX, 3
LSC_O: 
        XOR     DX, DX
        MOV     AL, QUJIAN[BX]
        MOV     DI, 10
        DIV     DI
        ADD     DL, 30H
        MOV     DI, CX
        MOV     TMPSTR[DI], DL
        CMP     AX, 0
        JE      LSC_E
        LOOP    LSC_O
LSC_E:
        INOUT   TMPSTR[DI], 9
        POP     CX
        INOUT   ENDL, 9
        INC     BX
        LOOP    LSC_P
        RET
SELECT  ENDP

CODES	ENDS
        END	START