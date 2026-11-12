a04b2f08 002050e2 subs r2, r0, #0
a04b2f0c 70402de9 push {r4, r5, r6, lr}
a04b2f10 4600000a beq #0xa04b3030
a04b2f14 0c3509e3 movw r3, #0x950c
a04b2f18 f44405e3 movw r4, #0x54f4
a04b2f1c a4314ae3 movt r3, #0xa1a4
a04b2f20 000092e5 ldr r0, [r2]
a04b2f24 00c093e5 ldr ip, [r3]
a04b2f28 a4414ae3 movt r4, #0xa1a4
a04b2f2c 041092e5 ldr r1, [r2, #4]
a04b2f30 0430a0e1 mov r3, r4
a04b2f34 00005ce3 cmp ip, #0
a04b2f38 0300a3e8 stm r3!, {r0, r1}
a04b2f3c 4a00000a beq #0xa04b306c
a04b2f40 0c00a0e1 mov r0, ip
a04b2f44 46fbffeb bl #0xa04b1c64
a04b2f48 083509e3 movw r3, #0x9508
a04b2f4c a4314ae3 movt r3, #0xa1a4
a04b2f50 000093e5 ldr r0, [r3]
a04b2f54 000050e3 cmp r0, #0
a04b2f58 3b00000a beq #0xa04b304c
a04b2f5c 445609e3 movw r5, #0x9644
a04b2f60 a4514ae3 movt r5, #0xa1a4
a04b2f64 43fbffeb bl #0xa04b1c78
a04b2f68 003095e5 ldr r3, [r5]
a04b2f6c 02c013e2 ands ip, r3, #2
a04b2f70 1500001a bne #0xa04b2fcc
a04b2f74 060094e8 ldm r4, {r1, r2}
a04b2f78 000051e3 cmp r1, #0
a04b2f7c 0100000a beq #0xa04b2f88
a04b2f80 000052e3 cmp r2, #0
a04b2f84 4700001a bne #0xa04b30a8
a04b2f88 b00208e3 movw r0, #0x82b0
a04b2f8c 63004ae3 movt r0, #0xa063
a04b2f90 55d0f7eb bl #0xa02a70ec
a04b2f94 ff00a0e3 mov r0, #0xff
a04b2f98 7080bde8 pop {r4, r5, r6, pc}
a04b2f9c 080308e3 movw r0, #0x8308
a04b2fa0 e4150ce3 movw r1, #0xc5e4
a04b2fa4 78104ae3 movt r1, #0xa078
a04b2fa8 63004ae3 movt r0, #0xa063
a04b2fac 4ed0f7eb bl #0xa02a70ec
a04b2fb0 240308e3 movw r0, #0x8324
a04b2fb4 001094e5 ldr r1, [r4]
a04b2fb8 63004ae3 movt r0, #0xa063
a04b2fbc 4ad0f7eb bl #0xa02a70ec
a04b2fc0 003095e5 ldr r3, [r5]
a04b2fc4 023083e3 orr r3, r3, #2
a04b2fc8 003085e5 str r3, [r5]
a04b2fcc 106013e2 ands r6, r3, #0x10
a04b2fd0 0c00001a bne #0xa04b3008
a04b2fd4 b01700eb bl #0xa04b8e9c
a04b2fd8 004050e2 subs r4, r0, #0
a04b2fdc 2900001a bne #0xa04b3088
a04b2fe0 500308e3 movw r0, #0x8350
a04b2fe4 63004ae3 movt r0, #0xa063
a04b2fe8 3fd0f7eb bl #0xa02a70ec
a04b2fec 003095e5 ldr r3, [r5]
a04b2ff0 482609e3 movw r2, #0x9648
a04b2ff4 a4214ae3 movt r2, #0xa1a4
a04b2ff8 0110a0e3 mov r1, #1
a04b2ffc 001082e5 str r1, [r2]
a04b3000 103083e3 orr r3, r3, #0x10
a04b3004 003085e5 str r3, [r5]
a04b3008 080013e3 tst r3, #8
a04b300c 0500001a bne #0xa04b3028
a04b3010 c91300eb bl #0xa04b7f3c
a04b3014 000050e3 cmp r0, #0
a04b3018 1200001a bne #0xa04b3068
a04b301c 003095e5 ldr r3, [r5]
a04b3020 083083e3 orr r3, r3, #8
a04b3024 003085e5 str r3, [r5]
a04b3028 0000a0e3 mov r0, #0
a04b302c 7080bde8 pop {r4, r5, r6, pc}
a04b3030 3c0208e3 movw r0, #0x823c
a04b3034 881b07e3 movw r1, #0x7b88
a04b3038 63104ae3 movt r1, #0xa063
a04b303c 63004ae3 movt r0, #0xa063
a04b3040 29d0f7eb bl #0xa02a70ec
a04b3044 ff00a0e3 mov r0, #0xff
a04b3048 7080bde8 pop {r4, r5, r6, pc}
a04b304c 880208e3 movw r0, #0x8288
a04b3050 881b07e3 movw r1, #0x7b88
a04b3054 63104ae3 movt r1, #0xa063
a04b3058 63004ae3 movt r0, #0xa063
a04b305c 22d0f7eb bl #0xa02a70ec
a04b3060 ff00a0e3 mov r0, #0xff
a04b3064 7080bde8 pop {r4, r5, r6, pc}
a04b3068 7080bde8 pop {r4, r5, r6, pc}
a04b306c 5c0208e3 movw r0, #0x825c
a04b3070 881b07e3 movw r1, #0x7b88
a04b3074 63104ae3 movt r1, #0xa063
a04b3078 63004ae3 movt r0, #0xa063
a04b307c 1ad0f7eb bl #0xa02a70ec
a04b3080 ff00a0e3 mov r0, #0xff
a04b3084 7080bde8 pop {r4, r5, r6, pc}
a04b3088 700308e3 movw r0, #0x8370
a04b308c 63004ae3 movt r0, #0xa063
a04b3090 15d0f7eb bl #0xa02a70ec
a04b3094 483609e3 movw r3, #0x9648
a04b3098 0400a0e1 mov r0, r4
a04b309c a4314ae3 movt r3, #0xa1a4
a04b30a0 006083e5 str r6, [r3]
a04b30a4 7080bde8 pop {r4, r5, r6, pc}
a04b30a8 0100a0e1 mov r0, r1
a04b30ac 0c30a0e1 mov r3, ip
a04b30b0 0210a0e1 mov r1, r2
a04b30b4 0c20a0e1 mov r2, ip
a04b30b8 4af9ffeb bl #0xa04b15e8
a04b30bc 001050e2 subs r1, r0, #0
a04b30c0 b5ffff0a beq #0xa04b2f9c
a04b30c4 d80208e3 movw r0, #0x82d8
a04b30c8 63004ae3 movt r0, #0xa063
a04b30cc 06d0f7eb bl #0xa02a70ec
a04b30d0 afffffea b #0xa04b2f94
