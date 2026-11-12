a03c0b20 70402de9   push     {r4, r5, r6, lr}
a03c0b24 0040a0e1   mov      r4, r0
a03c0b28 200200eb   bl       #0xa03c13b0
a03c0b2c 0060a0e1   mov      r6, r0
a03c0b30 850000eb   bl       #0xa03c0d4c
a03c0b34 005050e2   subs     r5, r0, #0
a03c0b38 1900000a   beq      #0xa03c0ba4
a03c0b3c 710000eb   bl       #0xa03c0d08
a03c0b40 002050e2   subs     r2, r0, #0
a03c0b44 1600001a   bne      #0xa03c0ba4
a03c0b48 343c06e3   movw     r3, #0x6c34
a03c0b4c 79314ae3   movt     r3, #0xa179
a03c0b50 030055e1   cmp      r5, r3
a03c0b54 1200000a   beq      #0xa03c0ba4
a03c0b58 000054e3   cmp      r4, #0
a03c0b5c 1400000a   beq      #0xa03c0bb4
a03c0b60 803706e3   movw     r3, #0x6780
a03c0b64 01c0a0e3   mov      ip, #1
a03c0b68 79314ae3   movt     r3, #0xa179
a03c0b6c 04e0a0e3   mov      lr, #4
a03c0b70 001093e5   ldr      r1, [r3]
a03c0b74 0600a0e1   mov      r0, r6
a03c0b78 882085e5   str      r2, [r5, #0x88]
a03c0b7c 30e085e5   str      lr, [r5, #0x30]
a03c0b80 0c2081e0   add      r2, r1, ip
a03c0b84 38c085e5   str      ip, [r5, #0x38]
a03c0b88 4c4085e5   str      r4, [r5, #0x4c]
a03c0b8c 002083e5   str      r2, [r3]
a03c0b90 240200eb   bl       #0xa03c1428
a03c0b94 0500a0e1   mov      r0, r5
a03c0b98 6f0400eb   bl       #0xa03c1d5c
a03c0b9c 880095e5   ldr      r0, [r5, #0x88]
a03c0ba0 7080bde8   pop      {r4, r5, r6, pc}
a03c0ba4 0600a0e1   mov      r0, r6
a03c0ba8 1e0200eb   bl       #0xa03c1428
a03c0bac 1300a0e3   mov      r0, #0x13
a03c0bb0 7080bde8   pop      {r4, r5, r6, pc}
a03c0bb4 0600a0e1   mov      r0, r6
a03c0bb8 1a0200eb   bl       #0xa03c1428
a03c0bbc 0400a0e1   mov      r0, r4
a03c0bc0 7080bde8   pop      {r4, r5, r6, pc}
a03c0bc4 000050e3   cmp      r0, #0
a03c0bc8 f8402de9   push     {r3, r4, r5, r6, r7, lr}
a03c0bcc 0400000a   beq      #0xa03c0be4
a03c0bd0 002090e5   ldr      r2, [r0]
a03c0bd4 443205e3   movw     r3, #0x5244
a03c0bd8 483445e3   movt     r3, #0x5448
a03c0bdc 030052e1   cmp      r2, r3
a03c0be0 0200000a   beq      #0xa03c0bf0
a03c0be4 0e40a0e3   mov      r4, #0xe
a03c0be8 0400a0e1   mov      r0, r4
a03c0bec f880bde8   pop      {r3, r4, r5, r6, r7, pc}
a03c0bf0 0050a0e1   mov      r5, r0
a03c0bf4 0160a0e1   mov      r6, r1
a03c0bf8 ec0100eb   bl       #0xa03c13b0
a03c0bfc 981095e5   ldr      r1, [r5, #0x98]
a03c0c00 0070a0e1   mov      r7, r0
a03c0c04 304095e5   ldr      r4, [r5, #0x30]
a03c0c08 0310c1e3   bic      r1, r1, #3
a03c0c0c 000054e3   cmp      r4, #0
a03c0c10 011086e1   orr      r1, r6, r1
a03c0c14 981085e5   str      r1, [r5, #0x98]
a03c0c18 1700001a   bne      #0xa03c0c7c
a03c0c1c 320000eb   bl       #0xa03c0cec
a03c0c20 0050a0e1   mov      r5, r0
a03c0c24 8c0000eb   bl       #0xa03c0e5c
a03c0c28 142306e3   movw     r2, #0x6314
a03c0c2c 0c3306e3   movw     r3, #0x630c
a03c0c30 79214ae3   movt     r2, #0xa179
a03c0c34 79314ae3   movt     r3, #0xa179
a03c0c38 052192e7   ldr      r2, [r2, r5, lsl #2]
a03c0c3c 053193e7   ldr      r3, [r3, r5, lsl #2]
a03c0c40 030052e1   cmp      r2, r3
a03c0c44 0900000a   beq      #0xa03c0c70
a03c0c48 e83206e3   movw     r3, #0x62e8
a03c0c4c 79314ae3   movt     r3, #0xa179
a03c0c50 053193e7   ldr      r3, [r3, r5, lsl #2]
a03c0c54 000053e3   cmp      r3, #0
a03c0c58 0400001a   bne      #0xa03c0c70
a03c0c5c 803706e3   movw     r3, #0x6780
a03c0c60 79314ae3   movt     r3, #0xa179
a03c0c64 002093e5   ldr      r2, [r3]
a03c0c68 000052e3   cmp      r2, #0
a03c0c6c 0500000a   beq      #0xa03c0c88
a03c0c70 0700a0e1   mov      r0, r7
a03c0c74 eb0100eb   bl       #0xa03c1428
a03c0c78 daffffea   b        #0xa03c0be8
a03c0c7c e90100eb   bl       #0xa03c1428
a03c0c80 0040a0e3   mov      r4, #0
a03c0c84 d7ffffea   b        #0xa03c0be8
a03c0c88 002093e5   ldr      r2, [r3]
a03c0c8c 0700a0e1   mov      r0, r7
a03c0c90 012082e2   add      r2, r2, #1
a03c0c94 002083e5   str      r2, [r3]
a03c0c98 e20100eb   bl       #0xa03c1428
a03c0c9c fa0300eb   bl       #0xa03c1c8c
a03c0ca0 d0ffffea   b        #0xa03c0be8
a03c0ca4 000050e3   cmp      r0, #0
a03c0ca8 0400000a   beq      #0xa03c0cc0
a03c0cac 002090e5   ldr      r2, [r0]
a03c0cb0 443205e3   movw     r3, #0x5244
a03c0cb4 483445e3   movt     r3, #0x5448
a03c0cb8 030052e1   cmp      r2, r3
a03c0cbc 0100000a   beq      #0xa03c0cc8
a03c0cc0 0e00a0e3   mov      r0, #0xe
a03c0cc4 1eff2fe1   bx       lr
a03c0cc8 000051e3   cmp      r1, #0
a03c0ccc 0400000a   beq      #0xa03c0ce4
a03c0cd0 983090e5   ldr      r3, [r0, #0x98]
a03c0cd4 0000a0e3   mov      r0, #0
a03c0cd8 033003e2   and      r3, r3, #3
a03c0cdc 003081e5   str      r3, [r1]
a03c0ce0 1eff2fe1   bx       lr
a03c0ce4 0300a0e3   mov      r0, #3
a03c0ce8 1eff2fe1   bx       lr
a03c0cec b00f10ee   mrc      p15, #0, r0, c0, c0, #5
a03c0cf0 030000e2   and      r0, r0, #3
a03c0cf4 1eff2fe1   bx       lr
a03c0cf8 10402de9   push     {r4, lr}
a03c0cfc 25edffeb   bl       #0xa03bc198
a03c0d00 1040bde8   pop      {r4, lr}
a03c0d04 1eff2fe1   bx       lr
