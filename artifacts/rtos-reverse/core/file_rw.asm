a033a2ac 04e02de5   str      lr, [sp, #-4]!
a033a2b0 14d04de2   sub      sp, sp, #0x14
a033a2b4 0cc08de2   add      ip, sp, #0xc
a033a2b8 00c08de5   str      ip, [sp]
a033a2bc f65500eb   bl       #0xa034fa9c
a033a2c0 0c009de5   ldr      r0, [sp, #0xc]
a033a2c4 14d08de2   add      sp, sp, #0x14
a033a2c8 04f09de4   pop      {pc}
a033a2cc 04e02de5   str      lr, [sp, #-4]!
a033a2d0 0cd04de2   sub      sp, sp, #0xc
a033a2d4 10109de5   ldr      r1, [sp, #0x10]
a033a2d8 00108de5   str      r1, [sp]
a033a2dc 765800eb   bl       #0xa03504bc
a033a2e0 0cd08de2   add      sp, sp, #0xc
a033a2e4 04e09de4   pop      {lr}
a033a2e8 84feffea   b        #0xa0339d00
a033a2ec 30402de9   push     {r4, r5, lr}
a033a2f0 14d04de2   sub      sp, sp, #0x14
a033a2f4 0150a0e1   mov      r5, r1
a033a2f8 0240a0e1   mov      r4, r2
a033a2fc 0010a0e1   mov      r1, r0
a033a300 0120a0e3   mov      r2, #1
a033a304 04008de2   add      r0, sp, #4
a033a308 8e0200eb   bl       #0xa033ad48
a033a30c 000050e3   cmp      r0, #0
a033a310 2c309f15   ldrne    r3, [pc, #0x2c]
a033a314 d80d8315   strne    r0, [r3, #0xdd8]
a033a318 0200000a   beq      #0xa033a328
a033a31c 77feffeb   bl       #0xa0339d00
a033a320 14d08de2   add      sp, sp, #0x14
a033a324 3080bde8   pop      {r4, r5, pc}
a033a328 0510a0e1   mov      r1, r5
a033a32c 0420a0e1   mov      r2, r4
a033a330 04008de2   add      r0, sp, #4
a033a334 182400eb   bl       #0xa034339c
a033a338 70feffeb   bl       #0xa0339d00
a033a33c 14d08de2   add      sp, sp, #0x14
a033a340 3080bde8   pop      {r4, r5, pc}
