a03c4240 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c4244 1cd04de2 sub sp, sp, #0x1c
a03c4248 58409de5 ldr r4, [sp, #0x58]
a03c424c 40709de5 ldr r7, [sp, #0x40]
a03c4250 d84054e2 subs r4, r4, #0xd8
a03c4254 44809de5 ldr r8, [sp, #0x44]
a03c4258 0140a013 movne r4, #1
a03c425c 48c09de5 ldr ip, [sp, #0x48]
a03c4260 000050e3 cmp r0, #0
a03c4264 01408403 orreq r4, r4, #1
a03c4268 4cb09de5 ldr fp, [sp, #0x4c]
a03c426c 000054e3 cmp r4, #0
a03c4270 50a09de5 ldr sl, [sp, #0x50]
a03c4274 54909de5 ldr sb, [sp, #0x54]
a03c4278 0200000a beq #0xa03c4288
a03c427c 0e00a0e3 mov r0, #0xe
a03c4280 1cd08de2 add sp, sp, #0x1c
a03c4284 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c4288 0c108de5 str r1, [sp, #0xc]
a03c428c 801706e3 movw r1, #0x6780
a03c4290 79114ae3 movt r1, #0xa179
a03c4294 04c08de5 str ip, [sp, #4]
a03c4298 08208de5 str r2, [sp, #8]
a03c429c 0060a0e1 mov r6, r0
a03c42a0 10308de5 str r3, [sp, #0x10]
a03c42a4 00108de5 str r1, [sp]
a03c42a8 14108de5 str r1, [sp, #0x14]
a03c42ac 3ff4ffeb bl #0xa03c13b0
a03c42b0 00109de5 ldr r1, [sp]
a03c42b4 003091e5 ldr r3, [r1]
a03c42b8 013083e2 add r3, r3, #1
a03c42bc 003081e5 str r3, [r1]
a03c42c0 58f4ffeb bl #0xa03c1428
a03c42c4 fc2206e3 movw r2, #0x62fc
a03c42c8 043306e3 movw r3, #0x6304
a03c42cc 79214ae3 movt r2, #0xa179
a03c42d0 79314ae3 movt r3, #0xa179
a03c42d4 00e092e5 ldr lr, [r2]
a03c42d8 010048e2 sub r0, r8, #1
a03c42dc 005093e5 ldr r5, [r3]
a03c42e0 000087e0 add r0, r7, r0
a03c42e4 02109de8 ldm sp, {r1, ip}
a03c42e8 00005ee3 cmp lr, #0
a03c42ec 1400000a beq #0xa03c4344
a03c42f0 050056e1 cmp r6, r5
a03c42f4 0430a011 movne r3, r4
a03c42f8 0200001a bne #0xa03c4308
a03c42fc 500000ea b #0xa03c4444
a03c4300 050056e1 cmp r6, r5
a03c4304 4e00000a beq #0xa03c4444
a03c4308 0c2095e5 ldr r2, [r5, #0xc]
a03c430c 013083e2 add r3, r3, #1
a03c4310 020057e1 cmp r7, r2
a03c4314 0200003a blo #0xa03c4324
a03c4318 104095e5 ldr r4, [r5, #0x10]
a03c431c 040057e1 cmp r7, r4
a03c4320 3b00003a blo #0xa03c4414
a03c4324 020050e1 cmp r0, r2
a03c4328 0200003a blo #0xa03c4338
a03c432c 102095e5 ldr r2, [r5, #0x10]
a03c4330 020050e1 cmp r0, r2
a03c4334 3600003a blo #0xa03c4414
a03c4338 0e0053e1 cmp r3, lr
a03c433c 8c5095e5 ldr r5, [r5, #0x8c]
a03c4340 eeffff1a bne #0xa03c4300
a03c4344 02108de8 stm sp, {r1, ip}
a03c4348 18f4ffeb bl #0xa03c13b0
a03c434c 00109de5 ldr r1, [sp]
a03c4350 003091e5 ldr r3, [r1]
a03c4354 013043e2 sub r3, r3, #1
a03c4358 003081e5 str r3, [r1]
a03c435c 31f4ffeb bl #0xa03c1428
a03c4360 dff4ffeb bl #0xa03c16e4
a03c4364 050056e1 cmp r6, r5
a03c4368 c3ffff0a beq #0xa03c427c
a03c436c 08309de5 ldr r3, [sp, #8]
a03c4370 000053e3 cmp r3, #0
a03c4374 00005713 cmpne r7, #0
a03c4378 2f00000a beq #0xa03c443c
a03c437c c70058e3 cmp r8, #0xc7
a03c4380 04c09de5 ldr ip, [sp, #4]
a03c4384 0500a093 movls r0, #5
a03c4388 bcffff9a bls #0xa03c4280
a03c438c ff005ce3 cmp ip, #0xff
a03c4390 0f00a083 movhi r0, #0xf
a03c4394 b9ffff8a bhi #0xa03c4280
a03c4398 0b005ce1 cmp ip, fp
a03c439c 1800a033 movlo r0, #0x18
a03c43a0 b6ffff3a blo #0xa03c4280
a03c43a4 010059e3 cmp sb, #1
a03c43a8 1000a083 movhi r0, #0x10
a03c43ac b3ffff8a bhi #0xa03c4280
a03c43b0 00c08de5 str ip, [sp]
a03c43b4 64f2ffeb bl #0xa03c0d4c
a03c43b8 343c06e3 movw r3, #0x6c34
a03c43bc 00c09de5 ldr ip, [sp]
a03c43c0 79314ae3 movt r3, #0xa179
a03c43c4 000053e1 cmp r3, r0
a03c43c8 2d00000a beq #0xa03c4484
a03c43cc 00c08de5 str ip, [sp]
a03c43d0 4cf2ffeb bl #0xa03c0d08
a03c43d4 000050e3 cmp r0, #0
a03c43d8 00c09de5 ldr ip, [sp]
a03c43dc 2100001a bne #0xa03c4468
a03c43e0 40708de5 str r7, [sp, #0x40]
a03c43e4 0600a0e1 mov r0, r6
a03c43e8 44808de5 str r8, [sp, #0x44]
a03c43ec 0c109de5 ldr r1, [sp, #0xc]
a03c43f0 48c08de5 str ip, [sp, #0x48]
a03c43f4 08209de5 ldr r2, [sp, #8]
a03c43f8 4cb08de5 str fp, [sp, #0x4c]
a03c43fc 10309de5 ldr r3, [sp, #0x10]
a03c4400 50a08de5 str sl, [sp, #0x50]
a03c4404 54908de5 str sb, [sp, #0x54]
a03c4408 1cd08de2 add sp, sp, #0x1c
a03c440c f04fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c4410 1eeeffea b #0xa03bfc90
a03c4414 00108de5 str r1, [sp]
a03c4418 e4f3ffeb bl #0xa03c13b0
a03c441c 00109de5 ldr r1, [sp]
a03c4420 003091e5 ldr r3, [r1]
a03c4424 013043e2 sub r3, r3, #1
a03c4428 003081e5 str r3, [r1]
a03c442c fdf3ffeb bl #0xa03c1428
a03c4430 abf4ffeb bl #0xa03c16e4
a03c4434 050056e1 cmp r6, r5
a03c4438 8fffff0a beq #0xa03c427c
a03c443c 0300a0e3 mov r0, #3
a03c4440 8effffea b #0xa03c4280
a03c4444 00108de5 str r1, [sp]
a03c4448 d8f3ffeb bl #0xa03c13b0
a03c444c 00109de5 ldr r1, [sp]
a03c4450 003091e5 ldr r3, [r1]
a03c4454 013043e2 sub r3, r3, #1
a03c4458 003081e5 str r3, [r1]
a03c445c f1f3ffeb bl #0xa03c1428
a03c4460 9ff4ffeb bl #0xa03c16e4
a03c4464 84ffffea b #0xa03c427c
a03c4468 00c08de5 str ip, [sp]
a03c446c 25f2ffeb bl #0xa03c0d08
a03c4470 ef300fe3 movw r3, #0xf0ef
a03c4474 00c09de5 ldr ip, [sp]
a03c4478 f0304fe3 movt r3, #0xf0f0
a03c447c 030050e1 cmp r0, r3
a03c4480 d6ffff8a bhi #0xa03c43e0
a03c4484 1300a0e3 mov r0, #0x13
a03c4488 7cffffea b #0xa03c4280
