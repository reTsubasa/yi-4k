; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; cache, mode=ARM; selected range, not guaranteed function boundary
a0498728  1f0010e3   tst       r0, #0x1f
a049872c  30402de9   push      {r4, r5, lr}
a0498730  0040a0e1   mov       r4, r0
a0498734  0cd04de2   sub       sp, sp, #0xc
a0498738  0150a0e1   mov       r5, r1
a049873c  0400000a   beq       #0xa0498754
a0498740  d4360ae3   movw      r3, #0xa6d4
a0498744  a3314ae3   movt      r3, #0xa1a3
a0498748  003093e5   ldr       r3, [r3]
a049874c  000053e3   cmp       r3, #0
a0498750  0400001a   bne       #0xa0498768
a0498754  0400a0e1   mov       r0, r4
a0498758  0510a0e1   mov       r1, r5
a049875c  0cd08de2   add       sp, sp, #0xc
a0498760  3040bde8   pop       {r4, r5, lr}
a0498764  d82600ea   b         #0xa04a22cc
a0498768  c80c0de3   movw      r0, #0xdcc8
a049876c  901c0de3   movw      r1, #0xdc90
a0498770  00e08de5   str       lr, [sp]
a0498774  62104ae3   movt      r1, #0xa062
a0498778  0420a0e1   mov       r2, r4
a049877c  053084e0   add       r3, r4, r5
a0498780  62004ae3   movt      r0, #0xa062
a0498784  583af8eb   bl        #0xa02a70ec
a0498788  f1ffffea   b         #0xa0498754
a049878c  1f0010e3   tst       r0, #0x1f
a0498790  30402de9   push      {r4, r5, lr}
a0498794  0040a0e1   mov       r4, r0
a0498798  0cd04de2   sub       sp, sp, #0xc
a049879c  0150a0e1   mov       r5, r1
a04987a0  0400000a   beq       #0xa04987b8
a04987a4  d4360ae3   movw      r3, #0xa6d4
a04987a8  a3314ae3   movt      r3, #0xa1a3
a04987ac  003093e5   ldr       r3, [r3]
a04987b0  000053e3   cmp       r3, #0
a04987b4  0400001a   bne       #0xa04987cc
a04987b8  0400a0e1   mov       r0, r4
a04987bc  0510a0e1   mov       r1, r5
a04987c0  0cd08de2   add       sp, sp, #0xc
a04987c4  3040bde8   pop       {r4, r5, lr}
a04987c8  1a2600ea   b         #0xa04a2038
a04987cc  c80c0de3   movw      r0, #0xdcc8
a04987d0  a01c0de3   movw      r1, #0xdca0
a04987d4  00e08de5   str       lr, [sp]
a04987d8  62104ae3   movt      r1, #0xa062
a04987dc  0420a0e1   mov       r2, r4
a04987e0  053084e0   add       r3, r4, r5
a04987e4  62004ae3   movt      r0, #0xa062
a04987e8  3f3af8eb   bl        #0xa02a70ec
a04987ec  f1ffffea   b         #0xa04987b8
a04987f0  1f0010e3   tst       r0, #0x1f
a04987f4  30402de9   push      {r4, r5, lr}
a04987f8  0040a0e1   mov       r4, r0
a04987fc  0cd04de2   sub       sp, sp, #0xc
a0498800  0150a0e1   mov       r5, r1
a0498804  0400000a   beq       #0xa049881c
a0498808  d4360ae3   movw      r3, #0xa6d4
a049880c  a3314ae3   movt      r3, #0xa1a3
a0498810  003093e5   ldr       r3, [r3]
a0498814  000053e3   cmp       r3, #0
a0498818  0400001a   bne       #0xa0498830
a049881c  0400a0e1   mov       r0, r4
a0498820  0510a0e1   mov       r1, r5
a0498824  0cd08de2   add       sp, sp, #0xc
a0498828  3040bde8   pop       {r4, r5, lr}
a049882c  4d2700ea   b         #0xa04a2568
a0498830  c80c0de3   movw      r0, #0xdcc8
a0498834  b81c0de3   movw      r1, #0xdcb8
a0498838  00e08de5   str       lr, [sp]
a049883c  62104ae3   movt      r1, #0xa062
a0498840  0420a0e1   mov       r2, r4
a0498844  053084e0   add       r3, r4, r5
a0498848  62004ae3   movt      r0, #0xa062
a049884c  263af8eb   bl        #0xa02a70ec
a0498850  f1ffffea   b         #0xa049881c
