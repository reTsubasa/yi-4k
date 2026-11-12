a0210894 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0210898 0040a0e3 mov r4, #0
a021089c 45df4de2 sub sp, sp, #0x114
a02108a0 845c07e3 movw r5, #0x7c84
a02108a4 606504e3 movw r6, #0x4560
a02108a8 b820a0e3 mov r2, #0xb8
a02108ac 0410a0e1 mov r1, r4
a02108b0 58008de2 add r0, sp, #0x58
a02108b4 3c514ae3 movt r5, #0xa13c
a02108b8 6d604ae3 movt r6, #0xa06d
a02108bc 20408de5 str r4, [sp, #0x20]
a02108c0 24408de5 str r4, [sp, #0x24]
a02108c4 28408de5 str r4, [sp, #0x28]
a02108c8 47a10bfa blx #0xa04f8dec
a02108cc 002095e5 ldr r2, [r5]
a02108d0 003096e5 ldr r3, [r6]
a02108d4 030052e1 cmp r2, r3
a02108d8 1300000a beq #0xa021092c
a02108dc 5affffeb bl #0xa021064c
a02108e0 203d07e3 movw r3, #0x7d20
a02108e4 007095e5 ldr r7, [r5]
a02108e8 3c314ae3 movt r3, #0xa13c
a02108ec 003093e5 ldr r3, [r3]
a02108f0 007086e5 str r7, [r6]
a02108f4 040053e1 cmp r3, r4
a02108f8 0460a011 movne r6, r4
a02108fc 8d00000a beq #0xa0210b38
a0210900 b430d5e1 ldrh r3, [r5, #4]
a0210904 000053e3 cmp r3, #0
a0210908 0400000a beq #0xa0210920
a021090c 0c3d07e3 movw r3, #0x7d0c
a0210910 3c314ae3 movt r3, #0xa13c
a0210914 003093e5 ldr r3, [r3]
a0210918 000053e3 cmp r3, #0
a021091c 0a00000a beq #0xa021094c
a0210920 0000a0e3 mov r0, #0
a0210924 45df8de2 add sp, sp, #0x114
a0210928 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a021092c 203d07e3 movw r3, #0x7d20
a0210930 3c314ae3 movt r3, #0xa13c
a0210934 003093e5 ldr r3, [r3]
a0210938 000053e3 cmp r3, #0
a021093c 8e01000a beq #0xa0210f7c
a0210940 0170a0e3 mov r7, #1
a0210944 0460a0e1 mov r6, r4
a0210948 ecffffea b #0xa0210900
a021094c 8712a0e1 lsl r1, r7, #5
a0210950 083504e3 movw r3, #0x4508
a0210954 6d304ae3 movt r3, #0xa06d
a0210958 071141e0 sub r1, r1, r7, lsl #2
a021095c 000057e3 cmp r7, #0
a0210960 e48302e3 movw r8, #0x23e4
a0210964 012083e0 add r2, r3, r1
a0210968 0150d3e7 ldrb r5, [r3, r1]
a021096c 040092e5 ldr r0, [r2, #4]
a0210970 10308302 addeq r3, r3, #0x10
a0210974 081092e5 ldr r1, [r2, #8]
a0210978 d8308d12 addne r3, sp, #0xd8
a021097c bec0d2e1 ldrh ip, [r2, #0xe]
a0210980 3a814ae3 movt r8, #0xa13a
a0210984 bce0d2e1 ldrh lr, [r2, #0xc]
a0210988 10208212 addne r2, r2, #0x10
a021098c c4008de5 str r0, [sp, #0xc4]
a0210990 3270a0e3 mov r7, #0x32
a0210994 c8108de5 str r1, [sp, #0xc8]
a0210998 07009308 ldmeq r3, {r0, r1, r2}
a021099c 03009218 ldmne r2, {r0, r1}
a02109a0 becccde1 strh ip, [sp, #0xce]
a02109a4 d8c08d02 addeq ip, sp, #0xd8
a02109a8 07008c08 stmeq ip, {r0, r1, r2}
a02109ac 102d07e3 movw r2, #0x7d10
a02109b0 03008318 stmne r3, {r0, r1}
a02109b4 2030a0e3 mov r3, #0x20
a02109b8 341c07e3 movw r1, #0x7c34
a02109bc 00c0a0e3 mov ip, #0
a02109c0 b450cde5 strb r5, [sp, #0xb4]
a02109c4 3c114ae3 movt r1, #0xa13c
a02109c8 bceccde1 strh lr, [sp, #0xcc]
a02109cc 3c214ae3 movt r2, #0xa13c
a02109d0 01e0a0e3 mov lr, #1
a02109d4 000098e5 ldr r0, [r8]
a02109d8 2350a0e3 mov r5, #0x23
a02109dc 00308de5 str r3, [sp]
a02109e0 0a36a0e3 mov r3, #0xa00000
a02109e4 b670cde5 strb r7, [sp, #0xb6]
a02109e8 b850cde5 strb r5, [sp, #0xb8]
a02109ec b7e0cde5 strb lr, [sp, #0xb7]
a02109f0 b9e0cde5 strb lr, [sp, #0xb9]
a02109f4 b5c0cde5 strb ip, [sp, #0xb5]
a02109f8 bcc08de5 str ip, [sp, #0xbc]
a02109fc c0c08de5 str ip, [sp, #0xc0]
a0210a00 742702eb bl #0xa029a7d8
a0210a04 000050e3 cmp r0, #0
a0210a08 3301001a bne #0xa0210edc
a0210a0c 345c07e3 movw r5, #0x7c34
a0210a10 2030a0e3 mov r3, #0x20
a0210a14 3c514ae3 movt r5, #0xa13c
a0210a18 1c1d07e3 movw r1, #0x7d1c
a0210a1c 00e095e5 ldr lr, [r5]
a0210a20 2c2c07e3 movw r2, #0x7c2c
a0210a24 000098e5 ldr r0, [r8]
a0210a28 0ac6a0e3 mov ip, #0xa00000
a0210a2c 00308de5 str r3, [sp]
a0210a30 3c114ae3 movt r1, #0xa13c
a0210a34 3c214ae3 movt r2, #0xa13c
a0210a38 1939a0e3 mov r3, #0x64000
a0210a3c f0e08de5 str lr, [sp, #0xf0]
a0210a40 f4c08de5 str ip, [sp, #0xf4]
a0210a44 632702eb bl #0xa029a7d8
a0210a48 000050e3 cmp r0, #0
a0210a4c 2901001a bne #0xa0210ef8
a0210a50 1c3d07e3 movw r3, #0x7d1c
a0210a54 19c9a0e3 mov ip, #0x64000
a0210a58 3c314ae3 movt r3, #0xa13c
a0210a5c d40f0ee3 movw r0, #0xefd4
a0210a60 00e093e5 ldr lr, [r3]
a0210a64 0a26a0e3 mov r2, #0xa00000
a0210a68 001095e5 ldr r1, [r5]
a0210a6c 58004ae3 movt r0, #0xa058
a0210a70 00c08de5 str ip, [sp]
a0210a74 2657a0e3 mov r5, #0x980000
a0210a78 0e30a0e1 mov r3, lr
a0210a7c f8e08de5 str lr, [sp, #0xf8]
a0210a80 fcc08de5 str ip, [sp, #0xfc]
a0210a84 20b08de2 add fp, sp, #0x20
a0210a88 00518de5 str r5, [sp, #0x100]
a0210a8c 805c07e3 movw r5, #0x7c80
a0210a90 955902eb bl #0xa02a70ec
a0210a94 8ccc07e3 movw ip, #0x7c8c
a0210a98 3c514ae3 movt r5, #0xa13c
a0210a9c 3cc14ae3 movt ip, #0xa13c
a0210aa0 007095e5 ldr r7, [r5]
a0210aa4 00e09ce5 ldr lr, [ip]
a0210aa8 24a08de2 add sl, sp, #0x24
a0210aac 28908de2 add sb, sp, #0x28
a0210ab0 0080a0e3 mov r8, #0
a0210ab4 067087e0 add r7, r7, r6
a0210ab8 00b08de5 str fp, [sp]
a0210abc 04e08ee0 add lr, lr, r4
a0210ac0 04a08de5 str sl, [sp, #4]
a0210ac4 08908de5 str sb, [sp, #8]
a0210ac8 0620a0e1 mov r2, r6
a0210acc 0c808de5 str r8, [sp, #0xc]
a0210ad0 0e10a0e1 mov r1, lr
a0210ad4 0430a0e1 mov r3, r4
a0210ad8 00e08ce5 str lr, [ip]
a0210adc 0700a0e1 mov r0, r7
a0210ae0 0140a0e3 mov r4, #1
a0210ae4 007085e5 str r7, [r5]
a0210ae8 d040cde5 strb r4, [sp, #0xd0]
a0210aec 65fdffeb bl #0xa0210088
a0210af0 643c07e3 movw r3, #0x7c64
a0210af4 24c09de5 ldr ip, [sp, #0x24]
a0210af8 3c314ae3 movt r3, #0xa13c
a0210afc 28209de5 ldr r2, [sp, #0x28]
a0210b00 00e093e5 ldr lr, [r3]
a0210b04 4c3c07e3 movw r3, #0x7c4c
a0210b08 3c314ae3 movt r3, #0xa13c
a0210b0c 0c1d07e3 movw r1, #0x7d0c
a0210b10 3c114ae3 movt r1, #0xa13c
a0210b14 b4008de2 add r0, sp, #0xb4
a0210b18 00e083e5 str lr, [r3]
a0210b1c 04c083e5 str ip, [r3, #4]
a0210b20 082083e5 str r2, [r3, #8]
a0210b24 d4308de5 str r3, [sp, #0xd4]
a0210b28 7f3d09eb bl #0xa046012c
a0210b2c 0000a0e3 mov r0, #0
a0210b30 45df8de2 add sp, sp, #0x114
a0210b34 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0210b38 58008de2 add r0, sp, #0x58
a0210b3c 613d09eb bl #0xa04600c8
a0210b40 8722a0e1 lsl r2, r7, #5
a0210b44 083504e3 movw r3, #0x4508
a0210b48 6d304ae3 movt r3, #0xa06d
a0210b4c 072142e0 sub r2, r2, r7, lsl #2
a0210b50 040057e1 cmp r7, r4
a0210b54 021083e0 add r1, r3, r2
a0210b58 0240d3e7 ldrb r4, [r3, r2]
a0210b5c 040091e5 ldr r0, [r1, #4]
a0210b60 bce0d1e1 ldrh lr, [r1, #0xc]
a0210b64 bec0d1e1 ldrh ip, [r1, #0xe]
a0210b68 082091e5 ldr r2, [r1, #8]
a0210b6c 5840cde5 strb r4, [sp, #0x58]
a0210b70 b0e7cde1 strh lr, [sp, #0x70]
a0210b74 b2c7cde1 strh ip, [sp, #0x72]
a0210b78 68008de5 str r0, [sp, #0x68]
a0210b7c 6c208de5 str r2, [sp, #0x6c]
a0210b80 ce00000a beq #0xa0210ec0
a0210b84 101081e2 add r1, r1, #0x10
a0210b88 182e0ee3 movw r2, #0xee18
a0210b8c 030091e8 ldm r1, {r0, r1}
a0210b90 58204ae3 movt r2, #0xa058
a0210b94 243e0ee3 movw r3, #0xee24
a0210b98 020057e3 cmp r7, #2
a0210b9c 58304ae3 movt r3, #0xa058
a0210ba0 0230a001 moveq r3, r2
a0210ba4 7c208de2 add r2, sp, #0x7c
a0210ba8 030082e8 stm r2, {r0, r1}
a0210bac 2c0e0ee3 movw r0, #0xee2c
a0210bb0 38ac07e3 movw sl, #0x7c38
a0210bb4 0310a0e1 mov r1, r3
a0210bb8 58004ae3 movt r0, #0xa058
a0210bbc 3ca14ae3 movt sl, #0xa13c
a0210bc0 7c9003e3 movw sb, #0x307c
a0210bc4 485902eb bl #0xa02a70ec
a0210bc8 00209ae5 ldr r2, [sl]
a0210bcc 6f904ae3 movt sb, #0xa06f
a0210bd0 400e0ee3 movw r0, #0xee40
a0210bd4 041099e5 ldr r1, [sb, #4]
a0210bd8 58004ae3 movt r0, #0xa058
a0210bdc 68bd0fe3 movw fp, #0xfd68
a0210be0 b020cde5 strb r2, [sp, #0xb0]
a0210be4 0260a0e3 mov r6, #2
a0210be8 7220efe6 uxtb r2, r2
a0210bec 2340a0e3 mov r4, #0x23
a0210bf0 20b04ae3 movt fp, #0xa020
a0210bf4 3c5902eb bl #0xa02a70ec
a0210bf8 3220a0e3 mov r2, #0x32
a0210bfc 0030a0e3 mov r3, #0
a0210c00 1010a0e3 mov r1, #0x10
a0210c04 01eba0e3 mov lr, #0x400
a0210c08 01c0a0e3 mov ip, #1
a0210c0c 5a20cde5 strb r2, [sp, #0x5a]
a0210c10 44008de2 add r0, sp, #0x44
a0210c14 802b0be3 movw r2, #0xbb80
a0210c18 4ce08de5 str lr, [sp, #0x4c]
a0210c1c e48302e3 movw r8, #0x23e4
a0210c20 50108de5 str r1, [sp, #0x50]
a0210c24 3a814ae3 movt r8, #0xa13a
a0210c28 1c108de5 str r1, [sp, #0x1c]
a0210c2c 44208de5 str r2, [sp, #0x44]
a0210c30 18208de5 str r2, [sp, #0x18]
a0210c34 5bc0cde5 strb ip, [sp, #0x5b]
a0210c38 5dc0cde5 strb ip, [sp, #0x5d]
a0210c3c 5c40cde5 strb r4, [sp, #0x5c]
a0210c40 5930cde5 strb r3, [sp, #0x59]
a0210c44 60308de5 str r3, [sp, #0x60]
a0210c48 64308de5 str r3, [sp, #0x64]
a0210c4c 54308de5 str r3, [sp, #0x54]
a0210c50 2c308de5 str r3, [sp, #0x2c]
a0210c54 30308de5 str r3, [sp, #0x30]
a0210c58 34308de5 str r3, [sp, #0x34]
a0210c5c 38308de5 str r3, [sp, #0x38]
a0210c60 3c308de5 str r3, [sp, #0x3c]
a0210c64 40308de5 str r3, [sp, #0x40]
a0210c68 48608de5 str r6, [sp, #0x48]
a0210c6c 90b08de5 str fp, [sp, #0x90]
a0210c70 300302eb bl #0xa0291938
a0210c74 033080e2 add r3, r0, #3
a0210c78 44008de2 add r0, sp, #0x44
a0210c7c 03c0c3e3 bic ip, r3, #3
a0210c80 14c08de5 str ip, [sp, #0x14]
a0210c84 5d0302eb bl #0xa0291a00
a0210c88 18209de5 ldr r2, [sp, #0x18]
a0210c8c 023ba0e3 mov r3, #0x800
a0210c90 074080e2 add r4, r0, #7
a0210c94 2c008de2 add r0, sp, #0x2c
a0210c98 30608de5 str r6, [sp, #0x30]
a0210c9c 0740c4e3 bic r4, r4, #7
a0210ca0 2c208de5 str r2, [sp, #0x2c]
a0210ca4 34308de5 str r3, [sp, #0x34]
a0210ca8 54ff01eb bl #0xa0290a00
a0210cac 14c09de5 ldr ip, [sp, #0x14]
a0210cb0 030080e2 add r0, r0, #3
a0210cb4 18209de5 ldr r2, [sp, #0x18]
a0210cb8 0330c0e3 bic r3, r0, #3
a0210cbc 1c109de5 ldr r1, [sp, #0x1c]
a0210cc0 38008de2 add r0, sp, #0x38
a0210cc4 0c3083e0 add r3, r3, ip
a0210cc8 3c608de5 str r6, [sp, #0x3c]
a0210ccc 14308de5 str r3, [sp, #0x14]
a0210cd0 38208de5 str r2, [sp, #0x38]
a0210cd4 40108de5 str r1, [sp, #0x40]
a0210cd8 750802eb bl #0xa0292eb4
a0210cdc 14309de5 ldr r3, [sp, #0x14]
a0210ce0 030080e2 add r0, r0, #3
a0210ce4 00e098e5 ldr lr, [r8]
a0210ce8 0360c0e3 bic r6, r0, #3
a0210cec 20c0a0e3 mov ip, #0x20
a0210cf0 801c07e3 movw r1, #0x7c80
a0210cf4 066083e0 add r6, r3, r6
a0210cf8 242c07e3 movw r2, #0x7c24
a0210cfc 8630a0e1 lsl r3, r6, #1
a0210d00 0e00a0e1 mov r0, lr
a0210d04 00c08de5 str ip, [sp]
a0210d08 3c114ae3 movt r1, #0xa13c
a0210d0c 3c214ae3 movt r2, #0xa13c
a0210d10 b02602eb bl #0xa029a7d8
a0210d14 000050e3 cmp r0, #0
a0210d18 9200001a bne #0xa0210f68
a0210d1c f03302e3 movw r3, #0x23f0
a0210d20 20c0a0e3 mov ip, #0x20
a0210d24 3a314ae3 movt r3, #0xa13a
a0210d28 8c1c07e3 movw r1, #0x7c8c
a0210d2c 142d07e3 movw r2, #0x7d14
a0210d30 000093e5 ldr r0, [r3]
a0210d34 3c114ae3 movt r1, #0xa13c
a0210d38 00c08de5 str ip, [sp]
a0210d3c 3c214ae3 movt r2, #0xa13c
a0210d40 8430a0e1 lsl r3, r4, #1
a0210d44 a32602eb bl #0xa029a7d8
a0210d48 000050e3 cmp r0, #0
a0210d4c 8000001a bne #0xa0210f54
a0210d50 4030a0e3 mov r3, #0x40
a0210d54 441c07e3 movw r1, #0x7c44
a0210d58 3c2c07e3 movw r2, #0x7c3c
a0210d5c 000098e5 ldr r0, [r8]
a0210d60 3c114ae3 movt r1, #0xa13c
a0210d64 00308de5 str r3, [sp]
a0210d68 3c214ae3 movt r2, #0xa13c
a0210d6c 0a36a0e3 mov r3, #0xa00000
a0210d70 90b08de5 str fp, [sp, #0x90]
a0210d74 972602eb bl #0xa029a7d8
a0210d78 000050e3 cmp r0, #0
a0210d7c 6f00001a bne #0xa0210f40
a0210d80 44bc07e3 movw fp, #0x7c44
a0210d84 2030a0e3 mov r3, #0x20
a0210d88 3cb14ae3 movt fp, #0xa13c
a0210d8c 301c07e3 movw r1, #0x7c30
a0210d90 00c09be5 ldr ip, [fp]
a0210d94 182d07e3 movw r2, #0x7d18
a0210d98 000098e5 ldr r0, [r8]
a0210d9c 0ae6a0e3 mov lr, #0xa00000
a0210da0 00308de5 str r3, [sp]
a0210da4 3c114ae3 movt r1, #0xa13c
a0210da8 3fc08ce2 add ip, ip, #0x3f
a0210dac 3c214ae3 movt r2, #0xa13c
a0210db0 3fc0cce3 bic ip, ip, #0x3f
a0210db4 1939a0e3 mov r3, #0x64000
a0210db8 00c08be5 str ip, [fp]
a0210dbc 94c08de5 str ip, [sp, #0x94]
a0210dc0 98e08de5 str lr, [sp, #0x98]
a0210dc4 832602eb bl #0xa029a7d8
a0210dc8 000050e3 cmp r0, #0
a0210dcc 5600001a bne #0xa0210f2c
a0210dd0 308c07e3 movw r8, #0x7c30
a0210dd4 1939a0e3 mov r3, #0x64000
a0210dd8 3c814ae3 movt r8, #0xa13c
a0210ddc 700f0ee3 movw r0, #0xef70
a0210de0 00c098e5 ldr ip, [r8]
a0210de4 02e5a0e3 mov lr, #0x800000
a0210de8 00109be5 ldr r1, [fp]
a0210dec 0a26a0e3 mov r2, #0xa00000
a0210df0 00308de5 str r3, [sp]
a0210df4 58004ae3 movt r0, #0xa058
a0210df8 1fc08ce2 add ip, ip, #0x1f
a0210dfc a0308de5 str r3, [sp, #0xa0]
a0210e00 1fc0cce3 bic ip, ip, #0x1f
a0210e04 a4e08de5 str lr, [sp, #0xa4]
a0210e08 0c30a0e1 mov r3, ip
a0210e0c 00c088e5 str ip, [r8]
a0210e10 9cc08de5 str ip, [sp, #0x9c]
a0210e14 648c07e3 movw r8, #0x7c64
a0210e18 b35802eb bl #0xa02a70ec
a0210e1c 802c07e3 movw r2, #0x7c80
a0210e20 8c3c07e3 movw r3, #0x7c8c
a0210e24 3c214ae3 movt r2, #0xa13c
a0210e28 3c314ae3 movt r3, #0xa13c
a0210e2c 001093e5 ldr r1, [r3]
a0210e30 20e08de2 add lr, sp, #0x20
a0210e34 000092e5 ldr r0, [r2]
a0210e38 24c08de2 add ip, sp, #0x24
a0210e3c 28208de2 add r2, sp, #0x28
a0210e40 0030a0e3 mov r3, #0
a0210e44 00e08de5 str lr, [sp]
a0210e48 3c814ae3 movt r8, #0xa13c
a0210e4c 04c08de5 str ip, [sp, #4]
a0210e50 01c0a0e3 mov ip, #1
a0210e54 08208de5 str r2, [sp, #8]
a0210e58 0620a0e1 mov r2, r6
a0210e5c 0c308de5 str r3, [sp, #0xc]
a0210e60 0430a0e1 mov r3, r4
a0210e64 74c0cde5 strb ip, [sp, #0x74]
a0210e68 86fcffeb bl #0xa0210088
a0210e6c 28309de5 ldr r3, [sp, #0x28]
a0210e70 b80f0ee3 movw r0, #0xefb8
a0210e74 20c09de5 ldr ip, [sp, #0x20]
a0210e78 54130fe3 movw r1, #0xf354
a0210e7c 24209de5 ldr r2, [sp, #0x24]
a0210e80 58104ae3 movt r1, #0xa058
a0210e84 58004ae3 movt r0, #0xa058
a0210e88 78808de5 str r8, [sp, #0x78]
a0210e8c 00c088e5 str ip, [r8]
a0210e90 0c0088e9 stmib r8, {r2, r3}
a0210e94 945802eb bl #0xa02a70ec
a0210e98 000098e5 ldr r0, [r8]
a0210e9c 1afcffeb bl #0xa020ff0c
a0210ea0 00309ae5 ldr r3, [sl]
a0210ea4 000053e3 cmp r3, #0
a0210ea8 1900001a bne #0xa0210f14
a0210eac 201d07e3 movw r1, #0x7d20
a0210eb0 58008de2 add r0, sp, #0x58
a0210eb4 3c114ae3 movt r1, #0xa13c
a0210eb8 9b3c09eb bl #0xa046012c
a0210ebc 8ffeffea b #0xa0210900
a0210ec0 103083e2 add r3, r3, #0x10
a0210ec4 7cc08de2 add ip, sp, #0x7c
a0210ec8 070093e8 ldm r3, {r0, r1, r2}
a0210ecc 243e0ee3 movw r3, #0xee24
a0210ed0 58304ae3 movt r3, #0xa058
a0210ed4 07008ce8 stm ip, {r0, r1, r2}
a0210ed8 33ffffea b #0xa0210bac
a0210edc 7c3003e3 movw r3, #0x307c
a0210ee0 f00e0ee3 movw r0, #0xeef0
a0210ee4 6f304ae3 movt r3, #0xa06f
a0210ee8 58004ae3 movt r0, #0xa058
a0210eec 041093e5 ldr r1, [r3, #4]
a0210ef0 7d5802eb bl #0xa02a70ec
a0210ef4 c4feffea b #0xa0210a0c
a0210ef8 7c3003e3 movw r3, #0x307c
a0210efc 300f0ee3 movw r0, #0xef30
a0210f00 6f304ae3 movt r3, #0xa06f
a0210f04 58004ae3 movt r0, #0xa058
a0210f08 041093e5 ldr r1, [r3, #4]
a0210f0c 765802eb bl #0xa02a70ec
a0210f10 cefeffea b #0xa0210a50
a0210f14 903c07e3 movw r3, #0x7c90
a0210f18 0610a0e3 mov r1, #6
a0210f1c 3c314ae3 movt r3, #0xa13c
a0210f20 780093e5 ldr r0, [r3, #0x78]
a0210f24 7d0702eb bl #0xa0292d20
a0210f28 dfffffea b #0xa0210eac
a0210f2c 300f0ee3 movw r0, #0xef30
a0210f30 041099e5 ldr r1, [sb, #4]
a0210f34 58004ae3 movt r0, #0xa058
a0210f38 6b5802eb bl #0xa02a70ec
a0210f3c a3ffffea b #0xa0210dd0
a0210f40 f00e0ee3 movw r0, #0xeef0
a0210f44 041099e5 ldr r1, [sb, #4]
a0210f48 58004ae3 movt r0, #0xa058
a0210f4c 665802eb bl #0xa02a70ec
a0210f50 8affffea b #0xa0210d80
a0210f54 ac0e0ee3 movw r0, #0xeeac
a0210f58 041099e5 ldr r1, [sb, #4]
a0210f5c 58004ae3 movt r0, #0xa058
a0210f60 615802eb bl #0xa02a70ec
a0210f64 79ffffea b #0xa0210d50
a0210f68 640e0ee3 movw r0, #0xee64
a0210f6c 041099e5 ldr r1, [sb, #4]
a0210f70 58004ae3 movt r0, #0xa058
a0210f74 5c5802eb bl #0xa02a70ec
a0210f78 67ffffea b #0xa0210d1c
a0210f7c 58008de2 add r0, sp, #0x58
a0210f80 0170a0e3 mov r7, #1
a0210f84 4f3c09eb bl #0xa04600c8
a0210f88 082504e3 movw r2, #0x4508
a0210f8c 7cc08de2 add ip, sp, #0x7c
a0210f90 6d204ae3 movt r2, #0xa06d
a0210f94 243e0ee3 movw r3, #0xee24
a0210f98 2c1082e2 add r1, r2, #0x2c
a0210f9c 1c80d2e5 ldrb r8, [r2, #0x1c]
a0210fa0 b862d2e1 ldrh r6, [r2, #0x28]
a0210fa4 58304ae3 movt r3, #0xa058
a0210fa8 204092e5 ldr r4, [r2, #0x20]
a0210fac bae2d2e1 ldrh lr, [r2, #0x2a]
a0210fb0 030091e8 ldm r1, {r0, r1}
a0210fb4 242092e5 ldr r2, [r2, #0x24]
a0210fb8 5880cde5 strb r8, [sp, #0x58]
a0210fbc 03008ce8 stm ip, {r0, r1}
a0210fc0 b067cde1 strh r6, [sp, #0x70]
a0210fc4 68408de5 str r4, [sp, #0x68]
a0210fc8 b2e7cde1 strh lr, [sp, #0x72]
a0210fcc 6c208de5 str r2, [sp, #0x6c]
a0210fd0 f5feffea b #0xa0210bac
