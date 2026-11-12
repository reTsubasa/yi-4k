a023809c push {r4, r5, lr}
a02380a0 mov r3, #0
a02380a4 ldr r5, [pc, #0xa8]
a02380a8 sub sp, sp, #0x2c
a02380ac str r3, [sp, #4]
a02380b0 str r3, [sp, #8]
a02380b4 str r3, [sp, #0xc]
a02380b8 str r3, [sp, #0x10]
a02380bc str r3, [sp, #0x14]
a02380c0 str r3, [sp, #0x18]
a02380c4 str r3, [sp, #0x1c]
a02380c8 str r3, [sp, #0x20]
a02380cc str r3, [sp, #0x24]
a02380d0 ldr r0, [pc, #0x80]
a02380d4 add r1, sp, #4
a02380d8 mvn r2, #0
a02380dc bl #0xa03bc56c
a02380e0 cmp r0, #0
a02380e4 bne #0xa0238148
a02380e8 movw r4, #0x7b8
a02380ec mvn r1, #0
a02380f0 ldr r0, [pc, #0x64]
a02380f4 movt r4, #0xa143
a02380f8 bl #0xa03bc46c
a02380fc b #0xa023810c
a0238100 add r4, r4, #8
a0238104 cmp r4, r5
a0238108 beq #0xa023813c
a023810c ldr r3, [r4, #0x1dc]
a0238110 cmp r3, #0
a0238114 beq #0xa0238100
a0238118 ldr r0, [r4, #0x1e0]
a023811c ldr r2, [sp, #4]
a0238120 cmp r0, r2
a0238124 bne #0xa0238100
a0238128 add r1, sp, #0x10
a023812c add r4, r4, #8
a0238130 blx r3
a0238134 cmp r4, r5
a0238138 bne #0xa023810c
a023813c ldr r0, [pc, #0x18]
a0238140 bl #0xa03bc498
a0238144 b #0xa02380d0
a0238148 mov r0, #1
a023814c bl #0xa03bc320
a0238150 b #0xa02380d0
