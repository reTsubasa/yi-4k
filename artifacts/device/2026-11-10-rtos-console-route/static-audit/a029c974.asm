a029c974 cmp r0, #0
a029c978 beq #0xa029cb7c
a029c97c movw r1, #0xe3e8
a029c980 push {r4, r5, r6, r7, r8, sb, lr}
a029c984 movt r1, #0xa05a
a029c988 sub sp, sp, #0x84
a029c98c blx #0xa04fb00c
a029c990 subs r6, r0, #0
a029c994 beq #0xa029cb50
a029c998 ldrb r7, [r6]
a029c99c cmp r7, #0x23
a029c9a0 moveq r0, #0
a029c9a4 beq #0xa029ca88
a029c9a8 movw r4, #0x2ea0
a029c9ac movt r4, #0xa06f
a029c9b0 b #0xa029c9c0
a029c9b4 ldr r4, [r4, #8]
a029c9b8 cmp r4, #0
a029c9bc beq #0xa029ca7c
a029c9c0 mov r0, r6
a029c9c4 ldr r1, [r4]
a029c9c8 blx #0xa04f9744
a029c9cc subs r5, r0, #0
a029c9d0 bne #0xa029c9b4
a029c9d4 ldr r4, [r4, #4]
a029c9d8 cmp r4, #0
a029c9dc beq #0xa029ca7c
a029c9e0 movw r1, #0x6c90
a029c9e4 str r6, [sp]
a029c9e8 movt r1, #0xa05a
a029c9ec blx #0xa04fb00c
a029c9f0 subs r7, r0, #0
a029c9f4 beq #0xa029cafc
a029c9f8 blx #0xa04f99f0
a029c9fc subs r6, r0, #0
a029ca00 ble #0xa029cafc
a029ca04 mov r2, r5
a029ca08 mov r0, #1
a029ca0c mov r3, r5
a029ca10 b #0xa029ca40
a029ca14 cmp r2, #1
a029ca18 add r3, r3, #1
a029ca1c mov r2, #0
a029ca20 strbeq r5, [ip]
a029ca24 cmp r0, #0x1f
a029ca28 movle r1, #1
a029ca2c movgt r1, #0
a029ca30 cmp r6, r3
a029ca34 movle r1, #0
a029ca38 cmp r1, #0
a029ca3c beq #0xa029cb00
a029ca40 ldrb r1, [r7, r3]
a029ca44 add ip, r7, r3
a029ca48 cmp r1, #0x20
a029ca4c cmpne r1, #9
a029ca50 beq #0xa029ca14
a029ca54 cmp r1, #0x27
a029ca58 beq #0xa029ca90
a029ca5c cmp r2, #0
a029ca60 mov r2, #1
a029ca64 addeq r1, sp, #0x80
a029ca68 add r3, r3, #1
a029ca6c addeq r1, r1, r0, lsl #2
a029ca70 addeq r0, r0, r2
a029ca74 streq ip, [r1, #-0x80]
a029ca78 b #0xa029ca24
a029ca7c cmp r7, #0
a029ca80 bne #0xa029cb5c
a029ca84 mvn r0, #0
a029ca88 add sp, sp, #0x84
a029ca8c pop {r4, r5, r6, r7, r8, sb, pc}
a029ca90 lsl sb, r0, #2
a029ca94 add r8, r3, #1
a029ca98 add r2, sp, #0x80
a029ca9c cmp r6, r8
a029caa0 add r2, r2, sb
a029caa4 str ip, [r2, #-0x80]
a029caa8 ble #0xa029caec
a029caac ldrb r2, [r7, r8]
a029cab0 add ip, r7, r8
a029cab4 cmp r2, #0x27
a029cab8 addne r2, r3, #2
a029cabc movne r1, r8
a029cac0 addne r2, r7, r2
a029cac4 bne #0xa029cad8
a029cac8 b #0xa029cb2c
a029cacc ldrb lr, [ip]
a029cad0 cmp lr, #0x27
a029cad4 beq #0xa029cb30
a029cad8 add r1, r1, #1
a029cadc mov ip, r2
a029cae0 cmp r6, r1
a029cae4 add r2, r2, #1
a029cae8 bgt #0xa029cacc
a029caec mov r3, r8
a029caf0 mov r2, #1
a029caf4 add r0, r0, #1
a029caf8 b #0xa029ca24
a029cafc mov r0, #1
a029cb00 movw r3, #0x3068
a029cb04 mov r1, sp
a029cb08 movt r3, #0xa06f
a029cb0c ldr r2, [r3]
a029cb10 blx r4
a029cb14 movw r3, #0x63a8
a029cb18 mov r2, r0
a029cb1c movt r3, #0xa144
a029cb20 str r2, [r3, #0x300]
a029cb24 add sp, sp, #0x84
a029cb28 pop {r4, r5, r6, r7, r8, sb, pc}
a029cb2c mov r1, r8
a029cb30 add r3, sp, #0x80
a029cb34 add r8, r7, r8
a029cb38 add sb, r3, sb
a029cb3c mov r2, #0
a029cb40 str r8, [sb, #-0x80]
a029cb44 add r3, r1, #1
a029cb48 strb r5, [ip]
a029cb4c b #0xa029caf4
a029cb50 mov r0, r6
a029cb54 add sp, sp, #0x84
a029cb58 pop {r4, r5, r6, r7, r8, sb, pc}
a029cb5c movw r3, #0x3068
a029cb60 movw r0, #0xe3ec
a029cb64 movt r3, #0xa06f
a029cb68 mov r1, r6
a029cb6c ldr r3, [r3]
a029cb70 movt r0, #0xa05a
a029cb74 blx r3
a029cb78 b #0xa029ca84
a029cb7c mvn r0, #0
a029cb80 bx lr
