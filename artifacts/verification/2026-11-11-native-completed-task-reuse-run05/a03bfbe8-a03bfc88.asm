a03bfbe8 0f002de9 push {r0, r1, r2, r3}
a03bfbec 00004fe1 mrs r0, spsr
a03bfbf0 04e04ee2 sub lr, lr, #4
a03bfbf4 01542de9 push {r0, sl, ip, lr}
a03bfbf8 00000fe1 mrs r0, apsr
a03bfbfc c00080e3 orr r0, r0, #0xc0
a03bfc00 00f02fe1 msr cpsr_fsxc, r0
a03bfc04 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03bfc08 03a00ae2 and sl, sl, #3
a03bfc0c 0ac1a0e1 lsl ip, sl, #2
a03bfc10 70309fe5 ldr r3, [pc, #0x70]
a03bfc14 0c3083e0 add r3, r3, ip
a03bfc18 002093e5 ldr r2, [r3]
a03bfc1c 000052e3 cmp r2, #0
a03bfc20 0600000a beq #0xa03bfc40
a03bfc24 012082e2 add r2, r2, #1
a03bfc28 002083e5 str r2, [r3]
a03bfc2c 00a0a0e3 mov sl, #0
a03bfc30 00502de9 push {ip, lr}
a03bfc34 28f8ffeb bl #0xa03bdcdc
a03bfc38 0050bde8 pop {ip, lr}
a03bfc3c 44f1ffea b #0xa03bc154
a03bfc40 012082e2 add r2, r2, #1
a03bfc44 002083e5 str r2, [r3]
a03bfc48 3c109fe5 ldr r1, [pc, #0x3c]
a03bfc4c 0c1081e0 add r1, r1, ip
a03bfc50 000091e5 ldr r0, [r1]
a03bfc54 000050e3 cmp r0, #0
a03bfc58 0400000a beq #0xa03bfc70
a03bfc5c 00a0a0e3 mov sl, #0
a03bfc60 00502de9 push {ip, lr}
a03bfc64 1cf8ffeb bl #0xa03bdcdc
a03bfc68 0050bde8 pop {ip, lr}
a03bfc6c 38f1ffea b #0xa03bc154
a03bfc70 00a0a0e3 mov sl, #0
a03bfc74 00502de9 push {ip, lr}
a03bfc78 17f8ffeb bl #0xa03bdcdc
a03bfc7c 0050bde8 pop {ip, lr}
a03bfc80 20d08de2 add sp, sp, #0x20
a03bfc84 32f1ffea b #0xa03bc154
