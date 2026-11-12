
FUNCTION 0xa046e6fc
a046e6fc push     {r3, r4, r5, r6, r7, r8, sb, lr}
a046e700 movw     r3, #0xfd38
a046e704 movt     r3, #0xa045
a046e708 ldr      r4, [pc, #0x74]
a046e70c cmp      r3, #0
a046e710 mov      r6, #1
a046e714 moveq    r6, r3
a046e718 mov      sb, r0
a046e71c uxtb     r6, r6
a046e720 add      r7, r4, #0x3f0
a046e724 mov      r0, r4
a046e728 mvn      r1, #0
a046e72c bl       #0xa03bc46c
a046e730 ldrb     r5, [r4, #0x34]
a046e734 mov      r0, r4
a046e738 ldr      r8, [r4, #-4]
a046e73c add      r4, r4, #0x150
a046e740 bl       #0xa03bc498
a046e744 ldr      r3, [sb, #4]
a046e748 cmp      r5, #0
a046e74c movne    r2, #0
a046e750 andeq    r2, r6, #1
a046e754 cmp      r3, r5
a046e758 movne    r3, #0
a046e75c andeq    r3, r2, #1
a046e760 cmp      r3, #0
a046e764 bne      #0xa046e778
a046e768 cmp      r4, r7
a046e76c bne      #0xa046e724
a046e770 mov      r0, #0
a046e774 pop      {r3, r4, r5, r6, r7, r8, sb, pc}
a046e778 mov      r0, r8
a046e77c bl       #0xa045fd38
a046e780 b        #0xa046e768

FUNCTION 0xa045fd38
a045fd38 push     {r4, r5, r6, lr}
a045fd3c movw     r4, #0x71a8
a045fd40 movt     r4, #0xa19c
a045fd44 ldr      r3, [r4]
a045fd48 cmp      r3, #0
a045fd4c moveq    r4, r3
a045fd50 bne      #0xa045fd5c
a045fd54 mov      r0, r4
a045fd58 pop      {r4, r5, r6, pc}
a045fd5c mov      r5, r0
a045fd60 mov      r0, #0
a045fd64 bl       #0xa045d570
a045fd68 cmp      r0, #0
a045fd6c bne      #0xa045fdcc
a045fd70 ldr      r6, [pc, #0x5c]
a045fd74 add      r4, r4, #0xb2
a045fd78 ldrb     r3, [r4, #-2]
a045fd7c cmp      r3, #0
a045fd80 beq      #0xa045fd90
a045fd84 ldr      r3, [r4, #0xa]
a045fd88 cmp      r5, r3
a045fd8c beq      #0xa045fdb0
a045fd90 add      r4, r4, #0xf0
a045fd94 cmp      r4, r6
a045fd98 bne      #0xa045fd78
a045fd9c mov      r4, #0
a045fda0 mov      r0, #0
a045fda4 bl       #0xa045d60c
a045fda8 mov      r0, r4
a045fdac pop      {r4, r5, r6, pc}
a045fdb0 mov      r0, r4
a045fdb4 add      r1, r4, #2
a045fdb8 bl       #0xa045d7b8
a045fdbc cmp      r0, #0
a045fdc0 beq      #0xa045fd90
a045fdc4 mvn      r4, #0
a045fdc8 b        #0xa045fda0
a045fdcc mvn      r4, #0
a045fdd0 b        #0xa045fd54

FUNCTION 0xa045d570
a045d570 cmp      r0, #0
a045d574 push     {r4, r5, lr}
a045d578 sub      sp, sp, #0xc
a045d57c beq      #0xa045d59c
a045d580 add      r0, r0, #0x18
a045d584 bl       #0xa03bc498
a045d588 cmp      r0, #0
a045d58c movwne   r2, #0x10cc
a045d590 movne    ip, #0x64
a045d594 movtne   r2, #0xa062
a045d598 bne      #0xa045d5d8
a045d59c ldr      r4, [pc, #0x64]
a045d5a0 add      r5, r4, #0x780
a045d5a4 mov      r0, r4
a045d5a8 movw     r1, #0x7530
a045d5ac bl       #0xa03bc46c
a045d5b0 cmp      r0, #0
a045d5b4 add      r4, r4, #0xf0
a045d5b8 bne      #0xa045d5cc
a045d5bc cmp      r4, r5
a045d5c0 bne      #0xa045d5a4
a045d5c4 add      sp, sp, #0xc
a045d5c8 pop      {r4, r5, pc}
a045d5cc movw     r2, #0x10e0
a045d5d0 mov      ip, #0x6c
a045d5d4 movt     r2, #0xa062
a045d5d8 mov      r1, #0
a045d5dc movw     r0, #0xfb8
a045d5e0 movw     r3, #0x19dc
a045d5e4 str      r2, [sp]
a045d5e8 str      ip, [sp, #4]
a045d5ec mov      r2, r1
a045d5f0 movt     r3, #0xa060
a045d5f4 movt     r0, #0xa062
a045d5f8 bl       #0xa02a70ec
a045d5fc mvn      r0, #0
a045d600 add      sp, sp, #0xc
a045d604 pop      {r4, r5, pc}

FUNCTION 0xa045d60c
a045d60c push     {r4, r5, r6, lr}
a045d610 mov      r5, r0
a045d614 ldr      r4, [pc, #0x70]
a045d618 sub      sp, sp, #8
a045d61c add      r6, r4, #0x780
a045d620 cmp      r5, r4
a045d624 add      r0, r4, #0x18
a045d628 add      r4, r4, #0xf0
a045d62c beq      #0xa045d63c
a045d630 bl       #0xa03bc498
a045d634 cmp      r0, #0
a045d638 bne      #0xa045d650
a045d63c cmp      r4, r6
a045d640 bne      #0xa045d620
a045d644 mov      r0, #0
a045d648 add      sp, sp, #8
a045d64c pop      {r4, r5, r6, pc}
a045d650 movw     r2, #0x10cc
a045d654 mov      ip, #0x7c
a045d658 mov      r1, #0
a045d65c movt     r2, #0xa062
a045d660 movw     r0, #0xfb8
a045d664 movw     r3, #0x19dc
a045d668 str      r2, [sp]
a045d66c movt     r3, #0xa060
a045d670 str      ip, [sp, #4]
a045d674 mov      r2, r1
a045d678 movt     r0, #0xa062
a045d67c bl       #0xa02a70ec
a045d680 mvn      r0, #0
a045d684 add      sp, sp, #8
a045d688 pop      {r4, r5, r6, pc}

FUNCTION 0xa045d7b8
a045d7b8 ldrb     r3, [r0]
a045d7bc cmp      r3, #0
a045d7c0 beq      #0xa045d854
a045d7c4 push     {r4, r5, r6, r7, lr}
a045d7c8 mov      r4, #0
a045d7cc sub      sp, sp, #0xc
a045d7d0 mov      r7, r1
a045d7d4 mov      r6, r0
a045d7d8 mov      r5, r4
a045d7dc b        #0xa045d7ec
a045d7e0 ldrb     r3, [r6]
a045d7e4 cmp      r5, r3
a045d7e8 bhs      #0xa045d848
a045d7ec ldr      r3, [r7]
a045d7f0 add      r5, r5, #1
a045d7f4 add      r3, r3, r4
a045d7f8 add      r4, r4, #0xc
a045d7fc ldr      r0, [r3, #8]
a045d800 bl       #0xa029351c
a045d804 cmp      r0, #0
a045d808 beq      #0xa045d7e0
a045d80c movw     r2, #0x10f4
a045d810 movw     ip, #0x537
a045d814 mov      r1, #0
a045d818 movt     r2, #0xa062
a045d81c movw     r0, #0xfb8
a045d820 movw     r3, #0x19dc
a045d824 str      r2, [sp]
a045d828 movt     r3, #0xa060
a045d82c str      ip, [sp, #4]
a045d830 mov      r2, r1
a045d834 movt     r0, #0xa062
a045d838 bl       #0xa02a70ec
a045d83c mvn      r0, #0
a045d840 add      sp, sp, #0xc
a045d844 pop      {r4, r5, r6, r7, pc}
a045d848 mov      r0, #0
a045d84c add      sp, sp, #0xc
a045d850 pop      {r4, r5, r6, r7, pc}
a045d854 mov      r0, #0
a045d858 bx       lr

FUNCTION 0xa029351c
a029351c push     {r4, r5, r6, r7, lr}
a0293520 movw     r4, #0x52ac
a0293524 movt     r4, #0xa144
a0293528 sub      sp, sp, #0xc
a029352c mov      r6, r0
a0293530 mov      r7, lr
a0293534 ldr      r3, [r4]
a0293538 ldr      r5, [r0, #0x40]
a029353c tst      r3, #2
a0293540 bne      #0xa02935b4
a0293544 ldr      r0, [r5, #0x10]
a0293548 mvn      r1, #0
a029354c bl       #0xa03bc46c
a0293550 cmp      r0, #0
a0293554 bne      #0xa02935e8
a0293558 mov      r3, #1
a029355c ldr      r0, [r5, #0x10]
a0293560 strb     r3, [r5, #4]
a0293564 bl       #0xa03bc498
a0293568 subs     r5, r0, #0
a029356c bne      #0xa02935e8
a0293570 ldr      r3, [r4]
a0293574 tst      r3, #2
a0293578 beq      #0xa02935a8
a029357c movw     ip, #0xbb04
a0293580 movw     r0, #0xb8e8
a0293584 movt     ip, #0xa05a
a0293588 movw     r1, #0xc514
a029358c str      r5, [sp, #4]
a0293590 mov      r2, r7
a0293594 mov      r3, r6
a0293598 str      ip, [sp]
a029359c movt     r0, #0xa05a
a02935a0 movt     r1, #0xa05a
a02935a4 bl       #0xa02a70ec
a02935a8 mov      r0, r5
a02935ac add      sp, sp, #0xc
a02935b0 pop      {r4, r5, r6, r7, pc}
a02935b4 movw     r3, #0xbaf8
a02935b8 mov      r2, #0
a02935bc movt     r3, #0xa05a
a02935c0 movw     r0, #0xb8e8
a02935c4 movw     r1, #0xc514
a02935c8 str      r3, [sp]
a02935cc str      r2, [sp, #4]
a02935d0 movt     r1, #0xa05a
a02935d4 mov      r2, lr
a02935d8 mov      r3, r6
a02935dc movt     r0, #0xa05a
a02935e0 bl       #0xa02a70ec
a02935e4 b        #0xa0293544
a02935e8 mvn      r5, #0
a02935ec mov      r0, r5
a02935f0 add      sp, sp, #0xc
a02935f4 pop      {r4, r5, r6, r7, pc}
a02935f8 push     {r4, r5, r6, r7, lr}
