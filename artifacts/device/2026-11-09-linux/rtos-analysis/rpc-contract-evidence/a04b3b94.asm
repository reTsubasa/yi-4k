a04b3b94 f0412de9 push {r4, r5, r6, r7, r8, lr}
a04b3b98 10d04de2 sub sp, sp, #0x10
a04b3b9c 2c409de5 ldr r4, [sp, #0x2c]
a04b3ba0 00c0a0e3 mov ip, #0
a04b3ba4 0060a0e1 mov r6, r0
a04b3ba8 0170a0e1 mov r7, r1
a04b3bac 30e09de5 ldr lr, [sp, #0x30]
a04b3bb0 28809de5 ldr r8, [sp, #0x28]
a04b3bb4 38509de5 ldr r5, [sp, #0x38]
a04b3bb8 10408de9 stmib sp, {r4, lr}
a04b3bbc 0cc08de5 str ip, [sp, #0xc]
a04b3bc0 00808de5 str r8, [sp]
a04b3bc4 bc21fceb bl #0xa03bc2bc
a04b3bc8 0510e0e1 mvn r1, r5
a04b3bcc 0040a0e1 mov r4, r0
a04b3bd0 031001e2 and r1, r1, #3
a04b3bd4 0600a0e1 mov r0, r6
a04b3bd8 fe22fceb bl #0xa03bc7d8
a04b3bdc 000054e3 cmp r4, #0
a04b3be0 0500001a bne #0xa04b3bfc
a04b3be4 34309de5 ldr r3, [sp, #0x34]
a04b3be8 010053e3 cmp r3, #1
a04b3bec 0400a011 movne r0, r4
a04b3bf0 0b00000a beq #0xa04b3c24
a04b3bf4 10d08de2 add sp, sp, #0x10
a04b3bf8 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a04b3bfc e80a08e3 movw r0, #0x8ae8
a04b3c00 c81a07e3 movw r1, #0x7ac8
a04b3c04 0720a0e1 mov r2, r7
a04b3c08 0430a0e1 mov r3, r4
a04b3c0c 63104ae3 movt r1, #0xa063
a04b3c10 63004ae3 movt r0, #0xa063
a04b3c14 34cdf7eb bl #0xa02a70ec
a04b3c18 ff00a0e3 mov r0, #0xff
a04b3c1c 10d08de2 add sp, sp, #0x10
a04b3c20 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a04b3c24 0600a0e1 mov r0, r6
a04b3c28 bb21fceb bl #0xa03bc31c
a04b3c2c 0400a0e1 mov r0, r4
a04b3c30 10d08de2 add sp, sp, #0x10
a04b3c34 f081bde8 pop {r4, r5, r6, r7, r8, pc}
