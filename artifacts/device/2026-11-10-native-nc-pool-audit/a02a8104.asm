a02a8104 e03a0de3 movw r3, #0xdae0
a02a8108 10402de9 push {r4, lr}
a02a810c 44314ae3 movt r3, #0xa144
a02a8110 08d04de2 sub sp, sp, #8
a02a8114 0020a0e1 mov r2, r0
a02a8118 04108de2 add r1, sp, #4
a02a811c 0040a0e1 mov r4, r0
a02a8120 000093e5 ldr r0, [r3]
a02a8124 6430a0e3 mov r3, #0x64
a02a8128 6b5104eb bl #0xa03bc6dc
a02a812c 001050e2 subs r1, r0, #0
a02a8130 0000a013 movne r0, #0
a02a8134 0300001a bne #0xa02a8148
a02a8138 0420a0e1 mov r2, r4
a02a813c 04009de5 ldr r0, [sp, #4]
a02a8140 294309fa blx #0xa04f8dec
a02a8144 04009de5 ldr r0, [sp, #4]
a02a8148 08d08de2 add sp, sp, #8
a02a814c 1080bde8 pop {r4, pc}
