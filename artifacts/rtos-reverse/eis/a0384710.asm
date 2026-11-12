; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a0384710 28d04de2 sub      sp, sp, #0x28
a0384714 0030a0e1 mov      r3, r0
a0384718 08108de5 str      r1, [sp, #8]
a038471c 04208de5 str      r2, [sp, #4]
a0384720 0f30cde5 strb     r3, [sp, #0xf]
a0384724 ec3f0ae3 movw     r3, #0xafec
a0384728 70314ae3 movt     r3, #0xa170
a038472c 003093e5 ldr      r3, [r3]
a0384730 1c308de5 str      r3, [sp, #0x1c]
a0384734 ec3f0ae3 movw     r3, #0xafec
a0384738 70314ae3 movt     r3, #0xa170
a038473c 003093e5 ldr      r3, [r3]
a0384740 18308de5 str      r3, [sp, #0x18]
a0384744 883f0ae3 movw     r3, #0xaf88
a0384748 70314ae3 movt     r3, #0xa170
a038474c 0030d3e5 ldrb     r3, [r3]
a0384750 000053e3 cmp      r3, #0
a0384754 7900000a beq      #0xa0384940
a0384758 d43a07e3 movw     r3, #0x7ad4
a038475c 75304ae3 movt     r3, #0xa075
a0384760 002093e5 ldr      r2, [r3]
a0384764 a13a07e3 movw     r3, #0x7aa1
a0384768 75304ae3 movt     r3, #0xa075
a038476c 0030d3e5 ldrb     r3, [r3]
a0384770 7330afe6 sxtb     r3, r3
a0384774 1233a0e1 lsl      r3, r2, r3
a0384778 903a07ee vmov     s15, r3
a038477c e70bf8ee vcvt.f64.s32 d16, s15
a0384780 9e1bdfed vldr     d17, [pc, #0x278]
a0384784 a10b60ee vmul.f64 d16, d16, d17
a0384788 9e1bdfed vldr     d17, [pc, #0x278]
a038478c a10bc0ee vdiv.f64 d16, d16, d17
a0384790 e07bfdee vcvt.s32.f64 s15, d16
a0384794 903a17ee vmov     r3, s15
a0384798 14308de5 str      r3, [sp, #0x14]
a038479c 14109de5 ldr      r1, [sp, #0x14]
a03847a0 1f3508e3 movw     r3, #0x851f
a03847a4 eb3145e3 movt     r3, #0x51eb
a03847a8 9123c3e0 smull    r2, r3, r1, r3
a03847ac c322a0e1 asr      r2, r3, #5
a03847b0 c13fa0e1 asr      r3, r1, #0x1f
a03847b4 023063e0 rsb      r3, r3, r2
a03847b8 14308de5 str      r3, [sp, #0x14]
a03847bc 08309de5 ldr      r3, [sp, #8]
a03847c0 000053e3 cmp      r3, #0
a03847c4 030000ba blt      #0xa03847d8
a03847c8 08209de5 ldr      r2, [sp, #8]
a03847cc 14309de5 ldr      r3, [sp, #0x14]
a03847d0 030052e1 cmp      r2, r3
a03847d4 070000ba blt      #0xa03847f8
a03847d8 08309de5 ldr      r3, [sp, #8]
a03847dc 000053e3 cmp      r3, #0
a03847e0 0d0000aa bge      #0xa038481c
a03847e4 14309de5 ldr      r3, [sp, #0x14]
a03847e8 002063e2 rsb      r2, r3, #0
a03847ec 08309de5 ldr      r3, [sp, #8]
a03847f0 030052e1 cmp      r2, r3
a03847f4 080000aa bge      #0xa038481c
a03847f8 893f0ae3 movw     r3, #0xaf89
a03847fc 70314ae3 movt     r3, #0xa170
a0384800 0030d3e5 ldrb     r3, [r3]
a0384804 013083e2 add      r3, r3, #1
a0384808 7320efe6 uxtb     r2, r3
a038480c 893f0ae3 movw     r3, #0xaf89
a0384810 70314ae3 movt     r3, #0xa170
a0384814 0020c3e5 strb     r2, [r3]
a0384818 030000ea b        #0xa038482c
a038481c 893f0ae3 movw     r3, #0xaf89
a0384820 70314ae3 movt     r3, #0xa170
a0384824 0020a0e3 mov      r2, #0
a0384828 0020c3e5 strb     r2, [r3]
a038482c 893f0ae3 movw     r3, #0xaf89
a0384830 70314ae3 movt     r3, #0xa170
a0384834 0020d3e5 ldrb     r2, [r3]
a0384838 d83a07e3 movw     r3, #0x7ad8
a038483c 75304ae3 movt     r3, #0xa075
a0384840 0030d3e5 ldrb     r3, [r3]
a0384844 030052e1 cmp      r2, r3
a0384848 2000009a bls      #0xa03848d0
a038484c d83a07e3 movw     r3, #0x7ad8
a0384850 75304ae3 movt     r3, #0xa075
a0384854 0020d3e5 ldrb     r2, [r3]
a0384858 893f0ae3 movw     r3, #0xaf89
a038485c 70314ae3 movt     r3, #0xa170
a0384860 0020c3e5 strb     r2, [r3]
a0384864 04309de5 ldr      r3, [sp, #4]
a0384868 002093e5 ldr      r2, [r3]
a038486c dc3a07e3 movw     r3, #0x7adc
a0384870 75304ae3 movt     r3, #0xa075
a0384874 003093e5 ldr      r3, [r3]
a0384878 930201e0 mul      r1, r3, r2
a038487c 1f3508e3 movw     r3, #0x851f
a0384880 eb3145e3 movt     r3, #0x51eb
a0384884 9123c3e0 smull    r2, r3, r1, r3
a0384888 c322a0e1 asr      r2, r3, #5
a038488c c13fa0e1 asr      r3, r1, #0x1f
a0384890 020063e0 rsb      r0, r3, r2
a0384894 543b07e3 movw     r3, #0x7b54
a0384898 75304ae3 movt     r3, #0xa075
a038489c 0030d3e5 ldrb     r3, [r3]
a03848a0 7330afe6 sxtb     r3, r3
a03848a4 08209de5 ldr      r2, [sp, #8]
a03848a8 920301e0 mul      r1, r2, r3
a03848ac 1f3508e3 movw     r3, #0x851f
a03848b0 eb3145e3 movt     r3, #0x51eb
a03848b4 9123c3e0 smull    r2, r3, r1, r3
a03848b8 c322a0e1 asr      r2, r3, #5
a03848bc c13fa0e1 asr      r3, r1, #0x1f
a03848c0 023063e0 rsb      r3, r3, r2
a03848c4 033080e0 add      r3, r0, r3
a03848c8 24308de5 str      r3, [sp, #0x24]
a03848cc 360000ea b        #0xa03849ac
a03848d0 04309de5 ldr      r3, [sp, #4]
a03848d4 002093e5 ldr      r2, [r3]
a03848d8 0230a0e1 mov      r3, r2
a03848dc 8330a0e1 lsl      r3, r3, #1
a03848e0 023083e0 add      r3, r3, r2
a03848e4 8322a0e1 lsl      r2, r3, #5
a03848e8 021083e0 add      r1, r3, r2
a03848ec 1f3508e3 movw     r3, #0x851f
a03848f0 eb3145e3 movt     r3, #0x51eb
a03848f4 9123c3e0 smull    r2, r3, r1, r3
a03848f8 c322a0e1 asr      r2, r3, #5
a03848fc c13fa0e1 asr      r3, r1, #0x1f
a0384900 020063e0 rsb      r0, r3, r2
a0384904 543b07e3 movw     r3, #0x7b54
a0384908 75304ae3 movt     r3, #0xa075
a038490c 0030d3e5 ldrb     r3, [r3]
a0384910 7330afe6 sxtb     r3, r3
a0384914 08209de5 ldr      r2, [sp, #8]
a0384918 920301e0 mul      r1, r2, r3
a038491c 1f3508e3 movw     r3, #0x851f
a0384920 eb3145e3 movt     r3, #0x51eb
a0384924 9123c3e0 smull    r2, r3, r1, r3
a0384928 c322a0e1 asr      r2, r3, #5
a038492c c13fa0e1 asr      r3, r1, #0x1f
a0384930 023063e0 rsb      r3, r3, r2
a0384934 033080e0 add      r3, r0, r3
a0384938 24308de5 str      r3, [sp, #0x24]
a038493c 1a0000ea b        #0xa03849ac
a0384940 04309de5 ldr      r3, [sp, #4]
a0384944 002093e5 ldr      r2, [r3]
a0384948 0230a0e1 mov      r3, r2
a038494c 8330a0e1 lsl      r3, r3, #1
a0384950 023083e0 add      r3, r3, r2
a0384954 8322a0e1 lsl      r2, r3, #5
a0384958 021083e0 add      r1, r3, r2
a038495c 1f3508e3 movw     r3, #0x851f
a0384960 eb3145e3 movt     r3, #0x51eb
a0384964 9123c3e0 smull    r2, r3, r1, r3
a0384968 c322a0e1 asr      r2, r3, #5
a038496c c13fa0e1 asr      r3, r1, #0x1f
a0384970 020063e0 rsb      r0, r3, r2
a0384974 543b07e3 movw     r3, #0x7b54
a0384978 75304ae3 movt     r3, #0xa075
a038497c 0030d3e5 ldrb     r3, [r3]
a0384980 7330afe6 sxtb     r3, r3
a0384984 08209de5 ldr      r2, [sp, #8]
a0384988 920301e0 mul      r1, r2, r3
a038498c 1f3508e3 movw     r3, #0x851f
a0384990 eb3145e3 movt     r3, #0x51eb
a0384994 9123c3e0 smull    r2, r3, r1, r3
a0384998 c322a0e1 asr      r2, r3, #5
a038499c c13fa0e1 asr      r3, r1, #0x1f
a03849a0 023063e0 rsb      r3, r3, r2
a03849a4 033080e0 add      r3, r0, r3
a03849a8 24308de5 str      r3, [sp, #0x24]
a03849ac 24309de5 ldr      r3, [sp, #0x24]
a03849b0 20308de5 str      r3, [sp, #0x20]
a03849b4 20209de5 ldr      r2, [sp, #0x20]
a03849b8 1c309de5 ldr      r3, [sp, #0x1c]
a03849bc 030052e1 cmp      r2, r3
a03849c0 020000da ble      #0xa03849d0
a03849c4 1c309de5 ldr      r3, [sp, #0x1c]
a03849c8 20308de5 str      r3, [sp, #0x20]
a03849cc 070000ea b        #0xa03849f0
a03849d0 18309de5 ldr      r3, [sp, #0x18]
a03849d4 002063e2 rsb      r2, r3, #0
a03849d8 20309de5 ldr      r3, [sp, #0x20]
a03849dc 030052e1 cmp      r2, r3
a03849e0 020000da ble      #0xa03849f0
a03849e4 18309de5 ldr      r3, [sp, #0x18]
a03849e8 003063e2 rsb      r3, r3, #0
a03849ec 20308de5 str      r3, [sp, #0x20]
a03849f0 20309de5 ldr      r3, [sp, #0x20]
a03849f4 0300a0e1 mov      r0, r3
a03849f8 28d08de2 add      sp, sp, #0x28
a03849fc 1eff2fe1 bx       lr
a0384a00 182d4454 strbpl   r2, [r4], #-0xd18
a0384a04 fb210940 strdmi   r2, r3, [sb], -fp
a0384a08 00000000 andeq    r0, r0, r0
a0384a0c 00806640 rsbmi    r8, r6, r0
