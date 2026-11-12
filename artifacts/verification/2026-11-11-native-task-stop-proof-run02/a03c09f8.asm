a03c09f8 00200fe1 mrs r2, apsr
a03c09fc c00008f1 cpsie if
a03c0a00 b01f10ee mrc p15, #0, r1, c0, c0, #5
a03c0a04 031001e2 and r1, r1, #3
a03c0a08 0111a0e1 lsl r1, r1, #2
a03c0a0c 58009fe5 ldr r0, [pc, #0x58]
a03c0a10 010080e0 add r0, r0, r1
a03c0a14 001090e5 ldr r1, [r0]
a03c0a18 000051e3 cmp r1, #0
a03c0a1c 0100000a beq #0xa03c0a28
a03c0a20 0100a0e3 mov r0, #1
a03c0a24 a00081e5 str r0, [r1, #0xa0]
a03c0a28 02f02fe1 msr cpsr_fsxc, r2
a03c0a2c 1eff2fe1 bx lr
