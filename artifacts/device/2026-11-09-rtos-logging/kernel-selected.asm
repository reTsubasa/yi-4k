
FUNCTION_WINDOW head 0x40008000
40008000 bl       #0x40014740
40008004 mrs      sb, apsr
40008008 eor      sb, sb, #0x1a
4000800c tst      sb, #0x1f
40008010 bic      sb, sb, #0x1f
40008014 orr      sb, sb, #0xd3
40008018 bne      #0x40008030
4000801c orr      sb, sb, #0x100
40008020 add      lr, pc, #0xc
40008024 msr      spsr_fsxc, sb
40008028 msr      elr_hyp, lr
4000802c eret     
40008030 msr      cpsr_c, sb
40008034 mrc      p15, #0, sb, c0, c0, #0
40008038 bl       #0x405426ec
4000803c movs     sl, r5
40008040 beq      #0x40542730
40008044 add      r3, pc, #0x34
40008048 ldm      r3, {r4, r8}
4000804c sub      r4, r3, r4
40008050 add      r8, r8, r4
40008054 bl       #0x40008150
40008058 ldr      sp, [pc, #0x1c]
4000805c add      lr, pc, #8
40008060 mrc      p15, #0, r4, c2, c0, #0
40008064 mov      r8, r4
40008068 add      pc, sl, #0x10
4000806c mov      r5, #0x15
40008070 mcr      p15, #0, r5, c3, c0, #0
40008074 mcr      p15, #0, r0, c1, c0, #0
40008078 mov      pc, sp
4000807c subsmi   r6, r2, r0, ror #4
40008080 andmi    r8, r0, r0, lsl #1
40008084 andmi    r0, r0, r0
40008088 add      r4, r8, #0x4000
4000808c mov      r0, r4
40008090 mov      r3, #0
40008094 add      r6, r0, #0x4000
40008098 str      r3, [r0], #4
4000809c str      r3, [r0], #4
400080a0 str      r3, [r0], #4
400080a4 str      r3, [r0], #4
400080a8 teq      r0, r6
400080ac bne      #0x40008098
400080b0 ldr      r7, [sl, #8]
400080b4 add      r0, pc, #0x74
400080b8 ldm      r0, {r3, r5, r6}
400080bc sub      r0, r0, r3
400080c0 add      r5, r5, r0
400080c4 add      r6, r6, r0
400080c8 lsr      r5, r5, #0x14
400080cc lsr      r6, r6, #0x14
400080d0 orr      r3, r7, r5, lsl #20
400080d4 str      r3, [r4, r5, lsl #2]
400080d8 cmp      r5, r6
400080dc addlo    r5, r5, #1
400080e0 blo      #0x400080d0
400080e4 add      r0, r4, #0x1000
400080e8 ldr      r6, [pc, #0x3c]
400080ec orr      r3, r8, r7
400080f0 add      r6, r4, r6, lsr #18
400080f4 str      r3, [r0], #4
400080f8 add      r3, r3, #0x100000
400080fc cmp      r0, r6
40008100 bls      #0x400080f4
40008104 lsr      r0, r2, #0x14
40008108 lsls     r0, r0, #0x14
4000810c subne    r3, r0, r8
40008110 addne    r3, r3, #0x40000000
40008114 addne    r3, r4, r3, lsr #18
40008118 orrne    r6, r7, r0
4000811c strne    r6, [r3], #4
40008120 addne    r6, r6, #0x100000
40008124 strne    r6, [r3]
40008128 mov      pc, lr
4000812c subsmi   r8, sl, r7, asr #13
40008130 andmi    r8, r0, r0, lsr r1
40008134 submi    r1, r0, r0, asr #17
40008138 ldrdmi   r1, r2, [r0], #-0x88
4000813c bic      r0, r0, #2
40008140 mov      r5, #0x15
40008144 mcr      p15, #0, r5, c3, c0, #0
40008148 mcr      p15, #0, r4, c2, c0, #0
4000814c b        #0x404018c0
40008150 tst      r2, #3
40008154 bne      #0x40008188
40008158 ldr      r5, [r2]
4000815c ldr      r6, [pc, #0x2c]
40008160 cmp      r5, r6
40008164 beq      #0x40008184
40008168 cmp      r5, #5
4000816c cmpne    r5, #2
40008170 bne      #0x40008188
40008174 ldr      r5, [r2, #4]
40008178 ldr      r6, [pc, #0x14]
4000817c cmp      r5, r6
40008180 bne      #0x40008188
40008184 mov      pc, lr
40008188 mov      r2, #0
4000818c mov      pc, lr
40008190 ldcl     p13, c0, [lr, #0x340]!
40008194 strbpl   r0, [r1], #-1
40008198 andeq    r0, r0, r0
4000819c andeq    r0, r0, r0
400081a0 andeq    r0, r0, r0
400081a4 andeq    r0, r0, r0
400081a8 andeq    r0, r0, r0
400081ac andeq    r0, r0, r0
400081b0 andeq    r0, r0, r0
400081b4 andeq    r0, r0, r0
400081b8 andeq    r0, r0, r0
400081bc andeq    r0, r0, r0
400081c0 b        #0x4000fb10
400081c4 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
400081c8 mov      sb, r0
400081cc ldr      r3, [r0, #0x40]
400081d0 sub      sp, sp, #0x8c
400081d4 ldr      r7, [r0, #0x3c]
400081d8 and      r2, r3, #0x1f
400081dc cmp      r2, #0x13
400081e0 beq      #0x40008354
400081e4 mov      r0, sp
400081e8 tst      r3, #0x20
400081ec bic      r8, r0, #0x1fc0
400081f0 mov      r0, r7
400081f4 bic      r1, r8, #0x3f
400081f8 ldr      r4, [r1, #8]
400081fc sub      r1, r4, #1
40008200 beq      #0x4000826c
40008204 bl       #0x401f3618
40008208 cmp      r0, #0
4000820c beq      #0x40008364
40008210 movw     r6, #0x7184
40008214 movt     r6, #0x4058
40008218 ldr      fp, [r6]
4000821c tst      fp, #1

FUNCTION_WINDOW pfn_valid 0x40016494
40016494 lsl      r0, r0, #0xc
40016498 b        #0x400c2e1c
4001649c push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
400164a0 mov      r5, r0
400164a4 movw     r0, #0xd6dc
400164a8 sub      sp, sp, #0x14
400164ac movt     r0, #0x4049
400164b0 bl       #0x403fcad4
400164b4 mov      r0, r5
400164b8 bl       #0x40093ea8
400164bc ands     r5, r5, #2
400164c0 beq      #0x400164cc
400164c4 add      sp, sp, #0x14
400164c8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
400164cc movw     r3, #0x719c
400164d0 movt     r3, #0x4058
400164d4 ldr      r0, [r3, #4]
400164d8 mov      r2, r3
400164dc str      r3, [sp, #8]
400164e0 cmp      r0, #0
400164e4 ble      #0x40016a48
400164e8 movw     r1, #0xdcb0
400164ec mov      fp, r5
400164f0 mov      sb, r1
400164f4 mov      r6, r5
400164f8 movt     sb, #0x4059
400164fc mov      r7, r5
40016500 str      sb, [sp, #4]
40016504 mov      r4, r5
40016508 mov      r3, r5
4001650c mov      r8, r5
40016510 add      sb, r2, #4

FUNCTION_WINDOW devmem_range_checks 0x40017d14
40017d14 add      r0, r0, r1, lsr #12
40017d18 cmp      r0, #0x100000
40017d1c movhi    r0, #0
40017d20 movls    r0, #1
40017d24 bx       lr
40017d28 push     {r4, lr}
40017d2c mov      r1, #0
40017d30 mov      r4, r0
40017d34 lsl      r0, r0, #0xc
40017d38 bl       #0x4002eaa0
40017d3c cmp      r0, #0
40017d40 beq      #0x40017d4c
40017d44 mov      r0, #0
40017d48 pop      {r4, pc}
40017d4c mov      r0, r4
40017d50 bl       #0x4002e3d8
40017d54 clz      r0, r0
40017d58 lsr      r0, r0, #5
40017d5c pop      {r4, pc}
40017d60 push     {r4, r5, r6, lr}
40017d64 mov      r1, #2
40017d68 mov      r6, r0
40017d6c mov      r0, #0xd0
40017d70 bl       #0x40098920
40017d74 subs     r4, r0, #0
40017d78 beq      #0x40017e1c
40017d7c mov      r1, #0xfc0
40017d80 bl       #0x401f47a0
40017d84 movw     r3, #0x4498
40017d88 mov      r2, #0x3040
40017d8c movt     r3, #0x4056
40017d90 add      r0, r4, #0xfc0
40017d94 ldr      r5, [r3, #0x2c]
40017d98 add      r1, r5, #0xfc0
40017d9c bl       #0x401f4040
40017da0 mov      r1, #0x4000
40017da4 mov      r0, r4
40017da8 bl       #0x4001988c
40017dac movw     r0, #0x5b3c
40017db0 movt     r0, #0x4055
40017db4 ldr      r1, [r0]
40017db8 tst      r1, #0x2000
40017dbc bne      #0x40017e1c
40017dc0 ldr      r3, [r4]
40017dc4 cmp      r3, #0
40017dc8 beq      #0x40017e24
40017dcc bic      r2, r3, #0xff0
40017dd0 bic      r0, r2, #0xf
40017dd4 bl       #0x4001d530
40017dd8 subs     r6, r0, #0
40017ddc beq      #0x40017e40
40017de0 ldr      r5, [r5]
40017de4 bic      ip, r5, #0xff0
40017de8 bic      r0, ip, #0xf
40017dec bl       #0x4001d530
40017df0 mov      r5, r0
40017df4 mov      r2, #0
40017df8 mov      r0, r6
40017dfc ldr      r1, [r5]
40017e00 bl       #0x40019800
40017e04 add      r0, r6, #4
40017e08 ldr      r1, [r5, #4]
40017e0c mov      r2, #0
40017e10 bl       #0x40019800

FUNCTION_WINDOW read_mem 0x40265578
40265578 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
4026557c mov      sl, r1
40265580 ldr      sb, [r3]
40265584 sub      sp, sp, #0x3c
40265588 mov      r1, r2
4026558c mov      r8, r2
40265590 str      r3, [sp, #0x34]
40265594 mov      r0, sb
40265598 bl       #0x40017ccc
4026559c cmp      r0, #0
402655a0 beq      #0x40265880
402655a4 cmp      r8, #0
402655a8 beq      #0x40265930
402655ac mov      r3, sp
402655b0 mov      r2, #0
402655b4 bic      r0, r3, #0x1fc0
402655b8 str      r2, [sp, #0x24]
402655bc bic      r1, r0, #0x3f
402655c0 str      r1, [sp, #0x28]
402655c4 lsr      fp, sb, #0xc
402655c8 mov      r6, #0
402655cc str      r6, [sp, #0x14]
402655d0 ubfx     r7, sb, #0, #0xc
402655d4 lsl      ip, fp, #0xc
402655d8 rsb      r5, r7, #0x1000
402655dc cmp      r5, r8
402655e0 str      ip, [sp, #0x10]
402655e4 movhs    r5, r8
402655e8 ldrd     r0, r1, [sp, #0x10]
402655ec adds     r2, r0, r8
402655f0 adc      r3, r1, #0
402655f4 mov      r6, r2
402655f8 cmp      r1, r3
402655fc mov      r7, r3
40265600 cmpeq    r0, r2
40265604 strd     r6, r7, [sp, #0x18]
40265608 bhs      #0x40265848
4026560c mvn      ip, r0
40265610 mvn      lr, r1
40265614 adds     r6, r2, ip
40265618 mov      r0, fp
4026561c adc      r7, r3, lr
40265620 lsr      r3, r6, #0xc
40265624 lsr      ip, r7, #0xc
40265628 orr      r1, r3, r7, lsl #20
4026562c str      ip, [sp, #0xc]
40265630 str      r1, [sp, #8]
40265634 bl       #0x40017d28
40265638 ldrd     r2, r3, [sp, #8]
4026563c cmp      r0, #0
40265640 mov      r3, #0
40265644 and      r2, r2, #7
40265648 beq      #0x402658f8
4026564c ldrd     r6, r7, [sp, #0x10]
40265650 add      r4, fp, #1
40265654 ldrd     r0, r1, [sp, #0x18]
40265658 adds     r6, r6, #0x1000
4026565c adc      r7, r7, #0
40265660 cmp      r1, r7
40265664 cmpeq    r0, r6
40265668 bls      #0x40265848
4026566c orrs     r1, r2, r3
40265670 beq      #0x40265790
40265674 cmp      r3, #0
40265678 cmpeq    r2, #1
4026567c beq      #0x40265764
40265680 cmp      r3, #0
40265684 cmpeq    r2, #2
40265688 beq      #0x40265748
4026568c cmp      r3, #0
40265690 cmpeq    r2, #3
40265694 beq      #0x4026572c
40265698 cmp      r3, #0
4026569c cmpeq    r2, #4
402656a0 beq      #0x40265710
402656a4 cmp      r3, #0
402656a8 cmpeq    r2, #5
402656ac beq      #0x402656f4
402656b0 cmp      r3, #0
402656b4 cmpeq    r2, #6
402656b8 beq      #0x402656d8
402656bc mov      r0, r4
402656c0 bl       #0x40017d28
402656c4 cmp      r0, #0
402656c8 beq      #0x402658f8
402656cc adds     r6, r6, #0x1000
402656d0 add      r4, r4, #1
402656d4 adc      r7, r7, #0
402656d8 mov      r0, r4
402656dc bl       #0x40017d28
402656e0 cmp      r0, #0
402656e4 beq      #0x402658f8
402656e8 adds     r6, r6, #0x1000
402656ec add      r4, r4, #1
402656f0 adc      r7, r7, #0
402656f4 mov      r0, r4
402656f8 bl       #0x40017d28
402656fc cmp      r0, #0
40265700 beq      #0x402658f8
40265704 adds     r6, r6, #0x1000
40265708 add      r4, r4, #1
4026570c adc      r7, r7, #0
40265710 mov      r0, r4
40265714 bl       #0x40017d28
40265718 cmp      r0, #0
4026571c beq      #0x402658f8
40265720 adds     r6, r6, #0x1000
40265724 add      r4, r4, #1
40265728 adc      r7, r7, #0
4026572c mov      r0, r4
40265730 bl       #0x40017d28
40265734 cmp      r0, #0
40265738 beq      #0x402658f8
4026573c adds     r6, r6, #0x1000
40265740 add      r4, r4, #1
40265744 adc      r7, r7, #0
40265748 mov      r0, r4
4026574c bl       #0x40017d28
40265750 cmp      r0, #0
40265754 beq      #0x402658f8
40265758 adds     r6, r6, #0x1000
4026575c add      r4, r4, #1
40265760 adc      r7, r7, #0
40265764 mov      r0, r4
40265768 bl       #0x40017d28
4026576c cmp      r0, #0
40265770 beq      #0x402658f8
40265774 ldrd     r2, r3, [sp, #0x18]
40265778 adds     r6, r6, #0x1000
4026577c adc      r7, r7, #0
40265780 add      r4, r4, #1
40265784 cmp      r3, r7
40265788 cmpeq    r2, r6
4026578c bls      #0x40265848
40265790 str      sb, [sp, #0x2c]
40265794 mov      fp, r8
40265798 ldrd     r8, sb, [sp, #0x18]
4026579c str      r5, [sp, #0x30]
402657a0 mov      r0, r4
402657a4 add      r5, r4, #1
402657a8 bl       #0x40017d28
402657ac cmp      r0, #0
402657b0 mov      r0, r5
402657b4 beq      #0x402658f8
402657b8 bl       #0x40017d28
402657bc cmp      r0, #0
402657c0 add      r0, r5, #1
402657c4 beq      #0x402658f8
402657c8 bl       #0x40017d28
402657cc cmp      r0, #0
402657d0 add      r0, r4, #3
402657d4 beq      #0x402658f8
402657d8 bl       #0x40017d28
402657dc cmp      r0, #0
402657e0 add      r0, r4, #4
402657e4 beq      #0x402658f8
402657e8 bl       #0x40017d28
402657ec cmp      r0, #0
402657f0 add      r0, r4, #5
402657f4 beq      #0x402658f8
402657f8 bl       #0x40017d28
402657fc cmp      r0, #0
40265800 add      r0, r4, #6
40265804 beq      #0x402658f8
40265808 bl       #0x40017d28
4026580c cmp      r0, #0
40265810 add      r0, r4, #7
40265814 add      r4, r4, #8
40265818 beq      #0x402658f8
4026581c bl       #0x40017d28
40265820 cmp      r0, #0
40265824 beq      #0x402658f8
40265828 adds     r6, r6, #0x8000
4026582c adc      r7, r7, #0
40265830 cmp      sb, r7
40265834 cmpeq    r8, r6
40265838 bhi      #0x402657a0
4026583c ldr      sb, [sp, #0x2c]
40265840 mov      r8, fp
40265844 ldr      r5, [sp, #0x30]
40265848 mov      r0, sb
4026584c bl       #0x4001d530
40265850 subs     fp, r0, #0
40265854 beq      #0x40265880
40265858 ldr      r0, [sp, #0x28]
4026585c ldr      lr, [r0, #8]
40265860 adds     r2, sl, r5
40265864 sbcslo   r2, r2, lr
40265868 movlo    lr, #0
4026586c cmp      lr, #0
40265870 beq      #0x4026588c
40265874 mov      r1, fp
40265878 mov      r0, sb
4026587c bl       #0x40265184
40265880 mvn      r0, #0xd
40265884 add      sp, sp, #0x3c
40265888 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
4026588c mov      r2, r5
40265890 mov      r1, fp
40265894 mov      r0, sl
40265898 bl       #0x401f2600
4026589c mov      r1, fp
402658a0 mov      r4, r0
402658a4 mov      r0, sb
402658a8 bl       #0x40265184
402658ac cmp      r4, #0
402658b0 bne      #0x40265880
402658b4 ldr      r2, [sp, #0x24]
402658b8 subs     r8, r8, r5
402658bc add      sl, sl, r5
402658c0 add      sb, sb, r5
402658c4 add      r3, r2, r5
402658c8 str      r3, [sp, #0x24]
402658cc bne      #0x402655c4
402658d0 asr      r5, r3, #0x1f
402658d4 mov      r4, r3
402658d8 ldr      r1, [sp, #0x34]
402658dc ldr      r0, [sp, #0x24]
402658e0 ldrd     r2, r3, [r1]
402658e4 adds     r2, r2, r4
402658e8 adc      r3, r3, r5
402658ec strd     r2, r3, [r1]
402658f0 add      sp, sp, #0x3c
402658f4 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
402658f8 mov      ip, sp
402658fc ldrd     r4, r5, [sp, #0x18]
40265900 bic      r6, ip, #0x1fc0
40265904 movw     r0, #0x8dc8
40265908 bic      r7, r6, #0x3f
4026590c ldrd     r2, r3, [sp, #0x10]
40265910 ldr      sb, [r7, #0xc]
40265914 movt     r0, #0x404c
40265918 strd     r4, r5, [sp]
4026591c add      r1, sb, #0x1d8
40265920 bl       #0x403fcad4
40265924 mvn      r0, #0
40265928 add      sp, sp, #0x3c
4026592c pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
40265930 str      r8, [sp, #0x24]
40265934 mov      r4, #0
40265938 mov      r5, #0
4026593c b        #0x402658d8

FUNCTION_WINDOW mmap_mem 0x40265940
40265940 mov      r0, #1
40265944 bx       lr
40265948 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
4026594c sub      sp, sp, #0x24
40265950 ldm      r1, {r3, fp}
40265954 mov      r5, r1
40265958 str      r0, [sp, #0x14]
4026595c rsb      fp, r3, fp
40265960 ldr      r0, [r1, #0x4c]
40265964 mov      r1, fp
40265968 bl       #0x40017d14
4026596c cmp      r0, #0
40265970 beq      #0x40265c3c
40265974 ldr      r4, [r5, #0x4c]
40265978 lsr      r3, r4, #0x14
4026597c lsl      r0, r4, #0xc
40265980 str      r3, [sp, #0xc]
40265984 str      r0, [sp, #8]
40265988 ldrd     r2, r3, [sp, #8]
4026598c adds     r8, r2, fp
40265990 adc      sb, r3, #0
40265994 cmp      r3, sb
40265998 cmpeq    r2, r8
4026599c bhs      #0x40265c48
402659a0 mvn      r2, r2
402659a4 mvn      r1, r3
402659a8 adds     r6, r2, r8
402659ac mov      r0, r4
402659b0 lsr      r3, r6, #0xc
402659b4 adc      r7, r1, sb
402659b8 orr      r1, r3, r7, lsl #20
402659bc mov      r3, #0
402659c0 and      r2, r1, #7
402659c4 strd     r2, r3, [sp, #0x18]
402659c8 bl       #0x40017d28
402659cc cmp      r0, #0
402659d0 ldrd     r2, r3, [sp, #0x18]
402659d4 beq      #0x40265c50
402659d8 ldrd     r6, r7, [sp, #8]
402659dc add      r4, r4, #1
402659e0 adds     r6, r6, #0x1000
402659e4 adc      r7, r7, #0
402659e8 cmp      sb, r7
402659ec cmpeq    r8, r6
402659f0 bls      #0x40265bb0
402659f4 orrs     r1, r2, r3
402659f8 beq      #0x40265b14
402659fc cmp      r3, #0
40265a00 cmpeq    r2, #1
40265a04 beq      #0x40265aec
40265a08 cmp      r3, #0
40265a0c cmpeq    r2, #2
40265a10 beq      #0x40265ad0
40265a14 cmp      r3, #0
40265a18 cmpeq    r2, #3
40265a1c beq      #0x40265ab4
40265a20 cmp      r3, #0
40265a24 cmpeq    r2, #4
40265a28 beq      #0x40265a98
40265a2c cmp      r3, #0
40265a30 cmpeq    r2, #5
40265a34 beq      #0x40265a7c
40265a38 cmp      r3, #0
40265a3c cmpeq    r2, #6
40265a40 beq      #0x40265a60
40265a44 mov      r0, r4
40265a48 bl       #0x40017d28
40265a4c cmp      r0, #0
40265a50 beq      #0x40265c50
40265a54 adds     r6, r6, #0x1000
40265a58 add      r4, r4, #1
40265a5c adc      r7, r7, #0
40265a60 mov      r0, r4
40265a64 bl       #0x40017d28
40265a68 cmp      r0, #0
40265a6c beq      #0x40265c50
40265a70 adds     r6, r6, #0x1000
40265a74 add      r4, r4, #1
40265a78 adc      r7, r7, #0
40265a7c mov      r0, r4
40265a80 bl       #0x40017d28
40265a84 cmp      r0, #0
40265a88 beq      #0x40265c50
40265a8c adds     r6, r6, #0x1000
40265a90 add      r4, r4, #1
40265a94 adc      r7, r7, #0
40265a98 mov      r0, r4
40265a9c bl       #0x40017d28
40265aa0 cmp      r0, #0
40265aa4 beq      #0x40265c50
40265aa8 adds     r6, r6, #0x1000
40265aac add      r4, r4, #1
40265ab0 adc      r7, r7, #0
40265ab4 mov      r0, r4
40265ab8 bl       #0x40017d28
40265abc cmp      r0, #0
40265ac0 beq      #0x40265c50
40265ac4 adds     r6, r6, #0x1000
40265ac8 add      r4, r4, #1
40265acc adc      r7, r7, #0
40265ad0 mov      r0, r4
40265ad4 bl       #0x40017d28
40265ad8 cmp      r0, #0
40265adc beq      #0x40265c50
40265ae0 adds     r6, r6, #0x1000
40265ae4 add      r4, r4, #1
40265ae8 adc      r7, r7, #0
40265aec mov      r0, r4
40265af0 bl       #0x40017d28
40265af4 cmp      r0, #0
40265af8 beq      #0x40265c50
40265afc adds     r6, r6, #0x1000
40265b00 add      r4, r4, #1
40265b04 adc      r7, r7, #0
40265b08 cmp      sb, r7
40265b0c cmpeq    r8, r6
40265b10 bls      #0x40265bb0
40265b14 mov      r0, r4
40265b18 add      sl, r4, #1
40265b1c bl       #0x40017d28
40265b20 cmp      r0, #0
40265b24 mov      r0, sl
40265b28 beq      #0x40265c50
40265b2c bl       #0x40017d28
40265b30 cmp      r0, #0
40265b34 add      r0, sl, #1
40265b38 beq      #0x40265c50
40265b3c bl       #0x40017d28
40265b40 cmp      r0, #0
40265b44 add      r0, r4, #3
40265b48 beq      #0x40265c50
40265b4c bl       #0x40017d28
40265b50 cmp      r0, #0
40265b54 add      r0, r4, #4
40265b58 beq      #0x40265c50
40265b5c bl       #0x40017d28
40265b60 cmp      r0, #0
40265b64 add      r0, r4, #5
40265b68 beq      #0x40265c50
40265b6c bl       #0x40017d28
40265b70 cmp      r0, #0
40265b74 add      r0, r4, #6
40265b78 beq      #0x40265c50
40265b7c bl       #0x40017d28
40265b80 cmp      r0, #0
40265b84 add      r0, r4, #7
40265b88 add      r4, r4, #8
40265b8c beq      #0x40265c50
40265b90 bl       #0x40017d28
40265b94 cmp      r0, #0
40265b98 beq      #0x40265c50
40265b9c adds     r6, r6, #0x8000
40265ba0 adc      r7, r7, #0
40265ba4 cmp      sb, r7
40265ba8 cmpeq    r8, r6
40265bac bhi      #0x40265b14
40265bb0 ldr      r1, [r5, #0x4c]
40265bb4 add      r3, r5, #0x24
40265bb8 mov      r2, fp
40265bbc ldr      r0, [sp, #0x14]
40265bc0 bl       #0x40265940
40265bc4 cmp      r0, #0
40265bc8 beq      #0x40265c3c
40265bcc ldr      r0, [sp, #0x14]
40265bd0 ldr      sl, [r5, #0x4c]
40265bd4 ldr      r4, [r5, #0x24]
40265bd8 ldr      r8, [r0, #0x1c]
40265bdc tst      r8, #0x1000
40265be0 beq      #0x40265c1c
40265be4 bic      r4, r4, #0x3c
40265be8 ldr      ip, [pc, #0x90]
40265bec mov      r3, fp
40265bf0 ldr      r1, [r5]
40265bf4 mov      r2, sl
40265bf8 str      r4, [r5, #0x24]
40265bfc mov      r0, r5
40265c00 str      r4, [sp]
40265c04 str      ip, [r5, #0x48]
40265c08 bl       #0x400b11f8
40265c0c cmp      r0, #0
40265c10 mvnne    r0, #0xa
40265c14 add      sp, sp, #0x24
40265c18 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
40265c1c movw     sb, #0xdcc0
40265c20 movt     sb, #0x4059
40265c24 ldr      r0, [sb]
40265c28 bl       #0x4001d62c
40265c2c cmp      r0, sl, lsl #12
40265c30 ldr      sl, [r5, #0x4c]
40265c34 bhi      #0x40265be8
40265c38 b        #0x40265be4
40265c3c mvn      r0, #0x15
40265c40 add      sp, sp, #0x24
40265c44 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
40265c48 mov      r1, r4
40265c4c b        #0x40265bb4
40265c50 mov      r5, sp
40265c54 movw     r0, #0x8dc8
40265c58 bic      fp, r5, #0x1fc0
40265c5c ldrd     r2, r3, [sp, #8]
40265c60 bic      lr, fp, #0x3f
40265c64 movt     r0, #0x404c
40265c68 ldr      r1, [lr, #0xc]
40265c6c strd     r8, sb, [sp]
40265c70 add      r1, r1, #0x1d8
40265c74 bl       #0x403fcad4
40265c78 mvn      r0, #0
40265c7c b        #0x40265c14
40265c80 umaalmi  r2, r2, r4, lr
40265c84 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
40265c88 sub      sp, sp, #0x1c
40265c8c ldr      ip, [r0]
40265c90 ldm      ip, {r8, lr}
40265c94 ldr      r4, [ip, #0xc]
40265c98 ldr      fp, [ip, #0x14]
40265c9c str      lr, [sp]
40265ca0 sub      r8, r8, #1
40265ca4 ldr      lr, [ip, #8]
40265ca8 str      r4, [sp, #8]
40265cac str      lr, [sp, #4]
40265cb0 ldr      lr, [ip, #0x10]
40265cb4 str      lr, [sp, #0xc]
40265cb8 cmp      r2, #0
40265cbc ldr      sb, [r0, #0x18]
40265cc0 ldr      r6, [r0, #0x14]
40265cc4 beq      #0x40265d8c
40265cc8 movw     sl, #0x305c
40265ccc add      r2, r1, r2
40265cd0 movt     sl, #0x4042
40265cd4 str      r2, [sp, #0x10]
40265cd8 str      r3, [sp, #0x14]
40265cdc ldr      r5, [sp]
40265ce0 sub      r6, r6, #1
40265ce4 ldr      ip, [sp, #4]
40265ce8 and      r6, r6, r8
40265cec ldr      r3, [r0, #4]

FUNCTION_WINDOW amba_dspmem_mmap 0x4027f694
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
