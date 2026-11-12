; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01a63d4+0x100; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01a63d4  f0412de9  push     {r4, r5, r6, r7, r8, lr}
a01a63d8  43dd4de2  sub      sp, sp, #0x10c0
a01a63dc  38d04de2  sub      sp, sp, #0x38
a01a63e0  0040a0e3  mov      r4, #0
a01a63e4  682001e3  movw     r2, #0x1068
a01a63e8  0080a0e1  mov      r8, r0
a01a63ec  0170a0e1  mov      r7, r1
a01a63f0  90008de2  add      r0, sp, #0x90
a01a63f4  a0119fe5  ldr      r1, [pc, #0x1a0]
a01a63f8  10408de5  str      r4, [sp, #0x10]
a01a63fc  14408de5  str      r4, [sp, #0x14]
a01a6400  18408de5  str      r4, [sp, #0x18]
a01a6404  1c408de5  str      r4, [sp, #0x1c]
a01a6408  20408de5  str      r4, [sp, #0x20]
a01a640c  24408de5  str      r4, [sp, #0x24]
a01a6410  28408de5  str      r4, [sp, #0x28]
a01a6414  2c408de5  str      r4, [sp, #0x2c]
a01a6418  30408de5  str      r4, [sp, #0x30]
a01a641c  34408de5  str      r4, [sp, #0x34]
a01a6420  38408de5  str      r4, [sp, #0x38]
a01a6424  3c408de5  str      r4, [sp, #0x3c]
a01a6428  40408de5  str      r4, [sp, #0x40]
a01a642c  44408de5  str      r4, [sp, #0x44]
a01a6430  48408de5  str      r4, [sp, #0x48]
a01a6434  4c408de5  str      r4, [sp, #0x4c]
a01a6438  50408de5  str      r4, [sp, #0x50]
a01a643c  54408de5  str      r4, [sp, #0x54]
a01a6440  58408de5  str      r4, [sp, #0x58]
a01a6444  5c408de5  str      r4, [sp, #0x5c]
a01a6448  60408de5  str      r4, [sp, #0x60]
a01a644c  64408de5  str      r4, [sp, #0x64]
a01a6450  68408de5  str      r4, [sp, #0x68]
a01a6454  6c408de5  str      r4, [sp, #0x6c]
a01a6458  70408de5  str      r4, [sp, #0x70]
a01a645c  74408de5  str      r4, [sp, #0x74]
a01a6460  78408de5  str      r4, [sp, #0x78]
a01a6464  7c408de5  str      r4, [sp, #0x7c]
a01a6468  80408de5  str      r4, [sp, #0x80]
a01a646c  84408de5  str      r4, [sp, #0x84]
a01a6470  88408de5  str      r4, [sp, #0x88]
a01a6474  8c408de5  str      r4, [sp, #0x8c]
a01a6478  80d803eb  bl       #0xa029c680
a01a647c  0400a0e1  mov      r0, r4
a01a6480  30108de2  add      r1, sp, #0x30
a01a6484  2020a0e3  mov      r2, #0x20
a01a6488  64a9feeb  bl       #0xa0150a20
a01a648c  000050e3  cmp      r0, #0
a01a6490  2500001a  bne      #0xa01a652c
a01a6494  0040a0e1  mov      r4, r0
a01a6498  0050a0e1  mov      r5, r0
a01a649c  90608de2  add      r6, sp, #0x90
a01a64a0  020000ea  b        #0xa01a64b0
a01a64a4  015085e2  add      r5, r5, #1
a01a64a8  2a0055e3  cmp      r5, #0x2a
a01a64ac  2600000a  beq      #0xa01a654c
a01a64b0  701101e3  movw     r1, #0x1170
a01a64b4  042096e7  ldr      r2, [r6, r4]
a01a64b8  5c104ae3  movt     r1, #0xa05c ; constant 0xa05c1170: '%u'
a01a64bc  10008de2  add      r0, sp, #0x10
a01a64c0  e24b0dfa  blx      #0xa04f9450
a01a64c4  10008de2  add      r0, sp, #0x10
a01a64c8  0810a0e1  mov      r1, r8
a01a64cc  3f4c0dfa  blx      #0xa04f95d0
a01a64d0  000050e3  cmp      r0, #0
