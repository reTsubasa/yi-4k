; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; kal_bytepool, mode=ARM; selected range, not guaranteed function boundary
a03bc6b0  04e02de5   str       lr, [sp, #-4]!
a03bc6b4  34c0a0e3   mov       ip, #0x34
a03bc6b8  0cd04de2   sub       sp, sp, #0xc
a03bc6bc  0230a0e1   mov       r3, r2
a03bc6c0  0120a0e1   mov       r2, r1
a03bc6c4  0010a0e3   mov       r1, #0
a03bc6c8  00c08de5   str       ip, [sp]
a03bc6cc  941b00eb   bl        #0xa03c3524
a03bc6d0  0cd08de2   add       sp, sp, #0xc
a03bc6d4  04f09de4   pop       {pc}
a03bc6d8  e11b00ea   b         #0xa03c3664
a03bc6dc  010073e3   cmn       r3, #1
a03bc6e0  0a00000a   beq       #0xa03bc710
a03bc6e4  83c3a0e1   lsl       ip, r3, #7
a03bc6e8  30002de9   push      {r4, r5}
a03bc6ec  d34d04e3   movw      r4, #0x4dd3
a03bc6f0  03c14ce0   sub       ip, ip, r3, lsl #2
a03bc6f4  624041e3   movt      r4, #0x1062
a03bc6f8  03308ce0   add       r3, ip, r3
a03bc6fc  8331a0e1   lsl       r3, r3, #3
a03bc700  934485e0   umull     r4, r5, r3, r4
a03bc704  2533a0e1   lsr       r3, r5, #6
a03bc708  3000bde8   pop       {r4, r5}
a03bc70c  4d1b00ea   b         #0xa03c3448
a03bc710  4c1b00ea   b         #0xa03c3448
a03bc714  f91b00ea   b         #0xa03c3700
