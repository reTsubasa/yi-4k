
kernel read physical gate
40017ccc movw     r3, #0xffff
40017cd0 movt     r3, #0x3c9f
40017cd4 cmp      r0, r3
40017cd8 bhi      #0x40017ce4
40017cdc mov      r0, #0
40017ce0 bx       lr
40017ce4 movw     r2, #0xdcc0
40017ce8 push     {r4, lr}
40017cec movt     r2, #0x4059
40017cf0 add      r4, r0, r1
40017cf4 ldr      r0, [r2]
40017cf8 sub      r0, r0, #1
40017cfc bl       #0x4001d62c
40017d00 add      r0, r0, #1
40017d04 cmp      r4, r0
40017d08 movhi    r0, #0
40017d0c movls    r0, #1
40017d10 pop      {r4, pc}
40017d14 add      r0, r0, r1, lsr #12
40017d18 cmp      r0, #0x100000
40017d1c movhi    r0, #0
40017d20 movls    r0, #1
40017d24 bx       lr
40017d28 push     {r4, lr}
40017d2c mov      r1, #0

kernel physical translation
4001d530 movw     r2, #0x76d8
4001d534 movt     r2, #0x4055
4001d538 add      r1, r2, #8
4001d53c ldm      r1, {r1, r3, ip}
4001d540 lsl      r3, r3, #0xc
4001d544 cmp      r0, r3
4001d548 blo      #0x4001d558
4001d54c add      ip, r3, ip
4001d550 cmp      ip, r0
4001d554 bhi      #0x4001d620
4001d558 add      r3, r2, #0x20
4001d55c ldm      r3, {r1, r3, ip}
4001d560 lsl      r3, r3, #0xc
4001d564 cmp      r0, r3
4001d568 blo      #0x4001d578
4001d56c add      ip, r3, ip
4001d570 cmp      r0, ip
4001d574 blo      #0x4001d620
4001d578 add      r1, r2, #0x38
4001d57c ldm      r1, {r1, r3, ip}
4001d580 lsl      r3, r3, #0xc
4001d584 cmp      r0, r3
4001d588 blo      #0x4001d598
4001d58c add      ip, r3, ip
4001d590 cmp      r0, ip
4001d594 blo      #0x4001d620
4001d598 add      r3, r2, #0x50
4001d59c ldm      r3, {r1, r3, ip}
4001d5a0 lsl      r3, r3, #0xc
4001d5a4 cmp      r0, r3
4001d5a8 blo      #0x4001d5b8
4001d5ac add      ip, r3, ip
4001d5b0 cmp      r0, ip
4001d5b4 blo      #0x4001d620
4001d5b8 add      r1, r2, #0x68
4001d5bc ldm      r1, {r1, r3, ip}
4001d5c0 lsl      r3, r3, #0xc
4001d5c4 cmp      r0, r3
4001d5c8 blo      #0x4001d5d8
4001d5cc add      ip, r3, ip
4001d5d0 cmp      r0, ip
4001d5d4 blo      #0x4001d620
4001d5d8 add      r3, r2, #0x80
4001d5dc ldm      r3, {r1, r3, ip}
4001d5e0 lsl      r3, r3, #0xc
4001d5e4 cmp      r0, r3
4001d5e8 blo      #0x4001d5f8
4001d5ec add      ip, r3, ip
4001d5f0 cmp      r0, ip
4001d5f4 blo      #0x4001d620
4001d5f8 add      r2, r2, #0x98
4001d5fc ldm      r2, {r1, r3, ip}
4001d600 lsl      r3, r3, #0xc
4001d604 cmp      r3, r0
4001d608 bhi      #0x4001d618
4001d60c add      ip, r3, ip
4001d610 cmp      r0, ip
4001d614 blo      #0x4001d620
4001d618 add      r0, r0, #0x3600000
4001d61c bx       lr
4001d620 add      r0, r1, r0
4001d624 rsb      r0, r3, r0
4001d628 bx       lr

