a04a2038 000051e3   cmp      r1, #0
a04a203c 1eff2f01   bxeq     lr
a04a2040 803b0de3   movw     r3, #0xdb80
a04a2044 f04f2de9   push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04a2048 62304ae3   movt     r3, #0xa062
a04a204c 14d04de2   sub      sp, sp, #0x14
a04a2050 011041e2   sub      r1, r1, #1
a04a2054 1fb0c0e3   bic      fp, r0, #0x1f
a04a2058 002093e5   ldr      r2, [r3]
a04a205c 005081e0   add      r5, r1, r0
a04a2060 04308de5   str      r3, [sp, #4]
a04a2064 002192e5   ldr      r2, [r2, #0x100]
a04a2068 000052e3   cmp      r2, #0
a04a206c 2500000a   beq      #0xa04a2108
a04a2070 20a6e0e1   mvn      sl, r0, lsr #12
a04a2074 0aa6e0e1   mvn      sl, sl, lsl #12
a04a2078 0a0055e1   cmp      r5, sl
a04a207c 1300009a   bls      #0xa04a20d0
a04a2080 ec700ce3   movw     r7, #0xc0ec
a04a2084 f0800ce3   movw     r8, #0xc0f0
a04a2088 78704ae3   movt     r7, #0xa078
a04a208c 78804ae3   movt     r8, #0xa078
a04a2090 0b00a0e1   mov      r0, fp
a04a2094 180800eb   bl       #0xa04a40fc
a04a2098 000050e3   cmp      r0, #0
a04a209c 2300000a   beq      #0xa04a2130
a04a20a0 4ff07ff5   dsb      sy
a04a20a4 0b005ae1   cmp      sl, fp
a04a20a8 0300003a   blo      #0xa04a20bc
a04a20ac 36bf07ee   mcr      p15, #0, fp, c7, c6, #1
a04a20b0 20b08be2   add      fp, fp, #0x20
a04a20b4 0a005be1   cmp      fp, sl
a04a20b8 fbffff9a   bls      #0xa04a20ac
a04a20bc 4ff07ff5   dsb      sy
a04a20c0 01b08ae2   add      fp, sl, #1
a04a20c4 01aa8ae2   add      sl, sl, #0x1000
a04a20c8 0a0055e1   cmp      r5, sl
a04a20cc efffff8a   bhi      #0xa04a2090
a04a20d0 0b00a0e1   mov      r0, fp
a04a20d4 080800eb   bl       #0xa04a40fc
a04a20d8 000050e3   cmp      r0, #0
a04a20dc 3f00000a   beq      #0xa04a21e0
a04a20e0 4ff07ff5   dsb      sy
a04a20e4 0b0055e1   cmp      r5, fp
a04a20e8 0300003a   blo      #0xa04a20fc
a04a20ec 36bf07ee   mcr      p15, #0, fp, c7, c6, #1
a04a20f0 20b08be2   add      fp, fp, #0x20
a04a20f4 0b0055e1   cmp      r5, fp
a04a20f8 fbffff2a   bhs      #0xa04a20ec
a04a20fc 4ff07ff5   dsb      sy
a04a2100 14d08de2   add      sp, sp, #0x14
a04a2104 f08fbde8   pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a04a2108 4ff07ff5   dsb      sy
a04a210c 05005be1   cmp      fp, r5
a04a2110 f9ffff8a   bhi      #0xa04a20fc
a04a2114 36bf07ee   mcr      p15, #0, fp, c7, c6, #1
a04a2118 20b08be2   add      fp, fp, #0x20
a04a211c 0b0055e1   cmp      r5, fp
a04a2120 fbffff2a   bhs      #0xa04a2114
a04a2124 4ff07ff5   dsb      sy
a04a2128 14d08de2   add      sp, sp, #0x14
a04a212c f08fbde8   pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a04a2130 0b00a0e1   mov      r0, fp
a04a2134 7a0600eb   bl       #0xa04a3b24
