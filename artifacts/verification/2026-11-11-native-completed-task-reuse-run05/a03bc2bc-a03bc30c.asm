a03bc2bc f0402de9 push {r4, r5, r6, r7, lr}
a03bc2c0 24d04de2 sub sp, sp, #0x24
a03bc2c4 3c709de5 ldr r7, [sp, #0x3c]
a03bc2c8 02c0a0e1 mov ip, r2
a03bc2cc d8e0a0e3 mov lr, #0xd8
a03bc2d0 0040a0e3 mov r4, #0
a03bc2d4 40609de5 ldr r6, [sp, #0x40]
a03bc2d8 44509de5 ldr r5, [sp, #0x44]
a03bc2dc 08208de5 str r2, [sp, #8]
a03bc2e0 0320a0e1 mov r2, r3
a03bc2e4 0cc08de5 str ip, [sp, #0xc]
a03bc2e8 00708de5 str r7, [sp]
a03bc2ec 04608de5 str r6, [sp, #4]
a03bc2f0 14508de5 str r5, [sp, #0x14]
a03bc2f4 10408de5 str r4, [sp, #0x10]
a03bc2f8 18e08de5 str lr, [sp, #0x18]
a03bc2fc 38309de5 ldr r3, [sp, #0x38]
a03bc300 ce1f00eb bl #0xa03c4240
a03bc304 24d08de2 add sp, sp, #0x24
a03bc308 f080bde8 pop {r4, r5, r6, r7, pc}
