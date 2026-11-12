; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; stdio, mode=ARM; selected range, not guaranteed function boundary
a032e0c8  503000ea   b         #0xa033a210
a032e0cc  b73000ea   b         #0xa033a3b0
a032e0d0  423000ea   b         #0xa033a1e0
a032e0d4  743000ea   b         #0xa033a2ac
a032e0d8  b83000ea   b         #0xa033a3c0
a032e0dc  04e02de5   str       lr, [sp, #-4]!
a032e0e0  0cd04de2   sub       sp, sp, #0xc
a032e0e4  0d10a0e1   mov       r1, sp
a032e0e8  443000eb   bl        #0xa033a200
a032e0ec  000050e3   cmp       r0, #0
a032e0f0  0200001a   bne       #0xa032e100
a032e0f4  d000cde1   ldrd      r0, r1, [sp]
a032e0f8  0cd08de2   add       sp, sp, #0xc
a032e0fc  04f09de4   pop       {pc}
a032e100  0000e0e3   mvn       r0, #0
a032e104  0010e0e3   mvn       r1, #0
a032e108  faffffea   b         #0xa032e0f8
a032e10c  6e3000ea   b         #0xa033a2cc
a032e110  363000ea   b         #0xa033a1f0
a032e114  263000ea   b         #0xa033a1b4
a032e118  fb3000ea   b         #0xa033a50c
a032e11c  0d3100ea   b         #0xa033a558
a032e120  d93000ea   b         #0xa033a48c
a032e124  df2f00ea   b         #0xa033a0a8
a032e128  0030a0e3   mov       r3, #0
a032e12c  fd2f00ea   b         #0xa033a128
a032e130  0210a0e1   mov       r1, r2
a032e134  08402de9   push      {r3, lr}
a032e138  213000eb   bl        #0xa033a1c4
a032e13c  0010a0e3   mov       r1, #0
a032e140  0880bde8   pop       {r3, pc}
a032e144  9a2f00ea   b         #0xa0339fb4
a032e148  1c2f00ea   b         #0xa0339dc0
a032e14c  5e2f00ea   b         #0xa0339ecc
a032e150  30402de9   push      {r4, r5, lr}
a032e154  0cd04de2   sub       sp, sp, #0xc
a032e158  18c09de5   ldr       ip, [sp, #0x18]
a032e15c  0050a0e1   mov       r5, r0
a032e160  0340a0e1   mov       r4, r3
a032e164  00c08de5   str       ip, [sp]
a032e168  6d2f00eb   bl        #0xa0339f24
a032e16c  000050e3   cmp       r0, #0
a032e170  0400001a   bne       #0xa032e188
a032e174  0500a0e1   mov       r0, r5
a032e178  0410a0e1   mov       r1, r4
a032e17c  0cd08de2   add       sp, sp, #0xc
a032e180  3040bde8   pop       {r4, r5, lr}
a032e184  3a2f00ea   b         #0xa0339e74
a032e188  0000e0e3   mvn       r0, #0
a032e18c  0cd08de2   add       sp, sp, #0xc
a032e190  3080bde8   pop       {r4, r5, pc}
a032e194  f04f2de9   push      {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a032e198  24d04de2   sub       sp, sp, #0x24
a032e19c  0140a0e1   mov       r4, r1
a032e1a0  0d10a0e1   mov       r1, sp
a032e1a4  6b3000eb   bl        #0xa033a358
a032e1a8  000050e3   cmp       r0, #0
a032e1ac  2300001a   bne       #0xa032e240
a032e1b0  bec0dde1   ldrh      ip, [sp, #0xe]
a032e1b4  b611dde1   ldrh      r1, [sp, #0x16]
a032e1b8  b221dde1   ldrh      r2, [sp, #0x12]
a032e1bc  b831dde1   ldrh      r3, [sp, #0x18]
a032e1c0  1f800ce2   and       r8, ip, #0x1f
a032e1c4  1f9001e2   and       sb, r1, #0x1f
a032e1c8  8880a0e1   lsl       r8, r8, #1
a032e1cc  ac55a0e1   lsr       r5, ip, #0xb
a032e1d0  8990a0e1   lsl       sb, sb, #1
a032e1d4  d060cde1   ldrd      r6, r7, [sp]
a032e1d8  a1b5a0e1   lsr       fp, r1, #0xb
a032e1dc  1de0dde5   ldrb      lr, [sp, #0x1d]
a032e1e0  a2a4a0e1   lsr       sl, r2, #9
a032e1e4  1680c4e5   strb      r8, [r4, #0x16]
a032e1e8  a384a0e1   lsr       r8, r3, #9
a032e1ec  dcc2e5e7   ubfx      ip, ip, #5, #6
a032e1f0  1e90c4e5   strb      sb, [r4, #0x1e]
a032e1f4  d112e5e7   ubfx      r1, r1, #5, #6
a032e1f8  1f9002e2   and       sb, r2, #0x1f
a032e1fc  1450c4e5   strb      r5, [r4, #0x14]
a032e200  d222e3e7   ubfx      r2, r2, #5, #4
a032e204  1f5003e2   and       r5, r3, #0x1f
a032e208  d332e3e7   ubfx      r3, r3, #5, #4
a032e20c  15c0c4e5   strb      ip, [r4, #0x15]
a032e210  1cb0c4e5   strb      fp, [r4, #0x1c]
a032e214  1d10c4e5   strb      r1, [r4, #0x1d]
a032e218  10a0c4e5   strb      sl, [r4, #0x10]
a032e21c  1290c4e5   strb      sb, [r4, #0x12]
a032e220  1120c4e5   strb      r2, [r4, #0x11]
a032e224  1880c4e5   strb      r8, [r4, #0x18]
a032e228  1a50c4e5   strb      r5, [r4, #0x1a]
a032e22c  1930c4e5   strb      r3, [r4, #0x19]
a032e230  f860c4e1   strd      r6, r7, [r4, #8]
a032e234  00e084e5   str       lr, [r4]
a032e238  24d08de2   add       sp, sp, #0x24
a032e23c  f08fbde8   pop       {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a032e240  0000e0e3   mvn       r0, #0
a032e244  fbffffea   b         #0xa032e238
