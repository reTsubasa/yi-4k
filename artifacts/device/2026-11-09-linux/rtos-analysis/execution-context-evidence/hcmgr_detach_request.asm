a01e5d44 10402de9 push {r4, lr}
a01e5d48 0010e0e3 mvn r1, #0
a01e5d4c 4c409fe5 ldr r4, [pc, #0x4c]
a01e5d50 130e84e2 add r0, r4, #0x130
a01e5d54 c45907eb bl #0xa03bc46c
a01e5d58 ac3194e5 ldr r3, [r4, #0x1ac]
a01e5d5c 000053e3 cmp r3, #0
a01e5d60 0500000a beq #0xa01e5d7c
a01e5d64 043093e5 ldr r3, [r3, #4]
a01e5d68 33ff2fe1 blx r3
a01e5d6c 130e84e2 add r0, r4, #0x130
a01e5d70 c85907eb bl #0xa03bc498
a01e5d74 0000a0e3 mov r0, #0
a01e5d78 1080bde8 pop {r4, pc}
a01e5d7c a80b0ae3 movw r0, #0xaba8
a01e5d80 b01e0de3 movw r1, #0xdeb0
a01e5d84 57104ae3 movt r1, #0xa057
a01e5d88 7720a0e3 mov r2, #0x77
a01e5d8c 53004ae3 movt r0, #0xa053
a01e5d90 d50403eb bl #0xa02a70ec
a01e5d94 e20503eb bl #0xa02a7524
a01e5d98 c0000cf1 cpsid if
a01e5d9c feffffea b #0xa01e5d9c
