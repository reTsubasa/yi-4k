; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01ab8bc+0xb0; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01ab8bc  010050e3  cmp      r0, #1
a01ab8c0  f0472de9  push     {r4, r5, r6, r7, r8, sb, sl, lr}
a01ab8c4  04540bd3  movwle   r5, #0xb404
a01ab8c8  0080a0e1  mov      r8, r0
a01ab8cc  0260a0e1  mov      r6, r2
a01ab8d0  56504ad3  movtle   r5, #0xa056
a01ab8d4  170000da  ble      #0xa01ab938
a01ab8d8  04540be3  movw     r5, #0xb404
a01ab8dc  0190a0e1  mov      sb, r1
a01ab8e0  047091e5  ldr      r7, [r1, #4]
a01ab8e4  56504ae3  movt     r5, #0xa056
a01ab8e8  0040a0e3  mov      r4, #0
a01ab8ec  010000ea  b        #0xa01ab8f8
a01ab8f0  450054e3  cmp      r4, #0x45
a01ab8f4  0f00000a  beq      #0xa01ab938
a01ab8f8  840195e7  ldr      r0, [r5, r4, lsl #3]
a01ab8fc  0710a0e1  mov      r1, r7
a01ab900  8f370dfa  blx      #0xa04f9744
a01ab904  000050e3  cmp      r0, #0
a01ab908  04340be3  movw     r3, #0xb404
a01ab90c  8421a0e1  lsl      r2, r4, #3
a01ab910  56304ae3  movt     r3, #0xa056
a01ab914  014084e2  add      r4, r4, #1
a01ab918  f4ffff1a  bne      #0xa01ab8f0
a01ab91c  023083e0  add      r3, r3, r2
a01ab920  020048e2  sub      r0, r8, #2
a01ab924  081089e2  add      r1, sb, #8
a01ab928  0620a0e1  mov      r2, r6
a01ab92c  043093e5  ldr      r3, [r3, #4]
a01ab930  f047bde8  pop      {r4, r5, r6, r7, r8, sb, sl, lr}
a01ab934  13ff2fe1  bx       r3
a01ab938  b8070ae3  movw     r0, #0xa7b8
a01ab93c  0040a0e3  mov      r4, #0
a01ab940  56004ae3  movt     r0, #0xa056 ; constant 0xa056a7b8: 'supported test commands:\n'
a01ab944  36ff2fe1  blx      r6
a01ab948  6c070ae3  movw     r0, #0xa76c
a01ab94c  841195e7  ldr      r1, [r5, r4, lsl #3]
a01ab950  56004ae3  movt     r0, #0xa056 ; constant 0xa056a76c: '\t%s\n'
a01ab954  014084e2  add      r4, r4, #1
a01ab958  36ff2fe1  blx      r6
a01ab95c  450054e3  cmp      r4, #0x45
a01ab960  f8ffff1a  bne      #0xa01ab948
a01ab964  0000e0e3  mvn      r0, #0
a01ab968  f087bde8  pop      {r4, r5, r6, r7, r8, sb, sl, pc}
