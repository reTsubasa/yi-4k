a03bc640 1080bde8   pop      {r4, pc}
a03bc644 b62000ea   b        #0xa03c4924
a03bc648 ab2000ea   b        #0xa03c48fc
a03bc64c f0412de9   push     {r4, r5, r6, r7, r8, lr}
a03bc650 0180a0e1   mov      r8, r1
a03bc654 0270a0e1   mov      r7, r2
a03bc658 0050a0e1   mov      r5, r0
a03bc65c 0360a0e1   mov      r6, r3
a03bc660 a52000eb   bl       #0xa03c48fc
a03bc664 0810a0e1   mov      r1, r8
a03bc668 0040a0e1   mov      r4, r0
a03bc66c 0720a0e1   mov      r2, r7
a03bc670 0500a0e1   mov      r0, r5
a03bc674 2d2000eb   bl       #0xa03c4730
a03bc678 010056e3   cmp      r6, #1
a03bc67c 044080e1   orr      r4, r0, r4
a03bc680 0100000a   beq      #0xa03bc68c
a03bc684 0400a0e1   mov      r0, r4
a03bc688 f081bde8   pop      {r4, r5, r6, r7, r8, pc}
a03bc68c 0500a0e1   mov      r0, r5
a03bc690 1c2000eb   bl       #0xa03c4708
a03bc694 044080e1   orr      r4, r0, r4
a03bc698 0400a0e1   mov      r0, r4
a03bc69c f081bde8   pop      {r4, r5, r6, r7, r8, pc}
a03bc6a0 103806e3   movw     r3, #0x6810
a03bc6a4 79314ae3   movt     r3, #0xa179
a03bc6a8 000093e5   ldr      r0, [r3]
a03bc6ac 1eff2fe1   bx       lr
a03bc6b0 04e02de5   str      lr, [sp, #-4]!
a03bc6b4 34c0a0e3   mov      ip, #0x34
a03bc6b8 0cd04de2   sub      sp, sp, #0xc
a03bc6bc 0230a0e1   mov      r3, r2
a03bc6c0 0120a0e1   mov      r2, r1
a03bc6c4 0010a0e3   mov      r1, #0
a03bc6c8 00c08de5   str      ip, [sp]
a03bc6cc 941b00eb   bl       #0xa03c3524
a03bc6d0 0cd08de2   add      sp, sp, #0xc
a03bc6d4 04f09de4   pop      {pc}
a03bc6d8 e11b00ea   b        #0xa03c3664
a03bc6dc 010073e3   cmn      r3, #1
a03bc6e0 0a00000a   beq      #0xa03bc710
a03bc6e4 83c3a0e1   lsl      ip, r3, #7
a03bc6e8 30002de9   push     {r4, r5}
a03bc6ec d34d04e3   movw     r4, #0x4dd3
a03bc6f0 03c14ce0   sub      ip, ip, r3, lsl #2
a03bc6f4 624041e3   movt     r4, #0x1062
a03bc6f8 03308ce0   add      r3, ip, r3
a03bc6fc 8331a0e1   lsl      r3, r3, #3
a03bc700 934485e0   umull    r4, r5, r3, r4
a03bc704 2533a0e1   lsr      r3, r5, #6
a03bc708 3000bde8   pop      {r4, r5}
a03bc70c 4d1b00ea   b        #0xa03c3448
a03bc710 4c1b00ea   b        #0xa03c3448
a03bc714 f91b00ea   b        #0xa03c3700
a03bc718 04e02de5   str      lr, [sp, #-4]!
a03bc71c 30c0a0e3   mov      ip, #0x30
a03bc720 0cd04de2   sub      sp, sp, #0xc
a03bc724 02e0a0e1   mov      lr, r2
a03bc728 0120a0e1   mov      r2, r1
a03bc72c 0010a0e3   mov      r1, #0
a03bc730 00308de5   str      r3, [sp]
a03bc734 0e30a0e1   mov      r3, lr
a03bc738 04c08de5   str      ip, [sp, #4]
a03bc73c b61a00eb   bl       #0xa03c321c
