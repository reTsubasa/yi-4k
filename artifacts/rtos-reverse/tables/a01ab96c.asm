; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01ab96c+0x90; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01ab96c  000050e3  cmp      r0, #0
a01ab970  30402de9  push     {r4, r5, lr}
a01ab974  0250a0e1  mov      r5, r2
a01ab978  0cd04de2  sub      sp, sp, #0xc
a01ab97c  170000da  ble      #0xa01ab9e0
a01ab980  0130a0e1  mov      r3, r1
a01ab984  d4170ae3  movw     r1, #0xa7d4
a01ab988  000093e5  ldr      r0, [r3]
a01ab98c  56104ae3  movt     r1, #0xa056 ; constant 0xa056a7d4: 'chip_id'
a01ab990  6b370dfa  blx      #0xa04f9744
a01ab994  004050e2  subs     r4, r0, #0
a01ab998  1000001a  bne      #0xa01ab9e0
a01ab99c  a43505e3  movw     r3, #0x55a4
a01ab9a0  a3314ae3  movt     r3, #0xa1a3
a01ab9a4  003093e5  ldr      r3, [r3]
a01ab9a8  0cc093e5  ldr      ip, [r3, #0xc]
a01ab9ac  00005ce3  cmp      ip, #0
a01ab9b0  0300000a  beq      #0xa01ab9c4
a01ab9b4  0410a0e1  mov      r1, r4
a01ab9b8  06208de2  add      r2, sp, #6
a01ab9bc  0130a0e3  mov      r3, #1
a01ab9c0  3cff2fe1  blx      ip
a01ab9c4  dc070ae3  movw     r0, #0xa7dc
a01ab9c8  b610dde1  ldrh     r1, [sp, #6]
a01ab9cc  56004ae3  movt     r0, #0xa056 ; constant 0xa056a7dc: 'gyro chip id: 0x%02x\r\n'
a01ab9d0  35ff2fe1  blx      r5
a01ab9d4  0400a0e1  mov      r0, r4
a01ab9d8  0cd08de2  add      sp, sp, #0xc
a01ab9dc  3080bde8  pop      {r4, r5, pc}
a01ab9e0  f4070ae3  movw     r0, #0xa7f4
a01ab9e4  0040e0e3  mvn      r4, #0
a01ab9e8  56004ae3  movt     r0, #0xa056 ; constant 0xa056a7f4: 'gyro chip_id\r\n'
a01ab9ec  35ff2fe1  blx      r5
a01ab9f0  0400a0e1  mov      r0, r4
a01ab9f4  0cd08de2  add      sp, sp, #0xc
a01ab9f8  3080bde8  pop      {r4, r5, pc}
