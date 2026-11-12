a04a43fc 70402de9 push {r4, r5, r6, lr}
a04a4400 104f11ee mrc p15, #0, r4, c1, c0, #0
a04a4404 040014e3 tst r4, #4
a04a4408 015004e2 and r5, r4, #1
a04a440c 2400001a bne #0xa04a44a4
a04a4410 40410ce3 movw r4, #0xc140
a04a4414 78404ae3 movt r4, #0xa078
a04a4418 003094e5 ldr r3, [r4]
a04a441c 010053e3 cmp r3, #1
a04a4420 fcffff1a bne #0xa04a4418
a04a4424 000055e3 cmp r5, #0
a04a4428 1700001a bne #0xa04a448c
a04a442c 155f07ee mcr p15, #0, r5, c7, c5, #0
a04a4430 155f08ee mcr p15, #0, r5, c8, c5, #0
a04a4434 aaf6ffeb bl #0xa04a1ee4
a04a4438 165f08ee mcr p15, #0, r5, c8, c6, #0
a04a443c 70209fe5 ldr r2, [pc, #0x70]
a04a4440 182f07ee mcr p15, #0, r2, c7, c8, #0
a04a4444 143f17ee mrc p15, #0, r3, c7, c4, #0
a04a4448 020013e3 tst r3, #2
a04a444c 2338a011 lsrne r3, r3, #0x10
a04a4450 7220ff16 uxthne r2, r2
a04a4454 0338a011 lslne r3, r3, #0x10
a04a4458 ff3ec303 biceq r3, r3, #0xff0
a04a445c 0f30c303 biceq r3, r3, #0xf
a04a4460 02308311 orrne r3, r3, r2
a04a4464 103f02ee mcr p15, #0, r3, c2, c0, #0
a04a4468 000055e3 cmp r5, #0
a04a446c 0130a003 moveq r3, #1
a04a4470 3130a013 movne r3, #0x31
a04a4474 103f03ee mcr p15, #0, r3, c3, c0, #0
a04a4478 4ff07ff5 dsb sy
a04a447c 6ff07ff5 isb sy
a04a4480 0230a0e3 mov r3, #2
a04a4484 003084e5 str r3, [r4]
a04a4488 7080bde8 pop {r4, r5, r6, pc}
a04a448c 0060a0e3 mov r6, #0
a04a4490 156f07ee mcr p15, #0, r6, c7, c5, #0
a04a4494 156f08ee mcr p15, #0, r6, c8, c5, #0
a04a4498 9ff6ffeb bl #0xa04a1f1c
a04a449c 166f08ee mcr p15, #0, r6, c8, c6, #0
a04a44a0 e5ffffea b #0xa04a443c
a04a44a4 9cf6ffeb bl #0xa04a1f1c
a04a44a8 1f41c2e7 bfc r4, #2, #1
a04a44ac 104f01ee mcr p15, #0, r4, c1, c0, #0
a04a44b0 d6ffffea b #0xa04a4410
