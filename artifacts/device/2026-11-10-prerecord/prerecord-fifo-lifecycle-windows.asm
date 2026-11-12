a0233434 410351e3 cmp r1, #0x4000001
a0233438 1700000a beq #0xa023349c
a023343c 810351e3 cmp r1, #0x4000002
a0233440 10402de9 push {r4, lr}
a0233444 0040a0e1 mov r4, r0
a0233448 10d04de2 sub sp, sp, #0x10
a023344c 0500000a beq #0xa0233468
a0233450 f80303e3 movw r0, #0x33f8
a0233454 58004ae3 movt r0, #0xa058
a0233458 23cf01eb bl #0xa02a70ec
a023345c 0000a0e3 mov r0, #0
a0233460 10d08de2 add sp, sp, #0x10
a0233464 1080bde8 pop {r4, pc}
a0233468 0c108de2 add r1, sp, #0xc
a023346c 0020a0e3 mov r2, #0
a0233470 3a7908eb bl #0xa0451960
a0233474 603b0fe3 movw r3, #0xfb60
a0233478 42314ae3 movt r3, #0xa142
a023347c 000093e5 ldr r0, [r3]
a0233480 000054e1 cmp r4, r0
a0233484 0600000a beq #0xa02334a4
a0233488 0110a0e3 mov r1, #1
a023348c 007a08eb bl #0xa0451c94
a0233490 0000a0e3 mov r0, #0
a0233494 10d08de2 add sp, sp, #0x10
a0233498 1080bde8 pop {r4, pc}
a023349c 0000a0e3 mov r0, #0
a02334a0 1eff2fe1 bx lr
a02334a4 503b0fe3 movw r3, #0xfb50
a02334a8 42314ae3 movt r3, #0xa142
a02334ac 003093e5 ldr r3, [r3]
a02334b0 000053e3 cmp r3, #0
a02334b4 f3ffff0a beq #0xa0233488
a02334b8 0c309de5 ldr r3, [sp, #0xc]
a02334bc ff24e0e3 mvn r2, #0xff000000
a02334c0 181093e5 ldr r1, [r3, #0x18]
a02334c4 020051e1 cmp r1, r2
a02334c8 eeffff0a beq #0xa0233488
a02334cc 1020d3e5 ldrb r2, [r3, #0x10]
a02334d0 012042e2 sub r2, r2, #1
a02334d4 020052e3 cmp r2, #2
a02334d8 eaffff8a bhi #0xa0233488
a02334dc 142a0fe3 movw r2, #0xfa14
a02334e0 48cb0fe3 movw ip, #0xfb48
a02334e4 42c14ae3 movt ip, #0xa142
a02334e8 00e0a0e3 mov lr, #0
a02334ec 42214ae3 movt r2, #0xa142
a02334f0 140093e5 ldr r0, [r3, #0x14]
a02334f4 002092e5 ldr r2, [r2]
a02334f8 00309ce5 ldr r3, [ip]
a02334fc 00e08de5 str lr, [sp]
a0233500 b3ffffeb bl #0xa02333d4
a0233504 d4ffffea b #0xa023345c
a0233508 30402de9 push {r4, r5, lr}
a023350c 5c4b0fe3 movw r4, #0xfb5c
a0233510 42414ae3 movt r4, #0xa142
a0233514 441b0fe3 movw r1, #0xfb44
a0233518 42114ae3 movt r1, #0xa142
a023351c 5cd04de2 sub sp, sp, #0x5c
a0233520 0400a0e1 mov r0, r4
a0233524 605b0fe3 movw r5, #0xfb60
a0233528 4279ffeb bl #0xa0211a38
a023352c 42514ae3 movt r5, #0xa142
a0233530 e80208e3 movw r0, #0x82e8
a0233534 3c014ae3 movt r0, #0xa13c
a0233538 001095e5 ldr r1, [r5]
a023353c 00c090e5 ldr ip, [r0]
a0233540 483b0fe3 movw r3, #0xfb48
a0233544 002094e5 ldr r2, [r4]
a0233548 140a0fe3 movw r0, #0xfa14
a023354c 000051e3 cmp r1, #0
a0233550 42314ae3 movt r3, #0xa142
a0233554 42014ae3 movt r0, #0xa142
a0233558 02208ce0 add r2, ip, r2
a023355c 00c080e5 str ip, [r0]
a0233560 002083e5 str r2, [r3]
a0233564 0100000a beq #0xa0233570
a0233568 5cd08de2 add sp, sp, #0x5c
a023356c 3080bde8 pop {r4, r5, pc}
a0233570 5820a0e3 mov r2, #0x58
a0233574 0d00a0e1 mov r0, sp
a0233578 1b160bfa blx #0xa04f8dec
a023357c d84208e3 movw r4, #0x82d8
a0233580 0d00a0e1 mov r0, sp
a0233584 097508eb bl #0xa04509b0
a0233588 3c414ae3 movt r4, #0xa13c
a023358c 9c0c00e3 movw r0, #0xc9c
a0233590 001094e5 ldr r1, [r4]
a0233594 5a004ae3 movt r0, #0xa05a
a0233598 d3ce01eb bl #0xa02a70ec
a023359c 00e094e5 ldr lr, [r4]
a02335a0 343403e3 movw r3, #0x3434
a02335a4 23304ae3 movt r3, #0xa023
a02335a8 01c0a0e3 mov ip, #1
a02335ac 022aa0e3 mov r2, #0x2000
a02335b0 0d00a0e1 mov r0, sp
a02335b4 0510a0e1 mov r1, r5
a02335b8 00e08de5 str lr, [sp]
a02335bc 0c308de5 str r3, [sp, #0xc]
a02335c0 04108de9 stmib sp, {r2, ip}
a02335c4 047508eb bl #0xa04509dc
a02335c8 5cd08de2 add sp, sp, #0x5c
a02335cc 3080bde8 pop {r4, r5, pc}
a02335d0 10402de9 push {r4, lr}
a02335d4 604b0fe3 movw r4, #0xfb60
a02335d8 42414ae3 movt r4, #0xa142
a02335dc 000094e5 ldr r0, [r4]
a02335e0 000050e3 cmp r0, #0
a02335e4 1080bd08 popeq {r4, pc}
a02335e8 bd7708eb bl #0xa04514e4
a02335ec 0030a0e3 mov r3, #0
a02335f0 003084e5 str r3, [r4]
a02335f4 1080bde8 pop {r4, pc}
a04509b0 10402de9 push {r4, lr}
a04509b4 0010a0e3 mov r1, #0
a04509b8 5820a0e3 mov r2, #0x58
a04509bc 0040a0e1 mov r4, r0
a04509c0 09a102fa blx #0xa04f8dec
a04509c4 8020a0e3 mov r2, #0x80
a04509c8 0130a0e3 mov r3, #1
a04509cc 042084e5 str r2, [r4, #4]
a04509d0 0000a0e3 mov r0, #0
a04509d4 083084e5 str r3, [r4, #8]
a04509d8 1080bde8 pop {r4, pc}
a04509dc f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04509e0 54d04de2 sub sp, sp, #0x54
a04509e4 0c3090e5 ldr r3, [r0, #0xc]
a04509e8 0070a0e1 mov r7, r0
a04509ec 1c108de5 str r1, [sp, #0x1c]
a04509f0 000053e3 cmp r3, #0
a04509f4 a202000a beq #0xa0451484
a04509f8 088090e5 ldr r8, [r0, #8]
a04509fc 8c6106e3 movw r6, #0x618c
a0450a00 96614ae3 movt r6, #0xa196
a0450a04 000058e3 cmp r8, #0
a0450a08 3000001a bne #0xa0450ad0
a0450a0c 543096e5 ldr r3, [r6, #0x54]
a0450a10 000053e3 cmp r3, #0
a0450a14 0850a011 movne r5, r8
a0450a18 1f00001a bne #0xa0450a9c
a0450a1c 0040a0e3 mov r4, #0
a0450a20 e8030de3 movw r0, #0xd3e8
a0450a24 dc1901e3 movw r1, #0x19dc
a0450a28 74290de3 movw r2, #0xd974
a0450a2c 533600e3 movw r3, #0x653
a0450a30 00408de5 str r4, [sp]
a0450a34 61004ae3 movt r0, #0xa061
a0450a38 60104ae3 movt r1, #0xa060
a0450a3c 61204ae3 movt r2, #0xa061
a0450a40 a959f9eb bl #0xa02a70ec
a0450a44 1c309de5 ldr r3, [sp, #0x1c]
a0450a48 0000e0e3 mvn r0, #0
a0450a4c 004083e5 str r4, [r3]
a0450a50 b40000ea b #0xa0450d28
a0450a54 14b084e2 add fp, r4, #0x14
a0450a58 0b00a0e1 mov r0, fp
a0450a5c 82aefdeb bl #0xa03bc46c
a0450a60 000050e3 cmp r0, #0
a0450a64 0b00a0e1 mov r0, fp
a0450a68 0300001a bne #0xa0450a7c
a0450a6c 0c3094e5 ldr r3, [r4, #0xc]
a0450a70 000053e3 cmp r3, #0
a0450a74 3a00000a beq #0xa0450b64
a0450a78 86aefdeb bl #0xa03bc498
a0450a7c 0a00a0e1 mov r0, sl
a0450a80 84aefdeb bl #0xa03bc498
a0450a84 015085e2 add r5, r5, #1
a0450a88 543096e5 ldr r3, [r6, #0x54]
a0450a8c 7550efe6 uxtb r5, r5
a0450a90 7580afe6 sxtb r8, r5
a0450a94 030058e1 cmp r8, r3
a0450a98 3500002a bhs #0xa0450b74
a0450a9c 0834a0e1 lsl r3, r8, #8
a0450aa0 044096e5 ldr r4, [r6, #4]
a0450aa4 0010a0e3 mov r1, #0
a0450aa8 883143e0 sub r3, r3, r8, lsl #3
a0450aac 8c9106e3 movw sb, #0x618c
a0450ab0 96914ae3 movt sb, #0xa196
a0450ab4 034084e0 add r4, r4, r3
a0450ab8 48a084e2 add sl, r4, #0x48
a0450abc 0a00a0e1 mov r0, sl
a0450ac0 69aefdeb bl #0xa03bc46c
a0450ac4 001050e2 subs r1, r0, #0
a0450ac8 edffff1a bne #0xa0450a84
a0450acc e0ffffea b #0xa0450a54
a0450ad0 503096e5 ldr r3, [r6, #0x50]
a0450ad4 000053e3 cmp r3, #0
a0450ad8 0080a013 movne r8, #0
a0450adc 0850a011 movne r5, r8
a0450ae0 0600001a bne #0xa0450b00
a0450ae4 9a0000ea b #0xa0450d54
a0450ae8 015085e2 add r5, r5, #1
a0450aec 503096e5 ldr r3, [r6, #0x50]
a0450af0 7550efe6 uxtb r5, r5
a0450af4 7580afe6 sxtb r8, r5
a0450af8 030058e1 cmp r8, r3
a0450afc 9100002a bhs #0xa0450d48
a0450b00 0834a0e1 lsl r3, r8, #8
a0450b04 084096e5 ldr r4, [r6, #8]
a0450b08 0010a0e3 mov r1, #0
a0450b0c 883143e0 sub r3, r3, r8, lsl #3
a0450b10 8cb106e3 movw fp, #0x618c
a0450b14 96b14ae3 movt fp, #0xa196
a0450b18 034084e0 add r4, r4, r3
a0450b1c 489084e2 add sb, r4, #0x48
a0450b20 0900a0e1 mov r0, sb
a0450b24 50aefdeb bl #0xa03bc46c
a0450b28 001050e2 subs r1, r0, #0
a0450b2c edffff1a bne #0xa0450ae8
a0450b30 14a084e2 add sl, r4, #0x14
a0450b34 0a00a0e1 mov r0, sl
a0450b38 4baefdeb bl #0xa03bc46c
a0450b3c 000050e3 cmp r0, #0
a0450b40 0a00a0e1 mov r0, sl
a0450b44 0300001a bne #0xa0450b58
a0450b48 0c3094e5 ldr r3, [r4, #0xc]
a0450b4c 000053e3 cmp r3, #0
a0450b50 3c01000a beq #0xa0451048
a0450b54 4faefdeb bl #0xa03bc498
a0450b58 0900a0e1 mov r0, sb
a0450b5c 4daefdeb bl #0xa03bc498
a0450b60 e0ffffea b #0xa0450ae8
a0450b64 0120a0e3 mov r2, #1
a0450b68 103084e5 str r3, [r4, #0x10]
a0450b6c 0c2084e5 str r2, [r4, #0xc]
a0450b70 543099e5 ldr r3, [sb, #0x54]
a0450b74 030058e1 cmp r8, r3
a0450b78 a7ffff0a beq #0xa0450a1c
a0450b7c 00c0a0e3 mov ip, #0
a0450b80 54199fe5 ldr r1, [pc, #0x954]
a0450b84 0030a0e3 mov r3, #0
a0450b88 020000ea b #0xa0450b98
a0450b8c 013083e2 add r3, r3, #1
a0450b90 400053e3 cmp r3, #0x40
a0450b94 7c00000a beq #0xa0450d8c
a0450b98 0420b1e5 ldr r2, [r1, #4]!
a0450b9c 7300efe6 uxtb r0, r3
a0450ba0 000052e3 cmp r2, #0
a0450ba4 f8ffff1a bne #0xa0450b8c
a0450ba8 7000afe6 sxtb r0, r0
a0450bac 8c1006e3 movw r1, #0x608c
a0450bb0 96114ae3 movt r1, #0xa196
a0450bb4 000084e5 str r0, [r4]
a0450bb8 0100a0e3 mov r0, #1
a0450bbc 034181e7 str r4, [r1, r3, lsl #2]
a0450bc0 044084e5 str r4, [r4, #4]
a0450bc4 003097e5 ldr r3, [r7]
a0450bc8 083084e5 str r3, [r4, #8]
a0450bcc 0c3097e5 ldr r3, [r7, #0xc]
a0450bd0 a43084e5 str r3, [r4, #0xa4]
a0450bd4 1c30d7e5 ldrb r3, [r7, #0x1c]
a0450bd8 b030c4e5 strb r3, [r4, #0xb0]
a0450bdc 203097e5 ldr r3, [r7, #0x20]
a0450be0 b83084e5 str r3, [r4, #0xb8]
a0450be4 243097e5 ldr r3, [r7, #0x24]
a0450be8 bc3084e5 str r3, [r4, #0xbc]
a0450bec 103097e5 ldr r3, [r7, #0x10]
a0450bf0 a83084e5 str r3, [r4, #0xa8]
a0450bf4 143097e5 ldr r3, [r7, #0x14]
a0450bf8 b42084e5 str r2, [r4, #0xb4]
a0450bfc c42084e5 str r2, [r4, #0xc4]
a0450c00 ac3084e5 str r3, [r4, #0xac]
a0450c04 283097e5 ldr r3, [r7, #0x28]
a0450c08 f400c4e5 strb r0, [r4, #0xf4]
a0450c0c c83084e5 str r3, [r4, #0xc8]
a0450c10 042097e5 ldr r2, [r7, #4]
a0450c14 000052e3 cmp r2, #0
a0450c18 0200001a bne #0xa0450c28
a0450c1c 00005ce3 cmp ip, #0
a0450c20 2202000a beq #0xa04514b0
a0450c24 88209ce5 ldr r2, [ip, #0x88]
a0450c28 8232a0e1 lsl r3, r2, #5
a0450c2c 2000a0e3 mov r0, #0x20
a0450c30 882084e5 str r2, [r4, #0x88]
a0450c34 801084e2 add r1, r4, #0x80
a0450c38 843084e5 str r3, [r4, #0x84]
a0450c3c a02084e2 add r2, r4, #0xa0
a0450c40 00008de5 str r0, [sp]
a0450c44 94089fe5 ldr r0, [pc, #0x894]
a0450c48 e226f9eb bl #0xa029a7d8
a0450c4c 003050e2 subs r3, r0, #0
a0450c50 7f01001a bne #0xa0451254
a0450c54 0310a0e1 mov r1, r3
a0450c58 800094e5 ldr r0, [r4, #0x80]
a0450c5c 842094e5 ldr r2, [r4, #0x84]
a0450c60 61a002fa blx #0xa04f8dec
a0450c64 081097e5 ldr r1, [r7, #8]
a0450c68 000051e3 cmp r1, #0
a0450c6c 2f00000a beq #0xa0450d30
a0450c70 3030d7e5 ldrb r3, [r7, #0x30]
a0450c74 108094e5 ldr r8, [r4, #0x10]
a0450c78 000053e3 cmp r3, #0
a0450c7c 5300001a bne #0xa0450dd0
a0450c80 145088e2 add r5, r8, #0x14
a0450c84 0010e0e3 mvn r1, #0
a0450c88 0500a0e1 mov r0, r5
a0450c8c f6adfdeb bl #0xa03bc46c
a0450c90 d829c8e1 ldrd r2, r3, [r8, #0x98]
a0450c94 0500a0e1 mov r0, r5
a0450c98 f829c4e1 strd r2, r3, [r4, #0x98]
a0450c9c fdadfdeb bl #0xa03bc498
a0450ca0 983094e5 ldr r3, [r4, #0x98]
a0450ca4 ff10a0e3 mov r1, #0xff
a0450ca8 9c2094e5 ldr r2, [r4, #0x9c]
a0450cac c01084e5 str r1, [r4, #0xc0]
a0450cb0 0300a0e1 mov r0, r3
a0450cb4 0310a0e1 mov r1, r3
a0450cb8 903084e5 str r3, [r4, #0x90]
a0450cbc 942084e5 str r2, [r4, #0x94]
a0450cc0 103094e5 ldr r3, [r4, #0x10]
a0450cc4 b0c30de3 movw ip, #0xd3b0
a0450cc8 04008de5 str r0, [sp, #4]
a0450ccc 61c04ae3 movt ip, #0xa061
a0450cd0 00108de5 str r1, [sp]
a0450cd4 b8230de3 movw r2, #0xd3b8
a0450cd8 881094e5 ldr r1, [r4, #0x88]
a0450cdc 000053e3 cmp r3, #0
a0450ce0 61204ae3 movt r2, #0xa061
a0450ce4 0c20a001 moveq r2, ip
a0450ce8 d8040de3 movw r0, #0xd4d8
a0450cec 08108de5 str r1, [sp, #8]
a0450cf0 61004ae3 movt r0, #0xa061
a0450cf4 80c094e5 ldr ip, [r4, #0x80]
a0450cf8 0410a0e1 mov r1, r4
a0450cfc 0cc08de5 str ip, [sp, #0xc]
a0450d00 84c094e5 ldr ip, [r4, #0x84]
a0450d04 10c08de5 str ip, [sp, #0x10]
a0450d08 f758f9eb bl #0xa02a70ec
a0450d0c 1c309de5 ldr r3, [sp, #0x1c]
a0450d10 140084e2 add r0, r4, #0x14
a0450d14 004083e5 str r4, [r3]
a0450d18 deadfdeb bl #0xa03bc498
a0450d1c 480084e2 add r0, r4, #0x48
a0450d20 dcadfdeb bl #0xa03bc498
a0450d24 0000a0e3 mov r0, #0
a0450d28 54d08de2 add sp, sp, #0x54
a0450d2c f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0450d30 0020a0e3 mov r2, #0
a0450d34 0030a0e3 mov r3, #0
a0450d38 0100a0e1 mov r0, r1
a0450d3c f029c4e1 strd r2, r3, [r4, #0x90]
a0450d40 f829c4e1 strd r2, r3, [r4, #0x98]
a0450d44 ddffffea b #0xa0450cc0
a0450d48 00c0a0e3 mov ip, #0
a0450d4c 030058e1 cmp r8, r3
a0450d50 8affff1a bne #0xa0450b80
a0450d54 0040a0e3 mov r4, #0
a0450d58 0c040de3 movw r0, #0xd40c
a0450d5c dc1901e3 movw r1, #0x19dc
a0450d60 74290de3 movw r2, #0xd974
a0450d64 383600e3 movw r3, #0x638
a0450d68 00408de5 str r4, [sp]
a0450d6c 61004ae3 movt r0, #0xa061
a0450d70 60104ae3 movt r1, #0xa060
a0450d74 61204ae3 movt r2, #0xa061
a0450d78 db58f9eb bl #0xa02a70ec
a0450d7c 1c309de5 ldr r3, [sp, #0x1c]
a0450d80 0000e0e3 mvn r0, #0
a0450d84 004083e5 str r4, [r3]
a0450d88 e6ffffea b #0xa0450d28
a0450d8c 0030a0e3 mov r3, #0
a0450d90 28050de3 movw r0, #0xd528
a0450d94 dc1901e3 movw r1, #0x19dc
a0450d98 74290de3 movw r2, #0xd974
a0450d9c 60104ae3 movt r1, #0xa060
a0450da0 61204ae3 movt r2, #0xa061
a0450da4 00308de5 str r3, [sp]
a0450da8 61004ae3 movt r0, #0xa061
a0450dac 633600e3 movw r3, #0x663
a0450db0 cd58f9eb bl #0xa02a70ec
a0450db4 140084e2 add r0, r4, #0x14
a0450db8 b6adfdeb bl #0xa03bc498
a0450dbc 480084e2 add r0, r4, #0x48
a0450dc0 b4adfdeb bl #0xa03bc498
a0450dc4 0000e0e3 mvn r0, #0
a0450dc8 54d08de2 add sp, sp, #0x54
a0450dcc f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0450dd0 140088e2 add r0, r8, #0x14
a0450dd4 0010e0e3 mvn r1, #0
a0450dd8 28008de5 str r0, [sp, #0x28]
a0450ddc 889098e5 ldr sb, [r8, #0x88]
a0450de0 a1adfdeb bl #0xa03bc46c
a0450de4 d829c8e1 ldrd r2, r3, [r8, #0x98]
a0450de8 88a094e5 ldr sl, [r4, #0x88]
a0450dec f829c4e1 strd r2, r3, [r4, #0x98]
a0450df0 901098e5 ldr r1, [r8, #0x90]
a0450df4 01e04ae2 sub lr, sl, #1
a0450df8 940098e5 ldr r0, [r8, #0x94]
a0450dfc 02c061e0 rsb ip, r1, r2
a0450e00 901084e5 str r1, [r4, #0x90]
a0450e04 0e005ce1 cmp ip, lr
a0450e08 940084e5 str r0, [r4, #0x94]
a0450e0c 0300009a bls #0xa0450e20
a0450e10 0e0052e0 subs r0, r2, lr
a0450e14 0ec0a0e1 mov ip, lr
a0450e18 0010c3e2 sbc r1, r3, #0
a0450e1c f009c4e1 strd r0, r1, [r4, #0x90]
a0450e20 3110d7e5 ldrb r1, [r7, #0x31]
a0450e24 020051e3 cmp r1, #2
a0450e28 38909705 ldreq sb, [r7, #0x38]
a0450e2c 0c0059e1 cmp sb, ip
a0450e30 0c90a021 movhs sb, ip
a0450e34 090052e0 subs r0, r2, sb
a0450e38 0010c3e2 sbc r1, r3, #0
a0450e3c 000059e3 cmp sb, #0
a0450e40 0020a0e1 mov r2, r0
a0450e44 0130a0e1 mov r3, r1
a0450e48 f022cde1 strd r2, r3, [sp, #0x20]
a0450e4c f029c4e1 strd r2, r3, [r4, #0x90]
a0450e50 3100000a beq #0xa0450f1c
a0450e54 20009de5 ldr r0, [sp, #0x20]
a0450e58 0a10a0e1 mov r1, sl
a0450e5c 04d602fa blx #0xa0506674
a0450e60 806094e5 ldr r6, [r4, #0x80]
a0450e64 d022cde1 ldrd r2, r3, [sp, #0x20]
a0450e68 88b098e5 ldr fp, [r8, #0x88]
a0450e6c 023089e0 add r3, sb, r2
a0450e70 0200a0e1 mov r0, r2
a0450e74 816286e0 add r6, r6, r1, lsl #5
a0450e78 0b10a0e1 mov r1, fp
a0450e7c 20909de5 ldr sb, [sp, #0x20]
a0450e80 30308de5 str r3, [sp, #0x30]
a0450e84 fad502fa blx #0xa0506674
a0450e88 805098e5 ldr r5, [r8, #0x80]
a0450e8c 20708de5 str r7, [sp, #0x20]
a0450e90 0970a0e1 mov r7, sb
a0450e94 30909de5 ldr sb, [sp, #0x30]
a0450e98 815285e0 add r5, r5, r1, lsl #5
a0450e9c 001095e5 ldr r1, [r5]
a0450ea0 017087e2 add r7, r7, #1
a0450ea4 04e095e5 ldr lr, [r5, #4]
a0450ea8 0700a0e1 mov r0, r7
a0450eac 08c095e5 ldr ip, [r5, #8]
a0450eb0 206086e2 add r6, r6, #0x20
a0450eb4 0c2095e5 ldr r2, [r5, #0xc]
a0450eb8 205085e2 add r5, r5, #0x20
a0450ebc 201006e5 str r1, [r6, #-0x20]
a0450ec0 1ce006e5 str lr, [r6, #-0x1c]
a0450ec4 18c006e5 str ip, [r6, #-0x18]
a0450ec8 142006e5 str r2, [r6, #-0x14]
a0450ecc 0ce015e5 ldr lr, [r5, #-0xc]
a0450ed0 08c015e5 ldr ip, [r5, #-8]
a0450ed4 042015e5 ldr r2, [r5, #-4]
a0450ed8 101015e5 ldr r1, [r5, #-0x10]
a0450edc 0ce006e5 str lr, [r6, #-0xc]
a0450ee0 08c006e5 str ip, [r6, #-8]
a0450ee4 101006e5 str r1, [r6, #-0x10]
a0450ee8 0a10a0e1 mov r1, sl
a0450eec 042006e5 str r2, [r6, #-4]
a0450ef0 dfd502fa blx #0xa0506674
a0450ef4 0700a0e1 mov r0, r7
a0450ef8 000051e3 cmp r1, #0
a0450efc 0b10a0e1 mov r1, fp
a0450f00 80609405 ldreq r6, [r4, #0x80]
a0450f04 dad502fa blx #0xa0506674
a0450f08 000051e3 cmp r1, #0
a0450f0c 80509805 ldreq r5, [r8, #0x80]
a0450f10 090057e1 cmp r7, sb
a0450f14 e0ffff1a bne #0xa0450e9c
a0450f18 20709de5 ldr r7, [sp, #0x20]
a0450f1c 28009de5 ldr r0, [sp, #0x28]
a0450f20 5cadfdeb bl #0xa03bc498
a0450f24 4030d7e5 ldrb r3, [r7, #0x40]
a0450f28 c03084e5 str r3, [r4, #0xc0]
a0450f2c 3130d7e5 ldrb r3, [r7, #0x31]
a0450f30 020053e3 cmp r3, #2
a0450f34 0900000a beq #0xa0450f60
a0450f38 010053e3 cmp r3, #1
a0450f3c 6b00000a beq #0xa04510f0
a0450f40 030053e3 cmp r3, #3
a0450f44 d400000a beq #0xa045129c
a0450f48 040053e3 cmp r3, #4
a0450f4c 6000000a beq #0xa04510d4
a0450f50 28509de5 ldr r5, [sp, #0x28]
a0450f54 0010e0e3 mvn r1, #0
a0450f58 0500a0e1 mov r0, r5
a0450f5c 4affffea b #0xa0450c8c
a0450f60 d089c4e1 ldrd r8, sb, [r4, #0x90]
a0450f64 0030a0e3 mov r3, #0
a0450f68 885094e5 ldr r5, [r4, #0x88]
a0450f6c 0800a0e1 mov r0, r8
a0450f70 0910a0e1 mov r1, sb
a0450f74 0520a0e1 mov r2, r5
a0450f78 eed702fa blx #0xa0506f38
a0450f7c d809c4e1 ldrd r0, r1, [r4, #0x98]
a0450f80 0030a0e3 mov r3, #0
a0450f84 20208de5 str r2, [sp, #0x20]
a0450f88 0520a0e1 mov r2, r5
a0450f8c e9d702fa blx #0xa0506f38
a0450f90 803094e5 ldr r3, [r4, #0x80]
a0450f94 006052e2 subs r6, r2, #0
a0450f98 20c09de5 ldr ip, [sp, #0x20]
a0450f9c 7e234612 subne r2, r6, #0xf8000001
a0450fa0 40a0d7e5 ldrb sl, [r7, #0x40]
a0450fa4 0300a0e1 mov r0, r3
a0450fa8 82228310 addne r2, r3, r2, lsl #5
a0450fac 8cb283e0 add fp, r3, ip, lsl #5
a0450fb0 0b20a001 moveq r2, fp
a0450fb4 06005ce1 cmp ip, r6
a0450fb8 d820c2e1 ldrd r2, r3, [r2, #8]
a0450fbc f822cde1 strd r2, r3, [sp, #0x28]
a0450fc0 1600000a beq #0xa0451020
a0450fc4 1020dbe5 ldrb r2, [fp, #0x10]
a0450fc8 0a0052e1 cmp r2, sl
a0450fcc 20708d15 strne r7, [sp, #0x20]
a0450fd0 0c10a011 movne r1, ip
a0450fd4 0b70a011 movne r7, fp
a0450fd8 00b0a011 movne fp, r0
a0450fdc 0300001a bne #0xa0450ff0
a0450fe0 ed0000ea b #0xa045139c
a0450fe4 1020d7e5 ldrb r2, [r7, #0x10]
a0450fe8 0a0052e1 cmp r2, sl
a0450fec e800000a beq #0xa0451394
a0450ff0 018098e2 adds r8, r8, #1
a0450ff4 010081e2 add r0, r1, #1
a0450ff8 0510a0e1 mov r1, r5
a0450ffc 0090a9e2 adc sb, sb, #0
a0451000 9bd502fa blx #0xa0506674
a0451004 000051e3 cmp r1, #0
a0451008 207087e2 add r7, r7, #0x20
a045100c 0b70a001 moveq r7, fp
a0451010 010056e1 cmp r6, r1
a0451014 f089c4e1 strd r8, sb, [r4, #0x90]
a0451018 f1ffff1a bne #0xa0450fe4
a045101c 20709de5 ldr r7, [sp, #0x20]
a0451020 0000e0e3 mvn r0, #0
a0451024 0010e0e3 mvn r1, #0
a0451028 0020a0e3 mov r2, #0
a045102c 0030a0e3 mov r3, #0
a0451030 f804c7e1 strd r0, r1, [r7, #0x48]
a0451034 f025c7e1 strd r2, r3, [r7, #0x50]
a0451038 c0a084e5 str sl, [r4, #0xc0]
a045103c 981094e5 ldr r1, [r4, #0x98]
a0451040 900094e5 ldr r0, [r4, #0x90]
a0451044 1dffffea b #0xa0450cc0
a0451048 0120a0e3 mov r2, #1
a045104c 04c09be5 ldr ip, [fp, #4]
a0451050 0c2084e5 str r2, [r4, #0xc]
a0451054 54109be5 ldr r1, [fp, #0x54]
a0451058 000097e5 ldr r0, [r7]
a045105c 000051e3 cmp r1, #0
a0451060 0400001a bne #0xa0451078
a0451064 6f0000ea b #0xa0451228
a0451068 013083e2 add r3, r3, #1
a045106c f8c08ce2 add ip, ip, #0xf8
a0451070 010053e1 cmp r3, r1
a0451074 6b00000a beq #0xa0451228
a0451078 08209ce5 ldr r2, [ip, #8]
a045107c 020050e1 cmp r0, r2
a0451080 f8ffff1a bne #0xa0451068
a0451084 00005ce3 cmp ip, #0
a0451088 10c08415 strne ip, [r4, #0x10]
a045108c 50309615 ldrne r3, [r6, #0x50]
a0451090 2dffff1a bne #0xa0450d4c
a0451094 0030a0e3 mov r3, #0
a0451098 54040de3 movw r0, #0xd454
a045109c dc1901e3 movw r1, #0x19dc
a04510a0 74290de3 movw r2, #0xd974
a04510a4 60104ae3 movt r1, #0xa060
a04510a8 61204ae3 movt r2, #0xa061
a04510ac 00308de5 str r3, [sp]
a04510b0 61004ae3 movt r0, #0xa061
a04510b4 2a3600e3 movw r3, #0x62a
a04510b8 0b58f9eb bl #0xa02a70ec
a04510bc 0a00a0e1 mov r0, sl
a04510c0 f4acfdeb bl #0xa03bc498
a04510c4 0900a0e1 mov r0, sb
a04510c8 f2acfdeb bl #0xa03bc498
a04510cc 0000e0e3 mvn r0, #0
a04510d0 14ffffea b #0xa0450d28
a04510d4 4030d7e5 ldrb r3, [r7, #0x40]
a04510d8 0120a0e3 mov r2, #1
a04510dc c42084e5 str r2, [r4, #0xc4]
a04510e0 981094e5 ldr r1, [r4, #0x98]
a04510e4 c03084e5 str r3, [r4, #0xc0]
a04510e8 900094e5 ldr r0, [r4, #0x90]
a04510ec f3feffea b #0xa0450cc0
a04510f0 886094e5 ldr r6, [r4, #0x88]
a04510f4 0030a0e3 mov r3, #0
a04510f8 d009c4e1 ldrd r0, r1, [r4, #0x90]
a04510fc 0620a0e1 mov r2, r6
a0451100 f803cde1 strd r0, r1, [sp, #0x38]
a0451104 8bd702fa blx #0xa0506f38
a0451108 d809c4e1 ldrd r0, r1, [r4, #0x98]
a045110c 0290a0e1 mov sb, r2
a0451110 0030a0e3 mov r3, #0
a0451114 0620a0e1 mov r2, r6
a0451118 86d702fa blx #0xa0506f38
a045111c 280097e5 ldr r0, [r7, #0x28]
a0451120 008052e2 subs r8, r2, #0
a0451124 3cc097e5 ldr ip, [r7, #0x3c]
a0451128 7ee34812 subne lr, r8, #0xf8000001
a045112c 803094e5 ldr r3, [r4, #0x80]
a0451130 381097e5 ldr r1, [r7, #0x38]
a0451134 2ca097e5 ldr sl, [r7, #0x2c]
a0451138 900c0ce0 mul ip, r0, ip
a045113c 38b097e5 ldr fp, [r7, #0x38]
a0451140 895283e0 add r5, r3, sb, lsl #5
a0451144 4020d7e5 ldrb r2, [r7, #0x40]
a0451148 900181e0 umull r0, r1, r0, r1
a045114c 8ee28310 addne lr, r3, lr, lsl #5
a0451150 05e0a001 moveq lr, r5
a0451154 30308de5 str r3, [sp, #0x30]
a0451158 34208de5 str r2, [sp, #0x34]
a045115c 0030a0e3 mov r3, #0
a0451160 fa2fa0e3 mov r2, #0x3e8
a0451164 9bca2ce0 mla ip, fp, sl, ip
a0451168 d8a0cee1 ldrd sl, fp, [lr, #8]
a045116c f0a4cde1 strd sl, fp, [sp, #0x40]
a0451170 01108ce0 add r1, ip, r1
a0451174 6fd702fa blx #0xa0506f38
a0451178 01005be1 cmp fp, r1
a045117c 00005a01 cmpeq sl, r0
a0451180 a500009a bls #0xa045141c
a0451184 d024cde1 ldrd r2, r3, [sp, #0x40]
a0451188 002052e0 subs r2, r2, r0
a045118c 0130c3e0 sbc r3, r3, r1
a0451190 f022cde1 strd r2, r3, [sp, #0x20]
a0451194 080059e1 cmp sb, r8
a0451198 1700000a beq #0xa04511fc
a045119c d8a3cde1 ldrd sl, fp, [sp, #0x38]
a04511a0 28608de5 str r6, [sp, #0x28]
a04511a4 48708de5 str r7, [sp, #0x48]
a04511a8 d820c5e1 ldrd r2, r3, [r5, #8]
a04511ac 010089e2 add r0, sb, #1
a04511b0 d062cde1 ldrd r6, r7, [sp, #0x20]
a04511b4 28109de5 ldr r1, [sp, #0x28]
a04511b8 030057e1 cmp r7, r3
a04511bc 02005601 cmpeq r6, r2
a04511c0 0300002a bhs #0xa04511d4
a04511c4 10c0d5e5 ldrb ip, [r5, #0x10]
a04511c8 34e09de5 ldr lr, [sp, #0x34]
a04511cc 0e005ce1 cmp ip, lr
a04511d0 9500000a beq #0xa045142c
a04511d4 26d502fa blx #0xa0506674
a04511d8 01a09ae2 adds sl, sl, #1
a04511dc 205085e2 add r5, r5, #0x20
a04511e0 00b0abe2 adc fp, fp, #0
a04511e4 009051e2 subs sb, r1, #0
a04511e8 30509d05 ldreq r5, [sp, #0x30]
a04511ec 090058e1 cmp r8, sb
a04511f0 f0a9c4e1 strd sl, fp, [r4, #0x90]
a04511f4 ebffff1a bne #0xa04511a8
a04511f8 48709de5 ldr r7, [sp, #0x48]
a04511fc 0030a0e3 mov r3, #0
a0451200 0020a0e3 mov r2, #0
a0451204 f025c7e1 strd r2, r3, [r7, #0x50]
a0451208 0000e0e3 mvn r0, #0
a045120c 34309de5 ldr r3, [sp, #0x34]
a0451210 0010e0e3 mvn r1, #0
a0451214 f804c7e1 strd r0, r1, [r7, #0x48]
a0451218 981094e5 ldr r1, [r4, #0x98]
a045121c c03084e5 str r3, [r4, #0xc0]
a0451220 900094e5 ldr r0, [r4, #0x90]
a0451224 a5feffea b #0xa0450cc0
a0451228 0030a0e3 mov r3, #0
a045122c 30040de3 movw r0, #0xd430
a0451230 dc1901e3 movw r1, #0x19dc
a0451234 e8290ce3 movw r2, #0xc9e8
a0451238 00308de5 str r3, [sp]
a045123c 60104ae3 movt r1, #0xa060
a0451240 61204ae3 movt r2, #0xa061
a0451244 c23fa0e3 mov r3, #0x308
a0451248 61004ae3 movt r0, #0xa061
a045124c a657f9eb bl #0xa02a70ec
a0451250 8fffffea b #0xa0451094
a0451254 b8040de3 movw r0, #0xd4b8
a0451258 dc1901e3 movw r1, #0x19dc
a045125c 74290de3 movw r2, #0xd974
a0451260 60104ae3 movt r1, #0xa060
a0451264 00308de5 str r3, [sp]
a0451268 61204ae3 movt r2, #0xa061
a045126c 863600e3 movw r3, #0x686
a0451270 61004ae3 movt r0, #0xa061
a0451274 9c57f9eb bl #0xa02a70ec
a0451278 1c209de5 ldr r2, [sp, #0x1c]
a045127c 0030a0e3 mov r3, #0
a0451280 140084e2 add r0, r4, #0x14
a0451284 003082e5 str r3, [r2]
a0451288 82acfdeb bl #0xa03bc498
a045128c 480084e2 add r0, r4, #0x48
a0451290 80acfdeb bl #0xa03bc498
a0451294 0000e0e3 mvn r0, #0
a0451298 a2feffea b #0xa0450d28
a045129c 886094e5 ldr r6, [r4, #0x88]
a04512a0 0030a0e3 mov r3, #0
a04512a4 d009c4e1 ldrd r0, r1, [r4, #0x90]
a04512a8 0620a0e1 mov r2, r6
a04512ac f803cde1 strd r0, r1, [sp, #0x38]
a04512b0 20d702fa blx #0xa0506f38
a04512b4 d809c4e1 ldrd r0, r1, [r4, #0x98]
a04512b8 0290a0e1 mov sb, r2
a04512bc 0030a0e3 mov r3, #0
a04512c0 0620a0e1 mov r2, r6
a04512c4 1bd702fa blx #0xa0506f38
a04512c8 280097e5 ldr r0, [r7, #0x28]
a04512cc 008052e2 subs r8, r2, #0
a04512d0 3cc097e5 ldr ip, [r7, #0x3c]
a04512d4 7ee34812 subne lr, r8, #0xf8000001
a04512d8 803094e5 ldr r3, [r4, #0x80]
a04512dc 381097e5 ldr r1, [r7, #0x38]
a04512e0 2ca097e5 ldr sl, [r7, #0x2c]
a04512e4 900c0ce0 mul ip, r0, ip
a04512e8 38b097e5 ldr fp, [r7, #0x38]
a04512ec 895283e0 add r5, r3, sb, lsl #5
a04512f0 4020d7e5 ldrb r2, [r7, #0x40]
a04512f4 900181e0 umull r0, r1, r0, r1
a04512f8 8ee28310 addne lr, r3, lr, lsl #5
a04512fc 05e0a001 moveq lr, r5
a0451300 30308de5 str r3, [sp, #0x30]
a0451304 34208de5 str r2, [sp, #0x34]
a0451308 0030a0e3 mov r3, #0
a045130c fa2fa0e3 mov r2, #0x3e8
a0451310 9bca2ce0 mla ip, fp, sl, ip
a0451314 d8a0cee1 ldrd sl, fp, [lr, #8]
a0451318 f8a4cde1 strd sl, fp, [sp, #0x48]
a045131c 01108ce0 add r1, ip, r1
a0451320 04d702fa blx #0xa0506f38
a0451324 080059e1 cmp sb, r8
a0451328 f002cde1 strd r0, r1, [sp, #0x20]
a045132c b2ffff0a beq #0xa04511fc
a0451330 d8a3cde1 ldrd sl, fp, [sp, #0x38]
a0451334 28608de5 str r6, [sp, #0x28]
a0451338 40708de5 str r7, [sp, #0x40]
a045133c d820c5e1 ldrd r2, r3, [r5, #8]
a0451340 010089e2 add r0, sb, #1
a0451344 d062cde1 ldrd r6, r7, [sp, #0x20]
a0451348 28109de5 ldr r1, [sp, #0x28]
a045134c 030057e1 cmp r7, r3
a0451350 02005601 cmpeq r6, r2
a0451354 0300002a bhs #0xa0451368
a0451358 10c0d5e5 ldrb ip, [r5, #0x10]
a045135c 34e09de5 ldr lr, [sp, #0x34]
a0451360 0e005ce1 cmp ip, lr
a0451364 4100000a beq #0xa0451470
a0451368 c1d402fa blx #0xa0506674
a045136c 01a09ae2 adds sl, sl, #1
a0451370 205085e2 add r5, r5, #0x20
a0451374 00b0abe2 adc fp, fp, #0
a0451378 009051e2 subs sb, r1, #0
a045137c 30509d05 ldreq r5, [sp, #0x30]
a0451380 090058e1 cmp r8, sb
a0451384 f0a9c4e1 strd sl, fp, [r4, #0x90]
a0451388 ebffff1a bne #0xa045133c
a045138c 40709de5 ldr r7, [sp, #0x40]
a0451390 99ffffea b #0xa04511fc
a0451394 07b0a0e1 mov fp, r7
a0451398 20709de5 ldr r7, [sp, #0x20]
a045139c d820cbe1 ldrd r2, r3, [fp, #8]
a04513a0 d802cde1 ldrd r0, r1, [sp, #0x28]
a04513a4 f824c7e1 strd r2, r3, [r7, #0x48]
a04513a8 d884c7e1 ldrd r8, sb, [r7, #0x48]
a04513ac d822c7e1 ldrd r2, r3, [r7, #0x28]
a04513b0 080050e0 subs r0, r0, r8
a04513b4 0910c1e0 sbc r1, r1, sb
a04513b8 00a1a0e1 lsl sl, r0, #2
a04513bc 01c1a0e1 lsl ip, r1, #2
a04513c0 20bf8ce1 orr fp, ip, r0, lsr #30
a04513c4 8bc2a0e1 lsl ip, fp, #5
a04513c8 aacd8ce1 orr ip, ip, sl, lsr #27
a04513cc 24c08de5 str ip, [sp, #0x24]
a04513d0 8ac2a0e1 lsl ip, sl, #5
a04513d4 20c08de5 str ip, [sp, #0x20]
a04513d8 d082cde1 ldrd r8, sb, [sp, #0x20]
a04513dc 0a8058e0 subs r8, r8, sl
a04513e0 0b90c9e0 sbc sb, sb, fp
a04513e4 08a090e0 adds sl, r0, r8
a04513e8 09b0a1e0 adc fp, r1, sb
a04513ec 8ae1a0e1 lsl lr, sl, #3
a04513f0 8bc1a0e1 lsl ip, fp, #3
a04513f4 0e00a0e1 mov r0, lr
a04513f8 aace8ce1 orr ip, ip, sl, lsr #29
a04513fc 0c10a0e1 mov r1, ip
a0451400 ccd602fa blx #0xa0506f38
a0451404 ff30a0e3 mov r3, #0xff
a0451408 f005c7e1 strd r0, r1, [r7, #0x50]
a045140c c03084e5 str r3, [r4, #0xc0]
a0451410 981094e5 ldr r1, [r4, #0x98]
a0451414 900094e5 ldr r0, [r4, #0x90]
a0451418 28feffea b #0xa0450cc0
a045141c 0020a0e3 mov r2, #0
a0451420 0030a0e3 mov r3, #0
a0451424 f022cde1 strd r2, r3, [sp, #0x20]
a0451428 59ffffea b #0xa0451194
a045142c 080059e1 cmp sb, r8
a0451430 48709de5 ldr r7, [sp, #0x48]
a0451434 70ffff0a beq #0xa04511fc
a0451438 d004cde1 ldrd r0, r1, [sp, #0x40]
a045143c 020050e0 subs r0, r0, r2
a0451440 f824c7e1 strd r2, r3, [r7, #0x48]
a0451444 0310c1e0 sbc r1, r1, r3
a0451448 00a1a0e1 lsl sl, r0, #2
a045144c 01c1a0e1 lsl ip, r1, #2
a0451450 d822c7e1 ldrd r2, r3, [r7, #0x28]
a0451454 20bf8ce1 orr fp, ip, r0, lsr #30
a0451458 8bc2a0e1 lsl ip, fp, #5
a045145c aacd8ce1 orr ip, ip, sl, lsr #27
a0451460 0c90a0e1 mov sb, ip
a0451464 8ac2a0e1 lsl ip, sl, #5
a0451468 0c80a0e1 mov r8, ip
a045146c daffffea b #0xa04513dc
a0451470 080059e1 cmp sb, r8
a0451474 40709de5 ldr r7, [sp, #0x40]
a0451478 5fffff0a beq #0xa04511fc
a045147c d804cde1 ldrd r0, r1, [sp, #0x48]
a0451480 edffffea b #0xa045143c
a0451484 c0030de3 movw r0, #0xd3c0
a0451488 dc1901e3 movw r1, #0x19dc
a045148c 74290de3 movw r2, #0xd974
a0451490 00308de5 str r3, [sp]
a0451494 61004ae3 movt r0, #0xa061
a0451498 60104ae3 movt r1, #0xa060
a045149c 61204ae3 movt r2, #0xa061
a04514a0 173600e3 movw r3, #0x617
a04514a4 1057f9eb bl #0xa02a70ec
a04514a8 0000e0e3 mvn r0, #0
a04514ac 1dfeffea b #0xa0450d28
a04514b0 80040de3 movw r0, #0xd480
a04514b4 dc1901e3 movw r1, #0x19dc
a04514b8 74290de3 movw r2, #0xd974
a04514bc 00c08de5 str ip, [sp]
a04514c0 61004ae3 movt r0, #0xa061
a04514c4 60104ae3 movt r1, #0xa060
a04514c8 61204ae3 movt r2, #0xa061
a04514cc 7b3600e3 movw r3, #0x67b
a04514d0 0557f9eb bl #0xa02a70ec
a04514d4 0000e0e3 mvn r0, #0
a04514d8 12feffea b #0xa0450d28
a04514dc 886096a1 orrsge r6, r6, r8, lsl #1
a04514e0 a86196a1 orrsge r6, r6, r8, lsr #3
a04514e4 f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
a04514e8 00a0a0e3 mov sl, #0
a04514ec 045090e5 ldr r5, [r0, #4]
a04514f0 18d04de2 sub sp, sp, #0x18
a04514f4 632700e3 movw r2, #0x763
a04514f8 0060a0e1 mov r6, r0
a04514fc 0c10a0e3 mov r1, #0xc
a0451500 0200a0e3 mov r0, #2
a0451504 0530a0e1 mov r3, r5
a0451508 00a08de5 str sl, [sp]
a045150c 04a08de5 str sl, [sp, #4]
a0451510 488085e2 add r8, r5, #0x48
a0451514 08a08de5 str sl, [sp, #8]
a0451518 149085e2 add sb, r5, #0x14
a045151c 84f4ffeb bl #0xa044e734
a0451520 0010e0e3 mvn r1, #0
a0451524 0800a0e1 mov r0, r8
a0451528 cfabfdeb bl #0xa03bc46c
a045152c 0900a0e1 mov r0, sb
a0451530 0010e0e3 mvn r1, #0
a0451534 ccabfdeb bl #0xa03bc46c
a0451538 003096e5 ldr r3, [r6]
a045153c 3f0053e3 cmp r3, #0x3f
a0451540 4300008a bhi #0xa0451654
a0451544 980095e5 ldr r0, [r5, #0x98]
a0451548 b0130de3 movw r1, #0xd3b0
a045154c 103095e5 ldr r3, [r5, #0x10]
a0451550 61104ae3 movt r1, #0xa061
a0451554 b8230de3 movw r2, #0xd3b8
a0451558 8c7006e3 movw r7, #0x608c
a045155c 00008de5 str r0, [sp]
a0451560 54050de3 movw r0, #0xd554
a0451564 90c095e5 ldr ip, [r5, #0x90]
a0451568 000053e3 cmp r3, #0
a045156c 61204ae3 movt r2, #0xa061
a0451570 61004ae3 movt r0, #0xa061
a0451574 0120a001 moveq r2, r1
a0451578 0510a0e1 mov r1, r5
a045157c 04c08de5 str ip, [sp, #4]
a0451580 96714ae3 movt r7, #0xa196
a0451584 88c095e5 ldr ip, [r5, #0x88]
a0451588 08c08de5 str ip, [sp, #8]
a045158c 80c095e5 ldr ip, [r5, #0x80]
a0451590 0cc08de5 str ip, [sp, #0xc]
a0451594 84c095e5 ldr ip, [r5, #0x84]
a0451598 10c08de5 str ip, [sp, #0x10]
a045159c d256f9eb bl #0xa02a70ec
a04515a0 003096e5 ldr r3, [r6]
a04515a4 034197e7 ldr r4, [r7, r3, lsl #2]
a04515a8 000054e3 cmp r4, #0
a04515ac 3100000a beq #0xa0451678
a04515b0 0c4095e5 ldr r4, [r5, #0xc]
a04515b4 000054e3 cmp r4, #0
a04515b8 5a00000a beq #0xa0451728
a04515bc a00095e5 ldr r0, [r5, #0xa0]
a04515c0 000050e3 cmp r0, #0
a04515c4 0200000a beq #0xa04515d4
a04515c8 51acfdeb bl #0xa03bc714
a04515cc 004050e2 subs r4, r0, #0
a04515d0 3c00001a bne #0xa04516c8
a04515d4 80c095e5 ldr ip, [r5, #0x80]
a04515d8 0040a0e3 mov r4, #0
a04515dc 0530a0e1 mov r3, r5
a04515e0 0c10a0e3 mov r1, #0xc
a04515e4 882700e3 movw r2, #0x788
a04515e8 0100a0e3 mov r0, #1
a04515ec 00c08de5 str ip, [sp]
a04515f0 84c095e5 ldr ip, [r5, #0x84]
a04515f4 08408de5 str r4, [sp, #8]
a04515f8 04c08de5 str ip, [sp, #4]
a04515fc 4cf4ffeb bl #0xa044e734
a0451600 a04085e5 str r4, [r5, #0xa0]
a0451604 0900a0e1 mov r0, sb
a0451608 804085e5 str r4, [r5, #0x80]
a045160c 0c4085e5 str r4, [r5, #0xc]
a0451610 084085e5 str r4, [r5, #8]
a0451614 9fabfdeb bl #0xa03bc498
a0451618 0800a0e1 mov r0, r8
a045161c 9dabfdeb bl #0xa03bc498
a0451620 00c096e5 ldr ip, [r6]
a0451624 0530a0e1 mov r3, r5
a0451628 00408de5 str r4, [sp]
a045162c 0c10a0e3 mov r1, #0xc
a0451630 04408de5 str r4, [sp, #4]
a0451634 922700e3 movw r2, #0x792
a0451638 08408de5 str r4, [sp, #8]
a045163c 0400a0e3 mov r0, #4
a0451640 0c4187e7 str r4, [r7, ip, lsl #2]
a0451644 3af4ffeb bl #0xa044e734
a0451648 0400a0e1 mov r0, r4
a045164c 18d08de2 add sp, sp, #0x18
a0451650 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a0451654 a80b0ae3 movw r0, #0xaba8
a0451658 68190ce3 movw r1, #0xc968
a045165c 61104ae3 movt r1, #0xa061
a0451660 672700e3 movw r2, #0x767
a0451664 53004ae3 movt r0, #0xa053
a0451668 9f56f9eb bl #0xa02a70ec
a045166c ac57f9eb bl #0xa02a7524
a0451670 c0000cf1 cpsid if
a0451674 feffffea b #0xa0451674
a0451678 a4050de3 movw r0, #0xd5a4
a045167c 441d0ce3 movw r1, #0xcd44
a0451680 68290ce3 movw r2, #0xc968
a0451684 00408de5 str r4, [sp]
a0451688 61104ae3 movt r1, #0xa061
a045168c 61204ae3 movt r2, #0xa061
a0451690 773ea0e3 mov r3, #0x770
a0451694 61004ae3 movt r0, #0xa061
a0451698 9356f9eb bl #0xa02a70ec
a045169c 00408de5 str r4, [sp]
a04516a0 0530a0e1 mov r3, r5
a04516a4 04408de5 str r4, [sp, #4]
a04516a8 0c10a0e3 mov r1, #0xc
a04516ac 08408de5 str r4, [sp, #8]
a04516b0 722700e3 movw r2, #0x772
a04516b4 0400a0e3 mov r0, #4
a04516b8 1df4ffeb bl #0xa044e734
a04516bc 0400a0e1 mov r0, r4
a04516c0 18d08de2 add sp, sp, #0x18
a04516c4 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a04516c8 f4050de3 movw r0, #0xd5f4
a04516cc dc1901e3 movw r1, #0x19dc
a04516d0 68290ce3 movw r2, #0xc968
a0451960 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0451964 14d04de2 sub sp, sp, #0x14
a0451968 044090e5 ldr r4, [r0, #4]
a045196c 0c3094e5 ldr r3, [r4, #0xc]
a0451970 000053e3 cmp r3, #0
a0451974 5500000a beq #0xa0451ad0
a0451978 0090a0e3 mov sb, #0
a045197c 00108de5 str r1, [sp]
a0451980 04208de5 str r2, [sp, #4]
a0451984 0430a0e1 mov r3, r4
a0451988 0160a0e1 mov r6, r1
a045198c 0250a0e1 mov r5, r2
a0451990 0e10a0e3 mov r1, #0xe
a0451994 dd2700e3 movw r2, #0x7dd
a0451998 0200a0e3 mov r0, #2
a045199c 08908de5 str sb, [sp, #8]
a04519a0 147084e2 add r7, r4, #0x14
a04519a4 62f3ffeb bl #0xa044e734
a04519a8 0700a0e1 mov r0, r7
a04519ac 0010e0e3 mvn r1, #0
a04519b0 adaafdeb bl #0xa03bc46c
a04519b4 008050e2 subs r8, r0, #0
a04519b8 1d00001a bne #0xa0451a34
a04519bc 882094e5 ldr r2, [r4, #0x88]
a04519c0 020055e1 cmp r5, r2
a04519c4 0030a023 movhs r3, #0
a04519c8 00308625 strhs r3, [r6]
a04519cc 0a00002a bhs #0xa04519fc
a04519d0 d089c4e1 ldrd r8, sb, [r4, #0x90]
a04519d4 0030a0e3 mov r3, #0
a04519d8 d8a9c4e1 ldrd sl, fp, [r4, #0x98]
a04519dc 08005ae0 subs r0, sl, r8
a04519e0 0910cbe0 sbc r1, fp, sb
a04519e4 030051e1 cmp r1, r3
a04519e8 02005001 cmpeq r0, r2
a04519ec 1b00009a bls #0xa0451a60
a04519f0 0880e0e3 mvn r8, #8
a04519f4 0030a0e3 mov r3, #0
a04519f8 003086e5 str r3, [r6]
a04519fc 0700a0e1 mov r0, r7
a0451a00 a4aafdeb bl #0xa03bc498
a0451a04 0020a0e3 mov r2, #0
a0451a08 00608de5 str r6, [sp]
a0451a0c 08208de5 str r2, [sp, #8]
a0451a10 0430a0e1 mov r3, r4
a0451a14 04508de5 str r5, [sp, #4]
a0451a18 0400a0e3 mov r0, #4
a0451a1c 0e10a0e3 mov r1, #0xe
a0451a20 fe2700e3 movw r2, #0x7fe
a0451a24 42f3ffeb bl #0xa044e734
a0451a28 0800a0e1 mov r0, r8
a0451a2c 14d08de2 add sp, sp, #0x14
a0451a30 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0451a34 14060de3 movw r0, #0xd614
a0451a38 dc1901e3 movw r1, #0x19dc
a0451a3c 0c290de3 movw r2, #0xd90c
a0451a40 00908de5 str sb, [sp]
a0451a44 04408de5 str r4, [sp, #4]
a0451a48 60104ae3 movt r1, #0xa060
a0451a4c 61204ae3 movt r2, #0xa061
a0451a50 e13700e3 movw r3, #0x7e1
a0451a54 61004ae3 movt r0, #0xa061
a0451a58 a355f9eb bl #0xa02a70ec
a0451a5c d6ffffea b #0xa04519bc
a0451a60 050098e0 adds r0, r8, r5
a0451a64 0010a9e2 adc r1, sb, #0
a0451a68 0b0051e1 cmp r1, fp
a0451a6c 0a005001 cmpeq r0, sl
a0451a70 0030a023 movhs r3, #0
a0451a74 0780e023 mvnhs r8, #7
a0451a78 00308625 strhs r3, [r6]
a0451a7c deffff2a bhs #0xa04519fc
a0451a80 809094e5 ldr sb, [r4, #0x80]
a0451a84 0030a0e3 mov r3, #0
a0451a88 0380a0e1 mov r8, r3
a0451a8c 009086e5 str sb, [r6]
a0451a90 882094e5 ldr r2, [r4, #0x88]
a0451a94 27d502fa blx #0xa0506f38
a0451a98 82c289e0 add ip, sb, r2, lsl #5
a0451a9c 0e10a0e3 mov r1, #0xe
a0451aa0 fa2700e3 movw r2, #0x7fa
a0451aa4 00c086e5 str ip, [r6]
a0451aa8 0430a0e1 mov r3, r4
a0451aac 08e09ce5 ldr lr, [ip, #8]
a0451ab0 0100a0e3 mov r0, #1
a0451ab4 00e08de5 str lr, [sp]
a0451ab8 14e09ce5 ldr lr, [ip, #0x14]
a0451abc 04e08de5 str lr, [sp, #4]
a0451ac0 18c09ce5 ldr ip, [ip, #0x18]
a0451ac4 08c08de5 str ip, [sp, #8]
a0451ac8 19f3ffeb bl #0xa044e734
a0451acc caffffea b #0xa04519fc
a0451ad0 5c0c0ce3 movw r0, #0xcc5c
a0451ad4 dc1901e3 movw r1, #0x19dc
a0451ad8 0c290de3 movw r2, #0xd90c
a0451adc 18008de8 stm sp, {r3, r4}
a0451ae0 61004ae3 movt r0, #0xa061
a0451ae4 60104ae3 movt r1, #0xa060
a0451ae8 61204ae3 movt r2, #0xa061
a0451aec d93700e3 movw r3, #0x7d9
a0451af0 7d55f9eb bl #0xa02a70ec
a0451af4 0000e0e3 mvn r0, #0
a0451af8 cbffffea b #0xa0451a2c
a0451afc f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0451b00 14d04de2 sub sp, sp, #0x14
a0451b04 044090e5 ldr r4, [r0, #4]
a0451b08 0c3094e5 ldr r3, [r4, #0xc]
a0451b0c 000053e3 cmp r3, #0
a0451b10 5400000a beq #0xa0451c68
a0451b14 0080a0e3 mov r8, #0
a0451b18 00108de5 str r1, [sp]
a0451b1c 04208de5 str r2, [sp, #4]
a0451b20 0430a0e1 mov r3, r4
a0451b24 0160a0e1 mov r6, r1
a0451b28 0250a0e1 mov r5, r2
a0451b2c 0f10a0e3 mov r1, #0xf
a0451b30 1d2800e3 movw r2, #0x81d
a0451b34 0200a0e3 mov r0, #2
a0451b38 08808de5 str r8, [sp, #8]
a0451b3c 147084e2 add r7, r4, #0x14
a0451b40 fbf2ffeb bl #0xa044e734
a0451b44 0700a0e1 mov r0, r7
a0451b48 0010e0e3 mvn r1, #0
a0451b4c 46aafdeb bl #0xa03bc46c
a0451b50 080050e1 cmp r0, r8
a0451b54 2f00001a bne #0xa0451c18
a0451b58 0030a0e3 mov r3, #0
a0451b5c 00608de5 str r6, [sp]
a0451b60 08308de5 str r3, [sp, #8]
a0451b64 0100a0e3 mov r0, #1
a0451b68 0430a0e1 mov r3, r4
a0451b6c 04508de5 str r5, [sp, #4]
a0451b70 0f10a0e3 mov r1, #0xf
a0451b74 242800e3 movw r2, #0x824
a0451b78 edf2ffeb bl #0xa044e734
a0451b7c 883094e5 ldr r3, [r4, #0x88]
a0451b80 030055e1 cmp r5, r3
a0451b84 1000003a blo #0xa0451bcc
a0451c94 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0451c98 0080a0e3 mov r8, #0
a0451c9c 044090e5 ldr r4, [r0, #4]
a0451ca0 5cd04de2 sub sp, sp, #0x5c
a0451ca4 0060a0e1 mov r6, r0
a0451ca8 103094e5 ldr r3, [r4, #0x10]
a0451cac 30808de5 str r8, [sp, #0x30]
a0451cb0 34808de5 str r8, [sp, #0x34]
a0451cb4 24308de5 str r3, [sp, #0x24]
a0451cb8 38808de5 str r8, [sp, #0x38]
a0451cbc 3c808de5 str r8, [sp, #0x3c]
a0451cc0 40808de5 str r8, [sp, #0x40]
a0451cc4 44808de5 str r8, [sp, #0x44]
a0451cc8 48808de5 str r8, [sp, #0x48]
a0451ccc 4c808de5 str r8, [sp, #0x4c]
a0451cd0 50808de5 str r8, [sp, #0x50]
a0451cd4 54808de5 str r8, [sp, #0x54]
a0451cd8 0c3094e5 ldr r3, [r4, #0xc]
a0451cdc 080053e1 cmp r3, r8
a0451ce0 c500000a beq #0xa0451ffc
a0451ce4 48c084e2 add ip, r4, #0x48
a0451ce8 0430a0e1 mov r3, r4
a0451cec 0c90a0e1 mov sb, ip
a0451cf0 5e2800e3 movw r2, #0x85e
a0451cf4 00008de5 str r0, [sp]
a0451cf8 0150a0e1 mov r5, r1
a0451cfc 04108de5 str r1, [sp, #4]
a0451d00 0200a0e3 mov r0, #2
a0451d04 1010a0e3 mov r1, #0x10
a0451d08 08808de5 str r8, [sp, #8]
a0451d0c 28c08de5 str ip, [sp, #0x28]
a0451d10 147084e2 add r7, r4, #0x14
a0451d14 86f2ffeb bl #0xa044e734
a0451d18 0010e0e3 mvn r1, #0
a0451d1c 0900a0e1 mov r0, sb
a0451d20 d1a9fdeb bl #0xa03bc46c
a0451d24 0700a0e1 mov r0, r7
a0451d28 0010e0e3 mvn r1, #0
a0451d2c cea9fdeb bl #0xa03bc46c
a0451d30 003050e2 subs r3, r0, #0
a0451d34 2c308de5 str r3, [sp, #0x2c]
a0451d38 8100001a bne #0xa0451f44
a0451d3c d009c4e1 ldrd r0, r1, [r4, #0x90]
a0451d40 d889c4e1 ldrd r8, sb, [r4, #0x98]
a0451d44 80b094e5 ldr fp, [r4, #0x80]
a0451d48 008058e0 subs r8, r8, r0
a0451d4c 080055e1 cmp r5, r8
a0451d50 8600008a bhi #0xa0451f70
a0451d54 882094e5 ldr r2, [r4, #0x88]
a0451d58 0030a0e3 mov r3, #0
a0451d5c 75d402fa blx #0xa0506f38
a0451d60 0200a0e1 mov r0, r2
a0451d64 0310a0e1 mov r1, r3
a0451d68 80a28be0 add sl, fp, r0, lsl #5
a0451d6c f801cde1 strd r0, r1, [sp, #0x18]
a0451d70 742800e3 movw r2, #0x874
a0451d74 08e09ae5 ldr lr, [sl, #8]
a0451d78 1010a0e3 mov r1, #0x10
a0451d7c 0430a0e1 mov r3, r4
a0451d80 0090a0e3 mov sb, #0
a0451d84 0100a0e3 mov r0, #1
a0451d88 0580a0e1 mov r8, r5
a0451d8c 00e08de5 str lr, [sp]
a0451d90 14e09ae5 ldr lr, [sl, #0x14]
a0451d94 f081cde1 strd r8, sb, [sp, #0x10]
a0451d98 04e08de5 str lr, [sp, #4]
a0451d9c 18e09ae5 ldr lr, [sl, #0x18]
a0451da0 08e08de5 str lr, [sp, #8]
a0451da4 62f2ffeb bl #0xa044e734
a0451da8 d021cde1 ldrd r2, r3, [sp, #0x10]
a0451dac d801cde1 ldrd r0, r1, [sp, #0x18]
a0451db0 889094e5 ldr sb, [r4, #0x88]
a0451db4 020090e0 adds r0, r0, r2
a0451db8 0310a1e0 adc r1, r1, r3
a0451dbc 0030a0e3 mov r3, #0
a0451dc0 030051e1 cmp r1, r3
a0451dc4 09005001 cmpeq r0, sb
a0451dc8 3b00008a bhi #0xa0451ebc
a0451dcc 8592a0e1 lsl sb, r5, #5
a0451dd0 0010a0e3 mov r1, #0
a0451dd4 0a00a0e1 mov r0, sl
a0451dd8 0920a0e1 mov r2, sb
a0451ddc 029c02fa blx #0xa04f8dec
a0451de0 0030a0e3 mov r3, #0
a0451de4 08908de5 str sb, [sp, #8]
a0451de8 04308de5 str r3, [sp, #4]
a0451dec 0800a0e3 mov r0, #8
a0451df0 00a08de5 str sl, [sp]
a0451df4 1010a0e3 mov r1, #0x10
a0451df8 812800e3 movw r2, #0x881
a0451dfc 0430a0e1 mov r3, r4
a0451e00 4bf2ffeb bl #0xa044e734
a0451e04 d029c4e1 ldrd r2, r3, [r4, #0x90]
a0451e08 0080a0e3 mov r8, #0
a0451e0c d0a1cde1 ldrd sl, fp, [sp, #0x10]
a0451e10 1010a0e3 mov r1, #0x10
a0451e14 0100a0e3 mov r0, #1
a0451e18 02a09ae0 adds sl, sl, r2
a0451e1c 852800e3 movw r2, #0x885
a0451e20 03b0abe0 adc fp, fp, r3
a0451e24 0430a0e1 mov r3, r4
a0451e28 f0a9c4e1 strd sl, fp, [r4, #0x90]
a0451e2c 20018de8 stm sp, {r5, r8}
a0451e30 08808de5 str r8, [sp, #8]
a0451e34 3ef2ffeb bl #0xa044e734
a0451e38 0700a0e1 mov r0, r7
a0451e3c 95a9fdeb bl #0xa03bc498
a0451e40 24309de5 ldr r3, [sp, #0x24]
a0451e44 080053e1 cmp r3, r8
a0451e48 0200000a beq #0xa0451e58
a0451e4c b030d3e5 ldrb r3, [r3, #0xb0]
a0451e50 010053e3 cmp r3, #1
a0451e54 5c00000a beq #0xa0451fcc
a0451e58 04c096e5 ldr ip, [r6, #4]
a0451e5c 0133a0e3 mov r3, #0x4000000
a0451e60 c0019fe5 ldr r0, [pc, #0x1c0]
a0451e64 30108de2 add r1, sp, #0x30
a0451e68 0020a0e3 mov r2, #0
a0451e6c 38508de5 str r5, [sp, #0x38]
a0451e70 34c08de5 str ip, [sp, #0x34]
a0451e74 30308de5 str r3, [sp, #0x30]
a0451e78 c6a9fdeb bl #0xa03bc598
a0451e7c 007050e2 subs r7, r0, #0
a0451e80 4700001a bne #0xa0451fa4
a0451e84 28009de5 ldr r0, [sp, #0x28]
a0451e88 82a9fdeb bl #0xa03bc498
a0451e8c 0020a0e3 mov r2, #0
a0451e90 00608de5 str r6, [sp]
a0451e94 08208de5 str r2, [sp, #8]
a0451e98 0430a0e1 mov r3, r4
a0451e9c 04508de5 str r5, [sp, #4]
a0451ea0 0400a0e3 mov r0, #4
a0451ea4 1010a0e3 mov r1, #0x10
a0451ea8 992800e3 movw r2, #0x899
a0451eac 20f2ffeb bl #0xa044e734
a0451eb0 0700a0e1 mov r0, r7
a0451eb4 5cd08de2 add sp, sp, #0x5c
a0451eb8 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0451ebc 18309de5 ldr r3, [sp, #0x18]
a0451ec0 0a00a0e1 mov r0, sl
a0451ec4 0010a0e3 mov r1, #0
a0451ec8 099063e0 rsb sb, r3, sb
a0451ecc 8932a0e1 lsl r3, sb, #5
a0451ed0 059069e0 rsb sb, sb, r5
a0451ed4 8992a0e1 lsl sb, sb, #5
a0451ed8 0320a0e1 mov r2, r3
a0451edc 18308de5 str r3, [sp, #0x18]
a0451ee0 c19b02fa blx #0xa04f8dec
a0451ee4 18309de5 ldr r3, [sp, #0x18]
a0451ee8 1010a0e3 mov r1, #0x10
a0451eec 00a08de5 str sl, [sp]
a0451ef0 7b2800e3 movw r2, #0x87b
a0451ef4 0800a0e3 mov r0, #8
a0451ef8 08308de5 str r3, [sp, #8]
a0451efc 0030a0e3 mov r3, #0
a0451f00 04308de5 str r3, [sp, #4]
a0451f04 0430a0e1 mov r3, r4
a0451f08 09f2ffeb bl #0xa044e734
a0451f0c 0920a0e1 mov r2, sb
a0451f10 0b00a0e1 mov r0, fp
a0451f14 0010a0e3 mov r1, #0
a0451f18 b39b02fa blx #0xa04f8dec
a0451f1c 0030a0e3 mov r3, #0
a0451f20 08908de5 str sb, [sp, #8]
a0451f24 04308de5 str r3, [sp, #4]
a0451f28 1010a0e3 mov r1, #0x10
a0451f2c 00b08de5 str fp, [sp]
a0451f30 7e2800e3 movw r2, #0x87e
a0451f34 0430a0e1 mov r3, r4
a0451f38 0800a0e3 mov r0, #8
a0451f3c fcf1ffeb bl #0xa044e734
a0451f40 afffffea b #0xa0451e04
a0451f44 14060de3 movw r0, #0xd614
a0451f48 dc1901e3 movw r1, #0x19dc
a0451f4c f8280de3 movw r2, #0xd8f8
a0451f50 00808de5 str r8, [sp]
a0451f54 04408de5 str r4, [sp, #4]
a0451f58 60104ae3 movt r1, #0xa060
a0451f5c 61204ae3 movt r2, #0xa061
a0451f60 633800e3 movw r3, #0x863
a0451f64 61004ae3 movt r0, #0xa061
a0451f68 5f54f9eb bl #0xa02a70ec
a0451f6c 72ffffea b #0xa0451d3c
a0451f70 0030a0e3 mov r3, #0
a0451f74 70060de3 movw r0, #0xd670
a0451f78 441d0ce3 movw r1, #0xcd44
a0451f7c f8280de3 movw r2, #0xd8f8
a0451f80 00308de5 str r3, [sp]
a0451f84 61104ae3 movt r1, #0xa061
a0451f88 61004ae3 movt r0, #0xa061
a0451f8c 61204ae3 movt r2, #0xa061
a0451f90 6d3800e3 movw r3, #0x86d
a0451f94 0850a0e1 mov r5, r8
a0451f98 5354f9eb bl #0xa02a70ec
a0451f9c d009c4e1 ldrd r0, r1, [r4, #0x90]
a0451fa0 6bffffea b #0xa0451d54
a0451fa4 94060de3 movw r0, #0xd694
a0451fa8 dc1901e3 movw r1, #0x19dc
a0451fac f8280de3 movw r2, #0xd8f8
a0451fb0 00708de5 str r7, [sp]
a0451fb4 60104ae3 movt r1, #0xa060
a0451fb8 61204ae3 movt r2, #0xa061
a0451fbc 953800e3 movw r3, #0x895
a0451fc0 61004ae3 movt r0, #0xa061
a0451fc4 4854f9eb bl #0xa02a70ec
a0451fc8 adffffea b #0xa0451e84
a0451fcc 28009de5 ldr r0, [sp, #0x28]
a0451fd0 30a9fdeb bl #0xa03bc498
a0451fd4 00608de5 str r6, [sp]
a0451fd8 0430a0e1 mov r3, r4
a0451fdc 04508de5 str r5, [sp, #4]
a0451fe0 0400a0e3 mov r0, #4
a0451fe4 08808de5 str r8, [sp, #8]
a0451fe8 1010a0e3 mov r1, #0x10
a0451fec 8b2800e3 movw r2, #0x88b
a0451ff0 cff1ffeb bl #0xa044e734
a0451ff4 2c009de5 ldr r0, [sp, #0x2c]
a0451ff8 adffffea b #0xa0451eb4
a0451ffc 5c0c0ce3 movw r0, #0xcc5c
a0452000 dc1901e3 movw r1, #0x19dc
a0452004 f8280de3 movw r2, #0xd8f8
a0452008 18008de8 stm sp, {r3, r4}
a045200c 61004ae3 movt r0, #0xa061
a0452010 60104ae3 movt r1, #0xa060
a0452014 61204ae3 movt r2, #0xa061
a0452018 5a3800e3 movw r3, #0x85a
a045201c 3254f9eb bl #0xa02a70ec
a0452020 0000e0e3 mvn r0, #0
a0452024 a2ffffea b #0xa0451eb4
a044e8d4 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a044e8d8 0050a0e3 mov r5, #0
a044e8dc 3cd04de2 sub sp, sp, #0x3c
a044e8e0 0030a0e1 mov r3, r0
a044e8e4 01b0a0e1 mov fp, r1
a044e8e8 ae2300e3 movw r2, #0x3ae
a044e8ec 10008de5 str r0, [sp, #0x10]
a044e8f0 0200a0e3 mov r0, #2
a044e8f4 00108de5 str r1, [sp]
a044e8f8 0310a0e3 mov r1, #3
a044e8fc 04508de5 str r5, [sp, #4]
a044e900 08508de5 str r5, [sp, #8]
a044e904 8affffeb bl #0xa044e734
a044e908 10309de5 ldr r3, [sp, #0x10]
a044e90c 0c4093e5 ldr r4, [r3, #0xc]
a044e910 050054e1 cmp r4, r5
a044e914 7b00000a beq #0xa044eb08
a044e918 10309de5 ldr r3, [sp, #0x10]
a044e91c 0010e0e3 mvn r1, #0
a044e920 146083e2 add r6, r3, #0x14
a044e924 0600a0e1 mov r0, r6
a044e928 cfb6fdeb bl #0xa03bc46c
a044e92c 14309be5 ldr r3, [fp, #0x14]
a044e930 0100a0e3 mov r0, #1
a044e934 08c09be5 ldr ip, [fp, #8]
a044e938 0310a0e3 mov r1, #3
a044e93c 08508de5 str r5, [sp, #8]
a044e940 ee2fa0e3 mov r2, #0x3b8
a044e944 00308de5 str r3, [sp]
a044e948 04c08de5 str ip, [sp, #4]
a044e94c 10309de5 ldr r3, [sp, #0x10]
a044e950 77ffffeb bl #0xa044e734
a044e954 10309de5 ldr r3, [sp, #0x10]
a044e958 104093e5 ldr r4, [r3, #0x10]
a044e95c 000054e3 cmp r4, #0
a044e960 ae00000a beq #0xa044ec20
a044e964 ac3094e5 ldr r3, [r4, #0xac]
a044e968 482084e2 add r2, r4, #0x48
a044e96c 0600a0e1 mov r0, r6
a044e970 14208de5 str r2, [sp, #0x14]
a044e974 14a084e2 add sl, r4, #0x14
a044e978 013083e2 add r3, r3, #1
a044e97c 34308de5 str r3, [sp, #0x34]
a044e980 c4b6fdeb bl #0xa03bc498
a044e984 0010e0e3 mvn r1, #0
a044e988 14009de5 ldr r0, [sp, #0x14]
a044e98c b6b6fdeb bl #0xa03bc46c
a044e990 0010e0e3 mvn r1, #0
a044e994 0a00a0e1 mov r0, sl
a044e998 b3b6fdeb bl #0xa03bc46c
a044e99c d809c4e1 ldrd r0, r1, [r4, #0x98]
a044e9a0 0530a0e1 mov r3, r5
a044e9a4 882094e5 ldr r2, [r4, #0x88]
a044e9a8 62e102fa blx #0xa0506f38
a044e9ac 806094e5 ldr r6, [r4, #0x80]
a044e9b0 0270a0e1 mov r7, r2
a044e9b4 00009be5 ldr r0, [fp]
a044e9b8 c52300e3 movw r2, #0x3c5
a044e9bc 04109be5 ldr r1, [fp, #4]
a044e9c0 08309be5 ldr r3, [fp, #8]
a044e9c4 0ce09be5 ldr lr, [fp, #0xc]
a044e9c8 87c286e0 add ip, r6, r7, lsl #5
a044e9cc 870286e7 str r0, [r6, r7, lsl #5]
a044e9d0 04108ce5 str r1, [ip, #4]
a044e9d4 08308ce5 str r3, [ip, #8]
a044e9d8 0ce08ce5 str lr, [ip, #0xc]
a044e9dc 1ce09be5 ldr lr, [fp, #0x1c]
a044e9e0 10009be5 ldr r0, [fp, #0x10]
a044e9e4 14109be5 ldr r1, [fp, #0x14]
a044e9e8 18309be5 ldr r3, [fp, #0x18]
a044e9ec 1ce08ce5 str lr, [ip, #0x1c]
a044e9f0 10008ce5 str r0, [ip, #0x10]
a044e9f4 0800a0e3 mov r0, #8
a044e9f8 14108ce5 str r1, [ip, #0x14]
a044e9fc 0310a0e3 mov r1, #3
a044ea00 18308ce5 str r3, [ip, #0x18]
a044ea04 0430a0e1 mov r3, r4
a044ea08 00c08de5 str ip, [sp]
a044ea0c 20c0a0e3 mov ip, #0x20
a044ea10 08c08de5 str ip, [sp, #8]
a044ea14 04b08de5 str fp, [sp, #4]
a044ea18 45ffffeb bl #0xa044e734
a044ea1c d869c4e1 ldrd r6, r7, [r4, #0x98]
a044ea20 0310a0e3 mov r1, #3
a044ea24 c72300e3 movw r2, #0x3c7
a044ea28 0430a0e1 mov r3, r4
a044ea2c 0100a0e3 mov r0, #1
a044ea30 018096e2 adds r8, r6, #1
a044ea34 0090a7e2 adc sb, r7, #0
a044ea38 0860a0e1 mov r6, r8
a044ea3c 0970a0e1 mov r7, sb
a044ea40 f869c4e1 strd r6, r7, [r4, #0x98]
a044ea44 00508de5 str r5, [sp]
a044ea48 04508de5 str r5, [sp, #4]
a044ea4c 08508de5 str r5, [sp, #8]
a044ea50 37ffffeb bl #0xa044e734
a044ea54 d069c4e1 ldrd r6, r7, [r4, #0x90]
a044ea58 0a00a0e1 mov r0, sl
a044ea5c d829c4e1 ldrd r2, r3, [r4, #0x98]
a044ea60 881094e5 ldr r1, [r4, #0x88]
a044ea64 062052e0 subs r2, r2, r6
a044ea68 0730c3e0 sbc r3, r3, r7
a044ea6c 0260a0e1 mov r6, r2
a044ea70 0370a0e1 mov r7, r3
a044ea74 0030a0e3 mov r3, #0
a044ea78 030057e1 cmp r7, r3
a044ea7c 01005601 cmpeq r6, r1
a044ea80 0160a003 moveq r6, #1
a044ea84 0060a013 movne r6, #0
a044ea88 82b6fdeb bl #0xa03bc498
a044ea8c a47094e5 ldr r7, [r4, #0xa4]
a044ea90 000057e3 cmp r7, #0
a044ea94 0800000a beq #0xa044eabc
a044ea98 d809c4e1 ldrd r0, r1, [r4, #0x98]
a044ea9c 0530a0e1 mov r3, r5
a044eaa0 34a09de5 ldr sl, [sp, #0x34]
a044eaa4 010050e2 subs r0, r0, #1
a044eaa8 0010c1e2 sbc r1, r1, #0
a044eaac 0a20a0e1 mov r2, sl
a044eab0 20e102fa blx #0xa0506f38
a044eab4 033092e1 orrs r3, r2, r3
a044eab8 3f00000a beq #0xa044ebbc
a044eabc 14009de5 ldr r0, [sp, #0x14]
a044eac0 74b6fdeb bl #0xa03bc498
a044eac4 a43094e5 ldr r3, [r4, #0xa4]
a044eac8 000053e3 cmp r3, #0
a044eacc 0060a003 moveq r6, #0
a044ead0 01600612 andne r6, r6, #1
a044ead4 000056e3 cmp r6, #0
a044ead8 1e00001a bne #0xa044eb58
a044eadc 0020a0e3 mov r2, #0
a044eae0 00b08de5 str fp, [sp]
a044eae4 04208de5 str r2, [sp, #4]
a044eae8 0310a0e3 mov r1, #3
a044eaec 08208de5 str r2, [sp, #8]
a044eaf0 0400a0e3 mov r0, #4
a044eaf4 10309de5 ldr r3, [sp, #0x10]
a044eaf8 3e2400e3 movw r2, #0x43e
a044eafc 0cffffeb bl #0xa044e734
a044eb00 3cd08de2 add sp, sp, #0x3c
a044eb04 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a044eb08 5c0c0ce3 movw r0, #0xcc5c
a044eb0c dc1901e3 movw r1, #0x19dc
a044eb10 38290de3 movw r2, #0xd938
a044eb14 04308de5 str r3, [sp, #4]
a044eb18 00408de5 str r4, [sp]
a044eb1c 60104ae3 movt r1, #0xa060
a044eb20 61204ae3 movt r2, #0xa061
a044eb24 b13300e3 movw r3, #0x3b1
a044eb28 61004ae3 movt r0, #0xa061
a044eb2c 6e61f9eb bl #0xa02a70ec
a044eb30 00b08de5 str fp, [sp]
a044eb34 0310a0e3 mov r1, #3
a044eb38 10309de5 ldr r3, [sp, #0x10]
a044eb3c b22300e3 movw r2, #0x3b2
a044eb40 04408de5 str r4, [sp, #4]
a044eb44 0400a0e3 mov r0, #4
a044eb48 08408de5 str r4, [sp, #8]
a044eb4c f8feffeb bl #0xa044e734
a044eb50 3cd08de2 add sp, sp, #0x3c
a044eb54 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a044eb58 0550a0e3 mov r5, #5
a044eb5c 0060a0e3 mov r6, #0
a044eb60 005440e3 movt r5, #0x400
a044eb64 08608de5 str r6, [sp, #8]
a044eb68 28008de8 stm sp, {r3, r5}
a044eb6c 0310a0e3 mov r1, #3
a044eb70 0430a0e1 mov r3, r4
a044eb74 d92300e3 movw r2, #0x3d9
a044eb78 1000a0e3 mov r0, #0x10
a044eb7c ecfeffeb bl #0xa044e734
a044eb80 0510a0e1 mov r1, r5
a044eb84 0620a0e1 mov r2, r6
a044eb88 a43094e5 ldr r3, [r4, #0xa4]
a044eb8c 0400a0e1 mov r0, r4
a044eb90 33ff2fe1 blx r3
a044eb94 a42094e5 ldr r2, [r4, #0xa4]
a044eb98 0430a0e1 mov r3, r4
a044eb9c 04508de5 str r5, [sp, #4]
a044eba0 0310a0e3 mov r1, #3
a044eba4 08608de5 str r6, [sp, #8]
a044eba8 2000a0e3 mov r0, #0x20
a044ebac 00208de5 str r2, [sp]
a044ebb0 db2300e3 movw r2, #0x3db
a044ebb4 defeffeb bl #0xa044e734
a044ebb8 c7ffffea b #0xa044eadc
a044ebbc 8153a0e3 mov r5, #0x4000002
a044ebc0 0430a0e1 mov r3, r4
a044ebc4 00708de5 str r7, [sp]
a044ebc8 0310a0e3 mov r1, #3
a044ebcc 08a08de5 str sl, [sp, #8]
a044ebd0 d12300e3 movw r2, #0x3d1
a044ebd4 04508de5 str r5, [sp, #4]
a044ebd8 1000a0e3 mov r0, #0x10
a044ebdc d4feffeb bl #0xa044e734
a044ebe0 0510a0e1 mov r1, r5
a044ebe4 a43094e5 ldr r3, [r4, #0xa4]
a044ebe8 34208de2 add r2, sp, #0x34
a044ebec 0400a0e1 mov r0, r4
a044ebf0 33ff2fe1 blx r3
a044ebf4 a43094e5 ldr r3, [r4, #0xa4]
a044ebf8 0310a0e3 mov r1, #3
a044ebfc 34c09de5 ldr ip, [sp, #0x34]
a044ec00 d32300e3 movw r2, #0x3d3
a044ec04 04508de5 str r5, [sp, #4]
a044ec08 2000a0e3 mov r0, #0x20
a044ec0c 00308de5 str r3, [sp]
a044ec10 0430a0e1 mov r3, r4
a044ec14 08c08de5 str ip, [sp, #8]
a044ec18 c5feffeb bl #0xa044e734
a044ec1c a6ffffea b #0xa044eabc
a044ec20 8c8106e3 movw r8, #0x618c
a044ec24 0600a0e1 mov r0, r6
a044ec28 96814ae3 movt r8, #0xa196
a044ec2c 10309de5 ldr r3, [sp, #0x10]
a044ec30 506098e5 ldr r6, [r8, #0x50]
a044ec34 08a098e5 ldr sl, [r8, #8]
a044ec38 087093e5 ldr r7, [r3, #8]
a044ec3c 15b6fdeb bl #0xa03bc498
a044ec40 000056e3 cmp r6, #0
a044ec44 a4ffffda ble #0xa044eadc
a044ec48 0530a0e3 mov r3, #5
a044ec4c 7c2003e3 movw r2, #0x307c
a044ec50 0450a0e1 mov r5, r4
a044ec54 003440e3 movt r3, #0x400
a044ec58 6f204ae3 movt r2, #0xa06f
a044ec5c 1c408de5 str r4, [sp, #0x1c]
a044ec60 20308de5 str r3, [sp, #0x20]
a044ec64 24208de5 str r2, [sp, #0x24]
a044ec68 14608de5 str r6, [sp, #0x14]
a044ec6c 18708de5 str r7, [sp, #0x18]
a044ec70 28808de5 str r8, [sp, #0x28]
a044ec74 0c309ae5 ldr r3, [sl, #0xc]
a044ec78 000053e3 cmp r3, #0
a044ec7c 0300000a beq #0xa044ec90
a044ec80 08309ae5 ldr r3, [sl, #8]
a044ec84 18209de5 ldr r2, [sp, #0x18]
a044ec88 020053e1 cmp r3, r2
a044ec8c 0500000a beq #0xa044eca8
a044ec90 14309de5 ldr r3, [sp, #0x14]
a044ec94 015085e2 add r5, r5, #1
a044ec98 f8a08ae2 add sl, sl, #0xf8
a044ec9c 050053e1 cmp r3, r5
a044eca0 f3ffff1a bne #0xa044ec74
a044eca4 8cffffea b #0xa044eadc
a044eca8 14308ae2 add r3, sl, #0x14
a044ecac 0010e0e3 mvn r1, #0
a044ecb0 0300a0e1 mov r0, r3
a044ecb4 2c308de5 str r3, [sp, #0x2c]
a044ecb8 ebb5fdeb bl #0xa03bc46c
a044ecbc c4309ae5 ldr r3, [sl, #0xc4]
a044ecc0 000053e3 cmp r3, #0
a044ecc4 bd00001a bne #0xa044efc0
a044ecc8 0c209ae5 ldr r2, [sl, #0xc]
a044eccc 000052e3 cmp r2, #0
a044ecd0 9c00001a bne #0xa044ef48
a044ecd4 80309ae5 ldr r3, [sl, #0x80]
a044ecd8 004053e2 subs r4, r3, #0
a044ecdc b100000a beq #0xa044efa8
a044ece0 ac109ae5 ldr r1, [sl, #0xac]
a044ece4 0230a0e1 mov r3, r2
a044ece8 012081e2 add r2, r1, #1
a044ecec 34208de5 str r2, [sp, #0x34]
a044ecf0 d809cae1 ldrd r0, r1, [sl, #0x98]
a044ecf4 88209ae5 ldr r2, [sl, #0x88]
a044ecf8 8ee002fa blx #0xa0506f38
a044ecfc 0280a0e1 mov r8, r2
a044ed00 00909be5 ldr sb, [fp]
a044ed04 0430a0e1 mov r3, r4
a044ed08 08e09be5 ldr lr, [fp, #8]
a044ed0c 884284e0 add r4, r4, r8, lsl #5
a044ed10 0cc09be5 ldr ip, [fp, #0xc]
a044ed14 0820a0e1 mov r2, r8
a044ed18 04809be5 ldr r8, [fp, #4]
a044ed1c 0310a0e3 mov r1, #3
a044ed20 829283e7 str sb, [r3, r2, lsl #5]
a044ed24 0800a0e3 mov r0, #8
a044ed28 08e084e5 str lr, [r4, #8]
a044ed2c 062400e3 movw r2, #0x406
a044ed30 048084e5 str r8, [r4, #4]
a044ed34 0a30a0e1 mov r3, sl
a044ed38 0cc084e5 str ip, [r4, #0xc]
a044ed3c 1cc09be5 ldr ip, [fp, #0x1c]
a044ed40 10909be5 ldr sb, [fp, #0x10]
a044ed44 14809be5 ldr r8, [fp, #0x14]
a044ed48 18e09be5 ldr lr, [fp, #0x18]
a044ed4c 1cc084e5 str ip, [r4, #0x1c]
a044ed50 20c0a0e3 mov ip, #0x20
a044ed54 109084e5 str sb, [r4, #0x10]
a044ed58 148084e5 str r8, [r4, #0x14]
a044ed5c 18e084e5 str lr, [r4, #0x18]
a044ed60 08c08de5 str ip, [sp, #8]
a044ed64 10088de8 stm sp, {r4, fp}
a044ed68 71feffeb bl #0xa044e734
a044ed6c d889cae1 ldrd r8, sb, [sl, #0x98]
a044ed70 0310a0e3 mov r1, #3
a044ed74 092400e3 movw r2, #0x409
a044ed78 0a30a0e1 mov r3, sl
a044ed7c 0100a0e3 mov r0, #1
a044ed80 016098e2 adds r6, r8, #1
a044ed84 0070a9e2 adc r7, sb, #0
a044ed88 0680a0e1 mov r8, r6
a044ed8c 0790a0e1 mov sb, r7
a044ed90 f889cae1 strd r8, sb, [sl, #0x98]
a044ed94 08809be5 ldr r8, [fp, #8]
a044ed98 14e09be5 ldr lr, [fp, #0x14]
a044ed9c 18c09be5 ldr ip, [fp, #0x18]
a044eda0 00418de8 stm sp, {r8, lr}
a044eda4 08c08de5 str ip, [sp, #8]
a044eda8 61feffeb bl #0xa044e734
a044edac d029cae1 ldrd r2, r3, [sl, #0x90]
a044edb0 d809cae1 ldrd r0, r1, [sl, #0x98]
a044edb4 88e09ae5 ldr lr, [sl, #0x88]
a044edb8 0260a0e1 mov r6, r2
a044edbc 0370a0e1 mov r7, r3
a044edc0 022050e0 subs r2, r0, r2
a044edc4 c0c09ae5 ldr ip, [sl, #0xc0]
a044edc8 0330c1e0 sbc r3, r1, r3
a044edcc 0280a0e1 mov r8, r2
a044edd0 0390a0e1 mov sb, r3
a044edd4 0030a0e3 mov r3, #0
a044edd8 030059e1 cmp sb, r3
a044eddc 1c309de5 ldr r3, [sp, #0x1c]
a044ede0 0e005801 cmpeq r8, lr
a044ede4 0130a003 moveq r3, #1
a044ede8 ff005ce3 cmp ip, #0xff
a044edec 1c308de5 str r3, [sp, #0x1c]
a044edf0 0a00000a beq #0xa044ee20
a044edf4 1030d4e5 ldrb r3, [r4, #0x10]
a044edf8 03005ce1 cmp ip, r3
a044edfc ff30a003 moveq r3, #0xff
a044ee00 c0308a05 streq r3, [sl, #0xc0]
a044ee04 0500000a beq #0xa044ee20
a044ee08 018096e2 adds r8, r6, #1
a044ee0c 2c009de5 ldr r0, [sp, #0x2c]
a044ee10 0090a7e2 adc sb, r7, #0
a044ee14 f089cae1 strd r8, sb, [sl, #0x90]
a044ee18 9eb5fdeb bl #0xa03bc498
a044ee1c 9bffffea b #0xa044ec90
a044ee20 182094e5 ldr r2, [r4, #0x18]
a044ee24 ff34e0e3 mvn r3, #0xff000000
a044ee28 030052e1 cmp r2, r3
a044ee2c 6600000a beq #0xa044efcc
a044ee30 1030d4e5 ldrb r3, [r4, #0x10]
a044ee34 ff0053e3 cmp r3, #0xff
a044ee38 6300000a beq #0xa044efcc
a044ee3c 34209de5 ldr r2, [sp, #0x34]
a044ee40 0030a0e3 mov r3, #0
a044ee44 3be002fa blx #0xa0506f38
a044ee48 033092e1 orrs r3, r2, r3
a044ee4c 2c009de5 ldr r0, [sp, #0x2c]
a044ee50 7f00001a bne #0xa044f054
a044ee54 8fb5fdeb bl #0xa03bc498
a044ee58 a4309ae5 ldr r3, [sl, #0xa4]
a044ee5c 000053e3 cmp r3, #0
a044ee60 8affff0a beq #0xa044ec90
a044ee64 38808de2 add r8, sp, #0x38
a044ee68 8143a0e3 mov r4, #0x4000002
a044ee6c 04c038e5 ldr ip, [r8, #-4]!
a044ee70 0310a0e3 mov r1, #3
a044ee74 00308de5 str r3, [sp]
a044ee78 2b2400e3 movw r2, #0x42b
a044ee7c 0a30a0e1 mov r3, sl
a044ee80 1000a0e3 mov r0, #0x10
a044ee84 08c08de5 str ip, [sp, #8]
a044ee88 04408de5 str r4, [sp, #4]
a044ee8c 28feffeb bl #0xa044e734
a044ee90 0820a0e1 mov r2, r8
a044ee94 0410a0e1 mov r1, r4
a044ee98 a4309ae5 ldr r3, [sl, #0xa4]
a044ee9c 0a00a0e1 mov r0, sl
a044eea0 33ff2fe1 blx r3
a044eea4 a4309ae5 ldr r3, [sl, #0xa4]
a044eea8 2000a0e3 mov r0, #0x20
a044eeac 34c09de5 ldr ip, [sp, #0x34]
a044eeb0 0310a0e3 mov r1, #3
a044eeb4 04408de5 str r4, [sp, #4]
a044eeb8 2d2400e3 movw r2, #0x42d
a044eebc 00308de5 str r3, [sp]
a044eec0 0a30a0e1 mov r3, sl
a044eec4 08c08de5 str ip, [sp, #8]
a044eec8 19feffeb bl #0xa044e734
a044eecc a4309ae5 ldr r3, [sl, #0xa4]
a044eed0 1c209de5 ldr r2, [sp, #0x1c]
a044eed4 000052e3 cmp r2, #0
a044eed8 00005313 cmpne r3, #0
a044eedc 6bffff0a beq #0xa044ec90
a044eee0 20809de5 ldr r8, [sp, #0x20]
a044eee4 0040a0e3 mov r4, #0
a044eee8 00308de5 str r3, [sp]
a044eeec 0310a0e3 mov r1, #3
a044eef0 0a30a0e1 mov r3, sl
a044eef4 08408de5 str r4, [sp, #8]
a044eef8 04808de5 str r8, [sp, #4]
a044eefc 372400e3 movw r2, #0x437
a044ef00 1000a0e3 mov r0, #0x10
a044ef04 0afeffeb bl #0xa044e734
a044ef08 0510a0e3 mov r1, #5
a044ef0c 0420a0e1 mov r2, r4
a044ef10 a4309ae5 ldr r3, [sl, #0xa4]
a044ef14 001440e3 movt r1, #0x400
a044ef18 0a00a0e1 mov r0, sl
a044ef1c 33ff2fe1 blx r3
a044ef20 a4309ae5 ldr r3, [sl, #0xa4]
a044ef24 0310a0e3 mov r1, #3
a044ef28 08408de5 str r4, [sp, #8]
a044ef2c 392400e3 movw r2, #0x439
a044ef30 04808de5 str r8, [sp, #4]
a044ef34 2000a0e3 mov r0, #0x20
a044ef38 00308de5 str r3, [sp]
a044ef3c 0a30a0e1 mov r3, sl
a044ef40 fbfdffeb bl #0xa044e734
a044ef44 51ffffea b #0xa044ec90
a044ef48 ac209ae5 ldr r2, [sl, #0xac]
a044ef4c 80109ae5 ldr r1, [sl, #0x80]
a044ef50 012082e2 add r2, r2, #1
a044ef54 34208de5 str r2, [sp, #0x34]
a044ef58 0140a0e1 mov r4, r1
a044ef5c 88209ae5 ldr r2, [sl, #0x88]
a044ef60 d809cae1 ldrd r0, r1, [sl, #0x98]
a044ef64 f3df02fa blx #0xa0506f38
a044ef68 000054e3 cmp r4, #0
a044ef6c 0280a0e1 mov r8, r2
a044ef70 62ffff1a bne #0xa044ed00
a044ef74 24309de5 ldr r3, [sp, #0x24]
a044ef78 a80c0ce3 movw r0, #0xcca8
a044ef7c 14209de5 ldr r2, [sp, #0x14]
a044ef80 61004ae3 movt r0, #0xa061
a044ef84 041093e5 ldr r1, [r3, #4]
a044ef88 28309de5 ldr r3, [sp, #0x28]
a044ef8c 083093e5 ldr r3, [r3, #8]
a044ef90 00208de5 str r2, [sp]
a044ef94 0420a0e1 mov r2, r4
a044ef98 08048de9 stmib sp, {r3, sl}
a044ef9c 0530a0e1 mov r3, r5
a044efa0 5160f9eb bl #0xa02a70ec
a044efa4 55ffffea b #0xa044ed00
a044efa8 840c0ce3 movw r0, #0xcc84
a044efac 38190de3 movw r1, #0xd938
a044efb0 61004ae3 movt r0, #0xa061
a044efb4 61104ae3 movt r1, #0xa061
a044efb8 0a20a0e1 mov r2, sl
a044efbc 4a60f9eb bl #0xa02a70ec
a044efc0 2c009de5 ldr r0, [sp, #0x2c]
a044efc4 33b5fdeb bl #0xa03bc498
a044efc8 30ffffea b #0xa044ec90
a044efcc ff34e0e3 mvn r3, #0xff000000
a044efd0 2c009de5 ldr r0, [sp, #0x2c]
a044efd4 34308de5 str r3, [sp, #0x34]
a044efd8 2eb5fdeb bl #0xa03bc498
a044efdc a4309ae5 ldr r3, [sl, #0xa4]
a044efe0 000053e3 cmp r3, #0
a044efe4 29ffff0a beq #0xa044ec90
a044efe8 38808de2 add r8, sp, #0x38
a044efec 4143a0e3 mov r4, #0x4000001
a044eff0 04c038e5 ldr ip, [r8, #-4]!
a044eff4 0310a0e3 mov r1, #3
a044eff8 00308de5 str r3, [sp]
a044effc 232400e3 movw r2, #0x423
a044f000 0a30a0e1 mov r3, sl
a044f004 04408de5 str r4, [sp, #4]
a044f008 08c08de5 str ip, [sp, #8]
a044f00c 1000a0e3 mov r0, #0x10
a044f010 c7fdffeb bl #0xa044e734
a044f014 0820a0e1 mov r2, r8
a044f018 0410a0e1 mov r1, r4
a044f01c a4309ae5 ldr r3, [sl, #0xa4]
a044f020 0a00a0e1 mov r0, sl
a044f024 33ff2fe1 blx r3
a044f028 a4309ae5 ldr r3, [sl, #0xa4]
a044f02c 0310a0e3 mov r1, #3
a044f030 34c09de5 ldr ip, [sp, #0x34]
a044f034 252400e3 movw r2, #0x425
a044f038 04408de5 str r4, [sp, #4]
a044f03c 2000a0e3 mov r0, #0x20
a044f040 00308de5 str r3, [sp]
a044f044 0a30a0e1 mov r3, sl
a044f048 08c08de5 str ip, [sp, #8]
a044f04c b8fdffeb bl #0xa044e734
a044f050 9dffffea b #0xa044eecc
a044f054 0fb5fdeb bl #0xa03bc498
a044f058 9bffffea b #0xa044eecc
