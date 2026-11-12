a01b8c20 push {r4, r5, r6, r7, lr}
a01b8c24 movw r0, #0x1e0
a01b8c28 movw r2, #0xfc0c
a01b8c2c movw r4, #0x5270
a01b8c30 movt r4, #0xa126
a01b8c34 sub sp, sp, #0x14
a01b8c38 movt r0, #0xa057
a01b8c3c movt r2, #0xa056
a01b8c40 mov r1, #0x31c
a01b8c44 bl #0xa02a70ec
a01b8c48 ldr r3, [r4]
a01b8c4c cmp r3, #1
a01b8c50 moveq r4, #0
a01b8c54 beq #0xa01b8d8c
a01b8c58 add r0, r4, #0x1cc
a01b8c5c add r1, r4, #0x208
a01b8c60 mov r2, #0xc
a01b8c64 mov r3, #0xa
a01b8c68 bl #0xa03bc534
a01b8c6c subs r7, r0, #0
a01b8c70 bne #0xa01b8db0
a01b8c74 movw r5, #0x23e4
a01b8c78 mov r6, #0x20
a01b8c7c movt r5, #0xa13a
a01b8c80 str r6, [sp]
a01b8c84 add r1, r4, #0xe0
a01b8c88 ldr r0, [r5]
a01b8c8c add r2, r4, #0xe4
a01b8c90 mov r3, #0x2000
a01b8c94 bl #0xa029a7d8
a01b8c98 cmp r0, #0
a01b8c9c blt #0xa01b8de0
a01b8ca0 ldr r0, [r4, #0xe0]
a01b8ca4 mov ip, #1
a01b8ca8 mov r2, #0x2000
a01b8cac movw r1, #0x200
a01b8cb0 movw r3, #0x7994
a01b8cb4 str r2, [sp, #8]
a01b8cb8 str r0, [sp, #4]
a01b8cbc movt r1, #0xa057
a01b8cc0 str r7, [sp]
a01b8cc4 movt r3, #0xa01b
a01b8cc8 str ip, [sp, #0xc]
a01b8ccc add r0, r4, #4
a01b8cd0 mov r2, #0xc8
a01b8cd4 str ip, [r4, #0xdc]
a01b8cd8 str ip, [r4, #0x1c0]
a01b8cdc bl #0xa03bc2bc
a01b8ce0 cmp r0, #0
a01b8ce4 blt #0xa01b8de8
a01b8ce8 ldr r0, [r5]
a01b8cec add r1, r4, #0x1c4
a01b8cf0 str r6, [sp]
a01b8cf4 add r2, r4, #0x1c8
a01b8cf8 mov r3, #0x4000
a01b8cfc bl #0xa029a7d8
a01b8d00 cmp r0, #0
a01b8d04 blt #0xa01b8df8
a01b8d08 movw r5, #0x5578
a01b8d0c movt r5, #0xa126
a01b8d10 ldr r3, [r5]
a01b8d14 cmp r3, #0
a01b8d18 bne #0xa01b8d3c
a01b8d1c movw r0, #0x557c
a01b8d20 movt r0, #0xa126
a01b8d24 bl #0xa03bc458
a01b8d28 cmp r0, #0
a01b8d2c bne #0xa01b8df0
a01b8d30 ldr r3, [r5]
a01b8d34 add r3, r3, #1
a01b8d38 str r3, [r5]
a01b8d3c ldr r0, [r4, #0x1c4]
a01b8d40 movw r5, #0x5270
a01b8d44 mov ip, #0
a01b8d48 mov r2, #0x2000
a01b8d4c movt r5, #0xa126
a01b8d50 mov r6, #1
a01b8d54 movw r1, #0x210
a01b8d58 movw r3, #0x8710
a01b8d5c str r0, [sp, #4]
a01b8d60 movt r1, #0xa057
a01b8d64 str r2, [sp, #8]
a01b8d68 add r0, r5, #0xe8
a01b8d6c str ip, [sp]
a01b8d70 movt r3, #0xa01b
a01b8d74 str r6, [sp, #0xc]
a01b8d78 mov r2, #0xc8
a01b8d7c bl #0xa03bc2bc
a01b8d80 subs r4, r0, #0
a01b8d84 blt #0xa01b8e00
a01b8d88 str r6, [r5]
a01b8d8c movw r0, #0x220
a01b8d90 movw r2, #0xfc0c
a01b8d94 movt r2, #0xa056
a01b8d98 movw r1, #0x36a
a01b8d9c movt r0, #0xa057
a01b8da0 bl #0xa02a70ec
a01b8da4 mov r0, r4
a01b8da8 add sp, sp, #0x14
a01b8dac pop {r4, r5, r6, r7, pc}
a01b8db0 mvn r4, #0
a01b8db4 movw r2, #0x307c
a01b8db8 movw r0, #0x240
a01b8dbc movt r2, #0xa06f
a01b8dc0 movw r3, #0xfc0c
a01b8dc4 ldr r1, [r2, #8]
a01b8dc8 movt r3, #0xa056
a01b8dcc str r4, [sp]
a01b8dd0 mov r2, #0x368
a01b8dd4 movt r0, #0xa057
a01b8dd8 bl #0xa02a70ec
a01b8ddc b #0xa01b8d8c
a01b8de0 mvn r4, #1
a01b8de4 b #0xa01b8db4
a01b8de8 mvn r4, #2
a01b8dec b #0xa01b8db4
a01b8df0 mvn r4, #4
a01b8df4 b #0xa01b8db4
a01b8df8 mvn r4, #3
a01b8dfc b #0xa01b8db4
a01b8e00 mvn r4, #5
a01b8e04 b #0xa01b8db4
