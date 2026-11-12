a0233608 push {r4, r5, r6, r7, r8, sb, lr}
a023360c movw r0, #0xcc0
a0233610 movw r5, #0xfb6c
a0233614 sub sp, sp, #0x34
a0233618 mov r4, #0
a023361c movt r0, #0xa05a
a0233620 movt r5, #0xa142
a0233624 str r4, [sp, #0x10]
a0233628 str r4, [sp, #0x14]
a023362c str r4, [sp, #0x18]
a0233630 str r4, [sp, #0x1c]
a0233634 bl #0xa02a70ec
a0233638 ldr r3, [r5]
a023363c cmp r3, #1
a0233640 beq #0xa0233844
a0233644 bl #0xa022f07c
a0233648 mov r0, #5
a023364c bl #0xa022f168
a0233650 cmp r0, #0
a0233654 blt #0xa02338fc
a0233658 mov r1, #9
a023365c mov r2, #0x46
a0233660 mov r3, #0x3000
a0233664 add r0, sp, #0x10
a0233668 strb r1, [sp, #0x10]
a023366c str r2, [sp, #0x18]
a0233670 str r3, [sp, #0x14]
a0233674 bl #0xa04b35b0
a0233678 cmp r0, #0
a023367c blt #0xa0233910
a0233680 movw r6, #0xfa6c
a0233684 movw lr, #0x3340
a0233688 movt r6, #0xa142
a023368c movw ip, #0x32c4
a0233690 ldr r7, [r6]
a0233694 movw r0, #0x316c
a0233698 movw r1, #0x2e74
a023369c movw r2, #0xfb50
a02336a0 movw r3, #0xfa2c
a02336a4 movt lr, #0xa023
a02336a8 cmp r7, #0
a02336ac movt ip, #0xa023
a02336b0 movt r0, #0xa023
a02336b4 movt r1, #0xa023
a02336b8 movt r2, #0xa142
a02336bc movt r3, #0xa142
a02336c0 str lr, [sp, #0x20]
a02336c4 str ip, [sp, #0x24]
a02336c8 str r0, [sp, #0x28]
a02336cc str r1, [sp, #0x2c]
a02336d0 str r4, [r2]
a02336d4 strb r4, [r3]
a02336d8 beq #0xa0233710
a02336dc movw r0, #0xeb0
a02336e0 movw r1, #0x960
a02336e4 movt r0, #0xa05a
a02336e8 movt r1, #0xa05a
a02336ec bl #0xa02a70ec
a02336f0 mov r0, #1
a02336f4 bl #0xa04b2bd8
a02336f8 cmp r0, #0
a02336fc movge r3, #1
a0233700 strge r3, [r5]
a0233704 blt #0xa0233924
a0233708 add sp, sp, #0x34
a023370c pop {r4, r5, r6, r7, r8, sb, pc}
a0233710 movw r4, #0x23e4
a0233714 movw r7, #0xfa0c
a0233718 movt r7, #0xa142
a023371c movt r4, #0xa13a
a0233720 mov r8, #0x20
a0233724 ldr r0, [r4]
a0233728 add r1, r7, #4
a023372c mov r2, r7
a0233730 str r8, [sp]
a0233734 mov r3, #0x1000
a0233738 bl #0xa029a7d8
a023373c cmp r0, #0
a0233740 bne #0xa023385c
a0233744 movw r1, #0xfb70
a0233748 ldr r0, [r4]
a023374c movt r1, #0xa142
a0233750 mov r2, #0x100000
a0233754 mov r3, r8
a0233758 bl #0xa03bc77c
a023375c cmp r0, #0
a0233760 bne #0xa0233824
a0233764 movw r1, #0xfb64
a0233768 ldr r0, [r4]
a023376c movt r1, #0xa142
a0233770 mov r2, #0x100000
a0233774 mov r3, r8
a0233778 bl #0xa03bc77c
a023377c cmp r0, #0
a0233780 bne #0xa023387c
a0233784 movw sb, #0xfb54
a0233788 ldr r0, [r4]
a023378c movt sb, #0xa142
a0233790 mov r3, r8
a0233794 mov r1, sb
a0233798 mov r2, #0xa00
a023379c bl #0xa03bc77c
a02337a0 cmp r0, #0
a02337a4 bne #0xa02338bc
a02337a8 movw r0, #0xfa30
a02337ac ldr r1, [sb, #4]
a02337b0 movt r0, #0xa142
a02337b4 mov r2, #0x14
a02337b8 mov r3, #0x80
a02337bc bl #0xa03bc534
a02337c0 cmp r0, #0
a02337c4 bne #0xa023389c
a02337c8 ldr lr, [r7, #4]
a02337cc mov ip, #0x1000
a02337d0 mov r2, #1
a02337d4 movw r1, #0xe64
a02337d8 movw r3, #0x2e90
a02337dc str r2, [sp, #0xc]
a02337e0 stm sp, {r0, lr}
a02337e4 movt r1, #0xa05a
a02337e8 mov r0, r6
a02337ec str ip, [sp, #8]
a02337f0 movt r3, #0xa023
a02337f4 mov r2, #0x64
a02337f8 bl #0xa03bc2bc
a02337fc cmp r0, #0
a0233800 beq #0xa02338dc
a0233804 movw r0, #0xd98
a0233808 movw r1, #0x960
a023380c movw r2, #0xe78
a0233810 movt r1, #0xa05a
a0233814 movt r2, #0xa05a
a0233818 movt r0, #0xa05a
a023381c bl #0xa02a70ec
a0233820 b #0xa02336f0
a0233824 movw r0, #0xd98
a0233828 movw r1, #0x960
a023382c movw r2, #0xdd8
a0233830 movt r1, #0xa05a
a0233834 movt r2, #0xa05a
a0233838 movt r0, #0xa05a
a023383c bl #0xa02a70ec
a0233840 b #0xa02336f0
a0233844 movw r0, #0xce4
a0233848 movt r0, #0xa05a
a023384c bl #0xa02a70ec
a0233850 mov r0, r4
a0233854 add sp, sp, #0x34
a0233858 pop {r4, r5, r6, r7, r8, sb, pc}
a023385c movw r0, #0xd98
a0233860 movw r1, #0x960
a0233864 movw r2, #0xdac
a0233868 movt r1, #0xa05a
a023386c movt r2, #0xa05a
a0233870 movt r0, #0xa05a
a0233874 bl #0xa02a70ec
a0233878 b #0xa02336f0
a023387c movw r0, #0xd98
a0233880 movw r1, #0x960
a0233884 movw r2, #0xdf8
a0233888 movt r1, #0xa05a
a023388c movt r2, #0xa05a
a0233890 movt r0, #0xa05a
a0233894 bl #0xa02a70ec
a0233898 b #0xa02336f0
a023389c movw r0, #0xd98
a02338a0 movw r1, #0x960
a02338a4 movw r2, #0xe40
a02338a8 movt r1, #0xa05a
a02338ac movt r2, #0xa05a
a02338b0 movt r0, #0xa05a
a02338b4 bl #0xa02a70ec
a02338b8 b #0xa02336f0
a02338bc movw r0, #0xd98
a02338c0 movw r1, #0x960
a02338c4 movw r2, #0xe18
a02338c8 movt r1, #0xa05a
a02338cc movt r2, #0xa05a
a02338d0 movt r0, #0xa05a
a02338d4 bl #0xa02a70ec
a02338d8 b #0xa02336f0
a02338dc add r0, sp, #0x20
a02338e0 bl #0xa04b6128
a02338e4 movw r0, #0xe98
a02338e8 movw r1, #0x960
a02338ec movt r1, #0xa05a
a02338f0 movt r0, #0xa05a
a02338f4 bl #0xa02a70ec
a02338f8 b #0xa02336f0
a02338fc movw r0, #0xd20
a0233900 movt r0, #0xa05a
a0233904 bl #0xa02a70ec
a0233908 mvn r0, #0
a023390c b #0xa0233708
a0233910 movw r0, #0xd5c
a0233914 movt r0, #0xa05a
a0233918 bl #0xa02a70ec
a023391c mvn r0, #1
a0233920 b #0xa0233708
a0233924 movw r0, #0xedc
a0233928 movt r0, #0xa05a
a023392c bl #0xa02a70ec
a0233930 mvn r0, #3
a0233934 b #0xa0233708
