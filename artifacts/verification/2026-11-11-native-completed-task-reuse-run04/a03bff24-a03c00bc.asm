a03bff24 00300fe1 mrs r3, apsr
a03bff28 c00083e3 orr r0, r3, #0xc0
a03bff2c 00f02fe1 msr cpsr_fsxc, r0
a03bff30 9ef7ffeb bl #0xa03bddb0
a03bff34 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03bff38 03a00ae2 and sl, sl, #3
a03bff3c 0ac1a0e1 lsl ip, sl, #2
a03bff40 74319fe5 ldr r3, [pc, #0x174]
a03bff44 0c3083e0 add r3, r3, ip
a03bff48 002093e5 ldr r2, [r3]
a03bff4c 012042e2 sub r2, r2, #1
a03bff50 002083e5 str r2, [r3]
a03bff54 000052e3 cmp r2, #0
a03bff58 0300000a beq #0xa03bff6c
a03bff5c 0154bde8 pop {r0, sl, ip, lr}
a03bff60 00f06fe1 msr spsr_fsxc, r0
a03bff64 0f00bde8 pop {r0, r1, r2, r3}
a03bff68 0ef0b0e1 movs pc, lr
a03bff6c 00109de5 ldr r1, [sp]
a03bff70 1f20a0e3 mov r2, #0x1f
a03bff74 021001e0 and r1, r1, r2
a03bff78 120051e3 cmp r1, #0x12
a03bff7c 1100000a beq #0xa03bffc8
a03bff80 38119fe5 ldr r1, [pc, #0x138]
a03bff84 0c1081e0 add r1, r1, ip
a03bff88 000091e5 ldr r0, [r1]
a03bff8c 000050e3 cmp r0, #0
a03bff90 4300000a beq #0xa03c00a4
a03bff94 28319fe5 ldr r3, [pc, #0x128]
a03bff98 082093e5 ldr r2, [r3, #8]
a03bff9c 0a0052e1 cmp r2, sl
a03bffa0 0300001a bne #0xa03bffb4
a03bffa4 1c319fe5 ldr r3, [pc, #0x11c]
a03bffa8 002093e5 ldr r2, [r3]
a03bffac 000052e3 cmp r2, #0
a03bffb0 0400001a bne #0xa03bffc8
a03bffb4 10319fe5 ldr r3, [pc, #0x110]
a03bffb8 0c3083e0 add r3, r3, ip
a03bffbc 002093e5 ldr r2, [r3]
a03bffc0 020050e1 cmp r0, r2
a03bffc4 0300001a bne #0xa03bffd8
a03bffc8 0154bde8 pop {r0, sl, ip, lr}
a03bffcc 00f06fe1 msr spsr_fsxc, r0
a03bffd0 0f00bde8 pop {r0, r1, r2, r3}
a03bffd4 0ef0b0e1 movs pc, lr
a03bffd8 0854bde8 pop {r3, sl, ip, lr}
a03bffdc 0e10a0e1 mov r1, lr
a03bffe0 d320a0e3 mov r2, #0xd3
a03bffe4 02f02fe1 msr cpsr_fsxc, r2
a03bffe8 04102de5 str r1, [sp, #-4]!
a03bffec f05f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, ip, lr}
a03bfff0 0340a0e1 mov r4, r3
a03bfff4 d120a0e3 mov r2, #0xd1
a03bfff8 02f02fe1 msr cpsr_fsxc, r2
a03bfffc 0f00bde8 pop {r0, r1, r2, r3}
a03c0000 d350a0e3 mov r5, #0xd3
a03c0004 05f02fe1 msr cpsr_fsxc, r5
a03c0008 0f002de9 push {r0, r1, r2, r3}
a03c000c b0af10ee mrc p15, #0, sl, c0, c0, #5
a03c0010 03a00ae2 and sl, sl, #3
a03c0014 0ac1a0e1 lsl ip, sl, #2
a03c0018 a0109fe5 ldr r1, [pc, #0xa0]
a03c001c 0c1081e0 add r1, r1, ip
a03c0020 000091e5 ldr r0, [r1]
a03c0024 a02090e5 ldr r2, [r0, #0xa0]
a03c0028 000052e3 cmp r2, #0
a03c002c 0300000a beq #0xa03c0040
a03c0030 102af1ee vmrs r2, fpscr
a03c0034 04202de5 str r2, [sp, #-4]!
a03c0038 200b6ded vpush {d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, d30, d31}
a03c003c 200b2ded vpush {d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15}
a03c0040 0130a0e3 mov r3, #1
a03c0044 18002de9 push {r3, r4}
a03c0048 08d080e5 str sp, [r0, #8]
a03c004c 2040c4e3 bic r4, r4, #0x20
a03c0050 c03084e3 orr r3, r4, #0xc0
a03c0054 03f02fe1 msr cpsr_fsxc, r3
a03c0058 70309fe5 ldr r3, [pc, #0x70]
a03c005c 002093e5 ldr r2, [r3]
a03c0060 000052e3 cmp r2, #0
a03c0064 fcffff1a bne #0xa03c005c
a03c0068 64309fe5 ldr r3, [pc, #0x64]
a03c006c 0c3083e0 add r3, r3, ip
a03c0070 002093e5 ldr r2, [r3]
a03c0074 000052e3 cmp r2, #0
a03c0078 0200000a beq #0xa03c0088
a03c007c 182080e5 str r2, [r0, #0x18]
a03c0080 0020a0e3 mov r2, #0
a03c0084 002083e5 str r2, [r3]
a03c0088 0020a0e3 mov r2, #0
a03c008c 002081e5 str r2, [r1]
a03c0090 982090e5 ldr r2, [r0, #0x98]
a03c0094 022982e3 orr r2, r2, #0x8000
a03c0098 5ff07ff5 dmb sy
a03c009c 982080e5 str r2, [r0, #0x98]
a03c00a0 130200ea b #0xa03c08f4
a03c00a4 20d08de2 add sp, sp, #0x20
a03c00a8 00300fe1 mrs r3, apsr
a03c00ac 1f30c3e3 bic r3, r3, #0x1f
a03c00b0 133083e3 orr r3, r3, #0x13
a03c00b4 03f02fe1 msr cpsr_fsxc, r3
a03c00b8 0d0200ea b #0xa03c08f4
