; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a022b96c f0472de9 push     {r4, r5, r6, r7, r8, sb, sl, lr}
a022b970 d04300e3 movw     r4, #0x3d0
a022b974 a02209e3 movw     r2, #0x92a0
a022b978 3d414ae3 movt     r4, #0xa13d
a022b97c 0060a0e1 mov      r6, r0
a022b980 fedf4de2 sub      sp, sp, #0x3f8
a022b984 0170a0e1 mov      r7, r1
a022b988 0400a0e1 mov      r0, r4
a022b98c 042040e3 movt     r2, #4
a022b990 ff10a0e3 mov      r1, #0xff
a022b994 14350bfa blx      #0xa04f8dec
a022b998 020056e3 cmp      r6, #2
a022b99c 120000ca bgt      #0xa022b9ec
a022b9a0 14020ce3 movw     r0, #0xc214
a022b9a4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c214 'Usage: t img -idsp dump [0, 1-7] [filename.bin]: dump idsp configuration'
a022b9a8 cfed01eb bl       #0xa02a70ec
a022b9ac 60020ce3 movw     r0, #0xc260
a022b9b0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c260 '       t img -idsp dump [100] [filename.bin]: dump MCTF configuration, both for mode 0 and mode 5'
a022b9b4 cced01eb bl       #0xa02a70ec
a022b9b8 c4020ce3 movw     r0, #0xc2c4
a022b9bc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c2c4 '       t img -idsp dump [filename]: dump idsp mode5 sec2/3 configuration'
a022b9c0 c9ed01eb bl       #0xa02a70ec
a022b9c4 10030ce3 movw     r0, #0xc310
a022b9c8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c310 '       t img -idsp debug [module(8bits): 0-6, 255] [debug mask(32bits)]: set dsp debug level'
a022b9cc c6ed01eb bl       #0xa02a70ec
a022b9d0 70030ce3 movw     r0, #0xc370
a022b9d4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c370 '       t img -idsp dbgthd [thread disable mask(8bits)]: set dsp thread disable mask'
a022b9d8 c3ed01eb bl       #0xa02a70ec
a022b9dc ff00a0e3 mov      r0, #0xff
a022b9e0 7000afe6 sxtb     r0, r0
a022b9e4 fedf8de2 add      sp, sp, #0x3f8
a022b9e8 f087bde8 pop      {r4, r5, r6, r7, r8, sb, sl, pc}
a022b9ec 085097e5 ldr      r5, [r7, #8]
a022b9f0 0500a0e1 mov      r0, r5
a022b9f4 7eecffeb bl       #0xa0226bf4
a022b9f8 000050e3 cmp      r0, #0
a022b9fc e7ffff1a bne      #0xa022b9a0
a022ba00 88130ae3 movw     r1, #0xa388
a022ba04 0500a0e1 mov      r0, r5
a022ba08 56104ae3 movt     r1, #0xa056 ; heuristic 0xa056a388 'dump'
a022ba0c 4c370bfa blx      #0xa04f9744
a022ba10 000050e3 cmp      r0, #0
a022ba14 2d00000a beq      #0xa022bad0
a022ba18 fc1d0ce3 movw     r1, #0xcdfc
a022ba1c 0500a0e1 mov      r0, r5
a022ba20 55104ae3 movt     r1, #0xa055 ; heuristic 0xa055cdfc 'multi'
a022ba24 46370bfa blx      #0xa04f9744
a022ba28 000050e3 cmp      r0, #0
a022ba2c 3200000a beq      #0xa022bafc
a022ba30 181a07e3 movw     r1, #0x7a18
a022ba34 0500a0e1 mov      r0, r5
a022ba38 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0577a18 'debug'
a022ba3c 40370bfa blx      #0xa04f9744
a022ba40 004050e2 subs     r4, r0, #0
a022ba44 0401000a beq      #0xa022be5c
a022ba48 bc110ce3 movw     r1, #0xc1bc
a022ba4c 0500a0e1 mov      r0, r5
a022ba50 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c1bc 'dbgthd'
a022ba54 3a370bfa blx      #0xa04f9744
a022ba58 000050e3 cmp      r0, #0
a022ba5c 8401000a beq      #0xa022c074
a022ba60 c4110ce3 movw     r1, #0xc1c4
a022ba64 0500a0e1 mov      r0, r5
a022ba68 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c1c4 'flush'
a022ba6c 34370bfa blx      #0xa04f9744
a022ba70 000050e3 cmp      r0, #0
a022ba74 e900000a beq      #0xa022be20
a022ba78 ec110ce3 movw     r1, #0xc1ec
a022ba7c 0500a0e1 mov      r0, r5
a022ba80 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c1ec 'clean'
a022ba84 2e370bfa blx      #0xa04f9744
a022ba88 000050e3 cmp      r0, #0
a022ba8c c3ffff1a bne      #0xa022b9a0
a022ba90 0c0097e5 ldr      r0, [r7, #0xc]
a022ba94 01310bfa blx      #0xa04f7ea0
a022ba98 0040a0e1 mov      r4, r0
a022ba9c 100097e5 ldr      r0, [r7, #0x10]
a022baa0 fe300bfa blx      #0xa04f7ea0
a022baa4 7050ffe6 uxth     r5, r0
a022baa8 0400a0e1 mov      r0, r4
a022baac 0510a0e1 mov      r1, r5
a022bab0 1cb309eb bl       #0xa0498728
a022bab4 f4010ce3 movw     r0, #0xc1f4
a022bab8 0520a0e1 mov      r2, r5
a022babc 0410a0e1 mov      r1, r4
a022bac0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c1f4 'Idsp Memory clean 0x%x Size%d'
a022bac4 88ed01eb bl       #0xa02a70ec
a022bac8 0000a0e3 mov      r0, #0
a022bacc c3ffffea b        #0xa022b9e0
a022bad0 c8008de2 add      r0, sp, #0xc8
a022bad4 4b7f02eb bl       #0xa02cb808
a022bad8 c8309de5 ldr      r3, [sp, #0xc8]
a022badc 0050a0e1 mov      r5, r0
a022bae0 330e53e3 cmp      r3, #0x330
a022bae4 3700000a beq      #0xa022bbc8
a022bae8 880e0be3 movw     r0, #0xbe88
a022baec 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059be88 "[Warn] Type doesn't match"
a022baf0 7ded01eb bl       #0xa02a70ec
a022baf4 ff00a0e3 mov      r0, #0xff
a022baf8 b8ffffea b        #0xa022b9e0
a022bafc 0c0097e5 ldr      r0, [r7, #0xc]
a022bb00 dc50dde5 ldrb     r5, [sp, #0xdc]
a022bb04 dd60dde5 ldrb     r6, [sp, #0xdd]
a022bb08 e4300bfa blx      #0xa04f7ea0
a022bb0c 0080a0e1 mov      r8, r0
a022bb10 c8008de2 add      r0, sp, #0xc8
a022bb14 3b7f02eb bl       #0xa02cb808
a022bb18 c8309de5 ldr      r3, [sp, #0xc8]
a022bb1c 0040a0e1 mov      r4, r0
a022bb20 330e53e3 cmp      r3, #0x330
a022bb24 efffff1a bne      #0xa022bae8
a022bb28 860565e1 smulbb   r5, r6, r5
a022bb2c 7550efe6 uxtb     r5, r5
a022bb30 020055e3 cmp      r5, #2
a022bb34 8301008a bhi      #0xa022c148
a022bb38 f0239de5 ldr      r2, [sp, #0x3f0]
a022bb3c 000052e3 cmp      r2, #0
a022bb40 0d00000a beq      #0xa022bb7c
a022bb44 000055e3 cmp      r5, #0
a022bb48 b001000a beq      #0xa022c210
a022bb4c 7860efe6 uxtb     r6, r8
a022bb50 fe1f8de2 add      r1, sp, #0x3f8
a022bb54 0692a0e1 lsl      sb, r6, #4
a022bb58 8663a0e1 lsl      r6, r6, #7
a022bb5c 063069e0 rsb      r3, sb, r6
a022bb60 033081e0 add      r3, r1, r3
a022bb64 f01213e5 ldr      r1, [r3, #-0x2f0]
a022bb68 000051e3 cmp      r1, #0
a022bb6c b501001a bne      #0xa022c248
a022bb70 580f0be3 movw     r0, #0xbf58
a022bb74 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bf58 'Idsp Sec2 dump info are zero, Sec2IdspLeftCfgAddr 0x%X Sec2IdspCfgLength %d'
a022bb78 5bed01eb bl       #0xa02a70ec
a022bb7c f4239de5 ldr      r2, [sp, #0x3f4]
a022bb80 000052e3 cmp      r2, #0
a022bb84 0d00000a beq      #0xa022bbc0
a022bb88 000055e3 cmp      r5, #0
a022bb8c a601000a beq      #0xa022c22c
a022bb90 7860efe6 uxtb     r6, r8
a022bb94 0692a0e1 lsl      sb, r6, #4
a022bb98 8663a0e1 lsl      r6, r6, #7
a022bb9c fe1f8de2 add      r1, sp, #0x3f8
a022bba0 063069e0 rsb      r3, sb, r6
a022bba4 033081e0 add      r3, r1, r3
a022bba8 e41213e5 ldr      r1, [r3, #-0x2e4]
a022bbac 000051e3 cmp      r1, #0
a022bbb0 d401001a bne      #0xa022c308
a022bbb4 a4000ce3 movw     r0, #0xc0a4
a022bbb8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c0a4 'Idsp Sec3 dump info are zero, Sec3IdspLeftCfgAddr 0x%X Sec3IdspCfgLength %d'
a022bbbc 4aed01eb bl       #0xa02a70ec
a022bbc0 7400efe6 uxtb     r0, r4
a022bbc4 85ffffea b        #0xa022b9e0
a022bbc8 030056e3 cmp      r6, #3
a022bbcc 1f40c4e3 bic      r4, r4, #0x1f
a022bbd0 204084e2 add      r4, r4, #0x20
a022bbd4 aa00000a beq      #0xa022be84
a022bbd8 0c0097e5 ldr      r0, [r7, #0xc]
a022bbdc 0030d0e5 ldrb     r3, [r0]
a022bbe0 2d0053e3 cmp      r3, #0x2d
a022bbe4 0130d005 ldrbeq   r3, [r0, #1]
a022bbe8 01208002 addeq    r2, r0, #1
a022bbec 0020a011 movne    r2, r0
a022bbf0 000053e3 cmp      r3, #0
a022bbf4 0900000a beq      #0xa022bc20
a022bbf8 303043e2 sub      r3, r3, #0x30
a022bbfc 090053e3 cmp      r3, #9
a022bc00 0200009a bls      #0xa022bc10
a022bc04 9e0000ea b        #0xa022be84
a022bc08 090051e3 cmp      r1, #9
a022bc0c 9c00008a bhi      #0xa022be84
a022bc10 0130f2e5 ldrb     r3, [r2, #1]!
a022bc14 000053e3 cmp      r3, #0
a022bc18 301043e2 sub      r1, r3, #0x30
a022bc1c f9ffff1a bne      #0xa022bc08
a022bc20 9e300bfa blx      #0xa04f7ea0
a022bc24 000055e3 cmp      r5, #0
a022bc28 7000efe6 uxtb     r0, r0
a022bc2c 4901001a bne      #0xa022c158
a022bc30 010050e3 cmp      r0, #1
a022bc34 1301001a bne      #0xa022c088
a022bc38 df40dde5 ldrb     r4, [sp, #0xdf]
a022bc3c de30dde5 ldrb     r3, [sp, #0xde]
a022bc40 840364e1 smulbb   r4, r4, r3
a022bc44 7440efe6 uxtb     r4, r4
a022bc48 020054e3 cmp      r4, #2
a022bc4c 0302008a bhi      #0xa022c460
a022bc50 f0239de5 ldr      r2, [sp, #0x3f0]
a022bc54 000052e3 cmp      r2, #0
a022bc58 3500000a beq      #0xa022bd34
a022bc5c 000054e3 cmp      r4, #0
a022bc60 38139de5 ldr      r1, [sp, #0x338]
a022bc64 0100000a beq      #0xa022bc70
a022bc68 000051e3 cmp      r1, #0
a022bc6c b102001a bne      #0xa022c738
a022bc70 580f0be3 movw     r0, #0xbf58
a022bc74 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bf58 'Idsp Sec2 dump info are zero, Sec2IdspLeftCfgAddr 0x%X Sec2IdspCfgLength %d'
a022bc78 1bed01eb bl       #0xa02a70ec
a022bc7c 010054e3 cmp      r4, #1
a022bc80 2b00009a bls      #0xa022bd34
a022bc84 70139de5 ldr      r1, [sp, #0x370]
a022bc88 000051e3 cmp      r1, #0
a022bc8c 2402000a beq      #0xa022c524
a022bc90 b40b02eb bl       #0xa02aeb68
a022bc94 a43f0be3 movw     r3, #0xbfa4
a022bc98 08808de2 add      r8, sp, #8
a022bc9c 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059bfa4 'sec2idsp_R.bin'
a022bca0 c81e0be3 movw     r1, #0xbec8
a022bca4 0020a0e1 mov      r2, r0
a022bca8 00308de5 str      r3, [sp]
a022bcac 0800a0e1 mov      r0, r8
a022bcb0 103097e5 ldr      r3, [r7, #0x10]
a022bcb4 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022bcb8 e4350bfa blx      #0xa04f9450
a022bcbc 0830dde5 ldrb     r3, [sp, #8]
a022bcc0 48008de2 add      r0, sp, #0x48
a022bcc4 000053e3 cmp      r3, #0
a022bcc8 e002000a beq      #0xa022c850
a022bccc 0810a0e1 mov      r1, r8
a022bcd0 0020a0e1 mov      r2, r0
a022bcd4 0130c2e4 strb     r3, [r2], #1
a022bcd8 0130f1e5 ldrb     r3, [r1, #1]!
a022bcdc 000053e3 cmp      r3, #0
a022bce0 fbffff1a bne      #0xa022bcd4
a022bce4 0030a0e3 mov      r3, #0
a022bce8 5c1b06e3 movw     r1, #0x6b5c
a022bcec 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022bcf0 0030c2e5 strb     r3, [r2]
a022bcf4 f30804eb bl       #0xa032e0c8
a022bcf8 006050e2 subs     r6, r0, #0
a022bcfc bd02000a beq      #0xa022c7f8
a022bd00 0110a0e3 mov      r1, #1
a022bd04 f0239de5 ldr      r2, [sp, #0x3f0]
a022bd08 0630a0e1 mov      r3, r6
a022bd0c 70039de5 ldr      r0, [sp, #0x370]
a022bd10 f00804eb bl       #0xa032e0d8
a022bd14 0050a0e1 mov      r5, r0
a022bd18 0600a0e1 mov      r0, r6
a022bd1c eb0804eb bl       #0xa032e0d0
a022bd20 b40f0be3 movw     r0, #0xbfb4
a022bd24 70139de5 ldr      r1, [sp, #0x370]
a022bd28 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bfb4 'Idsp Sec2 dump success, Sec2IdspRightCfgAddr 0x%X Sec2IdspCfgLength %d'
a022bd2c f0239de5 ldr      r2, [sp, #0x3f0]
a022bd30 edec01eb bl       #0xa02a70ec
a022bd34 f4239de5 ldr      r2, [sp, #0x3f4]
a022bd38 000052e3 cmp      r2, #0
a022bd3c 3500000a beq      #0xa022be18
a022bd40 000054e3 cmp      r4, #0
a022bd44 44139de5 ldr      r1, [sp, #0x344]
a022bd48 0100000a beq      #0xa022bd54
a022bd4c 000051e3 cmp      r1, #0
a022bd50 4e02001a bne      #0xa022c690
a022bd54 a4000ce3 movw     r0, #0xc0a4
a022bd58 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c0a4 'Idsp Sec3 dump info are zero, Sec3IdspLeftCfgAddr 0x%X Sec3IdspCfgLength %d'
a022bd5c e2ec01eb bl       #0xa02a70ec
a022bd60 010054e3 cmp      r4, #1
a022bd64 2b00009a bls      #0xa022be18
a022bd68 7c139de5 ldr      r1, [sp, #0x37c]
a022bd6c 000051e3 cmp      r1, #0
a022bd70 e601000a beq      #0xa022c510
a022bd74 7b0b02eb bl       #0xa02aeb68
a022bd78 f0c00ce3 movw     ip, #0xc0f0
a022bd7c 08808de2 add      r8, sp, #8
a022bd80 59c04ae3 movt     ip, #0xa059 ; heuristic 0xa059c0f0 'sec3idsp_R.bin'
a022bd84 c81e0be3 movw     r1, #0xbec8
a022bd88 103097e5 ldr      r3, [r7, #0x10]
a022bd8c 0020a0e1 mov      r2, r0
a022bd90 00c08de5 str      ip, [sp]
a022bd94 0800a0e1 mov      r0, r8
a022bd98 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022bd9c ab350bfa blx      #0xa04f9450
a022bda0 0830dde5 ldrb     r3, [sp, #8]
a022bda4 48008de2 add      r0, sp, #0x48
a022bda8 000053e3 cmp      r3, #0
a022bdac ab02000a beq      #0xa022c860
a022bdb0 0810a0e1 mov      r1, r8
a022bdb4 0020a0e1 mov      r2, r0
a022bdb8 0130c2e4 strb     r3, [r2], #1
a022bdbc 0130f1e5 ldrb     r3, [r1, #1]!
a022bdc0 000053e3 cmp      r3, #0
a022bdc4 fbffff1a bne      #0xa022bdb8
a022bdc8 0030a0e3 mov      r3, #0
a022bdcc 5c1b06e3 movw     r1, #0x6b5c
a022bdd0 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022bdd4 0030c2e5 strb     r3, [r2]
a022bdd8 ba0804eb bl       #0xa032e0c8
a022bddc 004050e2 subs     r4, r0, #0
a022bde0 8402000a beq      #0xa022c7f8
a022bde4 0110a0e3 mov      r1, #1
a022bde8 f4239de5 ldr      r2, [sp, #0x3f4]
a022bdec 0430a0e1 mov      r3, r4
a022bdf0 7c039de5 ldr      r0, [sp, #0x37c]
a022bdf4 b70804eb bl       #0xa032e0d8
a022bdf8 0050a0e1 mov      r5, r0
a022bdfc 0400a0e1 mov      r0, r4
a022be00 b20804eb bl       #0xa032e0d0
a022be04 00010ce3 movw     r0, #0xc100
a022be08 7c139de5 ldr      r1, [sp, #0x37c]
a022be0c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c100 'Idsp Sec3 dump success, Sec3IdspRightCfgAddr 0x%X Sec3IdspCfgLength %d'
a022be10 f4239de5 ldr      r2, [sp, #0x3f4]
a022be14 b4ec01eb bl       #0xa02a70ec
a022be18 7500efe6 uxtb     r0, r5
a022be1c effeffea b        #0xa022b9e0
a022be20 0c0097e5 ldr      r0, [r7, #0xc]
a022be24 1d300bfa blx      #0xa04f7ea0
a022be28 0040a0e1 mov      r4, r0
a022be2c 100097e5 ldr      r0, [r7, #0x10]
a022be30 1a300bfa blx      #0xa04f7ea0
a022be34 7050ffe6 uxth     r5, r0
a022be38 0400a0e1 mov      r0, r4
a022be3c 0510a0e1 mov      r1, r5
a022be40 6ab209eb bl       #0xa04987f0
a022be44 cc010ce3 movw     r0, #0xc1cc
a022be48 0520a0e1 mov      r2, r5
a022be4c 0410a0e1 mov      r1, r4
a022be50 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c1cc 'Idsp Memory Flush 0x%x Size%d'
a022be54 a4ec01eb bl       #0xa02a70ec
a022be58 1affffea b        #0xa022bac8
a022be5c 0c0097e5 ldr      r0, [r7, #0xc]
a022be60 0e300bfa blx      #0xa04f7ea0
a022be64 0050a0e1 mov      r5, r0
a022be68 100097e5 ldr      r0, [r7, #0x10]
a022be6c 0b300bfa blx      #0xa04f7ea0
a022be70 0420a0e1 mov      r2, r4
a022be74 0010a0e1 mov      r1, r0
a022be78 7500efe6 uxtb     r0, r5
a022be7c 066902eb bl       #0xa02c629c
a022be80 10ffffea b        #0xa022bac8
a022be84 000055e3 cmp      r5, #0
a022be88 c4feff1a bne      #0xa022b9a0
a022be8c dd50dde5 ldrb     r5, [sp, #0xdd]
a022be90 dc30dde5 ldrb     r3, [sp, #0xdc]
a022be94 850365e1 smulbb   r5, r5, r3
a022be98 7550efe6 uxtb     r5, r5
a022be9c 020055e3 cmp      r5, #2
a022bea0 6501008a bhi      #0xa022c43c
a022bea4 f0239de5 ldr      r2, [sp, #0x3f0]
a022bea8 000052e3 cmp      r2, #0
a022beac 4201000a beq      #0xa022c3bc
a022beb0 000055e3 cmp      r5, #0
a022beb4 08119de5 ldr      r1, [sp, #0x108]
a022beb8 0100000a beq      #0xa022bec4
a022bebc 000051e3 cmp      r1, #0
a022bec0 c601001a bne      #0xa022c5e0
a022bec4 580f0be3 movw     r0, #0xbf58
a022bec8 0040a0e3 mov      r4, #0
a022becc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bf58 'Idsp Sec2 dump info are zero, Sec2IdspLeftCfgAddr 0x%X Sec2IdspCfgLength %d'
a022bed0 85ec01eb bl       #0xa02a70ec
a022bed4 010055e3 cmp      r5, #1
a022bed8 2b00009a bls      #0xa022bf8c
a022bedc 40119de5 ldr      r1, [sp, #0x140]
a022bee0 000051e3 cmp      r1, #0
a022bee4 6101000a beq      #0xa022c470
a022bee8 1e0b02eb bl       #0xa02aeb68
a022beec a43f0be3 movw     r3, #0xbfa4
a022bef0 08808de2 add      r8, sp, #8
a022bef4 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059bfa4 'sec2idsp_R.bin'
a022bef8 c81e0be3 movw     r1, #0xbec8
a022befc 0020a0e1 mov      r2, r0
a022bf00 00308de5 str      r3, [sp]
a022bf04 0800a0e1 mov      r0, r8
a022bf08 0c3097e5 ldr      r3, [r7, #0xc]
a022bf0c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022bf10 4e350bfa blx      #0xa04f9450
a022bf14 0830dde5 ldrb     r3, [sp, #8]
a022bf18 48008de2 add      r0, sp, #0x48
a022bf1c 000053e3 cmp      r3, #0
a022bf20 4802000a beq      #0xa022c848
a022bf24 0810a0e1 mov      r1, r8
a022bf28 0020a0e1 mov      r2, r0
a022bf2c 0130c2e4 strb     r3, [r2], #1
a022bf30 0130f1e5 ldrb     r3, [r1, #1]!
a022bf34 000053e3 cmp      r3, #0
a022bf38 fbffff1a bne      #0xa022bf2c
a022bf3c 0030a0e3 mov      r3, #0
a022bf40 5c1b06e3 movw     r1, #0x6b5c
a022bf44 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022bf48 0030c2e5 strb     r3, [r2]
a022bf4c 5d0804eb bl       #0xa032e0c8
a022bf50 006050e2 subs     r6, r0, #0
a022bf54 3c01000a beq      #0xa022c44c
a022bf58 0110a0e3 mov      r1, #1
a022bf5c f0239de5 ldr      r2, [sp, #0x3f0]
a022bf60 0630a0e1 mov      r3, r6
a022bf64 40019de5 ldr      r0, [sp, #0x140]
a022bf68 5a0804eb bl       #0xa032e0d8
a022bf6c 0040a0e1 mov      r4, r0
a022bf70 0600a0e1 mov      r0, r6
a022bf74 550804eb bl       #0xa032e0d0
a022bf78 b40f0be3 movw     r0, #0xbfb4
a022bf7c 40119de5 ldr      r1, [sp, #0x140]
a022bf80 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bfb4 'Idsp Sec2 dump success, Sec2IdspRightCfgAddr 0x%X Sec2IdspCfgLength %d'
a022bf84 f0239de5 ldr      r2, [sp, #0x3f0]
a022bf88 57ec01eb bl       #0xa02a70ec
a022bf8c f4239de5 ldr      r2, [sp, #0x3f4]
a022bf90 000052e3 cmp      r2, #0
a022bf94 09ffff0a beq      #0xa022bbc0
a022bf98 000055e3 cmp      r5, #0
a022bf9c 14119de5 ldr      r1, [sp, #0x114]
a022bfa0 0100000a beq      #0xa022bfac
a022bfa4 000051e3 cmp      r1, #0
a022bfa8 6201001a bne      #0xa022c538
a022bfac a4000ce3 movw     r0, #0xc0a4
a022bfb0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c0a4 'Idsp Sec3 dump info are zero, Sec3IdspLeftCfgAddr 0x%X Sec3IdspCfgLength %d'
a022bfb4 4cec01eb bl       #0xa02a70ec
a022bfb8 010055e3 cmp      r5, #1
a022bfbc fffeff9a bls      #0xa022bbc0
a022bfc0 4c119de5 ldr      r1, [sp, #0x14c]
a022bfc4 000051e3 cmp      r1, #0
a022bfc8 2d01000a beq      #0xa022c484
a022bfcc e50a02eb bl       #0xa02aeb68
a022bfd0 f0c00ce3 movw     ip, #0xc0f0
a022bfd4 08808de2 add      r8, sp, #8
a022bfd8 59c04ae3 movt     ip, #0xa059 ; heuristic 0xa059c0f0 'sec3idsp_R.bin'
a022bfdc c81e0be3 movw     r1, #0xbec8
a022bfe0 0c3097e5 ldr      r3, [r7, #0xc]
a022bfe4 0020a0e1 mov      r2, r0
a022bfe8 00c08de5 str      ip, [sp]
a022bfec 0800a0e1 mov      r0, r8
a022bff0 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022bff4 15350bfa blx      #0xa04f9450
a022bff8 0830dde5 ldrb     r3, [sp, #8]
a022bffc 48008de2 add      r0, sp, #0x48
a022c000 000053e3 cmp      r3, #0
a022c004 1702000a beq      #0xa022c868
a022c008 0810a0e1 mov      r1, r8
a022c00c 0020a0e1 mov      r2, r0
a022c010 0130c2e4 strb     r3, [r2], #1
a022c014 0130f1e5 ldrb     r3, [r1, #1]!
a022c018 000053e3 cmp      r3, #0
a022c01c fbffff1a bne      #0xa022c010
a022c020 0030a0e3 mov      r3, #0
a022c024 5c1b06e3 movw     r1, #0x6b5c
a022c028 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c02c 0030c2e5 strb     r3, [r2]
a022c030 240804eb bl       #0xa032e0c8
a022c034 005050e2 subs     r5, r0, #0
a022c038 0301000a beq      #0xa022c44c
a022c03c f4239de5 ldr      r2, [sp, #0x3f4]
a022c040 0110a0e3 mov      r1, #1
a022c044 0530a0e1 mov      r3, r5
a022c048 4c019de5 ldr      r0, [sp, #0x14c]
a022c04c 210804eb bl       #0xa032e0d8
a022c050 0040a0e1 mov      r4, r0
a022c054 0500a0e1 mov      r0, r5
a022c058 1c0804eb bl       #0xa032e0d0
a022c05c 00010ce3 movw     r0, #0xc100
a022c060 4c119de5 ldr      r1, [sp, #0x14c]
a022c064 f4239de5 ldr      r2, [sp, #0x3f4]
a022c068 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c100 'Idsp Sec3 dump success, Sec3IdspRightCfgAddr 0x%X Sec3IdspCfgLength %d'
a022c06c 1eec01eb bl       #0xa02a70ec
a022c070 d2feffea b        #0xa022bbc0
a022c074 0c0097e5 ldr      r0, [r7, #0xc]
a022c078 882f0bfa blx      #0xa04f7ea0
a022c07c 7000efe6 uxtb     r0, r0
a022c080 a36802eb bl       #0xa02c6314
a022c084 8ffeffea b        #0xa022bac8
a022c088 643040e2 sub      r3, r0, #0x64
a022c08c 020053e3 cmp      r3, #2
a022c090 42feff8a bhi      #0xa022b9a0
a022c094 0410a0e1 mov      r1, r4
a022c098 67e9ffeb bl       #0xa022663c
a022c09c 98010ce3 movw     r0, #0xc198
a022c0a0 0410a0e1 mov      r1, r4
a022c0a4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c198 'idsp_dump addr %0.8X'
a022c0a8 0fec01eb bl       #0xa02a70ec
a022c0ac 050056e3 cmp      r6, #5
a022c0b0 f800000a beq      #0xa022c498
a022c0b4 ab0a02eb bl       #0xa02aeb68
a022c0b8 341f00e3 movw     r1, #0xf34
a022c0bc b0310ce3 movw     r3, #0xc1b0
a022c0c0 0020a0e1 mov      r2, r0
a022c0c4 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059c1b0 'idsp_0.bin'
a022c0c8 08008de2 add      r0, sp, #8
a022c0cc 55104ae3 movt     r1, #0xa055 ; heuristic 0xa0550f34 '%c:\\%s'
a022c0d0 de340bfa blx      #0xa04f9450
a022c0d4 0830dde5 ldrb     r3, [sp, #8]
a022c0d8 48008de2 add      r0, sp, #0x48
a022c0dc 000053e3 cmp      r3, #0
a022c0e0 ce01000a beq      #0xa022c820
a022c0e4 08208de2 add      r2, sp, #8
a022c0e8 00c0a0e1 mov      ip, r0
a022c0ec 0130cce4 strb     r3, [ip], #1
a022c0f0 0130f2e5 ldrb     r3, [r2, #1]!
a022c0f4 000053e3 cmp      r3, #0
a022c0f8 fbffff1a bne      #0xa022c0ec
a022c0fc 0030a0e3 mov      r3, #0
a022c100 5c1b06e3 movw     r1, #0x6b5c
a022c104 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c108 0030cce5 strb     r3, [ip]
a022c10c ed0704eb bl       #0xa032e0c8
a022c110 005050e2 subs     r5, r0, #0
a022c114 d501000a beq      #0xa022c870
a022c118 802209e3 movw     r2, #0x9280
a022c11c 0400a0e1 mov      r0, r4
a022c120 042040e3 movt     r2, #4
a022c124 0110a0e3 mov      r1, #1
a022c128 0530a0e1 mov      r3, r5
a022c12c e90704eb bl       #0xa032e0d8
a022c130 0040a0e1 mov      r4, r0
a022c134 0500a0e1 mov      r0, r5
a022c138 e40704eb bl       #0xa032e0d0
a022c13c 010074e3 cmn      r4, #1
a022c140 9efeff1a bne      #0xa022bbc0
a022c144 15feffea b        #0xa022b9a0
a022c148 a40e0be3 movw     r0, #0xbea4
a022c14c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bea4 '[Warn]: Not support > 2 slices now'
a022c150 e5eb01eb bl       #0xa02a70ec
a022c154 77feffea b        #0xa022bb38
a022c158 640050e3 cmp      r0, #0x64
a022c15c 07005013 cmpne    r0, #7
a022c160 cd01008a bhi      #0xa022c89c
a022c164 0410a0e1 mov      r1, r4
a022c168 33e9ffeb bl       #0xa022663c
a022c16c 98010ce3 movw     r0, #0xc198
a022c170 0410a0e1 mov      r1, r4
a022c174 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c198 'idsp_dump addr %0.8X'
a022c178 dbeb01eb bl       #0xa02a70ec
a022c17c 050056e3 cmp      r6, #5
a022c180 8f00000a beq      #0xa022c3c4
a022c184 770a02eb bl       #0xa02aeb68
a022c188 341f00e3 movw     r1, #0xf34
a022c18c b0310ce3 movw     r3, #0xc1b0
a022c190 0020a0e1 mov      r2, r0
a022c194 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059c1b0 'idsp_0.bin'
a022c198 08008de2 add      r0, sp, #8
a022c19c 55104ae3 movt     r1, #0xa055 ; heuristic 0xa0550f34 '%c:\\%s'
a022c1a0 aa340bfa blx      #0xa04f9450
a022c1a4 0830dde5 ldrb     r3, [sp, #8]
a022c1a8 48008de2 add      r0, sp, #0x48
a022c1ac 000053e3 cmp      r3, #0
a022c1b0 3401000a beq      #0xa022c688
a022c1b4 08208de2 add      r2, sp, #8
a022c1b8 00c0a0e1 mov      ip, r0
a022c1bc 0130cce4 strb     r3, [ip], #1
a022c1c0 0130f2e5 ldrb     r3, [r2, #1]!
a022c1c4 000053e3 cmp      r3, #0
a022c1c8 fbffff1a bne      #0xa022c1bc
a022c1cc 0030a0e3 mov      r3, #0
a022c1d0 5c1b06e3 movw     r1, #0x6b5c
a022c1d4 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c1d8 0030cce5 strb     r3, [ip]
a022c1dc b90704eb bl       #0xa032e0c8
a022c1e0 006050e2 subs     r6, r0, #0
a022c1e4 7d01000a beq      #0xa022c7e0
a022c1e8 802209e3 movw     r2, #0x9280
a022c1ec 0400a0e1 mov      r0, r4
a022c1f0 042040e3 movt     r2, #4
a022c1f4 0110a0e3 mov      r1, #1
a022c1f8 0630a0e1 mov      r3, r6
a022c1fc b50704eb bl       #0xa032e0d8
a022c200 0040a0e1 mov      r4, r0
a022c204 0600a0e1 mov      r0, r6
a022c208 b00704eb bl       #0xa032e0d0
a022c20c caffffea b        #0xa022c13c
a022c210 7810efe6 uxtb     r1, r8
a022c214 8133a0e1 lsl      r3, r1, #7
a022c218 013243e0 sub      r3, r3, r1, lsl #4
a022c21c fe1f8de2 add      r1, sp, #0x3f8
a022c220 033081e0 add      r3, r1, r3
a022c224 f01213e5 ldr      r1, [r3, #-0x2f0]
a022c228 50feffea b        #0xa022bb70
a022c22c 7880efe6 uxtb     r8, r8
a022c230 8833a0e1 lsl      r3, r8, #7
a022c234 088243e0 sub      r8, r3, r8, lsl #4
a022c238 fe3f8de2 add      r3, sp, #0x3f8
a022c23c 083083e0 add      r3, r3, r8
a022c240 e41213e5 ldr      r1, [r3, #-0x2e4]
a022c244 5afeffea b        #0xa022bbb4
a022c248 460a02eb bl       #0xa02aeb68
a022c24c d4ce0be3 movw     ip, #0xbed4
a022c250 08808de2 add      r8, sp, #8
a022c254 59c04ae3 movt     ip, #0xa059 ; heuristic 0xa059bed4 'sec2idsp_L.bin'
a022c258 c81e0be3 movw     r1, #0xbec8
a022c25c 0c3097e5 ldr      r3, [r7, #0xc]
a022c260 0020a0e1 mov      r2, r0
a022c264 00c08de5 str      ip, [sp]
a022c268 0800a0e1 mov      r0, r8
a022c26c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022c270 76340bfa blx      #0xa04f9450
a022c274 0830dde5 ldrb     r3, [sp, #8]
a022c278 48008de2 add      r0, sp, #0x48
a022c27c 000053e3 cmp      r3, #0
a022c280 6201000a beq      #0xa022c810
a022c284 0810a0e1 mov      r1, r8
a022c288 0020a0e1 mov      r2, r0
a022c28c 0130c2e4 strb     r3, [r2], #1
a022c290 0130f1e5 ldrb     r3, [r1, #1]!
a022c294 000053e3 cmp      r3, #0
a022c298 fbffff1a bne      #0xa022c28c
a022c29c 0030a0e3 mov      r3, #0
a022c2a0 5c1b06e3 movw     r1, #0x6b5c
a022c2a4 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c2a8 0030c2e5 strb     r3, [r2]
a022c2ac 850704eb bl       #0xa032e0c8
a022c2b0 00a050e2 subs     sl, r0, #0
a022c2b4 6400000a beq      #0xa022c44c
a022c2b8 fe3f8de2 add      r3, sp, #0x3f8
a022c2bc 065069e0 rsb      r5, sb, r6
a022c2c0 055083e0 add      r5, r3, r5
a022c2c4 0110a0e3 mov      r1, #1
a022c2c8 f0239de5 ldr      r2, [sp, #0x3f0]
a022c2cc 0a30a0e1 mov      r3, sl
a022c2d0 f00215e5 ldr      r0, [r5, #-0x2f0]
a022c2d4 7f0704eb bl       #0xa032e0d8
a022c2d8 0040a0e1 mov      r4, r0
a022c2dc 0a00a0e1 mov      r0, sl
a022c2e0 7a0704eb bl       #0xa032e0d0
a022c2e4 100f0be3 movw     r0, #0xbf10
a022c2e8 f0239de5 ldr      r2, [sp, #0x3f0]
a022c2ec f01215e5 ldr      r1, [r5, #-0x2f0]
a022c2f0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bf10 'Idsp Sec2 dump success, Sec2IdspLeftCfgAddr 0x%X Sec2IdspCfgLength %d'
a022c2f4 7ceb01eb bl       #0xa02a70ec
a022c2f8 f4239de5 ldr      r2, [sp, #0x3f4]
a022c2fc 000052e3 cmp      r2, #0
a022c300 25feff1a bne      #0xa022bb9c
a022c304 2dfeffea b        #0xa022bbc0
a022c308 160a02eb bl       #0xa02aeb68
a022c30c 4cc00ce3 movw     ip, #0xc04c
a022c310 08808de2 add      r8, sp, #8
a022c314 59c04ae3 movt     ip, #0xa059 ; heuristic 0xa059c04c 'sec3idsp_L.bin'
a022c318 c81e0be3 movw     r1, #0xbec8
a022c31c 0c3097e5 ldr      r3, [r7, #0xc]
a022c320 0020a0e1 mov      r2, r0
a022c324 00c08de5 str      ip, [sp]
a022c328 0800a0e1 mov      r0, r8
a022c32c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022c330 46340bfa blx      #0xa04f9450
a022c334 0830dde5 ldrb     r3, [sp, #8]
a022c338 48008de2 add      r0, sp, #0x48
a022c33c 000053e3 cmp      r3, #0
a022c340 3801000a beq      #0xa022c828
a022c344 0810a0e1 mov      r1, r8
a022c348 0020a0e1 mov      r2, r0
a022c34c 0130c2e4 strb     r3, [r2], #1
a022c350 0130f1e5 ldrb     r3, [r1, #1]!
a022c354 000053e3 cmp      r3, #0
a022c358 fbffff1a bne      #0xa022c34c
a022c35c 0030a0e3 mov      r3, #0
a022c360 5c1b06e3 movw     r1, #0x6b5c
a022c364 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c368 0030c2e5 strb     r3, [r2]
a022c36c 550704eb bl       #0xa032e0c8
a022c370 007050e2 subs     r7, r0, #0
a022c374 3400000a beq      #0xa022c44c
a022c378 fe3f8de2 add      r3, sp, #0x3f8
a022c37c 065069e0 rsb      r5, sb, r6
a022c380 055083e0 add      r5, r3, r5
a022c384 f4239de5 ldr      r2, [sp, #0x3f4]
a022c388 0110a0e3 mov      r1, #1
a022c38c 0730a0e1 mov      r3, r7
a022c390 e40215e5 ldr      r0, [r5, #-0x2e4]
a022c394 4f0704eb bl       #0xa032e0d8
a022c398 0040a0e1 mov      r4, r0
a022c39c 0700a0e1 mov      r0, r7
a022c3a0 4a0704eb bl       #0xa032e0d0
a022c3a4 5c000ce3 movw     r0, #0xc05c
a022c3a8 e41215e5 ldr      r1, [r5, #-0x2e4]
a022c3ac f4239de5 ldr      r2, [sp, #0x3f4]
a022c3b0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c05c 'Idsp Sec3 dump success, Sec3IdspLeftCfgAddr 0x%X Sec3IdspCfgLength %d'
a022c3b4 4ceb01eb bl       #0xa02a70ec
a022c3b8 00feffea b        #0xa022bbc0
a022c3bc 0240a0e1 mov      r4, r2
a022c3c0 f1feffea b        #0xa022bf8c
a022c3c4 e70902eb bl       #0xa02aeb68
a022c3c8 341f00e3 movw     r1, #0xf34
a022c3cc 0020a0e1 mov      r2, r0
a022c3d0 103097e5 ldr      r3, [r7, #0x10]
a022c3d4 08008de2 add      r0, sp, #8
a022c3d8 55104ae3 movt     r1, #0xa055 ; heuristic 0xa0550f34 '%c:\\%s'
a022c3dc 1b340bfa blx      #0xa04f9450
a022c3e0 0830dde5 ldrb     r3, [sp, #8]
a022c3e4 48008de2 add      r0, sp, #0x48
a022c3e8 000053e3 cmp      r3, #0
a022c3ec 0901000a beq      #0xa022c818
a022c3f0 08208de2 add      r2, sp, #8
a022c3f4 00c0a0e1 mov      ip, r0
a022c3f8 0130cce4 strb     r3, [ip], #1
a022c3fc 0130f2e5 ldrb     r3, [r2, #1]!
a022c400 000053e3 cmp      r3, #0
a022c404 fbffff1a bne      #0xa022c3f8
a022c408 0030a0e3 mov      r3, #0
a022c40c 5c1b06e3 movw     r1, #0x6b5c
a022c410 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c414 0030cce5 strb     r3, [ip]
a022c418 2a0704eb bl       #0xa032e0c8
a022c41c 006050e2 subs     r6, r0, #0
a022c420 70ffff1a bne      #0xa022c1e8
a022c424 e40e0be3 movw     r0, #0xbee4
a022c428 101097e5 ldr      r1, [r7, #0x10]
a022c42c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c430 2deb01eb bl       #0xa02a70ec
a022c434 7500efe6 uxtb     r0, r5
a022c438 68fdffea b        #0xa022b9e0
a022c43c a40e0be3 movw     r0, #0xbea4
a022c440 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bea4 '[Warn]: Not support > 2 slices now'
a022c444 28eb01eb bl       #0xa02a70ec
a022c448 95feffea b        #0xa022bea4
a022c44c e40e0be3 movw     r0, #0xbee4
a022c450 0810a0e1 mov      r1, r8
a022c454 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c458 23eb01eb bl       #0xa02a70ec
a022c45c d7fdffea b        #0xa022bbc0
a022c460 a40e0be3 movw     r0, #0xbea4
a022c464 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bea4 '[Warn]: Not support > 2 slices now'
a022c468 1feb01eb bl       #0xa02a70ec
a022c46c f7fdffea b        #0xa022bc50
a022c470 fc0f0be3 movw     r0, #0xbffc
a022c474 f0239de5 ldr      r2, [sp, #0x3f0]
a022c478 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bffc 'Idsp Sec2 dump info are zero, Sec2IdspRightCfgAddr 0x%X Sec2IdspCfgLength %d'
a022c47c 1aeb01eb bl       #0xa02a70ec
a022c480 c1feffea b        #0xa022bf8c
a022c484 48010ce3 movw     r0, #0xc148
a022c488 f4239de5 ldr      r2, [sp, #0x3f4]
a022c48c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c148 'Idsp Sec3 dump info are zero, Sec3IdspRightCfgAddr 0x%X Sec3IdspCfgLength %d'
a022c490 15eb01eb bl       #0xa02a70ec
a022c494 c9fdffea b        #0xa022bbc0
a022c498 b20902eb bl       #0xa02aeb68
a022c49c 341f00e3 movw     r1, #0xf34
a022c4a0 0020a0e1 mov      r2, r0
a022c4a4 103097e5 ldr      r3, [r7, #0x10]
a022c4a8 08008de2 add      r0, sp, #8
a022c4ac 55104ae3 movt     r1, #0xa055 ; heuristic 0xa0550f34 '%c:\\%s'
a022c4b0 e6330bfa blx      #0xa04f9450
a022c4b4 0830dde5 ldrb     r3, [sp, #8]
a022c4b8 48008de2 add      r0, sp, #0x48
a022c4bc 000053e3 cmp      r3, #0
a022c4c0 e400000a beq      #0xa022c858
a022c4c4 08208de2 add      r2, sp, #8
a022c4c8 00c0a0e1 mov      ip, r0
a022c4cc 0130cce4 strb     r3, [ip], #1
a022c4d0 0130f2e5 ldrb     r3, [r2, #1]!
a022c4d4 000053e3 cmp      r3, #0
a022c4d8 fbffff1a bne      #0xa022c4cc
a022c4dc 0030a0e3 mov      r3, #0
a022c4e0 5c1b06e3 movw     r1, #0x6b5c
a022c4e4 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c4e8 0030cce5 strb     r3, [ip]
a022c4ec f50604eb bl       #0xa032e0c8
a022c4f0 005050e2 subs     r5, r0, #0
a022c4f4 07ffff1a bne      #0xa022c118
a022c4f8 e40e0be3 movw     r0, #0xbee4
a022c4fc 101097e5 ldr      r1, [r7, #0x10]
a022c500 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c504 f8ea01eb bl       #0xa02a70ec
a022c508 0500a0e1 mov      r0, r5
a022c50c 33fdffea b        #0xa022b9e0
a022c510 48010ce3 movw     r0, #0xc148
a022c514 f4239de5 ldr      r2, [sp, #0x3f4]
a022c518 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c148 'Idsp Sec3 dump info are zero, Sec3IdspRightCfgAddr 0x%X Sec3IdspCfgLength %d'
a022c51c f2ea01eb bl       #0xa02a70ec
a022c520 3cfeffea b        #0xa022be18
a022c524 fc0f0be3 movw     r0, #0xbffc
a022c528 f0239de5 ldr      r2, [sp, #0x3f0]
a022c52c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bffc 'Idsp Sec2 dump info are zero, Sec2IdspRightCfgAddr 0x%X Sec2IdspCfgLength %d'
a022c530 edea01eb bl       #0xa02a70ec
a022c534 fefdffea b        #0xa022bd34
a022c538 8a0902eb bl       #0xa02aeb68
a022c53c 4c300ce3 movw     r3, #0xc04c
a022c540 08808de2 add      r8, sp, #8
a022c544 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059c04c 'sec3idsp_L.bin'
a022c548 c81e0be3 movw     r1, #0xbec8
a022c54c 0020a0e1 mov      r2, r0
a022c550 00308de5 str      r3, [sp]
a022c554 0800a0e1 mov      r0, r8
a022c558 0c3097e5 ldr      r3, [r7, #0xc]
a022c55c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022c560 ba330bfa blx      #0xa04f9450
a022c564 0830dde5 ldrb     r3, [sp, #8]
a022c568 48008de2 add      r0, sp, #0x48
a022c56c 000053e3 cmp      r3, #0
a022c570 cf00000a beq      #0xa022c8b4
a022c574 0810a0e1 mov      r1, r8
a022c578 0020a0e1 mov      r2, r0
a022c57c 0130c2e4 strb     r3, [r2], #1
a022c580 0130f1e5 ldrb     r3, [r1, #1]!
a022c584 000053e3 cmp      r3, #0
a022c588 fbffff1a bne      #0xa022c57c
a022c58c 0030a0e3 mov      r3, #0
a022c590 5c1b06e3 movw     r1, #0x6b5c
a022c594 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c598 0030c2e5 strb     r3, [r2]
a022c59c c90604eb bl       #0xa032e0c8
a022c5a0 006050e2 subs     r6, r0, #0
a022c5a4 a8ffff0a beq      #0xa022c44c
a022c5a8 f4239de5 ldr      r2, [sp, #0x3f4]
a022c5ac 0110a0e3 mov      r1, #1
a022c5b0 0630a0e1 mov      r3, r6
a022c5b4 14019de5 ldr      r0, [sp, #0x114]
a022c5b8 c60604eb bl       #0xa032e0d8
a022c5bc 0040a0e1 mov      r4, r0
a022c5c0 0600a0e1 mov      r0, r6
a022c5c4 c10604eb bl       #0xa032e0d0
a022c5c8 5c000ce3 movw     r0, #0xc05c
a022c5cc 14119de5 ldr      r1, [sp, #0x114]
a022c5d0 f4239de5 ldr      r2, [sp, #0x3f4]
a022c5d4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c05c 'Idsp Sec3 dump success, Sec3IdspLeftCfgAddr 0x%X Sec3IdspCfgLength %d'
a022c5d8 c3ea01eb bl       #0xa02a70ec
a022c5dc 75feffea b        #0xa022bfb8
a022c5e0 600902eb bl       #0xa02aeb68
a022c5e4 d43e0be3 movw     r3, #0xbed4
a022c5e8 08808de2 add      r8, sp, #8
a022c5ec 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059bed4 'sec2idsp_L.bin'
a022c5f0 c81e0be3 movw     r1, #0xbec8
a022c5f4 0020a0e1 mov      r2, r0
a022c5f8 00308de5 str      r3, [sp]
a022c5fc 0800a0e1 mov      r0, r8
a022c600 0c3097e5 ldr      r3, [r7, #0xc]
a022c604 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022c608 90330bfa blx      #0xa04f9450
a022c60c 0830dde5 ldrb     r3, [sp, #8]
a022c610 48008de2 add      r0, sp, #0x48
a022c614 000053e3 cmp      r3, #0
a022c618 9b00000a beq      #0xa022c88c
a022c61c 0810a0e1 mov      r1, r8
a022c620 0020a0e1 mov      r2, r0
a022c624 0130c2e4 strb     r3, [r2], #1
a022c628 0130f1e5 ldrb     r3, [r1, #1]!
a022c62c 000053e3 cmp      r3, #0
a022c630 fbffff1a bne      #0xa022c624
a022c634 0030a0e3 mov      r3, #0
a022c638 5c1b06e3 movw     r1, #0x6b5c
a022c63c 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c640 0030c2e5 strb     r3, [r2]
a022c644 9f0604eb bl       #0xa032e0c8
a022c648 006050e2 subs     r6, r0, #0
a022c64c 7700000a beq      #0xa022c830
a022c650 f0239de5 ldr      r2, [sp, #0x3f0]
a022c654 0110a0e3 mov      r1, #1
a022c658 0630a0e1 mov      r3, r6
a022c65c 08019de5 ldr      r0, [sp, #0x108]
a022c660 9c0604eb bl       #0xa032e0d8
a022c664 0040a0e1 mov      r4, r0
a022c668 0600a0e1 mov      r0, r6
a022c66c 970604eb bl       #0xa032e0d0
a022c670 100f0be3 movw     r0, #0xbf10
a022c674 08119de5 ldr      r1, [sp, #0x108]
a022c678 f0239de5 ldr      r2, [sp, #0x3f0]
a022c67c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bf10 'Idsp Sec2 dump success, Sec2IdspLeftCfgAddr 0x%X Sec2IdspCfgLength %d'
a022c680 99ea01eb bl       #0xa02a70ec
a022c684 12feffea b        #0xa022bed4
a022c688 00c0a0e1 mov      ip, r0
a022c68c cefeffea b        #0xa022c1cc
a022c690 340902eb bl       #0xa02aeb68
a022c694 4c300ce3 movw     r3, #0xc04c
a022c698 08808de2 add      r8, sp, #8
a022c69c 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059c04c 'sec3idsp_L.bin'
a022c6a0 c81e0be3 movw     r1, #0xbec8
a022c6a4 0020a0e1 mov      r2, r0
a022c6a8 00308de5 str      r3, [sp]
a022c6ac 0800a0e1 mov      r0, r8
a022c6b0 103097e5 ldr      r3, [r7, #0x10]
a022c6b4 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022c6b8 64330bfa blx      #0xa04f9450
a022c6bc 0830dde5 ldrb     r3, [sp, #8]
a022c6c0 48008de2 add      r0, sp, #0x48
a022c6c4 000053e3 cmp      r3, #0
a022c6c8 7100000a beq      #0xa022c894
a022c6cc 0810a0e1 mov      r1, r8
a022c6d0 0020a0e1 mov      r2, r0
a022c6d4 0130c2e4 strb     r3, [r2], #1
a022c6d8 0130f1e5 ldrb     r3, [r1, #1]!
a022c6dc 000053e3 cmp      r3, #0
a022c6e0 fbffff1a bne      #0xa022c6d4
a022c6e4 0030a0e3 mov      r3, #0
a022c6e8 5c1b06e3 movw     r1, #0x6b5c
a022c6ec 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c6f0 0030c2e5 strb     r3, [r2]
a022c6f4 730604eb bl       #0xa032e0c8
a022c6f8 006050e2 subs     r6, r0, #0
a022c6fc 3d00000a beq      #0xa022c7f8
a022c700 f4239de5 ldr      r2, [sp, #0x3f4]
a022c704 0110a0e3 mov      r1, #1
a022c708 0630a0e1 mov      r3, r6
a022c70c 44039de5 ldr      r0, [sp, #0x344]
a022c710 700604eb bl       #0xa032e0d8
a022c714 0050a0e1 mov      r5, r0
a022c718 0600a0e1 mov      r0, r6
a022c71c 6b0604eb bl       #0xa032e0d0
a022c720 5c000ce3 movw     r0, #0xc05c
a022c724 44139de5 ldr      r1, [sp, #0x344]
a022c728 f4239de5 ldr      r2, [sp, #0x3f4]
a022c72c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c05c 'Idsp Sec3 dump success, Sec3IdspLeftCfgAddr 0x%X Sec3IdspCfgLength %d'
a022c730 6dea01eb bl       #0xa02a70ec
a022c734 89fdffea b        #0xa022bd60
a022c738 0a0902eb bl       #0xa02aeb68
a022c73c d43e0be3 movw     r3, #0xbed4
a022c740 08808de2 add      r8, sp, #8
a022c744 59304ae3 movt     r3, #0xa059 ; heuristic 0xa059bed4 'sec2idsp_L.bin'
a022c748 c81e0be3 movw     r1, #0xbec8
a022c74c 0020a0e1 mov      r2, r0
a022c750 00308de5 str      r3, [sp]
a022c754 0800a0e1 mov      r0, r8
a022c758 103097e5 ldr      r3, [r7, #0x10]
a022c75c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059bec8 '%c:\\%s_%s'
a022c760 3a330bfa blx      #0xa04f9450
a022c764 0830dde5 ldrb     r3, [sp, #8]
a022c768 48008de2 add      r0, sp, #0x48
a022c76c 000053e3 cmp      r3, #0
a022c770 4d00000a beq      #0xa022c8ac
a022c774 0810a0e1 mov      r1, r8
a022c778 0020a0e1 mov      r2, r0
a022c77c 0130c2e4 strb     r3, [r2], #1
a022c780 0130f1e5 ldrb     r3, [r1, #1]!
a022c784 000053e3 cmp      r3, #0
a022c788 fbffff1a bne      #0xa022c77c
a022c78c 0030a0e3 mov      r3, #0
a022c790 5c1b06e3 movw     r1, #0x6b5c
a022c794 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0576b5c 'w'
a022c798 0030c2e5 strb     r3, [r2]
a022c79c 490604eb bl       #0xa032e0c8
a022c7a0 006050e2 subs     r6, r0, #0
a022c7a4 2100000a beq      #0xa022c830
a022c7a8 f0239de5 ldr      r2, [sp, #0x3f0]
a022c7ac 0110a0e3 mov      r1, #1
a022c7b0 0630a0e1 mov      r3, r6
a022c7b4 38039de5 ldr      r0, [sp, #0x338]
a022c7b8 460604eb bl       #0xa032e0d8
a022c7bc 0050a0e1 mov      r5, r0
a022c7c0 0600a0e1 mov      r0, r6
a022c7c4 410604eb bl       #0xa032e0d0
a022c7c8 100f0be3 movw     r0, #0xbf10
a022c7cc 38139de5 ldr      r1, [sp, #0x338]
a022c7d0 f0239de5 ldr      r2, [sp, #0x3f0]
a022c7d4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bf10 'Idsp Sec2 dump success, Sec2IdspLeftCfgAddr 0x%X Sec2IdspCfgLength %d'
a022c7d8 43ea01eb bl       #0xa02a70ec
a022c7dc 26fdffea b        #0xa022bc7c
a022c7e0 e40e0be3 movw     r0, #0xbee4
a022c7e4 b0110ce3 movw     r1, #0xc1b0
a022c7e8 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c1b0 'idsp_0.bin'
a022c7ec 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c7f0 3dea01eb bl       #0xa02a70ec
a022c7f4 87fdffea b        #0xa022be18
a022c7f8 e40e0be3 movw     r0, #0xbee4
a022c7fc 0810a0e1 mov      r1, r8
a022c800 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c804 38ea01eb bl       #0xa02a70ec
a022c808 7500efe6 uxtb     r0, r5
a022c80c 73fcffea b        #0xa022b9e0
a022c810 0020a0e1 mov      r2, r0
a022c814 a0feffea b        #0xa022c29c
a022c818 00c0a0e1 mov      ip, r0
a022c81c f9feffea b        #0xa022c408
a022c820 00c0a0e1 mov      ip, r0
a022c824 34feffea b        #0xa022c0fc
a022c828 0020a0e1 mov      r2, r0
a022c82c cafeffea b        #0xa022c35c
a022c830 e40e0be3 movw     r0, #0xbee4
a022c834 0810a0e1 mov      r1, r8
a022c838 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c83c 2aea01eb bl       #0xa02a70ec
a022c840 0000a0e3 mov      r0, #0
a022c844 65fcffea b        #0xa022b9e0
a022c848 0020a0e1 mov      r2, r0
a022c84c bafdffea b        #0xa022bf3c
a022c850 0020a0e1 mov      r2, r0
a022c854 22fdffea b        #0xa022bce4
a022c858 00c0a0e1 mov      ip, r0
a022c85c 1effffea b        #0xa022c4dc
a022c860 0020a0e1 mov      r2, r0
a022c864 57fdffea b        #0xa022bdc8
a022c868 0020a0e1 mov      r2, r0
a022c86c ebfdffea b        #0xa022c020
a022c870 e40e0be3 movw     r0, #0xbee4
a022c874 b0110ce3 movw     r1, #0xc1b0
a022c878 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059bee4 'File open fail. Skip dumping debug data %s'
a022c87c 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c1b0 'idsp_0.bin'
a022c880 19ea01eb bl       #0xa02a70ec
a022c884 0500a0e1 mov      r0, r5
a022c888 54fcffea b        #0xa022b9e0
a022c88c 0020a0e1 mov      r2, r0
a022c890 67ffffea b        #0xa022c634
a022c894 0020a0e1 mov      r2, r0
a022c898 91ffffea b        #0xa022c6e4
a022c89c 653040e2 sub      r3, r0, #0x65
a022c8a0 010053e3 cmp      r3, #1
a022c8a4 2efeff9a bls      #0xa022c164
a022c8a8 3cfcffea b        #0xa022b9a0
a022c8ac 0020a0e1 mov      r2, r0
a022c8b0 b5ffffea b        #0xa022c78c
a022c8b4 0020a0e1 mov      r2, r0
a022c8b8 33ffffea b        #0xa022c58c
