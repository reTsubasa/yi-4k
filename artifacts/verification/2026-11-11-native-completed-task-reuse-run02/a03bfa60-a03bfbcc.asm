a03bfa60 00300fe1 mrs r3, apsr
a03bfa64 c00083e3 orr r0, r3, #0xc0
a03bfa68 00f02fe1 msr cpsr_fsxc, r0
a03bfa6c cff8ffeb bl #0xa03bddb0
a03bfa70 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03bfa74 03a00ae2 and sl, sl, #3
a03bfa78 0ac1a0e1 lsl ip, sl, #2
a03bfa7c 48319fe5 ldr r3, [pc, #0x148]
a03bfa80 0c3083e0 add r3, r3, ip
a03bfa84 002093e5 ldr r2, [r3]
a03bfa88 012042e2 sub r2, r2, #1
a03bfa8c 002083e5 str r2, [r3]
a03bfa90 000052e3 cmp r2, #0
a03bfa94 0300000a beq #0xa03bfaa8
a03bfa98 0154bde8 pop {r0, sl, ip, lr}
a03bfa9c 00f06fe1 msr spsr_fsxc, r0
a03bfaa0 0f00bde8 pop {r0, r1, r2, r3}
a03bfaa4 0ef0b0e1 movs pc, lr
a03bfaa8 20119fe5 ldr r1, [pc, #0x120]
a03bfaac 0c1081e0 add r1, r1, ip
a03bfab0 000091e5 ldr r0, [r1]
a03bfab4 000050e3 cmp r0, #0
a03bfab8 4000000a beq #0xa03bfbc0
a03bfabc 10319fe5 ldr r3, [pc, #0x110]
a03bfac0 082093e5 ldr r2, [r3, #8]
a03bfac4 0a0052e1 cmp r2, sl
a03bfac8 0300001a bne #0xa03bfadc
a03bfacc 04319fe5 ldr r3, [pc, #0x104]
a03bfad0 002093e5 ldr r2, [r3]
a03bfad4 000052e3 cmp r2, #0
a03bfad8 0400001a bne #0xa03bfaf0
a03bfadc f8309fe5 ldr r3, [pc, #0xf8]
a03bfae0 0c3083e0 add r3, r3, ip
a03bfae4 002093e5 ldr r2, [r3]
a03bfae8 020050e1 cmp r0, r2
a03bfaec 0300001a bne #0xa03bfb00
a03bfaf0 0154bde8 pop {r0, sl, ip, lr}
a03bfaf4 00f06fe1 msr spsr_fsxc, r0
a03bfaf8 0f00bde8 pop {r0, r1, r2, r3}
a03bfafc 0ef0b0e1 movs pc, lr
a03bfb00 0854bde8 pop {r3, sl, ip, lr}
a03bfb04 0e10a0e1 mov r1, lr
a03bfb08 d320a0e3 mov r2, #0xd3
a03bfb0c 02f021e1 msr cpsr_c, r2
a03bfb10 04102de5 str r1, [sp, #-4]!
a03bfb14 f05f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, ip, lr}
a03bfb18 0340a0e1 mov r4, r3
a03bfb1c d220a0e3 mov r2, #0xd2
a03bfb20 02f021e1 msr cpsr_c, r2
a03bfb24 0f00bde8 pop {r0, r1, r2, r3}
a03bfb28 d350a0e3 mov r5, #0xd3
a03bfb2c 05f021e1 msr cpsr_c, r5
a03bfb30 0f002de9 push {r0, r1, r2, r3}
a03bfb34 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03bfb38 03a00ae2 and sl, sl, #3
a03bfb3c 0ac1a0e1 lsl ip, sl, #2
a03bfb40 88109fe5 ldr r1, [pc, #0x88]
a03bfb44 0c1081e0 add r1, r1, ip
a03bfb48 000091e5 ldr r0, [r1]
a03bfb4c a02090e5 ldr r2, [r0, #0xa0]
a03bfb50 000052e3 cmp r2, #0
a03bfb54 0300000a beq #0xa03bfb68
a03bfb58 102af1ee vmrs r2, fpscr
a03bfb5c 04202de5 str r2, [sp, #-4]!
a03bfb60 200b6ded vpush {d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31}
a03bfb64 200b2ded vpush {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
a03bfb68 0130a0e3 mov r3, #1
a03bfb6c 18002de9 push {r3, r4}
a03bfb70 08d080e5 str sp, [r0, #8]
a03bfb74 64309fe5 ldr r3, [pc, #0x64]
a03bfb78 002093e5 ldr r2, [r3]
a03bfb7c 000052e3 cmp r2, #0
a03bfb80 fcffff1a bne #0xa03bfb78
a03bfb84 58309fe5 ldr r3, [pc, #0x58]
a03bfb88 0c3083e0 add r3, r3, ip
a03bfb8c 002093e5 ldr r2, [r3]
a03bfb90 000052e3 cmp r2, #0
a03bfb94 0200000a beq #0xa03bfba4
a03bfb98 182080e5 str r2, [r0, #0x18]
a03bfb9c 0020a0e3 mov r2, #0
a03bfba0 002083e5 str r2, [r3]
a03bfba4 0020a0e3 mov r2, #0
a03bfba8 002081e5 str r2, [r1]
a03bfbac 982090e5 ldr r2, [r0, #0x98]
a03bfbb0 022982e3 orr r2, r2, #0x8000
a03bfbb4 5ff07ff5 dmb sy
a03bfbb8 982080e5 str r2, [r0, #0x98]
a03bfbbc 4c0300ea b #0xa03c08f4
a03bfbc0 d330a0e3 mov r3, #0xd3
a03bfbc4 03f021e1 msr cpsr_c, r3
a03bfbc8 490300ea b #0xa03c08f4
