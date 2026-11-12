; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01abb44+0x74; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01abb44  000050e3  cmp      r0, #0
a01abb48  180000da  ble      #0xa01abbb0
a01abb4c  10402de9  push     {r4, lr}
a01abb50  0140a0e1  mov      r4, r1
a01abb54  e4130fe3  movw     r1, #0xf3e4
a01abb58  000094e5  ldr      r0, [r4]
a01abb5c  63104ae3  movt     r1, #0xa063 ; constant 0xa063f3e4: '0'
a01abb60  9a360dfa  blx      #0xa04f95d0
a01abb64  000050e3  cmp      r0, #0
a01abb68  0600001a  bne      #0xa01abb88
a01abb6c  0020a0e1  mov      r2, r0
a01abb70  0110a0e3  mov      r1, #1
a01abb74  0800a0e3  mov      r0, #8
a01abb78  09084de3  movt     r0, #0xd809
a01abb7c  86ea00eb  bl       #0xa01e659c
a01abb80  0000a0e3  mov      r0, #0
a01abb84  1080bde8  pop      {r4, pc}
a01abb88  a0100fe3  movw     r1, #0xf0a0
a01abb8c  000094e5  ldr      r0, [r4]
a01abb90  52104ae3  movt     r1, #0xa052 ; constant 0xa052f0a0: '1'
a01abb94  8d360dfa  blx      #0xa04f95d0
a01abb98  000050e3  cmp      r0, #0
a01abb9c  0010a001  moveq    r1, r0
a01abba0  0120a003  moveq    r2, #1
a01abba4  f2ffff0a  beq      #0xa01abb74
a01abba8  0000a0e3  mov      r0, #0
a01abbac  1080bde8  pop      {r4, pc}
a01abbb0  0000a0e3  mov      r0, #0
a01abbb4  1eff2fe1  bx       lr
