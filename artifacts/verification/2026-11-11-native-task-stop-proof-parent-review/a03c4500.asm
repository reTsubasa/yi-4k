a03c0190 f84f2de9 push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c0194 0160a0e1 mov r6, r1
a03c0198 03a0a0e1 mov sl, r3
a03c019c 0040a0e1 mov r4, r0
a03c01a0 02b0a0e1 mov fp, r2
a03c01a4 28909de5 ldr sb, [sp, #0x28]
a03c01a8 2c809de5 ldr r8, [sp, #0x2c]
a03c01ac 30709de5 ldr r7, [sp, #0x30]
a03c01b0 38509de5 ldr r5, [sp, #0x38]
a03c01b4 7d0400eb bl #0xa03c13b0
a03c01b8 000056e3 cmp r6, #0
a03c01bc 28309415 ldrne r3, [r4, #0x28]
a03c01c0 00308615 strne r3, [r6]
a03c01c4 00005be3 cmp fp, #0
a03c01c8 30309415 ldrne r3, [r4, #0x30]
a03c01cc 00308b15 strne r3, [fp]
a03c01d0 00005ae3 cmp sl, #0
a03c01d4 04309415 ldrne r3, [r4, #4]
a03c01d8 00308a15 strne r3, [sl]
a03c01dc 000059e3 cmp sb, #0
a03c01e0 b0309415 ldrne r3, [r4, #0xb0]
a03c01e4 00308915 strne r3, [sb]
a03c01e8 000058e3 cmp r8, #0
a03c01ec b4309415 ldrne r3, [r4, #0xb4]
a03c01f0 00308815 strne r3, [r8]
a03c01f4 000057e3 cmp r7, #0
a03c01f8 18309415 ldrne r3, [r4, #0x18]
a03c01fc 00308715 strne r3, [r7]
a03c0200 34309de5 ldr r3, [sp, #0x34]
a03c0204 000053e3 cmp r3, #0
a03c0208 8c309415 ldrne r3, [r4, #0x8c]
a03c020c 34209d15 ldrne r2, [sp, #0x34]
a03c0210 00308215 strne r3, [r2]
a03c0214 000055e3 cmp r5, #0
a03c0218 74309415 ldrne r3, [r4, #0x74]
a03c021c 00308515 strne r3, [r5]
a03c0220 800400eb bl #0xa03c1428
a03c0224 0000a0e3 mov r0, #0
a03c0228 f88fbde8 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c4500 00c050e2 subs ip, r0, #0
a03c4504 f0412de9 push {r4, r5, r6, r7, r8, lr}
a03c4508 18809de5 ldr r8, [sp, #0x18]
a03c450c 1c709de5 ldr r7, [sp, #0x1c]
a03c4510 20609de5 ldr r6, [sp, #0x20]
a03c4514 24509de5 ldr r5, [sp, #0x24]
a03c4518 28409de5 ldr r4, [sp, #0x28]
a03c451c 0400000a beq #0xa03c4534
a03c4520 00e09ce5 ldr lr, [ip]
a03c4524 44c205e3 movw ip, #0x5244
a03c4528 48c445e3 movt ip, #0x5448
a03c452c 0c005ee1 cmp lr, ip
a03c4530 0100000a beq #0xa03c453c
a03c4534 0e00a0e3 mov r0, #0xe
a03c4538 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03c453c f041bde8 pop {r4, r5, r6, r7, r8, lr}
a03c4540 12efffea b #0xa03c0190
