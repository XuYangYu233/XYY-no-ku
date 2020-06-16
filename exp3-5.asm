DATAS	SEGMENT
ARY_A   DW      1,2,3,4,5,6,7,8,9,0AH,0BH,0CH,0DH,0EH,0FH
ARY_B   DW      1,3,4,8,9,0DH,74H,489H,2ADH,123H,483H,5D9H
        DW      89H,3921H,3821H,32H,4CH,21H,24DH,98H,77DDH
ARY_C   DW      20 DUP(0)
TEMP    DB      5 DUP(0),' ','$'
STRNUM  DB      'the number of A is:',13,10,'$'
ENDL    DB      13,10,'$'
DATAS	ENDS

PUBLIC  TEMP
EXTRN   DISP:FAR

STACKS	SEGMENT
        DW      128 DUP(0)
STACKS	ENDS

CODES	SEGMENT USE16
        ASSUME	CS:CODES, DS:DATAS, SS:STACKS
START:
        MOV	AX, DATAS
        MOV	DS, AX
        XOR     BP, BP
        LEA     SI, ARY_A
        MOV     CX, 15
LOO_A: 
        MOV     AX, [SI]
        LEA     DI, ARY_B
        PUSH    CX
        MOV     CX, 20
LOO_B: 
        MOV     BX, [DI]
        CMP     AX, BX
        JNE     LBL_NE
        MOV     ARY_C[BP], AX
        ADD     BP, 2
        JMP     BREAK
LBL_NE:
        ADD     DI, 2
        LOOP    LOO_B
BREAK:
        POP     CX
        ADD     SI, 2
        LOOP    LOO_A
        LEA     DX, STRNUM
        MOV     AH, 9
        INT     21H
        MOV     AL, STRNUM[14]
        INC     AX
        MOV     STRNUM[14], AL

        MOV     CX, 15
        MOV     BX, 0
LBL_A:
        MOV     AX, ARY_A[BX]
        ADD     BX, 2
        CALL    FAR PTR DISP
        LOOP    LBL_A
        LEA     DX, ENDL
        MOV     AH, 9
        INT     21H
        LEA     DX, STRNUM
        INT     21H
        MOV     AL, STRNUM[14]
        INC     AX
        MOV     STRNUM[14], AL
        MOV     CX, 20
        MOV     BX, 0
LBL_B: 
        MOV     AX, ARY_B[BX]
        ADD     BX, 2
        CALL    FAR PTR DISP
        LOOP    LBL_B
        LEA     DX, ENDL
        MOV     AH, 9
        INT     21H
        LEA     DX, STRNUM
        INT     21H
        MOV     CX, 20
        MOV     BX, 0
LBL_C: 
        MOV     AX, ARY_C[BX]
        ADD     BX, 2
        CALL    FAR PTR DISP
        LOOP    LBL_C
        MOV	AH, 4CH
        INT	21H
CODES	ENDS
        END	START