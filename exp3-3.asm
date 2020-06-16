DATAS	SEGMENT
SUCC    DB      'THE STRING IS MATCHED!',13,10,'$'
FAIL    DB      'THE STRING IS NOT MATCHED!',13,10,'$'
INPUT1  DB      'please input string1:','$'
INPUT2  DB      'please input string2:','$'
NEXTL   DB      13,10,'$'
N       EQU     21
BUF1    DB      N+1
COUNT1  DB      0
STR1    DB      N+1 DUP(0)
BUF2    DB      N+1
COUNT2  DB      0
STR2    DB      N+1 DUP(0)
DATAS	ENDS

STACKS	SEGMENT
        DW      128 DUP(0)
STACKS	ENDS

INOUT   MACRO   X, Y
        PUSH    AX
        PUSH    DX
        LEA     DX, X
        MOV     AH, Y
        INT     21H
        POP     DX
        POP     AX
        ENDM

CODES	SEGMENT
        ASSUME	CS:CODES, DS:DATAS, SS:STACKS, ES:DATAS
START:
        MOV	AX, DATAS
        MOV	DS, AX
        MOV     ES, AX
        INOUT   INPUT1, 9
        INOUT   BUF1, 10
        INOUT   NEXTL, 9
        INOUT   INPUT2, 9
        INOUT   BUF2, 10
        INOUT   NEXTL, 9

        LEA     SI, STR1
        LEA     DI, STR2
        MOV     CL, N
        CLD
        REPZ    CMPSB
        JNZ     NMATCH
        INOUT   SUCC, 9
        JMP     EXIT
NMATCH:
        INOUT   FAIL, 9
EXIT:
        MOV	AH, 4CH
        INT	21H
CODES	ENDS
        END	START