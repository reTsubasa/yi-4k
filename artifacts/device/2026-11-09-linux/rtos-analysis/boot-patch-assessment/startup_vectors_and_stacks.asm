a01000fc b01f10ee mrc p15, #0, r1, c0, c0, #5
a0100100 031001e2 and r1, r1, #3
a0100104 00000fe1 mrs r0, apsr
a0100108 000051e3 cmp r1, #0
a010010c 1f00c0e3 bic r0, r0, #0x1f
a0100110 d10080e3 orr r0, r0, #0xd1
a0100114 00f021e1 msr cpsr_c, r0
a0100118 18219f05 ldreq r2, [pc, #0x118]
a010011c 18219f15 ldrne r2, [pc, #0x118]
a0100120 00d092e5 ldr sp, [r2]
a0100124 1f00c0e3 bic r0, r0, #0x1f
a0100128 d20080e3 orr r0, r0, #0xd2
a010012c 00f021e1 msr cpsr_c, r0
a0100130 08219f05 ldreq r2, [pc, #0x108]
a0100134 08219f15 ldrne r2, [pc, #0x108]
a0100138 00d092e5 ldr sp, [r2]
a010013c 1f00c0e3 bic r0, r0, #0x1f
a0100140 d70080e3 orr r0, r0, #0xd7
a0100144 00f021e1 msr cpsr_c, r0
a0100148 f8209f05 ldreq r2, [pc, #0xf8]
a010014c f8209f15 ldrne r2, [pc, #0xf8]
a0100150 00d092e5 ldr sp, [r2]
a0100154 1f00c0e3 bic r0, r0, #0x1f
a0100158 db0080e3 orr r0, r0, #0xdb
a010015c 00f021e1 msr cpsr_c, r0
a0100160 e8209f05 ldreq r2, [pc, #0xe8]
a0100164 e8209f15 ldrne r2, [pc, #0xe8]
a0100168 00d092e5 ldr sp, [r2]
a010016c 1f00c0e3 bic r0, r0, #0x1f
a0100170 df0080e3 orr r0, r0, #0xdf
a0100174 00f021e1 msr cpsr_c, r0
a0100178 d8209f05 ldreq r2, [pc, #0xd8]
a010017c d8209f15 ldrne r2, [pc, #0xd8]
a0100180 00d092e5 ldr sp, [r2]
a0100184 1f00c0e3 bic r0, r0, #0x1f
a0100188 d30080e3 orr r0, r0, #0xd3
a010018c 00f021e1 msr cpsr_c, r0
a0100190 c8209f05 ldreq r2, [pc, #0xc8]
a0100194 c8209f15 ldrne r2, [pc, #0xc8]
a0100198 00d092e5 ldr sp, [r2]
a010019c 500f11ee mrc p15, #0, r0, c1, c0, #2
a01001a0 0f0680e3 orr r0, r0, #0xf00000
a01001a4 500f01ee mcr p15, #0, r0, c1, c0, #2
a01001a8 0100a0e3 mov r0, #1
a01001ac 950f07ee mcr p15, #0, r0, c7, c5, #4
a01001b0 0101a0e3 mov r0, #0x40000000
a01001b4 100ae8ee vmsr fpexc, r0
a01001b8 0304a0e3 mov r0, #0x3000000
a01001bc 100ae1ee vmsr fpscr, r0
a01001c0 000051e3 cmp r1, #0
a01001c4 0000000a beq #0xa01001cc
a01001c8 12f00aea b #0xa03bc218
a01001cc 58009fe5 ldr r0, [pc, #0x58]
a01001d0 58109fe5 ldr r1, [pc, #0x58]
a01001d4 0310c1e3 bic r1, r1, #3
a01001d8 041081e2 add r1, r1, #4
a01001dc 0030a0e3 mov r3, #0
a01001e0 0040a0e3 mov r4, #0
a01001e4 0050a0e3 mov r5, #0
a01001e8 0060a0e3 mov r6, #0
a01001ec 0070a0e3 mov r7, #0
a01001f0 0080a0e3 mov r8, #0
a01001f4 0090a0e3 mov sb, #0
a01001f8 00a0a0e3 mov sl, #0
a01001fc 00b0a0e3 mov fp, #0
a0100200 00c0a0e3 mov ip, #0
a0100204 f81fa0e8 stm r0!, {r3, r4, r5, r6, r7, r8, sb, sl, fp, ip}
a0100208 002051e0 subs r2, r1, r0
a010020c 280052e3 cmp r2, #0x28
a0100210 fbffffaa bge #0xa0100204
a0100214 000052e3 cmp r2, #0
a0100218 0200000a beq #0xa0100228
a010021c 0800a0e8 stm r0!, {r3}
a0100220 042052e2 subs r2, r2, #4
a0100224 fcffffca bgt #0xa010021c
a0100228 e0ef0aea b #0xa03bc1b0
a010022c 0030fba0 rscsge r3, fp, r0
