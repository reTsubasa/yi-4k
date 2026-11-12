00010768 push     {r0, r1, r4, r5, r6, r7, r8, lr}
0001076c mov      r5, #0
00010770 mov      r7, r0
00010774 mov      r6, r1
00010778 mov      r8, r5
0001077c str      r8, [sp]
00010780 mov      r1, r6
00010784 ldr      r3, [pc, #0xc4]
00010788 mov      r0, r7
0001078c ldr      r2, [pc, #0xc0]
00010790 bl       #0x10710 ; getopt_long
00010794 cmn      r0, #1
00010798 mov      r4, r0
0001079c beq      #0x107b4
000107a0 cmp      r4, #0x66
000107a4 mov      r5, #1
000107a8 beq      #0x1077c
000107ac ldr      r0, [r6]
000107b0 bl       #0x10af4
000107b4 bl       #0x10738 ; AmbaEventNotify_Init
000107b8 cmp      r0, #0
000107bc bge      #0x107d0
000107c0 ldr      r0, [pc, #0x90]
000107c4 bl       #0x106ec ; puts
000107c8 mov      r0, r4
000107cc b        #0x10848
000107d0 cmp      r5, #0
000107d4 bne      #0x107e4
000107d8 mov      r1, #1
000107dc mov      r0, r5
000107e0 bl       #0x106e0 ; daemon
000107e4 ldr      r0, [pc, #0x70]
000107e8 blx      #0x10b6c
000107ec ldr      r1, [pc, #0x6c]
000107f0 mov      r0, #0xf
000107f4 bl       #0x106bc ; signal
000107f8 ldr      r1, [pc, #0x60]
000107fc mov      r0, #1
00010800 bl       #0x106bc ; signal
00010804 ldr      r1, [pc, #0x54]
00010808 mov      r0, #0xa
0001080c bl       #0x106bc ; signal
00010810 ldr      r1, [pc, #0x48]
00010814 mov      r0, #3
00010818 bl       #0x106bc ; signal
0001081c ldr      r1, [pc, #0x3c]
00010820 mov      r0, #2
00010824 bl       #0x106bc ; signal
00010828 ldr      r1, [pc, #0x30]
0001082c mov      r0, #9
00010830 bl       #0x106bc ; signal
00010834 mov      r1, #0
00010838 ldr      r0, [pc, #0x24]
0001083c bl       #0x106c8 ; AmbaEventNotifier_Reg_cbEvent
00010840 bl       #0x106d4 ; AmbaEventNotifier_ExecEventProcess
00010844 mov      r0, #0
00010848 add      sp, sp, #8
0001084c pop      {r4, r5, r6, r7, r8, pc}
00010850 ldrdeq   r0, r1, [r2], -r0
00010854 andeq    r0, r1, lr, lsr #26
00010858 andeq    r0, r1, r2, lsr sp
0001085c strdeq   r0, r1, [r1], -r0
00010860 andeq    r0, r1, r8, asr #18
00010864 andeq    r0, r1, ip, ror #18
00010868 bleq     #0x4c9ac
0001086c cdpeq    p0, #0, c15, c0, c15, #2
00010870 strbtmi  fp, [sl], -r2, lsl #24
00010874 strlt    fp, [r1], #-0x404
00010878 ldrsbgt  pc, [r0], -pc
0001087c stcgt    p8, c15, [r4, #-0x134]
00010880 blmi     #0x122894
00010884 svc      #0x38f7ff
00010888 svc      #0x68f7ff
0001088c andeq    r0, r1, sb, ror #22
00010890 andeq    r0, r1, r8, ror #14
00010894 andeq    r0, r1, sb, lsr #22
00010898 ldr      r3, [pc, #0x14]
0001089c ldr      r2, [pc, #0x14]
000108a0 add      r3, pc, r3
000108a4 ldr      r2, [r3, r2]
000108a8 cmp      r2, #0
000108ac bxeq     lr
000108b0 b        #0x10704 ; __gmon_start__
000108b4 ldrdeq   r0, r1, [r1], -r0
000108b8 andeq    r0, r0, r8, asr #32
000108bc .byte    0x07, 0x4b, 0x40, 0xf6
000108c0 vshr.s64 q11, q8, #0x40
000108c4 bne      #0x6d08d4
000108c8 stmdble  r5, {r1, r2, r8, sb, fp, sp}
000108cc movweq   pc, #0x240
000108d0 movweq   pc, #0x2c0
000108d4 ldrmi    fp, [r8, -r3, lsl #2]
000108d8 svclt    #0x4770
000108dc strdeq   r0, r1, [r2], -r3
000108e0 mvnsvs   pc, #64, #12
000108e4 rscsvs   pc, r0, r0, asr #12
000108e8 movweq   pc, #0x22c0
000108ec andeq    pc, r2, r0, asr #5
000108f0 addne    r1, sb, sb, lsl sl
000108f4 bicsvc   lr, r1, r1, lsl #22
000108f8 andle    r1, r5, sb, asr #32
000108fc movweq   pc, #0x240
00010900 movweq   pc, #0x2c0
00010904 ldrmi    fp, [r8, -r3, lsl #2]
00010908 svclt    #0x4770
0001090c .byte    0x10, 0xb5, 0x40, 0xf6
00010910 .byte    0xf0, 0x64, 0xc0, 0xf2
00010914 stmdavc  r3!, {r1, sl}
00010918 .byte    0x1b, 0xb9, 0xff, 0xf7
0001091c movwhs   pc, #0x1fcf
00010920 ldclt    p0, c7, [r0, #-0x8c]
00010924 rsbspl   pc, r4, r0, asr #12
00010928 .byte    0x08, 0xb5, 0xc0, 0xf2
0001092c stmdavs  r3, {r1}
00010930 pop      {r0, r1, r4, r8, fp, ip, sp, pc}
00010934 ldrb     r4, [r3, r8]
00010938 movweq   pc, #0x240
0001093c movweq   pc, #0x2c0
00010940 rscsle   r2, r6, r0, lsl #22
00010944 .byte    0x98, 0x47, 0xf4, 0xe7
00010948 mov      r2, r0
0001094c push     {r4, lr}
00010950 ldr      r1, [pc, #0xc]
00010954 ldr      r0, [pc, #0xc]
00010958 bl       #0x106b0 ; printf
0001095c mov      r0, #0
00010960 bl       #0x1071c ; exit
00010964 muleq    r1, ip, fp
00010968 andeq    r0, r1, sp, lsr #23
0001096c sub      r3, r0, #1
00010970 push     {r4, r5, r6, lr}
00010974 mov      r6, r1
00010978 mov      r4, r2
0001097c cmp      r3, #4
00010980 ldrls    pc, [pc, r3, lsl #2]
00010984 b        #0x10a34
00010988 muleq    r1, ip, sb
0001098c andeq    r0, r1, r0, asr #19
00010990 ldrdeq   r0, r1, [r1], -ip
00010994 strdeq   r0, r1, [r1], -r8
00010998 andeq    r0, r1, r8, lsl sl
0001099c ldr      r0, [pc, #0x110]
000109a0 bl       #0x106ec ; puts
000109a4 cmp      r4, #0
000109a8 movne    r1, r6
000109ac ldrne    r0, [pc, #0x104]
000109b0 bne      #0x10a10
000109b4 mov      r1, #0
000109b8 ldr      r0, [pc, #0xfc]
000109bc b        #0x10a10
000109c0 ldr      r0, [pc, #0xf8]
000109c4 bl       #0x106ec ; puts
000109c8 cmp      r4, #0
000109cc movne    r1, r6
000109d0 ldrne    r0, [pc, #0xec]
000109d4 bne      #0x10a10
000109d8 b        #0x109b4
000109dc ldr      r0, [pc, #0xe4]
000109e0 bl       #0x106ec ; puts
000109e4 cmp      r4, #0
000109e8 movne    r1, r6
000109ec ldrne    r0, [pc, #0xd8]
000109f0 bne      #0x10a10
000109f4 b        #0x109b4
000109f8 ldr      r0, [pc, #0xd0]
000109fc bl       #0x106ec ; puts
00010a00 cmp      r4, #0
00010a04 beq      #0x109b4
00010a08 ldr      r0, [pc, #0xc4]
00010a0c mov      r1, r6
00010a10 bl       #0x106b0 ; printf
00010a14 b        #0x10aa8
00010a18 ldr      r0, [pc, #0xb8]
00010a1c bl       #0x106ec ; puts
00010a20 cmp      r4, #0
00010a24 movne    r1, r6
00010a28 ldrne    r0, [pc, #0xac]
00010a2c bne      #0x10a10
00010a30 b        #0x109b4
00010a34 mov      r2, r0
00010a38 ldr      r1, [pc, #0xa0]
00010a3c ldr      r0, [pc, #0xa0]
00010a40 mov      r5, #0
00010a44 bl       #0x106b0 ; printf
00010a48 mov      r0, #0xa
00010a4c bl       #0x10744 ; putchar
00010a50 mov      r1, r4
00010a54 ldr      r0, [pc, #0x8c]
00010a58 bl       #0x106b0 ; printf
00010a5c cmp      r5, r4
00010a60 bge      #0x10aa0
00010a64 ldrb     r1, [r6, r5]
00010a68 ldr      r0, [pc, #0x7c]
00010a6c bl       #0x106b0 ; printf
00010a70 tst      r5, #0xf
00010a74 moveq    r0, #1
00010a78 movne    r0, #0
00010a7c cmp      r5, #0
00010a80 moveq    r0, #0
00010a84 andne    r0, r0, #1
00010a88 cmp      r0, #0
00010a8c beq      #0x10a98
00010a90 mov      r0, #0xa
00010a94 bl       #0x10744 ; putchar
00010a98 add      r5, r5, #1
00010a9c b        #0x10a5c
00010aa0 mov      r0, #0xa
00010aa4 bl       #0x10744 ; putchar
00010aa8 mov      r0, #0xa
00010aac pop      {r4, r5, r6, lr}
00010ab0 b        #0x10744 ; putchar
00010ab4 ldrdeq   r0, r1, [r1], -r0
00010ab8 andeq    r0, r1, sl, lsl #24
00010abc andeq    r0, r1, r7, ror #23
00010ac0 andeq    r0, r1, sl, lsl ip
00010ac4 andeq    r0, r1, r0, lsr ip
00010ac8 andeq    r0, r1, pc, lsr ip
00010acc andeq    r0, r1, r7, asr ip
00010ad0 andeq    r0, r1, r8, ror #24
00010ad4 andeq    r0, r1, lr, ror ip
00010ad8 andeq    r0, r1, sp, lsl #25
00010adc andeq    r0, r1, r3, lsr #25
00010ae0 muleq    r1, r4, fp
00010ae4 strheq   r0, [r1], -r2
00010ae8 andeq    r0, r1, ip, asr #25
00010aec ldrdeq   r0, r1, [r1], -sp
00010af0 b        #0x10750 ; AmbaEventNotify_Release
00010af4 mov      r1, r0
00010af8 push     {r4, lr}
00010afc ldr      r0, [pc, #0x18]
00010b00 bl       #0x106b0 ; printf
00010b04 ldr      r0, [pc, #0x14]
00010b08 bl       #0x106ec ; puts
00010b0c ldr      r0, [pc, #0x10]
00010b10 bl       #0x106ec ; puts
00010b14 mov      r0, #1
00010b18 bl       #0x1071c ; exit
00010b1c andeq    r0, r1, r3, ror #25
00010b20 strdeq   r0, r1, [r1], -r3
00010b24 strdeq   r0, r1, [r1], -lr
00010b28 .byte    0x2d, 0xe9, 0xf8, 0x43
00010b2c stcmi    p6, c4, [ip, #-0x18]
00010b30 ldrmi    r4, [r0], pc, lsl #12
00010b34 .byte    0xdf, 0xf8, 0x2c, 0x90
00010b38 .byte    0x7d, 0x44, 0xff, 0xf7
00010b3c ldrbtmi  lr, [sb], #0xdaa
00010b40 streq    lr, [r5, #-0xbc9]
00010b44 andle    r1, sb, sp, lsr #1
00010b48 .byte    0x00, 0x24, 0x59, 0xf8
00010b4c strbmi   r3, [r2], -r4, lsr #32
00010b50 ldrtmi   r3, [sb], -r1, lsl #8
00010b54 .byte    0x30, 0x46, 0x98, 0x47
00010b58 mvnsle   r4, ip, lsr #5
00010b5c .byte    0xbd, 0xe8, 0xf8, 0x83
00010b60 andeq    r0, r1, r4, lsr r2
00010b64 andeq    r0, r1, sl, lsr #4
00010b68 svclt    #0x4770
00010b6c bmi      #0x163784
00010b70 ldmpl    sl, {r0, r1, r3, r4, r5, r6, sl, lr}
00010b74 ldmdavs  r2, {r1, r8, ip, sp, pc}
00010b78 .byte    0x00, 0x21, 0xff, 0xf7
00010b7c svclt    #0xbdd5
00010b80 andeq    r0, r1, r4, lsl #6
00010b84 andeq    r0, r0, ip, asr #32
