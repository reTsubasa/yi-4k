WINDOW 0xa0495c30
a0495c30 push     {r4, lr}
a0495c34 movw     r4, #0x22a0
a0495c38 movt     r4, #0xa06f
a0495c3c ldr      r3, [r4]
a0495c40 cmp      r3, #0
a0495c44 bne      #0xa0495c74
a0495c48 movw     r3, #0xa528
a0495c4c movt     r3, #0xa1a3
a0495c50 ldr      r2, [r3]
a0495c54 add      r2, r2, #1
a0495c58 str      r2, [r3]
a0495c5c bl       #0xa03c2d64
a0495c60 ldr      r3, [r4]
a0495c64 cmp      r3, #0
a0495c68 popeq    {r4, pc}
a0495c6c pop      {r4, lr}
a0495c70 b        #0xa03cd1f0
a0495c74 bl       #0xa03cd1ec
a0495c78 b        #0xa0495c48
WINDOW 0xa048e3f8
a048e3f8 movw     r3, #0xa528
a048e3fc movt     r3, #0xa1a3
a048e400 ldr      r0, [r3]
a048e404 bx       lr
WINDOW 0xa04a1d84
a04a1d84 bl       #0xa0495c7c
a04a1d88 movw     r3, #0xa528
a04a1d8c mov      r2, #0x3e8
a04a1d90 mov      ip, #0
a04a1d94 movt     r3, #0xa1a3
a04a1d98 mov      r1, sp
a04a1d9c mov      r0, #7
a04a1da0 str      ip, [r3]
a04a1da4 str      r2, [sp]
a04a1da8 str      r2, [sp, #4]
a04a1dac bl       #0xa0495d30
a04a1db0 bl       #0xa048f410
a04a1db4 add      sp, sp, #0x10
