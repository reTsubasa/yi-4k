0xa03bd0b8  push {r4, r5, r6, r7, r8, sb, sl, lr}
0xa03bd0bc  mov sl, r1
0xa03bd0c0  mov r8, r3
0xa03bd0c4  mov r4, r0
0xa03bd0c8  mov sb, r2
0xa03bd0cc  ldr r7, [sp, #0x20]
0xa03bd0d0  ldr r6, [sp, #0x24]
0xa03bd0d4  ldr r5, [sp, #0x28]
0xa03bd0d8  bl #0xa03c13b0
0xa03bd0dc  cmp sl, #0
0xa03bd0e0  ldrne r3, [r4, #4]
0xa03bd0e4  strne r3, [sl]
0xa03bd0e8  cmp sb, #0
0xa03bd0ec  ldrne r3, [r4, #8]
0xa03bd0f0  strne r3, [sb]
0xa03bd0f4  cmp r8, #0
0xa03bd0f8  ldrne r3, [r4, #0xc]
0xa03bd0fc  strne r3, [r8]
0xa03bd100  cmp r7, #0
0xa03bd104  ldrne r3, [r4, #0x24]
0xa03bd108  strne r3, [r7]
0xa03bd10c  cmp r6, #0
0xa03bd110  ldrne r3, [r4, #0x28]
0xa03bd114  strne r3, [r6]
0xa03bd118  cmp r5, #0
0xa03bd11c  ldrne r3, [r4, #0x2c]
0xa03bd120  strne r3, [r5]
0xa03bd124  bl #0xa03c1428
0xa03bd128  mov r0, #0
0xa03bd12c  pop {r4, r5, r6, r7, r8, sb, sl, pc}
0xa03c36c4  subs ip, r0, #0
0xa03c36c8  push {r4, r5, r6, lr}
0xa03c36cc  ldr r6, [sp, #0x10]
0xa03c36d0  ldr r5, [sp, #0x14]
0xa03c36d4  ldr r4, [sp, #0x18]
0xa03c36d8  beq #0xa03c36f0
0xa03c36dc  ldr lr, [ip]
0xa03c36e0  movw ip, #0x5445
0xa03c36e4  movt ip, #0x4259
0xa03c36e8  cmp lr, ip
0xa03c36ec  beq #0xa03c36f8
0xa03c36f0  mov r0, #2
0xa03c36f4  pop {r4, r5, r6, pc}
0xa03c36f8  pop {r4, r5, r6, lr}
0xa03c36fc  b #0xa03bd0b8
