a0247e54 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0247e58 c4d04de2 sub sp, sp, #0xc4
a0247e5c 0040a0e3 mov r4, #0
a0247e60 10008de5 str r0, [sp, #0x10]
a0247e64 40ad03e3 movw sl, #0x3d40
a0247e68 0100a0e1 mov r0, r1
a0247e6c 20508de2 add r5, sp, #0x20
a0247e70 14108de5 str r1, [sp, #0x14]
a0247e74 44a14ae3 movt sl, #0xa144
a0247e78 18408de5 str r4, [sp, #0x18]
a0247e7c 1c408de5 str r4, [sp, #0x1c]
a0247e80 7c9003e3 movw sb, #0x307c
a0247e84 131506eb bl #0xa03cd2d8
a0247e88 608008e3 movw r8, #0x8060
a0247e8c 0430a0e3 mov r3, #4
a0247e90 cc2108e3 movw r2, #0x81cc
a0247e94 707008e3 movw r7, #0x8070
a0247e98 f06108e3 movw r6, #0x81f0
a0247e9c 6f904ae3 movt sb, #0xa06f
a0247ea0 5a804ae3 movt r8, #0xa05a
a0247ea4 5a704ae3 movt r7, #0xa05a
a0247ea8 5a604ae3 movt r6, #0xa05a
a0247eac 00008ae5 str r0, [sl]
a0247eb0 00308de5 str r3, [sp]
a0247eb4 5a204ae3 movt r2, #0xa05a
a0247eb8 0500a0e1 mov r0, r5
a0247ebc a010a0e3 mov r1, #0xa0
a0247ec0 ff30a0e3 mov r3, #0xff
a0247ec4 01b0a0e3 mov fp, #1
a0247ec8 3dc50afa blx #0xa04f93c4
a0247ecc 081099e5 ldr r1, [sb, #8]
a0247ed0 0630a0e1 mov r3, r6
a0247ed4 00508de5 str r5, [sp]
a0247ed8 0720a0e1 mov r2, r7
a0247edc 0800a0e1 mov r0, r8
a0247ee0 bf40cde5 strb r4, [sp, #0xbf]
a0247ee4 807c01eb bl #0xa02a70ec
a0247ee8 0320a0e3 mov r2, #3
a0247eec 1800a0e3 mov r0, #0x18
a0247ef0 18208de5 str r2, [sp, #0x18]
a0247ef4 f71406eb bl #0xa03cd2d8
a0247ef8 f82108e3 movw r2, #0x81f8
a0247efc 1c008de5 str r0, [sp, #0x1c]
a0247f00 00b08de5 str fp, [sp]
a0247f04 0500a0e1 mov r0, r5
a0247f08 5a204ae3 movt r2, #0xa05a
a0247f0c a010a0e3 mov r1, #0xa0
a0247f10 033100e3 movw r3, #0x103
a0247f14 2ac50afa blx #0xa04f93c4
a0247f18 081099e5 ldr r1, [sb, #8]
a0247f1c 0720a0e1 mov r2, r7
a0247f20 00508de5 str r5, [sp]
a0247f24 0630a0e1 mov r3, r6
a0247f28 0800a0e1 mov r0, r8
a0247f2c bf40cde5 strb r4, [sp, #0xbf]
a0247f30 6d7c01eb bl #0xa02a70ec
a0247f34 1c109de5 ldr r1, [sp, #0x1c]
a0247f38 203a07e3 movw r3, #0x7a20
a0247f3c 02c0a0e3 mov ip, #2
a0247f40 24304ae3 movt r3, #0xa024
a0247f44 242208e3 movw r2, #0x8224
a0247f48 0500a0e1 mov r0, r5
a0247f4c 044081e5 str r4, [r1, #4]
a0247f50 5a204ae3 movt r2, #0xa05a
a0247f54 1ce09de5 ldr lr, [sp, #0x1c]
a0247f58 a010a0e3 mov r1, #0xa0
a0247f5c 00308ee5 str r3, [lr]
a0247f60 423fa0e3 mov r3, #0x108
a0247f64 00c08de5 str ip, [sp]
a0247f68 15c50afa blx #0xa04f93c4
a0247f6c 081099e5 ldr r1, [sb, #8]
a0247f70 0720a0e1 mov r2, r7
a0247f74 00508de5 str r5, [sp]
a0247f78 0630a0e1 mov r3, r6
a0247f7c 0800a0e1 mov r0, r8
a0247f80 bf40cde5 strb r4, [sp, #0xbf]
a0247f84 587c01eb bl #0xa02a70ec
a0247f88 1cc09de5 ldr ip, [sp, #0x1c]
a0247f8c 0c3408e3 movw r3, #0x840c
a0247f90 03e0a0e3 mov lr, #3
a0247f94 24304ae3 movt r3, #0xa024
a0247f98 482208e3 movw r2, #0x8248
a0247f9c 0500a0e1 mov r0, r5
a0247fa0 08308ce5 str r3, [ip, #8]
a0247fa4 5a204ae3 movt r2, #0xa05a
a0247fa8 0c408ce5 str r4, [ip, #0xc]
a0247fac a010a0e3 mov r1, #0xa0
a0247fb0 00e08de5 str lr, [sp]
a0247fb4 0d3100e3 movw r3, #0x10d
a0247fb8 01c50afa blx #0xa04f93c4
a0247fbc 081099e5 ldr r1, [sb, #8]
a0247fc0 0720a0e1 mov r2, r7
a0247fc4 0630a0e1 mov r3, r6
a0247fc8 00508de5 str r5, [sp]
a0247fcc 0800a0e1 mov r0, r8
a0247fd0 bf40cde5 strb r4, [sp, #0xbf]
a0247fd4 447c01eb bl #0xa02a70ec
a0247fd8 1cc09de5 ldr ip, [sp, #0x1c]
a0247fdc f40807e3 movw r0, #0x78f4
a0247fe0 24004ae3 movt r0, #0xa024
a0247fe4 00509ae5 ldr r5, [sl]
a0247fe8 18e08de2 add lr, sp, #0x18
a0247fec 702208e3 movw r2, #0x8270
a0247ff0 10008ce5 str r0, [ip, #0x10]
a0247ff4 0b10a0e1 mov r1, fp
a0247ff8 14408ce5 str r4, [ip, #0x14]
a0247ffc 5a204ae3 movt r2, #0xa05a
a0248000 14c09de5 ldr ip, [sp, #0x14]
a0248004 c102a0e3 mov r0, #0x1000000c
a0248008 10309de5 ldr r3, [sp, #0x10]
a024800c 08e08de5 str lr, [sp, #8]
a0248010 20108de8 stm sp, {r5, ip}
a0248014 0cb08de5 str fp, [sp, #0xc]
a0248018 a50a06eb bl #0xa03caab4
a024801c 1c009de5 ldr r0, [sp, #0x1c]
a0248020 8f1406eb bl #0xa03cd264
a0248024 0400a0e1 mov r0, r4
a0248028 c4d08de2 add sp, sp, #0xc4
a024802c f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
