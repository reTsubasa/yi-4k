a03c0190 push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c0194 mov r6, r1
a03c0198 mov sl, r3
a03c019c mov r4, r0
a03c01a0 mov fp, r2
a03c01a4 ldr sb, [sp, #0x28]
a03c01a8 ldr r8, [sp, #0x2c]
a03c01ac ldr r7, [sp, #0x30]
a03c01b0 ldr r5, [sp, #0x38]
a03c01b4 bl #0xa03c13b0
a03c01b8 cmp r6, #0
a03c01bc ldrne r3, [r4, #0x28]
a03c01c0 strne r3, [r6]
a03c01c4 cmp fp, #0
a03c01c8 ldrne r3, [r4, #0x30]
a03c01cc strne r3, [fp]
a03c01d0 cmp sl, #0
a03c01d4 ldrne r3, [r4, #4]
a03c01d8 strne r3, [sl]
a03c01dc cmp sb, #0
a03c01e0 ldrne r3, [r4, #0xb0]
a03c01e4 strne r3, [sb]
a03c01e8 cmp r8, #0
a03c01ec ldrne r3, [r4, #0xb4]
a03c01f0 strne r3, [r8]
a03c01f4 cmp r7, #0
a03c01f8 ldrne r3, [r4, #0x18]
a03c01fc strne r3, [r7]
a03c0200 ldr r3, [sp, #0x34]
a03c0204 cmp r3, #0
a03c0208 ldrne r3, [r4, #0x8c]
a03c020c ldrne r2, [sp, #0x34]
a03c0210 strne r3, [r2]
a03c0214 cmp r5, #0
a03c0218 ldrne r3, [r4, #0x74]
a03c021c strne r3, [r5]
a03c0220 bl #0xa03c1428
a03c0224 mov r0, #0
a03c0228 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c4500 subs ip, r0, #0
a03c4504 push {r4, r5, r6, r7, r8, lr}
a03c4508 ldr r8, [sp, #0x18]
a03c450c ldr r7, [sp, #0x1c]
a03c4510 ldr r6, [sp, #0x20]
a03c4514 ldr r5, [sp, #0x24]
a03c4518 ldr r4, [sp, #0x28]
a03c451c beq #0xa03c4534
a03c4520 ldr lr, [ip]
a03c4524 movw ip, #0x5244
a03c4528 movt ip, #0x5448
a03c452c cmp lr, ip
a03c4530 beq #0xa03c453c
a03c4534 mov r0, #0xe
a03c4538 pop {r4, r5, r6, r7, r8, pc}
a03c453c pop {r4, r5, r6, r7, r8, lr}
a03c4540 b #0xa03c0190
