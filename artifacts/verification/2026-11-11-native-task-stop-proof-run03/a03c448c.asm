a03bfe70 10402de9 push {r4, lr}
a03bfe74 0040a0e1 mov r4, r0
a03bfe78 4c0500eb bl #0xa03c13b0
a03bfe7c 303094e5 ldr r3, [r4, #0x30]
a03bfe80 013043e2 sub r3, r3, #1
a03bfe84 010053e3 cmp r3, #1
a03bfe88 0200009a bls #0xa03bfe98
a03bfe8c 650500eb bl #0xa03c1428
a03bfe90 1100a0e3 mov r0, #0x11
a03bfe94 1080bde8 pop {r4, pc}
a03bfe98 fc2206e3 movw r2, #0x62fc
a03bfe9c 0030a0e3 mov r3, #0
a03bfea0 79214ae3 movt r2, #0xa179
a03bfea4 003084e5 str r3, [r4]
a03bfea8 003092e5 ldr r3, [r2]
a03bfeac 0010a0e1 mov r1, r0
a03bfeb0 013043e2 sub r3, r3, #1
a03bfeb4 000053e3 cmp r3, #0
a03bfeb8 003082e5 str r3, [r2]
a03bfebc 0c00000a beq #0xa03bfef4
a03bfec0 043306e3 movw r3, #0x6304
a03bfec4 8c2094e5 ldr r2, [r4, #0x8c]
a03bfec8 79314ae3 movt r3, #0xa179
a03bfecc 900094e5 ldr r0, [r4, #0x90]
a03bfed0 00c093e5 ldr ip, [r3]
a03bfed4 900082e5 str r0, [r2, #0x90]
a03bfed8 04005ce1 cmp ip, r4
a03bfedc 8c2080e5 str r2, [r0, #0x8c]
a03bfee0 00208305 streq r2, [r3]
a03bfee4 0100a0e1 mov r0, r1
a03bfee8 4e0500eb bl #0xa03c1428
a03bfeec 0000a0e3 mov r0, #0
a03bfef0 1080bde8 pop {r4, pc}
a03bfef4 042306e3 movw r2, #0x6304
a03bfef8 79214ae3 movt r2, #0xa179
a03bfefc 003082e5 str r3, [r2]
a03bff00 f7ffffea b #0xa03bfee4
a03c448c 10402de9 push {r4, lr}
a03c4490 0040a0e1 mov r4, r0
a03c4494 1bf2ffeb bl #0xa03c0d08
a03c4498 000050e3 cmp r0, #0
a03c449c 0100000a beq #0xa03c44a8
a03c44a0 1300a0e3 mov r0, #0x13
a03c44a4 1080bde8 pop {r4, pc}
a03c44a8 000054e3 cmp r4, #0
a03c44ac 0400000a beq #0xa03c44c4
a03c44b0 002094e5 ldr r2, [r4]
a03c44b4 443205e3 movw r3, #0x5244
a03c44b8 483445e3 movt r3, #0x5448
a03c44bc 030052e1 cmp r2, r3
a03c44c0 0100000a beq #0xa03c44cc
a03c44c4 0e00a0e3 mov r0, #0xe
a03c44c8 1080bde8 pop {r4, pc}
a03c44cc 0400a0e1 mov r0, r4
a03c44d0 1040bde8 pop {r4, lr}
a03c44d4 65eeffea b #0xa03bfe70
