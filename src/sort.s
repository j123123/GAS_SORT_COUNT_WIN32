.intel_syntax noprefix

.section .data

# ��������������� ������
ARRAY:
    .byte   2,   1,  0,    3,   8 
    .byte  16,  82,  23,  66,   0
    .byte  17,  16,  74,   3,   6
    .byte    1,   3,  55,  16,  17
    .byte  33, 133, 254, 241,   5
# ������ �������, ��������� ��� ����� ������� ������� ������ � �����

    ARR_SIZE= . - ARRAY


/*---------------------------------------
������, ������������� ������� ����������|
    .byte    0,   0,   1,   1,   2      |
    .byte    3,   3,   3,   5,   6      |
    .byte     8,  16,  16,  16,  17     |
    .byte    17,  23,  33,  55,  66     |
    .byte    74,  82, 133, 241, 254     |
---------------------------------------*/

# ��������� ������ ��� ������ ��������
TMP_ARR:  
    .space 256

# �������� ������ ����� ����� ������ ��������
RET_ADDR:
    .space 4

# ��������� ������ ��� ��������������� � ����� ������
_tmp:
    .space ARR_SIZE*4+1

# ��������� ������ ��� ������ ��������������
format_str:
    .rept ARR_SIZE
        .ascii "%u "
    .endr
        .ascii "\0"

# ������ � ���������� ���� ���������
_title:
    .ascii "Counting sort\0"

    .section .text

    .globl _WinMainCRTStartup
_WinMainCRTStartup:

    MOV DWORD PTR DS:[RET_ADDR], ESP # ��������� ����� ����� ����� ��������

################# ������ ��������� ���������� #################
    
    MOV EAX, 0                            # ������� ��� ������� �������� ������ �������, ��-�� ��� ���������
    MOV EBX, 0                            # ������� ������� �� ������� TMP_ARR
    MOV ECX, 0                            # ������� ������� �� ������� ARRAY

repeatOne:
    MOV AL, BYTE PTR DS:[ARRAY + ECX]     # �������� ��-�� ������� � �������
    INC ECX                               # ����������� ������� �������
    MOV BL, BYTE PTR DS:[TMP_ARR + EAX]   # �������� �������-������� ������� EAX � �������
    INC BL                                # ����������� ���
    MOV BYTE PTR DS:[TMP_ARR + EAX], BL   # �������� ������� � ������-�������    
    CMP ECX, ARR_SIZE                     # ���������� ���������� �������� � �������� �������
    JNE repeatOne                         # ���� �� ����� �������� ��� ���, � ���� ������ ���� ������




    MOV EAX, 0x0                          # ������� ������� ������� TMP_ARR
    MOV EBX, 0x0                          # ������� ������� ������� ARRAY
    MOV ECX, 0x0                          # ��, ������� ��������� � ����� "�������"
#    MOV EDX, 0x0                          # ������ ����
        
    JMP ENTRY
repeatTwo:
    INC AL                                # ����������� �������-��������� ���������� �����
    CMP AL, 0x0                           # ��������� ��������� � �����. ����� 255 ���� 0
    JE  toExit                            # ���� ���� �� ���� � ������
ENTRY:
    MOV CL, BYTE PTR DS:[TMP_ARR + EAX]   # ������ �� ��������������� ������� ���-�� "�������"
    CMP CL, 0x0                           # TEST CL, CL � �� ���� �� ��?
WHILE_BL_NOT_ZERO:
    JZ    repeatTwo                       # ���� ����, ���� ���������� � ���������� ��������
    MOV BYTE PTR DS:[ARRAY + EBX], AL     # ����� ������� � ������ ARRAY
    INC BX                                # ��������� �� ����. ������� � ������� ARRAY
    DEC CL                                # ��������� ������� ��������� � ����� "�������"
    JMP WHILE_BL_NOT_ZERO                 # ���� ����, �� ��������� � ���������� "������"
    
################# ����� ��������� ���������� #################
    
toExit:

################# ������ ��������� �������� �������� � ���� #################

# �������������� ������� � ������
# �������� ������ ����� �� ������� � ����� � ����
    MOV EAX, ARR_SIZE-1
    MOV EBX, 0x0

    .rept ARR_SIZE                        # ���� ������ ������ ��������(������������) ���� ����� ����� ���
        MOV BL, BYTE PTR DS:[ARRAY+EAX]
        DEC EAX
        PUSH EBX
    .endr                                 # ������� ����� ����� ���� ������� ��� ���


    
# ����� �-��� �������� � ������
    PUSH OFFSET FLAT:format_str
    PUSH OFFSET FLAT:_tmp
    CALL _sprintf
    
# ����� ������� � ���������� ����
    PUSH   0x0                            # style
    PUSH   OFFSET FLAT:_title             # ��������� �� ���������
    PUSH   OFFSET FLAT:_tmp               # ��������� �� ������ � ���������������� ������� � ���� ������  
    PUSH   0x0                            # window handle
    CALL  _MessageBoxA@16                 # MessageBox

# �.�. ���� ���������, �� ���������� ��������� �� ���� ����� ������ ��������
    MOV ESP, DWORD PTR DS:[RET_ADDR] 

# ������� � ������� 0, ��� ������� ���������� ��������� � ������� �� ������� WinMainCRTStartup
    MOV  EAX, 0
    RET 16
