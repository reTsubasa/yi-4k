a02a3db0 050050e3 cmp      r0, #5
a02a3db4 f0412de9 push     {r4, r5, r6, r7, r8, lr}
a02a3db8 0140a0e1 mov      r4, r1
a02a3dbc 01dc4de2 sub      sp, sp, #0x100
a02a3dc0 0280a0e1 mov      r8, r2
a02a3dc4 4400001a bne      #0xa02a3edc
a02a3dc8 041091e5 ldr      r1, [r1, #4]
a02a3dcc 0130d1e5 ldrb     r3, [r1, #1]
a02a3dd0 3a0053e3 cmp      r3, #0x3a
a02a3dd4 3200001a bne      #0xa02a3ea4
a02a3dd8 012ca0e3 mov      r2, #0x100
a02a3ddc 0d00a0e1 mov      r0, sp
a02a3de0 545709fa blx      #0xa04f9b38
a02a3de4 0010a0e3 mov      r1, #0
a02a3de8 080094e5 ldr      r0, [r4, #8]
a02a3dec 0120a0e1 mov      r2, r1
a02a3df0 4c5d09fa blx      #0xa04fb328
a02a3df4 0c5094e5 ldr      r5, [r4, #0xc]
a02a3df8 ec1207e3 movw     r1, #0x72ec
a02a3dfc 63104ae3 movt     r1, #0xa063
a02a3e00 0070a0e1 mov      r7, r0
a02a3e04 0500a0e1 mov      r0, r5
a02a3e08 4d5609fa blx      #0xa04f9744
a02a3e0c 001050e2 subs     r1, r0, #0
a02a3e10 1d00000a beq      #0xa02a3e8c
a02a3e14 c01504e3 movw     r1, #0x45c0
a02a3e18 0500a0e1 mov      r0, r5
a02a3e1c 5f104ae3 movt     r1, #0xa05f
a02a3e20 475609fa blx      #0xa04f9744
a02a3e24 001050e2 subs     r1, r0, #0
a02a3e28 3100001a bne      #0xa02a3ef4
a02a3e2c 100094e5 ldr      r0, [r4, #0x10]
a02a3e30 0120a0e1 mov      r2, r1
a02a3e34 3b5d09fa blx      #0xa04fb328
a02a3e38 0050a0e1 mov      r5, r0
a02a3e3c 5c1b06e3 movw     r1, #0x6b5c
a02a3e40 0d00a0e1 mov      r0, sp
a02a3e44 57104ae3 movt     r1, #0xa057
a02a3e48 9e2802eb bl       #0xa032e0c8
a02a3e4c 006050e2 subs     r6, r0, #0
a02a3e50 1800000a beq      #0xa02a3eb8
a02a3e54 0700a0e1 mov      r0, r7
a02a3e58 0110a0e3 mov      r1, #1
a02a3e5c 0520a0e1 mov      r2, r5
a02a3e60 0630a0e1 mov      r3, r6
a02a3e64 9b2802eb bl       #0xa032e0d8
a02a3e68 000055e1 cmp      r5, r0
a02a3e6c 1100001a bne      #0xa02a3eb8
a02a3e70 0600a0e1 mov      r0, r6
a02a3e74 952802eb bl       #0xa032e0d0
a02a3e78 000050e3 cmp      r0, #0
a02a3e7c 0000a0a3 movge    r0, #0
a02a3e80 0c0000ba blt      #0xa02a3eb8
a02a3e84 01dc8de2 add      sp, sp, #0x100
a02a3e88 f081bde8 pop      {r4, r5, r6, r7, r8, pc}
a02a3e8c 100094e5 ldr      r0, [r4, #0x10]
a02a3e90 0120a0e1 mov      r2, r1
a02a3e94 015067e2 rsb      r5, r7, #1
a02a3e98 225d09fa blx      #0xa04fb328
a02a3e9c 005085e0 add      r5, r5, r0
a02a3ea0 e5ffffea b        #0xa02a3e3c
a02a3ea4 5c0c0fe3 movw     r0, #0xfc5c
a02a3ea8 5a004ae3 movt     r0, #0xa05a
a02a3eac 32ff2fe1 blx      r2
a02a3eb0 0100e0e3 mvn      r0, #1
a02a3eb4 f2ffffea b        #0xa02a3e84
a02a3eb8 952802eb bl       #0xa032e114
a02a3ebc 0030a0e1 mov      r3, r0
a02a3ec0 900c0fe3 movw     r0, #0xfc90
a02a3ec4 001094e5 ldr      r1, [r4]
a02a3ec8 0d20a0e1 mov      r2, sp
a02a3ecc 5a004ae3 movt     r0, #0xa05a
a02a3ed0 38ff2fe1 blx      r8
a02a3ed4 0400e0e3 mvn      r0, #4
a02a3ed8 e9ffffea b        #0xa02a3e84
a02a3edc 3c0200e3 movw     r0, #0x23c
a02a3ee0 001091e5 ldr      r1, [r1]
a02a3ee4 5b004ae3 movt     r0, #0xa05b
a02a3ee8 32ff2fe1 blx      r2
a02a3eec 0000e0e3 mvn      r0, #0
a02a3ef0 e3ffffea b        #0xa02a3e84
a02a3ef4 680200e3 movw     r0, #0x268
a02a3ef8 5b004ae3 movt     r0, #0xa05b
a02a3efc 38ff2fe1 blx      r8
a02a3f00 0300e0e3 mvn      r0, #3
a02a3f04 deffffea b        #0xa02a3e84
