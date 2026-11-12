WINDOW 0x4000fdf4
4000fdf4 movw     r3, #0x5b48
4000fdf8 push     {r4, r5, r6, lr}
4000fdfc movt     r3, #0x4055
4000fe00 movw     r4, #0x96b4
4000fe04 mov      r1, r0
4000fe08 movt     r4, #0x4056
4000fe0c ldr      r2, [r3, #0x60]
4000fe10 mov      r5, #0x3e8
4000fe14 ldrb     r0, [r3]
4000fe18 blx      r2
4000fe1c movw     r0, #0x65b0
4000fe20 ldr      r1, [r4, #4]
4000fe24 movt     r0, #0x666
4000fe28 blx      r1
4000fe2c movw     r0, #0x65b0
4000fe30 ldr      r6, [r4, #4]
4000fe34 movt     r0, #0x666
4000fe38 blx      r6
4000fe3c movw     r0, #0x65b0
4000fe40 ldr      ip, [r4, #4]
4000fe44 movt     r0, #0x666
4000fe48 blx      ip
4000fe4c movw     r0, #0x65b0
4000fe50 ldr      r3, [r4, #4]
4000fe54 movt     r0, #0x666
4000fe58 blx      r3
4000fe5c movw     r0, #0x65b0
4000fe60 ldr      r2, [r4, #4]
4000fe64 movt     r0, #0x666
4000fe68 blx      r2
4000fe6c movw     r0, #0x65b0
4000fe70 ldr      r1, [r4, #4]
4000fe74 movt     r0, #0x666
4000fe78 blx      r1
4000fe7c movw     r0, #0x65b0
4000fe80 ldr      r6, [r4, #4]
WINDOW 0x4001d894
4001d894 movw     r3, #0x7d40
4001d898 push     {r4, lr}
4001d89c movt     r3, #0x4055
4001d8a0 ldr      r0, [r3]
4001d8a4 ldr      r1, [r0]
4001d8a8 cmp      r1, #0
4001d8ac bne      #0x4001d8d8
4001d8b0 cpsid    i
4001d8b4 cpsid    f
4001d8b8 bl       #0x4001912c
4001d8bc mov      ip, #0
4001d8c0 mov      r2, #2
4001d8c4 movt     ip, #0xe817
4001d8c8 str      r2, [ip, #0x68]
4001d8cc mov      r3, #3
4001d8d0 str      r3, [ip, #0x68]
4001d8d4 pop      {r4, pc}
4001d8d8 bl       #0x400209a4
4001d8dc b        #0x4001d8b4
4001d8e0 mov      r3, #0
4001d8e4 sub      sp, sp, #8
4001d8e8 movt     r3, #0xe817
4001d8ec ldr      r2, [r3, #0x50]
4001d8f0 str      r2, [sp, #4]
4001d8f4 ldr      r0, [sp, #4]
4001d8f8 orr      r1, r0, #0x20
4001d8fc str      r1, [r3, #0x50]
4001d900 add      sp, sp, #8
4001d904 bx       lr
4001d908 bx       lr
4001d90c bx       lr
4001d910 mov      r0, #0
4001d914 bx       lr
4001d918 mov      r0, #0
4001d91c bx       lr
4001d920 mov      r0, #0
4001d924 bx       lr
4001d928 bx       lr
4001d92c push     {r4, lr}
4001d930 bl       #0x40019880
4001d934 mov      r0, #0
4001d938 pop      {r4, pc}
4001d93c push     {r4, r5, lr}
4001d940 mov      r1, #0
4001d944 sub      sp, sp, #0xc
4001d948 mov      r5, r0
4001d94c bl       #0x4001d3d8
4001d950 bic      r2, r0, #0x8000
4001d954 cmp      r2, #1
4001d958 movle    r4, #0
4001d95c ble      #0x4001d978
4001d960 movw     r0, #0xcbc8
4001d964 rsb      r4, r2, #1
4001d968 movt     r0, #0x4057
4001d96c ldrh     r1, [r0, #0x12]
4001d970 tst      r1, #4
4001d974 bne      #0x4001d984
4001d978 mov      r0, r4
4001d97c add      sp, sp, #0xc
4001d980 pop      {r4, r5, pc}
4001d984 movw     r2, #0x7220
4001d988 movw     r1, #0xe6e8
4001d98c str      r4, [sp]
4001d990 mov      r3, r5
4001d994 movt     r2, #0x4040
4001d998 movt     r1, #0x4049
4001d99c bl       #0x40223ed8
4001d9a0 b        #0x4001d978
4001d9a4 push     {r4, r5, lr}
4001d9a8 mov      r1, #0
4001d9ac sub      sp, sp, #0xc
4001d9b0 mov      r5, r0
