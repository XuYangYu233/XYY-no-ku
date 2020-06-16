DATAS	SEGMENT
X       DB      1 DUP(0)
INPUT   DB      ' please input:','$'
SJZ     DB      ' decimalism!',13,10,'$'
DAXIE   DB      ' capital letter!',13,10,'$'
XIAOXIE DB      ' small letter!',13,10,'$'
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
HEAD:
        ASMOUT  INPUT
        MOV     AH, 1
        INT     21H
        MOV     X, AL
        CALL    JUDGE
        MOV     AX, 4
        CMP     AX, BX
        JE      GCK
        JMP     HEAD
GCK:
        MOV	AH, 4CH
        INT	21H

JUDGE   PROC
        MOV     BL, '0'
        CMP     BL, X
        JA      END4
        MOV     BL, '9'
        CMP     BL, X
        JAE     END1
        MOV     BL, 'A'
        CMP     BL, X
        JA      END4
        MOV     BL, 'Z'
        CMP     BL, X
        JAE     END2
        MOV     BL, 'a'
        CMP     BL, X 
        JA      END4
        MOV     BL, 'z'
        CMP     BL, X
        JAE     END3
        JB      END4
END1:   
        MOV     BX, 1
        ASMOUT  SJZ
        JMP     EXIT
END2:
        MOV     BX, 2
        ASMOUT  DAXIE
        JMP     EXIT
END3:
        MOV     BX, 3
        ASMOUT  XIAOXIE
        JMP     EXIT
END4:
        MOV     BX, 4
        JMP     EXIT
EXIT:
        RET
JUDGE   ENDP

CODES	ENDS
        END	START