00010740 push     {r4, r5, r6, r7, r8, lr}
00010744 sub      sp, sp, #0x200
00010748 mov      r7, r0
0001074c mov      r5, r1
00010750 mov      r2, #0x200
00010754 mov      r1, #0
00010758 mov      r0, sp
0001075c bl       #0x10710 ; memset
00010760 cmp      r7, #1
00010764 ble      #0x10bd4
00010768 bl       #0x10704 ; AmbaEventNotify_Init
0001076c subs     r4, r0, #0
00010770 bge      #0x10780
00010774 ldr      r0, [pc, #0x46c]
00010778 bl       #0x106ac ; puts
0001077c b        #0x10bdc
00010780 ldr      r0, [pc, #0x464]
00010784 blx      #0x10da8
00010788 ldr      r6, [r5, #4]
0001078c ldr      r1, [pc, #0x45c]
00010790 mov      r0, r6
00010794 bl       #0x10688 ; strcmp
00010798 subs     r2, r0, #0
0001079c moveq    r1, r2
000107a0 moveq    r0, #0x10000001
000107a4 beq      #0x1083c
000107a8 ldr      r1, [pc, #0x444]
000107ac mov      r0, r6
000107b0 bl       #0x10688 ; strcmp
000107b4 subs     r1, r0, #0
000107b8 bne      #0x10844
000107bc mov      r6, #2
000107c0 mov      r2, #0x200
000107c4 mov      r0, sp
000107c8 bl       #0x10710 ; memset
000107cc cmp      r6, r7
000107d0 beq      #0x10810
000107d4 cmp      r6, #2
000107d8 mov      r0, sp
000107dc beq      #0x107f0
000107e0 bl       #0x106dc ; strlen
000107e4 ldr      r3, [r5, r6, lsl #2]
000107e8 ldr      r2, [pc, #0x408]
000107ec b        #0x107fc
000107f0 bl       #0x106dc ; strlen
000107f4 ldr      r3, [r5, #8]
000107f8 ldr      r2, [pc, #0x3fc]
000107fc rsb      r1, r0, #0x200
00010800 add      r0, sp, r0
00010804 bl       #0x106e8 ; snprintf
00010808 add      r6, r6, #1
0001080c b        #0x107cc
00010810 ldr      r0, [pc, #0x3e8]
00010814 bl       #0x106a0 ; usleep
00010818 ldrb     r2, [sp]
0001081c cmp      r2, #0
00010820 moveq    r1, r2
00010824 beq      #0x10838
00010828 mov      r0, sp
0001082c bl       #0x106dc ; strlen
00010830 mov      r1, sp
00010834 add      r2, r0, #1
00010838 ldr      r0, [pc, #0x3c4]
0001083c bl       #0x10734 ; AmbaEventNotify_Send
00010840 b        #0x10be0
00010844 ldr      r1, [pc, #0x3bc]
00010848 mov      r0, r6
0001084c bl       #0x10688 ; strcmp
00010850 subs     r2, r0, #0
00010854 bne      #0x10878
00010858 mov      r1, r2
0001085c ldr      r0, [r5, #8]
00010860 bl       #0x106d0 ; strtoul
00010864 mov      r2, #4
00010868 str      r0, [sp]
0001086c mov      r1, sp
00010870 ldr      r0, [pc, #0x394]
00010874 b        #0x1083c
00010878 ldr      r1, [pc, #0x390]
0001087c mov      r0, r6
00010880 bl       #0x10688 ; strcmp
00010884 subs     r1, r0, #0
00010888 bne      #0x10908
0001088c mov      r4, #2
00010890 mov      r2, #0x200
00010894 mov      r0, sp
00010898 bl       #0x10710 ; memset
0001089c cmp      r4, r7
000108a0 beq      #0x108e0
000108a4 cmp      r4, #2
000108a8 mov      r0, sp
000108ac beq      #0x108c0
000108b0 bl       #0x106dc ; strlen
000108b4 ldr      r3, [r5, r4, lsl #2]
000108b8 ldr      r2, [pc, #0x338]
000108bc b        #0x108cc
000108c0 bl       #0x106dc ; strlen
000108c4 ldr      r3, [r5, #8]
000108c8 ldr      r2, [pc, #0x32c]
000108cc rsb      r1, r0, #0x200
000108d0 add      r0, sp, r0
000108d4 bl       #0x106e8 ; snprintf
000108d8 add      r4, r4, #1
000108dc b        #0x1089c
000108e0 ldrb     r2, [sp]
000108e4 cmp      r2, #0
000108e8 moveq    r1, r2
000108ec beq      #0x10900
000108f0 mov      r0, sp
000108f4 bl       #0x106dc ; strlen
000108f8 mov      r1, sp
000108fc add      r2, r0, #1
00010900 mov      r0, #0x10000002
00010904 b        #0x1083c
00010908 ldr      r1, [pc, #0x304]
0001090c mov      r0, r6
00010910 bl       #0x10688 ; strcmp
00010914 subs     r8, r0, #0
00010918 bne      #0x1095c
0001091c mov      r2, r8
00010920 mov      r1, r8
00010924 ldr      r0, [r5, #8]
00010928 bl       #0x106d0 ; strtoul
0001092c mov      r2, r8
00010930 mov      r7, r0
00010934 mov      r1, r8
00010938 ldr      r0, [r5, #0xc]
0001093c bl       #0x106d0 ; strtoul
00010940 uxth     r0, r0
00010944 mov      r2, #4
00010948 orr      r1, r0, r7, lsl #16
0001094c ldr      r0, [pc, #0x2c4]
00010950 str      r1, [sp]
00010954 mov      r1, sp
00010958 b        #0x1083c
0001095c ldr      r1, [pc, #0x2b8]
00010960 mov      r0, r6
00010964 bl       #0x10688 ; strcmp
00010968 subs     r1, r0, #0
0001096c bne      #0x109ec
00010970 mov      r8, #2
00010974 mov      r2, #0x200
00010978 mov      r0, sp
0001097c bl       #0x10710 ; memset
00010980 cmp      r8, r7
00010984 beq      #0x109c4
00010988 cmp      r8, #2
0001098c mov      r0, sp
00010990 beq      #0x109a4
00010994 bl       #0x106dc ; strlen
00010998 ldr      r3, [r5, r8, lsl #2]
0001099c ldr      r2, [pc, #0x254]
000109a0 b        #0x109b0
000109a4 bl       #0x106dc ; strlen
000109a8 ldr      r3, [r5, #8]
000109ac ldr      r2, [pc, #0x248]
000109b0 rsb      r1, r0, #0x200
000109b4 add      r0, sp, r0
000109b8 bl       #0x106e8 ; snprintf
000109bc add      r8, r8, #1
000109c0 b        #0x10980
000109c4 ldrb     r2, [sp]
000109c8 cmp      r2, #0
000109cc moveq    r1, r2
000109d0 beq      #0x109e4
000109d4 mov      r0, sp
000109d8 bl       #0x106dc ; strlen
000109dc mov      r1, sp
000109e0 add      r2, r0, #1
000109e4 ldr      r0, [pc, #0x234]
000109e8 b        #0x1083c
000109ec ldr      r1, [pc, #0x230]
000109f0 mov      r0, r6
000109f4 bl       #0x10688 ; strcmp
000109f8 subs     r2, r0, #0
000109fc bne      #0x10a20
00010a00 mov      r1, r2
00010a04 ldr      r0, [r5, #8]
00010a08 bl       #0x106d0 ; strtoul
00010a0c mov      r2, #4
00010a10 str      r0, [sp]
00010a14 mov      r1, sp
00010a18 ldr      r0, [pc, #0x208]
00010a1c b        #0x1083c
00010a20 ldr      r1, [pc, #0x204]
00010a24 mov      r0, r6
00010a28 bl       #0x10688 ; strcmp
00010a2c cmp      r0, #0
00010a30 moveq    r2, #0
00010a34 moveq    r0, #0x10000003
00010a38 moveq    r1, r2
00010a3c beq      #0x1083c
00010a40 ldr      r1, [pc, #0x1e8]
00010a44 mov      r0, r6
00010a48 bl       #0x10688 ; strcmp
00010a4c subs     r2, r0, #0
00010a50 moveq    r1, r2
00010a54 moveq    r0, #0x10000004
00010a58 beq      #0x1083c
00010a5c ldr      r1, [pc, #0x1d0]
00010a60 mov      r0, r6
00010a64 bl       #0x10688 ; strcmp
00010a68 subs     r2, r0, #0
00010a6c moveq    r1, r2
00010a70 moveq    r0, #0x10000005
00010a74 beq      #0x1083c
00010a78 ldr      r1, [pc, #0x1b8]
00010a7c mov      r0, r6
00010a80 bl       #0x10688 ; strcmp
00010a84 cmp      r0, #0
00010a88 bne      #0x10ad8
00010a8c ldr      r6, [r5, #8]
00010a90 ldr      r1, [pc, #0x1a4]
00010a94 mov      r0, r6
00010a98 bl       #0x10688 ; strcmp
00010a9c subs     r2, r0, #0
00010aa0 moveq    r1, r2
00010aa4 ldreq    r0, [pc, #0x194]
00010aa8 beq      #0x1083c
00010aac ldr      r1, [pc, #0x190]
00010ab0 mov      r0, r6
00010ab4 bl       #0x10688 ; strcmp
00010ab8 subs     r2, r0, #0
00010abc moveq    r1, r2
00010ac0 ldreq    r0, [pc, #0x180]
00010ac4 beq      #0x1083c
00010ac8 ldr      r0, [pc, #0x17c]
00010acc bl       #0x106ac ; puts
00010ad0 mov      r0, r4
00010ad4 b        #0x10be0
00010ad8 ldr      r1, [pc, #0x170]
00010adc mov      r0, r6
00010ae0 bl       #0x10688 ; strcmp
00010ae4 subs     r2, r0, #0
00010ae8 moveq    r1, r2
00010aec ldreq    r0, [pc, #0x160]
00010af0 beq      #0x1083c
00010af4 ldr      r1, [pc, #0x15c]
00010af8 mov      r0, r6
00010afc bl       #0x10688 ; strcmp
00010b00 subs     r2, r0, #0
00010b04 moveq    r1, r2
00010b08 ldreq    r0, [pc, #0x14c]
00010b0c beq      #0x1083c
00010b10 ldr      r1, [pc, #0x148]
00010b14 mov      r0, r6
00010b18 bl       #0x10688 ; strcmp
00010b1c subs     r2, r0, #0
00010b20 bne      #0x10b44
00010b24 mov      r1, r2
00010b28 ldr      r0, [r5, #8]
00010b2c bl       #0x106d0 ; strtoul
00010b30 mov      r2, #4
00010b34 str      r0, [sp]
00010b38 mov      r1, sp
00010b3c ldr      r0, [pc, #0x120]
00010b40 b        #0x1083c
00010b44 ldr      r1, [pc, #0x11c]
00010b48 mov      r0, r6
00010b4c bl       #0x10688 ; strcmp
00010b50 subs     r1, r0, #0
00010b54 bne      #0x10bd4
00010b58 mov      r4, #2
00010b5c mov      r2, #0x200
00010b60 mov      r0, sp
00010b64 bl       #0x10710 ; memset
00010b68 cmp      r4, r7
00010b6c bge      #0x10bac
00010b70 cmp      r4, #2
00010b74 mov      r0, sp
00010b78 beq      #0x10b8c
00010b7c bl       #0x106dc ; strlen
00010b80 ldr      r3, [r5, r4, lsl #2]
00010b84 ldr      r2, [pc, #0x6c]
00010b88 b        #0x10b98
00010b8c bl       #0x106dc ; strlen
00010b90 ldr      r3, [r5, #8]
00010b94 ldr      r2, [pc, #0x60]
00010b98 rsb      r1, r0, #0x200
00010b9c add      r0, sp, r0
00010ba0 bl       #0x106e8 ; snprintf
00010ba4 add      r4, r4, #1
00010ba8 b        #0x10b68
00010bac ldrb     r2, [sp]
00010bb0 cmp      r2, #0
00010bb4 moveq    r1, r2
00010bb8 beq      #0x10bcc
00010bbc mov      r0, sp
00010bc0 bl       #0x106dc ; strlen
00010bc4 mov      r1, sp
00010bc8 add      r2, r0, #1
00010bcc ldr      r0, [pc, #0x98]
00010bd0 b        #0x1083c
00010bd4 ldr      r0, [r5]
00010bd8 bl       #0x10d54
00010bdc mvn      r0, #0
00010be0 add      sp, sp, #0x200
00010be4 pop      {r4, r5, r6, r7, r8, pc}
00010be8 andeq    r1, r1, r7, asr #32
00010bec andeq    r0, r1, r0, asr sp
00010bf0 andeq    r1, r1, ip, rrx
00010bf4 andeq    r1, r1, r6, ror r0
00010bf8 andeq    r1, r1, sp, ror r0
00010bfc andeq    r1, r1, lr, ror r0
00010c00 subseq   r8, fp, r0, lsl #27
00010c04 strdne   r0, r1, [r0], -ip
00010c08 andeq    r1, r1, r1, lsl #1
00010c0c andne    r0, r0, sl, lsl r0
00010c10 andeq    r1, r1, sl, lsl #1
00010c14 muleq    r1, r4, r0
00010c18 andne    r0, r0, r5, lsl r0
00010c1c andeq    r1, r1, r2, lsr #1
00010c20 strdne   r0, r1, [r0], -fp
00010c24 andeq    r1, r1, pc, lsr #1
00010c28 strdne   r0, r1, [r0], -sl
00010c2c strheq   r1, [r1], -r4
00010c30 strheq   r1, [r1], -ip
00010c34 andeq    r1, r1, r2, asr #1
00010c38 andeq    r1, r1, sb, asr #1
00010c3c andeq    r1, r1, pc, asr #1
00010c40 andne    r0, r0, sb, ror #7
00010c44 ldrdeq   r1, r2, [r1], -r1
00010c48 andne    r0, r0, fp, ror #7
00010c4c ldrdeq   r1, r2, [r1], -r3
00010c50 andeq    r1, r1, r7, ror #1
00010c54 andne    r0, r0, r3, lsl r0
00010c58 strdeq   r1, r2, [r1], -r4
00010c5c andne    r0, r0, r4, lsl r0
00010c60 strdeq   r1, r2, [r1], -pc
00010c64 andne    r0, r0, r6, lsl r0
00010c68 andeq    r1, r1, r6, lsl #2
00010c6c andne    r0, r0, sl, ror #7
00010c70 bleq     #0x4cdb4
00010c74 cdpeq    p0, #0, c15, c0, c15, #2
00010c78 strbtmi  fp, [sl], -r2, lsl #24
00010c7c strlt    fp, [r1], #-0x404
00010c80 ldrsbgt  pc, [r0], -pc
00010c84 stcgt    p8, c15, [r4, #-0x134]
00010c88 blmi     #0x122c9c
00010c8c ldc      p7, c15, [r4, #-0x3fc]
00010c90 stcl     p7, c15, [sl, #-0x3fc]
00010c94 andeq    r0, r1, r5, lsr #27
00010c98 andeq    r0, r1, r0, asr #14
00010c9c andeq    r0, r1, r5, ror #26
00010ca0 ldr      r3, [pc, #0x14]
00010ca4 ldr      r2, [pc, #0x14]
00010ca8 add      r3, pc, r3
00010cac ldr      r2, [r3, r2]
00010cb0 cmp      r2, #0
00010cb4 bxeq     lr
00010cb8 b        #0x106c4 ; __gmon_start__
00010cbc andeq    r0, r1, r8, ror r5
00010cc0 andeq    r0, r0, r8, asr #32
00010cc4 .byte    0x07, 0x4b, 0x41, 0xf2
00010cc8 vaddl.s8 q9, d16, d0
00010ccc bne      #0x6d0cdc
00010cd0 stmdble  r5, {r1, r2, r8, sb, fp, sp}
00010cd4 movweq   pc, #0x240
00010cd8 movweq   pc, #0x2c0
00010cdc ldrmi    fp, [r8, -r3, lsl #2]
00010ce0 svclt    #0x4770
00010ce4 andeq    r1, r2, r3, lsl #5
00010ce8 orrhs    pc, r0, #0x10000004
00010cec addhs    pc, r0, r1, asr #4
00010cf0 movweq   pc, #0x22c0
00010cf4 andeq    pc, r2, r0, asr #5
00010cf8 addne    r1, sb, sb, lsl sl
00010cfc bicsvc   lr, r1, r1, lsl #22
00010d00 andle    r1, r5, sb, asr #32
00010d04 movweq   pc, #0x240
00010d08 movweq   pc, #0x2c0
00010d0c ldrmi    fp, [r8, -r3, lsl #2]
00010d10 svclt    #0x4770
00010d14 vqrshl.s8 d27, d0, d1
00010d18 vaddhn.i16 d18, q8, q0
00010d1c stmdavc  r3!, {r1, sl}
00010d20 .byte    0x1b, 0xb9, 0xff, 0xf7
00010d24 movwhs   pc, #0x1fcf
00010d28 ldclt    p0, c7, [r0, #-0x8c]
00010d2c eorne    pc, r4, r1, asr #4
00010d30 .byte    0x08, 0xb5, 0xc0, 0xf2
00010d34 stmdavs  r3, {r1}
00010d38 pop      {r0, r1, r4, r8, fp, ip, sp, pc}
00010d3c ldrb     r4, [r3, r8]
00010d40 movweq   pc, #0x240
00010d44 movweq   pc, #0x2c0
00010d48 rscsle   r2, r6, r0, lsl #22
00010d4c .byte    0x98, 0x47, 0xf4, 0xe7
00010d50 b        #0x1071c ; AmbaEventNotify_Release
00010d54 mov      r1, r0
00010d58 ldr      r0, [pc]
00010d5c b        #0x10694 ; printf
00010d60 ldrdeq   r0, r1, [r1], -r0
00010d64 .byte    0x2d, 0xe9, 0xf8, 0x43
00010d68 stcmi    p6, c4, [ip, #-0x18]
00010d6c ldrmi    r4, [r0], pc, lsl #12
00010d70 .byte    0xdf, 0xf8, 0x2c, 0x90
00010d74 .byte    0x7d, 0x44, 0xff, 0xf7
00010d78 ldrbtmi  lr, [sb], #0xc78
00010d7c streq    lr, [r5, #-0xbc9]
00010d80 andle    r1, sb, sp, lsr #1
00010d84 .byte    0x00, 0x24, 0x59, 0xf8
00010d88 strbmi   r3, [r2], -r4, lsr #32
00010d8c ldrtmi   r3, [sb], -r1, lsl #8
00010d90 .byte    0x30, 0x46, 0x98, 0x47
00010d94 mvnsle   r4, ip, lsr #5
00010d98 .byte    0xbd, 0xe8, 0xf8, 0x83
00010d9c andeq    r0, r1, r8, lsr #7
00010da0 muleq    r1, lr, r3
00010da4 svclt    #0x4770
00010da8 bmi      #0x1639c0
00010dac ldmpl    sl, {r0, r1, r3, r4, r5, r6, sl, lr}
00010db0 ldmdavs  r2, {r1, r8, ip, sp, pc}
00010db4 .byte    0x00, 0x21, 0xff, 0xf7
00010db8 svclt    #0xbc9d
00010dbc andeq    r0, r1, r8, ror r4
00010dc0 andeq    r0, r0, ip, asr #32
