a0231fc8 push {r4, r5, lr}
a0231fcc movw r0, #0x5b8
a0231fd0 movw r2, #0x77c
a0231fd4 movw r5, #0xf9c0
a0231fd8 sub sp, sp, #0x14
a0231fdc mov r4, #0
a0231fe0 movt r0, #0xa05a
a0231fe4 movt r2, #0xa05a
a0231fe8 movw r1, #0x1e2
a0231fec movt r5, #0xa142
a0231ff0 str r4, [sp]
a0231ff4 str r4, [sp, #4]
a0231ff8 str r4, [sp, #8]
a0231ffc str r4, [sp, #0xc]
a0232000 bl #0xa02a70ec
a0232004 ldr r3, [r5]
a0232008 cmp r3, #1
a023200c beq #0xa0232084
a0232010 bl #0xa022f07c
a0232014 mov r0, #4
a0232018 bl #0xa022f168
a023201c cmp r0, #0
a0232020 blt #0xa02320b4
a0232024 mov r1, #4
a0232028 mov r2, #0x46
a023202c mov r3, #0x3000
a0232030 mov r0, sp
a0232034 strb r1, [sp]
a0232038 str r2, [sp, #8]
a023203c str r3, [sp, #4]
a0232040 bl #0xa04b35b0
a0232044 cmp r0, #0
a0232048 blt #0xa02320e0
a023204c bl #0xa023166c
a0232050 cmp r0, #0
a0232054 blt #0xa023210c
a0232058 mov r0, #1
a023205c bl #0xa04b2bd8
a0232060 cmp r0, #0
a0232064 blt #0xa0232138
a0232068 movw r3, #0x63f4
a023206c mov r2, #1
a0232070 movt r3, #0xa06e
a0232074 str r2, [r5]
a0232078 str r2, [r3, #8]
a023207c add sp, sp, #0x14
a0232080 pop {r4, r5, pc}
a0232084 movw r2, #0x307c
a0232088 movw r0, #0x5ec
a023208c movt r2, #0xa06f
a0232090 movw r3, #0x77c
a0232094 ldr r1, [r2, #8]
a0232098 movt r3, #0xa05a
a023209c movw r2, #0x1e6
a02320a0 movt r0, #0xa05a
a02320a4 bl #0xa02a70ec
a02320a8 mov r0, r4
a02320ac add sp, sp, #0x14
a02320b0 pop {r4, r5, pc}
a02320b4 movw r2, #0x307c
a02320b8 movw r0, #0x63c
a02320bc movt r2, #0xa06f
a02320c0 movw r3, #0x77c
a02320c4 ldr r1, [r2, #8]
a02320c8 movt r0, #0xa05a
a02320cc movt r3, #0xa05a
a02320d0 movw r2, #0x1ef
a02320d4 bl #0xa02a70ec
a02320d8 mvn r0, #0
a02320dc b #0xa023207c
a02320e0 movw r2, #0x307c
a02320e4 movw r0, #0x68c
a02320e8 movt r2, #0xa06f
a02320ec movw r3, #0x77c
a02320f0 ldr r1, [r2, #8]
a02320f4 movt r0, #0xa05a
a02320f8 movt r3, #0xa05a
a02320fc movw r2, #0x1fa
a0232100 bl #0xa02a70ec
a0232104 mvn r0, #1
a0232108 b #0xa023207c
a023210c movw r2, #0x307c
a0232110 movw r0, #0x6dc
a0232114 movt r2, #0xa06f
a0232118 movw r3, #0x77c
a023211c ldr r1, [r2, #8]
a0232120 movt r0, #0xa05a
a0232124 movt r3, #0xa05a
a0232128 movw r2, #0x201
a023212c bl #0xa02a70ec
a0232130 mvn r0, #2
a0232134 b #0xa023207c
a0232138 movw r2, #0x307c
a023213c movw r0, #0x724
a0232140 movt r2, #0xa06f
a0232144 movw r3, #0x77c
a0232148 ldr r1, [r2, #8]
a023214c movt r0, #0xa05a
a0232150 movt r3, #0xa05a
a0232154 movw r2, #0x213
a0232158 bl #0xa02a70ec
a023215c mvn r0, #3
a0232160 b #0xa023207c
