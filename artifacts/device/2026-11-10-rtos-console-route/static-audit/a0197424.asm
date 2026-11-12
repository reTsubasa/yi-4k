a0197424 push {r4, r5, lr}
a0197428 sub sp, sp, #0x14
a019742c mov r4, #0
a0197430 mov r5, r0
a0197434 mov r0, sp
a0197438 str r4, [sp]
a019743c str r4, [sp, #4]
a0197440 str r4, [sp, #8]
a0197444 str r4, [sp, #0xc]
a0197448 bl #0xa02a708c
a019744c ldr r3, [sp]
a0197450 cmp r3, r5
a0197454 beq #0xa01974b0
a0197458 cmp r3, #1
a019745c beq #0xa0197510
a0197460 mov r3, #1
a0197464 str r3, [sp]
a0197468 bl #0xa02a6ff0
a019746c cmp r0, r4
a0197470 beq #0xa01974e8
a0197474 movw r3, #0x307c
a0197478 movw r0, #0xffa4
a019747c movt r3, #0xa06f
a0197480 movt r0, #0xa055
a0197484 ldr r1, [r3, #4]
a0197488 bl #0xa02a70ec
a019748c mov r0, sp
a0197490 bl #0xa02a702c
a0197494 movw r0, #0x6618
a0197498 movw r1, #0x6600
a019749c movt r1, #0xa029
a01974a0 movt r0, #0xa029
a01974a4 bl #0xa029de40
a01974a8 add sp, sp, #0x14
a01974ac pop {r4, r5, pc}
a01974b0 movw r1, #0x307c
a01974b4 movw ip, #0xde14
a01974b8 movt ip, #0xa056
a01974bc cmp r3, #0
a01974c0 movw r2, #0xdee4
a01974c4 movt r1, #0xa06f
a01974c8 movw r0, #0xffe0
a01974cc movt r2, #0xa056
a01974d0 ldr r1, [r1, #4]
a01974d4 movne r2, ip
a01974d8 movt r0, #0xa055
a01974dc bl #0xa02a70ec
a01974e0 add sp, sp, #0x14
a01974e4 pop {r4, r5, pc}
a01974e8 movw r0, #0x6600
a01974ec movt r0, #0xa029
a01974f0 bl #0xa02a6fb0
a01974f4 movw r3, #0x307c
a01974f8 movw r0, #0xff7c
a01974fc movt r3, #0xa06f
a0197500 movt r0, #0xa055
a0197504 ldr r1, [r3, #4]
a0197508 bl #0xa02a70ec
a019750c b #0xa019748c
a0197510 mov r0, sp
a0197514 str r4, [sp]
a0197518 bl #0xa02a702c
a019751c movw r3, #0x307c
a0197520 movw r0, #0xffc0
a0197524 movt r3, #0xa06f
a0197528 movt r0, #0xa055
a019752c ldr r1, [r3, #4]
a0197530 bl #0xa02a70ec
a0197534 add sp, sp, #0x14
a0197538 pop {r4, r5, pc}
