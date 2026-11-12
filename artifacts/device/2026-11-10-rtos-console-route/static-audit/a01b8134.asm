a01b8134 push {r4, r5, r6, r7, r8, lr}
a01b8138 mov r4, #0x80
a01b813c sub sp, sp, #0x88
a01b8140 mov r6, r1
a01b8144 mov r5, r0
a01b8148 mov r7, r2
a01b814c add r0, sp, #8
a01b8150 mov r2, r4
a01b8154 mov r1, #0
a01b8158 mov r8, r3
a01b815c blx #0xa04f8dec
a01b8160 cmp r6, #0x7f
a01b8164 bhi #0xa01b8370
a01b8168 mov r0, r5
a01b816c blx #0xa04f99f0
a01b8170 mov r1, r0
a01b8174 mov r0, r5
a01b8178 bl #0xa01b577c
a01b817c subs r6, r0, #0
a01b8180 beq #0xa01b83d0
a01b8184 movw r1, #0xfe08
a01b8188 add r2, sp, #8
a01b818c movt r1, #0xa056
a01b8190 mov r3, r4
a01b8194 bl #0xa01b7e08
a01b8198 movw r0, #0xfe14
a01b819c movw r2, #0x32c
a01b81a0 add r3, sp, #8
a01b81a4 movt r2, #0xa057
a01b81a8 movw r1, #0x216
a01b81ac movt r0, #0xa056
a01b81b0 bl #0xa02a70ec
a01b81b4 mov r1, #0
a01b81b8 mov r2, r4
a01b81bc add r0, sp, #8
a01b81c0 blx #0xa04f8dec
a01b81c4 movw r1, #0xfe3c
a01b81c8 mov r0, r6
a01b81cc movt r1, #0xa056
a01b81d0 bl #0xa01b7d5c
a01b81d4 subs r5, r0, #0
a01b81d8 beq #0xa01b83a4
a01b81dc movw r1, #0xf778
a01b81e0 add r2, sp, #8
a01b81e4 movt r1, #0xa054
a01b81e8 mov r3, r4
a01b81ec bl #0xa01b7e08
a01b81f0 cmp r0, #0
a01b81f4 blt #0xa01b8240
a01b81f8 movw r2, #0x5574
a01b81fc mov r1, r8
a01b8200 movt r2, #0xa063
a01b8204 add r3, sp, #8
a01b8208 mov r0, r7
a01b820c blx #0xa04f93c4
a01b8210 movw r0, #0xfe78
a01b8214 movw r2, #0x32c
a01b8218 movt r2, #0xa057
a01b821c movw r1, #0x223
a01b8220 str r7, [sp]
a01b8224 movt r0, #0xa056
a01b8228 add r3, sp, #8
a01b822c bl #0xa02a70ec
a01b8230 add r0, sp, #8
a01b8234 mov r2, r4
a01b8238 mov r1, #0
a01b823c blx #0xa04f8dec
a01b8240 movw r1, #0xfd88
a01b8244 mov r0, r5
a01b8248 movt r1, #0xa056
a01b824c add r2, sp, #8
a01b8250 mov r3, #0x80
a01b8254 bl #0xa01b7e08
a01b8258 cmp r0, #0
a01b825c blt #0xa01b828c
a01b8260 movw r0, #0xfea4
a01b8264 movw r2, #0x32c
a01b8268 movt r2, #0xa057
a01b826c movw r1, #0x229
a01b8270 movt r0, #0xa056
a01b8274 add r3, sp, #8
a01b8278 bl #0xa02a70ec
a01b827c add r0, sp, #8
a01b8280 mov r1, #0
a01b8284 mov r2, #0x80
a01b8288 blx #0xa04f8dec
a01b828c movw r1, #0xfec4
a01b8290 mov r0, r5
a01b8294 movt r1, #0xa056
a01b8298 add r2, sp, #8
a01b829c mov r3, #0x80
a01b82a0 bl #0xa01b7e08
a01b82a4 cmp r0, #0
a01b82a8 blt #0xa01b82f8
a01b82ac movw r2, #0x5574
a01b82b0 ldr r1, [sp, #0xa4]
a01b82b4 movt r2, #0xa063
a01b82b8 add r3, sp, #8
a01b82bc ldr r0, [sp, #0xa0]
a01b82c0 blx #0xa04f93c4
a01b82c4 ldr r3, [sp, #0xa0]
a01b82c8 movw r0, #0xfec8
a01b82cc movw r2, #0x32c
a01b82d0 movw r1, #0x22f
a01b82d4 movt r2, #0xa057
a01b82d8 movt r0, #0xa056
a01b82dc str r3, [sp]
a01b82e0 add r3, sp, #8
a01b82e4 bl #0xa02a70ec
a01b82e8 add r0, sp, #8
a01b82ec mov r1, #0
a01b82f0 mov r2, #0x80
a01b82f4 blx #0xa04f8dec
a01b82f8 movw r1, #0xfd94
a01b82fc mov r0, r5
a01b8300 movt r1, #0xa056
a01b8304 add r2, sp, #8
a01b8308 mov r3, #0x80
a01b830c bl #0xa01b7e08
a01b8310 cmp r0, #0
a01b8314 blt #0xa01b8344
a01b8318 movw r0, #0xfef8
a01b831c movw r2, #0x32c
a01b8320 movt r2, #0xa057
a01b8324 mov r1, #0x234
a01b8328 movt r0, #0xa056
a01b832c add r3, sp, #8
a01b8330 bl #0xa02a70ec
a01b8334 add r0, sp, #8
a01b8338 mov r1, #0
a01b833c mov r2, #0x80
a01b8340 blx #0xa04f8dec
a01b8344 mov r0, r6
a01b8348 bl #0xa01b57bc
a01b834c movw r0, #0xff1c
a01b8350 movw r2, #0x32c
a01b8354 movt r0, #0xa056
a01b8358 movt r2, #0xa057
a01b835c mov r1, #0x238
a01b8360 bl #0xa02a70ec
a01b8364 mov r0, #0
a01b8368 add sp, sp, #0x88
a01b836c pop {r4, r5, r6, r7, r8, pc}
a01b8370 movw r2, #0x307c
a01b8374 movw r0, #0xfda0
a01b8378 movt r2, #0xa06f
a01b837c movw r3, #0x32c
a01b8380 ldr r1, [r2, #8]
a01b8384 movt r0, #0xa056
a01b8388 str r4, [sp]
a01b838c movt r3, #0xa057
a01b8390 str r6, [sp, #4]
a01b8394 movw r2, #0x20b
a01b8398 bl #0xa02a70ec
a01b839c mvn r0, #0
a01b83a0 b #0xa01b8368
a01b83a4 movw r2, #0x307c
a01b83a8 movw r0, #0xfe48
a01b83ac movt r2, #0xa06f
a01b83b0 movw r3, #0x32c
a01b83b4 ldr r1, [r2, #8]
a01b83b8 movt r0, #0xa056
a01b83bc movt r3, #0xa057
a01b83c0 movw r2, #0x21d
a01b83c4 bl #0xa02a70ec
a01b83c8 mvn r0, #2
a01b83cc b #0xa01b8368
a01b83d0 movw r2, #0x307c
a01b83d4 movw r0, #0xfddc
a01b83d8 movt r2, #0xa06f
a01b83dc movw r3, #0x32c
a01b83e0 ldr r1, [r2, #8]
a01b83e4 movt r0, #0xa056
a01b83e8 movt r3, #0xa057
a01b83ec movw r2, #0x212
a01b83f0 bl #0xa02a70ec
a01b83f4 mvn r0, #1
a01b83f8 b #0xa01b8368
