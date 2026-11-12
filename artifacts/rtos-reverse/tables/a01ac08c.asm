; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01ac08c+0x60; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01ac08c  000050e3  cmp      r0, #0
a01ac090  70402de9  push     {r4, r5, r6, lr}
a01ac094  0250a0e1  mov      r5, r2
a01ac098  0e0000da  ble      #0xa01ac0d8
a01ac09c  000091e5  ldr      r0, [r1]
a01ac0a0  0140a0e1  mov      r4, r1
a01ac0a4  7d2f0dfa  blx      #0xa04f7ea0
a01ac0a8  7060efe6  uxtb     r6, r0
a01ac0ac  041094e5  ldr      r1, [r4, #4]
a01ac0b0  0120a0e3  mov      r2, #1
a01ac0b4  0600a0e1  mov      r0, r6
a01ac0b8  82b5ffeb  bl       #0xa01996c8
a01ac0bc  1c0a0ae3  movw     r0, #0xaa1c
a01ac0c0  0610a0e1  mov      r1, r6
a01ac0c4  042094e5  ldr      r2, [r4, #4]
a01ac0c8  56004ae3  movt     r0, #0xa056 ; constant 0xa056aa1c: 'show_str [%d] %s!\r\n'
a01ac0cc  35ff2fe1  blx      r5
a01ac0d0  0000a0e3  mov      r0, #0
a01ac0d4  7080bde8  pop      {r4, r5, r6, pc}
a01ac0d8  300a0ae3  movw     r0, #0xaa30
a01ac0dc  56004ae3  movt     r0, #0xa056 ; constant 0xa056aa30: 'show_str [line] xxx!\r\n'
a01ac0e0  32ff2fe1  blx      r2
a01ac0e4  0000e0e3  mvn      r0, #0
a01ac0e8  7080bde8  pop      {r4, r5, r6, pc}
