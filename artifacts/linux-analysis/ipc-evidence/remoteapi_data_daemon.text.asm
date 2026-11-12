00010a30 push     {r4, r5, lr}
00010a34 mov      r1, #1
00010a38 sub      sp, sp, #0x94
00010a3c mov      r0, #0
00010a40 bl       #0x10964 ; daemon
00010a44 mov      r2, #0x8c
00010a48 mov      r1, #0
00010a4c add      r0, sp, #4
00010a50 bl       #0x109c4 ; memset
00010a54 ldr      r3, [pc, #0x178]
00010a58 mov      r0, #4
00010a5c add      r1, sp, r0
00010a60 str      r0, [sp, #0x88]
00010a64 mov      r2, #0
00010a68 mov      r0, #0xf
00010a6c str      r3, [sp, #4]
00010a70 bl       #0x1094c ; sigaction
00010a74 mov      r2, #0
00010a78 add      r1, sp, #4
00010a7c mov      r0, #3
00010a80 bl       #0x1094c ; sigaction
00010a84 mov      r2, #0
00010a88 add      r1, sp, #4
00010a8c mov      r0, #2
00010a90 bl       #0x1094c ; sigaction
00010a94 mov      r2, #0
00010a98 add      r1, sp, #4
00010a9c mov      r0, #1
00010aa0 bl       #0x1094c ; sigaction
00010aa4 mov      r2, #0
00010aa8 add      r1, sp, #4
00010aac mov      r0, #0xa
00010ab0 bl       #0x1094c ; sigaction
00010ab4 mov      r2, #0
00010ab8 add      r1, sp, #4
00010abc mov      r0, #9
00010ac0 bl       #0x1094c ; sigaction
00010ac4 bl       #0x109d0 ; data_server_init
00010ac8 subs     r4, r0, #0
00010acc beq      #0x10af4
00010ad0 ldr      r5, [pc, #0x100]
00010ad4 mov      r3, #0x22
00010ad8 ldr      r2, [pc, #0xfc]
00010adc ldr      r1, [pc, #0xfc]
00010ae0 ldr      r0, [r5]
00010ae4 bl       #0x109a0 ; fprintf
00010ae8 mov      r2, r4
00010aec ldr      r1, [pc, #0xf0]
00010af0 b        #0x10bb4
00010af4 bl       #0x1104c
00010af8 subs     r4, r0, #0
00010afc beq      #0x10b24
00010b00 ldr      r5, [pc, #0xd0]
00010b04 mov      r3, #0x28
00010b08 ldr      r2, [pc, #0xcc]
00010b0c ldr      r1, [pc, #0xcc]
00010b10 ldr      r0, [r5]
00010b14 bl       #0x109a0 ; fprintf
00010b18 mov      r2, r4
00010b1c ldr      r1, [pc, #0xc4]
00010b20 b        #0x10bb4
00010b24 bl       #0x11154
00010b28 subs     r4, r0, #0
00010b2c beq      #0x10b54
00010b30 ldr      r5, [pc, #0xa0]
00010b34 mov      r3, #0x2e
00010b38 ldr      r2, [pc, #0x9c]
00010b3c ldr      r1, [pc, #0x9c]
00010b40 ldr      r0, [r5]
00010b44 bl       #0x109a0 ; fprintf
00010b48 mov      r2, r4
00010b4c ldr      r1, [pc, #0x98]
00010b50 b        #0x10bb4
00010b54 bl       #0x1091c ; data_server_start
00010b58 bl       #0x10940 ; data_server_stop
00010b5c subs     r4, r0, #0
00010b60 beq      #0x10b88
00010b64 ldr      r5, [pc, #0x6c]
00010b68 mov      r3, #0x37
00010b6c ldr      r2, [pc, #0x68]
00010b70 ldr      r1, [pc, #0x68]
00010b74 ldr      r0, [r5]
00010b78 bl       #0x109a0 ; fprintf
00010b7c mov      r2, r4
00010b80 ldr      r1, [pc, #0x68]
00010b84 b        #0x10bb4
00010b88 bl       #0x10a24 ; data_server_release
00010b8c subs     r4, r0, #0
00010b90 beq      #0x10bc8
00010b94 ldr      r5, [pc, #0x3c]
00010b98 mov      r3, #0x3d
00010b9c ldr      r2, [pc, #0x38]
00010ba0 ldr      r1, [pc, #0x38]
00010ba4 ldr      r0, [r5]
00010ba8 bl       #0x109a0 ; fprintf
00010bac ldr      r1, [pc, #0x40]
00010bb0 mov      r2, r4
00010bb4 ldr      r0, [r5]
00010bb8 bl       #0x109a0 ; fprintf
00010bbc ldr      r1, [r5]
00010bc0 mov      r0, #0xa
00010bc4 bl       #0x109e8 ; fputc
00010bc8 mov      r0, r4
00010bcc add      sp, sp, #0x94
00010bd0 pop      {r4, r5, pc}
00010bd4 andeq    r1, r1, ip, lsl #3
00010bd8 andeq    r1, r2, r0, lsr #10
00010bdc ldrdeq   r1, r2, [r1], -pc
00010be0 andeq    r1, r1, sl, lsr r2
00010be4 andeq    r1, r1, r4, ror #5
00010be8 andeq    r1, r1, r4, lsl #6
00010bec andeq    r1, r1, r6, lsr #6
00010bf0 andeq    r1, r1, r6, asr #6
00010bf4 andeq    r1, r1, r6, ror #6
00010bf8 bleq     #0x4cd3c
00010bfc cdpeq    p0, #0, c15, c0, c15, #2
00010c00 strbtmi  fp, [sl], -r2, lsl #24
00010c04 strlt    fp, [r1], #-0x404
00010c08 ldrsbgt  pc, [r0], -pc
00010c0c stcgt    p8, c15, [r4, #-0x134]
00010c10 blmi     #0x122c24
00010c14 mcr      p7, #5, pc, c12, c15, #7
00010c18 mrc      p7, #7, apsr_nzcv, c8, c15, #7
00010c1c ldrdeq   r1, r2, [r1], -sp
00010c20 andeq    r0, r1, r0, lsr sl
00010c24 muleq    r1, sp, r1
00010c28 ldr      r3, [pc, #0x14]
00010c2c ldr      r2, [pc, #0x14]
00010c30 add      r3, pc, r3
00010c34 ldr      r2, [r3, r2]
00010c38 cmp      r2, #0
00010c3c bxeq     lr
00010c40 b        #0x10988 ; __gmon_start__
00010c44 andeq    r0, r1, r4, ror #16
00010c48 andeq    r0, r0, r8, ror r0
00010c4c .byte    0x07, 0x4b, 0x41, 0xf2
00010c50 .byte    0x20, 0x50, 0xc0, 0xf2
00010c54 bne      #0x6d0c64
00010c58 stmdble  r5, {r1, r2, r8, sb, fp, sp}
00010c5c movweq   pc, #0x240
00010c60 movweq   pc, #0x2c0
00010c64 ldrmi    fp, [r8, -r3, lsl #2]
00010c68 svclt    #0x4770
00010c6c andeq    r1, r2, r3, lsr #10
00010c70 .byte    0x41, 0xf2, 0x20, 0x53
00010c74 eorpl    pc, r0, r1, asr #4
00010c78 movweq   pc, #0x22c0
00010c7c andeq    pc, r2, r0, asr #5
00010c80 addne    r1, sb, sb, lsl sl
00010c84 bicsvc   lr, r1, r1, lsl #22
00010c88 andle    r1, r5, sb, asr #32
00010c8c movweq   pc, #0x240
00010c90 movweq   pc, #0x2c0
00010c94 ldrmi    fp, [r8, -r3, lsl #2]
00010c98 svclt    #0x4770
00010c9c vqrshl.s8 d27, d0, d1
00010ca0 vaddhn.i16 d21, q0, q10
00010ca4 stmdavc  r3!, {r1, sl}
00010ca8 .byte    0x1b, 0xb9, 0xff, 0xf7
00010cac movwhs   pc, #0x1fcf
00010cb0 ldclt    p0, c7, [r0, #-0x8c]
00010cb4 adclo    pc, r0, r1, asr #4
00010cb8 .byte    0x08, 0xb5, 0xc0, 0xf2
00010cbc stmdavs  r3, {r1}
00010cc0 pop      {r0, r1, r4, r8, fp, ip, sp, pc}
00010cc4 ldrb     r4, [r3, r8]
00010cc8 movweq   pc, #0x240
00010ccc movweq   pc, #0x2c0
00010cd0 rscsle   r2, r6, r0, lsl #22
00010cd4 .byte    0x98, 0x47, 0xf4, 0xe7
00010cd8 cmp      r1, #0
00010cdc cmpne    r0, #0
00010ce0 ble      #0x10d40
00010ce4 push     {r4, lr}
00010ce8 sub      sp, sp, #0x18
00010cec add      r2, sp, #0x18
00010cf0 mov      r3, #0x10
00010cf4 mov      r4, r1
00010cf8 add      r1, sp, #8
00010cfc str      r3, [r2, #-0x14]!
00010d00 bl       #0x10934 ; accept
00010d04 mov      r3, r4
00010d08 mov      lr, r0
00010d0c add      r2, sp, #8
00010d10 add      r4, sp, #0x18
00010d14 mov      ip, r2
00010d18 add      r3, r3, #8
00010d1c ldm      ip!, {r0, r1}
00010d20 cmp      ip, r4
00010d24 str      r0, [r3, #-8]
00010d28 str      r1, [r3, #-4]
00010d2c mov      r2, ip
00010d30 bne      #0x10d14
00010d34 mov      r0, lr
00010d38 add      sp, sp, #0x18
00010d3c pop      {r4, pc}
00010d40 mvn      r0, #0
00010d44 bx       lr
00010d48 push     {r4, r5, r6, r7, r8, sb, sl, lr}
00010d4c mov      r2, #0x10
00010d50 sub      sp, sp, #0x20
00010d54 mov      sl, r0
00010d58 mov      r1, #0
00010d5c add      r0, sp, r2
00010d60 str      r1, [sp, #0xc]
00010d64 mov      r6, #2
00010d68 bl       #0x109c4 ; memset
00010d6c ubfx     r3, sl, #8, #8
00010d70 strh     r6, [sp, #0x10]
00010d74 orr      r0, r3, sl, lsl #8
00010d78 ldr      r5, [pc, #0x1e0]
00010d7c strh     r0, [sp, #0x12]
00010d80 ldr      r0, [pc, #0x1dc]
00010d84 bl       #0x108f8 ; getprotobyname
00010d88 cmp      r0, #0
00010d8c bne      #0x10dc0
00010d90 mov      r3, #0x30
00010d94 ldr      r2, [pc, #0x1cc]
00010d98 ldr      r1, [pc, #0x1cc]
00010d9c ldr      r0, [r5]
00010da0 bl       #0x109a0 ; fprintf
00010da4 ldr      r1, [r5]
00010da8 ldr      r0, [pc, #0x1c0]
00010dac bl       #0x10a00 ; fputs
00010db0 ldr      r1, [r5]
00010db4 mov      r0, #0xa
00010db8 bl       #0x109e8 ; fputc
00010dbc b        #0x10de8
00010dc0 ldr      r2, [r0, #8]
00010dc4 mov      r1, #1
00010dc8 mov      r0, r6
00010dcc bl       #0x109f4 ; socket
00010dd0 subs     r4, r0, #0
00010dd4 bge      #0x10df0
00010dd8 bl       #0x109ac ; __errno_location
00010ddc ldr      r0, [r0]
00010de0 bl       #0x1097c ; strerror
00010de4 bl       #0x10928 ; perror
00010de8 mov      r0, r6
00010dec bl       #0x10994 ; exit
00010df0 mov      sb, #1
00010df4 add      r7, sp, #0x20
00010df8 mov      r8, #4
00010dfc str      sb, [r7, #-0x14]!
00010e00 mov      r1, sb
00010e04 mov      r3, r7
00010e08 mov      r2, r6
00010e0c str      r8, [sp]
00010e10 bl       #0x108ec ; setsockopt
00010e14 mov      r1, sb
00010e18 mov      r3, r7
00010e1c mov      r2, #9
00010e20 str      r8, [sp]
00010e24 mov      r0, r4
00010e28 str      sb, [sp, #0xc]
00010e2c bl       #0x108ec ; setsockopt
00010e30 mov      sb, #0x3c
00010e34 mov      r3, r7
00010e38 mov      r2, r8
00010e3c mov      r1, #6
00010e40 str      r8, [sp]
00010e44 mov      r0, r4
00010e48 str      sb, [sp, #0xc]
00010e4c bl       #0x108ec ; setsockopt
00010e50 mov      r3, r7
00010e54 mov      r2, #5
00010e58 mov      r1, #6
00010e5c str      r8, [sp]
00010e60 mov      r0, r4
00010e64 str      sb, [sp, #0xc]
00010e68 bl       #0x108ec ; setsockopt
00010e6c mov      r3, #0x48
00010e70 ldr      r2, [pc, #0xf0]
00010e74 ldr      r1, [pc, #0xf0]
00010e78 ldr      r0, [r5]
00010e7c bl       #0x109a0 ; fprintf
00010e80 mov      r2, sl
00010e84 ldr      r1, [pc, #0xe8]
00010e88 ldr      r0, [r5]
00010e8c bl       #0x109a0 ; fprintf
00010e90 ldr      r1, [r5]
00010e94 mov      r0, #0xa
00010e98 bl       #0x109e8 ; fputc
00010e9c mov      r2, #0x10
00010ea0 mov      r0, r4
00010ea4 add      r1, sp, r2
00010ea8 bl       #0x109b8 ; bind
00010eac cmn      r0, #1
00010eb0 bne      #0x10f20
00010eb4 bl       #0x109ac ; __errno_location
00010eb8 ldr      r0, [r0]
00010ebc bl       #0x1097c ; strerror
00010ec0 bl       #0x10928 ; perror
00010ec4 mov      r3, #0x52
00010ec8 ldr      r2, [pc, #0x98]
00010ecc ldr      r1, [pc, #0x98]
00010ed0 ldr      r0, [r5]
00010ed4 bl       #0x109a0 ; fprintf
00010ed8 mov      r2, #6
00010edc ldr      r1, [pc, #0x94]
00010ee0 ldr      r0, [r5]
00010ee4 bl       #0x109a0 ; fprintf
00010ee8 ldr      r1, [r5]
00010eec mov      r0, #0xa
00010ef0 bl       #0x109e8 ; fputc
00010ef4 mov      r0, #6
00010ef8 bl       #0x10910 ; sleep
00010efc mov      r2, #0x10
00010f00 mov      r0, r4
00010f04 add      r1, sp, r2
00010f08 bl       #0x109b8 ; bind
00010f0c cmn      r0, #1
00010f10 bne      #0x10f20
00010f14 mov      r0, r4
00010f18 bl       #0x10a18 ; close
00010f1c b        #0x10de8
00010f20 mov      r1, #0x200
00010f24 mov      r0, r4
00010f28 bl       #0x109dc ; listen
00010f2c cmp      r0, #0
00010f30 bge      #0x10f54
00010f34 bl       #0x109ac ; __errno_location
00010f38 ldr      r0, [r0]
00010f3c bl       #0x1097c ; strerror
00010f40 bl       #0x10928 ; perror
00010f44 mov      r0, r4
00010f48 bl       #0x10a18 ; close
00010f4c mov      r0, #2
00010f50 b        #0x10dec
00010f54 mov      r0, r4
00010f58 add      sp, sp, #0x20
00010f5c pop      {r4, r5, r6, r7, r8, sb, sl, pc}
00010f60 andeq    r1, r2, r0, lsr #10
00010f64 andeq    r1, r1, r6, lsr r2
00010f68 andeq    r1, r1, ip, ror #3
00010f6c andeq    r1, r1, sl, lsr r2
00010f70 andeq    r1, r1, r3, asr #4
00010f74 andeq    r1, r1, r7, ror #4
00010f78 andeq    r1, r1, r7, ror r2
00010f7c push     {r4, lr}
00010f80 mov      r3, #0x63
00010f84 ldr      r4, [pc, #0x2c]
00010f88 ldr      r2, [pc, #0x2c]
00010f8c ldr      r1, [pc, #0x2c]
00010f90 ldr      r0, [r4]
00010f94 bl       #0x109a0 ; fprintf
00010f98 ldr      r1, [r4]
00010f9c ldr      r0, [pc, #0x20]
00010fa0 bl       #0x10a00 ; fputs
00010fa4 ldr      r1, [r4]
00010fa8 mov      r0, #0xa
00010fac bl       #0x109e8 ; fputc
00010fb0 mvn      r0, #0
00010fb4 pop      {r4, pc}
00010fb8 andeq    r1, r2, r0, lsr #10
00010fbc andeq    r1, r1, r4, lsl #4
00010fc0 andeq    r1, r1, sl, lsr r2
00010fc4 andeq    r1, r1, fp, lsl #5
00010fc8 push     {r4, lr}
00010fcc mov      r3, #0x69
00010fd0 ldr      r4, [pc, #0x2c]
00010fd4 ldr      r2, [pc, #0x2c]
00010fd8 ldr      r1, [pc, #0x2c]
00010fdc ldr      r0, [r4]
00010fe0 bl       #0x109a0 ; fprintf
00010fe4 ldr      r1, [r4]
00010fe8 ldr      r0, [pc, #0x20]
00010fec bl       #0x10a00 ; fputs
00010ff0 ldr      r1, [r4]
00010ff4 mov      r0, #0xa
00010ff8 bl       #0x109e8 ; fputc
00010ffc mov      r0, #0
00011000 pop      {r4, pc}
00011004 andeq    r1, r2, r0, lsr #10
00011008 andeq    r1, r1, sp, lsl r2
0001100c andeq    r1, r1, sl, lsr r2
00011010 andeq    r1, r1, fp, lsl #5
00011014 push     {r0, r1, r2, r3, r4, lr}
00011018 mov      r2, #0
0001101c mov      r3, #1
00011020 ldr      r0, [pc, #0x1c]
00011024 stm      sp, {r2, r3}
00011028 ldr      r3, [pc, #0x18]
0001102c str      r0, [sp, #8]
00011030 mov      r0, sp
00011034 str      r3, [sp, #0xc]
00011038 bl       #0x10958 ; cmd_server_create_hndlr
0001103c add      sp, sp, #0x14
00011040 pop      {pc}
00011044 andeq    r0, r1, r8, asr #26
00011048 ldrdeq   r0, r1, [r1], -r8
0001104c push     {r0, r1, r2, r3, r4, lr}
00011050 mov      r2, #0
00011054 mov      r3, #1
00011058 ldr      r0, [pc, #0x1c]
0001105c stm      sp, {r2, r3}
00011060 ldr      r3, [pc, #0x18]
00011064 str      r0, [sp, #8]
00011068 mov      r0, sp
0001106c str      r3, [sp, #0xc]
00011070 bl       #0x10904 ; data_server_create_hndlr
00011074 add      sp, sp, #0x14
00011078 pop      {pc}
0001107c andeq    r0, r1, r8, asr #26
00011080 ldrdeq   r0, r1, [r1], -r8
00011084 push     {r4, lr}
00011088 mov      r3, #0x4e
0001108c ldr      r4, [pc, #0x2c]
00011090 ldr      r2, [pc, #0x2c]
00011094 ldr      r1, [pc, #0x2c]
00011098 ldr      r0, [r4]
0001109c bl       #0x109a0 ; fprintf
000110a0 ldr      r1, [r4]
000110a4 ldr      r0, [pc, #0x20]
000110a8 bl       #0x10a00 ; fputs
000110ac ldr      r1, [r4]
000110b0 mov      r0, #0xa
000110b4 bl       #0x109e8 ; fputc
000110b8 mvn      r0, #0
000110bc pop      {r4, pc}
000110c0 andeq    r1, r2, r0, lsr #10
000110c4 muleq    r1, pc, r2
000110c8 andeq    r1, r1, sl, lsr r2
000110cc andeq    r1, r1, sp, asr #5
000110d0 push     {r4, lr}
000110d4 mov      r3, #0x54
000110d8 ldr      r4, [pc, #0x2c]
000110dc ldr      r2, [pc, #0x2c]
000110e0 ldr      r1, [pc, #0x2c]
000110e4 ldr      r0, [r4]
000110e8 bl       #0x109a0 ; fprintf
000110ec ldr      r1, [r4]
000110f0 ldr      r0, [pc, #0x20]
000110f4 bl       #0x10a00 ; fputs
000110f8 ldr      r1, [r4]
000110fc mov      r0, #0xa
00011100 bl       #0x109e8 ; fputc
00011104 mov      r0, #0
00011108 pop      {r4, pc}
0001110c andeq    r1, r2, r0, lsr #10
00011110 strheq   r1, [r1], -r6
00011114 andeq    r1, r1, sl, lsr r2
00011118 andeq    r1, r1, sp, asr #5
0001111c push     {r0, r1, r2, r3, r4, lr}
00011120 mov      r3, #1
00011124 ldr      r0, [pc, #0x20]
00011128 ldr      r1, [pc, #0x20]
0001112c str      r0, [sp, #0xc]
00011130 mov      r0, sp
00011134 str      r3, [sp, #4]
00011138 str      r3, [sp]
0001113c str      r1, [sp, #8]
00011140 bl       #0x10958 ; cmd_server_create_hndlr
00011144 add      sp, sp, #0x14
00011148 pop      {pc}
0001114c andeq    r1, r1, r4, lsl #1
00011150 ldrdeq   r1, r2, [r1], -r0
00011154 push     {r0, r1, r2, r3, r4, lr}
00011158 mov      r3, #1
0001115c ldr      r0, [pc, #0x20]
00011160 ldr      r1, [pc, #0x20]
00011164 str      r0, [sp, #0xc]
00011168 mov      r0, sp
0001116c str      r3, [sp, #4]
00011170 str      r3, [sp]
00011174 str      r1, [sp, #8]
00011178 bl       #0x10904 ; data_server_create_hndlr
0001117c add      sp, sp, #0x14
00011180 pop      {pc}
00011184 andeq    r1, r1, r4, lsl #1
00011188 ldrdeq   r1, r2, [r1], -r0
0001118c push     {r4, lr}
00011190 bl       #0x10a24 ; data_server_release
00011194 mov      r0, #0
00011198 bl       #0x10994 ; exit
0001119c .byte    0x2d, 0xe9, 0xf8, 0x43
000111a0 stcmi    p6, c4, [ip, #-0x18]
000111a4 ldrmi    r4, [r0], pc, lsl #12
000111a8 .byte    0xdf, 0xf8, 0x2c, 0x90
000111ac .byte    0x7d, 0x44, 0xff, 0xf7
000111b0 ldrbtmi  lr, [sb], #0xb8e
000111b4 streq    lr, [r5, #-0xbc9]
000111b8 andle    r1, sb, sp, lsr #1
000111bc .byte    0x00, 0x24, 0x59, 0xf8
000111c0 strbmi   r3, [r2], -r4, lsr #32
000111c4 ldrtmi   r3, [sb], -r1, lsl #8
000111c8 .byte    0x30, 0x46, 0x98, 0x47
000111cc mvnsle   r4, ip, lsr #5
000111d0 .byte    0xbd, 0xe8, 0xf8, 0x83
000111d4 andeq    r0, r1, ip, ror #3
000111d8 andeq    r0, r1, r2, ror #3
000111dc svclt    #0x4770
