a033a1b4 08402de9   push     {r3, lr}
a033a1b8 476a00eb   bl       #0xa0354adc
a033a1bc 0840bde8   pop      {r3, lr}
a033a1c0 c0feffea   b        #0xa0339cc8
a033a1c4 04e02de5   str      lr, [sp, #-4]!
a033a1c8 0cd04de2   sub      sp, sp, #0xc
a033a1cc 04208de2   add      r2, sp, #4
a033a1d0 ae5900eb   bl       #0xa0350890
a033a1d4 04009de5   ldr      r0, [sp, #4]
a033a1d8 0cd08de2   add      sp, sp, #0xc
a033a1dc 04f09de4   pop      {pc}
a033a1e0 08402de9   push     {r3, lr}
a033a1e4 2d5500eb   bl       #0xa034f6a0
a033a1e8 0840bde8   pop      {r3, lr}
a033a1ec c3feffea   b        #0xa0339d00
a033a1f0 08402de9   push     {r3, lr}
a033a1f4 6b5800eb   bl       #0xa03503a8
a033a1f8 0840bde8   pop      {r3, lr}
a033a1fc c3feffea   b        #0xa0339d10
a033a200 08402de9   push     {r3, lr}
a033a204 1f5c00eb   bl       #0xa0351288
a033a208 0840bde8   pop      {r3, lr}
a033a20c bbfeffea   b        #0xa0339d00
a033a210 30402de9   push     {r4, r5, lr}
a033a214 0050a0e1   mov      r5, r0
a033a218 14d04de2   sub      sp, sp, #0x14
a033a21c 0100a0e1   mov      r0, r1
a033a220 66feffeb   bl       #0xa0339bc0
a033a224 004050e2   subs     r4, r0, #0
a033a228 0500001a   bne      #0xa033a244
a033a22c 60309fe5   ldr      r3, [pc, #0x60]
a033a230 0a20a0e3   mov      r2, #0xa
a033a234 0400a0e1   mov      r0, r4
a033a238 d82d83e5   str      r2, [r3, #0xdd8]
a033a23c 14d08de2   add      sp, sp, #0x14
a033a240 3080bde8   pop      {r4, r5, pc}
a033a244 0510a0e1   mov      r1, r5
a033a248 04008de2   add      r0, sp, #4
a033a24c 0120a0e3   mov      r2, #1
a033a250 bc0200eb   bl       #0xa033ad48
a033a254 000050e3   cmp      r0, #0
a033a258 0700000a   beq      #0xa033a27c
a033a25c 0030a0e3   mov      r3, #0
a033a260 2c209fe5   ldr      r2, [pc, #0x2c]
a033a264 0310a0e1   mov      r1, r3
a033a268 00308de5   str      r3, [sp]
a033a26c d80d82e5   str      r0, [r2, #0xdd8]
a033a270 acfeffeb   bl       #0xa0339d28
a033a274 14d08de2   add      sp, sp, #0x14
a033a278 3080bde8   pop      {r4, r5, pc}
a033a27c 0410a0e1   mov      r1, r4
a033a280 04008de2   add      r0, sp, #4
a033a284 0d20a0e1   mov      r2, sp
a033a288 a95400eb   bl       #0xa034f534
a033a28c 00109de5   ldr      r1, [sp]
a033a290 f6ffffea   b        #0xa033a270
