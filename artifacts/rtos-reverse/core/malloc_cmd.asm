a01a88a0 040097e5   ldr      r0, [r7, #4]
a01a88a4 464a0dfa   blx      #0xa04fb1c4
a01a88a8 0f1000e2   and      r1, r0, #0xf
a01a88ac 5032e0e7   ubfx     r3, r0, #4, #1
a01a88b0 1140c0e7   bfi      r4, r1, #0, #1
a01a88b4 d022e0e7   ubfx     r2, r0, #5, #1
a01a88b8 9340c1e7   bfi      r4, r3, #1, #1
a01a88bc 5033e0e7   ubfx     r3, r0, #6, #1
a01a88c0 1241c2e7   bfi      r4, r2, #2, #1
a01a88c4 010051e3   cmp      r1, #1
a01a88c8 9341c3e7   bfi      r4, r3, #3, #1
a01a88cc 5034e3e7   ubfx     r3, r0, #8, #4
a01a88d0 1342cbe7   bfi      r4, r3, #4, #8
a01a88d4 5036e3e7   ubfx     r3, r0, #0xc, #4
a01a88d8 0050a0e1   mov      r5, r0
a01a88dc 1346cfe7   bfi      r4, r3, #0xc, #4
a01a88e0 040000da   ble      #0xa01a88f8
a01a88e4 600209e3   movw     r0, #0x9260
a01a88e8 0120a0e3   mov      r2, #1
a01a88ec 56004ae3   movt     r0, #0xa056
a01a88f0 024084e1   orr      r4, r4, r2
a01a88f4 36ff2fe1   blx      r6
a01a88f8 a40209e3   movw     r0, #0x92a4
a01a88fc 0510a0e1   mov      r1, r5
a01a8900 0420a0e1   mov      r2, r4
a01a8904 56004ae3   movt     r0, #0xa056
a01a8908 36ff2fe1   blx      r6
a01a890c 0000a0e3   mov      r0, #0
a01a8910 f081bde8   pop      {r4, r5, r6, r7, r8, pc}
a01a8914 0410a0e1   mov      r1, r4
a01a8918 0420a0e1   mov      r2, r4
a01a891c 040097e5   ldr      r0, [r7, #4]
a01a8920 0450a0e1   mov      r5, r4
a01a8924 264a0dfa   blx      #0xa04fb1c4
a01a8928 012000e2   and      r2, r0, #1
a01a892c d030e0e7   ubfx     r3, r0, #1, #1
a01a8930 1250c3e7   bfi      r5, r2, #0, #4
a01a8934 5021e0e7   ubfx     r2, r0, #2, #1
a01a8938 1352c4e7   bfi      r5, r3, #4, #1
a01a893c 5012e7e7   ubfx     r1, r0, #4, #8
a01a8940 d031e0e7   ubfx     r3, r0, #3, #1
a01a8944 9252c5e7   bfi      r5, r2, #5, #1
a01a8948 1353c6e7   bfi      r5, r3, #6, #1
a01a894c 0f0051e3   cmp      r1, #0xf
a01a8950 1154cbe7   bfi      r5, r1, #8, #4
a01a8954 5036e3e7   ubfx     r3, r0, #0xc, #4
a01a8958 0040a0e1   mov      r4, r0
a01a895c 1356cfe7   bfi      r5, r3, #0xc, #4
a01a8960 0600008a   bhi      #0xa01a8980
a01a8964 100309e3   movw     r0, #0x9310
a01a8968 0410a0e1   mov      r1, r4
a01a896c 0520a0e1   mov      r2, r5
a01a8970 56004ae3   movt     r0, #0xa056
a01a8974 36ff2fe1   blx      r6
a01a8978 0000a0e3   mov      r0, #0
a01a897c f081bde8   pop      {r4, r5, r6, r7, r8, pc}
a01a8980 d00209e3   movw     r0, #0x92d0
a01a8984 0f20a0e3   mov      r2, #0xf
a01a8988 56004ae3   movt     r0, #0xa056
a01a898c 0f5c85e3   orr      r5, r5, #0xf00
a01a8990 36ff2fe1   blx      r6
a01a8994 f2ffffea   b        #0xa01a8964
a01a8998 010050e3   cmp      r0, #1
a01a899c f04f2de9   push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01a89a0 0070a0e1   mov      r7, r0
a01a89a4 1cd04de2   sub      sp, sp, #0x1c
a01a89a8 0250a0e1   mov      r5, r2
a01a89ac 360000da   ble      #0xa01a8a8c
a01a89b0 006091e5   ldr      r6, [r1]
a01a89b4 0140a0e1   mov      r4, r1
a01a89b8 981e04e3   movw     r1, #0x4e98
a01a89bc 56104ae3   movt     r1, #0xa056
a01a89c0 0600a0e1   mov      r0, r6
a01a89c4 5e430dfa   blx      #0xa04f9744
a01a89c8 008050e2   subs     r8, r0, #0
a01a89cc 3400000a   beq      #0xa01a8aa4
a01a89d0 8c1309e3   movw     r1, #0x938c
a01a89d4 0600a0e1   mov      r0, r6
a01a89d8 56104ae3   movt     r1, #0xa056
a01a89dc 58430dfa   blx      #0xa04f9744
a01a89e0 001050e2   subs     r1, r0, #0
a01a89e4 4000000a   beq      #0xa01a8aec
a01a89e8 201d0ce3   movw     r1, #0xcd20
a01a89ec 0600a0e1   mov      r0, r6
a01a89f0 55104ae3   movt     r1, #0xa055
a01a89f4 52430dfa   blx      #0xa04f9744
a01a89f8 000050e3   cmp      r0, #0
a01a89fc a100000a   beq      #0xa01a8c88
a01a8a00 081409e3   movw     r1, #0x9408
a01a8a04 0600a0e1   mov      r0, r6
a01a8a08 56104ae3   movt     r1, #0xa056
a01a8a0c 4c430dfa   blx      #0xa04f9744
a01a8a10 001050e2   subs     r1, r0, #0
a01a8a14 8f00000a   beq      #0xa01a8c58
a01a8a18 e41f0de3   movw     r1, #0xdfe4
a01a8a1c 0600a0e1   mov      r0, r6
a01a8a20 54104ae3   movt     r1, #0xa054
a01a8a24 46430dfa   blx      #0xa04f9744
a01a8a28 100f6fe1   clz      r0, r0
a01a8a2c 020057e3   cmp      r7, #2
a01a8a30 a002a0e1   lsr      r0, r0, #5
a01a8a34 0000a003   moveq    r0, #0
a01a8a38 000050e3   cmp      r0, #0
a01a8a3c 1200000a   beq      #0xa01a8a8c
a01a8a40 841a04e3   movw     r1, #0x4a84
a01a8a44 080094e5   ldr      r0, [r4, #8]
a01a8a48 53104ae3   movt     r1, #0xa053
a01a8a4c 3c430dfa   blx      #0xa04f9744
a01a8a50 106f6fe1   clz      r6, r0
a01a8a54 047094e5   ldr      r7, [r4, #4]
a01a8a58 2c1409e3   movw     r1, #0x942c
a01a8a5c 56104ae3   movt     r1, #0xa056
a01a8a60 a662a0e1   lsr      r6, r6, #5
a01a8a64 0700a0e1   mov      r0, r7
a01a8a68 35430dfa   blx      #0xa04f9744
a01a8a6c 000050e3   cmp      r0, #0
a01a8a70 b300000a   beq      #0xa01a8d44
a01a8a74 441409e3   movw     r1, #0x9444
a01a8a78 0700a0e1   mov      r0, r7
a01a8a7c 56104ae3   movt     r1, #0xa056
a01a8a80 2f430dfa   blx      #0xa04f9744
a01a8a84 000050e3   cmp      r0, #0
a01a8a88 a300000a   beq      #0xa01a8d1c
a01a8a8c 480409e3   movw     r0, #0x9448
a01a8a90 56004ae3   movt     r0, #0xa056
a01a8a94 35ff2fe1   blx      r5
a01a8a98 0000a0e3   mov      r0, #0
a01a8a9c 1cd08de2   add      sp, sp, #0x1c
a01a8aa0 f08fbde8   pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8aa4 0810a0e1   mov      r1, r8
a01a8aa8 0820a0e1   mov      r2, r8
a01a8aac 040094e5   ldr      r0, [r4, #4]
a01a8ab0 c3490dfa   blx      #0xa04fb1c4
a01a8ab4 0040a0e1   mov      r4, r0
a01a8ab8 430300e3   movw     r0, #0x343
a01a8abc 0410a0e1   mov      r1, r4
a01a8ac0 0820a0e1   mov      r2, r8
a01a8ac4 01004fe3   movt     r0, #0xf001
a01a8ac8 b3f600eb   bl       #0xa01e659c
a01a8acc 600309e3   movw     r0, #0x9360
a01a8ad0 0410a0e1   mov      r1, r4
a01a8ad4 0820a0e1   mov      r2, r8
a01a8ad8 56004ae3   movt     r0, #0xa056
a01a8adc 35ff2fe1   blx      r5
a01a8ae0 0000a0e3   mov      r0, #0
a01a8ae4 1cd08de2   add      sp, sp, #0x1c
a01a8ae8 f08fbde8   pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8aec cc7308e3   movw     r7, #0x83cc
a01a8af0 0120a0e1   mov      r2, r1
a01a8af4 040094e5   ldr      r0, [r4, #4]
a01a8af8 25714ae3   movt     r7, #0xa125
a01a8afc b0490dfa   blx      #0xa04fb1c4
a01a8b00 003097e5   ldr      r3, [r7]
a01a8b04 08008de5   str      r0, [sp, #8]
a01a8b08 032080e0   add      r2, r0, r3
a01a8b0c 320052e3   cmp      r2, #0x32
a01a8b10 322063c2   rsbgt    r2, r3, #0x32
a01a8b14 08208dc5   strgt    r2, [sp, #8]
a01a8b18 320053e3   cmp      r3, #0x32
a01a8b1c 6900000a   beq      #0xa01a8cc8
a01a8b20 08309de5   ldr      r3, [sp, #8]
a01a8b24 000053e3   cmp      r3, #0
a01a8b28 daffffda   ble      #0xa01a8a98
a01a8b2c 003308e3   movw     r3, #0x8300
a01a8b30 e4a302e3   movw     sl, #0x23e4
a01a8b34 25314ae3   movt     r3, #0xa125
a01a8b38 67b606e3   movw     fp, #0x6667
a01a8b3c 10308de5   str      r3, [sp, #0x10]
a01a8b40 383208e3   movw     r3, #0x8238
a01a8b44 cc6308e3   movw     r6, #0x83cc
a01a8b48 25314ae3   movt     r3, #0xa125
a01a8b4c 3aa14ae3   movt     sl, #0xa13a
a01a8b50 0c308de5   str      r3, [sp, #0xc]
a01a8b54 66b646e3   movt     fp, #0x6666
a01a8b58 25614ae3   movt     r6, #0xa125
a01a8b5c 0080a0e3   mov      r8, #0
a01a8b60 14508de5   str      r5, [sp, #0x14]
a01a8b64 170000ea   b        #0xa01a8bc8
a01a8b68 005096e5   ldr      r5, [r6]
a01a8b6c 320055e3   cmp      r5, #0x32
a01a8b70 4b0000ca   bgt      #0xa01a8ca4
a01a8b74 003308e3   movw     r3, #0x8300
a01a8b78 25314ae3   movt     r3, #0xa125
a01a8b7c 050193e7   ldr      r0, [r3, r5, lsl #2]
a01a8b80 99400dfa   blx      #0xa04f8dec
a01a8b84 05e199e7   ldr      lr, [sb, r5, lsl #2]
a01a8b88 003308e3   movw     r3, #0x8300
a01a8b8c 25314ae3   movt     r3, #0xa125
a01a8b90 ac0309e3   movw     r0, #0x93ac
a01a8b94 052193e7   ldr      r2, [r3, r5, lsl #2]
a01a8b98 0510a0e1   mov      r1, r5
a01a8b9c 0e30a0e1   mov      r3, lr
a01a8ba0 00408de5   str      r4, [sp]
a01a8ba4 56004ae3   movt     r0, #0xa056
a01a8ba8 14c09de5   ldr      ip, [sp, #0x14]
a01a8bac 3cff2fe1   blx      ip
a01a8bb0 08209de5   ldr      r2, [sp, #8]
a01a8bb4 003096e5   ldr      r3, [r6]
a01a8bb8 020058e1   cmp      r8, r2
a01a8bbc 013083e2   add      r3, r3, #1
