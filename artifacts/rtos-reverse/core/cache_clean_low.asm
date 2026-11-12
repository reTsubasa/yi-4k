; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; cache_clean_low, mode=ARM; selected range, not guaranteed function boundary
a04a22cc  000051e3   cmp       r1, #0
a04a22d0  1eff2f01   bxeq      lr
a04a22d4  803b0de3   movw      r3, #0xdb80
a04a22d8  f04f2de9   push      {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04a22dc  62304ae3   movt      r3, #0xa062
a04a22e0  14d04de2   sub       sp, sp, #0x14
a04a22e4  011041e2   sub       r1, r1, #1
a04a22e8  1f40c0e3   bic       r4, r0, #0x1f
a04a22ec  04308de5   str       r3, [sp, #4]
a04a22f0  005081e0   add       r5, r1, r0
a04a22f4  003093e5   ldr       r3, [r3]
a04a22f8  003193e5   ldr       r3, [r3, #0x100]
a04a22fc  000053e3   cmp       r3, #0
a04a2300  2700000a   beq       #0xa04a23a4
a04a2304  20b6e0e1   mvn       fp, r0, lsr #12
a04a2308  0bb6e0e1   mvn       fp, fp, lsl #12
a04a230c  0b0055e1   cmp       r5, fp
a04a2310  1400009a   bls       #0xa04a2368
a04a2314  ec700ce3   movw      r7, #0xc0ec
a04a2318  f0800ce3   movw      r8, #0xc0f0
a04a231c  78704ae3   movt      r7, #0xa078
a04a2320  78804ae3   movt      r8, #0xa078
a04a2324  4ff07ff5   dsb       sy
a04a2328  04005be1   cmp       fp, r4
a04a232c  0400003a   blo       #0xa04a2344
a04a2330  0430a0e1   mov       r3, r4
a04a2334  3a3f07ee   mcr       p15, #0, r3, c7, c10, #1
a04a2338  203083e2   add       r3, r3, #0x20
a04a233c  0b0053e1   cmp       r3, fp
a04a2340  fbffff9a   bls       #0xa04a2334
a04a2344  4ff07ff5   dsb       sy
a04a2348  0400a0e1   mov       r0, r4
a04a234c  6a0700eb   bl        #0xa04a40fc
a04a2350  000050e3   cmp       r0, #0
a04a2354  1c00000a   beq       #0xa04a23cc
a04a2358  01408be2   add       r4, fp, #1
a04a235c  01ba8be2   add       fp, fp, #0x1000
a04a2360  0b0055e1   cmp       r5, fp
a04a2364  eeffff8a   bhi       #0xa04a2324
a04a2368  4ff07ff5   dsb       sy
a04a236c  040055e1   cmp       r5, r4
a04a2370  0400003a   blo       #0xa04a2388
a04a2374  0430a0e1   mov       r3, r4
a04a2378  3a3f07ee   mcr       p15, #0, r3, c7, c10, #1
a04a237c  203083e2   add       r3, r3, #0x20
a04a2380  030055e1   cmp       r5, r3
a04a2384  fbffff2a   bhs       #0xa04a2378
a04a2388  4ff07ff5   dsb       sy
