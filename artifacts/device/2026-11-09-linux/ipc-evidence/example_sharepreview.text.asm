00010a14 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
00010a18 mov      r7, r0
00010a1c ldr      r6, [pc, #0x4c0]
00010a20 sub      sp, sp, #0x54
00010a24 mov      fp, r1
00010a28 mov      r3, #0
00010a2c ldr      sl, [pc, #0x4b4]
00010a30 ldr      r4, [pc, #0x4b4]
00010a34 str      r3, [r4, #0x1c]
00010a38 str      r3, [r4, #0x20]
00010a3c mov      r5, #0
00010a40 ldr      r3, [pc, #0x4a8]
00010a44 str      r5, [sp]
00010a48 mov      r1, fp
00010a4c ldr      r2, [pc, #0x4a0]
00010a50 mov      r0, r7
00010a54 bl       #0x1095c ; getopt_long
00010a58 cmn      r0, #1
00010a5c beq      #0x10afc
00010a60 cmp      r0, #0x69
00010a64 beq      #0x10a8c
00010a68 cmp      r0, #0x76
00010a6c mov      r8, #1
00010a70 beq      #0x10a84
00010a74 cmp      r0, #0x64
00010a78 bne      #0x10ab0
00010a7c str      r8, [r4, #0x1c]
00010a80 b        #0x10a3c
00010a84 str      r8, [r4, #0x20]
00010a88 b        #0x10a3c
00010a8c ldr      sb, [sl]
00010a90 mov      r0, sb
00010a94 bl       #0x109d8 ; atoi
00010a98 mov      r2, sb
00010a9c mov      r6, r0
00010aa0 mov      r1, r0
00010aa4 ldr      r0, [pc, #0x44c]
00010aa8 bl       #0x108cc ; printf
00010aac b        #0x10a3c
00010ab0 ldr      r5, [pc, #0x444]
00010ab4 ldr      r2, [fp]
00010ab8 ldr      r1, [pc, #0x440]
00010abc ldr      r0, [r5]
00010ac0 bl       #0x10974 ; fprintf
00010ac4 ldr      r1, [r5]
00010ac8 ldr      r0, [pc, #0x434]
00010acc bl       #0x109f0 ; fputs
00010ad0 ldr      r1, [r5]
00010ad4 ldr      r0, [pc, #0x42c]
00010ad8 bl       #0x109f0 ; fputs
00010adc ldr      r1, [r5]
00010ae0 ldr      r0, [pc, #0x424]
00010ae4 bl       #0x109f0 ; fputs
00010ae8 ldr      r1, [r5]
00010aec ldr      r0, [pc, #0x41c]
00010af0 bl       #0x109f0 ; fputs
00010af4 mov      r0, r8
00010af8 bl       #0x10968 ; exit
00010afc ldr      r0, [r4, #0x1c]
00010b00 cmp      r0, r5
00010b04 beq      #0x10b14
00010b08 mov      r1, #1
00010b0c mov      r0, r5
00010b10 bl       #0x10920 ; daemon
00010b14 ldr      r0, [pc, #0x3f8]
00010b18 mov      r7, #0
00010b1c blx      #0x112e4
00010b20 ldr      r1, [pc, #0x3f0]
00010b24 mov      r0, #0xf
00010b28 bl       #0x108f0 ; signal
00010b2c ldr      r1, [pc, #0x3e4]
00010b30 mov      r0, #1
00010b34 bl       #0x108f0 ; signal
00010b38 ldr      r1, [pc, #0x3d8]
00010b3c mov      r0, #0xa
00010b40 bl       #0x108f0 ; signal
00010b44 ldr      r1, [pc, #0x3cc]
00010b48 mov      r0, #3
00010b4c bl       #0x108f0 ; signal
00010b50 ldr      r1, [pc, #0x3c0]
00010b54 mov      r0, #2
00010b58 bl       #0x108f0 ; signal
00010b5c ldr      r1, [pc, #0x3b4]
00010b60 mov      r0, #9
00010b64 bl       #0x108f0 ; signal
00010b68 mov      r2, #0xc
00010b6c mov      r1, #0
00010b70 ldr      r0, [pc, #0x3a4]
00010b74 bl       #0x10990 ; memset
00010b78 mov      r2, #0xc
00010b7c mov      r1, #0
00010b80 ldr      r0, [pc, #0x398]
00010b84 bl       #0x10990 ; memset
00010b88 mov      r2, #0x18
00010b8c mov      r1, #0
00010b90 ldr      r0, [pc, #0x38c]
00010b94 bl       #0x10990 ; memset
00010b98 str      r7, [r4]
00010b9c bl       #0x110c4
00010ba0 cmp      r0, r7
00010ba4 str      r0, [r4]
00010ba8 bne      #0x10bc4
00010bac ldr      sl, [pc, #0x348]
00010bb0 ldr      r2, [pc, #0x370]
00010bb4 ldr      r1, [pc, #0x370]
00010bb8 ldr      r0, [sl]
00010bbc bl       #0x10974 ; fprintf
00010bc0 b        #0x10c04
00010bc4 mov      r2, #4
00010bc8 mvn      r3, #0
00010bcc stmib    sp, {r2, r3}
00010bd0 add      r2, sp, #0x10
00010bd4 str      r2, [sp]
00010bd8 mov      r3, r7
00010bdc mov      r2, r7
00010be0 mov      r1, #3
00010be4 bl       #0x109c0 ; ambaipc_clnt_call
00010be8 subs     r3, r0, #0
00010bec beq      #0x10eb8
00010bf0 ldr      sb, [pc, #0x304]
00010bf4 ldr      r2, [pc, #0x32c]
00010bf8 ldr      r1, [pc, #0x330]
00010bfc ldr      r0, [sb]
00010c00 bl       #0x10974 ; fprintf
00010c04 ldr      fp, [r4]
00010c08 cmp      fp, #0
00010c0c bne      #0x10c3c
00010c10 bl       #0x110c4
00010c14 ldr      ip, [pc, #0x2d0]
00010c18 cmp      r0, #0
00010c1c str      r0, [ip]
00010c20 bne      #0x10c3c
00010c24 ldr      r6, [pc, #0x2d0]
00010c28 ldr      r2, [pc, #0x304]
00010c2c ldr      r1, [pc, #0x2f8]
00010c30 ldr      r0, [r6]
00010c34 bl       #0x10974 ; fprintf
00010c38 b        #0x10c84
00010c3c ldr      r5, [pc, #0x2a8]
00010c40 mov      r1, #0x18
00010c44 mvn      r3, #0
00010c48 stmib    sp, {r1, r3}
00010c4c mov      r3, #0
00010c50 add      lr, r5, #0x24
00010c54 mov      r2, r3
00010c58 str      lr, [sp]
00010c5c mov      r1, #1
00010c60 ldr      r0, [r4]
00010c64 bl       #0x109c0 ; ambaipc_clnt_call
00010c68 subs     r3, r0, #0
00010c6c beq      #0x10ca0
00010c70 ldr      r4, [pc, #0x284]
00010c74 ldr      r2, [pc, #0x2b8]
00010c78 ldr      r1, [pc, #0x2b0]
00010c7c ldr      r0, [r4]
00010c80 bl       #0x10974 ; fprintf
00010c84 ldr      sb, [pc, #0x270]
00010c88 mvn      r2, #0
00010c8c ldr      r1, [pc, #0x2a4]
00010c90 ldr      r0, [sb]
00010c94 bl       #0x10974 ; fprintf
00010c98 mvn      r0, #0
00010c9c b        #0x10edc
00010ca0 ldr      sb, [r5, #0x2c]
00010ca4 ldr      r7, [r5, #0x28]
00010ca8 ubfx     r3, sb, #0, #0xc
00010cac cmp      r3, #0
00010cb0 ubfx     r0, r7, #0, #0xc
00010cb4 addne    sb, sb, #0x1000
00010cb8 bicne    sb, sb, #0xff0
00010cbc bicne    sb, sb, #0xf
00010cc0 cmp      r0, #0
00010cc4 beq      #0x10cec
00010cc8 bic      r1, r7, #0xff0
00010ccc mov      r2, r7
00010cd0 bic      r8, r1, #0xf
00010cd4 add      sb, sb, #0x1000
00010cd8 mov      r7, r8
00010cdc mov      r3, r8
00010ce0 ldr      r1, [pc, #0x254]
00010ce4 ldr      r0, [pc, #0x254]
00010ce8 bl       #0x108cc ; printf
00010cec mov      r1, sb
00010cf0 mov      r0, r7
00010cf4 bl       #0x110d4
00010cf8 ldr      sl, [r4, #0x24]
00010cfc ldr      r2, [r4, #0x28]
00010d00 str      sb, [r4, #8]
00010d04 ldr      sb, [r4, #0x38]
00010d08 rsb      fp, sl, r2
00010d0c str      r0, [r4, #4]
00010d10 add      ip, r0, fp
00010d14 rsb      r5, r7, ip
00010d18 ubfx     r0, sb, #0, #0xc
00010d1c ldr      r7, [r4, #0x34]
00010d20 cmp      r0, #0
00010d24 addne    sb, sb, #0x1000
00010d28 add      r3, sl, r5
00010d2c bicne    sb, sb, #0xff0
00010d30 str      r5, [r4, #0xc]
00010d34 ubfx     r1, r7, #0, #0xc
00010d38 bicne    sb, sb, #0xf
00010d3c cmp      r1, #0
00010d40 str      r3, [r4, #0x24]
00010d44 beq      #0x10d6c
00010d48 bic      lr, r7, #0xff0
00010d4c mov      r2, r7
00010d50 bic      r8, lr, #0xf
00010d54 add      sb, sb, #0x1000
00010d58 mov      r7, r8
00010d5c mov      r3, r8
00010d60 ldr      r1, [pc, #0x1d4]
00010d64 ldr      r0, [pc, #0x1d8]
00010d68 bl       #0x108cc ; printf
00010d6c mov      r1, sb
00010d70 mov      r0, r7
00010d74 bl       #0x110d4
00010d78 ldr      sl, [r4, #0x30]
00010d7c ldr      r2, [r4, #0x34]
00010d80 str      sb, [r4, #0x14]
00010d84 ldr      sb, [pc, #0x160]
00010d88 rsb      fp, sl, r2
00010d8c str      r0, [r4, #0x10]
00010d90 add      ip, r0, fp
00010d94 mov      r0, #1
00010d98 rsb      r5, r7, ip
00010d9c add      r3, sl, r5
00010da0 str      r5, [r4, #0x18]
00010da4 mov      r5, #0xa
00010da8 str      r3, [r4, #0x30]
00010dac bl       #0x111a4
00010db0 ldr      r7, [r4, #0x24]
00010db4 ldr      r0, [r4, #0x30]
00010db8 ldr      sl, [r7, #4]
00010dbc cmp      sl, #0
00010dc0 str      sl, [r0, #4]
00010dc4 bne      #0x10dd4
00010dc8 ldr      r0, [pc, #0x178]
00010dcc bl       #0x10938 ; puts
00010dd0 b        #0x10e98
00010dd4 add      r1, r7, sl, lsl #2
00010dd8 ldr      r2, [sb, #0xc]
00010ddc ldr      r0, [pc, #0x168]
00010de0 sub      r8, sl, #1
00010de4 ldr      lr, [r1, #0x28]
00010de8 add      fp, lr, r2
00010dec bl       #0x10938 ; puts
00010df0 mov      r1, sl
00010df4 ldr      r0, [pc, #0x154]
00010df8 bl       #0x108cc ; printf
00010dfc ldr      ip, [sb, #0x30]
00010e00 ldr      r0, [pc, #0x14c]
00010e04 ldr      r1, [ip, #4]
00010e08 bl       #0x108cc ; printf
00010e0c mov      r3, #0xc
00010e10 ldr      r0, [pc, #0x140]
00010e14 mla      r7, r3, r8, r7
00010e18 ldr      r1, [r7, #0x10]
00010e1c bl       #0x108cc ; printf
00010e20 ldrh     r1, [r7, #8]
00010e24 ldr      r0, [pc, #0x130]
00010e28 bl       #0x108cc ; printf
00010e2c ldrh     r1, [r7, #0xa]
00010e30 ldr      r0, [pc, #0x128]
00010e34 bl       #0x108cc ; printf
00010e38 ldrh     r1, [r7, #0xc]
00010e3c ldr      r0, [pc, #0x120]
00010e40 bl       #0x108cc ; printf
00010e44 mov      r1, fp
00010e48 ldr      r0, [pc, #0x118]
00010e4c bl       #0x108cc ; printf
00010e50 ldr      r2, [sb, #0x3c]
00010e54 add      r0, sp, #0x10
00010e58 ldr      r1, [pc, #0x10c]
00010e5c bl       #0x109cc ; sprintf
00010e60 ldr      r1, [pc, #0x108]
00010e64 add      r0, sp, #0x10
00010e68 bl       #0x109e4 ; fopen64
00010e6c ldr      r2, [r7, #0x10]
00010e70 mov      r3, r0
00010e74 mov      sl, r0
00010e78 mov      r1, #1
00010e7c mov      r0, fp
00010e80 bl       #0x10908 ; fwrite
00010e84 mov      r0, sl
00010e88 bl       #0x1099c ; fclose
00010e8c ldr      r0, [sb, #0x3c]
00010e90 add      r8, r0, #1
00010e94 str      r8, [sb, #0x3c]
00010e98 mov      r0, r6
00010e9c bl       #0x10914 ; usleep
00010ea0 subs     r5, r5, #1
00010ea4 bne      #0x10db0
00010ea8 mov      r0, r5
00010eac bl       #0x111a4
00010eb0 mov      r0, r5
00010eb4 b        #0x10edc
00010eb8 ldr      r5, [sp, #0x10]
00010ebc cmp      r5, #0
00010ec0 bne      #0x10c04
00010ec4 ldr      r8, [pc, #0x30]
00010ec8 mov      r2, r5
00010ecc ldr      r1, [pc, #0xa0]
00010ed0 ldr      r0, [r8]
00010ed4 bl       #0x10974 ; fprintf
00010ed8 b        #0x10eb0
00010edc add      sp, sp, #0x54
00010ee0 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
00010ee4 andeq    r4, pc, r0, asr #4
00010ee8 andeq    r1, r2, r0, lsr #17
00010eec andeq    r1, r2, r8, lsr #17
00010ef0 andeq    r1, r2, r4, asr r8
00010ef4 andeq    r1, r1, r2, lsl r5
00010ef8 andeq    r1, r1, r7, ror #8
00010efc muleq    r2, r8, r8
00010f00 andeq    r1, r1, r1, lsl #9
00010f04 muleq    r1, r6, r4
00010f08 andeq    r1, r1, r0, lsr #9
00010f0c strheq   r1, [r1], -pc
00010f10 ldrdeq   r1, r2, [r1], -pc
00010f14 andeq    r1, r1, r8, asr r2
00010f18 andeq    r1, r1, r8, asr r0
00010f1c andeq    r1, r2, ip, lsr #17
00010f20 strheq   r1, [r2], -r8
00010f24 andeq    r1, r2, ip, asr #17
00010f28 andeq    r1, r1, fp, lsr #6
00010f2c andeq    r1, r1, r3, lsr #8
00010f30 andeq    r1, r1, pc, lsr r4
00010f34 andeq    r1, r1, r5, asr #6
00010f38 andeq    r1, r1, sb, asr r5
00010f3c andeq    r1, r1, r0, ror #6
00010f40 andeq    r1, r1, r4, lsl #11
00010f44 andeq    r1, r1, r1, asr #11
00010f48 strdeq   r1, r2, [r1], -pc
00010f4c andeq    r1, r1, r5, lsr #12
00010f50 andeq    r1, r1, r3, lsr r6
00010f54 andeq    r1, r1, pc, lsr r6
00010f58 andeq    r1, r1, ip, asr #12
00010f5c andeq    r1, r1, r6, asr r6
00010f60 andeq    r1, r1, r1, ror #12
00010f64 andeq    r1, r1, ip, ror #12
00010f68 andeq    r1, r1, r8, ror r6
00010f6c andeq    r1, r1, r0, lsl #13
00010f70 muleq    r1, sb, r6
00010f74 andeq    r1, r1, r6, lsl r5
00010f78 bleq     #0x4d0bc
00010f7c cdpeq    p0, #0, c15, c0, c15, #2
00010f80 strbtmi  fp, [sl], -r2, lsl #24
00010f84 strlt    fp, [r1], #-0x404
00010f88 ldrsbgt  pc, [r0], -pc
00010f8c stcgt    p8, c15, [r4, #-0x134]
00010f90 blmi     #0x122fa4
00010f94 ldcl     p7, c15, [r6], {0xff}
00010f98 ldc      p7, c15, [r0, #-0x3fc]!
00010f9c andeq    r1, r1, r1, ror #5
00010fa0 andeq    r0, r1, r4, lsl sl
00010fa4 andeq    r1, r1, r1, lsr #5
00010fa8 ldr      r3, [pc, #0x14]
00010fac ldr      r2, [pc, #0x14]
00010fb0 add      r3, pc, r3
00010fb4 ldr      r2, [r3, r2]
00010fb8 cmp      r2, #0
00010fbc bxeq     lr
00010fc0 b        #0x10950 ; __gmon_start__
00010fc4 andeq    r0, r1, r4, lsl r8
00010fc8 andeq    r0, r0, r8, ror r0
00010fcc .byte    0x07, 0x4b, 0x41, 0xf6
00010fd0 vshr.s64 d16, d4, #0x40
00010fd4 bne      #0x6d0fe4
00010fd8 stmdble  r5, {r1, r2, r8, sb, fp, sp}
00010fdc movweq   pc, #0x240
00010fe0 movweq   pc, #0x2c0
00010fe4 ldrmi    fp, [r8, -r3, lsl #2]
00010fe8 svclt    #0x4770
00010fec muleq    r2, r7, r8
00010ff0 orrseq   pc, r4, #0x4100000
00010ff4 addseq   pc, r4, r1, asr #12
00010ff8 movweq   pc, #0x22c0
00010ffc andeq    pc, r2, r0, asr #5
00011000 addne    r1, sb, sb, lsl sl
00011004 bicsvc   lr, r1, r1, lsl #22
00011008 andle    r1, r5, sb, asr #32
0001100c movweq   pc, #0x240
00011010 movweq   pc, #0x2c0
00011014 ldrmi    fp, [r8, -r3, lsl #2]
00011018 svclt    #0x4770
0001101c .byte    0x10, 0xb5, 0x41, 0xf6
00011020 vaddhn.i16 d16, q8, q10
00011024 stmdavc  r3!, {r1, sl}
00011028 .byte    0x1b, 0xb9, 0xff, 0xf7
0001102c movwhs   pc, #0x1fcf
00011030 ldclt    p0, c7, [r0, #-0x8c]
00011034 sbcsvs   pc, r0, r1, asr #4
00011038 .byte    0x08, 0xb5, 0xc0, 0xf2
0001103c stmdavs  r3, {r1}
00011040 pop      {r0, r1, r4, r8, fp, ip, sp, pc}
00011044 ldrb     r4, [r3, r8]
00011048 movweq   pc, #0x240
0001104c movweq   pc, #0x2c0
00011050 rscsle   r2, r6, r0, lsl #22
00011054 .byte    0x98, 0x47, 0xf4, 0xe7
00011058 mov      r2, r0
0001105c push     {r4, lr}
00011060 ldr      r1, [pc, #0xc]
00011064 ldr      r0, [pc, #0xc]
00011068 bl       #0x108cc ; printf
0001106c mov      r0, #0
00011070 bl       #0x10968 ; exit
00011074 andeq    r1, r1, r5, ror #6
00011078 andeq    r1, r1, ip, ror r3
0001107c push     {r4, lr}
00011080 mov      r4, r0
00011084 ldr      r0, [r0]
00011088 cmp      r0, #0
0001108c popeq    {r4, pc}
00011090 ldr      r1, [r4, #4]
00011094 bl       #0x109b4 ; munmap
00011098 cmp      r0, #0
0001109c beq      #0x110b0
000110a0 ldr      r0, [pc, #0x18]
000110a4 bl       #0x108fc ; perror
000110a8 mvn      r0, #0
000110ac pop      {r4, pc}
000110b0 str      r0, [r4]
000110b4 str      r0, [r4, #4]
000110b8 str      r0, [r4, #8]
000110bc pop      {r4, pc}
000110c0 muleq    r1, pc, r3
000110c4 mov      r2, #1
000110c8 mov      r1, #0x1000000c
000110cc mov      r0, r2
000110d0 b        #0x109a8 ; ambaipc_clnt_create
000110d4 push     {r0, r1, r2, r3, r4, r5, r6, r7, r8, lr}
000110d8 mov      r3, r1
000110dc mov      r2, r0
000110e0 mov      r7, r0
000110e4 mov      r8, r1
000110e8 mov      r6, #0
000110ec ldr      r1, [pc, #0x94]
000110f0 ldr      r0, [pc, #0x94]
000110f4 bl       #0x108cc ; printf
000110f8 ldr      r1, [pc, #0x90]
000110fc ldr      r0, [pc, #0x90]
00011100 bl       #0x1092c ; open64
00011104 cmn      r0, #1
00011108 mov      r5, r0
0001110c bne      #0x1111c
00011110 ldr      r0, [pc, #0x80]
00011114 bl       #0x108fc ; perror
00011118 b        #0x11158
0001111c str      r0, [sp]
00011120 mov      r3, #1
00011124 str      r7, [sp, #8]
00011128 mov      r2, #3
0001112c str      r6, [sp, #0xc]
00011130 mov      r1, r8
00011134 mov      r0, r6
00011138 bl       #0x108d8 ; mmap64
0001113c cmn      r0, #1
00011140 mov      r4, r0
00011144 bne      #0x11160
00011148 ldr      r0, [pc, #0x4c]
0001114c bl       #0x108fc ; perror
00011150 mov      r0, r5
00011154 bl       #0x10a08 ; close
00011158 mov      r0, r6
0001115c b        #0x11180
00011160 mov      r2, r0
00011164 mov      r3, r8
00011168 mov      r1, r7
0001116c ldr      r0, [pc, #0x2c]
00011170 bl       #0x108cc ; printf
00011174 mov      r0, r5
00011178 bl       #0x10a08 ; close
0001117c mov      r0, r4
00011180 add      sp, sp, #0x10
00011184 pop      {r4, r5, r6, r7, r8, pc}
00011188 andeq    r1, r1, ip, lsl #6
0001118c strheq   r1, [r1], -r2
00011190 andseq   r1, r0, r2
00011194 ldrdeq   r1, r2, [r1], -sp
00011198 ldrdeq   r1, r2, [r1], -r0
0001119c andeq    r1, r1, r6, ror #7
000111a0 strdeq   r1, r2, [r1], -r6
000111a4 push     {r4, r5, r6, lr}
000111a8 mov      r6, r0
000111ac ldr      r4, [pc, #0x90]
000111b0 sub      sp, sp, #0x18
000111b4 ldr      r3, [r4]
000111b8 mov      r5, r4
000111bc cmp      r3, #0
000111c0 bne      #0x111f0
000111c4 bl       #0x110c4
000111c8 cmp      r0, #0
000111cc str      r0, [r4]
000111d0 bne      #0x111f0
000111d4 ldr      ip, [pc, #0x6c]
000111d8 ldr      r2, [pc, #0x6c]
000111dc ldr      r1, [pc, #0x6c]
000111e0 ldr      r0, [ip]
000111e4 bl       #0x10974 ; fprintf
000111e8 mvn      r0, #0
000111ec b        #0x1123c
000111f0 mov      r3, #4
000111f4 add      r2, sp, #0x18
000111f8 add      r1, sp, #0x14
000111fc mvn      r4, #0
00011200 str      r6, [r2, #-8]!
00011204 stmib    sp, {r3, r4}
00011208 str      r1, [sp]
0001120c mov      r1, #2
00011210 ldr      r0, [r5]
00011214 bl       #0x109c0 ; ambaipc_clnt_call
00011218 subs     r3, r0, #0
0001121c ldreq    r0, [sp, #0x14]
00011220 beq      #0x1123c
00011224 ldr      r0, [pc, #0x1c]
00011228 ldr      r2, [pc, #0x1c]
0001122c ldr      r1, [pc, #0x20]
00011230 ldr      r0, [r0]
00011234 bl       #0x10974 ; fprintf
00011238 b        #0x111e8
0001123c add      sp, sp, #0x18
00011240 pop      {r4, r5, r6, pc}
00011244 andeq    r1, r2, r8, lsr #17
00011248 muleq    r2, r8, r8
0001124c andeq    r1, r1, r4, lsl r3
00011250 andeq    r1, r1, r3, lsr #8
00011254 andeq    r1, r1, pc, lsr r4
00011258 push     {r4, lr}
0001125c mov      r0, #0
00011260 ldr      r4, [pc, #0x2c]
00011264 bl       #0x111a4
00011268 ldr      r0, [r4]
0001126c cmp      r0, #0
00011270 beq      #0x11280
00011274 bl       #0x108e4 ; ambaipc_clnt_destroy
00011278 cmp      r0, #0
0001127c streq    r0, [r4]
00011280 ldr      r0, [pc, #0x10]
00011284 bl       #0x1107c
00011288 ldr      r0, [pc, #0xc]
0001128c pop      {r4, lr}
00011290 b        #0x1107c
00011294 andeq    r1, r2, r8, lsr #17
00011298 andeq    r1, r2, ip, lsr #17
0001129c strheq   r1, [r2], -r8
000112a0 .byte    0x2d, 0xe9, 0xf8, 0x43
000112a4 stcmi    p6, c4, [ip, #-0x18]
000112a8 ldrmi    r4, [r0], pc, lsl #12
000112ac .byte    0xdf, 0xf8, 0x2c, 0x90
000112b0 .byte    0x7d, 0x44, 0xff, 0xf7
000112b4 ldrbtmi  lr, [sb], #0xafc
000112b8 streq    lr, [r5, #-0xbc9]
000112bc andle    r1, sb, sp, lsr #1
000112c0 .byte    0x00, 0x24, 0x59, 0xf8
000112c4 strbmi   r3, [r2], -r4, lsr #32
000112c8 ldrtmi   r3, [sb], -r1, lsl #8
000112cc .byte    0x30, 0x46, 0x98, 0x47
000112d0 mvnsle   r4, ip, lsr #5
000112d4 .byte    0xbd, 0xe8, 0xf8, 0x83
000112d8 andeq    r0, r1, r8, lsl r4
000112dc andeq    r0, r1, lr, lsl #8
000112e0 svclt    #0x4770
000112e4 bmi      #0x163efc
000112e8 ldmpl    sl, {r0, r1, r3, r4, r5, r6, sl, lr}
000112ec ldmdavs  r2, {r1, r8, ip, sp, pc}
000112f0 .byte    0x00, 0x21, 0xff, 0xf7
000112f4 svclt    #0xbb45
000112f8 andeq    r0, r1, r0, ror #9
000112fc andeq    r0, r0, ip, ror r0
