a03bceec f8402de9 push {r3, r4, r5, r6, r7, lr}
a03bcef0 0250a0e1 mov r5, r2
a03bcef4 0360a0e1 mov r6, r3
a03bcef8 0170a0e1 mov r7, r1
a03bcefc 3420a0e3 mov r2, #0x34
a03bcf00 0010a0e3 mov r1, #0
a03bcf04 0040a0e1 mov r4, r0
a03bcf08 b7ef04fa blx #0xa04f8dec
a03bcf0c 0330c6e3 bic r3, r6, #3
a03bcf10 ee1e0ee3 movw r1, #0xeeee
a03bcf14 030085e0 add r0, r5, r3
a03bcf18 086043e2 sub r6, r3, #8
a03bcf1c 0020a0e1 mov r2, r0
a03bcf20 02e0a0e3 mov lr, #2
a03bcf24 ff1f4fe3 movt r1, #0xffff
a03bcf28 00c0a0e3 mov ip, #0
a03bcf2c 1c3084e5 str r3, [r4, #0x1c]
a03bcf30 047084e5 str r7, [r4, #4]
a03bcf34 185084e5 str r5, [r4, #0x18]
a03bcf38 105084e5 str r5, [r4, #0x10]
a03bcf3c 145084e5 str r5, [r4, #0x14]
a03bcf40 086084e5 str r6, [r4, #8]
a03bcf44 0ce084e5 str lr, [r4, #0xc]
a03bcf48 044000e5 str r4, [r0, #-4]
a03bcf4c 085022e5 str r5, [r2, #-8]!
a03bcf50 041085e5 str r1, [r5, #4]
a03bcf54 002085e5 str r2, [r5]
a03bcf58 20c084e5 str ip, [r4, #0x20]
a03bcf5c 131100eb bl #0xa03c13b0
a03bcf60 452405e3 movw r2, #0x5445
a03bcf64 b43206e3 movw r3, #0x62b4
a03bcf68 79314ae3 movt r3, #0xa179
a03bcf6c 592244e3 movt r2, #0x4259
a03bcf70 002084e5 str r2, [r4]
a03bcf74 002093e5 ldr r2, [r3]
a03bcf78 000052e3 cmp r2, #0
a03bcf7c 012082e2 add r2, r2, #1
a03bcf80 002083e5 str r2, [r3]
a03bcf84 d43206e3 movw r3, #0x62d4
a03bcf88 0900000a beq #0xa03bcfb4
a03bcf8c 79314ae3 movt r3, #0xa179
a03bcf90 003093e5 ldr r3, [r3]
a03bcf94 302093e5 ldr r2, [r3, #0x30]
a03bcf98 304083e5 str r4, [r3, #0x30]
a03bcf9c 2c4082e5 str r4, [r2, #0x2c]
a03bcfa0 302084e5 str r2, [r4, #0x30]
a03bcfa4 2c3084e5 str r3, [r4, #0x2c]
a03bcfa8 1e1100eb bl #0xa03c1428
a03bcfac 0000a0e3 mov r0, #0
a03bcfb0 f880bde8 pop {r3, r4, r5, r6, r7, pc}
a03bcfb4 79314ae3 movt r3, #0xa179
a03bcfb8 2c4084e5 str r4, [r4, #0x2c]
a03bcfbc 304084e5 str r4, [r4, #0x30]
a03bcfc0 004083e5 str r4, [r3]
a03bcfc4 f7ffffea b #0xa03bcfa8
a03c3524 f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
a03c3528 20409de5 ldr r4, [sp, #0x20]
a03c352c 344054e2 subs r4, r4, #0x34
a03c3530 0140a013 movne r4, #1
a03c3534 000050e3 cmp r0, #0
a03c3538 01408403 orreq r4, r4, #1
a03c353c 000054e3 cmp r4, #0
a03c3540 0100000a beq #0xa03c354c
a03c3544 0200a0e3 mov r0, #2
a03c3548 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03c354c 80a706e3 movw sl, #0x6780
a03c3550 0290a0e1 mov sb, r2
a03c3554 79a14ae3 movt sl, #0xa179
a03c3558 0380a0e1 mov r8, r3
a03c355c 0170a0e1 mov r7, r1
a03c3560 0050a0e1 mov r5, r0
a03c3564 91f7ffeb bl #0xa03c13b0
a03c3568 00309ae5 ldr r3, [sl]
a03c356c 013083e2 add r3, r3, #1
a03c3570 00308ae5 str r3, [sl]
a03c3574 abf7ffeb bl #0xa03c1428
a03c3578 b43206e3 movw r3, #0x62b4
a03c357c d42206e3 movw r2, #0x62d4
a03c3580 79314ae3 movt r3, #0xa179
a03c3584 79214ae3 movt r2, #0xa179
a03c3588 003093e5 ldr r3, [r3]
a03c358c 006092e5 ldr r6, [r2]
a03c3590 000053e3 cmp r3, #0
a03c3594 0400001a bne #0xa03c35ac
a03c3598 0c0000ea b #0xa03c35d0
a03c359c 014084e2 add r4, r4, #1
a03c35a0 2c6096e5 ldr r6, [r6, #0x2c]
a03c35a4 030054e1 cmp r4, r3
a03c35a8 0800000a beq #0xa03c35d0
a03c35ac 060055e1 cmp r5, r6
a03c35b0 f9ffff1a bne #0xa03c359c
a03c35b4 7df7ffeb bl #0xa03c13b0
a03c35b8 00309ae5 ldr r3, [sl]
a03c35bc 013043e2 sub r3, r3, #1
a03c35c0 00308ae5 str r3, [sl]
a03c35c4 97f7ffeb bl #0xa03c1428
a03c35c8 45f8ffeb bl #0xa03c16e4
a03c35cc dcffffea b #0xa03c3544
a03c35d0 76f7ffeb bl #0xa03c13b0
a03c35d4 00309ae5 ldr r3, [sl]
a03c35d8 013043e2 sub r3, r3, #1
a03c35dc 00308ae5 str r3, [sl]
a03c35e0 90f7ffeb bl #0xa03c1428
a03c35e4 3ef8ffeb bl #0xa03c16e4
a03c35e8 060055e1 cmp r5, r6
a03c35ec d4ffff0a beq #0xa03c3544
a03c35f0 000059e3 cmp sb, #0
a03c35f4 0300000a beq #0xa03c3608
a03c35f8 630058e3 cmp r8, #0x63
a03c35fc 0300008a bhi #0xa03c3610
a03c3600 0500a0e3 mov r0, #5
a03c3604 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03c3608 0300a0e3 mov r0, #3
a03c360c f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03c3610 cdf5ffeb bl #0xa03c0d4c
a03c3614 343c06e3 movw r3, #0x6c34
a03c3618 79314ae3 movt r3, #0xa179
a03c361c 000053e1 cmp r3, r0
a03c3620 0700000a beq #0xa03c3644
a03c3624 b7f5ffeb bl #0xa03c0d08
a03c3628 000050e3 cmp r0, #0
a03c362c 0600000a beq #0xa03c364c
a03c3630 b4f5ffeb bl #0xa03c0d08
a03c3634 ef300fe3 movw r3, #0xf0ef
a03c3638 f0304fe3 movt r3, #0xf0f0
a03c363c 030050e1 cmp r0, r3
a03c3640 0100008a bhi #0xa03c364c
a03c3644 1300a0e3 mov r0, #0x13
a03c3648 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03c364c 0500a0e1 mov r0, r5
a03c3650 0710a0e1 mov r1, r7
a03c3654 0920a0e1 mov r2, sb
a03c3658 0830a0e1 mov r3, r8
a03c365c f047bde8 pop {r4, r5, r6, r7, r8, sb, sl, lr}
a03c3660 21e6ffea b #0xa03bceec
