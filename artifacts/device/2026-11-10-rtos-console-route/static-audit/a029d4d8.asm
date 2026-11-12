a029d4d8 push {r4, lr}
a029d4dc sub sp, sp, #0x10
a029d4e0 ldr r4, [pc, #0xc4]
a029d4e4 mvn r3, #0
a029d4e8 mov r1, #3
a029d4ec str r3, [sp]
a029d4f0 mov r2, #0
a029d4f4 ldr r0, [pc, #0xb4]
a029d4f8 add r3, sp, #0xc
a029d4fc bl #0xa03bc4ac
a029d500 ldr r1, [sp, #0xc]
a029d504 ldr r0, [pc, #0xa0]
a029d508 tst r1, #2
a029d50c bne #0xa029d568
a029d510 tst r1, #1
a029d514 beq #0xa029d584
a029d518 blx #0xa04f99f0
a029d51c mov r3, r0
a029d520 movw r1, #0xe4b8
a029d524 cmp r3, #4
a029d528 sub r0, r0, #4
a029d52c movt r1, #0xa05a
a029d530 add r0, r4, r0
a029d534 bls #0xa029d544
a029d538 blx #0xa04f9744
a029d53c cmp r0, #0
a029d540 beq #0xa029d5a0
a029d544 ldr r0, [pc, #0x60]
a029d548 bl #0xa029ccb8
a029d54c mov r1, #1
a029d550 ldr r0, [pc, #0x58]
a029d554 bl #0xa03bc4f0
a029d558 mov r1, #0x10
a029d55c ldr r0, [pc, #0x4c]
a029d560 bl #0xa03bc4e8
a029d564 b #0xa029d4e4
a029d568 movw r0, #0xe4a8
a029d56c movt r0, #0xa05a
a029d570 bl #0xa029d3b4
a029d574 mov r1, #2
a029d578 ldr r0, [pc, #0x30]
a029d57c bl #0xa03bc4f0
a029d580 b #0xa029d4e4
a029d584 movw r0, #0xe4c0
a029d588 movt r0, #0xa05a
a029d58c bl #0xa02a70ec
a029d590 mov r1, #3
a029d594 ldr r0, [pc, #0x14]
a029d598 bl #0xa03bc4f0
a029d59c b #0xa029d4e4
a029d5a0 ldr r0, [pc, #4]
a029d5a4 bl #0xa029d3b4
a029d5a8 b #0xa029d54c
