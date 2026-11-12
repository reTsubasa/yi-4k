a03cf01c 38402de9 push {r3, r4, r5, lr}
a03cf020 e60200eb bl #0xa03cfbc0
a03cf024 003000e3 movw r3, #0
a03cf028 0040a0e1 mov r4, r0
a03cf02c 003040e3 movt r3, #0
a03cf030 000053e3 cmp r3, #0
a03cf034 0000000a beq #0xa03cf03c
a03cf038 00f020e3 nop 
a03cf03c c8050fe3 movw r0, #0xf5c8
a03cf040 28140fe3 movw r1, #0xf428
a03cf044 60104ae3 movt r1, #0xa060
a03cf048 60004ae3 movt r0, #0xa060
a03cf04c 2660fbeb bl #0xa02a70ec
a03cf050 0030a0e3 mov r3, #0
a03cf054 083084e5 str r3, [r4, #8]
a03cf058 db0200eb bl #0xa03cfbcc
a03cf05c 000050e3 cmp r0, #0
a03cf060 140084e5 str r0, [r4, #0x14]
a03cf064 3f00000a beq #0xa03cf168
a03cf068 500100e3 movw r0, #0x150
a03cf06c 7e014ae3 movt r0, #0xa17e
a03cf070 003090e5 ldr r3, [r0]
a03cf074 0c0084e5 str r0, [r4, #0xc]
a03cf078 000053e3 cmp r3, #0
a03cf07c 1d00000a beq #0xa03cf0f8
a03cf080 780100e3 movw r0, #0x178
a03cf084 7e014ae3 movt r0, #0xa17e
a03cf088 003090e5 ldr r3, [r0]
a03cf08c 100084e5 str r0, [r4, #0x10]
a03cf090 000053e3 cmp r3, #0
a03cf094 2a00000a beq #0xa03cf144
a03cf098 005094e5 ldr r5, [r4]
a03cf09c 0130a0e3 mov r3, #1
a03cf0a0 b03085e5 str r3, [r5, #0xb0]
a03cf0a4 143094e5 ldr r3, [r4, #0x14]
a03cf0a8 003093e5 ldr r3, [r3]
a03cf0ac 000053e3 cmp r3, #0
a03cf0b0 1e00000a beq #0xa03cf130
a03cf0b4 0400a0e1 mov r0, r4
a03cf0b8 33ff2fe1 blx r3
a03cf0bc 0040a0e1 mov r4, r0
a03cf0c0 0000a0e3 mov r0, #0
a03cf0c4 0010a0e1 mov r1, r0
a03cf0c8 84ffffeb bl #0xa03ceee0
a03cf0cc 7f0a00eb bl #0xa03d1ad0
a03cf0d0 000054e3 cmp r4, #0
a03cf0d4 0f00001a bne #0xa03cf118
a03cf0d8 0130a0e3 mov r3, #1
a03cf0dc ac3085e5 str r3, [r5, #0xac]
a03cf0e0 003000e3 movw r3, #0
a03cf0e4 003040e3 movt r3, #0
a03cf0e8 000053e3 cmp r3, #0
a03cf0ec 3880bd08 popeq {r3, r4, r5, pc}
a03cf0f0 3840bde8 pop {r3, r4, r5, lr}
a03cf0f4 00f020e3 nop 
a03cf0f8 e7b4ffeb bl #0xa03bc49c
a03cf0fc 000050e3 cmp r0, #0
a03cf100 deffff0a beq #0xa03cf080
a03cf104 dc050fe3 movw r0, #0xf5dc
a03cf108 28140fe3 movw r1, #0xf428
a03cf10c 60004ae3 movt r0, #0xa060
a03cf110 60104ae3 movt r1, #0xa060
a03cf114 f45ffbeb bl #0xa02a70ec
a03cf118 18060fe3 movw r0, #0xf618
a03cf11c 28140fe3 movw r1, #0xf428
a03cf120 60104ae3 movt r1, #0xa060
a03cf124 60004ae3 movt r0, #0xa060
a03cf128 ef5ffbeb bl #0xa02a70ec
a03cf12c ebffffea b #0xa03cf0e0
a03cf130 0300a0e1 mov r0, r3
a03cf134 0310a0e1 mov r1, r3
a03cf138 68ffffeb bl #0xa03ceee0
a03cf13c 630a00eb bl #0xa03d1ad0
a03cf140 e4ffffea b #0xa03cf0d8
a03cf144 c3b4ffeb bl #0xa03bc458
a03cf148 000050e3 cmp r0, #0
a03cf14c d1ffff0a beq #0xa03cf098
a03cf150 fc050fe3 movw r0, #0xf5fc
a03cf154 28140fe3 movw r1, #0xf428
a03cf158 60104ae3 movt r1, #0xa060
a03cf15c 60004ae3 movt r0, #0xa060
a03cf160 e15ffbeb bl #0xa02a70ec
a03cf164 ebffffea b #0xa03cf118
a03cf168 a80b0ae3 movw r0, #0xaba8
a03cf16c ac170fe3 movw r1, #0xf7ac
a03cf170 60104ae3 movt r1, #0xa060
a03cf174 372200e3 movw r2, #0x237
a03cf178 53004ae3 movt r0, #0xa053
a03cf17c da5ffbeb bl #0xa02a70ec
a03cf180 e760fbeb bl #0xa02a7524
a03cf184 c0000cf1 cpsid if
a03cf188 feffffea b #0xa03cf188
a03cf18c f0402de9 push {r4, r5, r6, r7, lr}
a03cf190 1cd04de2 sub sp, sp, #0x1c
