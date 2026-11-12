a022f07c 38402de9 push {r3, r4, r5, lr}
a022f080 fc4905e3 movw r4, #0x59fc
a022f084 6e404ae3 movt r4, #0xa06e
a022f088 003094e5 ldr r3, [r4]
a022f08c 000053e3 cmp r3, #0
a022f090 0150a003 moveq r5, #1
a022f094 0100001a bne #0xa022f0a0
a022f098 0500a0e1 mov r0, r5
a022f09c 3880bde8 pop {r3, r4, r5, pc}
a022f0a0 20060fe3 movw r0, #0xf620
a022f0a4 42014ae3 movt r0, #0xa142
a022f0a8 fb3406eb bl #0xa03bc49c
a022f0ac 005050e2 subs r5, r0, #0
a022f0b0 1400001a bne #0xa022f108
a022f0b4 e42302e3 movw r2, #0x23e4
a022f0b8 f03302e3 movw r3, #0x23f0
a022f0bc 3a214ae3 movt r2, #0xa13a
a022f0c0 3a314ae3 movt r3, #0xa13a
a022f0c4 001093e5 ldr r1, [r3]
a022f0c8 000092e5 ldr r0, [r2]
a022f0cc 830f0aeb bl #0xa04b2ee0
a022f0d0 0510a0e1 mov r1, r5
a022f0d4 0500a0e1 mov r0, r5
a022f0d8 89120aeb bl #0xa04b3b04
a022f0dc 0100a0e3 mov r0, #1
a022f0e0 48320aeb bl #0xa04bba08
a022f0e4 0500a0e1 mov r0, r5
a022f0e8 ba0e0aeb bl #0xa04b2bd8
a022f0ec 20060fe3 movw r0, #0xf620
a022f0f0 0110a0e3 mov r1, #1
a022f0f4 42014ae3 movt r0, #0xa142
a022f0f8 fa3406eb bl #0xa03bc4e8
a022f0fc 005084e5 str r5, [r4]
a022f100 0500a0e1 mov r0, r5
a022f104 3880bde8 pop {r3, r4, r5, pc}
a022f108 7c3003e3 movw r3, #0x307c
a022f10c e4070fe3 movw r0, #0xf7e4
a022f110 6f304ae3 movt r3, #0xa06f
a022f114 59004ae3 movt r0, #0xa059
a022f118 041093e5 ldr r1, [r3, #4]
a022f11c 0050e0e3 mvn r5, #0
a022f120 f1df01eb bl #0xa02a70ec
a022f124 dbffffea b #0xa022f098
