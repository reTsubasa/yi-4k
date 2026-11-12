a01a8bc0 003086e5   str      r3, [r6]
a01a8bc4 b3ffff0a   beq      #0xa01a8a98
a01a8bc8 9b960beb   bl       #0xa048e63c
a01a8bcc d7400dfa   blx      #0xa04f8f30
a01a8bd0 dc400dfa   blx      #0xa04f8f48
a01a8bd4 0030a0e1   mov      r3, r0
a01a8bd8 002097e5   ldr      r2, [r7]
a01a8bdc 930bc1e0   smull    r0, r1, r3, fp
a01a8be0 c34fa0e1   asr      r4, r3, #0x1f
a01a8be4 0cc09de5   ldr      ip, [sp, #0xc]
a01a8be8 4000a0e3   mov      r0, #0x40
a01a8bec 00008de5   str      r0, [sp]
a01a8bf0 389208e3   movw     sb, #0x8238
a01a8bf4 0221a0e1   lsl      r2, r2, #2
a01a8bf8 00009ae5   ldr      r0, [sl]
a01a8bfc 018088e2   add      r8, r8, #1
a01a8c00 414864e0   rsb      r4, r4, r1, asr #16
a01a8c04 10109de5   ldr      r1, [sp, #0x10]
a01a8c08 25914ae3   movt     sb, #0xa125
a01a8c0c 84e8a0e1   lsl      lr, r4, #0x11
a01a8c10 021081e0   add      r1, r1, r2
a01a8c14 84478ee0   add      r4, lr, r4, lsl #15
a01a8c18 02208ce0   add      r2, ip, r2
a01a8c1c 034064e0   rsb      r4, r4, r3
a01a8c20 0430a0e1   mov      r3, r4
a01a8c24 ebc603eb   bl       #0xa029a7d8
a01a8c28 001050e2   subs     r1, r0, #0
a01a8c2c 0420a0e1   mov      r2, r4
a01a8c30 ccffff0a   beq      #0xa01a8b68
a01a8c34 a80b0ae3   movw     r0, #0xaba8
a01a8c38 e8130be3   movw     r1, #0xb3e8
a01a8c3c 56104ae3   movt     r1, #0xa056
a01a8c40 c92c00e3   movw     r2, #0xcc9
a01a8c44 53004ae3   movt     r0, #0xa053
a01a8c48 27f903eb   bl       #0xa02a70ec
a01a8c4c 34fa03eb   bl       #0xa02a7524
a01a8c50 c0000cf1   cpsid    if
a01a8c54 feffffea   b        #0xa01a8c54
a01a8c58 0120a0e1   mov      r2, r1
a01a8c5c 040094e5   ldr      r0, [r4, #4]
a01a8c60 57490dfa   blx      #0xa04fb1c4
a01a8c64 0040a0e1   mov      r4, r0
a01a8c68 0721ffeb   bl       #0xa017108c
a01a8c6c 140409e3   movw     r0, #0x9414
a01a8c70 0410a0e1   mov      r1, r4
a01a8c74 56004ae3   movt     r0, #0xa056
a01a8c78 35ff2fe1   blx      r5
a01a8c7c 0000a0e3   mov      r0, #0
a01a8c80 1cd08de2   add      sp, sp, #0x1c
a01a8c84 f08fbde8   pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8c88 ae25ffeb   bl       #0xa0172348
a01a8c8c ec0309e3   movw     r0, #0x93ec
a01a8c90 56004ae3   movt     r0, #0xa056
a01a8c94 35ff2fe1   blx      r5
a01a8c98 0000a0e3   mov      r0, #0
a01a8c9c 1cd08de2   add      sp, sp, #0x1c
a01a8ca0 f08fbde8   pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8ca4 a80b0ae3   movw     r0, #0xaba8
a01a8ca8 e8130be3   movw     r1, #0xb3e8
a01a8cac 56104ae3   movt     r1, #0xa056
a01a8cb0 ca2c00e3   movw     r2, #0xcca
a01a8cb4 53004ae3   movt     r0, #0xa053
a01a8cb8 0bf903eb   bl       #0xa02a70ec
a01a8cbc 18fa03eb   bl       #0xa02a7524
a01a8cc0 c0000cf1   cpsid    if
a01a8cc4 feffffea   b        #0xa01a8cc4
a01a8cc8 940309e3   movw     r0, #0x9394
a01a8ccc 56004ae3   movt     r0, #0xa056
a01a8cd0 35ff2fe1   blx      r5
a01a8cd4 003097e5   ldr      r3, [r7]
a01a8cd8 000053e3   cmp      r3, #0
a01a8cdc 0b0000da   ble      #0xa01a8d10
a01a8ce0 70609fe5   ldr      r6, [pc, #0x70]
a01a8ce4 0040a0e3   mov      r4, #0
a01a8ce8 6ca09fe5   ldr      sl, [pc, #0x6c]
a01a8cec 0480a0e1   mov      r8, r4
a01a8cf0 0400b6e5   ldr      r0, [r6, #4]!
a01a8cf4 014084e2   add      r4, r4, #1
a01a8cf8 854e08eb   bl       #0xa03bc714
a01a8cfc 003097e5   ldr      r3, [r7]
a01a8d00 008086e5   str      r8, [r6]
a01a8d04 0480aae5   str      r8, [sl, #4]!
a01a8d08 040053e1   cmp      r3, r4
a01a8d0c f7ffffca   bgt      #0xa01a8cf0
a01a8d10 0030a0e3   mov      r3, #0
a01a8d14 003087e5   str      r3, [r7]
a01a8d18 80ffffea   b        #0xa01a8b20
a01a8d1c d10fa0e3   mov      r0, #0x344
a01a8d20 0620a0e1   mov      r2, r6
a01a8d24 01004fe3   movt     r0, #0xf001
a01a8d28 0910a0e3   mov      r1, #9
a01a8d2c 1af600eb   bl       #0xa01e659c
a01a8d30 300409e3   movw     r0, #0x9430
a01a8d34 041094e5   ldr      r1, [r4, #4]
a01a8d38 56004ae3   movt     r0, #0xa056
a01a8d3c 35ff2fe1   blx      r5
a01a8d40 54ffffea   b        #0xa01a8a98
a01a8d44 d10fa0e3   mov      r0, #0x344
a01a8d48 0620a0e1   mov      r2, r6
a01a8d4c 01004fe3   movt     r0, #0xf001
a01a8d50 0410a0e3   mov      r1, #4
a01a8d54 f4ffffea   b        #0xa01a8d2c
