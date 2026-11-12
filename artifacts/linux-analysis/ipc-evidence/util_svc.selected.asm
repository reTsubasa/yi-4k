
FUNCTION AmbaRpcProg_Util_Exec2_Svc 0x10e0c
00010e0c push     {r4, lr}
00010e10 mov      r4, r1
00010e14 bl       #0x10988 ; system
00010e18 cmp      r0, #0
00010e1c moveq    r3, #1
00010e20 streq    r0, [r4, #0xc]
00010e24 streq    r3, [r4, #8]
00010e28 popeq    {r4, pc}
00010e2c ldr      r0, [pc, #0x18]
00010e30 add      r0, pc, r0
00010e34 bl       #0x10964 ; puts
00010e38 mov      r2, #2
00010e3c mov      r1, #1
00010e40 str      r2, [r4, #0xc]
00010e44 str      r1, [r4, #8]
00010e48 pop      {r4, pc}
00010e4c muleq    r0, r4, r0

FUNCTION AmbaRpcProg_Util_Exec1_Svc 0x10cbc
00010cbc push     {r4, r5, r6, r7, r8, sb, lr}
00010cc0 mov      r4, r0
00010cc4 sub      sp, sp, #0x6c
00010cc8 mov      r0, #0x1000
00010ccc mov      sb, r1
00010cd0 bl       #0x10970 ; malloc
00010cd4 ldr      r1, [pc, #0xf4]
00010cd8 mov      r6, r0
00010cdc ldr      r8, [pc, #0xf0]
00010ce0 mov      r0, r4
00010ce4 add      r1, pc, r1
00010ce8 bl       #0x109dc ; popen
00010cec subs     r7, r0, #0
00010cf0 add      r8, pc, r8
00010cf4 beq      #0x10db0
00010cf8 add      r4, sp, #4
00010cfc mov      r2, r7
00010d00 mov      r1, #0x64
00010d04 mov      r0, r4
00010d08 bl       #0x10904 ; fgets
00010d0c mov      r1, r4
00010d10 mov      r0, r6
00010d14 bl       #0x1094c ; strcpy
00010d18 mov      r0, r4
00010d1c bl       #0x109b8 ; strlen
00010d20 mov      r5, r0
00010d24 b        #0x10d50
00010d28 bl       #0x109b8 ; strlen
00010d2c ldr      r3, [pc, #0xa4]
00010d30 add      r5, r5, r0
00010d34 mov      r1, r4
00010d38 mov      r0, r6
00010d3c ldr      r2, [r8, r3]
00010d40 ldr      ip, [r2]
00010d44 cmp      r5, ip
00010d48 bge      #0x10d6c
00010d4c bl       #0x10940 ; strcat
00010d50 mov      r2, r7
00010d54 mov      r1, #0x64
00010d58 mov      r0, r4
00010d5c bl       #0x10904 ; fgets
00010d60 cmp      r0, #0
00010d64 mov      r0, r4
00010d68 bne      #0x10d28
00010d6c mov      r0, r6
00010d70 bl       #0x109b8 ; strlen
00010d74 add      r8, r0, #1
00010d78 mov      r1, r6
00010d7c mov      r2, r8
00010d80 ldr      r0, [sb, #4]
00010d84 bl       #0x10910 ; memcpy
00010d88 mov      r1, #0
00010d8c mov      r0, r6
00010d90 str      r1, [sb, #0xc]
00010d94 str      r1, [sb, #8]
00010d98 str      r8, [sb]
00010d9c bl       #0x108f8 ; free
00010da0 mov      r0, r7
00010da4 bl       #0x10a00 ; pclose
00010da8 add      sp, sp, #0x6c
00010dac pop      {r4, r5, r6, r7, r8, sb, pc}
00010db0 ldr      r0, [pc, #0x24]
00010db4 mov      r4, #2
00010db8 add      r0, pc, r0
00010dbc bl       #0x10964 ; puts
00010dc0 str      r7, [sb, #8]
00010dc4 str      r4, [sb, #0xc]
00010dc8 add      sp, sp, #0x6c
00010dcc pop      {r4, r5, r6, r7, r8, sb, pc}
00010dd0 strheq   r0, [r0], -r4
00010dd4 andeq    r0, r1, ip, lsl r4
00010dd8 andeq    r0, r0, r8, ror r0
00010ddc andeq    r0, r0, r4, ror #1
