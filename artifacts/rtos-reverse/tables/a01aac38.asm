; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01aac38+0x118; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01aac38  08402de9  push     {r3, lr}
a01aac3c  b811feeb  bl       #0xa012f324
a01aac40  3614feeb  bl       #0xa012fd20
a01aac44  0000a0e3  mov      r0, #0
a01aac48  0880bde8  pop      {r3, pc}
a01aac4c  08402de9  push     {r3, lr}
a01aac50  e513feeb  bl       #0xa012fbec
a01aac54  0000a0e3  mov      r0, #0
a01aac58  0880bde8  pop      {r3, pc}
a01aac5c  000050e3  cmp      r0, #0
a01aac60  0f0000da  ble      #0xa01aaca4
a01aac64  10402de9  push     {r4, lr}
a01aac68  004091e5  ldr      r4, [r1]
a01aac6c  54190ce3  movw     r1, #0xc954
a01aac70  5c104ae3  movt     r1, #0xa05c ; constant 0xa05cc954: 'setting'
a01aac74  0400a0e1  mov      r0, r4
a01aac78  b13a0dfa  blx      #0xa04f9744
a01aac7c  001050e2  subs     r1, r0, #0
a01aac80  0900000a  beq      #0xa01aacac
a01aac84  fc1205e3  movw     r1, #0x52fc
a01aac88  0400a0e1  mov      r0, r4
a01aac8c  56104ae3  movt     r1, #0xa056 ; constant 0xa05652fc: 'preview'
a01aac90  ab3a0dfa  blx      #0xa04f9744
a01aac94  000050e3  cmp      r0, #0
a01aac98  0800001a  bne      #0xa01aacc0
a01aac9c  0000e0e3  mvn      r0, #0
a01aaca0  1080bde8  pop      {r4, pc}
a01aaca4  0000e0e3  mvn      r0, #0
a01aaca8  1eff2fe1  bx       lr
a01aacac  0120a0e1  mov      r2, r1
a01aacb0  1d00a0e3  mov      r0, #0x1d
a01aacb4  411dfeeb  bl       #0xa01321c0
a01aacb8  0000a0e3  mov      r0, #0
a01aacbc  1080bde8  pop      {r4, pc}
a01aacc0  0010a0e3  mov      r1, #0
a01aacc4  1b00a0e3  mov      r0, #0x1b
a01aacc8  0120a0e1  mov      r2, r1
a01aaccc  3b1dfeeb  bl       #0xa01321c0
a01aacd0  0000a0e3  mov      r0, #0
a01aacd4  1080bde8  pop      {r4, pc}
a01aacd8  000050e3  cmp      r0, #0
a01aacdc  050000da  ble      #0xa01aacf8
a01aace0  08402de9  push     {r3, lr}
a01aace4  000091e5  ldr      r0, [r1]
a01aace8  0210a0e1  mov      r1, r2
a01aacec  72edffeb  bl       #0xa01a62bc
a01aacf0  0000a0e3  mov      r0, #0
a01aacf4  0880bde8  pop      {r3, pc}
a01aacf8  0000a0e3  mov      r0, #0
a01aacfc  1eff2fe1  bx       lr
a01aad00  000050e3  cmp      r0, #0
a01aad04  050000da  ble      #0xa01aad20
a01aad08  08402de9  push     {r3, lr}
a01aad0c  000091e5  ldr      r0, [r1]
a01aad10  0210a0e1  mov      r1, r2
a01aad14  22edffeb  bl       #0xa01a61a4
a01aad18  0000a0e3  mov      r0, #0
a01aad1c  0880bde8  pop      {r3, pc}
a01aad20  0000a0e3  mov      r0, #0
a01aad24  1eff2fe1  bx       lr
a01aad28  000050e3  cmp      r0, #0
a01aad2c  050000da  ble      #0xa01aad48
a01aad30  08402de9  push     {r3, lr}
a01aad34  000091e5  ldr      r0, [r1]
a01aad38  0210a0e1  mov      r1, r2
a01aad3c  a4edffeb  bl       #0xa01a63d4
a01aad40  0000a0e3  mov      r0, #0
a01aad44  0880bde8  pop      {r3, pc}
a01aad48  0000a0e3  mov      r0, #0
a01aad4c  1eff2fe1  bx       lr
