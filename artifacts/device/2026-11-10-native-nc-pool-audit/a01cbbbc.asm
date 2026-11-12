a01cbbbc f0432de9 push {r4, r5, r6, r7, r8, sb, lr}
a01cbbc0 20400be3 movw r4, #0xb020
a01cbbc4 28414ae3 movt r4, #0xa128
a01cbbc8 0030a0e3 mov r3, #0
a01cbbcc 2cd04de2 sub sp, sp, #0x2c
a01cbbd0 000094e5 ldr r0, [r4]
a01cbbd4 24308de5 str r3, [sp, #0x24]
a01cbbd8 04308de5 str r3, [sp, #4]
a01cbbdc 030050e1 cmp r0, r3
a01cbbe0 08308de5 str r3, [sp, #8]
a01cbbe4 0c308de5 str r3, [sp, #0xc]
a01cbbe8 10308de5 str r3, [sp, #0x10]
a01cbbec 0100000a beq #0xa01cbbf8
a01cbbf0 2cd08de2 add sp, sp, #0x2c
a01cbbf4 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a01cbbf8 28508de2 add r5, sp, #0x28
a01cbbfc 803b0be3 movw r3, #0xbb80
a01cbc00 143025e5 str r3, [r5, #-0x14]!
a01cbc04 0210a0e3 mov r1, #2
a01cbc08 1020a0e3 mov r2, #0x10
a01cbc0c 013ca0e3 mov r3, #0x100
a01cbc10 0500a0e1 mov r0, r5
a01cbc14 18108de5 str r1, [sp, #0x18]
a01cbc18 20208de5 str r2, [sp, #0x20]
a01cbc1c 18700be3 movw r7, #0xb018
a01cbc20 1c308de5 str r3, [sp, #0x1c]
a01cbc24 28714ae3 movt r7, #0xa128
a01cbc28 a22403eb bl #0xa0294eb8
a01cbc2c 0090a0e1 mov sb, r0
a01cbc30 0500a0e1 mov r0, r5
a01cbc34 cf2403eb bl #0xa0294f78
a01cbc38 e43302e3 movw r3, #0x23e4
a01cbc3c 0080a0e1 mov r8, r0
a01cbc40 3a314ae3 movt r3, #0xa13a
a01cbc44 0710a0e1 mov r1, r7
a01cbc48 0920a0e1 mov r2, sb
a01cbc4c 000093e5 ldr r0, [r3]
a01cbc50 2030a0e3 mov r3, #0x20
a01cbc54 0c600be3 movw r6, #0xb00c
a01cbc58 c7c207eb bl #0xa03bc77c
a01cbc5c f03302e3 movw r3, #0x23f0
a01cbc60 28614ae3 movt r6, #0xa128
a01cbc64 3a314ae3 movt r3, #0xa13a
a01cbc68 0610a0e1 mov r1, r6
a01cbc6c 0820a0e1 mov r2, r8
a01cbc70 000093e5 ldr r0, [r3]
a01cbc74 2030a0e3 mov r3, #0x20
a01cbc78 bfc207eb bl #0xa03bc77c
a01cbc7c 04c097e5 ldr ip, [r7, #4]
a01cbc80 0500a0e1 mov r0, r5
a01cbc84 043096e5 ldr r3, [r6, #4]
a01cbc88 04108de2 add r1, sp, #4
a01cbc8c 0c208de2 add r2, sp, #0xc
a01cbc90 08908de5 str sb, [sp, #8]
a01cbc94 04c08de5 str ip, [sp, #4]
a01cbc98 0c308de5 str r3, [sp, #0xc]
a01cbc9c 10808de5 str r8, [sp, #0x10]
a01cbca0 642503eb bl #0xa0295238
a01cbca4 000084e5 str r0, [r4]
a01cbca8 2cd08de2 add sp, sp, #0x2c
a01cbcac f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
