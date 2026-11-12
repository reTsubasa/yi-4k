; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa02265b0+0x8c; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a02265b0  010050e3  cmp      r0, #1
a02265b4  f8432de9  push     {r3, r4, r5, r6, r7, r8, sb, lr}
a02265b8  0080a0e1  mov      r8, r0
a02265bc  1b0000da  ble      #0xa0226630
a02265c0  047091e5  ldr      r7, [r1, #4]
a02265c4  0040a0e3  mov      r4, #0
a02265c8  e06807e3  movw     r6, #0x78e0
a02265cc  0190a0e1  mov      sb, r1
a02265d0  0450a0e1  mov      r5, r4
a02265d4  59604ae3  movt     r6, #0xa059
a02265d8  041096e7  ldr      r1, [r6, r4]
a02265dc  0700a0e1  mov      r0, r7
a02265e0  574c0bfa  blx      #0xa04f9744
a02265e4  000050e3  cmp      r0, #0
a02265e8  e03807e3  movw     r3, #0x78e0
a02265ec  59304ae3  movt     r3, #0xa059
a02265f0  0c4084e2  add      r4, r4, #0xc
a02265f4  0400000a  beq      #0xa022660c
a02265f8  015085e2  add      r5, r5, #1
a02265fc  110055e3  cmp      r5, #0x11
a0226600  f4ffff1a  bne      #0xa02265d8
a0226604  0000a0e3  mov      r0, #0
a0226608  f883bde8  pop      {r3, r4, r5, r6, r7, r8, sb, pc}
a022660c  0522a0e1  lsl      r2, r5, #4
a0226610  0800a0e1  mov      r0, r8
a0226614  0910a0e1  mov      r1, sb
a0226618  055142e0  sub      r5, r2, r5, lsl #2
a022661c  053083e0  add      r3, r3, r5
a0226620  043093e5  ldr      r3, [r3, #4]
a0226624  33ff2fe1  blx      r3
a0226628  0000a0e3  mov      r0, #0
a022662c  f883bde8  pop      {r3, r4, r5, r6, r7, r8, sb, pc}
a0226630  d0ffffeb  bl       #0xa0226578 ; imgcmd_help
a0226634  0000a0e3  mov      r0, #0
a0226638  f883bde8  pop      {r3, r4, r5, r6, r7, r8, sb, pc}
