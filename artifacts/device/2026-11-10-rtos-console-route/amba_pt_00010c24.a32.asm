# Explicit A32 excerpt; not a complete mixed-mode ELF listing.
00010c24 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
00010c28 mov sb, r0
00010c2c ldr r3, [pc, #0x5b4]
00010c30 sub sp, sp, #0x3ec
00010c34 mov r8, r1
00010c38 add fp, sp, #0x24
00010c3c ldr lr, [pc, #0x5a8]
00010c40 mov ip, fp
00010c44 add r0, pc, r3
00010c48 mov r5, #0
00010c4c mov r6, r0
00010c50 str r0, [sp, #0x10]
00010c54 add sl, pc, lr
00010c58 ldr r6, [pc, #0x590]
00010c5c ldm sl!, {r0, r1, r2, r3}
00010c60 mov r7, r5
00010c64 add r6, pc, r6
00010c68 stm ip!, {r0, r1, r2, r3}
00010c6c ldm sl, {r0, r1, r2, r3}
00010c70 stm ip, {r0, r1, r2, r3}
00010c74 str r7, [sp]
00010c78 mov r3, fp
00010c7c mov r2, r6
00010c80 mov r1, r8
00010c84 mov r0, sb
00010c88 bl #0x10b40
00010c8c cmp r0, #0x66
00010c90 beq #0x10ca8
00010c94 cmp r0, #0x68
00010c98 beq #0x1103c
00010c9c cmn r0, #1
00010ca0 beq #0x10cb0
00010ca4 bl #0x10bf4
00010ca8 mov r5, #1
00010cac b #0x10c74
00010cb0 cmp r5, #0
00010cb4 beq #0x11068
00010cb8 ldr r2, [pc, #0x534]
00010cbc mov r1, #2
00010cc0 add r0, pc, r2
00010cc4 bl #0x10b04
00010cc8 ldr r1, [pc, #0x528]
00010ccc cmp r0, #0
00010cd0 add r4, pc, r1
00010cd4 str r0, [r4]
00010cd8 blt #0x11078
00010cdc mov r8, #1
00010ce0 mov r0, #8
00010ce4 str r8, [sp, #0x18]
00010ce8 add r7, sp, #0x18
00010cec bl #0x10b1c
00010cf0 ldr fp, [pc, #0x504]
00010cf4 mov sb, r0
00010cf8 ldr lr, [sp, #0x10]
00010cfc mov r0, #0x20000008
00010d00 str sb, [sp, #0x1c]
00010d04 mov r1, r8
00010d08 str r8, [sb, #4]
00010d0c mov r3, r7
00010d10 ldr sl, [pc, #0x4e8]
00010d14 ldr ip, [lr, fp]
00010d18 str r8, [sp]
00010d1c add r6, pc, sl
00010d20 mov r2, r6
00010d24 str ip, [sb]
00010d28 bl #0x10bac
00010d2c subs r2, r0, #0
00010d30 beq #0x10d74
00010d34 ldr r0, [pc, #0x4c8]
00010d38 ldr r4, [sp, #0x10]
00010d3c ldr r3, [pc, #0x4c4]
00010d40 ldr sb, [r4, r0]
00010d44 add r1, pc, r3
00010d48 ldr r0, [sb]
00010d4c bl #0x10b70
00010d50 mov r1, r8
00010d54 mov r0, #0x20000008
00010d58 bl #0x10be8
00010d5c str r8, [sp]
00010d60 mov r3, r7
00010d64 mov r2, r6
00010d68 mov r1, r8
00010d6c mov r0, #0x20000008
00010d70 bl #0x10bac
00010d74 add r8, sp, #0xc4
00010d78 mov r2, #0x8c
00010d7c mov r1, #0
00010d80 mov r0, r8
00010d84 bl #0x10b88
00010d88 ldr r2, [pc, #0x47c]
00010d8c mov r1, r8
00010d90 mov fp, #4
00010d94 mov r0, #0xf
00010d98 str fp, [sp, #0x148]
00010d9c add r7, pc, r2
00010da0 mov r2, #0
00010da4 str r7, [sp, #0xc4]
00010da8 bl #0x10ac8
00010dac cmp r0, #0
00010db0 bge #0x10dc0
00010db4 ldr r1, [pc, #0x454]
00010db8 add r0, pc, r1
00010dbc bl #0x10b10
00010dc0 ldr sl, [pc, #0x44c]
00010dc4 mov r1, #1
00010dc8 mov r0, #2
00010dcc bl #0x10a98
00010dd0 add r4, pc, sl
00010dd4 ldr r0, [r4]
00010dd8 bl #0x10b7c
00010ddc ldr r0, [r4]
00010de0 bl #0x10abc
00010de4 ldr r0, [r4]
00010de8 bl #0x10c0c
00010dec mov r1, #2
00010df0 bl #0x10b04
00010df4 mov r6, r0
00010df8 bl #0x10bb8
00010dfc subs sb, r0, #0
00010e00 beq #0x110f0
00010e04 mov r0, r6
00010e08 add r7, sp, #0x40
00010e0c bl #0x10c00
00010e10 add fp, sp, #0xc0
00010e14 mov r3, r7
00010e18 mov r2, #0
00010e1c str r2, [r3, #4]
00010e20 str r2, [r3, #8]
00010e24 str r2, [r3, #0xc]
00010e28 str r2, [r3, #0x10]
00010e2c str r2, [r3, #0x14]
00010e30 str r2, [r3, #0x18]
00010e34 str r2, [r3, #0x1c]
00010e38 str r2, [r3, #0x20]!
00010e3c cmp r3, fp
00010e40 bne #0x10e1c
00010e44 ldr r1, [pc, #0x3cc]
00010e48 add r2, sp, #0x3e8
00010e4c ldr r4, [sp, #0x44]
00010e50 add r0, sp, #0x3e8
00010e54 add sl, pc, r1
00010e58 ldr r6, [sl]
00010e5c orr sb, r4, #1
00010e60 str sb, [sp, #0x44]
00010e64 ldr r4, [pc, #0x3b0]
00010e68 cmp r6, #0
00010e6c add ip, r6, #0x1f
00010e70 movge ip, r6
00010e74 ands lr, r6, #0x8000001f
00010e78 asr r8, ip, #5
00010e7c submi lr, lr, #1
00010e80 mvnmi lr, lr, lsl #27
00010e84 ldr ip, [pc, #0x394]
00010e88 lsl r3, r8, #2
00010e8c ldr sb, [pc, #0x390]
00010e90 mvnmi lr, lr, lsr #27
00010e94 add r6, pc, r4
00010e98 add sl, r2, r3
00010e9c add r1, r0, r3
00010ea0 ldr r3, [sl, #-0x3a4]
00010ea4 add r8, pc, ip
00010ea8 addmi lr, lr, #1
00010eac mov r0, #1
00010eb0 add sl, pc, sb
00010eb4 str r8, [sp, #0x14]
00010eb8 add sb, sp, #0x44
00010ebc orr lr, r3, r0, lsl lr
00010ec0 add r8, sp, #0x1c
00010ec4 str lr, [r1, #-0x3a4]
00010ec8 mov r1, #0
00010ecc mov r4, r7
00010ed0 mov r2, r1
00010ed4 mov r3, #0x258
00010ed8 str r3, [sp, #0x1c]
00010edc str r1, [sp, #0x20]
00010ee0 str r2, [r4, #4]
00010ee4 str r2, [r4, #8]
00010ee8 str r2, [r4, #0xc]
00010eec str r2, [r4, #0x10]
00010ef0 str r2, [r4, #0x14]
00010ef4 str r2, [r4, #0x18]
00010ef8 str r2, [r4, #0x1c]
00010efc str r2, [r4, #0x20]!
00010f00 cmp fp, r4
00010f04 bne #0x10ee0
00010f08 ldr r0, [r6]
00010f0c mov r4, #1
00010f10 ldr lr, [sp, #0x44]
00010f14 str r8, [sp]
00010f18 cmp r0, #0
00010f1c add ip, r0, #0x1f
00010f20 movge ip, r0
00010f24 asr r1, r0, #0x1f
00010f28 asr ip, ip, #5
00010f2c orr r2, lr, r4
00010f30 add lr, sp, #0x3e8
00010f34 lsr r3, r1, #0x1b
00010f38 add ip, lr, ip, lsl #2
00010f3c str r2, [sp, #0x44]
00010f40 add r1, r0, r3
00010f44 ldr lr, [ip, #-0x3a4]
00010f48 and r2, r1, #0x1f
00010f4c rsb r1, r3, r2
00010f50 mov r3, #0
00010f54 add r0, r0, r4
00010f58 mov r2, r3
00010f5c orr lr, lr, r4, lsl r1
00010f60 mov r1, sb
00010f64 str lr, [ip, #-0x3a4]
00010f68 bl #0x10aa4
00010f6c cmp r5, #0
00010f70 beq #0x10f80
00010f74 ldr r0, [sp, #0x44]
00010f78 tst r0, #1
00010f7c bne #0x110ac
00010f80 ldr r2, [sl]
00010f84 add r3, sp, #0x3e8
00010f88 cmp r2, #0
00010f8c add r4, r2, #0x1f
00010f90 movge r4, r2
00010f94 asr r1, r2, #0x1f
00010f98 asr lr, r4, #5
00010f9c lsr r0, r1, #0x1b
00010fa0 add ip, r3, lr, lsl #2
00010fa4 add r4, r2, r0
00010fa8 ldr lr, [ip, #-0x3a4]
00010fac and r1, r4, #0x1f
00010fb0 rsb r0, r0, r1
00010fb4 asr r3, lr, r0
00010fb8 tst r3, #1
00010fbc beq #0x10ec8
00010fc0 add r4, sp, #0x1e8
00010fc4 mov r0, r2
00010fc8 mov r1, r4
00010fcc movw r2, #0x1ff
00010fd0 bl #0x10a80
00010fd4 subs r2, r0, #0
00010fd8 blt #0x111a4
00010fdc add ip, sp, #0x3e8
00010fe0 mov r3, #0
00010fe4 add lr, ip, r2
00010fe8 mov r1, r4
00010fec mov r0, #1
00010ff0 strb r3, [lr, #-0x200]
00010ff4 str r3, [sp, #0xc]
00010ff8 bl #0x10b94
00010ffc mov r2, #1
00011000 mov r1, #0x10000007
00011004 mov r0, r2
00011008 bl #0x10ba0
0001100c subs r3, r0, #0
00011010 ldr r2, [sp, #0xc]
00011014 beq #0x110e0
00011018 mov r1, r2
0001101c mov r0, r4
00011020 mov r2, r3
00011024 str r3, [sp, #0xc]
00011028 bl #0x1138c
0001102c ldr r1, [sp, #0xc]
00011030 mov r0, r1
00011034 bl #0x10a8c
00011038 b #0x10ec8
0001103c ldr lr, [pc, #0x1e4]
00011040 mov r2, #0x2d
00011044 ldr r5, [pc, #0x1b8]
00011048 mov r1, #1
0001104c add r0, pc, lr
00011050 ldr r3, [sp, #0x10]
00011054 ldr r5, [r3, r5]
00011058 ldr r3, [r5]
0001105c bl #0x10ad4
00011060 mov r0, #1
00011064 bl #0x10b4c
00011068 mov r1, #1
0001106c mov r0, r5
00011070 bl #0x10af8
00011074 b #0x10cb8
00011078 ldr r8, [pc, #0x184]
0001107c mov r2, #0x13
00011080 ldr r4, [sp, #0x10]
00011084 mov r1, #1
00011088 ldr r0, [pc, #0x19c]
0001108c mvn sb, #0
00011090 ldr ip, [r4, r8]
00011094 add r0, pc, r0
00011098 ldr r3, [ip]
0001109c bl #0x10ad4
000110a0 mov r0, sb
000110a4 add sp, sp, #0x3ec
000110a8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
000110ac add r3, sp, #0x150
000110b0 mov r2, #0x95
000110b4 mov r1, r3
000110b8 mov r0, #0
000110bc str r3, [sp, #0xc]
000110c0 bl #0x10a80
000110c4 subs r2, r0, #0
000110c8 ldr ip, [sp, #0xc]
000110cc blt #0x111bc
000110d0 mov r1, ip
000110d4 ldr r0, [r6]
000110d8 bl #0x10b94
000110dc b #0x10f80
000110e0 ldr r1, [sp, #0x14]
000110e4 mov r0, #3
000110e8 bl #0x10bdc
000110ec b #0x10ec8
000110f0 ldr r0, [r4]
000110f4 add r5, sp, #0x150
000110f8 bl #0x10c00
000110fc mov r1, sb
00011100 mov r0, r6
00011104 bl #0x10ab0
00011108 mov r1, #1
0001110c mov r0, r6
00011110 bl #0x10ab0
00011114 mov r1, #2
00011118 mov r0, r6
0001111c bl #0x10ab0
00011120 mov r0, r6
00011124 add r8, sp, #0x1e8
00011128 bl #0x10c00
0001112c mov r1, r5
00011130 mov r0, r6
00011134 bl #0x10c18
00011138 mov ip, r5
0001113c add lr, sp, #0x1e8
00011140 ldm ip!, {r0, r1, r2, r3}
00011144 stm lr!, {r0, r1, r2, r3}
00011148 ldm ip!, {r0, r1, r2, r3}
0001114c stm lr!, {r0, r1, r2, r3}
00011150 ldm ip!, {r0, r1, r2, r3}
00011154 stm lr!, {r0, r1, r2, r3}
00011158 ldm ip, {r0, r1, r2}
0001115c stm lr, {r0, r1, r2}
00011160 mov r0, r8
00011164 bl #0x10a74
00011168 mov r2, r8
0001116c mov r1, sb
00011170 mov r0, r6
00011174 bl #0x10aec
00011178 bl #0x10b64
0001117c mov r2, #1
00011180 movw r1, #0x540e
00011184 mov r0, sb
00011188 bl #0x10ae0
0001118c ldr r0, [pc, #0x9c]
00011190 mov r2, sb
00011194 add r1, pc, r0
00011198 mov r0, r1
0001119c bl #0x10bc4
000111a0 b #0x110a0
000111a4 ldr r7, [pc, #0x88]
000111a8 mov r2, #0x14
000111ac ldr r5, [pc, #0x50]
000111b0 mov r1, #1
000111b4 add r0, pc, r7
000111b8 b #0x11050
000111bc ldr sl, [sp, #0x10]
000111c0 mov r2, #0x14
000111c4 ldr fp, [pc, #0x38]
000111c8 mov r1, r4
000111cc ldr r6, [pc, #0x64]
000111d0 ldr sb, [sl, fp]
000111d4 add r0, pc, r6
000111d8 ldr r3, [sb]
000111dc bl #0x10ad4
000111e0 mov r0, r4
000111e4 bl #0x10b4c
000111e8 andeq r0, r1, r4, lsl #20
000111ec andeq r0, r1, r4, lsr #21
000111f0 andeq r0, r0, r0, asr #15
000111f4 muleq r0, r8, r7
000111f8 andeq r0, r1, ip, asr #20
000111fc andeq r0, r0, r0, lsr #1
00011200 andeq r0, r0, ip, asr r7
00011204 muleq r0, ip, r0
00011208 andeq r0, r0, ip, lsr r7
0001120c strheq r0, [r0], -r8
00011210 andeq r0, r0, ip, ror #13
00011214 andeq r0, r1, ip, asr #18
00011218 andeq r0, r1, r8, asr #17
0001121c andeq r0, r1, r8, lsl #17
00011220 andeq r0, r0, ip, asr #12
00011224 andeq r0, r1, ip, ror #16
00011228 ldrdeq r0, r1, [r0], -ip
0001122c ldrdeq r0, r1, [r0], -r0
00011230 andeq r0, r0, r8, ror r3
00011234 andeq r0, r0, r4, lsr #6
00011238 andeq r0, r0, ip, ror #5
