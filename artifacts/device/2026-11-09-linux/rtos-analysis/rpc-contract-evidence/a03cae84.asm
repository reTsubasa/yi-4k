a03cae84 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03cae88 b0b205e3 movw fp, #0x52b0
a03cae8c a4ac0ae3 movw sl, #0xaca4
a03cae90 44b14ae3 movt fp, #0xa144
a03cae94 62a04ae3 movt sl, #0xa062
a03cae98 2cd04de2 sub sp, sp, #0x2c
a03cae9c 0030a0e3 mov r3, #0
a03caea0 0050a0e1 mov r5, r0
a03caea4 449080e2 add sb, r0, #0x44
a03caea8 34009be5 ldr r0, [fp, #0x34]
a03caeac 18308de5 str r3, [sp, #0x18]
a03caeb0 1c308de5 str r3, [sp, #0x1c]
a03caeb4 20308de5 str r3, [sp, #0x20]
a03caeb8 24308de5 str r3, [sp, #0x24]
a03caebc 050900eb bl #0xa03cd2d8
a03caec0 0cb08de5 str fp, [sp, #0xc]
a03caec4 1c008de5 str r0, [sp, #0x1c]
a03caec8 0040e0e3 mvn r4, #0
a03caecc 0900a0e1 mov r0, sb
a03caed0 00408de5 str r4, [sp]
a03caed4 0510a0e3 mov r1, #5
a03caed8 0120a0e3 mov r2, #1
a03caedc 14308de2 add r3, sp, #0x14
a03caee0 71c5ffeb bl #0xa03bc4ac
a03caee4 000050e3 cmp r0, #0
a03caee8 6900001a bne #0xa03cb094
a03caeec 14309de5 ldr r3, [sp, #0x14]
a03caef0 040013e3 tst r3, #4
a03caef4 6b00001a bne #0xa03cb0a8
a03caef8 106085e2 add r6, r5, #0x10
a03caefc 0410a0e1 mov r1, r4
a03caf00 0600a0e1 mov r0, r6
a03caf04 357e85e2 add r7, r5, #0x350
a03caf08 57c5ffeb bl #0xa03bc46c
a03caf0c 402395e5 ldr r2, [r5, #0x340]
a03caf10 0700a0e1 mov r0, r7
a03caf14 3c1395e5 ldr r1, [r5, #0x33c]
a03caf18 4c2082e2 add r2, r2, #0x4c
a03caf1c d745fbeb bl #0xa029c680
a03caf20 0210a0e3 mov r1, #2
a03caf24 0900a0e1 mov r0, sb
a03caf28 6ec5ffeb bl #0xa03bc4e8
a03caf2c 001050e2 subs r1, r0, #0
a03caf30 1700001a bne #0xa03caf94
a03caf34 483395e5 ldr r3, [r5, #0x348]
a03caf38 000053e3 cmp r3, #0
a03caf3c 0b0000da ble #0xa03caf70
a03caf40 0530a0e1 mov r3, r5
a03caf44 00c0a0e3 mov ip, #0
a03caf48 704193e5 ldr r4, [r3, #0x170]
a03caf4c 3c3083e2 add r3, r3, #0x3c
a03caf50 000054e3 cmp r4, #0
a03caf54 1200000a beq #0xa03cafa4
a03caf58 01c08ce2 add ip, ip, #1
a03caf5c 08005ce3 cmp ip, #8
a03caf60 f8ffff1a bne #0xa03caf48
a03caf64 60040ee3 movw r0, #0xe460
a03caf68 60004ae3 movt r0, #0xa060
a03caf6c 5e70fbeb bl #0xa02a70ec
a03caf70 0600a0e1 mov r0, r6
a03caf74 47c5ffeb bl #0xa03bc498
a03caf78 443395e5 ldr r3, [r5, #0x344]
a03caf7c 010053e3 cmp r3, #1
a03caf80 d0ffff0a beq #0xa03caec8
a03caf84 1c009de5 ldr r0, [sp, #0x1c]
a03caf88 b50800eb bl #0xa03cd264
a03caf8c 2cd08de2 add sp, sp, #0x2c
a03caf90 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03caf94 28040ee3 movw r0, #0xe428
a03caf98 60004ae3 movt r0, #0xa060
a03caf9c 5270fbeb bl #0xa02a70ec
a03cafa0 e3ffffea b #0xa03caf34
a03cafa4 0c83a0e1 lsl r8, ip, #6
a03cafa8 07e0a0e1 mov lr, r7
a03cafac 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a03cafb0 0c8148e0 sub r8, r8, ip, lsl #2
a03cafb4 08b085e0 add fp, r5, r8
a03cafb8 57cf8be2 add ip, fp, #0x15c
a03cafbc 578f9be2 adds r8, fp, #0x15c
a03cafc0 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03cafc4 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a03cafc8 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03cafcc 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a03cafd0 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03cafd4 07009ee8 ldm lr, {r0, r1, r2}
a03cafd8 07008ce8 stm ip, {r0, r1, r2}
a03cafdc 70518be5 str r5, [fp, #0x170]
a03cafe0 dfffff0a beq #0xa03caf64
a03cafe4 0700a0e1 mov r0, r7
a03cafe8 e37f85e2 add r7, r5, #0x38c
a03cafec 981395e5 ldr r1, [r5, #0x398]
a03caff0 10209ae5 ldr r2, [sl, #0x10]
a03caff4 4c3395e5 ldr r3, [r5, #0x34c]
a03caff8 002092e5 ldr r2, [r2]
a03caffc 813183e0 add r3, r3, r1, lsl #3
a03cb000 782385e5 str r2, [r5, #0x378]
a03cb004 041013e5 ldr r1, [r3, #-4]
a03cb008 70f6ffeb bl #0xa03c89d0
a03cb00c 483395e5 ldr r3, [r5, #0x348]
a03cb010 982395e5 ldr r2, [r5, #0x398]
a03cb014 030052e1 cmp r2, r3
a03cb018 0130a0d3 movle r3, #1
a03cb01c 0030a0c3 movgt r3, #0
a03cb020 000052e3 cmp r2, #0
a03cb024 0030a0d3 movle r3, #0
a03cb028 000053e3 cmp r3, #0
a03cb02c 1000000a beq #0xa03cb074
a03cb030 0c309de5 ldr r3, [sp, #0xc]
a03cb034 0410a0e1 mov r1, r4
a03cb038 1c009de5 ldr r0, [sp, #0x1c]
a03cb03c 342093e5 ldr r2, [r3, #0x34]
a03cb040 69b704fa blx #0xa04f8dec
a03cb044 983395e5 ldr r3, [r5, #0x398]
a03cb048 18108de2 add r1, sp, #0x18
a03cb04c 4c2395e5 ldr r2, [r5, #0x34c]
a03cb050 e70f85e2 add r0, r5, #0x39c
a03cb054 1e3243e2 sub r3, r3, #0xe0000001
a03cb058 833192e7 ldr r3, [r2, r3, lsl #3]
a03cb05c 33ff2fe1 blx r3
a03cb060 0700a0e1 mov r0, r7
a03cb064 0810a0e1 mov r1, r8
a03cb068 18208de2 add r2, sp, #0x18
a03cb06c 56ffffeb bl #0xa03cadcc
a03cb070 beffffea b #0xa03caf70
a03cb074 02c0a0e3 mov ip, #2
a03cb078 0700a0e1 mov r0, r7
a03cb07c 0810a0e1 mov r1, r8
a03cb080 18208de2 add r2, sp, #0x18
a03cb084 20308de5 str r3, [sp, #0x20]
a03cb088 24c08de5 str ip, [sp, #0x24]
a03cb08c 4effffeb bl #0xa03cadcc
a03cb090 b6ffffea b #0xa03caf70
a03cb094 0010a0e1 mov r1, r0
a03cb098 f0030ee3 movw r0, #0xe3f0
a03cb09c 60004ae3 movt r0, #0xa060
a03cb0a0 1170fbeb bl #0xa02a70ec
a03cb0a4 b6ffffea b #0xa03caf84
a03cb0a8 1c009de5 ldr r0, [sp, #0x1c]
a03cb0ac 6c0800eb bl #0xa03cd264
a03cb0b0 0810a0e3 mov r1, #8
a03cb0b4 0900a0e1 mov r0, sb
a03cb0b8 0ac5ffeb bl #0xa03bc4e8
a03cb0bc 001050e2 subs r1, r0, #0
a03cb0c0 b1ffff0a beq #0xa03caf8c
a03cb0c4 88040ee3 movw r0, #0xe488
a03cb0c8 60004ae3 movt r0, #0xa060
a03cb0cc 0670fbeb bl #0xa02a70ec
a03cb0d0 adffffea b #0xa03caf8c
