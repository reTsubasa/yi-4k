
FUNCTION nl_send_pkt 0x2b24
00002b24 push     {r4, r5, r6, lr}
00002b28 mov      r5, r1
00002b2c add      r4, r2, #0x5c
00002b30 mov      r6, r0
00002b34 bl       #0x10fc ; read_timer
00002b38 mov      r1, r5
00002b3c str      r0, [r5, #0x34]
00002b40 mov      r2, r4
00002b44 str      r4, [r1, #-0x10]!
00002b48 mov      r0, r6
00002b4c mov      r3, #0
00002b50 pop      {r4, r5, r6, lr}
00002b54 b        #0x1180 ; send

FUNCTION nl_recv_pkt 0x2b58
00002b58 cmn      r3, #1
00002b5c push     {r4, r5, r6, r7, r8, sb, lr}
00002b60 sub      r7, r1, #0x10
00002b64 sub      sp, sp, #0x14
00002b68 add      r8, r2, #0x5c
00002b6c mov      r6, r0
00002b70 beq      #0x2bc8
00002b74 lsl      lr, r3, #7
00002b78 movw     r4, #0xde83
00002b7c movt     r4, #0x431b
00002b80 sub      r1, lr, r3, lsl #2
00002b84 movw     sb, #0x4240
00002b88 movt     sb, #0xf
00002b8c add      ip, r1, r3
00002b90 mov      r3, #8
00002b94 lsl      ip, ip, #3
00002b98 str      r3, [sp]
00002b9c mov      r2, #0x14
00002ba0 umull    r4, r5, ip, r4
00002ba4 add      r3, sp, r3
00002ba8 mov      r1, #1
00002bac lsr      r5, r5, #0x12
00002bb0 mls      lr, sb, r5, ip
00002bb4 str      r5, [sp, #8]
00002bb8 str      lr, [sp, #0xc]
00002bbc bl       #0xf7c ; setsockopt
00002bc0 cmp      r0, #0
00002bc4 blt      #0x2bf4
00002bc8 mov      r1, r7
00002bcc mov      r2, r8
00002bd0 mov      r0, r6
00002bd4 mov      r3, #0
00002bd8 bl       #0x1168 ; recv
00002bdc subs     r7, r0, #0
00002be0 subgt    r7, r7, #0x5c
00002be4 ble      #0x2c04
00002be8 mov      r0, r7
00002bec add      sp, sp, #0x14
00002bf0 pop      {r4, r5, r6, r7, r8, sb, pc}
00002bf4 ldr      r0, [pc, #0x20]
00002bf8 add      r0, pc, r0
00002bfc bl       #0x103c ; puts
00002c00 b        #0x2bc8
00002c04 ldr      r2, [pc, #0x14]
00002c08 add      r0, pc, r2
00002c0c bl       #0x103c ; puts
00002c10 mov      r0, r7
00002c14 add      sp, sp, #0x14
00002c18 pop      {r4, r5, r6, r7, r8, sb, pc}
00002c1c andeq    r0, r0, r8, lsr #14
00002c20 andeq    r0, r0, ip, lsr #14

FUNCTION nl_open_socket 0x2a54
00002a54 mov      ip, #0x10
00002a58 push     {r4, r5, r6, r7, lr}
00002a5c mov      r3, #0
00002a60 sub      sp, sp, #0x14
00002a64 mov      lr, #0xc
00002a68 mov      r6, r0
00002a6c mov      r2, #0x19
00002a70 mov      r0, ip
00002a74 mov      r1, #3
00002a78 str      r3, [sp, #4]
00002a7c str      r3, [sp, #8]
00002a80 add      r5, sp, #4
00002a84 str      r3, [sp, #0xc]
00002a88 strh     ip, [sp, #4]
00002a8c str      lr, [sp]
00002a90 bl       #0x1144 ; socket
00002a94 subs     r4, r0, #0
00002a98 ble      #0x2ae0
00002a9c ldr      r2, [sp]
00002aa0 mov      r1, r5
00002aa4 bl       #0x10cc ; bind
00002aa8 subs     r7, r0, #0
00002aac bne      #0x2af8
00002ab0 cmp      r6, #0
00002ab4 moveq    r0, r4
00002ab8 beq      #0x2ad8
00002abc mov      r1, r5
00002ac0 mov      r2, sp
00002ac4 mov      r0, r4
00002ac8 bl       #0x112c ; getsockname
00002acc ldr      r1, [sp, #8]
00002ad0 mov      r0, r4
00002ad4 str      r1, [r6]
00002ad8 add      sp, sp, #0x14
00002adc pop      {r4, r5, r6, r7, pc}
00002ae0 ldr      r2, [pc, #0x30]
00002ae4 add      r0, pc, r2
00002ae8 bl       #0x103c ; puts
00002aec mov      r0, r4
00002af0 add      sp, sp, #0x14
00002af4 pop      {r4, r5, r6, r7, pc}
00002af8 ldr      r0, [pc, #0x1c]
00002afc add      r0, pc, r0
00002b00 bl       #0x103c ; puts
00002b04 mov      r0, r4
00002b08 bl       #0x1174 ; close
00002b0c mov      r0, r7
00002b10 add      sp, sp, #0x14
00002b14 pop      {r4, r5, r6, r7, pc}
00002b18 andeq    r0, r0, ip, lsl #16
00002b1c andeq    r0, r0, ip, lsl #16

FUNCTION ambaipc_clnt_create 0x2600
00002600 push     {r4, r5, r6, r7, r8, sb, sl, lr}
00002604 mov      r8, r0
00002608 sub      sp, sp, #0x30
0000260c mov      r0, #0x80
00002610 mov      r7, r1
00002614 mov      sb, r2
00002618 ldr      r6, [pc, #0x144]
0000261c bl       #0x1048 ; malloc
00002620 subs     r4, r0, #0
00002624 add      r6, pc, r6
00002628 moveq    r0, r4
0000262c beq      #0x273c
00002630 add      r0, sp, #8
00002634 add      r5, sp, #4
00002638 bl       #0x10f0 ; nl_open_socket
0000263c ldr      r3, [pc, #0x124]
00002640 str      r0, [r4]
00002644 ldr      sl, [r6, r3]
00002648 ldr      r0, [sl]
0000264c bl       #0xf34 ; nl_alloc_pkt
00002650 movw     r1, #0xface
00002654 str      r0, [r4, #0x58]
00002658 movt     r1, #0xbabe
0000265c mov      r0, r5
00002660 str      r1, [r4, #8]
00002664 bl       #0x1120 ; pthread_mutexattr_init
00002668 mov      r1, #1
0000266c mov      r0, r5
00002670 bl       #0xf64 ; pthread_mutexattr_settype
00002674 mov      r1, r5
00002678 add      r0, r4, #0x60
0000267c bl       #0xff4 ; pthread_mutex_init
00002680 ldr      r2, [sp, #8]
00002684 mov      ip, #0
00002688 strb     ip, [r4, #0xc]
0000268c add      r0, r4, #0x18
00002690 strb     r8, [r4, #0xd]
00002694 str      r2, [r4, #0x14]
00002698 str      r7, [r4, #0x4c]
0000269c str      sb, [r4, #0x50]
000026a0 bl       #0x10f0 ; nl_open_socket
000026a4 str      r0, [r4, #4]
000026a8 ldr      r0, [sl]
000026ac bl       #0xf34 ; nl_alloc_pkt
000026b0 str      r0, [r4, #0x5c]
000026b4 mov      r0, r4
000026b8 bl       #0x2414
000026bc subs     r8, r0, #0
000026c0 beq      #0x2744
000026c4 ldr      r0, [pc, #0xa0]
000026c8 mov      r1, r7
000026cc add      r0, pc, r0
000026d0 bl       #0xf94 ; printf
000026d4 ldr      sl, [pc, #0x94]
000026d8 add      sb, sp, #0xc
000026dc mov      r0, sb
000026e0 ldr      r5, [pc, #0x8c]
000026e4 bl       #0x10b4 ; pthread_attr_init
000026e8 bl       #0x10a8 ; getpagesize
000026ec ldr      r6, [r6, sl]
000026f0 mov      r3, r0
000026f4 ldr      r1, [pc, #0x7c]
000026f8 mov      r2, #0x20000
000026fc mov      r7, r0
00002700 ldr      r0, [r6]
00002704 add      r1, pc, r1
00002708 bl       #0x109c ; fprintf
0000270c mov      r1, #0x20000
00002710 mov      r0, sb
00002714 bl       #0xf88 ; pthread_attr_setstacksize
00002718 mov      r1, r7
0000271c mov      r0, sb
00002720 bl       #0xf40 ; pthread_attr_setguardsize
00002724 mov      r3, r4
00002728 mov      r1, sb
0000272c add      r2, pc, r5
00002730 add      r0, r4, #0x7c
00002734 bl       #0x1114 ; pthread_create
00002738 mov      r0, r4
0000273c add      sp, sp, #0x30
00002740 pop      {r4, r5, r6, r7, r8, sb, sl, pc}
00002744 mov      r0, r4
00002748 bl       #0x252c
0000274c cmp      r0, #0xa
00002750 bne      #0x26d4
00002754 mov      r0, r4
00002758 bl       #0xfe8 ; ambaipc_clnt_destroy
0000275c mov      r0, r8
00002760 b        #0x273c
00002764 andeq    r0, r1, r0, ror pc
00002768 strdeq   r0, r1, [r0], -r0
0000276c strdeq   r0, r1, [r0], -ip
00002770 andeq    r0, r0, r8, ror #1
00002774 .byte    0x24, 0xfc, 0xff, 0xff
00002778 andeq    r0, r0, ip, lsl #22

FUNCTION ambaipc_clnt_call 0x277c
0000277c push     {r4, r5, r6, r7, r8, sb, sl, lr}
00002780 subs     r4, r0, #0
00002784 ldr      r6, [pc, #0x238]
00002788 add      r6, pc, r6
0000278c beq      #0x27d0
00002790 add      r5, r4, #0x60
00002794 mov      r8, r1
00002798 mov      r0, r5
0000279c mov      sb, r2
000027a0 mov      r7, r3
000027a4 bl       #0xfc4 ; pthread_mutex_lock
000027a8 ldr      ip, [r4, #8]
000027ac movw     r0, #0xface
000027b0 movt     r0, #0xbabe
000027b4 cmp      ip, r0
000027b8 mvnne    r6, #2
000027bc beq      #0x27f4
000027c0 mov      r0, r5
000027c4 bl       #0xf1c ; pthread_mutex_unlock
000027c8 mov      r0, r6
000027cc pop      {r4, r5, r6, r7, r8, sb, sl, pc}
000027d0 ldr      r0, [pc, #0x1f0]
000027d4 mvn      r6, #4
000027d8 ldr      ip, [pc, #0x1ec]
000027dc add      r3, pc, r0
000027e0 add      r1, r3, #0x10
000027e4 add      r0, pc, ip
000027e8 bl       #0xf94 ; printf
000027ec mov      r0, r6
000027f0 pop      {r4, r5, r6, r7, r8, sb, sl, pc}
000027f4 ldr      r3, [r4, #0x1c]
000027f8 cmp      r3, #0
000027fc bne      #0x2840
00002800 mov      r0, r4
00002804 bl       #0x2414
00002808 cmp      r0, #0
0000280c beq      #0x295c
00002810 cmp      r0, #4
00002814 beq      #0x29a4
00002818 cmp      r0, #1
0000281c beq      #0x2938
00002820 ldr      r1, [pc, #0x1a8]
00002824 mvn      r6, #2
00002828 ldr      lr, [pc, #0x1a4]
0000282c add      r2, pc, r1
00002830 add      r0, pc, lr
00002834 add      r1, r2, #0x10
00002838 bl       #0xf94 ; printf
0000283c b        #0x27c0
00002840 mov      r2, #0x4c
00002844 add      r1, r4, #0xc
00002848 ldr      r0, [r4, #0x58]
0000284c sub      sl, r8, #0xc0000001
00002850 bl       #0xfd0 ; memcpy
00002854 ldr      ip, [r4, #0x58]
00002858 mov      r1, sb
0000285c mov      r2, r7
00002860 str      r8, [ip, #0x48]
00002864 ldr      r0, [r4, #0x78]
00002868 ldr      r3, [r4, #0x58]
0000286c ldr      ip, [r0, sl, lsl #2]
00002870 add      r0, r3, #0x4c
00002874 str      ip, [r3, #0x18]
00002878 bl       #0xfd0 ; memcpy
0000287c ldr      r1, [r4, #0x58]
00002880 mov      r2, r7
00002884 ldr      r0, [r4]
00002888 bl       #0xfac ; nl_send_pkt
0000288c ldr      r1, [sp, #0x28]
00002890 cmp      r1, #0
00002894 beq      #0x2930
00002898 ldr      lr, [r4, #0x78]
0000289c ldr      r2, [lr, sl, lsl #2]
000028a0 cmp      r2, #1
000028a4 beq      #0x2930
000028a8 ldr      r7, [pc, #0x128]
000028ac ldr      r3, [sp, #0x28]
000028b0 ldr      r1, [r4, #0x58]
000028b4 ldr      r8, [r6, r7]
000028b8 ldr      r0, [r4]
000028bc ldr      r2, [r8]
000028c0 bl       #0x1084 ; nl_recv_pkt
000028c4 ldr      r7, [r4, #0x58]
000028c8 subs     r8, r0, #0
000028cc ldr      r6, [r7, #0x40]
000028d0 blt      #0x2974
000028d4 cmp      r6, #4
000028d8 beq      #0x299c
000028dc bl       #0x10fc ; read_timer
000028e0 ldr      r3, [r4, #0x78]
000028e4 str      r0, [r7, #0x30]
000028e8 ldr      r0, [r4, #0x58]
000028ec ldr      r1, [r3, sl, lsl #2]
000028f0 bl       #0xf58 ; rpc_record_stats
000028f4 cmp      r6, #0
000028f8 rsbne    r6, r6, #0
000028fc bne      #0x27c0
00002900 ldr      ip, [sp, #0x20]
00002904 cmp      ip, #0
00002908 beq      #0x2930
0000290c ldr      lr, [sp, #0x24]
00002910 ldr      r1, [r4, #0x58]
00002914 ldr      r0, [sp, #0x20]
00002918 cmp      r8, lr
0000291c movlt    r2, r8
00002920 movge    r2, lr
00002924 add      r1, r1, #0x4c
00002928 bl       #0xfd0 ; memcpy
0000292c b        #0x27c0
00002930 mov      r6, #0
00002934 b        #0x27c0
00002938 ldr      r6, [pc, #0x9c]
0000293c ldr      r0, [pc, #0x9c]
00002940 ldr      r2, [r4, #0x4c]
00002944 add      ip, pc, r6
00002948 mvn      r6, #0
0000294c add      r1, ip, #0x10
00002950 add      r0, pc, r0
00002954 bl       #0xf94 ; printf
00002958 b        #0x27c0
0000295c mov      r0, r4
00002960 bl       #0x252c
00002964 cmp      r0, #0xa
00002968 bne      #0x2840
0000296c mvn      r6, #9
00002970 b        #0x27c0
00002974 bl       #0x10c0 ; __errno_location
00002978 mov      sb, r0
0000297c ldr      r0, [r0]
00002980 cmp      r0, #0xb
00002984 bne      #0x28d4
00002988 ldr      r6, [pc, #0x54]
0000298c add      r0, pc, r6
00002990 bl       #0x103c ; puts
00002994 mov      r2, #0
00002998 str      r2, [sb]
0000299c mvn      r6, #3
000029a0 b        #0x27c0
000029a4 ldr      r3, [pc, #0x3c]
000029a8 mvn      r6, #3
000029ac ldr      r2, [pc, #0x38]
000029b0 add      r1, pc, r3
000029b4 add      r0, pc, r2
000029b8 add      r1, r1, #0x10
000029bc bl       #0xf94 ; printf
000029c0 b        #0x27c0
000029c4 andeq    r0, r1, ip, lsl #28
000029c8 andeq    r0, r0, r0, lsr sb
000029cc andeq    r0, r0, r8, asr sl
000029d0 andeq    r0, r0, r0, ror #17
000029d4 andeq    r0, r0, r4, ror sl
000029d8 strdeq   r0, r1, [r0], -r0
000029dc andeq    r0, r0, r8, asr #15
000029e0 andeq    r0, r0, ip, lsr #18
000029e4 andeq    r0, r0, r4, lsr sb
000029e8 andeq    r0, r0, ip, asr r7
000029ec andeq    r0, r0, r4, lsr #17
