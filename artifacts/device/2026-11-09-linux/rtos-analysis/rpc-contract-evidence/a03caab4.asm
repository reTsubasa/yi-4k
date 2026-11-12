a03caab4 f0432de9 push {r4, r5, r6, r7, r8, sb, lr}
a03caab8 084609e3 movw r4, #0x9608
a03caabc 78404ae3 movt r4, #0xa078
a03caac0 0160a0e1 mov r6, r1
a03caac4 0380a0e1 mov r8, r3
a03caac8 14d04de2 sub sp, sp, #0x14
a03caacc 001094e5 ldr r1, [r4]
a03caad0 0050a0e1 mov r5, r0
a03caad4 0270a0e1 mov r7, r2
a03caad8 010054e1 cmp r4, r1
a03caadc 783041e2 sub r3, r1, #0x78
a03caae0 0400001a bne #0xa03caaf8
a03caae4 120000ea b #0xa03cab34
a03caae8 783093e5 ldr r3, [r3, #0x78]
a03caaec 030054e1 cmp r4, r3
a03caaf0 783043e2 sub r3, r3, #0x78
a03caaf4 0e00000a beq #0xa03cab34
a03caaf8 002093e5 ldr r2, [r3]
a03caafc 020055e1 cmp r5, r2
a03cab00 f8ffff1a bne #0xa03caae8
a03cab04 042093e5 ldr r2, [r3, #4]
a03cab08 020056e1 cmp r6, r2
a03cab0c f5ffff1a bne #0xa03caae8
a03cab10 000053e3 cmp r3, #0
a03cab14 0600000a beq #0xa03cab34
a03cab18 28030ee3 movw r0, #0xe328
a03cab1c 0510a0e1 mov r1, r5
a03cab20 60004ae3 movt r0, #0xa060
a03cab24 7071fbeb bl #0xa02a70ec
a03cab28 0100a0e3 mov r0, #1
a03cab2c 14d08de2 add sp, sp, #0x14
a03cab30 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a03cab34 b03205e3 movw r3, #0x52b0
a03cab38 44314ae3 movt r3, #0xa144
a03cab3c 340093e5 ldr r0, [r3, #0x34]
a03cab40 e70f80e2 add r0, r0, #0x39c
a03cab44 e30900eb bl #0xa03cd2d8
a03cab48 0010a0e3 mov r1, #0
a03cab4c e72fa0e3 mov r2, #0x39c
a03cab50 0090a0e1 mov sb, r0
a03cab54 a4b804fa blx #0xa04f8dec
a03cab58 3c309de5 ldr r3, [sp, #0x3c]
a03cab5c 600089e8 stm sb, {r5, r6}
a03cab60 807089e5 str r7, [sb, #0x80]
a03cab64 443389e5 str r3, [sb, #0x344]
a03cab68 38309de5 ldr r3, [sp, #0x38]
a03cab6c 003093e5 ldr r3, [r3]
a03cab70 483389e5 str r3, [sb, #0x348]
a03cab74 38309de5 ldr r3, [sp, #0x38]
a03cab78 000093e5 ldr r0, [r3]
a03cab7c 8001a0e1 lsl r0, r0, #3
a03cab80 d40900eb bl #0xa03cd2d8
a03cab84 38309de5 ldr r3, [sp, #0x38]
a03cab88 4c0389e5 str r0, [sb, #0x34c]
a03cab8c 002093e5 ldr r2, [r3]
a03cab90 041093e5 ldr r1, [r3, #4]
a03cab94 8221a0e1 lsl r2, r2, #3
a03cab98 b846fbeb bl #0xa029c680
a03cab9c 70280ae3 movw r2, #0xa870
a03caba0 080089e2 add r0, sb, #8
a03caba4 3c204ae3 movt r2, #0xa03c
a03caba8 0910a0e1 mov r1, sb
a03cabac fbf6ffeb bl #0xa03c87a0
a03cabb0 3c209de5 ldr r2, [sp, #0x3c]
a03cabb4 003094e5 ldr r3, [r4]
a03cabb8 000052e3 cmp r2, #0
a03cabbc 782089e2 add r2, sb, #0x78
a03cabc0 042083e5 str r2, [r3, #4]
a03cabc4 002084e5 str r2, [r4]
a03cabc8 783089e5 str r3, [sb, #0x78]
a03cabcc 7c4089e5 str r4, [sb, #0x7c]
a03cabd0 0200001a bne #0xa03cabe0
a03cabd4 3c009de5 ldr r0, [sp, #0x3c]
a03cabd8 14d08de2 add sp, sp, #0x14
a03cabdc f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a03cabe0 30209de5 ldr r2, [sp, #0x30]
a03cabe4 01c0a0e3 mov ip, #1
a03cabe8 843e0ae3 movw r3, #0xae84
a03cabec 00908de5 str sb, [sp]
a03cabf0 840089e2 add r0, sb, #0x84
a03cabf4 0710a0e1 mov r1, r7
a03cabf8 04208de5 str r2, [sp, #4]
a03cabfc 3c304ae3 movt r3, #0xa03c
a03cac00 34209de5 ldr r2, [sp, #0x34]
a03cac04 0cc08de5 str ip, [sp, #0xc]
a03cac08 08208de5 str r2, [sp, #8]
a03cac0c 0820a0e1 mov r2, r8
a03cac10 a9c5ffeb bl #0xa03bc2bc
a03cac14 0000a0e3 mov r0, #0
a03cac18 c3ffffea b #0xa03cab2c
