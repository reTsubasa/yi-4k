a03c4694 cmp      r0, #0
a03c4698 beq      #0xa03c46b0
a03c469c ldr      r2, [r0]
a03c46a0 movw     r3, #0x5244
a03c46a4 movt     r3, #0x5448
a03c46a8 cmp      r2, r3
a03c46ac beq      #0xa03c46b8
a03c46b0 mov      r0, #0xe
a03c46b4 bx       lr
a03c46b8 push     {r4, lr}
a03c46bc mov      r4, r0
a03c46c0 bl       #0xa03c0d08
a03c46c4 cmp      r0, #0
a03c46c8 beq      #0xa03c46d4
a03c46cc mov      r0, #0x13
a03c46d0 pop      {r4, pc}
