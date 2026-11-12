0xa03bc77c  push {r3, r4, r5, r6, r7, lr}
0xa03bc780  mov r4, r3
0xa03bc784  add r2, r2, r4
0xa03bc788  mov r3, #0
0xa03bc78c  mov r5, r1
0xa03bc790  bl #0xa03c3448
0xa03bc794  subs r7, r0, #0
0xa03bc798  bne #0xa03bc7ac
0xa03bc79c  cmp r4, #0
0xa03bc7a0  ldr r6, [r5]
0xa03bc7a4  bne #0xa03bc7b4
0xa03bc7a8  str r6, [r5, #4]
0xa03bc7ac  mov r0, r7
0xa03bc7b0  pop {r3, r4, r5, r6, r7, pc}
0xa03bc7b4  mov r0, r6
0xa03bc7b8  mov r1, r4
0xa03bc7bc  blx #0xa0506674
0xa03bc7c0  cmp r1, #0
0xa03bc7c4  addne r6, r4, r6
0xa03bc7c8  rsbne r6, r1, r6
0xa03bc7cc  b #0xa03bc7a8
