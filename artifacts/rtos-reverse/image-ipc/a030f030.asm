; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a030f030 f0402de9 push     {r4, r5, r6, r7, lr}
a030f034 44d04de2 sub      sp, sp, #0x44
a030f038 0020d0e5 ldrb     r2, [r0]
a030f03c 0040a0e3 mov      r4, #0
a030f040 0050a0e1 mov      r5, r0
a030f044 0170a0e1 mov      r7, r1
a030f048 0330d0e5 ldrb     r3, [r0, #3]
a030f04c 04108de2 add      r1, sp, #4
a030f050 0c008de2 add      r0, sp, #0xc
a030f054 0c20cde5 strb     r2, [sp, #0xc]
a030f058 08408de5 str      r4, [sp, #8]
a030f05c 0d30cde5 strb     r3, [sp, #0xd]
a030f060 10408de5 str      r4, [sp, #0x10]
a030f064 14408de5 str      r4, [sp, #0x14]
a030f068 18408de5 str      r4, [sp, #0x18]
a030f06c 1c408de5 str      r4, [sp, #0x1c]
a030f070 02e6ffeb bl       #0xa0308880
a030f074 006050e2 subs     r6, r0, #0
a030f078 3e0000ba blt      #0xa030f178
a030f07c 0410a0e1 mov      r1, r4
a030f080 04009de5 ldr      r0, [sp, #4]
a030f084 f8b402eb bl       #0xa03bc46c
a030f088 0010d5e5 ldrb     r1, [r5]
a030f08c 000051e3 cmp      r1, #0
a030f090 4c00001a bne      #0xa030f1c8
a030f094 08108de2 add      r1, sp, #8
a030f098 0c008de2 add      r0, sp, #0xc
a030f09c ace5ffeb bl       #0xa0308754
a030f0a0 08409de5 ldr      r4, [sp, #8]
a030f0a4 483c00e3 movw     r3, #0xc48
a030f0a8 043040e3 movt     r3, #4
a030f0ac 0500a0e1 mov      r0, r5
a030f0b0 10108de2 add      r1, sp, #0x10
a030f0b4 18208de2 add      r2, sp, #0x18
a030f0b8 56ca84e2 add      ip, r4, #0x56000
a030f0bc 033084e0 add      r3, r4, r3
a030f0c0 3ace8ce2 add      ip, ip, #0x3a0
a030f0c4 10708de5 str      r7, [sp, #0x10]
a030f0c8 14c08de5 str      ip, [sp, #0x14]
a030f0cc 1c308de5 str      r3, [sp, #0x1c]
a030f0d0 ad6900eb bl       #0xa032978c
a030f0d4 006050e2 subs     r6, r0, #0
a030f0d8 0400000a beq      #0xa030f0f0
a030f0dc 04009de5 ldr      r0, [sp, #4]
a030f0e0 ecb402eb bl       #0xa03bc498
a030f0e4 0600a0e1 mov      r0, r6
a030f0e8 44d08de2 add      sp, sp, #0x44
a030f0ec f080bde8 pop      {r4, r5, r6, r7, pc}
a030f0f0 18109de5 ldr      r1, [sp, #0x18]
a030f0f4 243003e3 movw     r3, #0x3024
a030f0f8 002097e5 ldr      r2, [r7]
a030f0fc 000051e3 cmp      r1, #0
a030f100 032084e7 str      r2, [r4, r3]
a030f104 f4ffff0a beq      #0xa030f0dc
a030f108 9fe6ffeb bl       #0xa0308b8c
a030f10c 000050e3 cmp      r0, #0
a030f110 1e00000a beq      #0xa030f190
a030f114 1ce09de5 ldr      lr, [sp, #0x1c]
a030f118 20c08de2 add      ip, sp, #0x20
a030f11c 00009ee5 ldr      r0, [lr]
a030f120 04109ee5 ldr      r1, [lr, #4]
a030f124 08209ee5 ldr      r2, [lr, #8]
a030f128 0c309ee5 ldr      r3, [lr, #0xc]
a030f12c 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f130 10009ee5 ldr      r0, [lr, #0x10]
a030f134 14109ee5 ldr      r1, [lr, #0x14]
a030f138 1c309ee5 ldr      r3, [lr, #0x1c]
a030f13c 18209ee5 ldr      r2, [lr, #0x18]
a030f140 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f144 28109de5 ldr      r1, [sp, #0x28]
a030f148 34009de5 ldr      r0, [sp, #0x34]
a030f14c bbfaffeb bl       #0xa030dc40
a030f150 041095e5 ldr      r1, [r5, #4]
a030f154 0f3001e2 and      r3, r1, #0xf
a030f158 0f0053e3 cmp      r3, #0xf
a030f15c deffff0a beq      #0xa030f0dc
a030f160 0620a0e1 mov      r2, r6
a030f164 0500a0e1 mov      r0, r5
a030f168 20308de2 add      r3, sp, #0x20
a030f16c a8fbffeb bl       #0xa030e014
a030f170 0060a0e1 mov      r6, r0
a030f174 d8ffffea b        #0xa030f0dc
a030f178 8c0f00e3 movw     r0, #0xf8c
a030f17c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030f180 d95ffeeb bl       #0xa02a70ec
a030f184 0600a0e1 mov      r0, r6
a030f188 44d08de2 add      sp, sp, #0x44
a030f18c f080bde8 pop      {r4, r5, r6, r7, pc}
a030f190 1c309de5 ldr      r3, [sp, #0x1c]
a030f194 081093e5 ldr      r1, [r3, #8]
a030f198 140093e5 ldr      r0, [r3, #0x14]
a030f19c a7faffeb bl       #0xa030dc40
a030f1a0 041095e5 ldr      r1, [r5, #4]
a030f1a4 0f3001e2 and      r3, r1, #0xf
a030f1a8 0f0053e3 cmp      r3, #0xf
a030f1ac caffff0a beq      #0xa030f0dc
a030f1b0 0620a0e1 mov      r2, r6
a030f1b4 0500a0e1 mov      r0, r5
a030f1b8 1c309de5 ldr      r3, [sp, #0x1c]
a030f1bc 94fbffeb bl       #0xa030e014
a030f1c0 0060a0e1 mov      r6, r0
a030f1c4 c4ffffea b        #0xa030f0dc
a030f1c8 c00905e3 movw     r0, #0x59c0
a030f1cc 0060e0e3 mvn      r6, #0
a030f1d0 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e59c0 'Warning. AmbaDSP_ImgSetVideoMctfGhostPrv() does not support pipe %d'
a030f1d4 c45ffeeb bl       #0xa02a70ec
a030f1d8 04009de5 ldr      r0, [sp, #4]
a030f1dc adb402eb bl       #0xa03bc498
a030f1e0 bfffffea b        #0xa030f0e4
a030f1e4 010051e3 cmp      r1, #1
a030f1e8 f0432de9 push     {r4, r5, r6, r7, r8, sb, lr}
a030f1ec 0030a0e3 mov      r3, #0
a030f1f0 3cd04de2 sub      sp, sp, #0x3c
a030f1f4 0170a0e1 mov      r7, r1
a030f1f8 0050a0e1 mov      r5, r0
a030f1fc 08308de5 str      r3, [sp, #8]
a030f200 0340a091 movls    r4, r3
a030f204 0330cde5 strb     r3, [sp, #3]
a030f208 10308de5 str      r3, [sp, #0x10]
a030f20c 14308de5 str      r3, [sp, #0x14]
a030f210 0900009a bls      #0xa030f23c
a030f214 7c2003e3 movw     r2, #0x307c
a030f218 680a05e3 movw     r0, #0x5a68
a030f21c 6f204ae3 movt     r2, #0xa06f
a030f220 7c3f05e3 movw     r3, #0x5f7c
a030f224 0142a0e3 mov      r4, #0x10000000
a030f228 041092e5 ldr      r1, [r2, #4]
a030f22c 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5a68 '%s[Warning] Enb=%d should be within [0:1] in %s\n'
a030f230 5e304ae3 movt     r3, #0xa05e ; heuristic 0xa05e5f7c 'DSP_ImgCheckSetVideoMctfEnable'
a030f234 0720a0e1 mov      r2, r7
a030f238 ab5ffeeb bl       #0xa02a70ec
a030f23c 0020d5e5 ldrb     r2, [r5]
a030f240 0c008de2 add      r0, sp, #0xc
a030f244 0330d5e5 ldrb     r3, [r5, #3]
a030f248 04108de2 add      r1, sp, #4
a030f24c 0c20cde5 strb     r2, [sp, #0xc]
a030f250 0d30cde5 strb     r3, [sp, #0xd]
a030f254 89e5ffeb bl       #0xa0308880
a030f258 006050e2 subs     r6, r0, #0
a030f25c 300000ba blt      #0xa030f324
a030f260 0010a0e3 mov      r1, #0
a030f264 04009de5 ldr      r0, [sp, #4]
a030f268 7fb402eb bl       #0xa03bc46c
a030f26c 0010d5e5 ldrb     r1, [r5]
a030f270 000051e3 cmp      r1, #0
a030f274 1c00000a beq      #0xa030f2ec
a030f278 010051e3 cmp      r1, #1
a030f27c 0f00001a bne      #0xa030f2c0
a030f280 0080a0e3 mov      r8, #0
a030f284 0890a0e1 mov      sb, r8
a030f288 0500a0e1 mov      r0, r5
a030f28c 03108de2 add      r1, sp, #3
a030f290 10208de2 add      r2, sp, #0x10
a030f294 6c6900eb bl       #0xa032984c
a030f298 006050e2 subs     r6, r0, #0
a030f29c 0400001a bne      #0xa030f2b4
a030f2a0 0070c9e5 strb     r7, [sb]
a030f2a4 0070c8e5 strb     r7, [r8]
a030f2a8 10309de5 ldr      r3, [sp, #0x10]
a030f2ac 000053e3 cmp      r3, #0
a030f2b0 1f00001a bne      #0xa030f334
a030f2b4 04009de5 ldr      r0, [sp, #4]
a030f2b8 76b402eb bl       #0xa03bc498
a030f2bc 050000ea b        #0xa030f2d8
a030f2c0 9c0a05e3 movw     r0, #0x5a9c
a030f2c4 0060e0e3 mvn      r6, #0
a030f2c8 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5a9c 'Warning. AmbaDSP_ImgSetVideoMctfEnable() does not support pipe %d'
a030f2cc 865ffeeb bl       #0xa02a70ec
a030f2d0 04009de5 ldr      r0, [sp, #4]
a030f2d4 6fb402eb bl       #0xa03bc498
a030f2d8 000054e3 cmp      r4, #0
a030f2dc 01628613 orrne    r6, r6, #0x10000000
a030f2e0 0600a0e1 mov      r0, r6
a030f2e4 3cd08de2 add      sp, sp, #0x3c
a030f2e8 f083bde8 pop      {r4, r5, r6, r7, r8, sb, pc}
a030f2ec 0c008de2 add      r0, sp, #0xc
a030f2f0 08108de2 add      r1, sp, #8
a030f2f4 16e5ffeb bl       #0xa0308754
a030f2f8 08809de5 ldr      r8, [sp, #8]
a030f2fc 483c00e3 movw     r3, #0xc48
a030f300 043040e3 movt     r3, #4
a030f304 0370cde5 strb     r7, [sp, #3]
a030f308 033088e0 add      r3, r8, r3
a030f30c c19d88e2 add      sb, r8, #0x3040
a030f310 bf8d88e2 add      r8, r8, #0x2fc0
a030f314 14308de5 str      r3, [sp, #0x14]
a030f318 399089e2 add      sb, sb, #0x39
a030f31c 208088e2 add      r8, r8, #0x20
a030f320 d8ffffea b        #0xa030f288
a030f324 8c0f00e3 movw     r0, #0xf8c
a030f328 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030f32c 6e5ffeeb bl       #0xa02a70ec
a030f330 e8ffffea b        #0xa030f2d8
a030f334 14e6ffeb bl       #0xa0308b8c
a030f338 000050e3 cmp      r0, #0
a030f33c 1800000a beq      #0xa030f3a4
a030f340 14e09de5 ldr      lr, [sp, #0x14]
a030f344 18c08de2 add      ip, sp, #0x18
a030f348 00009ee5 ldr      r0, [lr]
a030f34c 04109ee5 ldr      r1, [lr, #4]
a030f350 08209ee5 ldr      r2, [lr, #8]
a030f354 0c309ee5 ldr      r3, [lr, #0xc]
a030f358 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f35c 10009ee5 ldr      r0, [lr, #0x10]
a030f360 14109ee5 ldr      r1, [lr, #0x14]
a030f364 1c309ee5 ldr      r3, [lr, #0x1c]
a030f368 18209ee5 ldr      r2, [lr, #0x18]
a030f36c 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f370 20109de5 ldr      r1, [sp, #0x20]
a030f374 2c009de5 ldr      r0, [sp, #0x2c]
a030f378 30faffeb bl       #0xa030dc40
a030f37c 041095e5 ldr      r1, [r5, #4]
a030f380 0f3001e2 and      r3, r1, #0xf
a030f384 0f0053e3 cmp      r3, #0xf
a030f388 c9ffff0a beq      #0xa030f2b4
a030f38c 0620a0e1 mov      r2, r6
a030f390 0500a0e1 mov      r0, r5
a030f394 18308de2 add      r3, sp, #0x18
a030f398 1dfbffeb bl       #0xa030e014
a030f39c 0060a0e1 mov      r6, r0
a030f3a0 c3ffffea b        #0xa030f2b4
a030f3a4 14309de5 ldr      r3, [sp, #0x14]
a030f3a8 081093e5 ldr      r1, [r3, #8]
a030f3ac 140093e5 ldr      r0, [r3, #0x14]
a030f3b0 22faffeb bl       #0xa030dc40
a030f3b4 041095e5 ldr      r1, [r5, #4]
a030f3b8 0f3001e2 and      r3, r1, #0xf
a030f3bc 0f0053e3 cmp      r3, #0xf
a030f3c0 bbffff0a beq      #0xa030f2b4
a030f3c4 0620a0e1 mov      r2, r6
a030f3c8 0500a0e1 mov      r0, r5
a030f3cc 14309de5 ldr      r3, [sp, #0x14]
a030f3d0 0ffbffeb bl       #0xa030e014
a030f3d4 0060a0e1 mov      r6, r0
a030f3d8 b5ffffea b        #0xa030f2b4
a030f3dc 010051e3 cmp      r1, #1
a030f3e0 f0412de9 push     {r4, r5, r6, r7, r8, lr}
a030f3e4 0030a0e3 mov      r3, #0
a030f3e8 40d04de2 sub      sp, sp, #0x40
a030f3ec 0170a0e1 mov      r7, r1
a030f3f0 0050a0e1 mov      r5, r0
a030f3f4 0c308de5 str      r3, [sp, #0xc]
a030f3f8 0340a091 movls    r4, r3
a030f3fc 10308de5 str      r3, [sp, #0x10]
a030f400 0730cde5 strb     r3, [sp, #7]
a030f404 18308de5 str      r3, [sp, #0x18]
a030f408 1c308de5 str      r3, [sp, #0x1c]
a030f40c 0900009a bls      #0xa030f438
a030f410 7c2003e3 movw     r2, #0x307c
a030f414 680a05e3 movw     r0, #0x5a68
a030f418 6f204ae3 movt     r2, #0xa06f
a030f41c c43205e3 movw     r3, #0x52c4
a030f420 0142a0e3 mov      r4, #0x10000000
a030f424 041092e5 ldr      r1, [r2, #4]
a030f428 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5a68 '%s[Warning] Enb=%d should be within [0:1] in %s\n'
a030f42c 5e304ae3 movt     r3, #0xa05e ; heuristic 0xa05e52c4 'DSP_ImgCheckSetVideoMctfCompressionEnable'
a030f430 0720a0e1 mov      r2, r7
a030f434 2c5ffeeb bl       #0xa02a70ec
a030f438 0020d5e5 ldrb     r2, [r5]
a030f43c 14008de2 add      r0, sp, #0x14
a030f440 0330d5e5 ldrb     r3, [r5, #3]
a030f444 08108de2 add      r1, sp, #8
a030f448 1420cde5 strb     r2, [sp, #0x14]
a030f44c 1530cde5 strb     r3, [sp, #0x15]
a030f450 0ae5ffeb bl       #0xa0308880
a030f454 006050e2 subs     r6, r0, #0
a030f458 370000ba blt      #0xa030f53c
a030f45c 0010a0e3 mov      r1, #0
a030f460 08009de5 ldr      r0, [sp, #8]
a030f464 00b402eb bl       #0xa03bc46c
a030f468 0010d5e5 ldrb     r1, [r5]
a030f46c 000051e3 cmp      r1, #0
a030f470 2500000a beq      #0xa030f50c
a030f474 010051e3 cmp      r1, #1
a030f478 1800001a bne      #0xa030f4e0
a030f47c 14008de2 add      r0, sp, #0x14
a030f480 10108de2 add      r1, sp, #0x10
a030f484 b2e4ffeb bl       #0xa0308754
a030f488 10209de5 ldr      r2, [sp, #0x10]
a030f48c 5a8b02e3 movw     r8, #0x2b5a
a030f490 443800e3 movw     r3, #0x844
a030f494 058040e3 movt     r8, #5
a030f498 063040e3 movt     r3, #6
a030f49c 0770cde5 strb     r7, [sp, #7]
a030f4a0 088082e0 add      r8, r2, r8
a030f4a4 033082e0 add      r3, r2, r3
a030f4a8 1c308de5 str      r3, [sp, #0x1c]
a030f4ac 0500a0e1 mov      r0, r5
a030f4b0 07108de2 add      r1, sp, #7
a030f4b4 18208de2 add      r2, sp, #0x18
a030f4b8 126900eb bl       #0xa0329908
a030f4bc 006050e2 subs     r6, r0, #0
a030f4c0 0300001a bne      #0xa030f4d4
a030f4c4 0070c8e5 strb     r7, [r8]
a030f4c8 18309de5 ldr      r3, [sp, #0x18]
a030f4cc 000053e3 cmp      r3, #0
a030f4d0 1d00001a bne      #0xa030f54c
a030f4d4 08009de5 ldr      r0, [sp, #8]
a030f4d8 eeb302eb bl       #0xa03bc498
a030f4dc 050000ea b        #0xa030f4f8
a030f4e0 3c0b05e3 movw     r0, #0x5b3c
a030f4e4 0060e0e3 mvn      r6, #0
a030f4e8 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5b3c 'Warning. AmbaDSP_ImgSetVideoMctfCompensationEnable() does not support pipe %d'
a030f4ec fe5efeeb bl       #0xa02a70ec
a030f4f0 08009de5 ldr      r0, [sp, #8]
a030f4f4 e7b302eb bl       #0xa03bc498
a030f4f8 000054e3 cmp      r4, #0
a030f4fc 01628613 orrne    r6, r6, #0x10000000
a030f500 0600a0e1 mov      r0, r6
a030f504 40d08de2 add      sp, sp, #0x40
a030f508 f081bde8 pop      {r4, r5, r6, r7, r8, pc}
a030f50c 14008de2 add      r0, sp, #0x14
a030f510 0c108de2 add      r1, sp, #0xc
a030f514 8ee4ffeb bl       #0xa0308754
a030f518 0c809de5 ldr      r8, [sp, #0xc]
a030f51c 483c00e3 movw     r3, #0xc48
a030f520 043040e3 movt     r3, #4
a030f524 0770cde5 strb     r7, [sp, #7]
a030f528 033088e0 add      r3, r8, r3
a030f52c c18d88e2 add      r8, r8, #0x3040
a030f530 1c308de5 str      r3, [sp, #0x1c]
a030f534 3a8088e2 add      r8, r8, #0x3a
a030f538 dbffffea b        #0xa030f4ac
a030f53c 8c0f00e3 movw     r0, #0xf8c
a030f540 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030f544 e85efeeb bl       #0xa02a70ec
a030f548 eaffffea b        #0xa030f4f8
a030f54c 8ee5ffeb bl       #0xa0308b8c
a030f550 000050e3 cmp      r0, #0
a030f554 0f00000a beq      #0xa030f598
a030f558 1ce09de5 ldr      lr, [sp, #0x1c]
a030f55c 20c08de2 add      ip, sp, #0x20
a030f560 00009ee5 ldr      r0, [lr]
a030f564 04109ee5 ldr      r1, [lr, #4]
a030f568 08209ee5 ldr      r2, [lr, #8]
a030f56c 0c309ee5 ldr      r3, [lr, #0xc]
a030f570 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f574 10009ee5 ldr      r0, [lr, #0x10]
a030f578 14109ee5 ldr      r1, [lr, #0x14]
a030f57c 18209ee5 ldr      r2, [lr, #0x18]
a030f580 1c309ee5 ldr      r3, [lr, #0x1c]
a030f584 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f588 28109de5 ldr      r1, [sp, #0x28]
a030f58c 34009de5 ldr      r0, [sp, #0x34]
a030f590 aaf9ffeb bl       #0xa030dc40
a030f594 ceffffea b        #0xa030f4d4
a030f598 1c309de5 ldr      r3, [sp, #0x1c]
a030f59c 140093e5 ldr      r0, [r3, #0x14]
a030f5a0 081093e5 ldr      r1, [r3, #8]
a030f5a4 a5f9ffeb bl       #0xa030dc40
a030f5a8 c9ffffea b        #0xa030f4d4
a030f5ac f0402de9 push     {r4, r5, r6, r7, lr}
a030f5b0 0030a0e3 mov      r3, #0
a030f5b4 b020d1e1 ldrh     r2, [r1]
a030f5b8 14d04de2 sub      sp, sp, #0x14
a030f5bc 0160a0e1 mov      r6, r1
a030f5c0 0070a0e1 mov      r7, r0
a030f5c4 08308de5 str      r3, [sp, #8]
a030f5c8 010052e3 cmp      r2, #1
a030f5cc 0350a091 movls    r5, r3
a030f5d0 0a00009a bls      #0xa030f600
a030f5d4 7c1003e3 movw     r1, #0x307c
a030f5d8 680a05e3 movw     r0, #0x5a68
a030f5dc 6f104ae3 movt     r1, #0xa06f
a030f5e0 f03205e3 movw     r3, #0x52f0
a030f5e4 5e304ae3 movt     r3, #0xa05e ; heuristic 0xa05e52f0 'DSP_ImgCheckSetVideoMctfGlobalMotionVector'
a030f5e8 041091e5 ldr      r1, [r1, #4]
a030f5ec 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5a68 '%s[Warning] Enb=%d should be within [0:1] in %s\n'
a030f5f0 0152a0e3 mov      r5, #0x10000000
a030f5f4 bc5efeeb bl       #0xa02a70ec
a030f5f8 0130a0e3 mov      r3, #1
a030f5fc b030c6e1 strh     r3, [r6]
a030f600 0020d7e5 ldrb     r2, [r7]
a030f604 0c008de2 add      r0, sp, #0xc
a030f608 0330d7e5 ldrb     r3, [r7, #3]
a030f60c 04108de2 add      r1, sp, #4
a030f610 0c20cde5 strb     r2, [sp, #0xc]
a030f614 0d30cde5 strb     r3, [sp, #0xd]
a030f618 98e4ffeb bl       #0xa0308880
a030f61c 004050e2 subs     r4, r0, #0
a030f620 430000ba blt      #0xa030f734
a030f624 0010a0e3 mov      r1, #0
a030f628 04009de5 ldr      r0, [sp, #4]
a030f62c 8eb302eb bl       #0xa03bc46c
a030f630 0010d7e5 ldrb     r1, [r7]
a030f634 000051e3 cmp      r1, #0
a030f638 3200001a bne      #0xa030f708
a030f63c 08108de2 add      r1, sp, #8
a030f640 0c008de2 add      r0, sp, #0xc
a030f644 42e4ffeb bl       #0xa0308754
a030f648 08209de5 ldr      r2, [sp, #8]
a030f64c 00c096e5 ldr      ip, [r6]
a030f650 041096e5 ldr      r1, [r6, #4]
a030f654 bf3d82e2 add      r3, r2, #0x2fc0
a030f658 020a82e2 add      r0, r2, #0x2000
a030f65c d8cf80e5 str      ip, [r0, #0xfd8]
a030f660 1c1083e5 str      r1, [r3, #0x1c]
a030f664 b230d6e1 ldrh     r3, [r6, #2]
a030f668 b410d6e1 ldrh     r1, [r6, #4]
a030f66c 73c0bfe6 sxth     ip, r3
a030f670 7100bfe6 sxth     r0, r1
a030f674 020a5ce3 cmp      ip, #0x2000
a030f678 ff3f01a3 movwge   r3, #0x1fff
a030f67c 020000aa bge      #0xa030f68c
a030f680 020a7ce3 cmn      ip, #0x2000
a030f684 5330eda7 ubfxge   r3, r3, #0, #0xe
a030f688 023aa0b3 movlt    r3, #0x2000
a030f68c 010a50e3 cmp      r0, #0x1000
a030f690 0319a0a3 movge    r1, #0xc000
a030f694 ff1340a3 movtge   r1, #0x3ff
a030f698 030000aa bge      #0xa030f6ac
a030f69c 010a70e3 cmn      r0, #0x1000
a030f6a0 5110eca7 ubfxge   r1, r1, #0, #0xd
a030f6a4 0113a0b3 movlt    r1, #0x4000000
a030f6a8 0117a0a1 lslge    r1, r1, #0xe
a030f6ac b0c0d6e1 ldrh     ip, [r6]
a030f6b0 010782e2 add      r0, r2, #0x40000
a030f6b4 d0ead0e5 ldrb     lr, [r0, #0xad0]
a030f6b8 033081e1 orr      r3, r1, r3
a030f6bc d43a80e5 str      r3, [r0, #0xad4]
a030f6c0 00309ce2 adds     r3, ip, #0
a030f6c4 0130a013 movne    r3, #1
a030f6c8 13e0c0e7 bfi      lr, r3, #0, #1
a030f6cc d0eac0e5 strb     lr, [r0, #0xad0]
a030f6d0 043097e5 ldr      r3, [r7, #4]
a030f6d4 0f3003e2 and      r3, r3, #0xf
a030f6d8 0f0053e3 cmp      r3, #0xf
a030f6dc 0040a003 moveq    r4, #0
a030f6e0 0500000a beq      #0xa030f6fc
a030f6e4 c81a00e3 movw     r1, #0xac8
a030f6e8 0000a0e3 mov      r0, #0
a030f6ec 041040e3 movt     r1, #4
a030f6f0 011082e0 add      r1, r2, r1
a030f6f4 cbc1feeb bl       #0xa02bfe28
a030f6f8 0040a0e1 mov      r4, r0
a030f6fc 04009de5 ldr      r0, [sp, #4]
a030f700 64b302eb bl       #0xa03bc498
a030f704 050000ea b        #0xa030f720
a030f708 dc0b05e3 movw     r0, #0x5bdc
a030f70c 0040e0e3 mvn      r4, #0
a030f710 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5bdc 'Warning. AmbaDSP_ImgSetVideoMctfGlobalMotionVector() does not support pipe %d'
a030f714 745efeeb bl       #0xa02a70ec
a030f718 04009de5 ldr      r0, [sp, #4]
a030f71c 5db302eb bl       #0xa03bc498
a030f720 000055e3 cmp      r5, #0
a030f724 01428413 orrne    r4, r4, #0x10000000
a030f728 0400a0e1 mov      r0, r4
a030f72c 14d08de2 add      sp, sp, #0x14
a030f730 f080bde8 pop      {r4, r5, r6, r7, pc}
a030f734 8c0f00e3 movw     r0, #0xf8c
a030f738 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030f73c 6a5efeeb bl       #0xa02a70ec
a030f740 f6ffffea b        #0xa030f720
a030f744 f0402de9 push     {r4, r5, r6, r7, lr}
a030f748 007051e2 subs     r7, r1, #0
a030f74c 14d04de2 sub      sp, sp, #0x14
a030f750 0060a0e3 mov      r6, #0
a030f754 08608de5 str      r6, [sp, #8]
a030f758 2b00000a beq      #0xa030f80c
a030f75c 0020d0e5 ldrb     r2, [r0]
a030f760 0050a0e1 mov      r5, r0
a030f764 0330d0e5 ldrb     r3, [r0, #3]
a030f768 04108de2 add      r1, sp, #4
a030f76c 0c008de2 add      r0, sp, #0xc
a030f770 0c20cde5 strb     r2, [sp, #0xc]
a030f774 0d30cde5 strb     r3, [sp, #0xd]
a030f778 40e4ffeb bl       #0xa0308880
a030f77c 004050e2 subs     r4, r0, #0
a030f780 130000ba blt      #0xa030f7d4
a030f784 0610a0e1 mov      r1, r6
a030f788 04009de5 ldr      r0, [sp, #4]
a030f78c 36b302eb bl       #0xa03bc46c
a030f790 0040d5e5 ldrb     r4, [r5]
a030f794 000054e3 cmp      r4, #0
a030f798 1300001a bne      #0xa030f7ec
a030f79c 0c008de2 add      r0, sp, #0xc
a030f7a0 08108de2 add      r1, sp, #8
a030f7a4 eae3ffeb bl       #0xa0308754
a030f7a8 09009de9 ldmib    sp, {r0, r3}
a030f7ac bf3d83e2 add      r3, r3, #0x2fc0
a030f7b0 182093e5 ldr      r2, [r3, #0x18]
a030f7b4 183083e2 add      r3, r3, #0x18
a030f7b8 043093e5 ldr      r3, [r3, #4]
a030f7bc 002087e5 str      r2, [r7]
a030f7c0 043087e5 str      r3, [r7, #4]
a030f7c4 33b302eb bl       #0xa03bc498
a030f7c8 0400a0e1 mov      r0, r4
a030f7cc 14d08de2 add      sp, sp, #0x14
a030f7d0 f080bde8 pop      {r4, r5, r6, r7, pc}
a030f7d4 8c0f00e3 movw     r0, #0xf8c
a030f7d8 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030f7dc 425efeeb bl       #0xa02a70ec
a030f7e0 0400a0e1 mov      r0, r4
a030f7e4 14d08de2 add      sp, sp, #0x14
a030f7e8 f080bde8 pop      {r4, r5, r6, r7, pc}
a030f7ec 2c0c05e3 movw     r0, #0x5c2c
a030f7f0 0410a0e1 mov      r1, r4
a030f7f4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5c2c 'Warning. AmbaDSP_ImgGetVideoMctfGlobalMotionVector() does not support pipe %d'
a030f7f8 0040e0e3 mvn      r4, #0
a030f7fc 3a5efeeb bl       #0xa02a70ec
a030f800 04009de5 ldr      r0, [sp, #4]
a030f804 23b302eb bl       #0xa03bc498
a030f808 eeffffea b        #0xa030f7c8
a030f80c e00a05e3 movw     r0, #0x5ae0
a030f810 0040e0e3 mvn      r4, #0
a030f814 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5ae0 'Warning. pEnb is empty.'
a030f818 335efeeb bl       #0xa02a70ec
a030f81c e9ffffea b        #0xa030f7c8
a030f820 010051e3 cmp      r1, #1
a030f824 f0412de9 push     {r4, r5, r6, r7, r8, lr}
a030f828 0030a0e3 mov      r3, #0
a030f82c 38d04de2 sub      sp, sp, #0x38
a030f830 0170a0e1 mov      r7, r1
a030f834 0060a0e1 mov      r6, r0
a030f838 08308de5 str      r3, [sp, #8]
a030f83c 0340a091 movls    r4, r3
a030f840 0330cde5 strb     r3, [sp, #3]
a030f844 10308de5 str      r3, [sp, #0x10]
a030f848 14308de5 str      r3, [sp, #0x14]
a030f84c 0900009a bls      #0xa030f878
a030f850 7c2003e3 movw     r2, #0x307c
a030f854 7c0c05e3 movw     r0, #0x5c7c
a030f858 6f204ae3 movt     r2, #0xa06f
a030f85c 9c3f05e3 movw     r3, #0x5f9c
a030f860 0142a0e3 mov      r4, #0x10000000
a030f864 041092e5 ldr      r1, [r2, #4]
a030f868 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5c7c '%s[Warning] ZMVEnb=%d should be within [0:1] in %s\n'
a030f86c 5e304ae3 movt     r3, #0xa05e ; heuristic 0xa05e5f9c 'DSP_ImgCheckSetVideoMctfZMVEnable'
a030f870 0720a0e1 mov      r2, r7
a030f874 1c5efeeb bl       #0xa02a70ec
a030f878 0020d6e5 ldrb     r2, [r6]
a030f87c 0c008de2 add      r0, sp, #0xc
a030f880 0330d6e5 ldrb     r3, [r6, #3]
a030f884 04108de2 add      r1, sp, #4
a030f888 0c20cde5 strb     r2, [sp, #0xc]
a030f88c 0d30cde5 strb     r3, [sp, #0xd]
a030f890 fae3ffeb bl       #0xa0308880
a030f894 005050e2 subs     r5, r0, #0
a030f898 270000ba blt      #0xa030f93c
a030f89c 0010a0e3 mov      r1, #0
a030f8a0 04009de5 ldr      r0, [sp, #4]
a030f8a4 f0b202eb bl       #0xa03bc46c
a030f8a8 0010d6e5 ldrb     r1, [r6]
a030f8ac 000051e3 cmp      r1, #0
a030f8b0 1600001a bne      #0xa030f910
a030f8b4 08108de2 add      r1, sp, #8
a030f8b8 0c008de2 add      r0, sp, #0xc
a030f8bc a4e3ffeb bl       #0xa0308754
a030f8c0 08809de5 ldr      r8, [sp, #8]
a030f8c4 483c00e3 movw     r3, #0xc48
a030f8c8 043040e3 movt     r3, #4
a030f8cc 0600a0e1 mov      r0, r6
a030f8d0 03108de2 add      r1, sp, #3
a030f8d4 10208de2 add      r2, sp, #0x10
a030f8d8 033088e0 add      r3, r8, r3
a030f8dc 0370cde5 strb     r7, [sp, #3]
a030f8e0 14308de5 str      r3, [sp, #0x14]
a030f8e4 f06700eb bl       #0xa03298ac
a030f8e8 005050e2 subs     r5, r0, #0
a030f8ec 0400001a bne      #0xa030f904
a030f8f0 10309de5 ldr      r3, [sp, #0x10]
a030f8f4 038a88e2 add      r8, r8, #0x3000
a030f8f8 7b70c8e5 strb     r7, [r8, #0x7b]
a030f8fc 000053e3 cmp      r3, #0
a030f900 1100001a bne      #0xa030f94c
a030f904 04009de5 ldr      r0, [sp, #4]
a030f908 e2b202eb bl       #0xa03bc498
a030f90c 050000ea b        #0xa030f928
a030f910 b00c05e3 movw     r0, #0x5cb0
a030f914 0050e0e3 mvn      r5, #0
a030f918 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e5cb0 'Warning. AmbaDSP_ImgSetVideoMctfZMVEnable() does not support pipe %d'
a030f91c f25dfeeb bl       #0xa02a70ec
a030f920 04009de5 ldr      r0, [sp, #4]
a030f924 dbb202eb bl       #0xa03bc498
a030f928 000054e3 cmp      r4, #0
a030f92c 01528513 orrne    r5, r5, #0x10000000
a030f930 0500a0e1 mov      r0, r5
a030f934 38d08de2 add      sp, sp, #0x38
a030f938 f081bde8 pop      {r4, r5, r6, r7, r8, pc}
a030f93c 8c0f00e3 movw     r0, #0xf8c
a030f940 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a030f944 e85dfeeb bl       #0xa02a70ec
a030f948 f6ffffea b        #0xa030f928
a030f94c 8ee4ffeb bl       #0xa0308b8c
a030f950 000050e3 cmp      r0, #0
a030f954 1800000a beq      #0xa030f9bc
a030f958 14e09de5 ldr      lr, [sp, #0x14]
a030f95c 18c08de2 add      ip, sp, #0x18
a030f960 00009ee5 ldr      r0, [lr]
a030f964 04109ee5 ldr      r1, [lr, #4]
a030f968 08209ee5 ldr      r2, [lr, #8]
a030f96c 0c309ee5 ldr      r3, [lr, #0xc]
a030f970 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f974 10009ee5 ldr      r0, [lr, #0x10]
a030f978 14109ee5 ldr      r1, [lr, #0x14]
a030f97c 1c309ee5 ldr      r3, [lr, #0x1c]
a030f980 18209ee5 ldr      r2, [lr, #0x18]
a030f984 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a030f988 20109de5 ldr      r1, [sp, #0x20]
a030f98c 2c009de5 ldr      r0, [sp, #0x2c]
a030f990 aaf8ffeb bl       #0xa030dc40
a030f994 041096e5 ldr      r1, [r6, #4]
a030f998 0f3001e2 and      r3, r1, #0xf
a030f99c 0f0053e3 cmp      r3, #0xf
a030f9a0 d7ffff0a beq      #0xa030f904
a030f9a4 0520a0e1 mov      r2, r5
a030f9a8 0600a0e1 mov      r0, r6
a030f9ac 18308de2 add      r3, sp, #0x18
a030f9b0 97f9ffeb bl       #0xa030e014
a030f9b4 0050a0e1 mov      r5, r0
a030f9b8 d1ffffea b        #0xa030f904
a030f9bc 14309de5 ldr      r3, [sp, #0x14]
a030f9c0 081093e5 ldr      r1, [r3, #8]
a030f9c4 140093e5 ldr      r0, [r3, #0x14]
a030f9c8 9cf8ffeb bl       #0xa030dc40
a030f9cc 041096e5 ldr      r1, [r6, #4]
a030f9d0 0f3001e2 and      r3, r1, #0xf
a030f9d4 0f0053e3 cmp      r3, #0xf
a030f9d8 c9ffff0a beq      #0xa030f904
a030f9dc 0520a0e1 mov      r2, r5
a030f9e0 0600a0e1 mov      r0, r6
a030f9e4 14309de5 ldr      r3, [sp, #0x14]
a030f9e8 89f9ffeb bl       #0xa030e014
a030f9ec 0050a0e1 mov      r5, r0
a030f9f0 c3ffffea b        #0xa030f904
a030f9f4 f0402de9 push     {r4, r5, r6, r7, lr}
a030f9f8 007051e2 subs     r7, r1, #0
a030f9fc 14d04de2 sub      sp, sp, #0x14
a030fa00 0060a0e3 mov      r6, #0
a030fa04 08608de5 str      r6, [sp, #8]
a030fa08 2800000a beq      #0xa030fab0
a030fa0c 0020d0e5 ldrb     r2, [r0]
a030fa10 0050a0e1 mov      r5, r0
a030fa14 0330d0e5 ldrb     r3, [r0, #3]
a030fa18 04108de2 add      r1, sp, #4
a030fa1c 0c008de2 add      r0, sp, #0xc
a030fa20 0c20cde5 strb     r2, [sp, #0xc]
a030fa24 0d30cde5 strb     r3, [sp, #0xd]
a030fa28 94e3ffeb bl       #0xa0308880
a030fa2c 004050e2 subs     r4, r0, #0
