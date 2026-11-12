a04b1d18 f8402de9 push {r3, r4, r5, r6, r7, lr}
a04b1d1c 0060a0e1 mov r6, r0
a04b1d20 18c09de5 ldr ip, [sp, #0x18]
a04b1d24 0170a0e1 mov r7, r1
a04b1d28 0350a0e1 mov r5, r3
a04b1d2c 00005ce3 cmp ip, #0
a04b1d30 1a00000a beq #0xa04b1da0
a04b1d34 01005ce3 cmp ip, #1
a04b1d38 1100001a bne #0xa04b1d84
a04b1d3c d43405e3 movw r3, #0x54d4
a04b1d40 a4314ae3 movt r3, #0xa1a4
a04b1d44 000093e5 ldr r0, [r3]
a04b1d48 000050e3 cmp r0, #0
a04b1d4c 1800000a beq #0xa04b1db4
a04b1d50 052082e0 add r2, r2, r5
a04b1d54 0610a0e1 mov r1, r6
a04b1d58 0030e0e3 mvn r3, #0
a04b1d5c b945fceb bl #0xa03c3448
a04b1d60 000050e3 cmp r0, #0
a04b1d64 0040a0e1 mov r4, r0
a04b1d68 0300001a bne #0xa04b1d7c
a04b1d6c 000055e3 cmp r5, #0
a04b1d70 006096e5 ldr r6, [r6]
a04b1d74 1500001a bne #0xa04b1dd0
a04b1d78 006087e5 str r6, [r7]
a04b1d7c 0400a0e1 mov r0, r4
a04b1d80 f880bde8 pop {r3, r4, r5, r6, r7, pc}
a04b1d84 1c0807e3 movw r0, #0x781c
a04b1d88 401807e3 movw r1, #0x7840
a04b1d8c 63104ae3 movt r1, #0xa063
a04b1d90 63004ae3 movt r0, #0xa063
a04b1d94 d4d4f7eb bl #0xa02a70ec
a04b1d98 ff00a0e3 mov r0, #0xff
a04b1d9c f880bde8 pop {r3, r4, r5, r6, r7, pc}
a04b1da0 d83405e3 movw r3, #0x54d8
a04b1da4 a4314ae3 movt r3, #0xa1a4
a04b1da8 000093e5 ldr r0, [r3]
a04b1dac 000050e3 cmp r0, #0
a04b1db0 e6ffff1a bne #0xa04b1d50
a04b1db4 f80707e3 movw r0, #0x77f8
a04b1db8 401807e3 movw r1, #0x7840
a04b1dbc 63104ae3 movt r1, #0xa063
a04b1dc0 63004ae3 movt r0, #0xa063
a04b1dc4 c8d4f7eb bl #0xa02a70ec
a04b1dc8 1200a0e3 mov r0, #0x12
a04b1dcc f880bde8 pop {r3, r4, r5, r6, r7, pc}
a04b1dd0 0600a0e1 mov r0, r6
a04b1dd4 0510a0e1 mov r1, r5
a04b1dd8 255201fa blx #0xa0506674
a04b1ddc 000051e3 cmp r1, #0
a04b1de0 05608610 addne r6, r6, r5
a04b1de4 06606110 rsbne r6, r1, r6
a04b1de8 e2ffffea b #0xa04b1d78
