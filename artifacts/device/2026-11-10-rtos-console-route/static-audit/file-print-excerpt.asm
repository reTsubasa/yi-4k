a029c6dc push {r0, r1, r2, r3}
a029c6e0 push {r4, lr}
a029c6e4 movw r4, #0xbba0
a029c6e8 sub sp, sp, #8
a029c6ec movt r4, #0xa085
a029c6f0 add r3, sp, #0x14
a029c6f4 mov r0, r4
a029c6f8 mov r2, r3
a029c6fc ldr r1, [sp, #0x10]
a029c700 str r3, [sp, #4]
a029c704 blx #0xa04ffa84
a029c708 movw r3, #0x63a8
a029c70c mov r1, #0
a029c710 movt r3, #0xa144
a029c714 mov r2, r0
a029c718 ldr r3, [r3, #0x2fc]
a029c71c strb r1, [r4, r0]
a029c720 mov r0, r4
a029c724 cmp r3, r1
a029c728 beq #0xa029c744
a029c72c mov r1, #1
a029c730 bl #0xa032e0d8
a029c734 add sp, sp, #8
a029c738 pop {r4, lr}
a029c73c add sp, sp, #0x10
a029c740 bx lr
a029c744 add r1, r2, #1
a029c748 bl #0xa02a7368
