; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a022d820 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a022d824 8bdf4de2 sub      sp, sp, #0x22c
a022d828 0140a0e1 mov      r4, r1
a022d82c c020a0e3 mov      r2, #0xc0
a022d830 0010a0e3 mov      r1, #0
a022d834 5a0f8de2 add      r0, sp, #0x168
a022d838 6b2d0bfa blx      #0xa04f8dec
a022d83c 382400e3 movw     r2, #0x438
a022d840 1e1da0e3 mov      r1, #0x780
a022d844 60090ce3 movw     r0, #0xc960
a022d848 00c0a0e3 mov      ip, #0
a022d84c 0130a0e1 mov      r3, r1
a022d850 01e0a0e3 mov      lr, #1
a022d854 00208de5 str      r2, [sp]
a022d858 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c960 'Warp size info VCapWidth= %d VCapHeight=%d MainWidth=%d MainHeight=%d'
a022d85c 4cc08de5 str      ip, [sp, #0x4c]
a022d860 50c08de5 str      ip, [sp, #0x50]
a022d864 54c08de5 str      ip, [sp, #0x54]
a022d868 4de0cde5 strb     lr, [sp, #0x4d]
a022d86c 1ee601eb bl       #0xa02a70ec
a022d870 5a1f8de2 add      r1, sp, #0x168
a022d874 4c008de2 add      r0, sp, #0x4c
a022d878 eb9303eb bl       #0xa031282c
a022d87c 085094e5 ldr      r5, [r4, #8]
a022d880 0500a0e1 mov      r0, r5
a022d884 dae4ffeb bl       #0xa0226bf4
a022d888 000050e3 cmp      r0, #0
a022d88c 0e00000a beq      #0xa022d8cc
a022d890 00c094e5 ldr      ip, [r4]
a022d894 74030de3 movw     r0, #0xd374
a022d898 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d374 '\n\rUsage: t %s -warp: get warp info\n\r       t %s -warp 0: warp off\n\r       t %s -warp 1: hor and ver warp on\n\r       t %s -warp 2: dzoom 2x test\n\r       t %s -warp 3: dzoom 1x test\n\r       t %s -warp bypasstest: Only used in video mode, bypass function test with the the same pattern to -warp 1\n\r       t %s -warp vert [0|1]: enable/disable vertical warp flip\n\r'
a022d89c 00c08de5 str      ip, [sp]
a022d8a0 0c10a0e1 mov      r1, ip
a022d8a4 04c08de5 str      ip, [sp, #4]
a022d8a8 0c20a0e1 mov      r2, ip
a022d8ac 08c08de5 str      ip, [sp, #8]
a022d8b0 0c30a0e1 mov      r3, ip
a022d8b4 0cc08de5 str      ip, [sp, #0xc]
a022d8b8 0be601eb bl       #0xa02a70ec
a022d8bc ff00a0e3 mov      r0, #0xff
a022d8c0 7000afe6 sxtb     r0, r0
a022d8c4 8bdf8de2 add      sp, sp, #0x22c
a022d8c8 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a022d8cc 0060d5e5 ldrb     r6, [r5]
a022d8d0 000056e3 cmp      r6, #0
a022d8d4 1101000a beq      #0xa022dd20
a022d8d8 181a07e3 movw     r1, #0x7a18
a022d8dc 0500a0e1 mov      r0, r5
a022d8e0 57104ae3 movt     r1, #0xa057 ; heuristic 0xa0577a18 'debug'
a022d8e4 962f0bfa blx      #0xa04f9744
a022d8e8 000050e3 cmp      r0, #0
a022d8ec 1102000a beq      #0xa022e138
a022d8f0 c0190ce3 movw     r1, #0xc9c0
a022d8f4 0500a0e1 mov      r0, r5
a022d8f8 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c9c0 'vert'
a022d8fc 902f0bfa blx      #0xa04f9744
a022d900 000050e3 cmp      r0, #0
a022d904 0c01000a beq      #0xa022dd3c
a022d908 c8190ce3 movw     r1, #0xc9c8
a022d90c 0500a0e1 mov      r0, r5
a022d910 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059c9c8 'windowinfo'
a022d914 8a2f0bfa blx      #0xa04f9744
a022d918 000050e3 cmp      r0, #0
a022d91c 0a02000a beq      #0xa022e14c
a022d920 541c0ce3 movw     r1, #0xcc54
a022d924 0500a0e1 mov      r0, r5
a022d928 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059cc54 'warpcoretrasnfer'
a022d92c 842f0bfa blx      #0xa04f9744
a022d930 000050e3 cmp      r0, #0
a022d934 0b01000a beq      #0xa022dd68
a022d938 681c0ce3 movw     r1, #0xcc68
a022d93c 0500a0e1 mov      r0, r5
a022d940 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059cc68 'wct'
a022d944 7e2f0bfa blx      #0xa04f9744
a022d948 000050e3 cmp      r0, #0
a022d94c 0501000a beq      #0xa022dd68
a022d950 f01f0ce3 movw     r1, #0xcff0
a022d954 0500a0e1 mov      r0, r5
a022d958 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059cff0 'superwarp'
a022d95c 782f0bfa blx      #0xa04f9744
a022d960 000050e3 cmp      r0, #0
a022d964 3c02000a beq      #0xa022e25c
a022d968 30130de3 movw     r1, #0xd330
a022d96c 0500a0e1 mov      r0, r5
a022d970 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059d330 'superview'
a022d974 722f0bfa blx      #0xa04f9744
a022d978 000050e3 cmp      r0, #0
a022d97c 3802000a beq      #0xa022e264
a022d980 24100ae3 movw     r1, #0xa024
a022d984 0500a0e1 mov      r0, r5
a022d988 59104ae3 movt     r1, #0xa059 ; heuristic 0xa059a024 'bypasstest'
a022d98c 6c2f0bfa blx      #0xa04f9744
a022d990 000050e3 cmp      r0, #0
a022d994 3402000a beq      #0xa022e26c
a022d998 2d0056e3 cmp      r6, #0x2d
a022d99c 0520a011 movne    r2, r5
a022d9a0 7502000a beq      #0xa022e37c
a022d9a4 306046e2 sub      r6, r6, #0x30
a022d9a8 090056e3 cmp      r6, #9
a022d9ac 0200009a bls      #0xa022d9bc
a022d9b0 b6ffffea b        #0xa022d890
a022d9b4 090051e3 cmp      r1, #9
a022d9b8 b4ffff8a bhi      #0xa022d890
a022d9bc 0130f2e5 ldrb     r3, [r2, #1]!
a022d9c0 000053e3 cmp      r3, #0
a022d9c4 301043e2 sub      r1, r3, #0x30
a022d9c8 f9ffff1a bne      #0xa022d9b4
a022d9cc 0500a0e1 mov      r0, r5
a022d9d0 32290bfa blx      #0xa04f7ea0
a022d9d4 0b0050e3 cmp      r0, #0xb
a022d9d8 0050a0e1 mov      r5, r0
a022d9dc 2b03000a beq      #0xa022e690
a022d9e0 0a0055e3 cmp      r5, #0xa
a022d9e4 2003000a beq      #0xa022e66c
a022d9e8 010055e3 cmp      r5, #1
a022d9ec 6702009a bls      #0xa022e390
a022d9f0 020055e3 cmp      r5, #2
a022d9f4 2803000a beq      #0xa022e69c
a022d9f8 150055e3 cmp      r5, #0x15
a022d9fc 4d03000a beq      #0xa022e738
a022da00 030055e3 cmp      r5, #3
a022da04 6b03000a beq      #0xa022e7b8
a022da08 040055e3 cmp      r5, #4
a022da0c 2004000a beq      #0xa022ea94
a022da10 050055e3 cmp      r5, #5
a022da14 8203000a beq      #0xa022e824
a022da18 060055e3 cmp      r5, #6
a022da1c 8004000a beq      #0xa022ec24
a022da20 0c0055e3 cmp      r5, #0xc
a022da24 c000001a bne      #0xa022dd2c
a022da28 98608de2 add      r6, sp, #0x98
a022da2c 0010a0e3 mov      r1, #0
a022da30 2820a0e3 mov      r2, #0x28
a022da34 0600a0e1 mov      r0, r6
a022da38 eb2c0bfa blx      #0xa04f8dec
a022da3c 2c030de3 movw     r0, #0xd32c
a022da40 0050a0e3 mov      r5, #0
a022da44 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d32c 'EIS superview'
a022da48 44508de5 str      r5, [sp, #0x44]
a022da4c 48508de5 str      r5, [sp, #0x48]
a022da50 d4b208e3 movw     fp, #0x82d4
a022da54 a4e501eb bl       #0xa02a70ec
a022da58 0510a0e1 mov      r1, r5
a022da5c 0c20a0e3 mov      r2, #0xc
a022da60 58008de2 add      r0, sp, #0x58
a022da64 42b14ae3 movt     fp, #0xa142
a022da68 df2c0bfa blx      #0xa04f8dec
a022da6c b4e19de5 ldr      lr, [sp, #0x1b4]
a022da70 1eada0e3 mov      sl, #0x780
a022da74 b8c1dde5 ldrb     ip, [sp, #0x1b8]
a022da78 b911dde5 ldrb     r1, [sp, #0x1b9]
a022da7c ba21dde5 ldrb     r2, [sp, #0x1ba]
a022da80 bb31dde5 ldrb     r3, [sp, #0x1bb]
a022da84 a8919de5 ldr      sb, [sp, #0x1a8]
a022da88 ac819de5 ldr      r8, [sp, #0x1ac]
a022da8c b0719de5 ldr      r7, [sp, #0x1b0]
a022da90 0c0094e5 ldr      r0, [r4, #0xc]
a022da94 90e08de5 str      lr, [sp, #0x90]
a022da98 94c0cde5 strb     ip, [sp, #0x94]
a022da9c 9510cde5 strb     r1, [sp, #0x95]
a022daa0 9620cde5 strb     r2, [sp, #0x96]
a022daa4 9730cde5 strb     r3, [sp, #0x97]
a022daa8 84908de5 str      sb, [sp, #0x84]
a022daac 389400e3 movw     sb, #0x438
a022dab0 88808de5 str      r8, [sp, #0x88]
a022dab4 0f8ca0e3 mov      r8, #0xf00
a022dab8 8c708de5 str      r7, [sp, #0x8c]
a022dabc 017100e3 movw     r7, #0x101
a022dac0 f6280bfa blx      #0xa04f7ea0
a022dac4 64008de5 str      r0, [sp, #0x64]
a022dac8 137042e3 movt     r7, #0x2013
a022dacc 100094e5 ldr      r0, [r4, #0x10]
a022dad0 f2280bfa blx      #0xa04f7ea0
a022dad4 68008de5 str      r0, [sp, #0x68]
a022dad8 140094e5 ldr      r0, [r4, #0x14]
a022dadc ef280bfa blx      #0xa04f7ea0
a022dae0 6c008de5 str      r0, [sp, #0x6c]
a022dae4 180094e5 ldr      r0, [r4, #0x18]
a022dae8 ec280bfa blx      #0xa04f7ea0
a022daec 70008de5 str      r0, [sp, #0x70]
a022daf0 1c0094e5 ldr      r0, [r4, #0x1c]
a022daf4 e9280bfa blx      #0xa04f7ea0
a022daf8 7c008de5 str      r0, [sp, #0x7c]
a022dafc 200094e5 ldr      r0, [r4, #0x20]
a022db00 e6280bfa blx      #0xa04f7ea0
a022db04 80008de5 str      r0, [sp, #0x80]
a022db08 240094e5 ldr      r0, [r4, #0x24]
a022db0c e3280bfa blx      #0xa04f7ea0
a022db10 74008de5 str      r0, [sp, #0x74]
a022db14 280094e5 ldr      r0, [r4, #0x28]
a022db18 e0280bfa blx      #0xa04f7ea0
a022db1c 01c0a0e3 mov      ip, #1
a022db20 1fe0a0e3 mov      lr, #0x1f
a022db24 2330a0e3 mov      r3, #0x23
a022db28 78008de5 str      r0, [sp, #0x78]
a022db2c 70718de5 str      r7, [sp, #0x170]
a022db30 3c030de3 movw     r0, #0xd33c
a022db34 0770a0e3 mov      r7, #7
a022db38 9c908de5 str      sb, [sp, #0x9c]
a022db3c 8c818de5 str      r8, [sp, #0x18c]
a022db40 94950de3 movw     sb, #0xd594
a022db44 ac8907e3 movw     r8, #0x79ac
a022db48 0e10a0e1 mov      r1, lr
a022db4c 0320a0e1 mov      r2, r3
a022db50 74e18de5 str      lr, [sp, #0x174]
a022db54 78318de5 str      r3, [sp, #0x178]
a022db58 06e0a0e3 mov      lr, #6
a022db5c 013aa0e3 mov      r3, #0x1000
a022db60 98a08de5 str      sl, [sp, #0x98]
a022db64 68c18de5 str      ip, [sp, #0x168]
a022db68 59004ae3 movt     r0, #0xa059
a022db6c 94c1cde5 strb     ip, [sp, #0x194]
a022db70 59804ae3 movt     r8, #0xa059
a022db74 95c1cde5 strb     ip, [sp, #0x195]
a022db78 59904ae3 movt     sb, #0xa059
a022db7c 96c1cde5 strb     ip, [sp, #0x196]
a022db80 7aa800e3 movw     sl, #0x87a
a022db84 97c1cde5 strb     ip, [sp, #0x197]
a022db88 87cea0e3 mov      ip, #0x870
a022db8c 7c718de5 str      r7, [sp, #0x17c]
a022db90 0b70a0e1 mov      r7, fp
a022db94 90c18de5 str      ip, [sp, #0x190]
a022db98 80e18de5 str      lr, [sp, #0x180]
a022db9c 40508de5 str      r5, [sp, #0x40]
a022dba0 84518de5 str      r5, [sp, #0x184]
a022dba4 88518de5 str      r5, [sp, #0x188]
a022dba8 4fe501eb bl       #0xa02a70ec
a022dbac 0510a0e1 mov      r1, r5
a022dbb0 0b00a0e1 mov      r0, fp
a022dbb4 0129a0e3 mov      r2, #0x4000
a022dbb8 8b2c0bfa blx      #0xa04f8dec
a022dbbc 021045e2 sub      r1, r5, #2
a022dbc0 3ce085e2 add      lr, r5, #0x3c
a022dbc4 012088e0 add      r2, r8, r1
a022dbc8 0ee088e0 add      lr, r8, lr
a022dbcc 011089e0 add      r1, sb, r1
a022dbd0 0730a0e1 mov      r3, r7
a022dbd4 b2c0f2e1 ldrh     ip, [r2, #2]!
a022dbd8 043083e2 add      r3, r3, #4
a022dbdc b200f1e1 ldrh     r0, [r1, #2]!
a022dbe0 0e0052e1 cmp      r2, lr
a022dbe4 b4c043e1 strh     ip, [r3, #-4]
a022dbe8 b20043e1 strh     r0, [r3, #-2]
a022dbec f8ffff1a bne      #0xa022dbd4
a022dbf0 3e5085e2 add      r5, r5, #0x3e
a022dbf4 7c7087e2 add      r7, r7, #0x7c
a022dbf8 0a0055e1 cmp      r5, sl
a022dbfc eeffff1a bne      #0xa022dbbc
a022dc00 17ee8de2 add      lr, sp, #0x170
a022dc04 c0c08de2 add      ip, sp, #0xc0
a022dc08 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022dc0c 9851dde5 ldrb     r5, [sp, #0x198]
a022dc10 a4b18de5 str      fp, [sp, #0x1a4]
a022dc14 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022dc18 1f50c0e7 bfc      r5, #0, #1
a022dc1c 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022dc20 9851cde5 strb     r5, [sp, #0x198]
a022dc24 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022dc28 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022dc2c 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022dc30 03009ee8 ldm      lr, {r0, r1}
a022dc34 03008ce8 stm      ip, {r0, r1}
a022dc38 b4ad02eb bl       #0xa02d9310
a022dc3c f40709e3 movw     r0, #0x97f4
a022dc40 84108de2 add      r1, sp, #0x84
a022dc44 3c014ae3 movt     r0, #0xa13c
a022dc48 39ae02eb bl       #0xa02d9534
a022dc4c f40709e3 movw     r0, #0x97f4
a022dc50 44108de2 add      r1, sp, #0x44
a022dc54 3c014ae3 movt     r0, #0xa13c
a022dc58 6cae02eb bl       #0xa02d9610
a022dc5c f40709e3 movw     r0, #0x97f4
a022dc60 74108de2 add      r1, sp, #0x74
a022dc64 3c014ae3 movt     r0, #0xa13c
a022dc68 43af02eb bl       #0xa02d997c
a022dc6c f40709e3 movw     r0, #0x97f4
a022dc70 40108de2 add      r1, sp, #0x40
a022dc74 3c014ae3 movt     r0, #0xa13c
a022dc78 5eaf02eb bl       #0xa02d99f8
a022dc7c f40709e3 movw     r0, #0x97f4
a022dc80 64108de2 add      r1, sp, #0x64
a022dc84 3c014ae3 movt     r0, #0xa13c
a022dc88 1caf02eb bl       #0xa02d9900
a022dc8c f40709e3 movw     r0, #0x97f4
a022dc90 0610a0e1 mov      r1, r6
a022dc94 3c014ae3 movt     r0, #0xa13c
a022dc98 d7ae02eb bl       #0xa02d97fc
a022dc9c f40709e3 movw     r0, #0x97f4
a022dca0 0610a0e3 mov      r1, #6
a022dca4 3c014ae3 movt     r0, #0xa13c
a022dca8 8faf02eb bl       #0xa02d9aec
a022dcac f40709e3 movw     r0, #0x97f4
a022dcb0 c0108de2 add      r1, sp, #0xc0
a022dcb4 3c014ae3 movt     r0, #0xa13c
a022dcb8 73ae02eb bl       #0xa02d968c
a022dcbc 2c0094e5 ldr      r0, [r4, #0x2c]
a022dcc0 76280bfa blx      #0xa04f7ea0
a022dcc4 900a07ee vmov     s15, r0
a022dcc8 f40709e3 movw     r0, #0x97f4
a022dccc 211bdfed vldr     d17, [pc, #0x84]
a022dcd0 3c014ae3 movt     r0, #0xa13c
a022dcd4 e70bf8ee vcvt.f64.s32 d16, s15
a022dcd8 200b9fed vldr     d0, [pc, #0x80]
a022dcdc a10b60ee vmul.f64 d16, d16, d17
a022dce0 800b80ee vdiv.f64 d0, d16, d0
a022dce4 a7af02eb bl       #0xa02d9b88
a022dce8 f40709e3 movw     r0, #0x97f4
a022dcec 0110a0e3 mov      r1, #1
a022dcf0 3c014ae3 movt     r0, #0xa13c
a022dcf4 afb202eb bl       #0xa02da7b8
a022dcf8 300094e5 ldr      r0, [r4, #0x30]
a022dcfc 67280bfa blx      #0xa04f7ea0
a022dd00 0010a0e1 mov      r1, r0
a022dd04 f40709e3 movw     r0, #0x97f4
a022dd08 3c014ae3 movt     r0, #0xa13c
a022dd0c 14b102eb bl       #0xa02da164
a022dd10 f40709e3 movw     r0, #0x97f4
a022dd14 3c014ae3 movt     r0, #0xa13c
a022dd18 fdb102eb bl       #0xa02da514
a022dd1c 020000ea b        #0xa022dd2c
a022dd20 a8090ce3 movw     r0, #0xc9a8
a022dd24 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c9a8 'current warp info: TBD'
a022dd28 efe401eb bl       #0xa02a70ec
a022dd2c 0000a0e3 mov      r0, #0
a022dd30 7000afe6 sxtb     r0, r0
a022dd34 8bdf8de2 add      sp, sp, #0x22c
a022dd38 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a022dd3c 0c0094e5 ldr      r0, [r4, #0xc]
a022dd40 56280bfa blx      #0xa04f7ea0
a022dd44 c0108de2 add      r1, sp, #0xc0
a022dd48 b20ccde1 strh     r0, [sp, #0xc2]
a022dd4c 4c008de2 add      r0, sp, #0x4c
a022dd50 abaf02eb bl       #0xa02d9c04
a022dd54 f4ffffea b        #0xa022dd2c
a022dd58 182d4454 strbpl   r2, [r4], #-0xd18
a022dd5c fb210940 strdmi   r2, r3, [sb], -fp
a022dd60 00000000 andeq    r0, r0, r0
a022dd64 00806640 rsbmi    r8, r6, r0
a022dd68 0030a0e3 mov      r3, #0
a022dd6c 0c0094e5 ldr      r0, [r4, #0xc]
a022dd70 98308de5 str      r3, [sp, #0x98]
a022dd74 9c308de5 str      r3, [sp, #0x9c]
a022dd78 a0308de5 str      r3, [sp, #0xa0]
a022dd7c a4308de5 str      r3, [sp, #0xa4]
a022dd80 a8308de5 str      r3, [sp, #0xa8]
a022dd84 ac308de5 str      r3, [sp, #0xac]
a022dd88 b0308de5 str      r3, [sp, #0xb0]
a022dd8c b4308de5 str      r3, [sp, #0xb4]
a022dd90 b8308de5 str      r3, [sp, #0xb8]
a022dd94 bc308de5 str      r3, [sp, #0xbc]
a022dd98 40280bfa blx      #0xa04f7ea0
a022dd9c 0050a0e1 mov      r5, r0
a022dda0 100094e5 ldr      r0, [r4, #0x10]
a022dda4 3d280bfa blx      #0xa04f7ea0
a022dda8 0060a0e1 mov      r6, r0
a022ddac 140094e5 ldr      r0, [r4, #0x14]
a022ddb0 3a280bfa blx      #0xa04f7ea0
a022ddb4 0070a0e1 mov      r7, r0
a022ddb8 180094e5 ldr      r0, [r4, #0x18]
a022ddbc 37280bfa blx      #0xa04f7ea0
a022ddc0 0080a0e1 mov      r8, r0
a022ddc4 1c0094e5 ldr      r0, [r4, #0x1c]
a022ddc8 34280bfa blx      #0xa04f7ea0
a022ddcc 10008de5 str      r0, [sp, #0x10]
a022ddd0 200094e5 ldr      r0, [r4, #0x20]
a022ddd4 31280bfa blx      #0xa04f7ea0
a022ddd8 00b0a0e1 mov      fp, r0
a022dddc 240094e5 ldr      r0, [r4, #0x24]
a022dde0 2e280bfa blx      #0xa04f7ea0
a022dde4 00a0a0e1 mov      sl, r0
a022dde8 280094e5 ldr      r0, [r4, #0x28]
a022ddec 2b280bfa blx      #0xa04f7ea0
a022ddf0 0090a0e1 mov      sb, r0
a022ddf4 6c0c0ce3 movw     r0, #0xcc6c
a022ddf8 0510a0e1 mov      r1, r5
a022ddfc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cc6c 'VinSensorGeo.StartX     = %d'
a022de00 20508de5 str      r5, [sp, #0x20]
a022de04 b8e401eb bl       #0xa02a70ec
a022de08 8c0c0ce3 movw     r0, #0xcc8c
a022de0c 0610a0e1 mov      r1, r6
a022de10 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cc8c 'VinSensorGeo.StartY     = %d'
a022de14 24608de5 str      r6, [sp, #0x24]
a022de18 b3e401eb bl       #0xa02a70ec
a022de1c ac0c0ce3 movw     r0, #0xccac
a022de20 0710a0e1 mov      r1, r7
a022de24 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ccac 'VinSensorGeo.Width      = %d'
a022de28 28708de5 str      r7, [sp, #0x28]
a022de2c aee401eb bl       #0xa02a70ec
a022de30 cc0c0ce3 movw     r0, #0xcccc
a022de34 0810a0e1 mov      r1, r8
a022de38 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cccc 'VinSensorGeo.Height     = %d'
a022de3c 2c808de5 str      r8, [sp, #0x2c]
a022de40 a9e401eb bl       #0xa02a70ec
a022de44 ec0c0ce3 movw     r0, #0xccec
a022de48 14b08de5 str      fp, [sp, #0x14]
a022de4c 1010dde5 ldrb     r1, [sp, #0x10]
a022de50 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ccec 'VinSensorGeo.HSubSample = %d/%d'
a022de54 1420dde5 ldrb     r2, [sp, #0x14]
a022de58 a3e401eb bl       #0xa02a70ec
a022de5c 0c0d0ce3 movw     r0, #0xcd0c
a022de60 18a08de5 str      sl, [sp, #0x18]
a022de64 1c908de5 str      sb, [sp, #0x1c]
a022de68 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cd0c 'VinSensorGeo.VSubSample = %d/%d'
a022de6c 1c20dde5 ldrb     r2, [sp, #0x1c]
a022de70 1810dde5 ldrb     r1, [sp, #0x18]
a022de74 9ce401eb bl       #0xa02a70ec
a022de78 2c0094e5 ldr      r0, [r4, #0x2c]
a022de7c 07280bfa blx      #0xa04f7ea0
a022de80 0090a0e1 mov      sb, r0
a022de84 300094e5 ldr      r0, [r4, #0x30]
a022de88 04280bfa blx      #0xa04f7ea0
a022de8c 00a0a0e1 mov      sl, r0
a022de90 340094e5 ldr      r0, [r4, #0x34]
a022de94 01280bfa blx      #0xa04f7ea0
a022de98 00b0a0e1 mov      fp, r0
a022de9c 380094e5 ldr      r0, [r4, #0x38]
a022dea0 fe270bfa blx      #0xa04f7ea0
a022dea4 0050a0e1 mov      r5, r0
a022dea8 2c0d0ce3 movw     r0, #0xcd2c
a022deac 0910a0e1 mov      r1, sb
a022deb0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cd2c 'DzoomInfo.ZoomX   = %d'
a022deb4 30908de5 str      sb, [sp, #0x30]
a022deb8 8be401eb bl       #0xa02a70ec
a022debc 440d0ce3 movw     r0, #0xcd44
a022dec0 0a10a0e1 mov      r1, sl
a022dec4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cd44 'DzoomInfo.ZoomY   = %d'
a022dec8 34a08de5 str      sl, [sp, #0x34]
a022decc 86e401eb bl       #0xa02a70ec
a022ded0 5c0d0ce3 movw     r0, #0xcd5c
a022ded4 0b10a0e1 mov      r1, fp
a022ded8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cd5c 'DzoomInfo.ShiftX  = %d'
a022dedc 38b08de5 str      fp, [sp, #0x38]
a022dee0 81e401eb bl       #0xa02a70ec
a022dee4 740d0ce3 movw     r0, #0xcd74
a022dee8 0510a0e1 mov      r1, r5
a022deec 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cd74 'DzoomInfo.ShiftY  = %d'
a022def0 3c508de5 str      r5, [sp, #0x3c]
a022def4 7ce401eb bl       #0xa02a70ec
a022def8 3c0094e5 ldr      r0, [r4, #0x3c]
a022defc e7270bfa blx      #0xa04f7ea0
a022df00 0060a0e1 mov      r6, r0
a022df04 400094e5 ldr      r0, [r4, #0x40]
a022df08 e4270bfa blx      #0xa04f7ea0
a022df0c 0070a0e1 mov      r7, r0
a022df10 440094e5 ldr      r0, [r4, #0x44]
a022df14 e1270bfa blx      #0xa04f7ea0
a022df18 0090a0e1 mov      sb, r0
a022df1c 480094e5 ldr      r0, [r4, #0x48]
a022df20 de270bfa blx      #0xa04f7ea0
a022df24 0080a0e1 mov      r8, r0
a022df28 8c0d0ce3 movw     r0, #0xcd8c
a022df2c 0610a0e1 mov      r1, r6
a022df30 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cd8c 'DmyRange.Bottom  = %d'
a022df34 6ce401eb bl       #0xa02a70ec
a022df38 a40d0ce3 movw     r0, #0xcda4
a022df3c 0710a0e1 mov      r1, r7
a022df40 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cda4 'DmyRange.Top     = %d'
a022df44 68e401eb bl       #0xa02a70ec
a022df48 bc0d0ce3 movw     r0, #0xcdbc
a022df4c 0910a0e1 mov      r1, sb
a022df50 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cdbc 'DmyRange.Left    = %d'
a022df54 64e401eb bl       #0xa02a70ec
a022df58 d40d0ce3 movw     r0, #0xcdd4
a022df5c 0810a0e1 mov      r1, r8
a022df60 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cdd4 'DmyRange.Right   = %d'
a022df64 60e401eb bl       #0xa02a70ec
a022df68 4c0094e5 ldr      r0, [r4, #0x4c]
a022df6c cb270bfa blx      #0xa04f7ea0
a022df70 00b0a0e1 mov      fp, r0
a022df74 500094e5 ldr      r0, [r4, #0x50]
a022df78 c8270bfa blx      #0xa04f7ea0
a022df7c 00a0a0e1 mov      sl, r0
a022df80 ec0d0ce3 movw     r0, #0xcdec
a022df84 0b10a0e1 mov      r1, fp
a022df88 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cdec 'MainWinDim.Width  = %d'
a022df8c 56e401eb bl       #0xa02a70ec
a022df90 040e0ce3 movw     r0, #0xce04
a022df94 0a10a0e1 mov      r1, sl
a022df98 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ce04 'MainWinDim.Height = %d'
a022df9c 52e401eb bl       #0xa02a70ec
a022dfa0 540094e5 ldr      r0, [r4, #0x54]
a022dfa4 bd270bfa blx      #0xa04f7ea0
a022dfa8 0050a0e1 mov      r5, r0
a022dfac 580094e5 ldr      r0, [r4, #0x58]
a022dfb0 ba270bfa blx      #0xa04f7ea0
a022dfb4 0040a0e1 mov      r4, r0
a022dfb8 1c0e0ce3 movw     r0, #0xce1c
a022dfbc 0510a0e1 mov      r1, r5
a022dfc0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ce1c 'EIS.HorSkewPhaseInc = %d'
a022dfc4 48e401eb bl       #0xa02a70ec
a022dfc8 380e0ce3 movw     r0, #0xce38
a022dfcc 0410a0e1 mov      r1, r4
a022dfd0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ce38 'EIS.VerSkewPhaseInc = %d'
a022dfd4 44e401eb bl       #0xa02a70ec
a022dfd8 ccac02eb bl       #0xa02d9310
a022dfdc 9ca08de5 str      sl, [sp, #0x9c]
a022dfe0 98e08de2 add      lr, sp, #0x98
a022dfe4 20a09de5 ldr      sl, [sp, #0x20]
a022dfe8 e4c08de2 add      ip, sp, #0xe4
a022dfec 98b08de5 str      fp, [sp, #0x98]
a022dff0 10b0dde5 ldrb     fp, [sp, #0x10]
a022dff4 c0a08de5 str      sl, [sp, #0xc0]
a022dff8 24a09de5 ldr      sl, [sp, #0x24]
a022dffc d0b0cde5 strb     fp, [sp, #0xd0]
a022e000 14b0dde5 ldrb     fp, [sp, #0x14]
a022e004 c4a08de5 str      sl, [sp, #0xc4]
a022e008 28a09de5 ldr      sl, [sp, #0x28]
a022e00c d1b0cde5 strb     fp, [sp, #0xd1]
a022e010 18b0dde5 ldrb     fp, [sp, #0x18]
a022e014 c8a08de5 str      sl, [sp, #0xc8]
a022e018 2ca09de5 ldr      sl, [sp, #0x2c]
a022e01c d2b0cde5 strb     fp, [sp, #0xd2]
a022e020 1cb0dde5 ldrb     fp, [sp, #0x1c]
a022e024 cca08de5 str      sl, [sp, #0xcc]
a022e028 30a09de5 ldr      sl, [sp, #0x30]
a022e02c 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022e030 d4a08de5 str      sl, [sp, #0xd4]
a022e034 34a09de5 ldr      sl, [sp, #0x34]
a022e038 d3b0cde5 strb     fp, [sp, #0xd3]
a022e03c 38b09de5 ldr      fp, [sp, #0x38]
a022e040 d8a08de5 str      sl, [sp, #0xd8]
a022e044 3ca09de5 ldr      sl, [sp, #0x3c]
a022e048 dcb08de5 str      fp, [sp, #0xdc]
a022e04c e0a08de5 str      sl, [sp, #0xe0]
a022e050 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022e054 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022e058 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022e05c 03009ee8 ldm      lr, {r0, r1}
a022e060 03008ce8 stm      ip, {r0, r1}
a022e064 c0108de2 add      r1, sp, #0xc0
a022e068 4c008de2 add      r0, sp, #0x4c
a022e06c 14918de5 str      sb, [sp, #0x114]
a022e070 18818de5 str      r8, [sp, #0x118]
a022e074 1c718de5 str      r7, [sp, #0x11c]
a022e078 20618de5 str      r6, [sp, #0x120]
a022e07c 0c518de5 str      r5, [sp, #0x10c]
a022e080 10418de5 str      r4, [sp, #0x110]
a022e084 feae02eb bl       #0xa02d9c84
a022e088 540e0ce3 movw     r0, #0xce54
a022e08c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ce54 '==============Output==============='
a022e090 15e401eb bl       #0xa02a70ec
a022e094 780e0ce3 movw     r0, #0xce78
a022e098 48119de5 ldr      r1, [sp, #0x148]
a022e09c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ce78 'WindowInfo.ActWinCrop.LeftTopX  = %d'
a022e0a0 11e401eb bl       #0xa02a70ec
a022e0a4 a00e0ce3 movw     r0, #0xcea0
a022e0a8 4c119de5 ldr      r1, [sp, #0x14c]
a022e0ac 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cea0 'WindowInfo.ActWinCrop.LeftTopY  = %d'
a022e0b0 0de401eb bl       #0xa02a70ec
a022e0b4 c80e0ce3 movw     r0, #0xcec8
a022e0b8 50119de5 ldr      r1, [sp, #0x150]
a022e0bc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cec8 'WindowInfo.ActWinCrop.RightBotX = %d'
a022e0c0 09e401eb bl       #0xa02a70ec
a022e0c4 f00e0ce3 movw     r0, #0xcef0
a022e0c8 54119de5 ldr      r1, [sp, #0x154]
a022e0cc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cef0 'WindowInfo.ActWinCrop.RightBotY = %d'
a022e0d0 05e401eb bl       #0xa02a70ec
a022e0d4 180f0ce3 movw     r0, #0xcf18
a022e0d8 30119de5 ldr      r1, [sp, #0x130]
a022e0dc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cf18 'WindowInfo.DmyWinGeo.StartX  = %d'
a022e0e0 01e401eb bl       #0xa02a70ec
a022e0e4 3c0f0ce3 movw     r0, #0xcf3c
a022e0e8 34119de5 ldr      r1, [sp, #0x134]
a022e0ec 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cf3c 'WindowInfo.DmyWinGeo.StartY  = %d'
a022e0f0 fde301eb bl       #0xa02a70ec
a022e0f4 600f0ce3 movw     r0, #0xcf60
a022e0f8 38119de5 ldr      r1, [sp, #0x138]
a022e0fc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cf60 'WindowInfo.DmyWinGeo.Width   = %d'
a022e100 f9e301eb bl       #0xa02a70ec
a022e104 840f0ce3 movw     r0, #0xcf84
a022e108 3c119de5 ldr      r1, [sp, #0x13c]
a022e10c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cf84 'WindowInfo.DmyWinGeo.Height  = %d'
a022e110 f5e301eb bl       #0xa02a70ec
a022e114 a80f0ce3 movw     r0, #0xcfa8
a022e118 40119de5 ldr      r1, [sp, #0x140]
a022e11c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cfa8 'WindowInfo.CfaWinDim.Width  = %d'
a022e120 f1e301eb bl       #0xa02a70ec
a022e124 cc0f0ce3 movw     r0, #0xcfcc
a022e128 44119de5 ldr      r1, [sp, #0x144]
a022e12c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cfcc 'WindowInfo.CfaWinDim.Height = %d'
a022e130 ede301eb bl       #0xa02a70ec
a022e134 fcfeffea b        #0xa022dd2c
a022e138 0c0094e5 ldr      r0, [r4, #0xc]
a022e13c 57270bfa blx      #0xa04f7ea0
a022e140 7000efe6 uxtb     r0, r0
a022e144 fb9103eb bl       #0xa0312938
a022e148 f7feffea b        #0xa022dd2c
a022e14c c0108de2 add      r1, sp, #0xc0
a022e150 4c008de2 add      r0, sp, #0x4c
a022e154 b5af02eb bl       #0xa02da030
a022e158 d4090ce3 movw     r0, #0xc9d4
a022e15c c0109de5 ldr      r1, [sp, #0xc0]
a022e160 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c9d4 'WarpWinInfo.DzoomInfo.ZoomX      = %d'
a022e164 e0e301eb bl       #0xa02a70ec
a022e168 fc090ce3 movw     r0, #0xc9fc
a022e16c c4109de5 ldr      r1, [sp, #0xc4]
a022e170 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059c9fc 'WarpWinInfo.DzoomInfo.ZoomY      = %d'
a022e174 dce301eb bl       #0xa02a70ec
a022e178 240a0ce3 movw     r0, #0xca24
a022e17c c8109de5 ldr      r1, [sp, #0xc8]
a022e180 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ca24 'WarpWinInfo.DzoomInfo.ShiftX     = %d'
a022e184 d8e301eb bl       #0xa02a70ec
a022e188 4c0a0ce3 movw     r0, #0xca4c
a022e18c cc109de5 ldr      r1, [sp, #0xcc]
a022e190 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ca4c 'WarpWinInfo.DzoomInfo.ShiftY     = %d'
a022e194 d4e301eb bl       #0xa02a70ec
a022e198 740a0ce3 movw     r0, #0xca74
a022e19c e8109de5 ldr      r1, [sp, #0xe8]
a022e1a0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ca74 'WarpWinInfo.ActWinCrop.LeftTopX  = %d'
a022e1a4 d0e301eb bl       #0xa02a70ec
a022e1a8 9c0a0ce3 movw     r0, #0xca9c
a022e1ac ec109de5 ldr      r1, [sp, #0xec]
a022e1b0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059ca9c 'WarpWinInfo.ActWinCrop.LeftTopY  = %d'
a022e1b4 cce301eb bl       #0xa02a70ec
a022e1b8 c40a0ce3 movw     r0, #0xcac4
a022e1bc f0109de5 ldr      r1, [sp, #0xf0]
a022e1c0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cac4 'WarpWinInfo.ActWinCrop.RightBotX = %d'
a022e1c4 c8e301eb bl       #0xa02a70ec
a022e1c8 ec0a0ce3 movw     r0, #0xcaec
a022e1cc f4109de5 ldr      r1, [sp, #0xf4]
a022e1d0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059caec 'WarpWinInfo.ActWinCrop.RightBotY = %d'
a022e1d4 c4e301eb bl       #0xa02a70ec
a022e1d8 140b0ce3 movw     r0, #0xcb14
a022e1dc d0109de5 ldr      r1, [sp, #0xd0]
a022e1e0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cb14 'WarpWinInfo.DmyWinGeo.StartX     = %d'
a022e1e4 c0e301eb bl       #0xa02a70ec
a022e1e8 3c0b0ce3 movw     r0, #0xcb3c
a022e1ec d4109de5 ldr      r1, [sp, #0xd4]
a022e1f0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cb3c 'WarpWinInfo.DmyWinGeo.StartY     = %d'
a022e1f4 bce301eb bl       #0xa02a70ec
a022e1f8 640b0ce3 movw     r0, #0xcb64
a022e1fc d8109de5 ldr      r1, [sp, #0xd8]
a022e200 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cb64 'WarpWinInfo.DmyWinGeo.Width      = %d'
a022e204 b8e301eb bl       #0xa02a70ec
a022e208 8c0b0ce3 movw     r0, #0xcb8c
a022e20c dc109de5 ldr      r1, [sp, #0xdc]
a022e210 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cb8c 'WarpWinInfo.DmyWinGeo.Height     = %d'
a022e214 b4e301eb bl       #0xa02a70ec
a022e218 b40b0ce3 movw     r0, #0xcbb4
a022e21c e0109de5 ldr      r1, [sp, #0xe0]
a022e220 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cbb4 'WarpWinInfo.CfaWinDim.Width      = %d'
a022e224 b0e301eb bl       #0xa02a70ec
a022e228 dc0b0ce3 movw     r0, #0xcbdc
a022e22c e4109de5 ldr      r1, [sp, #0xe4]
a022e230 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cbdc 'WarpWinInfo.CfaWinDim.Height     = %d'
a022e234 ace301eb bl       #0xa02a70ec
a022e238 040c0ce3 movw     r0, #0xcc04
a022e23c f8109de5 ldr      r1, [sp, #0xf8]
a022e240 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cc04 'WarpWinInfo.MainWinDim.Width     = %d'
a022e244 a8e301eb bl       #0xa02a70ec
a022e248 2c0c0ce3 movw     r0, #0xcc2c
a022e24c fc109de5 ldr      r1, [sp, #0xfc]
a022e250 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cc2c 'WarpWinInfo.MainWinDim.Height    = %d'
a022e254 a4e301eb bl       #0xa02a70ec
a022e258 b3feffea b        #0xa022dd2c
a022e25c d8aafeeb bl       #0xa01d8dc4
a022e260 b1feffea b        #0xa022dd2c
a022e264 8afcffeb bl       #0xa022d494
a022e268 affeffea b        #0xa022dd2c
a022e26c d0319de5 ldr      r3, [sp, #0x1d0]
a022e270 38c400e3 movw     ip, #0x438
a022e274 cc419de5 ldr      r4, [sp, #0x1cc]
a022e278 00a0a0e1 mov      sl, r0
a022e27c 1ca8dfe7 bfi      sl, ip, #0x10, #0x10
a022e280 1e9da0e3 mov      sb, #0x780
a022e284 433e63e2 rsb      r3, r3, #0x430
a022e288 015c8de2 add      r5, sp, #0x100
a022e28c 083083e2 add      r3, r3, #8
a022e290 1e4d64e2 rsb      r4, r4, #0x780
a022e294 a3e0a0e1 lsr      lr, r3, #1
a022e298 94350de3 movw     r3, #0xd594
a022e29c 59304ae3 movt     r3, #0xa059
a022e2a0 a440a0e1 lsr      r4, r4, #1
a022e2a4 d4308de5 str      r3, [sp, #0xd4]
a022e2a8 013c8de2 add      r3, sp, #0x100
a022e2ac 023083e2 add      r3, r3, #2
a022e2b0 01e08ee2 add      lr, lr, #1
a022e2b4 014084e2 add      r4, r4, #1
a022e2b8 b090c3e1 strh     sb, [r3]
a022e2bc 01e0cee3 bic      lr, lr, #1
a022e2c0 413f8de2 add      r3, sp, #0x104
a022e2c4 0140c4e3 bic      r4, r4, #1
a022e2c8 e4a08de5 str      sl, [sp, #0xe4]
a022e2cc ac2907e3 movw     r2, #0x79ac
a022e2d0 41af8de2 add      sl, sp, #0x104
a022e2d4 0188a0e3 mov      r8, #0x10000
a022e2d8 0170a0e3 mov      r7, #1
a022e2dc 1e60a0e3 mov      r6, #0x1e
a022e2e0 b0c0cae1 strh     ip, [sl]
a022e2e4 98008de5 str      r0, [sp, #0x98]
a022e2e8 59204ae3 movt     r2, #0xa059
a022e2ec 1eb5a0e3 mov      fp, #0x7800000
a022e2f0 b0e0c5e1 strh     lr, [r5]
a022e2f4 be4fcde1 strh     r4, [sp, #0xfe]
a022e2f8 2250a0e3 mov      r5, #0x22
a022e2fc 0340a0e3 mov      r4, #3
a022e300 02e0a0e3 mov      lr, #2
a022e304 9c008de5 str      r0, [sp, #0x9c]
a022e308 42af8de2 add      sl, sp, #0x108
a022e30c a0008de5 str      r0, [sp, #0xa0]
a022e310 023083e2 add      r3, r3, #2
a022e314 d8008de5 str      r0, [sp, #0xd8]
a022e318 c0108de2 add      r1, sp, #0xc0
a022e31c dc008de5 str      r0, [sp, #0xdc]
a022e320 fc00cde5 strb     r0, [sp, #0xfc]
a022e324 f8008de5 str      r0, [sp, #0xf8]
a022e328 f0008de5 str      r0, [sp, #0xf0]
a022e32c f4008de5 str      r0, [sp, #0xf4]
a022e330 98008de2 add      r0, sp, #0x98
a022e334 b0c0cae1 strh     ip, [sl]
a022e338 d0208de5 str      r2, [sp, #0xd0]
a022e33c b090c3e1 strh     sb, [r3]
a022e340 e0b08de5 str      fp, [sp, #0xe0]
a022e344 e8808de5 str      r8, [sp, #0xe8]
a022e348 ec808de5 str      r8, [sp, #0xec]
a022e34c c0708de5 str      r7, [sp, #0xc0]
a022e350 c870cde5 strb     r7, [sp, #0xc8]
a022e354 c460cde5 strb     r6, [sp, #0xc4]
a022e358 c960cde5 strb     r6, [sp, #0xc9]
a022e35c c550cde5 strb     r5, [sp, #0xc5]
a022e360 ca50cde5 strb     r5, [sp, #0xca]
a022e364 c640cde5 strb     r4, [sp, #0xc6]
a022e368 cb40cde5 strb     r4, [sp, #0xcb]
a022e36c c7e0cde5 strb     lr, [sp, #0xc7]
a022e370 cce0cde5 strb     lr, [sp, #0xcc]
a022e374 7d9103eb bl       #0xa0312970
a022e378 6bfeffea b        #0xa022dd2c
a022e37c 0160d5e5 ldrb     r6, [r5, #1]
a022e380 012085e2 add      r2, r5, #1
a022e384 000056e3 cmp      r6, #0
a022e388 85fdff1a bne      #0xa022d9a4
a022e38c 8efdffea b        #0xa022d9cc
a022e390 0010a0e3 mov      r1, #0
a022e394 38c400e3 movw     ip, #0x438
a022e398 0100a0e1 mov      r0, r1
a022e39c 010055e1 cmp      r5, r1
a022e3a0 1e2da0e3 mov      r2, #0x780
a022e3a4 0130a0e3 mov      r3, #1
a022e3a8 1c08dfe7 bfi      r0, ip, #0x10, #0x10
a022e3ac 1ee5a0e3 mov      lr, #0x7800000
a022e3b0 c4118de5 str      r1, [sp, #0x1c4]
a022e3b4 c8118de5 str      r1, [sp, #0x1c8]
a022e3b8 dc118de5 str      r1, [sp, #0x1dc]
a022e3bc e0118de5 str      r1, [sp, #0x1e0]
a022e3c0 e8018de5 str      r0, [sp, #0x1e8]
a022e3c4 b4c18de5 str      ip, [sp, #0x1b4]
a022e3c8 d0c18de5 str      ip, [sp, #0x1d0]
a022e3cc d8c18de5 str      ip, [sp, #0x1d8]
a022e3d0 f0c18de5 str      ip, [sp, #0x1f0]
a022e3d4 b0218de5 str      r2, [sp, #0x1b0]
a022e3d8 cc218de5 str      r2, [sp, #0x1cc]
a022e3dc d4218de5 str      r2, [sp, #0x1d4]
a022e3e0 ec218de5 str      r2, [sp, #0x1ec]
a022e3e4 b831cde5 strb     r3, [sp, #0x1b8]
a022e3e8 b931cde5 strb     r3, [sp, #0x1b9]
a022e3ec ba31cde5 strb     r3, [sp, #0x1ba]
a022e3f0 bb31cde5 strb     r3, [sp, #0x1bb]
a022e3f4 e4e18de5 str      lr, [sp, #0x1e4]
a022e3f8 c700000a beq      #0xa022e71c
a022e3fc a8919de5 ldr      sb, [sp, #0x1a8]
a022e400 014100e3 movw     r4, #0x101
a022e404 ac819de5 ldr      r8, [sp, #0x1ac]
a022e408 d40208e3 movw     r0, #0x82d4
a022e40c 68318de5 str      r3, [sp, #0x168]
a022e410 06e0a0e3 mov      lr, #6
a022e414 90c18de5 str      ip, [sp, #0x190]
a022e418 67c606e3 movw     ip, #0x6667
a022e41c 9431cde5 strb     r3, [sp, #0x194]
a022e420 66c646e3 movt     ip, #0x6666
a022e424 9531cde5 strb     r3, [sp, #0x195]
a022e428 42014ae3 movt     r0, #0xa142
a022e42c 9631cde5 strb     r3, [sp, #0x196]
a022e430 134042e3 movt     r4, #0x2013
a022e434 9731cde5 strb     r3, [sp, #0x197]
a022e438 893808e3 movw     r3, #0x8889
a022e43c 883848e3 movt     r3, #0x8888
a022e440 8c218de5 str      r2, [sp, #0x18c]
a022e444 1f60a0e3 mov      r6, #0x1f
a022e448 0129a0e3 mov      r2, #0x4000
a022e44c 1250a0e3 mov      r5, #0x12
a022e450 00b0a0e1 mov      fp, r0
a022e454 14308de5 str      r3, [sp, #0x14]
a022e458 0170a0e1 mov      r7, r1
a022e45c 10c08de5 str      ip, [sp, #0x10]
a022e460 18c08de5 str      ip, [sp, #0x18]
a022e464 7ce18de5 str      lr, [sp, #0x17c]
a022e468 80e18de5 str      lr, [sp, #0x180]
a022e46c 70418de5 str      r4, [sp, #0x170]
a022e470 84918de5 str      sb, [sp, #0x184]
a022e474 88818de5 str      r8, [sp, #0x188]
a022e478 74618de5 str      r6, [sp, #0x174]
a022e47c 78518de5 str      r5, [sp, #0x178]
a022e480 592a0bfa blx      #0xa04f8dec
a022e484 98000ae3 movw     r0, #0xa098
a022e488 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a098 'Test hor & ver warp table'
a022e48c 16e301eb bl       #0xa02a70ec
a022e490 14309de5 ldr      r3, [sp, #0x14]
a022e494 10c09de5 ldr      ip, [sp, #0x10]
a022e498 18b08de5 str      fp, [sp, #0x18]
a022e49c 03a0a0e1 mov      sl, r3
a022e4a0 0b30a0e1 mov      r3, fp
a022e4a4 0cb0a0e1 mov      fp, ip
a022e4a8 094047e2 sub      r4, r7, #9
a022e4ac 0360a0e1 mov      r6, r3
a022e4b0 940404e0 mul      r4, r4, r4
a022e4b4 0050a0e3 mov      r5, #0
a022e4b8 099067e2 rsb      sb, r7, #9
a022e4bc 14908de5 str      sb, [sp, #0x14]
a022e4c0 008064e2 rsb      r8, r4, #0
a022e4c4 044264e0 rsb      r4, r4, r4, lsl #4
a022e4c8 10808de5 str      r8, [sp, #0x10]
a022e4cc 0f0045e2 sub      r0, r5, #0xf
a022e4d0 14109de5 ldr      r1, [sp, #0x14]
a022e4d4 900000e0 mul      r0, r0, r0
a022e4d8 c42fa0e1 asr      r2, r4, #0x1f
a022e4dc 10e09de5 ldr      lr, [sp, #0x10]
a022e4e0 000057e3 cmp      r7, #0
a022e4e4 948ac9e0 smull    r8, sb, r4, sl
a022e4e8 910000e0 mul      r0, r1, r0
a022e4ec c0cfa0e1 asr      ip, r0, #0x1f
a022e4f0 900bc1e0 smull    r0, r1, r0, fp
a022e4f4 090084e0 add      r0, r4, sb
a022e4f8 c02162e0 rsb      r2, r2, r0, asr #3
a022e4fc 0e4084e0 add      r4, r4, lr
a022e500 b020c6e1 strh     r2, [r6]
a022e504 41c26ce0 rsb      ip, ip, r1, asr #4
a022e508 b2c0c6e1 strh     ip, [r6, #2]
a022e50c 2f02000a beq      #0xa022edd0
a022e510 015085e2 add      r5, r5, #1
a022e514 046086e2 add      r6, r6, #4
a022e518 1f0055e3 cmp      r5, #0x1f
a022e51c eaffff1a bne      #0xa022e4cc
a022e520 017087e2 add      r7, r7, #1
a022e524 7c3083e2 add      r3, r3, #0x7c
a022e528 120057e3 cmp      r7, #0x12
a022e52c ddffff1a bne      #0xa022e4a8
a022e530 18b09de5 ldr      fp, [sp, #0x18]
a022e534 a4b18de5 str      fp, [sp, #0x1a4]
a022e538 c0008de2 add      r0, sp, #0xc0
a022e53c 0240a0e3 mov      r4, #2
a022e540 6a9d06eb bl       #0xa03d5af0
a022e544 18c00de3 movw     ip, #0xd018
a022e548 c0e08de2 add      lr, sp, #0xc0
a022e54c 59c04ae3 movt     ip, #0xa059 ; heuristic 0xa059d018 'd:\\warp_table_3904x2604.bin'
a022e550 0f00bce8 ldm      ip!, {r0, r1, r2, r3}
a022e554 0f00aee8 stm      lr!, {r0, r1, r2, r3}
a022e558 07009ce8 ldm      ip, {r0, r1, r2}
a022e55c 07008ee8 stm      lr, {r0, r1, r2}
a022e560 34000de3 movw     r0, #0xd034
a022e564 84119de5 ldr      r1, [sp, #0x184]
a022e568 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d034 'CalcWarp.CalibWarpInfo.VinSensorGeo.StartX = %d'
a022e56c 0c41cde5 strb     r4, [sp, #0x10c]
a022e570 dde201eb bl       #0xa02a70ec
a022e574 64000de3 movw     r0, #0xd064
a022e578 88119de5 ldr      r1, [sp, #0x188]
a022e57c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d064 'CalcWarp.CalibWarpInfo.VinSensorGeo.StartY = %d'
a022e580 d9e201eb bl       #0xa02a70ec
a022e584 94000de3 movw     r0, #0xd094
a022e588 8c119de5 ldr      r1, [sp, #0x18c]
a022e58c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d094 'CalcWarp.CalibWarpInfo.VinSensorGeo.Width = %d'
a022e590 d5e201eb bl       #0xa02a70ec
a022e594 c4000de3 movw     r0, #0xd0c4
a022e598 90119de5 ldr      r1, [sp, #0x190]
a022e59c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d0c4 'CalcWarp.CalibWarpInfo.VinSensorGeo.Height = %d'
a022e5a0 d1e201eb bl       #0xa02a70ec
a022e5a4 f4000de3 movw     r0, #0xd0f4
a022e5a8 9411dde5 ldrb     r1, [sp, #0x194]
a022e5ac 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d0f4 'CalcWarp.CalibWarpInfo.VinSensorGeo.HSubSample.FactorNum = %d'
a022e5b0 cde201eb bl       #0xa02a70ec
a022e5b4 34010de3 movw     r0, #0xd134
a022e5b8 9511dde5 ldrb     r1, [sp, #0x195]
a022e5bc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d134 'CalcWarp.CalibWarpInfo.VinSensorGeo.HSubSample.FactorDen = %d'
a022e5c0 c9e201eb bl       #0xa02a70ec
a022e5c4 74010de3 movw     r0, #0xd174
a022e5c8 9611dde5 ldrb     r1, [sp, #0x196]
a022e5cc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d174 'CalcWarp.CalibWarpInfo.VinSensorGeo.VSubSample.FactorNum = %d'
a022e5d0 c5e201eb bl       #0xa02a70ec
a022e5d4 b4010de3 movw     r0, #0xd1b4
a022e5d8 9711dde5 ldrb     r1, [sp, #0x197]
a022e5dc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d1b4 'CalcWarp.CalibWarpInfo.VinSensorGeo.VSubSample.FactorDen = %d'
a022e5e0 c1e201eb bl       #0xa02a70ec
a022e5e4 f4010de3 movw     r0, #0xd1f4
a022e5e8 7c119de5 ldr      r1, [sp, #0x17c]
a022e5ec 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d1f4 'CalcWarp.CalibWarpInfo.TileWidthExp = %d'
a022e5f0 bde201eb bl       #0xa02a70ec
a022e5f4 20020de3 movw     r0, #0xd220
a022e5f8 80119de5 ldr      r1, [sp, #0x180]
a022e5fc 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d220 'CalcWarp.CalibWarpInfo.TileHeightExp = %d'
a022e600 b9e201eb bl       #0xa02a70ec
a022e604 4c020de3 movw     r0, #0xd24c
a022e608 74119de5 ldr      r1, [sp, #0x174]
a022e60c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d24c 'CalcWarp.CalibWarpInfo.HorGridNum = %d'
a022e610 b5e201eb bl       #0xa02a70ec
a022e614 74020de3 movw     r0, #0xd274
a022e618 78119de5 ldr      r1, [sp, #0x178]
a022e61c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d274 'CalcWarp.CalibWarpInfo.VerGridNum = %d'
a022e620 b1e201eb bl       #0xa02a70ec
a022e624 c0008de2 add      r0, sp, #0xc0
a022e628 f8a706eb bl       #0xa03d8610
a022e62c 004050e2 subs     r4, r0, #0
a022e630 d101000a beq      #0xa022ed7c
a022e634 d40208e3 movw     r0, #0x82d4
a022e638 012aa0e3 mov      r2, #0x1000
a022e63c 0430a0e1 mov      r3, r4
a022e640 0410a0e3 mov      r1, #4
a022e644 42014ae3 movt     r0, #0xa142
a022e648 649e06eb bl       #0xa03d5fe0
a022e64c 0400a0e1 mov      r0, r4
a022e650 3f9d06eb bl       #0xa03d5b54
a022e654 4c008de2 add      r0, sp, #0x4c
a022e658 5a1f8de2 add      r1, sp, #0x168
a022e65c d18c03eb bl       #0xa03119a8
a022e660 4c008de2 add      r0, sp, #0x4c
a022e664 7d8f03eb bl       #0xa0312460
a022e668 affdffea b        #0xa022dd2c
a022e66c 043105e3 movw     r3, #0x5104
a022e670 0020a0e3 mov      r2, #0
a022e674 fc0f0ce3 movw     r0, #0xcffc
a022e678 42314ae3 movt     r3, #0xa142
a022e67c 0210a0e1 mov      r1, r2
a022e680 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059cffc 'Force to NonStitching = %d '
a022e684 002083e5 str      r2, [r3]
a022e688 97e201eb bl       #0xa02a70ec
a022e68c a6fdffea b        #0xa022dd2c
a022e690 043105e3 movw     r3, #0x5104
a022e694 0120a0e3 mov      r2, #1
a022e698 f5ffffea b        #0xa022e674
a022e69c ac020de3 movw     r0, #0xd2ac
a022e6a0 1e4da0e3 mov      r4, #0x780
a022e6a4 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d2ac 'Test 2x dzoom'
a022e6a8 1e8ea0e3 mov      r8, #0x1e0
a022e6ac 8ee201eb bl       #0xa02a70ec
a022e6b0 0e7100e3 movw     r7, #0x10e
a022e6b4 38e400e3 movw     lr, #0x438
a022e6b8 0fcda0e3 mov      ip, #0x3c0
a022e6bc 872fa0e3 mov      r2, #0x21c
a022e6c0 0030a0e3 mov      r3, #0
a022e6c4 5a1f8de2 add      r1, sp, #0x168
a022e6c8 0f65a0e3 mov      r6, #0x3c00000
a022e6cc 8757a0e3 mov      r5, #0x21c0000
a022e6d0 4c008de2 add      r0, sp, #0x4c
a022e6d4 b0418de5 str      r4, [sp, #0x1b0]
a022e6d8 ec418de5 str      r4, [sp, #0x1ec]
a022e6dc b4e18de5 str      lr, [sp, #0x1b4]
a022e6e0 f0e18de5 str      lr, [sp, #0x1f0]
a022e6e4 ccc18de5 str      ip, [sp, #0x1cc]
a022e6e8 d4c18de5 str      ip, [sp, #0x1d4]
a022e6ec d0218de5 str      r2, [sp, #0x1d0]
a022e6f0 d8218de5 str      r2, [sp, #0x1d8]
a022e6f4 c4818de5 str      r8, [sp, #0x1c4]
a022e6f8 c8718de5 str      r7, [sp, #0x1c8]
a022e6fc dc318de5 str      r3, [sp, #0x1dc]
a022e700 e0318de5 str      r3, [sp, #0x1e0]
a022e704 e4618de5 str      r6, [sp, #0x1e4]
a022e708 e8518de5 str      r5, [sp, #0x1e8]
a022e70c a58c03eb bl       #0xa03119a8
a022e710 4c008de2 add      r0, sp, #0x4c
a022e714 518f03eb bl       #0xa0312460
a022e718 83fdffea b        #0xa022dd2c
a022e71c d40208e3 movw     r0, #0x82d4
a022e720 0510a0e1 mov      r1, r5
a022e724 0129a0e3 mov      r2, #0x4000
a022e728 42014ae3 movt     r0, #0xa142
a022e72c 68518de5 str      r5, [sp, #0x168]
a022e730 ad290bfa blx      #0xa04f8dec
a022e734 7fffffea b        #0xa022e538
a022e738 bc020de3 movw     r0, #0xd2bc
a022e73c 0040a0e3 mov      r4, #0
a022e740 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d2bc 'Test 2x dzoom with large dummy range'
a022e744 1e66a0e3 mov      r6, #0x1e00000
a022e748 67e201eb bl       #0xa02a70ec
a022e74c 04e0a0e1 mov      lr, r4
a022e750 1e2da0e3 mov      r2, #0x780
a022e754 383400e3 movw     r3, #0x438
a022e758 00c0a0e3 mov      ip, #0
a022e75c 2ae340e3 movt     lr, #0x32a
a022e760 5a1f8de2 add      r1, sp, #0x168
a022e764 0e4140e3 movt     r4, #0x10e
a022e768 5a56a0e3 mov      r5, #0x5a00000
a022e76c 4c008de2 add      r0, sp, #0x4c
a022e770 e0418de5 str      r4, [sp, #0x1e0]
a022e774 e8e18de5 str      lr, [sp, #0x1e8]
a022e778 b0218de5 str      r2, [sp, #0x1b0]
a022e77c ec218de5 str      r2, [sp, #0x1ec]
a022e780 cc218de5 str      r2, [sp, #0x1cc]
a022e784 d4218de5 str      r2, [sp, #0x1d4]
a022e788 b4318de5 str      r3, [sp, #0x1b4]
a022e78c f0318de5 str      r3, [sp, #0x1f0]
a022e790 d0318de5 str      r3, [sp, #0x1d0]
a022e794 d8318de5 str      r3, [sp, #0x1d8]
a022e798 dc618de5 str      r6, [sp, #0x1dc]
a022e79c e4518de5 str      r5, [sp, #0x1e4]
a022e7a0 c4c18de5 str      ip, [sp, #0x1c4]
a022e7a4 c8c18de5 str      ip, [sp, #0x1c8]
a022e7a8 7e8c03eb bl       #0xa03119a8
a022e7ac 4c008de2 add      r0, sp, #0x4c
a022e7b0 2a8f03eb bl       #0xa0312460
a022e7b4 5cfdffea b        #0xa022dd2c
a022e7b8 e4020de3 movw     r0, #0xd2e4
a022e7bc 1e45a0e3 mov      r4, #0x7800000
a022e7c0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d2e4 'Test 1x dzoom'
a022e7c4 48e201eb bl       #0xa02a70ec
a022e7c8 00c0a0e3 mov      ip, #0
a022e7cc 383400e3 movw     r3, #0x438
a022e7d0 0ce0a0e1 mov      lr, ip
a022e7d4 1e2da0e3 mov      r2, #0x780
a022e7d8 13e8dfe7 bfi      lr, r3, #0x10, #0x10
a022e7dc 5a1f8de2 add      r1, sp, #0x168
a022e7e0 4c008de2 add      r0, sp, #0x4c
a022e7e4 dcc18de5 str      ip, [sp, #0x1dc]
a022e7e8 e0c18de5 str      ip, [sp, #0x1e0]
a022e7ec e8e18de5 str      lr, [sp, #0x1e8]
a022e7f0 b4318de5 str      r3, [sp, #0x1b4]
a022e7f4 d0318de5 str      r3, [sp, #0x1d0]
a022e7f8 d8318de5 str      r3, [sp, #0x1d8]
a022e7fc f0318de5 str      r3, [sp, #0x1f0]
a022e800 b0218de5 str      r2, [sp, #0x1b0]
a022e804 cc218de5 str      r2, [sp, #0x1cc]
a022e808 d4218de5 str      r2, [sp, #0x1d4]
a022e80c ec218de5 str      r2, [sp, #0x1ec]
a022e810 e4418de5 str      r4, [sp, #0x1e4]
a022e814 638c03eb bl       #0xa03119a8
a022e818 4c008de2 add      r0, sp, #0x4c
a022e81c 0f8f03eb bl       #0xa0312460
a022e820 41fdffea b        #0xa022dd2c
a022e824 0050a0e3 mov      r5, #0
a022e828 98608de2 add      r6, sp, #0x98
a022e82c 0510a0e1 mov      r1, r5
a022e830 2820a0e3 mov      r2, #0x28
a022e834 0600a0e1 mov      r0, r6
a022e838 44508de5 str      r5, [sp, #0x44]
a022e83c 48508de5 str      r5, [sp, #0x48]
a022e840 69290bfa blx      #0xa04f8dec
a022e844 18030de3 movw     r0, #0xd318
a022e848 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d318 'Extra effect rotate'
a022e84c 26e201eb bl       #0xa02a70ec
a022e850 0510a0e1 mov      r1, r5
a022e854 0c20a0e3 mov      r2, #0xc
a022e858 58008de2 add      r0, sp, #0x58
a022e85c 62290bfa blx      #0xa04f8dec
a022e860 b4e19de5 ldr      lr, [sp, #0x1b4]
a022e864 b8c1dde5 ldrb     ip, [sp, #0x1b8]
a022e868 b911dde5 ldrb     r1, [sp, #0x1b9]
a022e86c ba21dde5 ldrb     r2, [sp, #0x1ba]
a022e870 bb31dde5 ldrb     r3, [sp, #0x1bb]
a022e874 a8819de5 ldr      r8, [sp, #0x1a8]
a022e878 ac719de5 ldr      r7, [sp, #0x1ac]
a022e87c b0519de5 ldr      r5, [sp, #0x1b0]
a022e880 0c0094e5 ldr      r0, [r4, #0xc]
a022e884 90e08de5 str      lr, [sp, #0x90]
a022e888 94c0cde5 strb     ip, [sp, #0x94]
a022e88c 9510cde5 strb     r1, [sp, #0x95]
a022e890 9620cde5 strb     r2, [sp, #0x96]
a022e894 9730cde5 strb     r3, [sp, #0x97]
a022e898 84808de5 str      r8, [sp, #0x84]
a022e89c 88708de5 str      r7, [sp, #0x88]
a022e8a0 8c508de5 str      r5, [sp, #0x8c]
a022e8a4 1e5da0e3 mov      r5, #0x780
a022e8a8 7c250bfa blx      #0xa04f7ea0
a022e8ac 64008de5 str      r0, [sp, #0x64]
a022e8b0 100094e5 ldr      r0, [r4, #0x10]
a022e8b4 79250bfa blx      #0xa04f7ea0
a022e8b8 68008de5 str      r0, [sp, #0x68]
a022e8bc 140094e5 ldr      r0, [r4, #0x14]
a022e8c0 76250bfa blx      #0xa04f7ea0
a022e8c4 6c008de5 str      r0, [sp, #0x6c]
a022e8c8 180094e5 ldr      r0, [r4, #0x18]
a022e8cc 73250bfa blx      #0xa04f7ea0
a022e8d0 70008de5 str      r0, [sp, #0x70]
a022e8d4 1c0094e5 ldr      r0, [r4, #0x1c]
a022e8d8 70250bfa blx      #0xa04f7ea0
a022e8dc 7c008de5 str      r0, [sp, #0x7c]
a022e8e0 200094e5 ldr      r0, [r4, #0x20]
a022e8e4 6d250bfa blx      #0xa04f7ea0
a022e8e8 80008de5 str      r0, [sp, #0x80]
a022e8ec 240094e5 ldr      r0, [r4, #0x24]
a022e8f0 6a250bfa blx      #0xa04f7ea0
a022e8f4 74008de5 str      r0, [sp, #0x74]
a022e8f8 280094e5 ldr      r0, [r4, #0x28]
a022e8fc 67250bfa blx      #0xa04f7ea0
a022e900 b0e19de5 ldr      lr, [sp, #0x1b0]
a022e904 013100e3 movw     r3, #0x101
a022e908 b4c19de5 ldr      ip, [sp, #0x1b4]
a022e90c 133042e3 movt     r3, #0x2013
a022e910 a8819de5 ldr      r8, [sp, #0x1a8]
a022e914 3f108ee2 add      r1, lr, #0x3f
a022e918 ac719de5 ldr      r7, [sp, #0x1ac]
a022e91c 3f208ce2 add      r2, ip, #0x3f
a022e920 4113a0e1 asr      r1, r1, #6
a022e924 4223a0e1 asr      r2, r2, #6
a022e928 b891dde5 ldrb     sb, [sp, #0x1b8]
a022e92c 011081e2 add      r1, r1, #1
a022e930 78008de5 str      r0, [sp, #0x78]
a022e934 012082e2 add      r2, r2, #1
a022e938 b9a1dde5 ldrb     sl, [sp, #0x1b9]
a022e93c 92010be0 mul      fp, r2, r1
a022e940 ba01dde5 ldrb     r0, [sp, #0x1ba]
a022e944 8ce18de5 str      lr, [sp, #0x18c]
a022e948 38e400e3 movw     lr, #0x438
a022e94c 90c18de5 str      ip, [sp, #0x190]
a022e950 01c0a0e3 mov      ip, #1
a022e954 70318de5 str      r3, [sp, #0x170]
a022e958 0630a0e3 mov      r3, #6
a022e95c 010a5be3 cmp      fp, #0x1000
a022e960 bbb1dde5 ldrb     fp, [sp, #0x1bb]
a022e964 74118de5 str      r1, [sp, #0x174]
a022e968 78218de5 str      r2, [sp, #0x178]
a022e96c 84818de5 str      r8, [sp, #0x184]
a022e970 88718de5 str      r7, [sp, #0x188]
a022e974 9491cde5 strb     sb, [sp, #0x194]
a022e978 95a1cde5 strb     sl, [sp, #0x195]
a022e97c 9601cde5 strb     r0, [sp, #0x196]
a022e980 97b1cde5 strb     fp, [sp, #0x197]
a022e984 98508de5 str      r5, [sp, #0x98]
a022e988 9ce08de5 str      lr, [sp, #0x9c]
a022e98c 40c08de5 str      ip, [sp, #0x40]
a022e990 68c18de5 str      ip, [sp, #0x168]
a022e994 7c318de5 str      r3, [sp, #0x17c]
a022e998 80318de5 str      r3, [sp, #0x180]
a022e99c 030000da ble      #0xa022e9b0
a022e9a0 5c000ae3 movw     r0, #0xa05c
a022e9a4 013aa0e3 mov      r3, #0x1000
a022e9a8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a05c 'Error; Calc grid number %d * %d > max available number %d'
a022e9ac cee101eb bl       #0xa02a70ec
a022e9b0 17ee8de2 add      lr, sp, #0x170
a022e9b4 c0c08de2 add      ip, sp, #0xc0
a022e9b8 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022e9bc d47208e3 movw     r7, #0x82d4
a022e9c0 42714ae3 movt     r7, #0xa142
a022e9c4 9851dde5 ldrb     r5, [sp, #0x198]
a022e9c8 a4718de5 str      r7, [sp, #0x1a4]
a022e9cc 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022e9d0 015085e3 orr      r5, r5, #1
a022e9d4 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022e9d8 9851cde5 strb     r5, [sp, #0x198]
a022e9dc 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022e9e0 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a022e9e4 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a022e9e8 03009ee8 ldm      lr, {r0, r1}
a022e9ec 03008ce8 stm      ip, {r0, r1}
a022e9f0 46aa02eb bl       #0xa02d9310
a022e9f4 84108de2 add      r1, sp, #0x84
a022e9f8 4c008de2 add      r0, sp, #0x4c
a022e9fc ccaa02eb bl       #0xa02d9534
a022ea00 44108de2 add      r1, sp, #0x44
a022ea04 4c008de2 add      r0, sp, #0x4c
a022ea08 00ab02eb bl       #0xa02d9610
a022ea0c 74108de2 add      r1, sp, #0x74
a022ea10 4c008de2 add      r0, sp, #0x4c
a022ea14 d8ab02eb bl       #0xa02d997c
a022ea18 40108de2 add      r1, sp, #0x40
a022ea1c 4c008de2 add      r0, sp, #0x4c
a022ea20 f4ab02eb bl       #0xa02d99f8
a022ea24 64108de2 add      r1, sp, #0x64
a022ea28 4c008de2 add      r0, sp, #0x4c
a022ea2c b3ab02eb bl       #0xa02d9900
a022ea30 0610a0e1 mov      r1, r6
a022ea34 4c008de2 add      r0, sp, #0x4c
a022ea38 6fab02eb bl       #0xa02d97fc
a022ea3c 4c008de2 add      r0, sp, #0x4c
a022ea40 0510a0e3 mov      r1, #5
a022ea44 28ac02eb bl       #0xa02d9aec
a022ea48 c0108de2 add      r1, sp, #0xc0
a022ea4c 4c008de2 add      r0, sp, #0x4c
a022ea50 0dab02eb bl       #0xa02d968c
a022ea54 2c0094e5 ldr      r0, [r4, #0x2c]
a022ea58 10250bfa blx      #0xa04f7ea0
a022ea5c 900a07ee vmov     s15, r0
a022ea60 4c008de2 add      r0, sp, #0x4c
a022ea64 e11bdfed vldr     d17, [pc, #0x384]
a022ea68 e70bf8ee vcvt.f64.s32 d16, s15
a022ea6c e10b9fed vldr     d0, [pc, #0x384]
a022ea70 a10b60ee vmul.f64 d16, d16, d17
a022ea74 800b80ee vdiv.f64 d0, d16, d0
a022ea78 42ac02eb bl       #0xa02d9b88
a022ea7c 4c008de2 add      r0, sp, #0x4c
a022ea80 0010a0e3 mov      r1, #0
a022ea84 b6ad02eb bl       #0xa02da164
a022ea88 4c008de2 add      r0, sp, #0x4c
a022ea8c a0ae02eb bl       #0xa02da514
a022ea90 a5fcffea b        #0xa022dd2c
a022ea94 f4020de3 movw     r0, #0xd2f4
a022ea98 d4b208e3 movw     fp, #0x82d4
a022ea9c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d2f4 'Test only 2x dzoom with warp effect'
a022eaa0 0040a0e3 mov      r4, #0
a022eaa4 90e101eb bl       #0xa02a70ec
a022eaa8 bbc1dde5 ldrb     ip, [sp, #0x1bb]
a022eaac 012100e3 movw     r2, #0x101
a022eab0 a8919de5 ldr      sb, [sp, #0x1a8]
a022eab4 132042e3 movt     r2, #0x2013
a022eab8 ac819de5 ldr      r8, [sp, #0x1ac]
a022eabc 1e1da0e3 mov      r1, #0x780
a022eac0 b871dde5 ldrb     r7, [sp, #0x1b8]
a022eac4 383400e3 movw     r3, #0x438
a022eac8 b961dde5 ldrb     r6, [sp, #0x1b9]
a022eacc 0feda0e3 mov      lr, #0x3c0
a022ead0 ba51dde5 ldrb     r5, [sp, #0x1ba]
a022ead4 0b00a0e1 mov      r0, fp
a022ead8 70218de5 str      r2, [sp, #0x170]
a022eadc 872fa0e3 mov      r2, #0x21c
a022eae0 97c1cde5 strb     ip, [sp, #0x197]
a022eae4 c0ce0fe3 movw     ip, #0xfec0
a022eae8 ffcf4fe3 movt     ip, #0xffff
a022eaec 42014ae3 movt     r0, #0xa142
a022eaf0 84918de5 str      sb, [sp, #0x184]
a022eaf4 1eaea0e3 mov      sl, #0x1e0
a022eaf8 88818de5 str      r8, [sp, #0x188]
a022eafc 0e9100e3 movw     sb, #0x10e
a022eb00 9471cde5 strb     r7, [sp, #0x194]
a022eb04 0f85a0e3 mov      r8, #0x3c00000
a022eb08 9561cde5 strb     r6, [sp, #0x195]
a022eb0c 8777a0e3 mov      r7, #0x21c0000
a022eb10 9651cde5 strb     r5, [sp, #0x196]
a022eb14 0160a0e3 mov      r6, #1
a022eb18 b0118de5 str      r1, [sp, #0x1b0]
a022eb1c 1f50a0e3 mov      r5, #0x1f
a022eb20 ec118de5 str      r1, [sp, #0x1ec]
a022eb24 00b0a0e1 mov      fp, r0
a022eb28 8c118de5 str      r1, [sp, #0x18c]
a022eb2c 0410a0e1 mov      r1, r4
a022eb30 b4318de5 str      r3, [sp, #0x1b4]
a022eb34 f0318de5 str      r3, [sp, #0x1f0]
a022eb38 90318de5 str      r3, [sp, #0x190]
a022eb3c 0630a0e3 mov      r3, #6
a022eb40 cce18de5 str      lr, [sp, #0x1cc]
a022eb44 d4e18de5 str      lr, [sp, #0x1d4]
a022eb48 12e0a0e3 mov      lr, #0x12
a022eb4c d0218de5 str      r2, [sp, #0x1d0]
a022eb50 d8218de5 str      r2, [sp, #0x1d8]
a022eb54 0129a0e3 mov      r2, #0x4000
a022eb58 14c08de5 str      ip, [sp, #0x14]
a022eb5c 7c318de5 str      r3, [sp, #0x17c]
a022eb60 c8918de5 str      sb, [sp, #0x1c8]
a022eb64 0490a0e1 mov      sb, r4
a022eb68 e4818de5 str      r8, [sp, #0x1e4]
a022eb6c 0080a0e1 mov      r8, r0
a022eb70 e8718de5 str      r7, [sp, #0x1e8]
a022eb74 0470a0e1 mov      r7, r4
a022eb78 dc418de5 str      r4, [sp, #0x1dc]
a022eb7c e0418de5 str      r4, [sp, #0x1e0]
a022eb80 c4a18de5 str      sl, [sp, #0x1c4]
a022eb84 68618de5 str      r6, [sp, #0x168]
a022eb88 10408de5 str      r4, [sp, #0x10]
a022eb8c 80318de5 str      r3, [sp, #0x180]
a022eb90 78e18de5 str      lr, [sp, #0x178]
a022eb94 74518de5 str      r5, [sp, #0x174]
a022eb98 93280bfa blx      #0xa04f8dec
a022eb9c 98000ae3 movw     r0, #0xa098
a022eba0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a098 'Test hor & ver warp table'
a022eba4 50e101eb bl       #0xa02a70ec
a022eba8 10309de5 ldr      r3, [sp, #0x10]
a022ebac 14c09de5 ldr      ip, [sp, #0x14]
a022ebb0 0050a0e3 mov      r5, #0
a022ebb4 0360a0e1 mov      r6, r3
a022ebb8 0540a0e1 mov      r4, r5
a022ebbc 05ada0e3 mov      sl, #0x140
a022ebc0 0e0054e3 cmp      r4, #0xe
a022ebc4 0621a0e1 lsl      r2, r6, #2
a022ebc8 b5c088d1 strhle   ip, [r8, r5]
a022ebcc 016086e2 add      r6, r6, #1
a022ebd0 b5a088c1 strhgt   sl, [r8, r5]
a022ebd4 000057e3 cmp      r7, #0
a022ebd8 02108be0 add      r1, fp, r2
a022ebdc 045085e2 add      r5, r5, #4
a022ebe0 b290c1e1 strh     sb, [r1, #2]
a022ebe4 6f00000a beq      #0xa022eda8
a022ebe8 014084e2 add      r4, r4, #1
a022ebec 1f0054e3 cmp      r4, #0x1f
a022ebf0 f2ffff1a bne      #0xa022ebc0
a022ebf4 017087e2 add      r7, r7, #1
a022ebf8 7c8088e2 add      r8, r8, #0x7c
a022ebfc 120057e3 cmp      r7, #0x12
a022ec00 1f3083e2 add      r3, r3, #0x1f
a022ec04 e9ffff1a bne      #0xa022ebb0
a022ec08 5a1f8de2 add      r1, sp, #0x168
a022ec0c 4c008de2 add      r0, sp, #0x4c
a022ec10 a4b18de5 str      fp, [sp, #0x1a4]
a022ec14 638b03eb bl       #0xa03119a8
a022ec18 4c008de2 add      r0, sp, #0x4c
a022ec1c 0f8e03eb bl       #0xa0312460
a022ec20 41fcffea b        #0xa022dd2c
a022ec24 f4020de3 movw     r0, #0xd2f4
a022ec28 0040a0e3 mov      r4, #0
a022ec2c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d2f4 'Test only 2x dzoom with warp effect'
a022ec30 01a100e3 movw     sl, #0x101
a022ec34 2ce101eb bl       #0xa02a70ec
a022ec38 a8819de5 ldr      r8, [sp, #0x1a8]
a022ec3c 0ec100e3 movw     ip, #0x10e
a022ec40 ac719de5 ldr      r7, [sp, #0x1ac]
a022ec44 0430a0e1 mov      r3, r4
a022ec48 b9e1dde5 ldrb     lr, [sp, #0x1b9]
a022ec4c 1e2da0e3 mov      r2, #0x780
a022ec50 ba11dde5 ldrb     r1, [sp, #0x1ba]
a022ec54 1c38dfe7 bfi      r3, ip, #0x10, #0x10
a022ec58 bb61dde5 ldrb     r6, [sp, #0x1bb]
a022ec5c 13a042e3 movt     sl, #0x2013
a022ec60 b8b1dde5 ldrb     fp, [sp, #0x1b8]
a022ec64 d40208e3 movw     r0, #0x82d4
a022ec68 7c518de5 str      r5, [sp, #0x17c]
a022ec6c 42014ae3 movt     r0, #0xa142
a022ec70 80518de5 str      r5, [sp, #0x180]
a022ec74 0150a0e3 mov      r5, #1
a022ec78 dc418de5 str      r4, [sp, #0x1dc]
a022ec7c c09e0fe3 movw     sb, #0xfec0
a022ec80 e0418de5 str      r4, [sp, #0x1e0]
a022ec84 ff9f4fe3 movt     sb, #0xffff
a022ec88 e8318de5 str      r3, [sp, #0x1e8]
a022ec8c 383400e3 movw     r3, #0x438
a022ec90 d0c18de5 str      ip, [sp, #0x1d0]
a022ec94 d8c18de5 str      ip, [sp, #0x1d8]
a022ec98 1ecea0e3 mov      ip, #0x1e0
a022ec9c 70a18de5 str      sl, [sp, #0x170]
a022eca0 2daea0e3 mov      sl, #0x2d0
a022eca4 84818de5 str      r8, [sp, #0x184]
a022eca8 968100e3 movw     r8, #0x196
a022ecac 88718de5 str      r7, [sp, #0x188]
a022ecb0 1e76a0e3 mov      r7, #0x1e00000
a022ecb4 95e1cde5 strb     lr, [sp, #0x195]
a022ecb8 1fe0a0e3 mov      lr, #0x1f
a022ecbc 9611cde5 strb     r1, [sp, #0x196]
a022ecc0 0410a0e1 mov      r1, r4
a022ecc4 9761cde5 strb     r6, [sp, #0x197]
a022ecc8 0460a0e1 mov      r6, r4
a022eccc b0218de5 str      r2, [sp, #0x1b0]
a022ecd0 1240a0e3 mov      r4, #0x12
a022ecd4 ec218de5 str      r2, [sp, #0x1ec]
a022ecd8 8c218de5 str      r2, [sp, #0x18c]
a022ecdc 0129a0e3 mov      r2, #0x4000
a022ece0 b4318de5 str      r3, [sp, #0x1b4]
a022ece4 f0318de5 str      r3, [sp, #0x1f0]
a022ece8 90318de5 str      r3, [sp, #0x190]
a022ecec ccc18de5 str      ip, [sp, #0x1cc]
a022ecf0 d4c18de5 str      ip, [sp, #0x1d4]
a022ecf4 e4718de5 str      r7, [sp, #0x1e4]
a022ecf8 74e18de5 str      lr, [sp, #0x174]
a022ecfc 94b1cde5 strb     fp, [sp, #0x194]
a022ed00 c4a18de5 str      sl, [sp, #0x1c4]
a022ed04 c8818de5 str      r8, [sp, #0x1c8]
a022ed08 68518de5 str      r5, [sp, #0x168]
a022ed0c 78418de5 str      r4, [sp, #0x178]
a022ed10 35280bfa blx      #0xa04f8dec
a022ed14 98000ae3 movw     r0, #0xa098
a022ed18 e0709fe5 ldr      r7, [pc, #0xe0]
a022ed1c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a098 'Test hor & ver warp table'
a022ed20 f1e001eb bl       #0xa02a70ec
a022ed24 0050a0e3 mov      r5, #0
a022ed28 7c4047e2 sub      r4, r7, #0x7c
a022ed2c 0580a0e1 mov      r8, r5
a022ed30 080056e3 cmp      r6, #8
a022ed34 053da0e3 mov      r3, #0x140
a022ed38 b080c4e1 strh     r8, [r4]
a022ed3c b230c4c1 strhgt   r3, [r4, #2]
a022ed40 020000ca bgt      #0xa022ed50
a022ed44 000056e3 cmp      r6, #0
a022ed48 b290c4e1 strh     sb, [r4, #2]
a022ed4c 0f00000a beq      #0xa022ed90
a022ed50 044084e2 add      r4, r4, #4
a022ed54 015085e2 add      r5, r5, #1
a022ed58 070054e1 cmp      r4, r7
a022ed5c f3ffff1a bne      #0xa022ed30
a022ed60 016086e2 add      r6, r6, #1
a022ed64 7c7084e2 add      r7, r4, #0x7c
a022ed68 120056e3 cmp      r6, #0x12
a022ed6c ecffff1a bne      #0xa022ed24
a022ed70 d4b208e3 movw     fp, #0x82d4
a022ed74 42b14ae3 movt     fp, #0xa142
a022ed78 a2ffffea b        #0xa022ec08
a022ed7c 9c020de3 movw     r0, #0xd29c
a022ed80 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059d29c 'file open error'
a022ed84 d8e001eb bl       #0xa02a70ec
a022ed88 ff00a0e3 mov      r0, #0xff
a022ed8c cbfaffea b        #0xa022d8c0
a022ed90 b4000ae3 movw     r0, #0xa0b4
a022ed94 0510a0e1 mov      r1, r5
a022ed98 0620a0e1 mov      r2, r6
a022ed9c 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a0b4 '%d       %d'
a022eda0 d1e001eb bl       #0xa02a70ec
a022eda4 e9ffffea b        #0xa022ed50
a022eda8 b4000ae3 movw     r0, #0xa0b4
a022edac f2209be1 ldrsh    r2, [fp, r2]
a022edb0 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a0b4 '%d       %d'
a022edb4 0410a0e1 mov      r1, r4
a022edb8 14c08de5 str      ip, [sp, #0x14]
a022edbc 10308de5 str      r3, [sp, #0x10]
a022edc0 c9e001eb bl       #0xa02a70ec
a022edc4 14c09de5 ldr      ip, [sp, #0x14]
a022edc8 10309de5 ldr      r3, [sp, #0x10]
a022edcc 85ffffea b        #0xa022ebe8
a022edd0 b4000ae3 movw     r0, #0xa0b4
a022edd4 0510a0e1 mov      r1, r5
a022edd8 59004ae3 movt     r0, #0xa059 ; heuristic 0xa059a0b4 '%d       %d'
a022eddc 1c308de5 str      r3, [sp, #0x1c]
a022ede0 c1e001eb bl       #0xa02a70ec
a022ede4 1c309de5 ldr      r3, [sp, #0x1c]
a022ede8 c8fdffea b        #0xa022e510
a022edec 00f020e3 nop      
a022edf0 182d4454 strbpl   r2, [r4], #-0xd18
a022edf4 fb210940 strdmi   r2, r3, [sb], -fp
a022edf8 00000000 andeq    r0, r0, r0
a022edfc 00806640 rsbmi    r8, r6, r0
