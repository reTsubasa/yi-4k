a04fb328 30b4       push     {r4, r5}
a04fb32a 41f25004   movw     r4, #0x1050
a04fb32e 0d46       mov      r5, r1
a04fb330 caf28204   movt     r4, #0xa082
a04fb334 1346       mov      r3, r2
a04fb336 0146       mov      r1, r0
a04fb338 2a46       mov      r2, r5
a04fb33a 2068       ldr      r0, [r4]
a04fb33c 30bc       pop      {r4, r5}
a04fb33e fff74fbf   b.w      #0xa04fb1e0
a04fb342 00bf       nop      
a04fb344 0000       movs     r0, r0
a04fb346 0000       movs     r0, r0
a04fb348 2de9f04f   push.w   {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04fb34c 0c46       mov      r4, r1
a04fb34e 2ded048b   vpush    {d8, d9}
a04fb352 1546       mov      r5, r2
a04fb354 bfb0       sub      sp, #0xfc
a04fb356 0491       str      r1, [sp, #0x10]
a04fb358 0993       str      r3, [sp, #0x24]
a04fb35a 0690       str      r0, [sp, #0x18]
a04fb35c 06f064f9   bl       #0xa0501628
a04fb360 0368       ldr      r3, [r0]
a04fb362 1846       mov      r0, r3
a04fb364 1293       str      r3, [sp, #0x48]
a04fb366 fef743fb   bl       #0xa04f99f0
a04fb36a a389       ldrh     r3, [r4, #0xc]
a04fb36c 1a06       lsls     r2, r3, #0x18
a04fb36e 1390       str      r0, [sp, #0x4c]
a04fb370 04d5       bpl      #0xa04fb37c
a04fb372 049b       ldr      r3, [sp, #0x10]
a04fb374 1b69       ldr      r3, [r3, #0x10]
a04fb376 002b       cmp      r3, #0
a04fb378 01f0cc80   beq.w    #0xa04fc514
a04fb37c 9fed9e8b   vldr     d8, [pc, #0x278]
a04fb380 0df1b80a   add.w    sl, sp, #0xb8
a04fb384 40f27c71   movw     r1, #0x77c
a04fb388 46f26760   movw     r0, #0x6667
a04fb38c d346       mov      fp, sl
a04fb38e 2f46       mov      r7, r5
a04fb390 0023       movs     r3, #0
a04fb392 caf26401   movt     r1, #0xa064
a04fb396 c6f26660   movt     r0, #0x6666
a04fb39a 0f93       str      r3, [sp, #0x3c]
a04fb39c 1193       str      r3, [sp, #0x44]
a04fb39e 1693       str      r3, [sp, #0x58]
a04fb3a0 0793       str      r3, [sp, #0x1c]
a04fb3a2 1091       str      r1, [sp, #0x40]
a04fb3a4 1790       str      r0, [sp, #0x5c]
a04fb3a6 2393       str      r3, [sp, #0x8c]
