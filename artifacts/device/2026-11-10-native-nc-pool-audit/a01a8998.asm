a01a8998 010050e3 cmp r0, #1
a01a899c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01a89a0 0070a0e1 mov r7, r0
a01a89a4 1cd04de2 sub sp, sp, #0x1c
a01a89a8 0250a0e1 mov r5, r2
a01a89ac 360000da ble #0xa01a8a8c
a01a89b0 006091e5 ldr r6, [r1]
a01a89b4 0140a0e1 mov r4, r1
a01a89b8 981e04e3 movw r1, #0x4e98
a01a89bc 56104ae3 movt r1, #0xa056
a01a89c0 0600a0e1 mov r0, r6
a01a89c4 5e430dfa blx #0xa04f9744
a01a89c8 008050e2 subs r8, r0, #0
a01a89cc 3400000a beq #0xa01a8aa4
a01a89d0 8c1309e3 movw r1, #0x938c
a01a89d4 0600a0e1 mov r0, r6
a01a89d8 56104ae3 movt r1, #0xa056
a01a89dc 58430dfa blx #0xa04f9744
a01a89e0 001050e2 subs r1, r0, #0
a01a89e4 4000000a beq #0xa01a8aec
a01a89e8 201d0ce3 movw r1, #0xcd20
a01a89ec 0600a0e1 mov r0, r6
a01a89f0 55104ae3 movt r1, #0xa055
a01a89f4 52430dfa blx #0xa04f9744
a01a89f8 000050e3 cmp r0, #0
a01a89fc a100000a beq #0xa01a8c88
a01a8a00 081409e3 movw r1, #0x9408
a01a8a04 0600a0e1 mov r0, r6
a01a8a08 56104ae3 movt r1, #0xa056
a01a8a0c 4c430dfa blx #0xa04f9744
a01a8a10 001050e2 subs r1, r0, #0
a01a8a14 8f00000a beq #0xa01a8c58
a01a8a18 e41f0de3 movw r1, #0xdfe4
a01a8a1c 0600a0e1 mov r0, r6
a01a8a20 54104ae3 movt r1, #0xa054
a01a8a24 46430dfa blx #0xa04f9744
a01a8a28 100f6fe1 clz r0, r0
a01a8a2c 020057e3 cmp r7, #2
a01a8a30 a002a0e1 lsr r0, r0, #5
a01a8a34 0000a003 moveq r0, #0
a01a8a38 000050e3 cmp r0, #0
a01a8a3c 1200000a beq #0xa01a8a8c
a01a8a40 841a04e3 movw r1, #0x4a84
a01a8a44 080094e5 ldr r0, [r4, #8]
a01a8a48 53104ae3 movt r1, #0xa053
a01a8a4c 3c430dfa blx #0xa04f9744
a01a8a50 106f6fe1 clz r6, r0
a01a8a54 047094e5 ldr r7, [r4, #4]
a01a8a58 2c1409e3 movw r1, #0x942c
a01a8a5c 56104ae3 movt r1, #0xa056
a01a8a60 a662a0e1 lsr r6, r6, #5
a01a8a64 0700a0e1 mov r0, r7
a01a8a68 35430dfa blx #0xa04f9744
a01a8a6c 000050e3 cmp r0, #0
a01a8a70 b300000a beq #0xa01a8d44
a01a8a74 441409e3 movw r1, #0x9444
a01a8a78 0700a0e1 mov r0, r7
a01a8a7c 56104ae3 movt r1, #0xa056
a01a8a80 2f430dfa blx #0xa04f9744
a01a8a84 000050e3 cmp r0, #0
a01a8a88 a300000a beq #0xa01a8d1c
a01a8a8c 480409e3 movw r0, #0x9448
a01a8a90 56004ae3 movt r0, #0xa056
a01a8a94 35ff2fe1 blx r5
a01a8a98 0000a0e3 mov r0, #0
a01a8a9c 1cd08de2 add sp, sp, #0x1c
a01a8aa0 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8aa4 0810a0e1 mov r1, r8
a01a8aa8 0820a0e1 mov r2, r8
a01a8aac 040094e5 ldr r0, [r4, #4]
a01a8ab0 c3490dfa blx #0xa04fb1c4
a01a8ab4 0040a0e1 mov r4, r0
a01a8ab8 430300e3 movw r0, #0x343
a01a8abc 0410a0e1 mov r1, r4
a01a8ac0 0820a0e1 mov r2, r8
a01a8ac4 01004fe3 movt r0, #0xf001
a01a8ac8 b3f600eb bl #0xa01e659c
a01a8acc 600309e3 movw r0, #0x9360
a01a8ad0 0410a0e1 mov r1, r4
a01a8ad4 0820a0e1 mov r2, r8
a01a8ad8 56004ae3 movt r0, #0xa056
a01a8adc 35ff2fe1 blx r5
a01a8ae0 0000a0e3 mov r0, #0
a01a8ae4 1cd08de2 add sp, sp, #0x1c
a01a8ae8 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8aec cc7308e3 movw r7, #0x83cc
a01a8af0 0120a0e1 mov r2, r1
a01a8af4 040094e5 ldr r0, [r4, #4]
a01a8af8 25714ae3 movt r7, #0xa125
a01a8afc b0490dfa blx #0xa04fb1c4
a01a8b00 003097e5 ldr r3, [r7]
a01a8b04 08008de5 str r0, [sp, #8]
a01a8b08 032080e0 add r2, r0, r3
a01a8b0c 320052e3 cmp r2, #0x32
a01a8b10 322063c2 rsbgt r2, r3, #0x32
a01a8b14 08208dc5 strgt r2, [sp, #8]
a01a8b18 320053e3 cmp r3, #0x32
a01a8b1c 6900000a beq #0xa01a8cc8
a01a8b20 08309de5 ldr r3, [sp, #8]
a01a8b24 000053e3 cmp r3, #0
a01a8b28 daffffda ble #0xa01a8a98
a01a8b2c 003308e3 movw r3, #0x8300
a01a8b30 e4a302e3 movw sl, #0x23e4
a01a8b34 25314ae3 movt r3, #0xa125
a01a8b38 67b606e3 movw fp, #0x6667
a01a8b3c 10308de5 str r3, [sp, #0x10]
a01a8b40 383208e3 movw r3, #0x8238
a01a8b44 cc6308e3 movw r6, #0x83cc
a01a8b48 25314ae3 movt r3, #0xa125
a01a8b4c 3aa14ae3 movt sl, #0xa13a
a01a8b50 0c308de5 str r3, [sp, #0xc]
a01a8b54 66b646e3 movt fp, #0x6666
a01a8b58 25614ae3 movt r6, #0xa125
a01a8b5c 0080a0e3 mov r8, #0
a01a8b60 14508de5 str r5, [sp, #0x14]
a01a8b64 170000ea b #0xa01a8bc8
a01a8b68 005096e5 ldr r5, [r6]
a01a8b6c 320055e3 cmp r5, #0x32
a01a8b70 4b0000ca bgt #0xa01a8ca4
a01a8b74 003308e3 movw r3, #0x8300
a01a8b78 25314ae3 movt r3, #0xa125
a01a8b7c 050193e7 ldr r0, [r3, r5, lsl #2]
a01a8b80 99400dfa blx #0xa04f8dec
a01a8b84 05e199e7 ldr lr, [sb, r5, lsl #2]
a01a8b88 003308e3 movw r3, #0x8300
a01a8b8c 25314ae3 movt r3, #0xa125
a01a8b90 ac0309e3 movw r0, #0x93ac
a01a8b94 052193e7 ldr r2, [r3, r5, lsl #2]
a01a8b98 0510a0e1 mov r1, r5
a01a8b9c 0e30a0e1 mov r3, lr
a01a8ba0 00408de5 str r4, [sp]
a01a8ba4 56004ae3 movt r0, #0xa056
a01a8ba8 14c09de5 ldr ip, [sp, #0x14]
a01a8bac 3cff2fe1 blx ip
a01a8bb0 08209de5 ldr r2, [sp, #8]
a01a8bb4 003096e5 ldr r3, [r6]
a01a8bb8 020058e1 cmp r8, r2
a01a8bbc 013083e2 add r3, r3, #1
a01a8bc0 003086e5 str r3, [r6]
a01a8bc4 b3ffff0a beq #0xa01a8a98
a01a8bc8 9b960beb bl #0xa048e63c
a01a8bcc d7400dfa blx #0xa04f8f30
a01a8bd0 dc400dfa blx #0xa04f8f48
a01a8bd4 0030a0e1 mov r3, r0
a01a8bd8 002097e5 ldr r2, [r7]
a01a8bdc 930bc1e0 smull r0, r1, r3, fp
a01a8be0 c34fa0e1 asr r4, r3, #0x1f
a01a8be4 0cc09de5 ldr ip, [sp, #0xc]
a01a8be8 4000a0e3 mov r0, #0x40
a01a8bec 00008de5 str r0, [sp]
a01a8bf0 389208e3 movw sb, #0x8238
a01a8bf4 0221a0e1 lsl r2, r2, #2
a01a8bf8 00009ae5 ldr r0, [sl]
a01a8bfc 018088e2 add r8, r8, #1
a01a8c00 414864e0 rsb r4, r4, r1, asr #16
a01a8c04 10109de5 ldr r1, [sp, #0x10]
a01a8c08 25914ae3 movt sb, #0xa125
a01a8c0c 84e8a0e1 lsl lr, r4, #0x11
a01a8c10 021081e0 add r1, r1, r2
a01a8c14 84478ee0 add r4, lr, r4, lsl #15
a01a8c18 02208ce0 add r2, ip, r2
a01a8c1c 034064e0 rsb r4, r4, r3
a01a8c20 0430a0e1 mov r3, r4
a01a8c24 ebc603eb bl #0xa029a7d8
a01a8c28 001050e2 subs r1, r0, #0
a01a8c2c 0420a0e1 mov r2, r4
a01a8c30 ccffff0a beq #0xa01a8b68
a01a8c34 a80b0ae3 movw r0, #0xaba8
a01a8c38 e8130be3 movw r1, #0xb3e8
a01a8c3c 56104ae3 movt r1, #0xa056
a01a8c40 c92c00e3 movw r2, #0xcc9
a01a8c44 53004ae3 movt r0, #0xa053
a01a8c48 27f903eb bl #0xa02a70ec
a01a8c4c 34fa03eb bl #0xa02a7524
a01a8c50 c0000cf1 cpsid if
a01a8c54 feffffea b #0xa01a8c54
a01a8c58 0120a0e1 mov r2, r1
a01a8c5c 040094e5 ldr r0, [r4, #4]
a01a8c60 57490dfa blx #0xa04fb1c4
a01a8c64 0040a0e1 mov r4, r0
a01a8c68 0721ffeb bl #0xa017108c
a01a8c6c 140409e3 movw r0, #0x9414
a01a8c70 0410a0e1 mov r1, r4
a01a8c74 56004ae3 movt r0, #0xa056
a01a8c78 35ff2fe1 blx r5
a01a8c7c 0000a0e3 mov r0, #0
a01a8c80 1cd08de2 add sp, sp, #0x1c
a01a8c84 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8c88 ae25ffeb bl #0xa0172348
a01a8c8c ec0309e3 movw r0, #0x93ec
a01a8c90 56004ae3 movt r0, #0xa056
a01a8c94 35ff2fe1 blx r5
a01a8c98 0000a0e3 mov r0, #0
a01a8c9c 1cd08de2 add sp, sp, #0x1c
a01a8ca0 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01a8ca4 a80b0ae3 movw r0, #0xaba8
a01a8ca8 e8130be3 movw r1, #0xb3e8
a01a8cac 56104ae3 movt r1, #0xa056
a01a8cb0 ca2c00e3 movw r2, #0xcca
a01a8cb4 53004ae3 movt r0, #0xa053
a01a8cb8 0bf903eb bl #0xa02a70ec
a01a8cbc 18fa03eb bl #0xa02a7524
a01a8cc0 c0000cf1 cpsid if
a01a8cc4 feffffea b #0xa01a8cc4
a01a8cc8 940309e3 movw r0, #0x9394
a01a8ccc 56004ae3 movt r0, #0xa056
a01a8cd0 35ff2fe1 blx r5
a01a8cd4 003097e5 ldr r3, [r7]
a01a8cd8 000053e3 cmp r3, #0
a01a8cdc 0b0000da ble #0xa01a8d10
a01a8ce0 70609fe5 ldr r6, [pc, #0x70]
a01a8ce4 0040a0e3 mov r4, #0
a01a8ce8 6ca09fe5 ldr sl, [pc, #0x6c]
a01a8cec 0480a0e1 mov r8, r4
a01a8cf0 0400b6e5 ldr r0, [r6, #4]!
a01a8cf4 014084e2 add r4, r4, #1
a01a8cf8 854e08eb bl #0xa03bc714
a01a8cfc 003097e5 ldr r3, [r7]
a01a8d00 008086e5 str r8, [r6]
a01a8d04 0480aae5 str r8, [sl, #4]!
a01a8d08 040053e1 cmp r3, r4
a01a8d0c f7ffffca bgt #0xa01a8cf0
a01a8d10 0030a0e3 mov r3, #0
a01a8d14 003087e5 str r3, [r7]
a01a8d18 80ffffea b #0xa01a8b20
a01a8d1c d10fa0e3 mov r0, #0x344
a01a8d20 0620a0e1 mov r2, r6
a01a8d24 01004fe3 movt r0, #0xf001
a01a8d28 0910a0e3 mov r1, #9
a01a8d2c 1af600eb bl #0xa01e659c
a01a8d30 300409e3 movw r0, #0x9430
a01a8d34 041094e5 ldr r1, [r4, #4]
a01a8d38 56004ae3 movt r0, #0xa056
a01a8d3c 35ff2fe1 blx r5
a01a8d40 54ffffea b #0xa01a8a98
a01a8d44 d10fa0e3 mov r0, #0x344
a01a8d48 0620a0e1 mov r2, r6
a01a8d4c 01004fe3 movt r0, #0xf001
a01a8d50 0410a0e3 mov r1, #4
a01a8d54 f4ffffea b #0xa01a8d2c
