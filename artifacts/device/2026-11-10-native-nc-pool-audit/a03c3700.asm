a03bd34c 000050e3 cmp r0, #0
a03bd350 0e00000a beq #0xa03bd390
a03bd354 f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
a03bd358 ee5e0ee3 movw r5, #0xeeee
a03bd35c 044010e5 ldr r4, [r0, #-4]
a03bd360 ff5f4fe3 movt r5, #0xffff
a03bd364 050054e1 cmp r4, r5
a03bd368 0600000a beq #0xa03bd388
a03bd36c 000054e3 cmp r4, #0
a03bd370 0400000a beq #0xa03bd388
a03bd374 002094e5 ldr r2, [r4]
a03bd378 453405e3 movw r3, #0x5445
a03bd37c 593244e3 movt r3, #0x4259
a03bd380 030052e1 cmp r2, r3
a03bd384 0300000a beq #0xa03bd398
a03bd388 0300a0e3 mov r0, #3
a03bd38c f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03bd390 0300a0e3 mov r0, #3
a03bd394 1eff2fe1 bx lr
a03bd398 0060a0e1 mov r6, r0
a03bd39c 0080a0e3 mov r8, #0
a03bd3a0 690e00eb bl #0xa03c0d4c
a03bd3a4 200084e5 str r0, [r4, #0x20]
a03bd3a8 087046e2 sub r7, r6, #8
a03bd3ac ff0f00eb bl #0xa03c13b0
a03bd3b0 045006e5 str r5, [r6, #-4]
a03bd3b4 00c0a0e1 mov ip, r0
a03bd3b8 141094e5 ldr r1, [r4, #0x14]
a03bd3bc 083016e5 ldr r3, [r6, #-8]
a03bd3c0 ee6e0ee3 movw r6, #0xeeee
a03bd3c4 082094e5 ldr r2, [r4, #8]
a03bd3c8 ff6f4fe3 movt r6, #0xffff
a03bd3cc 010057e1 cmp r7, r1
a03bd3d0 033067e0 rsb r3, r7, r3
a03bd3d4 14708435 strlo r7, [r4, #0x14]
a03bd3d8 807706e3 movw r7, #0x6780
a03bd3dc 033082e0 add r3, r2, r3
a03bd3e0 79714ae3 movt r7, #0xa179
a03bd3e4 083084e5 str r3, [r4, #8]
a03bd3e8 283094e5 ldr r3, [r4, #0x28]
a03bd3ec 0c00a0e1 mov r0, ip
a03bd3f0 000053e3 cmp r3, #0
a03bd3f4 1a00000a beq #0xa03bd464
a03bd3f8 249094e5 ldr sb, [r4, #0x24]
a03bd3fc 091000eb bl #0xa03c1428
a03bd400 0400a0e1 mov r0, r4
a03bd404 7c1099e5 ldr r1, [sb, #0x7c]
a03bd408 48ffffeb bl #0xa03bd130
a03bd40c 0050a0e1 mov r5, r0
a03bd410 e60f00eb bl #0xa03c13b0
a03bd414 000055e3 cmp r5, #0
a03bd418 00c0a0e1 mov ip, r0
a03bd41c 081045e2 sub r1, r5, #8
a03bd420 0f00000a beq #0xa03bd464
a03bd424 24a094e5 ldr sl, [r4, #0x24]
a03bd428 09005ae1 cmp sl, sb
a03bd42c 1100000a beq #0xa03bd478
a03bd430 083015e5 ldr r3, [r5, #-8]
a03bd434 046005e5 str r6, [r5, #-4]
a03bd438 082094e5 ldr r2, [r4, #8]
a03bd43c 033061e0 rsb r3, r1, r3
a03bd440 140094e5 ldr r0, [r4, #0x14]
a03bd444 033082e0 add r3, r2, r3
a03bd448 083084e5 str r3, [r4, #8]
a03bd44c 000051e1 cmp r1, r0
a03bd450 283094e5 ldr r3, [r4, #0x28]
a03bd454 0c00a0e1 mov r0, ip
a03bd458 14108435 strlo r1, [r4, #0x14]
a03bd45c 000053e3 cmp r3, #0
a03bd460 e4ffff1a bne #0xa03bd3f8
a03bd464 0c00a0e1 mov r0, ip
a03bd468 ee0f00eb bl #0xa03c1428
a03bd46c 9c1000eb bl #0xa03c16e4
a03bd470 0000a0e3 mov r0, #0
a03bd474 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03bd478 283094e5 ldr r3, [r4, #0x28]
a03bd47c 013043e2 sub r3, r3, #1
a03bd480 000053e3 cmp r3, #0
a03bd484 283084e5 str r3, [r4, #0x28]
a03bd488 74309a15 ldrne r3, [sl, #0x74]
a03bd48c 24308405 streq r3, [r4, #0x24]
a03bd490 24308415 strne r3, [r4, #0x24]
a03bd494 78209a15 ldrne r2, [sl, #0x78]
a03bd498 78208315 strne r2, [r3, #0x78]
a03bd49c 74308215 strne r3, [r2, #0x74]
a03bd4a0 80309ae5 ldr r3, [sl, #0x80]
a03bd4a4 6c808ae5 str r8, [sl, #0x6c]
a03bd4a8 005083e5 str r5, [r3]
a03bd4ac 003097e5 ldr r3, [r7]
a03bd4b0 88808ae5 str r8, [sl, #0x88]
a03bd4b4 013083e2 add r3, r3, #1
a03bd4b8 003087e5 str r3, [r7]
a03bd4bc d90f00eb bl #0xa03c1428
a03bd4c0 0a00a0e1 mov r0, sl
a03bd4c4 be1000eb bl #0xa03c17c4
a03bd4c8 b80f00eb bl #0xa03c13b0
a03bd4cc 00c0a0e1 mov ip, r0
a03bd4d0 c4ffffea b #0xa03bd3e8
a03c3700 000050e3 cmp r0, #0
a03c3704 1000000a beq #0xa03c374c
a03c3708 10402de9 push {r4, lr}
a03c370c 0040a0e1 mov r4, r0
a03c3710 8df5ffeb bl #0xa03c0d4c
a03c3714 343c06e3 movw r3, #0x6c34
a03c3718 79314ae3 movt r3, #0xa179
a03c371c 000053e1 cmp r3, r0
a03c3720 0700000a beq #0xa03c3744
a03c3724 77f5ffeb bl #0xa03c0d08
a03c3728 000050e3 cmp r0, #0
a03c372c 0800000a beq #0xa03c3754
a03c3730 74f5ffeb bl #0xa03c0d08
a03c3734 ef300fe3 movw r3, #0xf0ef
a03c3738 f0304fe3 movt r3, #0xf0f0
a03c373c 030050e1 cmp r0, r3
a03c3740 0300008a bhi #0xa03c3754
a03c3744 1300a0e3 mov r0, #0x13
a03c3748 1080bde8 pop {r4, pc}
a03c374c 0300a0e3 mov r0, #3
a03c3750 1eff2fe1 bx lr
a03c3754 0400a0e1 mov r0, r4
a03c3758 1040bde8 pop {r4, lr}
a03c375c fae6ffea b #0xa03bd34c
