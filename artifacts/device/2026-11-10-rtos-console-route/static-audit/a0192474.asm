a0192474 push {r4, r5, lr}
a0192478 sub sp, sp, #0xc
a019247c mov r4, r0
a0192480 add r0, sp, #4
a0192484 bl #0xa01881f4
a0192488 cmp r4, #0
a019248c bne #0xa019253c
a0192490 movw r3, #0x604c
a0192494 movt r3, #0xa105
a0192498 ldrb r5, [r3]
a019249c cmp r5, #0
a01924a0 bne #0xa01924d4
a01924a4 ldr r2, [sp, #4]
a01924a8 movw r3, #0xb008
a01924ac movt r3, #0xa069
a01924b0 mov r0, r5
a01924b4 ldr r3, [r3]
a01924b8 ldr r2, [r2]
a01924bc cmp r2, r3
a01924c0 beq #0xa01925ac
a01924c4 bl #0xa022f3c8
a01924c8 bl #0xa022f55c
a01924cc bl #0xa01758b0
a01924d0 b #0xa0192514
a01924d4 cmp r5, #1
a01924d8 beq #0xa01925f4
a01924dc cmp r5, #2
a01924e0 beq #0xa01926a4
a01924e4 cmp r5, #3
a01924e8 beq #0xa019263c
a01924ec movw r3, #0x5cd4
a01924f0 movw r0, #0xf298
a01924f4 movt r3, #0xa105
a01924f8 movw r2, #0xebd8
a01924fc ldr r3, [r3]
a0192500 movt r0, #0xa055
a0192504 movt r2, #0xa055
a0192508 movw r1, #0x582
a019250c ldrb r3, [r3, #0x77]
a0192510 bl #0xa02a70ec
a0192514 mov r2, #0
a0192518 movw r3, #0x6040
a019251c movt r3, #0xa105
a0192520 mov r0, r2
a0192524 mov r1, r2
a0192528 str r2, [r3]
a019252c bl #0xa04b2e68
a0192530 mov r0, #0
a0192534 add sp, sp, #0xc
a0192538 pop {r4, r5, pc}
a019253c mov r0, #0
a0192540 bl #0xa04b2bd8
a0192544 movw r3, #0x5cd4
a0192548 movt r3, #0xa105
a019254c ldr r3, [r3]
a0192550 ldrb r4, [r3, #0x77]
a0192554 cmp r4, #0
a0192558 beq #0xa01925d0
a019255c cmp r4, #1
a0192560 beq #0xa0192620
a0192564 cmp r4, #2
a0192568 beq #0xa01926cc
a019256c cmp r4, #3
a0192570 beq #0xa0192644
a0192574 movw r0, #0xf298
a0192578 movw r2, #0xebd8
a019257c mov r3, r4
a0192580 movt r0, #0xa055
a0192584 movt r2, #0xa055
a0192588 movw r1, #0x556
a019258c bl #0xa02a70ec
a0192590 movw r3, #0x6040
a0192594 mov r2, #1
a0192598 movt r3, #0xa105
a019259c mov r0, #0
a01925a0 str r2, [r3]
a01925a4 add sp, sp, #0xc
a01925a8 pop {r4, r5, pc}
a01925ac bl #0xa022f3c8
a01925b0 ldr r3, [sp, #4]
a01925b4 movw r0, #0x315
a01925b8 mov r1, r5
a01925bc mov r2, r5
a01925c0 movt r0, #0xf001
a01925c4 ldr r3, [r3, #0x28]
a01925c8 blx r3
a01925cc b #0xa0192514
a01925d0 mov r0, #1
a01925d4 bl #0xa022f3c8
a01925d8 bl #0xa022f364
a01925dc bl #0xa017575c
a01925e0 bl #0xa022f4b4
a01925e4 movw r3, #0x604c
a01925e8 movt r3, #0xa105
a01925ec strb r4, [r3]
a01925f0 b #0xa0192590
a01925f4 mov r0, r4
a01925f8 bl #0xa0231038
a01925fc ldr r2, [sp, #4]
a0192600 movw r3, #0xb038
a0192604 movt r3, #0xa069
a0192608 ldr r3, [r3]
a019260c ldr r1, [r2]
a0192610 cmp r1, r3
a0192614 beq #0xa0192700
a0192618 bl #0xa0231384
a019261c b #0xa0192514
a0192620 mov r0, r4
a0192624 bl #0xa0231038
a0192628 bl #0xa0231058
a019262c movw r3, #0x604c
a0192630 movt r3, #0xa105
a0192634 strb r4, [r3]
a0192638 b #0xa0192590
a019263c bl #0xa0233938
a0192640 b #0xa0192514
a0192644 movw r0, #0xf220
a0192648 movw r2, #0xebd8
a019264c movt r2, #0xa055
a0192650 movw r1, #0x54e
a0192654 movt r0, #0xa055
a0192658 bl #0xa02a70ec
a019265c ldr r3, [sp, #4]
a0192660 mov r1, #0
a0192664 movw r0, #0x139
a0192668 mov r2, r1
a019266c movt r0, #0xf0ff
a0192670 ldr r3, [r3, #0x28]
a0192674 blx r3
a0192678 movw r0, #0xf25c
a019267c movw r2, #0xebd8
a0192680 movt r2, #0xa055
a0192684 mov r1, #0x550
a0192688 movt r0, #0xa055
a019268c bl #0xa02a70ec
a0192690 bl #0xa0233608
a0192694 movw r3, #0x604c
a0192698 movt r3, #0xa105
a019269c strb r4, [r3]
a01926a0 b #0xa0192590
a01926a4 movw r0, #0xf2c8
a01926a8 movw r2, #0xebd8
a01926ac movt r2, #0xa055
a01926b0 movw r1, #0x578
a01926b4 movt r0, #0xa055
a01926b8 bl #0xa02a70ec
a01926bc bl #0xa0232164
a01926c0 mov r0, r4
a01926c4 bl #0xa02965c0
a01926c8 b #0xa0192514
a01926cc movw r3, #0x307c
a01926d0 movw r0, #0xf1f4
a01926d4 movt r3, #0xa06f
a01926d8 movt r0, #0xa055
a01926dc ldr r1, [r3, #8]
a01926e0 bl #0xa02a70ec
a01926e4 bl #0xa0231fc8
a01926e8 mov r0, #1
a01926ec bl #0xa02965c0
a01926f0 movw r3, #0x604c
a01926f4 movt r3, #0xa105
a01926f8 strb r4, [r3]
a01926fc b #0xa0192590
a0192700 movw r0, #0x315
a0192704 ldr r3, [r2, #0x28]
a0192708 mov r1, r4
a019270c mov r2, r4
a0192710 movt r0, #0xf001
a0192714 blx r3
a0192718 b #0xa0192514
