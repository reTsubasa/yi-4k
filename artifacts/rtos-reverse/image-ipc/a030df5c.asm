; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a030df5c f0402de9 push     {r4, r5, r6, r7, lr}
a030df60 14d04de2 sub      sp, sp, #0x14
a030df64 0020d0e5 ldrb     r2, [r0]
a030df68 0050a0e1 mov      r5, r0
a030df6c 0170a0e1 mov      r7, r1
a030df70 0060a0e3 mov      r6, #0
a030df74 0330d0e5 ldrb     r3, [r0, #3]
a030df78 04108de2 add      r1, sp, #4
a030df7c 0c008de2 add      r0, sp, #0xc
a030df80 0c20cde5 strb     r2, [sp, #0xc]
a030df84 08608de5 str      r6, [sp, #8]
a030df88 0d30cde5 strb     r3, [sp, #0xd]
a030df8c 3beaffeb bl       #0xa0308880
a030df90 004050e2 subs     r4, r0, #0
a030df94 100000ba blt      #0xa030dfdc
a030df98 0610a0e1 mov      r1, r6
a030df9c 04009de5 ldr      r0, [sp, #4]
a030dfa0 31b902eb bl       #0xa03bc46c
a030dfa4 0040d5e5 ldrb     r4, [r5]
a030dfa8 000054e3 cmp      r4, #0
a030dfac 1000001a bne      #0xa030dff4
a030dfb0 0c008de2 add      r0, sp, #0xc
a030dfb4 08108de2 add      r1, sp, #8
a030dfb8 e5e9ffeb bl       #0xa0308754
a030dfbc 09009de9 ldmib    sp, {r0, r3}
a030dfc0 013783e2 add      r3, r3, #0x40000
a030dfc4 503c93e5 ldr      r3, [r3, #0xc50]
a030dfc8 003087e5 str      r3, [r7]
a030dfcc 31b902eb bl       #0xa03bc498
a030dfd0 0400a0e1 mov      r0, r4
a030dfd4 14d08de2 add      sp, sp, #0x14
a030dfd8 f080bde8 pop      {r4, r5, r6, r7, pc}
a030dfdc 8c0f00e3 movw     r0, #0xf8c
a030dfe0 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030dfe4 4064feeb bl       #0xa02a70ec
a030dfe8 0400a0e1 mov      r0, r4
a030dfec 14d08de2 add      sp, sp, #0x14
a030dff0 f080bde8 pop      {r4, r5, r6, r7, pc}
a030dff4 1c0305e3 movw     r0, #0x531c
a030dff8 0410a0e1 mov      r1, r4
a030dffc 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e531c 'Warning. DSP_ImgGetVideoMctfAddress() does not support pipe %d'
a030e000 0040e0e3 mvn      r4, #0
a030e004 3864feeb bl       #0xa02a70ec
a030e008 04009de5 ldr      r0, [sp, #4]
a030e00c 21b902eb bl       #0xa03bc498
a030e010 eeffffea b        #0xa030dfd0
a030e014 f0432de9 push     {r4, r5, r6, r7, r8, sb, lr}
a030e018 0340a0e1 mov      r4, r3
a030e01c 0060d0e5 ldrb     r6, [r0]
a030e020 0030a0e3 mov      r3, #0
a030e024 0cd04de2 sub      sp, sp, #0xc
a030e028 0300d0e5 ldrb     r0, [r0, #3]
a030e02c 030056e1 cmp      r6, r3
a030e030 085094e5 ldr      r5, [r4, #8]
a030e034 0460cde5 strb     r6, [sp, #4]
a030e038 0500cde5 strb     r0, [sp, #5]
a030e03c 00308de5 str      r3, [sp]
a030e040 7100001a bne      #0xa030e20c
a030e044 0180a0e1 mov      r8, r1
a030e048 04008de2 add      r0, sp, #4
a030e04c 0d10a0e1 mov      r1, sp
a030e050 0270a0e1 mov      r7, r2
a030e054 bee9ffeb bl       #0xa0308754
a030e058 00309de5 ldr      r3, [sp]
a030e05c 012783e2 add      r2, r3, #0x40000
a030e060 8318d2e5 ldrb     r1, [r2, #0x883]
a030e064 010051e3 cmp      r1, #1
a030e068 2c00000a beq      #0xa030e120
a030e06c 013a83e2 add      r3, r3, #0x1000
a030e070 e01fd5e5 ldrb     r1, [r5, #0xfe0]
a030e074 103ad3e5 ldrb     r3, [r3, #0xa10]
a030e078 0690a0e1 mov      sb, r6
a030e07c 282dd5e5 ldrb     r2, [r5, #0xd28]
a030e080 013003e2 and      r3, r3, #1
a030e084 1310c0e7 bfi      r1, r3, #0, #1
a030e088 1320c0e7 bfi      r2, r3, #0, #1
a030e08c e01fc5e5 strb     r1, [r5, #0xfe0]
a030e090 282dc5e5 strb     r2, [r5, #0xd28]
a030e094 1930d4e5 ldrb     r3, [r4, #0x19]
a030e098 1630c0e7 bfi      r3, r6, #0, #1
a030e09c 1930c4e5 strb     r3, [r4, #0x19]
a030e0a0 1430d4e5 ldrb     r3, [r4, #0x14]
a030e0a4 081094e5 ldr      r1, [r4, #8]
a030e0a8 313083e3 orr      r3, r3, #0x31
a030e0ac 1430c4e5 strb     r3, [r4, #0x14]
a030e0b0 140094e5 ldr      r0, [r4, #0x14]
a030e0b4 e1feffeb bl       #0xa030dc40
a030e0b8 1830d4e5 ldrb     r3, [r4, #0x18]
a030e0bc 1720d4e5 ldrb     r2, [r4, #0x17]
a030e0c0 f03003e2 and      r3, r3, #0xf0
a030e0c4 100012e3 tst      r2, #0x10
a030e0c8 1f32c7e7 bfc      r3, #4, #4
a030e0cc 1830c4e5 strb     r3, [r4, #0x18]
a030e0d0 0800001a bne      #0xa030e0f8
a030e0d4 400012e3 tst      r2, #0x40
a030e0d8 0c00001a bne      #0xa030e110
a030e0dc 0800a0e1 mov      r0, r8
a030e0e0 0710a0e1 mov      r1, r7
a030e0e4 0420a0e1 mov      r2, r4
a030e0e8 2ec3feeb bl       #0xa02beda8
a030e0ec 090080e1 orr      r0, r0, sb
a030e0f0 0cd08de2 add      sp, sp, #0xc
a030e0f4 f083bde8 pop      {r4, r5, r6, r7, r8, sb, pc}
a030e0f8 100094e5 ldr      r0, [r4, #0x10]
a030e0fc 221ea0e3 mov      r1, #0x220
a030e100 715006eb bl       #0xa04a22cc
a030e104 1720d4e5 ldrb     r2, [r4, #0x17]
a030e108 400012e3 tst      r2, #0x40
a030e10c f2ffff0a beq      #0xa030e0dc
a030e110 0c0094e5 ldr      r0, [r4, #0xc]
a030e114 801005e3 movw     r1, #0x5080
a030e118 6b5006eb bl       #0xa04a22cc
a030e11c eeffffea b        #0xa030e0dc
a030e120 8838d2e5 ldrb     r3, [r2, #0x888]
a030e124 0190e0e3 mvn      sb, #1
a030e128 010053e3 cmp      r3, #1
a030e12c 0430d4e5 ldrb     r3, [r4, #4]
a030e130 1f00000a beq      #0xa030e1b4
a030e134 8408d2e5 ldrb     r0, [r2, #0x884]
a030e138 1910d4e5 ldrb     r1, [r4, #0x19]
a030e13c 1030c1e7 bfi      r3, r0, #0, #2
a030e140 0430c4e5 strb     r3, [r4, #4]
a030e144 1610c0e7 bfi      r1, r6, #0, #1
a030e148 8508d2e5 ldrb     r0, [r2, #0x885]
a030e14c 1910c4e5 strb     r1, [r4, #0x19]
a030e150 1032c5e7 bfi      r3, r0, #4, #2
a030e154 0430c4e5 strb     r3, [r4, #4]
a030e158 8618d2e5 ldrb     r1, [r2, #0x886]
a030e15c e0efd5e5 ldrb     lr, [r5, #0xfe0]
a030e160 28cdd5e5 ldrb     ip, [r5, #0xd28]
a030e164 0400d5e5 ldrb     r0, [r5, #4]
a030e168 011001e2 and      r1, r1, #1
a030e16c 11e0c0e7 bfi      lr, r1, #0, #1
a030e170 003095e5 ldr      r3, [r5]
a030e174 11c0c0e7 bfi      ip, r1, #0, #1
a030e178 e0efc5e5 strb     lr, [r5, #0xfe0]
a030e17c c01000e2 and      r1, r0, #0xc0
a030e180 28cdc5e5 strb     ip, [r5, #0xd28]
a030e184 8708d2e5 ldrb     r0, [r2, #0x887]
a030e188 3f3003e2 and      r3, r3, #0x3f
a030e18c 0410c5e5 strb     r1, [r5, #4]
a030e190 042095e5 ldr      r2, [r5, #4]
a030e194 000050e3 cmp      r0, #0
a030e198 0214a013 movne    r1, #0x2000000
a030e19c 0010a003 moveq    r1, #0
a030e1a0 013383e1 orr      r3, r3, r1, lsl #6
a030e1a4 1623dde7 bfi      r2, r6, #6, #0x18
a030e1a8 042085e5 str      r2, [r5, #4]
a030e1ac 003085e5 str      r3, [r5]
a030e1b0 baffffea b        #0xa030e0a0
a030e1b4 1920d4e5 ldrb     r2, [r4, #0x19]
a030e1b8 1630c1e7 bfi      r3, r6, #0, #2
a030e1bc 1632c5e7 bfi      r3, r6, #4, #2
a030e1c0 0430c4e5 strb     r3, [r4, #4]
a030e1c4 012082e3 orr      r2, r2, #1
a030e1c8 1920c4e5 strb     r2, [r4, #0x19]
a030e1cc 0420d5e5 ldrb     r2, [r5, #4]
a030e1d0 e00fd5e5 ldrb     r0, [r5, #0xfe0]
a030e1d4 281dd5e5 ldrb     r1, [r5, #0xd28]
a030e1d8 3f20c2e3 bic      r2, r2, #0x3f
a030e1dc 003095e5 ldr      r3, [r5]
a030e1e0 0420c5e5 strb     r2, [r5, #4]
a030e1e4 1600c0e7 bfi      r0, r6, #0, #1
a030e1e8 042095e5 ldr      r2, [r5, #4]
a030e1ec 1610c0e7 bfi      r1, r6, #0, #1
a030e1f0 3f3003e2 and      r3, r3, #0x3f
a030e1f4 e00fc5e5 strb     r0, [r5, #0xfe0]
a030e1f8 281dc5e5 strb     r1, [r5, #0xd28]
a030e1fc 1623dde7 bfi      r2, r6, #6, #0x18
a030e200 003085e5 str      r3, [r5]
a030e204 042085e5 str      r2, [r5, #4]
a030e208 a4ffffea b        #0xa030e0a0
a030e20c 5c0305e3 movw     r0, #0x535c
a030e210 0610a0e1 mov      r1, r6
a030e214 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e535c 'Warning. _AmbaDSP_CmdVcapMctfGmvSetup() does not support pipe %d'
a030e218 b363feeb bl       #0xa02a70ec
a030e21c 0000e0e3 mvn      r0, #0
a030e220 b2ffffea b        #0xa030e0f0
a030e224 f0402de9 push     {r4, r5, r6, r7, lr}
a030e228 14d04de2 sub      sp, sp, #0x14
a030e22c 0020d0e5 ldrb     r2, [r0]
a030e230 0050a0e1 mov      r5, r0
a030e234 0170a0e1 mov      r7, r1
a030e238 0060a0e3 mov      r6, #0
a030e23c 0330d0e5 ldrb     r3, [r0, #3]
a030e240 04108de2 add      r1, sp, #4
a030e244 0c008de2 add      r0, sp, #0xc
a030e248 0c20cde5 strb     r2, [sp, #0xc]
a030e24c 08608de5 str      r6, [sp, #8]
a030e250 0d30cde5 strb     r3, [sp, #0xd]
a030e254 89e9ffeb bl       #0xa0308880
a030e258 004050e2 subs     r4, r0, #0
a030e25c 170000ba blt      #0xa030e2c0
a030e260 0610a0e1 mov      r1, r6
a030e264 04009de5 ldr      r0, [sp, #4]
a030e268 7fb802eb bl       #0xa03bc46c
a030e26c 0040d5e5 ldrb     r4, [r5]
a030e270 000054e3 cmp      r4, #0
a030e274 1700001a bne      #0xa030e2d8
a030e278 08108de2 add      r1, sp, #8
a030e27c 0c008de2 add      r0, sp, #0xc
a030e280 33e9ffeb bl       #0xa0308754
a030e284 08209de5 ldr      r2, [sp, #8]
a030e288 831800e3 movw     r1, #0x883
a030e28c 00c097e5 ldr      ip, [r7]
a030e290 833800e3 movw     r3, #0x883
a030e294 041040e3 movt     r1, #4
a030e298 043040e3 movt     r3, #4
a030e29c 033082e0 add      r3, r2, r3
a030e2a0 04009de5 ldr      r0, [sp, #4]
a030e2a4 01c082e7 str      ip, [r2, r1]
a030e2a8 b420d7e1 ldrh     r2, [r7, #4]
a030e2ac b420c3e1 strh     r2, [r3, #4]
a030e2b0 78b802eb bl       #0xa03bc498
a030e2b4 0400a0e1 mov      r0, r4
a030e2b8 14d08de2 add      sp, sp, #0x14
a030e2bc f080bde8 pop      {r4, r5, r6, r7, pc}
a030e2c0 8c0f00e3 movw     r0, #0xf8c
a030e2c4 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030e2c8 8763feeb bl       #0xa02a70ec
a030e2cc 0400a0e1 mov      r0, r4
a030e2d0 14d08de2 add      sp, sp, #0x14
a030e2d4 f080bde8 pop      {r4, r5, r6, r7, pc}
a030e2d8 a00305e3 movw     r0, #0x53a0
a030e2dc 0410a0e1 mov      r1, r4
a030e2e0 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e53a0 'Warning. AmbaDSP_ImgSetVideoMctfPowerSaving() does not support pipe %d'
a030e2e4 0040e0e3 mvn      r4, #0
a030e2e8 7f63feeb bl       #0xa02a70ec
a030e2ec 04009de5 ldr      r0, [sp, #4]
a030e2f0 68b802eb bl       #0xa03bc498
a030e2f4 eeffffea b        #0xa030e2b4
a030e2f8 f0472de9 push     {r4, r5, r6, r7, r8, sb, sl, lr}
a030e2fc 0050a0e3 mov      r5, #0
a030e300 b823d1e1 ldrh     r2, [r1, #0x38]
a030e304 58d04de2 sub      sp, sp, #0x58
a030e308 0190a0e1 mov      sb, r1
a030e30c 00a0a0e1 mov      sl, r0
a030e310 18508de5 str      r5, [sp, #0x18]
a030e314 010c52e3 cmp      r2, #0x100
a030e318 28508de5 str      r5, [sp, #0x28]
a030e31c 2c508de5 str      r5, [sp, #0x2c]
a030e320 30508de5 str      r5, [sp, #0x30]
a030e324 34508de5 str      r5, [sp, #0x34]
a030e328 20508de5 str      r5, [sp, #0x20]
a030e32c 24508de5 str      r5, [sp, #0x24]
a030e330 9800008a bhi      #0xa030e598
