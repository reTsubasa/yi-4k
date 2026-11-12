a0231408 push {r4, r5, lr}
a023140c mov r3, #0
a0231410 sub sp, sp, #0x214
a0231414 movw r4, #0x63f4
a0231418 movw r5, #0x6410
a023141c mov r1, r3
a0231420 add r0, sp, #0x10
a0231424 mov r2, #0x200
a0231428 str r3, [sp, #0xc]
a023142c movt r4, #0xa06e
a0231430 movt r5, #0xa06e
a0231434 blx #0xa04f8dec
a0231438 ldr r3, [r4, #8]
a023143c cmp r3, #1
a0231440 bne #0xa0231464
a0231444 bl #0xa04b3dc8
a0231448 cmp r0, #1
a023144c mov r0, #0x64
a0231450 beq #0xa0231494
a0231454 bl #0xa03bc320
a0231458 ldr r3, [r4, #8]
a023145c cmp r3, #1
a0231460 beq #0xa0231444
a0231464 movw r0, #0xf7d8
a0231468 mov r1, #2
a023146c movt r0, #0xa142
a0231470 bl #0xa03bc4e8
a0231474 movw r0, #0xfe40
a0231478 movw r2, #0xfde4
a023147c movt r2, #0xa059
a0231480 mov r1, #0xa6
a0231484 movt r0, #0xa059
a0231488 bl #0xa02a70ec
a023148c add sp, sp, #0x214
a0231490 pop {r4, r5, pc}
a0231494 mov r1, #0
a0231498 mov r2, #0x200
a023149c add r0, sp, #0x10
a02314a0 blx #0xa04f8dec
a02314a4 add r2, sp, #0xc
a02314a8 add r0, sp, #0x10
a02314ac mov r1, #0x200
a02314b0 bl #0xa04b3e44
a02314b4 subs r3, r0, #0xd
a02314b8 mov r2, r0
a02314bc movne r3, #1
a02314c0 cmp r0, #0
a02314c4 cmpne r0, #0xd
a02314c8 bne #0xa023150c
a02314cc cmp r3, #0
a02314d0 beq #0xa0231438
a02314d4 ldr r3, [r5]
a02314d8 mov r1, #0x77
a02314dc subs r0, r3, #0
a02314e0 blt #0xa0231438
a02314e4 bl #0xa0232518
a02314e8 add r1, sp, #0x10
a02314ec ldr r0, [r5]
a02314f0 ldr r2, [sp, #0xc]
a02314f4 mov r3, #0x3e8
a02314f8 bl #0xa0232bf0
a02314fc ldr r0, [r5]
a0231500 mov r1, #0x77
a0231504 bl #0xa023273c
a0231508 b #0xa0231438
a023150c movw r1, #0x307c
a0231510 movw r0, #0xfe0c
a0231514 movt r1, #0xa06f
a0231518 movw r3, #0xfde4
a023151c ldr r1, [r1, #8]
a0231520 movt r3, #0xa059
a0231524 str r2, [sp]
a0231528 movt r0, #0xa059
a023152c mov r2, #0x92
a0231530 bl #0xa02a70ec
a0231534 b #0xa0231464
