a0295cf8 000000e3 movw r0, #0
a0295cfc 001000e3 movw r1, #0
a0295d00 00004ae3 movt r0, #0xa000
a0295d04 10104ae3 movt r1, #0xa010
a0295d08 0f2200e2 and r2, r0, #0xf0000000
a0295d0c b03305e3 movw r3, #0x53b0
a0295d10 06c282e2 add ip, r2, #0x60000000
a0295d14 0f22c0e3 bic r2, r0, #0xf0000000
a0295d18 44314ae3 movt r3, #0xa144
a0295d1c f0412de9 push {r4, r5, r6, r7, r8, lr}
a0295d20 02208ce1 orr r2, ip, r2
a0295d24 51e0ebe7 ubfx lr, r1, #0, #0xc
a0295d28 00005ee3 cmp lr, #0
a0295d2c 00e000e3 movw lr, #0
a0295d30 050083e8 stm r3, {r0, r2}
a0295d34 14220ee3 movw r2, #0xe214
a0295d38 64204ae3 movt r2, #0xa064
a0295d3c ff1ec113 bicne r1, r1, #0xff0
a0295d40 5240ebe7 ubfx r4, r2, #0, #0xc
a0295d44 0f10c113 bicne r1, r1, #0xf
a0295d48 011a8112 addne r1, r1, #0x1000
a0295d4c 000054e3 cmp r4, #0
a0295d50 0f4600e3 movw r4, #0x60f
a0295d54 10e04ae3 movt lr, #0xa010
a0295d58 014040e3 movt r4, #1
a0295d5c 011060e0 rsb r1, r0, r1
a0295d60 0c4083e5 str r4, [r3, #0xc]
a0295d64 00400be3 movw r4, #0xb000
a0295d68 69404ae3 movt r4, #0xa069
a0295d6c 0fc20ee2 and ip, lr, #0xf0000000
a0295d70 ff2ec213 bicne r2, r2, #0xff0
a0295d74 0f52cee3 bic r5, lr, #0xf0000000
a0295d78 081083e5 str r1, [r3, #8]
a0295d7c 06c28ce2 add ip, ip, #0x60000000
a0295d80 0f1204e2 and r1, r4, #0xf0000000
a0295d84 fc0601e3 movw r0, #0x16fc
a0295d88 82004ae3 movt r0, #0xa082
a0295d8c 05c08ce1 orr ip, ip, r5
a0295d90 0f20c213 bicne r2, r2, #0xf
a0295d94 065281e2 add r5, r1, #0x60000000
a0295d98 0f12c4e3 bic r1, r4, #0xf0000000
a0295d9c 5060ebe7 ubfx r6, r0, #0, #0xc
a0295da0 011085e1 orr r1, r5, r1
a0295da4 012a8212 addne r2, r2, #0x1000
a0295da8 02206ee0 rsb r2, lr, r2
a0295dac 000056e3 cmp r6, #0
a0295db0 10e083e5 str lr, [r3, #0x10]
a0295db4 0f6600e3 movw r6, #0x60f
a0295db8 241083e5 str r1, [r3, #0x24]
a0295dbc 00e00fe3 movw lr, #0xf000
a0295dc0 001e0ae3 movw r1, #0xae00
a0295dc4 64e04ae3 movt lr, #0xa064
a0295dc8 69104ae3 movt r1, #0xa069
a0295dcc ff0ec013 bicne r0, r0, #0xff0
a0295dd0 016040e3 movt r6, #1
a0295dd4 0f00c013 bicne r0, r0, #0xf
a0295dd8 182083e5 str r2, [r3, #0x18]
a0295ddc 0f220ee2 and r2, lr, #0xf0000000
a0295de0 1c6083e5 str r6, [r3, #0x1c]
a0295de4 5160ebe7 ubfx r6, r1, #0, #0xc
a0295de8 065282e2 add r5, r2, #0x60000000
a0295dec 010a8012 addne r0, r0, #0x1000
a0295df0 0f22cee3 bic r2, lr, #0xf0000000
a0295df4 000056e3 cmp r6, #0
a0295df8 ff1ec113 bicne r1, r1, #0xff0
a0295dfc 022085e1 orr r2, r5, r2
a0295e00 0f10c113 bicne r1, r1, #0xf
a0295e04 342083e5 str r2, [r3, #0x34]
a0295e08 0f6600e3 movw r6, #0x60f
a0295e0c 782101e3 movw r2, #0x1178
a0295e10 a5214ae3 movt r2, #0xa1a5
a0295e14 016040e3 movt r6, #1
a0295e18 011a8112 addne r1, r1, #0x1000
a0295e1c 000064e0 rsb r0, r4, r0
a0295e20 01106ee0 rsb r1, lr, r1
a0295e24 2c6083e5 str r6, [r3, #0x2c]
a0295e28 5260ebe7 ubfx r6, r2, #0, #0xc
a0295e2c 280083e5 str r0, [r3, #0x28]
a0295e30 000056e3 cmp r6, #0
a0295e34 381083e5 str r1, [r3, #0x38]
a0295e38 680f04e3 movw r0, #0x4f68
a0295e3c 036601e3 movw r6, #0x1603
a0295e40 001000e3 movw r1, #0
a0295e44 82004ae3 movt r0, #0xa082
a0295e48 10124ae3 movt r1, #0xa210
a0295e4c ff2ec213 bicne r2, r2, #0xff0
a0295e50 016040e3 movt r6, #1
a0295e54 0f20c213 bicne r2, r2, #0xf
a0295e58 0f5200e2 and r5, r0, #0xf0000000
a0295e5c 3c6083e5 str r6, [r3, #0x3c]
a0295e60 5160f3e7 ubfx r6, r1, #0, #0x14
a0295e64 204083e5 str r4, [r3, #0x20]
a0295e68 065285e2 add r5, r5, #0x60000000
a0295e6c 0f42c0e3 bic r4, r0, #0xf0000000
a0295e70 012a8212 addne r2, r2, #0x1000
a0295e74 000056e3 cmp r6, #0
a0295e78 211aa011 lsrne r1, r1, #0x14
a0295e7c 022060e0 rsb r2, r0, r2
a0295e80 30e083e5 str lr, [r3, #0x30]
a0295e84 04e085e1 orr lr, r5, r4
a0295e88 44e083e5 str lr, [r3, #0x44]
a0295e8c 0f6600e3 movw r6, #0x60f
a0295e90 482083e5 str r2, [r3, #0x48]
a0295e94 00e000e3 movw lr, #0
a0295e98 002000e3 movw r2, #0
a0295e9c b0e14ae3 movt lr, #0xa1b0
a0295ea0 002c4de3 movt r2, #0xdc00
a0295ea4 011aa011 lslne r1, r1, #0x14
a0295ea8 016040e3 movt r6, #1
a0295eac 400083e5 str r0, [r3, #0x40]
a0295eb0 0f520ee2 and r5, lr, #0xf0000000
a0295eb4 4c6083e5 str r6, [r3, #0x4c]
a0295eb8 5260f3e7 ubfx r6, r2, #0, #0x14
a0295ebc 0f42cee3 bic r4, lr, #0xf0000000
a0295ec0 065285e2 add r5, r5, #0x60000000
a0295ec4 01168112 addne r1, r1, #0x100000
a0295ec8 000056e3 cmp r6, #0
a0295ecc 040085e1 orr r0, r5, r4
a0295ed0 222aa011 lsrne r2, r2, #0x14
a0295ed4 01106ee0 rsb r1, lr, r1
a0295ed8 540083e5 str r0, [r3, #0x54]
a0295edc 016601e3 movw r6, #0x1601
a0295ee0 581083e5 str r1, [r3, #0x58]
a0295ee4 000000e3 movw r0, #0
a0295ee8 001000e3 movw r1, #0
a0295eec 10034ae3 movt r0, #0xa310
a0295ef0 10134ae3 movt r1, #0xa310
a0295ef4 022aa011 lslne r2, r2, #0x14
a0295ef8 016040e3 movt r6, #1
a0295efc 50e083e5 str lr, [r3, #0x50]
a0295f00 0f5200e2 and r5, r0, #0xf0000000
a0295f04 5c6083e5 str r6, [r3, #0x5c]
a0295f08 5160f3e7 ubfx r6, r1, #0, #0x14
a0295f0c 0f42c0e3 bic r4, r0, #0xf0000000
a0295f10 065285e2 add r5, r5, #0x60000000
a0295f14 01268212 addne r2, r2, #0x100000
a0295f18 000056e3 cmp r6, #0
a0295f1c 04e085e1 orr lr, r5, r4
a0295f20 211aa011 lsrne r1, r1, #0x14
a0295f24 022060e0 rsb r2, r0, r2
a0295f28 64e083e5 str lr, [r3, #0x64]
a0295f2c 0d6600e3 movw r6, #0x60d
a0295f30 682083e5 str r2, [r3, #0x68]
a0295f34 00e000e3 movw lr, #0
a0295f38 002000e3 movw r2, #0
a0295f3c 10e24ae3 movt lr, #0xa210
a0295f40 00204ee3 movt r2, #0xe000
a0295f44 011aa011 lslne r1, r1, #0x14
a0295f48 016040e3 movt r6, #1
a0295f4c 600083e5 str r0, [r3, #0x60]
a0295f50 0f520ee2 and r5, lr, #0xf0000000
a0295f54 6c6083e5 str r6, [r3, #0x6c]
a0295f58 5260f3e7 ubfx r6, r2, #0, #0x14
a0295f5c 0f42cee3 bic r4, lr, #0xf0000000
a0295f60 065285e2 add r5, r5, #0x60000000
a0295f64 01168112 addne r1, r1, #0x100000
a0295f68 000056e3 cmp r6, #0
a0295f6c 040085e1 orr r0, r5, r4
a0295f70 222aa011 lsrne r2, r2, #0x14
a0295f74 740083e5 str r0, [r3, #0x74]
a0295f78 000000e3 movw r0, #0
a0295f7c 70e083e5 str lr, [r3, #0x70]
a0295f80 000c4de3 movt r0, #0xdc00
a0295f84 022aa011 lslne r2, r2, #0x14
a0295f88 01106ee0 rsb r1, lr, r1
a0295f8c 14c083e5 str ip, [r3, #0x14]
a0295f90 0f5200e2 and r5, r0, #0xf0000000
a0295f94 0f42c0e3 bic r4, r0, #0xf0000000
a0295f98 781083e5 str r1, [r3, #0x78]
a0295f9c 065285e2 add r5, r5, #0x60000000
a0295fa0 018601e3 movw r8, #0x1601
a0295fa4 0070a0e3 mov r7, #0
a0295fa8 0f6600e3 movw r6, #0x60f
a0295fac 01268212 addne r2, r2, #0x100000
a0295fb0 0d1601e3 movw r1, #0x160d
a0295fb4 04e085e1 orr lr, r5, r4
a0295fb8 018040e3 movt r8, #1
a0295fbc ff7f4fe3 movt r7, #0xffff
a0295fc0 016040e3 movt r6, #1
a0295fc4 0149a0e3 mov r4, #0x4000
a0295fc8 022060e0 rsb r2, r0, r2
a0295fcc 011040e3 movt r1, #1
a0295fd0 84c083e5 str ip, [r3, #0x84]
a0295fd4 900083e5 str r0, [r3, #0x90]
a0295fd8 94e083e5 str lr, [r3, #0x94]
a0295fdc 7c8083e5 str r8, [r3, #0x7c]
a0295fe0 807083e5 str r7, [r3, #0x80]
a0295fe4 8c6083e5 str r6, [r3, #0x8c]
a0295fe8 884083e5 str r4, [r3, #0x88]
a0295fec 982083e5 str r2, [r3, #0x98]
a0295ff0 9c1083e5 str r1, [r3, #0x9c]
a0295ff4 f081bde8 pop {r4, r5, r6, r7, r8, pc}
