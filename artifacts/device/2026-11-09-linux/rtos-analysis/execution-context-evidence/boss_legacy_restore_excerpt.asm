a03d2040 9c409005 ldreq r4, [r0, #0x9c]
a03d2044 0c309005 ldreq r3, [r0, #0xc]
a03d2048 08209005 ldreq r2, [r0, #8]
a03d204c 04109005 ldreq r1, [r0, #4]
a03d2050 00009005 ldreq r0, [r0]
a03d2054 2100000a beq #0xa03d20e0
a03d2058 c42090e5 ldr r2, [r0, #0xc4]
a03d205c 302f0fee mcr p15, #0, r2, c15, c0, #1
a03d2060 c82090e5 ldr r2, [r0, #0xc8]
a03d2064 cc3090e5 ldr r3, [r0, #0xcc]
a03d2068 122f0aee mcr p15, #0, r2, c10, c2, #0
a03d206c 323f0aee mcr p15, #0, r3, c10, c2, #1
a03d2070 0c229fe5 ldr r2, [pc, #0x20c]
a03d2074 0c3090e5 ldr r3, [r0, #0xc]
a03d2078 023003e0 and r3, r3, r2
a03d207c fc219fe5 ldr r2, [pc, #0x1fc]
a03d2080 030052e1 cmp r2, r3
a03d2084 9c409005 ldreq r4, [r0, #0x9c]
a03d2088 0c309005 ldreq r3, [r0, #0xc]
a03d208c 08209005 ldreq r2, [r0, #8]
a03d2090 04109005 ldreq r1, [r0, #4]
a03d2094 00009005 ldreq r0, [r0]
a03d2098 2000000a beq #0xa03d2120
a03d209c 08f04fe2 sub pc, pc, #8
a03d20a0 107f11ee mrc p15, #0, r7, c1, c0, #0
a03d20a4 e8619fe5 ldr r6, [pc, #0x1e8]
a03d20a8 067087e1 orr r7, r7, r6
a03d20ac 107f01ee mcr p15, #0, r7, c1, c0, #0
a03d20b0 7aff17ee mrc p15, #0, apsr_nzcv, c7, c10, #3
a03d20b4 fdffff1a bne #0xa03d20b0
a03d20b8 9a7f07ee mcr p15, #0, r7, c7, c10, #4
a03d20bc 0070a0e3 mov r7, #0
a03d20c0 104f01ee mcr p15, #0, r4, c1, c0, #0
a03d20c4 157f08ee mcr p15, #0, r7, c8, c5, #0
a03d20c8 157f07ee mcr p15, #0, r7, c7, c5, #0
a03d20cc 02f0a0e1 mov pc, r2
a03d20d0 00000000 andeq r0, r0, r0
a03d20d4 00000000 andeq r0, r0, r0
a03d20d8 00000000 andeq r0, r0, r0
a03d20dc 00000000 andeq r0, r0, r0
a03d20e0 107f11ee mrc p15, #0, r7, c1, c0, #0
a03d20e4 a8619fe5 ldr r6, [pc, #0x1a8]
a03d20e8 067087e1 orr r7, r7, r6
a03d20ec 107f01ee mcr p15, #0, r7, c1, c0, #0
a03d20f0 0070a0e3 mov r7, #0
a03d20f4 9c619fe5 ldr r6, [pc, #0x19c]
a03d20f8 022086e0 add r2, r6, r2
a03d20fc 00000000 andeq r0, r0, r0
a03d2100 104f01ee mcr p15, #0, r4, c1, c0, #0
a03d2104 157f08ee mcr p15, #0, r7, c8, c5, #0
a03d2108 157f07ee mcr p15, #0, r7, c7, c5, #0
a03d210c 02f0a0e1 mov pc, r2
a03d2110 00000000 andeq r0, r0, r0
a03d2114 00000000 andeq r0, r0, r0
a03d2118 00000000 andeq r0, r0, r0
a03d211c 00000000 andeq r0, r0, r0
a03d2120 107f11ee mrc p15, #0, r7, c1, c0, #0
a03d2124 68619fe5 ldr r6, [pc, #0x168]
a03d2128 067087e1 orr r7, r7, r6
a03d212c 107f01ee mcr p15, #0, r7, c1, c0, #0
a03d2130 0070a0e3 mov r7, #0
a03d2134 60619fe5 ldr r6, [pc, #0x160]
a03d2138 022086e0 add r2, r6, r2
a03d213c 00000000 andeq r0, r0, r0
a03d2140 104f01ee mcr p15, #0, r4, c1, c0, #0
a03d2144 157f08ee mcr p15, #0, r7, c8, c5, #0
a03d2148 157f07ee mcr p15, #0, r7, c7, c5, #0
a03d214c 02f0a0e1 mov pc, r2
