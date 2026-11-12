a029caf8 c9ffffea b #0xa029ca24
a029cafc 0100a0e3 mov r0, #1
a029cb00 683003e3 movw r3, #0x3068
a029cb04 0d10a0e1 mov r1, sp
a029cb08 6f304ae3 movt r3, #0xa06f
a029cb0c 002093e5 ldr r2, [r3]
a029cb10 34ff2fe1 blx r4
a029cb14 a83306e3 movw r3, #0x63a8
a029cb18 0020a0e1 mov r2, r0
a029cb1c 44314ae3 movt r3, #0xa144
a029cb20 002383e5 str r2, [r3, #0x300]
a029cb24 84d08de2 add sp, sp, #0x84
a029cb28 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a029cb2c 0810a0e1 mov r1, r8
