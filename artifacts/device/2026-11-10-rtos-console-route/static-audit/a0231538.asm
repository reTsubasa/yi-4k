a0231538 push {r4, r5, r6, r7, r8, lr}
a023153c sub sp, sp, #0x410
a0231540 mov r1, #0
a0231544 mov r2, #0x400
a0231548 add r0, sp, #0x10
a023154c movw r4, #0x63f4
a0231550 blx #0xa04f8dec
a0231554 movw r0, #0xfe5c
a0231558 movw r2, #0xfdd4
a023155c movt r0, #0xa059
a0231560 movt r2, #0xa059
a0231564 mov r1, #0x69
a0231568 movt r4, #0xa06e
a023156c movw r5, #0x6414
a0231570 movw r8, #0x307c
a0231574 mov r7, r4
a0231578 movt r5, #0xa06e
a023157c bl #0xa02a70ec
a0231580 movt r8, #0xa06f
a0231584 b #0xa0231590
a0231588 ldr r0, [r4]
a023158c bl #0xa03bc320
a0231590 ldr r3, [r4, #8]
a0231594 cmp r3, #1
a0231598 bne #0xa0231608
a023159c bl #0xa04b3dc8
a02315a0 cmp r0, #1
a02315a4 bne #0xa0231588
a02315a8 mov r3, #0
a02315ac mov r1, #0x72
a02315b0 ldr r0, [r5]
a02315b4 str r3, [sp, #0xc]
a02315b8 bl #0xa0232518
a02315bc add r1, sp, #0x10
a02315c0 ldr r2, [r7, #4]
a02315c4 mov r3, #0x64
a02315c8 ldr r0, [r5]
a02315cc bl #0xa023297c
a02315d0 subs r1, r0, #0
a02315d4 add r3, sp, #0x10
a02315d8 add r2, sp, #0xc
a02315dc mov r0, r3
a02315e0 ble #0xa0231638
a02315e4 bl #0xa04b3de8
a02315e8 mov r1, #0x72
a02315ec mov r6, r0
a02315f0 ldr r0, [r5]
a02315f4 bl #0xa023273c
a02315f8 cmp r6, #0xd
a02315fc beq #0xa0231648
a0231600 cmp r6, #0
a0231604 beq #0xa0231588
a0231608 movw r0, #0xf7d8
a023160c mov r1, #1
a0231610 movt r0, #0xa142
a0231614 bl #0xa03bc4e8
a0231618 movw r0, #0xfe40
a023161c movw r2, #0xfdd4
a0231620 movt r2, #0xa059
a0231624 mov r1, #0x84
a0231628 movt r0, #0xa059
a023162c bl #0xa02a70ec
a0231630 add sp, sp, #0x410
a0231634 pop {r4, r5, r6, r7, r8, pc}
a0231638 ldr r0, [r5]
a023163c mov r1, #0x72
a0231640 bl #0xa023273c
a0231644 b #0xa0231588
a0231648 movw r0, #0xfe7c
a023164c movw r3, #0xfdd4
a0231650 ldr r1, [r8, #8]
a0231654 movt r3, #0xa059
a0231658 str r6, [sp]
a023165c mov r2, #0x71
a0231660 movt r0, #0xa059
a0231664 bl #0xa02a70ec
a0231668 b #0xa0231590
