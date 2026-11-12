a03cadcc f8432de9 push {r3, r4, r5, r6, r7, r8, sb, lr}
a03cadd0 a43c0ae3 movw r3, #0xaca4
a03cadd4 145091e5 ldr r5, [r1, #0x14]
a03cadd8 62304ae3 movt r3, #0xa062
a03caddc 0060a0e1 mov r6, r0
a03cade0 0170a0e1 mov r7, r1
a03cade4 103093e5 ldr r3, [r3, #0x10]
a03cade8 0010e0e3 mvn r1, #0
a03cadec 108085e2 add r8, r5, #0x10
a03cadf0 0240a0e1 mov r4, r2
a03cadf4 0800a0e1 mov r0, r8
a03cadf8 009093e5 ldr sb, [r3]
a03cadfc 9ac5ffeb bl #0xa03bc46c
a03cae00 000056e3 cmp r6, #0
a03cae04 0c309415 ldrne r3, [r4, #0xc]
a03cae08 0120a013 movne r2, #1
a03cae0c 0c008618 stmne r6, {r2, r3}
a03cae10 083094e5 ldr r3, [r4, #8]
a03cae14 000053e3 cmp r3, #0
a03cae18 1300001a bne #0xa03cae6c
a03cae1c 07e0a0e1 mov lr, r7
a03cae20 35ce85e2 add ip, r5, #0x350
a03cae24 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a03cae28 0c60a0e1 mov r6, ip
a03cae2c 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03cae30 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a03cae34 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03cae38 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a03cae3c 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03cae40 07009ee8 ldm lr, {r0, r1, r2}
a03cae44 07008ce8 stm ip, {r0, r1, r2}
a03cae48 e70f85e2 add r0, r5, #0x39c
a03cae4c 6c9385e5 str sb, [r5, #0x36c]
a03cae50 041094e5 ldr r1, [r4, #4]
a03cae54 002094e5 ldr r2, [r4]
a03cae58 0846fbeb bl #0xa029c680
a03cae5c 002094e5 ldr r2, [r4]
a03cae60 0610a0e1 mov r1, r6
a03cae64 080085e2 add r0, r5, #8
a03cae68 a2f6ffeb bl #0xa03c88f8
a03cae6c 0040a0e3 mov r4, #0
a03cae70 0800a0e1 mov r0, r8
a03cae74 144087e5 str r4, [r7, #0x14]
a03cae78 86c5ffeb bl #0xa03bc498
a03cae7c 0400a0e1 mov r0, r4
a03cae80 f883bde8 pop {r3, r4, r5, r6, r7, r8, sb, pc}
