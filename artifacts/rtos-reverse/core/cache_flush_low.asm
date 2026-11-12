; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; cache_flush_low, mode=ARM; selected range, not guaranteed function boundary
a04a2568  000051e3   cmp       r1, #0
a04a256c  1eff2f01   bxeq      lr
a04a2570  803b0de3   movw      r3, #0xdb80
a04a2574  f04f2de9   push      {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04a2578  62304ae3   movt      r3, #0xa062
a04a257c  14d04de2   sub       sp, sp, #0x14
a04a2580  011041e2   sub       r1, r1, #1
a04a2584  1fb0c0e3   bic       fp, r0, #0x1f
a04a2588  002093e5   ldr       r2, [r3]
a04a258c  006081e0   add       r6, r1, r0
a04a2590  04308de5   str       r3, [sp, #4]
a04a2594  002192e5   ldr       r2, [r2, #0x100]
a04a2598  000052e3   cmp       r2, #0
a04a259c  9000000a   beq       #0xa04a27e4
a04a25a0  20a6e0e1   mvn       sl, r0, lsr #12
a04a25a4  0aa6e0e1   mvn       sl, sl, lsl #12
a04a25a8  0a0056e1   cmp       r6, sl
a04a25ac  4700009a   bls       #0xa04a26d0
a04a25b0  ec700ce3   movw      r7, #0xc0ec
a04a25b4  f0800ce3   movw      r8, #0xc0f0
a04a25b8  78704ae3   movt      r7, #0xa078
a04a25bc  78804ae3   movt      r8, #0xa078
a04a25c0  0b00a0e1   mov       r0, fp
a04a25c4  cc0600eb   bl        #0xa04a40fc
a04a25c8  000050e3   cmp       r0, #0
a04a25cc  3300001a   bne       #0xa04a26a0
a04a25d0  4ff07ff5   dsb       sy
a04a25d4  0b005ae1   cmp       sl, fp
a04a25d8  0400003a   blo       #0xa04a25f0
a04a25dc  0b20a0e1   mov       r2, fp
a04a25e0  3a2f07ee   mcr       p15, #0, r2, c7, c10, #1
a04a25e4  202082e2   add       r2, r2, #0x20
a04a25e8  0a0052e1   cmp       r2, sl
a04a25ec  fbffff9a   bls       #0xa04a25e0
a04a25f0  4ff07ff5   dsb       sy
a04a25f4  0b00a0e1   mov       r0, fp
