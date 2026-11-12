a029cb84 subs r3, r0, #0
a029cb88 beq #0xa029ccb0
a029cb8c movw r1, #0x3444
a029cb90 push {r4, r5, r6, r7, r8, sb, sl, lr}
a029cb94 movt r1, #0xa064
a029cb98 mov r4, r3
a029cb9c blx #0xa04fb00c
a029cba0 mov r7, r0
a029cba4 clz r0, r0
a029cba8 lsr r0, r0, #5
a029cbac cmp r4, r7
a029cbb0 orrlo r0, r0, #1
a029cbb4 cmp r0, #0
a029cbb8 bne #0xa029cca0
a029cbbc movw r1, #0xc918
a029cbc0 movt r1, #0xa05f
a029cbc4 blx #0xa04fb00c
a029cbc8 cmp r0, #0
a029cbcc movweq r8, #0x63a8
a029cbd0 movteq r8, #0xa144
a029cbd4 beq #0xa029cc04
a029cbd8 movw r1, #0x6b5c
a029cbdc movw r8, #0x63a8
a029cbe0 movt r1, #0xa057
a029cbe4 movt r8, #0xa144
a029cbe8 bl #0xa032e0c8
a029cbec movw r3, #0x3068
a029cbf0 movw r2, #0xc6dc
a029cbf4 movt r3, #0xa06f
a029cbf8 movt r2, #0xa029
a029cbfc str r0, [r8, #0x2fc]
a029cc00 str r2, [r3]
a029cc04 mov r0, r7
a029cc08 blx #0xa04f99f0
a029cc0c subs r6, r0, #0
a029cc10 blt #0xa029cca8
a029cc14 mov r5, #0
a029cc18 sub r4, r7, #1
a029cc1c mov r0, r5
a029cc20 mov sb, r5
a029cc24 mvn sl, #0
a029cc28 add r4, r4, #1
a029cc2c ldrb r3, [r4]
a029cc30 rsb r2, r7, r4
a029cc34 add r5, r5, #1
a029cc38 cmp r3, #0x3b
a029cc3c cmpne r2, r6
a029cc40 beq #0xa029cc88
a029cc44 cmp r6, r5
a029cc48 bge #0xa029cc28
a029cc4c ldr r0, [r8, #0x2fc]
a029cc50 movw r4, #0x63a8
a029cc54 movt r4, #0xa144
a029cc58 cmp r0, #0
a029cc5c beq #0xa029cc80
a029cc60 bl #0xa032e0d0
a029cc64 movw r3, #0x3068
a029cc68 movw r2, #0x72a8
a029cc6c movt r3, #0xa06f
a029cc70 movt r2, #0xa02a
a029cc74 mov r1, #0
a029cc78 str r2, [r3]
a029cc7c str r1, [r4, #0x2fc]
a029cc80 mov r0, sl
a029cc84 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a029cc88 strb sb, [r4]
a029cc8c add r0, r7, r0
a029cc90 bl #0xa029c974
a029cc94 mov sl, r0
a029cc98 mov r0, r5
a029cc9c b #0xa029cc44
a029cca0 mvn r0, #0
a029cca4 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a029cca8 mvn sl, #0
a029ccac b #0xa029cc4c
a029ccb0 mvn r0, #0
a029ccb4 bx lr
