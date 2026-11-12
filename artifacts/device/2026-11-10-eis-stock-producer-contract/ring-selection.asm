a0312788: 012783e2 add r2, r3, #0x40000
a031278c: 56ba83e2 add fp, r3, #0x56000
a0312790: 8a28d2e5 ldrb r2, [r2, #0x88a]
a0312794: 9213dbe5 ldrb r1, [fp, #0x392]
a0312798: 380093e5 ldr r0, [r3, #0x38]
a031279c: 010052e1 cmp r2, r1
a03127a0: 7000ef86 uxtbhi r0, r0
a03127a4: 00108180 addhi r1, r1, r0
a03127a8: 011062e0 rsb r1, r2, r1
a03127ac: 922d05e3 movw r2, #0x5d92
a03127b0: 032040e3 movt r2, #3
a03127b4: 28108de5 str r1, [sp, #0x28]
a03127b8: 022081e0 add r2, r1, r2
a03127bc: 022183e0 add r2, r3, r2, lsl #2
a03127c0: 046092e5 ldr r6, [r2, #4]
a03127c4: 0d7a86e2 add r7, r6, #0xd000
a03127c8: 3a6b86e2 add r6, r6, #0xe800
a03127cc: 607087e2 add r7, r7, #0x60
a03127d0: 606086e2 add r6, r6, #0x60
a03127d4: bbffffea b #0xa03126c8
