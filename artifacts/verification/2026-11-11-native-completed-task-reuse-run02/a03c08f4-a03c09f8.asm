a03c08f4 00200fe1 mrs r2, apsr
a03c08f8 c000c2e3 bic r0, r2, #0xc0
a03c08fc 00f02fe1 msr cpsr_fsxc, r0
a03c0900 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03c0904 03a00ae2 and sl, sl, #3
a03c0908 0ac1a0e1 lsl ip, sl, #2
a03c090c 54119fe5 ldr r1, [pc, #0x154]
a03c0910 0c1081e0 add r1, r1, ip
a03c0914 00200fe1 mrs r2, apsr
a03c0918 c00082e3 orr r0, r2, #0xc0
a03c091c 00f02fe1 msr cpsr_fsxc, r0
a03c0920 000091e5 ldr r0, [r1]
a03c0924 000050e3 cmp r0, #0
a03c0928 0700001a bne #0xa03c094c
a03c092c 00200fe1 mrs r2, apsr
a03c0930 c000c2e3 bic r0, r2, #0xc0
a03c0934 00f02fe1 msr cpsr_fsxc, r0
a03c0938 03f020e3 wfi 
a03c093c 00200fe1 mrs r2, apsr
a03c0940 c00082e3 orr r0, r2, #0xc0
a03c0944 00f02fe1 msr cpsr_fsxc, r0
a03c0948 e9ffffea b #0xa03c08f4
a03c094c 982090e5 ldr r2, [r0, #0x98]
a03c0950 023902e2 and r3, r2, #0x8000
a03c0954 000053e3 cmp r3, #0
a03c0958 e5ffff0a beq #0xa03c08f4
a03c095c 0229c2e3 bic r2, r2, #0x8000
a03c0960 982080e5 str r2, [r0, #0x98]
a03c0964 00119fe5 ldr r1, [pc, #0x100]
a03c0968 0c1081e0 add r1, r1, ip
a03c096c 000081e5 str r0, [r1]
a03c0970 042090e5 ldr r2, [r0, #4]
a03c0974 183090e5 ldr r3, [r0, #0x18]
a03c0978 012082e2 add r2, r2, #1
a03c097c 042080e5 str r2, [r0, #4]
a03c0980 e8209fe5 ldr r2, [pc, #0xe8]
a03c0984 0c2082e0 add r2, r2, ip
a03c0988 08d090e5 ldr sp, [r0, #8]
a03c098c 003082e5 str r3, [r2]
a03c0990 0050a0e1 mov r5, r0
a03c0994 92f4ffeb bl #0xa03bdbe4
a03c0998 0500a0e1 mov r0, r5
a03c099c 3000bde8 pop {r4, r5}
a03c09a0 000054e3 cmp r4, #0
a03c09a4 0800000a beq #0xa03c09cc
a03c09a8 05f06fe1 msr spsr_fsxc, r5
a03c09ac a01090e5 ldr r1, [r0, #0xa0]
a03c09b0 000051e3 cmp r1, #0
a03c09b4 0300000a beq #0xa03c09c8
a03c09b8 200bbdec vpop {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
a03c09bc 200bfdec vpop {d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31}
a03c09c0 04409de4 pop {r4}
a03c09c4 104ae1ee vmsr fpscr, r4
a03c09c8 ffdffde8 ldm sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, sb, sl, fp, ip, lr, pc} ^
a03c09cc 05f02fe1 msr cpsr_fsxc, r5
a03c09d0 a01090e5 ldr r1, [r0, #0xa0]
a03c09d4 000051e3 cmp r1, #0
a03c09d8 0300000a beq #0xa03c09ec
a03c09dc 108bbdec vpop {d8, d9, d10, d11, d12, d13, d14, d15}
a03c09e0 200bfdec vpop {d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31}
a03c09e4 04409de4 pop {r4}
a03c09e8 104ae1ee vmsr fpscr, r4
a03c09ec 05f02fe1 msr cpsr_fsxc, r5
a03c09f0 f04fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c09f4 1eff2fe1 bx lr
