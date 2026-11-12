; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa04af7e0+0x9c; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a04af7e0  010050e3  cmp      r0, #1
a04af7e4  f0472de9  push     {r4, r5, r6, r7, r8, sb, sl, lr}
a04af7e8  0080a0e1  mov      r8, r0
a04af7ec  0190a0e1  mov      sb, r1
a04af7f0  02a0a0e1  mov      sl, r2
a04af7f4  1b0000da  ble      #0xa04af868
a04af7f8  0040a0e3  mov      r4, #0
a04af7fc  346307e3  movw     r6, #0x7334
a04af800  047091e5  ldr      r7, [r1, #4]
a04af804  0450a0e1  mov      r5, r4
a04af808  63604ae3  movt     r6, #0xa063
a04af80c  020000ea  b        #0xa04af81c
a04af810  015085e2  add      r5, r5, #1
a04af814  150055e3  cmp      r5, #0x15
a04af818  1000000a  beq      #0xa04af860
a04af81c  041096e7  ldr      r1, [r6, r4]
a04af820  0700a0e1  mov      r0, r7
a04af824  c62701fa  blx      #0xa04f9744
a04af828  000050e3  cmp      r0, #0
a04af82c  343307e3  movw     r3, #0x7334
a04af830  63304ae3  movt     r3, #0xa063
a04af834  0c4084e2  add      r4, r4, #0xc
a04af838  f4ffff1a  bne      #0xa04af810
a04af83c  0522a0e1  lsl      r2, r5, #4
a04af840  010048e2  sub      r0, r8, #1
a04af844  041089e2  add      r1, sb, #4
a04af848  055142e0  sub      r5, r2, r5, lsl #2
a04af84c  0a20a0e1  mov      r2, sl
a04af850  053083e0  add      r3, r3, r5
a04af854  f047bde8  pop      {r4, r5, r6, r7, r8, sb, sl, lr}
a04af858  043093e5  ldr      r3, [r3, #4]
a04af85c  13ff2fe1  bx       r3
a04af860  0000e0e3  mvn      r0, #0
a04af864  f087bde8  pop      {r4, r5, r6, r7, r8, sb, sl, pc}
a04af868  0100a0e1  mov      r0, r1
a04af86c  0210a0e1  mov      r1, r2
a04af870  c3ffffeb  bl       #0xa04af784
a04af874  0000a0e3  mov      r0, #0
a04af878  f087bde8  pop      {r4, r5, r6, r7, r8, sb, sl, pc}
