a0476bb4 f0432de9 push {r4, r5, r6, r7, r8, sb, lr}
a0476bb8 e44b00e3 movw r4, #0xbe4
a0476bbc a3414ae3 movt r4, #0xa1a3
a0476bc0 0030a0e3 mov r3, #0
a0476bc4 24d04de2 sub sp, sp, #0x24
a0476bc8 0050a0e1 mov r5, r0
a0476bcc 0020d4e5 ldrb r2, [r4]
a0476bd0 0160a0e1 mov r6, r1
a0476bd4 10308de5 str r3, [sp, #0x10]
a0476bd8 14308de5 str r3, [sp, #0x14]
a0476bdc 030052e1 cmp r2, r3
a0476be0 4e00000a beq #0xa0476d20
a0476be4 000056e3 cmp r6, #0
a0476be8 00005513 cmpne r5, #0
a0476bec 4800000a beq #0xa0476d14
a0476bf0 007095e5 ldr r7, [r5]
a0476bf4 000057e3 cmp r7, #0
a0476bf8 4d00000a beq #0xa0476d34
a0476bfc 010057e3 cmp r7, #1
a0476c00 4300001a bne #0xa0476d14
a0476c04 a03202e3 movw r3, #0x22a0
a0476c08 6f304ae3 movt r3, #0xa06f
a0476c0c 003093e5 ldr r3, [r3]
a0476c10 000053e3 cmp r3, #0
a0476c14 b100000a beq #0xa0476ee0
a0476c18 188c00e3 movw r8, #0xc18
a0476c1c a3814ae3 movt r8, #0xa1a3
a0476c20 003098e5 ldr r3, [r8]
a0476c24 000053e3 cmp r3, #0
a0476c28 7900001a bne #0xa0476e14
a0476c2c 080095e5 ldr r0, [r5, #8]
a0476c30 149c00e3 movw sb, #0xc14
a0476c34 a759fdeb bl #0xa03cd2d8
a0476c38 000050e3 cmp r0, #0
a0476c3c a3914ae3 movt sb, #0xa1a3
a0476c40 000089e5 str r0, [sb]
a0476c44 ae00000a beq #0xa0476f04
a0476c48 0230a0e3 mov r3, #2
a0476c4c 1000a0e3 mov r0, #0x10
a0476c50 18308de5 str r3, [sp, #0x18]
a0476c54 9f59fdeb bl #0xa03cd2d8
a0476c58 0030a0e1 mov r3, r0
a0476c5c 481b07e3 movw r1, #0x7b48
a0476c60 1c308de5 str r3, [sp, #0x1c]
a0476c64 47104ae3 movt r1, #0xa047
a0476c68 047083e5 str r7, [r3, #4]
a0476c6c 9c3b07e3 movw r3, #0x7b9c
a0476c70 1cc09de5 ldr ip, [sp, #0x1c]
a0476c74 47304ae3 movt r3, #0xa047
a0476c78 009099e5 ldr sb, [sb]
a0476c7c 18e08de2 add lr, sp, #0x18
a0476c80 102b05e3 movw r2, #0x5b10
a0476c84 5102a0e3 mov r0, #0x10000005
a0476c88 00108ce5 str r1, [ip]
a0476c8c 62204ae3 movt r2, #0xa062
a0476c90 1cc09de5 ldr ip, [sp, #0x1c]
a0476c94 0710a0e1 mov r1, r7
a0476c98 0c708ce5 str r7, [ip, #0xc]
a0476c9c 08308ce5 str r3, [ip, #8]
a0476ca0 081095e9 ldmib r5, {r3, ip}
a0476ca4 00908de5 str sb, [sp]
a0476ca8 0c708de5 str r7, [sp, #0xc]
a0476cac 00508de9 stmib sp, {ip, lr}
a0476cb0 7f4ffdeb bl #0xa03caab4
a0476cb4 005050e2 subs r5, r0, #0
a0476cb8 5800001a bne #0xa0476e20
a0476cbc 1c009de5 ldr r0, [sp, #0x1c]
a0476cc0 6759fdeb bl #0xa03cd264
a0476cc4 540b05e3 movw r0, #0x5b54
a0476cc8 62004ae3 movt r0, #0xa062
a0476ccc 8d0a00eb bl #0xa0479708
a0476cd0 009050e2 subs sb, r0, #0
a0476cd4 780000ba blt #0xa0476ebc
a0476cd8 0500a0e1 mov r0, r5
a0476cdc 0720a0e1 mov r2, r7
a0476ce0 5212a0e3 mov r1, #0x20000005
a0476ce4 6a38fdeb bl #0xa03c4e94
a0476ce8 103c00e3 movw r3, #0xc10
a0476cec 000050e3 cmp r0, #0
a0476cf0 a3314ae3 movt r3, #0xa1a3
a0476cf4 000083e5 str r0, [r3]
a0476cf8 7a00000a beq #0xa0476ee8
a0476cfc 0030d4e5 ldrb r3, [r4]
a0476d00 010053e3 cmp r3, #1
a0476d04 5000000a beq #0xa0476e4c
a0476d08 0000e0e3 mvn r0, #0
a0476d0c 24d08de2 add sp, sp, #0x24
a0476d10 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a0476d14 0200e0e3 mvn r0, #2
a0476d18 24d08de2 add sp, sp, #0x24
a0476d1c f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a0476d20 33fdffeb bl #0xa04761f4
a0476d24 000050e3 cmp r0, #0
a0476d28 adffffaa bge #0xa0476be4
a0476d2c 24d08de2 add sp, sp, #0x24
a0476d30 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a0476d34 fc7b00e3 movw r7, #0xbfc
a0476d38 a3714ae3 movt r7, #0xa1a3
a0476d3c 009097e5 ldr sb, [r7]
a0476d40 000059e3 cmp sb, #0
a0476d44 3200001a bne #0xa0476e14
a0476d48 0030d4e5 ldrb r3, [r4]
a0476d4c e48b00e3 movw r8, #0xbe4
a0476d50 a3814ae3 movt r8, #0xa1a3
a0476d54 010053e3 cmp r3, #1
a0476d58 eaffff1a bne #0xa0476d08
a0476d5c 040098e5 ldr r0, [r8, #4]
a0476d60 72f3ffeb bl #0xa0473b30
a0476d64 000050e3 cmp r0, #0
a0476d68 eaffffba blt #0xa0476d18
a0476d6c 10008de2 add r0, sp, #0x10
a0476d70 14108de2 add r1, sp, #0x14
a0476d74 0820a0e3 mov r2, #8
a0476d78 2030a0e3 mov r3, #0x20
a0476d7c 70f3ffeb bl #0xa0473b44
a0476d80 000050e3 cmp r0, #0
a0476d84 e3ffffba blt #0xa0476d18
a0476d88 14109de5 ldr r1, [sp, #0x14]
a0476d8c dc3b00e3 movw r3, #0xbdc
a0476d90 a3314ae3 movt r3, #0xa1a3
a0476d94 10e09de5 ldr lr, [sp, #0x10]
a0476d98 003093e5 ldr r3, [r3]
a0476d9c 102085e2 add r2, r5, #0x10
a0476da0 009081e5 str sb, [r1]
a0476da4 d8cb00e3 movw ip, #0xbd8
a0476da8 041086e5 str r1, [r6, #4]
a0476dac a3c14ae3 movt ip, #0xa1a3
a0476db0 009086e5 str sb, [r6]
a0476db4 145095e5 ldr r5, [r5, #0x14]
a0476db8 0c4098e5 ldr r4, [r8, #0xc]
a0476dbc 001087e5 str r1, [r7]
a0476dc0 055083e0 add r5, r3, r5
a0476dc4 040098e5 ldr r0, [r8, #4]
a0476dc8 083044e2 sub r3, r4, #8
a0476dcc 0510a0e1 mov r1, r5
a0476dd0 0c3088e5 str r3, [r8, #0xc]
a0476dd4 00e08ce5 str lr, [ip]
a0476dd8 8d0400eb bl #0xa0478014
a0476ddc 0c3098e5 ldr r3, [r8, #0xc]
a0476de0 004050e2 subs r4, r0, #0
a0476de4 0400a0a1 movge r0, r4
a0476de8 035065e0 rsb r5, r5, r3
a0476dec 0c5088e5 str r5, [r8, #0xc]
a0476df0 c8ffffaa bge #0xa0476d18
a0476df4 e40a05e3 movw r0, #0x5ae4
a0476df8 141305e3 movw r1, #0x5314
a0476dfc 62004ae3 movt r0, #0xa062
a0476e00 62104ae3 movt r1, #0xa062
a0476e04 2f2400e3 movw r2, #0x42f
a0476e08 b7c0f8eb bl #0xa02a70ec
a0476e0c 0400a0e1 mov r0, r4
a0476e10 c0ffffea b #0xa0476d18
a0476e14 0500e0e3 mvn r0, #5
a0476e18 24d08de2 add sp, sp, #0x24
a0476e1c f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a0476e20 280b05e3 movw r0, #0x5b28
a0476e24 141305e3 movw r1, #0x5314
a0476e28 62104ae3 movt r1, #0xa062
a0476e2c 452ea0e3 mov r2, #0x450
a0476e30 0530a0e1 mov r3, r5
a0476e34 62004ae3 movt r0, #0xa062
a0476e38 abc0f8eb bl #0xa02a70ec
a0476e3c 1c009de5 ldr r0, [sp, #0x1c]
a0476e40 0759fdeb bl #0xa03cd264
a0476e44 0500a0e1 mov r0, r5
a0476e48 b2ffffea b #0xa0476d18
a0476e4c 040094e5 ldr r0, [r4, #4]
a0476e50 e44b00e3 movw r4, #0xbe4
a0476e54 35f3ffeb bl #0xa0473b30
a0476e58 000050e3 cmp r0, #0
a0476e5c a3414ae3 movt r4, #0xa1a3
a0476e60 acffffba blt #0xa0476d18
a0476e64 10008de2 add r0, sp, #0x10
a0476e68 14108de2 add r1, sp, #0x14
a0476e6c 0820a0e3 mov r2, #8
a0476e70 2030a0e3 mov r3, #0x20
a0476e74 32f3ffeb bl #0xa0473b44
a0476e78 000050e3 cmp r0, #0
a0476e7c a5ffffba blt #0xa0476d18
a0476e80 0c2094e5 ldr r2, [r4, #0xc]
a0476e84 cc1b00e3 movw r1, #0xbcc
a0476e88 14309de5 ldr r3, [sp, #0x14]
a0476e8c 00c0a0e3 mov ip, #0
a0476e90 10509de5 ldr r5, [sp, #0x10]
a0476e94 a3114ae3 movt r1, #0xa1a3
a0476e98 01e0a0e3 mov lr, #1
a0476e9c 082042e2 sub r2, r2, #8
a0476ea0 00c083e5 str ip, [r3]
a0476ea4 003088e5 str r3, [r8]
a0476ea8 005081e5 str r5, [r1]
a0476eac 0c2084e5 str r2, [r4, #0xc]
a0476eb0 043086e5 str r3, [r6, #4]
a0476eb4 00e086e5 str lr, [r6]
a0476eb8 96ffffea b #0xa0476d18
a0476ebc 740b05e3 movw r0, #0x5b74
a0476ec0 141305e3 movw r1, #0x5314
a0476ec4 62004ae3 movt r0, #0xa062
a0476ec8 62104ae3 movt r1, #0xa062
a0476ecc 582400e3 movw r2, #0x458
a0476ed0 0930a0e1 mov r3, sb
a0476ed4 84c0f8eb bl #0xa02a70ec
a0476ed8 0900a0e1 mov r0, sb
a0476edc 8dffffea b #0xa0476d18
a0476ee0 0300e0e3 mvn r0, #3
a0476ee4 8bffffea b #0xa0476d18
a0476ee8 480705e3 movw r0, #0x5748
a0476eec 141305e3 movw r1, #0x5314
a0476ef0 62104ae3 movt r1, #0xa062
a0476ef4 5e2400e3 movw r2, #0x45e
a0476ef8 62004ae3 movt r0, #0xa062
a0476efc 7ac0f8eb bl #0xa02a70ec
a0476f00 80ffffea b #0xa0476d08
a0476f04 280605e3 movw r0, #0x5628
a0476f08 141305e3 movw r1, #0x5314
a0476f0c 62004ae3 movt r0, #0xa062
a0476f10 62104ae3 movt r1, #0xa062
a0476f14 422400e3 movw r2, #0x442
a0476f18 73c0f8eb bl #0xa02a70ec
a0476f1c 0000e0e3 mvn r0, #0
a0476f20 7cffffea b #0xa0476d18
