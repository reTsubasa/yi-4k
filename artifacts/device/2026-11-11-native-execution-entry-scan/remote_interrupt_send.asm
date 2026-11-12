a0482f3c 70402de9 push {r4, r5, r6, lr}
a0482f40 0050a0e1 mov r5, r0
a0482f44 a00b06e3 movw r0, #0x6ba0
a0482f48 10d04de2 sub sp, sp, #0x10
a0482f4c 0160a0e1 mov r6, r1
a0482f50 a3014ae3 movt r0, #0xa1a3
a0482f54 0010e0e3 mvn r1, #0
a0482f58 0240a0e1 mov r4, r2
a0482f5c 42e5fceb bl #0xa03bc46c
a0482f60 000050e3 cmp r0, #0
a0482f64 1600001a bne #0xa0482fc4
a0482f68 04008de2 add r0, sp, #4
a0482f6c 877e00eb bl #0xa04a2990
a0482f70 020056e3 cmp r6, #2
a0482f74 0e00000a beq #0xa0482fb4
a0482f78 010056e3 cmp r6, #1
a0482f7c 0c40dd05 ldrbeq r4, [sp, #0xc]
a0482f80 1644e001 mvneq r4, r6, lsl r4
a0482f84 0410a0e1 mov r1, r4
a0482f88 0500a0e1 mov r0, r5
a0482f8c 305100eb bl #0xa0497454
a0482f90 0500a0e1 mov r0, r5
a0482f94 a35100eb bl #0xa0497628
a0482f98 0040a0e1 mov r4, r0
a0482f9c a00b06e3 movw r0, #0x6ba0
a0482fa0 a3014ae3 movt r0, #0xa1a3
a0482fa4 3be5fceb bl #0xa03bc498
a0482fa8 0400a0e1 mov r0, r4
a0482fac 10d08de2 add sp, sp, #0x10
a0482fb0 7080bde8 pop {r4, r5, r6, pc}
a0482fb4 0c40dde5 ldrb r4, [sp, #0xc]
a0482fb8 0130a0e3 mov r3, #1
a0482fbc 1344a0e1 lsl r4, r3, r4
a0482fc0 efffffea b #0xa0482f84
a0482fc4 0000e0e3 mvn r0, #0
a0482fc8 f7ffffea b #0xa0482fac
