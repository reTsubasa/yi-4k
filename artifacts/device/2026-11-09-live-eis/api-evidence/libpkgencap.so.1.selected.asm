
FUNCTION delete_pkg_buffer 0x688
00000688 subs     r3, r0, #0
0000068c beq      #0x6bc
00000690 ldr      r0, [r3]
00000694 cmp      r0, #0
00000698 beq      #0x6bc
0000069c push     {r4, lr}
000006a0 mov      r4, r3
000006a4 bl       #0x51c ; free
000006a8 mov      r0, #0
000006ac ldr      r1, [pc, #0x10]
000006b0 str      r0, [r4]
000006b4 str      r0, [r1]
000006b8 pop      {r4, pc}
000006bc mvn      r0, #0
000006c0 bx       lr
000006c4 strdeq   r0, r1, [r1], -r8

FUNCTION encapHdr 0x6c8
000006c8 push     {r4, r5, r6, r7, lr}
000006cc subs     r4, r0, #0
000006d0 sub      sp, sp, #0x24
000006d4 beq      #0x790
000006d8 ldr      lr, [r4, #0xc]
000006dc cmp      lr, #0
000006e0 beq      #0x790
000006e4 ldr      r3, [pc, #0xb0]
000006e8 mov      ip, sp
000006ec ldr      r5, [pc, #0xac]
000006f0 mov      r7, #2
000006f4 str      r7, [sp, #0x1c]
000006f8 ldm      r3, {r0, r1, r2, r3}
000006fc ldr      r6, [r5]
00000700 stm      sp, {r0, r1, r2, r3}
00000704 mov      r2, #0
00000708 ldr      r0, [r4, #4]
0000070c str      r2, [sp, #0x14]
00000710 ldr      r2, [r4]
00000714 add      r1, r0, lr
00000718 add      lr, sp, #0x20
0000071c str      r1, [sp, #0x10]
00000720 str      r6, [sp, #0x18]
00000724 mov      r3, ip
00000728 add      r2, r2, #8
0000072c ldm      r3!, {r0, r1}
00000730 cmp      r3, lr
00000734 str      r0, [r2, #-8]
00000738 str      r1, [r2, #-4]
0000073c mov      ip, r3
00000740 bne      #0x724
00000744 ldr      r2, [r4, #0xc]
00000748 ands     r1, r2, #3
0000074c beq      #0x778
00000750 ldr      r0, [r4, #4]
00000754 add      lr, r2, #4
00000758 ldr      ip, [r4]
0000075c rsb      r7, r1, lr
00000760 add      r3, r2, r0
00000764 rsb      r2, r1, #4
00000768 add      r0, ip, r3
0000076c mov      r1, #0
00000770 bl       #0x540 ; memset
00000774 mov      r2, r7
00000778 add      r1, r2, #0x20
0000077c mov      r0, #0
00000780 str      r1, [r4, #0x10]
00000784 add      r4, r6, #1
00000788 str      r4, [r5]
0000078c b        #0x794
00000790 mvn      r0, #0
00000794 add      sp, sp, #0x24
00000798 pop      {r4, r5, r6, r7, pc}
0000079c andeq    r0, r0, ip, lsr #15
000007a0 strdeq   r0, r1, [r1], -r8

FUNCTION create_pkg_buffer 0x640
00000640 push     {r4, lr}
00000644 subs     r4, r0, #0
00000648 beq      #0x680
0000064c ldr      r0, [r4, #8]
00000650 cmp      r0, #0
00000654 beq      #0x680
00000658 ands     r2, r0, #3
0000065c mov      r1, #0x20
00000660 addne    r3, r0, #4
00000664 str      r1, [r4, #4]
00000668 rsbne    r0, r2, r3
0000066c add      r0, r0, r1
00000670 bl       #0x528 ; malloc
00000674 str      r0, [r4]
00000678 mov      r0, #0
0000067c pop      {r4, pc}
00000680 mvn      r0, #0
00000684 pop      {r4, pc}
