; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; threadx_sleep, mode=ARM; selected range, not guaranteed function boundary
a03c0b20  70402de9   push      {r4, r5, r6, lr}
a03c0b24  0040a0e1   mov       r4, r0
a03c0b28  200200eb   bl        #0xa03c13b0
a03c0b2c  0060a0e1   mov       r6, r0
a03c0b30  850000eb   bl        #0xa03c0d4c
a03c0b34  005050e2   subs      r5, r0, #0
a03c0b38  1900000a   beq       #0xa03c0ba4
a03c0b3c  710000eb   bl        #0xa03c0d08
a03c0b40  002050e2   subs      r2, r0, #0
a03c0b44  1600001a   bne       #0xa03c0ba4
a03c0b48  343c06e3   movw      r3, #0x6c34
a03c0b4c  79314ae3   movt      r3, #0xa179
a03c0b50  030055e1   cmp       r5, r3
a03c0b54  1200000a   beq       #0xa03c0ba4
a03c0b58  000054e3   cmp       r4, #0
a03c0b5c  1400000a   beq       #0xa03c0bb4
a03c0b60  803706e3   movw      r3, #0x6780
a03c0b64  01c0a0e3   mov       ip, #1
a03c0b68  79314ae3   movt      r3, #0xa179
a03c0b6c  04e0a0e3   mov       lr, #4
a03c0b70  001093e5   ldr       r1, [r3]
a03c0b74  0600a0e1   mov       r0, r6
a03c0b78  882085e5   str       r2, [r5, #0x88]
a03c0b7c  30e085e5   str       lr, [r5, #0x30]
a03c0b80  0c2081e0   add       r2, r1, ip
a03c0b84  38c085e5   str       ip, [r5, #0x38]
a03c0b88  4c4085e5   str       r4, [r5, #0x4c]
a03c0b8c  002083e5   str       r2, [r3]
a03c0b90  240200eb   bl        #0xa03c1428
a03c0b94  0500a0e1   mov       r0, r5
a03c0b98  6f0400eb   bl        #0xa03c1d5c
a03c0b9c  880095e5   ldr       r0, [r5, #0x88]
a03c0ba0  7080bde8   pop       {r4, r5, r6, pc}
a03c0ba4  0600a0e1   mov       r0, r6
a03c0ba8  1e0200eb   bl        #0xa03c1428
a03c0bac  1300a0e3   mov       r0, #0x13
a03c0bb0  7080bde8   pop       {r4, r5, r6, pc}
a03c0bb4  0600a0e1   mov       r0, r6
a03c0bb8  1a0200eb   bl        #0xa03c1428
a03c0bbc  0400a0e1   mov       r0, r4
a03c0bc0  7080bde8   pop       {r4, r5, r6, pc}
