a03c0a74 70402de9 push {r4, r5, r6, lr}
a03c0a78 b30000eb bl #0xa03c0d4c
a03c0a7c 0040a0e1 mov r4, r0
a03c0a80 dcffffeb bl #0xa03c09f8
a03c0a84 490200eb bl #0xa03c13b0
a03c0a88 c85094e5 ldr r5, [r4, #0xc8]
a03c0a8c 650200eb bl #0xa03c1428
a03c0a90 000055e3 cmp r5, #0
a03c0a94 0200000a beq #0xa03c0aa4
a03c0a98 0400a0e1 mov r0, r4
a03c0a9c 0010a0e3 mov r1, #0
a03c0aa0 35ff2fe1 blx r5
a03c0aa4 443094e5 ldr r3, [r4, #0x44]
a03c0aa8 480094e5 ldr r0, [r4, #0x48]
a03c0aac 33ff2fe1 blx r3
a03c0ab0 1c3306e3 movw r3, #0x631c
a03c0ab4 79314ae3 movt r3, #0xa179
a03c0ab8 003093e5 ldr r3, [r3]
a03c0abc 000053e3 cmp r3, #0
a03c0ac0 0100000a beq #0xa03c0acc
a03c0ac4 0400a0e1 mov r0, r4
a03c0ac8 33ff2fe1 blx r3
a03c0acc 370200eb bl #0xa03c13b0
a03c0ad0 803706e3 movw r3, #0x6780
a03c0ad4 c86094e5 ldr r6, [r4, #0xc8]
a03c0ad8 79314ae3 movt r3, #0xa179
a03c0adc 0150a0e3 mov r5, #1
a03c0ae0 002093e5 ldr r2, [r3]
a03c0ae4 0010a0e3 mov r1, #0
a03c0ae8 305084e5 str r5, [r4, #0x30]
a03c0aec 385084e5 str r5, [r4, #0x38]
a03c0af0 052082e0 add r2, r2, r5
a03c0af4 4c1084e5 str r1, [r4, #0x4c]
a03c0af8 002083e5 str r2, [r3]
a03c0afc 490200eb bl #0xa03c1428
a03c0b00 000056e3 cmp r6, #0
a03c0b04 0200000a beq #0xa03c0b14
a03c0b08 0510a0e1 mov r1, r5
a03c0b0c 0400a0e1 mov r0, r4
a03c0b10 36ff2fe1 blx r6
a03c0b14 0400a0e1 mov r0, r4
a03c0b18 7040bde8 pop {r4, r5, r6, lr}
a03c0b1c 8e0400ea b #0xa03c1d5c
