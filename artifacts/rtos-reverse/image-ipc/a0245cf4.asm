; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a0245cf4 010050e3 cmp      r0, #1
a0245cf8 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0245cfc 42de4de2 sub      sp, sp, #0x420
a0245d00 0050a0e1 mov      r5, r0
a0245d04 0cd04de2 sub      sp, sp, #0xc
a0245d08 0270a0e1 mov      r7, r2
a0245d0c b700000a beq      #0xa0245ff0
a0245d10 048091e5 ldr      r8, [r1, #4]
a0245d14 0160a0e1 mov      r6, r1
a0245d18 601107e3 movw     r1, #0x7160
a0245d1c 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a7160 'list'
a0245d20 0800a0e1 mov      r0, r8
a0245d24 86ce0afa blx      #0xa04f9744
a0245d28 004050e2 subs     r4, r0, #0
a0245d2c a200000a beq      #0xa0245fbc
a0245d30 681107e3 movw     r1, #0x7168
a0245d34 0800a0e1 mov      r0, r8
a0245d38 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a7168 'svc'
a0245d3c 80ce0afa blx      #0xa04f9744
a0245d40 004050e2 subs     r4, r0, #0
a0245d44 1200001a bne      #0xa0245d94
a0245d48 040055e3 cmp      r5, #4
a0245d4c a000001a bne      #0xa0245fd4
a0245d50 281201e3 movw     r1, #0x1228
a0245d54 080096e5 ldr      r0, [r6, #8]
a0245d58 53104ae3 movt     r1, #0xa053 ; heuristic 0xa0531228 'test'
a0245d5c 78ce0afa blx      #0xa04f9744
a0245d60 000050e3 cmp      r0, #0
a0245d64 0600001a bne      #0xa0245d84
a0245d68 0c3096e5 ldr      r3, [r6, #0xc]
a0245d6c 0030d3e5 ldrb     r3, [r3]
a0245d70 2b0053e3 cmp      r3, #0x2b
a0245d74 0901000a beq      #0xa02461a0
a0245d78 1102a0e3 mov      r0, #0x10000001
a0245d7c 0110a0e3 mov      r1, #1
a0245d80 a51306eb bl       #0xa03cac1c
a0245d84 0400a0e1 mov      r0, r4
a0245d88 42de8de2 add      sp, sp, #0x420
a0245d8c 0cd08de2 add      sp, sp, #0xc
a0245d90 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0245d94 941107e3 movw     r1, #0x7194
a0245d98 0800a0e1 mov      r0, r8
a0245d9c 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a7194 'clnt'
a0245da0 67ce0afa blx      #0xa04f9744
a0245da4 004050e2 subs     r4, r0, #0
a0245da8 6e00001a bne      #0xa0245f68
a0245dac 088096e5 ldr      r8, [r6, #8]
a0245db0 281201e3 movw     r1, #0x1228
a0245db4 53104ae3 movt     r1, #0xa053 ; heuristic 0xa0531228 'test'
a0245db8 0800a0e1 mov      r0, r8
a0245dbc 60ce0afa blx      #0xa04f9744
a0245dc0 000050e3 cmp      r0, #0
a0245dc4 af00000a beq      #0xa0246088
a0245dc8 9c1107e3 movw     r1, #0x719c
a0245dcc 0800a0e1 mov      r0, r8
a0245dd0 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a719c 'exec1'
a0245dd4 5ace0afa blx      #0xa04f9744
a0245dd8 000050e3 cmp      r0, #0
a0245ddc 0500000a beq      #0xa0245df8
a0245de0 a41107e3 movw     r1, #0x71a4
a0245de4 0800a0e1 mov      r0, r8
a0245de8 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a71a4 'exec2'
a0245dec 54ce0afa blx      #0xa04f9744
a0245df0 000050e3 cmp      r0, #0
a0245df4 b000001a bne      #0xa02460bc
a0245df8 1212a0e3 mov      r1, #0x20000001
a0245dfc 0120a0e3 mov      r2, #1
a0245e00 0000a0e3 mov      r0, #0
a0245e04 22fc05eb bl       #0xa03c4e94
a0245e08 10008de5 str      r0, [sp, #0x10]
a0245e0c 6500a0e3 mov      r0, #0x65
a0245e10 301d06eb bl       #0xa03cd2d8
a0245e14 0080a0e1 mov      r8, r0
a0245e18 020ba0e3 mov      r0, #0x800
a0245e1c 2d1d06eb bl       #0xa03cd2d8
a0245e20 0010a0e3 mov      r1, #0
a0245e24 022ba0e3 mov      r2, #0x800
a0245e28 14008de5 str      r0, [sp, #0x14]
a0245e2c eecb0afa blx      #0xa04f8dec
a0245e30 0800a0e1 mov      r0, r8
a0245e34 0c1096e5 ldr      r1, [r6, #0xc]
a0245e38 b0ce0afa blx      #0xa04f9900
a0245e3c 040055e3 cmp      r5, #4
a0245e40 0e0000da ble      #0xa0245e80
a0245e44 18290ce3 movw     r2, #0xc918
a0245e48 0c9086e2 add      sb, r6, #0xc
a0245e4c 5f204ae3 movt     r2, #0xa05f ; heuristic 0xa05fc918 ' '
a0245e50 04b0a0e3 mov      fp, #4
a0245e54 b0a0d2e1 ldrh     sl, [r2]
a0245e58 0800a0e1 mov      r0, r8
a0245e5c 01b08be2 add      fp, fp, #1
a0245e60 e2ce0afa blx      #0xa04f99f0
a0245e64 012080e2 add      r2, r0, #1
a0245e68 b0a088e1 strh     sl, [r8, r0]
a0245e6c 020088e0 add      r0, r8, r2
a0245e70 0410b9e5 ldr      r1, [sb, #4]!
a0245e74 a1ce0afa blx      #0xa04f9900
a0245e78 05005be1 cmp      fp, r5
a0245e7c f5ffff1a bne      #0xa0245e58
a0245e80 10309de5 ldr      r3, [sp, #0x10]
a0245e84 000053e3 cmp      r3, #0
a0245e88 8b00000a beq      #0xa02460bc
a0245e8c 085096e5 ldr      r5, [r6, #8]
a0245e90 281201e3 movw     r1, #0x1228
a0245e94 53104ae3 movt     r1, #0xa053 ; heuristic 0xa0531228 'test'
a0245e98 0500a0e1 mov      r0, r5
a0245e9c 28ce0afa blx      #0xa04f9744
a0245ea0 001050e2 subs     r1, r0, #0
a0245ea4 1d00001a bne      #0xa0245f20
a0245ea8 0c3096e5 ldr      r3, [r6, #0xc]
a0245eac 0030d3e5 ldrb     r3, [r3]
a0245eb0 310053e3 cmp      r3, #0x31
a0245eb4 8400000a beq      #0xa02460cc
a0245eb8 320053e3 cmp      r3, #0x32
a0245ebc 1700001a bne      #0xa0245f20
a0245ec0 781e0fe3 movw     r1, #0xfe78
a0245ec4 20208de2 add      r2, sp, #0x20
a0245ec8 62104ae3 movt     r1, #0xa062 ; heuristic 0xa062fe78 '%d'
a0245ecc 100096e5 ldr      r0, [r6, #0x10]
a0245ed0 72cd0afa blx      #0xa04f94a0
a0245ed4 28908de2 add      sb, sp, #0x28
a0245ed8 20c09de5 ldr      ip, [sp, #0x20]
a0245edc 0410a0e3 mov      r1, #4
a0245ee0 fa3fa0e3 mov      r3, #0x3e8
a0245ee4 0c9049e2 sub      sb, sb, #0xc
a0245ee8 20208de2 add      r2, sp, #0x20
a0245eec 04108de5 str      r1, [sp, #4]
a0245ef0 0210a0e3 mov      r1, #2
a0245ef4 08308de5 str      r3, [sp, #8]
a0245ef8 0830a0e3 mov      r3, #8
a0245efc 00908de5 str      sb, [sp]
a0245f00 10009de5 ldr      r0, [sp, #0x10]
a0245f04 24c08de5 str      ip, [sp, #0x24]
a0245f08 0cfc05eb bl       #0xa03c4f40
a0245f0c c40107e3 movw     r0, #0x71c4
a0245f10 1c109de5 ldr      r1, [sp, #0x1c]
a0245f14 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a71c4 '\treturn value is %d\n'
a0245f18 37ff2fe1 blx      r7
a0245f1c 085096e5 ldr      r5, [r6, #8]
a0245f20 9c1107e3 movw     r1, #0x719c
a0245f24 0500a0e1 mov      r0, r5
a0245f28 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a719c 'exec1'
a0245f2c 04ce0afa blx      #0xa04f9744
a0245f30 006050e2 subs     r6, r0, #0
a0245f34 6900000a beq      #0xa02460e0
a0245f38 a41107e3 movw     r1, #0x71a4
a0245f3c 0500a0e1 mov      r0, r5
a0245f40 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a71a4 'exec2'
a0245f44 fecd0afa blx      #0xa04f9744
a0245f48 000050e3 cmp      r0, #0
a0245f4c 8600000a beq      #0xa024616c
a0245f50 10009de5 ldr      r0, [sp, #0x10]
a0245f54 30fb05eb bl       #0xa03c4c1c
a0245f58 0400a0e1 mov      r0, r4
a0245f5c 42de8de2 add      sp, sp, #0x420
a0245f60 0cd08de2 add      sp, sp, #0xc
a0245f64 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0245f68 7c1d06e3 movw     r1, #0x6d7c
a0245f6c 0800a0e1 mov      r0, r8
a0245f70 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a6d7c 'profile'
a0245f74 f2cd0afa blx      #0xa04f9744
a0245f78 004050e2 subs     r4, r0, #0
a0245f7c 4800001a bne      #0xa02460a4
a0245f80 085096e5 ldr      r5, [r6, #8]
a0245f84 a41100e3 movw     r1, #0x1a4
a0245f88 59104ae3 movt     r1, #0xa059 ; heuristic 0xa05901a4 'start'
a0245f8c 0500a0e1 mov      r0, r5
a0245f90 ebcd0afa blx      #0xa04f9744
a0245f94 000050e3 cmp      r0, #0
a0245f98 a300000a beq      #0xa024622c
a0245f9c 781f0be3 movw     r1, #0xbf78
a0245fa0 0500a0e1 mov      r0, r5
a0245fa4 56104ae3 movt     r1, #0xa056 ; heuristic 0xa056bf78 'stop'
a0245fa8 e5cd0afa blx      #0xa04f9744
a0245fac 000050e3 cmp      r0, #0
a0245fb0 73ffff1a bne      #0xa0245d84
a0245fb4 bd0a06eb bl       #0xa03c8ab0
a0245fb8 71ffffea b        #0xa0245d84
a0245fbc 0700a0e1 mov      r0, r7
a0245fc0 a11206eb bl       #0xa03caa4c
a0245fc4 0400a0e1 mov      r0, r4
a0245fc8 42de8de2 add      sp, sp, #0x420
a0245fcc 0cd08de2 add      sp, sp, #0xc
a0245fd0 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0245fd4 6c0107e3 movw     r0, #0x716c
a0245fd8 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a716c 'invalid input for svc\n'
a0245fdc 37ff2fe1 blx      r7
a0245fe0 0400a0e1 mov      r0, r4
a0245fe4 42de8de2 add      sp, sp, #0x420
a0245fe8 0cd08de2 add      sp, sp, #0xc
a0245fec f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0245ff0 a80d06e3 movw     r0, #0x6da8
a0245ff4 0540a0e1 mov      r4, r5
a0245ff8 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a6da8 'supported test commands\n'
a0245ffc 32ff2fe1 blx      r2
a0246000 480f06e3 movw     r0, #0x6f48
a0246004 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a6f48 '    rpc list:    list registered program\n'
a0246008 37ff2fe1 blx      r7
a024600c 740f06e3 movw     r0, #0x6f74
a0246010 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a6f74 '    rpc svc [prog_name] +: register program\n'
a0246014 37ff2fe1 blx      r7
a0246018 a40f06e3 movw     r0, #0x6fa4
a024601c 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a6fa4 '    rpc svc [prog_name] -: unregister program\n'
a0246020 37ff2fe1 blx      r7
a0246024 d40f06e3 movw     r0, #0x6fd4
a0246028 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a6fd4 '             supported programs: test (test rpc program)\n'
a024602c 37ff2fe1 blx      r7
a0246030 100007e3 movw     r0, #0x7010
a0246034 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a7010 '                                 exec (execute command in Linux)\n'
a0246038 37ff2fe1 blx      r7
a024603c 540007e3 movw     r0, #0x7054
a0246040 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a7054 '    rpc clnt test 1 str: echo [str]\n'
a0246044 37ff2fe1 blx      r7
a0246048 7c0007e3 movw     r0, #0x707c
a024604c 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a707c '    rpc clnt test 2 a: calulate a+a\n'
a0246050 37ff2fe1 blx      r7
a0246054 a40007e3 movw     r0, #0x70a4
a0246058 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a70a4 '    rpc clnt exec1 [command] (execute command in Linux and return the result)\n'
a024605c 37ff2fe1 blx      r7
a0246060 f40007e3 movw     r0, #0x70f4
a0246064 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a70f4 '    rpc clnt exec2 [command] (execute command in Linux)\n'
a0246068 37ff2fe1 blx      r7
a024606c 300107e3 movw     r0, #0x7130
a0246070 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a7130 '    rpc profile start\n'
a0246074 37ff2fe1 blx      r7
a0246078 480107e3 movw     r0, #0x7148
a024607c 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a7148 '    rpc profile stop\n'
a0246080 37ff2fe1 blx      r7
a0246084 3effffea b        #0xa0245d84
a0246088 3212a0e3 mov      r1, #0x20000003
a024608c 0120a0e3 mov      r2, #1
a0246090 7ffb05eb bl       #0xa03c4e94
a0246094 0480a0e1 mov      r8, r4
a0246098 10008de5 str      r0, [sp, #0x10]
a024609c 14408de5 str      r4, [sp, #0x14]
a02460a0 76ffffea b        #0xa0245e80
a02460a4 000207e3 movw     r0, #0x7200
a02460a8 0810a0e1 mov      r1, r8
a02460ac 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a7200 'unknown  command %s\n'
a02460b0 0040a0e3 mov      r4, #0
a02460b4 37ff2fe1 blx      r7
a02460b8 31ffffea b        #0xa0245d84
a02460bc ac0107e3 movw     r0, #0x71ac
a02460c0 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a71ac 'Client creation failed\n'
a02460c4 37ff2fe1 blx      r7
a02460c8 2dffffea b        #0xa0245d84
a02460cc 100096e5 ldr      r0, [r6, #0x10]
a02460d0 10209de5 ldr      r2, [sp, #0x10]
a02460d4 f6feffeb bl       #0xa0245cb4
a02460d8 085096e5 ldr      r5, [r6, #8]
a02460dc 8fffffea b        #0xa0245f20
a02460e0 0800a0e1 mov      r0, r8
a02460e4 14109de5 ldr      r1, [sp, #0x14]
a02460e8 10209de5 ldr      r2, [sp, #0x10]
a02460ec 250c06eb bl       #0xa03c9188
a02460f0 1c008de5 str      r0, [sp, #0x1c]
a02460f4 0800a0e1 mov      r0, r8
a02460f8 591c06eb bl       #0xa03cd264
a02460fc 1c809de5 ldr      r8, [sp, #0x1c]
a0246100 000058e3 cmp      r8, #0
a0246104 4e00001a bne      #0xa0246244
a0246108 14009de5 ldr      r0, [sp, #0x14]
a024610c 37ce0afa blx      #0xa04f99f0
a0246110 015080e2 add      r5, r0, #1
a0246114 000055e3 cmp      r5, #0
a0246118 14609dc5 ldrgt    r6, [sp, #0x14]
a024611c 28908dc2 addgt    sb, sp, #0x28
a0246120 0e0000da ble      #0xa0246160
a0246124 010b55e3 cmp      r5, #0x400
a0246128 0900a0e1 mov      r0, sb
a024612c 0610a0e1 mov      r1, r6
a0246130 ff2300e3 movw     r2, #0x3ff
a0246134 4a0000da ble      #0xa0246264
a0246138 505901eb bl       #0xa029c680
a024613c 2784cde5 strb     r8, [sp, #0x427]
a0246140 740505e3 movw     r0, #0x5574
a0246144 015b45e2 sub      r5, r5, #0x400
a0246148 63004ae3 movt     r0, #0xa063 ; heuristic 0xa0635574 '%s'
a024614c 0910a0e1 mov      r1, sb
a0246150 37ff2fe1 blx      r7
a0246154 000055e3 cmp      r5, #0
a0246158 016b86e2 add      r6, r6, #0x400
a024615c f0ffffca bgt      #0xa0246124
a0246160 14009de5 ldr      r0, [sp, #0x14]
a0246164 3e1c06eb bl       #0xa03cd264
a0246168 78ffffea b        #0xa0245f50
a024616c 14109de5 ldr      r1, [sp, #0x14]
a0246170 0800a0e1 mov      r0, r8
a0246174 10209de5 ldr      r2, [sp, #0x10]
a0246178 140c06eb bl       #0xa03c91d0
a024617c 000050e3 cmp      r0, #0
a0246180 0010a0e1 mov      r1, r0
a0246184 1c008de5 str      r0, [sp, #0x1c]
a0246188 2900001a bne      #0xa0246234
a024618c 14009de5 ldr      r0, [sp, #0x14]
a0246190 331c06eb bl       #0xa03cd264
a0246194 0800a0e1 mov      r0, r8
a0246198 311c06eb bl       #0xa03cd264
a024619c 6bffffea b        #0xa0245f50
a02461a0 010aa0e3 mov      r0, #0x1000
a02461a4 016aa0e3 mov      r6, #0x1000
a02461a8 4a1c06eb bl       #0xa03cd2d8
a02461ac 0230a0e3 mov      r3, #2
a02461b0 0070a0e1 mov      r7, r0
a02461b4 1000a0e3 mov      r0, #0x10
a02461b8 28308de5 str      r3, [sp, #0x28]
a02461bc 451c06eb bl       #0xa03cd2d8
a02461c0 01c0a0e3 mov      ip, #1
a02461c4 0030a0e1 mov      r3, r0
a02461c8 2c308de5 str      r3, [sp, #0x2c]
a02461cc 6ce605e3 movw     lr, #0x566c
a02461d0 04c083e5 str      ip, [r3, #4]
a02461d4 203605e3 movw     r3, #0x5620
a02461d8 2c109de5 ldr      r1, [sp, #0x2c]
a02461dc 24304ae3 movt     r3, #0xa024
a02461e0 24e04ae3 movt     lr, #0xa024
a02461e4 28508de2 add      r5, sp, #0x28
a02461e8 842107e3 movw     r2, #0x7184
a02461ec 1102a0e3 mov      r0, #0x10000001
a02461f0 0c4081e5 str      r4, [r1, #0xc]
a02461f4 5a204ae3 movt     r2, #0xa05a ; heuristic 0xa05a7184 'test_rpc_svc'
a02461f8 003081e5 str      r3, [r1]
a02461fc 0c10a0e1 mov      r1, ip
a0246200 2c809de5 ldr      r8, [sp, #0x2c]
a0246204 4130a0e3 mov      r3, #0x41
a0246208 08e088e5 str      lr, [r8, #8]
a024620c 00708de5 str      r7, [sp]
a0246210 0cc08de5 str      ip, [sp, #0xc]
a0246214 04608de5 str      r6, [sp, #4]
a0246218 08508de5 str      r5, [sp, #8]
a024621c 241206eb bl       #0xa03caab4
a0246220 2c009de5 ldr      r0, [sp, #0x2c]
a0246224 0e1c06eb bl       #0xa03cd264
a0246228 d5feffea b        #0xa0245d84
a024622c d50906eb bl       #0xa03c8988
a0246230 d3feffea b        #0xa0245d84
a0246234 dc0107e3 movw     r0, #0x71dc
a0246238 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a71dc '\tExecute exec1 failed: status %d\n'
a024623c 37ff2fe1 blx      r7
a0246240 d1ffffea b        #0xa024618c
a0246244 dc0107e3 movw     r0, #0x71dc
a0246248 0810a0e1 mov      r1, r8
a024624c 5a004ae3 movt     r0, #0xa05a ; heuristic 0xa05a71dc '\tExecute exec1 failed: status %d\n'
a0246250 0640a0e1 mov      r4, r6
a0246254 37ff2fe1 blx      r7
a0246258 14009de5 ldr      r0, [sp, #0x14]
a024625c 001c06eb bl       #0xa03cd264
a0246260 c7feffea b        #0xa0245d84
a0246264 0900a0e1 mov      r0, sb
a0246268 0610a0e1 mov      r1, r6
a024626c 0520a0e1 mov      r2, r5
a0246270 025901eb bl       #0xa029c680
a0246274 b1ffffea b        #0xa0246140
a0246278 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a024627c b420a0e3 mov      r2, #0xb4
a0246280 048b2ded vpush    {d8, d9}
a0246284 bbdf4de2 sub      sp, sp, #0x2ec
a0246288 01a0a0e1 mov      sl, r1
a024628c 0140a0e1 mov      r4, r1
a0246290 20008de5 str      r0, [sp, #0x20]
a0246294 0010a0e3 mov      r1, #0
a0246298 34008de2 add      r0, sp, #0x34
a024629c 0370a0e1 mov      r7, r3
a02462a0 046014e4 ldr      r6, [r4], #-4
a02462a4 d0ca0afa blx      #0xa04f8dec
a02462a8 0030a0e3 mov      r3, #0
a02462ac 0207a0e3 mov      r0, #0x80000
a02462b0 0350a0e1 mov      r5, r3
a02462b4 071c06eb bl       #0xa03cd2d8
a02462b8 10208ae2 add      r2, sl, #0x10
a02462bc 00b0a0e1 mov      fp, r0
a02462c0 0510a0e1 mov      r1, r5
a02462c4 0430b4e5 ldr      r3, [r4, #4]!
a02462c8 000053e3 cmp      r3, #0
a02462cc 01108112 addne    r1, r1, #1
a02462d0 020054e1 cmp      r4, r2
a02462d4 faffff1a bne      #0xa02462c4
a02462d8 000051e3 cmp      r1, #0
a02462dc 0130a0e1 mov      r3, r1
a02462e0 1c108de5 str      r1, [sp, #0x1c]
a02462e4 5801000a beq      #0xa024684c
a02462e8 020756e3 cmp      r6, #0x80000
a02462ec 0130a093 movls    r3, #1
a02462f0 24308d95 strls    r3, [sp, #0x24]
a02462f4 5801008a bhi      #0xa024685c
a02462f8 db9a9fed vldr     s18, [pc, #0x36c]
a02462fc 0040a0e3 mov      r4, #0
a0246300 e8308de2 add      r3, sp, #0xe8
a0246304 18408de5 str      r4, [sp, #0x18]
a0246308 0c308de5 str      r3, [sp, #0xc]
a024630c 281207e3 movw     r1, #0x7228
a0246310 0630a0e1 mov      r3, r6
a0246314 0c009de5 ldr      r0, [sp, #0xc]
a0246318 5a104ae3 movt     r1, #0xa05a ; heuristic 0xa05a7228 '%s/throughput_%u.bin'
a024631c 20209de5 ldr      r2, [sp, #0x20]
a0246320 4acc0afa blx      #0xa04f9450
a0246324 1c309de5 ldr      r3, [sp, #0x1c]
a0246328 010053e3 cmp      r3, #1
a024632c 2801009a bls      #0xa02467d4
a0246330 780308e3 movw     r0, #0x8378
a0246334 56004ae3 movt     r0, #0xa056 ; heuristic 0xa0568378 '--- large file write with multi bs ---\n'
a0246338 37ff2fe1 blx      r7
a024633c 00209ae5 ldr      r2, [sl]
a0246340 000052e3 cmp      r2, #0
a0246344 0900000a beq      #0xa0246370
a0246348 0a80a0e1 mov      r8, sl
a024634c 0050a0e3 mov      r5, #0
a0246350 a00308e3 movw     r0, #0x83a0
a0246354 0510a0e1 mov      r1, r5
a0246358 56004ae3 movt     r0, #0xa056 ; heuristic 0xa05683a0 '--- bs %d =  %d---\n'
a024635c 015085e2 add      r5, r5, #1
a0246360 37ff2fe1 blx      r7
a0246364 0420b8e5 ldr      r2, [r8, #4]!
a0246368 000052e3 cmp      r2, #0
a024636c f7ffff1a bne      #0xa0246350
a0246370 18209de5 ldr      r2, [sp, #0x18]
a0246374 2c008de2 add      r0, sp, #0x2c
a0246378 0231a0e1 lsl      r3, r2, #2
a024637c 0222a0e1 lsl      r2, r2, #4
a0246380 10308de5 str      r3, [sp, #0x10]
a0246384 023063e0 rsb      r3, r3, r2
a0246388 14208de5 str      r2, [sp, #0x14]
a024638c ba2f8de2 add      r2, sp, #0x2e8
a0246390 033082e0 add      r3, r2, r3
a0246394 b46203e5 str      r6, [r3, #-0x2b4]
a0246398 ed8501eb bl       #0xa02a7b54
a024639c 5c1b06e3 movw     r1, #0x6b5c
a02463a0 0c009de5 ldr      r0, [sp, #0xc]
a02463a4 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a02463a8 220706eb bl       #0xa03c8038
a02463ac 009050e2 subs     sb, r0, #0
a02463b0 0050a013 movne    r5, #0
a02463b4 08508d15 strne    r5, [sp, #8]
a02463b8 1e01000a beq      #0xa0246838
a02463bc 04319ae7 ldr      r3, [sl, r4, lsl #2]
a02463c0 0b00a0e1 mov      r0, fp
a02463c4 0920a0e1 mov      r2, sb
a02463c8 014084e2 add      r4, r4, #1
a02463cc 000053e3 cmp      r3, #0
a02463d0 0360a011 movne    r6, r3
a02463d4 0340a001 moveq    r4, r3
a02463d8 0610a0e1 mov      r1, r6
a02463dc 3d0706eb bl       #0xa03c80d8
a02463e0 008050e2 subs     r8, r0, #0
a02463e4 ec0000ba blt      #0xa024679c
a02463e8 d300000a beq      #0xa024673c
a02463ec 2c008de2 add      r0, sp, #0x2c
a02463f0 30108de2 add      r1, sp, #0x30
a02463f4 db8501eb bl       #0xa02a7b68
a02463f8 202e04e3 movw     r2, #0x4e20
a02463fc 085085e0 add      r5, r5, r8
a0246400 020050e1 cmp      r0, r2
a0246404 c200009a bls      #0xa0246714
a0246408 0900a0e1 mov      r0, sb
a024640c 0680a0e1 mov      r8, r6
a0246410 140706eb bl       #0xa03c8068
a0246414 001050e2 subs     r1, r0, #0
a0246418 e90000ba blt      #0xa02467c4
a024641c 30108de2 add      r1, sp, #0x30
a0246420 2c008de2 add      r0, sp, #0x2c
a0246424 cf8501eb bl       #0xa02a7b68
a0246428 900a07ee vmov     s15, r0
a024642c c538a0e1 asr      r3, r5, #0x11
a0246430 678af8ee vcvt.f32.u32 s17, s15
a0246434 040408e3 movw     r0, #0x8404
a0246438 0520a0e1 mov      r2, r5
a024643c 0610a0e1 mov      r1, r6
a0246440 103a08ee vmov     s16, r3
a0246444 56004ae3 movt     r0, #0xa056 ; heuristic 0xa0568404 '(bs=%d) wrote %d bytes\n'
a0246448 37ff2fe1 blx      r7
a024644c 898ac8ee vdiv.f32 s17, s17, s18
a0246450 1c0408e3 movw     r0, #0x841c
a0246454 c88ab8ee vcvt.f32.s32 s16, s16
a0246458 0610a0e1 mov      r1, r6
a024645c 56004ae3 movt     r0, #0xa056 ; heuristic 0xa056841c '(bs=%d) write time elapsed : %f sec\n'
a0246460 288a88ee vdiv.f32 s16, s16, s17
a0246464 e80af7ee vcvt.f64.f32 d16, s17
a0246468 302b53ec vmov     r2, r3, d16
a024646c 37ff2fe1 blx      r7
a0246470 440408e3 movw     r0, #0x8444
a0246474 0610a0e1 mov      r1, r6
a0246478 56004ae3 movt     r0, #0xa056 ; heuristic 0xa0568444 '(bs=%d) write throughput : %f Mbit/sec\n'
a024647c c80af7ee vcvt.f64.f32 d16, s16
a0246480 302b53ec vmov     r2, r3, d16
a0246484 37ff2fe1 blx      r7
a0246488 1c309de5 ldr      r3, [sp, #0x1c]
a024648c 10209de5 ldr      r2, [sp, #0x10]
a0246490 010053e3 cmp      r3, #1
a0246494 14309de5 ldr      r3, [sp, #0x14]
a0246498 033062e0 rsb      r3, r2, r3
a024649c ba2f8de2 add      r2, sp, #0x2e8
a02464a0 033082e0 add      r3, r2, r3
a02464a4 ab8a03ed vstr     s16, [r3, #-0x2ac]
a02464a8 ce00009a bls      #0xa02467e8
a02464ac 900408e3 movw     r0, #0x8490
a02464b0 56004ae3 movt     r0, #0xa056 ; heuristic 0xa0568490 '--- large file read with multi bs ---\n'
a02464b4 37ff2fe1 blx      r7
a02464b8 00209ae5 ldr      r2, [sl]
a02464bc 000052e3 cmp      r2, #0
