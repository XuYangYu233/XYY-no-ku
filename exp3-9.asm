DATAS	SEGMENT
STR     DB      'AVC'
N 	EQU 	28
XBLAB	DB      'abcdefghijklmnopqrstuvwxyz0123456789'
MLAB 	DB	'qwertyuiopasdfghjklzxcvbnm9638527410'
JLAB 	DB 	'kxvmcnophqrszyijadlegwbuft9852741630'
MCODE 	DB 	N DUP(' '),13,10,'$'
JCODE	DB 	N DUP(' '),13,10,'$'
SETSTR 	DB 	'please set password(numbers and letters):','$'
LOGSTR 	DB 	'please input login password:','$'
SUCSTR	DB 	'login succeed! the true password is:',13,10,'$'
WROSTR  DB      'wrong password! try again:','$'
LEN 	DB 	0
ENDL 	DB 	13,10,'$'
DATAS	ENDS

STACKS	SEGMENT
	DW 	128 DUP(0)
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
	ASSUME	CS:CODES, DS:DATAS, SS:STACKS, ES:DATAS
START:
	MOV	AX, DATAS
	MOV	DS, AX
        MOV     ES, AX
	ASMOUT 	SETSTR
        MOV     BP, 0
L_CHK:
        MOV     CX, N
        MOV     SI, 0
L_SET: 
        MOV     AH, 7
        INT     21H
        CMP     AL, 0DH
        JE      L_SFN
        PUSH    AX
        MOV     DL, '*'
        MOV     AH, 2
        INT     21H
        POP     AX
        MOV     DI, 0
        CALL    ENCRYPT
        CMP     BP, 1
        JE      L_JCO
        MOV     MCODE[SI], AL
        JMP     L_MCO
L_JCO:
        MOV     JCODE[SI], AL
L_MCO:
        INC     SI
        LOOP    L_SET
L_SFN:
        ASMOUT  ENDL
        CMP     BP, 1
        JE      L_CHF
        ASMOUT  MCODE
        MOV     BP, 1
        ASMOUT  LOGSTR
        JMP     L_CHK
L_CHF:
        ASMOUT  JCODE
        LEA     SI, MCODE
        LEA     DI, JCODE
        MOV     CX, N
        CLD
        REPZ    CMPSB
        JNZ     L_WRO
        ASMOUT  SUCSTR
        JMP     L_SUC
L_WRO:
        ASMOUT  WROSTR
        LEA     DI, JCODE
        MOV     CX, N
        MOV     AL, 20H
        CLD
        REP     STOSB
        JMP     L_CHK
L_SUC:
        MOV     SI, 0
        MOV     CX, N
L_DEC: 
        MOV     AL, MCODE[SI]
        MOV     DI, 1
        CALL    ENCRYPT
        MOV     JCODE[SI], AL
        INC     SI
        LOOP    L_DEC
        ASMOUT  JCODE
	MOV	AH, 4CH
	INT	21H

ENCRYPT PROC 
	CMP     AL, '0'
        JL      LE_ILL
        CMP     AL, '9'
        JLE     LE_NUM
        CMP     AL, 'A'
        JL      LE_ILL
        CMP     AL, 'Z'
        JLE     LE_BCH
        CMP     AL, 'a'
        JL      LE_ILL
        CMP     AL, 'z'
        JLE     LE_NUM
        JMP     LE_ILL
LE_BCH:
        ADD     AL, 20H
        JMP     LE_NUM
LE_NUM:
        PUSH    CX
        MOV     CX, 36
        MOV     BX, 0
LE_XBL: 
        MOV     DL, XBLAB[BX]
        CMP     DL, AL
        JE      LE_XEX
        INC     BX
        LOOP    LE_XBL
LE_XEX:
        CMP     DI, 0
        JNE     LE_DEC
        MOV     AL, MLAB[BX]
        JMP     LE_ENC
LE_DEC:
        MOV     AL, JLAB[BX]
LE_ENC:
        POP     CX
        JMP     LE_EXI
LE_ILL:
        MOV     AL, 20H
LE_EXI:
	RET
ENCRYPT ENDP

CODES	ENDS
	END	START