kernel DSP region RPC getter
4002049c push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
400204a0 movw     r4, #0x75c0
400204a4 movt     r4, #0x4058
400204a8 sub      sp, sp, #0x1c
400204ac add      r6, r4, #0x20
400204b0 mov      sl, r0
400204b4 mov      r0, r6
400204b8 mov      r8, r2
400204bc mov      r7, r3
400204c0 mov      sb, r1
400204c4 bl       #0x4001d62c
400204c8 mov      r1, #0x20
400204cc mov      r5, r0
400204d0 mov      r0, r6
400204d4 mov      fp, #1
400204d8 bl       #0x4001c714
400204dc add      r0, sp, #0xc
400204e0 mov      r1, #0xc
400204e4 bl       #0x401f47a0
400204e8 ldr      ip, [r4]
400204ec mov      r6, #0xc
400204f0 add      r3, sp, r6
400204f4 mov      lr, #6
400204f8 str      lr, [sp, #0xc]
400204fc ldr      r2, [ip, #0x104]
40020500 mov      r0, ip
40020504 ldr      r1, [ip, #0x100]
40020508 stm      sp, {r6, fp}
4002050c str      sl, [sp, #0x10]
40020510 str      r5, [sp, #0x14]
40020514 bl       #0x402f3824
40020518 movw     r0, #0x7c30
4002051c movt     r0, #0x4055
40020520 bl       #0x40400754
40020524 mov      r0, r5
40020528 bl       #0x4001d530
4002052c mov      r1, #0x20
40020530 bl       #0x4001c42c
40020534 ldr      r3, [r4, #0x20]
40020538 mov      r0, #0
4002053c str      r3, [sb]
40020540 ldr      r1, [r4, #0x24]
40020544 str      r1, [r8]
40020548 ldr      r2, [r4, #0x28]
4002054c str      r2, [r7]
40020550 add      sp, sp, #0x1c
40020554 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}

kernel DSP mmap
4027f694 push     {r4, r5, r6, r7, lr}
4027f698 movw     r4, #0x26c4
4027f69c movt     r4, #0x405a
4027f6a0 sub      sp, sp, #0xc
4027f6a4 mov      r7, r0
4027f6a8 mov      r5, r1
4027f6ac ldr      r0, [pc, #0xc0]
4027f6b0 bl       #0x403ff7d8
4027f6b4 add      r3, r4, #4
4027f6b8 add      r2, r4, #8
4027f6bc add      r1, r4, #0xc
4027f6c0 mov      r0, #1
4027f6c4 bl       #0x4002049c
4027f6c8 cmp      r0, #0
4027f6cc blt      #0x4027f72c
4027f6d0 ldm      r5, {r1, r6}
4027f6d4 ldr      r3, [r4, #4]
4027f6d8 rsb      r6, r1, r6
4027f6dc cmp      r6, r3
4027f6e0 bne      #0x4027f758
4027f6e4 ldr      r3, [r7, #0x1c]
4027f6e8 ldr      r7, [r4, #8]
4027f6ec ldr      r4, [r5, #0x24]
4027f6f0 tst      r3, #0x1000
4027f6f4 bne      #0x4027f740
4027f6f8 lsr      r2, r7, #0xc
4027f6fc str      r4, [r5, #0x24]
4027f700 mov      r3, r6
4027f704 str      r4, [sp]
4027f708 mov      r0, r5
4027f70c str      r2, [r5, #0x4c]
4027f710 bl       #0x400b11f8
4027f714 and      r4, r0, r0, asr #31
4027f718 ldr      r0, [pc, #0x54]
4027f71c bl       #0x403ff67c
4027f720 mov      r0, r4
4027f724 add      sp, sp, #0xc
4027f728 pop      {r4, r5, r6, r7, pc}
4027f72c movw     r0, #0xaea0
4027f730 mvn      r4, #0x15
4027f734 movt     r0, #0x404c
4027f738 bl       #0x403fcad4
4027f73c b        #0x4027f718
4027f740 movw     r0, #0xaec8
4027f744 bic      r4, r4, #0x3c
4027f748 movt     r0, #0x404c
4027f74c bl       #0x403fcad4
4027f750 ldr      r1, [r5]
4027f754 b        #0x4027f6f8
4027f758 movw     r0, #0xb014
4027f75c mov      r2, r6
4027f760 ldr      r1, [pc, #0x10]
4027f764 movt     r0, #0x404c
4027f768 mvn      r4, #0x15
4027f76c bl       #0x403fcad4
4027f770 b        #0x4027f718
4027f774 subsmi   lr, r6, ip, lsr #32
4027f778 submi    r3, r2, ip, lsl #22
4027f77c push     {r4, r5, lr}
4027f780 sub      sp, sp, #0x14
4027f784 ldr      r0, [pc, #0xdc]
4027f788 mov      r4, r1
4027f78c mov      r5, r2
4027f790 bl       #0x403ff7d8
4027f794 movw     r3, #0x9901
4027f798 movt     r3, #0x800c
4027f79c cmp      r4, r3
4027f7a0 bne      #0x4027f84c

read argument parser
a02a2cfc cmp      r0, #1
a02a2d00 ble      #0xa02a2d5c
a02a2d04 cmp      r0, #2
a02a2d08 push     {r4, r5, r6, lr}
a02a2d0c mov      r6, r3
a02a2d10 mov      r5, r2
a02a2d14 mov      r4, r1
a02a2d18 bne      #0xa02a2d44
a02a2d1c mov      r3, #1
a02a2d20 str      r3, [r6]
a02a2d24 mov      r1, #0
a02a2d28 ldr      r0, [r4, #4]
a02a2d2c mov      r2, r1
a02a2d30 blx      #0xa04fb328
a02a2d34 mov      r3, #0
a02a2d38 str      r0, [r5]
a02a2d3c mov      r0, r3
a02a2d40 pop      {r4, r5, r6, pc}
a02a2d44 mov      r1, #0
a02a2d48 ldr      r0, [r4, #8]
a02a2d4c mov      r2, r1
a02a2d50 blx      #0xa04fb328
a02a2d54 str      r0, [r6]
a02a2d58 b        #0xa02a2d24
a02a2d5c mvn      r3, #0
a02a2d60 mov      r0, r3
a02a2d64 bx       lr

readb
a02a2e58 push     {r4, r5, r6, r7, lr}
a02a2e5c sub      sp, sp, #0xc
a02a2e60 mov      r6, r2
a02a2e64 add      r3, sp, #4
a02a2e68 mov      r2, sp
a02a2e6c mov      r4, r1
a02a2e70 bl       #0xa02a2cfc
a02a2e74 subs     r7, r0, #0
a02a2e78 bne      #0xa02a2f14
a02a2e7c ldr      r3, [sp, #4]
a02a2e80 cmp      r3, #0
a02a2e84 ldrne    r3, [sp]
a02a2e88 movne    r4, r7
a02a2e8c bne      #0xa02a2ec0
a02a2e90 b        #0xa02a2f08
a02a2e94 movw     r0, #0xfde8
a02a2e98 ldrb     r2, [r3]
a02a2e9c movt     r0, #0xa05a
a02a2ea0 blx      r6
a02a2ea4 ldr      r2, [sp, #4]
a02a2ea8 add      r4, r4, #1
a02a2eac ldr      r3, [sp]
a02a2eb0 cmp      r4, r2
a02a2eb4 add      r3, r3, #1
a02a2eb8 str      r3, [sp]
a02a2ebc bhs      #0xa02a2ef4
a02a2ec0 ands     r5, r4, #0xf
a02a2ec4 movw     r0, #0xfdf0
a02a2ec8 movt     r0, #0xa05a
a02a2ecc mov      r1, r3
a02a2ed0 beq      #0xa02a2e94
a02a2ed4 ldrb     r1, [r3]
a02a2ed8 blx      r6
a02a2edc cmp      r5, #0xf
a02a2ee0 bne      #0xa02a2ea4
a02a2ee4 movw     r0, #0x52c
a02a2ee8 movt     r0, #0xa058
a02a2eec blx      r6
a02a2ef0 b        #0xa02a2ea4
a02a2ef4 tst      r4, #0xf
a02a2ef8 beq      #0xa02a2f08
a02a2efc movw     r0, #0x52c
a02a2f00 movt     r0, #0xa058
a02a2f04 blx      r6
a02a2f08 mov      r0, r7
a02a2f0c add      sp, sp, #0xc
a02a2f10 pop      {r4, r5, r6, r7, pc}
a02a2f14 movw     r0, #0xfdcc
a02a2f18 ldr      r1, [r4]
a02a2f1c movt     r0, #0xa05a
a02a2f20 mvn      r7, #0
a02a2f24 blx      r6
a02a2f28 b        #0xa02a2f08

readl
a02a3000 push     {r4, r5, r6, r7, lr}
a02a3004 sub      sp, sp, #0xc
a02a3008 mov      r6, r2
a02a300c add      r3, sp, #4
a02a3010 mov      r2, sp
a02a3014 mov      r4, r1
a02a3018 bl       #0xa02a2cfc
a02a301c subs     r7, r0, #0
a02a3020 bne      #0xa02a30bc
a02a3024 ldr      r3, [sp, #4]
a02a3028 cmp      r3, #0
a02a302c ldrne    r3, [sp]
a02a3030 movne    r4, r7
a02a3034 bne      #0xa02a3068
a02a3038 b        #0xa02a30b0
a02a303c movw     r0, #0xfe08
a02a3040 ldr      r2, [r3]
a02a3044 movt     r0, #0xa05a
a02a3048 blx      r6
a02a304c ldr      r2, [sp, #4]
a02a3050 add      r4, r4, #1
a02a3054 ldr      r3, [sp]
a02a3058 cmp      r4, r2
a02a305c add      r3, r3, #4
a02a3060 str      r3, [sp]
a02a3064 bhs      #0xa02a309c
a02a3068 ands     r5, r4, #3
a02a306c movw     r0, #0xfe10
a02a3070 movt     r0, #0xa05a
a02a3074 mov      r1, r3
a02a3078 beq      #0xa02a303c
a02a307c ldr      r1, [r3]
a02a3080 blx      r6
a02a3084 cmp      r5, #3
a02a3088 bne      #0xa02a304c
a02a308c movw     r0, #0x52c
a02a3090 movt     r0, #0xa058
a02a3094 blx      r6
a02a3098 b        #0xa02a304c
a02a309c tst      r4, #3
a02a30a0 beq      #0xa02a30b0
a02a30a4 movw     r0, #0x52c
a02a30a8 movt     r0, #0xa058
a02a30ac blx      r6
a02a30b0 mov      r0, r7
a02a30b4 add      sp, sp, #0xc
a02a30b8 pop      {r4, r5, r6, r7, pc}
a02a30bc movw     r0, #0xfdcc
a02a30c0 ldr      r1, [r4]
a02a30c4 movt     r0, #0xa05a
a02a30c8 mvn      r7, #0
a02a30cc blx      r6
a02a30d0 b        #0xa02a30b0

BBT marker creation
a048372c movw     r3, #0x9c44
a0483730 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0483734 mov      r2, r3
a0483738 movw     r3, #0xb5fc
a048373c movt     r2, #0xa1a3
a0483740 movt     r3, #0xa078
a0483744 ldr      r4, [r2]
a0483748 sub      sp, sp, #0x1c
a048374c ldr      r3, [r3]
a0483750 str      r2, [sp, #0x14]
a0483754 cmp      r4, #0
a0483758 ldr      r7, [r2, #0x20]
a048375c str      r3, [sp, #0x10]
a0483760 beq      #0xa04838e4
a0483764 mov      r8, r0
a0483768 mov      r0, r3
a048376c ldrb     r3, [r4, #9]
a0483770 mov      r5, r2
a0483774 mov      r1, #0xff
a0483778 mov      r2, #0x800
a048377c str      r3, [sp, #8]
a0483780 blx      #0xa04f8dec
a0483784 movw     r3, #0xb244
a0483788 ldrb     sb, [r5, #0x31]
a048378c movt     r3, #0xa078
a0483790 ldrb     r2, [r4, #8]
a0483794 ldr      sl, [r3, #0x14]
a0483798 cmp      r7, #0
a048379c add      sb, sl, sb
a04837a0 add      r3, sb, r2
a04837a4 str      r3, [sp, #0xc]
a04837a8 beq      #0xa04837c0
a04837ac ldrls    r3, [sp, #0x10]
a04837b0 mov      r6, #0
a04837b4 mov      r5, r6
a04837b8 strls    r6, [r3]
a04837bc bhi      #0xa048385c
a04837c0 movw     r5, #0xb604
a04837c4 sub      r0, r7, #1
a04837c8 movt     r5, #0xa078
a04837cc mov      r4, #0
a04837d0 ldr      r6, [r5]
a04837d4 bl       #0xa0492c7c
a04837d8 str      r0, [r6, #0x348]
a04837dc sub      r0, r0, #1
a04837e0 ldr      r6, [r5]
a04837e4 bl       #0xa0492c7c
a04837e8 movw     r3, #0xb600
a04837ec movw     ip, #0x7433
a04837f0 movt     r3, #0xa078
a04837f4 ldr      r2, [r5]
a04837f8 ldr      r1, [r3]
a04837fc movt     ip, #0x4262
a0483800 str      r0, [r6, #0x34c]
a0483804 movw     lr, #0x6242
a0483808 movt     lr, #0x3274
a048380c mov      r3, r8
a0483810 str      ip, [r1, #0x1c8]
a0483814 mov      r0, r4
a0483818 ldr      ip, [sp, #0x14]
a048381c str      lr, [r1, #0x1c4]
a0483820 ldr      r1, [r2, #0x348]
a0483824 ldr      r2, [r2, #0x34c]
a0483828 strb     r4, [ip, #0x34]
a048382c bl       #0xa0483570
a0483830 mov      r0, r4
a0483834 add      sp, sp, #0x1c
a0483838 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a048383c mov      r3, fp
a0483840 mov      fp, r8
a0483844 mov      r8, r3
a0483848 ldr      r3, [sp, #0x10]
a048384c cmp      r7, r5
a0483850 str      fp, [r3], #4
a0483854 str      r3, [sp, #0x10]
a0483858 bls      #0xa04837c0
a048385c mov      r3, r8
a0483860 mov      r4, #0
a0483864 mov      r8, r4
a0483868 mov      fp, r3
a048386c b        #0xa04838a0
a0483870 add      r4, r4, #2
a0483874 add      r5, r5, #1
a0483878 cmp      r4, #0x1f
a048387c orr      r8, r8, r3
a0483880 movgt    r2, #0
a0483884 movle    r2, #1
a0483888 cmp      r7, r5
a048388c ldr      r3, [sp, #8]
a0483890 movls    r2, #0
a0483894 cmp      r2, #0
a0483898 add      r6, r6, r3
a048389c beq      #0xa048383c
a04838a0 mov      r2, #0
a04838a4 mov      r3, sl
a04838a8 str      fp, [sp]
a04838ac mov      r0, r6
a04838b0 mov      r1, #2
a04838b4 bl       #0xa04831f0
a04838b8 ldrb     r2, [sb]
a04838bc mov      r3, #0
a04838c0 cmp      r2, #0xff
a04838c4 bne      #0xa0483870
a04838c8 ldr      r3, [sp, #0xc]
a04838cc ldrb     r2, [r3]
a04838d0 mov      r3, #0
a04838d4 cmp      r2, #0xff
a04838d8 moveq    r3, #3
a04838dc lsleq    r3, r3, r4
a04838e0 b        #0xa0483870
a04838e4 mvn      r0, #0
a04838e8 b        #0xa0483834

BBT marker consumer
a0483570 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0483574 movw     r4, #0x9c44
a0483578 movt     r4, #0xa1a3
a048357c mov      fp, r1
a0483580 sub      sp, sp, #0x24
a0483584 ldr      r1, [r4]
a0483588 str      r2, [sp, #8]
a048358c ldrb     r6, [r4, #0x30]
a0483590 cmp      r1, #0
a0483594 beq      #0xa0483724
a0483598 mov      sl, r3
a048359c ldrb     r3, [r1, #9]
a04835a0 cmp      fp, #0
a04835a4 ldrb     r7, [r1, #8]
a04835a8 str      r3, [sp, #0xc]
a04835ac blt      #0xa048363c
a04835b0 smulbb   r3, r7, r6
a04835b4 movw     sb, #0xb244
a04835b8 movt     sb, #0xa078
a04835bc mov      r8, r0
a04835c0 mov      r1, #0xff
a04835c4 mov      r2, r3
a04835c8 str      r3, [sp, #0x10]
a04835cc ldr      r3, [sb, #0x14]
a04835d0 mov      r0, r3
a04835d4 blx      #0xa04f8dec
a04835d8 cmp      r6, #0
a04835dc mov      r3, r0
a04835e0 movwne   lr, #0xb600
a04835e4 uxtbne   r5, r8
a04835e8 movtne   lr, #0xa078
a04835ec movne    r2, #0
a04835f0 beq      #0xa048361c
a04835f4 ldr      r0, [lr]
a04835f8 add      r2, r2, #1
a04835fc ldrb     r1, [r4, #0x32]
a0483600 cmp      r2, r6
a0483604 ldr      r0, [r0, #0x1c4]
a0483608 str      r0, [r3, r1]
a048360c ldrb     r1, [r4, #0x33]
a0483610 strb     r5, [r3, r1]
a0483614 add      r3, r3, r7
a0483618 bne      #0xa04835f4
a048361c mov      r0, fp
a0483620 mov      r1, sl
a0483624 bl       #0xa04834b0
a0483628 subs     r5, r0, #0
a048362c beq      #0xa0483644
a0483630 mov      r0, r5
a0483634 add      sp, sp, #0x24
a0483638 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a048363c mvn      r5, #0
a0483640 b        #0xa0483630
a0483644 ldr      r1, [sp, #0xc]
a0483648 movw     r3, #0xb5fc
a048364c mov      r2, r3
a0483650 movw     ip, #0xb244
a0483654 movt     r2, #0xa078
a0483658 movt     ip, #0xa078
a048365c ldr      r3, [sb, #0x14]
a0483660 str      r2, [sp, #0x18]
a0483664 mul      r0, r1, fp
a0483668 str      sl, [sp]
a048366c mov      r1, r6
a0483670 ldr      r2, [r2]
a0483674 str      ip, [sp, #0x14]
a0483678 str      ip, [sp, #0x1c]
a048367c bl       #0xa048336c
a0483680 ldr      r3, [sp, #8]
a0483684 cmp      r3, #0
a0483688 cmpge    r0, #0
a048368c bne      #0xa0483634
a0483690 ldr      ip, [sp, #0x14]
a0483694 mov      r1, #0xff
a0483698 ldr      r2, [sp, #0x10]
a048369c ldr      r3, [ip, #0x14]
a04836a0 mov      r0, r3
a04836a4 blx      #0xa04f8dec
a04836a8 cmp      r6, #0
a04836ac mov      r3, r0
a04836b0 movwne   lr, #0xb600
a04836b4 uxtbne   r8, r8
a04836b8 movtne   lr, #0xa078
a04836bc beq      #0xa04836e8
a04836c0 ldr      r1, [lr]
a04836c4 add      r5, r5, #1
a04836c8 ldrb     r2, [r4, #0x32]
a04836cc cmp      r5, r6
a04836d0 ldr      r1, [r1, #0x1c8]
a04836d4 str      r1, [r3, r2]
a04836d8 ldrb     r2, [r4, #0x33]
a04836dc strb     r8, [r3, r2]
a04836e0 add      r3, r3, r7
a04836e4 bne      #0xa04836c0
a04836e8 ldr      r0, [sp, #8]
a04836ec mov      r1, sl
a04836f0 bl       #0xa04834b0
a04836f4 cmp      r0, #0
a04836f8 bne      #0xa0483634
a04836fc ldr      r3, [sp, #0x18]
a0483700 ldr      r1, [sp, #8]
a0483704 ldr      r2, [r3]
a0483708 ldr      r3, [sp, #0xc]
a048370c str      sl, [sp]
a0483710 mul      r0, r3, r1
a0483714 ldr      r3, [sb, #0x14]
a0483718 mov      r1, r6
a048371c bl       #0xa048336c
a0483720 b        #0xa0483634
a0483724 mvn      r0, #0
a0483728 b        #0xa0483634
