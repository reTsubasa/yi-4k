a04f8d80 53f8146c   ldr      r6, [r3, #-0x14]
a04f8d84 44f8146c   str      r6, [r4, #-0x14]
a04f8d88 e8d8       bhi      #0xa04f8d5c
a04f8d8a a2f11003   sub.w    r3, r2, #0x10
a04f8d8e 02f00f0e   and      lr, r2, #0xf
a04f8d92 23f00f03   bic      r3, r3, #0xf
a04f8d96 bef1030f   cmp.w    lr, #3
a04f8d9a 03f11003   add.w    r3, r3, #0x10
a04f8d9e 1944       add      r1, r3
a04f8da0 0344       add      r3, r0
a04f8da2 21d9       bls      #0xa04f8de8
a04f8da4 1e1f       subs     r6, r3, #4
a04f8da6 0d46       mov      r5, r1
a04f8da8 7446       mov      r4, lr
a04f8daa 55f8047b   ldr      r7, [r5], #4
a04f8dae 043c       subs     r4, #4
a04f8db0 032c       cmp      r4, #3
a04f8db2 46f8047f   str      r7, [r6, #4]!
a04f8db6 f8d8       bhi      #0xa04f8daa
a04f8db8 aef10404   sub.w    r4, lr, #4
a04f8dbc 02f00302   and      r2, r2, #3
a04f8dc0 24f00304   bic      r4, r4, #3
a04f8dc4 0434       adds     r4, #4
a04f8dc6 2344       add      r3, r4
a04f8dc8 2144       add      r1, r4
a04f8dca 52b1       cbz      r2, #0xa04f8de2
a04f8dcc 013b       subs     r3, #1
a04f8dce 0a44       add      r2, r1
a04f8dd0 11f8014b   ldrb     r4, [r1], #1
a04f8dd4 9142       cmp      r1, r2
a04f8dd6 03f8014f   strb     r4, [r3, #1]!
a04f8dda f9d1       bne      #0xa04f8dd0
a04f8ddc f0bd       pop      {r4, r5, r6, r7, pc}
a04f8dde 0346       mov      r3, r0
a04f8de0 f3e7       b        #0xa04f8dca
a04f8de2 f0bd       pop      {r4, r5, r6, r7, pc}
a04f8de4 0346       mov      r3, r0
a04f8de6 f1e7       b        #0xa04f8dcc
a04f8de8 7246       mov      r2, lr
a04f8dea eee7       b        #0xa04f8dca
a04f8dec 8307       lsls     r3, r0, #0x1e
a04f8dee 70b4       push     {r4, r5, r6}
a04f8df0 4ad0       beq      #0xa04f8e88
a04f8df2 541e       subs     r4, r2, #1
a04f8df4 002a       cmp      r2, #0
a04f8df6 45d0       beq      #0xa04f8e84
a04f8df8 cdb2       uxtb     r5, r1
a04f8dfa 0346       mov      r3, r0
a04f8dfc 02e0       b        #0xa04f8e04
a04f8dfe 002c       cmp      r4, #0
a04f8e00 40d0       beq      #0xa04f8e84
a04f8e02 1446       mov      r4, r2
a04f8e04 03f8015b   strb     r5, [r3], #1
a04f8e08 13f0030f   tst.w    r3, #3
a04f8e0c 04f1ff32   add.w    r2, r4, #-1
a04f8e10 f5d1       bne      #0xa04f8dfe
a04f8e12 032c       cmp      r4, #3
a04f8e14 2fd9       bls      #0xa04f8e76
a04f8e16 cdb2       uxtb     r5, r1
a04f8e18 0f2c       cmp      r4, #0xf
a04f8e1a 45ea0525   orr.w    r5, r5, r5, lsl #8
a04f8e1e 45ea0545   orr.w    r5, r5, r5, lsl #16
a04f8e22 1ad9       bls      #0xa04f8e5a
a04f8e24 03f11002   add.w    r2, r3, #0x10
a04f8e28 2646       mov      r6, r4
a04f8e2a 103e       subs     r6, #0x10
a04f8e2c 42f8105c   str      r5, [r2, #-0x10]
a04f8e30 0f2e       cmp      r6, #0xf
a04f8e32 42f80c5c   str      r5, [r2, #-0xc]
a04f8e36 42f8085c   str      r5, [r2, #-0x8]
a04f8e3a 02f11002   add.w    r2, r2, #0x10
a04f8e3e 42f8145c   str      r5, [r2, #-0x14]
a04f8e42 f2d8       bhi      #0xa04f8e2a
a04f8e44 a4f11002   sub.w    r2, r4, #0x10
a04f8e48 04f00f04   and      r4, r4, #0xf
a04f8e4c 22f00f02   bic      r2, r2, #0xf
a04f8e50 032c       cmp      r4, #3
a04f8e52 02f11002   add.w    r2, r2, #0x10
a04f8e56 1344       add      r3, r2
a04f8e58 0dd9       bls      #0xa04f8e76
a04f8e5a 1e46       mov      r6, r3
a04f8e5c 2246       mov      r2, r4
a04f8e5e 043a       subs     r2, #4
a04f8e60 46f8045b   str      r5, [r6], #4
a04f8e64 032a       cmp      r2, #3
a04f8e66 fad8       bhi      #0xa04f8e5e
a04f8e68 221f       subs     r2, r4, #4
a04f8e6a 04f00304   and      r4, r4, #3
a04f8e6e 22f00302   bic      r2, r2, #3
a04f8e72 0432       adds     r2, #4
a04f8e74 1344       add      r3, r2
a04f8e76 2cb1       cbz      r4, #0xa04f8e84
a04f8e78 c9b2       uxtb     r1, r1
a04f8e7a 1c44       add      r4, r3
a04f8e7c 03f8011b   strb     r1, [r3], #1
