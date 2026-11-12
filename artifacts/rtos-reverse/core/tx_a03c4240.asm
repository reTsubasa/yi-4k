a03c4240 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c4244 sub      sp, sp, #0x1c
a03c4248 ldr      r4, [sp, #0x58]
a03c424c ldr      r7, [sp, #0x40]
a03c4250 subs     r4, r4, #0xd8
a03c4254 ldr      r8, [sp, #0x44]
a03c4258 movne    r4, #1
a03c425c ldr      ip, [sp, #0x48]
a03c4260 cmp      r0, #0
a03c4264 orreq    r4, r4, #1
a03c4268 ldr      fp, [sp, #0x4c]
a03c426c cmp      r4, #0
a03c4270 ldr      sl, [sp, #0x50]
a03c4274 ldr      sb, [sp, #0x54]
a03c4278 beq      #0xa03c4288
a03c427c mov      r0, #0xe
a03c4280 add      sp, sp, #0x1c
a03c4284 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c4288 str      r1, [sp, #0xc]
a03c428c movw     r1, #0x6780
a03c4290 movt     r1, #0xa179
a03c4294 str      ip, [sp, #4]
a03c4298 str      r2, [sp, #8]
a03c429c mov      r6, r0
a03c42a0 str      r3, [sp, #0x10]
a03c42a4 str      r1, [sp]
a03c42a8 str      r1, [sp, #0x14]
a03c42ac bl       #0xa03c13b0
a03c42b0 ldr      r1, [sp]
a03c42b4 ldr      r3, [r1]
a03c42b8 add      r3, r3, #1
a03c42bc str      r3, [r1]
a03c42c0 bl       #0xa03c1428
a03c42c4 movw     r2, #0x62fc
a03c42c8 movw     r3, #0x6304
a03c42cc movt     r2, #0xa179
a03c42d0 movt     r3, #0xa179
a03c42d4 ldr      lr, [r2]
a03c42d8 sub      r0, r8, #1
a03c42dc ldr      r5, [r3]
a03c42e0 add      r0, r7, r0
a03c42e4 ldm      sp, {r1, ip}
a03c42e8 cmp      lr, #0
a03c42ec beq      #0xa03c4344
a03c42f0 cmp      r6, r5
a03c42f4 movne    r3, r4
a03c42f8 bne      #0xa03c4308
a03c42fc b        #0xa03c4444
a03c4300 cmp      r6, r5
a03c4304 beq      #0xa03c4444
a03c4308 ldr      r2, [r5, #0xc]
a03c430c add      r3, r3, #1
a03c4310 cmp      r7, r2
a03c4314 blo      #0xa03c4324
a03c4318 ldr      r4, [r5, #0x10]
a03c431c cmp      r7, r4
a03c4320 blo      #0xa03c4414
a03c4324 cmp      r0, r2
a03c4328 blo      #0xa03c4338
a03c432c ldr      r2, [r5, #0x10]
a03c4330 cmp      r0, r2
a03c4334 blo      #0xa03c4414
a03c4338 cmp      r3, lr
a03c433c ldr      r5, [r5, #0x8c]
a03c4340 bne      #0xa03c4300
a03c4344 stm      sp, {r1, ip}
a03c4348 bl       #0xa03c13b0
a03c434c ldr      r1, [sp]
a03c4350 ldr      r3, [r1]
a03c4354 sub      r3, r3, #1
a03c4358 str      r3, [r1]
a03c435c bl       #0xa03c1428
a03c4360 bl       #0xa03c16e4
a03c4364 cmp      r6, r5
a03c4368 beq      #0xa03c427c
a03c436c ldr      r3, [sp, #8]
a03c4370 cmp      r3, #0
a03c4374 cmpne    r7, #0
a03c4378 beq      #0xa03c443c
a03c437c cmp      r8, #0xc7
a03c4380 ldr      ip, [sp, #4]
a03c4384 movls    r0, #5
a03c4388 bls      #0xa03c4280
a03c438c cmp      ip, #0xff
a03c4390 movhi    r0, #0xf
a03c4394 bhi      #0xa03c4280
a03c4398 cmp      ip, fp
a03c439c movlo    r0, #0x18
a03c43a0 blo      #0xa03c4280
a03c43a4 cmp      sb, #1
a03c43a8 movhi    r0, #0x10
a03c43ac bhi      #0xa03c4280
a03c43b0 str      ip, [sp]
a03c43b4 bl       #0xa03c0d4c
a03c43b8 movw     r3, #0x6c34
a03c43bc ldr      ip, [sp]
a03c43c0 movt     r3, #0xa179
a03c43c4 cmp      r3, r0
a03c43c8 beq      #0xa03c4484
a03c43cc str      ip, [sp]
a03c43d0 bl       #0xa03c0d08
a03c43d4 cmp      r0, #0
a03c43d8 ldr      ip, [sp]
a03c43dc bne      #0xa03c4468
a03c43e0 str      r7, [sp, #0x40]
a03c43e4 mov      r0, r6
a03c43e8 str      r8, [sp, #0x44]
a03c43ec ldr      r1, [sp, #0xc]
a03c43f0 str      ip, [sp, #0x48]
a03c43f4 ldr      r2, [sp, #8]
a03c43f8 str      fp, [sp, #0x4c]
a03c43fc ldr      r3, [sp, #0x10]
a03c4400 str      sl, [sp, #0x50]
a03c4404 str      sb, [sp, #0x54]
a03c4408 add      sp, sp, #0x1c
a03c440c pop      {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c4410 b        #0xa03bfc90
a03c4414 str      r1, [sp]
a03c4418 bl       #0xa03c13b0
a03c441c ldr      r1, [sp]
a03c4420 ldr      r3, [r1]
a03c4424 sub      r3, r3, #1
a03c4428 str      r3, [r1]
a03c442c bl       #0xa03c1428
a03c4430 bl       #0xa03c16e4
a03c4434 cmp      r6, r5
a03c4438 beq      #0xa03c427c
a03c443c mov      r0, #3
a03c4440 b        #0xa03c4280
a03c4444 str      r1, [sp]
a03c4448 bl       #0xa03c13b0
a03c444c ldr      r1, [sp]
a03c4450 ldr      r3, [r1]
a03c4454 sub      r3, r3, #1
a03c4458 str      r3, [r1]
a03c445c bl       #0xa03c1428
a03c4460 bl       #0xa03c16e4
a03c4464 b        #0xa03c427c
a03c4468 str      ip, [sp]
a03c446c bl       #0xa03c0d08
a03c4470 movw     r3, #0xf0ef
a03c4474 ldr      ip, [sp]
a03c4478 movt     r3, #0xf0f0
a03c447c cmp      r0, r3
a03c4480 bhi      #0xa03c43e0
a03c4484 mov      r0, #0x13
a03c4488 b        #0xa03c4280
