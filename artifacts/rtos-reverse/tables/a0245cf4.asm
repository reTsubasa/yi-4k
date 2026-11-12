; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa0245cf4+0x100; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a0245cf4  010050e3  cmp      r0, #1
a0245cf8  f04f2de9  push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0245cfc  42de4de2  sub      sp, sp, #0x420
a0245d00  0050a0e1  mov      r5, r0
a0245d04  0cd04de2  sub      sp, sp, #0xc
a0245d08  0270a0e1  mov      r7, r2
a0245d0c  b700000a  beq      #0xa0245ff0
a0245d10  048091e5  ldr      r8, [r1, #4]
a0245d14  0160a0e1  mov      r6, r1
a0245d18  601107e3  movw     r1, #0x7160
a0245d1c  5a104ae3  movt     r1, #0xa05a ; constant 0xa05a7160: 'list'
a0245d20  0800a0e1  mov      r0, r8
a0245d24  86ce0afa  blx      #0xa04f9744
a0245d28  004050e2  subs     r4, r0, #0
a0245d2c  a200000a  beq      #0xa0245fbc
a0245d30  681107e3  movw     r1, #0x7168
a0245d34  0800a0e1  mov      r0, r8
a0245d38  5a104ae3  movt     r1, #0xa05a ; constant 0xa05a7168: 'svc'
a0245d3c  80ce0afa  blx      #0xa04f9744
a0245d40  004050e2  subs     r4, r0, #0
a0245d44  1200001a  bne      #0xa0245d94
a0245d48  040055e3  cmp      r5, #4
a0245d4c  a000001a  bne      #0xa0245fd4
a0245d50  281201e3  movw     r1, #0x1228
a0245d54  080096e5  ldr      r0, [r6, #8]
a0245d58  53104ae3  movt     r1, #0xa053 ; constant 0xa0531228: 'test'
a0245d5c  78ce0afa  blx      #0xa04f9744
a0245d60  000050e3  cmp      r0, #0
a0245d64  0600001a  bne      #0xa0245d84
a0245d68  0c3096e5  ldr      r3, [r6, #0xc]
a0245d6c  0030d3e5  ldrb     r3, [r3]
a0245d70  2b0053e3  cmp      r3, #0x2b
a0245d74  0901000a  beq      #0xa02461a0
a0245d78  1102a0e3  mov      r0, #0x10000001
a0245d7c  0110a0e3  mov      r1, #1
a0245d80  a51306eb  bl       #0xa03cac1c
a0245d84  0400a0e1  mov      r0, r4
a0245d88  42de8de2  add      sp, sp, #0x420
a0245d8c  0cd08de2  add      sp, sp, #0xc
a0245d90  f08fbde8  pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0245d94  941107e3  movw     r1, #0x7194
a0245d98  0800a0e1  mov      r0, r8
a0245d9c  5a104ae3  movt     r1, #0xa05a ; constant 0xa05a7194: 'clnt'
a0245da0  67ce0afa  blx      #0xa04f9744
a0245da4  004050e2  subs     r4, r0, #0
a0245da8  6e00001a  bne      #0xa0245f68
a0245dac  088096e5  ldr      r8, [r6, #8]
a0245db0  281201e3  movw     r1, #0x1228
a0245db4  53104ae3  movt     r1, #0xa053 ; constant 0xa0531228: 'test'
a0245db8  0800a0e1  mov      r0, r8
a0245dbc  60ce0afa  blx      #0xa04f9744
a0245dc0  000050e3  cmp      r0, #0
a0245dc4  af00000a  beq      #0xa0246088
a0245dc8  9c1107e3  movw     r1, #0x719c
a0245dcc  0800a0e1  mov      r0, r8
a0245dd0  5a104ae3  movt     r1, #0xa05a ; constant 0xa05a719c: 'exec1'
a0245dd4  5ace0afa  blx      #0xa04f9744
a0245dd8  000050e3  cmp      r0, #0
a0245ddc  0500000a  beq      #0xa0245df8
a0245de0  a41107e3  movw     r1, #0x71a4
a0245de4  0800a0e1  mov      r0, r8
a0245de8  5a104ae3  movt     r1, #0xa05a ; constant 0xa05a71a4: 'exec2'
a0245dec  54ce0afa  blx      #0xa04f9744
a0245df0  000050e3  cmp      r0, #0
