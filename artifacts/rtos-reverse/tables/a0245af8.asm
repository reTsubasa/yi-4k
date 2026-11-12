; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa0245af8+0xb0; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a0245af8  010050e3  cmp      r0, #1
a0245afc  f8432de9  push     {r3, r4, r5, r6, r7, r8, sb, lr}
a0245b00  185c06d3  movwle   r5, #0x6c18
a0245b04  0080a0e1  mov      r8, r0
a0245b08  0260a0e1  mov      r6, r2
a0245b0c  5a504ad3  movtle   r5, #0xa05a
a0245b10  0f0000da  ble      #0xa0245b54
a0245b14  047091e5  ldr      r7, [r1, #4]
a0245b18  185c06e3  movw     r5, #0x6c18
a0245b1c  0190a0e1  mov      sb, r1
a0245b20  5a504ae3  movt     r5, #0xa05a
a0245b24  0040a0e3  mov      r4, #0
a0245b28  840195e7  ldr      r0, [r5, r4, lsl #3]
a0245b2c  0710a0e1  mov      r1, r7
a0245b30  03cf0afa  blx      #0xa04f9744
a0245b34  000050e3  cmp      r0, #0
a0245b38  183c06e3  movw     r3, #0x6c18
a0245b3c  8421a0e1  lsl      r2, r4, #3
a0245b40  5a304ae3  movt     r3, #0xa05a
a0245b44  014084e2  add      r4, r4, #1
a0245b48  0e00000a  beq      #0xa0245b88
a0245b4c  060054e3  cmp      r4, #6
a0245b50  f4ffff1a  bne      #0xa0245b28
a0245b54  9c0e06e3  movw     r0, #0x6e9c
a0245b58  0040a0e3  mov      r4, #0
a0245b5c  5a004ae3  movt     r0, #0xa05a ; constant 0xa05a6e9c: 'Supported test commands:\n'
a0245b60  36ff2fe1  blx      r6
a0245b64  dc010ae3  movw     r0, #0xa1dc
a0245b68  841195e7  ldr      r1, [r5, r4, lsl #3]
a0245b6c  56004ae3  movt     r0, #0xa056 ; constant 0xa056a1dc: '    %s\n'
a0245b70  014084e2  add      r4, r4, #1
a0245b74  36ff2fe1  blx      r6
a0245b78  060054e3  cmp      r4, #6
a0245b7c  f8ffff1a  bne      #0xa0245b64
a0245b80  0000a0e3  mov      r0, #0
a0245b84  f883bde8  pop      {r3, r4, r5, r6, r7, r8, sb, pc}
a0245b88  023083e0  add      r3, r3, r2
a0245b8c  010048e2  sub      r0, r8, #1
a0245b90  043093e5  ldr      r3, [r3, #4]
a0245b94  041089e2  add      r1, sb, #4
a0245b98  0620a0e1  mov      r2, r6
a0245b9c  33ff2fe1  blx      r3
a0245ba0  0000a0e3  mov      r0, #0
a0245ba4  f883bde8  pop      {r3, r4, r5, r6, r7, r8, sb, pc}
