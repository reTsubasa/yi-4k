a0238170 push {r4, r5, r6, r7, lr}
a0238174 movw r4, #0x7b8
a0238178 movt r4, #0xa143
a023817c sub sp, sp, #0x14
a0238180 ldrb r1, [r4]
a0238184 cmp r1, #0
a0238188 bne #0xa0238298
a023818c movw r0, #0x74c
a0238190 mov r2, #0x6c
a0238194 movt r0, #0xa143
a0238198 blx #0xa04f8dec
a023819c movw r0, #0x1024
a02381a0 movt r0, #0xa05a
a02381a4 bl #0xa02a70ec
a02381a8 mov r2, #0x24
a02381ac add r0, r4, #0x110
a02381b0 add r1, r4, #0x14c
a02381b4 mov r3, #4
a02381b8 bl #0xa03bc534
a02381bc subs r2, r0, #0
a02381c0 bne #0xa02382a0
a02381c4 movw r5, #0x307c
a02381c8 movw r0, #0x1058
a02381cc movt r5, #0xa06f
a02381d0 movt r0, #0xa05a
a02381d4 ldr r1, [r5, #8]
a02381d8 bl #0xa02a70ec
a02381dc add r0, r4, #0xdc
a02381e0 bl #0xa03bc458
a02381e4 subs r6, r0, #0
a02381e8 bne #0xa02382c0
a02381ec movw r0, #0x10d4
a02381f0 ldr r1, [r5, #8]
a02381f4 movt r0, #0xa05a
a02381f8 mov r7, #1
a02381fc bl #0xa02a70ec
a0238200 movw r0, #0x1110
a0238204 ldr r1, [r5, #8]
a0238208 mov r2, #0x88
a023820c mov r3, #0x8000
a0238210 movt r0, #0xa05a
a0238214 bl #0xa02a70ec
a0238218 movw r2, #0xa14
a023821c mov r0, #0x8000
a0238220 movt r2, #0xa143
a0238224 movw r1, #0x115c
a0238228 movw r3, #0x809c
a023822c str r6, [sp]
a0238230 str r2, [sp, #4]
a0238234 movt r1, #0xa05a
a0238238 str r0, [sp, #8]
a023823c movt r3, #0xa023
a0238240 str r7, [sp, #0xc]
a0238244 add r0, r4, #4
a0238248 mov r2, #0x88
a023824c bl #0xa03bc2bc
a0238250 subs r6, r0, #0
a0238254 bne #0xa02382dc
a0238258 movw r0, #0x11ac
a023825c ldr r1, [r5, #8]
a0238260 movt r0, #0xa05a
a0238264 bl #0xa02a70ec
a0238268 mov r0, #1
a023826c mov r1, r6
a0238270 mov r2, r6
a0238274 movt r0, #0xb001
a0238278 strb r7, [r4]
a023827c bl #0xa01e659c
a0238280 movw r0, #0x11e8
a0238284 movt r0, #0xa05a
a0238288 bl #0xa02a70ec
a023828c mov r0, r6
a0238290 add sp, sp, #0x14
a0238294 pop {r4, r5, r6, r7, pc}
a0238298 mvn r0, #0
a023829c b #0xa0238290
a02382a0 movw r3, #0x307c
a02382a4 movw r0, #0x1094
a02382a8 movt r3, #0xa06f
a02382ac movt r0, #0xa05a
a02382b0 ldr r1, [r3, #4]
a02382b4 bl #0xa02a70ec
a02382b8 mvn r0, #0
a02382bc b #0xa0238290
a02382c0 movw r0, #0x116c
a02382c4 ldr r1, [r5, #4]
a02382c8 mov r2, r6
a02382cc movt r0, #0xa05a
a02382d0 bl #0xa02a70ec
a02382d4 mvn r0, #0
a02382d8 b #0xa0238290
a02382dc movw r0, #0x121c
a02382e0 ldr r1, [r5, #4]
a02382e4 mov r2, r6
a02382e8 movt r0, #0xa05a
a02382ec bl #0xa02a70ec
a02382f0 mvn r0, #0
a02382f4 b #0xa0238290
