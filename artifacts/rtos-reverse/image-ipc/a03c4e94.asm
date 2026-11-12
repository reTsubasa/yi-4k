; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a03c4e94 f0412de9 push     {r4, r5, r6, r7, r8, lr}
a03c4e98 b05205e3 movw     r5, #0x52b0
a03c4e9c 44514ae3 movt     r5, #0xa144
a03c4ea0 0080a0e1 mov      r8, r0
a03c4ea4 0170a0e1 mov      r7, r1
a03c4ea8 0260a0e1 mov      r6, r2
a03c4eac 340095e5 ldr      r0, [r5, #0x34]
a03c4eb0 110e80e2 add      r0, r0, #0x110
a03c4eb4 072100eb bl       #0xa03cd2d8
a03c4eb8 004050e2 subs     r4, r0, #0
a03c4ebc 1500000a beq      #0xa03c4f18
a03c4ec0 342095e5 ldr      r2, [r5, #0x34]
a03c4ec4 0010a0e3 mov      r1, #0
a03c4ec8 112e82e2 add      r2, r2, #0x110
a03c4ecc c6cf04fa blx      #0xa04f8dec
a03c4ed0 842904e3 movw     r2, #0x4984
a03c4ed4 0410a0e1 mov      r1, r4
a03c4ed8 3c204ae3 movt     r2, #0xa03c
a03c4edc 0400a0e1 mov      r0, r4
a03c4ee0 2e0e00eb bl       #0xa03c87a0
a03c4ee4 642094e5 ldr      r2, [r4, #0x64]
a03c4ee8 0130a0e3 mov      r3, #1
a03c4eec b07084e5 str      r7, [r4, #0xb0]
a03c4ef0 0400a0e1 mov      r0, r4
a03c4ef4 b46084e5 str      r6, [r4, #0xb4]
a03c4ef8 7180c4e5 strb     r8, [r4, #0x71]
a03c4efc 782084e5 str      r2, [r4, #0x78]
a03c4f00 7030c4e5 strb     r3, [r4, #0x70]
a03c4f04 e4feffeb bl       #0xa03c4a9c
a03c4f08 000050e3 cmp      r0, #0
a03c4f0c 0300001a bne      #0xa03c4f20
a03c4f10 0400a0e1 mov      r0, r4
a03c4f14 49ffffeb bl       #0xa03c4c40
a03c4f18 0400a0e1 mov      r0, r4
a03c4f1c f081bde8 pop      {r4, r5, r6, r7, r8, pc}
a03c4f20 600c0ce3 movw     r0, #0xcc60
a03c4f24 0810a0e1 mov      r1, r8
a03c4f28 0720a0e1 mov      r2, r7
a03c4f2c 0630a0e1 mov      r3, r6
a03c4f30 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060cc60 'binding failure warning: host = %d, prog = %d, vers = %d ! Client needs to bind again next time!\n'
a03c4f34 6c88fbeb bl       #0xa02a70ec
a03c4f38 0400a0e1 mov      r0, r4
a03c4f3c f081bde8 pop      {r4, r5, r6, r7, r8, pc}
a03c4f40 a4cc0ae3 movw     ip, #0xaca4
a03c4f44 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c4f48 62c04ae3 movt     ip, #0xa062
a03c4f4c 0040a0e1 mov      r4, r0
a03c4f50 085080e2 add      r5, r0, #8
a03c4f54 1cd04de2 sub      sp, sp, #0x1c
a03c4f58 10009ce5 ldr      r0, [ip, #0x10]
a03c4f5c 0170a0e1 mov      r7, r1
a03c4f60 0010e0e3 mvn      r1, #0
a03c4f64 0360a0e1 mov      r6, r3
a03c4f68 02b0a0e1 mov      fp, r2
a03c4f6c 00c0a0e1 mov      ip, r0
a03c4f70 0c008de5 str      r0, [sp, #0xc]
a03c4f74 0500a0e1 mov      r0, r5
a03c4f78 00a09ce5 ldr      sl, [ip]
a03c4f7c 3addffeb bl       #0xa03bc46c
a03c4f80 803094e5 ldr      r3, [r4, #0x80]
a03c4f84 000053e3 cmp      r3, #0
a03c4f88 1100001a bne      #0xa03c4fd4
a03c4f8c 0400a0e1 mov      r0, r4
a03c4f90 c1feffeb bl       #0xa03c4a9c
a03c4f94 008050e2 subs     r8, r0, #0
a03c4f98 0b00000a beq      #0xa03c4fcc
a03c4f9c 040058e3 cmp      r8, #4
a03c4fa0 7800000a beq      #0xa03c5188
a03c4fa4 010058e3 cmp      r8, #1
a03c4fa8 7100000a beq      #0xa03c5174
a03c4fac 080d0ce3 movw     r0, #0xcd08
a03c4fb0 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060cd08 'Other binding problem.'
a03c4fb4 4c88fbeb bl       #0xa02a70ec
a03c4fb8 0500a0e1 mov      r0, r5
a03c4fbc 35ddffeb bl       #0xa03bc498
a03c4fc0 0800a0e1 mov      r0, r8
a03c4fc4 1cd08de2 add      sp, sp, #0x1c
a03c4fc8 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c4fcc 0400a0e1 mov      r0, r4
a03c4fd0 1affffeb bl       #0xa03c4c40
a03c4fd4 c48084e2 add      r8, r4, #0xc4
a03c4fd8 701084e2 add      r1, r4, #0x70
a03c4fdc 4c20a0e3 mov      r2, #0x4c
a03c4fe0 0800a0e1 mov      r0, r8
a03c4fe4 a55dfbeb bl       #0xa029c680
a03c4fe8 c03094e5 ldr      r3, [r4, #0xc0]
a03c4fec 079147e2 sub      sb, r7, #0xc0000001
a03c4ff0 0c7184e5 str      r7, [r4, #0x10c]
a03c4ff4 117e84e2 add      r7, r4, #0x110
a03c4ff8 0620a0e1 mov      r2, r6
a03c4ffc 0b10a0e1 mov      r1, fp
a03c5000 093193e7 ldr      r3, [r3, sb, lsl #2]
a03c5004 0700a0e1 mov      r0, r7
a03c5008 dc3084e5 str      r3, [r4, #0xdc]
a03c500c 9b5dfbeb bl       #0xa029c680
a03c5010 140d06e3 movw     r0, #0x6d14
a03c5014 0010e0e3 mvn      r1, #0
a03c5018 e0a084e5 str      sl, [r4, #0xe0]
a03c501c 79014ae3 movt     r0, #0xa179
a03c5020 11ddffeb bl       #0xa03bc46c
a03c5024 bc3d06e3 movw     r3, #0x6dbc
a03c5028 140d06e3 movw     r0, #0x6d14
a03c502c 79314ae3 movt     r3, #0xa179
a03c5030 79014ae3 movt     r0, #0xa179
a03c5034 002093e5 ldr      r2, [r3]
a03c5038 c82084e5 str      r2, [r4, #0xc8]
a03c503c 012082e2 add      r2, r2, #1
a03c5040 002083e5 str      r2, [r3]
a03c5044 13ddffeb bl       #0xa03bc498
a03c5048 0400a0e1 mov      r0, r4
a03c504c 0810a0e1 mov      r1, r8
a03c5050 0620a0e1 mov      r2, r6
a03c5054 270e00eb bl       #0xa03c88f8
a03c5058 48309de5 ldr      r3, [sp, #0x48]
a03c505c 000053e3 cmp      r3, #0
a03c5060 2500000a beq      #0xa03c50fc
a03c5064 c03094e5 ldr      r3, [r4, #0xc0]
a03c5068 093193e7 ldr      r3, [r3, sb, lsl #2]
a03c506c 010053e3 cmp      r3, #1
a03c5070 2100000a beq      #0xa03c50fc
a03c5074 48309de5 ldr      r3, [sp, #0x48]
a03c5078 3c0084e2 add      r0, r4, #0x3c
a03c507c 0110a0e3 mov      r1, #1
a03c5080 0320a0e3 mov      r2, #3
a03c5084 00308de5 str      r3, [sp]
a03c5088 14308de2 add      r3, sp, #0x14
a03c508c 06ddffeb bl       #0xa03bc4ac
a03c5090 070050e3 cmp      r0, #7
a03c5094 1d00000a beq      #0xa03c5110
a03c5098 0c309de5 ldr      r3, [sp, #0xc]
a03c509c 0800a0e1 mov      r0, r8
a03c50a0 046194e5 ldr      r6, [r4, #0x104]
a03c50a4 002093e5 ldr      r2, [r3]
a03c50a8 c03094e5 ldr      r3, [r4, #0xc0]
a03c50ac ec2084e5 str      r2, [r4, #0xec]
a03c50b0 091193e7 ldr      r1, [r3, sb, lsl #2]
a03c50b4 450e00eb bl       #0xa03c89d0
a03c50b8 000056e3 cmp      r6, #0
a03c50bc 0900001a bne      #0xa03c50e8
a03c50c0 40309de5 ldr      r3, [sp, #0x40]
a03c50c4 000053e3 cmp      r3, #0
a03c50c8 bc3094e5 ldr      r3, [r4, #0xbc]
a03c50cc 0500000a beq      #0xa03c50e8
a03c50d0 44209de5 ldr      r2, [sp, #0x44]
a03c50d4 0710a0e1 mov      r1, r7
a03c50d8 40009de5 ldr      r0, [sp, #0x40]
a03c50dc 030052e1 cmp      r2, r3
a03c50e0 0320a0a1 movge    r2, r3
a03c50e4 655dfbeb bl       #0xa029c680
a03c50e8 0500a0e1 mov      r0, r5
a03c50ec e9dcffeb bl       #0xa03bc498
a03c50f0 0600a0e1 mov      r0, r6
a03c50f4 1cd08de2 add      sp, sp, #0x1c
a03c50f8 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c50fc 0500a0e1 mov      r0, r5
a03c5100 e4dcffeb bl       #0xa03bc498
a03c5104 0000a0e3 mov      r0, #0
a03c5108 1cd08de2 add      sp, sp, #0x1c
a03c510c f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c5110 200d0ce3 movw     r0, #0xcd20
a03c5114 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060cd20 'recving: timeout!\n'
a03c5118 f387fbeb bl       #0xa02a70ec
a03c511c 0c00a0e3 mov      r0, #0xc
a03c5120 6c2000eb bl       #0xa03cd2d8
a03c5124 c8e094e5 ldr      lr, [r4, #0xc8]
a03c5128 0010a0e1 mov      r1, r0
a03c512c 003609e3 movw     r3, #0x9600
a03c5130 0120a0e1 mov      r2, r1
a03c5134 78304ae3 movt     r3, #0xa078
a03c5138 48cd06e3 movw     ip, #0x6d48
a03c513c 04e082e4 str      lr, [r2], #4
a03c5140 79c14ae3 movt     ip, #0xa179
a03c5144 00e093e5 ldr      lr, [r3]
a03c5148 0500a0e1 mov      r0, r5
a03c514c 0040a0e3 mov      r4, #0
a03c5150 002083e5 str      r2, [r3]
a03c5154 00408ce5 str      r4, [ip]
a03c5158 04208ee5 str      r2, [lr, #4]
a03c515c 04e081e5 str      lr, [r1, #4]
a03c5160 083081e5 str      r3, [r1, #8]
a03c5164 cbdcffeb bl       #0xa03bc498
a03c5168 0400a0e3 mov      r0, #4
a03c516c 1cd08de2 add      sp, sp, #0x1c
a03c5170 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03c5174 e40c0ce3 movw     r0, #0xcce4
a03c5178 b01094e5 ldr      r1, [r4, #0xb0]
a03c517c 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060cce4 'Can not find svc for program %d\n'
a03c5180 d987fbeb bl       #0xa02a70ec
a03c5184 8bffffea b        #0xa03c4fb8
a03c5188 c40c0ce3 movw     r0, #0xccc4
a03c518c 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060ccc4 'Binding svc program timeout!\n'
a03c5190 d587fbeb bl       #0xa02a70ec
a03c5194 87ffffea b        #0xa03c4fb8
a03c5198 4c3d06e3 movw     r3, #0x6d4c
a03c519c c82b04e3 movw     r2, #0x4bc8
a03c51a0 79314ae3 movt     r3, #0xa179
a03c51a4 70c0a0e3 mov      ip, #0x70
a03c51a8 0300a0e1 mov      r0, r3
a03c51ac 0310a0e1 mov      r1, r3
a03c51b0 3c204ae3 movt     r2, #0xa03c
a03c51b4 64c083e5 str      ip, [r3, #0x64]
a03c51b8 780d00ea b        #0xa03c87a0
a03c51bc 040091e5 ldr      r0, [r1, #4]
a03c51c0 003090e5 ldr      r3, [r0]
a03c51c4 010053e3 cmp      r3, #1
a03c51c8 0600000a beq      #0xa03c51e8
a03c51cc 0400003a blo      #0xa03c51e4
a03c51d0 020053e3 cmp      r3, #2
a03c51d4 0000001a bne      #0xa03c51dc
a03c51d8 100000ea b        #0xa03c5220
a03c51dc 0000e0e3 mvn      r0, #0
a03c51e0 1eff2fe1 bx       lr
a03c51e4 140000ea b        #0xa03c523c
a03c51e8 350000ea b        #0xa03c52c4
a03c51ec e83d06e3 movw     r3, #0x6de8
