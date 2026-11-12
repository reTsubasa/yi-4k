; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01acd10+0x140; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01acd10  f0412de9  push     {r4, r5, r6, r7, r8, lr}
a01acd14  48d04de2  sub      sp, sp, #0x48
a01acd18  0050a0e1  mov      r5, r0
a01acd1c  0160a0e1  mov      r6, r1
a01acd20  0270a0e1  mov      r7, r2
a01acd24  0d00a0e1  mov      r0, sp
a01acd28  0010a0e3  mov      r1, #0
a01acd2c  4820a0e3  mov      r2, #0x48
a01acd30  2d300dfa  blx      #0xa04f8dec
a01acd34  000055e3  cmp      r5, #0
a01acd38  0e0000da  ble      #0xa01acd78
a01acd3c  004096e5  ldr      r4, [r6]
a01acd40  ec1d0ce3  movw     r1, #0xcdec
a01acd44  57104ae3  movt     r1, #0xa057 ; constant 0xa057cdec: 'init'
a01acd48  0400a0e1  mov      r0, r4
a01acd4c  7c320dfa  blx      #0xa04f9744
a01acd50  000050e3  cmp      r0, #0
a01acd54  2600000a  beq      #0xa01acdf4
a01acd58  18100be3  movw     r1, #0xb018
a01acd5c  0400a0e1  mov      r0, r4
a01acd60  62104ae3  movt     r1, #0xa062 ; constant 0xa062b018: 'read'
a01acd64  76320dfa  blx      #0xa04f9744
a01acd68  008050e2  subs     r8, r0, #0
a01acd6c  0700001a  bne      #0xa01acd90
a01acd70  020055e3  cmp      r5, #2
a01acd74  240000ca  bgt      #0xa01ace0c
a01acd78  1c0f0ae3  movw     r0, #0xaf1c
a01acd7c  56004ae3  movt     r0, #0xa056 ; constant 0xa056af1c: 't ants bitmaps [init|read|write|info]\n'
a01acd80  37ff2fe1  blx      r7
a01acd84  0000a0e3  mov      r0, #0
a01acd88  48d08de2  add      sp, sp, #0x48
a01acd8c  f081bde8  pop      {r4, r5, r6, r7, r8, pc}
a01acd90  241a0ee3  movw     r1, #0xea24
a01acd94  0400a0e1  mov      r0, r4
a01acd98  63104ae3  movt     r1, #0xa063 ; constant 0xa063ea24: 'write'
a01acd9c  68320dfa  blx      #0xa04f9744
a01acda0  000050e3  cmp      r0, #0
a01acda4  1600000a  beq      #0xa01ace04
a01acda8  041f0ce3  movw     r1, #0xcf04
a01acdac  0400a0e1  mov      r0, r4
a01acdb0  5f104ae3  movt     r1, #0xa05f ; constant 0xa05fcf04: 'info'
a01acdb4  62320dfa  blx      #0xa04f9744
a01acdb8  000050e3  cmp      r0, #0
a01acdbc  edffff1a  bne      #0xa01acd78
a01acdc0  0d00a0e1  mov      r0, sp
a01acdc4  c6660beb  bl       #0xa04868e4
a01acdc8  001050e2  subs     r1, r0, #0
a01acdcc  1b00001a  bne      #0xa01ace40
a01acdd0  ec0e0ae3  movw     r0, #0xaeec
a01acdd4  0d10a0e1  mov      r1, sp
a01acdd8  56004ae3  movt     r0, #0xa056 ; constant 0xa056aeec: 'file name: %s\n'
a01acddc  37ff2fe1  blx      r7
a01acde0  fc0e0ae3  movw     r0, #0xaefc
a01acde4  40109de5  ldr      r1, [sp, #0x40]
a01acde8  56004ae3  movt     r0, #0xa056 ; constant 0xa056aefc: 'file size: %d\n'
a01acdec  37ff2fe1  blx      r7
a01acdf0  e3ffffea  b        #0xa01acd84
a01acdf4  36660beb  bl       #0xa04866d4
a01acdf8  0000a0e3  mov      r0, #0
a01acdfc  48d08de2  add      sp, sp, #0x48
a01ace00  f081bde8  pop      {r4, r5, r6, r7, r8, pc}
a01ace04  43ffffeb  bl       #0xa01acb18
a01ace08  ddffffea  b        #0xa01acd84
a01ace0c  0810a0e1  mov      r1, r8
a01ace10  0820a0e1  mov      r2, r8
a01ace14  040096e5  ldr      r0, [r6, #4]
a01ace18  e9380dfa  blx      #0xa04fb1c4
a01ace1c  0810a0e1  mov      r1, r8
a01ace20  0040a0e1  mov      r4, r0
a01ace24  0820a0e1  mov      r2, r8
a01ace28  080096e5  ldr      r0, [r6, #8]
a01ace2c  e4380dfa  blx      #0xa04fb1c4
a01ace30  0010a0e1  mov      r1, r0
a01ace34  0400a0e1  mov      r0, r4
a01ace38  aefeffeb  bl       #0xa01ac8f8
a01ace3c  d0ffffea  b        #0xa01acd84
a01ace40  0c0f0ae3  movw     r0, #0xaf0c
a01ace44  56004ae3  movt     r0, #0xa056 ; constant 0xa056af0c: 'data size: %d\n'
a01ace48  37ff2fe1  blx      r7
a01ace4c  ccffffea  b        #0xa01acd84
