a03c0d4c 00300fe1 mrs r3, apsr
a03c0d50 c02083e3 orr r2, r3, #0xc0
a03c0d54 02f02fe1 msr cpsr_fsxc, r2
a03c0d58 b02f10ee mrc p15, #0, r2, c0, c0, #5
a03c0d5c 032002e2 and r2, r2, #3
a03c0d60 0221a0e1 lsl r2, r2, #2
a03c0d64 0c109fe5 ldr r1, [pc, #0xc]
a03c0d68 021081e0 add r1, r1, r2
a03c0d6c 000091e5 ldr r0, [r1]
a03c0d70 03f021e1 msr cpsr_c, r3
a03c0d74 1eff2fe1 bx lr
