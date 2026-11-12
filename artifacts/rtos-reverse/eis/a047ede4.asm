; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a047ede4 010050e3 cmp      r0, #1
a047ede8 30402de9 push     {r4, r5, lr}
a047edec 0150a0e1 mov      r5, r1
a047edf0 14d04de2 sub      sp, sp, #0x14
a047edf4 5100000a beq      #0xa047ef40
a047edf8 020050e3 cmp      r0, #2
a047edfc 6900000a beq      #0xa047efa8
a047ee00 030050e3 cmp      r0, #3
a047ee04 0200000a beq      #0xa047ee14
a047ee08 0000a0e3 mov      r0, #0
a047ee0c 14d08de2 add      sp, sp, #0x14
a047ee10 3080bde8 pop      {r4, r5, pc}
a047ee14 104605e3 movw     r4, #0x5610
a047ee18 10308de2 add      r3, sp, #0x10
a047ee1c a3414ae3 movt     r4, #0xa1a3
a047ee20 7300e0e3 mvn      r0, #0x73
a047ee24 fa2fa0e3 mov      r2, #0x3e8
a047ee28 b0100be3 movw     r1, #0xb0b0
a047ee2c 00408de5 str      r4, [sp]
a047ee30 78104ae3 movt     r1, #0xa078
a047ee34 010063e5 strb     r0, [r3, #-1]!
a047ee38 0100a0e3 mov      r0, #1
a047ee3c 04208de5 str      r2, [sp, #4]
a047ee40 1720a0e3 mov      r2, #0x17
a047ee44 b83c00eb bl       #0xa048e12c
a047ee48 1610d4e5 ldrb     r1, [r4, #0x16]
a047ee4c ac3505e3 movw     r3, #0x55ac
a047ee50 1520d4e5 ldrb     r2, [r4, #0x15]
a047ee54 a3314ae3 movt     r3, #0xa1a3
a047ee58 012482e1 orr      r2, r2, r1, lsl #8
a047ee5c b620c5e1 strh     r2, [r5, #6]
a047ee60 bc13d3e1 ldrh     r1, [r3, #0x3c]
a047ee64 012082e0 add      r2, r2, r1
a047ee68 b620c5e1 strh     r2, [r5, #6]
a047ee6c b822d3e1 ldrh     r2, [r3, #0x28]
a047ee70 010052e3 cmp      r2, #1
a047ee74 7500000a beq      #0xa047f050
a047ee78 0810d4e5 ldrb     r1, [r4, #8]
a047ee7c 0720d4e5 ldrb     r2, [r4, #7]
a047ee80 0900d4e5 ldrb     r0, [r4, #9]
a047ee84 011482e1 orr      r1, r2, r1, lsl #8
a047ee88 ba10c5e1 strh     r1, [r5, #0xa]
a047ee8c 0a20d4e5 ldrb     r2, [r4, #0xa]
a047ee90 020480e1 orr      r0, r0, r2, lsl #8
a047ee94 b800c5e1 strh     r0, [r5, #8]
a047ee98 0ce0d4e5 ldrb     lr, [r4, #0xc]
a047ee9c 10c605e3 movw     ip, #0x5610
a047eea0 0b20d4e5 ldrb     r2, [r4, #0xb]
a047eea4 a3c14ae3 movt     ip, #0xa1a3
a047eea8 0e2482e1 orr      r2, r2, lr, lsl #8
a047eeac bc20c5e1 strh     r2, [r5, #0xc]
a047eeb0 bce3d3e1 ldrh     lr, [r3, #0x3c]
a047eeb4 0e0080e0 add      r0, r0, lr
a047eeb8 b800c5e1 strh     r0, [r5, #8]
a047eebc bc03d3e1 ldrh     r0, [r3, #0x3c]
a047eec0 001081e0 add      r1, r1, r0
a047eec4 ba10c5e1 strh     r1, [r5, #0xa]
a047eec8 bc13d3e1 ldrh     r1, [r3, #0x3c]
a047eecc 012082e0 add      r2, r2, r1
a047eed0 bc20c5e1 strh     r2, [r5, #0xc]
a047eed4 b420d3e1 ldrh     r2, [r3, #4]
a047eed8 010c52e3 cmp      r2, #0x100
a047eedc 6700000a beq      #0xa047f080
a047eee0 0210dce5 ldrb     r1, [ip, #2]
a047eee4 0120dce5 ldrb     r2, [ip, #1]
a047eee8 011482e1 orr      r1, r2, r1, lsl #8
a047eeec b210c5e1 strh     r1, [r5, #2]
a047eef0 0400dce5 ldrb     r0, [ip, #4]
a047eef4 0320dce5 ldrb     r2, [ip, #3]
a047eef8 000482e1 orr      r0, r2, r0, lsl #8
a047eefc b000c5e1 strh     r0, [r5]
a047ef00 06c0d4e5 ldrb     ip, [r4, #6]
a047ef04 0520d4e5 ldrb     r2, [r4, #5]
a047ef08 0c2482e1 orr      r2, r2, ip, lsl #8
a047ef0c b420c5e1 strh     r2, [r5, #4]
a047ef10 bcc3d3e1 ldrh     ip, [r3, #0x3c]
a047ef14 0c0080e0 add      r0, r0, ip
a047ef18 b000c5e1 strh     r0, [r5]
a047ef1c bc03d3e1 ldrh     r0, [r3, #0x3c]
a047ef20 001081e0 add      r1, r1, r0
a047ef24 0000a0e3 mov      r0, #0
a047ef28 b210c5e1 strh     r1, [r5, #2]
a047ef2c bc33d3e1 ldrh     r3, [r3, #0x3c]
a047ef30 032082e0 add      r2, r2, r3
a047ef34 b420c5e1 strh     r2, [r5, #4]
a047ef38 14d08de2 add      sp, sp, #0x14
a047ef3c 3080bde8 pop      {r4, r5, pc}
a047ef40 104605e3 movw     r4, #0x5610
a047ef44 10308de2 add      r3, sp, #0x10
a047ef48 7320e0e3 mvn      r2, #0x73
a047ef4c facfa0e3 mov      ip, #0x3e8
a047ef50 a3414ae3 movt     r4, #0xa1a3
a047ef54 b0100be3 movw     r1, #0xb0b0
a047ef58 00408de5 str      r4, [sp]
a047ef5c 78104ae3 movt     r1, #0xa078
a047ef60 012063e5 strb     r2, [r3, #-1]!
a047ef64 0720a0e3 mov      r2, #7
a047ef68 04c08de5 str      ip, [sp, #4]
a047ef6c 6e3c00eb bl       #0xa048e12c
a047ef70 ac3505e3 movw     r3, #0x55ac
a047ef74 a3314ae3 movt     r3, #0xa1a3
a047ef78 b420d3e1 ldrh     r2, [r3, #4]
a047ef7c 010c52e3 cmp      r2, #0x100
a047ef80 4700000a beq      #0xa047f0a4
a047ef84 0210d4e5 ldrb     r1, [r4, #2]
a047ef88 0120d4e5 ldrb     r2, [r4, #1]
a047ef8c 011482e1 orr      r1, r2, r1, lsl #8
a047ef90 b210c5e1 strh     r1, [r5, #2]
a047ef94 0400d4e5 ldrb     r0, [r4, #4]
a047ef98 0320d4e5 ldrb     r2, [r4, #3]
a047ef9c 000482e1 orr      r0, r2, r0, lsl #8
a047efa0 b000c5e1 strh     r0, [r5]
a047efa4 d5ffffea b        #0xa047ef00
a047efa8 104605e3 movw     r4, #0x5610
a047efac 10308de2 add      r3, sp, #0x10
a047efb0 7300e0e3 mvn      r0, #0x73
a047efb4 fa2fa0e3 mov      r2, #0x3e8
a047efb8 a3414ae3 movt     r4, #0xa1a3
a047efbc b0100be3 movw     r1, #0xb0b0
a047efc0 00408de5 str      r4, [sp]
a047efc4 78104ae3 movt     r1, #0xa078
a047efc8 010063e5 strb     r0, [r3, #-1]!
a047efcc 0100a0e3 mov      r0, #1
a047efd0 04208de5 str      r2, [sp, #4]
a047efd4 1020a0e3 mov      r2, #0x10
a047efd8 533c00eb bl       #0xa048e12c
a047efdc ac3505e3 movw     r3, #0x55ac
a047efe0 a3314ae3 movt     r3, #0xa1a3
a047efe4 b822d3e1 ldrh     r2, [r3, #0x28]
a047efe8 010052e3 cmp      r2, #1
a047efec 3500000a beq      #0xa047f0c8
a047eff0 0810d4e5 ldrb     r1, [r4, #8]
a047eff4 0720d4e5 ldrb     r2, [r4, #7]
a047eff8 0900d4e5 ldrb     r0, [r4, #9]
a047effc 011482e1 orr      r1, r2, r1, lsl #8
a047f000 ba10c5e1 strh     r1, [r5, #0xa]
a047f004 0a20d4e5 ldrb     r2, [r4, #0xa]
a047f008 020480e1 orr      r0, r0, r2, lsl #8
a047f00c b800c5e1 strh     r0, [r5, #8]
a047f010 0cc0d4e5 ldrb     ip, [r4, #0xc]
a047f014 0b20d4e5 ldrb     r2, [r4, #0xb]
a047f018 0c2482e1 orr      r2, r2, ip, lsl #8
a047f01c bc20c5e1 strh     r2, [r5, #0xc]
a047f020 bcc3d3e1 ldrh     ip, [r3, #0x3c]
a047f024 0c0080e0 add      r0, r0, ip
a047f028 b800c5e1 strh     r0, [r5, #8]
a047f02c bc03d3e1 ldrh     r0, [r3, #0x3c]
a047f030 001081e0 add      r1, r1, r0
a047f034 0000a0e3 mov      r0, #0
a047f038 ba10c5e1 strh     r1, [r5, #0xa]
a047f03c bc33d3e1 ldrh     r3, [r3, #0x3c]
a047f040 032082e0 add      r2, r2, r3
a047f044 bc20c5e1 strh     r2, [r5, #0xc]
a047f048 14d08de2 add      sp, sp, #0x14
a047f04c 3080bde8 pop      {r4, r5, pc}
a047f050 ba22d3e1 ldrh     r2, [r3, #0x2a]
a047f054 000052e3 cmp      r2, #0
a047f058 86ffff1a bne      #0xa047ee78
a047f05c 0800d4e5 ldrb     r0, [r4, #8]
a047f060 0720d4e5 ldrb     r2, [r4, #7]
a047f064 000482e1 orr      r0, r2, r0, lsl #8
a047f068 b800c5e1 strh     r0, [r5, #8]
a047f06c 0a10d4e5 ldrb     r1, [r4, #0xa]
a047f070 0920d4e5 ldrb     r2, [r4, #9]
a047f074 011482e1 orr      r1, r2, r1, lsl #8
a047f078 ba10c5e1 strh     r1, [r5, #0xa]
a047f07c 85ffffea b        #0xa047ee98
a047f080 0200dce5 ldrb     r0, [ip, #2]
a047f084 0120dce5 ldrb     r2, [ip, #1]
a047f088 000482e1 orr      r0, r2, r0, lsl #8
a047f08c b000c5e1 strh     r0, [r5]
a047f090 0410dce5 ldrb     r1, [ip, #4]
a047f094 0320dce5 ldrb     r2, [ip, #3]
a047f098 011482e1 orr      r1, r2, r1, lsl #8
a047f09c b210c5e1 strh     r1, [r5, #2]
a047f0a0 96ffffea b        #0xa047ef00
a047f0a4 0200d4e5 ldrb     r0, [r4, #2]
a047f0a8 0120d4e5 ldrb     r2, [r4, #1]
a047f0ac 000482e1 orr      r0, r2, r0, lsl #8
a047f0b0 b000c5e1 strh     r0, [r5]
a047f0b4 0410d4e5 ldrb     r1, [r4, #4]
a047f0b8 0320d4e5 ldrb     r2, [r4, #3]
a047f0bc 011482e1 orr      r1, r2, r1, lsl #8
a047f0c0 b210c5e1 strh     r1, [r5, #2]
a047f0c4 8dffffea b        #0xa047ef00
a047f0c8 ba22d3e1 ldrh     r2, [r3, #0x2a]
a047f0cc 000052e3 cmp      r2, #0
a047f0d0 c6ffff1a bne      #0xa047eff0
a047f0d4 0800d4e5 ldrb     r0, [r4, #8]
a047f0d8 0720d4e5 ldrb     r2, [r4, #7]
a047f0dc 000482e1 orr      r0, r2, r0, lsl #8
a047f0e0 b800c5e1 strh     r0, [r5, #8]
a047f0e4 0a10d4e5 ldrb     r1, [r4, #0xa]
a047f0e8 0920d4e5 ldrb     r2, [r4, #9]
a047f0ec 011482e1 orr      r1, r2, r1, lsl #8
a047f0f0 ba10c5e1 strh     r1, [r5, #0xa]
a047f0f4 c5ffffea b        #0xa047f010
a047f0f8 70402de9 push     {r4, r5, r6, lr}
a047f0fc 10d04de2 sub      sp, sp, #0x10
a047f100 7fc0e0e3 mvn      ip, #0x7f
a047f104 10308de2 add      r3, sp, #0x10
a047f108 0e008de2 add      r0, sp, #0xe
a047f10c 322ea0e3 mov      r2, #0x320
a047f110 b0100be3 movw     r1, #0xb0b0
a047f114 05c063e5 strb     ip, [r3, #-5]!
a047f118 78104ae3 movt     r1, #0xa078
a047f11c 05008de8 stm      sp, {r0, r2}
a047f120 0040a0e3 mov      r4, #0
a047f124 0220a0e3 mov      r2, #2
a047f128 0100a0e3 mov      r0, #1
a047f12c be40cde1 strh     r4, [sp, #0xe]
a047f130 fd3b00eb bl       #0xa048e12c
a047f134 0f20dde5 ldrb     r2, [sp, #0xf]
a047f138 d10052e3 cmp      r2, #0xd1
a047f13c 4a00001a bne      #0xa047f26c
a047f140 fa5fa0e3 mov      r5, #0x3e8
a047f144 b0100be3 movw     r1, #0xb0b0
a047f148 11c0a0e3 mov      ip, #0x11
a047f14c 0c308de2 add      r3, sp, #0xc
a047f150 78104ae3 movt     r1, #0xa078
a047f154 0220a0e3 mov      r2, #2
a047f158 7e60a0e3 mov      r6, #0x7e
a047f15c 00408de5 str      r4, [sp]
a047f160 04508de5 str      r5, [sp, #4]
a047f164 0100a0e3 mov      r0, #1
a047f168 0dc0cde5 strb     ip, [sp, #0xd]
a047f16c 0c60cde5 strb     r6, [sp, #0xc]
a047f170 ed3b00eb bl       #0xa048e12c
a047f174 0500a0e3 mov      r0, #5
a047f178 68f4fceb bl       #0xa03bc320
a047f17c b0100be3 movw     r1, #0xb0b0
a047f180 15c0a0e3 mov      ip, #0x15
a047f184 0c308de2 add      r3, sp, #0xc
a047f188 78104ae3 movt     r1, #0xa078
a047f18c 0220a0e3 mov      r2, #2
a047f190 30008de8 stm      sp, {r4, r5}
a047f194 0100a0e3 mov      r0, #1
a047f198 0dc0cde5 strb     ip, [sp, #0xd]
a047f19c 0c60cde5 strb     r6, [sp, #0xc]
a047f1a0 e13b00eb bl       #0xa048e12c
a047f1a4 0500a0e3 mov      r0, #5
a047f1a8 5cf4fceb bl       #0xa03bc320
a047f1ac b0100be3 movw     r1, #0xb0b0
a047f1b0 40e0a0e3 mov      lr, #0x40
a047f1b4 2cc0a0e3 mov      ip, #0x2c
a047f1b8 0c308de2 add      r3, sp, #0xc
a047f1bc 78104ae3 movt     r1, #0xa078
a047f1c0 0220a0e3 mov      r2, #2
a047f1c4 30008de8 stm      sp, {r4, r5}
a047f1c8 0100a0e3 mov      r0, #1
a047f1cc 0ce0cde5 strb     lr, [sp, #0xc]
a047f1d0 0dc0cde5 strb     ip, [sp, #0xd]
a047f1d4 d43b00eb bl       #0xa048e12c
a047f1d8 b0100be3 movw     r1, #0xb0b0
a047f1dc 41e0a0e3 mov      lr, #0x41
a047f1e0 08c0a0e3 mov      ip, #8
a047f1e4 0c308de2 add      r3, sp, #0xc
a047f1e8 78104ae3 movt     r1, #0xa078
a047f1ec 0220a0e3 mov      r2, #2
a047f1f0 30008de8 stm      sp, {r4, r5}
a047f1f4 0100a0e3 mov      r0, #1
a047f1f8 0ce0cde5 strb     lr, [sp, #0xc]
a047f1fc 0dc0cde5 strb     ip, [sp, #0xd]
a047f200 c93b00eb bl       #0xa048e12c
a047f204 b0100be3 movw     r1, #0xb0b0
a047f208 42e0a0e3 mov      lr, #0x42
a047f20c 0dc0a0e3 mov      ip, #0xd
a047f210 0c308de2 add      r3, sp, #0xc
a047f214 78104ae3 movt     r1, #0xa078
a047f218 0220a0e3 mov      r2, #2
a047f21c 30008de8 stm      sp, {r4, r5}
a047f220 0100a0e3 mov      r0, #1
a047f224 0ce0cde5 strb     lr, [sp, #0xc]
a047f228 0dc0cde5 strb     ip, [sp, #0xd]
a047f22c be3b00eb bl       #0xa048e12c
a047f230 b0100be3 movw     r1, #0xb0b0
a047f234 43e0a0e3 mov      lr, #0x43
a047f238 03c0a0e3 mov      ip, #3
a047f23c 04508de5 str      r5, [sp, #4]
a047f240 0c308de2 add      r3, sp, #0xc
a047f244 00408de5 str      r4, [sp]
a047f248 78104ae3 movt     r1, #0xa078
a047f24c 0100a0e3 mov      r0, #1
a047f250 0220a0e3 mov      r2, #2
a047f254 0ce0cde5 strb     lr, [sp, #0xc]
a047f258 0dc0cde5 strb     ip, [sp, #0xd]
a047f25c b23b00eb bl       #0xa048e12c
a047f260 0400a0e1 mov      r0, r4
a047f264 10d08de2 add      sp, sp, #0x10
a047f268 7080bde8 pop      {r4, r5, r6, pc}
a047f26c b00808e3 movw     r0, #0x88b0
a047f270 d110a0e3 mov      r1, #0xd1
a047f274 62004ae3 movt     r0, #0xa062
a047f278 9b9ff8eb bl       #0xa02a70ec
a047f27c e40808e3 movw     r0, #0x88e4
a047f280 62004ae3 movt     r0, #0xa062
a047f284 989ff8eb bl       #0xa02a70ec
a047f288 0c3605e3 movw     r3, #0x560c
a047f28c 0020e0e3 mvn      r2, #0
a047f290 a3314ae3 movt     r3, #0xa1a3
a047f294 0200a0e1 mov      r0, r2
a047f298 b020c3e1 strh     r2, [r3]
a047f29c f0ffffea b        #0xa047f264
