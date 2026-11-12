; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a0227dfc f0402de9 push     {r4, r5, r6, r7, lr}
a0227e00 9cd04de2 sub      sp, sp, #0x9c
a0227e04 0040a0e3 mov      r4, #0
a0227e08 0060a0e1 mov      r6, r0
a0227e0c 48008de2 add      r0, sp, #0x48
a0227e10 0150a0e1 mov      r5, r1
a0227e14 00408de5 str      r4, [sp]
a0227e18 04408de5 str      r4, [sp, #4]
a0227e1c 08408de5 str      r4, [sp, #8]
a0227e20 32b706eb bl       #0xa03d5af0
a0227e24 b0060ae3 movw     r0, #0xa6b0
a0227e28 84150de3 movw     r1, #0xd584
a0227e2c 0130a0e3 mov      r3, #1
a0227e30 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059d584 'AppLibTune_Mctf'
a0227e34 582800e3 movw     r2, #0x858
a0227e38 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a6b0 '%s() %d'
a0227e3c 0130cde5 strb     r3, [sp, #1]
a0227e40 0040cde5 strb     r4, [sp]
a0227e44 0240cde5 strb     r4, [sp, #2]
a0227e48 a7fc01eb bl       #0xa02a70ec
a0227e4c 020056e3 cmp      r6, #2
a0227e50 903c06d3 movwle   r3, #0x6c90
a0227e54 084095c5 ldrgt    r4, [r5, #8]
a0227e58 5a304ad3 movtle   r3, #0xa05a
a0227e5c 0340a0d1 movle    r4, r3
a0227e60 083085d5 strle    r3, [r5, #8]
a0227e64 0400a0e1 mov      r0, r4
a0227e68 61fbffeb bl       #0xa0226bf4
a0227e6c 006050e2 subs     r6, r0, #0
a0227e70 4000001a bne      #0xa0227f78
a0227e74 0030d4e5 ldrb     r3, [r4]
a0227e78 000053e3 cmp      r3, #0
a0227e7c 5d00000a beq      #0xa0227ff8
a0227e80 e41c0ce3 movw     r1, #0xcce4
a0227e84 0400a0e1 mov      r0, r4
a0227e88 57104ae3 movt     r1, #0xa057 ; heuristic 0xa057cce4 'load'
a0227e8c 2c460bfa blx      #0xa04f9744
a0227e90 007050e2 subs     r7, r0, #0
a0227e94 bd00000a beq      #0xa0228190
a0227e98 c41c0ce3 movw     r1, #0xccc4
a0227e9c 0400a0e1 mov      r0, r4
a0227ea0 57104ae3 movt     r1, #0xa057 ; heuristic 0xa057ccc4 'save'
a0227ea4 26460bfa blx      #0xa04f9744
a0227ea8 003050e2 subs     r3, r0, #0
a0227eac 9b00000a beq      #0xa0228120
a0227eb0 781e0ee3 movw     r1, #0xee78
a0227eb4 0400a0e1 mov      r0, r4
a0227eb8 5c104ae3 movt     r1, #0xa05c ; heuristic 0xa05cee78 'enable'
a0227ebc 20460bfa blx      #0xa04f9744
a0227ec0 000050e3 cmp      r0, #0
a0227ec4 cf00000a beq      #0xa0228208
a0227ec8 a4180ae3 movw     r1, #0xa8a4
a0227ecc 0400a0e1 mov      r0, r4
a0227ed0 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059a8a4 'cmpr_en'
a0227ed4 1a460bfa blx      #0xa04f9744
a0227ed8 000050e3 cmp      r0, #0
a0227edc e700000a beq      #0xa0228280
a0227ee0 ac180ae3 movw     r1, #0xa8ac
a0227ee4 0400a0e1 mov      r0, r4
a0227ee8 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059a8ac 'zmv_en'
a0227eec 14460bfa blx      #0xa04f9744
a0227ef0 000050e3 cmp      r0, #0
a0227ef4 ce00001a bne      #0xa0228234
a0227ef8 0c0095e5 ldr      r0, [r5, #0xc]
a0227efc 0030d0e5 ldrb     r3, [r0]
a0227f00 2d0053e3 cmp      r3, #0x2d
a0227f04 0130d005 ldrbeq   r3, [r0, #1]
a0227f08 01208002 addeq    r2, r0, #1
a0227f0c 0020a011 movne    r2, r0
a0227f10 000053e3 cmp      r3, #0
a0227f14 0900000a beq      #0xa0227f40
a0227f18 303043e2 sub      r3, r3, #0x30
a0227f1c 090053e3 cmp      r3, #9
a0227f20 0200009a bls      #0xa0227f30
a0227f24 e50000ea b        #0xa02282c0
a0227f28 090051e3 cmp      r1, #9
a0227f2c e300008a bhi      #0xa02282c0
a0227f30 0130f2e5 ldrb     r3, [r2, #1]!
a0227f34 000053e3 cmp      r3, #0
a0227f38 301043e2 sub      r1, r3, #0x30
a0227f3c f9ffff1a bne      #0xa0227f28
a0227f40 d63f0bfa blx      #0xa04f7ea0
a0227f44 7030efe6 uxtb     r3, r0
a0227f48 0d00a0e1 mov      r0, sp
a0227f4c 0310a0e1 mov      r1, r3
a0227f50 0c30cde5 strb     r3, [sp, #0xc]
a0227f54 319e03eb bl       #0xa030f820
a0227f58 b4080ae3 movw     r0, #0xa8b4
a0227f5c 0c10dde5 ldrb     r1, [sp, #0xc]
a0227f60 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a8b4 'ZMV enable %d'
a0227f64 60fc01eb bl       #0xa02a70ec
a0227f68 0000a0e3 mov      r0, #0
a0227f6c 7000afe6 sxtb     r0, r0
a0227f70 9cd08de2 add      sp, sp, #0x9c
a0227f74 f080bde8 pop      {r4, r5, r6, r7, pc}
a0227f78 dc080ae3 movw     r0, #0xa8dc
a0227f7c 001095e5 ldr      r1, [r5]
a0227f80 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a8dc 'Usage: t %s -mctf: get the current MCTF_ext setting\n\r'
a0227f84 58fc01eb bl       #0xa02a70ec
a0227f88 14090ae3 movw     r0, #0xa914
a0227f8c 001095e5 ldr      r1, [r5]
a0227f90 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a914 '       t %s -mctf enable [enable:0/1/2]: set mctf enable or not\n\r'
a0227f94 54fc01eb bl       #0xa02a70ec
a0227f98 58090ae3 movw     r0, #0xa958
a0227f9c 001095e5 ldr      r1, [r5]
a0227fa0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a958 '       t %s -mctf save [mctf_cfg_path]: save current mctf bin to path\n\r'
a0227fa4 50fc01eb bl       #0xa02a70ec
a0227fa8 a0090ae3 movw     r0, #0xa9a0
a0227fac 001095e5 ldr      r1, [r5]
a0227fb0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a9a0 '       t %s -mctf zmv_en [enable:0/1]: set mctf zmv enable or not\n\r'
a0227fb4 4cfc01eb bl       #0xa02a70ec
a0227fb8 e4090ae3 movw     r0, #0xa9e4
a0227fbc 001095e5 ldr      r1, [r5]
a0227fc0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a9e4 '       t %s -mctf load [mctf_cfg_path]: load mctf bin (debug only)\n\r'
a0227fc4 48fc01eb bl       #0xa02a70ec
a0227fc8 58090ae3 movw     r0, #0xa958
a0227fcc 001095e5 ldr      r1, [r5]
a0227fd0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a958 '       t %s -mctf save [mctf_cfg_path]: save current mctf bin to path\n\r'
a0227fd4 44fc01eb bl       #0xa02a70ec
a0227fd8 2c0a0ae3 movw     r0, #0xaa2c
a0227fdc 001095e5 ldr      r1, [r5]
a0227fe0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059aa2c '       t %s -mctf ghost [Y] [Cb] [Cr]: config ghost pre\n\r'
a0227fe4 40fc01eb bl       #0xa02a70ec
a0227fe8 ff00a0e3 mov      r0, #0xff
a0227fec 7000afe6 sxtb     r0, r0
a0227ff0 9cd08de2 add      sp, sp, #0x9c
a0227ff4 f080bde8 pop      {r4, r5, r6, r7, pc}
a0227ff8 0c108de2 add      r1, sp, #0xc
a0227ffc 0d00a0e1 mov      r0, sp
a0228000 0350a0e1 mov      r5, r3
a0228004 0c408de2 add      r4, sp, #0xc
a0228008 009a03eb bl       #0xa030e810
a022800c b8060ae3 movw     r0, #0xa6b8
a0228010 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a6b8 'Current MCTF setting '
a0228014 34fc01eb bl       #0xa02a70ec
a0228018 d0060ae3 movw     r0, #0xa6d0
a022801c 0c10dde5 ldrb     r1, [sp, #0xc]
a0228020 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a6d0 'Enable = %d YCombinedStrength %d'
a0228024 b424dde1 ldrh     r2, [sp, #0x44]
a0228028 2ffc01eb bl       #0xa02a70ec
a022802c f4060ae3 movw     r0, #0xa6f4
a0228030 0510a0e1 mov      r1, r5
a0228034 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a6f4 'chan_info %d:'
a0228038 015085e2 add      r5, r5, #1
a022803c 2afc01eb bl       #0xa02a70ec
a0228040 04070ae3 movw     r0, #0xa704
a0228044 0210d4e5 ldrb     r1, [r4, #2]
a0228048 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a704 '    TemporalAlpha0: %d'
a022804c 26fc01eb bl       #0xa02a70ec
a0228050 1c070ae3 movw     r0, #0xa71c
a0228054 0310d4e5 ldrb     r1, [r4, #3]
a0228058 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a71c '    TemporalAlpha1: %d'
a022805c 22fc01eb bl       #0xa02a70ec
a0228060 34070ae3 movw     r0, #0xa734
a0228064 0410d4e5 ldrb     r1, [r4, #4]
a0228068 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a734 '    TemporalAlpha2: %d'
a022806c 1efc01eb bl       #0xa02a70ec
a0228070 4c070ae3 movw     r0, #0xa74c
a0228074 0510d4e5 ldrb     r1, [r4, #5]
a0228078 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a74c '    TemporalAlpha3: %d'
a022807c 1afc01eb bl       #0xa02a70ec
a0228080 64070ae3 movw     r0, #0xa764
a0228084 0610d4e5 ldrb     r1, [r4, #6]
a0228088 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a764 '    TemporalT0: %d'
a022808c 16fc01eb bl       #0xa02a70ec
a0228090 78070ae3 movw     r0, #0xa778
a0228094 0710d4e5 ldrb     r1, [r4, #7]
a0228098 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a778 '    TemporalT1: %d'
a022809c 12fc01eb bl       #0xa02a70ec
a02280a0 8c070ae3 movw     r0, #0xa78c
a02280a4 0810d4e5 ldrb     r1, [r4, #8]
a02280a8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a78c '    TemporalT2: %d'
a02280ac 0efc01eb bl       #0xa02a70ec
a02280b0 a0070ae3 movw     r0, #0xa7a0
a02280b4 0910d4e5 ldrb     r1, [r4, #9]
a02280b8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a7a0 '    TemporalT3: %d'
a02280bc 0afc01eb bl       #0xa02a70ec
a02280c0 b4070ae3 movw     r0, #0xa7b4
a02280c4 0a10d4e5 ldrb     r1, [r4, #0xa]
a02280c8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a7b4 '    TemporalMaxChange: %d'
a02280cc 06fc01eb bl       #0xa02a70ec
a02280d0 d0070ae3 movw     r0, #0xa7d0
a02280d4 bc10d4e1 ldrh     r1, [r4, #0xc]
a02280d8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a7d0 '    Radius: %d'
a02280dc 02fc01eb bl       #0xa02a70ec
a02280e0 e0070ae3 movw     r0, #0xa7e0
a02280e4 be10d4e1 ldrh     r1, [r4, #0xe]
a02280e8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a7e0 '    StrengthThreeD: %d'
a02280ec fefb01eb bl       #0xa02a70ec
a02280f0 f8070ae3 movw     r0, #0xa7f8
a02280f4 b011d4e1 ldrh     r1, [r4, #0x10]
a02280f8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a7f8 '    StrengthSpatial: %d'
a02280fc fafb01eb bl       #0xa02a70ec
a0228100 10080ae3 movw     r0, #0xa810
a0228104 b211f4e1 ldrh     r1, [r4, #0x12]!
a0228108 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a810 '    LevelAdjust: %d'
a022810c f6fb01eb bl       #0xa02a70ec
a0228110 030055e3 cmp      r5, #3
a0228114 c4ffff1a bne      #0xa022802c
a0228118 0000a0e3 mov      r0, #0
a022811c 92ffffea b        #0xa0227f6c
a0228120 0c108de2 add      r1, sp, #0xc
a0228124 0d00a0e1 mov      r0, sp
a0228128 0c308de5 str      r3, [sp, #0xc]
a022812c 8a9703eb bl       #0xa030df5c
a0228130 7c3003e3 movw     r3, #0x307c
a0228134 54080ae3 movw     r0, #0xa854
a0228138 6f304ae3 movt     r3, #0xa06f
a022813c 0c209de5 ldr      r2, [sp, #0xc]
a0228140 0c1093e5 ldr      r1, [r3, #0xc]
a0228144 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a854 '%sCurrentMctfCfgAddr 0x%.8x\n'
a0228148 e7fb01eb bl       #0xa02a70ec
a022814c 0230a0e3 mov      r3, #2
a0228150 0c1095e5 ldr      r1, [r5, #0xc]
a0228154 48008de2 add      r0, sp, #0x48
a0228158 9430cde5 strb     r3, [sp, #0x94]
a022815c e7450bfa blx      #0xa04f9900
a0228160 48008de2 add      r0, sp, #0x48
a0228164 29c106eb bl       #0xa03d8610
a0228168 004050e2 subs     r4, r0, #0
a022816c 5d00000a beq      #0xa02282e8
a0228170 0c009de5 ldr      r0, [sp, #0xc]
a0228174 0110a0e3 mov      r1, #1
a0228178 d02b06e3 movw     r2, #0x6bd0
a022817c 0430a0e1 mov      r3, r4
a0228180 96b706eb bl       #0xa03d5fe0
a0228184 0400a0e1 mov      r0, r4
a0228188 71b606eb bl       #0xa03d5b54
a022818c 75ffffea b        #0xa0227f68
a0228190 0c108de2 add      r1, sp, #0xc
a0228194 0d00a0e1 mov      r0, sp
a0228198 0c708de5 str      r7, [sp, #0xc]
a022819c 6e9703eb bl       #0xa030df5c
a02281a0 0c1095e5 ldr      r1, [r5, #0xc]
a02281a4 48008de2 add      r0, sp, #0x48
a02281a8 9470cde5 strb     r7, [sp, #0x94]
a02281ac d3450bfa blx      #0xa04f9900
a02281b0 48008de2 add      r0, sp, #0x48
a02281b4 15c106eb bl       #0xa03d8610
a02281b8 004050e2 subs     r4, r0, #0
a02281bc 4300000a beq      #0xa02282d0
a02281c0 000809e3 movw     r0, #0x9800
a02281c4 0430a0e1 mov      r3, r4
a02281c8 0110a0e3 mov      r1, #1
a02281cc d02b06e3 movw     r2, #0x6bd0
a02281d0 3c014ae3 movt     r0, #0xa13c
a02281d4 e4b606eb bl       #0xa03d5d6c
a02281d8 0400a0e1 mov      r0, r4
a02281dc 5cb606eb bl       #0xa03d5b54
a02281e0 001809e3 movw     r1, #0x9800
a02281e4 d02b06e3 movw     r2, #0x6bd0
a02281e8 3c114ae3 movt     r1, #0xa13c
a02281ec 0c009de5 ldr      r0, [sp, #0xc]
a02281f0 22d101eb bl       #0xa029c680
a02281f4 0c009de5 ldr      r0, [sp, #0xc]
a02281f8 d01b06e3 movw     r1, #0x6bd0
a02281fc 49c109eb bl       #0xa0498728
a0228200 0000a0e3 mov      r0, #0
a0228204 58ffffea b        #0xa0227f6c
a0228208 0c0095e5 ldr      r0, [r5, #0xc]
a022820c 233f0bfa blx      #0xa04f7ea0
a0228210 7040efe6 uxtb     r4, r0
a0228214 b8080ae3 movw     r0, #0xa8b8
a0228218 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a8b8 'enable %d'
a022821c 0410a0e1 mov      r1, r4
a0228220 b1fb01eb bl       #0xa02a70ec
a0228224 0410a0e1 mov      r1, r4
a0228228 0d00a0e1 mov      r0, sp
a022822c ec9b03eb bl       #0xa030f1e4
a0228230 4cffffea b        #0xa0227f68
a0228234 c4180ae3 movw     r1, #0xa8c4
a0228238 0400a0e1 mov      r0, r4
a022823c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059a8c4 'ghost'
a0228240 3f450bfa blx      #0xa04f9744
a0228244 000050e3 cmp      r0, #0
a0228248 1200001a bne      #0xa0228298
a022824c 0c0095e5 ldr      r0, [r5, #0xc]
a0228250 123f0bfa blx      #0xa04f7ea0
a0228254 0c00cde5 strb     r0, [sp, #0xc]
a0228258 100095e5 ldr      r0, [r5, #0x10]
a022825c 0f3f0bfa blx      #0xa04f7ea0
a0228260 0d00cde5 strb     r0, [sp, #0xd]
a0228264 140095e5 ldr      r0, [r5, #0x14]
a0228268 0c3f0bfa blx      #0xa04f7ea0
a022826c 0c108de2 add      r1, sp, #0xc
a0228270 0e00cde5 strb     r0, [sp, #0xe]
a0228274 0d00a0e1 mov      r0, sp
a0228278 6c9b03eb bl       #0xa030f030
a022827c 39ffffea b        #0xa0227f68
a0228280 0c0095e5 ldr      r0, [r5, #0xc]
a0228284 053f0bfa blx      #0xa04f7ea0
a0228288 7010efe6 uxtb     r1, r0
a022828c 0d00a0e1 mov      r0, sp
a0228290 519c03eb bl       #0xa030f3dc
a0228294 33ffffea b        #0xa0227f68
a0228298 cc180ae3 movw     r1, #0xa8cc
a022829c 0600a0e1 mov      r0, r6
a02282a0 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059a8cc ' :\t\n${}[]();,'
a02282a4 584b0bfa blx      #0xa04fb00c
a02282a8 fc3e0bfa blx      #0xa04f7ea0
a02282ac 0c108de2 add      r1, sp, #0xc
a02282b0 b404cde1 strh     r0, [sp, #0x44]
a02282b4 0d00a0e1 mov      r0, sp
a02282b8 0e9803eb bl       #0xa030e2f8
a02282bc 29ffffea b        #0xa0227f68
a02282c0 0d00a0e1 mov      r0, sp
a02282c4 0c108de2 add      r1, sp, #0xc
a02282c8 c99d03eb bl       #0xa030f9f4
a02282cc 21ffffea b        #0xa0227f58
a02282d0 24080ae3 movw     r0, #0xa824
a02282d4 0c1095e5 ldr      r1, [r5, #0xc]
a02282d8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a824 "File opened error, can't load the file %s \n\r"
a02282dc 82fb01eb bl       #0xa02a70ec
a02282e0 ff00a0e3 mov      r0, #0xff
a02282e4 40ffffea b        #0xa0227fec
a02282e8 74080ae3 movw     r0, #0xa874
a02282ec 0c1095e5 ldr      r1, [r5, #0xc]
a02282f0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a874 "File opened error, can't save the file %s \n\r"
a02282f4 7cfb01eb bl       #0xa02a70ec
a02282f8 ff00a0e3 mov      r0, #0xff
a02282fc 3affffea b        #0xa0227fec
