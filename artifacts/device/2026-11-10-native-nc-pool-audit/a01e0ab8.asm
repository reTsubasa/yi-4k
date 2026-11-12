a01e0ab8 10402de9 push {r4, lr}
a01e0abc ac390be3 movw r3, #0xb9ac
a01e0ac0 202090e5 ldr r2, [r0, #0x20]
a01e0ac4 30d04de2 sub sp, sp, #0x30
a01e0ac8 29314ae3 movt r3, #0xa129
a01e0acc 002083e5 str r2, [r3]
a01e0ad0 ccba02eb bl #0xa028f608
a01e0ad4 2020a0e3 mov r2, #0x20
a01e0ad8 0030a0e1 mov r3, r0
a01e0adc 140107e3 movw r0, #0x7114
a01e0ae0 00208de5 str r2, [sp]
a01e0ae4 fd004ae3 movt r0, #0xa0fd
a01e0ae8 18108de2 add r1, sp, #0x18
a01e0aec 14208de2 add r2, sp, #0x14
a01e0af0 38e702eb bl #0xa029a7d8
a01e0af4 003050e2 subs r3, r0, #0
a01e0af8 3f00001a bne #0xa01e0bfc
a01e0afc 802b0be3 movw r2, #0xbb80
a01e0b00 30408de2 add r4, sp, #0x30
a01e0b04 142024e5 str r2, [r4, #-0x14]!
a01e0b08 02c0a0e3 mov ip, #2
a01e0b0c 1010a0e3 mov r1, #0x10
a01e0b10 012ba0e3 mov r2, #0x400
a01e0b14 0400a0e1 mov r0, r4
a01e0b18 2c308de5 str r3, [sp, #0x2c]
a01e0b1c 20c08de5 str ip, [sp, #0x20]
a01e0b20 28108de5 str r1, [sp, #0x28]
a01e0b24 24208de5 str r2, [sp, #0x24]
a01e0b28 82c302eb bl #0xa0291938
a01e0b2c 032080e2 add r2, r0, #3
a01e0b30 140107e3 movw r0, #0x7114
a01e0b34 0320c2e3 bic r2, r2, #3
a01e0b38 fd004ae3 movt r0, #0xa0fd
a01e0b3c 102082e2 add r2, r2, #0x10
a01e0b40 10108de2 add r1, sp, #0x10
a01e0b44 8220a0e1 lsl r2, r2, #1
a01e0b48 6430a0e3 mov r3, #0x64
a01e0b4c e26e07eb bl #0xa03bc6dc
a01e0b50 000050e3 cmp r0, #0
a01e0b54 2000001a bne #0xa01e0bdc
a01e0b58 0400a0e1 mov r0, r4
a01e0b5c a7c302eb bl #0xa0291a00
a01e0b60 072080e2 add r2, r0, #7
a01e0b64 200207e3 movw r0, #0x7220
a01e0b68 0720c2e3 bic r2, r2, #7
a01e0b6c fe004ae3 movt r0, #0xa0fe
a01e0b70 102082e2 add r2, r2, #0x10
a01e0b74 0c108de2 add r1, sp, #0xc
a01e0b78 8220a0e1 lsl r2, r2, #1
a01e0b7c 6430a0e3 mov r3, #0x64
a01e0b80 d56e07eb bl #0xa03bc6dc
a01e0b84 000050e3 cmp r0, #0
a01e0b88 1700001a bne #0xa01e0bec
a01e0b8c 0420a0e1 mov r2, r4
a01e0b90 0c109de5 ldr r1, [sp, #0xc]
a01e0b94 10009de5 ldr r0, [sp, #0x10]
a01e0b98 b9fd09eb bl #0xa0460284
a01e0b9c 4c020ce3 movw r0, #0xc24c
a01e0ba0 57004ae3 movt r0, #0xa057
a01e0ba4 501903eb bl #0xa02a70ec
a01e0ba8 7c3003e3 movw r3, #0x307c
a01e0bac 78020ce3 movw r0, #0xc278
a01e0bb0 6f304ae3 movt r3, #0xa06f
a01e0bb4 18209de5 ldr r2, [sp, #0x18]
a01e0bb8 041093e5 ldr r1, [r3, #4]
a01e0bbc 57004ae3 movt r0, #0xa057
a01e0bc0 491903eb bl #0xa02a70ec
a01e0bc4 0000a0e3 mov r0, #0
a01e0bc8 18109de5 ldr r1, [sp, #0x18]
a01e0bcc 22ffffeb bl #0xa01e085c
a01e0bd0 0000a0e3 mov r0, #0
a01e0bd4 30d08de2 add sp, sp, #0x30
a01e0bd8 1080bde8 pop {r4, pc}
a01e0bdc e8070ce3 movw r0, #0xc7e8
a01e0be0 55004ae3 movt r0, #0xa055
a01e0be4 401903eb bl #0xa02a70ec
a01e0be8 daffffea b #0xa01e0b58
a01e0bec 10080ce3 movw r0, #0xc810
a01e0bf0 55004ae3 movt r0, #0xa055
a01e0bf4 3c1903eb bl #0xa02a70ec
a01e0bf8 e3ffffea b #0xa01e0b8c
a01e0bfc 20020ce3 movw r0, #0xc220
a01e0c00 57004ae3 movt r0, #0xa057
a01e0c04 381903eb bl #0xa02a70ec
a01e0c08 0b00e0e3 mvn r0, #0xb
a01e0c0c f0ffffea b #0xa01e0bd4
