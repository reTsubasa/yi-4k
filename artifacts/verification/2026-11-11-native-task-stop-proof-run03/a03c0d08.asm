a03c0d08 00300fe1 mrs r3, apsr
a03c0d0c c02083e3 orr r2, r3, #0xc0
a03c0d10 02f02fe1 msr cpsr_fsxc, r2
a03c0d14 b02f10ee mrc p15, #0, r2, c0, c0, #5
a03c0d18 032002e2 and r2, r2, #3
a03c0d1c 0221a0e1 lsl r2, r2, #2
a03c0d20 0c109fe5 ldr r1, [pc, #0xc]
a03c0d24 021081e0 add r1, r1, r2
a03c0d28 000091e5 ldr r0, [r1]
a03c0d2c 03f021e1 msr cpsr_c, r3
a03c0d30 1eff2fe1 bx lr
