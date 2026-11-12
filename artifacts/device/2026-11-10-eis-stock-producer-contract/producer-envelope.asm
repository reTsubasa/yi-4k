a0311ccc: 0020d5e5 ldrb r2, [r5]
a0311cd0: 40008de2 add r0, sp, #0x40
a0311cd4: 0330d5e5 ldrb r3, [r5, #3]
a0311cd8: 34108de2 add r1, sp, #0x34
a0311cdc: 4020cde5 strb r2, [sp, #0x40]
a0311ce0: 4130cde5 strb r3, [sp, #0x41]
a0311ce4: e5daffeb bl #0xa0308880
a0311ce8: 007050e2 subs r7, r0, #0
a0311cec: 750100ba blt #0xa03122c8
a0311cf0: 0010a0e3 mov r1, #0
a0311cf4: 34009de5 ldr r0, [sp, #0x34]
a0311cf8: dba902eb bl #0xa03bc46c
a0311cfc: 0010d5e5 ldrb r1, [r5]
a0311d00: 000051e3 cmp r1, #0
a0311d04: e500000a beq #0xa03120a0
a0311d08: 010051e3 cmp r1, #1
a0311d0c: d700001a bne #0xa0312070
a0311d10: 3c108de2 add r1, sp, #0x3c
a0311d14: 40008de2 add r0, sp, #0x40
a0311d18: 8ddaffeb bl #0xa0308754
a0311d1c: 3c309de5 ldr r3, [sp, #0x3c]
a0311d20: 7c0a02e3 movw r0, #0x2a7c
a0311d24: 841800e3 movw r1, #0x884
a0311d28: d42800e3 movw r2, #0x8d4
a0311d2c: 050040e3 movt r0, #5
a0311d30: 061040e3 movt r1, #6
a0311d34: 062040e3 movt r2, #6
a0311d38: 1ac983e2 add ip, r3, #0x68000
a0311d3c: 000083e0 add r0, r3, r0
a0311d40: 011083e0 add r1, r3, r1
a0311d44: 022083e0 add r2, r3, r2
a0311d48: 528a83e2 add r8, r3, #0x52000
a0311d4c: 773a83e2 add r3, r3, #0x77000
a0311d50: a98e88e2 add r8, r8, #0xa90
a0311d54: b69f83e2 add sb, r3, #0x2d8
a0311d58: b7af83e2 add sl, r3, #0x2dc
a0311d5c: 56ce8ce2 add ip, ip, #0x560
a0311d60: 64408de5 str r4, [sp, #0x64]
a0311d64: 6cc08de5 str ip, [sp, #0x6c]
a0311d68: 74008de5 str r0, [sp, #0x74]
a0311d6c: 58108de5 str r1, [sp, #0x58]
a0311d70: 60208de5 str r2, [sp, #0x60]
a0311d74: 0030d5e5 ldrb r3, [r5]
a0311d78: 010053e3 cmp r3, #1
a0311d7c: 5e01000a beq #0xa03122fc
a0311d80: 0500a0e1 mov r0, r5
a0311d84: 64108de2 add r1, sp, #0x64
a0311d88: 54208de2 add r2, sp, #0x54
a0311d8c: 696c00eb bl #0xa032cf38
a0311d90: 007050e2 subs r7, r0, #0
a0311d94: 4f01000a beq #0xa03122d8
a0311d98: 34009de5 ldr r0, [sp, #0x34]
a0311d9c: bda902eb bl #0xa03bc498
a0311da0: b80000ea b #0xa0312088
