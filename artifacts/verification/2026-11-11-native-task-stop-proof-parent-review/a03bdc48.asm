a03bdc48 38402de9 push {r3, r4, r5, lr}
a03bdc4c 260c00eb bl #0xa03c0cec
a03bdc50 0c3306e3 movw r3, #0x630c
a03bdc54 0050a0e1 mov r5, r0
a03bdc58 79314ae3 movt r3, #0xa179
a03bdc5c 004193e7 ldr r4, [r3, r0, lsl #2]
a03bdc60 000054e3 cmp r4, #0
a03bdc64 3880bd08 popeq {r3, r4, r5, pc}
a03bdc68 ca4403eb bl #0xa048ef98
a03bdc6c d03094e5 ldr r3, [r4, #0xd0]
a03bdc70 000053e3 cmp r3, #0
a03bdc74 0e00000a beq #0xa03bdcb4
a03bdc78 0020a0e3 mov r2, #0
a03bdc7c 030050e1 cmp r0, r3
a03bdc80 d02084e5 str r2, [r4, #0xd0]
a03bdc84 a02206e3 movw r2, #0x62a0
a03bdc88 000063e0 rsb r0, r3, r0
a03bdc8c 79214ae3 movt r2, #0xa179
a03bdc90 cc3094e5 ldr r3, [r4, #0xcc]
a03bdc94 01004032 sublo r0, r0, #1
a03bdc98 051192e7 ldr r1, [r2, r5, lsl #2]
a03bdc9c 033090e0 adds r3, r0, r3
a03bdca0 0030e023 mvnhs r3, #0
a03bdca4 010090e0 adds r0, r0, r1
a03bdca8 0000e023 mvnhs r0, #0
a03bdcac cc3084e5 str r3, [r4, #0xcc]
a03bdcb0 050182e7 str r0, [r2, r5, lsl #2]
a03bdcb4 143306e3 movw r3, #0x6314
a03bdcb8 79314ae3 movt r3, #0xa179
a03bdcbc 053193e7 ldr r3, [r3, r5, lsl #2]
a03bdcc0 000053e3 cmp r3, #0
a03bdcc4 3880bd18 popne {r3, r4, r5, pc}
a03bdcc8 b24403eb bl #0xa048ef98
a03bdccc 803206e3 movw r3, #0x6280
a03bdcd0 79314ae3 movt r3, #0xa179
a03bdcd4 050183e7 str r0, [r3, r5, lsl #2]
a03bdcd8 3880bde8 pop {r3, r4, r5, pc}
