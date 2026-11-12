a03bc200 0220cde5   strb     r2, [sp, #2]
a03bc204 ec6c03eb   bl       #0xa04975bc
a03bc208 8c0700eb   bl       #0xa03be040
a03bc20c 0400a0e1   mov      r0, r4
a03bc210 08d08de2   add      sp, sp, #8
a03bc214 1080bde8   pop      {r4, pc}
a03bc218 10402de9   push     {r4, lr}
a03bc21c 76a003eb   bl       #0xa04a43fc
a03bc220 e02509e3   movw     r2, #0x95e0
a03bc224 78204ae3   movt     r2, #0xa078
a03bc228 003092e5   ldr      r3, [r2]
a03bc22c e04509e3   movw     r4, #0x95e0
a03bc230 78404ae3   movt     r4, #0xa078
a03bc234 010053e3   cmp      r3, #1
a03bc238 faffff1a   bne      #0xa03bc228
a03bc23c 9da003eb   bl       #0xa04a44b8
a03bc240 533d04e3   movw     r3, #0x4d53
a03bc244 0400a0e1   mov      r0, r4
a03bc248 503040e3   movt     r3, #0x50
a03bc24c 0410a0e3   mov      r1, #4
a03bc250 003084e5   str      r3, [r4]
a03bc254 c39803eb   bl       #0xa04a2568
a03bc258 1040bde8   pop      {r4, lr}
a03bc25c e11200ea   b        #0xa03c0de8
a03bc260 e43003e3   movw     r3, #0x30e4
a03bc264 10402de9   push     {r4, lr}
a03bc268 6f304ae3   movt     r3, #0xa06f
a03bc26c a0200de3   movw     r2, #0xd0a0
a03bc270 10d04de2   sub      sp, sp, #0x10
a03bc274 00e0a0e3   mov      lr, #0
a03bc278 004093e5   ldr      r4, [r3]
a03bc27c 01c0a0e3   mov      ip, #1
a03bc280 a8204ae3   movt     r2, #0xa0a8
a03bc284 d8090de3   movw     r0, #0xd9d8
a03bc288 001b0ce3   movw     r1, #0xcb00
a03bc28c 683907e3   movw     r3, #0x7968
a03bc290 04208de5   str      r2, [sp, #4]
a03bc294 60104ae3   movt     r1, #0xa060
a03bc298 08408de5   str      r4, [sp, #8]
a03bc29c 2a304ae3   movt     r3, #0xa02a
a03bc2a0 00e08de5   str      lr, [sp]
a03bc2a4 fe20a0e3   mov      r2, #0xfe
a03bc2a8 0cc08de5   str      ip, [sp, #0xc]
a03bc2ac 44014ae3   movt     r0, #0xa144
a03bc2b0 010000eb   bl       #0xa03bc2bc
a03bc2b4 10d08de2   add      sp, sp, #0x10
a03bc2b8 1080bde8   pop      {r4, pc}
a03bc2bc f0402de9   push     {r4, r5, r6, r7, lr}
a03bc2c0 24d04de2   sub      sp, sp, #0x24
a03bc2c4 3c709de5   ldr      r7, [sp, #0x3c]
a03bc2c8 02c0a0e1   mov      ip, r2
a03bc2cc d8e0a0e3   mov      lr, #0xd8
a03bc2d0 0040a0e3   mov      r4, #0
a03bc2d4 40609de5   ldr      r6, [sp, #0x40]
a03bc2d8 44509de5   ldr      r5, [sp, #0x44]
a03bc2dc 08208de5   str      r2, [sp, #8]
a03bc2e0 0320a0e1   mov      r2, r3
a03bc2e4 0cc08de5   str      ip, [sp, #0xc]
a03bc2e8 00708de5   str      r7, [sp]
a03bc2ec 04608de5   str      r6, [sp, #4]
a03bc2f0 14508de5   str      r5, [sp, #0x14]
a03bc2f4 10408de5   str      r4, [sp, #0x10]
a03bc2f8 18e08de5   str      lr, [sp, #0x18]
a03bc2fc 38309de5   ldr      r3, [sp, #0x38]
a03bc300 ce1f00eb   bl       #0xa03c4240
a03bc304 24d08de2   add      sp, sp, #0x24
a03bc308 f080bde8   pop      {r4, r5, r6, r7, pc}
a03bc30c 5e2000ea   b        #0xa03c448c
a03bc310 df2000ea   b        #0xa03c4694
a03bc314 b22000ea   b        #0xa03c45e4
a03bc318 d32000ea   b        #0xa03c466c
a03bc31c c82000ea   b        #0xa03c4644
