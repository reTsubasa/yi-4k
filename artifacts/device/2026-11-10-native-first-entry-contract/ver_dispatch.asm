a02a40bc 10402de9 push {r4, lr}
a02a40c0 10d04de2 sub sp, sp, #0x10
a02a40c4 0040a0e1 mov r4, r0
a02a40c8 08108de2 add r1, sp, #8
a02a40cc 04008de2 add r0, sp, #4
a02a40d0 0c208de2 add r2, sp, #0xc
a02a40d4 b0ddffeb bl #0xa029b79c
a02a40d8 ac0400e3 movw r0, #0x4ac
a02a40dc 04109de5 ldr r1, [sp, #4]
a02a40e0 08209de5 ldr r2, [sp, #8]
a02a40e4 5b004ae3 movt r0, #0xa05b
a02a40e8 0c309de5 ldr r3, [sp, #0xc]
a02a40ec 34ff2fe1 blx r4
a02a40f0 10d08de2 add sp, sp, #0x10
a02a40f4 1080bde8 pop {r4, pc}
a02a40f8 010050e3 cmp r0, #1
a02a40fc f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
a02a4100 0050a0e1 mov r5, r0
a02a4104 08d04de2 sub sp, sp, #8
a02a4108 0280a0e1 mov r8, r2
a02a410c 3500000a beq #0xa02a41e8
a02a4110 047091e5 ldr r7, [r1, #4]
a02a4114 0160a0e1 mov r6, r1
a02a4118 e01400e3 movw r1, #0x4e0
a02a411c 5b104ae3 movt r1, #0xa05b
a02a4120 0700a0e1 mov r0, r7
a02a4124 865509fa blx #0xa04f9744
a02a4128 004050e2 subs r4, r0, #0
a02a412c 0400000a beq #0xa02a4144
a02a4130 020055e3 cmp r5, #2
a02a4134 1e00000a beq #0xa02a41b4
a02a4138 0000a0e3 mov r0, #0
a02a413c 08d08de2 add sp, sp, #8
a02a4140 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a02a4144 001096e5 ldr r1, [r6]
a02a4148 e40400e3 movw r0, #0x4e4
a02a414c 5b004ae3 movt r0, #0xa05b
a02a4150 207601e3 movw r7, #0x1620
a02a4154 82704ae3 movt r7, #0xa082
a02a4158 0130a0e1 mov r3, r1
a02a415c 00108de5 str r1, [sp]
a02a4160 0120a0e1 mov r2, r1
a02a4164 38ff2fe1 blx r8
a02a4168 940500e3 movw r0, #0x594
a02a416c 5b004ae3 movt r0, #0xa05b
a02a4170 38ff2fe1 blx r8
a02a4174 003097e5 ldr r3, [r7]
a02a4178 000053e3 cmp r3, #0
a02a417c edffff0a beq #0xa02a4138
a02a4180 305601e3 movw r5, #0x1630
a02a4184 82504ae3 movt r5, #0xa082
a02a4188 1c0305e3 movw r0, #0x531c
a02a418c 041095e4 ldr r1, [r5], #4
a02a4190 63004ae3 movt r0, #0xa063
a02a4194 014084e2 add r4, r4, #1
a02a4198 38ff2fe1 blx r8
a02a419c 003097e5 ldr r3, [r7]
a02a41a0 030054e1 cmp r4, r3
a02a41a4 f7ffff3a blo #0xa02a4188
a02a41a8 0000a0e3 mov r0, #0
a02a41ac 08d08de2 add sp, sp, #8
a02a41b0 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a02a41b4 ac1500e3 movw r1, #0x5ac
a02a41b8 0700a0e1 mov r0, r7
a02a41bc 5b104ae3 movt r1, #0xa05b
a02a41c0 5f5509fa blx #0xa04f9744
a02a41c4 000050e3 cmp r0, #0
a02a41c8 3400000a beq #0xa02a42a0
a02a41cc 0700a0e1 mov r0, r7
a02a41d0 20ddffeb bl #0xa029b658
a02a41d4 001050e2 subs r1, r0, #0
a02a41d8 d6ffff0a beq #0xa02a4138
a02a41dc 0800a0e1 mov r0, r8
a02a41e0 97ffffeb bl #0xa02a4044
a02a41e4 d3ffffea b #0xa02a4138
a02a41e8 207601e3 movw r7, #0x1620
a02a41ec 82704ae3 movt r7, #0xa082
a02a41f0 003097e5 ldr r3, [r7]
a02a41f4 000053e3 cmp r3, #0
a02a41f8 30a60113 movwne sl, #0x1630
a02a41fc 0090a013 movne sb, #0
a02a4200 82a04a13 movtne sl, #0xa082
a02a4204 1200000a beq #0xa02a4254
a02a4208 0040a0e3 mov r4, #0
a02a420c 09618ae0 add r6, sl, sb, lsl #2
a02a4210 060000ea b #0xa02a4230
a02a4214 09ddffeb bl #0xa029b640
a02a4218 0050a0e1 mov r5, r0
a02a421c 000096e5 ldr r0, [r6]
a02a4220 0510a0e1 mov r1, r5
a02a4224 465509fa blx #0xa04f9744
a02a4228 000050e3 cmp r0, #0
a02a422c 1000000a beq #0xa02a4274
a02a4230 00ddffeb bl #0xa029b638
a02a4234 000054e1 cmp r4, r0
a02a4238 0400a0e1 mov r0, r4
a02a423c 014084e2 add r4, r4, #1
a02a4240 f3ffff3a blo #0xa02a4214
a02a4244 003097e5 ldr r3, [r7]
a02a4248 019089e2 add sb, sb, #1
a02a424c 030059e1 cmp sb, r3
a02a4250 ecffff3a blo #0xa02a4208
a02a4254 c40400e3 movw r0, #0x4c4
a02a4258 d01106e3 movw r1, #0x61d0
a02a425c 53104ae3 movt r1, #0xa053
a02a4260 5b004ae3 movt r0, #0xa05b
a02a4264 38ff2fe1 blx r8
a02a4268 0800a0e1 mov r0, r8
a02a426c 92ffffeb bl #0xa02a40bc
a02a4270 b0ffffea b #0xa02a4138
a02a4274 0500a0e1 mov r0, r5
a02a4278 f6dcffeb bl #0xa029b658
a02a427c 001050e2 subs r1, r0, #0
a02a4280 efffff0a beq #0xa02a4244
a02a4284 0800a0e1 mov r0, r8
a02a4288 019089e2 add sb, sb, #1
a02a428c 6cffffeb bl #0xa02a4044
a02a4290 003097e5 ldr r3, [r7]
a02a4294 030059e1 cmp sb, r3
a02a4298 daffff3a blo #0xa02a4208
a02a429c ecffffea b #0xa02a4254
a02a42a0 0800a0e1 mov r0, r8
a02a42a4 84ffffeb bl #0xa02a40bc
a02a42a8 a2ffffea b #0xa02a4138
