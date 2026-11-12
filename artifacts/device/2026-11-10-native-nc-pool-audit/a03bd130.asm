a03bd130 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03bd134 0060a0e1 mov r6, r0
a03bd138 0cd04de2 sub sp, sp, #0xc
a03bd13c 0140a0e1 mov r4, r1
a03bd140 04108de5 str r1, [sp, #4]
a03bd144 991000eb bl #0xa03c13b0
a03bd148 082096e5 ldr r2, [r6, #8]
a03bd14c 040052e1 cmp r2, r4
a03bd150 7a00009a bls #0xa03bd340
a03bd154 144096e5 ldr r4, [r6, #0x14]
a03bd158 0090a0e3 mov sb, #0
a03bd15c 0c5096e5 ldr r5, [r6, #0xc]
a03bd160 eebe0ee3 movw fp, #0xeeee
a03bd164 00a0a0e1 mov sl, r0
a03bd168 0980a0e1 mov r8, sb
a03bd16c ffbf4fe3 movt fp, #0xffff
a03bd170 0470a0e1 mov r7, r4
a03bd174 015085e2 add r5, r5, #1
a03bd178 150000ea b #0xa03bd1d4
a03bd17c 000055e3 cmp r5, #0
a03bd180 01504512 subne r5, r5, #1
a03bd184 0a00a0e1 mov r0, sl
a03bd188 a61000eb bl #0xa03c1428
a03bd18c 871000eb bl #0xa03c13b0
a03bd190 00a0a0e1 mov sl, r0
a03bd194 ec0e00eb bl #0xa03c0d4c
a03bd198 202096e5 ldr r2, [r6, #0x20]
a03bd19c 000052e1 cmp r2, r0
a03bd1a0 0900000a beq #0xa03bd1cc
a03bd1a4 147096e5 ldr r7, [r6, #0x14]
a03bd1a8 200086e5 str r0, [r6, #0x20]
a03bd1ac 0c5096e5 ldr r5, [r6, #0xc]
a03bd1b0 042097e5 ldr r2, [r7, #4]
a03bd1b4 004097e5 ldr r4, [r7]
a03bd1b8 015085e2 add r5, r5, #1
a03bd1bc 0b0052e1 cmp r2, fp
a03bd1c0 1f00000a beq #0xa03bd244
a03bd1c4 0470a0e1 mov r7, r4
a03bd1c8 144086e5 str r4, [r6, #0x14]
a03bd1cc 000055e3 cmp r5, #0
a03bd1d0 2700000a beq #0xa03bd274
a03bd1d4 042094e5 ldr r2, [r4, #4]
a03bd1d8 0b0052e1 cmp r2, fp
a03bd1dc 00409415 ldrne r4, [r4]
a03bd1e0 e5ffff1a bne #0xa03bd17c
a03bd1e4 002094e5 ldr r2, [r4]
a03bd1e8 019029e2 eor sb, sb, #1
a03bd1ec 04309de5 ldr r3, [sp, #4]
a03bd1f0 070054e1 cmp r4, r7
a03bd1f4 0090a003 moveq sb, #0
a03bd1f8 01900912 andne sb, sb, #1
a03bd1fc 000059e3 cmp sb, #0
a03bd200 028064e0 rsb r8, r4, r2
a03bd204 0470a011 movne r7, r4
a03bd208 088048e2 sub r8, r8, #8
a03bd20c 080053e1 cmp r3, r8
a03bd210 1700009a bls #0xa03bd274
a03bd214 041092e5 ldr r1, [r2, #4]
a03bd218 0b0051e1 cmp r1, fp
a03bd21c 2700000a beq #0xa03bd2c0
a03bd220 000055e3 cmp r5, #0
a03bd224 004092e5 ldr r4, [r2]
a03bd228 0190a003 moveq sb, #1
a03bd22c 0580a001 moveq r8, r5
a03bd230 d3ffff0a beq #0xa03bd184
a03bd234 015045e2 sub r5, r5, #1
a03bd238 0190a0e3 mov sb, #1
a03bd23c 0080a0e3 mov r8, #0
a03bd240 cdffffea b #0xa03bd17c
a03bd244 04309de5 ldr r3, [sp, #4]
a03bd248 048067e0 rsb r8, r7, r4
a03bd24c 088048e2 sub r8, r8, #8
a03bd250 080053e1 cmp r3, r8
a03bd254 0300009a bls #0xa03bd268
a03bd258 042094e5 ldr r2, [r4, #4]
a03bd25c 0b0052e1 cmp r2, fp
a03bd260 00409415 ldrne r4, [r4]
a03bd264 d6ffff1a bne #0xa03bd1c4
a03bd268 000055e3 cmp r5, #0
a03bd26c 0740a0e1 mov r4, r7
a03bd270 d7ffff1a bne #0xa03bd1d4
a03bd274 000058e3 cmp r8, #0
a03bd278 2a00000a beq #0xa03bd328
a03bd27c 04309de5 ldr r3, [sp, #4]
a03bd280 082063e0 rsb r2, r3, r8
a03bd284 130052e3 cmp r2, #0x13
a03bd288 1900008a bhi #0xa03bd2f4
a03bd28c 046084e5 str r6, [r4, #4]
a03bd290 070054e1 cmp r4, r7
a03bd294 082096e5 ldr r2, [r6, #8]
a03bd298 0a00a0e1 mov r0, sl
a03bd29c 082042e2 sub r2, r2, #8
a03bd2a0 028068e0 rsb r8, r8, r2
a03bd2a4 088086e5 str r8, [r6, #8]
a03bd2a8 00709405 ldreq r7, [r4]
a03bd2ac 147086e5 str r7, [r6, #0x14]
a03bd2b0 5c1000eb bl #0xa03c1428
a03bd2b4 080084e2 add r0, r4, #8
a03bd2b8 0cd08de2 add sp, sp, #0xc
a03bd2bc f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03bd2c0 001092e5 ldr r1, [r2]
a03bd2c4 001084e5 str r1, [r4]
a03bd2c8 140096e5 ldr r0, [r6, #0x14]
a03bd2cc 0c1096e5 ldr r1, [r6, #0xc]
a03bd2d0 020050e1 cmp r0, r2
a03bd2d4 012041e2 sub r2, r1, #1
a03bd2d8 14408605 streq r4, [r6, #0x14]
a03bd2dc 0c2086e5 str r2, [r6, #0xc]
a03bd2e0 0190a003 moveq sb, #1
a03bd2e4 0080a003 moveq r8, #0
a03bd2e8 0190a013 movne sb, #1
a03bd2ec 0080a013 movne r8, #0
a03bd2f0 a1ffffea b #0xa03bd17c
a03bd2f4 00c094e5 ldr ip, [r4]
a03bd2f8 080083e2 add r0, r3, #8
a03bd2fc ee2e0ee3 movw r2, #0xeeee
a03bd300 001084e0 add r1, r4, r0
a03bd304 ff2f4fe3 movt r2, #0xffff
a03bd308 0380a0e1 mov r8, r3
a03bd30c 00c084e7 str ip, [r4, r0]
a03bd310 042081e5 str r2, [r1, #4]
a03bd314 0c2096e5 ldr r2, [r6, #0xc]
a03bd318 012082e2 add r2, r2, #1
a03bd31c 0c2086e5 str r2, [r6, #0xc]
a03bd320 001084e5 str r1, [r4]
a03bd324 d8ffffea b #0xa03bd28c
a03bd328 0a00a0e1 mov r0, sl
a03bd32c 147086e5 str r7, [r6, #0x14]
a03bd330 3c1000eb bl #0xa03c1428
a03bd334 0800a0e1 mov r0, r8
a03bd338 0cd08de2 add sp, sp, #0xc
a03bd33c f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03bd340 381000eb bl #0xa03c1428
a03bd344 0000a0e3 mov r0, #0
a03bd348 daffffea b #0xa03bd2b8
