0xa03bd130  push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa03bd134  mov r6, r0
0xa03bd138  sub sp, sp, #0xc
0xa03bd13c  mov r4, r1
0xa03bd140  str r1, [sp, #4]
0xa03bd144  bl #0xa03c13b0
0xa03bd148  ldr r2, [r6, #8]
0xa03bd14c  cmp r2, r4
0xa03bd150  bls #0xa03bd340
0xa03bd154  ldr r4, [r6, #0x14]
0xa03bd158  mov sb, #0
0xa03bd15c  ldr r5, [r6, #0xc]
0xa03bd160  movw fp, #0xeeee
0xa03bd164  mov sl, r0
0xa03bd168  mov r8, sb
0xa03bd16c  movt fp, #0xffff
0xa03bd170  mov r7, r4
0xa03bd174  add r5, r5, #1
0xa03bd178  b #0xa03bd1d4
0xa03bd17c  cmp r5, #0
0xa03bd180  subne r5, r5, #1
0xa03bd184  mov r0, sl
0xa03bd188  bl #0xa03c1428
0xa03bd18c  bl #0xa03c13b0
0xa03bd190  mov sl, r0
0xa03bd194  bl #0xa03c0d4c
0xa03bd198  ldr r2, [r6, #0x20]
0xa03bd19c  cmp r2, r0
0xa03bd1a0  beq #0xa03bd1cc
0xa03bd1a4  ldr r7, [r6, #0x14]
0xa03bd1a8  str r0, [r6, #0x20]
0xa03bd1ac  ldr r5, [r6, #0xc]
0xa03bd1b0  ldr r2, [r7, #4]
0xa03bd1b4  ldr r4, [r7]
0xa03bd1b8  add r5, r5, #1
0xa03bd1bc  cmp r2, fp
0xa03bd1c0  beq #0xa03bd244
0xa03bd1c4  mov r7, r4
0xa03bd1c8  str r4, [r6, #0x14]
0xa03bd1cc  cmp r5, #0
0xa03bd1d0  beq #0xa03bd274
0xa03bd1d4  ldr r2, [r4, #4]
0xa03bd1d8  cmp r2, fp
0xa03bd1dc  ldrne r4, [r4]
0xa03bd1e0  bne #0xa03bd17c
0xa03bd1e4  ldr r2, [r4]
0xa03bd1e8  eor sb, sb, #1
0xa03bd1ec  ldr r3, [sp, #4]
0xa03bd1f0  cmp r4, r7
0xa03bd1f4  moveq sb, #0
0xa03bd1f8  andne sb, sb, #1
0xa03bd1fc  cmp sb, #0
0xa03bd200  rsb r8, r4, r2
0xa03bd204  movne r7, r4
0xa03bd208  sub r8, r8, #8
0xa03bd20c  cmp r3, r8
0xa03bd210  bls #0xa03bd274
0xa03bd214  ldr r1, [r2, #4]
0xa03bd218  cmp r1, fp
0xa03bd21c  beq #0xa03bd2c0
0xa03bd220  cmp r5, #0
0xa03bd224  ldr r4, [r2]
0xa03bd228  moveq sb, #1
0xa03bd22c  moveq r8, r5
0xa03bd230  beq #0xa03bd184
0xa03bd234  sub r5, r5, #1
0xa03bd238  mov sb, #1
0xa03bd23c  mov r8, #0
0xa03bd240  b #0xa03bd17c
0xa03bd244  ldr r3, [sp, #4]
0xa03bd248  rsb r8, r7, r4
0xa03bd24c  sub r8, r8, #8
0xa03bd250  cmp r3, r8
0xa03bd254  bls #0xa03bd268
0xa03bd258  ldr r2, [r4, #4]
0xa03bd25c  cmp r2, fp
0xa03bd260  ldrne r4, [r4]
0xa03bd264  bne #0xa03bd1c4
0xa03bd268  cmp r5, #0
0xa03bd26c  mov r4, r7
0xa03bd270  bne #0xa03bd1d4
0xa03bd274  cmp r8, #0
0xa03bd278  beq #0xa03bd328
0xa03bd27c  ldr r3, [sp, #4]
0xa03bd280  rsb r2, r3, r8
0xa03bd284  cmp r2, #0x13
0xa03bd288  bhi #0xa03bd2f4
0xa03bd28c  str r6, [r4, #4]
0xa03bd290  cmp r4, r7
0xa03bd294  ldr r2, [r6, #8]
0xa03bd298  mov r0, sl
0xa03bd29c  sub r2, r2, #8
0xa03bd2a0  rsb r8, r8, r2
0xa03bd2a4  str r8, [r6, #8]
0xa03bd2a8  ldreq r7, [r4]
0xa03bd2ac  str r7, [r6, #0x14]
0xa03bd2b0  bl #0xa03c1428
0xa03bd2b4  add r0, r4, #8
0xa03bd2b8  add sp, sp, #0xc
0xa03bd2bc  pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa03bd2c0  ldr r1, [r2]
0xa03bd2c4  str r1, [r4]
0xa03bd2c8  ldr r0, [r6, #0x14]
0xa03bd2cc  ldr r1, [r6, #0xc]
0xa03bd2d0  cmp r0, r2
0xa03bd2d4  sub r2, r1, #1
0xa03bd2d8  streq r4, [r6, #0x14]
0xa03bd2dc  str r2, [r6, #0xc]
0xa03bd2e0  moveq sb, #1
0xa03bd2e4  moveq r8, #0
0xa03bd2e8  movne sb, #1
0xa03bd2ec  movne r8, #0
0xa03bd2f0  b #0xa03bd17c
0xa03bd2f4  ldr ip, [r4]
0xa03bd2f8  add r0, r3, #8
0xa03bd2fc  movw r2, #0xeeee
0xa03bd300  add r1, r4, r0
0xa03bd304  movt r2, #0xffff
0xa03bd308  mov r8, r3
0xa03bd30c  str ip, [r4, r0]
0xa03bd310  str r2, [r1, #4]
0xa03bd314  ldr r2, [r6, #0xc]
0xa03bd318  add r2, r2, #1
0xa03bd31c  str r2, [r6, #0xc]
0xa03bd320  str r1, [r4]
0xa03bd324  b #0xa03bd28c
0xa03bd328  mov r0, sl
0xa03bd32c  str r7, [r6, #0x14]
0xa03bd330  bl #0xa03c1428
0xa03bd334  mov r0, r8
0xa03bd338  add sp, sp, #0xc
0xa03bd33c  pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa03bd340  bl #0xa03c1428
0xa03bd344  mov r0, #0
0xa03bd348  b #0xa03bd2b8
