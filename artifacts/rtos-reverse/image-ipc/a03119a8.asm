; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a03119a8 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03119ac 0030a0e3 mov      r3, #0
a03119b0 028b2ded vpush    {d8}
a03119b4 7cd04de2 sub      sp, sp, #0x7c
a03119b8 0140a0e1 mov      r4, r1
a03119bc 0050a0e1 mov      r5, r0
a03119c0 006091e5 ldr      r6, [r1]
a03119c4 38308de5 str      r3, [sp, #0x38]
a03119c8 3c308de5 str      r3, [sp, #0x3c]
a03119cc 030056e1 cmp      r6, r3
a03119d0 64308de5 str      r3, [sp, #0x64]
a03119d4 68308de5 str      r3, [sp, #0x68]
a03119d8 6c308de5 str      r3, [sp, #0x6c]
a03119dc 70308de5 str      r3, [sp, #0x70]
a03119e0 74308de5 str      r3, [sp, #0x74]
a03119e4 54308de5 str      r3, [sp, #0x54]
a03119e8 58308de5 str      r3, [sp, #0x58]
a03119ec 5c308de5 str      r3, [sp, #0x5c]
a03119f0 60308de5 str      r3, [sp, #0x60]
a03119f4 9100000a beq      #0xa0311c40
a03119f8 081091e5 ldr      r1, [r1, #8]
a03119fc 013700e3 movw     r3, #0x701
a0311a00 012100e3 movw     r2, #0x101
a0311a04 143042e3 movt     r3, #0x2014
a0311a08 132042e3 movt     r2, #0x2013
a0311a0c 030051e1 cmp      r1, r3
a0311a10 02005111 cmpne    r1, r2
a0311a14 0160a013 movne    r6, #1
a0311a18 0060a003 moveq    r6, #0
a0311a1c 6802001a bne      #0xa03123c4
a0311a20 0c1094e5 ldr      r1, [r4, #0xc]
a0311a24 142094e5 ldr      r2, [r4, #0x14]
a0311a28 243094e5 ldr      r3, [r4, #0x24]
a0311a2c 010041e2 sub      r0, r1, #1
a0311a30 100253e1 cmp      r3, r0, lsl r2
a0311a34 7802008a bhi      #0xa031241c
a0311a38 101094e5 ldr      r1, [r4, #0x10]
a0311a3c 182094e5 ldr      r2, [r4, #0x18]
a0311a40 287094e5 ldr      r7, [r4, #0x28]
a0311a44 013041e2 sub      r3, r1, #1
a0311a48 130257e1 cmp      r7, r3, lsl r2
a0311a4c 7802008a bhi      #0xa0312434
a0311a50 3c3094e5 ldr      r3, [r4, #0x3c]
a0311a54 000053e3 cmp      r3, #0
a0311a58 7c02000a beq      #0xa0312450
a0311a5c 2e0bd4ed vldr     d16, [r4, #0xb8]
a0311a60 0080a0e3 mov      r8, #0
a0311a64 0090a0e3 mov      sb, #0
a0311a68 400bf5ee vcmp.f64 d16, #0
a0311a6c 10faf1ee vmrs     apsr_nzcv, fpscr
a0311a70 0200000a beq      #0xa0311a80
a0311a74 0030d5e5 ldrb     r3, [r5]
a0311a78 010053e3 cmp      r3, #1
a0311a7c 5c02000a beq      #0xa03123f4
a0311a80 042094e5 ldr      r2, [r4, #4]
a0311a84 012c12e2 ands     r2, r2, #0x100
a0311a88 6c00001a bne      #0xa0311c40
a0311a8c 407094e5 ldr      r7, [r4, #0x40]
a0311a90 1cc094e5 ldr      ip, [r4, #0x1c]
a0311a94 0c0057e1 cmp      r7, ip
a0311a98 2c208d35 strlo    r2, [sp, #0x2c]
a0311a9c 9501002a bhs      #0xa03120f8
a0311aa0 2c90d4e5 ldrb     sb, [r4, #0x2c]
a0311aa4 2d80d4e5 ldrb     r8, [r4, #0x2d]
a0311aa8 2fb0d4e5 ldrb     fp, [r4, #0x2f]
a0311aac 2ea0d4e5 ldrb     sl, [r4, #0x2e]
a0311ab0 000059e3 cmp      sb, #0
a0311ab4 00005813 cmpne    r8, #0
a0311ab8 5100d4e5 ldrb     r0, [r4, #0x51]
a0311abc 01e0a003 moveq    lr, #1
a0311ac0 00e0a013 movne    lr, #0
a0311ac4 00005be3 cmp      fp, #0
a0311ac8 01e08e03 orreq    lr, lr, #1
a0311acc 5010d4e5 ldrb     r1, [r4, #0x50]
a0311ad0 00005ae3 cmp      sl, #0
a0311ad4 01e08e03 orreq    lr, lr, #1
a0311ad8 5320d4e5 ldrb     r2, [r4, #0x53]
a0311adc 000050e3 cmp      r0, #0
a0311ae0 01e08e03 orreq    lr, lr, #1
a0311ae4 5230d4e5 ldrb     r3, [r4, #0x52]
a0311ae8 000051e3 cmp      r1, #0
a0311aec 01e08e03 orreq    lr, lr, #1
a0311af0 000052e3 cmp      r2, #0
a0311af4 01e08e03 orreq    lr, lr, #1
a0311af8 000053e3 cmp      r3, #0
a0311afc 01e08e03 orreq    lr, lr, #1
a0311b00 00005ee3 cmp      lr, #0
a0311b04 1b02001a bne      #0xa0312378
a0311b08 48e094e5 ldr      lr, [r4, #0x48]
a0311b0c 24308de5 str      r3, [sp, #0x24]
a0311b10 243094e5 ldr      r3, [r4, #0x24]
a0311b14 28208de5 str      r2, [sp, #0x28]
a0311b18 9e0000e0 mul      r0, lr, r0
a0311b1c 20c08de5 str      ip, [sp, #0x20]
a0311b20 1c308de5 str      r3, [sp, #0x1c]
a0311b24 3bd207fa blx      #0xa0506418
a0311b28 1c309de5 ldr      r3, [sp, #0x1c]
a0311b2c 077080e0 add      r7, r0, r7
a0311b30 0910a0e1 mov      r1, sb
a0311b34 930800e0 mul      r0, r3, r8
a0311b38 36d207fa blx      #0xa0506418
a0311b3c 20c09de5 ldr      ip, [sp, #0x20]
a0311b40 24309de5 ldr      r3, [sp, #0x24]
a0311b44 28209de5 ldr      r2, [sp, #0x28]
a0311b48 0c0080e0 add      r0, r0, ip
a0311b4c 000057e1 cmp      r7, r0
a0311b50 1f00009a bls      #0xa0311bd4
a0311b54 287094e5 ldr      r7, [r4, #0x28]
a0311b58 202094e5 ldr      r2, [r4, #0x20]
a0311b5c 600906e3 movw     r0, #0x6960
a0311b60 0c10a0e1 mov      r1, ip
a0311b64 80028de8 stm      sp, {r7, sb}
a0311b68 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6960 'Error: WARP Calib vin geo x %d, y %d, w %d, h %d, HorSmp %d/%d, VerSmp %d/%d cannot cover'
a0311b6c 1c309de5 ldr      r3, [sp, #0x1c]
a0311b70 08808de5 str      r8, [sp, #8]
a0311b74 0ca08de5 str      sl, [sp, #0xc]
a0311b78 10b08de5 str      fp, [sp, #0x10]
a0311b7c 5a55feeb bl       #0xa02a70ec
a0311b80 4c7094e5 ldr      r7, [r4, #0x4c]
a0311b84 c00002e3 movw     r0, #0x20c0
a0311b88 5060d4e5 ldrb     r6, [r4, #0x50]
a0311b8c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d20c0 '       current vin geo x %d, y %d, w %d, h %d, HorSmp %d/%d, VerSmp %d/%d'
a0311b90 5150d4e5 ldrb     r5, [r4, #0x51]
a0311b94 52e0d4e5 ldrb     lr, [r4, #0x52]
a0311b98 53c0d4e5 ldrb     ip, [r4, #0x53]
a0311b9c 401094e5 ldr      r1, [r4, #0x40]
a0311ba0 442094e5 ldr      r2, [r4, #0x44]
a0311ba4 483094e5 ldr      r3, [r4, #0x48]
a0311ba8 00708de5 str      r7, [sp]
a0311bac 04608de5 str      r6, [sp, #4]
a0311bb0 08508de5 str      r5, [sp, #8]
a0311bb4 0ce08de5 str      lr, [sp, #0xc]
a0311bb8 10c08de5 str      ip, [sp, #0x10]
a0311bbc 4a55feeb bl       #0xa02a70ec
a0311bc0 0070e0e3 mvn      r7, #0
a0311bc4 0700a0e1 mov      r0, r7
a0311bc8 7cd08de2 add      sp, sp, #0x7c
a0311bcc 028bbdec vpop     {d8}
a0311bd0 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0311bd4 2c109de5 ldr      r1, [sp, #0x2c]
a0311bd8 4c0094e5 ldr      r0, [r4, #0x4c]
a0311bdc 28c08de5 str      ip, [sp, #0x28]
a0311be0 01e021e2 eor      lr, r1, #1
a0311be4 0310a0e1 mov      r1, r3
a0311be8 010040e2 sub      r0, r0, #1
a0311bec 01300ee2 and      r3, lr, #1
a0311bf0 900200e0 mul      r0, r0, r2
a0311bf4 24308de5 str      r3, [sp, #0x24]
a0311bf8 06d207fa blx      #0xa0506418
a0311bfc 287094e5 ldr      r7, [r4, #0x28]
a0311c00 0a10a0e1 mov      r1, sl
a0311c04 44e094e5 ldr      lr, [r4, #0x44]
a0311c08 012047e2 sub      r2, r7, #1
a0311c0c 0e3080e0 add      r3, r0, lr
a0311c10 920b00e0 mul      r0, r2, fp
a0311c14 20308de5 str      r3, [sp, #0x20]
a0311c18 fed107fa blx      #0xa0506418
a0311c1c 202094e5 ldr      r2, [r4, #0x20]
a0311c20 20109de5 ldr      r1, [sp, #0x20]
a0311c24 24309de5 ldr      r3, [sp, #0x24]
a0311c28 020080e0 add      r0, r0, r2
a0311c2c 28c09de5 ldr      ip, [sp, #0x28]
a0311c30 000051e1 cmp      r1, r0
a0311c34 01308383 orrhi    r3, r3, #1
a0311c38 000053e3 cmp      r3, #0
a0311c3c c6ffff1a bne      #0xa0311b5c
a0311c40 541094e5 ldr      r1, [r4, #0x54]
a0311c44 582094e5 ldr      r2, [r4, #0x58]
a0311c48 643094e5 ldr      r3, [r4, #0x64]
a0311c4c 000051e3 cmp      r1, #0
a0311c50 68c094e5 ldr      ip, [r4, #0x68]
a0311c54 0180a011 movne    r8, r1
a0311c58 5c1094e5 ldr      r1, [r4, #0x5c]
a0311c5c 48809405 ldreq    r8, [r4, #0x48]
a0311c60 000052e3 cmp      r2, #0
a0311c64 0270a011 movne    r7, r2
a0311c68 4c709405 ldreq    r7, [r4, #0x4c]
a0311c6c 012083e0 add      r2, r3, r1
a0311c70 080052e1 cmp      r2, r8
a0311c74 602094e5 ldr      r2, [r4, #0x60]
a0311c78 c201008a bhi      #0xa0312388
a0311c7c 02008ce0 add      r0, ip, r2
a0311c80 070050e1 cmp      r0, r7
a0311c84 bf01008a bhi      #0xa0312388
a0311c88 6c1094e5 ldr      r1, [r4, #0x6c]
a0311c8c 702094e5 ldr      r2, [r4, #0x70]
a0311c90 000051e3 cmp      r1, #0
a0311c94 ce01000a beq      #0xa03123d4
a0311c98 000052e3 cmp      r2, #0
a0311c9c cc01000a beq      #0xa03123d4
a0311ca0 841094e5 ldr      r1, [r4, #0x84]
a0311ca4 882094e5 ldr      r2, [r4, #0x88]
a0311ca8 000051e3 cmp      r1, #0
a0311cac cc01000a beq      #0xa03123e4
a0311cb0 000052e3 cmp      r2, #0
a0311cb4 ca01000a beq      #0xa03123e4
a0311cb8 3d3600e3 movw     r3, #0x63d
a0311cbc 4c314ae3 movt     r3, #0xa14c
a0311cc0 0030d3e5 ldrb     r3, [r3]
a0311cc4 000053e3 cmp      r3, #0
a0311cc8 3500001a bne      #0xa0311da4
a0311ccc 0020d5e5 ldrb     r2, [r5]
a0311cd0 40008de2 add      r0, sp, #0x40
a0311cd4 0330d5e5 ldrb     r3, [r5, #3]
a0311cd8 34108de2 add      r1, sp, #0x34
a0311cdc 4020cde5 strb     r2, [sp, #0x40]
a0311ce0 4130cde5 strb     r3, [sp, #0x41]
a0311ce4 e5daffeb bl       #0xa0308880
a0311ce8 007050e2 subs     r7, r0, #0
a0311cec 750100ba blt      #0xa03122c8
a0311cf0 0010a0e3 mov      r1, #0
a0311cf4 34009de5 ldr      r0, [sp, #0x34]
a0311cf8 dba902eb bl       #0xa03bc46c
a0311cfc 0010d5e5 ldrb     r1, [r5]
a0311d00 000051e3 cmp      r1, #0
a0311d04 e500000a beq      #0xa03120a0
a0311d08 010051e3 cmp      r1, #1
a0311d0c d700001a bne      #0xa0312070
a0311d10 3c108de2 add      r1, sp, #0x3c
a0311d14 40008de2 add      r0, sp, #0x40
a0311d18 8ddaffeb bl       #0xa0308754
a0311d1c 3c309de5 ldr      r3, [sp, #0x3c]
a0311d20 7c0a02e3 movw     r0, #0x2a7c
a0311d24 841800e3 movw     r1, #0x884
a0311d28 d42800e3 movw     r2, #0x8d4
a0311d2c 050040e3 movt     r0, #5
a0311d30 061040e3 movt     r1, #6
a0311d34 062040e3 movt     r2, #6
a0311d38 1ac983e2 add      ip, r3, #0x68000
a0311d3c 000083e0 add      r0, r3, r0
a0311d40 011083e0 add      r1, r3, r1
a0311d44 022083e0 add      r2, r3, r2
a0311d48 528a83e2 add      r8, r3, #0x52000
a0311d4c 773a83e2 add      r3, r3, #0x77000
a0311d50 a98e88e2 add      r8, r8, #0xa90
a0311d54 b69f83e2 add      sb, r3, #0x2d8
a0311d58 b7af83e2 add      sl, r3, #0x2dc
a0311d5c 56ce8ce2 add      ip, ip, #0x560
a0311d60 64408de5 str      r4, [sp, #0x64]
a0311d64 6cc08de5 str      ip, [sp, #0x6c]
a0311d68 74008de5 str      r0, [sp, #0x74]
a0311d6c 58108de5 str      r1, [sp, #0x58]
a0311d70 60208de5 str      r2, [sp, #0x60]
a0311d74 0030d5e5 ldrb     r3, [r5]
a0311d78 010053e3 cmp      r3, #1
a0311d7c 5e01000a beq      #0xa03122fc
a0311d80 0500a0e1 mov      r0, r5
a0311d84 64108de2 add      r1, sp, #0x64
a0311d88 54208de2 add      r2, sp, #0x54
a0311d8c 696c00eb bl       #0xa032cf38
a0311d90 007050e2 subs     r7, r0, #0
a0311d94 4f01000a beq      #0xa03122d8
a0311d98 34009de5 ldr      r0, [sp, #0x34]
a0311d9c bda902eb bl       #0xa03bc498
a0311da0 b80000ea b        #0xa0312088
a0311da4 e00906e3 movw     r0, #0x69e0
a0311da8 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e69e0 'AmbaDSP_ImgCalcWarpCompensation:'
a0311dac ce54feeb bl       #0xa02a70ec
a0311db0 04e095e5 ldr      lr, [r5, #4]
a0311db4 380c01e3 movw     r0, #0x1c38
a0311db8 08c0d5e5 ldrb     ip, [r5, #8]
a0311dbc 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d1c38 '     Pipe %d, Algo %d, Func %d, Ctx %d, Bch %d, Cfg %d '
a0311dc0 0370d5e5 ldrb     r7, [r5, #3]
a0311dc4 0120d5e5 ldrb     r2, [r5, #1]
a0311dc8 0230d5e5 ldrb     r3, [r5, #2]
a0311dcc 0010d5e5 ldrb     r1, [r5]
a0311dd0 80408de8 stm      sp, {r7, lr}
a0311dd4 08c08de5 str      ip, [sp, #8]
a0311dd8 c354feeb bl       #0xa02a70ec
a0311ddc 040a06e3 movw     r0, #0x6a04
a0311de0 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6a04 'AMBA_DSP_IMG_WARP_CALC_INFO_s:'
a0311de4 c054feeb bl       #0xa02a70ec
a0311de8 240a06e3 movw     r0, #0x6a24
a0311dec 001094e5 ldr      r1, [r4]
a0311df0 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6a24 '     WarpEnb = %d'
a0311df4 bc54feeb bl       #0xa02a70ec
a0311df8 e80306e3 movw     r0, #0x63e8
a0311dfc 041094e5 ldr      r1, [r4, #4]
a0311e00 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e63e8 '     Control = %d'
a0311e04 b854feeb bl       #0xa02a70ec
a0311e08 380a06e3 movw     r0, #0x6a38
a0311e0c d82bc4e1 ldrd     r2, r3, [r4, #0xb8]
a0311e10 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6a38 '     theta = %f'
a0311e14 b454feeb bl       #0xa02a70ec
a0311e18 003094e5 ldr      r3, [r4]
a0311e1c 000053e3 cmp      r3, #0
a0311e20 be00001a bne      #0xa0312120
a0311e24 380603e3 movw     r0, #0x3638
a0311e28 ba8b9fed vldr     d8, [pc, #0x2e8]
a0311e2c 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e3638 '     VinSensorGeo:'
a0311e30 ad54feeb bl       #0xa02a70ec
a0311e34 640302e3 movw     r0, #0x2364
a0311e38 401094e5 ldr      r1, [r4, #0x40]
a0311e3c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2364 '         StartX = %d'
a0311e40 a954feeb bl       #0xa02a70ec
a0311e44 800302e3 movw     r0, #0x2380
a0311e48 441094e5 ldr      r1, [r4, #0x44]
a0311e4c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2380 '         StartY = %d'
a0311e50 a554feeb bl       #0xa02a70ec
a0311e54 9c0302e3 movw     r0, #0x239c
a0311e58 481094e5 ldr      r1, [r4, #0x48]
a0311e5c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d239c '         Width  = %d'
a0311e60 a154feeb bl       #0xa02a70ec
a0311e64 b80302e3 movw     r0, #0x23b8
a0311e68 4c1094e5 ldr      r1, [r4, #0x4c]
a0311e6c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23b8 '         Height = %d'
a0311e70 9d54feeb bl       #0xa02a70ec
a0311e74 d40302e3 movw     r0, #0x23d4
a0311e78 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23d4 '         HSubSample:'
a0311e7c 9a54feeb bl       #0xa02a70ec
a0311e80 f00302e3 movw     r0, #0x23f0
a0311e84 5010d4e5 ldrb     r1, [r4, #0x50]
a0311e88 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23f0 '             FactorNum = %d'
a0311e8c 9654feeb bl       #0xa02a70ec
a0311e90 100402e3 movw     r0, #0x2410
a0311e94 5110d4e5 ldrb     r1, [r4, #0x51]
a0311e98 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2410 '             FactorDen = %d'
a0311e9c 9254feeb bl       #0xa02a70ec
a0311ea0 300402e3 movw     r0, #0x2430
a0311ea4 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2430 '         VSubSample:'
a0311ea8 8f54feeb bl       #0xa02a70ec
a0311eac f00302e3 movw     r0, #0x23f0
a0311eb0 5210d4e5 ldrb     r1, [r4, #0x52]
a0311eb4 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23f0 '             FactorNum = %d'
a0311eb8 8b54feeb bl       #0xa02a70ec
a0311ebc 100402e3 movw     r0, #0x2410
a0311ec0 5310d4e5 ldrb     r1, [r4, #0x53]
a0311ec4 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2410 '             FactorDen = %d'
a0311ec8 8754feeb bl       #0xa02a70ec
a0311ecc 480a06e3 movw     r0, #0x6a48
a0311ed0 541094e5 ldr      r1, [r4, #0x54]
a0311ed4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6a48 '     R2rOutWinDim.Width  = %d'
a0311ed8 8354feeb bl       #0xa02a70ec
a0311edc 680a06e3 movw     r0, #0x6a68
a0311ee0 581094e5 ldr      r1, [r4, #0x58]
a0311ee4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6a68 '     R2rOutWinDim.Height = %d'
a0311ee8 7f54feeb bl       #0xa02a70ec
a0311eec 880a06e3 movw     r0, #0x6a88
a0311ef0 5c1094e5 ldr      r1, [r4, #0x5c]
a0311ef4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6a88 '     DmyWinGeo.StartX = %d'
a0311ef8 7b54feeb bl       #0xa02a70ec
a0311efc a40a06e3 movw     r0, #0x6aa4
a0311f00 601094e5 ldr      r1, [r4, #0x60]
a0311f04 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6aa4 '     DmyWinGeo.StartY = %d'
a0311f08 7754feeb bl       #0xa02a70ec
a0311f0c c00a06e3 movw     r0, #0x6ac0
a0311f10 641094e5 ldr      r1, [r4, #0x64]
a0311f14 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6ac0 '     DmyWinGeo.Width  = %d'
a0311f18 7354feeb bl       #0xa02a70ec
a0311f1c dc0a06e3 movw     r0, #0x6adc
a0311f20 681094e5 ldr      r1, [r4, #0x68]
a0311f24 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6adc '     DmyWinGeo.Height = %d'
a0311f28 6f54feeb bl       #0xa02a70ec
a0311f2c f80a06e3 movw     r0, #0x6af8
a0311f30 6c1094e5 ldr      r1, [r4, #0x6c]
a0311f34 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6af8 '     CfaWinDim.Width  = %d'
a0311f38 6b54feeb bl       #0xa02a70ec
a0311f3c 140b06e3 movw     r0, #0x6b14
a0311f40 701094e5 ldr      r1, [r4, #0x70]
a0311f44 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6b14 '     CfaWinDim.Height = %d'
a0311f48 6754feeb bl       #0xa02a70ec
a0311f4c 1d7ad4ed vldr     s15, [r4, #0x74]
a0311f50 300b06e3 movw     r0, #0x6b30
a0311f54 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6b30 '     ActWinCrop.LeftTopX  = %f'
a0311f58 670bf8ee vcvt.f64.u32 d16, s15
a0311f5c 880b60ee vmul.f64 d16, d16, d8
a0311f60 302b53ec vmov     r2, r3, d16
a0311f64 6054feeb bl       #0xa02a70ec
a0311f68 1e7ad4ed vldr     s15, [r4, #0x78]
a0311f6c 500b06e3 movw     r0, #0x6b50
a0311f70 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6b50 '     ActWinCrop.LeftTopY  = %f'
a0311f74 670bf8ee vcvt.f64.u32 d16, s15
a0311f78 880b60ee vmul.f64 d16, d16, d8
a0311f7c 302b53ec vmov     r2, r3, d16
a0311f80 5954feeb bl       #0xa02a70ec
a0311f84 1f7ad4ed vldr     s15, [r4, #0x7c]
a0311f88 700b06e3 movw     r0, #0x6b70
a0311f8c 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6b70 '     ActWinCrop.RightBotX = %f'
a0311f90 670bf8ee vcvt.f64.u32 d16, s15
a0311f94 880b60ee vmul.f64 d16, d16, d8
a0311f98 302b53ec vmov     r2, r3, d16
a0311f9c 5254feeb bl       #0xa02a70ec
a0311fa0 207ad4ed vldr     s15, [r4, #0x80]
a0311fa4 900b06e3 movw     r0, #0x6b90
a0311fa8 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6b90 '     ActWinCrop.RightBotY = %f'
a0311fac 670bf8ee vcvt.f64.u32 d16, s15
a0311fb0 880b60ee vmul.f64 d16, d16, d8
a0311fb4 302b53ec vmov     r2, r3, d16
a0311fb8 4b54feeb bl       #0xa02a70ec
a0311fbc b00b06e3 movw     r0, #0x6bb0
a0311fc0 841094e5 ldr      r1, [r4, #0x84]
a0311fc4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6bb0 '     MainWinDim.Width  = %d'
a0311fc8 4754feeb bl       #0xa02a70ec
a0311fcc cc0b06e3 movw     r0, #0x6bcc
a0311fd0 881094e5 ldr      r1, [r4, #0x88]
a0311fd4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6bcc '     MainWinDim.Height = %d'
a0311fd8 4354feeb bl       #0xa02a70ec
a0311fdc e80b06e3 movw     r0, #0x6be8
a0311fe0 8c1094e5 ldr      r1, [r4, #0x8c]
a0311fe4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6be8 '     PrevWinDim[0].Width  = %d'
a0311fe8 3f54feeb bl       #0xa02a70ec
a0311fec 080c06e3 movw     r0, #0x6c08
a0311ff0 901094e5 ldr      r1, [r4, #0x90]
a0311ff4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6c08 '     PrevWinDim[0].Height = %d'
a0311ff8 3b54feeb bl       #0xa02a70ec
a0311ffc 280c06e3 movw     r0, #0x6c28
a0312000 941094e5 ldr      r1, [r4, #0x94]
a0312004 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6c28 '     PrevWinDim[1].Width  = %d'
a0312008 3754feeb bl       #0xa02a70ec
a031200c 480c06e3 movw     r0, #0x6c48
a0312010 981094e5 ldr      r1, [r4, #0x98]
a0312014 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6c48 '     PrevWinDim[1].Height = %d'
a0312018 3354feeb bl       #0xa02a70ec
a031201c 680c06e3 movw     r0, #0x6c68
a0312020 9c1094e5 ldr      r1, [r4, #0x9c]
a0312024 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6c68 '     ScreennailDim.Width  = %d'
a0312028 2f54feeb bl       #0xa02a70ec
a031202c 880c06e3 movw     r0, #0x6c88
a0312030 a01094e5 ldr      r1, [r4, #0xa0]
a0312034 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6c88 '     ScreennailDim.Height = %d'
a0312038 2b54feeb bl       #0xa02a70ec
a031203c a80c06e3 movw     r0, #0x6ca8
a0312040 a41094e5 ldr      r1, [r4, #0xa4]
a0312044 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6ca8 '     ThumbnailDim.Width  = %d'
a0312048 2754feeb bl       #0xa02a70ec
a031204c c80c06e3 movw     r0, #0x6cc8
a0312050 a81094e5 ldr      r1, [r4, #0xa8]
a0312054 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6cc8 '     ThumbnailDim.Height = %d'
a0312058 2354feeb bl       #0xa02a70ec
a031205c e80c06e3 movw     r0, #0x6ce8
a0312060 ac1094e5 ldr      r1, [r4, #0xac]
a0312064 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6ce8 '     HorSkewPhaseInc = %d'
a0312068 1f54feeb bl       #0xa02a70ec
a031206c 16ffffea b        #0xa0311ccc
a0312070 7c0d06e3 movw     r0, #0x6d7c
a0312074 0070e0e3 mvn      r7, #0
a0312078 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6d7c 'Warning. AmbaDSP_ImgCalcWarpCompensation() does not support pipe %d'
a031207c 1a54feeb bl       #0xa02a70ec
a0312080 34009de5 ldr      r0, [sp, #0x34]
a0312084 03a902eb bl       #0xa03bc498
a0312088 000056e3 cmp      r6, #0
a031208c 01728713 orrne    r7, r7, #0x10000000
a0312090 0700a0e1 mov      r0, r7
a0312094 7cd08de2 add      sp, sp, #0x7c
a0312098 028bbdec vpop     {d8}
a031209c f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03120a0 38108de2 add      r1, sp, #0x38
a03120a4 40008de2 add      r0, sp, #0x40
a03120a8 a9d9ffeb bl       #0xa0308754
a03120ac 38309de5 ldr      r3, [sp, #0x38]
a03120b0 64408de5 str      r4, [sp, #0x64]
a03120b4 412a83e2 add      r2, r3, #0x41000
a03120b8 470a83e2 add      r0, r3, #0x47000
a03120bc 2f1c83e2 add      r1, r3, #0x2f00
a03120c0 41cf82e2 add      ip, r2, #0x104
a03120c4 2f8c83e2 add      r8, r3, #0x2f00
a03120c8 060c80e2 add      r0, r0, #0x600
a03120cc 563a83e2 add      r3, r3, #0x56000
a03120d0 041081e2 add      r1, r1, #4
a03120d4 552f82e2 add      r2, r2, #0x154
a03120d8 68008de5 str      r0, [sp, #0x68]
a03120dc 74108de5 str      r1, [sp, #0x74]
a03120e0 188088e2 add      r8, r8, #0x18
a03120e4 58c08de5 str      ip, [sp, #0x58]
a03120e8 de9f83e2 add      sb, r3, #0x378
a03120ec 60208de5 str      r2, [sp, #0x60]
a03120f0 dfaf83e2 add      sl, r3, #0x37c
a03120f4 1effffea b        #0xa0311d74
a03120f8 443094e5 ldr      r3, [r4, #0x44]
a03120fc 202094e5 ldr      r2, [r4, #0x20]
a0312100 020053e1 cmp      r3, r2
a0312104 0030a033 movlo    r3, #0
a0312108 0130a023 movhs    r3, #1
a031210c 2c308de5 str      r3, [sp, #0x2c]
a0312110 62feffea b        #0xa0311aa0
a0312114 00f020e3 nop      
a0312118 00000000 andeq    r0, r0, r0
a031211c 0000f03e cdplo    p0, #0xf, c0, c0, c0, #0
a0312120 040d06e3 movw     r0, #0x6d04
a0312124 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6d04 '     CalibWarpInfo:'
a0312128 ef53feeb bl       #0xa02a70ec
a031212c d00202e3 movw     r0, #0x22d0
a0312130 081094e5 ldr      r1, [r4, #8]
a0312134 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d22d0 '         Version       = 0x%x'
a0312138 eb53feeb bl       #0xa02a70ec
a031213c f00202e3 movw     r0, #0x22f0
a0312140 0c1094e5 ldr      r1, [r4, #0xc]
a0312144 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d22f0 '         HorGridNum    = %d'
a0312148 e753feeb bl       #0xa02a70ec
a031214c 0c0302e3 movw     r0, #0x230c
a0312150 101094e5 ldr      r1, [r4, #0x10]
a0312154 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d230c '         VerGridNum    = %d'
a0312158 e353feeb bl       #0xa02a70ec
a031215c 280302e3 movw     r0, #0x2328
a0312160 141094e5 ldr      r1, [r4, #0x14]
a0312164 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2328 '         TileWidthExp  = %d'
a0312168 df53feeb bl       #0xa02a70ec
a031216c 440302e3 movw     r0, #0x2344
a0312170 181094e5 ldr      r1, [r4, #0x18]
a0312174 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2344 '         TileHeightExp = %d'
a0312178 db53feeb bl       #0xa02a70ec
a031217c 340603e3 movw     r0, #0x3634
a0312180 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e3634 '         VinSensorGeo:'
a0312184 d853feeb bl       #0xa02a70ec
a0312188 600302e3 movw     r0, #0x2360
a031218c 1c1094e5 ldr      r1, [r4, #0x1c]
a0312190 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2360 '             StartX = %d'
a0312194 d453feeb bl       #0xa02a70ec
a0312198 7c0302e3 movw     r0, #0x237c
a031219c 201094e5 ldr      r1, [r4, #0x20]
a03121a0 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d237c '             StartY = %d'
a03121a4 d053feeb bl       #0xa02a70ec
a03121a8 980302e3 movw     r0, #0x2398
a03121ac 241094e5 ldr      r1, [r4, #0x24]
a03121b0 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2398 '             Width  = %d'
a03121b4 cc53feeb bl       #0xa02a70ec
a03121b8 b40302e3 movw     r0, #0x23b4
a03121bc 281094e5 ldr      r1, [r4, #0x28]
a03121c0 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23b4 '             Height = %d'
a03121c4 c853feeb bl       #0xa02a70ec
a03121c8 d00302e3 movw     r0, #0x23d0
a03121cc 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23d0 '             HSubSample:'
a03121d0 c553feeb bl       #0xa02a70ec
a03121d4 ec0302e3 movw     r0, #0x23ec
a03121d8 2c10d4e5 ldrb     r1, [r4, #0x2c]
a03121dc 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23ec '                 FactorNum = %d'
a03121e0 c153feeb bl       #0xa02a70ec
a03121e4 0c0402e3 movw     r0, #0x240c
a03121e8 2d10d4e5 ldrb     r1, [r4, #0x2d]
a03121ec 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d240c '                 FactorDen = %d'
a03121f0 bd53feeb bl       #0xa02a70ec
a03121f4 2c0402e3 movw     r0, #0x242c
a03121f8 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d242c '             VSubSample:'
a03121fc ba53feeb bl       #0xa02a70ec
a0312200 ec0302e3 movw     r0, #0x23ec
a0312204 2e10d4e5 ldrb     r1, [r4, #0x2e]
a0312208 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d23ec '                 FactorNum = %d'
a031220c b653feeb bl       #0xa02a70ec
a0312210 0c0402e3 movw     r0, #0x240c
a0312214 2f10d4e5 ldrb     r1, [r4, #0x2f]
a0312218 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d240c '                 FactorDen = %d'
a031221c b253feeb bl       #0xa02a70ec
a0312220 180d06e3 movw     r0, #0x6d18
a0312224 3c1094e5 ldr      r1, [r4, #0x3c]
a0312228 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6d18 '         pWarp = 0x%x'
a031222c ae53feeb bl       #0xa02a70ec
a0312230 103094e5 ldr      r3, [r4, #0x10]
a0312234 000053e3 cmp      r3, #0
a0312238 f9feffda ble      #0xa0311e24
a031223c 0070a0e3 mov      r7, #0
a0312240 0cc094e5 ldr      ip, [r4, #0xc]
a0312244 300d06e3 movw     r0, #0x6d30
a0312248 3ce094e5 ldr      lr, [r4, #0x3c]
a031224c 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6d30 '             CalibWarpInfo.pWarp (%d, %d) (%d, %d) ... (%d, %d) (%d, %d)'
a0312250 970c03e0 mul      r3, r7, ip
a0312254 017087e2 add      r7, r7, #1
a0312258 0311a0e1 lsl      r1, r3, #2
a031225c 0cc083e0 add      ip, r3, ip
a0312260 0bc14ce2 sub      ip, ip, #0xc0000002
a0312264 043081e2 add      r3, r1, #4
a0312268 0cc1a0e1 lsl      ip, ip, #2
a031226c 03208ee0 add      r2, lr, r3
a0312270 f3309ee1 ldrsh    r3, [lr, r3]
a0312274 f290d2e1 ldrsh    sb, [r2, #2]
a0312278 01208ee0 add      r2, lr, r1
a031227c f220d2e1 ldrsh    r2, [r2, #2]
a0312280 0ca08ee0 add      sl, lr, ip
a0312284 f1109ee1 ldrsh    r1, [lr, r1]
a0312288 04808ce2 add      r8, ip, #4
a031228c 00908de5 str      sb, [sp]
a0312290 08908ee0 add      sb, lr, r8
a0312294 fcc09ee1 ldrsh    ip, [lr, ip]
a0312298 04c08de5 str      ip, [sp, #4]
a031229c f2c0dae1 ldrsh    ip, [sl, #2]
a03122a0 08c08de5 str      ip, [sp, #8]
a03122a4 f8c09ee1 ldrsh    ip, [lr, r8]
a03122a8 0cc08de5 str      ip, [sp, #0xc]
a03122ac f2c0d9e1 ldrsh    ip, [sb, #2]
a03122b0 10c08de5 str      ip, [sp, #0x10]
a03122b4 8c53feeb bl       #0xa02a70ec
a03122b8 103094e5 ldr      r3, [r4, #0x10]
a03122bc 030057e1 cmp      r7, r3
a03122c0 deffffba blt      #0xa0312240
a03122c4 d6feffea b        #0xa0311e24
a03122c8 8c0f00e3 movw     r0, #0xf8c
a03122cc 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a03122d0 8553feeb bl       #0xa02a70ec
a03122d4 6bffffea b        #0xa0312088
a03122d8 0800a0e1 mov      r0, r8
a03122dc 0410a0e1 mov      r1, r4
a03122e0 c020a0e3 mov      r2, #0xc0
a03122e4 e528feeb bl       #0xa029c680
a03122e8 54309de5 ldr      r3, [sp, #0x54]
a03122ec 003089e5 str      r3, [sb]
a03122f0 5c309de5 ldr      r3, [sp, #0x5c]
a03122f4 00308ae5 str      r3, [sl]
a03122f8 a6feffea b        #0xa0311d98
a03122fc 0130d5e5 ldrb     r3, [r5, #1]
a0312300 010053e3 cmp      r3, #1
a0312304 0200a003 moveq    r0, #2
a0312308 0200000a beq      #0xa0312318
a031230c 020053e3 cmp      r3, #2
a0312310 0300a003 moveq    r0, #3
a0312314 2500001a bne      #0xa03123b0
a0312318 64309de5 ldr      r3, [sp, #0x64]
a031231c 0020a0e3 mov      r2, #0
a0312320 0210d5e5 ldrb     r1, [r5, #2]
a0312324 b424cde1 strh     r2, [sp, #0x44]
a0312328 84b093e5 ldr      fp, [r3, #0x84]
a031232c 887093e5 ldr      r7, [r3, #0x88]
a0312330 020051e3 cmp      r1, #2
a0312334 5ce093e5 ldr      lr, [r3, #0x5c]
a0312338 641093e5 ldr      r1, [r3, #0x64]
a031233c 60c093e5 ldr      ip, [r3, #0x60]
a0312340 683093e5 ldr      r3, [r3, #0x68]
a0312344 b015cde1 strh     r1, [sp, #0x50]
a0312348 44108de2 add      r1, sp, #0x44
a031234c b624cde1 strh     r2, [sp, #0x46]
a0312350 4c208de2 add      r2, sp, #0x4c
a0312354 b8b4cde1 strh     fp, [sp, #0x48]
a0312358 ba74cde1 strh     r7, [sp, #0x4a]
a031235c bce4cde1 strh     lr, [sp, #0x4c]
a0312360 bec4cde1 strh     ip, [sp, #0x4e]
a0312364 b235cde1 strh     r3, [sp, #0x52]
a0312368 2800000a beq      #0xa0312410
a031236c 5cf2feeb bl       #0xa02cece4
a0312370 70008de5 str      r0, [sp, #0x70]
a0312374 81feffea b        #0xa0311d80
a0312378 180002e3 movw     r0, #0x2018
a031237c 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2018 'Error: Factors of Calib sample rate and Vin sensor sample rate shall not be 0'
a0312380 5953feeb bl       #0xa02a70ec
a0312384 0dfeffea b        #0xa0311bc0
a0312388 0c0102e3 movw     r0, #0x210c
a031238c 00c08de5 str      ip, [sp]
a0312390 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d210c 'Error: Dummy window x %d, y %d, w %d, h %d exceed'
a0312394 5453feeb bl       #0xa02a70ec
a0312398 400102e3 movw     r0, #0x2140
a031239c 0810a0e1 mov      r1, r8
a03123a0 0720a0e1 mov      r2, r7
a03123a4 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2140 '       vin->R2R window w %d, h %d'
a03123a8 4f53feeb bl       #0xa02a70ec
a03123ac 03feffea b        #0xa0311bc0
a03123b0 4c0502e3 movw     r0, #0x254c
a03123b4 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d254c '[Warn] unsupport mode'
a03123b8 4b53feeb bl       #0xa02a70ec
a03123bc 0200a0e3 mov      r0, #2
a03123c0 d4ffffea b        #0xa0312318
a03123c4 d40806e3 movw     r0, #0x68d4
a03123c8 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e68d4 'Error: Warp Version 0x%X != 0x%X, 0x%X'
a03123cc 4653feeb bl       #0xa02a70ec
a03123d0 fafdffea b        #0xa0311bc0
a03123d4 640102e3 movw     r0, #0x2164
a03123d8 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d2164 'Error: Invalid CfaWinDim %d, %d'
a03123dc 4253feeb bl       #0xa02a70ec
a03123e0 f6fdffea b        #0xa0311bc0
a03123e4 bc0906e3 movw     r0, #0x69bc
a03123e8 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e69bc 'Error: Invalid MainWinDim %d, %d'
a03123ec 3e53feeb bl       #0xa02a70ec
a03123f0 f2fdffea b        #0xa0311bc0
a03123f4 180906e3 movw     r0, #0x6918
a03123f8 302b53ec vmov     r2, r3, d16
a03123fc 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6918 'Error: Theta = %f Still mode should not use theta, force theta to zero'
a0312400 0162a0e3 mov      r6, #0x10000000
a0312404 3853feeb bl       #0xa02a70ec
a0312408 f88bc4e1 strd     r8, sb, [r4, #0xb8]
a031240c 9bfdffea b        #0xa0311a80
a0312410 50f2feeb bl       #0xa02ced58
a0312414 70008de5 str      r0, [sp, #0x70]
a0312418 58feffea b        #0xa0311d80
a031241c 01c0a0e3 mov      ip, #1
a0312420 240f01e3 movw     r0, #0x1f24
a0312424 1c22a0e1 lsl      r2, ip, r2
a0312428 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d1f24 'Error: (HorGridNum %d - 1) * TileWidth %d < Calib vin width %d'
a031242c 2e53feeb bl       #0xa02a70ec
a0312430 e2fdffea b        #0xa0311bc0
a0312434 01c0a0e3 mov      ip, #1
a0312438 640f01e3 movw     r0, #0x1f64
a031243c 0730a0e1 mov      r3, r7
a0312440 1c22a0e1 lsl      r2, ip, r2
a0312444 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d1f64 'Error: (VerGridNum %d - 1) * TileHeight %d < Calib vin height %d'
a0312448 2753feeb bl       #0xa02a70ec
a031244c dbfdffea b        #0xa0311bc0
a0312450 fc0806e3 movw     r0, #0x68fc
a0312454 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e68fc 'Error: Calib pWarp is NULL'
a0312458 2353feeb bl       #0xa02a70ec
a031245c d7fdffea b        #0xa0311bc0
a0312460 e0200fe3 movw     r2, #0xf0e0
a0312464 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0312468 4b214ae3 movt     r2, #0xa14b
a031246c 84d04de2 sub      sp, sp, #0x84
a0312470 0030a0e3 mov      r3, #0
a0312474 0040a0e1 mov      r4, r0
a0312478 0420d2e5 ldrb     r2, [r2, #4]
a031247c 20308de5 str      r3, [sp, #0x20]
a0312480 24308de5 str      r3, [sp, #0x24]
a0312484 040012e3 tst      r2, #4
a0312488 28308de5 str      r3, [sp, #0x28]
a031248c 6200001a bne      #0xa031261c
a0312490 0020d4e5 ldrb     r2, [r4]
a0312494 2c008de2 add      r0, sp, #0x2c
a0312498 0330d4e5 ldrb     r3, [r4, #3]
a031249c 1c108de2 add      r1, sp, #0x1c
a03124a0 2c20cde5 strb     r2, [sp, #0x2c]
a03124a4 2d30cde5 strb     r3, [sp, #0x2d]
a03124a8 f4d8ffeb bl       #0xa0308880
a03124ac 005050e2 subs     r5, r0, #0
a03124b0 c80000ba blt      #0xa03127d8
a03124b4 0010a0e3 mov      r1, #0
a03124b8 1c009de5 ldr      r0, [sp, #0x1c]
a03124bc eaa702eb bl       #0xa03bc46c
a03124c0 0010d4e5 ldrb     r1, [r4]
a03124c4 000051e3 cmp      r1, #0
a03124c8 6200000a beq      #0xa0312658
a03124cc 010051e3 cmp      r1, #1
a03124d0 4800001a bne      #0xa03125f8
a03124d4 2c008de2 add      r0, sp, #0x2c
a03124d8 24108de2 add      r1, sp, #0x24
a03124dc 9cd8ffeb bl       #0xa0308754
a03124e0 24209de5 ldr      r2, [sp, #0x24]
a03124e4 848800e3 movw     r8, #0x884
a03124e8 d49800e3 movw     sb, #0x8d4
a03124ec 068040e3 movt     r8, #6
a03124f0 069040e3 movt     sb, #6
a03124f4 0050a0e3 mov      r5, #0
a03124f8 773a82e2 add      r3, r2, #0x77000
a03124fc 1ac982e2 add      ip, r2, #0x68000
a0312500 b7bf83e2 add      fp, r3, #0x2dc
a0312504 b9af83e2 add      sl, r3, #0x2e4
a0312508 0030d4e5 ldrb     r3, [r4]
a031250c 557b82e2 add      r7, r2, #0x15400
a0312510 5b6b82e2 add      r6, r2, #0x16c00
a0312514 56ce8ce2 add      ip, ip, #0x560
a0312518 807087e2 add      r7, r7, #0x80
a031251c 806086e2 add      r6, r6, #0x80
a0312520 000053e3 cmp      r3, #0
a0312524 088082e0 add      r8, r2, r8
a0312528 099082e0 add      sb, r2, sb
a031252c 6c00000a beq      #0xa03126e4
a0312530 010053e3 cmp      r3, #1
a0312534 8d00001a bne      #0xa0312770
a0312538 0c10a0e1 mov      r1, ip
a031253c 062ba0e3 mov      r2, #0x1800
a0312540 0700a0e1 mov      r0, r7
a0312544 14c08de5 str      ip, [sp, #0x14]
a0312548 4c28feeb bl       #0xa029c680
a031254c 14c09de5 ldr      ip, [sp, #0x14]
a0312550 062ba0e3 mov      r2, #0x1800
a0312554 0600a0e1 mov      r0, r6
a0312558 061b8ce2 add      r1, ip, #0x1800
a031255c 4728feeb bl       #0xa029c680
a0312560 087088e5 str      r7, [r8, #8]
a0312564 0c6088e5 str      r6, [r8, #0xc]
a0312568 87d9ffeb bl       #0xa0308b8c
a031256c 005050e2 subs     r5, r0, #0
a0312570 9e00000a beq      #0xa03127f0
a0312574 5020a0e3 mov      r2, #0x50
a0312578 0810a0e1 mov      r1, r8
a031257c 30008de2 add      r0, sp, #0x30
a0312580 3e28feeb bl       #0xa029c680
a0312584 38009de5 ldr      r0, [sp, #0x38]
a0312588 061ba0e3 mov      r1, #0x1800
a031258c 4e3f06eb bl       #0xa04a22cc
a0312590 3c009de5 ldr      r0, [sp, #0x3c]
a0312594 061ba0e3 mov      r1, #0x1800
a0312598 4b3f06eb bl       #0xa04a22cc
a031259c 040094e5 ldr      r0, [r4, #4]
a03125a0 0f3000e2 and      r3, r0, #0xf
a03125a4 0f0053e3 cmp      r3, #0xf
a03125a8 0050a003 moveq    r5, #0
a03125ac 0300000a beq      #0xa03125c0
a03125b0 30208de2 add      r2, sp, #0x30
a03125b4 0010a0e3 mov      r1, #0
a03125b8 0cadfeeb bl       #0xa02bd9f0
a03125bc 0050a0e1 mov      r5, r0
a03125c0 0030dae5 ldrb     r3, [sl]
a03125c4 043083e3 orr      r3, r3, #4
a03125c8 0030cae5 strb     r3, [sl]
a03125cc 00309be5 ldr      r3, [fp]
a03125d0 000053e3 cmp      r3, #0
a03125d4 6600000a beq      #0xa0312774
a03125d8 040094e5 ldr      r0, [r4, #4]
a03125dc 0f3000e2 and      r3, r0, #0xf
a03125e0 0f0053e3 cmp      r3, #0xf
a03125e4 6200000a beq      #0xa0312774
a03125e8 0910a0e1 mov      r1, sb
a03125ec 81a7feeb bl       #0xa02bc3f8
a03125f0 005085e1 orr      r5, r5, r0
a03125f4 5e0000ea b        #0xa0312774
a03125f8 e00d06e3 movw     r0, #0x6de0
a03125fc 0050e0e3 mvn      r5, #0
a0312600 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6de0 'Warning. AmbaDSP_ImgSetWarpCompensation() does not support pipe %d'
a0312604 b852feeb bl       #0xa02a70ec
a0312608 1c009de5 ldr      r0, [sp, #0x1c]
a031260c a1a702eb bl       #0xa03bc498
a0312610 0500a0e1 mov      r0, r5
a0312614 84d08de2 add      sp, sp, #0x84
a0312618 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a031261c c00d06e3 movw     r0, #0x6dc0
a0312620 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6dc0 'AmbaDSP_ImgSetWarpCompensation:'
a0312624 b052feeb bl       #0xa02a70ec
a0312628 0350d4e5 ldrb     r5, [r4, #3]
a031262c 380c01e3 movw     r0, #0x1c38
a0312630 04e094e5 ldr      lr, [r4, #4]
a0312634 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d1c38 '     Pipe %d, Algo %d, Func %d, Ctx %d, Bch %d, Cfg %d '
a0312638 08c0d4e5 ldrb     ip, [r4, #8]
a031263c 0010d4e5 ldrb     r1, [r4]
a0312640 0120d4e5 ldrb     r2, [r4, #1]
a0312644 0230d4e5 ldrb     r3, [r4, #2]
a0312648 20408de8 stm      sp, {r5, lr}
a031264c 08c08de5 str      ip, [sp, #8]
a0312650 a552feeb bl       #0xa02a70ec
a0312654 8dffffea b        #0xa0312490
a0312658 2c008de2 add      r0, sp, #0x2c
a031265c 20108de2 add      r1, sp, #0x20
a0312660 3bd8ffeb bl       #0xa0308754
a0312664 040094e5 ldr      r0, [r4, #4]
a0312668 20309de5 ldr      r3, [sp, #0x20]
a031266c 0f0050e3 cmp      r0, #0xf
a0312670 419a83e2 add      sb, r3, #0x41000
a0312674 475a83e2 add      r5, r3, #0x47000
a0312678 418f89e2 add      r8, sb, #0x104
a031267c 065c85e2 add      r5, r5, #0x600
a0312680 559f89e2 add      sb, sb, #0x154
a0312684 3f00000a beq      #0xa0312788
a0312688 2c108de2 add      r1, sp, #0x2c
a031268c 28208de2 add      r2, sp, #0x28
a0312690 c5d8ffeb bl       #0xa03089ac
a0312694 28109de5 ldr      r1, [sp, #0x28]
a0312698 922d05e3 movw     r2, #0x5d92
a031269c 20309de5 ldr      r3, [sp, #0x20]
a03126a0 032040e3 movt     r2, #3
a03126a4 022081e0 add      r2, r1, r2
a03126a8 56ba83e2 add      fp, r3, #0x56000
a03126ac 022183e0 add      r2, r3, r2, lsl #2
a03126b0 046092e5 ldr      r6, [r2, #4]
a03126b4 9213cbe5 strb     r1, [fp, #0x392]
a03126b8 0d7a86e2 add      r7, r6, #0xd000
a03126bc 3a6b86e2 add      r6, r6, #0xe800
a03126c0 607087e2 add      r7, r7, #0x60
a03126c4 606086e2 add      r6, r6, #0x60
a03126c8 17a983e2 add      sl, r3, #0x5c000
a03126cc 0030d4e5 ldrb     r3, [r4]
a03126d0 dfbf8be2 add      fp, fp, #0x37c
a03126d4 f7ae8ae2 add      sl, sl, #0xf70
a03126d8 00c0a0e3 mov      ip, #0
a03126dc 000053e3 cmp      r3, #0
a03126e0 92ffff1a bne      #0xa0312530
a03126e4 0510a0e1 mov      r1, r5
a03126e8 062ba0e3 mov      r2, #0x1800
a03126ec 0700a0e1 mov      r0, r7
a03126f0 14308de5 str      r3, [sp, #0x14]
a03126f4 e127feeb bl       #0xa029c680
a03126f8 061b85e2 add      r1, r5, #0x1800
a03126fc 062ba0e3 mov      r2, #0x1800
a0312700 0600a0e1 mov      r0, r6
a0312704 dd27feeb bl       #0xa029c680
a0312708 087088e5 str      r7, [r8, #8]
a031270c 0c6088e5 str      r6, [r8, #0xc]
a0312710 1dd9ffeb bl       #0xa0308b8c
a0312714 005050e2 subs     r5, r0, #0
a0312718 3400000a beq      #0xa03127f0
a031271c 5020a0e3 mov      r2, #0x50
a0312720 0810a0e1 mov      r1, r8
a0312724 30008de2 add      r0, sp, #0x30
a0312728 d427feeb bl       #0xa029c680
a031272c 38009de5 ldr      r0, [sp, #0x38]
a0312730 061ba0e3 mov      r1, #0x1800
a0312734 e43e06eb bl       #0xa04a22cc
a0312738 3c009de5 ldr      r0, [sp, #0x3c]
a031273c 061ba0e3 mov      r1, #0x1800
a0312740 e13e06eb bl       #0xa04a22cc
a0312744 040094e5 ldr      r0, [r4, #4]
a0312748 14309de5 ldr      r3, [sp, #0x14]
a031274c 0f2000e2 and      r2, r0, #0xf
a0312750 0f0052e3 cmp      r2, #0xf
a0312754 0350a001 moveq    r5, r3
a0312758 98ffff0a beq      #0xa03125c0
a031275c 0310a0e1 mov      r1, r3
a0312760 30208de2 add      r2, sp, #0x30
a0312764 a1acfeeb bl       #0xa02bd9f0
a0312768 0050a0e1 mov      r5, r0
a031276c 93ffffea b        #0xa03125c0
a0312770 0050e0e3 mvn      r5, #0
a0312774 1c009de5 ldr      r0, [sp, #0x1c]
a0312778 46a702eb bl       #0xa03bc498
a031277c 0500a0e1 mov      r0, r5
a0312780 84d08de2 add      sp, sp, #0x84
a0312784 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0312788 012783e2 add      r2, r3, #0x40000
a031278c 56ba83e2 add      fp, r3, #0x56000
a0312790 8a28d2e5 ldrb     r2, [r2, #0x88a]
a0312794 9213dbe5 ldrb     r1, [fp, #0x392]
a0312798 380093e5 ldr      r0, [r3, #0x38]
a031279c 010052e1 cmp      r2, r1
a03127a0 7000ef86 uxtbhi   r0, r0
a03127a4 00108180 addhi    r1, r1, r0
a03127a8 011062e0 rsb      r1, r2, r1
a03127ac 922d05e3 movw     r2, #0x5d92
a03127b0 032040e3 movt     r2, #3
a03127b4 28108de5 str      r1, [sp, #0x28]
a03127b8 022081e0 add      r2, r1, r2
a03127bc 022183e0 add      r2, r3, r2, lsl #2
a03127c0 046092e5 ldr      r6, [r2, #4]
a03127c4 0d7a86e2 add      r7, r6, #0xd000
a03127c8 3a6b86e2 add      r6, r6, #0xe800
a03127cc 607087e2 add      r7, r7, #0x60
a03127d0 606086e2 add      r6, r6, #0x60
a03127d4 bbffffea b        #0xa03126c8
a03127d8 8c0f00e3 movw     r0, #0xf8c
a03127dc 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a03127e0 4152feeb bl       #0xa02a70ec
a03127e4 0500a0e1 mov      r0, r5
a03127e8 84d08de2 add      sp, sp, #0x84
a03127ec f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03127f0 0700a0e1 mov      r0, r7
a03127f4 061ba0e3 mov      r1, #0x1800
a03127f8 b33e06eb bl       #0xa04a22cc
a03127fc 0600a0e1 mov      r0, r6
a0312800 061ba0e3 mov      r1, #0x1800
a0312804 b03e06eb bl       #0xa04a22cc
a0312808 040094e5 ldr      r0, [r4, #4]
a031280c 0f3000e2 and      r3, r0, #0xf
a0312810 0f0053e3 cmp      r3, #0xf
a0312814 69ffff0a beq      #0xa03125c0
a0312818 0510a0e1 mov      r1, r5
a031281c 0820a0e1 mov      r2, r8
a0312820 72acfeeb bl       #0xa02bd9f0
a0312824 0050a0e1 mov      r5, r0
a0312828 64ffffea b        #0xa03125c0
a031282c f0402de9 push     {r4, r5, r6, r7, lr}
a0312830 007051e2 subs     r7, r1, #0
a0312834 14d04de2 sub      sp, sp, #0x14
a0312838 0040a0e3 mov      r4, #0
a031283c 04408de5 str      r4, [sp, #4]
a0312840 08408de5 str      r4, [sp, #8]
a0312844 3600000a beq      #0xa0312924
a0312848 0020d0e5 ldrb     r2, [r0]
a031284c 0050a0e1 mov      r5, r0
a0312850 0330d0e5 ldrb     r3, [r0, #3]
a0312854 0d10a0e1 mov      r1, sp
a0312858 0c008de2 add      r0, sp, #0xc
a031285c 0c20cde5 strb     r2, [sp, #0xc]
a0312860 0d30cde5 strb     r3, [sp, #0xd]
a0312864 05d8ffeb bl       #0xa0308880
a0312868 006050e2 subs     r6, r0, #0
a031286c 260000ba blt      #0xa031290c
a0312870 0410a0e1 mov      r1, r4
a0312874 00009de5 ldr      r0, [sp]
a0312878 fba602eb bl       #0xa03bc46c
a031287c 0010d5e5 ldrb     r1, [r5]
a0312880 000051e3 cmp      r1, #0
a0312884 1900000a beq      #0xa03128f0
a0312888 010051e3 cmp      r1, #1
a031288c 0e00001a bne      #0xa03128cc
a0312890 08108de2 add      r1, sp, #8
a0312894 0c008de2 add      r0, sp, #0xc
a0312898 add7ffeb bl       #0xa0308754
a031289c 08109de5 ldr      r1, [sp, #8]
a03128a0 521a81e2 add      r1, r1, #0x52000
a03128a4 a91e81e2 add      r1, r1, #0xa90
a03128a8 c020a0e3 mov      r2, #0xc0
a03128ac 0700a0e1 mov      r0, r7
a03128b0 7227feeb bl       #0xa029c680
a03128b4 0060a0e3 mov      r6, #0
a03128b8 00009de5 ldr      r0, [sp]
a03128bc f5a602eb bl       #0xa03bc498
a03128c0 0600a0e1 mov      r0, r6
a03128c4 14d08de2 add      sp, sp, #0x14
a03128c8 f080bde8 pop      {r4, r5, r6, r7, pc}
a03128cc 480e06e3 movw     r0, #0x6e48
a03128d0 0060e0e3 mvn      r6, #0
a03128d4 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6e48 'Warning. AmbaDSP_ImgGetWarpCompensation() does not support pipe %d'
a03128d8 0352feeb bl       #0xa02a70ec
a03128dc 00009de5 ldr      r0, [sp]
a03128e0 eca602eb bl       #0xa03bc498
a03128e4 0600a0e1 mov      r0, r6
a03128e8 14d08de2 add      sp, sp, #0x14
a03128ec f080bde8 pop      {r4, r5, r6, r7, pc}
a03128f0 04108de2 add      r1, sp, #4
a03128f4 0c008de2 add      r0, sp, #0xc
a03128f8 95d7ffeb bl       #0xa0308754
a03128fc 04109de5 ldr      r1, [sp, #4]
a0312900 2f1c81e2 add      r1, r1, #0x2f00
a0312904 181081e2 add      r1, r1, #0x18
a0312908 e6ffffea b        #0xa03128a8
a031290c 8c0f00e3 movw     r0, #0xf8c
a0312910 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d0f8c 'Warning. Cannot get context mutex'
a0312914 f451feeb bl       #0xa02a70ec
a0312918 0600a0e1 mov      r0, r6
a031291c 14d08de2 add      sp, sp, #0x14
a0312920 f080bde8 pop      {r4, r5, r6, r7, pc}
a0312924 240e06e3 movw     r0, #0x6e24
a0312928 0060e0e3 mvn      r6, #0
a031292c 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6e24 'Warning. pWarpCalcInfo is empty.'
a0312930 ed51feeb bl       #0xa02a70ec
a0312934 eaffffea b        #0xa03128e4
a0312938 003050e2 subs     r3, r0, #0
a031293c 10402de9 push     {r4, lr}
a0312940 8c0e0613 movwne   r0, #0x6e8c
a0312944 3d4600e3 movw     r4, #0x63d
a0312948 b00e0603 movweq   r0, #0x6eb0
a031294c 4c414a13 movtne   r4, #0xa14c
a0312950 4c414a03 movteq   r4, #0xa14c
a0312954 5e004a13 movtne   r0, #0xa05e ; heuristic 0xa05e6eb0 'Set Debug for WarpCompensation off'
a0312958 5e004a03 movteq   r0, #0xa05e ; heuristic 0xa05e6eb0 'Set Debug for WarpCompensation off'
a031295c 0030c4e5 strb     r3, [r4]
a0312960 e151feeb bl       #0xa02a70ec
a0312964 0000d4e5 ldrb     r0, [r4]
a0312968 1040bde8 pop      {r4, lr}
a031296c d36b00ea b        #0xa032d8c0
a0312970 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0312974 004051e2 subs     r4, r1, #0
a0312978 8cd04de2 sub      sp, sp, #0x8c
a031297c 0030a0e3 mov      r3, #0
a0312980 20308de5 str      r3, [sp, #0x20]
a0312984 24308de5 str      r3, [sp, #0x24]
a0312988 28308de5 str      r3, [sp, #0x28]
a031298c 6c01000a beq      #0xa0312f44
a0312990 103094e5 ldr      r3, [r4, #0x10]
a0312994 000053e3 cmp      r3, #0
a0312998 7101000a beq      #0xa0312f64
a031299c 143094e5 ldr      r3, [r4, #0x14]
a03129a0 000053e3 cmp      r3, #0
a03129a4 6a01000a beq      #0xa0312f54
a03129a8 0030d0e5 ldrb     r3, [r0]
a03129ac 0060a0e1 mov      r6, r0
a03129b0 000053e3 cmp      r3, #0
a03129b4 d600000a beq      #0xa0312d14
a03129b8 010053e3 cmp      r3, #1
a03129bc cd00001a bne      #0xa0312cf8
a03129c0 0410d4e5 ldrb     r1, [r4, #4]
a03129c4 400051e3 cmp      r1, #0x40
a03129c8 4e01008a bhi      #0xa0312f08
a03129cc 0510d4e5 ldrb     r1, [r4, #5]
a03129d0 300051e3 cmp      r1, #0x30
a03129d4 5501008a bhi      #0xa0312f30
a03129d8 e0200fe3 movw     r2, #0xf0e0
a03129dc 4b214ae3 movt     r2, #0xa14b
a03129e0 0420d2e5 ldrb     r2, [r2, #4]
a03129e4 040012e3 tst      r2, #4
a03129e8 0e00000a beq      #0xa0312a28
a03129ec c00d06e3 movw     r0, #0x6dc0
a03129f0 5e004ae3 movt     r0, #0xa05e ; heuristic 0xa05e6dc0 'AmbaDSP_ImgSetWarpCompensation:'
a03129f4 bc51feeb bl       #0xa02a70ec
a03129f8 0350d6e5 ldrb     r5, [r6, #3]
a03129fc 380c01e3 movw     r0, #0x1c38
a0312a00 04e096e5 ldr      lr, [r6, #4]
a0312a04 5d004ae3 movt     r0, #0xa05d ; heuristic 0xa05d1c38 '     Pipe %d, Algo %d, Func %d, Ctx %d, Bch %d, Cfg %d '
a0312a08 08c0d6e5 ldrb     ip, [r6, #8]
a0312a0c 0230d6e5 ldrb     r3, [r6, #2]
a0312a10 0010d6e5 ldrb     r1, [r6]
a0312a14 0120d6e5 ldrb     r2, [r6, #1]
a0312a18 20408de8 stm      sp, {r5, lr}
a0312a1c 08c08de5 str      ip, [sp, #8]
a0312a20 b151feeb bl       #0xa02a70ec
a0312a24 0030d6e5 ldrb     r3, [r6]
a0312a28 0320d6e5 ldrb     r2, [r6, #3]
a0312a2c 2c008de2 add      r0, sp, #0x2c
a0312a30 1c108de2 add      r1, sp, #0x1c
a0312a34 2c30cde5 strb     r3, [sp, #0x2c]
a0312a38 2d20cde5 strb     r2, [sp, #0x2d]
a0312a3c 8fd7ffeb bl       #0xa0308880
a0312a40 007050e2 subs     r7, r0, #0
a0312a44 eb0000ba blt      #0xa0312df8
a0312a48 1c009de5 ldr      r0, [sp, #0x1c]
a0312a4c 0010a0e3 mov      r1, #0
a0312a50 85a602eb bl       #0xa03bc46c
a0312a54 0070d6e5 ldrb     r7, [r6]
a0312a58 000057e3 cmp      r7, #0
a0312a5c c100000a beq      #0xa0312d68
a0312a60 010057e3 cmp      r7, #1
a0312a64 b500001a bne      #0xa0312d40
a0312a68 2c008de2 add      r0, sp, #0x2c
a0312a6c 24108de2 add      r1, sp, #0x24
a0312a70 37d7ffeb bl       #0xa0308754
a0312a74 24209de5 ldr      r2, [sp, #0x24]
a0312a78 845800e3 movw     r5, #0x884
a0312a7c 7c8a02e3 movw     r8, #0x2a7c
a0312a80 d4a800e3 movw     sl, #0x8d4
a0312a84 065040e3 movt     r5, #6
a0312a88 058040e3 movt     r8, #5
a0312a8c 1a7982e2 add      r7, r2, #0x68000
a0312a90 55bb82e2 add      fp, r2, #0x15400
a0312a94 5b9b82e2 add      sb, r2, #0x16c00
a0312a98 06a040e3 movt     sl, #6
a0312a9c 567e87e2 add      r7, r7, #0x560
