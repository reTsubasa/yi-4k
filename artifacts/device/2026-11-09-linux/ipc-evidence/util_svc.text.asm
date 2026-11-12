00010a0c push     {r4, r5, r6, r7, r8, sb, sl, lr}
00010a10 mov      sb, r0
00010a14 ldr      r6, [pc, #0x188]
00010a18 sub      sp, sp, #0xa0
00010a1c mov      r8, r1
00010a20 mov      r7, #0
00010a24 ldr      r5, [pc, #0x17c]
00010a28 ldr      sl, [pc, #0x17c]
00010a2c add      r6, pc, r6
00010a30 ldr      r4, [pc, #0x178]
00010a34 add      r5, pc, r5
00010a38 add      sl, pc, sl
00010a3c add      r4, pc, r4
00010a40 str      r7, [sp]
00010a44 mov      r3, r5
00010a48 mov      r2, r6
00010a4c mov      r1, r8
00010a50 mov      r0, sb
00010a54 bl       #0x109a0 ; getopt_long
00010a58 cmn      r0, #1
00010a5c beq      #0x10ae8
00010a60 cmp      r0, #0x62
00010a64 beq      #0x10aac
00010a68 cmp      r0, #0x68
00010a6c bne      #0x10ae0
00010a70 ldr      r3, [pc, #0x13c]
00010a74 add      r0, pc, r3
00010a78 bl       #0x10964 ; puts
00010a7c ldr      ip, [pc, #0x134]
00010a80 add      r0, pc, ip
00010a84 bl       #0x10964 ; puts
00010a88 ldr      r0, [pc, #0x12c]
00010a8c add      r0, pc, r0
00010a90 bl       #0x10964 ; puts
00010a94 ldr      r1, [pc, #0x124]
00010a98 add      r0, pc, r1
00010a9c bl       #0x10964 ; puts
00010aa0 mov      r0, #0
00010aa4 add      sp, sp, #0xa0
00010aa8 pop      {r4, r5, r6, r7, r8, sb, sl, pc}
00010aac mov      r1, #1
00010ab0 mov      r0, #0
00010ab4 bl       #0x10958 ; daemon
00010ab8 cmp      r0, #0
00010abc beq      #0x10a40
00010ac0 ldr      lr, [pc, #0xfc]
00010ac4 mov      r2, #0x1e
00010ac8 mov      r1, #1
00010acc mov      r0, sl
00010ad0 ldr      r3, [r4, lr]
00010ad4 ldr      r3, [r3]
00010ad8 bl       #0x10934 ; fwrite
00010adc b        #0x10a40
00010ae0 mvn      r0, #0
00010ae4 b        #0x10aa4
00010ae8 add      r7, sp, #0x14
00010aec mov      r2, #0x8c
00010af0 mov      r1, #0
00010af4 mov      r0, r7
00010af8 bl       #0x109c4 ; memset
00010afc ldr      r3, [pc, #0xc4]
00010b00 mov      ip, #4
00010b04 mov      r1, r7
00010b08 mov      r2, #0
00010b0c mov      r0, #0xf
00010b10 str      ip, [sp, #0x98]
00010b14 add      r8, pc, r3
00010b18 str      r8, [sp, #0x14]
00010b1c bl       #0x10928 ; sigaction
00010b20 cmp      r0, #0
00010b24 blt      #0x10b94
00010b28 ldr      r6, [pc, #0x9c]
00010b2c mov      r1, #2
00010b30 mov      r0, #0x10
00010b34 str      r1, [sp, #0xc]
00010b38 bl       #0x10970 ; malloc
00010b3c mov      r2, #0
00010b40 mov      sb, r0
00010b44 str      r2, [sb, #4]
00010b48 mov      lr, #1
00010b4c str      sb, [sp, #0x10]
00010b50 mov      r0, #0x20000001
00010b54 ldr      r5, [r4, r6]
00010b58 mov      r1, lr
00010b5c ldr      sl, [pc, #0x6c]
00010b60 add      r3, sp, #0xc
00010b64 str      lr, [sb, #0xc]
00010b68 str      r5, [sb]
00010b6c ldr      r7, [pc, #0x60]
00010b70 ldr      r4, [r4, sl]
00010b74 str      lr, [sp]
00010b78 add      r2, pc, r7
00010b7c str      r4, [sb, #8]
00010b80 bl       #0x109d0 ; ambaipc_svc_register
00010b84 movw     r0, #0x9680
00010b88 movt     r0, #0x98
00010b8c bl       #0x1091c ; sleep
00010b90 b        #0x10b84
00010b94 ldr      r0, [pc, #0x3c]
00010b98 add      r0, pc, r0
00010b9c bl       #0x10964 ; puts
00010ba0 b        #0x10b28
00010ba4 andeq    r0, r0, r8, ror r5
00010ba8 andeq    r0, r1, r0, ror #14
00010bac andeq    r0, r0, r4, lsr #9
00010bb0 ldrdeq   r0, r1, [r1], -r0
00010bb4 andeq    r0, r0, r8, lsl #9
00010bb8 muleq    r0, r8, r4
00010bbc strheq   r0, [r0], -r4
00010bc0 ldrdeq   r0, r1, [r0], -r0
00010bc4 andeq    r0, r0, r0, ror r0
00010bc8 andeq    r0, r0, r4, asr #5
00010bcc andeq    r0, r0, ip, ror r0
00010bd0 andeq    r0, r0, ip, rrx
00010bd4 andeq    r0, r0, ip, asr #8
00010bd8 andeq    r0, r0, r0, lsl r4
00010bdc bleq     #0x4cd20
00010be0 cdpeq    p0, #0, c15, c0, c15, #2
00010be4 strbtmi  fp, [sl], -r2, lsl #24
00010be8 strlt    fp, [r1], #-0x404
00010bec ldrsbgt  pc, [r0], -pc
00010bf0 stcgt    p8, c15, [r4, #-0x134]
00010bf4 blmi     #0x122c08
00010bf8 mcr      p7, #6, pc, c0, c15, #7
00010bfc mrc      p7, #7, apsr_nzcv, c10, c15, #7
00010c00 muleq    r1, r1, lr
00010c04 andeq    r0, r1, ip, lsl #20
00010c08 andeq    r0, r1, r1, asr lr
00010c0c ldr      r3, [pc, #0x14]
00010c10 ldr      r2, [pc, #0x14]
00010c14 add      r3, pc, r3
00010c18 ldr      r2, [r3, r2]
00010c1c cmp      r2, #0
00010c20 bxeq     lr
00010c24 b        #0x10994 ; __gmon_start__
00010c28 strdeq   r0, r1, [r1], -r8
00010c2c andeq    r0, r0, r4, ror r0
00010c30 .byte    0x07, 0x4b, 0x41, 0xf2
00010c34 vshr.s64 d17, d28, #0x40
00010c38 bne      #0x6d0c48
00010c3c stmdble  r5, {r1, r2, r8, sb, fp, sp}
00010c40 movweq   pc, #0x240
00010c44 movweq   pc, #0x2c0
00010c48 ldrmi    fp, [r8, -r3, lsl #2]
00010c4c svclt    #0x4770
00010c50 strheq   r1, [r2], -pc
00010c54 .byte    0x41, 0xf2, 0xbc, 0x13
00010c58 adcsne   pc, ip, r1, asr #4
00010c5c movweq   pc, #0x22c0
00010c60 andeq    pc, r2, r0, asr #5
00010c64 addne    r1, sb, sb, lsl sl
00010c68 bicsvc   lr, r1, r1, lsl #22
00010c6c andle    r1, r5, sb, asr #32
00010c70 movweq   pc, #0x240
00010c74 movweq   pc, #0x2c0
00010c78 ldrmi    fp, [r8, -r3, lsl #2]
00010c7c svclt    #0x4770
00010c80 vqrshl.s8 d27, d0, d1
00010c84 .byte    0xbc, 0x14, 0xc0, 0xf2
00010c88 stmdavc  r3!, {r1, sl}
00010c8c .byte    0x1b, 0xb9, 0xff, 0xf7
00010c90 movwhs   pc, #0x1fcf
00010c94 ldclt    p0, c7, [r0, #-0x8c]
00010c98 andeq    pc, r8, r1, asr #4
00010c9c .byte    0x08, 0xb5, 0xc0, 0xf2
00010ca0 stmdavs  r3, {r1}
00010ca4 pop      {r0, r1, r4, r8, fp, ip, sp, pc}
00010ca8 ldrb     r4, [r3, r8]
00010cac movweq   pc, #0x240
00010cb0 movweq   pc, #0x2c0
00010cb4 rscsle   r2, r6, r0, lsl #22
00010cb8 .byte    0x98, 0x47, 0xf4, 0xe7
00010cbc push     {r4, r5, r6, r7, r8, sb, lr}
00010cc0 mov      r4, r0
00010cc4 sub      sp, sp, #0x6c
00010cc8 mov      r0, #0x1000
00010ccc mov      sb, r1
00010cd0 bl       #0x10970 ; malloc
00010cd4 ldr      r1, [pc, #0xf4]
00010cd8 mov      r6, r0
00010cdc ldr      r8, [pc, #0xf0]
00010ce0 mov      r0, r4
00010ce4 add      r1, pc, r1
00010ce8 bl       #0x109dc ; popen
00010cec subs     r7, r0, #0
00010cf0 add      r8, pc, r8
00010cf4 beq      #0x10db0
00010cf8 add      r4, sp, #4
00010cfc mov      r2, r7
00010d00 mov      r1, #0x64
00010d04 mov      r0, r4
00010d08 bl       #0x10904 ; fgets
00010d0c mov      r1, r4
00010d10 mov      r0, r6
00010d14 bl       #0x1094c ; strcpy
00010d18 mov      r0, r4
00010d1c bl       #0x109b8 ; strlen
00010d20 mov      r5, r0
00010d24 b        #0x10d50
00010d28 bl       #0x109b8 ; strlen
00010d2c ldr      r3, [pc, #0xa4]
00010d30 add      r5, r5, r0
00010d34 mov      r1, r4
00010d38 mov      r0, r6
00010d3c ldr      r2, [r8, r3]
00010d40 ldr      ip, [r2]
00010d44 cmp      r5, ip
00010d48 bge      #0x10d6c
00010d4c bl       #0x10940 ; strcat
00010d50 mov      r2, r7
00010d54 mov      r1, #0x64
00010d58 mov      r0, r4
00010d5c bl       #0x10904 ; fgets
00010d60 cmp      r0, #0
00010d64 mov      r0, r4
00010d68 bne      #0x10d28
00010d6c mov      r0, r6
00010d70 bl       #0x109b8 ; strlen
00010d74 add      r8, r0, #1
00010d78 mov      r1, r6
00010d7c mov      r2, r8
00010d80 ldr      r0, [sb, #4]
00010d84 bl       #0x10910 ; memcpy
00010d88 mov      r1, #0
00010d8c mov      r0, r6
00010d90 str      r1, [sb, #0xc]
00010d94 str      r1, [sb, #8]
00010d98 str      r8, [sb]
00010d9c bl       #0x108f8 ; free
00010da0 mov      r0, r7
00010da4 bl       #0x10a00 ; pclose
00010da8 add      sp, sp, #0x6c
00010dac pop      {r4, r5, r6, r7, r8, sb, pc}
00010db0 ldr      r0, [pc, #0x24]
00010db4 mov      r4, #2
00010db8 add      r0, pc, r0
00010dbc bl       #0x10964 ; puts
00010dc0 str      r7, [sb, #8]
00010dc4 str      r4, [sb, #0xc]
00010dc8 add      sp, sp, #0x6c
00010dcc pop      {r4, r5, r6, r7, r8, sb, pc}
00010dd0 strheq   r0, [r0], -r4
00010dd4 andeq    r0, r1, ip, lsl r4
00010dd8 andeq    r0, r0, r8, ror r0
00010ddc andeq    r0, r0, r4, ror #1
00010de0 mov      r1, r0
00010de4 ldr      r0, [pc, #0x1c]
00010de8 push     {r4, lr}
00010dec add      r0, pc, r0
00010df0 bl       #0x108ec ; printf
00010df4 mov      r1, #1
00010df8 mov      r0, #0x20000001
00010dfc bl       #0x109e8 ; ambaipc_svc_unregister
00010e00 mov      r0, #0
00010e04 bl       #0x109ac ; exit
00010e08 andeq    r0, r0, r0, asr #1
00010e0c push     {r4, lr}
00010e10 mov      r4, r1
00010e14 bl       #0x10988 ; system
00010e18 cmp      r0, #0
00010e1c moveq    r3, #1
00010e20 streq    r0, [r4, #0xc]
00010e24 streq    r3, [r4, #8]
00010e28 popeq    {r4, pc}
00010e2c ldr      r0, [pc, #0x18]
00010e30 add      r0, pc, r0
00010e34 bl       #0x10964 ; puts
00010e38 mov      r2, #2
00010e3c mov      r1, #1
00010e40 str      r2, [r4, #0xc]
00010e44 str      r1, [r4, #8]
00010e48 pop      {r4, pc}
00010e4c muleq    r0, r4, r0
00010e50 .byte    0x2d, 0xe9, 0xf8, 0x43
00010e54 stcmi    p6, c4, [ip, #-0x18]
00010e58 ldrmi    r4, [r0], pc, lsl #12
00010e5c .byte    0xdf, 0xf8, 0x2c, 0x90
00010e60 .byte    0x7d, 0x44, 0xff, 0xf7
00010e64 ldrbtmi  lr, [sb], #0xd34
00010e68 streq    lr, [r5, #-0xbc9]
00010e6c andle    r1, sb, sp, lsr #1
00010e70 .byte    0x00, 0x24, 0x59, 0xf8
00010e74 strbmi   r3, [r2], -r4, lsr #32
00010e78 ldrtmi   r3, [sb], -r1, lsl #8
00010e7c .byte    0x30, 0x46, 0x98, 0x47
00010e80 mvnsle   r4, ip, lsr #5
00010e84 .byte    0xbd, 0xe8, 0xf8, 0x83
00010e88 andeq    r0, r1, r0, lsr #3
00010e8c muleq    r1, r6, r1
00010e90 svclt    #0x4770
