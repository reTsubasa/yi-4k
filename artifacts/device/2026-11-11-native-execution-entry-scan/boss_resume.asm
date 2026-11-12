a03cf4a0 38402de9 push {r3, r4, r5, lr}
a03cf4a4 c50100eb bl #0xa03cfbc0
a03cf4a8 0050a0e1 mov r5, r0
a03cf4ac 143090e5 ldr r3, [r0, #0x14]
a03cf4b0 000053e3 cmp r3, #0
a03cf4b4 1500000a beq #0xa03cf510
a03cf4b8 100090e5 ldr r0, [r0, #0x10]
a03cf4bc 0010e0e3 mvn r1, #0
a03cf4c0 e9b3ffeb bl #0xa03bc46c
a03cf4c4 000050e3 cmp r0, #0
a03cf4c8 0400000a beq #0xa03cf4e0
a03cf4cc 38060fe3 movw r0, #0xf638
a03cf4d0 bc170fe3 movw r1, #0xf7bc
a03cf4d4 60004ae3 movt r0, #0xa060
a03cf4d8 60104ae3 movt r1, #0xa060
a03cf4dc 025ffbeb bl #0xa02a70ec
a03cf4e0 143095e5 ldr r3, [r5, #0x14]
a03cf4e4 103093e5 ldr r3, [r3, #0x10]
a03cf4e8 000053e3 cmp r3, #0
a03cf4ec 0340a001 moveq r4, r3
a03cf4f0 0200000a beq #0xa03cf500
a03cf4f4 0500a0e1 mov r0, r5
a03cf4f8 33ff2fe1 blx r3
a03cf4fc 0040a0e1 mov r4, r0
a03cf500 100095e5 ldr r0, [r5, #0x10]
a03cf504 e3b3ffeb bl #0xa03bc498
a03cf508 0400a0e1 mov r0, r4
a03cf50c 3880bde8 pop {r3, r4, r5, pc}
a03cf510 a80b0ae3 movw r0, #0xaba8
a03cf514 34180fe3 movw r1, #0xf834
a03cf518 60104ae3 movt r1, #0xa060
a03cf51c 062300e3 movw r2, #0x306
a03cf520 53004ae3 movt r0, #0xa053
a03cf524 f05efbeb bl #0xa02a70ec
a03cf528 fd5ffbeb bl #0xa02a7524
a03cf52c c0000cf1 cpsid if
a03cf530 feffffea b #0xa03cf530
a03cf534 38402de9 push {r3, r4, r5, lr}
