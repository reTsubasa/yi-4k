
FUNCTION 0xa01f3124
a01f3124 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01f3128 sub      sp, sp, #0x14
a01f312c mov      r4, r0
a01f3130 bl       #0xa01f705c
a01f3134 subs     r3, r0, #0
a01f3138 str      r3, [sp, #0xc]
a01f313c beq      #0xa01f3164
a01f3140 movw     r0, #0x82d0
a01f3144 movw     r1, #0x2860
a01f3148 mvn      r3, #0
a01f314c movt     r1, #0xa058
a01f3150 mov      r2, #0xf4
a01f3154 movt     r0, #0xa058
a01f3158 str      r3, [sp, #0xc]
a01f315c bl       #0xa02a70ec
a01f3160 b        #0xa01f3268
a01f3164 mov      r0, r4
a01f3168 bl       #0xa01f69b0
a01f316c cmp      r0, #0
a01f3170 bne      #0xa01f3198
a01f3174 movw     r0, #0xaba8
a01f3178 movw     r1, #0x2860
a01f317c movt     r1, #0xa058
a01f3180 mov      r2, #0xf8
a01f3184 movt     r0, #0xa053
a01f3188 bl       #0xa02a70ec
a01f318c bl       #0xa02a7524
a01f3190 cpsid    if
a01f3194 b        #0xa01f3194
a01f3198 ldrd     r2, r3, [r0, #0x20]
a01f319c movw     fp, #0x1758
a01f31a0 movt     fp, #0xa13c
a01f31a4 strd     r2, r3, [sp]
a01f31a8 ldrd     r2, r3, [fp]
a01f31ac orrs     r3, r2, r3
a01f31b0 ldrdeq   r2, r3, [sp]
a01f31b4 strdeq   r2, r3, [fp]
a01f31b8 mov      sl, #0
a01f31bc mov      r5, #0x90
a01f31c0 uxtb     r3, sl
a01f31c4 ldrb     r2, [r4, #0x6f4]
a01f31c8 mla      ip, r5, r3, r4
a01f31cc cmp      r2, r3
a01f31d0 mov      r8, ip
a01f31d4 bls      #0xa01f3268
a01f31d8 ldrd     r6, r7, [fp]
a01f31dc add      r2, r3, #1
a01f31e0 ldrd     r0, r1, [sp]
a01f31e4 mul      lr, r5, r2
a01f31e8 cmp      r7, r1
a01f31ec cmpeq    r6, r0
a01f31f0 bls      #0xa01f321c
a01f31f4 ldrd     r0, r1, [ip, #0x98]
a01f31f8 ldrd     r6, r7, [sp]
a01f31fc subs     r6, r0, r6
a01f3200 sbc      r7, r1, r7
a01f3204 mov      r0, r6
a01f3208 mov      r1, r7
a01f320c strd     r0, r1, [ip, #0x98]
a01f3210 strd     r0, r1, [ip, #0xa0]
a01f3214 strd     r0, r1, [r4, lr]
a01f3218 b        #0xa01f3234
a01f321c ldrd     r0, r1, [r8, #0x98]
a01f3220 subs     r0, r0, r6
a01f3224 sbc      r1, r1, r7
a01f3228 strd     r0, r1, [r8, #0x98]
a01f322c strd     r0, r1, [r8, #0xa0]
a01f3230 strd     r0, r1, [r4, lr]
a01f3234 mul      r3, r5, r3
a01f3238 add      sl, sl, #1
a01f323c add      r1, r4, r3
a01f3240 ldrb     r0, [r1, #0x101]
a01f3244 cmp      r0, #1
a01f3248 bne      #0xa01f31c0
a01f324c mul      r2, r5, r2
a01f3250 add      r0, r3, #0x78
a01f3254 add      r0, r4, r0
a01f3258 ldrd     r2, r3, [r2, r4]
a01f325c strd     r2, r3, [r1, #0xc8]
a01f3260 bl       #0xa01f721c
a01f3264 b        #0xa01f31c0
a01f3268 ldr      r0, [sp, #0xc]
a01f326c add      sp, sp, #0x14
a01f3270 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}

FUNCTION 0xa01f705c
a01f705c cmp      r0, #0
a01f7060 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01f7064 mov      r8, r0
a01f7068 sub      sp, sp, #0x9c
a01f706c ldrb     sb, [r0, #0x6f4]
a01f7070 beq      #0xa01f71c0
a01f7074 ldrb     r3, [r0]
a01f7078 cmp      r3, #1
a01f707c bne      #0xa01f719c
a01f7080 cmp      sb, #0
a01f7084 movne    sl, #0
a01f7088 mvnne    r6, #0
a01f708c movne    r5, sl
a01f7090 mvnne    r7, #0
a01f7094 bne      #0xa01f70ac
a01f7098 b        #0xa01f7190
a01f709c add      r5, r5, #1
a01f70a0 uxtb     r5, r5
a01f70a4 cmp      sb, r5
a01f70a8 bls      #0xa01f7130
a01f70ac lsl      r3, r5, #7
a01f70b0 add      r3, r3, r5, lsl #4
a01f70b4 add      fp, r8, r3
a01f70b8 add      r3, r3, #0x78
a01f70bc ldrb     r2, [fp, #0x101]
a01f70c0 add      r4, r8, r3
a01f70c4 cmp      r2, #1
a01f70c8 bne      #0xa01f709c
a01f70cc mov      r1, r4
a01f70d0 mov      r2, #0x90
a01f70d4 add      r0, sp, #8
a01f70d8 bl       #0xa029c680
a01f70dc ldr      r0, [fp, #0xa8]
a01f70e0 add      r1, sp, #4
a01f70e4 mov      r2, #0
a01f70e8 bl       #0xa0451960
a01f70ec cmp      r0, #0
a01f70f0 mov      r0, r4
a01f70f4 bne      #0xa01f7200
a01f70f8 ldr      r1, [sp, #4]
a01f70fc bl       #0xa01f6be8
a01f7100 cmp      r1, r7
a01f7104 cmpeq    r0, r6
a01f7108 beq      #0xa01f71e4
a01f710c ldr      r3, [fp, #0x98]
a01f7110 add      r5, r5, #1
a01f7114 ldr      r2, [sp, #0x28]
a01f7118 uxtb     r5, r5
a01f711c rsb      r3, r2, r3
a01f7120 cmp      sl, r3
a01f7124 movge    sl, r3
a01f7128 cmp      sb, r5
a01f712c bhi      #0xa01f70ac
a01f7130 mov      r0, sl
a01f7134 asr      r1, sl, #0x1f
a01f7138 mov      lr, #0
a01f713c b        #0xa01f7148
a01f7140 cmp      sb, lr
a01f7144 bls      #0xa01f7190
a01f7148 lsl      ip, lr, #7
a01f714c add      r3, lr, #1
a01f7150 add      ip, ip, lr, lsl #4
a01f7154 uxtb     lr, r3
a01f7158 add      ip, r8, ip
a01f715c ldrd     r2, r3, [ip, #0x98]
a01f7160 subs     r2, r2, r0
a01f7164 sbc      r3, r3, r1
a01f7168 strd     r2, r3, [ip, #0x98]
a01f716c ldrb     r3, [r4, #0x89]
a01f7170 cmp      r3, #1
a01f7174 bne      #0xa01f7140
a01f7178 ldrd     r2, r3, [r4, #0x50]
a01f717c subs     r2, r2, r0
a01f7180 sbc      r3, r3, r1
a01f7184 cmp      sb, lr
a01f7188 strd     r2, r3, [r4, #0x50]
a01f718c bhi      #0xa01f7148
a01f7190 mov      r0, #0
a01f7194 add      sp, sp, #0x9c
a01f7198 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01f719c movw     r0, #0xaba8
a01f71a0 movw     r1, #0x435c
a01f71a4 movt     r1, #0xa058
a01f71a8 mov      r2, #0x154
a01f71ac movt     r0, #0xa053
a01f71b0 bl       #0xa02a70ec
a01f71b4 bl       #0xa02a7524
a01f71b8 cpsid    if
a01f71bc b        #0xa01f71bc
a01f71c0 movw     r0, #0xaba8
a01f71c4 movw     r1, #0x435c
a01f71c8 movt     r1, #0xa058
a01f71cc movw     r2, #0x153
a01f71d0 movt     r0, #0xa053
a01f71d4 bl       #0xa02a70ec
a01f71d8 bl       #0xa02a7524
a01f71dc cpsid    if
a01f71e0 b        #0xa01f71e0
a01f71e4 movw     r1, #0x435c
a01f71e8 movw     r0, #0x15f
a01f71ec movt     r1, #0xa058
a01f71f0 bl       #0xa01f6850
a01f71f4 mvn      r0, #0
a01f71f8 add      sp, sp, #0x9c
a01f71fc pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01f7200 movw     r1, #0x435c
a01f7204 movw     r0, #0x15a
a01f7208 movt     r1, #0xa058
a01f720c bl       #0xa01f6850
a01f7210 mvn      r0, #7
a01f7214 add      sp, sp, #0x9c
a01f7218 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}

FUNCTION 0xa0451960
a0451960 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0451964 sub      sp, sp, #0x14
a0451968 ldr      r4, [r0, #4]
a045196c ldr      r3, [r4, #0xc]
a0451970 cmp      r3, #0
a0451974 beq      #0xa0451ad0
a0451978 mov      sb, #0
a045197c str      r1, [sp]
a0451980 str      r2, [sp, #4]
a0451984 mov      r3, r4
a0451988 mov      r6, r1
a045198c mov      r5, r2
a0451990 mov      r1, #0xe
a0451994 movw     r2, #0x7dd
a0451998 mov      r0, #2
a045199c str      sb, [sp, #8]
a04519a0 add      r7, r4, #0x14
a04519a4 bl       #0xa044e734
a04519a8 mov      r0, r7
a04519ac mvn      r1, #0
a04519b0 bl       #0xa03bc46c
a04519b4 subs     r8, r0, #0
a04519b8 bne      #0xa0451a34
a04519bc ldr      r2, [r4, #0x88]
a04519c0 cmp      r5, r2
a04519c4 movhs    r3, #0
a04519c8 strhs    r3, [r6]
a04519cc bhs      #0xa04519fc
a04519d0 ldrd     r8, sb, [r4, #0x90]
a04519d4 mov      r3, #0
a04519d8 ldrd     sl, fp, [r4, #0x98]
a04519dc subs     r0, sl, r8
a04519e0 sbc      r1, fp, sb
a04519e4 cmp      r1, r3
a04519e8 cmpeq    r0, r2
a04519ec bls      #0xa0451a60
a04519f0 mvn      r8, #8
a04519f4 mov      r3, #0
a04519f8 str      r3, [r6]
a04519fc mov      r0, r7
a0451a00 bl       #0xa03bc498
a0451a04 mov      r2, #0
a0451a08 str      r6, [sp]
a0451a0c str      r2, [sp, #8]
a0451a10 mov      r3, r4
a0451a14 str      r5, [sp, #4]
a0451a18 mov      r0, #4
a0451a1c mov      r1, #0xe
a0451a20 movw     r2, #0x7fe
a0451a24 bl       #0xa044e734
a0451a28 mov      r0, r8
a0451a2c add      sp, sp, #0x14
a0451a30 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0451a34 movw     r0, #0xd614
a0451a38 movw     r1, #0x19dc
a0451a3c movw     r2, #0xd90c
a0451a40 str      sb, [sp]
a0451a44 str      r4, [sp, #4]
a0451a48 movt     r1, #0xa060
a0451a4c movt     r2, #0xa061
a0451a50 movw     r3, #0x7e1
a0451a54 movt     r0, #0xa061
a0451a58 bl       #0xa02a70ec
a0451a5c b        #0xa04519bc
a0451a60 adds     r0, r8, r5
a0451a64 adc      r1, sb, #0
a0451a68 cmp      r1, fp
a0451a6c cmpeq    r0, sl
a0451a70 movhs    r3, #0
a0451a74 mvnhs    r8, #7
a0451a78 strhs    r3, [r6]
a0451a7c bhs      #0xa04519fc
a0451a80 ldr      sb, [r4, #0x80]
a0451a84 mov      r3, #0
a0451a88 mov      r8, r3
a0451a8c str      sb, [r6]
a0451a90 ldr      r2, [r4, #0x88]
a0451a94 blx      #0xa0506f38
a0451a98 add      ip, sb, r2, lsl #5
a0451a9c mov      r1, #0xe
a0451aa0 movw     r2, #0x7fa
a0451aa4 str      ip, [r6]
a0451aa8 mov      r3, r4
a0451aac ldr      lr, [ip, #8]
a0451ab0 mov      r0, #1
a0451ab4 str      lr, [sp]
a0451ab8 ldr      lr, [ip, #0x14]
a0451abc str      lr, [sp, #4]
a0451ac0 ldr      ip, [ip, #0x18]
a0451ac4 str      ip, [sp, #8]
a0451ac8 bl       #0xa044e734
a0451acc b        #0xa04519fc
a0451ad0 movw     r0, #0xcc5c
a0451ad4 movw     r1, #0x19dc
a0451ad8 movw     r2, #0xd90c
a0451adc stm      sp, {r3, r4}
a0451ae0 movt     r0, #0xa061
a0451ae4 movt     r1, #0xa060
a0451ae8 movt     r2, #0xa061
a0451aec movw     r3, #0x7d9
a0451af0 bl       #0xa02a70ec
a0451af4 mvn      r0, #0
a0451af8 b        #0xa0451a2c

FUNCTION 0xa01f6be8
a01f6be8 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01f6bec sub      sp, sp, #0x4c
a01f6bf0 ldrd     r2, r3, [r1, #8]
a01f6bf4 cmp      r0, #0
a01f6bf8 mov      r4, r0
a01f6bfc mov      fp, r1
a01f6c00 ldrb     r8, [r0, #0x7f]
a01f6c04 strd     r2, r3, [sp, #0x30]
a01f6c08 ldr      r3, [r0, #0xc]
a01f6c0c str      r3, [sp, #0x24]
a01f6c10 beq      #0xa01f6da4
a01f6c14 cmp      r1, #0
a01f6c18 beq      #0xa01f6e3c
a01f6c1c ldrb     r3, [r0, #0x89]
a01f6c20 cmp      r3, #1
a01f6c24 beq      #0xa01f6c4c
a01f6c28 movw     r0, #0xaba8
a01f6c2c movw     r1, #0x4628
a01f6c30 movt     r1, #0xa058
a01f6c34 movw     r2, #0x135
a01f6c38 movt     r0, #0xa053
a01f6c3c bl       #0xa02a70ec
a01f6c40 bl       #0xa02a7524
a01f6c44 cpsid    if
a01f6c48 b        #0xa01f6c48
a01f6c4c ldr      r0, [sp, #0x24]
a01f6c50 mov      r1, r8
a01f6c54 blx      #0xa0506674
a01f6c58 cmp      r1, #0
a01f6c5c bne      #0xa01f6e18
a01f6c60 cmp      r8, #0x10
a01f6c64 bhi      #0xa01f6e60
a01f6c68 mov      r1, r8
a01f6c6c ldr      r0, [sp, #0x24]
a01f6c70 blx      #0xa0506418
a01f6c74 ldrb     ip, [r4, #0x7d]
a01f6c78 mov      sl, r0
a01f6c7c ldr      sb, [r4, #0x40]
a01f6c80 mov      r7, #0
a01f6c84 ldr      lr, [r4, #0x6c]
a01f6c88 mov      r3, #0
a01f6c8c cmp      ip, #2
a01f6c90 str      ip, [sp, #0x44]
a01f6c94 movne    r5, r0
a01f6c98 lsleq    r5, r0, #1
a01f6c9c ldr      r0, [r4, #0x68]
a01f6ca0 lsr      r2, r5, #1
a01f6ca4 ldr      ip, [r4, #4]
a01f6ca8 mov      r6, r2
a01f6cac umull    r0, r1, r0, sb
a01f6cb0 strd     r6, r7, [sp, #0x38]
a01f6cb4 ldrd     r6, r7, [r4, #0x58]
a01f6cb8 mov      r2, ip
a01f6cbc strd     r0, r1, [sp, #0x28]
a01f6cc0 ldrd     r0, r1, [sp, #0x30]
a01f6cc4 str      ip, [sp, #0x30]
a01f6cc8 add      ip, r4, #0x40
a01f6ccc str      ip, [sp, #0x40]
a01f6cd0 subs     r0, r0, r6
a01f6cd4 sbc      r1, r1, r7
a01f6cd8 mov      r6, r0
a01f6cdc mov      r7, r1
a01f6ce0 ldr      r1, [sp, #0x2c]
a01f6ce4 mla      r1, sb, lr, r1
a01f6ce8 str      r1, [sp, #0x2c]
a01f6cec ldrd     r0, r1, [sp, #0x28]
a01f6cf0 blx      #0xa0506f38
a01f6cf4 ldr      ip, [sp, #0x30]
a01f6cf8 subs     r6, r6, r0
a01f6cfc sbc      r7, r7, r1
a01f6d00 mov      r2, sb
a01f6d04 mov      r3, #0
a01f6d08 umull    r0, r1, r6, ip
a01f6d0c mla      r1, ip, r7, r1
a01f6d10 blx      #0xa0506f38
a01f6d14 ldrd     r6, r7, [sp, #0x38]
a01f6d18 mov      r2, r5
a01f6d1c mov      r3, #0
a01f6d20 adds     r6, r6, r0
a01f6d24 adc      r7, r7, r1
a01f6d28 mov      r0, r6
a01f6d2c mov      r1, r7
a01f6d30 blx      #0xa0506f38
a01f6d34 umull    r6, r7, r0, r5
a01f6d38 ldr      ip, [sp, #0x44]
a01f6d3c cmp      ip, #2
a01f6d40 mla      r7, r5, r1, r7
a01f6d44 ldrne    r5, [sp, #0x24]
a01f6d48 strd     r6, r7, [r4, #0x60]
a01f6d4c ldrb     sb, [fp, #0x10]
a01f6d50 beq      #0xa01f6dc8
a01f6d54 ldrh     r8, [r4, #0x78]
a01f6d58 cmp      r8, #1
a01f6d5c beq      #0xa01f6ef8
a01f6d60 cmp      sb, #4
a01f6d64 beq      #0xa01f6eb8
a01f6d68 sub      r3, r8, #1
a01f6d6c ldrd     sl, fp, [r4, #0x20]
a01f6d70 mul      r5, r3, r5
a01f6d74 ldrd     r2, r3, [r4, #0x50]
a01f6d78 subs     r0, sl, r2
a01f6d7c sbc      r1, fp, r3
a01f6d80 adds     r2, r0, r5
a01f6d84 adc      r3, r1, #0
a01f6d88 cmp      r7, r3
a01f6d8c cmpeq    r6, r2
a01f6d90 bne      #0xa01f6e7c
a01f6d94 mov      r0, r6
a01f6d98 mov      r1, r7
a01f6d9c add      sp, sp, #0x4c
a01f6da0 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01f6da4 movw     r0, #0xaba8
a01f6da8 movw     r1, #0x4628
a01f6dac movt     r1, #0xa058
a01f6db0 movw     r2, #0x133
a01f6db4 movt     r0, #0xa053
a01f6db8 bl       #0xa02a70ec
a01f6dbc bl       #0xa02a7524
a01f6dc0 cpsid    if
a01f6dc4 b        #0xa01f6dc4
a01f6dc8 ldr      r3, [sp, #0x24]
a01f6dcc mov      r1, r8
a01f6dd0 lsl      r5, r3, #1
a01f6dd4 mov      r0, r5
a01f6dd8 blx      #0xa0506418
a01f6ddc mov      r1, r8
a01f6de0 mov      sl, r0
a01f6de4 mov      r0, r5
a01f6de8 blx      #0xa0506674
a01f6dec cmp      r1, #0
a01f6df0 beq      #0xa01f6d54
a01f6df4 movw     r0, #0xaba8
a01f6df8 movw     r1, #0x4610
a01f6dfc movt     r1, #0xa058
a01f6e00 movw     r2, #0x102
a01f6e04 movt     r0, #0xa053
a01f6e08 bl       #0xa02a70ec
a01f6e0c bl       #0xa02a7524
a01f6e10 cpsid    if
a01f6e14 b        #0xa01f6e14
a01f6e18 movw     r0, #0xaba8
a01f6e1c movw     r1, #0x4628
a01f6e20 movt     r1, #0xa058
a01f6e24 movw     r2, #0x136
a01f6e28 movt     r0, #0xa053
a01f6e2c bl       #0xa02a70ec
a01f6e30 bl       #0xa02a7524
a01f6e34 cpsid    if
a01f6e38 b        #0xa01f6e38
a01f6e3c movw     r0, #0xaba8
a01f6e40 movw     r1, #0x4628
a01f6e44 movt     r1, #0xa058
a01f6e48 mov      r2, #0x134
a01f6e4c movt     r0, #0xa053
a01f6e50 bl       #0xa02a70ec
a01f6e54 bl       #0xa02a7524
a01f6e58 cpsid    if
a01f6e5c b        #0xa01f6e5c
a01f6e60 movw     r1, #0x4628
a01f6e64 mov      r0, #0x144
a01f6e68 movt     r1, #0xa058
a01f6e6c mvn      r6, #0
a01f6e70 mvn      r7, #0
a01f6e74 bl       #0xa01f6850
a01f6e78 b        #0xa01f6d94
a01f6e7c ldr      r2, [sp, #0x40]
a01f6e80 movw     r0, #0x4458
a01f6e84 movw     r1, #0x4610
a01f6e88 movt     r0, #0xa058
a01f6e8c strd     r6, r7, [sp]
a01f6e90 str      sb, [sp, #8]
a01f6e94 ldr      r3, [sp, #0x24]
a01f6e98 movt     r1, #0xa058
a01f6e9c str      r8, [sp, #0xc]
a01f6ea0 strd     sl, fp, [sp, #0x10]
a01f6ea4 str      r3, [sp, #0x18]
a01f6ea8 bl       #0xa02a70ec
a01f6eac mvn      r6, #0
a01f6eb0 mvn      r7, #0
a01f6eb4 b        #0xa01f6d94
a01f6eb8 ldrd     r2, r3, [r4, #0x50]
a01f6ebc ldrd     sl, fp, [r4, #0x20]
a01f6ec0 subs     r0, sl, r2
a01f6ec4 sbc      r1, fp, r3
a01f6ec8 subs     r2, r0, r5
a01f6ecc sbc      r3, r1, #0
a01f6ed0 cmp      r7, r3
a01f6ed4 cmpeq    r6, r2
a01f6ed8 beq      #0xa01f6d94
a01f6edc movw     r0, #0x43f4
a01f6ee0 movw     r1, #0x4610
a01f6ee4 strd     r6, r7, [sp]
a01f6ee8 movt     r0, #0xa058
a01f6eec ldr      r2, [sp, #0x40]
a01f6ef0 str      sb, [sp, #8]
a01f6ef4 b        #0xa01f6e94
a01f6ef8 ldr      ip, [r4, #0x20]
a01f6efc ldr      sb, [r4, #0x50]
a01f6f00 ldr      r3, [r4, #0x24]
a01f6f04 str      ip, [sp, #0x24]
a01f6f08 rsb      sb, ip, sb
a01f6f0c adds     sb, sb, r6
a01f6f10 str      r3, [sp, #0x28]
a01f6f14 beq      #0xa01f6d94
a01f6f18 eor      fp, sb, sb, asr #31
a01f6f1c mov      r1, sl
a01f6f20 sub      fp, fp, sb, asr #31
a01f6f24 mov      r0, fp
a01f6f28 blx      #0xa0506674
a01f6f2c cmp      r1, #0
a01f6f30 ldr      r2, [r4, #0x10]
a01f6f34 ldr      ip, [sp, #0x24]
a01f6f38 ldr      r3, [sp, #0x28]
a01f6f3c bne      #0xa01f7010
a01f6f40 str      r3, [sp, #0xc]
a01f6f44 movw     r0, #0x44c0
a01f6f48 ldr      r3, [sp, #0x30]
a01f6f4c movw     r1, #0x4610
a01f6f50 strd     r6, r7, [sp]
a01f6f54 movt     r0, #0xa058
a01f6f58 str      ip, [sp, #8]
a01f6f5c movt     r1, #0xa058
a01f6f60 str      r3, [sp, #0x14]
a01f6f64 str      r5, [sp, #0x10]
a01f6f68 bl       #0xa02a70ec
a01f6f6c ldrb     r3, [r4, #0x7d]
a01f6f70 strb     r8, [r4, #0x82]
a01f6f74 cmp      r3, #2
a01f6f78 beq      #0xa01f6ff4
a01f6f7c ldr      r5, [r4, #0xc]
a01f6f80 mov      r1, sl
a01f6f84 add      r5, sb, r5
a01f6f88 str      r5, [r4, #0xc]
a01f6f8c mov      r0, r5
a01f6f90 blx      #0xa0506418
a01f6f94 uxtb     r2, r0
a01f6f98 cmp      r2, #0x10
a01f6f9c strb     r2, [r4, #0x7f]
a01f6fa0 bhi      #0xa01f6fdc
a01f6fa4 ldrd     r6, r7, [r4, #0x20]
a01f6fa8 movw     r0, #0x4558
a01f6fac movw     r1, #0x4610
a01f6fb0 mov      r2, r5
a01f6fb4 movt     r0, #0xa058
a01f6fb8 movt     r1, #0xa058
a01f6fbc adds     sl, r6, sb
a01f6fc0 adc      fp, r7, sb, asr #31
a01f6fc4 strd     sl, fp, [r4, #0x20]
a01f6fc8 strd     sl, fp, [r4, #0x28]
a01f6fcc strd     sl, fp, [sp]
a01f6fd0 bl       #0xa02a70ec
a01f6fd4 ldrd     r6, r7, [r4, #0x60]
a01f6fd8 b        #0xa01f6d94
a01f6fdc movw     r0, #0x450c
a01f6fe0 movw     r1, #0x4610
a01f6fe4 movt     r1, #0xa058
a01f6fe8 movt     r0, #0xa058
a01f6fec bl       #0xa02a70ec
a01f6ff0 b        #0xa01f6eac
a01f6ff4 tst      fp, #1
a01f6ff8 bne      #0xa01f7038
a01f6ffc ldr      r5, [r4, #0xc]
a01f7000 add      r3, sb, sb, lsr #31
a01f7004 lsr      r1, sl, #1
a01f7008 add      r5, r5, r3, asr #1
a01f700c b        #0xa01f6f88
a01f7010 movw     r0, #0x4588
a01f7014 movw     r1, #0x4610
a01f7018 strd     r6, r7, [sp]
a01f701c movt     r1, #0xa058
a01f7020 str      ip, [sp, #8]
a01f7024 movt     r0, #0xa058
a01f7028 str      r3, [sp, #0xc]
a01f702c str      r5, [sp, #0x10]
a01f7030 bl       #0xa02a70ec
a01f7034 b        #0xa01f6eac
a01f7038 movw     r0, #0xaba8
a01f703c movw     r1, #0x4610
a01f7040 movt     r1, #0xa058
a01f7044 movw     r2, #0x116
a01f7048 movt     r0, #0xa053
a01f704c bl       #0xa02a70ec
a01f7050 bl       #0xa02a7524
a01f7054 cpsid    if
a01f7058 b        #0xa01f7058

FUNCTION 0xa01f69b0
a01f69b0 cmp      r0, #0
a01f69b4 push     {r3, r4, r5, r6, r7, lr}
a01f69b8 beq      #0xa01f6b20
a01f69bc ldrb     r2, [r0]
a01f69c0 cmp      r2, #1
a01f69c4 beq      #0xa01f6a5c
a01f69c8 cmp      r2, #3
a01f69cc bne      #0xa01f6a44
a01f69d0 ldrb     r1, [r0, #0x5f0]
a01f69d4 cmp      r1, #0
a01f69d8 beq      #0xa01f6b18
a01f69dc ldrb     r2, [r0, #0x101]
a01f69e0 add      ip, r0, #0x78
a01f69e4 cmp      r2, #2
a01f69e8 bne      #0xa01f6af4
a01f69ec mov      r2, #0
a01f69f0 add      r3, r0, #0x108
a01f69f4 mvn      r6, #0
a01f69f8 mov      r0, r2
a01f69fc mvn      r7, #0
a01f6a00 b        #0xa01f6a10
a01f6a04 ldrb     lr, [r3, #-7]
a01f6a08 cmp      lr, #2
a01f6a0c bne      #0xa01f6af4
a01f6a10 ldrd     r4, r5, [r3, #-0x70]
a01f6a14 add      r2, r2, #1
a01f6a18 mov      lr, r3
a01f6a1c add      r3, r3, #0x90
a01f6a20 cmp      r5, r7
a01f6a24 cmpeq    r4, r6
a01f6a28 movlo    r0, ip
a01f6a2c movlo    r6, r4
a01f6a30 movlo    r7, r5
a01f6a34 cmp      r1, r2
a01f6a38 mov      ip, lr
a01f6a3c bhi      #0xa01f6a04
a01f6a40 pop      {r3, r4, r5, r6, r7, pc}
a01f6a44 movw     r1, #0x4338
a01f6a48 mov      r0, #0xe9
a01f6a4c movt     r1, #0xa058
a01f6a50 bl       #0xa01f6850
a01f6a54 mov      r0, #0
a01f6a58 pop      {r3, r4, r5, r6, r7, pc}
a01f6a5c ldrb     r1, [r0, #0x6f4]
a01f6a60 cmp      r1, #0
a01f6a64 beq      #0xa01f6b18
a01f6a68 ldrb     r2, [r0, #0x101]
a01f6a6c add      ip, r0, #0x78
a01f6a70 cmp      r2, #3
a01f6a74 bhi      #0xa01f6ad0
a01f6a78 mov      r2, #0
a01f6a7c add      r3, r0, #0x108
a01f6a80 mvn      r6, #0
a01f6a84 mov      r0, r2
a01f6a88 mvn      r7, #0
a01f6a8c b        #0xa01f6a9c
a01f6a90 ldrb     lr, [r3, #-7]
a01f6a94 cmp      lr, #3
a01f6a98 bhi      #0xa01f6ad0
a01f6a9c ldrd     r4, r5, [r3, #-0x70]
a01f6aa0 add      r2, r2, #1
a01f6aa4 mov      lr, r3
a01f6aa8 add      r3, r3, #0x90
a01f6aac cmp      r5, r7
a01f6ab0 cmpeq    r4, r6
a01f6ab4 movlo    r0, ip
a01f6ab8 movlo    r6, r4
a01f6abc movlo    r7, r5
a01f6ac0 cmp      r1, r2
a01f6ac4 mov      ip, lr
a01f6ac8 bhi      #0xa01f6a90
a01f6acc pop      {r3, r4, r5, r6, r7, pc}
a01f6ad0 movw     r0, #0xaba8
a01f6ad4 movw     r1, #0x4338
a01f6ad8 movt     r1, #0xa058
a01f6adc mov      r2, #0xd2
a01f6ae0 movt     r0, #0xa053
a01f6ae4 bl       #0xa02a70ec
a01f6ae8 bl       #0xa02a7524
a01f6aec cpsid    if
a01f6af0 b        #0xa01f6af0
a01f6af4 movw     r0, #0xaba8
a01f6af8 movw     r1, #0x4338
a01f6afc movt     r1, #0xa058
a01f6b00 mov      r2, #0xe0
a01f6b04 movt     r0, #0xa053
a01f6b08 bl       #0xa02a70ec
a01f6b0c bl       #0xa02a7524
a01f6b10 cpsid    if
a01f6b14 b        #0xa01f6b14
a01f6b18 mov      r0, r1
a01f6b1c pop      {r3, r4, r5, r6, r7, pc}
a01f6b20 movw     r0, #0xaba8
a01f6b24 movw     r1, #0x4338
a01f6b28 movt     r1, #0xa058
a01f6b2c mov      r2, #0xca
a01f6b30 movt     r0, #0xa053
a01f6b34 bl       #0xa02a70ec
a01f6b38 bl       #0xa02a7524
a01f6b3c cpsid    if
a01f6b40 b        #0xa01f6b40

FUNCTION 0xa01f721c
a01f6b44 cmp      r0, #0
a01f6b48 push     {r3, lr}
a01f6b4c beq      #0xa01f6bc4
a01f6b50 ldrb     r3, [r0, #0x89]
a01f6b54 cmp      r3, #1
a01f6b58 beq      #0xa01f6b80
a01f6b5c movw     r0, #0xaba8
a01f6b60 movw     r1, #0x45f8
a01f6b64 movt     r1, #0xa058
a01f6b68 mov      r2, #0xf3
a01f6b6c movt     r0, #0xa053
a01f6b70 bl       #0xa02a70ec
a01f6b74 bl       #0xa02a7524
a01f6b78 cpsid    if
a01f6b7c b        #0xa01f6b7c
a01f6b80 ldrb     r3, [r0, #0x7e]
a01f6b84 cmp      r3, #0
a01f6b88 bne      #0xa01f6ba8
a01f6b8c ldr      r3, [r0, #0xc]
a01f6b90 ldrh     r2, [r0, #0x78]
a01f6b94 sub      r2, r2, #1
a01f6b98 mul      r2, r3, r2
a01f6b9c rsbs     r2, r2, #0
a01f6ba0 sbc      r3, r3, r3
a01f6ba4 strd     r2, r3, [r0, #0x68]
a01f6ba8 mov      r2, #0
a01f6bac mov      r3, #0
a01f6bb0 mov      r1, #0
a01f6bb4 strd     r2, r3, [r0, #0x58]
a01f6bb8 str      r1, [r0, #0x48]
a01f6bbc strd     r2, r3, [r0, #0x60]
a01f6bc0 pop      {r3, pc}
a01f6bc4 movw     r0, #0xaba8
a01f6bc8 movw     r1, #0x45f8
a01f6bcc movt     r1, #0xa058
a01f6bd0 mov      r2, #0xf2
a01f6bd4 movt     r0, #0xa053
a01f6bd8 bl       #0xa02a70ec
a01f6bdc bl       #0xa02a7524
a01f6be0 cpsid    if
a01f6be4 b        #0xa01f6be4
a01f721c push     {r3, lr}
a01f7220 subs     r3, r0, #0
a01f7224 beq      #0xa01f7268
a01f7228 ldrb     r2, [r3, #0x89]
a01f722c cmp      r2, #1
a01f7230 beq      #0xa01f7258
a01f7234 movw     r0, #0xaba8
a01f7238 movw     r1, #0x431c
a01f723c movt     r1, #0xa058
a01f7240 movw     r2, #0x173
a01f7244 movt     r0, #0xa053
a01f7248 bl       #0xa02a70ec
a01f724c bl       #0xa02a7524
a01f7250 cpsid    if
a01f7254 b        #0xa01f7254
a01f7258 mov      r2, #0
a01f725c strb     r2, [r3, #0x7e]
a01f7260 pop      {r3, lr}
a01f7264 b        #0xa01f6b44
a01f7268 movw     r0, #0xaba8
a01f726c movw     r1, #0x431c
a01f7270 movt     r1, #0xa058
a01f7274 movw     r2, #0x172
a01f7278 movt     r0, #0xa053
a01f727c bl       #0xa02a70ec
a01f7280 bl       #0xa02a7524
a01f7284 cpsid    if
a01f7288 b        #0xa01f7288

FUNCTION 0xa04404d8
a0440394 push     {r4, r5, lr}
a0440398 mov      r3, #0
a044039c ldrb     r1, [r0, #0x5f0]
a04403a0 sub      sp, sp, #0xac
a04403a4 cmp      r1, r3
a04403a8 add      r0, r0, #0x90
a04403ac add      r3, r3, #1
a04403b0 bls      #0xa0440420
a04403b4 ldrb     r2, [r0, #0x71]
a04403b8 cmp      r2, #2
a04403bc beq      #0xa0440414
a04403c0 movw     lr, #0x8ff4
a04403c4 add      ip, sp, #8
a04403c8 movt     lr, #0xa061
a04403cc movw     r4, #0x307c
a04403d0 ldm      lr!, {r0, r1, r2, r3}
a04403d4 movt     r4, #0xa06f
a04403d8 mov      r5, #0
a04403dc str      ip, [sp]
a04403e0 strb     r5, [sp, #0xa7]
a04403e4 ldr      lr, [lr]
a04403e8 stm      ip!, {r0, r1, r2, r3}
a04403ec movw     r0, #0x3148
a04403f0 movw     r2, #0xaa1c
a04403f4 ldr      r1, [r4]
a04403f8 movt     r0, #0xa061
a04403fc movt     r2, #0xa061
a0440400 movw     r3, #0x293
a0440404 strh     lr, [ip]
a0440408 bl       #0xa02a70ec
a044040c mvn      r0, #0
a0440410 b        #0xa0440424
a0440414 ldrd     r4, r5, [r0, #0x10]
a0440418 strd     r4, r5, [r0, #8]
a044041c b        #0xa04403a4
a0440420 mov      r0, #0
a0440424 add      sp, sp, #0xac
a0440428 pop      {r4, r5, pc}
a04404d8 push     {r3, lr}
a04404dc mov      r3, r0
a04404e0 ldrb     r2, [r0]
a04404e4 cmp      r2, #1
a04404e8 beq      #0xa0440520
a04404ec cmp      r2, #2
a04404f0 beq      #0xa044054c
a04404f4 cmp      r2, #3
a04404f8 beq      #0xa0440554
a04404fc movw     r0, #0xaba8
a0440500 movw     r1, #0xa92c
a0440504 movt     r1, #0xa061
a0440508 movw     r2, #0x2ad
a044050c movt     r0, #0xa053
a0440510 bl       #0xa02a70ec
a0440514 bl       #0xa02a7524
a0440518 cpsid    if
a044051c b        #0xa044051c
a0440520 ldrb     r1, [r0, #0x6f4]
a0440524 cmp      r1, #0
a0440528 beq      #0xa044054c
a044052c lsl      r2, r1, #7
a0440530 add      r2, r2, r1, lsl #4
a0440534 add      r2, r0, r2
a0440538 ldrd     r0, r1, [r3, #0xa0]
a044053c add      r3, r3, #0x90
a0440540 strd     r0, r1, [r3, #8]
a0440544 cmp      r3, r2
a0440548 bne      #0xa0440538
a044054c mov      r0, #0
a0440550 pop      {r3, pc}
a0440554 pop      {r3, lr}
a0440558 b        #0xa0440394

FUNCTION 0xa01f68b8
a01f68b8 ldrb     r2, [r0]
a01f68bc cmp      r2, #2
a01f68c0 beq      #0xa01f6984
a01f68c4 cmp      r2, #3
a01f68c8 push     {r3, lr}
a01f68cc mov      r3, r0
a01f68d0 beq      #0xa01f6930
a01f68d4 cmp      r2, #1
a01f68d8 beq      #0xa01f68f4
a01f68dc movw     r1, #0x4644
a01f68e0 mov      r0, #0x36
a01f68e4 movt     r1, #0xa058
a01f68e8 bl       #0xa01f6850
a01f68ec mvn      r0, #0
a01f68f0 pop      {r3, pc}
a01f68f4 ldrb     r2, [r0, #0x6f4]
a01f68f8 cmp      r2, #0
a01f68fc beq      #0xa01f6928
a01f6900 mov      r1, #0
a01f6904 mov      r2, r0
a01f6908 mov      r0, r1
a01f690c str      r0, [r2, #0x8c]
a01f6910 add      r1, r1, #1
a01f6914 str      r0, [r2, #0x88]
a01f6918 add      r2, r2, #0x90
a01f691c ldrb     ip, [r3, #0x6f4]
a01f6920 cmp      r1, ip
a01f6924 blo      #0xa01f690c
a01f6928 mov      r0, #0
a01f692c pop      {r3, pc}
a01f6930 ldrb     r2, [r0, #0x5f0]
a01f6934 cmp      r2, #0
a01f6938 beq      #0xa01f6928
a01f693c ldrb     r2, [r0, #0x101]
a01f6940 cmp      r2, #2
a01f6944 moveq    r1, #0
a01f6948 moveq    r2, r0
a01f694c moveq    r0, r1
a01f6950 beq      #0xa01f6964
a01f6954 b        #0xa01f698c
a01f6958 ldrb     ip, [r2, #0x101]
a01f695c cmp      ip, #2
a01f6960 bne      #0xa01f698c
a01f6964 str      r0, [r2, #0x8c]
a01f6968 add      r1, r1, #1
a01f696c str      r0, [r2, #0x88]
a01f6970 add      r2, r2, #0x90
a01f6974 ldrb     ip, [r3, #0x5f0]
a01f6978 cmp      r1, ip
a01f697c blo      #0xa01f6958
a01f6980 b        #0xa01f6928
a01f6984 mov      r0, #0
a01f6988 bx       lr
a01f698c movw     r0, #0xaba8
a01f6990 movw     r1, #0x45d4
a01f6994 movt     r1, #0xa058
a01f6998 mov      r2, #0x22
a01f699c movt     r0, #0xa053
a01f69a0 bl       #0xa02a70ec
a01f69a4 bl       #0xa02a7524
a01f69a8 cpsid    if
a01f69ac b        #0xa01f69ac

FUNCTION 0xa03e5b5c
a03e5b5c push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03e5b60 sub      sp, sp, #0xec
a03e5b64 ldrd     r2, r3, [r1, #8]
a03e5b68 cmp      r0, #0
a03e5b6c mov      r4, r0
a03e5b70 mov      fp, r1
a03e5b74 ldrb     r8, [r0, #0x7f]
a03e5b78 strd     r2, r3, [sp, #0x30]
a03e5b7c ldr      r3, [r0, #0xc]
a03e5b80 str      r3, [sp, #0x24]
a03e5b84 beq      #0xa03e5d18
a03e5b88 cmp      r1, #0
a03e5b8c beq      #0xa03e5db0
a03e5b90 ldrb     r3, [r0, #0x89]
a03e5b94 cmp      r3, #1
a03e5b98 beq      #0xa03e5bc0
a03e5b9c movw     r0, #0xaba8
a03e5ba0 movw     r1, #0x403c
a03e5ba4 movt     r1, #0xa061
a03e5ba8 mov      r2, #0x8c
a03e5bac movt     r0, #0xa053
a03e5bb0 bl       #0xa02a70ec
a03e5bb4 bl       #0xa02a7524
a03e5bb8 cpsid    if
a03e5bbc b        #0xa03e5bbc
a03e5bc0 ldr      r0, [sp, #0x24]
a03e5bc4 mov      r1, r8
a03e5bc8 blx      #0xa0506674
a03e5bcc subs     lr, r1, #0
a03e5bd0 bne      #0xa03e5d8c
a03e5bd4 cmp      r8, #0x10
a03e5bd8 bhi      #0xa03e5dd4
a03e5bdc mov      r1, r8
a03e5be0 ldr      r0, [sp, #0x24]
a03e5be4 blx      #0xa0506418
a03e5be8 ldrb     ip, [r4, #0x7d]
a03e5bec mov      sl, r0
a03e5bf0 ldr      sb, [r4, #0x40]
a03e5bf4 mov      r7, #0
a03e5bf8 ldr      lr, [r4, #0x6c]
a03e5bfc mov      r3, #0
a03e5c00 cmp      ip, #2
a03e5c04 str      ip, [sp, #0x44]
a03e5c08 movne    r5, r0
a03e5c0c lsleq    r5, r0, #1
a03e5c10 ldr      r0, [r4, #0x68]
a03e5c14 lsr      r2, r5, #1
a03e5c18 ldr      ip, [r4, #4]
a03e5c1c mov      r6, r2
a03e5c20 umull    r0, r1, r0, sb
a03e5c24 strd     r6, r7, [sp, #0x38]
a03e5c28 ldrd     r6, r7, [r4, #0x58]
a03e5c2c mov      r2, ip
a03e5c30 strd     r0, r1, [sp, #0x28]
a03e5c34 ldrd     r0, r1, [sp, #0x30]
a03e5c38 str      ip, [sp, #0x30]
a03e5c3c add      ip, r4, #0x40
a03e5c40 str      ip, [sp, #0x40]
a03e5c44 subs     r0, r0, r6
a03e5c48 sbc      r1, r1, r7
a03e5c4c mov      r6, r0
a03e5c50 mov      r7, r1
a03e5c54 ldr      r1, [sp, #0x2c]
a03e5c58 mla      r1, sb, lr, r1
a03e5c5c str      r1, [sp, #0x2c]
a03e5c60 ldrd     r0, r1, [sp, #0x28]
a03e5c64 blx      #0xa0506f38
a03e5c68 ldr      ip, [sp, #0x30]
a03e5c6c subs     r6, r6, r0
a03e5c70 sbc      r7, r7, r1
a03e5c74 mov      r2, sb
a03e5c78 mov      r3, #0
a03e5c7c umull    r0, r1, r6, ip
a03e5c80 mla      r1, ip, r7, r1
a03e5c84 blx      #0xa0506f38
a03e5c88 ldrd     r6, r7, [sp, #0x38]
a03e5c8c mov      r2, r5
a03e5c90 mov      r3, #0
a03e5c94 adds     r6, r6, r0
a03e5c98 adc      r7, r7, r1
a03e5c9c mov      r0, r6
a03e5ca0 mov      r1, r7
a03e5ca4 blx      #0xa0506f38
a03e5ca8 umull    r6, r7, r0, r5
a03e5cac ldr      ip, [sp, #0x44]
a03e5cb0 cmp      ip, #2
a03e5cb4 mla      r7, r5, r1, r7
a03e5cb8 ldrne    r5, [sp, #0x24]
a03e5cbc strd     r6, r7, [r4, #0x60]
a03e5cc0 ldrb     sb, [fp, #0x10]
a03e5cc4 beq      #0xa03e5d3c
a03e5cc8 ldrh     r8, [r4, #0x78]
a03e5ccc cmp      r8, #1
a03e5cd0 beq      #0xa03e5eac
a03e5cd4 cmp      sb, #4
a03e5cd8 beq      #0xa03e5e6c
a03e5cdc sub      r3, r8, #1
a03e5ce0 ldrd     sl, fp, [r4, #0x20]
a03e5ce4 mul      r5, r3, r5
a03e5ce8 ldrd     r2, r3, [r4, #0x50]
a03e5cec subs     r0, sl, r2
a03e5cf0 sbc      r1, fp, r3
a03e5cf4 adds     r2, r0, r5
a03e5cf8 adc      r3, r1, #0
a03e5cfc cmp      r7, r3
a03e5d00 cmpeq    r6, r2
a03e5d04 bne      #0xa03e5e30
a03e5d08 mov      r0, r6
a03e5d0c mov      r1, r7
a03e5d10 add      sp, sp, #0xec
a03e5d14 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03e5d18 movw     r0, #0xaba8
a03e5d1c movw     r1, #0x403c
a03e5d20 movt     r1, #0xa061
a03e5d24 mov      r2, #0x8a
a03e5d28 movt     r0, #0xa053
a03e5d2c bl       #0xa02a70ec
a03e5d30 bl       #0xa02a7524
a03e5d34 cpsid    if
a03e5d38 b        #0xa03e5d38
a03e5d3c ldr      r3, [sp, #0x24]
a03e5d40 mov      r1, r8
a03e5d44 lsl      r5, r3, #1
a03e5d48 mov      r0, r5
a03e5d4c blx      #0xa0506418
a03e5d50 mov      r1, r8
a03e5d54 mov      sl, r0
a03e5d58 mov      r0, r5
a03e5d5c blx      #0xa0506674
a03e5d60 cmp      r1, #0
a03e5d64 beq      #0xa03e5cc8
a03e5d68 movw     r0, #0xaba8
a03e5d6c movw     r1, #0x427c
a03e5d70 movt     r1, #0xa061
a03e5d74 mov      r2, #0x59
a03e5d78 movt     r0, #0xa053
a03e5d7c bl       #0xa02a70ec
a03e5d80 bl       #0xa02a7524
a03e5d84 cpsid    if
a03e5d88 b        #0xa03e5d88
a03e5d8c movw     r0, #0xaba8
a03e5d90 movw     r1, #0x403c
a03e5d94 movt     r1, #0xa061
a03e5d98 mov      r2, #0x8d
a03e5d9c movt     r0, #0xa053
a03e5da0 bl       #0xa02a70ec
a03e5da4 bl       #0xa02a7524
a03e5da8 cpsid    if
a03e5dac b        #0xa03e5dac
a03e5db0 movw     r0, #0xaba8
a03e5db4 movw     r1, #0x403c
a03e5db8 movt     r1, #0xa061
a03e5dbc mov      r2, #0x8b
a03e5dc0 movt     r0, #0xa053
a03e5dc4 bl       #0xa02a70ec
a03e5dc8 bl       #0xa02a7524
a03e5dcc cpsid    if
a03e5dd0 b        #0xa03e5dd0
a03e5dd4 movw     r4, #0x3a68
a03e5dd8 movw     r5, #0x307c
a03e5ddc movt     r4, #0xa061
a03e5de0 add      ip, sp, #0x48
a03e5de4 ldm      r4!, {r0, r1, r2, r3}
a03e5de8 movt     r5, #0xa06f
a03e5dec mvn      r6, #0
a03e5df0 mvn      r7, #0
a03e5df4 ldr      r5, [r5]
a03e5df8 str      ip, [sp]
a03e5dfc stm      ip!, {r0, r1, r2, r3}
a03e5e00 movw     r2, #0x403c
a03e5e04 ldm      r4, {r0, r1}
a03e5e08 movt     r2, #0xa061
a03e5e0c mov      r3, #0x9c
a03e5e10 strb     lr, [sp, #0xe7]
a03e5e14 str      r0, [ip], #4
a03e5e18 movw     r0, #0x3148
a03e5e1c strh     r1, [ip]
a03e5e20 movt     r0, #0xa061
a03e5e24 mov      r1, r5
a03e5e28 bl       #0xa02a70ec
a03e5e2c b        #0xa03e5d08
a03e5e30 ldr      r2, [sp, #0x40]
a03e5e34 movw     r0, #0x4458
a03e5e38 movw     r1, #0x427c
a03e5e3c movt     r0, #0xa058
a03e5e40 strd     r6, r7, [sp]
a03e5e44 str      sb, [sp, #8]
a03e5e48 ldr      r3, [sp, #0x24]
a03e5e4c movt     r1, #0xa061
a03e5e50 str      r8, [sp, #0xc]
a03e5e54 strd     sl, fp, [sp, #0x10]
a03e5e58 str      r3, [sp, #0x18]
a03e5e5c bl       #0xa02a70ec
a03e5e60 mvn      r6, #0
a03e5e64 mvn      r7, #0
a03e5e68 b        #0xa03e5d08
a03e5e6c ldrd     r2, r3, [r4, #0x50]
a03e5e70 ldrd     sl, fp, [r4, #0x20]
a03e5e74 subs     r0, sl, r2
a03e5e78 sbc      r1, fp, r3
a03e5e7c subs     r2, r0, r5
a03e5e80 sbc      r3, r1, #0
a03e5e84 cmp      r7, r3
a03e5e88 cmpeq    r6, r2
a03e5e8c beq      #0xa03e5d08
a03e5e90 movw     r0, #0x43f4
a03e5e94 movw     r1, #0x427c
a03e5e98 strd     r6, r7, [sp]
a03e5e9c movt     r0, #0xa058
a03e5ea0 ldr      r2, [sp, #0x40]
a03e5ea4 str      sb, [sp, #8]
a03e5ea8 b        #0xa03e5e48
a03e5eac ldr      ip, [r4, #0x20]
a03e5eb0 ldr      sb, [r4, #0x50]
a03e5eb4 ldr      r3, [r4, #0x24]
a03e5eb8 str      ip, [sp, #0x24]
a03e5ebc rsb      sb, ip, sb
a03e5ec0 adds     sb, sb, r6
a03e5ec4 str      r3, [sp, #0x28]
a03e5ec8 beq      #0xa03e5d08
a03e5ecc eor      fp, sb, sb, asr #31
a03e5ed0 mov      r1, sl
a03e5ed4 sub      fp, fp, sb, asr #31
a03e5ed8 mov      r0, fp
a03e5edc blx      #0xa0506674
a03e5ee0 cmp      r1, #0
a03e5ee4 ldr      r2, [r4, #0x10]
a03e5ee8 ldr      ip, [sp, #0x24]
a03e5eec ldr      r3, [sp, #0x28]
a03e5ef0 bne      #0xa03e5fc4
a03e5ef4 str      r3, [sp, #0xc]
a03e5ef8 movw     r0, #0x44c0
a03e5efc ldr      r3, [sp, #0x30]
a03e5f00 movw     r1, #0x427c
a03e5f04 strd     r6, r7, [sp]
a03e5f08 movt     r0, #0xa058
a03e5f0c str      ip, [sp, #8]
a03e5f10 movt     r1, #0xa061
a03e5f14 str      r3, [sp, #0x14]
a03e5f18 str      r5, [sp, #0x10]
a03e5f1c bl       #0xa02a70ec
a03e5f20 ldrb     r3, [r4, #0x7d]
a03e5f24 strb     r8, [r4, #0x82]
a03e5f28 cmp      r3, #2
a03e5f2c beq      #0xa03e5fa8
a03e5f30 ldr      r5, [r4, #0xc]
a03e5f34 mov      r1, sl
a03e5f38 add      r5, sb, r5
a03e5f3c str      r5, [r4, #0xc]
a03e5f40 mov      r0, r5
a03e5f44 blx      #0xa0506418
a03e5f48 uxtb     r2, r0
a03e5f4c cmp      r2, #0x10
a03e5f50 strb     r2, [r4, #0x7f]
a03e5f54 bhi      #0xa03e5f90
a03e5f58 ldrd     r6, r7, [r4, #0x20]
a03e5f5c movw     r0, #0x4558
a03e5f60 movw     r1, #0x427c
a03e5f64 mov      r2, r5
a03e5f68 movt     r0, #0xa058
a03e5f6c movt     r1, #0xa061
a03e5f70 adds     sl, r6, sb
a03e5f74 adc      fp, r7, sb, asr #31
a03e5f78 strd     sl, fp, [r4, #0x20]
a03e5f7c strd     sl, fp, [r4, #0x28]
a03e5f80 strd     sl, fp, [sp]
a03e5f84 bl       #0xa02a70ec
a03e5f88 ldrd     r6, r7, [r4, #0x60]
a03e5f8c b        #0xa03e5d08
a03e5f90 movw     r0, #0x450c
a03e5f94 movw     r1, #0x427c
a03e5f98 movt     r1, #0xa061
a03e5f9c movt     r0, #0xa058
a03e5fa0 bl       #0xa02a70ec
a03e5fa4 b        #0xa03e5e60
a03e5fa8 tst      fp, #1
a03e5fac bne      #0xa03e5fec
a03e5fb0 ldr      r5, [r4, #0xc]
a03e5fb4 add      r3, sb, sb, lsr #31
a03e5fb8 lsr      r1, sl, #1
a03e5fbc add      r5, r5, r3, asr #1
a03e5fc0 b        #0xa03e5f3c
a03e5fc4 movw     r0, #0x4588
a03e5fc8 movw     r1, #0x427c
a03e5fcc strd     r6, r7, [sp]
a03e5fd0 movt     r1, #0xa061
a03e5fd4 str      ip, [sp, #8]
a03e5fd8 movt     r0, #0xa058
a03e5fdc str      r3, [sp, #0xc]
a03e5fe0 str      r5, [sp, #0x10]
a03e5fe4 bl       #0xa02a70ec
a03e5fe8 b        #0xa03e5e60
a03e5fec movw     r0, #0xaba8
a03e5ff0 movw     r1, #0x427c
a03e5ff4 movt     r1, #0xa061
a03e5ff8 mov      r2, #0x6d
a03e5ffc movt     r0, #0xa053
a03e6000 bl       #0xa02a70ec
a03e6004 bl       #0xa02a7524
a03e6008 cpsid    if
a03e600c b        #0xa03e600c

FUNCTION 0xa029c680
a029c680 movw     r3, #0xc388
a029c684 push     {r4, r5, r6, lr}
a029c688 movt     r3, #0xa03b
a029c68c mov      r4, r0
a029c690 cmp      r3, #0
a029c694 mov      r6, r1
a029c698 mov      r5, r2
a029c69c beq      #0xa029c6ac
a029c6a0 bl       #0xa03bc388
a029c6a4 cmp      r0, #1
a029c6a8 beq      #0xa029c6c4
a029c6ac mov      r0, r4
a029c6b0 mov      r1, r6
a029c6b4 mov      r2, r5
a029c6b8 blx      #0xa029c180
a029c6bc mov      r0, r4
a029c6c0 pop      {r4, r5, r6, pc}
a029c6c4 mov      r0, r4
a029c6c8 mov      r1, r6
a029c6cc mov      r2, r5
a029c6d0 bl       #0xa029bf2c
a029c6d4 mov      r0, r4
a029c6d8 pop      {r4, r5, r6, pc}
