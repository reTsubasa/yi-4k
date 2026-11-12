a048fb7c d43206e3 movw r3, #0x62d4
a048fb80 000050e3 cmp r0, #0
a048fb84 79314ae3 movt r3, #0xa179
a048fb88 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a048fb8c 1cd04de2 sub sp, sp, #0x1c
a048fb90 005093e5 ldr r5, [r3]
a048fb94 3e00000a beq #0xa048fc94
a048fb98 0060a0e1 mov r6, r0
a048fb9c 880d0ce3 movw r0, #0xcd88
a048fba0 b47206e3 movw r7, #0x62b4
a048fba4 62004ae3 movt r0, #0xa062
a048fba8 36ff2fe1 blx r6
a048fbac 79714ae3 movt r7, #0xa179
a048fbb0 b00d0ce3 movw r0, #0xcdb0
a048fbb4 001097e5 ldr r1, [r7]
a048fbb8 62004ae3 movt r0, #0xa062
a048fbbc 36ff2fe1 blx r6
a048fbc0 880d0ce3 movw r0, #0xcd88
a048fbc4 62004ae3 movt r0, #0xa062
a048fbc8 36ff2fe1 blx r6
a048fbcc d80d0ce3 movw r0, #0xcdd8
a048fbd0 62004ae3 movt r0, #0xa062
a048fbd4 36ff2fe1 blx r6
a048fbd8 003097e5 ldr r3, [r7]
a048fbdc 000053e3 cmp r3, #0
a048fbe0 2800000a beq #0xa048fc88
a048fbe4 b0809fe5 ldr r8, [pc, #0xb0]
a048fbe8 18990ce3 movw sb, #0xc918
a048fbec 5f904ae3 movt sb, #0xa05f
a048fbf0 0040a0e3 mov r4, #0
a048fbf4 04b088e2 add fp, r8, #4
a048fbf8 0ca048e2 sub sl, r8, #0xc
a048fbfc 0a0000ea b #0xa048fc2c
a048fc00 00e09ae5 ldr lr, [sl]
a048fc04 014084e2 add r4, r4, #1
a048fc08 0c009ae9 ldmib sl, {r2, r3}
a048fc0c 00005ee3 cmp lr, #0
a048fc10 09e0a001 moveq lr, sb
a048fc14 00e08de5 str lr, [sp]
a048fc18 36ff2fe1 blx r6
a048fc1c 003097e5 ldr r3, [r7]
a048fc20 2c5095e5 ldr r5, [r5, #0x2c]
a048fc24 030054e1 cmp r4, r3
a048fc28 1600002a bhs #0xa048fc88
a048fc2c e01b09e3 movw r1, #0x9be0
a048fc30 00808de5 str r8, [sp]
a048fc34 a3114ae3 movt r1, #0xa1a3
a048fc38 04b08de5 str fp, [sp, #4]
a048fc3c 143081e2 add r3, r1, #0x14
a048fc40 042081e2 add r2, r1, #4
a048fc44 08308de5 str r3, [sp, #8]
a048fc48 0500a0e1 mov r0, r5
a048fc4c 083081e2 add r3, r1, #8
a048fc50 9bcefceb bl #0xa03c36c4
a048fc54 003050e2 subs r3, r0, #0
a048fc58 180e0ce3 movw r0, #0xce18
a048fc5c 0410a0e1 mov r1, r4
a048fc60 62004ae3 movt r0, #0xa062
a048fc64 e5ffff0a beq #0xa048fc00
a048fc68 fc0d0ce3 movw r0, #0xcdfc
a048fc6c 14308de5 str r3, [sp, #0x14]
a048fc70 62004ae3 movt r0, #0xa062
a048fc74 36ff2fe1 blx r6
a048fc78 14309de5 ldr r3, [sp, #0x14]
a048fc7c 0300a0e1 mov r0, r3
a048fc80 1cd08de2 add sp, sp, #0x1c
a048fc84 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a048fc88 0000a0e3 mov r0, #0
a048fc8c 1cd08de2 add sp, sp, #0x1c
a048fc90 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a048fc94 0000e0e3 mvn r0, #0
a048fc98 fbffffea b #0xa048fc8c
