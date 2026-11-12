a029d3b4 e01a01e3 movw r1, #0x1ae0
a029d3b8 f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
a029d3bc 54104ae3 movt r1, #0xa054
a029d3c0 01dc4de2 sub sp, sp, #0x100
a029d3c4 3f4302eb bl #0xa032e0c8
a029d3c8 006050e2 subs r6, r0, #0
a029d3cc 3f00000a beq #0xa029d4d0
a029d3d0 0010a0e3 mov r1, #0
a029d3d4 0d50a0e1 mov r5, sp
a029d3d8 0140a0e1 mov r4, r1
a029d3dc 0180a0e3 mov r8, #1
a029d3e0 0470a0e1 mov r7, r4
a029d3e4 2090a0e3 mov sb, #0x20
a029d3e8 0d00a0e1 mov r0, sp
a029d3ec 012ca0e3 mov r2, #0x100
a029d3f0 7d6e09fa blx #0xa04f8dec
a029d3f4 0110a0e3 mov r1, #1
a029d3f8 0630a0e1 mov r3, r6
a029d3fc 0120a0e1 mov r2, r1
a029d400 0500a0e1 mov r0, r5
a029d404 324302eb bl #0xa032e0d4
a029d408 00a050e2 subs sl, r0, #0
a029d40c 013c8de2 add r3, sp, #0x100
a029d410 042083e0 add r2, r3, r4
a029d414 1c00000a beq #0xa029d48c
a029d418 ff0054e3 cmp r4, #0xff
a029d41c 1f0000ca bgt #0xa029d4a0
a029d420 003152e5 ldrb r3, [r2, #-0x100]
a029d424 000053e3 cmp r3, #0
a029d428 0d005313 cmpne r3, #0xd
a029d42c 0a1043e2 sub r1, r3, #0xa
a029d430 111f6fe1 clz r1, r1
a029d434 a112a0e1 lsr r1, r1, #5
a029d438 0100a003 moveq r0, #1
a029d43c 0000a013 movne r0, #0
a029d440 000091e1 orrs r0, r1, r0
a029d444 0400001a bne #0xa029d45c
a029d448 090053e3 cmp r3, #9
a029d44c 01408412 addne r4, r4, #1
a029d450 00914205 strbeq sb, [r2, #-0x100]
a029d454 04508d10 addne r5, sp, r4
a029d458 e5ffffea b #0xa029d3f4
a029d45c 000051e3 cmp r1, #0
a029d460 0d00a0e1 mov r0, sp
a029d464 007142e5 strb r7, [r2, #-0x100]
a029d468 01808812 addne r8, r8, #1
a029d46c 11feffeb bl #0xa029ccb8
a029d470 0d00a0e1 mov r0, sp
a029d474 0010a0e3 mov r1, #0
a029d478 012ca0e3 mov r2, #0x100
a029d47c 0d50a0e1 mov r5, sp
a029d480 0040a0e3 mov r4, #0
a029d484 586e09fa blx #0xa04f8dec
a029d488 d9ffffea b #0xa029d3f4
a029d48c 0600a0e1 mov r0, r6
a029d490 0e4302eb bl #0xa032e0d0
a029d494 0a00a0e1 mov r0, sl
a029d498 01dc8de2 add sp, sp, #0x100
a029d49c f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a029d4a0 683003e3 movw r3, #0x3068
a029d4a4 70040ee3 movw r0, #0xe470
a029d4a8 6f304ae3 movt r3, #0xa06f
a029d4ac 0810a0e1 mov r1, r8
a029d4b0 003093e5 ldr r3, [r3]
a029d4b4 5a004ae3 movt r0, #0xa05a
a029d4b8 33ff2fe1 blx r3
a029d4bc 0600a0e1 mov r0, r6
a029d4c0 024302eb bl #0xa032e0d0
a029d4c4 0000e0e3 mvn r0, #0
a029d4c8 01dc8de2 add sp, sp, #0x100
a029d4cc f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a029d4d0 0000e0e3 mvn r0, #0
a029d4d4 efffffea b #0xa029d498
