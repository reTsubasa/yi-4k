a0189a28 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0189a2c 5ddf4de2 sub sp, sp, #0x174
a0189a30 5c20a0e3 mov r2, #0x5c
a0189a34 0050a0e1 mov r5, r0
a0189a38 0170a0e1 mov r7, r1
a0189a3c b8008de2 add r0, sp, #0xb8
a0189a40 0010a0e3 mov r1, #0
a0189a44 2c408de2 add r4, sp, #0x2c
a0189a48 e7bc0dfa blx #0xa04f8dec
a0189a4c 8c3703e3 movw r3, #0x378c
a0189a50 0010a0e3 mov r1, #0
a0189a54 0360a0e1 mov r6, r3
a0189a58 5c20a0e3 mov r2, #0x5c
a0189a5c 450f8de2 add r0, sp, #0x114
a0189a60 5c908de2 add sb, sp, #0x5c
a0189a64 e0bc0dfa blx #0xa04f8dec
a0189a68 0620a0e1 mov r2, r6
a0189a6c 78310ce3 movw r3, #0xc178
a0189a70 55304ae3 movt r3, #0xa055
a0189a74 05214ae3 movt r2, #0xa105
a0189a78 0260a0e1 mov r6, r2
a0189a7c 14208de5 str r2, [sp, #0x14]
a0189a80 070093e8 ldm r3, {r0, r1, r2}
a0189a84 0ce083e2 add lr, r3, #0xc
a0189a88 1cc083e2 add ip, r3, #0x1c
a0189a8c b03703e3 movw r3, #0x37b0
a0189a90 05314ae3 movt r3, #0xa105
a0189a94 006096e5 ldr r6, [r6]
a0189a98 00b0d3e5 ldrb fp, [r3]
a0189a9c 38a08de2 add sl, sp, #0x38
a0189aa0 070084e8 stm r4, {r0, r1, r2}
a0189aa4 000056e3 cmp r6, #0
a0189aa8 0f009ee8 ldm lr, {r0, r1, r2, r3}
a0189aac 54ee0ce3 movw lr, #0xce54
a0189ab0 6ce04ae3 movt lr, #0xa06c
a0189ab4 0080dee5 ldrb r8, [lr]
a0189ab8 0f0089e8 stm sb, {r0, r1, r2, r3}
a0189abc db30e0e7 ubfx r3, fp, #1, #1
a0189ac0 10308de5 str r3, [sp, #0x10]
a0189ac4 07009ce8 ldm ip, {r0, r1, r2}
a0189ac8 07008ae8 stm sl, {r0, r1, r2}
a0189acc 9302001a bne #0xa018a520
a0189ad0 00005be3 cmp fp, #0
a0189ad4 b8008de2 add r0, sp, #0xb8
a0189ad8 ae00001a bne #0xa0189d98
a0189adc 79590beb bl #0xa04600c8
a0189ae0 5c0e0ce3 movw r0, #0xce5c
a0189ae4 642e0ce3 movw r2, #0xce64
a0189ae8 000055e3 cmp r5, #0
a0189aec 0210a0e3 mov r1, #2
a0189af0 803b0be3 movw r3, #0xbb80
a0189af4 6c004ae3 movt r0, #0xa06c
a0189af8 6c204ae3 movt r2, #0xa06c
a0189afc b010c0e1 strh r1, [r0]
a0189b00 b01dcde1 strh r1, [sp, #0xd0]
a0189b04 b21dcde1 strh r1, [sp, #0xd2]
a0189b08 003082e5 str r3, [r2]
a0189b0c c8308de5 str r3, [sp, #0xc8]
a0189b10 cc308de5 str r3, [sp, #0xcc]
a0189b14 8101001a bne #0xa018a120
a0189b18 601e0ce3 movw r1, #0xce60
a0189b1c 6c2e0ce3 movw r2, #0xce6c
a0189b20 783703e3 movw r3, #0x3778
a0189b24 10c0a0e3 mov ip, #0x10
a0189b28 7d0ba0e3 mov r0, #0x1f400
a0189b2c 6c104ae3 movt r1, #0xa06c
a0189b30 6c204ae3 movt r2, #0xa06c
a0189b34 01eba0e3 mov lr, #0x400
a0189b38 05314ae3 movt r3, #0xa105
a0189b3c dc80cde5 strb r8, [sp, #0xdc]
a0189b40 b0c0c1e1 strh ip, [r1]
a0189b44 b8c0cde5 strb ip, [sp, #0xb8]
a0189b48 b0e0c2e1 strh lr, [r2]
a0189b4c 000083e5 str r0, [r3]
a0189b50 e0008de5 str r0, [sp, #0xe0]
a0189b54 30260ee3 movw r2, #0xe630
a0189b58 806b0be3 movw r6, #0xbb80
a0189b5c 174e8de2 add r4, sp, #0x170
a0189b60 04214ae3 movt r2, #0xa104
a0189b64 0030a0e3 mov r3, #0
a0189b68 0110a0e3 mov r1, #1
a0189b6c 0cc0a0e3 mov ip, #0xc
a0189b70 01eba0e3 mov lr, #0x400
a0189b74 046124e5 str r6, [r4, #-0x104]!
a0189b78 0280a0e3 mov r8, #2
a0189b7c 0050c2e5 strb r5, [r2]
a0189b80 0f70a0e3 mov r7, #0xf
a0189b84 1020a0e3 mov r2, #0x10
a0189b88 0400a0e1 mov r0, r4
a0189b8c bb10cde5 strb r1, [sp, #0xbb]
a0189b90 44908de2 add sb, sp, #0x44
a0189b94 bd10cde5 strb r1, [sp, #0xbd]
a0189b98 50a08de2 add sl, sp, #0x50
a0189b9c bcc0cde5 strb ip, [sp, #0xbc]
a0189ba0 78208de5 str r2, [sp, #0x78]
a0189ba4 18208de5 str r2, [sp, #0x18]
a0189ba8 74e08de5 str lr, [sp, #0x74]
a0189bac b930cde5 strb r3, [sp, #0xb9]
a0189bb0 c0308de5 str r3, [sp, #0xc0]
a0189bb4 c4308de5 str r3, [sp, #0xc4]
a0189bb8 7c308de5 str r3, [sp, #0x7c]
a0189bbc ba70cde5 strb r7, [sp, #0xba]
a0189bc0 20760ee3 movw r7, #0xe620
a0189bc4 70808de5 str r8, [sp, #0x70]
a0189bc8 04714ae3 movt r7, #0xa104
a0189bcc 591f04eb bl #0xa0291938
a0189bd0 035080e2 add r5, r0, #3
a0189bd4 0400a0e1 mov r0, r4
a0189bd8 881f04eb bl #0xa0291a00
a0189bdc 023ba0e3 mov r3, #0x800
a0189be0 07b080e2 add fp, r0, #7
a0189be4 0900a0e1 mov r0, sb
a0189be8 44608de5 str r6, [sp, #0x44]
a0189bec 4c308de5 str r3, [sp, #0x4c]
a0189bf0 0350c5e3 bic r5, r5, #3
a0189bf4 48808de5 str r8, [sp, #0x48]
a0189bf8 07b0cbe3 bic fp, fp, #7
a0189bfc 7f1b04eb bl #0xa0290a00
a0189c00 18209de5 ldr r2, [sp, #0x18]
a0189c04 030080e2 add r0, r0, #3
a0189c08 0330c0e3 bic r3, r0, #3
a0189c0c 0a00a0e1 mov r0, sl
a0189c10 055083e0 add r5, r3, r5
a0189c14 50608de5 str r6, [sp, #0x50]
a0189c18 58208de5 str r2, [sp, #0x58]
a0189c1c 54808de5 str r8, [sp, #0x54]
a0189c20 a32404eb bl #0xa0292eb4
a0189c24 003097e5 ldr r3, [r7]
a0189c28 030080e2 add r0, r0, #3
a0189c2c 0360c0e3 bic r6, r0, #3
a0189c30 062085e0 add r2, r5, r6
a0189c34 000053e3 cmp r3, #0
a0189c38 18208de5 str r2, [sp, #0x18]
a0189c3c 6103000a beq #0xa018a9c8
a0189c40 708703e3 movw r8, #0x3770
a0189c44 05814ae3 movt r8, #0xa105
a0189c48 6c5703e3 movw r5, #0x376c
a0189c4c 05514ae3 movt r5, #0xa105
a0189c50 003095e5 ldr r3, [r5]
a0189c54 000053e3 cmp r3, #0
a0189c58 1203000a beq #0xa018a8a8
a0189c5c ec650ee3 movw r6, #0xe5ec
a0189c60 04614ae3 movt r6, #0xa104
a0189c64 44560ee3 movw r5, #0xe644
a0189c68 6c3408e3 movw r3, #0x846c
a0189c6c 04514ae3 movt r5, #0xa104
a0189c70 18304ae3 movt r3, #0xa018
a0189c74 001095e5 ldr r1, [r5]
a0189c78 f0308de5 str r3, [sp, #0xf0]
a0189c7c 000051e3 cmp r1, #0
a0189c80 4303000a beq #0xa018a994
a0189c84 e4750ee3 movw r7, #0xe5e4
a0189c88 7629a0e3 mov r2, #0x1d8000
a0189c8c 04714ae3 movt r7, #0xa104
a0189c90 f4108de5 str r1, [sp, #0xf4]
a0189c94 003097e5 ldr r3, [r7]
a0189c98 f8208de5 str r2, [sp, #0xf8]
a0189c9c 000053e3 cmp r3, #0
a0189ca0 1f03000a beq #0xa018a924
a0189ca4 20220ee3 movw r2, #0xe220
a0189ca8 99e909e3 movw lr, #0x9999
a0189cac 022040e3 movt r2, #2
a0189cb0 ac080ce3 movw r0, #0xc8ac
a0189cb4 17e040e3 movt lr, #0x17
a0189cb8 00208de5 str r2, [sp]
a0189cbc 00218de5 str r2, [sp, #0x100]
a0189cc0 55004ae3 movt r0, #0xa055
a0189cc4 7629a0e3 mov r2, #0x1d8000
a0189cc8 fc308de5 str r3, [sp, #0xfc]
a0189ccc 04e18de5 str lr, [sp, #0x104]
a0189cd0 28508de2 add r5, sp, #0x28
a0189cd4 047504eb bl #0xa02a70ec
a0189cd8 00e0a0e3 mov lr, #0
a0189cdc 001096e5 ldr r1, [r6]
a0189ce0 000098e5 ldr r0, [r8]
a0189ce4 01c0a0e3 mov ip, #1
a0189ce8 18209de5 ldr r2, [sp, #0x18]
a0189cec 0b30a0e1 mov r3, fp
a0189cf0 0ce08de5 str lr, [sp, #0xc]
a0189cf4 04908de5 str sb, [sp, #4]
a0189cf8 08a08de5 str sl, [sp, #8]
a0189cfc 00508de5 str r5, [sp]
a0189d00 d4c0cde5 strb ip, [sp, #0xd4]
a0189d04 b9feffeb bl #0xa01897f0
a0189d08 28e09de5 ldr lr, [sp, #0x28]
a0189d0c cc350ee3 movw r3, #0xe5cc
a0189d10 44c09de5 ldr ip, [sp, #0x44]
a0189d14 04314ae3 movt r3, #0xa104
a0189d18 50209de5 ldr r2, [sp, #0x50]
a0189d1c 04160ee3 movw r1, #0xe604
a0189d20 00e083e5 str lr, [r3]
a0189d24 b8008de2 add r0, sp, #0xb8
a0189d28 04c083e5 str ip, [r3, #4]
a0189d2c 04114ae3 movt r1, #0xa104
a0189d30 082083e5 str r2, [r3, #8]
a0189d34 d8308de5 str r3, [sp, #0xd8]
a0189d38 fb580beb bl #0xa046012c
a0189d3c 10309de5 ldr r3, [sp, #0x10]
a0189d40 000053e3 cmp r3, #0
a0189d44 e500001a bne #0xa018a0e0
a0189d48 0400a0e1 mov r0, r4
a0189d4c 2f480beb bl #0xa045be10
a0189d50 04360ee3 movw r3, #0xe604
a0189d54 0120a0e3 mov r2, #1
a0189d58 04314ae3 movt r3, #0xa104
a0189d5c 70208de5 str r2, [sp, #0x70]
a0189d60 003093e5 ldr r3, [r3]
a0189d64 74308de5 str r3, [sp, #0x74]
a0189d68 8c1703e3 movw r1, #0x378c
a0189d6c 0400a0e1 mov r0, r4
a0189d70 05114ae3 movt r1, #0xa105
a0189d74 0040a0e3 mov r4, #0
a0189d78 6c40cde5 strb r4, [sp, #0x6c]
a0189d7c 2e480beb bl #0xa045be3c
a0189d80 14309de5 ldr r3, [sp, #0x14]
a0189d84 000093e5 ldr r0, [r3]
a0189d88 73480beb bl #0xa045bf5c
a0189d8c 0400a0e1 mov r0, r4
a0189d90 5ddf8de2 add sp, sp, #0x174
a0189d94 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0189d98 ca580beb bl #0xa04600c8
a0189d9c 643e0ce3 movw r3, #0xce64
a0189da0 5cee0ce3 movw lr, #0xce5c
a0189da4 6c304ae3 movt r3, #0xa06c
a0189da8 000055e3 cmp r5, #0
a0189dac 0220a0e3 mov r2, #2
a0189db0 0310a0e1 mov r1, r3
a0189db4 6ce04ae3 movt lr, #0xa06c
a0189db8 18308de5 str r3, [sp, #0x18]
a0189dbc 803b0be3 movw r3, #0xbb80
a0189dc0 b020cee1 strh r2, [lr]
a0189dc4 b02dcde1 strh r2, [sp, #0xd0]
a0189dc8 b22dcde1 strh r2, [sp, #0xd2]
a0189dcc 003081e5 str r3, [r1]
a0189dd0 c8308de5 str r3, [sp, #0xc8]
a0189dd4 cc308de5 str r3, [sp, #0xcc]
a0189dd8 6401001a bne #0xa018a370
a0189ddc 603e0ce3 movw r3, #0xce60
a0189de0 1010a0e3 mov r1, #0x10
a0189de4 6c304ae3 movt r3, #0xa06c
a0189de8 6c2e0ce3 movw r2, #0xce6c
a0189dec b010c3e1 strh r1, [r3]
a0189df0 783703e3 movw r3, #0x3778
a0189df4 6c204ae3 movt r2, #0xa06c
a0189df8 05314ae3 movt r3, #0xa105
a0189dfc b810cde5 strb r1, [sp, #0xb8]
a0189e00 010ba0e3 mov r0, #0x400
a0189e04 7d1ba0e3 mov r1, #0x1f400
a0189e08 dc80cde5 strb r8, [sp, #0xdc]
a0189e0c b000c2e1 strh r0, [r2]
a0189e10 001083e5 str r1, [r3]
a0189e14 e0108de5 str r1, [sp, #0xe0]
a0189e18 10309de5 ldr r3, [sp, #0x10]
a0189e1c 000053e3 cmp r3, #0
a0189e20 30360ee3 movw r3, #0xe630
a0189e24 04314ae3 movt r3, #0xa104
a0189e28 0050c3e5 strb r5, [r3]
a0189e2c dd00000a beq #0xa018a1a8
a0189e30 0220a0e3 mov r2, #2
a0189e34 4b1f8de2 add r1, sp, #0x12c
a0189e38 b020c1e1 strh r2, [r1]
a0189e3c 4b1f8de2 add r1, sp, #0x12c
a0189e40 021081e2 add r1, r1, #2
a0189e44 b020c1e1 strh r2, [r1]
a0189e48 b220cee1 strh r2, [lr, #2]
a0189e4c 000057e3 cmp r7, #0
a0189e50 18209de5 ldr r2, [sp, #0x18]
a0189e54 803b0be3 movw r3, #0xbb80
a0189e58 24318de5 str r3, [sp, #0x124]
a0189e5c 28318de5 str r3, [sp, #0x128]
a0189e60 043082e5 str r3, [r2, #4]
a0189e64 6501000a beq #0xa018a400
a0189e68 010057e3 cmp r7, #1
a0189e6c 6b02000a beq #0xa018a820
a0189e70 020057e3 cmp r7, #2
a0189e74 fb02000a beq #0xa018aa68
a0189e78 030057e3 cmp r7, #3
a0189e7c 1402000a beq #0xa018a6d4
a0189e80 040057e3 cmp r7, #4
a0189e84 3403000a beq #0xa018ab5c
a0189e88 050057e3 cmp r7, #5
a0189e8c 5a03000a beq #0xa018abfc
a0189e90 060057e3 cmp r7, #6
a0189e94 6c03000a beq #0xa018ac4c
a0189e98 070057e3 cmp r7, #7
a0189e9c 6601001a bne #0xa018a43c
a0189ea0 7d5ba0e3 mov r5, #0x1f400
a0189ea4 0f4da0e3 mov r4, #0x3c0
a0189ea8 38508de5 str r5, [sp, #0x38]
a0189eac 78e703e3 movw lr, #0x3778
a0189eb0 3c408de5 str r4, [sp, #0x3c]
a0189eb4 05e14ae3 movt lr, #0xa105
a0189eb8 07009ae8 ldm sl, {r0, r1, r2}
a0189ebc 6cce0ce3 movw ip, #0xce6c
a0189ec0 603e0ce3 movw r3, #0xce60
a0189ec4 6cc04ae3 movt ip, #0xa06c
a0189ec8 04508ee5 str r5, [lr, #4]
a0189ecc dce08de2 add lr, sp, #0xdc
a0189ed0 6c304ae3 movt r3, #0xa06c
a0189ed4 1050a0e3 mov r5, #0x10
a0189ed8 07008ee8 stm lr, {r0, r1, r2}
a0189edc 5020a0e3 mov r2, #0x50
a0189ee0 b240cce1 strh r4, [ip, #2]
a0189ee4 b250c3e1 strh r5, [r3, #2]
a0189ee8 b820cde5 strb r2, [sp, #0xb8]
a0189eec 520100ea b #0xa018a43c
a0189ef0 20760ee3 movw r7, #0xe620
a0189ef4 6c5703e3 movw r5, #0x376c
a0189ef8 04714ae3 movt r7, #0xa104
a0189efc 003097e5 ldr r3, [r7]
a0189f00 080053e1 cmp r3, r8
a0189f04 6303000a beq #0xa018ac98
a0189f08 05514ae3 movt r5, #0xa105
a0189f0c 003095e5 ldr r3, [r5]
a0189f10 000053e3 cmp r3, #0
a0189f14 5102000a beq #0xa018a860
a0189f18 44560ee3 movw r5, #0xe644
a0189f1c 6c3408e3 movw r3, #0x846c
a0189f20 04514ae3 movt r5, #0xa104
a0189f24 18304ae3 movt r3, #0xa018
a0189f28 001095e5 ldr r1, [r5]
a0189f2c f0308de5 str r3, [sp, #0xf0]
a0189f30 000051e3 cmp r1, #0
a0189f34 8902000a beq #0xa018a960
a0189f38 e4750ee3 movw r7, #0xe5e4
a0189f3c 7629a0e3 mov r2, #0x1d8000
a0189f40 04714ae3 movt r7, #0xa104
a0189f44 f4108de5 str r1, [sp, #0xf4]
a0189f48 003097e5 ldr r3, [r7]
a0189f4c f8208de5 str r2, [sp, #0xf8]
a0189f50 000053e3 cmp r3, #0
a0189f54 6302000a beq #0xa018a8e8
a0189f58 20220ee3 movw r2, #0xe220
a0189f5c 99c909e3 movw ip, #0x9999
a0189f60 022040e3 movt r2, #2
a0189f64 8c0f0ee3 movw r0, #0xef8c
a0189f68 00208de5 str r2, [sp]
a0189f6c 17c040e3 movt ip, #0x17
a0189f70 00218de5 str r2, [sp, #0x100]
a0189f74 58004ae3 movt r0, #0xa058
a0189f78 7629a0e3 mov r2, #0x1d8000
a0189f7c fc308de5 str r3, [sp, #0xfc]
a0189f80 04c18de5 str ip, [sp, #0x104]
a0189f84 587404eb bl #0xa02a70ec
a0189f88 10309de5 ldr r3, [sp, #0x10]
a0189f8c 000053e3 cmp r3, #0
a0189f90 6801000a beq #0xa018a538
a0189f94 f4550ee3 movw r5, #0xe5f4
a0189f98 04514ae3 movt r5, #0xa104
a0189f9c 001095e5 ldr r1, [r5]
a0189fa0 000051e3 cmp r1, #0
a0189fa4 c902000a beq #0xa018aad0
a0189fa8 847703e3 movw r7, #0x3784
a0189fac 7639a0e3 mov r3, #0x1d8000
a0189fb0 05714ae3 movt r7, #0xa105
a0189fb4 50118de5 str r1, [sp, #0x150]
a0189fb8 00c097e5 ldr ip, [r7]
a0189fbc 54318de5 str r3, [sp, #0x154]
a0189fc0 00005ce3 cmp ip, #0
a0189fc4 b202000a beq #0xa018aa94
a0189fc8 20e20ee3 movw lr, #0xe220
a0189fcc 998909e3 movw r8, #0x9999
a0189fd0 02e040e3 movt lr, #2
a0189fd4 f00f0ee3 movw r0, #0xeff0
a0189fd8 0c30a0e1 mov r3, ip
a0189fdc 00e08de5 str lr, [sp]
a0189fe0 178040e3 movt r8, #0x17
a0189fe4 7629a0e3 mov r2, #0x1d8000
a0189fe8 707703e3 movw r7, #0x3770
a0189fec ec550ee3 movw r5, #0xe5ec
a0189ff0 58004ae3 movt r0, #0xa058
a0189ff4 05714ae3 movt r7, #0xa105
a0189ff8 04514ae3 movt r5, #0xa104
a0189ffc 5ce18de5 str lr, [sp, #0x15c]
a018a000 58c18de5 str ip, [sp, #0x158]
a018a004 01b0a0e3 mov fp, #1
a018a008 60818de5 str r8, [sp, #0x160]
a018a00c cc850ee3 movw r8, #0xe5cc
a018a010 357404eb bl #0xa02a70ec
a018a014 28c08de2 add ip, sp, #0x28
a018a018 0030a0e3 mov r3, #0
a018a01c 001095e5 ldr r1, [r5]
a018a020 0620a0e1 mov r2, r6
a018a024 000097e5 ldr r0, [r7]
a018a028 04814ae3 movt r8, #0xa104
a018a02c 00c08de5 str ip, [sp]
a018a030 0c308de5 str r3, [sp, #0xc]
a018a034 04908de5 str sb, [sp, #4]
a018a038 18309de5 ldr r3, [sp, #0x18]
a018a03c 08a08de5 str sl, [sp, #8]
a018a040 d4b0cde5 strb fp, [sp, #0xd4]
a018a044 30b1cde5 strb fp, [sp, #0x130]
a018a048 e8fdffeb bl #0xa01897f0
a018a04c 00c095e5 ldr ip, [r5]
a018a050 28e08de2 add lr, sp, #0x28
a018a054 18009de5 ldr r0, [sp, #0x18]
a018a058 0620a0e1 mov r2, r6
a018a05c 001097e5 ldr r1, [r7]
a018a060 00e08de5 str lr, [sp]
a018a064 00c08ce0 add ip, ip, r0
a018a068 0cb08de5 str fp, [sp, #0xc]
a018a06c 04908de5 str sb, [sp, #4]
a018a070 066081e0 add r6, r1, r6
a018a074 08a08de5 str sl, [sp, #8]
a018a078 0c10a0e1 mov r1, ip
a018a07c 00c085e5 str ip, [r5]
a018a080 0030a0e1 mov r3, r0
a018a084 44c09de5 ldr ip, [sp, #0x44]
a018a088 0600a0e1 mov r0, r6
a018a08c 28e09de5 ldr lr, [sp, #0x28]
a018a090 006087e5 str r6, [r7]
a018a094 04c088e5 str ip, [r8, #4]
a018a098 50c09de5 ldr ip, [sp, #0x50]
a018a09c 00e088e5 str lr, [r8]
a018a0a0 08c088e5 str ip, [r8, #8]
a018a0a4 d1fdffeb bl #0xa01897f0
a018a0a8 00e098e5 ldr lr, [r8]
a018a0ac 983703e3 movw r3, #0x3798
a018a0b0 44c09de5 ldr ip, [sp, #0x44]
a018a0b4 05314ae3 movt r3, #0xa105
a018a0b8 50209de5 ldr r2, [sp, #0x50]
a018a0bc 04160ee3 movw r1, #0xe604
a018a0c0 b8008de2 add r0, sp, #0xb8
a018a0c4 04114ae3 movt r1, #0xa104
a018a0c8 00e083e5 str lr, [r3]
a018a0cc 04c083e5 str ip, [r3, #4]
a018a0d0 082083e5 str r2, [r3, #8]
a018a0d4 d8808de5 str r8, [sp, #0xd8]
a018a0d8 34318de5 str r3, [sp, #0x134]
a018a0dc 12580beb bl #0xa046012c
a018a0e0 c45703e3 movw r5, #0x37c4
a018a0e4 450f8de2 add r0, sp, #0x114
a018a0e8 05514ae3 movt r5, #0xa105
a018a0ec 0510a0e1 mov r1, r5
a018a0f0 0d580beb bl #0xa046012c
a018a0f4 0400a0e1 mov r0, r4
a018a0f8 44470beb bl #0xa045be10
a018a0fc 04360ee3 movw r3, #0xe604
a018a100 001095e5 ldr r1, [r5]
a018a104 04314ae3 movt r3, #0xa104
a018a108 0220a0e3 mov r2, #2
a018a10c 003093e5 ldr r3, [r3]
a018a110 78108de5 str r1, [sp, #0x78]
a018a114 70208de5 str r2, [sp, #0x70]
a018a118 74308de5 str r3, [sp, #0x74]
a018a11c 11ffffea b #0xa0189d68
a018a120 010055e3 cmp r5, #1
a018a124 da00000a beq #0xa018a494
a018a128 020055e3 cmp r5, #2
a018a12c 8e01000a beq #0xa018a76c
a018a130 030055e3 cmp r5, #3
a018a134 9d01000a beq #0xa018a7b0
a018a138 040055e3 cmp r5, #4
a018a13c 3d02000a beq #0xa018aa38
a018a140 050055e3 cmp r5, #5
a018a144 3501000a beq #0xa018a620
a018a148 060055e3 cmp r5, #6
a018a14c 7702000a beq #0xa018ab30
a018a150 070055e3 cmp r5, #7
a018a154 7efeff1a bne #0xa0189b54
a018a158 7d7ba0e3 mov r7, #0x1f400
a018a15c 0f6da0e3 mov r6, #0x3c0
a018a160 38708de5 str r7, [sp, #0x38]
a018a164 784703e3 movw r4, #0x3778
a018a168 3c608de5 str r6, [sp, #0x3c]
a018a16c 05414ae3 movt r4, #0xa105
a018a170 07009ae8 ldm sl, {r0, r1, r2}
a018a174 6cce0ce3 movw ip, #0xce6c
a018a178 603e0ce3 movw r3, #0xce60
a018a17c 6cc04ae3 movt ip, #0xa06c
a018a180 007084e5 str r7, [r4]
a018a184 6c304ae3 movt r3, #0xa06c
a018a188 dce08de2 add lr, sp, #0xdc
a018a18c 1070a0e3 mov r7, #0x10
a018a190 5040a0e3 mov r4, #0x50
a018a194 07008ee8 stm lr, {r0, r1, r2}
a018a198 b060cce1 strh r6, [ip]
a018a19c b070c3e1 strh r7, [r3]
a018a1a0 b840cde5 strb r4, [sp, #0xb8]
a018a1a4 6afeffea b #0xa0189b54
a018a1a8 10009de5 ldr r0, [sp, #0x10]
a018a1ac 0130a0e3 mov r3, #1
a018a1b0 0f10a0e3 mov r1, #0xf
a018a1b4 0c20a0e3 mov r2, #0xc
a018a1b8 ba10cde5 strb r1, [sp, #0xba]
a018a1bc b900cde5 strb r0, [sp, #0xb9]
a018a1c0 c0008de5 str r0, [sp, #0xc0]
a018a1c4 c4008de5 str r0, [sp, #0xc4]
a018a1c8 bb30cde5 strb r3, [sp, #0xbb]
a018a1cc bd30cde5 strb r3, [sp, #0xbd]
a018a1d0 bc20cde5 strb r2, [sp, #0xbc]
a018a1d4 806b0be3 movw r6, #0xbb80
a018a1d8 174e8de2 add r4, sp, #0x170
a018a1dc 1020a0e3 mov r2, #0x10
a018a1e0 046124e5 str r6, [r4, #-0x104]!
a018a1e4 013ba0e3 mov r3, #0x400
a018a1e8 0250a0e3 mov r5, #2
a018a1ec 0080a0e3 mov r8, #0
a018a1f0 0400a0e1 mov r0, r4
a018a1f4 78208de5 str r2, [sp, #0x78]
a018a1f8 44908de2 add sb, sp, #0x44
a018a1fc 20208de5 str r2, [sp, #0x20]
a018a200 50a08de2 add sl, sp, #0x50
a018a204 74308de5 str r3, [sp, #0x74]
a018a208 7c808de5 str r8, [sp, #0x7c]
a018a20c 70508de5 str r5, [sp, #0x70]
a018a210 c81d04eb bl #0xa0291938
a018a214 037080e2 add r7, r0, #3
a018a218 0400a0e1 mov r0, r4
a018a21c f71d04eb bl #0xa0291a00
a018a220 023ba0e3 mov r3, #0x800
a018a224 071080e2 add r1, r0, #7
a018a228 0720c1e3 bic r2, r1, #7
a018a22c 4c308de5 str r3, [sp, #0x4c]
a018a230 0900a0e1 mov r0, sb
a018a234 bc3703e3 movw r3, #0x37bc
a018a238 18208de5 str r2, [sp, #0x18]
a018a23c 0370c7e3 bic r7, r7, #3
a018a240 44608de5 str r6, [sp, #0x44]
a018a244 1c308de5 str r3, [sp, #0x1c]
a018a248 48508de5 str r5, [sp, #0x48]
a018a24c eb1904eb bl #0xa0290a00
a018a250 1c309de5 ldr r3, [sp, #0x1c]
a018a254 030080e2 add r0, r0, #3
a018a258 20209de5 ldr r2, [sp, #0x20]
a018a25c 0310c0e3 bic r1, r0, #3
a018a260 0a00a0e1 mov r0, sl
a018a264 50608de5 str r6, [sp, #0x50]
a018a268 05314ae3 movt r3, #0xa105
a018a26c 077081e0 add r7, r1, r7
a018a270 1c308de5 str r3, [sp, #0x1c]
a018a274 24308de5 str r3, [sp, #0x24]
a018a278 58208de5 str r2, [sp, #0x58]
a018a27c 54508de5 str r5, [sp, #0x54]
a018a280 0b2304eb bl #0xa0292eb4
a018a284 1c309de5 ldr r3, [sp, #0x1c]
a018a288 030080e2 add r0, r0, #3
a018a28c 0360c0e3 bic r6, r0, #3
a018a290 066087e0 add r6, r7, r6
a018a294 002093e5 ldr r2, [r3]
a018a298 080052e1 cmp r2, r8
a018a29c 13ffff0a beq #0xa0189ef0
a018a2a0 6c5703e3 movw r5, #0x376c
a018a2a4 05514ae3 movt r5, #0xa105
a018a2a8 002095e5 ldr r2, [r5]
a018a2ac 000052e3 cmp r2, #0
a018a2b0 0900000a beq #0xa018a2dc
a018a2b4 742603e3 movw r2, #0x3674
a018a2b8 1c308de5 str r3, [sp, #0x1c]
a018a2bc 05214ae3 movt r2, #0xa105
a018a2c0 000092e5 ldr r0, [r2]
a018a2c4 12c908eb bl #0xa03bc714
a018a2c8 1c309de5 ldr r3, [sp, #0x1c]
a018a2cc ec250ee3 movw r2, #0xe5ec
a018a2d0 04214ae3 movt r2, #0xa104
a018a2d4 008085e5 str r8, [r5]
a018a2d8 008082e5 str r8, [r2]
a018a2dc 20760ee3 movw r7, #0xe620
a018a2e0 04714ae3 movt r7, #0xa104
a018a2e4 002097e5 ldr r2, [r7]
a018a2e8 000052e3 cmp r2, #0
a018a2ec 70870303 movweq r8, #0x3770
a018a2f0 05814a03 movteq r8, #0xa105
a018a2f4 0a00000a beq #0xa018a324
a018a2f8 34260ee3 movw r2, #0xe634
a018a2fc 1c308de5 str r3, [sp, #0x1c]
a018a300 04214ae3 movt r2, #0xa104
a018a304 708703e3 movw r8, #0x3770
a018a308 000092e5 ldr r0, [r2]
a018a30c 05814ae3 movt r8, #0xa105
a018a310 ffc808eb bl #0xa03bc714
a018a314 1c309de5 ldr r3, [sp, #0x1c]
a018a318 0020a0e3 mov r2, #0
a018a31c 002088e5 str r2, [r8]
a018a320 002087e5 str r2, [r7]
a018a324 003093e5 ldr r3, [r3]
a018a328 0020a0e3 mov r2, #0
a018a32c 0c218de5 str r2, [sp, #0x10c]
a018a330 08318de5 str r3, [sp, #0x108]
a018a334 2030a0e3 mov r3, #0x20
a018a338 140107e3 movw r0, #0x7114
a018a33c 20160ee3 movw r1, #0xe620
a018a340 34260ee3 movw r2, #0xe634
a018a344 00308de5 str r3, [sp]
a018a348 fd004ae3 movt r0, #0xa0fd
a018a34c 04114ae3 movt r1, #0xa104
a018a350 04214ae3 movt r2, #0xa104
a018a354 8630a0e1 lsl r3, r6, #1
a018a358 1e4104eb bl #0xa029a7d8
a018a35c 000050e3 cmp r0, #0
a018a360 ec00001a bne #0xa018a718
a018a364 003097e5 ldr r3, [r7]
a018a368 003088e5 str r3, [r8]
a018a36c e6feffea b #0xa0189f0c
a018a370 010055e3 cmp r5, #1
a018a374 5500000a beq #0xa018a4d0
a018a378 020055e3 cmp r5, #2
a018a37c e900000a beq #0xa018a728
a018a380 030055e3 cmp r5, #3
a018a384 1401000a beq #0xa018a7dc
a018a388 040055e3 cmp r5, #4
a018a38c 9d01000a beq #0xa018aa08
a018a390 050055e3 cmp r5, #5
a018a394 b500000a beq #0xa018a670
a018a398 060055e3 cmp r5, #6
a018a39c d801000a beq #0xa018ab04
a018a3a0 070055e3 cmp r5, #7
a018a3a4 9bfeff1a bne #0xa0189e18
a018a3a8 7d3ba0e3 mov r3, #0x1f400
a018a3ac 0f2da0e3 mov r2, #0x3c0
a018a3b0 38308de5 str r3, [sp, #0x38]
a018a3b4 783703e3 movw r3, #0x3778
a018a3b8 3c208de5 str r2, [sp, #0x3c]
a018a3bc 05314ae3 movt r3, #0xa105
a018a3c0 07009ae8 ldm sl, {r0, r1, r2}
a018a3c4 7dcba0e3 mov ip, #0x1f400
a018a3c8 6c6e0ce3 movw r6, #0xce6c
a018a3cc 6c604ae3 movt r6, #0xa06c
a018a3d0 00c083e5 str ip, [r3]
a018a3d4 0f3da0e3 mov r3, #0x3c0
a018a3d8 dcc08de2 add ip, sp, #0xdc
a018a3dc b030c6e1 strh r3, [r6]
a018a3e0 606e0ce3 movw r6, #0xce60
a018a3e4 6c604ae3 movt r6, #0xa06c
a018a3e8 1030a0e3 mov r3, #0x10
a018a3ec 07008ce8 stm ip, {r0, r1, r2}
a018a3f0 5020a0e3 mov r2, #0x50
a018a3f4 b030c6e1 strh r3, [r6]
a018a3f8 b820cde5 strb r2, [sp, #0xb8]
a018a3fc 85feffea b #0xa0189e18
a018a400 601e0ce3 movw r1, #0xce60
a018a404 6c2e0ce3 movw r2, #0xce6c
a018a408 783703e3 movw r3, #0x3778
a018a40c 10c0a0e3 mov ip, #0x10
a018a410 7d0ba0e3 mov r0, #0x1f400
a018a414 6c104ae3 movt r1, #0xa06c
a018a418 6c204ae3 movt r2, #0xa06c
a018a41c 01eba0e3 mov lr, #0x400
a018a420 05314ae3 movt r3, #0xa105
a018a424 3881cde5 strb r8, [sp, #0x138]
a018a428 b2c0c1e1 strh ip, [r1, #2]
a018a42c 14c1cde5 strb ip, [sp, #0x114]
a018a430 b2e0c2e1 strh lr, [r2, #2]
a018a434 040083e5 str r0, [r3, #4]
a018a438 3c018de5 str r0, [sp, #0x13c]
a018a43c 4c160ee3 movw r1, #0xe64c
a018a440 0030a0e3 mov r3, #0
a018a444 0120a0e3 mov r2, #1
a018a448 0fc0a0e3 mov ip, #0xf
a018a44c 0c00a0e3 mov r0, #0xc
a018a450 04114ae3 movt r1, #0xa104
a018a454 0070c1e5 strb r7, [r1]
a018a458 bac0cde5 strb ip, [sp, #0xba]
a018a45c 16c1cde5 strb ip, [sp, #0x116]
a018a460 bb20cde5 strb r2, [sp, #0xbb]
a018a464 bd20cde5 strb r2, [sp, #0xbd]
a018a468 1721cde5 strb r2, [sp, #0x117]
a018a46c 1921cde5 strb r2, [sp, #0x119]
a018a470 bc00cde5 strb r0, [sp, #0xbc]
a018a474 1801cde5 strb r0, [sp, #0x118]
a018a478 b930cde5 strb r3, [sp, #0xb9]
a018a47c c0308de5 str r3, [sp, #0xc0]
a018a480 c4308de5 str r3, [sp, #0xc4]
a018a484 1531cde5 strb r3, [sp, #0x115]
a018a488 1c318de5 str r3, [sp, #0x11c]
a018a48c 20318de5 str r3, [sp, #0x120]
a018a490 4fffffea b #0xa018a1d4
a018a494 1070a0e3 mov r7, #0x10
a018a498 016ba0e3 mov r6, #0x400
a018a49c 2c708de5 str r7, [sp, #0x2c]
a018a4a0 60ee0ce3 movw lr, #0xce60
a018a4a4 34608de5 str r6, [sp, #0x34]
a018a4a8 6c3e0ce3 movw r3, #0xce6c
a018a4ac 070094e8 ldm r4, {r0, r1, r2}
a018a4b0 6ce04ae3 movt lr, #0xa06c
a018a4b4 6c304ae3 movt r3, #0xa06c
a018a4b8 dcc08de2 add ip, sp, #0xdc
a018a4bc b8b0cde5 strb fp, [sp, #0xb8]
a018a4c0 b070cee1 strh r7, [lr]
a018a4c4 07008ce8 stm ip, {r0, r1, r2}
a018a4c8 b060c3e1 strh r6, [r3]
a018a4cc a0fdffea b #0xa0189b54
a018a4d0 1030a0e3 mov r3, #0x10
a018a4d4 6c2e0ce3 movw r2, #0xce6c
a018a4d8 2c308de5 str r3, [sp, #0x2c]
a018a4dc 013ba0e3 mov r3, #0x400
a018a4e0 34308de5 str r3, [sp, #0x34]
a018a4e4 0230a0e1 mov r3, r2
a018a4e8 070094e8 ldm r4, {r0, r1, r2}
a018a4ec 6c304ae3 movt r3, #0xa06c
a018a4f0 60ce0ce3 movw ip, #0xce60
a018a4f4 1c308de5 str r3, [sp, #0x1c]
a018a4f8 dc308de2 add r3, sp, #0xdc
a018a4fc 6cc04ae3 movt ip, #0xa06c
a018a500 b860cde5 strb r6, [sp, #0xb8]
a018a504 070083e8 stm r3, {r0, r1, r2}
a018a508 1060a0e3 mov r6, #0x10
a018a50c 1c309de5 ldr r3, [sp, #0x1c]
a018a510 011ba0e3 mov r1, #0x400
a018a514 b060cce1 strh r6, [ip]
a018a518 b010c3e1 strh r1, [r3]
a018a51c 3dfeffea b #0xa0189e18
a018a520 b4070ce3 movw r0, #0xc7b4
a018a524 0610a0e1 mov r1, r6
a018a528 55004ae3 movt r0, #0xa055
a018a52c ee7204eb bl #0xa02a70ec
a018a530 0000e0e3 mvn r0, #0
a018a534 15feffea b #0xa0189d90
a018a538 01001be3 tst fp, #1
a018a53c 3300000a beq #0xa018a610
a018a540 10c09de5 ldr ip, [sp, #0x10]
a018a544 707703e3 movw r7, #0x3770
a018a548 ec550ee3 movw r5, #0xe5ec
a018a54c 05714ae3 movt r7, #0xa105
a018a550 04514ae3 movt r5, #0xa104
a018a554 28808de2 add r8, sp, #0x28
a018a558 001095e5 ldr r1, [r5]
a018a55c 0620a0e1 mov r2, r6
a018a560 000097e5 ldr r0, [r7]
a018a564 ccb50ee3 movw fp, #0xe5cc
a018a568 18309de5 ldr r3, [sp, #0x18]
a018a56c 04b14ae3 movt fp, #0xa104
a018a570 0cc08de5 str ip, [sp, #0xc]
a018a574 00808de5 str r8, [sp]
a018a578 04908de5 str sb, [sp, #4]
a018a57c 08a08de5 str sl, [sp, #8]
a018a580 9afcffeb bl #0xa01897f0
a018a584 00e095e5 ldr lr, [r5]
a018a588 0310a0e3 mov r1, #3
a018a58c 18309de5 ldr r3, [sp, #0x18]
a018a590 0620a0e1 mov r2, r6
a018a594 00c097e5 ldr ip, [r7]
a018a598 00808de5 str r8, [sp]
a018a59c 03e08ee0 add lr, lr, r3
a018a5a0 0c108de5 str r1, [sp, #0xc]
a018a5a4 04908de5 str sb, [sp, #4]
a018a5a8 06c08ce0 add ip, ip, r6
a018a5ac 08a08de5 str sl, [sp, #8]
a018a5b0 0e10a0e1 mov r1, lr
a018a5b4 44809de5 ldr r8, [sp, #0x44]
a018a5b8 0c00a0e1 mov r0, ip
a018a5bc 50609de5 ldr r6, [sp, #0x50]
a018a5c0 00e085e5 str lr, [r5]
a018a5c4 28e09de5 ldr lr, [sp, #0x28]
a018a5c8 00c087e5 str ip, [r7]
a018a5cc 02c0a0e3 mov ip, #2
a018a5d0 04808be5 str r8, [fp, #4]
a018a5d4 00e08be5 str lr, [fp]
a018a5d8 08608be5 str r6, [fp, #8]
a018a5dc d4c0cde5 strb ip, [sp, #0xd4]
a018a5e0 82fcffeb bl #0xa01897f0
a018a5e4 06009be8 ldm fp, {r1, r2}
a018a5e8 50309de5 ldr r3, [sp, #0x50]
a018a5ec d8b08de5 str fp, [sp, #0xd8]
a018a5f0 0c108be5 str r1, [fp, #0xc]
a018a5f4 10208be5 str r2, [fp, #0x10]
a018a5f8 14308be5 str r3, [fp, #0x14]
a018a5fc 04160ee3 movw r1, #0xe604
a018a600 b8008de2 add r0, sp, #0xb8
a018a604 04114ae3 movt r1, #0xa104
a018a608 c7560beb bl #0xa046012c
a018a60c cdfdffea b #0xa0189d48
a018a610 80080ce3 movw r0, #0xc880
a018a614 55004ae3 movt r0, #0xa055
a018a618 b37204eb bl #0xa02a70ec
a018a61c f6ffffea b #0xa018a5fc
a018a620 ee7ca0e3 mov r7, #0xee00
a018a624 786703e3 movw r6, #0x3778
a018a628 027040e3 movt r7, #2
a018a62c 05614ae3 movt r6, #0xa105
a018a630 60708de5 str r7, [sp, #0x60]
a018a634 604e0ce3 movw r4, #0xce60
a018a638 0f0099e8 ldm sb, {r0, r1, r2, r3}
a018a63c 6cee0ce3 movw lr, #0xce6c
a018a640 dcc08de2 add ip, sp, #0xdc
a018a644 6c404ae3 movt r4, #0xa06c
a018a648 007086e5 str r7, [r6]
a018a64c 6ce04ae3 movt lr, #0xa06c
a018a650 1070a0e3 mov r7, #0x10
a018a654 066ca0e3 mov r6, #0x600
a018a658 0f008ce8 stm ip, {r0, r1, r2, r3}
a018a65c 3030a0e3 mov r3, #0x30
a018a660 b070c4e1 strh r7, [r4]
a018a664 b060cee1 strh r6, [lr]
a018a668 b830cde5 strb r3, [sp, #0xb8]
a018a66c 38fdffea b #0xa0189b54
a018a670 783703e3 movw r3, #0x3778
a018a674 ee6ca0e3 mov r6, #0xee00
a018a678 05314ae3 movt r3, #0xa105
a018a67c 026040e3 movt r6, #2
a018a680 20308de5 str r3, [sp, #0x20]
a018a684 603e0ce3 movw r3, #0xce60
a018a688 03c0a0e1 mov ip, r3
a018a68c 60608de5 str r6, [sp, #0x60]
a018a690 6cc04ae3 movt ip, #0xa06c
a018a694 0f0099e8 ldm sb, {r0, r1, r2, r3}
a018a698 1cc08de5 str ip, [sp, #0x1c]
a018a69c 20c09de5 ldr ip, [sp, #0x20]
a018a6a0 00608ce5 str r6, [ip]
a018a6a4 dcc08de2 add ip, sp, #0xdc
a018a6a8 0f008ce8 stm ip, {r0, r1, r2, r3}
a018a6ac 6c6e0ce3 movw r6, #0xce6c
a018a6b0 1cc09de5 ldr ip, [sp, #0x1c]
a018a6b4 6c604ae3 movt r6, #0xa06c
a018a6b8 1010a0e3 mov r1, #0x10
a018a6bc 062ca0e3 mov r2, #0x600
a018a6c0 3030a0e3 mov r3, #0x30
a018a6c4 b020c6e1 strh r2, [r6]
a018a6c8 b010cce1 strh r1, [ip]
a018a6cc b830cde5 strb r3, [sp, #0xb8]
a018a6d0 d0fdffea b #0xa0189e18
a018a6d4 601e0ce3 movw r1, #0xce60
a018a6d8 6c2e0ce3 movw r2, #0xce6c
a018a6dc 783703e3 movw r3, #0x3778
a018a6e0 6c104ae3 movt r1, #0xa06c
a018a6e4 1040a0e3 mov r4, #0x10
a018a6e8 6c204ae3 movt r2, #0xa06c
a018a6ec 01eba0e3 mov lr, #0x400
a018a6f0 05314ae3 movt r3, #0xa105
a018a6f4 7d0ba0e3 mov r0, #0x1f400
a018a6f8 12c0a0e3 mov ip, #0x12
a018a6fc dc80cde5 strb r8, [sp, #0xdc]
a018a700 b240c1e1 strh r4, [r1, #2]
a018a704 b2e0c2e1 strh lr, [r2, #2]
a018a708 040083e5 str r0, [r3, #4]
a018a70c e0008de5 str r0, [sp, #0xe0]
a018a710 b8c0cde5 strb ip, [sp, #0xb8]
a018a714 48ffffea b #0xa018a43c
a018a718 e8070ce3 movw r0, #0xc7e8
a018a71c 55004ae3 movt r0, #0xa055
a018a720 717204eb bl #0xa02a70ec
a018a724 0effffea b #0xa018a364
a018a728 603e0ce3 movw r3, #0xce60
a018a72c 1010a0e3 mov r1, #0x10
a018a730 6c304ae3 movt r3, #0xa06c
a018a734 6c2e0ce3 movw r2, #0xce6c
a018a738 b010c3e1 strh r1, [r3]
a018a73c 6c204ae3 movt r2, #0xa06c
a018a740 011ba0e3 mov r1, #0x400
a018a744 783703e3 movw r3, #0x3778
a018a748 b010c2e1 strh r1, [r2]
a018a74c 05314ae3 movt r3, #0xa105
a018a750 7d2ba0e3 mov r2, #0x1f400
a018a754 1110a0e3 mov r1, #0x11
a018a758 dc80cde5 strb r8, [sp, #0xdc]
a018a75c 002083e5 str r2, [r3]
a018a760 e0208de5 str r2, [sp, #0xe0]
a018a764 b810cde5 strb r1, [sp, #0xb8]
a018a768 aafdffea b #0xa0189e18
a018a76c 601e0ce3 movw r1, #0xce60
a018a770 6c2e0ce3 movw r2, #0xce6c
a018a774 783703e3 movw r3, #0x3778
a018a778 6c104ae3 movt r1, #0xa06c
a018a77c 1040a0e3 mov r4, #0x10
a018a780 6c204ae3 movt r2, #0xa06c
a018a784 01eba0e3 mov lr, #0x400
a018a788 05314ae3 movt r3, #0xa105
a018a78c 7d0ba0e3 mov r0, #0x1f400
a018a790 11c0a0e3 mov ip, #0x11
a018a794 dc80cde5 strb r8, [sp, #0xdc]
a018a798 b040c1e1 strh r4, [r1]
a018a79c b0e0c2e1 strh lr, [r2]
a018a7a0 000083e5 str r0, [r3]
a018a7a4 e0008de5 str r0, [sp, #0xe0]
a018a7a8 b8c0cde5 strb ip, [sp, #0xb8]
a018a7ac e8fcffea b #0xa0189b54
a018a7b0 601e0ce3 movw r1, #0xce60
a018a7b4 6c2e0ce3 movw r2, #0xce6c
a018a7b8 783703e3 movw r3, #0x3778
a018a7bc 6c104ae3 movt r1, #0xa06c
a018a7c0 1040a0e3 mov r4, #0x10
a018a7c4 6c204ae3 movt r2, #0xa06c
a018a7c8 01eba0e3 mov lr, #0x400
a018a7cc 05314ae3 movt r3, #0xa105
a018a7d0 7d0ba0e3 mov r0, #0x1f400
a018a7d4 12c0a0e3 mov ip, #0x12
a018a7d8 edffffea b #0xa018a794
a018a7dc 603e0ce3 movw r3, #0xce60
a018a7e0 1010a0e3 mov r1, #0x10
a018a7e4 6c304ae3 movt r3, #0xa06c
a018a7e8 6c2e0ce3 movw r2, #0xce6c
a018a7ec b010c3e1 strh r1, [r3]
a018a7f0 6c204ae3 movt r2, #0xa06c
a018a7f4 011ba0e3 mov r1, #0x400
a018a7f8 783703e3 movw r3, #0x3778
a018a7fc b010c2e1 strh r1, [r2]
a018a800 05314ae3 movt r3, #0xa105
a018a804 7d2ba0e3 mov r2, #0x1f400
a018a808 1210a0e3 mov r1, #0x12
a018a80c dc80cde5 strb r8, [sp, #0xdc]
a018a810 002083e5 str r2, [r3]
a018a814 e0208de5 str r2, [sp, #0xe0]
a018a818 b810cde5 strb r1, [sp, #0xb8]
a018a81c 7dfdffea b #0xa0189e18
a018a820 1060a0e3 mov r6, #0x10
a018a824 015ba0e3 mov r5, #0x400
a018a828 2c608de5 str r6, [sp, #0x2c]
a018a82c 60ee0ce3 movw lr, #0xce60
a018a830 34508de5 str r5, [sp, #0x34]
a018a834 6ce04ae3 movt lr, #0xa06c
a018a838 070094e8 ldm r4, {r0, r1, r2}
a018a83c 6cce0ce3 movw ip, #0xce6c
a018a840 6cc04ae3 movt ip, #0xa06c
a018a844 4e3f8de2 add r3, sp, #0x138
a018a848 b260cee1 strh r6, [lr, #2]
a018a84c 00e0a0e3 mov lr, #0
a018a850 b250cce1 strh r5, [ip, #2]
a018a854 070083e8 stm r3, {r0, r1, r2}
a018a858 14e1cde5 strb lr, [sp, #0x114]
a018a85c f6feffea b #0xa018a43c
a018a860 2030a0e3 mov r3, #0x20
a018a864 200207e3 movw r0, #0x7220
a018a868 00308de5 str r3, [sp]
a018a86c 6c1703e3 movw r1, #0x376c
a018a870 18309de5 ldr r3, [sp, #0x18]
a018a874 742603e3 movw r2, #0x3674
a018a878 fe004ae3 movt r0, #0xa0fe
a018a87c 05114ae3 movt r1, #0xa105
a018a880 05214ae3 movt r2, #0xa105
a018a884 8330a0e1 lsl r3, r3, #1
a018a888 d23f04eb bl #0xa029a7d8
a018a88c 000050e3 cmp r0, #0
a018a890 c100001a bne #0xa018ab9c
a018a894 002095e5 ldr r2, [r5]
a018a898 ec350ee3 movw r3, #0xe5ec
a018a89c 04314ae3 movt r3, #0xa104
a018a8a0 002083e5 str r2, [r3]
a018a8a4 9bfdffea b #0xa0189f18
a018a8a8 2030a0e3 mov r3, #0x20
a018a8ac 200207e3 movw r0, #0x7220
a018a8b0 742603e3 movw r2, #0x3674
a018a8b4 00308de5 str r3, [sp]
a018a8b8 fe004ae3 movt r0, #0xa0fe
a018a8bc 05214ae3 movt r2, #0xa105
a018a8c0 0510a0e1 mov r1, r5
a018a8c4 0b30a0e1 mov r3, fp
a018a8c8 c23f04eb bl #0xa029a7d8
a018a8cc 000050e3 cmp r0, #0
a018a8d0 c100001a bne #0xa018abdc
a018a8d4 003095e5 ldr r3, [r5]
a018a8d8 ec650ee3 movw r6, #0xe5ec
a018a8dc 04614ae3 movt r6, #0xa104
a018a8e0 003086e5 str r3, [r6]
a018a8e4 defcffea b #0xa0189c64
a018a8e8 2010a0e3 mov r1, #0x20
a018a8ec 140107e3 movw r0, #0x7114
a018a8f0 802603e3 movw r2, #0x3680
a018a8f4 20320ee3 movw r3, #0xe220
a018a8f8 00108de5 str r1, [sp]
a018a8fc fd004ae3 movt r0, #0xa0fd
a018a900 05214ae3 movt r2, #0xa105
a018a904 023040e3 movt r3, #2
a018a908 0710a0e1 mov r1, r7
a018a90c b13f04eb bl #0xa029a7d8
a018a910 000050e3 cmp r0, #0
a018a914 a800001a bne #0xa018abbc
a018a918 003097e5 ldr r3, [r7]
a018a91c 001095e5 ldr r1, [r5]
a018a920 8cfdffea b #0xa0189f58
a018a924 2010a0e3 mov r1, #0x20
a018a928 140107e3 movw r0, #0x7114
a018a92c 802603e3 movw r2, #0x3680
a018a930 20320ee3 movw r3, #0xe220
a018a934 00108de5 str r1, [sp]
a018a938 fd004ae3 movt r0, #0xa0fd
a018a93c 05214ae3 movt r2, #0xa105
a018a940 023040e3 movt r3, #2
a018a944 0710a0e1 mov r1, r7
a018a948 a23f04eb bl #0xa029a7d8
a018a94c 000050e3 cmp r0, #0
a018a950 a500001a bne #0xa018abec
a018a954 003097e5 ldr r3, [r7]
a018a958 001095e5 ldr r1, [r5]
a018a95c d0fcffea b #0xa0189ca4
a018a960 2030a0e3 mov r3, #0x20
a018a964 140107e3 movw r0, #0x7114
a018a968 24260ee3 movw r2, #0xe624
a018a96c 00308de5 str r3, [sp]
a018a970 fd004ae3 movt r0, #0xa0fd
a018a974 04214ae3 movt r2, #0xa104
a018a978 0510a0e1 mov r1, r5
a018a97c 7639a0e3 mov r3, #0x1d8000
a018a980 943f04eb bl #0xa029a7d8
a018a984 000050e3 cmp r0, #0
a018a988 8700001a bne #0xa018abac
a018a98c 001095e5 ldr r1, [r5]
a018a990 68fdffea b #0xa0189f38
a018a994 2030a0e3 mov r3, #0x20
a018a998 140107e3 movw r0, #0x7114
a018a99c 24260ee3 movw r2, #0xe624
a018a9a0 00308de5 str r3, [sp]
a018a9a4 fd004ae3 movt r0, #0xa0fd
a018a9a8 04214ae3 movt r2, #0xa104
a018a9ac 0510a0e1 mov r1, r5
a018a9b0 7639a0e3 mov r3, #0x1d8000
a018a9b4 873f04eb bl #0xa029a7d8
a018a9b8 000050e3 cmp r0, #0
a018a9bc 8200001a bne #0xa018abcc
a018a9c0 001095e5 ldr r1, [r5]
a018a9c4 aefcffea b #0xa0189c84
a018a9c8 2030a0e3 mov r3, #0x20
a018a9cc 140107e3 movw r0, #0x7114
a018a9d0 34260ee3 movw r2, #0xe634
a018a9d4 00308de5 str r3, [sp]
a018a9d8 fd004ae3 movt r0, #0xa0fd
a018a9dc 04214ae3 movt r2, #0xa104
a018a9e0 0710a0e1 mov r1, r7
a018a9e4 18309de5 ldr r3, [sp, #0x18]
a018a9e8 7a3f04eb bl #0xa029a7d8
a018a9ec 000050e3 cmp r0, #0
a018a9f0 6500001a bne #0xa018ab8c
a018a9f4 003097e5 ldr r3, [r7]
a018a9f8 708703e3 movw r8, #0x3770
a018a9fc 05814ae3 movt r8, #0xa105
a018aa00 003088e5 str r3, [r8]
a018aa04 8ffcffea b #0xa0189c48
a018aa08 602e0ce3 movw r2, #0xce60
a018aa0c 1010a0e3 mov r1, #0x10
a018aa10 6c204ae3 movt r2, #0xa06c
a018aa14 6c3e0ce3 movw r3, #0xce6c
a018aa18 b010c2e1 strh r1, [r2]
a018aa1c 6c304ae3 movt r3, #0xa06c
a018aa20 022ba0e3 mov r2, #0x800
a018aa24 2010a0e3 mov r1, #0x20
a018aa28 b020c3e1 strh r2, [r3]
a018aa2c dc208de5 str r2, [sp, #0xdc]
a018aa30 b810cde5 strb r1, [sp, #0xb8]
a018aa34 f7fcffea b #0xa0189e18
a018aa38 602e0ce3 movw r2, #0xce60
a018aa3c 6c3e0ce3 movw r3, #0xce6c
a018aa40 021ba0e3 mov r1, #0x800
a018aa44 6c204ae3 movt r2, #0xa06c
a018aa48 10c0a0e3 mov ip, #0x10
a018aa4c 6c304ae3 movt r3, #0xa06c
a018aa50 2000a0e3 mov r0, #0x20
a018aa54 b0c0c2e1 strh ip, [r2]
a018aa58 b010c3e1 strh r1, [r3]
a018aa5c dc108de5 str r1, [sp, #0xdc]
a018aa60 b800cde5 strb r0, [sp, #0xb8]
a018aa64 3afcffea b #0xa0189b54
a018aa68 601e0ce3 movw r1, #0xce60
a018aa6c 6c2e0ce3 movw r2, #0xce6c
a018aa70 783703e3 movw r3, #0x3778
a018aa74 6c104ae3 movt r1, #0xa06c
a018aa78 1040a0e3 mov r4, #0x10
a018aa7c 6c204ae3 movt r2, #0xa06c
a018aa80 01eba0e3 mov lr, #0x400
a018aa84 05314ae3 movt r3, #0xa105
a018aa88 7d0ba0e3 mov r0, #0x1f400
a018aa8c 11c0a0e3 mov ip, #0x11
a018aa90 19ffffea b #0xa018a6fc
a018aa94 2010a0e3 mov r1, #0x20
a018aa98 140107e3 movw r0, #0x7114
a018aa9c e8250ee3 movw r2, #0xe5e8
a018aaa0 20320ee3 movw r3, #0xe220
a018aaa4 00108de5 str r1, [sp]
a018aaa8 fd004ae3 movt r0, #0xa0fd
a018aaac 04214ae3 movt r2, #0xa104
a018aab0 023040e3 movt r3, #2
a018aab4 0710a0e1 mov r1, r7
a018aab8 463f04eb bl #0xa029a7d8
a018aabc 000050e3 cmp r0, #0
a018aac0 6c00001a bne #0xa018ac78
a018aac4 00c097e5 ldr ip, [r7]
a018aac8 001095e5 ldr r1, [r5]
a018aacc 3dfdffea b #0xa0189fc8
a018aad0 2030a0e3 mov r3, #0x20
a018aad4 140107e3 movw r0, #0x7114
a018aad8 b42703e3 movw r2, #0x37b4
a018aadc 00308de5 str r3, [sp]
a018aae0 fd004ae3 movt r0, #0xa0fd
a018aae4 05214ae3 movt r2, #0xa105
a018aae8 0510a0e1 mov r1, r5
a018aaec 7639a0e3 mov r3, #0x1d8000
a018aaf0 383f04eb bl #0xa029a7d8
a018aaf4 000050e3 cmp r0, #0
a018aaf8 6200001a bne #0xa018ac88
a018aafc 001095e5 ldr r1, [r5]
a018ab00 28fdffea b #0xa0189fa8
a018ab04 602e0ce3 movw r2, #0xce60
a018ab08 1010a0e3 mov r1, #0x10
a018ab0c 6c204ae3 movt r2, #0xa06c
a018ab10 6c3e0ce3 movw r3, #0xce6c
a018ab14 b010c2e1 strh r1, [r2]
a018ab18 6c304ae3 movt r3, #0xa06c
a018ab1c 011ba0e3 mov r1, #0x400
a018ab20 4020a0e3 mov r2, #0x40
a018ab24 b010c3e1 strh r1, [r3]
a018ab28 b820cde5 strb r2, [sp, #0xb8]
a018ab2c b9fcffea b #0xa0189e18
a018ab30 602e0ce3 movw r2, #0xce60
a018ab34 6c3e0ce3 movw r3, #0xce6c
a018ab38 6c204ae3 movt r2, #0xa06c
a018ab3c 10c0a0e3 mov ip, #0x10
a018ab40 6c304ae3 movt r3, #0xa06c
a018ab44 010ba0e3 mov r0, #0x400
a018ab48 4010a0e3 mov r1, #0x40
a018ab4c b0c0c2e1 strh ip, [r2]
a018ab50 b000c3e1 strh r0, [r3]
a018ab54 b810cde5 strb r1, [sp, #0xb8]
a018ab58 fdfbffea b #0xa0189b54
a018ab5c 602e0ce3 movw r2, #0xce60
a018ab60 6c3e0ce3 movw r3, #0xce6c
a018ab64 021ba0e3 mov r1, #0x800
a018ab68 6c204ae3 movt r2, #0xa06c
a018ab6c 10c0a0e3 mov ip, #0x10
a018ab70 6c304ae3 movt r3, #0xa06c
a018ab74 2000a0e3 mov r0, #0x20
a018ab78 b2c0c2e1 strh ip, [r2, #2]
a018ab7c b210c3e1 strh r1, [r3, #2]
a018ab80 dc108de5 str r1, [sp, #0xdc]
a018ab84 b800cde5 strb r0, [sp, #0xb8]
a018ab88 2bfeffea b #0xa018a43c
a018ab8c e8070ce3 movw r0, #0xc7e8
a018ab90 55004ae3 movt r0, #0xa055
a018ab94 547104eb bl #0xa02a70ec
a018ab98 95ffffea b #0xa018a9f4
a018ab9c 10080ce3 movw r0, #0xc810
a018aba0 55004ae3 movt r0, #0xa055
a018aba4 507104eb bl #0xa02a70ec
a018aba8 39ffffea b #0xa018a894
a018abac 38080ce3 movw r0, #0xc838
a018abb0 55004ae3 movt r0, #0xa055
a018abb4 4c7104eb bl #0xa02a70ec
a018abb8 73ffffea b #0xa018a98c
a018abbc 5c080ce3 movw r0, #0xc85c
a018abc0 55004ae3 movt r0, #0xa055
a018abc4 487104eb bl #0xa02a70ec
a018abc8 52ffffea b #0xa018a918
a018abcc 38080ce3 movw r0, #0xc838
a018abd0 55004ae3 movt r0, #0xa055
a018abd4 447104eb bl #0xa02a70ec
a018abd8 78ffffea b #0xa018a9c0
a018abdc 10080ce3 movw r0, #0xc810
a018abe0 55004ae3 movt r0, #0xa055
a018abe4 407104eb bl #0xa02a70ec
a018abe8 39ffffea b #0xa018a8d4
a018abec 5c080ce3 movw r0, #0xc85c
a018abf0 55004ae3 movt r0, #0xa055
a018abf4 3c7104eb bl #0xa02a70ec
a018abf8 55ffffea b #0xa018a954
a018abfc ee5ca0e3 mov r5, #0xee00
a018ac00 78c703e3 movw ip, #0x3778
a018ac04 025040e3 movt r5, #2
a018ac08 05c14ae3 movt ip, #0xa105
a018ac0c 60508de5 str r5, [sp, #0x60]
a018ac10 604e0ce3 movw r4, #0xce60
a018ac14 0f0099e8 ldm sb, {r0, r1, r2, r3}
a018ac18 6cee0ce3 movw lr, #0xce6c
a018ac1c 6c404ae3 movt r4, #0xa06c
a018ac20 6ce04ae3 movt lr, #0xa06c
a018ac24 04508ce5 str r5, [ip, #4]
a018ac28 dcc08de2 add ip, sp, #0xdc
a018ac2c 1060a0e3 mov r6, #0x10
a018ac30 065ca0e3 mov r5, #0x600
a018ac34 0f008ce8 stm ip, {r0, r1, r2, r3}
a018ac38 3030a0e3 mov r3, #0x30
a018ac3c b260c4e1 strh r6, [r4, #2]
a018ac40 b250cee1 strh r5, [lr, #2]
a018ac44 b830cde5 strb r3, [sp, #0xb8]
a018ac48 fbfdffea b #0xa018a43c
a018ac4c 602e0ce3 movw r2, #0xce60
a018ac50 6c3e0ce3 movw r3, #0xce6c
a018ac54 6c204ae3 movt r2, #0xa06c
a018ac58 10c0a0e3 mov ip, #0x10
a018ac5c 6c304ae3 movt r3, #0xa06c
a018ac60 010ba0e3 mov r0, #0x400
a018ac64 4010a0e3 mov r1, #0x40
a018ac68 b2c0c2e1 strh ip, [r2, #2]
a018ac6c b200c3e1 strh r0, [r3, #2]
a018ac70 b810cde5 strb r1, [sp, #0xb8]
a018ac74 f0fdffea b #0xa018a43c
a018ac78 5c080ce3 movw r0, #0xc85c
a018ac7c 55004ae3 movt r0, #0xa055
a018ac80 197104eb bl #0xa02a70ec
a018ac84 8effffea b #0xa018aac4
a018ac88 38080ce3 movw r0, #0xc838
a018ac8c 55004ae3 movt r0, #0xa055
a018ac90 157104eb bl #0xa02a70ec
a018ac94 98ffffea b #0xa018aafc
a018ac98 708703e3 movw r8, #0x3770
a018ac9c 05514ae3 movt r5, #0xa105
a018aca0 05814ae3 movt r8, #0xa105
a018aca4 a2fdffea b #0xa018a334
