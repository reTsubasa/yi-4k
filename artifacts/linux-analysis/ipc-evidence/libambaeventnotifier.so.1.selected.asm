
FUNCTION AmbaEventNotify_Init 0xb1c
00000b1c push     {r4, r5, r6, r7, lr}
00000b20 sub      sp, sp, #0x1c
00000b24 ldr      r6, [pc, #0xdc]
00000b28 ldr      r5, [r6]
00000b2c cmp      r5, #0
00000b30 bne      #0xbf8
00000b34 mvn      r7, #0
00000b38 mov      r2, r5
00000b3c mov      r1, #1
00000b40 mov      r0, #2
00000b44 str      r7, [r6, #4]
00000b48 bl       #0x9e0 ; socket
00000b4c cmp      r0, r7
00000b50 mov      r4, r0
00000b54 bne      #0xb6c
00000b58 ldr      ip, [pc, #0xac]
00000b5c ldr      r0, [pc, #0xac]
00000b60 ldr      r1, [ip]
00000b64 bl       #0x9f8 ; fputs
00000b68 b        #0xbe0
00000b6c ldr      r0, [pc, #0xa0]
00000b70 bl       #0x9ec ; inet_addr
00000b74 str      r0, [sp, #0xc]
00000b78 mov      r3, #2
00000b7c ldr      r0, [pc, #0x94]
00000b80 mov      r2, #0x10
00000b84 add      r1, sp, #8
00000b88 strh     r3, [sp, #8]
00000b8c strh     r0, [sp, #0xa]
00000b90 mov      r0, r4
00000b94 bl       #0xa1c ; connect
00000b98 cmp      r0, #0
00000b9c bge      #0xbb8
00000ba0 ldr      r0, [pc, #0x74]
00000ba4 bl       #0x980 ; perror
00000ba8 mov      r0, r4
00000bac mov      r4, r7
00000bb0 bl       #0xa10 ; close
00000bb4 b        #0xbe0
00000bb8 add      r2, sp, #0x18
00000bbc mov      r1, #0x10
00000bc0 str      r1, [r2, #-0x14]!
00000bc4 mov      r0, r4
00000bc8 add      r1, sp, #8
00000bcc bl       #0x9d4 ; getsockname
00000bd0 mov      r2, #1
00000bd4 str      r4, [r6, #4]
00000bd8 str      r2, [r6]
00000bdc b        #0xbf8
00000be0 ldr      lr, [pc, #0x24]
00000be4 ldr      r2, [pc, #0x34]
00000be8 ldr      r1, [pc, #0x34]
00000bec ldr      r0, [lr]
00000bf0 bl       #0x9a4 ; fprintf
00000bf4 b        #0xbfc
00000bf8 mov      r4, #0
00000bfc mov      r0, r4
00000c00 add      sp, sp, #0x1c
00000c04 pop      {r4, r5, r6, r7, pc}
00000c08 andeq    r1, r1, r4, asr #4
00000c0c andeq    r0, r0, r0
00000c10 andeq    r0, r0, pc, lsr #31
00000c14 andeq    r0, r0, r8, asr #31
00000c18 .byte    0x26, 0xa0, 0xff, 0xff
00000c1c ldrdeq   r0, r1, [r0], -r2
00000c20 andeq    r0, r0, r4, asr #30
00000c24 andeq    r0, r0, r8, ror #31

FUNCTION AmbaEventNotify_Release 0xc28
00000c28 push     {r4, r5, r6, lr}
00000c2c ldr      r4, [pc, #0x64]
00000c30 ldr      r0, [r4]
00000c34 cmp      r0, #0
00000c38 popeq    {r4, r5, r6, pc}
00000c3c ldr      r0, [r4, #4]
00000c40 mov      r2, #1
00000c44 ldr      r3, [pc, #0x50]
00000c48 cmp      r0, #0
00000c4c str      r2, [r3]
00000c50 mov      r5, r3
00000c54 ble      #0xc70
00000c58 mov      r1, #2
00000c5c bl       #0x9bc ; shutdown
00000c60 ldr      r0, [r4, #4]
00000c64 bl       #0xa10 ; close
00000c68 mvn      r0, #0
00000c6c str      r0, [r4, #4]
00000c70 ldr      r0, [r5, #4]
00000c74 cmp      r0, #0
00000c78 beq      #0xc8c
00000c7c bl       #0x974 ; ambaipc_clnt_destroy
00000c80 cmp      r0, #0
00000c84 ldreq    r1, [pc, #0x10]
00000c88 streq    r0, [r1, #4]
00000c8c mov      ip, #0
00000c90 str      ip, [r4]
00000c94 pop      {r4, r5, r6, pc}
00000c98 andeq    r1, r1, r4, asr #4
00000c9c andeq    r1, r1, r8, asr r2

FUNCTION AmbaEventNotify_Send 0xca0
00000ca0 cmp      r2, #0x200
00000ca4 push     {r4, r5, r6, r7, r8, lr}
00000ca8 mov      r4, r2
00000cac sub      sp, sp, #0x220
00000cb0 bls      #0xcd8
00000cb4 ldr      r4, [pc, #0xe0]
00000cb8 mov      r1, #0x200
00000cbc str      r1, [sp]
00000cc0 mov      r3, r2
00000cc4 ldr      r1, [pc, #0xd4]
00000cc8 ldr      r2, [pc, #0xd4]
00000ccc ldr      r0, [r4]
00000cd0 bl       #0x9a4 ; fprintf
00000cd4 b        #0xd90
00000cd8 ldr      r5, [pc, #0xc8]
00000cdc mov      r8, r0
00000ce0 mov      r6, r1
00000ce4 ldr      r3, [r5, #4]
00000ce8 mov      r7, r5
00000cec cmp      r3, #0
00000cf0 bne      #0xd28
00000cf4 mov      r2, #1
00000cf8 mov      r1, #0x10000009
00000cfc mov      r0, r2
00000d00 bl       #0x9b0 ; ambaipc_clnt_create
00000d04 cmp      r0, #0
00000d08 str      r0, [r5, #4]
00000d0c bne      #0xd28
00000d10 ldr      lr, [pc, #0x84]
00000d14 ldr      r2, [pc, #0x88]
00000d18 ldr      r1, [pc, #0x8c]
00000d1c ldr      r0, [lr]
00000d20 bl       #0x9a4 ; fprintf
00000d24 b        #0xd90
00000d28 cmp      r4, #0
00000d2c str      r8, [sp, #0x18]
00000d30 str      r4, [sp, #0x1c]
00000d34 beq      #0xd48
00000d38 mov      r2, r4
00000d3c mov      r1, r6
00000d40 add      r0, sp, #0x20
00000d44 bl       #0x968 ; memcpy
00000d48 mov      r2, #4
00000d4c mov      r3, #0
00000d50 add      r0, sp, #0x14
00000d54 stmib    sp, {r2, r3}
00000d58 str      r0, [sp]
00000d5c mov      r3, #0x208
00000d60 add      r2, sp, #0x18
00000d64 mov      r1, #1
00000d68 ldr      r0, [r7, #4]
00000d6c bl       #0x9c8 ; ambaipc_clnt_call
00000d70 subs     r3, r0, #0
00000d74 moveq    r0, r4
00000d78 beq      #0xd94
00000d7c ldr      ip, [pc, #0x18]
00000d80 ldr      r2, [pc, #0x1c]
00000d84 ldr      r1, [pc, #0x24]
00000d88 ldr      r0, [ip]
00000d8c bl       #0x9a4 ; fprintf
00000d90 mvn      r0, #0
00000d94 add      sp, sp, #0x220
00000d98 pop      {r4, r5, r6, r7, r8, pc}
00000d9c andeq    r0, r0, r0
00000da0 strdeq   r0, r1, [r0], -sp
00000da4 andeq    r0, r0, sb, asr pc
00000da8 andeq    r1, r1, r8, asr r2
00000dac andeq    r1, r0, sp, lsl r0
00000db0 andeq    r1, r0, sb, lsr r0
