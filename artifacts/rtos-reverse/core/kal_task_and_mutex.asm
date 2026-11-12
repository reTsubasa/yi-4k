; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; kal_task_and_mutex, mode=ARM; selected range, not guaranteed function boundary
a03bc30c  5e2000ea   b         #0xa03c448c
a03bc310  df2000ea   b         #0xa03c4694
a03bc314  b22000ea   b         #0xa03c45e4
a03bc318  d32000ea   b         #0xa03c466c
a03bc31c  c82000ea   b         #0xa03c4644
a03bc320  fe1100ea   b         #0xa03c0b20
a03bc324  30402de9   push      {r4, r5, lr}
a03bc328  3cd04de2   sub       sp, sp, #0x3c
a03bc32c  28208de2   add       r2, sp, #0x28
a03bc330  2c308de2   add       r3, sp, #0x2c
a03bc334  30e08de2   add       lr, sp, #0x30
a03bc338  34c08de2   add       ip, sp, #0x34
a03bc33c  24508de2   add       r5, sp, #0x24
a03bc340  0140a0e1   mov       r4, r1
a03bc344  04208de5   str       r2, [sp, #4]
a03bc348  18108de2   add       r1, sp, #0x18
a03bc34c  1c208de2   add       r2, sp, #0x1c
a03bc350  08308de5   str       r3, [sp, #8]
a03bc354  00508de5   str       r5, [sp]
a03bc358  20308de2   add       r3, sp, #0x20
a03bc35c  0ce08de5   str       lr, [sp, #0xc]
a03bc360  10c08de5   str       ip, [sp, #0x10]
a03bc364  652000eb   bl        #0xa03c4500
a03bc368  1c109de5   ldr       r1, [sp, #0x1c]
a03bc36c  24209de5   ldr       r2, [sp, #0x24]
a03bc370  18309de5   ldr       r3, [sp, #0x18]
a03bc374  0e0084e8   stm       r4, {r1, r2, r3}
a03bc378  3cd08de2   add       sp, sp, #0x3c
a03bc37c  3080bde8   pop       {r4, r5, pc}
a03bc380  6f2000ea   b         #0xa03c4544
a03bc384  780f00ea   b         #0xa03c016c
a03bc388  08402de9   push      {r3, lr}
a03bc38c  5d1200eb   bl        #0xa03c0d08
a03bc390  000090e2   adds      r0, r0, #0
a03bc394  0100a013   movne     r0, #1
a03bc398  0880bde8   pop       {r3, pc}
a03bc39c  000050e3   cmp       r0, #0
a03bc3a0  0600000a   beq       #0xa03bc3c0
a03bc3a4  10402de9   push      {r4, lr}
a03bc3a8  0040a0e1   mov       r4, r0
a03bc3ac  ff1300eb   bl        #0xa03c13b0
a03bc3b0  0030a0e3   mov       r3, #0
a03bc3b4  000084e5   str       r0, [r4]
a03bc3b8  0300a0e1   mov       r0, r3
a03bc3bc  1080bde8   pop       {r4, pc}
a03bc3c0  0030e0e3   mvn       r3, #0
a03bc3c4  0300a0e1   mov       r0, r3
a03bc3c8  1eff2fe1   bx        lr
a03bc3cc  08402de9   push      {r3, lr}
a03bc3d0  141400eb   bl        #0xa03c1428
a03bc3d4  0000a0e3   mov       r0, #0
a03bc3d8  0880bde8   pop       {r3, pc}
a03bc3dc  0120a0e1   mov       r2, r1
a03bc3e0  2030a0e3   mov       r3, #0x20
a03bc3e4  0010a0e3   mov       r1, #0
a03bc3e8  001f00ea   b         #0xa03c3ff0
a03bc3ec  451f00ea   b         #0xa03c4108
a03bc3f0  010071e3   cmn       r1, #1
a03bc3f4  0700000a   beq       #0xa03bc418
a03bc3f8  8133a0e1   lsl       r3, r1, #7
a03bc3fc  d32d04e3   movw      r2, #0x4dd3
a03bc400  622041e3   movt      r2, #0x1062
a03bc404  013143e0   sub       r3, r3, r1, lsl #2
a03bc408  011083e0   add       r1, r3, r1
a03bc40c  8111a0e1   lsl       r1, r1, #3
a03bc410  912283e0   umull     r2, r3, r1, r2
a03bc414  2313a0e1   lsr       r1, r3, #6
a03bc418  521f00ea   b         #0xa03c4168
a03bc41c  7d1f00ea   b         #0xa03c4218
a03bc420  10402de9   push      {r4, lr}
a03bc424  20d04de2   sub       sp, sp, #0x20
a03bc428  18208de2   add       r2, sp, #0x18
a03bc42c  1c308de2   add       r3, sp, #0x1c
a03bc430  0140a0e1   mov       r4, r1
a03bc434  0c108de2   add       r1, sp, #0xc
a03bc438  0c008de8   stm       sp, {r2, r3}
a03bc43c  14308de2   add       r3, sp, #0x14
a03bc440  10208de2   add       r2, sp, #0x10
a03bc444  651f00eb   bl        #0xa03c41e0
a03bc448  10309de5   ldr       r3, [sp, #0x10]
a03bc44c  003084e5   str       r3, [r4]
a03bc450  20d08de2   add       sp, sp, #0x20
a03bc454  1080bde8   pop       {r4, pc}
a03bc458  0010a0e3   mov       r1, #0
a03bc45c  0120a0e3   mov       r2, #1
a03bc460  3430a0e3   mov       r3, #0x34
a03bc464  631d00ea   b         #0xa03c39f8
a03bc468  ac1d00ea   b         #0xa03c3b20
a03bc46c  010071e3   cmn       r1, #1
a03bc470  0700000a   beq       #0xa03bc494
a03bc474  8133a0e1   lsl       r3, r1, #7
a03bc478  d32d04e3   movw      r2, #0x4dd3
a03bc47c  622041e3   movt      r2, #0x1062
a03bc480  013143e0   sub       r3, r3, r1, lsl #2
a03bc484  011083e0   add       r1, r3, r1
a03bc488  8111a0e1   lsl       r1, r1, #3
a03bc48c  912283e0   umull     r2, r3, r1, r2
a03bc490  2313a0e1   lsr       r1, r3, #6
a03bc494  b91d00ea   b         #0xa03c3b80
