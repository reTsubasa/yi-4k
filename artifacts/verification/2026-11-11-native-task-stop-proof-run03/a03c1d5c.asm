a03c1d5c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c1d60 00a0a0e1 mov sl, r0
a03c1d64 0cd04de2 sub sp, sp, #0xc
a03c1d68 0c7306e3 movw r7, #0x630c
a03c1d6c 79714ae3 movt r7, #0xa179
a03c1d70 8efdffeb bl #0xa03c13b0
a03c1d74 a8309ae5 ldr r3, [sl, #0xa8]
a03c1d78 0080a0e1 mov r8, r0
a03c1d7c 013083e2 add r3, r3, #1
a03c1d80 a8308ae5 str r3, [sl, #0xa8]
a03c1d84 d8fbffeb bl #0xa03c0cec
a03c1d88 003197e7 ldr r3, [r7, r0, lsl #2]
a03c1d8c 0050a0e1 mov r5, r0
a03c1d90 0a0053e1 cmp r3, sl
a03c1d94 1501000a beq #0xa03c21f0
a03c1d98 08309ae5 ldr r3, [sl, #8]
a03c1d9c c4209ae5 ldr r2, [sl, #0xc4]
a03c1da0 020053e1 cmp r3, r2
a03c1da4 0c209ae5 ldr r2, [sl, #0xc]
a03c1da8 c4308a35 strlo r3, [sl, #0xc4]
a03c1dac ef3f0ee3 movw r3, #0xefef
a03c1db0 ef3f4ee3 movt r3, #0xefef
a03c1db4 001092e5 ldr r1, [r2]
a03c1db8 030051e1 cmp r1, r3
a03c1dbc 8300000a beq #0xa03c1fd0
a03c1dc0 0a00a0e1 mov r0, sl
a03c1dc4 15feffeb bl #0xa03c1620
a03c1dc8 c4309ae5 ldr r3, [sl, #0xc4]
a03c1dcc 042013e5 ldr r2, [r3, #-4]
a03c1dd0 ef3f0ee3 movw r3, #0xefef
a03c1dd4 ef3f4ee3 movt r3, #0xefef
a03c1dd8 030052e1 cmp r2, r3
a03c1ddc 0100000a beq #0xa03c1de8
a03c1de0 0a00a0e1 mov r0, sl
a03c1de4 aefdffeb bl #0xa03c14a4
a03c1de8 806706e3 movw r6, #0x6780
a03c1dec 38209ae5 ldr r2, [sl, #0x38]
a03c1df0 79614ae3 movt r6, #0xa179
a03c1df4 003096e5 ldr r3, [r6]
a03c1df8 000052e3 cmp r2, #0
a03c1dfc 14430603 movweq r4, #0x6314
a03c1e00 013043e2 sub r3, r3, #1
a03c1e04 79414a03 movteq r4, #0xa179
a03c1e08 003086e5 str r3, [r6]
a03c1e0c 3900000a beq #0xa03c1ef8
a03c1e10 2c309ae5 ldr r3, [sl, #0x2c]
a03c1e14 0010a0e3 mov r1, #0
a03c1e18 3c209ae5 ldr r2, [sl, #0x3c]
a03c1e1c 38108ae5 str r1, [sl, #0x38]
a03c1e20 020053e1 cmp r3, r2
a03c1e24 442306e3 movw r2, #0x6344
a03c1e28 a302a0e1 lsr r0, r3, #5
a03c1e2c 79214ae3 movt r2, #0xa179
a03c1e30 0200009a bls #0xa03c1e40
a03c1e34 031192e7 ldr r1, [r2, r3, lsl #2]
a03c1e38 0a0051e1 cmp r1, sl
a03c1e3c 2101000a beq #0xa03c22c8
a03c1e40 f8c206e3 movw ip, #0x62f8
a03c1e44 79c14ae3 movt ip, #0xa179
a03c1e48 00109ce5 ldr r1, [ip]
a03c1e4c 01005ae1 cmp sl, r1
a03c1e50 a500000a beq #0xa03c20ec
a03c1e54 00e0a0e1 mov lr, r0
a03c1e58 20109ae5 ldr r1, [sl, #0x20]
a03c1e5c 0a0051e1 cmp r1, sl
a03c1e60 6400000a beq #0xa03c1ff8
a03c1e64 24009ae5 ldr r0, [sl, #0x24]
a03c1e68 444306e3 movw r4, #0x6344
a03c1e6c 79414ae3 movt r4, #0xa179
a03c1e70 240081e5 str r0, [r1, #0x24]
a03c1e74 24109ae5 ldr r1, [sl, #0x24]
a03c1e78 20009ae5 ldr r0, [sl, #0x20]
a03c1e7c 200081e5 str r0, [r1, #0x20]
a03c1e80 031192e7 ldr r1, [r2, r3, lsl #2]
a03c1e84 0a0051e1 cmp r1, sl
a03c1e88 ff00000a beq #0xa03c228c
a03c1e8c 003306e3 movw r3, #0x6300
a03c1e90 441706e3 movw r1, #0x6744
a03c1e94 79314ae3 movt r3, #0xa179
a03c1e98 79114ae3 movt r1, #0xa179
a03c1e9c 000093e5 ldr r0, [r3]
a03c1ea0 000050e3 cmp r0, #0
a03c1ea4 0200000a beq #0xa03c1eb4
a03c1ea8 010010e3 tst r0, #1
a03c1eac 00e0a013 movne lr, #0
a03c1eb0 6e00000a beq #0xa03c2070
a03c1eb4 0e3191e7 ldr r3, [r1, lr, lsl #2]
a03c1eb8 000053e3 cmp r3, #0
a03c1ebc 5d00001a bne #0xa03c2038
a03c1ec0 94b09ae5 ldr fp, [sl, #0x94]
a03c1ec4 144306e3 movw r4, #0x6314
a03c1ec8 79414ae3 movt r4, #0xa179
a03c1ecc e89206e3 movw sb, #0x62e8
a03c1ed0 0b2194e7 ldr r2, [r4, fp, lsl #2]
a03c1ed4 0a0052e1 cmp r2, sl
a03c1ed8 0801000a beq #0xa03c2300
a03c1edc 79914ae3 movt sb, #0xa179
a03c1ee0 051199e7 ldr r1, [sb, r5, lsl #2]
a03c1ee4 803706e3 movw r3, #0x6780
a03c1ee8 002096e5 ldr r2, [r6]
a03c1eec 79314ae3 movt r3, #0xa179
a03c1ef0 022091e1 orrs r2, r1, r2
a03c1ef4 7400000a beq #0xa03c20cc
a03c1ef8 051197e7 ldr r1, [r7, r5, lsl #2]
a03c1efc 143306e3 movw r3, #0x6314
a03c1f00 052194e7 ldr r2, [r4, r5, lsl #2]
a03c1f04 79314ae3 movt r3, #0xa179
a03c1f08 020051e1 cmp r1, r2
a03c1f0c 2100000a beq #0xa03c1f98
a03c1f10 003093e5 ldr r3, [r3]
a03c1f14 000053e3 cmp r3, #0
a03c1f18 0100000a beq #0xa03c1f24
a03c1f1c 0000a0e3 mov r0, #0
a03c1f20 74fbffeb bl #0xa03c0cf8
a03c1f24 043094e5 ldr r3, [r4, #4]
a03c1f28 000053e3 cmp r3, #0
a03c1f2c 0100000a beq #0xa03c1f38
a03c1f30 0100a0e3 mov r0, #1
a03c1f34 6ffbffeb bl #0xa03c0cf8
a03c1f38 050194e7 ldr r0, [r4, r5, lsl #2]
a03c1f3c 000050e3 cmp r0, #0
a03c1f40 0a00000a beq #0xa03c1f70
a03c1f44 083090e5 ldr r3, [r0, #8]
a03c1f48 c42090e5 ldr r2, [r0, #0xc4]
a03c1f4c 020053e1 cmp r3, r2
a03c1f50 0c2090e5 ldr r2, [r0, #0xc]
a03c1f54 c4308035 strlo r3, [r0, #0xc4]
a03c1f58 ef3f0ee3 movw r3, #0xefef
a03c1f5c ef3f4ee3 movt r3, #0xefef
a03c1f60 001092e5 ldr r1, [r2]
a03c1f64 030051e1 cmp r1, r3
a03c1f68 0e00000a beq #0xa03c1fa8
a03c1f6c abfdffeb bl #0xa03c1620
a03c1f70 e83206e3 movw r3, #0x62e8
a03c1f74 79314ae3 movt r3, #0xa179
a03c1f78 053193e7 ldr r3, [r3, r5, lsl #2]
a03c1f7c 000053e3 cmp r3, #0
a03c1f80 0400001a bne #0xa03c1f98
a03c1f84 002096e5 ldr r2, [r6]
a03c1f88 803706e3 movw r3, #0x6780
a03c1f8c 79314ae3 movt r3, #0xa179
a03c1f90 000052e3 cmp r2, #0
a03c1f94 4c00000a beq #0xa03c20cc
a03c1f98 0800a0e1 mov r0, r8
a03c1f9c 0cd08de2 add sp, sp, #0xc
a03c1fa0 f04fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c1fa4 1ffdffea b #0xa03c1428
a03c1fa8 101090e5 ldr r1, [r0, #0x10]
a03c1fac ef3f0ee3 movw r3, #0xefef
a03c1fb0 ef3f4ee3 movt r3, #0xefef
a03c1fb4 011091e5 ldr r1, [r1, #1]
a03c1fb8 030051e1 cmp r1, r3
a03c1fbc eaffff1a bne #0xa03c1f6c
a03c1fc0 c43090e5 ldr r3, [r0, #0xc4]
a03c1fc4 030052e1 cmp r2, r3
a03c1fc8 e8ffff9a bls #0xa03c1f70
a03c1fcc e6ffffea b #0xa03c1f6c
a03c1fd0 10109ae5 ldr r1, [sl, #0x10]
a03c1fd4 ef3f0ee3 movw r3, #0xefef
a03c1fd8 ef3f4ee3 movt r3, #0xefef
a03c1fdc 011091e5 ldr r1, [r1, #1]
a03c1fe0 030051e1 cmp r1, r3
a03c1fe4 75ffff1a bne #0xa03c1dc0
a03c1fe8 c4309ae5 ldr r3, [sl, #0xc4]
a03c1fec 030052e1 cmp r2, r3
a03c1ff0 75ffff9a bls #0xa03c1dcc
a03c1ff4 71ffffea b #0xa03c1dc0
a03c1ff8 441706e3 movw r1, #0x6744
a03c1ffc 00b0a0e3 mov fp, #0
a03c2000 79114ae3 movt r1, #0xa179
a03c2004 1f9003e2 and sb, r3, #0x1f
a03c2008 00e191e7 ldr lr, [r1, r0, lsl #2]
a03c200c 0140a0e3 mov r4, #1
a03c2010 03b182e7 str fp, [r2, r3, lsl #2]
a03c2014 1439cee1 bic r3, lr, r4, lsl sb
a03c2018 0b0053e1 cmp r3, fp
a03c201c 003181e7 str r3, [r1, r0, lsl #2]
a03c2020 003306e3 movw r3, #0x6300
a03c2024 a000000a beq #0xa03c22ac
a03c2028 79314ae3 movt r3, #0xa179
a03c202c 000093e5 ldr r0, [r3]
a03c2030 000050e3 cmp r0, #0
a03c2034 9bffff1a bne #0xa03c1ea8
a03c2038 94909ae5 ldr sb, [sl, #0x94]
a03c203c 144306e3 movw r4, #0x6314
a03c2040 79414ae3 movt r4, #0xa179
a03c2044 093194e7 ldr r3, [r4, sb, lsl #2]
a03c2048 0a0053e1 cmp r3, sl
a03c204c a9ffff1a bne #0xa03c1ef8
a03c2050 00309ce5 ldr r3, [ip]
a03c2054 00c0a0e3 mov ip, #0
a03c2058 09c184e7 str ip, [r4, sb, lsl #2]
a03c205c 0c0053e1 cmp r3, ip
a03c2060 b700000a beq #0xa03c2344
a03c2064 0500a0e1 mov r0, r5
a03c2068 7bfbffeb bl #0xa03c0e5c
a03c206c a1ffffea b #0xa03c1ef8
a03c2070 003060e2 rsb r3, r0, #0
a03c2074 003003e0 and r3, r3, r0
a03c2078 ff0053e3 cmp r3, #0xff
a03c207c 01e0a093 movls lr, #1
a03c2080 0800009a bls #0xa03c20a8
a03c2084 010853e3 cmp r3, #0x10000
a03c2088 2334a031 lsrlo r3, r3, #8
a03c208c 09e0a033 movlo lr, #9
a03c2090 0400003a blo #0xa03c20a8
a03c2094 010453e3 cmp r3, #0x1000000
a03c2098 2338a031 lsrlo r3, r3, #0x10
a03c209c 233ca021 lsrhs r3, r3, #0x18
a03c20a0 11e0a033 movlo lr, #0x11
a03c20a4 19e0a023 movhs lr, #0x19
a03c20a8 0f0053e3 cmp r3, #0xf
a03c20ac 2332a081 lsrhi r3, r3, #4
a03c20b0 04e08e82 addhi lr, lr, #4
a03c20b4 030053e3 cmp r3, #3
a03c20b8 2331a081 lsrhi r3, r3, #2
a03c20bc 02e08e82 addhi lr, lr, #2
a03c20c0 013003e2 and r3, r3, #1
a03c20c4 0ee063e0 rsb lr, r3, lr
a03c20c8 79ffffea b #0xa03c1eb4
a03c20cc 002093e5 ldr r2, [r3]
a03c20d0 0800a0e1 mov r0, r8
a03c20d4 012082e2 add r2, r2, #1
a03c20d8 002083e5 str r2, [r3]
a03c20dc d1fcffeb bl #0xa03c1428
a03c20e0 0cd08de2 add sp, sp, #0xc
a03c20e4 f04fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03c20e8 e7feffea b #0xa03c1c8c
a03c20ec dc1206e3 movw r1, #0x62dc
a03c20f0 0040a0e3 mov r4, #0
a03c20f4 79114ae3 movt r1, #0xa179
a03c20f8 00408ce5 str r4, [ip]
a03c20fc 001091e5 ldr r1, [r1]
a03c2100 040051e1 cmp r1, r4
a03c2104 52ffff0a beq #0xa03c1e54
a03c2108 010011e3 tst r1, #1
a03c210c 04e0a011 movne lr, r4
a03c2110 1600001a bne #0xa03c2170
a03c2114 00e061e2 rsb lr, r1, #0
a03c2118 0e1001e0 and r1, r1, lr
a03c211c ff0051e3 cmp r1, #0xff
a03c2120 01e0a093 movls lr, #1
a03c2124 0800009a bls #0xa03c214c
a03c2128 010851e3 cmp r1, #0x10000
a03c212c 2114a031 lsrlo r1, r1, #8
a03c2130 09e0a033 movlo lr, #9
a03c2134 0400003a blo #0xa03c214c
a03c2138 010451e3 cmp r1, #0x1000000
a03c213c 2118a031 lsrlo r1, r1, #0x10
a03c2140 211ca021 lsrhs r1, r1, #0x18
a03c2144 11e0a033 movlo lr, #0x11
a03c2148 19e0a023 movhs lr, #0x19
a03c214c 0f0051e3 cmp r1, #0xf
a03c2150 2112a081 lsrhi r1, r1, #4
a03c2154 04e08e82 addhi lr, lr, #4
a03c2158 030051e3 cmp r1, #3
a03c215c 2111a081 lsrhi r1, r1, #2
a03c2160 02e08e82 addhi lr, lr, #2
a03c2164 011001e2 and r1, r1, #1
a03c2168 0ee061e0 rsb lr, r1, lr
a03c216c 8e42a0e1 lsl r4, lr, #5
a03c2170 241306e3 movw r1, #0x6324
a03c2174 79114ae3 movt r1, #0xa179
a03c2178 0e1191e7 ldr r1, [r1, lr, lsl #2]
a03c217c 010011e3 tst r1, #1
a03c2180 0010a013 movne r1, #0
a03c2184 1500001a bne #0xa03c21e0
a03c2188 009061e2 rsb sb, r1, #0
a03c218c 091001e0 and r1, r1, sb
a03c2190 ff0051e3 cmp r1, #0xff
a03c2194 0190a093 movls sb, #1
a03c2198 0800009a bls #0xa03c21c0
a03c219c 010851e3 cmp r1, #0x10000
a03c21a0 2114a031 lsrlo r1, r1, #8
a03c21a4 0990a033 movlo sb, #9
a03c21a8 0400003a blo #0xa03c21c0
a03c21ac 010451e3 cmp r1, #0x1000000
a03c21b0 2118a031 lsrlo r1, r1, #0x10
a03c21b4 211ca021 lsrhs r1, r1, #0x18
a03c21b8 1190a033 movlo sb, #0x11
a03c21bc 1990a023 movhs sb, #0x19
a03c21c0 0f0051e3 cmp r1, #0xf
a03c21c4 2112a081 lsrhi r1, r1, #4
a03c21c8 04908982 addhi sb, sb, #4
a03c21cc 030051e3 cmp r1, #3
a03c21d0 2111a081 lsrhi r1, r1, #2
a03c21d4 02908982 addhi sb, sb, #2
a03c21d8 011001e2 and r1, r1, #1
a03c21dc 091061e0 rsb r1, r1, sb
a03c21e0 044081e0 add r4, r1, r4
a03c21e4 041192e7 ldr r1, [r2, r4, lsl #2]
a03c21e8 00108ce5 str r1, [ip]
a03c21ec 19ffffea b #0xa03c1e58
a03c21f0 4c0093e5 ldr r0, [r3, #0x4c]
a03c21f4 182806e3 movw r2, #0x6818
a03c21f8 1cc093e5 ldr ip, [r3, #0x1c]
a03c21fc 79214ae3 movt r2, #0xa179
a03c2200 011040e2 sub r1, r0, #1
a03c2204 030071e3 cmn r1, #3
a03c2208 05c182e7 str ip, [r2, r5, lsl #2]
a03c220c e1feff8a bhi #0xa03c1d98
a03c2210 a82093e5 ldr r2, [r3, #0xa8]
a03c2214 200050e3 cmp r0, #0x20
a03c2218 140806e3 movw r0, #0x6814
a03c221c 0111a091 lslls r1, r1, #2
a03c2220 79014ae3 movt r0, #0xa179
a03c2224 a42083e5 str r2, [r3, #0xa4]
a03c2228 0c2d06e3 movw r2, #0x6d0c
a03c222c 79214ae3 movt r2, #0xa179
a03c2230 000090e5 ldr r0, [r0]
a03c2234 002092e5 ldr r2, [r2]
a03c2238 7c10a083 movhi r1, #0x7c
a03c223c 4cc083e2 add ip, r3, #0x4c
a03c2240 012082e0 add r2, r2, r1
a03c2244 000052e1 cmp r2, r0
a03c2248 08180623 movwhs r1, #0x6808
a03c224c 02206020 rsbhs r2, r0, r2
a03c2250 79114a23 movths r1, #0xa179
a03c2254 00109125 ldrhs r1, [r1]
a03c2258 02208120 addhs r2, r1, r2
a03c225c 001092e5 ldr r1, [r2]
a03c2260 000051e3 cmp r1, #0
a03c2264 14009115 ldrne r0, [r1, #0x14]
a03c2268 5cc08305 streq ip, [r3, #0x5c]
a03c226c 60c08305 streq ip, [r3, #0x60]
a03c2270 10c08015 strne ip, [r0, #0x10]
a03c2274 00c08205 streq ip, [r2]
a03c2278 14c08115 strne ip, [r1, #0x14]
a03c227c 60008315 strne r0, [r3, #0x60]
a03c2280 5c108315 strne r1, [r3, #0x5c]
a03c2284 642083e5 str r2, [r3, #0x64]
a03c2288 c2feffea b #0xa03c1d98
a03c228c 20909ae5 ldr sb, [sl, #0x20]
a03c2290 000306e3 movw r0, #0x6300
a03c2294 79014ae3 movt r0, #0xa179
a03c2298 441706e3 movw r1, #0x6744
a03c229c 000090e5 ldr r0, [r0]
a03c22a0 79114ae3 movt r1, #0xa179
a03c22a4 039184e7 str sb, [r4, r3, lsl #2]
a03c22a8 fcfeffea b #0xa03c1ea0
a03c22ac 79314ae3 movt r3, #0xa179
a03c22b0 00e0a0e1 mov lr, r0
a03c22b4 009093e5 ldr sb, [r3]
a03c22b8 1440c9e1 bic r4, sb, r4, lsl r0
a03c22bc 0400a0e1 mov r0, r4
a03c22c0 004083e5 str r4, [r3]
a03c22c4 f5feffea b #0xa03c1ea0
a03c22c8 241306e3 movw r1, #0x6324
a03c22cc 0140a0e3 mov r4, #1
a03c22d0 79114ae3 movt r1, #0xa179
a03c22d4 1fc003e2 and ip, r3, #0x1f
a03c22d8 00e191e7 ldr lr, [r1, r0, lsl #2]
a03c22dc 14cccee1 bic ip, lr, r4, lsl ip
a03c22e0 00005ce3 cmp ip, #0
a03c22e4 00c181e7 str ip, [r1, r0, lsl #2]
a03c22e8 dc120603 movweq r1, #0x62dc
a03c22ec 79114a03 movteq r1, #0xa179
a03c22f0 00c09105 ldreq ip, [r1]
a03c22f4 1440cc01 biceq r4, ip, r4, lsl r0
a03c22f8 00408105 streq r4, [r1]
a03c22fc cffeffea b #0xa03c1e40
a03c2300 05005be1 cmp fp, r5
a03c2304 0b3184e7 str r3, [r4, fp, lsl #2]
a03c2308 f3feff0a beq #0xa03c1edc
a03c230c 79914ae3 movt sb, #0xa179
a03c2310 ef300fe3 movw r3, #0xf0ef
a03c2314 0b2199e7 ldr r2, [sb, fp, lsl #2]
a03c2318 f0304fe3 movt r3, #0xf0f0
a03c231c 030052e1 cmp r2, r3
a03c2320 eefeff8a bhi #0xa03c1ee0
a03c2324 0b00a0e1 mov r0, fp
a03c2328 72faffeb bl #0xa03c0cf8
a03c232c 0b3194e7 ldr r3, [r4, fp, lsl #2]
a03c2330 000053e3 cmp r3, #0
a03c2334 e9feff0a beq #0xa03c1ee0
a03c2338 0b00a0e1 mov r0, fp
a03c233c 6dfaffeb bl #0xa03c0cf8
a03c2340 e6feffea b #0xa03c1ee0
a03c2344 3ce09ae5 ldr lr, [sl, #0x3c]
a03c2348 2cc09ae5 ldr ip, [sl, #0x2c]
a03c234c 0c005ee1 cmp lr, ip
a03c2350 43ffff3a blo #0xa03c2064
a03c2354 01c0a0e3 mov ip, #1
a03c2358 08a0a0e1 mov sl, r8
a03c235c 1cb9a0e1 lsl fp, ip, sb
a03c2360 04108de5 str r1, [sp, #4]
a03c2364 03c0a0e1 mov ip, r3
a03c2368 100000ea b #0xa03c23b0
a03c236c 94809ce5 ldr r8, [ip, #0x94]
a03c2370 14e306e3 movw lr, #0x6314
a03c2374 79e14ae3 movt lr, #0xa179
a03c2378 088194e7 ldr r8, [r4, r8, lsl #2]
a03c237c 0c0058e1 cmp r8, ip
a03c2380 0600000a beq #0xa03c23a0
a03c2384 2c809ce5 ldr r8, [ip, #0x2c]
a03c2388 3c109ce5 ldr r1, [ip, #0x3c]
a03c238c 080051e1 cmp r1, r8
a03c2390 6d00001a bne #0xa03c254c
a03c2394 98809ce5 ldr r8, [ip, #0x98]
a03c2398 08001be1 tst fp, r8
a03c239c 6600000a beq #0xa03c253c
a03c23a0 20c09ce5 ldr ip, [ip, #0x20]
a03c23a4 03e192e7 ldr lr, [r2, r3, lsl #2]
a03c23a8 0c005ee1 cmp lr, ip
a03c23ac 4d00000a beq #0xa03c24e8
a03c23b0 00005ce3 cmp ip, #0
a03c23b4 ecffff1a bne #0xa03c236c
a03c23b8 04109de5 ldr r1, [sp, #4]
a03c23bc 1e0000ea b #0xa03c243c
a03c23c0 00e06ce2 rsb lr, ip, #0
a03c23c4 0ec00ce0 and ip, ip, lr
a03c23c8 ff005ce3 cmp ip, #0xff
a03c23cc 01e0a093 movls lr, #1
a03c23d0 0800009a bls #0xa03c23f8
a03c23d4 01085ce3 cmp ip, #0x10000
a03c23d8 2cc4a031 lsrlo ip, ip, #8
a03c23dc 09e0a033 movlo lr, #9
a03c23e0 0400003a blo #0xa03c23f8
a03c23e4 01045ce3 cmp ip, #0x1000000
a03c23e8 2cc8a031 lsrlo ip, ip, #0x10
a03c23ec 2ccca021 lsrhs ip, ip, #0x18
a03c23f0 11e0a033 movlo lr, #0x11
a03c23f4 19e0a023 movhs lr, #0x19
a03c23f8 0f005ce3 cmp ip, #0xf
a03c23fc 2cc2a081 lsrhi ip, ip, #4
a03c2400 04e08e82 addhi lr, lr, #4
a03c2404 03005ce3 cmp ip, #3
a03c2408 2cc1a081 lsrhi ip, ip, #2
a03c240c 02e08e82 addhi lr, lr, #2
a03c2410 01c00ce2 and ip, ip, #1
a03c2414 0ec06ce0 rsb ip, ip, lr
a03c2418 03308ce0 add r3, ip, r3
a03c241c ff0053e3 cmp r3, #0xff
a03c2420 3300008a bhi #0xa03c24f4
a03c2424 03c192e7 ldr ip, [r2, r3, lsl #2]
a03c2428 00005ce3 cmp ip, #0
a03c242c 4000001a bne #0xa03c2534
a03c2430 013083e2 add r3, r3, #1
a03c2434 010c53e3 cmp r3, #0x100
a03c2438 2d00000a beq #0xa03c24f4
a03c243c a3c2a0e1 lsr ip, r3, #5
a03c2440 30ccb0e1 lsrs ip, r0, ip
a03c2444 2a00000a beq #0xa03c24f4
a03c2448 01001ce3 tst ip, #1
a03c244c 00c0a013 movne ip, #0
a03c2450 1600001a bne #0xa03c24b0
a03c2454 00e06ce2 rsb lr, ip, #0
a03c2458 0ec00ce0 and ip, ip, lr
a03c245c ff005ce3 cmp ip, #0xff
a03c2460 01e0a093 movls lr, #1
a03c2464 0800009a bls #0xa03c248c
a03c2468 01085ce3 cmp ip, #0x10000
a03c246c 2cc4a031 lsrlo ip, ip, #8
a03c2470 09e0a033 movlo lr, #9
a03c2474 0400003a blo #0xa03c248c
a03c2478 01045ce3 cmp ip, #0x1000000
a03c247c 2cc8a031 lsrlo ip, ip, #0x10
a03c2480 2ccca021 lsrhs ip, ip, #0x18
a03c2484 11e0a033 movlo lr, #0x11
a03c2488 19e0a023 movhs lr, #0x19
a03c248c 0f005ce3 cmp ip, #0xf
a03c2490 2cc2a081 lsrhi ip, ip, #4
a03c2494 04e08e82 addhi lr, lr, #4
a03c2498 03005ce3 cmp ip, #3
a03c249c 2cc1a081 lsrhi ip, ip, #2
a03c24a0 02e08e82 addhi lr, lr, #2
a03c24a4 01c00ce2 and ip, ip, #1
a03c24a8 0ec06ce0 rsb ip, ip, lr
a03c24ac 8cc2a0e1 lsl ip, ip, #5
a03c24b0 03308ce0 add r3, ip, r3
a03c24b4 ff0053e3 cmp r3, #0xff
a03c24b8 0d00008a bhi #0xa03c24f4
a03c24bc a3c2a0e1 lsr ip, r3, #5
a03c24c0 1fe003e2 and lr, r3, #0x1f
a03c24c4 0cc191e7 ldr ip, [r1, ip, lsl #2]
a03c24c8 3cceb0e1 lsrs ip, ip, lr
a03c24cc 1f30c303 biceq r3, r3, #0x1f
a03c24d0 20308302 addeq r3, r3, #0x20
a03c24d4 d6ffff0a beq #0xa03c2434
a03c24d8 01001ce3 tst ip, #1
a03c24dc b7ffff0a beq #0xa03c23c0
a03c24e0 00c0a0e3 mov ip, #0
a03c24e4 cbffffea b #0xa03c2418
a03c24e8 013083e2 add r3, r3, #1
a03c24ec 010c53e3 cmp r3, #0x100
a03c24f0 b0ffff1a bne #0xa03c23b8
a03c24f4 0a80a0e1 mov r8, sl
a03c24f8 050059e1 cmp sb, r5
a03c24fc 7dfeff0a beq #0xa03c1ef8
a03c2500 e83206e3 movw r3, #0x62e8
a03c2504 ef200fe3 movw r2, #0xf0ef
a03c2508 79314ae3 movt r3, #0xa179
a03c250c f0204fe3 movt r2, #0xf0f0
a03c2510 093193e7 ldr r3, [r3, sb, lsl #2]
a03c2514 020053e1 cmp r3, r2
a03c2518 0f00009a bls #0xa03c255c
a03c251c 093194e7 ldr r3, [r4, sb, lsl #2]
a03c2520 000053e3 cmp r3, #0
a03c2524 73feff0a beq #0xa03c1ef8
a03c2528 0900a0e1 mov r0, sb
a03c252c f1f9ffeb bl #0xa03c0cf8
a03c2530 70feffea b #0xa03c1ef8
a03c2534 04108de5 str r1, [sp, #4]
a03c2538 8bffffea b #0xa03c236c
a03c253c 0a80a0e1 mov r8, sl
a03c2540 94908ce5 str sb, [ip, #0x94]
a03c2544 09c18ee7 str ip, [lr, sb, lsl #2]
a03c2548 eaffffea b #0xa03c24f8
a03c254c 0500a0e1 mov r0, r5
a03c2550 0a80a0e1 mov r8, sl
a03c2554 40faffeb bl #0xa03c0e5c
a03c2558 e6ffffea b #0xa03c24f8
a03c255c 0900a0e1 mov r0, sb
a03c2560 e4f9ffeb bl #0xa03c0cf8
a03c2564 ecffffea b #0xa03c251c
