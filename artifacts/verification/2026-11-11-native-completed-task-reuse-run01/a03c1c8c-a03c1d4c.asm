a03c1c8c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c1c90 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03c1c94 03a00ae2 and sl, sl, #3
a03c1c98 0ac1a0e1 lsl ip, sl, #2
a03c1c9c a8309fe5 ldr r3, [pc, #0xa8]
a03c1ca0 0c3083e0 add r3, r3, ip
a03c1ca4 000093e5 ldr r0, [r3]
a03c1ca8 a01090e5 ldr r1, [r0, #0xa0]
a03c1cac 000051e3 cmp r1, #0
a03c1cb0 0300000a beq #0xa03c1cc4
a03c1cb4 104af1ee vmrs r4, fpscr
a03c1cb8 04402de5 str r4, [sp, #-4]!
a03c1cbc 200b6ded vpush {d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31}
a03c1cc0 108b2ded vpush {d8, d9, d10, d11, d12, d13, d14, d15}
a03c1cc4 0040a0e3 mov r4, #0
a03c1cc8 00500fe1 mrs r5, apsr
a03c1ccc 30002de9 push {r4, r5}
a03c1cd0 c02085e3 orr r2, r5, #0xc0
a03c1cd4 02f02fe1 msr cpsr_fsxc, r2
a03c1cd8 09102de9 push {r0, r3, ip}
a03c1cdc d9efffeb bl #0xa03bdc48
a03c1ce0 0910bde8 pop {r0, r3, ip}
a03c1ce4 64209fe5 ldr r2, [pc, #0x64]
a03c1ce8 0c2082e0 add r2, r2, ip
a03c1cec 001092e5 ldr r1, [r2]
a03c1cf0 08d080e5 str sp, [r0, #8]
a03c1cf4 0040a0e3 mov r4, #0
a03c1cf8 000051e3 cmp r1, #0
a03c1cfc 0100000a beq #0xa03c1d08
a03c1d00 004082e5 str r4, [r2]
a03c1d04 181080e5 str r1, [r0, #0x18]
a03c1d08 004083e5 str r4, [r3]
a03c1d0c 982090e5 ldr r2, [r0, #0x98]
a03c1d10 022982e3 orr r2, r2, #0x8000
a03c1d14 5ff07ff5 dmb sy
a03c1d18 982080e5 str r2, [r0, #0x98]
a03c1d1c 30309fe5 ldr r3, [pc, #0x30]
a03c1d20 30109fe5 ldr r1, [pc, #0x30]
a03c1d24 0020a0e3 mov r2, #0
a03c1d28 002081e5 str r2, [r1]
a03c1d2c 0c2083e5 str r2, [r3, #0xc]
a03c1d30 0010e0e3 mvn r1, #0
a03c1d34 081083e5 str r1, [r3, #8]
a03c1d38 5ff07ff5 dmb sy
a03c1d3c 002083e5 str r2, [r3]
a03c1d40 4ff07ff5 dsb sy
a03c1d44 04f020e3 sev 
a03c1d48 e9faffea b #0xa03c08f4
