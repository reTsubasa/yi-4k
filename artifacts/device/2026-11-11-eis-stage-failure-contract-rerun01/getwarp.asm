a0312f74: f0402de9 push {r4, r5, r6, r7, lr}
a0312f78: 004051e2 subs r4, r1, #0
a0312f7c: 14d04de2 sub sp, sp, #0x14
a0312f80: 0050a0e3 mov r5, #0
a0312f84: 04508de5 str r5, [sp, #4]
a0312f88: 08508de5 str r5, [sp, #8]
a0312f8c: 6c00000a beq #0xa0313144
a0312f90: 0020d0e5 ldrb r2, [r0]
a0312f94: 0060a0e1 mov r6, r0
a0312f98: 0330d0e5 ldrb r3, [r0, #3]
a0312f9c: 0d10a0e1 mov r1, sp
a0312fa0: 0c008de2 add r0, sp, #0xc
a0312fa4: 0c20cde5 strb r2, [sp, #0xc]
a0312fa8: 0d30cde5 strb r3, [sp, #0xd]
a0312fac: 33d6ffeb bl #0xa0308880
a0312fb0: 007050e2 subs r7, r0, #0
a0312fb4: 5c0000ba blt #0xa031312c
a0312fb8: 0510a0e1 mov r1, r5
a0312fbc: 00009de5 ldr r0, [sp]
a0312fc0: 29a502eb bl #0xa03bc46c
a0312fc4: 0010d6e5 ldrb r1, [r6]
a0312fc8: 000051e3 cmp r1, #0
a0312fcc: 4f00000a beq #0xa0313110
a0312fd0: 010051e3 cmp r1, #1
a0312fd4: 4400001a bne #0xa03130ec
a0312fd8: 0c008de2 add r0, sp, #0xc
a0312fdc: 08108de2 add r1, sp, #8
a0312fe0: dbd5ffeb bl #0xa0308754
a0312fe4: 08209de5 ldr r2, [sp, #8]
a0312fe8: 843800e3 movw r3, #0x884
a0312fec: 063040e3 movt r3, #6
a0312ff0: 033082e0 add r3, r2, r3
a0312ff4: 042093e5 ldr r2, [r3, #4]
a0312ff8: 0070a0e3 mov r7, #0
a0312ffc: 002084e5 str r2, [r4]
a0313000: 3020d3e5 ldrb r2, [r3, #0x30]
a0313004: 0420c4e5 strb r2, [r4, #4]
a0313008: 3120d3e5 ldrb r2, [r3, #0x31]
a031300c: 0520c4e5 strb r2, [r4, #5]
a0313010: 3220d3e5 ldrb r2, [r3, #0x32]
a0313014: 0620c4e5 strb r2, [r4, #6]
a0313018: 3320d3e5 ldrb r2, [r3, #0x33]
a031301c: 0720c4e5 strb r2, [r4, #7]
a0313020: 3420d3e5 ldrb r2, [r3, #0x34]
a0313024: 0820c4e5 strb r2, [r4, #8]
a0313028: 3520d3e5 ldrb r2, [r3, #0x35]
a031302c: 0920c4e5 strb r2, [r4, #9]
a0313030: 3620d3e5 ldrb r2, [r3, #0x36]
a0313034: 0a20c4e5 strb r2, [r4, #0xa]
a0313038: 3720d3e5 ldrb r2, [r3, #0x37]
a031303c: 0b20c4e5 strb r2, [r4, #0xb]
a0313040: 3820d3e5 ldrb r2, [r3, #0x38]
a0313044: 0c20c4e5 strb r2, [r4, #0xc]
a0313048: 082093e5 ldr r2, [r3, #8]
a031304c: 102084e5 str r2, [r4, #0x10]
a0313050: 0c2093e5 ldr r2, [r3, #0xc]
a0313054: 142084e5 str r2, [r4, #0x14]
a0313058: 102093e5 ldr r2, [r3, #0x10]
a031305c: 182084e5 str r2, [r4, #0x18]
a0313060: 142093e5 ldr r2, [r3, #0x14]
a0313064: 1c2084e5 str r2, [r4, #0x1c]
a0313068: 182093e5 ldr r2, [r3, #0x18]
a031306c: 202084e5 str r2, [r4, #0x20]
a0313070: 1c2093e5 ldr r2, [r3, #0x1c]
a0313074: 242084e5 str r2, [r4, #0x24]
a0313078: 202093e5 ldr r2, [r3, #0x20]
a031307c: 282084e5 str r2, [r4, #0x28]
a0313080: 242093e5 ldr r2, [r3, #0x24]
a0313084: 00009de5 ldr r0, [sp]
a0313088: 2c2084e5 str r2, [r4, #0x2c]
a031308c: 282093e5 ldr r2, [r3, #0x28]
a0313090: 302084e5 str r2, [r4, #0x30]
a0313094: 2c2093e5 ldr r2, [r3, #0x2c]
a0313098: 342084e5 str r2, [r4, #0x34]
a031309c: 3c2093e5 ldr r2, [r3, #0x3c]
a03130a0: 382084e5 str r2, [r4, #0x38]
a03130a4: 3920d3e5 ldrb r2, [r3, #0x39]
a03130a8: 3c20c4e5 strb r2, [r4, #0x3c]
a03130ac: b024d3e1 ldrh r2, [r3, #0x40]
a03130b0: be23c4e1 strh r2, [r4, #0x3e]
a03130b4: b224d3e1 ldrh r2, [r3, #0x42]
a03130b8: b024c4e1 strh r2, [r4, #0x40]
a03130bc: b424d3e1 ldrh r2, [r3, #0x44]
a03130c0: b224c4e1 strh r2, [r4, #0x42]
a03130c4: b624d3e1 ldrh r2, [r3, #0x46]
a03130c8: b424c4e1 strh r2, [r4, #0x44]
a03130cc: b824d3e1 ldrh r2, [r3, #0x48]
a03130d0: b624c4e1 strh r2, [r4, #0x46]
a03130d4: ba34d3e1 ldrh r3, [r3, #0x4a]
a03130d8: b834c4e1 strh r3, [r4, #0x48]
a03130dc: eda402eb bl #0xa03bc498
a03130e0: 0700a0e1 mov r0, r7
a03130e4: 14d08de2 add sp, sp, #0x14
a03130e8: f080bde8 pop {r4, r5, r6, r7, pc}
a03130ec: 780107e3 movw r0, #0x7178
a03130f0: 0070e0e3 mvn r7, #0
a03130f4: 5e004ae3 movt r0, #0xa05e
a03130f8: fb4ffeeb bl #0xa02a70ec
a03130fc: 00009de5 ldr r0, [sp]
a0313100: e4a402eb bl #0xa03bc498
a0313104: 0700a0e1 mov r0, r7
a0313108: 14d08de2 add sp, sp, #0x14
a031310c: f080bde8 pop {r4, r5, r6, r7, pc}
a0313110: 0c008de2 add r0, sp, #0xc
a0313114: 04108de2 add r1, sp, #4
a0313118: 8dd5ffeb bl #0xa0308754
a031311c: 04309de5 ldr r3, [sp, #4]
a0313120: 413a83e2 add r3, r3, #0x41000
a0313124: 413f83e2 add r3, r3, #0x104
a0313128: b1ffffea b #0xa0312ff4
a031312c: 840f00e3 movw r0, #0xf84
a0313130: 5d004ae3 movt r0, #0xa05d
a0313134: ec4ffeeb bl #0xa02a70ec
a0313138: 0700a0e1 mov r0, r7
a031313c: 14d08de2 add sp, sp, #0x14
a0313140: f080bde8 pop {r4, r5, r6, r7, pc}
a0313144: 500107e3 movw r0, #0x7150
a0313148: 0070e0e3 mvn r7, #0
a031314c: 5e004ae3 movt r0, #0xa05e
a0313150: e54ffeeb bl #0xa02a70ec
a0313154: eaffffea b #0xa0313104
a0313158: 70402de9 push {r4, r5, r6, lr}
a031315c: 0050a0e1 mov r5, r0
a0313160: 0020d0e5 ldrb r2, [r0]
a0313164: 18d04de2 sub sp, sp, #0x18
a0313168: 14008de2 add r0, sp, #0x14
a031316c: 0060a0e3 mov r6, #0
a0313170: 0330d5e5 ldrb r3, [r5, #3]
a0313174: 04108de5 str r1, [sp, #4]
a0313178: 0c108de2 add r1, sp, #0xc
a031317c: 1420cde5 strb r2, [sp, #0x14]
a0313180: 1530cde5 strb r3, [sp, #0x15]
a0313184: 10608de5 str r6, [sp, #0x10]
a0313188: bcd5ffeb bl #0xa0308880
a031318c: 004050e2 subs r4, r0, #0
a0313190: 1f0000ba blt #0xa0313214
a0313194: 0610a0e1 mov r1, r6
a0313198: 0c009de5 ldr r0, [sp, #0xc]
a031319c: b2a402eb bl #0xa03bc46c
a03131a0: 0040d5e5 ldrb r4, [r5]
a03131a4: 000054e3 cmp r4, #0
a03131a8: 1f00001a bne #0xa031322c
a03131ac: 14008de2 add r0, sp, #0x14
a03131b0: 10108de2 add r1, sp, #0x10
a03131b4: 66d5ffeb bl #0xa0308754
a03131b8: 10309de5 ldr r3, [sp, #0x10]
a03131bc: 8a5800e3 movw r5, #0x88a
a03131c0: 04209de5 ldr r2, [sp, #4]
a03131c4: 045040e3 movt r5, #4
a03131c8: 38c0d3e5 ldrb ip, [r3, #0x38]
a03131cc: 055083e0 add r5, r3, r5
a03131d0: 02005ce1 cmp ip, r2
a03131d4: 060000ba blt #0xa03131f4
a03131d8: 0430dde5 ldrb r3, [sp, #4]
a03131dc: 0030c5e5 strb r3, [r5]
a03131e0: 0c009de5 ldr r0, [sp, #0xc]
a03131e4: aba402eb bl #0xa03bc498
a03131e8: 0400a0e1 mov r0, r4
