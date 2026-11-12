; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa029e098+0x10c; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a029e098  000050e3  cmp      r0, #0
a029e09c  00005113  cmpne    r1, #0
a029e0a0  70402de9  push     {r4, r5, r6, lr}
a029e0a4  0030a0e3  mov      r3, #0
a029e0a8  08d04de2  sub      sp, sp, #8
a029e0ac  04308de5  str      r3, [sp, #4]
a029e0b0  3300000a  beq      #0xa029e184
a029e0b4  0040a0e1  mov      r4, r0
a029e0b8  0160a0e1  mov      r6, r1
a029e0bc  4b6e09fa  blx      #0xa04f99f0
a029e0c0  130050e3  cmp      r0, #0x13
a029e0c4  2e00008a  bhi      #0xa029e184
a029e0c8  080706e3  movw     r0, #0x6708
a029e0cc  0010e0e3  mvn      r1, #0
a029e0d0  44014ae3  movt     r0, #0xa144
a029e0d4  e47804eb  bl       #0xa03bc46c
a029e0d8  003050e2  subs     r3, r0, #0
a029e0dc  2800001a  bne      #0xa029e184
a029e0e0  3c070ae3  movw     r0, #0xa73c
a029e0e4  04108de2  add      r1, sp, #4
a029e0e8  44014ae3  movt     r0, #0xa144
a029e0ec  0c20a0e3  mov      r2, #0xc
a029e0f0  797904eb  bl       #0xa03bc6dc
a029e0f4  005050e2  subs     r5, r0, #0
a029e0f8  2100001a  bne      #0xa029e184
a029e0fc  0400a0e1  mov      r0, r4
a029e100  3a6e09fa  blx      #0xa04f99f0
a029e104  012080e2  add      r2, r0, #1
a029e108  3c070ae3  movw     r0, #0xa73c
a029e10c  0530a0e1  mov      r3, r5
a029e110  44014ae3  movt     r0, #0xa144
a029e114  04109de5  ldr      r1, [sp, #4]
a029e118  6f7904eb  bl       #0xa03bc6dc
a029e11c  005050e2  subs     r5, r0, #0
a029e120  1b00001a  bne      #0xa029e194
a029e124  0400a0e1  mov      r0, r4
a029e128  306e09fa  blx      #0xa04f99f0
a029e12c  04309de5  ldr      r3, [sp, #4]
a029e130  012080e2  add      r2, r0, #1
a029e134  0410a0e1  mov      r1, r4
a029e138  000093e5  ldr      r0, [r3]
a029e13c  7d6e09fa  blx      #0xa04f9b38
a029e140  04c09de5  ldr      ip, [sp, #4]
a029e144  702003e3  movw     r2, #0x3070
a029e148  6f204ae3  movt     r2, #0xa06f
a029e14c  04608ce5  str      r6, [ip, #4]
a029e150  08508ce5  str      r5, [ip, #8]
a029e154  000000ea  b        #0xa029e15c
a029e158  0320a0e1  mov      r2, r3
a029e15c  083092e5  ldr      r3, [r2, #8]
a029e160  000053e3  cmp      r3, #0
a029e164  fbffff1a  bne      #0xa029e158
a029e168  080706e3  movw     r0, #0x6708
a029e16c  08c082e5  str      ip, [r2, #8]
a029e170  44014ae3  movt     r0, #0xa144
a029e174  c77804eb  bl       #0xa03bc498
a029e178  0500a0e1  mov      r0, r5
a029e17c  08d08de2  add      sp, sp, #8
a029e180  7080bde8  pop      {r4, r5, r6, pc}
a029e184  0050e0e3  mvn      r5, #0
a029e188  0500a0e1  mov      r0, r5
a029e18c  08d08de2  add      sp, sp, #8
a029e190  7080bde8  pop      {r4, r5, r6, pc}
a029e194  04009de5  ldr      r0, [sp, #4]
a029e198  0050e0e3  mvn      r5, #0
a029e19c  5c7904eb  bl       #0xa03bc714
a029e1a0  f4ffffea  b        #0xa029e178
