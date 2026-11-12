; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01a9990+0x154; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01a9990  030050e3  cmp      r0, #3
a01a9994  f0432de9  push     {r4, r5, r6, r7, r8, sb, lr}
a01a9998  0040a0e3  mov      r4, #0
a01a999c  a4d04de2  sub      sp, sp, #0xa4
a01a99a0  0260a0e1  mov      r6, r2
a01a99a4  0c408de5  str      r4, [sp, #0xc]
a01a99a8  2c0000da  ble      #0xa01a9a60
a01a99ac  0150a0e1  mov      r5, r1
a01a99b0  0420a0e1  mov      r2, r4
a01a99b4  000091e5  ldr      r0, [r1]
a01a99b8  0410a0e1  mov      r1, r4
a01a99bc  00460dfa  blx      #0xa04fb1c4
a01a99c0  0410a0e1  mov      r1, r4
a01a99c4  0070a0e1  mov      r7, r0
a01a99c8  0420a0e1  mov      r2, r4
a01a99cc  040095e5  ldr      r0, [r5, #4]
a01a99d0  fb450dfa  blx      #0xa04fb1c4
a01a99d4  0410a0e1  mov      r1, r4
a01a99d8  0420a0e1  mov      r2, r4
a01a99dc  0090a0e1  mov      sb, r0
a01a99e0  080095e5  ldr      r0, [r5, #8]
a01a99e4  f6450dfa  blx      #0xa04fb1c4
a01a99e8  0410a0e1  mov      r1, r4
a01a99ec  0420a0e1  mov      r2, r4
a01a99f0  0080a0e1  mov      r8, r0
a01a99f4  0c0095e5  ldr      r0, [r5, #0xc]
a01a99f8  f1450dfa  blx      #0xa04fb1c4
a01a99fc  0040a0e1  mov      r4, r0
a01a9a00  840c09e3  movw     r0, #0x9c84
a01a9a04  00408de5  str      r4, [sp]
a01a9a08  0710a0e1  mov      r1, r7
a01a9a0c  0920a0e1  mov      r2, sb
a01a9a10  0830a0e1  mov      r3, r8
a01a9a14  56004ae3  movt     r0, #0xa056 ; constant 0xa0569c84: 'StreamID=%d, MaxBitRate=%d, AvgBitRate=%d, MinBitRate=%d\r\n'
a01a9a18  36ff2fe1  blx      r6
a01a9a1c  010057e3  cmp      r7, #1
a01a9a20  1400000a  beq      #0xa01a9a78
a01a9a24  d82208e3  movw     r2, #0x82d8
a01a9a28  6c3208e3  movw     r3, #0x826c
a01a9a2c  3c214ae3  movt     r2, #0xa13c
a01a9a30  3c314ae3  movt     r3, #0xa13c
a01a9a34  000092e5  ldr      r0, [r2]
a01a9a38  003093e5  ldr      r3, [r3]
a01a9a3c  0c308de5  str      r3, [sp, #0xc]
a01a9a40  34108de2  add      r1, sp, #0x34
a01a9a44  ce1c0beb  bl       #0xa0470d84
a01a9a48  7830dde5  ldrb     r3, [sp, #0x78]
a01a9a4c  020053e3  cmp      r3, #2
a01a9a50  0000a013  movne    r0, #0
a01a9a54  0f00000a  beq      #0xa01a9a98
a01a9a58  a4d08de2  add      sp, sp, #0xa4
a01a9a5c  f083bde8  pop      {r4, r5, r6, r7, r8, sb, pc}
a01a9a60  480c09e3  movw     r0, #0x9c48
a01a9a64  56004ae3  movt     r0, #0xa056 ; constant 0xa0569c48: 'set_video_vbr  stream_id maxbitrate avgbitrate minbitrate\r\n'
a01a9a68  32ff2fe1  blx      r2
a01a9a6c  0100a0e3  mov      r0, #1
a01a9a70  a4d08de2  add      sp, sp, #0xa4
a01a9a74  f083bde8  pop      {r4, r5, r6, r7, r8, sb, pc}
a01a9a78  8c2208e3  movw     r2, #0x828c
a01a9a7c  103208e3  movw     r3, #0x8210
a01a9a80  3c214ae3  movt     r2, #0xa13c
a01a9a84  3c314ae3  movt     r3, #0xa13c
a01a9a88  002092e5  ldr      r2, [r2]
a01a9a8c  000093e5  ldr      r0, [r3]
a01a9a90  0c208de5  str      r2, [sp, #0xc]
a01a9a94  e9ffffea  b        #0xa01a9a40
a01a9a98  7c3003e3  movw     r3, #0x307c
a01a9a9c  c00c09e3  movw     r0, #0x9cc0
a01a9aa0  6f304ae3  movt     r3, #0xa06f
a01a9aa4  00408de5  str      r4, [sp]
a01a9aa8  0720a0e1  mov      r2, r7
a01a9aac  041093e5  ldr      r1, [r3, #4]
a01a9ab0  56004ae3  movt     r0, #0xa056 ; constant 0xa0569cc0: '%sStream[%d]: avg=%d bps, [%d , %d] bps \r\n\n'
a01a9ab4  0830a0e1  mov      r3, r8
a01a9ab8  04908de5  str      sb, [sp, #4]
a01a9abc  2c408de5  str      r4, [sp, #0x2c]
a01a9ac0  30908de5  str      sb, [sp, #0x30]
a01a9ac4  28808de5  str      r8, [sp, #0x28]
a01a9ac8  87f503eb  bl       #0xa02a70ec ; analyst_printf_like
a01a9acc  10008de2  add      r0, sp, #0x10
a01a9ad0  0c108de2  add      r1, sp, #0xc
a01a9ad4  24ba07eb  bl       #0xa039836c
a01a9ad8  0000a0e3  mov      r0, #0
a01a9adc  a4d08de2  add      sp, sp, #0xa4
a01a9ae0  f083bde8  pop      {r4, r5, r6, r7, r8, sb, pc}
