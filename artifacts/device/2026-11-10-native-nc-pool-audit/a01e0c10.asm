a01e0c10 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01e0c14 070050e3 cmp r0, #7
a01e0c18 86de4de2 sub sp, sp, #0x860
a01e0c1c 0cd04de2 sub sp, sp, #0xc
a01e0c20 90889de5 ldr r8, [sp, #0x890]
a01e0c24 2f01001a bne #0xa01e10e8
a01e0c28 0160a0e1 mov r6, r1
a01e0c2c 040091e5 ldr r0, [r1, #4]
a01e0c30 0250a0e1 mov r5, r2
a01e0c34 0340a0e1 mov r4, r3
a01e0c38 985c0cfa blx #0xa04f7ea0
a01e0c3c 0030a0e3 mov r3, #0
a01e0c40 0090a0e1 mov sb, r0
a01e0c44 080096e5 ldr r0, [r6, #8]
a01e0c48 4430cde5 strb r3, [sp, #0x44]
a01e0c4c 935c0cfa blx #0xa04f7ea0
a01e0c50 020050e3 cmp r0, #2
a01e0c54 0010a0e1 mov r1, r0
a01e0c58 48008de5 str r0, [sp, #0x48]
a01e0c5c 3201008a bhi #0xa01e112c
a01e0c60 0c0096e5 ldr r0, [r6, #0xc]
a01e0c64 8d5c0cfa blx #0xa04f7ea0
a01e0c68 70a0efe6 uxtb sl, r0
a01e0c6c 100096e5 ldr r0, [r6, #0x10]
a01e0c70 8a5c0cfa blx #0xa04f7ea0
a01e0c74 0070a0e1 mov r7, r0
a01e0c78 140096e5 ldr r0, [r6, #0x14]
a01e0c7c 875c0cfa blx #0xa04f7ea0
a01e0c80 00005ae3 cmp sl, #0
a01e0c84 b000000a beq #0xa01e0f4c
a01e0c88 01005ae3 cmp sl, #1
a01e0c8c 4001001a bne #0xa01e1194
a01e0c90 7770efe6 uxtb r7, r7
a01e0c94 1e0057e3 cmp r7, #0x1e
a01e0c98 7b01008a bhi #0xa01e128c
a01e0c9c 7030efe6 uxtb r3, r0
a01e0ca0 1e0053e3 cmp r3, #0x1e
a01e0ca4 5601008a bhi #0xa01e1204
a01e0ca8 7070afe6 sxtb r7, r0
a01e0cac 68a08de2 add sl, sp, #0x68
a01e0cb0 46be8de2 add fp, sp, #0x460
a01e0cb4 0710a0e1 mov r1, r7
a01e0cb8 012ba0e3 mov r2, #0x400
a01e0cbc 0a00a0e1 mov r0, sl
a01e0cc0 08b08be2 add fp, fp, #8
a01e0cc4 48600cfa blx #0xa04f8dec
a01e0cc8 0710a0e1 mov r1, r7
a01e0ccc 0b00a0e1 mov r0, fp
a01e0cd0 012ba0e3 mov r2, #0x400
a01e0cd4 44600cfa blx #0xa04f8dec
a01e0cd8 180096e5 ldr r0, [r6, #0x18]
a01e0cdc 4ca08de5 str sl, [sp, #0x4c]
a01e0ce0 50b08de5 str fp, [sp, #0x50]
a01e0ce4 6d5c0cfa blx #0xa04f7ea0
a01e0ce8 4410dde5 ldrb r1, [sp, #0x44]
a01e0cec 0020a0e1 mov r2, r0
a01e0cf0 54008de5 str r0, [sp, #0x54]
a01e0cf4 020051e3 cmp r1, #2
a01e0cf8 5a01008a bhi #0xa01e1268
a01e0cfc 48309de5 ldr r3, [sp, #0x48]
a01e0d00 020053e3 cmp r3, #2
a01e0d04 5b01008a bhi #0xa01e1278
a01e0d08 000051e3 cmp r1, #0
a01e0d0c 8600001a bne #0xa01e0f2c
a01e0d10 4c009de5 ldr r0, [sp, #0x4c]
a01e0d14 000050e3 cmp r0, #0
a01e0d18 7401000a beq #0xa01e12f0
a01e0d1c 50009de5 ldr r0, [sp, #0x50]
a01e0d20 000050e3 cmp r0, #0
a01e0d24 7101000a beq #0xa01e12f0
a01e0d28 010053e3 cmp r3, #1
a01e0d2c bd00000a beq #0xa01e1028
a01e0d30 000053e3 cmp r3, #0
a01e0d34 207098e5 ldr r7, [r8, #0x20]
a01e0d38 0c108de5 str r1, [sp, #0xc]
a01e0d3c e500000a beq #0xa01e10d8
a01e0d40 020053e3 cmp r3, #2
a01e0d44 0e01000a beq #0xa01e1184
a01e0d48 866e8de2 add r6, sp, #0x860
a01e0d4c 803b0be3 movw r3, #0xbb80
a01e0d50 086086e2 add r6, r6, #8
a01e0d54 00c0a0e3 mov ip, #0
a01e0d58 403826e5 str r3, [r6, #-0x840]!
a01e0d5c 0210a0e3 mov r1, #2
a01e0d60 1020a0e3 mov r2, #0x10
a01e0d64 013ba0e3 mov r3, #0x400
a01e0d68 0600a0e1 mov r0, r6
a01e0d6c 38c08de5 str ip, [sp, #0x38]
a01e0d70 2c108de5 str r1, [sp, #0x2c]
a01e0d74 34208de5 str r2, [sp, #0x34]
a01e0d78 30308de5 str r3, [sp, #0x30]
a01e0d7c edc202eb bl #0xa0291938
a01e0d80 032080e2 add r2, r0, #3
a01e0d84 140107e3 movw r0, #0x7114
a01e0d88 0320c2e3 bic r2, r2, #3
a01e0d8c 08108de2 add r1, sp, #8
a01e0d90 102082e2 add r2, r2, #0x10
a01e0d94 fd004ae3 movt r0, #0xa0fd
a01e0d98 8220a0e1 lsl r2, r2, #1
a01e0d9c 6430a0e3 mov r3, #0x64
a01e0da0 4d6e07eb bl #0xa03bc6dc
a01e0da4 000050e3 cmp r0, #0
a01e0da8 ae00001a bne #0xa01e1068
a01e0dac 0600a0e1 mov r0, r6
a01e0db0 12c302eb bl #0xa0291a00
a01e0db4 072080e2 add r2, r0, #7
a01e0db8 200207e3 movw r0, #0x7220
a01e0dbc 0720c2e3 bic r2, r2, #7
a01e0dc0 04108de2 add r1, sp, #4
a01e0dc4 102082e2 add r2, r2, #0x10
a01e0dc8 fe004ae3 movt r0, #0xa0fe
a01e0dcc 8220a0e1 lsl r2, r2, #1
a01e0dd0 6430a0e3 mov r3, #0x64
a01e0dd4 406e07eb bl #0xa03bc6dc
a01e0dd8 000050e3 cmp r0, #0
a01e0ddc 9d00001a bne #0xa01e1058
a01e0de0 0620a0e1 mov r2, r6
a01e0de4 04109de5 ldr r1, [sp, #4]
a01e0de8 08009de5 ldr r0, [sp, #8]
a01e0dec 24fd09eb bl #0xa0460284
a01e0df0 4c020ce3 movw r0, #0xc24c
a01e0df4 57004ae3 movt r0, #0xa057
a01e0df8 bb1803eb bl #0xa02a70ec
a01e0dfc 01ba02eb bl #0xa028f608
a01e0e00 032080e2 add r2, r0, #3
a01e0e04 140107e3 movw r0, #0x7114
a01e0e08 0320c2e3 bic r2, r2, #3
a01e0e0c fd004ae3 movt r0, #0xa0fd
a01e0e10 0c108de2 add r1, sp, #0xc
a01e0e14 6430a0e3 mov r3, #0x64
a01e0e18 2f6e07eb bl #0xa03bc6dc
a01e0e1c 000050e3 cmp r0, #0
a01e0e20 8800001a bne #0xa01e1048
a01e0e24 0c209de5 ldr r2, [sp, #0xc]
a01e0e28 7c3003e3 movw r3, #0x307c
a01e0e2c 6f304ae3 movt r3, #0xa06f
a01e0e30 d0060ce3 movw r0, #0xc6d0
a01e0e34 041093e5 ldr r1, [r3, #4]
a01e0e38 57004ae3 movt r0, #0xa057
a01e0e3c 58208de5 str r2, [sp, #0x58]
a01e0e40 a91803eb bl #0xa02a70ec
a01e0e44 48309de5 ldr r3, [sp, #0x48]
a01e0e48 0220d3e3 bics r2, r3, #2
a01e0e4c 8900000a beq #0xa01e1078
a01e0e50 010053e3 cmp r3, #1
a01e0e54 ab00000a beq #0xa01e1108
a01e0e58 b8690be3 movw r6, #0xb9b8
a01e0e5c 29614ae3 movt r6, #0xa129
a01e0e60 04009de5 ldr r0, [sp, #4]
a01e0e64 2a6e07eb bl #0xa03bc714
a01e0e68 08009de5 ldr r0, [sp, #8]
a01e0e6c 286e07eb bl #0xa03bc714
a01e0e70 0c009de5 ldr r0, [sp, #0xc]
a01e0e74 266e07eb bl #0xa03bc714
a01e0e78 b4190be3 movw r1, #0xb9b4
a01e0e7c b0390be3 movw r3, #0xb9b0
a01e0e80 0020a0e3 mov r2, #0
a01e0e84 29114ae3 movt r1, #0xa129
a01e0e88 29314ae3 movt r3, #0xa129
a01e0e8c 002081e5 str r2, [r1]
a01e0e90 002086e5 str r2, [r6]
a01e0e94 002083e5 str r2, [r3]
a01e0e98 b9fd09eb bl #0xa0460584
a01e0e9c f0c60ce3 movw ip, #0xc6f0
a01e0ea0 ff7505e3 movw r7, #0x55ff
a01e0ea4 57c04ae3 movt ip, #0xa057
a01e0ea8 0760a0e1 mov r6, r7
a01e0eac 0f00bce8 ldm ip!, {r0, r1, r2, r3}
a01e0eb0 738ea0e3 mov r8, #0x730
a01e0eb4 00e0a0e3 mov lr, #0
a01e0eb8 1778dfe7 bfi r7, r7, #0x10, #0x10
a01e0ebc 138042e3 movt r8, #0x2013
a01e0ec0 1668dfe7 bfi r6, r6, #0x10, #0x10
a01e0ec4 047084e5 str r7, [r4, #4]
a01e0ec8 0e70a0e1 mov r7, lr
a01e0ecc 008084e5 str r8, [r4]
a01e0ed0 086084e5 str r6, [r4, #8]
a01e0ed4 0ce084e5 str lr, [r4, #0xc]
a01e0ed8 10e084e5 str lr, [r4, #0x10]
a01e0edc 14e084e5 str lr, [r4, #0x14]
a01e0ee0 18e084e5 str lr, [r4, #0x18]
a01e0ee4 1ce084e5 str lr, [r4, #0x1c]
a01e0ee8 20e084e5 str lr, [r4, #0x20]
a01e0eec 24e084e5 str lr, [r4, #0x24]
a01e0ef0 000085e5 str r0, [r5]
a01e0ef4 041085e5 str r1, [r5, #4]
a01e0ef8 0300bce8 ldm ip!, {r0, r1}
a01e0efc 082085e5 str r2, [r5, #8]
a01e0f00 0c3085e5 str r3, [r5, #0xc]
a01e0f04 b020dce1 ldrh r2, [ip]
a01e0f08 0230dce5 ldrb r3, [ip, #2]
a01e0f0c 100085e5 str r0, [r5, #0x10]
a01e0f10 141085e5 str r1, [r5, #0x14]
a01e0f14 b821c5e1 strh r2, [r5, #0x18]
a01e0f18 1a30c5e5 strb r3, [r5, #0x1a]
a01e0f1c 0700a0e1 mov r0, r7
a01e0f20 86de8de2 add sp, sp, #0x860
a01e0f24 0cd08de2 add sp, sp, #0xc
a01e0f28 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01e0f2c 000053e3 cmp r3, #0
a01e0f30 0020a0e3 mov r2, #0
a01e0f34 207098e5 ldr r7, [r8, #0x20]
a01e0f38 0c208de5 str r2, [sp, #0xc]
a01e0f3c 6500000a beq #0xa01e10d8
a01e0f40 010053e3 cmp r3, #1
a01e0f44 7dffff1a bne #0xa01e0d40
a01e0f48 3a0000ea b #0xa01e1038
a01e0f4c 0cb70ce3 movw fp, #0xc70c
a01e0f50 28708de2 add r7, sp, #0x28
a01e0f54 57b04ae3 movt fp, #0xa057
a01e0f58 28e70ce3 movw lr, #0xc728
a01e0f5c 0f00bbe8 ldm fp!, {r0, r1, r2, r3}
a01e0f60 57e04ae3 movt lr, #0xa057
a01e0f64 0cc08de2 add ip, sp, #0xc
a01e0f68 68a08de2 add sl, sp, #0x68
a01e0f6c 0f00a7e8 stm r7!, {r0, r1, r2, r3}
a01e0f70 07009be8 ldm fp, {r0, r1, r2}
a01e0f74 0300a7e8 stm r7!, {r0, r1}
a01e0f78 b020c7e1 strh r2, [r7]
a01e0f7c 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a01e0f80 0f00ace8 stm ip!, {r0, r1, r2, r3}
a01e0f84 07009ee8 ldm lr, {r0, r1, r2}
a01e0f88 0300ace8 stm ip!, {r0, r1}
a01e0f8c 0a00a0e1 mov r0, sl
a01e0f90 28108de2 add r1, sp, #0x28
a01e0f94 0020cce5 strb r2, [ip]
a01e0f98 b6fdffeb bl #0xa01e0678
a01e0f9c 000050e3 cmp r0, #0
a01e0fa0 d90000ba blt #0xa01e130c
a01e0fa4 46be8de2 add fp, sp, #0x460
a01e0fa8 0c108de2 add r1, sp, #0xc
a01e0fac 08b08be2 add fp, fp, #8
a01e0fb0 0b00a0e1 mov r0, fp
a01e0fb4 affdffeb bl #0xa01e0678
a01e0fb8 000050e3 cmp r0, #0
a01e0fbc 45ffffaa bge #0xa01e0cd8
a01e0fc0 7c3003e3 movw r3, #0x307c
a01e0fc4 a8030ce3 movw r0, #0xc3a8
a01e0fc8 6f304ae3 movt r3, #0xa06f
a01e0fcc 57004ae3 movt r0, #0xa057
a01e0fd0 041093e5 ldr r1, [r3, #4]
a01e0fd4 441803eb bl #0xa02a70ec
a01e0fd8 e0c30ce3 movw ip, #0xc3e0
a01e0fdc 57c04ae3 movt ip, #0xa057
a01e0fe0 20408ce2 add r4, ip, #0x20
a01e0fe4 0ce0a0e1 mov lr, ip
a01e0fe8 105085e2 add r5, r5, #0x10
a01e0fec 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a01e0ff0 10c08ce2 add ip, ip, #0x10
a01e0ff4 04005ee1 cmp lr, r4
a01e0ff8 100005e5 str r0, [r5, #-0x10]
a01e0ffc 0c1005e5 str r1, [r5, #-0xc]
a01e1000 082005e5 str r2, [r5, #-8]
a01e1004 043005e5 str r3, [r5, #-4]
a01e1008 f5ffff1a bne #0xa01e0fe4
a01e100c 0300bce8 ldm ip!, {r0, r1}
a01e1010 0030dce5 ldrb r3, [ip]
a01e1014 000085e5 str r0, [r5]
a01e1018 041085e5 str r1, [r5, #4]
a01e101c 0830c5e5 strb r3, [r5, #8]
a01e1020 0270e0e3 mvn r7, #2
a01e1024 bcffffea b #0xa01e0f1c
a01e1028 010b52e3 cmp r2, #0x400
a01e102c 20709835 ldrlo r7, [r8, #0x20]
a01e1030 0c108d35 strlo r1, [sp, #0xc]
a01e1034 cd00002a bhs #0xa01e1370
a01e1038 18060ce3 movw r0, #0xc618
a01e103c 57004ae3 movt r0, #0xa057
a01e1040 291803eb bl #0xa02a70ec
a01e1044 3fffffea b #0xa01e0d48
a01e1048 98060ce3 movw r0, #0xc698
a01e104c 57004ae3 movt r0, #0xa057
a01e1050 251803eb bl #0xa02a70ec
a01e1054 72ffffea b #0xa01e0e24
a01e1058 10080ce3 movw r0, #0xc810
a01e105c 55004ae3 movt r0, #0xa055
a01e1060 211803eb bl #0xa02a70ec
a01e1064 5dffffea b #0xa01e0de0
a01e1068 e8070ce3 movw r0, #0xc7e8
a01e106c 55004ae3 movt r0, #0xa055
a01e1070 1d1803eb bl #0xa02a70ec
a01e1074 4cffffea b #0xa01e0dac
a01e1078 ec1500e3 movw r1, #0x5ec
a01e107c 44008de2 add r0, sp, #0x44
a01e1080 1e104ae3 movt r1, #0xa01e
a01e1084 d5fc09eb bl #0xa04603e0
a01e1088 fa0fa0e3 mov r0, #0x3e8
a01e108c a36c07eb bl #0xa03bc320
a01e1090 48009de5 ldr r0, [sp, #0x48]
a01e1094 000050e3 cmp r0, #0
a01e1098 b8690b13 movwne r6, #0xb9b8
a01e109c 29614a13 movtne r6, #0xa129
a01e10a0 0a00001a bne #0xa01e10d0
a01e10a4 7990efe6 uxtb sb, sb
a01e10a8 b8690be3 movw r6, #0xb9b8
a01e10ac 29614ae3 movt r6, #0xa129
a01e10b0 890587e0 add r0, r7, sb, lsl #11
a01e10b4 001096e5 ldr r1, [r6]
a01e10b8 022ba0e3 mov r2, #0x800
a01e10bc 100080e2 add r0, r0, #0x10
a01e10c0 6eed02eb bl #0xa029c680
a01e10c4 0130a0e3 mov r3, #1
a01e10c8 0930c7e7 strb r3, [r7, sb]
a01e10cc 48009de5 ldr r0, [sp, #0x48]
a01e10d0 08feffeb bl #0xa01e08f8
a01e10d4 61ffffea b #0xa01e0e60
a01e10d8 e4050ce3 movw r0, #0xc5e4
a01e10dc 57004ae3 movt r0, #0xa057
a01e10e0 011803eb bl #0xa02a70ec
a01e10e4 17ffffea b #0xa01e0d48
a01e10e8 7c3003e3 movw r3, #0x307c
a01e10ec a4020ce3 movw r0, #0xc2a4
a01e10f0 6f304ae3 movt r3, #0xa06f
a01e10f4 57004ae3 movt r0, #0xa057
a01e10f8 041093e5 ldr r1, [r3, #4]
a01e10fc 0a70e0e3 mvn r7, #0xa
a01e1100 f91703eb bl #0xa02a70ec
a01e1104 84ffffea b #0xa01e0f1c
a01e1108 ec1500e3 movw r1, #0x5ec
a01e110c 44008de2 add r0, sp, #0x44
a01e1110 1e104ae3 movt r1, #0xa01e
a01e1114 b8690be3 movw r6, #0xb9b8
a01e1118 b0fc09eb bl #0xa04603e0
a01e111c fa0fa0e3 mov r0, #0x3e8
a01e1120 29614ae3 movt r6, #0xa129
a01e1124 7d6c07eb bl #0xa03bc320
a01e1128 4cffffea b #0xa01e0e60
a01e112c e0020ce3 movw r0, #0xc2e0
a01e1130 57004ae3 movt r0, #0xa057
a01e1134 ec1703eb bl #0xa02a70ec
a01e1138 20e30ce3 movw lr, #0xc320
a01e113c 57e04ae3 movt lr, #0xa057
a01e1140 20408ee2 add r4, lr, #0x20
a01e1144 0ec0a0e1 mov ip, lr
a01e1148 105085e2 add r5, r5, #0x10
a01e114c 0f00bce8 ldm ip!, {r0, r1, r2, r3}
a01e1150 10e08ee2 add lr, lr, #0x10
a01e1154 04005ce1 cmp ip, r4
a01e1158 100005e5 str r0, [r5, #-0x10]
a01e115c 0c1005e5 str r1, [r5, #-0xc]
a01e1160 082005e5 str r2, [r5, #-8]
a01e1164 043005e5 str r3, [r5, #-4]
a01e1168 f5ffff1a bne #0xa01e1144
a01e116c b020dee1 ldrh r2, [lr]
a01e1170 0470e0e3 mvn r7, #4
a01e1174 0230dee5 ldrb r3, [lr, #2]
a01e1178 b020c5e1 strh r2, [r5]
a01e117c 0230c5e5 strb r3, [r5, #2]
a01e1180 65ffffea b #0xa01e0f1c
a01e1184 5c060ce3 movw r0, #0xc65c
a01e1188 57004ae3 movt r0, #0xa057
a01e118c d61703eb bl #0xa02a70ec
a01e1190 ecfeffea b #0xa01e0d48
a01e1194 7c3003e3 movw r3, #0x307c
a01e1198 c4040ce3 movw r0, #0xc4c4
a01e119c 6f304ae3 movt r3, #0xa06f
a01e11a0 57004ae3 movt r0, #0xa057
a01e11a4 041093e5 ldr r1, [r3, #4]
a01e11a8 cf1703eb bl #0xa02a70ec
a01e11ac 0cc50ce3 movw ip, #0xc50c
a01e11b0 57c04ae3 movt ip, #0xa057
a01e11b4 30408ce2 add r4, ip, #0x30
a01e11b8 0ce0a0e1 mov lr, ip
a01e11bc 105085e2 add r5, r5, #0x10
a01e11c0 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a01e11c4 10c08ce2 add ip, ip, #0x10
a01e11c8 04005ee1 cmp lr, r4
a01e11cc 100005e5 str r0, [r5, #-0x10]
a01e11d0 0c1005e5 str r1, [r5, #-0xc]
a01e11d4 082005e5 str r2, [r5, #-8]
a01e11d8 043005e5 str r3, [r5, #-4]
a01e11dc f5ffff1a bne #0xa01e11b8
a01e11e0 0300bce8 ldm ip!, {r0, r1}
a01e11e4 0970e0e3 mvn r7, #9
a01e11e8 b020dce1 ldrh r2, [ip]
a01e11ec 0230dce5 ldrb r3, [ip, #2]
a01e11f0 000085e5 str r0, [r5]
a01e11f4 041085e5 str r1, [r5, #4]
a01e11f8 b820c5e1 strh r2, [r5, #8]
a01e11fc 0a30c5e5 strb r3, [r5, #0xa]
a01e1200 45ffffea b #0xa01e0f1c
a01e1204 7c3003e3 movw r3, #0x307c
a01e1208 68040ce3 movw r0, #0xc468
a01e120c 6f304ae3 movt r3, #0xa06f
a01e1210 57004ae3 movt r0, #0xa057
a01e1214 041093e5 ldr r1, [r3, #4]
a01e1218 b31703eb bl #0xa02a70ec
a01e121c 9ce40ce3 movw lr, #0xc49c
a01e1220 57e04ae3 movt lr, #0xa057
a01e1224 20408ee2 add r4, lr, #0x20
a01e1228 0ec0a0e1 mov ip, lr
a01e122c 105085e2 add r5, r5, #0x10
a01e1230 0f00bce8 ldm ip!, {r0, r1, r2, r3}
a01e1234 10e08ee2 add lr, lr, #0x10
a01e1238 04005ce1 cmp ip, r4
a01e123c 100005e5 str r0, [r5, #-0x10]
a01e1240 0c1005e5 str r1, [r5, #-0xc]
a01e1244 082005e5 str r2, [r5, #-8]
a01e1248 043005e5 str r3, [r5, #-4]
a01e124c f5ffff1a bne #0xa01e1228
a01e1250 00009ee5 ldr r0, [lr]
a01e1254 0870e0e3 mvn r7, #8
a01e1258 0430dee5 ldrb r3, [lr, #4]
a01e125c 000085e5 str r0, [r5]
a01e1260 0430c5e5 strb r3, [r5, #4]
a01e1264 2cffffea b #0xa01e0f1c
a01e1268 48050ce3 movw r0, #0xc548
a01e126c 57004ae3 movt r0, #0xa057
a01e1270 9d1703eb bl #0xa02a70ec
a01e1274 08ffffea b #0xa01e0e9c
a01e1278 e0020ce3 movw r0, #0xc2e0
a01e127c 0310a0e1 mov r1, r3
a01e1280 57004ae3 movt r0, #0xa057
a01e1284 981703eb bl #0xa02a70ec
a01e1288 03ffffea b #0xa01e0e9c
a01e128c 7c3003e3 movw r3, #0x307c
a01e1290 0c040ce3 movw r0, #0xc40c
a01e1294 6f304ae3 movt r3, #0xa06f
a01e1298 57004ae3 movt r0, #0xa057
a01e129c 041093e5 ldr r1, [r3, #4]
a01e12a0 911703eb bl #0xa02a70ec
a01e12a4 40e40ce3 movw lr, #0xc440
a01e12a8 57e04ae3 movt lr, #0xa057
a01e12ac 20408ee2 add r4, lr, #0x20
a01e12b0 0ec0a0e1 mov ip, lr
a01e12b4 105085e2 add r5, r5, #0x10
a01e12b8 0f00bce8 ldm ip!, {r0, r1, r2, r3}
a01e12bc 10e08ee2 add lr, lr, #0x10
a01e12c0 04005ce1 cmp ip, r4
a01e12c4 100005e5 str r0, [r5, #-0x10]
a01e12c8 0c1005e5 str r1, [r5, #-0xc]
a01e12cc 082005e5 str r2, [r5, #-8]
a01e12d0 043005e5 str r3, [r5, #-4]
a01e12d4 f5ffff1a bne #0xa01e12b0
a01e12d8 00009ee5 ldr r0, [lr]
a01e12dc 0770e0e3 mvn r7, #7
a01e12e0 b430dee1 ldrh r3, [lr, #4]
a01e12e4 000085e5 str r0, [r5]
a01e12e8 b430c5e1 strh r3, [r5, #4]
a01e12ec 0affffea b #0xa01e0f1c
a01e12f0 7c3003e3 movw r3, #0x307c
a01e12f4 78050ce3 movw r0, #0xc578
a01e12f8 6f304ae3 movt r3, #0xa06f
a01e12fc 57004ae3 movt r0, #0xa057
a01e1300 041093e5 ldr r1, [r3, #4]
a01e1304 781703eb bl #0xa02a70ec
a01e1308 e3feffea b #0xa01e0e9c
a01e130c 7c3003e3 movw r3, #0x307c
a01e1310 44030ce3 movw r0, #0xc344
a01e1314 6f304ae3 movt r3, #0xa06f
a01e1318 57004ae3 movt r0, #0xa057
a01e131c 041093e5 ldr r1, [r3, #4]
a01e1320 711703eb bl #0xa02a70ec
a01e1324 7cc30ce3 movw ip, #0xc37c
a01e1328 57c04ae3 movt ip, #0xa057
a01e132c 20408ce2 add r4, ip, #0x20
a01e1330 0ce0a0e1 mov lr, ip
a01e1334 105085e2 add r5, r5, #0x10
a01e1338 0f00bee8 ldm lr!, {r0, r1, r2, r3}
a01e133c 10c08ce2 add ip, ip, #0x10
a01e1340 04005ee1 cmp lr, r4
a01e1344 100005e5 str r0, [r5, #-0x10]
a01e1348 0c1005e5 str r1, [r5, #-0xc]
a01e134c 082005e5 str r2, [r5, #-8]
a01e1350 043005e5 str r3, [r5, #-4]
a01e1354 f5ffff1a bne #0xa01e1330
a01e1358 0300bce8 ldm ip!, {r0, r1}
a01e135c b030dce1 ldrh r3, [ip]
a01e1360 000085e5 str r0, [r5]
a01e1364 041085e5 str r1, [r5, #4]
a01e1368 b830c5e1 strh r3, [r5, #8]
a01e136c 2bffffea b #0xa01e1020
a01e1370 7c3003e3 movw r3, #0x307c
a01e1374 88050ce3 movw r0, #0xc588
a01e1378 6f304ae3 movt r3, #0xa06f
a01e137c 57004ae3 movt r0, #0xa057
a01e1380 041093e5 ldr r1, [r3, #4]
a01e1384 581703eb bl #0xa02a70ec
a01e1388 c3feffea b #0xa01e0e9c
