a03c2f00 10402de9 push {r4, lr}
a03c2f04 0040a0e1 mov r4, r0
a03c2f08 28f9ffeb bl #0xa03c13b0
a03c2f0c 182094e5 ldr r2, [r4, #0x18]
a03c2f10 000052e3 cmp r2, #0
a03c2f14 0b00000a beq #0xa03c2f48
a03c2f18 103094e5 ldr r3, [r4, #0x10]
a03c2f1c 030054e1 cmp r4, r3
a03c2f20 0a00000a beq #0xa03c2f50
a03c2f24 141094e5 ldr r1, [r4, #0x14]
a03c2f28 141083e5 str r1, [r3, #0x14]
a03c2f2c 103081e5 str r3, [r1, #0x10]
a03c2f30 001092e5 ldr r1, [r2]
a03c2f34 040051e1 cmp r1, r4
a03c2f38 18208305 streq r2, [r3, #0x18]
a03c2f3c 00308205 streq r3, [r2]
a03c2f40 0030a0e3 mov r3, #0
a03c2f44 183084e5 str r3, [r4, #0x18]
a03c2f48 1040bde8 pop {r4, lr}
a03c2f4c 35f9ffea b #0xa03c1428
a03c2f50 003092e5 ldr r3, [r2]
a03c2f54 040053e1 cmp r3, r4
a03c2f58 0030a003 moveq r3, #0
a03c2f5c 00308205 streq r3, [r2]
a03c2f60 f6ffffea b #0xa03c2f40
