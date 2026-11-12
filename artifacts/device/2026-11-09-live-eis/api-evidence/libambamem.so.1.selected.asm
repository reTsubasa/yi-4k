
FUNCTION AmbaMem_convert 0xb7c
00000b7c cmp      r0, #0
00000b80 beq      #0xbac
00000b84 cmp      r0, #1
00000b88 ldreq    r3, [pc, #0x34]
00000b8c beq      #0xbb0
00000b90 mov      r2, r0
00000b94 push     {r4, lr}
00000b98 ldr      r1, [pc, #0x28]
00000b9c ldr      r0, [pc, #0x28]
00000ba0 bl       #0x744 ; printf
00000ba4 mov      r0, #0
00000ba8 pop      {r4, pc}
00000bac ldr      r3, [pc, #0x1c]
00000bb0 ldr      r0, [r3]
00000bb4 cmp      r0, #0
00000bb8 ldrne    r0, [r3, #0xc]
00000bbc addne    r0, r1, r0
00000bc0 bx       lr
00000bc4 andeq    r0, r1, ip, lsr #30
00000bc8 andeq    r0, r0, r8, ror ip
00000bcc strdeq   r0, r1, [r0], -pc
00000bd0 andeq    r0, r1, ip, lsl pc

FUNCTION AmbaMem_init 0xbd4
00000bd4 push     {r4, r5, r6, lr}
00000bd8 ldr      r4, [pc, #0x38]
00000bdc ldr      r5, [r4, #0x20]
00000be0 cmp      r5, #0
00000be4 bne      #0xc10
00000be8 mov      r2, #0x10
00000bec mov      r1, r5
00000bf0 mov      r0, r4
00000bf4 bl       #0x7b0 ; memset
00000bf8 mov      r2, #0x10
00000bfc mov      r1, r5
00000c00 add      r0, r4, r2
00000c04 bl       #0x7b0 ; memset
00000c08 mov      r3, #1
00000c0c str      r3, [r4, #0x20]
00000c10 mov      r0, #0
00000c14 pop      {r4, r5, r6, pc}
00000c18 andeq    r0, r1, ip, lsl pc

FUNCTION AmbaMem_release 0xc1c
00000c1c push     {r4, lr}
00000c20 ldr      r4, [pc, #0x28]
00000c24 ldr      r3, [r4, #0x20]
00000c28 cmp      r3, #0
00000c2c beq      #0xc48
00000c30 mov      r0, #0
00000c34 bl       #0x768 ; AmbaMem_munmap
00000c38 mov      r0, #1
00000c3c bl       #0x768 ; AmbaMem_munmap
00000c40 mov      r0, #0
00000c44 str      r0, [r4, #0x20]
00000c48 mov      r0, #0
00000c4c pop      {r4, pc}
00000c50 andeq    r0, r1, ip, lsl pc

FUNCTION AmbaMem_munmap 0xab4
00000ab4 subs     r2, r0, #0
00000ab8 push     {r4, r5, r6, lr}
00000abc beq      #0xae0
00000ac0 cmp      r2, #1
00000ac4 ldreq    r5, [pc, #0x94]
00000ac8 beq      #0xae4
00000acc ldr      r1, [pc, #0x90]
00000ad0 ldr      r0, [pc, #0x90]
00000ad4 bl       #0x744 ; printf
00000ad8 mvn      r0, #0
00000adc pop      {r4, r5, r6, pc}
00000ae0 ldr      r5, [pc, #0x84]
00000ae4 ldr      r4, [r5]
00000ae8 cmp      r4, #0
00000aec bne      #0xb00
00000af0 ldr      r1, [pc, #0x6c]
00000af4 ldr      r0, [pc, #0x74]
00000af8 bl       #0x744 ; printf
00000afc b        #0xb58
00000b00 ldr      r0, [r5, #0xc]
00000b04 ldr      r1, [r5, #8]
00000b08 add      r0, r4, r0
00000b0c bl       #0x7bc ; munmap
00000b10 subs     r4, r0, #0
00000b14 bge      #0xb48
00000b18 bl       #0x7a4 ; __errno_location
00000b1c ldr      r3, [pc, #0x50]
00000b20 ldr      r5, [r0]
00000b24 ldr      r6, [r3]
00000b28 mov      r0, r5
00000b2c bl       #0x780 ; strerror
00000b30 mov      r2, r5
00000b34 mov      r3, r0
00000b38 ldr      r1, [pc, #0x38]
00000b3c mov      r0, r6
00000b40 bl       #0x798 ; fprintf
00000b44 b        #0xb58
00000b48 mov      r2, #0x10
00000b4c mov      r1, #0
00000b50 mov      r0, r5
00000b54 bl       #0x7b0 ; memset
00000b58 mov      r0, r4
00000b5c pop      {r4, r5, r6, pc}
00000b60 andeq    r0, r1, ip, lsr #30
00000b64 andeq    r0, r0, sb, ror #24
00000b68 strdeq   r0, r1, [r0], -pc
00000b6c andeq    r0, r1, ip, lsl pc
00000b70 andeq    r0, r0, sb, ror sp
00000b74 andeq    r0, r0, r0
00000b78 muleq    r0, r5, sp

FUNCTION AmbaMem_mmap 0x8c8
000008c8 push     {r4, r5, r6, r7, lr}
000008cc subs     r5, r0, #0
000008d0 sub      sp, sp, #0x24
000008d4 mov      r7, r1
000008d8 bne      #0x930
000008dc ldr      r1, [pc, #0x19c]
000008e0 ldr      r0, [pc, #0x19c]
000008e4 bl       #0x774 ; open64
000008e8 subs     r6, r0, #0
000008ec ldrle    r2, [pc, #0x190]
000008f0 ble      #0x950
000008f4 add      r2, sp, #0x14
000008f8 ldr      r1, [pc, #0x188]
000008fc bl       #0x75c ; ioctl
00000900 subs     r4, r0, #0
00000904 movne    r2, r4
00000908 ldrne    r1, [pc, #0x17c]
0000090c bne      #0x984
00000910 ldr      r4, [pc, #0x178]
00000914 ldr      r2, [sp, #0x14]
00000918 ldr      lr, [sp, #0x18]
0000091c ldr      r3, [sp, #0x1c]
00000920 str      r2, [r4]
00000924 str      lr, [r4, #4]
00000928 str      r3, [r4, #8]
0000092c b        #0x9cc
00000930 cmp      r5, #1
00000934 bne      #0x9b8
00000938 ldr      r1, [pc, #0x140]
0000093c ldr      r0, [pc, #0x150]
00000940 bl       #0x774 ; open64
00000944 subs     r6, r0, #0
00000948 bgt      #0x968
0000094c ldr      r2, [pc, #0x140]
00000950 ldr      r5, [pc, #0x140]
00000954 ldr      r1, [pc, #0x140]
00000958 ldr      r0, [r5]
0000095c bl       #0x798 ; fprintf
00000960 mvn      r0, #0
00000964 b        #0xa78
00000968 add      r2, sp, #0x14
0000096c ldr      r1, [pc, #0x114]
00000970 bl       #0x75c ; ioctl
00000974 subs     r4, r0, #0
00000978 beq      #0x994
0000097c ldr      r1, [pc, #0x11c]
00000980 mov      r2, r4
00000984 ldr      ip, [pc, #0x10c]
00000988 ldr      r0, [ip]
0000098c bl       #0x798 ; fprintf
00000990 b        #0xa6c
00000994 ldr      r4, [pc, #0xf4]
00000998 ldr      r3, [sp, #0x14]
0000099c ldr      r0, [sp, #0x18]
000009a0 ldr      r1, [sp, #0x1c]
000009a4 add      r4, r4, #0x10
000009a8 str      r3, [r4]
000009ac str      r0, [r4, #4]
000009b0 str      r1, [r4, #8]
000009b4 b        #0x9cc
000009b8 mov      r2, r5
000009bc ldr      r1, [pc, #0xe0]
000009c0 ldr      r0, [pc, #0xe0]
000009c4 bl       #0x744 ; printf
000009c8 b        #0x960
000009cc vmov.i32 d16, #0
000009d0 str      r6, [sp]
000009d4 mov      r3, #1
000009d8 mov      r2, #3
000009dc mov      r0, #0
000009e0 vstr     d16, [sp, #8]
000009e4 ldr      r1, [r4, #8]
000009e8 bl       #0x750 ; mmap64
000009ec cmn      r0, #1
000009f0 bne      #0xa28
000009f4 ldr      r7, [pc, #0x9c]
000009f8 bl       #0x7a4 ; __errno_location
000009fc ldr      r4, [r0]
00000a00 ldr      r7, [r7]
00000a04 mov      r0, r4
00000a08 bl       #0x780 ; strerror
00000a0c mov      r3, r4
00000a10 stm      sp, {r0, r5}
00000a14 ldr      r2, [pc, #0x88]
00000a18 mov      r0, r7
00000a1c ldr      r1, [pc, #0x88]
00000a20 bl       #0x798 ; fprintf
00000a24 b        #0xa68
00000a28 ldr      r3, [r4]
00000a2c ldr      r2, [r4, #8]
00000a30 rsb      r1, r3, r0
00000a34 str      r1, [r4, #0xc]
00000a38 stmib    sp, {r0, r2}
00000a3c mov      r2, r5
00000a40 ldr      r0, [r4, #4]
00000a44 ldr      r1, [pc, #0x58]
00000a48 str      r0, [sp]
00000a4c ldr      r0, [pc, #0x5c]
00000a50 bl       #0x744 ; printf
00000a54 cmp      r7, #0
00000a58 moveq    r4, r7
00000a5c beq      #0xa6c
00000a60 ldr      r4, [r4, #0xc]
00000a64 str      r4, [r7]
00000a68 mov      r4, #0
00000a6c mov      r0, r6
00000a70 bl       #0x7c8 ; close
00000a74 mov      r0, r4
00000a78 add      sp, sp, #0x24
00000a7c pop      {r4, r5, r6, r7, pc}
00000a80 andseq   r1, r0, r2
00000a84 andeq    r0, r0, r8, lsl #25
00000a88 andhi    sb, ip, r1, lsl #18
00000a8c andeq    r0, r0, sp, lsr #25
00000a90 andeq    r0, r1, ip, lsl pc
00000a94 andeq    r0, r0, lr, asr #25
00000a98 andeq    r0, r0, r0
00000a9c muleq    r0, sl, ip
00000aa0 ldrdeq   r0, r1, [r0], -pc
00000aa4 andeq    r0, r0, ip, asr ip
00000aa8 strdeq   r0, r1, [r0], -pc
00000aac andeq    r0, r0, r8, lsl sp
00000ab0 andeq    r0, r0, ip, lsr sp
