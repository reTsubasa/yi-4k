a03c00d8 0f002de9 push {r0, r1, r2, r3}
a03c00dc 00004fe1 mrs r0, spsr
a03c00e0 04e04ee2 sub lr, lr, #4
a03c00e4 01542de9 push {r0, sl, ip, lr}
a03c00e8 b0af10ee mrc p15, #0, sl, c0, c0, #5
a03c00ec 03a00ae2 and sl, sl, #3
a03c00f0 0ac1a0e1 lsl ip, sl, #2
a03c00f4 68309fe5 ldr r3, [pc, #0x68]
a03c00f8 0c3083e0 add r3, r3, ip
a03c00fc 002093e5 ldr r2, [r3]
a03c0100 000052e3 cmp r2, #0
a03c0104 0600000a beq #0xa03c0124
a03c0108 012082e2 add r2, r2, #1
a03c010c 002083e5 str r2, [r3]
a03c0110 00a0a0e3 mov sl, #0
a03c0114 00502de9 push {ip, lr}
a03c0118 eff6ffeb bl #0xa03bdcdc
a03c011c 0050bde8 pop {ip, lr}
a03c0120 0ef0ffea b #0xa03bc160
a03c0124 012082e2 add r2, r2, #1
a03c0128 002083e5 str r2, [r3]
a03c012c 34109fe5 ldr r1, [pc, #0x34]
a03c0130 0c1081e0 add r1, r1, ip
a03c0134 000091e5 ldr r0, [r1]
a03c0138 000050e3 cmp r0, #0
a03c013c 0400000a beq #0xa03c0154
a03c0140 00a0a0e3 mov sl, #0
a03c0144 00502de9 push {ip, lr}
a03c0148 e3f6ffeb bl #0xa03bdcdc
a03c014c 0050bde8 pop {ip, lr}
a03c0150 02f0ffea b #0xa03bc160
a03c0154 00502de9 push {ip, lr}
a03c0158 dff6ffeb bl #0xa03bdcdc
a03c015c 0050bde8 pop {ip, lr}
a03c0160 feefffea b #0xa03bc160
