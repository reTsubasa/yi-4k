
FUNCTION cmd_server_send_data 0x260c
0000260c push     {r0, r1, r4, lr}
00002610 mov      r1, r0
00002614 ldr      ip, [pc, #0xb0]
00002618 mov      r3, #0
0000261c mov      lr, #0x30
00002620 ldr      r0, [r0, #8]
00002624 mul      r2, lr, r3
00002628 ldr      r4, [r2, ip]
0000262c cmp      r0, r4
00002630 bne      #0x266c
00002634 ldr      ip, [pc, #0x90]
00002638 add      lr, ip, r2
0000263c ldr      r2, [r1, #0xc]
00002640 ldr      r4, [lr, #8]
00002644 cmp      r4, r2
00002648 beq      #0x2690
0000264c str      r2, [sp, #4]
00002650 mov      r3, r0
00002654 str      r4, [sp]
00002658 mov      r2, #0xc4
0000265c ldr      r1, [pc, #0x6c]
00002660 ldr      r0, [pc, #0x6c]
00002664 bl       #0x1164 ; printf
00002668 b        #0x26c0
0000266c add      r3, r3, #1
00002670 cmp      r3, #0xa
00002674 bne      #0x2624
00002678 mov      r3, r0
0000267c mov      r2, #0xc0
00002680 ldr      r1, [pc, #0x48]
00002684 ldr      r0, [pc, #0x4c]
00002688 bl       #0x1164 ; printf
0000268c b        #0x26c0
00002690 mov      r3, #0x4000
00002694 ldm      r1, {r1, r2}
00002698 bl       #0x1368 ; send
0000269c subs     r4, r0, #0
000026a0 bge      #0x26b8
000026a4 bl       #0x12a8 ; __errno_location
000026a8 mov      r1, r4
000026ac ldr      r2, [r0]
000026b0 ldr      r0, [pc, #0x24]
000026b4 bl       #0x1164 ; printf
000026b8 mov      r0, r4
000026bc b        #0x26c4
000026c0 mvn      r0, #3
000026c4 add      sp, sp, #8
000026c8 pop      {r4, pc}
000026cc andeq    r3, r1, r8, ror r8
000026d0 andeq    r3, r0, sl, asr #5
000026d4 andeq    r3, r0, r8, lsl r3
000026d8 muleq    r0, r0, r3
000026dc andeq    r3, r0, sl, ror r3

FUNCTION LU_NetCtrl_Reply_Svc 0x2098
00002098 push     {r4, r5, lr}
0000209c sub      sp, sp, #0x14
000020a0 mov      r4, r0
000020a4 mov      r2, #0x10
000020a8 mov      r5, r1
000020ac mov      r0, sp
000020b0 mov      r1, #0
000020b4 bl       #0x12b4 ; memset
000020b8 ldr      r1, [r4]
000020bc mov      r0, #0
000020c0 bl       #0x11b8 ; AmbaMem_convert
000020c4 mov      r2, r0
000020c8 str      r0, [sp]
000020cc ldr      r0, [r4, #0xc]
000020d0 ldr      r3, [r4, #4]
000020d4 ldr      r1, [r4, #8]
000020d8 str      r0, [sp, #0xc]
000020dc ldr      r0, [pc, #0x3c]
000020e0 str      r3, [sp, #4]
000020e4 str      r1, [sp, #8]
000020e8 bl       #0x1164 ; printf
000020ec mov      r0, sp
000020f0 bl       #0x1278 ; cmd_server_send_data
000020f4 subs     r4, r0, #0
000020f8 bge      #0x2108
000020fc mov      r1, r4
00002100 ldr      r0, [pc, #0x1c]
00002104 bl       #0x1164 ; printf
00002108 mov      r1, #0
0000210c mov      r0, r4
00002110 str      r1, [r5, #0xc]
00002114 str      r1, [r5, #8]
00002118 add      sp, sp, #0x14
0000211c pop      {r4, r5, pc}
00002120 andeq    r3, r0, r3, asr r1
00002124 andeq    r3, r0, fp, asr r1

FUNCTION netctrl_send_command 0x224c
0000224c push     {r4, r5, r6, lr}
00002250 sub      sp, sp, #0x410
00002254 mov      r4, r0
00002258 mov      r6, r1
0000225c mov      r5, r2
00002260 mov      r1, #0
00002264 mov      r2, #0x410
00002268 mov      r0, sp
0000226c bl       #0x12b4 ; memset
00002270 mov      r1, r4
00002274 mov      r0, sp
00002278 bl       #0x1224 ; strcpy
0000227c mov      r0, r4
00002280 ldr      r4, [pc, #0x68]
00002284 bl       #0x1284 ; strlen
00002288 add      r0, r0, #1
0000228c str      r6, [sp, #0x404]
00002290 ldr      r3, [r4]
00002294 mov      r6, r4
00002298 str      r0, [sp, #0x400]
0000229c str      r5, [sp, #0x408]
000022a0 cmp      r3, #0
000022a4 bne      #0x22d8
000022a8 mov      r2, #1
000022ac mov      r1, #0x10000005
000022b0 mov      r0, r2
000022b4 bl       #0x12e4 ; ambaipc_clnt_create
000022b8 cmp      r0, #0
000022bc mov      r1, r0
000022c0 str      r0, [r4]
000022c4 bne      #0x22d8
000022c8 ldr      r0, [pc, #0x24]
000022cc bl       #0x1164 ; printf
000022d0 mvn      r0, #0
000022d4 b        #0x22e8
000022d8 ldr      r2, [r6]
000022dc mov      r1, #0
000022e0 mov      r0, sp
000022e4 bl       #0x1320 ; RT_NetCtrl_Send_Clnt
000022e8 add      sp, sp, #0x410
000022ec pop      {r4, r5, r6, pc}
000022f0 andeq    r3, r1, r4, ror r8
000022f4 andeq    r3, r0, ip, lsr #3
