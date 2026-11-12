a018ae80 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a018ae84 8c4703e3 movw r4, #0x378c
a018ae88 05414ae3 movt r4, #0xa105
a018ae8c 04560ee3 movw r5, #0xe604
a018ae90 14d04de2 sub sp, sp, #0x14
a018ae94 04514ae3 movt r5, #0xa104
a018ae98 000094e5 ldr r0, [r4]
a018ae9c 0060a0e3 mov r6, #0
a018aea0 bd440beb bl #0xa045c19c
a018aea4 000095e5 ldr r0, [r5]
a018aea8 006084e5 str r6, [r4]
a018aeac 060050e1 cmp r0, r6
a018aeb0 0100000a beq #0xa018aebc
a018aeb4 b2540beb bl #0xa0460184
a018aeb8 006085e5 str r6, [r5]
a018aebc c44703e3 movw r4, #0x37c4
a018aec0 05414ae3 movt r4, #0xa105
a018aec4 000094e5 ldr r0, [r4]
a018aec8 000050e3 cmp r0, #0
a018aecc 0200000a beq #0xa018aedc
a018aed0 ab540beb bl #0xa0460184
a018aed4 0030a0e3 mov r3, #0
a018aed8 003084e5 str r3, [r4]
a018aedc cc450ee3 movw r4, #0xe5cc
a018aee0 986703e3 movw r6, #0x3798
a018aee4 04414ae3 movt r4, #0xa104
a018aee8 05614ae3 movt r6, #0xa105
a018aeec b08703e3 movw r8, #0x37b0
a018aef0 04a0a0e1 mov sl, r4
a018aef4 0470a0e1 mov r7, r4
a018aef8 06b0a0e1 mov fp, r6
a018aefc 0690a0e1 mov sb, r6
a018af00 05814ae3 movt r8, #0xa105
a018af04 0050a0e3 mov r5, #0
a018af08 05309ae7 ldr r3, [sl, r5]
a018af0c 04008de2 add r0, sp, #4
a018af10 000053e3 cmp r3, #0
a018af14 0900000a beq #0xa018af40
a018af18 042097e5 ldr r2, [r7, #4]
a018af1c 000052e3 cmp r2, #0
a018af20 0600000a beq #0xa018af40
a018af24 081097e5 ldr r1, [r7, #8]
a018af28 000051e3 cmp r1, #0
a018af2c 0300000a beq #0xa018af40
a018af30 0c108de5 str r1, [sp, #0xc]
a018af34 04308de5 str r3, [sp, #4]
a018af38 08208de5 str r2, [sp, #8]
a018af3c 532204eb bl #0xa0293890
a018af40 0030d8e5 ldrb r3, [r8]
a018af44 0c7087e2 add r7, r7, #0xc
a018af48 020013e3 tst r3, #2
a018af4c 0d00000a beq #0xa018af88
a018af50 05309be7 ldr r3, [fp, r5]
a018af54 04008de2 add r0, sp, #4
a018af58 000053e3 cmp r3, #0
a018af5c 0900000a beq #0xa018af88
a018af60 042099e5 ldr r2, [sb, #4]
a018af64 000052e3 cmp r2, #0
a018af68 0600000a beq #0xa018af88
a018af6c 081099e5 ldr r1, [sb, #8]
a018af70 000051e3 cmp r1, #0
a018af74 0300000a beq #0xa018af88
a018af78 0c108de5 str r1, [sp, #0xc]
a018af7c 04308de5 str r3, [sp, #4]
a018af80 08208de5 str r2, [sp, #8]
a018af84 412204eb bl #0xa0293890
a018af88 0c5085e2 add r5, r5, #0xc
a018af8c 0c9089e2 add sb, sb, #0xc
a018af90 180055e3 cmp r5, #0x18
a018af94 dbffff1a bne #0xa018af08
a018af98 0030d8e5 ldrb r3, [r8]
a018af9c 020013e3 tst r3, #2
a018afa0 5f00000a beq #0xa018b124
a018afa4 00009ae5 ldr r0, [sl]
a018afa8 000050e3 cmp r0, #0
a018afac 0000000a beq #0xa018afb4
a018afb0 c11a04eb bl #0xa0291abc
a018afb4 58729fe5 ldr r7, [pc, #0x258]
a018afb8 989703e3 movw sb, #0x3798
a018afbc 05914ae3 movt sb, #0xa105
a018afc0 0020a0e3 mov r2, #0
a018afc4 00208ae5 str r2, [sl]
a018afc8 185047e2 sub r5, r7, #0x18
a018afcc 00208be5 str r2, [fp]
a018afd0 0c208ae5 str r2, [sl, #0xc]
a018afd4 0c208be5 str r2, [fp, #0xc]
a018afd8 040095e5 ldr r0, [r5, #4]
a018afdc 000050e3 cmp r0, #0
a018afe0 0200000a beq #0xa018aff0
a018afe4 c81604eb bl #0xa0290b0c
a018afe8 0030a0e3 mov r3, #0
a018afec 043085e5 str r3, [r5, #4]
a018aff0 040099e5 ldr r0, [sb, #4]
a018aff4 0c5085e2 add r5, r5, #0xc
a018aff8 000050e3 cmp r0, #0
a018affc 0200000a beq #0xa018b00c
a018b000 c11604eb bl #0xa0290b0c
a018b004 0030a0e3 mov r3, #0
a018b008 043089e5 str r3, [sb, #4]
a018b00c 070055e1 cmp r5, r7
a018b010 0c9089e2 add sb, sb, #0xc
a018b014 efffff1a bne #0xa018afd8
a018b018 0050a0e3 mov r5, #0
a018b01c 080094e5 ldr r0, [r4, #8]
a018b020 000050e3 cmp r0, #0
a018b024 0100000a beq #0xa018b030
a018b028 d02004eb bl #0xa0293370
a018b02c 085084e5 str r5, [r4, #8]
a018b030 080096e5 ldr r0, [r6, #8]
a018b034 0c4084e2 add r4, r4, #0xc
a018b038 000050e3 cmp r0, #0
a018b03c 0100000a beq #0xa018b048
a018b040 ca2004eb bl #0xa0293370
a018b044 085086e5 str r5, [r6, #8]
a018b048 070054e1 cmp r4, r7
a018b04c 0c6086e2 add r6, r6, #0xc
a018b050 f1ffff1a bne #0xa018b01c
a018b054 34360ee3 movw r3, #0xe634
a018b058 0040a0e3 mov r4, #0
a018b05c 04314ae3 movt r3, #0xa104
a018b060 000093e5 ldr r0, [r3]
a018b064 aac508eb bl #0xa03bc714
a018b068 741603e3 movw r1, #0x3674
a018b06c 20260ee3 movw r2, #0xe620
a018b070 05114ae3 movt r1, #0xa105
a018b074 703703e3 movw r3, #0x3770
a018b078 04214ae3 movt r2, #0xa104
a018b07c 05314ae3 movt r3, #0xa105
a018b080 000091e5 ldr r0, [r1]
a018b084 004082e5 str r4, [r2]
a018b088 004083e5 str r4, [r3]
a018b08c a0c508eb bl #0xa03bc714
a018b090 24160ee3 movw r1, #0xe624
a018b094 6c2703e3 movw r2, #0x376c
a018b098 04114ae3 movt r1, #0xa104
a018b09c ec350ee3 movw r3, #0xe5ec
a018b0a0 05214ae3 movt r2, #0xa105
a018b0a4 04314ae3 movt r3, #0xa104
a018b0a8 000091e5 ldr r0, [r1]
a018b0ac 004082e5 str r4, [r2]
a018b0b0 004083e5 str r4, [r3]
a018b0b4 96c508eb bl #0xa03bc714
a018b0b8 0020d8e5 ldrb r2, [r8]
a018b0bc 44360ee3 movw r3, #0xe644
a018b0c0 04314ae3 movt r3, #0xa104
a018b0c4 004083e5 str r4, [r3]
a018b0c8 020012e3 tst r2, #2
a018b0cc 4800001a bne #0xa018b1f4
a018b0d0 803603e3 movw r3, #0x3680
a018b0d4 0040a0e3 mov r4, #0
a018b0d8 05314ae3 movt r3, #0xa105
a018b0dc 000093e5 ldr r0, [r3]
a018b0e0 8bc508eb bl #0xa03bc714
a018b0e4 0020d8e5 ldrb r2, [r8]
a018b0e8 e4350ee3 movw r3, #0xe5e4
a018b0ec 04314ae3 movt r3, #0xa104
a018b0f0 004083e5 str r4, [r3]
a018b0f4 020012e3 tst r2, #2
a018b0f8 0600000a beq #0xa018b118
a018b0fc e8350ee3 movw r3, #0xe5e8
a018b100 04314ae3 movt r3, #0xa104
a018b104 000093e5 ldr r0, [r3]
a018b108 81c508eb bl #0xa03bc714
a018b10c 843703e3 movw r3, #0x3784
a018b110 05314ae3 movt r3, #0xa105
a018b114 004083e5 str r4, [r3]
a018b118 0000a0e3 mov r0, #0
a018b11c 14d08de2 add sp, sp, #0x14
a018b120 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a018b124 015013e2 ands r5, r3, #1
a018b128 1300001a bne #0xa018b17c
a018b12c e0609fe5 ldr r6, [pc, #0xe0]
a018b130 000094e5 ldr r0, [r4]
a018b134 000050e3 cmp r0, #0
a018b138 0100000a beq #0xa018b144
a018b13c 5e1a04eb bl #0xa0291abc
a018b140 005084e5 str r5, [r4]
a018b144 040094e5 ldr r0, [r4, #4]
a018b148 000050e3 cmp r0, #0
a018b14c 0100000a beq #0xa018b158
a018b150 6d1604eb bl #0xa0290b0c
a018b154 045084e5 str r5, [r4, #4]
a018b158 080094e5 ldr r0, [r4, #8]
a018b15c 000050e3 cmp r0, #0
a018b160 0100000a beq #0xa018b16c
a018b164 812004eb bl #0xa0293370
a018b168 085084e5 str r5, [r4, #8]
a018b16c 0c4084e2 add r4, r4, #0xc
a018b170 060054e1 cmp r4, r6
a018b174 edffff1a bne #0xa018b130
a018b178 b5ffffea b #0xa018b054
a018b17c 00009ae5 ldr r0, [sl]
a018b180 000050e3 cmp r0, #0
a018b184 0000000a beq #0xa018b18c
a018b188 4b1a04eb bl #0xa0291abc
a018b18c 04009ae5 ldr r0, [sl, #4]
a018b190 0030a0e3 mov r3, #0
a018b194 00308ae5 str r3, [sl]
a018b198 0c308ae5 str r3, [sl, #0xc]
a018b19c 030050e1 cmp r0, r3
a018b1a0 0000000a beq #0xa018b1a8
a018b1a4 581604eb bl #0xa0290b0c
a018b1a8 08009ae5 ldr r0, [sl, #8]
a018b1ac 0050a0e3 mov r5, #0
a018b1b0 cc450ee3 movw r4, #0xe5cc
a018b1b4 04508ae5 str r5, [sl, #4]
a018b1b8 04414ae3 movt r4, #0xa104
a018b1bc 10508ae5 str r5, [sl, #0x10]
a018b1c0 050050e1 cmp r0, r5
a018b1c4 0100000a beq #0xa018b1d0
a018b1c8 682004eb bl #0xa0293370
a018b1cc 085084e5 str r5, [r4, #8]
a018b1d0 14009ae5 ldr r0, [sl, #0x14]
a018b1d4 cc450ee3 movw r4, #0xe5cc
a018b1d8 04414ae3 movt r4, #0xa104
a018b1dc 000050e3 cmp r0, #0
a018b1e0 9bffff0a beq #0xa018b054
a018b1e4 612004eb bl #0xa0293370
a018b1e8 0030a0e3 mov r3, #0
a018b1ec 143084e5 str r3, [r4, #0x14]
a018b1f0 97ffffea b #0xa018b054
a018b1f4 b43703e3 movw r3, #0x37b4
a018b1f8 05314ae3 movt r3, #0xa105
a018b1fc 000093e5 ldr r0, [r3]
a018b200 43c508eb bl #0xa03bc714
a018b204 f4350ee3 movw r3, #0xe5f4
a018b208 04314ae3 movt r3, #0xa104
a018b20c 004083e5 str r4, [r3]
a018b210 aeffffea b #0xa018b0d0
