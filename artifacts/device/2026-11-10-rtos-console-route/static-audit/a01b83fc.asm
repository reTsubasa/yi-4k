a01b83fc push {r4, r5, r6, r7, r8, lr}
a01b8400 mov r5, #0
a01b8404 sub sp, sp, #0x610
a01b8408 mov r4, r0
a01b840c mov r7, r1
a01b8410 mov r6, r2
a01b8414 mov r1, r5
a01b8418 mov r2, #0x200
a01b841c add r0, sp, #0x10
a01b8420 mov r8, r3
a01b8424 strh r5, [sp, #0xa]
a01b8428 strh r5, [sp, #0xc]
a01b842c strh r5, [sp, #0xe]
a01b8430 blx #0xa04f8dec
a01b8434 mov r1, r5
a01b8438 mov r2, #0x200
a01b843c add r0, sp, #0x210
a01b8440 blx #0xa04f8dec
a01b8444 mov r1, r5
a01b8448 add r0, sp, #0x410
a01b844c mov r2, #0x200
a01b8450 blx #0xa04f8dec
a01b8454 cmp r4, r5
a01b8458 beq #0xa01b85e0
a01b845c ldrb r1, [r4, #1]
a01b8460 movw r0, #0xff44
a01b8464 ldrb r3, [r4, #2]
a01b8468 movw r2, #0xfc38
a01b846c ldrb lr, [r4, #3]
a01b8470 mov ip, #3
a01b8474 movt r2, #0xa056
a01b8478 strb r1, [sp, #0xb]
a01b847c strb r3, [sp, #0xc]
a01b8480 movw r1, #0x252
a01b8484 ldrb r3, [r4]
a01b8488 movt r0, #0xa056
a01b848c strb lr, [sp, #0xd]
a01b8490 strb ip, [sp, #0xa]
a01b8494 bl #0xa02a70ec
a01b8498 movw r0, #0xff6c
a01b849c movw r2, #0xfc38
a01b84a0 movt r2, #0xa056
a01b84a4 movw r1, #0x253
a01b84a8 ldrb r3, [r4, #1]
a01b84ac movt r0, #0xa056
a01b84b0 bl #0xa02a70ec
a01b84b4 movw r0, #0xff90
a01b84b8 movw r2, #0xfc38
a01b84bc movt r2, #0xa056
a01b84c0 mov r1, #0x254
a01b84c4 ldrb r3, [r4, #2]
a01b84c8 movt r0, #0xa056
a01b84cc bl #0xa02a70ec
a01b84d0 movw r0, #0xffbc
a01b84d4 movw r2, #0xfc38
a01b84d8 ldrb r3, [r4, #3]
a01b84dc movt r0, #0xa056
a01b84e0 movt r2, #0xa056
a01b84e4 movw r1, #0x255
a01b84e8 bl #0xa02a70ec
a01b84ec ldrb r3, [r4]
a01b84f0 cmp r3, #1
a01b84f4 beq #0xa01b8524
a01b84f8 mvn r4, #1
a01b84fc movw r0, #0x2c
a01b8500 movw r2, #0xfc38
a01b8504 movt r2, #0xa056
a01b8508 mov r1, #0x27c
a01b850c mov r3, r4
a01b8510 movt r0, #0xa057
a01b8514 bl #0xa02a70ec
a01b8518 mov r0, r4
a01b851c add sp, sp, #0x610
a01b8520 pop {r4, r5, r6, r7, r8, pc}
a01b8524 ldrb r3, [r4, #2]
a01b8528 cmp r3, #1
a01b852c beq #0xa01b8580
a01b8530 cmp r3, #2
a01b8534 bne #0xa01b84f8
a01b8538 ldrb r3, [r4, #3]
a01b853c cmp r3, #1
a01b8540 beq #0xa01b85e8
a01b8544 cmp r3, #2
a01b8548 bne #0xa01b84f8
a01b854c mov r1, #0x200
a01b8550 add r0, sp, #0x410
a01b8554 bl #0xa01b7fb0
a01b8558 movw r2, #0xfc38
a01b855c uxth r5, r0
a01b8560 movw r0, #8
a01b8564 mov r1, #0x268
a01b8568 movt r0, #0xa057
a01b856c movt r2, #0xa056
a01b8570 add r3, sp, #0x410
a01b8574 bl #0xa02a70ec
a01b8578 add r1, sp, #0x410
a01b857c b #0xa01b8584
a01b8580 mov r1, r5
a01b8584 mov r2, r5
a01b8588 add r3, sp, #0x10
a01b858c add r0, sp, #0xa
a01b8590 bl #0xa01b7c50
a01b8594 uxth r1, r0
a01b8598 cmp r1, #0
a01b859c beq #0xa01b85d0
a01b85a0 add r0, sp, #0x10
a01b85a4 add r2, sp, #0x210
a01b85a8 bl #0xa01b7d20
a01b85ac uxth r0, r0
a01b85b0 cmp r0, #0
a01b85b4 beq #0xa01b85d8
a01b85b8 add r1, sp, #0x210
a01b85bc mov r4, #0
a01b85c0 bl #0xa0231f18
a01b85c4 mov r0, r4
a01b85c8 add sp, sp, #0x610
a01b85cc pop {r4, r5, r6, r7, r8, pc}
a01b85d0 mvn r4, #2
a01b85d4 b #0xa01b84fc
a01b85d8 mvn r4, #3
a01b85dc b #0xa01b84fc
a01b85e0 mvn r4, #0
a01b85e4 b #0xa01b84fc
a01b85e8 add r4, r4, #6
a01b85ec mov r0, r4
a01b85f0 blx #0xa04f99f0
a01b85f4 ldr r3, [sp, #0x628]
a01b85f8 uxth r1, r0
a01b85fc mov r2, r7
a01b8600 str r8, [sp]
a01b8604 mov r0, r4
a01b8608 str r3, [sp, #4]
a01b860c mov r3, r6
a01b8610 bl #0xa01b8134
a01b8614 movw r0, #0xffe4
a01b8618 movw r2, #0xfc38
a01b861c mov r1, #0x260
a01b8620 mov r3, r4
a01b8624 movt r0, #0xa056
a01b8628 movt r2, #0xa056
a01b862c bl #0xa02a70ec
a01b8630 mov r1, r5
a01b8634 b #0xa01b8584
