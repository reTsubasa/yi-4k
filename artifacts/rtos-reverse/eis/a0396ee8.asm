; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a0396ee8 10402de9 push     {r4, lr}
a0396eec 0040e0e3 mvn      r4, #0
a0396ef0 10d04de2 sub      sp, sp, #0x10
a0396ef4 880b0be3 movw     r0, #0xbb88
a0396ef8 0c308de2 add      r3, sp, #0xc
a0396efc 00408de5 str      r4, [sp]
a0396f00 70014ae3 movt     r0, #0xa170
a0396f04 0118a0e3 mov      r1, #0x10000
a0396f08 0320a0e3 mov      r2, #3
a0396f0c 669500eb bl       #0xa03bc4ac
a0396f10 0c309de5 ldr      r3, [sp, #0xc]
a0396f14 010813e3 tst      r3, #0x10000
a0396f18 f5ffff0a beq      #0xa0396ef4
a0396f1c 0010a0e3 mov      r1, #0
a0396f20 100001e3 movw     r0, #0x1010
a0396f24 0120a0e1 mov      r2, r1
a0396f28 0130a0e1 mov      r3, r1
a0396f2c 6b6700eb bl       #0xa03b0ce0
a0396f30 efffffea b        #0xa0396ef4
a0396f34 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0396f38 8c6c0be3 movw     r6, #0xbc8c
a0396f3c fc5c0be3 movw     r5, #0xbcfc
a0396f40 59df4de2 sub      sp, sp, #0x164
a0396f44 0020a0e3 mov      r2, #0
a0396f48 0690a0e1 mov      sb, r6
a0396f4c 70514ae3 movt     r5, #0xa170
a0396f50 846a0be3 movw     r6, #0xba84
a0396f54 b822cde1 strh     r2, [sp, #0x28]
a0396f58 06a0a0e1 mov      sl, r6
a0396f5c 0230a0e1 mov      r3, r2
a0396f60 002085e5 str      r2, [r5]
a0396f64 0260a0e1 mov      r6, r2
a0396f68 10208de5 str      r2, [sp, #0x10]
a0396f6c 0c208de5 str      r2, [sp, #0xc]
a0396f70 0920a0e1 mov      r2, sb
a0396f74 70214ae3 movt     r2, #0xa170
a0396f78 28709de5 ldr      r7, [sp, #0x28]
a0396f7c 1c208de5 str      r2, [sp, #0x1c]
a0396f80 0a20a0e1 mov      r2, sl
a0396f84 70214ae3 movt     r2, #0xa170
a0396f88 0180a0e3 mov      r8, #1
a0396f8c 4c208de5 str      r2, [sp, #0x4c]
a0396f90 902c0be3 movw     r2, #0xbc90
a0396f94 70214ae3 movt     r2, #0xa170
a0396f98 000d0be3 movw     r0, #0xbd00
a0396f9c 38208de5 str      r2, [sp, #0x38]
a0396fa0 882a0be3 movw     r2, #0xba88
a0396fa4 70214ae3 movt     r2, #0xa170
a0396fa8 c4c407e3 movw     ip, #0x74c4
a0396fac 30208de5 str      r2, [sp, #0x30]
a0396fb0 8c2a0be3 movw     r2, #0xba8c
a0396fb4 70214ae3 movt     r2, #0xa170
a0396fb8 88ec0be3 movw     lr, #0xbc88
a0396fbc 3c208de5 str      r2, [sp, #0x3c]
a0396fc0 942c0be3 movw     r2, #0xbc94
a0396fc4 70214ae3 movt     r2, #0xa170
a0396fc8 0040e0e3 mvn      r4, #0
a0396fcc 40208de5 str      r2, [sp, #0x40]
a0396fd0 b82c0be3 movw     r2, #0xbcb8
a0396fd4 70214ae3 movt     r2, #0xa170
a0396fd8 1871c7e7 bfi      r7, r8, #2, #6
a0396fdc 44208de5 str      r2, [sp, #0x44]
a0396fe0 242d0be3 movw     r2, #0xbd24
a0396fe4 70214ae3 movt     r2, #0xa170
a0396fe8 0510a0e3 mov      r1, #5
a0396fec 48208de5 str      r2, [sp, #0x48]
a0396ff0 202f00e3 movw     r2, #0xf20
a0396ff4 68bb07e3 movw     fp, #0x7b68
a0396ff8 70014ae3 movt     r0, #0xa170
a0396ffc 39c04ae3 movt     ip, #0xa039
a0397000 70e14ae3 movt     lr, #0xa170
a0397004 a3214ae3 movt     r2, #0xa1a3
a0397008 28708de5 str      r7, [sp, #0x28]
a039700c 54108de5 str      r1, [sp, #0x54]
a0397010 0470a0e1 mov      r7, r4
a0397014 14408de5 str      r4, [sp, #0x14]
a0397018 75b04ae3 movt     fp, #0xa075
a039701c 24008de5 str      r0, [sp, #0x24]
a0397020 0f90a0e3 mov      sb, #0xf
a0397024 20c08de5 str      ip, [sp, #0x20]
a0397028 18e08de5 str      lr, [sp, #0x18]
a039702c 34208de5 str      r2, [sp, #0x34]
a0397030 b90000ea b        #0xa039731c
a0397034 070001e3 movw     r0, #0x1007
a0397038 0110a0e3 mov      r1, #1
a039703c 0420a0e3 mov      r2, #4
a0397040 0030a0e3 mov      r3, #0
a0397044 256700eb bl       #0xa03b0ce0
a0397048 0020a0e3 mov      r2, #0
a039704c 0110a0e3 mov      r1, #1
a0397050 0230a0e1 mov      r3, r2
a0397054 060001e3 movw     r0, #0x1006
a0397058 206700eb bl       #0xa03b0ce0
a039705c 0010a0e3 mov      r1, #0
a0397060 020001e3 movw     r0, #0x1002
a0397064 0120a0e1 mov      r2, r1
a0397068 0130a0e1 mov      r3, r1
a039706c 1b6700eb bl       #0xa03b0ce0
a0397070 0010a0e3 mov      r1, #0
a0397074 030001e3 movw     r0, #0x1003
a0397078 0120a0e1 mov      r2, r1
a039707c 0130a0e1 mov      r3, r1
a0397080 166700eb bl       #0xa03b0ce0
a0397084 0010a0e3 mov      r1, #0
a0397088 010aa0e3 mov      r0, #0x1000
a039708c 0120a0e1 mov      r2, r1
a0397090 0130a0e1 mov      r3, r1
a0397094 116700eb bl       #0xa03b0ce0
a0397098 880b0be3 movw     r0, #0xbb88
a039709c 0010e0e3 mvn      r1, #0
a03970a0 70014ae3 movt     r0, #0xa170
a03970a4 0040a0e3 mov      r4, #0
a03970a8 109500eb bl       #0xa03bc4f0
a03970ac 001507e3 movw     r1, #0x7500
a03970b0 1a00a0e3 mov      r0, #0x1a
a03970b4 39104ae3 movt     r1, #0xa039
a03970b8 0460a0e1 mov      r6, r4
a03970bc 3ba8fceb bl       #0xa02c11b0
a03970c0 d41407e3 movw     r1, #0x74d4
a03970c4 1c00a0e3 mov      r0, #0x1c
a03970c8 39104ae3 movt     r1, #0xa039
a03970cc 0c408de5 str      r4, [sp, #0xc]
a03970d0 36a8fceb bl       #0xa02c11b0
a03970d4 20209de5 ldr      r2, [sp, #0x20]
a03970d8 fa3fa0e3 mov      r3, #0x3e8
a03970dc 0010e0e3 mvn      r1, #0
a03970e0 5c308de5 str      r3, [sp, #0x5c]
a03970e4 58308de5 str      r3, [sp, #0x58]
a03970e8 58008de2 add      r0, sp, #0x58
a03970ec 0130a0e3 mov      r3, #1
a03970f0 60208de5 str      r2, [sp, #0x60]
a03970f4 10308de5 str      r3, [sp, #0x10]
a03970f8 0480a0e1 mov      r8, r4
a03970fc 64408de5 str      r4, [sp, #0x64]
a0397100 eddc03eb bl       #0xa048e4bc
a0397104 0090a0e1 mov      sb, r0
a0397108 a80701e3 movw     r0, #0x17a8
a039710c 5c209de5 ldr      r2, [sp, #0x5c]
a0397110 0910a0e1 mov      r1, sb
a0397114 58309de5 ldr      r3, [sp, #0x58]
a0397118 60004ae3 movt     r0, #0xa060
a039711c f23ffceb bl       #0xa02a70ec
a0397120 dc0c0be3 movw     r0, #0xbcdc
a0397124 70014ae3 movt     r0, #0xa170
a0397128 bb9400eb bl       #0xa03bc41c
a039712c 18209de5 ldr      r2, [sp, #0x18]
a0397130 0030e0e3 mvn      r3, #0
a0397134 0340a0e1 mov      r4, r3
a0397138 0370a0e1 mov      r7, r3
a039713c 14308de5 str      r3, [sp, #0x14]
a0397140 003082e5 str      r3, [r2]
a0397144 1c209de5 ldr      r2, [sp, #0x1c]
a0397148 003082e5 str      r3, [r2]
a039714c 0030e0e3 mvn      r3, #0
a0397150 880b0be3 movw     r0, #0xbb88
a0397154 00308de5 str      r3, [sp]
a0397158 0120a0e3 mov      r2, #1
a039715c 50308de2 add      r3, sp, #0x50
a0397160 70014ae3 movt     r0, #0xa170
a0397164 ff1f0fe3 movw     r1, #0xffff
a0397168 fcac0be3 movw     sl, #0xbcfc
a039716c ce9400eb bl       #0xa03bc4ac
a0397170 003095e5 ldr      r3, [r5]
a0397174 70a14ae3 movt     sl, #0xa170
a0397178 0420d3e3 bics     r2, r3, #4
a039717c 6500000a beq      #0xa0397318
a0397180 030053e3 cmp      r3, #3
a0397184 c100000a beq      #0xa0397490
a0397188 020053e3 cmp      r3, #2
a039718c b900000a beq      #0xa0397478
a0397190 50309de5 ldr      r3, [sp, #0x50]
a0397194 080013e3 tst      r3, #8
a0397198 1700000a beq      #0xa03971fc
a039719c 10309de5 ldr      r3, [sp, #0x10]
a03971a0 000053e3 cmp      r3, #0
a03971a4 4c309de5 ldr      r3, [sp, #0x4c]
a03971a8 001093e5 ldr      r1, [r3]
a03971ac 0d00000a beq      #0xa03971e8
a03971b0 010057e1 cmp      r7, r1
a03971b4 0130a023 movhs    r3, #1
a03971b8 10308d25 strhs    r3, [sp, #0x10]
a03971bc 0900002a bhs      #0xa03971e8
a03971c0 01a067e0 rsb      sl, r7, r1
a03971c4 aa30b0e1 lsrs     r3, sl, #1
a03971c8 14308de5 str      r3, [sp, #0x14]
a03971cc 0030a013 movne    r3, #0
a03971d0 10308d05 streq    r3, [sp, #0x10]
a03971d4 0c308d05 streq    r3, [sp, #0xc]
a03971d8 0130a003 moveq    r3, #1
a03971dc 14308d05 streq    r3, [sp, #0x14]
a03971e0 10308d15 strne    r3, [sp, #0x10]
a03971e4 0c308d15 strne    r3, [sp, #0xc]
a03971e8 0020a0e3 mov      r2, #0
a03971ec 0d0001e3 movw     r0, #0x100d
a03971f0 0230a0e1 mov      r3, r2
a03971f4 b96600eb bl       #0xa03b0ce0
a03971f8 50309de5 ldr      r3, [sp, #0x50]
a03971fc 040013e3 tst      r3, #4
a0397200 3100000a beq      #0xa03972cc
a0397204 38209de5 ldr      r2, [sp, #0x38]
a0397208 18c09de5 ldr      ip, [sp, #0x18]
a039720c 34309de5 ldr      r3, [sp, #0x34]
a0397210 007092e5 ldr      r7, [r2]
a0397214 30209de5 ldr      r2, [sp, #0x30]
a0397218 003093e5 ldr      r3, [r3]
a039721c 00708ce5 str      r7, [ip]
a0397220 000092e5 ldr      r0, [r2]
a0397224 1cc09de5 ldr      ip, [sp, #0x1c]
a0397228 40209de5 ldr      r2, [sp, #0x40]
a039722c 183093e5 ldr      r3, [r3, #0x18]
a0397230 00008ce5 str      r0, [ip]
a0397234 001092e5 ldr      r1, [r2]
a0397238 3c009de5 ldr      r0, [sp, #0x3c]
a039723c 000053e3 cmp      r3, #0
a0397240 48209de5 ldr      r2, [sp, #0x48]
a0397244 001080e5 str      r1, [r0]
a0397248 002092e5 ldr      r2, [r2]
a039724c 44109de5 ldr      r1, [sp, #0x44]
a0397250 002081e5 str      r2, [r1]
a0397254 0500000a beq      #0xa0397270
a0397258 28209de5 ldr      r2, [sp, #0x28]
a039725c 68108de2 add      r1, sp, #0x68
a0397260 1f20c1e7 bfc      r2, #0, #2
a0397264 0200a0e1 mov      r0, r2
a0397268 b822cde1 strh     r2, [sp, #0x28]
a039726c 33ff2fe1 blx      r3
a0397270 d0009de5 ldr      r0, [sp, #0xd0]
a0397274 0160a0e3 mov      r6, #1
a0397278 cc109de5 ldr      r1, [sp, #0xcc]
a039727c 0c608de5 str      r6, [sp, #0xc]
a0397280 8033a0e1 lsl      r3, r0, #7
a0397284 003143e0 sub      r3, r3, r0, lsl #2
a0397288 000083e0 add      r0, r3, r0
a039728c 8001a0e1 lsl      r0, r0, #3
a0397290 60bc05fa blx      #0xa0506418
a0397294 0020a0e3 mov      r2, #0
a0397298 0040a0e1 mov      r4, r0
a039729c 0230a0e1 mov      r3, r2
a03972a0 0710a0e1 mov      r1, r7
a03972a4 0e0001e3 movw     r0, #0x100e
a03972a8 8c6600eb bl       #0xa03b0ce0
a03972ac 0020a0e3 mov      r2, #0
a03972b0 110001e3 movw     r0, #0x1011
a03972b4 0230a0e1 mov      r3, r2
a03972b8 54108de2 add      r1, sp, #0x54
a03972bc 876600eb bl       #0xa03b0ce0
a03972c0 54209de5 ldr      r2, [sp, #0x54]
a03972c4 50309de5 ldr      r3, [sp, #0x50]
a03972c8 044062e0 rsb      r4, r2, r4
a03972cc 010013e3 tst      r3, #1
a03972d0 6200001a bne      #0xa0397460
a03972d4 d8dc03eb bl       #0xa048e63c
a03972d8 000057e1 cmp      r7, r0
a03972dc 0d00002a bhs      #0xa0397318
a03972e0 14309de5 ldr      r3, [sp, #0x14]
a03972e4 000067e0 rsb      r0, r7, r0
a03972e8 000053e1 cmp      r3, r0
a03972ec 0500008a bhi      #0xa0397308
a03972f0 0c309de5 ldr      r3, [sp, #0xc]
a03972f4 000053e3 cmp      r3, #0
a03972f8 30209d15 ldrne    r2, [sp, #0x30]
a03972fc 0030a013 movne    r3, #0
a0397300 0c308d15 strne    r3, [sp, #0xc]
a0397304 00308215 strne    r3, [r2]
a0397308 000054e1 cmp      r4, r0
a039730c 0100008a bhi      #0xa0397318
a0397310 000056e3 cmp      r6, #0
a0397314 6400001a bne      #0xa03974ac
a0397318 003095e5 ldr      r3, [r5]
a039731c 000053e3 cmp      r3, #0
a0397320 89ffff1a bne      #0xa039714c
a0397324 000058e3 cmp      r8, #0
a0397328 3500000a beq      #0xa0397404
a039732c 040d0be3 movw     r0, #0xbd04
a0397330 70014ae3 movt     r0, #0xa170
a0397334 389400eb bl       #0xa03bc41c
a0397338 980c0be3 movw     r0, #0xbc98
a039733c 0010e0e3 mvn      r1, #0
a0397340 70014ae3 movt     r0, #0xa170
a0397344 299400eb bl       #0xa03bc3f0
a0397348 600701e3 movw     r0, #0x1760
a039734c c91e09e3 movw     r1, #0x9ec9
a0397350 331140e3 movt     r1, #0x133
a0397354 60004ae3 movt     r0, #0xa060
a0397358 633ffceb bl       #0xa02a70ec
a039735c 0020a0e3 mov      r2, #0
a0397360 ff10a0e3 mov      r1, #0xff
a0397364 0230a0e1 mov      r3, r2
a0397368 ff0001e3 movw     r0, #0x10ff
a039736c 5b6600eb bl       #0xa03b0ce0
a0397370 24309de5 ldr      r3, [sp, #0x24]
a0397374 001093e5 ldr      r1, [r3]
a0397378 000051e3 cmp      r1, #0
a039737c 0020a013 movne    r2, #0
a0397380 0120a001 moveq    r2, r1
a0397384 0230a011 movne    r3, r2
a0397388 0130a001 moveq    r3, r1
a039738c 0510a013 movne    r1, #5
a0397390 12000113 movwne   r0, #0x1012
a0397394 12000103 movweq   r0, #0x1012
a0397398 506600eb bl       #0xa03b0ce0
a039739c 0020a0e3 mov      r2, #0
a03973a0 0a1100e3 movw     r1, #0x10a
a03973a4 0230a0e1 mov      r3, r2
a03973a8 040001e3 movw     r0, #0x1004
a03973ac 4b6600eb bl       #0xa03b0ce0
a03973b0 0020a0e3 mov      r2, #0
a03973b4 00109be5 ldr      r1, [fp]
a03973b8 0230a0e1 mov      r3, r2
a03973bc 0a0001e3 movw     r0, #0x100a
a03973c0 466600eb bl       #0xa03b0ce0
a03973c4 780701e3 movw     r0, #0x1778
a03973c8 00109be5 ldr      r1, [fp]
a03973cc 60004ae3 movt     r0, #0xa060
a03973d0 453ffceb bl       #0xa02a70ec
a03973d4 3e27faeb bl       #0xa02210d4
a03973d8 004050e2 subs     r4, r0, #0
a03973dc 14ffff1a bne      #0xa0397034
a03973e0 880701e3 movw     r0, #0x1788
a03973e4 60004ae3 movt     r0, #0xa060
a03973e8 3f3ffceb bl       #0xa02a70ec
a03973ec 0410a0e1 mov      r1, r4
a03973f0 0420a0e1 mov      r2, r4
a03973f4 0430a0e1 mov      r3, r4
a03973f8 070001e3 movw     r0, #0x1007
a03973fc 376600eb bl       #0xa03b0ce0
a0397400 10ffffea b        #0xa0397048
a0397404 540701e3 movw     r0, #0x1754
a0397408 60004ae3 movt     r0, #0xa060
a039740c 363ffceb bl       #0xa02a70ec
a0397410 0900a0e1 mov      r0, sb
a0397414 6cdc03eb bl       #0xa048e5cc
a0397418 001507e3 movw     r1, #0x7500
a039741c 1a00a0e3 mov      r0, #0x1a
a0397420 39104ae3 movt     r1, #0xa039
a0397424 9ba7fceb bl       #0xa02c1298
a0397428 d41407e3 movw     r1, #0x74d4
a039742c 1c00a0e3 mov      r0, #0x1c
a0397430 39104ae3 movt     r1, #0xa039
a0397434 97a7fceb bl       #0xa02c1298
a0397438 880b0be3 movw     r0, #0xbb88
a039743c 0010e0e3 mvn      r1, #0
a0397440 70014ae3 movt     r0, #0xa170
a0397444 299400eb bl       #0xa03bc4f0
a0397448 0810a0e1 mov      r1, r8
a039744c 0820a0e1 mov      r2, r8
a0397450 0830a0e1 mov      r3, r8
a0397454 010001e3 movw     r0, #0x1001
a0397458 206600eb bl       #0xa03b0ce0
a039745c b2ffffea b        #0xa039732c
a0397460 0010a0e3 mov      r1, #0
a0397464 0f0001e3 movw     r0, #0x100f
a0397468 0120a0e1 mov      r2, r1
a039746c 0130a0e1 mov      r3, r1
a0397470 1a6600eb bl       #0xa03b0ce0
a0397474 96ffffea b        #0xa03972d4
a0397478 680b0be3 movw     r0, #0xbb68
a039747c 0030a0e3 mov      r3, #0
a0397480 70014ae3 movt     r0, #0xa170
a0397484 003085e5 str      r3, [r5]
a0397488 e39300eb bl       #0xa03bc41c
a039748c a1ffffea b        #0xa0397318
a0397490 bc0c0be3 movw     r0, #0xbcbc
a0397494 0130a0e3 mov      r3, #1
a0397498 70014ae3 movt     r0, #0xa170
a039749c 00308ae5 str      r3, [sl]
a03974a0 dd9300eb bl       #0xa03bc41c
a03974a4 00309ae5 ldr      r3, [sl]
a03974a8 36ffffea b        #0xa0397188
a03974ac 880b0be3 movw     r0, #0xbb88
a03974b0 0118a0e3 mov      r1, #0x10000
a03974b4 70014ae3 movt     r0, #0xa170
a03974b8 0060a0e3 mov      r6, #0
a03974bc 099400eb bl       #0xa03bc4e8
a03974c0 94ffffea b        #0xa0397318
a03974c4 880b0be3 movw     r0, #0xbb88
a03974c8 0110a0e3 mov      r1, #1
a03974cc 70014ae3 movt     r0, #0xa170
a03974d0 049400ea b        #0xa03bc4e8
a03974d4 08402de9 push     {r3, lr}
a03974d8 57dc03eb bl       #0xa048e63c
a03974dc 843a0be3 movw     r3, #0xba84
a03974e0 0810a0e3 mov      r1, #8
a03974e4 70314ae3 movt     r3, #0xa170
a03974e8 000083e5 str      r0, [r3]
a03974ec 880b0be3 movw     r0, #0xbb88
a03974f0 70014ae3 movt     r0, #0xa170
a03974f4 fb9300eb bl       #0xa03bc4e8
a03974f8 0000a0e3 mov      r0, #0
a03974fc 0880bde8 pop      {r3, pc}
a0397500 10402de9 push     {r4, lr}
a0397504 08d04de2 sub      sp, sp, #8
a0397508 4bdc03eb bl       #0xa048e63c
a039750c 203f00e3 movw     r3, #0xf20
a0397510 904c0be3 movw     r4, #0xbc90
a0397514 a3314ae3 movt     r3, #0xa1a3
a0397518 00c0a0e1 mov      ip, r0
a039751c 003093e5 ldr      r3, [r3]
a0397520 70414ae3 movt     r4, #0xa170
a0397524 0000a0e3 mov      r0, #0
a0397528 0120a0e3 mov      r2, #1
a039752c 00c084e5 str      ip, [r4]
a0397530 1201c7e7 bfi      r0, r2, #2, #6
a0397534 283093e5 ldr      r3, [r3, #0x28]
a0397538 000053e3 cmp      r3, #0
a039753c 0200000a beq      #0xa039754c
a0397540 04108de2 add      r1, sp, #4
a0397544 33ff2fe1 blx      r3
a0397548 00c094e5 ldr      ip, [r4]
a039754c 107a9fed vldr     s14, [pc, #0x40]
a0397550 243d0be3 movw     r3, #0xbd24
a0397554 017added vldr     s15, [sp, #4]
a0397558 942c0be3 movw     r2, #0xbc94
a039755c 880b0be3 movw     r0, #0xbb88
a0397560 70314ae3 movt     r3, #0xa170
a0397564 70214ae3 movt     r2, #0xa170
a0397568 0410a0e3 mov      r1, #4
a039756c 70014ae3 movt     r0, #0xa170
a0397570 00c082e5 str      ip, [r2]
a0397574 877a67ee vmul.f32 s15, s15, s14
a0397578 877a67ee vmul.f32 s15, s15, s14
a039757c e77afcee vcvt.u32.f32 s15, s15
a0397580 007ac3ed vstr     s15, [r3]
a0397584 d79300eb bl       #0xa03bc4e8
a0397588 0000a0e3 mov      r0, #0
a039758c 08d08de2 add      sp, sp, #8
a0397590 1080bde8 pop      {r4, pc}
a0397594 00008044 strmi    r0, [r0], #0
a0397598 fc3c0be3 movw     r3, #0xbcfc
a039759c 70314ae3 movt     r3, #0xa170
a03975a0 002093e5 ldr      r2, [r3]
a03975a4 010052e3 cmp      r2, #1
a03975a8 04005213 cmpne    r2, #4
a03975ac 1eff2f11 bxne     lr
a03975b0 0020a0e3 mov      r2, #0
a03975b4 002083e5 str      r2, [r3]
a03975b8 1eff2fe1 bx       lr
a03975bc f0402de9 push     {r4, r5, r6, r7, lr}
a03975c0 0070a0e1 mov      r7, r0
a03975c4 040d0be3 movw     r0, #0xbd04
a03975c8 14d04de2 sub      sp, sp, #0x14
a03975cc 0160a0e1 mov      r6, r1
a03975d0 70014ae3 movt     r0, #0xa170
a03975d4 0010a0e3 mov      r1, #0
a03975d8 b04b0be3 movw     r4, #0xbbb0
a03975dc 7e9300eb bl       #0xa03bc3dc
a03975e0 980c0be3 movw     r0, #0xbc98
a03975e4 0010a0e3 mov      r1, #0
a03975e8 70014ae3 movt     r0, #0xa170
a03975ec 70414ae3 movt     r4, #0xa170
a03975f0 799300eb bl       #0xa03bc3dc
a03975f4 dc0c0be3 movw     r0, #0xbcdc
a03975f8 0010a0e3 mov      r1, #0
a03975fc 70014ae3 movt     r0, #0xa170
a0397600 0150a0e1 mov      r5, r1
a0397604 749300eb bl       #0xa03bc3dc
a0397608 680b0be3 movw     r0, #0xbb68
a039760c 0510a0e1 mov      r1, r5
a0397610 70014ae3 movt     r0, #0xa170
a0397614 709300eb bl       #0xa03bc3dc
a0397618 bc0c0be3 movw     r0, #0xbcbc
a039761c 0510a0e1 mov      r1, r5
a0397620 70014ae3 movt     r0, #0xa170
a0397624 6c9300eb bl       #0xa03bc3dc
a0397628 880b0be3 movw     r0, #0xbb88
a039762c 70014ae3 movt     r0, #0xa170
a0397630 999300eb bl       #0xa03bc49c
a0397634 00c209e3 movw     ip, #0x9200
a0397638 02eaa0e3 mov      lr, #0x2000
a039763c acc04ae3 movt     ip, #0xa0ac
a0397640 c41701e3 movw     r1, #0x17c4
a0397644 343f06e3 movw     r3, #0x6f34
a0397648 0720a0e1 mov      r2, r7
a039764c 20108de8 stm      sp, {r5, ip}
a0397650 39304ae3 movt     r3, #0xa039
a0397654 08e08de5 str      lr, [sp, #8]
a0397658 0400a0e1 mov      r0, r4
a039765c 60104ae3 movt     r1, #0xa060
a0397660 0c508de5 str      r5, [sp, #0xc]
a0397664 149300eb bl       #0xa03bc2bc
a0397668 0610a0e1 mov      r1, r6
a039766c 0400a0e1 mov      r0, r4
a0397670 589400eb bl       #0xa03bc7d8
a0397674 0400a0e1 mov      r0, r4
a0397678 279300eb bl       #0xa03bc31c
a039767c 0500a0e1 mov      r0, r5
a0397680 14d08de2 add      sp, sp, #0x14
a0397684 f080bde8 pop      {r4, r5, r6, r7, pc}
a0397688 70402de9 push     {r4, r5, r6, lr}
a039768c 904a0be3 movw     r4, #0xba90
a0397690 58e09fe5 ldr      lr, [pc, #0x58]
a0397694 10d04de2 sub      sp, sp, #0x10
a0397698 02caa0e3 mov      ip, #0x2000
a039769c 70414ae3 movt     r4, #0xa170
a03976a0 0050a0e3 mov      r5, #0
a03976a4 0160a0e1 mov      r6, r1
a03976a8 e83e06e3 movw     r3, #0x6ee8
a03976ac dc1701e3 movw     r1, #0x17dc
a03976b0 0020a0e1 mov      r2, r0
a03976b4 20408de8 stm      sp, {r5, lr}
a03976b8 39304ae3 movt     r3, #0xa039
a03976bc 08c08de5 str      ip, [sp, #8]
a03976c0 0400a0e1 mov      r0, r4
a03976c4 60104ae3 movt     r1, #0xa060
a03976c8 0c508de5 str      r5, [sp, #0xc]
a03976cc fa9200eb bl       #0xa03bc2bc
a03976d0 0610a0e1 mov      r1, r6
a03976d4 0400a0e1 mov      r0, r4
a03976d8 3e9400eb bl       #0xa03bc7d8
a03976dc 0400a0e1 mov      r0, r4
a03976e0 0d9300eb bl       #0xa03bc31c
a03976e4 0500a0e1 mov      r0, r5
a03976e8 10d08de2 add      sp, sp, #0x10
a03976ec 7080bde8 pop      {r4, r5, r6, pc}
a03976f0 00b2aca0 adcge    fp, ip, r0, lsl #4
a03976f4 0110e0e1 mvn      r1, r1
a03976f8 afffffea b        #0xa03975bc
a03976fc 0110e0e1 mvn      r1, r1
a0397700 e0ffffea b        #0xa0397688
a0397704 6c3b07e3 movw     r3, #0x7b6c
a0397708 75304ae3 movt     r3, #0xa075
a039770c 0030d3e5 ldrb     r3, [r3]
a0397710 000053e3 cmp      r3, #0
a0397714 1600000a beq      #0xa0397774
a0397718 10402de9 push     {r4, lr}
a039771c fc4c0be3 movw     r4, #0xbcfc
a0397720 70414ae3 movt     r4, #0xa170
a0397724 003094e5 ldr      r3, [r4]
a0397728 000053e3 cmp      r3, #0
a039772c 0100000a beq      #0xa0397738
a0397730 0000a0e3 mov      r0, #0
a0397734 1080bde8 pop      {r4, pc}
a0397738 040d0be3 movw     r0, #0xbd04
a039773c 0010e0e3 mvn      r1, #0
a0397740 70014ae3 movt     r0, #0xa170
a0397744 299300eb bl       #0xa03bc3f0
a0397748 980c0be3 movw     r0, #0xbc98
a039774c 0130a0e3 mov      r3, #1
a0397750 70014ae3 movt     r0, #0xa170
a0397754 003084e5 str      r3, [r4]
a0397758 2f9300eb bl       #0xa03bc41c
a039775c dc0c0be3 movw     r0, #0xbcdc
a0397760 0010e0e3 mvn      r1, #0
a0397764 70014ae3 movt     r0, #0xa170
a0397768 209300eb bl       #0xa03bc3f0
a039776c 0000a0e3 mov      r0, #0
a0397770 1080bde8 pop      {r4, pc}
a0397774 0000a0e3 mov      r0, #0
a0397778 1eff2fe1 bx       lr
a039777c 08402de9 push     {r3, lr}
a0397780 6c3b07e3 movw     r3, #0x7b6c
a0397784 75304ae3 movt     r3, #0xa075
a0397788 0030d3e5 ldrb     r3, [r3]
a039778c 000053e3 cmp      r3, #0
a0397790 0000000a beq      #0xa0397798
a0397794 7fffffeb bl       #0xa0397598
a0397798 0000a0e3 mov      r0, #0
a039779c 0880bde8 pop      {r3, pc}
a03977a0 08402de9 push     {r3, lr}
a03977a4 6c3b07e3 movw     r3, #0x7b6c
a03977a8 75304ae3 movt     r3, #0xa075
a03977ac 0030d3e5 ldrb     r3, [r3]
a03977b0 000053e3 cmp      r3, #0
a03977b4 0600000a beq      #0xa03977d4
a03977b8 040d0be3 movw     r0, #0xbd04
a03977bc 0010e0e3 mvn      r1, #0
a03977c0 70014ae3 movt     r0, #0xa170
a03977c4 099300eb bl       #0xa03bc3f0
a03977c8 040d0be3 movw     r0, #0xbd04
a03977cc 70014ae3 movt     r0, #0xa170
a03977d0 119300eb bl       #0xa03bc41c
a03977d4 0000a0e3 mov      r0, #0
a03977d8 0880bde8 pop      {r3, pc}
a03977dc 683b07e3 movw     r3, #0x7b68
a03977e0 75304ae3 movt     r3, #0xa075
a03977e4 000083e5 str      r0, [r3]
