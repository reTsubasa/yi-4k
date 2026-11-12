a020cf14 f0402de9 push {r4, r5, r6, r7, lr}
a020cf18 e04b04e3 movw r4, #0x4be0
a020cf1c 3c414ae3 movt r4, #0xa13c
a020cf20 0030a0e3 mov r3, #0
a020cf24 44d04de2 sub sp, sp, #0x44
a020cf28 002094e5 ldr r2, [r4]
a020cf2c 28308de5 str r3, [sp, #0x28]
a020cf30 2c308de5 str r3, [sp, #0x2c]
a020cf34 030052e1 cmp r2, r3
a020cf38 30308de5 str r3, [sp, #0x30]
a020cf3c 34308de5 str r3, [sp, #0x34]
a020cf40 38308de5 str r3, [sp, #0x38]
a020cf44 5e00000a beq #0xa020d0c4
a020cf48 b43b04e3 movw r3, #0x4bb4
a020cf4c 0200a0e1 mov r0, r2
a020cf50 3c314ae3 movt r3, #0xa13c
a020cf54 2510a0e3 mov r1, #0x25
a020cf58 002083e5 str r2, [r3]
a020cf5c a71a09eb bl #0xa0453a00
a020cf60 004050e2 subs r4, r0, #0
a020cf64 0c00000a beq #0xa020cf9c
a020cf68 7c3003e3 movw r3, #0x307c
a020cf6c 50030de3 movw r0, #0xd350
a020cf70 6f304ae3 movt r3, #0xa06f
a020cf74 04250ee3 movw r2, #0xe504
a020cf78 041093e5 ldr r1, [r3, #4]
a020cf7c 58004ae3 movt r0, #0xa058
a020cf80 00408de5 str r4, [sp]
a020cf84 58204ae3 movt r2, #0xa058
a020cf88 e93100e3 movw r3, #0x1e9
a020cf8c 566802eb bl #0xa02a70ec
a020cf90 0400a0e1 mov r0, r4
a020cf94 44d08de2 add sp, sp, #0x44
a020cf98 f080bde8 pop {r4, r5, r6, r7, pc}
a020cf9c 28008de2 add r0, sp, #0x28
a020cfa0 a02409eb bl #0xa0456228
a020cfa4 004050e2 subs r4, r0, #0
a020cfa8 3800001a bne #0xa020d090
a020cfac 185c06e3 movw r5, #0x6c18
a020cfb0 3c514ae3 movt r5, #0xa13c
a020cfb4 00c095e5 ldr ip, [r5]
a020cfb8 00005ce3 cmp ip, #0
a020cfbc 0c00000a beq #0xa020cff4
a020cfc0 7c3003e3 movw r3, #0x307c
a020cfc4 e8030de3 movw r0, #0xd3e8
a020cfc8 6f304ae3 movt r3, #0xa06f
a020cfcc 04250ee3 movw r2, #0xe504
a020cfd0 041093e5 ldr r1, [r3, #4]
a020cfd4 58204ae3 movt r2, #0xa058
a020cfd8 00c08de5 str ip, [sp]
a020cfdc f53100e3 movw r3, #0x1f5
a020cfe0 58004ae3 movt r0, #0xa058
a020cfe4 406802eb bl #0xa02a70ec
a020cfe8 000095e5 ldr r0, [r5]
a020cfec c8bd06eb bl #0xa03bc714
a020cff0 004085e5 str r4, [r5]
a020cff4 e42302e3 movw r2, #0x23e4
a020cff8 2010a0e3 mov r1, #0x20
a020cffc 3a214ae3 movt r2, #0xa13a
a020d000 3c309de5 ldr r3, [sp, #0x3c]
a020d004 000092e5 ldr r0, [r2]
a020d008 182c06e3 movw r2, #0x6c18
a020d00c 00108de5 str r1, [sp]
a020d010 3c214ae3 movt r2, #0xa13c
a020d014 38108de2 add r1, sp, #0x38
a020d018 ee3502eb bl #0xa029a7d8
a020d01c 004050e2 subs r4, r0, #0
a020d020 0d00001a bne #0xa020d05c
a020d024 3320a0e3 mov r2, #0x33
a020d028 0130a0e3 mov r3, #1
a020d02c 28008de2 add r0, sp, #0x28
a020d030 2c208de5 str r2, [sp, #0x2c]
a020d034 34308de5 str r3, [sp, #0x34]
a020d038 892409eb bl #0xa0456264
a020d03c 004050e2 subs r4, r0, #0
a020d040 4e00001a bne #0xa020d180
a020d044 ec3404e3 movw r3, #0x44ec
a020d048 0400a0e1 mov r0, r4
a020d04c 6d304ae3 movt r3, #0xa06d
a020d050 004083e5 str r4, [r3]
a020d054 44d08de2 add sp, sp, #0x44
a020d058 f080bde8 pop {r4, r5, r6, r7, pc}
a020d05c 7c3003e3 movw r3, #0x307c
a020d060 64000be3 movw r0, #0xb064
a020d064 6f304ae3 movt r3, #0xa06f
a020d068 04250ee3 movw r2, #0xe504
a020d06c 041093e5 ldr r1, [r3, #4]
a020d070 58204ae3 movt r2, #0xa058
a020d074 00408de5 str r4, [sp]
a020d078 fb3100e3 movw r3, #0x1fb
a020d07c 58004ae3 movt r0, #0xa058
a020d080 196802eb bl #0xa02a70ec
a020d084 0400a0e1 mov r0, r4
a020d088 44d08de2 add sp, sp, #0x44
a020d08c f080bde8 pop {r4, r5, r6, r7, pc}
a020d090 7c3003e3 movw r3, #0x307c
a020d094 98030de3 movw r0, #0xd398
a020d098 6f304ae3 movt r3, #0xa06f
a020d09c 04250ee3 movw r2, #0xe504
a020d0a0 041093e5 ldr r1, [r3, #4]
a020d0a4 58204ae3 movt r2, #0xa058
a020d0a8 00408de5 str r4, [sp]
a020d0ac ef3100e3 movw r3, #0x1ef
a020d0b0 58004ae3 movt r0, #0xa058
a020d0b4 0c6802eb bl #0xa02a70ec
a020d0b8 0400a0e1 mov r0, r4
a020d0bc 44d08de2 add sp, sp, #0x44
a020d0c0 f080bde8 pop {r4, r5, r6, r7, pc}
a020d0c4 40508de2 add r5, sp, #0x40
a020d0c8 803b0be3 movw r3, #0xbb80
a020d0cc 183025e5 str r3, [r5, #-0x18]!
a020d0d0 0210a0e3 mov r1, #2
a020d0d4 1020a0e3 mov r2, #0x10
a020d0d8 013ca0e3 mov r3, #0x100
a020d0dc 0500a0e1 mov r0, r5
a020d0e0 2c108de5 str r1, [sp, #0x2c]
a020d0e4 34208de5 str r2, [sp, #0x34]
a020d0e8 30308de5 str r3, [sp, #0x30]
a020d0ec 711f02eb bl #0xa0294eb8
a020d0f0 0070a0e1 mov r7, r0
a020d0f4 0500a0e1 mov r0, r5
a020d0f8 9e1f02eb bl #0xa0294f78
a020d0fc e43302e3 movw r3, #0x23e4
a020d100 0060a0e1 mov r6, r0
a020d104 3a314ae3 movt r3, #0xa13a
a020d108 0720a0e1 mov r2, r7
a020d10c 18108de2 add r1, sp, #0x18
a020d110 000093e5 ldr r0, [r3]
a020d114 2030a0e3 mov r3, #0x20
a020d118 97bd06eb bl #0xa03bc77c
a020d11c f03302e3 movw r3, #0x23f0
a020d120 0620a0e1 mov r2, r6
a020d124 3a314ae3 movt r3, #0xa13a
a020d128 20108de2 add r1, sp, #0x20
a020d12c 000093e5 ldr r0, [r3]
a020d130 2030a0e3 mov r3, #0x20
a020d134 90bd06eb bl #0xa03bc77c
a020d138 1cc09de5 ldr ip, [sp, #0x1c]
a020d13c 38030de3 movw r0, #0xd338
a020d140 24309de5 ldr r3, [sp, #0x24]
a020d144 58004ae3 movt r0, #0xa058
a020d148 0c708de5 str r7, [sp, #0xc]
a020d14c 0c10a0e1 mov r1, ip
a020d150 08c08de5 str ip, [sp, #8]
a020d154 0320a0e1 mov r2, r3
a020d158 10308de5 str r3, [sp, #0x10]
a020d15c 14608de5 str r6, [sp, #0x14]
a020d160 e16702eb bl #0xa02a70ec
a020d164 10208de2 add r2, sp, #0x10
a020d168 0500a0e1 mov r0, r5
a020d16c 08108de2 add r1, sp, #8
a020d170 302002eb bl #0xa0295238
a020d174 0020a0e1 mov r2, r0
a020d178 000084e5 str r0, [r4]
a020d17c 71ffffea b #0xa020cf48
a020d180 7c3003e3 movw r3, #0x307c
a020d184 1c040de3 movw r0, #0xd41c
a020d188 6f304ae3 movt r3, #0xa06f
a020d18c 04250ee3 movw r2, #0xe504
a020d190 041093e5 ldr r1, [r3, #4]
a020d194 58204ae3 movt r2, #0xa058
a020d198 00408de5 str r4, [sp]
a020d19c 023200e3 movw r3, #0x202
a020d1a0 58004ae3 movt r0, #0xa058
a020d1a4 d06702eb bl #0xa02a70ec
a020d1a8 78ffffea b #0xa020cf90
