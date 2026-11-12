0001098c push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
00010990 mov      sl, r0
00010994 ldr      r7, [pc, #0x680]
00010998 sub      sp, sp, #0x54
0001099c mov      sb, r1
000109a0 mov      r8, #0
000109a4 ldr      r6, [pc, #0x674]
000109a8 ldr      r4, [pc, #0x674]
000109ac add      r7, pc, r7
000109b0 ldr      r5, [pc, #0x670]
000109b4 add      r6, pc, r6
000109b8 add      fp, pc, r4
000109bc add      r5, pc, r5
000109c0 str      r8, [sp]
000109c4 mov      r3, r6
000109c8 mov      r2, r7
000109cc mov      r1, sb
000109d0 mov      r0, sl
000109d4 bl       #0x10908 ; getopt_long
000109d8 cmn      r0, #1
000109dc beq      #0x10a68
000109e0 cmp      r0, #0x62
000109e4 beq      #0x10a2c
000109e8 cmp      r0, #0x68
000109ec bne      #0x10a60
000109f0 ldr      r1, [pc, #0x634]
000109f4 add      r0, pc, r1
000109f8 bl       #0x108d8 ; puts
000109fc ldr      r3, [pc, #0x62c]
00010a00 add      r0, pc, r3
00010a04 bl       #0x108d8 ; puts
00010a08 ldr      r2, [pc, #0x624]
00010a0c add      r0, pc, r2
00010a10 bl       #0x108d8 ; puts
00010a14 ldr      ip, [pc, #0x61c]
00010a18 add      r0, pc, ip
00010a1c bl       #0x108d8 ; puts
00010a20 mov      r0, #0
00010a24 add      sp, sp, #0x54
00010a28 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
00010a2c mov      r1, #1
00010a30 mov      r0, #0
00010a34 bl       #0x108cc ; daemon
00010a38 cmp      r0, #0
00010a3c beq      #0x109c0
00010a40 ldr      r4, [pc, #0x5f4]
00010a44 mov      r2, #0x1e
00010a48 mov      r1, #1
00010a4c mov      r0, fp
00010a50 ldr      lr, [r5, r4]
00010a54 ldr      r3, [lr]
00010a58 bl       #0x108b4 ; fwrite
00010a5c b        #0x109c0
00010a60 mvn      r0, #0
00010a64 b        #0x10a24
00010a68 mov      r2, #0x19
00010a6c mov      r1, #3
00010a70 mov      r0, #0x10
00010a74 add      sb, sp, #0x44
00010a78 bl       #0x10950 ; socket
00010a7c ldr      r3, [pc, #0x5bc]
00010a80 mov      r8, r0
00010a84 mov      r2, #0xc
00010a88 mov      r1, #0
00010a8c mov      r0, sb
00010a90 mov      fp, #0x6f
00010a94 add      sl, pc, r3
00010a98 str      r8, [sl]
00010a9c bl       #0x10938 ; memset
00010aa0 mov      r1, sb
00010aa4 mov      ip, #0x10
00010aa8 mov      r0, r8
00010aac mov      r2, #0xc
00010ab0 strh     ip, [sp, #0x44]
00010ab4 str      fp, [sp, #0x48]
00010ab8 bl       #0x1092c ; bind
00010abc subs     r1, r0, #0
00010ac0 bne      #0x11008
00010ac4 ldr      r0, [pc, #0x578]
00010ac8 ldr      r6, [pc, #0x578]
00010acc ldr      sb, [r5, r0]
00010ad0 add      r4, pc, r6
00010ad4 ldr      r0, [sb]
00010ad8 bl       #0x113b4
00010adc ldr      r1, [pc, #0x568]
00010ae0 mov      r5, r0
00010ae4 add      r8, r0, #0x4c
00010ae8 add      r6, r5, #0x53
00010aec str      r8, [sp, #0x14]
00010af0 add      r8, r5, #0x54
00010af4 add      r2, pc, r1
00010af8 add      r3, r0, #0x4d
00010afc add      sl, r0, #0x4e
00010b00 add      ip, r0, #0x4f
00010b04 str      r6, [sp, #0x2c]
00010b08 add      r6, r2, #0x20
00010b0c str      r8, [sp, #0x30]
00010b10 add      r8, r4, #0x20
00010b14 add      fp, r0, #0x50
00010b18 add      r7, r0, #0x58
00010b1c str      r3, [sp, #0x18]
00010b20 add      r0, r0, #0x51
00010b24 str      sl, [sp, #0x1c]
00010b28 add      r1, r5, #0x52
00010b2c str      ip, [sp, #0x20]
00010b30 add      r3, r5, #0x55
00010b34 add      sl, r5, #0x56
00010b38 add      ip, r5, #0x57
00010b3c str      fp, [sp, #0xc]
00010b40 str      r0, [sp, #0x24]
00010b44 str      r1, [sp, #0x28]
00010b48 str      r3, [sp, #0x34]
00010b4c str      sl, [sp, #0x38]
00010b50 str      ip, [sp, #0x3c]
00010b54 ldr      lr, [pc, #0x4f4]
00010b58 mov      r1, r5
00010b5c mvn      r3, #0
00010b60 ldr      r2, [sb]
00010b64 add      r4, pc, lr
00010b68 ldr      r0, [r4]
00010b6c bl       #0x112e8
00010b70 ldr      r1, [r5, #0x48]
00010b74 cmp      r1, #4
00010b78 addls    pc, pc, r1, lsl #2
00010b7c b        #0x10f2c
00010b80 b        #0x10d44
00010b84 b        #0x10e90
00010b88 b        #0x10e10
00010b8c b        #0x10c44
00010b90 b        #0x10b94
00010b94 ldr      r2, [pc, #0x4b8]
00010b98 ldr      r1, [r5, #0x40]
00010b9c ldr      sl, [r5, #0x44]
00010ba0 add      fp, pc, r2
00010ba4 ldr      r3, [fp, #0x20]!
00010ba8 cmp      r3, fp
00010bac sub      fp, r3, #0x34
00010bb0 bne      #0x10bc8
00010bb4 b        #0x10f3c
00010bb8 ldr      r4, [fp, #0x34]
00010bbc cmp      r4, r6
00010bc0 sub      fp, r4, #0x34
00010bc4 beq      #0x10f3c
00010bc8 ldr      ip, [fp]
00010bcc cmp      r1, ip
00010bd0 bne      #0x10bb8
00010bd4 ldr      lr, [fp, #4]
00010bd8 cmp      sl, lr
00010bdc bne      #0x10bb8
00010be0 ldr      lr, [pc, #0x470]
00010be4 mov      r2, r0
00010be8 ldr      ip, [fp, #8]
00010bec mov      r1, r5
00010bf0 ldr      r3, [r5, #0x14]
00010bf4 mov      sl, #0
00010bf8 add      r4, pc, lr
00010bfc str      ip, [r5, #0x10]
00010c00 str      r3, [r5, #0x48]
00010c04 ldr      r0, [r4]
00010c08 bl       #0x112b4
00010c0c mov      r1, #1
00010c10 strb     sl, [r5]
00010c14 strb     r1, [r5, #1]
00010c18 mov      ip, #0x70
00010c1c str      sl, [r5, #0x48]
00010c20 mov      r2, #4
00010c24 ldr      fp, [fp, #8]
00010c28 mov      r1, r5
00010c2c ldr      r0, [r4]
00010c30 str      sl, [r5, #0x3c]
00010c34 str      fp, [r5, #0x4c]
00010c38 str      ip, [r5, #0x10]
00010c3c bl       #0x112b4
00010c40 b        #0x10b54
00010c44 ldr      r2, [pc, #0x410]
00010c48 mov      r3, #1
00010c4c mov      lr, #0
00010c50 str      r3, [r5, #0x3c]
00010c54 str      lr, [r5, #0x40]
00010c58 add      r0, pc, r2
00010c5c ldr      r4, [r0, #0x20]!
00010c60 cmp      r4, r0
00010c64 sub      r4, r4, #0x34
00010c68 beq      #0x10cc4
00010c6c ldr      sl, [pc, #0x3ec]
00010c70 add      sl, pc, sl
00010c74 ldr      ip, [r4]
00010c78 add      fp, r4, #0xc
00010c7c mov      r1, fp
00010c80 mov      r0, r7
00010c84 str      ip, [r5, #0x4c]
00010c88 ldr      r2, [r4, #4]
00010c8c str      r2, [r5, #0x50]
00010c90 ldr      r3, [r4, #8]
00010c94 str      r3, [r5, #0x54]
00010c98 bl       #0x108c0 ; strcpy
00010c9c mov      r0, fp
00010ca0 bl       #0x10920 ; strlen
00010ca4 mov      r1, r5
00010ca8 add      r2, r0, #0xd
00010cac ldr      r0, [sl]
00010cb0 bl       #0x112b4
00010cb4 ldr      r1, [r4, #0x34]
00010cb8 cmp      r1, r8
00010cbc sub      r4, r1, #0x34
00010cc0 bne      #0x10c74
00010cc4 ldr      r0, [pc, #0x398]
00010cc8 mov      sl, #0
00010ccc ldr      ip, [sp, #0x14]
00010cd0 mov      r2, #0xc
00010cd4 ldr      fp, [sp, #0x18]
00010cd8 mov      r1, r5
00010cdc add      lr, pc, r0
00010ce0 ldr      r3, [sp, #0x1c]
00010ce4 strb     sl, [ip]
00010ce8 ldr      r0, [lr]
00010cec strb     sl, [fp]
00010cf0 ldr      r4, [sp, #0x20]
00010cf4 ldr      lr, [sp, #0xc]
00010cf8 ldr      ip, [sp, #0x24]
00010cfc ldr      fp, [sp, #0x28]
00010d00 strb     sl, [r3]
00010d04 strb     sl, [r4]
00010d08 ldr      r3, [sp, #0x2c]
00010d0c strb     sl, [lr]
00010d10 ldr      r4, [sp, #0x30]
00010d14 strb     sl, [ip]
00010d18 ldr      lr, [sp, #0x34]
00010d1c strb     sl, [fp]
00010d20 ldr      ip, [sp, #0x38]
00010d24 ldr      fp, [sp, #0x3c]
00010d28 strb     sl, [r3]
00010d2c strb     sl, [r4]
00010d30 strb     sl, [lr]
00010d34 strb     sl, [ip]
00010d38 strb     sl, [fp]
00010d3c bl       #0x112b4
00010d40 b        #0x10b54
00010d44 ldr      r2, [pc, #0x31c]
00010d48 ldr      sl, [r5, #0x40]
00010d4c ldr      lr, [r5, #0x44]
00010d50 add      ip, pc, r2
00010d54 ldr      r4, [ip, #0x20]!
00010d58 cmp      r4, ip
00010d5c sub      r4, r4, #0x34
00010d60 beq      #0x10ffc
00010d64 ldr      r0, [pc, #0x300]
00010d68 add      fp, pc, r0
00010d6c add      r1, fp, #0x20
00010d70 b        #0x10d84
00010d74 ldr      ip, [r4, #0x34]
00010d78 cmp      ip, r1
00010d7c sub      r4, ip, #0x34
00010d80 beq      #0x10ffc
00010d84 ldr      r3, [r4]
00010d88 cmp      sl, r3
00010d8c bne      #0x10d74
00010d90 ldr      r2, [r4, #4]
00010d94 cmp      lr, r2
00010d98 bne      #0x10d74
00010d9c mov      r0, #0
00010da0 mov      fp, #1
00010da4 str      r0, [r5, #0x40]
00010da8 mov      r0, sl
00010dac ldr      r1, [r4, #8]
00010db0 str      fp, [r5, #0x3c]
00010db4 str      r1, [r5, #0x4c]
00010db8 bl       #0x108f0 ; getCrc
00010dbc cmp      r0, #0
00010dc0 bne      #0x10dcc
00010dc4 mov      r0, sl
00010dc8 bl       #0x108a8 ; getPrivCrc
00010dcc str      r0, [r5, #0x50]
00010dd0 mov      r0, r7
00010dd4 ldr      r3, [r4, #0x2c]
00010dd8 ldr      r1, [r4, #0x30]
00010ddc str      r3, [r5, #0x54]
00010de0 ldr      r2, [r4, #0x2c]
00010de4 lsl      r2, r2, #2
00010de8 bl       #0x1089c ; memcpy
00010dec ldr      ip, [r4, #0x2c]
00010df0 mov      r1, r5
00010df4 ldr      r4, [pc, #0x274]
00010df8 add      r0, ip, #3
00010dfc add      sl, pc, r4
00010e00 lsl      r2, r0, #2
00010e04 ldr      r0, [sl]
00010e08 bl       #0x112b4
00010e0c b        #0x10b54
00010e10 ldr      r2, [pc, #0x25c]
00010e14 ldr      r1, [r5, #0x40]
00010e18 ldr      r0, [r5, #0x44]
00010e1c add      sl, pc, r2
00010e20 ldr      r3, [sl, #0x20]!
00010e24 cmp      r3, sl
00010e28 sub      r4, r3, #0x34
00010e2c beq      #0x10b54
00010e30 ldr      lr, [pc, #0x240]
00010e34 add      ip, pc, lr
00010e38 add      fp, ip, #0x20
00010e3c b        #0x10e50
00010e40 ldr      r4, [r4, #0x34]
00010e44 cmp      r4, fp
00010e48 sub      r4, r4, #0x34
00010e4c beq      #0x10b54
00010e50 ldr      r2, [r4]
00010e54 cmp      r1, r2
00010e58 bne      #0x10e40
00010e5c ldr      sl, [r4, #4]
00010e60 cmp      r0, sl
00010e64 bne      #0x10e40
00010e68 ldr      r1, [r4, #0x34]
00010e6c ldr      r3, [r4, #0x38]
00010e70 ldr      r0, [r4, #0x30]
00010e74 str      r3, [r1, #4]
00010e78 ldr      lr, [r4, #0x38]
00010e7c str      r1, [lr]
00010e80 bl       #0x10890 ; free
00010e84 mov      r0, r4
00010e88 bl       #0x10890 ; free
00010e8c b        #0x10b54
00010e90 ldr      r0, [pc, #0x1e4]
00010e94 ldr      r4, [r5, #0x40]
00010e98 ldr      fp, [r5, #0x44]
00010e9c add      r2, pc, r0
00010ea0 ldr      ip, [r2, #0x20]!
00010ea4 cmp      ip, r2
00010ea8 sub      r3, ip, #0x34
00010eac beq      #0x10f64
00010eb0 ldr      sl, [pc, #0x1c8]
00010eb4 add      r1, pc, sl
00010eb8 add      lr, r1, #0x20
00010ebc b        #0x10ed0
00010ec0 ldr      r3, [r3, #0x34]
00010ec4 cmp      r3, lr
00010ec8 sub      r3, r3, #0x34
00010ecc beq      #0x10f64
00010ed0 ldr      r0, [r3]
00010ed4 cmp      r4, r0
00010ed8 bne      #0x10ec0
00010edc ldr      r2, [r3, #4]
00010ee0 cmp      fp, r2
00010ee4 bne      #0x10ec0
00010ee8 ldr      lr, [pc, #0x194]
00010eec mov      r1, r4
00010ef0 add      r0, pc, lr
00010ef4 bl       #0x10884 ; printf
00010ef8 mvn      r0, #0
00010efc ldr      sl, [pc, #0x184]
00010f00 mov      r1, #1
00010f04 mov      r3, #0
00010f08 str      r0, [r5, #0x4c]
00010f0c str      r1, [r5, #0x3c]
00010f10 mov      r2, #4
00010f14 add      fp, pc, sl
00010f18 mov      r1, r5
00010f1c ldr      r0, [fp]
00010f20 str      r3, [r5, #0x40]
00010f24 bl       #0x112b4
00010f28 b        #0x10b54
00010f2c ldr      lr, [pc, #0x158]
00010f30 add      r0, pc, lr
00010f34 bl       #0x10884 ; printf
00010f38 b        #0x10b54
00010f3c ldr      r0, [pc, #0x14c]
00010f40 add      sl, pc, r0
00010f44 mov      lr, #1
00010f48 mov      r2, #4
00010f4c str      lr, [r5, #0x3c]
00010f50 mov      r1, r5
00010f54 str      lr, [r5, #0x40]
00010f58 ldr      r0, [sl]
00010f5c bl       #0x112b4
00010f60 b        #0x10b54
00010f64 mov      r1, #0x3c
00010f68 mov      r0, #1
00010f6c str      ip, [sp, #0x10]
00010f70 bl       #0x1086c ; calloc
00010f74 ldr      ip, [r5, #8]
00010f78 mov      sl, r0
00010f7c stm      r0, {r4, fp}
00010f80 mov      r1, #4
00010f84 str      ip, [r0, #8]
00010f88 ldr      fp, [r5, #0x4c]
00010f8c mov      r0, fp
00010f90 str      fp, [sl, #0x2c]
00010f94 add      r4, r5, fp, lsl #2
00010f98 bl       #0x1086c ; calloc
00010f9c lsl      r2, fp, #2
00010fa0 ldr      r1, [sp, #0xc]
00010fa4 add      fp, r4, #0x50
00010fa8 str      r0, [sl, #0x30]
00010fac bl       #0x1089c ; memcpy
00010fb0 mov      r0, fp
00010fb4 bl       #0x10920 ; strlen
00010fb8 add      r2, r0, #1
00010fbc mov      r1, fp
00010fc0 cmp      r2, #0x20
00010fc4 add      r0, sl, #0xc
00010fc8 movge    r2, #0x20
00010fcc bl       #0x1089c ; memcpy
00010fd0 ldr      r1, [pc, #0xbc]
00010fd4 add      r3, sl, #0x34
00010fd8 ldr      ip, [sp, #0x10]
00010fdc mov      r0, #0
00010fe0 add      r2, pc, r1
00010fe4 add      r4, r2, #0x20
00010fe8 str      r3, [ip, #4]
00010fec str      r3, [r2, #0x20]
00010ff0 str      ip, [sl, #0x34]
00010ff4 str      r4, [sl, #0x38]
00010ff8 b        #0x10efc
00010ffc ldr      sl, [pc, #0x94]
00011000 add      sl, pc, sl
00011004 b        #0x10f44
00011008 ldr      r5, [pc, #0x8c]
0001100c add      r0, pc, r5
00011010 bl       #0x10884 ; printf
00011014 mov      r0, #1
00011018 bl       #0x10914 ; exit
0001101c andeq    r0, r0, ip, lsr fp
00011020 andeq    r0, r1, r4, lsr #30
00011024 andeq    r0, r0, ip, ror #20
00011028 muleq    r1, r8, lr
0001102c andeq    r0, r0, r0, asr sl
00011030 andeq    r0, r0, ip, asr sl
00011034 andeq    r0, r0, r8, ror sl
00011038 muleq    r0, r4, sl
0001103c andeq    r0, r0, r0, ror r0
00011040 andeq    r0, r1, r0, ror lr
00011044 andeq    r0, r0, r8, ror r0
00011048 andeq    r0, r1, r8, lsl #28
0001104c andeq    r0, r1, r4, ror #27
00011050 andeq    r0, r1, r0, lsr #27
00011054 andeq    r0, r1, r8, lsr sp
00011058 andeq    r0, r1, ip, lsl #26
0001105c andeq    r0, r1, r0, lsl #25
00011060 muleq    r1, r4, ip
00011064 andeq    r0, r1, r8, lsr #24
00011068 andeq    r0, r1, r8, lsl #23
0001106c andeq    r0, r1, r0, ror fp
00011070 andeq    r0, r1, r8, lsl #22
00011074 strheq   r0, [r1], -ip
00011078 andeq    r0, r1, r4, lsr #21
0001107c andeq    r0, r1, ip, lsr sl
00011080 andeq    r0, r1, r4, lsr #20
00011084 andeq    r0, r0, ip, asr #12
00011088 strdeq   r0, r1, [r1], -r0
0001108c andeq    r0, r0, r8, ror #11
00011090 andeq    r0, r1, r4, asr #19
00011094 strdeq   r0, r1, [r1], -r8
00011098 andeq    r0, r1, r4, lsl #18
0001109c andeq    r0, r0, r0, ror #9
000110a0 bleq     #0x4d1e4
000110a4 cdpeq    p0, #0, c15, c0, c15, #2
000110a8 strbtmi  fp, [sl], -r2, lsl #24
000110ac strlt    fp, [r1], #-0x404
000110b0 ldrsbgt  pc, [r0], -pc
000110b4 stcgt    p8, c15, [r4, #-0x134]
000110b8 blmi     #0x1230cc
000110bc .byte    0xff, 0xf7, 0x12, 0xec
000110c0 mcrr     p7, #0xf, pc, ip, c15
000110c4 andeq    r1, r1, sp, lsl r4
000110c8 andeq    r0, r1, ip, lsl #19
000110cc ldrdeq   r1, r2, [r1], -sp
000110d0 ldr      r3, [pc, #0x14]
000110d4 ldr      r2, [pc, #0x14]
000110d8 add      r3, pc, r3
000110dc ldr      r2, [r3, r2]
000110e0 cmp      r2, #0
000110e4 bxeq     lr
000110e8 b        #0x108fc ; __gmon_start__
000110ec andeq    r0, r1, ip, ror r7
000110f0 andeq    r0, r0, r4, ror r0
000110f4 .byte    0x07, 0x4b, 0x41, 0xf6
000110f8 .byte    0x08, 0x10, 0xc0, 0xf2
000110fc bne      #0x6d110c
00011100 stmdble  r5, {r1, r2, r8, sb, fp, sp}
00011104 movweq   pc, #0x240
00011108 movweq   pc, #0x2c0
0001110c ldrmi    fp, [r8, -r3, lsl #2]
00011110 svclt    #0x4770
00011114 andeq    r1, r2, fp, lsl #18
00011118 movwne   pc, #0x8641
0001111c andne    pc, r8, r1, asr #12
00011120 movweq   pc, #0x22c0
00011124 andeq    pc, r2, r0, asr #5
00011128 addne    r1, sb, sb, lsl sl
0001112c bicsvc   lr, r1, r1, lsl #22
00011130 andle    r1, r5, sb, asr #32
00011134 movweq   pc, #0x240
00011138 movweq   pc, #0x2c0
0001113c ldrmi    fp, [r8, -r3, lsl #2]
00011140 svclt    #0x4770
00011144 .byte    0x10, 0xb5, 0x41, 0xf6
00011148 vaddhn.i16 d17, q0, q4
0001114c stmdavc  r3!, {r1, sl}
00011150 .byte    0x1b, 0xb9, 0xff, 0xf7
00011154 movwhs   pc, #0x1fcf
00011158 ldclt    p0, c7, [r0, #-0x8c]
0001115c eorvc    pc, r4, r1, asr #4
00011160 .byte    0x08, 0xb5, 0xc0, 0xf2
00011164 stmdavs  r3, {r1}
00011168 pop      {r0, r1, r4, r8, fp, ip, sp, pc}
0001116c ldrb     r4, [r3, r8]
00011170 movweq   pc, #0x240
00011174 movweq   pc, #0x2c0
00011178 rscsle   r2, r6, r0, lsl #22
0001117c .byte    0x98, 0x47, 0xf4, 0xe7
00011180 mov      r0, #0
00011184 bx       lr
00011188 ldr      r3, [pc, #0x14]
0001118c mov      r1, #0
00011190 ldr      r2, [pc, #0x10]
00011194 add      r3, pc, r3
00011198 ldr      r0, [r3, r2]
0001119c str      r1, [r0]
000111a0 bx       lr
000111a4 andeq    r0, r1, r0, asr #13
000111a8 andeq    r0, r0, ip, rrx
000111ac add      r3, r0, #0xb
000111b0 cmp      r3, #0x16
000111b4 bhi      #0x111d0
000111b8 ldr      r1, [pc, #0x1c]
000111bc cmp      r0, #0
000111c0 rsblt    r0, r0, #0
000111c4 add      r2, pc, r1
000111c8 ldr      r0, [r2, r0, lsl #2]
000111cc bx       lr
000111d0 ldr      r0, [pc, #8]
000111d4 add      r0, pc, r0
000111d8 bx       lr
000111dc andeq    r0, r1, ip, asr r5
000111e0 strheq   r0, [r0], -r8
000111e4 mov      ip, #0x10
000111e8 push     {r4, r5, r6, r7, lr}
000111ec mov      r3, #0
000111f0 sub      sp, sp, #0x14
000111f4 mov      lr, #0xc
000111f8 mov      r6, r0
000111fc mov      r2, #0x19
00011200 mov      r0, ip
00011204 mov      r1, #3
00011208 str      r3, [sp, #4]
0001120c str      r3, [sp, #8]
00011210 add      r5, sp, #4
00011214 str      r3, [sp, #0xc]
00011218 strh     ip, [sp, #4]
0001121c str      lr, [sp]
00011220 bl       #0x10950 ; socket
00011224 subs     r4, r0, #0
00011228 ble      #0x11270
0001122c ldr      r2, [sp]
00011230 mov      r1, r5
00011234 bl       #0x1092c ; bind
00011238 subs     r7, r0, #0
0001123c bne      #0x11288
00011240 cmp      r6, #0
00011244 moveq    r0, r4
00011248 beq      #0x11268
0001124c mov      r1, r5
00011250 mov      r2, sp
00011254 mov      r0, r4
00011258 bl       #0x10944 ; getsockname
0001125c ldr      r1, [sp, #8]
00011260 mov      r0, r4
00011264 str      r1, [r6]
00011268 add      sp, sp, #0x14
0001126c pop      {r4, r5, r6, r7, pc}
00011270 ldr      r2, [pc, #0x30]
00011274 add      r0, pc, r2
00011278 bl       #0x108d8 ; puts
0001127c mov      r0, r4
00011280 add      sp, sp, #0x14
00011284 pop      {r4, r5, r6, r7, pc}
00011288 ldr      r0, [pc, #0x1c]
0001128c add      r0, pc, r0
00011290 bl       #0x108d8 ; puts
00011294 mov      r0, r4
00011298 bl       #0x10974 ; close
0001129c mov      r0, r7
000112a0 add      sp, sp, #0x14
000112a4 pop      {r4, r5, r6, r7, pc}
000112a8 andeq    r0, r0, ip, lsr #6
000112ac andeq    r0, r0, ip, lsr #6
000112b0 b        #0x10974 ; close
000112b4 push     {r4, r5, r6, lr}
000112b8 mov      r5, r1
000112bc add      r4, r2, #0x5c
000112c0 mov      r6, r0
000112c4 bl       #0x11180
000112c8 mov      r1, r5
000112cc str      r0, [r5, #0x34]
000112d0 mov      r2, r4
000112d4 str      r4, [r1, #-0x10]!
000112d8 mov      r0, r6
000112dc mov      r3, #0
000112e0 pop      {r4, r5, r6, lr}
000112e4 b        #0x10980 ; send
000112e8 cmn      r3, #1
000112ec push     {r4, r5, r6, r7, r8, sb, lr}
000112f0 sub      r7, r1, #0x10
000112f4 sub      sp, sp, #0x14
000112f8 add      r8, r2, #0x5c
000112fc mov      r6, r0
00011300 beq      #0x11358
00011304 lsl      lr, r3, #7
00011308 movw     r4, #0xde83
0001130c movt     r4, #0x431b
00011310 sub      r1, lr, r3, lsl #2
00011314 movw     sb, #0x4240
00011318 movt     sb, #0xf
0001131c add      ip, r1, r3
00011320 mov      r3, #8
00011324 lsl      ip, ip, #3
00011328 str      r3, [sp]
0001132c mov      r2, #0x14
00011330 umull    r4, r5, ip, r4
00011334 add      r3, sp, r3
00011338 mov      r1, #1
0001133c lsr      r5, r5, #0x12
00011340 mls      lr, sb, r5, ip
00011344 str      r5, [sp, #8]
00011348 str      lr, [sp, #0xc]
0001134c bl       #0x10878 ; setsockopt
00011350 cmp      r0, #0
00011354 blt      #0x11384
00011358 mov      r1, r7
0001135c mov      r2, r8
00011360 mov      r0, r6
00011364 mov      r3, #0
00011368 bl       #0x10968 ; recv
0001136c subs     r7, r0, #0
00011370 subgt    r7, r7, #0x5c
00011374 ble      #0x11394
00011378 mov      r0, r7
0001137c add      sp, sp, #0x14
00011380 pop      {r4, r5, r6, r7, r8, sb, pc}
00011384 ldr      r0, [pc, #0x20]
00011388 add      r0, pc, r0
0001138c bl       #0x108d8 ; puts
00011390 b        #0x11358
00011394 ldr      r2, [pc, #0x14]
00011398 add      r0, pc, r2
0001139c bl       #0x108d8 ; puts
000113a0 mov      r0, r7
000113a4 add      sp, sp, #0x14
000113a8 pop      {r4, r5, r6, r7, r8, sb, pc}
000113ac andeq    r0, r0, r8, asr #4
000113b0 andeq    r0, r0, ip, asr #4
000113b4 add      r1, r0, #0x5f
000113b8 push     {r4, lr}
000113bc bic      r1, r1, #3
000113c0 mov      r0, #1
000113c4 bl       #0x1086c ; calloc
000113c8 cmp      r0, #0
000113cc addne    r0, r0, #0x10
000113d0 pop      {r4, pc}
000113d4 sub      r0, r0, #0x10
000113d8 b        #0x10890 ; free
000113dc .byte    0x2d, 0xe9, 0xf8, 0x43
000113e0 stcmi    p6, c4, [ip, #-0x18]
000113e4 ldrmi    r4, [r0], pc, lsl #12
000113e8 .byte    0xdf, 0xf8, 0x2c, 0x90
000113ec .byte    0x7d, 0x44, 0xff, 0xf7
000113f0 ldrbtmi  lr, [sb], #0xa2e
000113f4 streq    lr, [r5, #-0xbc9]
000113f8 andle    r1, sb, sp, lsr #1
000113fc .byte    0x00, 0x24, 0x59, 0xf8
00011400 strbmi   r3, [r2], -r4, lsr #32
00011404 ldrtmi   r3, [sb], -r1, lsl #8
00011408 .byte    0x30, 0x46, 0x98, 0x47
0001140c mvnsle   r4, ip, lsr #5
00011410 .byte    0xbd, 0xe8, 0xf8, 0x83
00011414 andeq    r0, r1, r0, lsr r3
00011418 andeq    r0, r1, r6, lsr #6
0001141c svclt    #0x4770
