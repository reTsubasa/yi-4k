a01b7994 push {r4, r5, r6, r7, lr}
a01b7998 sub sp, sp, #0x410
a01b799c sub sp, sp, #4
a01b79a0 movw r6, #0x5270
a01b79a4 movw r7, #0x307c
a01b79a8 mov r1, #0
a01b79ac add r0, sp, #0x10
a01b79b0 mov r2, #0x400
a01b79b4 movt r6, #0xa126
a01b79b8 movt r7, #0xa06f
a01b79bc blx #0xa04f8dec
a01b79c0 mov r3, #0
a01b79c4 str r3, [sp, #4]
a01b79c8 str r3, [sp, #8]
a01b79cc str r3, [sp, #0xc]
a01b79d0 ldr r3, [r6, #0x1c0]
a01b79d4 cmp r3, #0
a01b79d8 beq #0xa01b7a40
a01b79dc add r4, sp, #0x10
a01b79e0 mov r5, #0
a01b79e4 b #0xa01b7a00
a01b79e8 ldrb r3, [r4], #1
a01b79ec cmp r3, #0
a01b79f0 beq #0xa01b7a4c
a01b79f4 add r5, r5, #1
a01b79f8 cmp r5, #0x400
a01b79fc beq #0xa01b7a4c
a01b7a00 mov r0, #1
a01b7a04 mov r1, r4
a01b7a08 mvn r2, #0
a01b7a0c bl #0xa0231f68
a01b7a10 cmp r0, #0
a01b7a14 bgt #0xa01b79e8
a01b7a18 movw r0, #0xfce8
a01b7a1c movw r3, #0x348
a01b7a20 movt r3, #0xa057
a01b7a24 movt r0, #0xa056
a01b7a28 ldr r1, [r7, #8]
a01b7a2c mov r2, #0x144
a01b7a30 bl #0xa02a70ec
a01b7a34 ldr r3, [r6, #0x1c0]
a01b7a38 cmp r3, #0
a01b7a3c bne #0xa01b79dc
a01b7a40 add sp, sp, #0x410
a01b7a44 add sp, sp, #4
a01b7a48 pop {r4, r5, r6, r7, pc}
a01b7a4c movw r3, #0x23e4
a01b7a50 mov r2, r5
a01b7a54 movt r3, #0xa13a
a01b7a58 add r1, sp, #4
a01b7a5c ldr r0, [r3]
a01b7a60 mov r3, #0x20
a01b7a64 str r5, [sp, #0xc]
a01b7a68 bl #0xa03bc77c
a01b7a6c cmp r0, #0
a01b7a70 blt #0xa01b7a98
a01b7a74 add r1, sp, #0x10
a01b7a78 ldr r2, [sp, #0xc]
a01b7a7c ldr r0, [sp, #4]
a01b7a80 bl #0xa029c680
a01b7a84 add r1, sp, #4
a01b7a88 mvn r2, #0
a01b7a8c ldr r0, [pc, #0x24]
a01b7a90 bl #0xa03bc598
a01b7a94 b #0xa01b79d0
a01b7a98 movw r0, #0xfcb8
a01b7a9c movw r3, #0x348
a01b7aa0 movt r3, #0xa057
a01b7aa4 ldr r1, [r7, #8]
a01b7aa8 mov r2, #0x140
a01b7aac movt r0, #0xa056
a01b7ab0 bl #0xa02a70ec
a01b7ab4 b #0xa01b79d0
