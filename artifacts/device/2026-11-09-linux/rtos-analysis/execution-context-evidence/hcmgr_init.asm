a01e627c 10402de9 push {r4, lr}
a01e6280 1020a0e3 mov r2, #0x10
a01e6284 10d04de2 sub sp, sp, #0x10
a01e6288 48029fe5 ldr r0, [pc, #0x248]
a01e628c 4030a0e3 mov r3, #0x40
a01e6290 44129fe5 ldr r1, [pc, #0x244]
a01e6294 a65807eb bl #0xa03bc534
a01e6298 002050e2 subs r2, r0, #0
a01e629c 8600001a bne #0xa01e64bc
a01e62a0 38029fe5 ldr r0, [pc, #0x238]
a01e62a4 1020a0e3 mov r2, #0x10
a01e62a8 8030a0e3 mov r3, #0x80
a01e62ac 711d40e2 sub r1, r0, #0x1c40
a01e62b0 9f5807eb bl #0xa03bc534
a01e62b4 002050e2 subs r2, r0, #0
a01e62b8 7800001a bne #0xa01e64a0
a01e62bc 1020a0e3 mov r2, #0x10
a01e62c0 1c029fe5 ldr r0, [pc, #0x21c]
a01e62c4 1c129fe5 ldr r1, [pc, #0x21c]
a01e62c8 8030a0e3 mov r3, #0x80
a01e62cc 985807eb bl #0xa03bc534
a01e62d0 002050e2 subs r2, r0, #0
a01e62d4 6a00001a bne #0xa01e6484
a01e62d8 1020a0e3 mov r2, #0x10
a01e62dc 08029fe5 ldr r0, [pc, #0x208]
a01e62e0 08129fe5 ldr r1, [pc, #0x208]
a01e62e4 4030a0e3 mov r3, #0x40
a01e62e8 915807eb bl #0xa03bc534
a01e62ec 002050e2 subs r2, r0, #0
a01e62f0 5c00001a bne #0xa01e6468
a01e62f4 2c20a0e3 mov r2, #0x2c
a01e62f8 f4019fe5 ldr r0, [pc, #0x1f4]
a01e62fc f4119fe5 ldr r1, [pc, #0x1f4]
a01e6300 4030a0e3 mov r3, #0x40
a01e6304 8a5807eb bl #0xa03bc534
a01e6308 002050e2 subs r2, r0, #0
a01e630c 4e00001a bne #0xa01e644c
a01e6310 e4019fe5 ldr r0, [pc, #0x1e4]
a01e6314 0010a0e3 mov r1, #0
a01e6318 2f5807eb bl #0xa03bc3dc
a01e631c 002050e2 subs r2, r0, #0
a01e6320 4200001a bne #0xa01e6430
a01e6324 d4019fe5 ldr r0, [pc, #0x1d4]
a01e6328 4a5807eb bl #0xa03bc458
a01e632c 002050e2 subs r2, r0, #0
a01e6330 3700001a bne #0xa01e6414
a01e6334 c8019fe5 ldr r0, [pc, #0x1c8]
a01e6338 575807eb bl #0xa03bc49c
a01e633c 002050e2 subs r2, r0, #0
a01e6340 2c00001a bne #0xa01e63f8
a01e6344 0110a0e3 mov r1, #1
a01e6348 b4019fe5 ldr r0, [pc, #0x1b4]
a01e634c c04100e3 movw r4, #0x1c0
a01e6350 645807eb bl #0xa03bc4e8
a01e6354 39414ae3 movt r4, #0xa139
a01e6358 00c0a0e3 mov ip, #0
a01e635c 0128a0e3 mov r2, #0x10000
a01e6360 0100a0e3 mov r0, #1
a01e6364 28160ee3 movw r1, #0xe628
a01e6368 d43b05e3 movw r3, #0x5bd4
a01e636c 08208de5 str r2, [sp, #8]
a01e6370 57104ae3 movt r1, #0xa057
a01e6374 6e20a0e3 mov r2, #0x6e
a01e6378 0c008de5 str r0, [sp, #0xc]
a01e637c 04408de5 str r4, [sp, #4]
a01e6380 1e304ae3 movt r3, #0xa01e
a01e6384 00c08de5 str ip, [sp]
a01e6388 78019fe5 ldr r0, [pc, #0x178]
a01e638c ca5707eb bl #0xa03bc2bc
a01e6390 002050e2 subs r2, r0, #0
a01e6394 1000001a bne #0xa01e63dc
a01e6398 68019fe5 ldr r0, [pc, #0x168]
a01e639c 0110a0e3 mov r1, #1
a01e63a0 0c5907eb bl #0xa03bc7d8
a01e63a4 000050e3 cmp r0, #0
a01e63a8 0500000a beq #0xa01e63c4
a01e63ac 7c3003e3 movw r3, #0x307c
a01e63b0 7c060ee3 movw r0, #0xe67c
a01e63b4 6f304ae3 movt r3, #0xa06f
a01e63b8 57004ae3 movt r0, #0xa057
a01e63bc 041093e5 ldr r1, [r3, #4]
a01e63c0 490303eb bl #0xa02a70ec
a01e63c4 40319fe5 ldr r3, [pc, #0x140]
a01e63c8 0120a0e3 mov r2, #1
a01e63cc 0000a0e3 mov r0, #0
a01e63d0 1c22c3e5 strb r2, [r3, #0x21c]
a01e63d4 10d08de2 add sp, sp, #0x10
a01e63d8 1080bde8 pop {r4, pc}
a01e63dc 7c3003e3 movw r3, #0x307c
a01e63e0 44060ee3 movw r0, #0xe644
a01e63e4 6f304ae3 movt r3, #0xa06f
a01e63e8 57004ae3 movt r0, #0xa057
a01e63ec 041093e5 ldr r1, [r3, #4]
a01e63f0 3d0303eb bl #0xa02a70ec
a01e63f4 e7ffffea b #0xa01e6398
a01e63f8 7c3003e3 movw r3, #0x307c
a01e63fc f0050ee3 movw r0, #0xe5f0
a01e6400 6f304ae3 movt r3, #0xa06f
a01e6404 57004ae3 movt r0, #0xa057
a01e6408 041093e5 ldr r1, [r3, #4]
a01e640c 360303eb bl #0xa02a70ec
a01e6410 cbffffea b #0xa01e6344
a01e6414 7c3003e3 movw r3, #0x307c
a01e6418 b8050ee3 movw r0, #0xe5b8
a01e641c 6f304ae3 movt r3, #0xa06f
a01e6420 57004ae3 movt r0, #0xa057
a01e6424 041093e5 ldr r1, [r3, #4]
a01e6428 2f0303eb bl #0xa02a70ec
a01e642c c0ffffea b #0xa01e6334
a01e6430 7c3003e3 movw r3, #0x307c
a01e6434 70050ee3 movw r0, #0xe570
a01e6438 6f304ae3 movt r3, #0xa06f
a01e643c 57004ae3 movt r0, #0xa057
a01e6440 041093e5 ldr r1, [r3, #4]
a01e6444 280303eb bl #0xa02a70ec
a01e6448 b5ffffea b #0xa01e6324
a01e644c 7c3003e3 movw r3, #0x307c
a01e6450 2c050ee3 movw r0, #0xe52c
a01e6454 6f304ae3 movt r3, #0xa06f
a01e6458 57004ae3 movt r0, #0xa057
a01e645c 041093e5 ldr r1, [r3, #4]
a01e6460 210303eb bl #0xa02a70ec
a01e6464 a9ffffea b #0xa01e6310
a01e6468 7c3003e3 movw r3, #0x307c
a01e646c ec040ee3 movw r0, #0xe4ec
a01e6470 6f304ae3 movt r3, #0xa06f
a01e6474 57004ae3 movt r0, #0xa057
a01e6478 041093e5 ldr r1, [r3, #4]
a01e647c 1a0303eb bl #0xa02a70ec
a01e6480 9bffffea b #0xa01e62f4
a01e6484 7c3003e3 movw r3, #0x307c
a01e6488 ac040ee3 movw r0, #0xe4ac
a01e648c 6f304ae3 movt r3, #0xa06f
a01e6490 57004ae3 movt r0, #0xa057
a01e6494 041093e5 ldr r1, [r3, #4]
a01e6498 130303eb bl #0xa02a70ec
a01e649c 8dffffea b #0xa01e62d8
a01e64a0 7c3003e3 movw r3, #0x307c
a01e64a4 6c040ee3 movw r0, #0xe46c
a01e64a8 6f304ae3 movt r3, #0xa06f
a01e64ac 57004ae3 movt r0, #0xa057
a01e64b0 041093e5 ldr r1, [r3, #4]
a01e64b4 0c0303eb bl #0xa02a70ec
a01e64b8 7fffffea b #0xa01e62bc
a01e64bc 7c3003e3 movw r3, #0x307c
a01e64c0 28040ee3 movw r0, #0xe428
a01e64c4 6f304ae3 movt r3, #0xa06f
a01e64c8 57004ae3 movt r0, #0xa057
a01e64cc 041093e5 ldr r1, [r3, #4]
a01e64d0 050303eb bl #0xa02a70ec
a01e64d4 71ffffea b #0xa01e62a0
