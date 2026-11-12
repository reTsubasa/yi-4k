a029e1a4 010050e3 cmp      r0, #1
a029e1a8 f0412de9 push     {r4, r5, r6, r7, r8, lr}
a029e1ac 0080a0e1 mov      r8, r0
a029e1b0 0170a0e1 mov      r7, r1
a029e1b4 704003e3 movw     r4, #0x3070
a029e1b8 0260a0e1 mov      r6, r2
a029e1bc 1600000a beq      #0xa029e21c
a029e1c0 045091e5 ldr      r5, [r1, #4]
a029e1c4 6f404ae3 movt     r4, #0xa06f
a029e1c8 020000ea b        #0xa029e1d8
a029e1cc 084094e5 ldr      r4, [r4, #8]
a029e1d0 000054e3 cmp      r4, #0
a029e1d4 0a00000a beq      #0xa029e204
a029e1d8 0500a0e1 mov      r0, r5
a029e1dc 001094e5 ldr      r1, [r4]
a029e1e0 576d09fa blx      #0xa04f9744
a029e1e4 000050e3 cmp      r0, #0
a029e1e8 f7ffff1a bne      #0xa029e1cc
a029e1ec 043094e5 ldr      r3, [r4, #4]
a029e1f0 010048e2 sub      r0, r8, #1
a029e1f4 041087e2 add      r1, r7, #4
a029e1f8 0620a0e1 mov      r2, r6
a029e1fc f041bde8 pop      {r4, r5, r6, r7, r8, lr}
a029e200 13ff2fe1 bx       r3
a029e204 c4090ee3 movw     r0, #0xe9c4
a029e208 0510a0e1 mov      r1, r5
a029e20c 5a004ae3 movt     r0, #0xa05a
a029e210 36ff2fe1 blx      r6
a029e214 0000a0e3 mov      r0, #0
a029e218 f081bde8 pop      {r4, r5, r6, r7, r8, pc}
a029e21c 6f404ae3 movt     r4, #0xa06f
a029e220 041081e2 add      r1, r1, #4
a029e224 0000a0e3 mov      r0, #0
a029e228 043094e5 ldr      r3, [r4, #4]
a029e22c 33ff2fe1 blx      r3
a029e230 b8070ae3 movw     r0, #0xa7b8
a029e234 56004ae3 movt     r0, #0xa056
a029e238 36ff2fe1 blx      r6
a029e23c 6c070ae3 movw     r0, #0xa76c
a029e240 001094e5 ldr      r1, [r4]
a029e244 56004ae3 movt     r0, #0xa056
a029e248 36ff2fe1 blx      r6
a029e24c 084094e5 ldr      r4, [r4, #8]
a029e250 000054e3 cmp      r4, #0
a029e254 f8ffff1a bne      #0xa029e23c
a029e258 0000a0e3 mov      r0, #0
a029e25c f081bde8 pop      {r4, r5, r6, r7, r8, pc}
