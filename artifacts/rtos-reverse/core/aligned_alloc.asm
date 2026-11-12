; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; aligned_alloc, mode=ARM; selected range, not guaranteed function boundary
a029a7d8  70402de9   push      {r4, r5, r6, lr}
a029a7dc  0250a0e1   mov       r5, r2
a029a7e0  10409de5   ldr       r4, [sp, #0x10]
a029a7e4  0160a0e1   mov       r6, r1
a029a7e8  0510a0e1   mov       r1, r5
a029a7ec  1f0054e3   cmp       r4, #0x1f
a029a7f0  8420a081   lslhi     r2, r4, #1
a029a7f4  4020a093   movls     r2, #0x40
a029a7f8  2040a093   movls     r4, #0x20
a029a7fc  032082e0   add       r2, r2, r3
a029a800  7d3fa0e3   mov       r3, #0x1f4
a029a804  b48704eb   bl        #0xa03bc6dc
a029a808  000050e3   cmp       r0, #0
a029a80c  00309505   ldreq     r3, [r5]
a029a810  01204402   subeq     r2, r4, #1
a029a814  0230c301   biceq     r3, r3, r2
a029a818  04408300   addeq     r4, r3, r4
a029a81c  00408605   streq     r4, [r6]
a029a820  7080bde8   pop       {r4, r5, r6, pc}
