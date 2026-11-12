a04a41e8 f84f2de9 push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04a41ec 0090a0e1 mov sb, r0
a04a41f0 108f11ee mrc p15, #0, r8, c1, c0, #0
a04a41f4 0010a0e3 mov r1, #0
a04a41f8 0129a0e3 mov r2, #0x4000
a04a41fc f4019fe5 ldr r0, [pc, #0x1f4]
a04a4200 f05202e3 movw r5, #0x22f0
a04a4204 f85201fa blx #0xa04f8dec
a04a4208 000008e3 movw r0, #0x8000
a04a420c 0010a0e3 mov r1, #0
a04a4210 b9004ae3 movt r0, #0xa0b9
a04a4214 012aa0e3 mov r2, #0x1000
a04a4218 6f504ae3 movt r5, #0xa06f
a04a421c 08a0a0e1 mov sl, r8
a04a4220 f15201fa blx #0xa04f8dec
a04a4224 003095e5 ldr r3, [r5]
a04a4228 017008e2 and r7, r8, #1
a04a422c 000053e3 cmp r3, #0
a04a4230 0000000a beq #0xa04a4238
a04a4234 33ff2fe1 blx r3
a04a4238 f4600ce3 movw r6, #0xc0f4
a04a423c 044095e5 ldr r4, [r5, #4]
a04a4240 78604ae3 movt r6, #0xa078
a04a4244 0c10d5e5 ldrb r1, [r5, #0xc]
a04a4248 0520d6e5 ldrb r2, [r6, #5]
a04a424c f03202e3 movw r3, #0x22f0
a04a4250 000054e3 cmp r4, #0
a04a4254 6f304ae3 movt r3, #0xa06f
a04a4258 9122c5e7 bfi r2, r1, #5, #1
a04a425c 0520c6e5 strb r2, [r6, #5]
a04a4260 0900000a beq #0xa04a428c
a04a4264 08b093e5 ldr fp, [r3, #8]
a04a4268 00005be3 cmp fp, #0
a04a426c 060000da ble #0xa04a428c
a04a4270 0050a0e3 mov r5, #0
a04a4274 0400a0e1 mov r0, r4
a04a4278 015085e2 add r5, r5, #1
a04a427c 4bffffeb bl #0xa04a3fb0
a04a4280 0b0055e1 cmp r5, fp
a04a4284 104084e2 add r4, r4, #0x10
a04a4288 f9ffff1a bne #0xa04a4274
a04a428c fc400ce3 movw r4, #0xc0fc
a04a4290 78404ae3 movt r4, #0xa078
a04a4294 405084e2 add r5, r4, #0x40
a04a4298 0400a0e1 mov r0, r4
a04a429c 104084e2 add r4, r4, #0x10
a04a42a0 42ffffeb bl #0xa04a3fb0
a04a42a4 050054e1 cmp r4, r5
a04a42a8 faffff1a bne #0xa04a4298
a04a42ac 5ff07ff5 dmb sy
a04a42b0 40019fe5 ldr r0, [pc, #0x140]
a04a42b4 0119a0e3 mov r1, #0x4000
a04a42b8 03f8ffeb bl #0xa04a22cc
a04a42bc 000008e3 movw r0, #0x8000
a04a42c0 011aa0e3 mov r1, #0x1000
a04a42c4 b9004ae3 movt r0, #0xa0b9
a04a42c8 fff7ffeb bl #0xa04a22cc
a04a42cc 000057e3 cmp r7, #0
a04a42d0 3c00001a bne #0xa04a43c8
a04a42d4 157f07ee mcr p15, #0, r7, c7, c5, #0
a04a42d8 157f08ee mcr p15, #0, r7, c8, c5, #0
a04a42dc 00f7ffeb bl #0xa04a1ee4
a04a42e0 167f08ee mcr p15, #0, r7, c8, c6, #0
a04a42e4 0c219fe5 ldr r2, [pc, #0x10c]
a04a42e8 182f07ee mcr p15, #0, r2, c7, c8, #0
a04a42ec 143f17ee mrc p15, #0, r3, c7, c4, #0
a04a42f0 020013e3 tst r3, #2
a04a42f4 2338a011 lsrne r3, r3, #0x10
a04a42f8 7220ff16 uxthne r2, r2
a04a42fc 0338a011 lslne r3, r3, #0x10
a04a4300 ff3ec303 biceq r3, r3, #0xff0
a04a4304 0f30c303 biceq r3, r3, #0xf
a04a4308 02308311 orrne r3, r3, r2
a04a430c 103f02ee mcr p15, #0, r3, c2, c0, #0
a04a4310 000057e3 cmp r7, #0
a04a4314 0130a003 moveq r3, #1
a04a4318 3130a013 movne r3, #0x31
a04a431c 103f03ee mcr p15, #0, r3, c3, c0, #0
a04a4320 4ff07ff5 dsb sy
a04a4324 6ff07ff5 isb sy
a04a4328 040018e3 tst r8, #4
a04a432c 2b00001a bne #0xa04a43e0
a04a4330 40310ce3 movw r3, #0xc140
a04a4334 0120a0e3 mov r2, #1
a04a4338 78304ae3 movt r3, #0xa078
a04a433c 002083e5 str r2, [r3]
a04a4340 002093e5 ldr r2, [r3]
a04a4344 010052e3 cmp r2, #1
a04a4348 fcffff0a beq #0xa04a4340
a04a434c 000059e3 cmp sb, #0
a04a4350 0f32a0e3 mov r3, #0xf0000000
a04a4354 0f00a0e3 mov r0, #0xf
a04a4358 ff1f00e3 movw r1, #0xfff
a04a435c ff2f0fe3 movw r2, #0xffff
a04a4360 500083e5 str r0, [r3, #0x50]
a04a4364 541083e5 str r1, [r3, #0x54]
a04a4368 0c2083e5 str r2, [r3, #0xc]
a04a436c 1f00001a bne #0xa04a43f0
a04a4370 0f32a0e3 mov r3, #0xf0000000
a04a4374 002093e5 ldr r2, [r3]
a04a4378 602082e3 orr r2, r2, #0x60
a04a437c 002083e5 str r2, [r3]
a04a4380 302093e5 ldr r2, [r3, #0x30]
a04a4384 010012e3 tst r2, #1
a04a4388 01208203 orreq r2, r2, #1
a04a438c 30208305 streq r2, [r3, #0x30]
a04a4390 0f22a0e3 mov r2, #0xf0000000
a04a4394 003092e5 ldr r3, [r2]
a04a4398 013083e3 orr r3, r3, #1
a04a439c 003082e5 str r3, [r2]
a04a43a0 043096e5 ldr r3, [r6, #4]
a04a43a4 103f01ee mcr p15, #0, r3, c1, c0, #0
a04a43a8 e9f6ffeb bl #0xa04a1f54
a04a43ac 000057e3 cmp r7, #0
a04a43b0 0100001a bne #0xa04a43bc
a04a43b4 157f08ee mcr p15, #0, r7, c8, c5, #0
a04a43b8 167f08ee mcr p15, #0, r7, c8, c6, #0
a04a43bc 003096e5 ldr r3, [r6]
a04a43c0 303f01ee mcr p15, #0, r3, c1, c0, #1
a04a43c4 f88fbde8 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
a04a43c8 0040a0e3 mov r4, #0
a04a43cc 154f07ee mcr p15, #0, r4, c7, c5, #0
a04a43d0 154f08ee mcr p15, #0, r4, c8, c5, #0
a04a43d4 d0f6ffeb bl #0xa04a1f1c
a04a43d8 164f08ee mcr p15, #0, r4, c8, c6, #0
a04a43dc c0ffffea b #0xa04a42e4
a04a43e0 cdf6ffeb bl #0xa04a1f1c
a04a43e4 1fa1c2e7 bfc sl, #2, #1
a04a43e8 10af01ee mcr p15, #0, sl, c1, c0, #0
a04a43ec cfffffea b #0xa04a4330
a04a43f0 40f9ffeb bl #0xa04a28f8
a04a43f4 ddffffea b #0xa04a4370
a04a43f8 00c0b9a0 adcsge ip, sb, r0
