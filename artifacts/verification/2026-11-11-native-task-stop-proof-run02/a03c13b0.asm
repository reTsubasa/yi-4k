a03c13b0 00300fe1 mrs r3, apsr
a03c13b4 c02083e3 orr r2, r3, #0xc0
a03c13b8 02f02fe1 msr cpsr_fsxc, r2
a03c13bc b02f10ee mrc p15, #0, r2, c0, c0, #5
a03c13c0 032002e2 and r2, r2, #3
a03c13c4 58009fe5 ldr r0, [pc, #0x58]
a03c13c8 081090e5 ldr r1, [r0, #8]
a03c13cc 020051e1 cmp r1, r2
a03c13d0 0e00000a beq #0xa03c1410
a03c13d4 9f1f90e1 ldrex r1, [r0]
a03c13d8 000051e3 cmp r1, #0
a03c13dc 0200000a beq #0xa03c13ec
a03c13e0 03f021e1 msr cpsr_c, r3
a03c13e4 02f020e3 wfe 
a03c13e8 f0ffffea b #0xa03c13b0
a03c13ec 0110a0e3 mov r1, #1
a03c13f0 912f80e1 strex r2, r1, [r0]
a03c13f4 000052e3 cmp r2, #0
a03c13f8 03f02111 msrne cpsr_c, r3
a03c13fc ebffff1a bne #0xa03c13b0
a03c1400 5ff07ff5 dmb sy
a03c1404 b02f10ee mrc p15, #0, r2, c0, c0, #5
a03c1408 032002e2 and r2, r2, #3
a03c140c 082080e5 str r2, [r0, #8]
a03c1410 0c1090e5 ldr r1, [r0, #0xc]
a03c1414 011081e2 add r1, r1, #1
a03c1418 0c1080e5 str r1, [r0, #0xc]
a03c141c 0300a0e1 mov r0, r3
a03c1420 1eff2fe1 bx lr
