00010a2c push     {r4, r5, lr}
00010a30 mov      r1, #1
00010a34 sub      sp, sp, #0x94
00010a38 mov      r0, #0
00010a3c bl       #0x10960 ; daemon
00010a40 mov      r2, #0x8c
00010a44 mov      r1, #0
00010a48 add      r0, sp, #4
00010a4c bl       #0x109cc ; memset
00010a50 ldr      r3, [pc, #0x178]
00010a54 mov      r0, #4
00010a58 add      r1, sp, r0
00010a5c str      r0, [sp, #0x88]
00010a60 mov      r2, #0
00010a64 mov      r0, #0xf
00010a68 str      r3, [sp, #4]
00010a6c bl       #0x10948 ; sigaction
00010a70 mov      r2, #0
00010a74 add      r1, sp, #4
00010a78 mov      r0, #3
00010a7c bl       #0x10948 ; sigaction
00010a80 mov      r2, #0
00010a84 add      r1, sp, #4
00010a88 mov      r0, #2
00010a8c bl       #0x10948 ; sigaction
00010a90 mov      r2, #0
00010a94 add      r1, sp, #4
00010a98 mov      r0, #1
00010a9c bl       #0x10948 ; sigaction
00010aa0 mov      r2, #0
00010aa4 add      r1, sp, #4
00010aa8 mov      r0, #0xa
00010aac bl       #0x10948 ; sigaction
00010ab0 mov      r2, #0
00010ab4 add      r1, sp, #4
00010ab8 mov      r0, #9
00010abc bl       #0x10948 ; sigaction
00010ac0 bl       #0x109fc ; cmd_server_init
00010ac4 subs     r4, r0, #0
00010ac8 beq      #0x10af0
00010acc ldr      r5, [pc, #0x100]
00010ad0 mov      r3, #0x22
00010ad4 ldr      r2, [pc, #0xfc]
00010ad8 ldr      r1, [pc, #0xfc]
00010adc ldr      r0, [r5]
00010ae0 bl       #0x1099c ; fprintf
00010ae4 mov      r2, r4
00010ae8 ldr      r1, [pc, #0xf0]
00010aec b        #0x10bb0
00010af0 bl       #0x11010
00010af4 subs     r4, r0, #0
00010af8 beq      #0x10b20
00010afc ldr      r5, [pc, #0xd0]
00010b00 mov      r3, #0x28
00010b04 ldr      r2, [pc, #0xcc]
00010b08 ldr      r1, [pc, #0xcc]
00010b0c ldr      r0, [r5]
00010b10 bl       #0x1099c ; fprintf
00010b14 mov      r2, r4
00010b18 ldr      r1, [pc, #0xc4]
00010b1c b        #0x10bb0
00010b20 bl       #0x11118
00010b24 subs     r4, r0, #0
00010b28 beq      #0x10b50
00010b2c ldr      r5, [pc, #0xa0]
00010b30 mov      r3, #0x2e
00010b34 ldr      r2, [pc, #0x9c]
00010b38 ldr      r1, [pc, #0x9c]
00010b3c ldr      r0, [r5]
00010b40 bl       #0x1099c ; fprintf
00010b44 mov      r2, r4
00010b48 ldr      r1, [pc, #0x98]
00010b4c b        #0x10bb0
00010b50 bl       #0x1090c ; cmd_server_start
00010b54 bl       #0x10924 ; cmd_server_stop
00010b58 subs     r4, r0, #0
00010b5c beq      #0x10b84
00010b60 ldr      r5, [pc, #0x6c]
00010b64 mov      r3, #0x37
00010b68 ldr      r2, [pc, #0x68]
00010b6c ldr      r1, [pc, #0x68]
00010b70 ldr      r0, [r5]
00010b74 bl       #0x1099c ; fprintf
00010b78 mov      r2, r4
00010b7c ldr      r1, [pc, #0x68]
00010b80 b        #0x10bb0
00010b84 bl       #0x109b4 ; cmd_server_release
00010b88 subs     r4, r0, #0
00010b8c beq      #0x10bc4
00010b90 ldr      r5, [pc, #0x3c]
00010b94 mov      r3, #0x3d
00010b98 ldr      r2, [pc, #0x38]
00010b9c ldr      r1, [pc, #0x38]
00010ba0 ldr      r0, [r5]
00010ba4 bl       #0x1099c ; fprintf
00010ba8 ldr      r1, [pc, #0x40]
00010bac mov      r2, r4
00010bb0 ldr      r0, [r5]
00010bb4 bl       #0x1099c ; fprintf
00010bb8 ldr      r1, [r5]
00010bbc mov      r0, #0xa
00010bc0 bl       #0x109e4 ; fputc
00010bc4 mov      r0, r4
00010bc8 add      sp, sp, #0x94
00010bcc pop      {r4, r5, pc}
00010bd0 andeq    r1, r1, r8, lsl #3
00010bd4 andeq    r1, r2, r8, lsl r5
00010bd8 ldrdeq   r1, r2, [r1], -fp
00010bdc andeq    r1, r1, r6, lsr r2
00010be0 andeq    r1, r1, r0, ror #5
00010be4 strdeq   r1, r2, [r1], -pc
00010be8 andeq    r1, r1, r1, lsr #6
00010bec andeq    r1, r1, r1, asr #6
00010bf0 andeq    r1, r1, r0, ror #6
00010bf4 bleq     #0x4cd38
00010bf8 cdpeq    p0, #0, c15, c0, c15, #2
00010bfc strbtmi  fp, [sl], -r2, lsl #24
00010c00 strlt    fp, [r1], #-0x404
00010c04 ldrsbgt  pc, [r0], -pc
00010c08 stcgt    p8, c15, [r4, #-0x134]
00010c0c blmi     #0x122c20
00010c10 mcr      p7, #5, pc, c12, c15, #7
00010c14 mrc      p7, #7, apsr_nzcv, c14, c15, #7
00010c18 ldrdeq   r1, r2, [r1], -sb
00010c1c andeq    r0, r1, ip, lsr #20
00010c20 muleq    r1, sb, r1
00010c24 ldr      r3, [pc, #0x14]
00010c28 ldr      r2, [pc, #0x14]
00010c2c add      r3, pc, r3
00010c30 ldr      r2, [r3, r2]
00010c34 cmp      r2, #0
00010c38 bxeq     lr
00010c3c b        #0x10984 ; __gmon_start__
00010c40 andeq    r0, r1, r0, ror #16
00010c44 andeq    r0, r0, r8, ror r0
00010c48 .byte    0x07, 0x4b, 0x41, 0xf2
00010c4c vmov.i32 d21, #8
00010c50 bne      #0x6d0c60
00010c54 stmdble  r5, {r1, r2, r8, sb, fp, sp}
00010c58 movweq   pc, #0x240
00010c5c movweq   pc, #0x2c0
00010c60 ldrmi    fp, [r8, -r3, lsl #2]
00010c64 svclt    #0x4770
00010c68 andeq    r1, r2, fp, lsl r5
00010c6c tstpl    r8, #0x10000004
00010c70 andspl   pc, r8, r1, asr #4
00010c74 movweq   pc, #0x22c0
00010c78 andeq    pc, r2, r0, asr #5
00010c7c addne    r1, sb, sb, lsl sl
00010c80 bicsvc   lr, r1, r1, lsl #22
00010c84 andle    r1, r5, sb, asr #32
00010c88 movweq   pc, #0x240
00010c8c movweq   pc, #0x2c0
00010c90 ldrmi    fp, [r8, -r3, lsl #2]
00010c94 svclt    #0x4770
00010c98 vqrshl.s8 d27, d0, d1
00010c9c vmov.i32 d21, #0xc0000
00010ca0 stmdavc  r3!, {r1, sl}
00010ca4 .byte    0x1b, 0xb9, 0xff, 0xf7
00010ca8 movwhs   pc, #0x1fcf
00010cac ldclt    p0, c7, [r0, #-0x8c]
00010cb0 addslo   pc, r8, r1, asr #4
00010cb4 .byte    0x08, 0xb5, 0xc0, 0xf2
00010cb8 stmdavs  r3, {r1}
00010cbc pop      {r0, r1, r4, r8, fp, ip, sp, pc}
00010cc0 ldrb     r4, [r3, r8]
00010cc4 movweq   pc, #0x240
00010cc8 movweq   pc, #0x2c0
00010ccc rscsle   r2, r6, r0, lsl #22
00010cd0 .byte    0x98, 0x47, 0xf4, 0xe7
00010cd4 cmp      r1, #0
00010cd8 cmpne    r0, #0
00010cdc ble      #0x10d3c
00010ce0 push     {r4, lr}
00010ce4 sub      sp, sp, #0x18
00010ce8 add      r2, sp, #0x18
00010cec mov      r3, #0x10
00010cf0 mov      r4, r1
00010cf4 add      r1, sp, #8
00010cf8 str      r3, [r2, #-0x14]!
00010cfc bl       #0x1093c ; accept
00010d00 mov      r3, r4
00010d04 mov      lr, r0
00010d08 add      r2, sp, #8
00010d0c add      r4, sp, #0x18
00010d10 mov      ip, r2
00010d14 add      r3, r3, #8
00010d18 ldm      ip!, {r0, r1}
00010d1c cmp      ip, r4
00010d20 str      r0, [r3, #-8]
00010d24 str      r1, [r3, #-4]
00010d28 mov      r2, ip
00010d2c bne      #0x10d10
00010d30 mov      r0, lr
00010d34 add      sp, sp, #0x18
00010d38 pop      {r4, pc}
00010d3c mvn      r0, #0
00010d40 bx       lr
00010d44 push     {r4, r5, r6, r7, r8, sb, sl, lr}
00010d48 mov      r2, #0x10
00010d4c sub      sp, sp, #0x20
00010d50 mov      sl, r0
00010d54 mov      r1, #0
00010d58 add      r0, sp, r2
00010d5c str      r1, [sp, #0xc]
00010d60 mov      r6, #2
00010d64 bl       #0x109cc ; memset
00010d68 ubfx     r3, sl, #8, #8
00010d6c strh     r6, [sp, #0x10]
00010d70 orr      r0, r3, sl, lsl #8
00010d74 ldr      r5, [pc, #0x1e0]
00010d78 strh     r0, [sp, #0x12]
00010d7c ldr      r0, [pc, #0x1dc]
00010d80 bl       #0x108f4 ; getprotobyname
00010d84 cmp      r0, #0
00010d88 bne      #0x10dbc
00010d8c mov      r3, #0x30
00010d90 ldr      r2, [pc, #0x1cc]
00010d94 ldr      r1, [pc, #0x1cc]
00010d98 ldr      r0, [r5]
00010d9c bl       #0x1099c ; fprintf
00010da0 ldr      r1, [r5]
00010da4 ldr      r0, [pc, #0x1c0]
00010da8 bl       #0x10a08 ; fputs
00010dac ldr      r1, [r5]
00010db0 mov      r0, #0xa
00010db4 bl       #0x109e4 ; fputc
00010db8 b        #0x10de4
00010dbc ldr      r2, [r0, #8]
00010dc0 mov      r1, #1
00010dc4 mov      r0, r6
00010dc8 bl       #0x109f0 ; socket
00010dcc subs     r4, r0, #0
00010dd0 bge      #0x10dec
00010dd4 bl       #0x109a8 ; __errno_location
00010dd8 ldr      r0, [r0]
00010ddc bl       #0x10978 ; strerror
00010de0 bl       #0x10930 ; perror
00010de4 mov      r0, r6
00010de8 bl       #0x10990 ; exit
00010dec mov      sb, #1
00010df0 add      r7, sp, #0x20
00010df4 mov      r8, #4
00010df8 str      sb, [r7, #-0x14]!
00010dfc mov      r1, sb
00010e00 mov      r3, r7
00010e04 mov      r2, r6
00010e08 str      r8, [sp]
00010e0c bl       #0x108e8 ; setsockopt
00010e10 mov      r1, sb
00010e14 mov      r3, r7
00010e18 mov      r2, #9
00010e1c str      r8, [sp]
00010e20 mov      r0, r4
00010e24 str      sb, [sp, #0xc]
00010e28 bl       #0x108e8 ; setsockopt
00010e2c mov      sb, #0x3c
00010e30 mov      r3, r7
00010e34 mov      r2, r8
00010e38 mov      r1, #6
00010e3c str      r8, [sp]
00010e40 mov      r0, r4
00010e44 str      sb, [sp, #0xc]
00010e48 bl       #0x108e8 ; setsockopt
00010e4c mov      r3, r7
00010e50 mov      r2, #5
00010e54 mov      r1, #6
00010e58 str      r8, [sp]
00010e5c mov      r0, r4
00010e60 str      sb, [sp, #0xc]
00010e64 bl       #0x108e8 ; setsockopt
00010e68 mov      r3, #0x48
00010e6c ldr      r2, [pc, #0xf0]
00010e70 ldr      r1, [pc, #0xf0]
00010e74 ldr      r0, [r5]
00010e78 bl       #0x1099c ; fprintf
00010e7c mov      r2, sl
00010e80 ldr      r1, [pc, #0xe8]
00010e84 ldr      r0, [r5]
00010e88 bl       #0x1099c ; fprintf
00010e8c ldr      r1, [r5]
00010e90 mov      r0, #0xa
00010e94 bl       #0x109e4 ; fputc
00010e98 mov      r2, #0x10
00010e9c mov      r0, r4
00010ea0 add      r1, sp, r2
00010ea4 bl       #0x109c0 ; bind
00010ea8 cmn      r0, #1
00010eac bne      #0x10f1c
00010eb0 bl       #0x109a8 ; __errno_location
00010eb4 ldr      r0, [r0]
00010eb8 bl       #0x10978 ; strerror
00010ebc bl       #0x10930 ; perror
00010ec0 mov      r3, #0x52
00010ec4 ldr      r2, [pc, #0x98]
00010ec8 ldr      r1, [pc, #0x98]
00010ecc ldr      r0, [r5]
00010ed0 bl       #0x1099c ; fprintf
00010ed4 mov      r2, #6
00010ed8 ldr      r1, [pc, #0x94]
00010edc ldr      r0, [r5]
00010ee0 bl       #0x1099c ; fprintf
00010ee4 ldr      r1, [r5]
00010ee8 mov      r0, #0xa
00010eec bl       #0x109e4 ; fputc
00010ef0 mov      r0, #6
00010ef4 bl       #0x10918 ; sleep
00010ef8 mov      r2, #0x10
00010efc mov      r0, r4
00010f00 add      r1, sp, r2
00010f04 bl       #0x109c0 ; bind
00010f08 cmn      r0, #1
00010f0c bne      #0x10f1c
00010f10 mov      r0, r4
00010f14 bl       #0x10a20 ; close
00010f18 b        #0x10de4
00010f1c mov      r1, #0x200
00010f20 mov      r0, r4
00010f24 bl       #0x109d8 ; listen
00010f28 cmp      r0, #0
00010f2c bge      #0x10f50
00010f30 bl       #0x109a8 ; __errno_location
00010f34 ldr      r0, [r0]
00010f38 bl       #0x10978 ; strerror
00010f3c bl       #0x10930 ; perror
00010f40 mov      r0, r4
00010f44 bl       #0x10a20 ; close
00010f48 mov      r0, #2
00010f4c b        #0x10de8
00010f50 mov      r0, r4
00010f54 add      sp, sp, #0x20
00010f58 pop      {r4, r5, r6, r7, r8, sb, sl, pc}
00010f5c andeq    r1, r2, r8, lsl r5
00010f60 andeq    r1, r1, r2, lsr r2
00010f64 andeq    r1, r1, r8, ror #3
00010f68 andeq    r1, r1, r6, lsr r2
00010f6c andeq    r1, r1, pc, lsr r2
00010f70 andeq    r1, r1, r3, ror #4
00010f74 andeq    r1, r1, r3, ror r2
00010f78 push     {r4, lr}
00010f7c mov      r3, #0x63
00010f80 ldr      r4, [pc, #0x2c]
00010f84 ldr      r2, [pc, #0x2c]
00010f88 ldr      r1, [pc, #0x2c]
00010f8c ldr      r0, [r4]
00010f90 bl       #0x1099c ; fprintf
00010f94 ldr      r1, [r4]
00010f98 ldr      r0, [pc, #0x20]
00010f9c bl       #0x10a08 ; fputs
00010fa0 ldr      r1, [r4]
00010fa4 mov      r0, #0xa
00010fa8 bl       #0x109e4 ; fputc
00010fac mvn      r0, #0
00010fb0 pop      {r4, pc}
00010fb4 andeq    r1, r2, r8, lsl r5
00010fb8 andeq    r1, r1, r0, lsl #4
00010fbc andeq    r1, r1, r6, lsr r2
00010fc0 andeq    r1, r1, r7, lsl #5
00010fc4 push     {r4, lr}
00010fc8 mov      r3, #0x69
00010fcc ldr      r4, [pc, #0x2c]
00010fd0 ldr      r2, [pc, #0x2c]
00010fd4 ldr      r1, [pc, #0x2c]
00010fd8 ldr      r0, [r4]
00010fdc bl       #0x1099c ; fprintf
00010fe0 ldr      r1, [r4]
00010fe4 ldr      r0, [pc, #0x20]
00010fe8 bl       #0x10a08 ; fputs
00010fec ldr      r1, [r4]
00010ff0 mov      r0, #0xa
00010ff4 bl       #0x109e4 ; fputc
00010ff8 mov      r0, #0
00010ffc pop      {r4, pc}
00011000 andeq    r1, r2, r8, lsl r5
00011004 andeq    r1, r1, sb, lsl r2
00011008 andeq    r1, r1, r6, lsr r2
0001100c andeq    r1, r1, r7, lsl #5
00011010 push     {r0, r1, r2, r3, r4, lr}
00011014 mov      r2, #0
00011018 mov      r3, #1
0001101c ldr      r0, [pc, #0x1c]
00011020 stm      sp, {r2, r3}
00011024 ldr      r3, [pc, #0x18]
00011028 str      r0, [sp, #8]
0001102c mov      r0, sp
00011030 str      r3, [sp, #0xc]
00011034 bl       #0x10954 ; cmd_server_create_hndlr
00011038 add      sp, sp, #0x14
0001103c pop      {pc}
00011040 andeq    r0, r1, r4, asr #26
00011044 ldrdeq   r0, r1, [r1], -r4
00011048 push     {r0, r1, r2, r3, r4, lr}
0001104c mov      r2, #0
00011050 mov      r3, #1
00011054 ldr      r0, [pc, #0x1c]
00011058 stm      sp, {r2, r3}
0001105c ldr      r3, [pc, #0x18]
00011060 str      r0, [sp, #8]
00011064 mov      r0, sp
00011068 str      r3, [sp, #0xc]
0001106c bl       #0x10900 ; data_server_create_hndlr
00011070 add      sp, sp, #0x14
00011074 pop      {pc}
00011078 andeq    r0, r1, r4, asr #26
0001107c ldrdeq   r0, r1, [r1], -r4
00011080 push     {r4, lr}
00011084 mov      r3, #0x4e
00011088 ldr      r4, [pc, #0x2c]
0001108c ldr      r2, [pc, #0x2c]
00011090 ldr      r1, [pc, #0x2c]
00011094 ldr      r0, [r4]
00011098 bl       #0x1099c ; fprintf
0001109c ldr      r1, [r4]
000110a0 ldr      r0, [pc, #0x20]
000110a4 bl       #0x10a08 ; fputs
000110a8 ldr      r1, [r4]
000110ac mov      r0, #0xa
000110b0 bl       #0x109e4 ; fputc
000110b4 mvn      r0, #0
000110b8 pop      {r4, pc}
000110bc andeq    r1, r2, r8, lsl r5
000110c0 muleq    r1, fp, r2
000110c4 andeq    r1, r1, r6, lsr r2
000110c8 andeq    r1, r1, sb, asr #5
000110cc push     {r4, lr}
000110d0 mov      r3, #0x54
000110d4 ldr      r4, [pc, #0x2c]
000110d8 ldr      r2, [pc, #0x2c]
000110dc ldr      r1, [pc, #0x2c]
000110e0 ldr      r0, [r4]
000110e4 bl       #0x1099c ; fprintf
000110e8 ldr      r1, [r4]
000110ec ldr      r0, [pc, #0x20]
000110f0 bl       #0x10a08 ; fputs
000110f4 ldr      r1, [r4]
000110f8 mov      r0, #0xa
000110fc bl       #0x109e4 ; fputc
00011100 mov      r0, #0
00011104 pop      {r4, pc}
00011108 andeq    r1, r2, r8, lsl r5
0001110c strheq   r1, [r1], -r2
00011110 andeq    r1, r1, r6, lsr r2
00011114 andeq    r1, r1, sb, asr #5
00011118 push     {r0, r1, r2, r3, r4, lr}
0001111c mov      r3, #1
00011120 ldr      r0, [pc, #0x20]
00011124 ldr      r1, [pc, #0x20]
00011128 str      r0, [sp, #0xc]
0001112c mov      r0, sp
00011130 str      r3, [sp, #4]
00011134 str      r3, [sp]
00011138 str      r1, [sp, #8]
0001113c bl       #0x10954 ; cmd_server_create_hndlr
00011140 add      sp, sp, #0x14
00011144 pop      {pc}
00011148 andeq    r1, r1, r0, lsl #1
0001114c andeq    r1, r1, ip, asr #1
00011150 push     {r0, r1, r2, r3, r4, lr}
00011154 mov      r3, #1
00011158 ldr      r0, [pc, #0x20]
0001115c ldr      r1, [pc, #0x20]
00011160 str      r0, [sp, #0xc]
00011164 mov      r0, sp
00011168 str      r3, [sp, #4]
0001116c str      r3, [sp]
00011170 str      r1, [sp, #8]
00011174 bl       #0x10900 ; data_server_create_hndlr
00011178 add      sp, sp, #0x14
0001117c pop      {pc}
00011180 andeq    r1, r1, r0, lsl #1
00011184 andeq    r1, r1, ip, asr #1
00011188 push     {r4, lr}
0001118c bl       #0x109b4 ; cmd_server_release
00011190 mov      r0, #0
00011194 bl       #0x10990 ; exit
00011198 .byte    0x2d, 0xe9, 0xf8, 0x43
0001119c stcmi    p6, c4, [ip, #-0x18]
000111a0 ldrmi    r4, [r0], pc, lsl #12
000111a4 .byte    0xdf, 0xf8, 0x2c, 0x90
000111a8 .byte    0x7d, 0x44, 0xff, 0xf7
000111ac ldrbtmi  lr, [sb], #0xb8e
000111b0 streq    lr, [r5, #-0xbc9]
000111b4 andle    r1, sb, sp, lsr #1
000111b8 .byte    0x00, 0x24, 0x59, 0xf8
000111bc strbmi   r3, [r2], -r4, lsr #32
000111c0 ldrtmi   r3, [sb], -r1, lsl #8
000111c4 .byte    0x30, 0x46, 0x98, 0x47
000111c8 mvnsle   r4, ip, lsr #5
000111cc .byte    0xbd, 0xe8, 0xf8, 0x83
000111d0 andeq    r0, r1, r8, ror #3
000111d4 ldrdeq   r0, r1, [r1], -lr
000111d8 svclt    #0x4770
