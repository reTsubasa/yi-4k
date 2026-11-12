a01e5ce8 38402de9 push {r3, r4, r5, lr}
a01e5cec 0010e0e3 mvn r1, #0
a01e5cf0 48409fe5 ldr r4, [pc, #0x48]
a01e5cf4 0050a0e1 mov r5, r0
a01e5cf8 130e84e2 add r0, r4, #0x130
a01e5cfc da5907eb bl #0xa03bc46c
a01e5d00 000055e3 cmp r5, #0
a01e5d04 0400000a beq #0xa01e5d1c
a01e5d08 130e84e2 add r0, r4, #0x130
a01e5d0c ac5184e5 str r5, [r4, #0x1ac]
a01e5d10 e05907eb bl #0xa03bc498
a01e5d14 0000a0e3 mov r0, #0
a01e5d18 3880bde8 pop {r3, r4, r5, pc}
a01e5d1c a80b0ae3 movw r0, #0xaba8
a01e5d20 d01e0de3 movw r1, #0xded0
a01e5d24 57104ae3 movt r1, #0xa057
a01e5d28 6320a0e3 mov r2, #0x63
a01e5d2c 53004ae3 movt r0, #0xa053
a01e5d30 ed0403eb bl #0xa02a70ec
a01e5d34 fa0503eb bl #0xa02a7524
a01e5d38 c0000cf1 cpsid if
a01e5d3c feffffea b #0xa01e5d3c
