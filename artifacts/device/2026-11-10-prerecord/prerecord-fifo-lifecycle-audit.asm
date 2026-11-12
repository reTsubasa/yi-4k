0xa0233434 410351e3 cmp r1, #0x4000001
0xa0233438 1700000a beq #0xa023349c
0xa023343c 810351e3 cmp r1, #0x4000002
0xa0233440 10402de9 push {r4, lr}
0xa0233444 0040a0e1 mov r4, r0
0xa0233448 10d04de2 sub sp, sp, #0x10
0xa023344c 0500000a beq #0xa0233468
0xa0233450 f80303e3 movw r0, #0x33f8
0xa0233454 58004ae3 movt r0, #0xa058
0xa0233458 23cf01eb bl #0xa02a70ec
0xa023345c 0000a0e3 mov r0, #0
0xa0233460 10d08de2 add sp, sp, #0x10
0xa0233464 1080bde8 pop {r4, pc}
0xa0233468 0c108de2 add r1, sp, #0xc
0xa023346c 0020a0e3 mov r2, #0
0xa0233470 3a7908eb bl #0xa0451960
0xa0233474 603b0fe3 movw r3, #0xfb60
0xa0233478 42314ae3 movt r3, #0xa142
0xa023347c 000093e5 ldr r0, [r3]
0xa0233480 000054e1 cmp r4, r0
0xa0233484 0600000a beq #0xa02334a4
0xa0233488 0110a0e3 mov r1, #1
0xa023348c 007a08eb bl #0xa0451c94
0xa0233490 0000a0e3 mov r0, #0
0xa0233494 10d08de2 add sp, sp, #0x10
0xa0233498 1080bde8 pop {r4, pc}
0xa023349c 0000a0e3 mov r0, #0
0xa02334a0 1eff2fe1 bx lr
0xa02334a4 503b0fe3 movw r3, #0xfb50
0xa02334a8 42314ae3 movt r3, #0xa142
0xa02334ac 003093e5 ldr r3, [r3]
0xa02334b0 000053e3 cmp r3, #0
0xa02334b4 f3ffff0a beq #0xa0233488
0xa02334b8 0c309de5 ldr r3, [sp, #0xc]
0xa02334bc ff24e0e3 mvn r2, #0xff000000
0xa02334c0 181093e5 ldr r1, [r3, #0x18]
0xa02334c4 020051e1 cmp r1, r2
0xa02334c8 eeffff0a beq #0xa0233488
0xa02334cc 1020d3e5 ldrb r2, [r3, #0x10]
0xa02334d0 012042e2 sub r2, r2, #1
0xa02334d4 020052e3 cmp r2, #2
0xa02334d8 eaffff8a bhi #0xa0233488
0xa02334dc 142a0fe3 movw r2, #0xfa14
0xa02334e0 48cb0fe3 movw ip, #0xfb48
0xa02334e4 42c14ae3 movt ip, #0xa142
0xa02334e8 00e0a0e3 mov lr, #0
0xa02334ec 42214ae3 movt r2, #0xa142
0xa02334f0 140093e5 ldr r0, [r3, #0x14]
0xa02334f4 002092e5 ldr r2, [r2]
0xa02334f8 00309ce5 ldr r3, [ip]
0xa02334fc 00e08de5 str lr, [sp]
0xa0233500 b3ffffeb bl #0xa02333d4
0xa0233504 d4ffffea b #0xa023345c
0xa0233508 30402de9 push {r4, r5, lr}
0xa023350c 5c4b0fe3 movw r4, #0xfb5c
0xa0233510 42414ae3 movt r4, #0xa142
0xa0233514 441b0fe3 movw r1, #0xfb44
0xa0233518 42114ae3 movt r1, #0xa142
0xa023351c 5cd04de2 sub sp, sp, #0x5c
0xa0233520 0400a0e1 mov r0, r4
0xa0233524 605b0fe3 movw r5, #0xfb60
0xa0233528 4279ffeb bl #0xa0211a38
0xa023352c 42514ae3 movt r5, #0xa142
0xa0233530 e80208e3 movw r0, #0x82e8
0xa0233534 3c014ae3 movt r0, #0xa13c
0xa0233538 001095e5 ldr r1, [r5]
0xa023353c 00c090e5 ldr ip, [r0]
0xa0233540 483b0fe3 movw r3, #0xfb48
0xa0233544 002094e5 ldr r2, [r4]
0xa0233548 140a0fe3 movw r0, #0xfa14
0xa023354c 000051e3 cmp r1, #0
0xa0233550 42314ae3 movt r3, #0xa142
0xa0233554 42014ae3 movt r0, #0xa142
0xa0233558 02208ce0 add r2, ip, r2
0xa023355c 00c080e5 str ip, [r0]
0xa0233560 002083e5 str r2, [r3]
0xa0233564 0100000a beq #0xa0233570
0xa0233568 5cd08de2 add sp, sp, #0x5c
0xa023356c 3080bde8 pop {r4, r5, pc}
0xa0233570 5820a0e3 mov r2, #0x58
0xa0233574 0d00a0e1 mov r0, sp
0xa0233578 1b160bfa blx #0xa04f8dec
0xa023357c d84208e3 movw r4, #0x82d8
0xa0233580 0d00a0e1 mov r0, sp
0xa0233584 097508eb bl #0xa04509b0
0xa0233588 3c414ae3 movt r4, #0xa13c
0xa023358c 9c0c00e3 movw r0, #0xc9c
0xa0233590 001094e5 ldr r1, [r4]
0xa0233594 5a004ae3 movt r0, #0xa05a
0xa0233598 d3ce01eb bl #0xa02a70ec
0xa023359c 00e094e5 ldr lr, [r4]
0xa02335a0 343403e3 movw r3, #0x3434
0xa02335a4 23304ae3 movt r3, #0xa023
0xa02335a8 01c0a0e3 mov ip, #1
0xa02335ac 022aa0e3 mov r2, #0x2000
0xa02335b0 0d00a0e1 mov r0, sp
0xa02335b4 0510a0e1 mov r1, r5
0xa02335b8 00e08de5 str lr, [sp]
0xa02335bc 0c308de5 str r3, [sp, #0xc]
0xa02335c0 04108de9 stmib sp, {r2, ip}
0xa02335c4 047508eb bl #0xa04509dc
0xa02335c8 5cd08de2 add sp, sp, #0x5c
0xa02335cc 3080bde8 pop {r4, r5, pc}
0xa02335d0 10402de9 push {r4, lr}
0xa02335d4 604b0fe3 movw r4, #0xfb60
0xa02335d8 42414ae3 movt r4, #0xa142
0xa02335dc 000094e5 ldr r0, [r4]
0xa02335e0 000050e3 cmp r0, #0
0xa02335e4 1080bd08 popeq {r4, pc}
0xa02335e8 bd7708eb bl #0xa04514e4
0xa02335ec 0030a0e3 mov r3, #0
0xa02335f0 003084e5 str r3, [r4]
0xa02335f4 1080bde8 pop {r4, pc}
0xa04509b0 10402de9 push {r4, lr}
0xa04509b4 0010a0e3 mov r1, #0
0xa04509b8 5820a0e3 mov r2, #0x58
0xa04509bc 0040a0e1 mov r4, r0
0xa04509c0 09a102fa blx #0xa04f8dec
0xa04509c4 8020a0e3 mov r2, #0x80
0xa04509c8 0130a0e3 mov r3, #1
0xa04509cc 042084e5 str r2, [r4, #4]
0xa04509d0 0000a0e3 mov r0, #0
0xa04509d4 083084e5 str r3, [r4, #8]
0xa04509d8 1080bde8 pop {r4, pc}
0xa04509dc f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa04509e0 54d04de2 sub sp, sp, #0x54
0xa04509e4 0c3090e5 ldr r3, [r0, #0xc]
0xa04509e8 0070a0e1 mov r7, r0
0xa04509ec 1c108de5 str r1, [sp, #0x1c]
0xa04509f0 000053e3 cmp r3, #0
0xa04509f4 a202000a beq #0xa0451484
0xa04509f8 088090e5 ldr r8, [r0, #8]
0xa04509fc 8c6106e3 movw r6, #0x618c
0xa0450a00 96614ae3 movt r6, #0xa196
0xa0450a04 000058e3 cmp r8, #0
0xa0450a08 3000001a bne #0xa0450ad0
0xa0450a0c 543096e5 ldr r3, [r6, #0x54]
0xa0450a10 000053e3 cmp r3, #0
0xa0450a14 0850a011 movne r5, r8
0xa0450a18 1f00001a bne #0xa0450a9c
0xa0450a1c 0040a0e3 mov r4, #0
0xa0450a20 e8030de3 movw r0, #0xd3e8
0xa0450a24 dc1901e3 movw r1, #0x19dc
0xa0450a28 74290de3 movw r2, #0xd974
0xa0450a2c 533600e3 movw r3, #0x653
0xa0450a30 00408de5 str r4, [sp]
0xa0450a34 61004ae3 movt r0, #0xa061
0xa0450a38 60104ae3 movt r1, #0xa060
0xa0450a3c 61204ae3 movt r2, #0xa061
0xa0450a40 a959f9eb bl #0xa02a70ec
0xa0450a44 1c309de5 ldr r3, [sp, #0x1c]
0xa0450a48 0000e0e3 mvn r0, #0
0xa0450a4c 004083e5 str r4, [r3]
0xa0450a50 b40000ea b #0xa0450d28
0xa0450a54 14b084e2 add fp, r4, #0x14
0xa0450a58 0b00a0e1 mov r0, fp
0xa0450a5c 82aefdeb bl #0xa03bc46c
0xa0450a60 000050e3 cmp r0, #0
0xa0450a64 0b00a0e1 mov r0, fp
0xa0450a68 0300001a bne #0xa0450a7c
0xa0450a6c 0c3094e5 ldr r3, [r4, #0xc]
0xa0450a70 000053e3 cmp r3, #0
0xa0450a74 3a00000a beq #0xa0450b64
0xa0450a78 86aefdeb bl #0xa03bc498
0xa0450a7c 0a00a0e1 mov r0, sl
0xa0450a80 84aefdeb bl #0xa03bc498
0xa0450a84 015085e2 add r5, r5, #1
0xa0450a88 543096e5 ldr r3, [r6, #0x54]
0xa0450a8c 7550efe6 uxtb r5, r5
0xa0450a90 7580afe6 sxtb r8, r5
0xa0450a94 030058e1 cmp r8, r3
0xa0450a98 3500002a bhs #0xa0450b74
0xa0450a9c 0834a0e1 lsl r3, r8, #8
0xa0450aa0 044096e5 ldr r4, [r6, #4]
0xa0450aa4 0010a0e3 mov r1, #0
0xa0450aa8 883143e0 sub r3, r3, r8, lsl #3
0xa0450aac 8c9106e3 movw sb, #0x618c
0xa0450ab0 96914ae3 movt sb, #0xa196
0xa0450ab4 034084e0 add r4, r4, r3
0xa0450ab8 48a084e2 add sl, r4, #0x48
0xa0450abc 0a00a0e1 mov r0, sl
0xa0450ac0 69aefdeb bl #0xa03bc46c
0xa0450ac4 001050e2 subs r1, r0, #0
0xa0450ac8 edffff1a bne #0xa0450a84
0xa0450acc e0ffffea b #0xa0450a54
0xa0450ad0 503096e5 ldr r3, [r6, #0x50]
0xa0450ad4 000053e3 cmp r3, #0
0xa0450ad8 0080a013 movne r8, #0
0xa0450adc 0850a011 movne r5, r8
0xa0450ae0 0600001a bne #0xa0450b00
0xa0450ae4 9a0000ea b #0xa0450d54
0xa0450ae8 015085e2 add r5, r5, #1
0xa0450aec 503096e5 ldr r3, [r6, #0x50]
0xa0450af0 7550efe6 uxtb r5, r5
0xa0450af4 7580afe6 sxtb r8, r5
0xa0450af8 030058e1 cmp r8, r3
0xa0450afc 9100002a bhs #0xa0450d48
0xa0450b00 0834a0e1 lsl r3, r8, #8
0xa0450b04 084096e5 ldr r4, [r6, #8]
0xa0450b08 0010a0e3 mov r1, #0
0xa0450b0c 883143e0 sub r3, r3, r8, lsl #3
0xa0450b10 8cb106e3 movw fp, #0x618c
0xa0450b14 96b14ae3 movt fp, #0xa196
0xa0450b18 034084e0 add r4, r4, r3
0xa0450b1c 489084e2 add sb, r4, #0x48
0xa0450b20 0900a0e1 mov r0, sb
0xa0450b24 50aefdeb bl #0xa03bc46c
0xa0450b28 001050e2 subs r1, r0, #0
0xa0450b2c edffff1a bne #0xa0450ae8
0xa0450b30 14a084e2 add sl, r4, #0x14
0xa0450b34 0a00a0e1 mov r0, sl
0xa0450b38 4baefdeb bl #0xa03bc46c
0xa0450b3c 000050e3 cmp r0, #0
0xa0450b40 0a00a0e1 mov r0, sl
0xa0450b44 0300001a bne #0xa0450b58
0xa0450b48 0c3094e5 ldr r3, [r4, #0xc]
0xa0450b4c 000053e3 cmp r3, #0
0xa0450b50 3c01000a beq #0xa0451048
0xa0450b54 4faefdeb bl #0xa03bc498
0xa0450b58 0900a0e1 mov r0, sb
0xa0450b5c 4daefdeb bl #0xa03bc498
0xa0450b60 e0ffffea b #0xa0450ae8
0xa0450b64 0120a0e3 mov r2, #1
0xa0450b68 103084e5 str r3, [r4, #0x10]
0xa0450b6c 0c2084e5 str r2, [r4, #0xc]
0xa0450b70 543099e5 ldr r3, [sb, #0x54]
0xa0450b74 030058e1 cmp r8, r3
0xa0450b78 a7ffff0a beq #0xa0450a1c
0xa0450b7c 00c0a0e3 mov ip, #0
0xa0450b80 54199fe5 ldr r1, [pc, #0x954]
0xa0450b84 0030a0e3 mov r3, #0
0xa0450b88 020000ea b #0xa0450b98
0xa0450b8c 013083e2 add r3, r3, #1
0xa0450b90 400053e3 cmp r3, #0x40
0xa0450b94 7c00000a beq #0xa0450d8c
0xa0450b98 0420b1e5 ldr r2, [r1, #4]!
0xa0450b9c 7300efe6 uxtb r0, r3
0xa0450ba0 000052e3 cmp r2, #0
0xa0450ba4 f8ffff1a bne #0xa0450b8c
0xa0450ba8 7000afe6 sxtb r0, r0
0xa0450bac 8c1006e3 movw r1, #0x608c
0xa0450bb0 96114ae3 movt r1, #0xa196
0xa0450bb4 000084e5 str r0, [r4]
0xa0450bb8 0100a0e3 mov r0, #1
0xa0450bbc 034181e7 str r4, [r1, r3, lsl #2]
0xa0450bc0 044084e5 str r4, [r4, #4]
0xa0450bc4 003097e5 ldr r3, [r7]
0xa0450bc8 083084e5 str r3, [r4, #8]
0xa0450bcc 0c3097e5 ldr r3, [r7, #0xc]
0xa0450bd0 a43084e5 str r3, [r4, #0xa4]
0xa0450bd4 1c30d7e5 ldrb r3, [r7, #0x1c]
0xa0450bd8 b030c4e5 strb r3, [r4, #0xb0]
0xa0450bdc 203097e5 ldr r3, [r7, #0x20]
0xa0450be0 b83084e5 str r3, [r4, #0xb8]
0xa0450be4 243097e5 ldr r3, [r7, #0x24]
0xa0450be8 bc3084e5 str r3, [r4, #0xbc]
0xa0450bec 103097e5 ldr r3, [r7, #0x10]
0xa0450bf0 a83084e5 str r3, [r4, #0xa8]
0xa0450bf4 143097e5 ldr r3, [r7, #0x14]
0xa0450bf8 b42084e5 str r2, [r4, #0xb4]
0xa0450bfc c42084e5 str r2, [r4, #0xc4]
0xa0450c00 ac3084e5 str r3, [r4, #0xac]
0xa0450c04 283097e5 ldr r3, [r7, #0x28]
0xa0450c08 f400c4e5 strb r0, [r4, #0xf4]
0xa0450c0c c83084e5 str r3, [r4, #0xc8]
0xa0450c10 042097e5 ldr r2, [r7, #4]
0xa0450c14 000052e3 cmp r2, #0
0xa0450c18 0200001a bne #0xa0450c28
0xa0450c1c 00005ce3 cmp ip, #0
0xa0450c20 2202000a beq #0xa04514b0
0xa0450c24 88209ce5 ldr r2, [ip, #0x88]
0xa0450c28 8232a0e1 lsl r3, r2, #5
0xa0450c2c 2000a0e3 mov r0, #0x20
0xa0450c30 882084e5 str r2, [r4, #0x88]
0xa0450c34 801084e2 add r1, r4, #0x80
0xa0450c38 843084e5 str r3, [r4, #0x84]
0xa0450c3c a02084e2 add r2, r4, #0xa0
0xa0450c40 00008de5 str r0, [sp]
0xa0450c44 94089fe5 ldr r0, [pc, #0x894]
0xa0450c48 e226f9eb bl #0xa029a7d8
0xa0450c4c 003050e2 subs r3, r0, #0
0xa0450c50 7f01001a bne #0xa0451254
0xa0450c54 0310a0e1 mov r1, r3
0xa0450c58 800094e5 ldr r0, [r4, #0x80]
0xa0450c5c 842094e5 ldr r2, [r4, #0x84]
0xa0450c60 61a002fa blx #0xa04f8dec
0xa0450c64 081097e5 ldr r1, [r7, #8]
0xa0450c68 000051e3 cmp r1, #0
0xa0450c6c 2f00000a beq #0xa0450d30
0xa0450c70 3030d7e5 ldrb r3, [r7, #0x30]
0xa0450c74 108094e5 ldr r8, [r4, #0x10]
0xa0450c78 000053e3 cmp r3, #0
0xa0450c7c 5300001a bne #0xa0450dd0
0xa0450c80 145088e2 add r5, r8, #0x14
0xa0450c84 0010e0e3 mvn r1, #0
0xa0450c88 0500a0e1 mov r0, r5
0xa0450c8c f6adfdeb bl #0xa03bc46c
0xa0450c90 d829c8e1 ldrd r2, r3, [r8, #0x98]
0xa0450c94 0500a0e1 mov r0, r5
0xa0450c98 f829c4e1 strd r2, r3, [r4, #0x98]
0xa0450c9c fdadfdeb bl #0xa03bc498
0xa0450ca0 983094e5 ldr r3, [r4, #0x98]
0xa0450ca4 ff10a0e3 mov r1, #0xff
0xa0450ca8 9c2094e5 ldr r2, [r4, #0x9c]
0xa0450cac c01084e5 str r1, [r4, #0xc0]
0xa0450cb0 0300a0e1 mov r0, r3
0xa0450cb4 0310a0e1 mov r1, r3
0xa0450cb8 903084e5 str r3, [r4, #0x90]
0xa0450cbc 942084e5 str r2, [r4, #0x94]
0xa0450cc0 103094e5 ldr r3, [r4, #0x10]
0xa0450cc4 b0c30de3 movw ip, #0xd3b0
0xa0450cc8 04008de5 str r0, [sp, #4]
0xa0450ccc 61c04ae3 movt ip, #0xa061
0xa0450cd0 00108de5 str r1, [sp]
0xa0450cd4 b8230de3 movw r2, #0xd3b8
0xa0450cd8 881094e5 ldr r1, [r4, #0x88]
0xa0450cdc 000053e3 cmp r3, #0
0xa0450ce0 61204ae3 movt r2, #0xa061
0xa0450ce4 0c20a001 moveq r2, ip
0xa0450ce8 d8040de3 movw r0, #0xd4d8
0xa0450cec 08108de5 str r1, [sp, #8]
0xa0450cf0 61004ae3 movt r0, #0xa061
0xa0450cf4 80c094e5 ldr ip, [r4, #0x80]
0xa0450cf8 0410a0e1 mov r1, r4
0xa0450cfc 0cc08de5 str ip, [sp, #0xc]
0xa0450d00 84c094e5 ldr ip, [r4, #0x84]
0xa0450d04 10c08de5 str ip, [sp, #0x10]
0xa0450d08 f758f9eb bl #0xa02a70ec
0xa0450d0c 1c309de5 ldr r3, [sp, #0x1c]
0xa0450d10 140084e2 add r0, r4, #0x14
0xa0450d14 004083e5 str r4, [r3]
0xa0450d18 deadfdeb bl #0xa03bc498
0xa0450d1c 480084e2 add r0, r4, #0x48
0xa0450d20 dcadfdeb bl #0xa03bc498
0xa0450d24 0000a0e3 mov r0, #0
0xa0450d28 54d08de2 add sp, sp, #0x54
0xa0450d2c f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa0450d30 0020a0e3 mov r2, #0
0xa0450d34 0030a0e3 mov r3, #0
0xa0450d38 0100a0e1 mov r0, r1
0xa0450d3c f029c4e1 strd r2, r3, [r4, #0x90]
0xa0450d40 f829c4e1 strd r2, r3, [r4, #0x98]
0xa0450d44 ddffffea b #0xa0450cc0
0xa0450d48 00c0a0e3 mov ip, #0
0xa0450d4c 030058e1 cmp r8, r3
0xa0450d50 8affff1a bne #0xa0450b80
0xa0450d54 0040a0e3 mov r4, #0
0xa0450d58 0c040de3 movw r0, #0xd40c
0xa0450d5c dc1901e3 movw r1, #0x19dc
0xa0450d60 74290de3 movw r2, #0xd974
0xa0450d64 383600e3 movw r3, #0x638
0xa0450d68 00408de5 str r4, [sp]
0xa0450d6c 61004ae3 movt r0, #0xa061
0xa0450d70 60104ae3 movt r1, #0xa060
0xa0450d74 61204ae3 movt r2, #0xa061
0xa0450d78 db58f9eb bl #0xa02a70ec
0xa0450d7c 1c309de5 ldr r3, [sp, #0x1c]
0xa0450d80 0000e0e3 mvn r0, #0
0xa0450d84 004083e5 str r4, [r3]
0xa0450d88 e6ffffea b #0xa0450d28
0xa0450d8c 0030a0e3 mov r3, #0
0xa0450d90 28050de3 movw r0, #0xd528
0xa0450d94 dc1901e3 movw r1, #0x19dc
0xa0450d98 74290de3 movw r2, #0xd974
0xa0450d9c 60104ae3 movt r1, #0xa060
0xa0450da0 61204ae3 movt r2, #0xa061
0xa0450da4 00308de5 str r3, [sp]
0xa0450da8 61004ae3 movt r0, #0xa061
0xa0450dac 633600e3 movw r3, #0x663
0xa0450db0 cd58f9eb bl #0xa02a70ec
0xa0450db4 140084e2 add r0, r4, #0x14
0xa0450db8 b6adfdeb bl #0xa03bc498
0xa0450dbc 480084e2 add r0, r4, #0x48
0xa0450dc0 b4adfdeb bl #0xa03bc498
0xa0450dc4 0000e0e3 mvn r0, #0
0xa0450dc8 54d08de2 add sp, sp, #0x54
0xa0450dcc f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa0450dd0 140088e2 add r0, r8, #0x14
0xa0450dd4 0010e0e3 mvn r1, #0
0xa0450dd8 28008de5 str r0, [sp, #0x28]
0xa0450ddc 889098e5 ldr sb, [r8, #0x88]
0xa0450de0 a1adfdeb bl #0xa03bc46c
0xa0450de4 d829c8e1 ldrd r2, r3, [r8, #0x98]
0xa0450de8 88a094e5 ldr sl, [r4, #0x88]
0xa0450dec f829c4e1 strd r2, r3, [r4, #0x98]
0xa0450df0 901098e5 ldr r1, [r8, #0x90]
0xa0450df4 01e04ae2 sub lr, sl, #1
0xa0450df8 940098e5 ldr r0, [r8, #0x94]
0xa0450dfc 02c061e0 rsb ip, r1, r2
0xa0450e00 901084e5 str r1, [r4, #0x90]
0xa0450e04 0e005ce1 cmp ip, lr
0xa0450e08 940084e5 str r0, [r4, #0x94]
0xa0450e0c 0300009a bls #0xa0450e20
0xa0450e10 0e0052e0 subs r0, r2, lr
0xa0450e14 0ec0a0e1 mov ip, lr
0xa0450e18 0010c3e2 sbc r1, r3, #0
0xa0450e1c f009c4e1 strd r0, r1, [r4, #0x90]
0xa0450e20 3110d7e5 ldrb r1, [r7, #0x31]
0xa0450e24 020051e3 cmp r1, #2
0xa0450e28 38909705 ldreq sb, [r7, #0x38]
0xa0450e2c 0c0059e1 cmp sb, ip
0xa0450e30 0c90a021 movhs sb, ip
0xa0450e34 090052e0 subs r0, r2, sb
0xa0450e38 0010c3e2 sbc r1, r3, #0
0xa0450e3c 000059e3 cmp sb, #0
0xa0450e40 0020a0e1 mov r2, r0
0xa0450e44 0130a0e1 mov r3, r1
0xa0450e48 f022cde1 strd r2, r3, [sp, #0x20]
0xa0450e4c f029c4e1 strd r2, r3, [r4, #0x90]
0xa0450e50 3100000a beq #0xa0450f1c
0xa0450e54 20009de5 ldr r0, [sp, #0x20]
0xa0450e58 0a10a0e1 mov r1, sl
0xa0450e5c 04d602fa blx #0xa0506674
0xa0450e60 806094e5 ldr r6, [r4, #0x80]
0xa0450e64 d022cde1 ldrd r2, r3, [sp, #0x20]
0xa0450e68 88b098e5 ldr fp, [r8, #0x88]
0xa0450e6c 023089e0 add r3, sb, r2
0xa0450e70 0200a0e1 mov r0, r2
0xa0450e74 816286e0 add r6, r6, r1, lsl #5
0xa0450e78 0b10a0e1 mov r1, fp
0xa0450e7c 20909de5 ldr sb, [sp, #0x20]
0xa0450e80 30308de5 str r3, [sp, #0x30]
0xa0450e84 fad502fa blx #0xa0506674
0xa0450e88 805098e5 ldr r5, [r8, #0x80]
0xa0450e8c 20708de5 str r7, [sp, #0x20]
0xa0450e90 0970a0e1 mov r7, sb
0xa0450e94 30909de5 ldr sb, [sp, #0x30]
0xa0450e98 815285e0 add r5, r5, r1, lsl #5
0xa0450e9c 001095e5 ldr r1, [r5]
0xa0450ea0 017087e2 add r7, r7, #1
0xa0450ea4 04e095e5 ldr lr, [r5, #4]
0xa0450ea8 0700a0e1 mov r0, r7
0xa0450eac 08c095e5 ldr ip, [r5, #8]
0xa0450eb0 206086e2 add r6, r6, #0x20
0xa0450eb4 0c2095e5 ldr r2, [r5, #0xc]
0xa0450eb8 205085e2 add r5, r5, #0x20
0xa0450ebc 201006e5 str r1, [r6, #-0x20]
0xa0450ec0 1ce006e5 str lr, [r6, #-0x1c]
0xa0450ec4 18c006e5 str ip, [r6, #-0x18]
0xa0450ec8 142006e5 str r2, [r6, #-0x14]
0xa0450ecc 0ce015e5 ldr lr, [r5, #-0xc]
0xa0450ed0 08c015e5 ldr ip, [r5, #-8]
0xa0450ed4 042015e5 ldr r2, [r5, #-4]
0xa0450ed8 101015e5 ldr r1, [r5, #-0x10]
0xa0450edc 0ce006e5 str lr, [r6, #-0xc]
0xa0450ee0 08c006e5 str ip, [r6, #-8]
0xa0450ee4 101006e5 str r1, [r6, #-0x10]
0xa0450ee8 0a10a0e1 mov r1, sl
0xa0450eec 042006e5 str r2, [r6, #-4]
0xa0450ef0 dfd502fa blx #0xa0506674
0xa0450ef4 0700a0e1 mov r0, r7
0xa0450ef8 000051e3 cmp r1, #0
0xa0450efc 0b10a0e1 mov r1, fp
0xa0450f00 80609405 ldreq r6, [r4, #0x80]
0xa0450f04 dad502fa blx #0xa0506674
0xa0450f08 000051e3 cmp r1, #0
0xa0450f0c 80509805 ldreq r5, [r8, #0x80]
0xa0450f10 090057e1 cmp r7, sb
0xa0450f14 e0ffff1a bne #0xa0450e9c
0xa0450f18 20709de5 ldr r7, [sp, #0x20]
0xa0450f1c 28009de5 ldr r0, [sp, #0x28]
0xa0450f20 5cadfdeb bl #0xa03bc498
0xa0450f24 4030d7e5 ldrb r3, [r7, #0x40]
0xa0450f28 c03084e5 str r3, [r4, #0xc0]
0xa0450f2c 3130d7e5 ldrb r3, [r7, #0x31]
0xa0450f30 020053e3 cmp r3, #2
0xa0450f34 0900000a beq #0xa0450f60
0xa0450f38 010053e3 cmp r3, #1
0xa0450f3c 6b00000a beq #0xa04510f0
0xa0450f40 030053e3 cmp r3, #3
0xa0450f44 d400000a beq #0xa045129c
0xa0450f48 040053e3 cmp r3, #4
0xa0450f4c 6000000a beq #0xa04510d4
0xa0450f50 28509de5 ldr r5, [sp, #0x28]
0xa0450f54 0010e0e3 mvn r1, #0
0xa0450f58 0500a0e1 mov r0, r5
0xa0450f5c 4affffea b #0xa0450c8c
0xa0450f60 d089c4e1 ldrd r8, sb, [r4, #0x90]
0xa0450f64 0030a0e3 mov r3, #0
0xa0450f68 885094e5 ldr r5, [r4, #0x88]
0xa0450f6c 0800a0e1 mov r0, r8
0xa0450f70 0910a0e1 mov r1, sb
0xa0450f74 0520a0e1 mov r2, r5
0xa0450f78 eed702fa blx #0xa0506f38
0xa0450f7c d809c4e1 ldrd r0, r1, [r4, #0x98]
0xa0450f80 0030a0e3 mov r3, #0
0xa0450f84 20208de5 str r2, [sp, #0x20]
0xa0450f88 0520a0e1 mov r2, r5
0xa0450f8c e9d702fa blx #0xa0506f38
0xa0450f90 803094e5 ldr r3, [r4, #0x80]
0xa0450f94 006052e2 subs r6, r2, #0
0xa0450f98 20c09de5 ldr ip, [sp, #0x20]
0xa0450f9c 7e234612 subne r2, r6, #0xf8000001
0xa0450fa0 40a0d7e5 ldrb sl, [r7, #0x40]
0xa0450fa4 0300a0e1 mov r0, r3
0xa0450fa8 82228310 addne r2, r3, r2, lsl #5
0xa0450fac 8cb283e0 add fp, r3, ip, lsl #5
0xa0450fb0 0b20a001 moveq r2, fp
0xa0450fb4 06005ce1 cmp ip, r6
0xa0450fb8 d820c2e1 ldrd r2, r3, [r2, #8]
0xa0450fbc f822cde1 strd r2, r3, [sp, #0x28]
0xa0450fc0 1600000a beq #0xa0451020
0xa0450fc4 1020dbe5 ldrb r2, [fp, #0x10]
0xa0450fc8 0a0052e1 cmp r2, sl
0xa0450fcc 20708d15 strne r7, [sp, #0x20]
0xa0450fd0 0c10a011 movne r1, ip
0xa0450fd4 0b70a011 movne r7, fp
0xa0450fd8 00b0a011 movne fp, r0
0xa0450fdc 0300001a bne #0xa0450ff0
0xa0450fe0 ed0000ea b #0xa045139c
0xa0450fe4 1020d7e5 ldrb r2, [r7, #0x10]
0xa0450fe8 0a0052e1 cmp r2, sl
0xa0450fec e800000a beq #0xa0451394
0xa0450ff0 018098e2 adds r8, r8, #1
0xa0450ff4 010081e2 add r0, r1, #1
0xa0450ff8 0510a0e1 mov r1, r5
0xa0450ffc 0090a9e2 adc sb, sb, #0
0xa0451000 9bd502fa blx #0xa0506674
0xa0451004 000051e3 cmp r1, #0
0xa0451008 207087e2 add r7, r7, #0x20
0xa045100c 0b70a001 moveq r7, fp
0xa0451010 010056e1 cmp r6, r1
0xa0451014 f089c4e1 strd r8, sb, [r4, #0x90]
0xa0451018 f1ffff1a bne #0xa0450fe4
0xa045101c 20709de5 ldr r7, [sp, #0x20]
0xa0451020 0000e0e3 mvn r0, #0
0xa0451024 0010e0e3 mvn r1, #0
0xa0451028 0020a0e3 mov r2, #0
0xa045102c 0030a0e3 mov r3, #0
0xa0451030 f804c7e1 strd r0, r1, [r7, #0x48]
0xa0451034 f025c7e1 strd r2, r3, [r7, #0x50]
0xa0451038 c0a084e5 str sl, [r4, #0xc0]
0xa045103c 981094e5 ldr r1, [r4, #0x98]
0xa0451040 900094e5 ldr r0, [r4, #0x90]
0xa0451044 1dffffea b #0xa0450cc0
0xa0451048 0120a0e3 mov r2, #1
0xa045104c 04c09be5 ldr ip, [fp, #4]
0xa0451050 0c2084e5 str r2, [r4, #0xc]
0xa0451054 54109be5 ldr r1, [fp, #0x54]
0xa0451058 000097e5 ldr r0, [r7]
0xa045105c 000051e3 cmp r1, #0
0xa0451060 0400001a bne #0xa0451078
0xa0451064 6f0000ea b #0xa0451228
0xa0451068 013083e2 add r3, r3, #1
0xa045106c f8c08ce2 add ip, ip, #0xf8
0xa0451070 010053e1 cmp r3, r1
0xa0451074 6b00000a beq #0xa0451228
0xa0451078 08209ce5 ldr r2, [ip, #8]
0xa045107c 020050e1 cmp r0, r2
0xa0451080 f8ffff1a bne #0xa0451068
0xa0451084 00005ce3 cmp ip, #0
0xa0451088 10c08415 strne ip, [r4, #0x10]
0xa045108c 50309615 ldrne r3, [r6, #0x50]
0xa0451090 2dffff1a bne #0xa0450d4c
0xa0451094 0030a0e3 mov r3, #0
0xa0451098 54040de3 movw r0, #0xd454
0xa045109c dc1901e3 movw r1, #0x19dc
0xa04510a0 74290de3 movw r2, #0xd974
0xa04510a4 60104ae3 movt r1, #0xa060
0xa04510a8 61204ae3 movt r2, #0xa061
0xa04510ac 00308de5 str r3, [sp]
0xa04510b0 61004ae3 movt r0, #0xa061
0xa04510b4 2a3600e3 movw r3, #0x62a
0xa04510b8 0b58f9eb bl #0xa02a70ec
0xa04510bc 0a00a0e1 mov r0, sl
0xa04510c0 f4acfdeb bl #0xa03bc498
0xa04510c4 0900a0e1 mov r0, sb
0xa04510c8 f2acfdeb bl #0xa03bc498
0xa04510cc 0000e0e3 mvn r0, #0
0xa04510d0 14ffffea b #0xa0450d28
0xa04510d4 4030d7e5 ldrb r3, [r7, #0x40]
0xa04510d8 0120a0e3 mov r2, #1
0xa04510dc c42084e5 str r2, [r4, #0xc4]
0xa04510e0 981094e5 ldr r1, [r4, #0x98]
0xa04510e4 c03084e5 str r3, [r4, #0xc0]
0xa04510e8 900094e5 ldr r0, [r4, #0x90]
0xa04510ec f3feffea b #0xa0450cc0
0xa04510f0 886094e5 ldr r6, [r4, #0x88]
0xa04510f4 0030a0e3 mov r3, #0
0xa04510f8 d009c4e1 ldrd r0, r1, [r4, #0x90]
0xa04510fc 0620a0e1 mov r2, r6
0xa0451100 f803cde1 strd r0, r1, [sp, #0x38]
0xa0451104 8bd702fa blx #0xa0506f38
0xa0451108 d809c4e1 ldrd r0, r1, [r4, #0x98]
0xa045110c 0290a0e1 mov sb, r2
0xa0451110 0030a0e3 mov r3, #0
0xa0451114 0620a0e1 mov r2, r6
0xa0451118 86d702fa blx #0xa0506f38
0xa045111c 280097e5 ldr r0, [r7, #0x28]
0xa0451120 008052e2 subs r8, r2, #0
0xa0451124 3cc097e5 ldr ip, [r7, #0x3c]
0xa0451128 7ee34812 subne lr, r8, #0xf8000001
0xa045112c 803094e5 ldr r3, [r4, #0x80]
0xa0451130 381097e5 ldr r1, [r7, #0x38]
0xa0451134 2ca097e5 ldr sl, [r7, #0x2c]
0xa0451138 900c0ce0 mul ip, r0, ip
0xa045113c 38b097e5 ldr fp, [r7, #0x38]
0xa0451140 895283e0 add r5, r3, sb, lsl #5
0xa0451144 4020d7e5 ldrb r2, [r7, #0x40]
0xa0451148 900181e0 umull r0, r1, r0, r1
0xa045114c 8ee28310 addne lr, r3, lr, lsl #5
0xa0451150 05e0a001 moveq lr, r5
0xa0451154 30308de5 str r3, [sp, #0x30]
0xa0451158 34208de5 str r2, [sp, #0x34]
0xa045115c 0030a0e3 mov r3, #0
0xa0451160 fa2fa0e3 mov r2, #0x3e8
0xa0451164 9bca2ce0 mla ip, fp, sl, ip
0xa0451168 d8a0cee1 ldrd sl, fp, [lr, #8]
0xa045116c f0a4cde1 strd sl, fp, [sp, #0x40]
0xa0451170 01108ce0 add r1, ip, r1
0xa0451174 6fd702fa blx #0xa0506f38
0xa0451178 01005be1 cmp fp, r1
0xa045117c 00005a01 cmpeq sl, r0
0xa0451180 a500009a bls #0xa045141c
0xa0451184 d024cde1 ldrd r2, r3, [sp, #0x40]
0xa0451188 002052e0 subs r2, r2, r0
0xa045118c 0130c3e0 sbc r3, r3, r1
0xa0451190 f022cde1 strd r2, r3, [sp, #0x20]
0xa0451194 080059e1 cmp sb, r8
0xa0451198 1700000a beq #0xa04511fc
0xa045119c d8a3cde1 ldrd sl, fp, [sp, #0x38]
0xa04511a0 28608de5 str r6, [sp, #0x28]
0xa04511a4 48708de5 str r7, [sp, #0x48]
0xa04511a8 d820c5e1 ldrd r2, r3, [r5, #8]
0xa04511ac 010089e2 add r0, sb, #1
0xa04511b0 d062cde1 ldrd r6, r7, [sp, #0x20]
0xa04511b4 28109de5 ldr r1, [sp, #0x28]
0xa04511b8 030057e1 cmp r7, r3
0xa04511bc 02005601 cmpeq r6, r2
0xa04511c0 0300002a bhs #0xa04511d4
0xa04511c4 10c0d5e5 ldrb ip, [r5, #0x10]
0xa04511c8 34e09de5 ldr lr, [sp, #0x34]
0xa04511cc 0e005ce1 cmp ip, lr
0xa04511d0 9500000a beq #0xa045142c
0xa04511d4 26d502fa blx #0xa0506674
0xa04511d8 01a09ae2 adds sl, sl, #1
0xa04511dc 205085e2 add r5, r5, #0x20
0xa04511e0 00b0abe2 adc fp, fp, #0
0xa04511e4 009051e2 subs sb, r1, #0
0xa04511e8 30509d05 ldreq r5, [sp, #0x30]
0xa04511ec 090058e1 cmp r8, sb
0xa04511f0 f0a9c4e1 strd sl, fp, [r4, #0x90]
0xa04511f4 ebffff1a bne #0xa04511a8
0xa04511f8 48709de5 ldr r7, [sp, #0x48]
0xa04511fc 0030a0e3 mov r3, #0
0xa0451200 0020a0e3 mov r2, #0
0xa0451204 f025c7e1 strd r2, r3, [r7, #0x50]
0xa0451208 0000e0e3 mvn r0, #0
0xa045120c 34309de5 ldr r3, [sp, #0x34]
0xa0451210 0010e0e3 mvn r1, #0
0xa0451214 f804c7e1 strd r0, r1, [r7, #0x48]
0xa0451218 981094e5 ldr r1, [r4, #0x98]
0xa045121c c03084e5 str r3, [r4, #0xc0]
0xa0451220 900094e5 ldr r0, [r4, #0x90]
0xa0451224 a5feffea b #0xa0450cc0
0xa0451228 0030a0e3 mov r3, #0
0xa045122c 30040de3 movw r0, #0xd430
0xa0451230 dc1901e3 movw r1, #0x19dc
0xa0451234 e8290ce3 movw r2, #0xc9e8
0xa0451238 00308de5 str r3, [sp]
0xa045123c 60104ae3 movt r1, #0xa060
0xa0451240 61204ae3 movt r2, #0xa061
0xa0451244 c23fa0e3 mov r3, #0x308
0xa0451248 61004ae3 movt r0, #0xa061
0xa045124c a657f9eb bl #0xa02a70ec
0xa0451250 8fffffea b #0xa0451094
0xa0451254 b8040de3 movw r0, #0xd4b8
0xa0451258 dc1901e3 movw r1, #0x19dc
0xa045125c 74290de3 movw r2, #0xd974
0xa0451260 60104ae3 movt r1, #0xa060
0xa0451264 00308de5 str r3, [sp]
0xa0451268 61204ae3 movt r2, #0xa061
0xa045126c 863600e3 movw r3, #0x686
0xa0451270 61004ae3 movt r0, #0xa061
0xa0451274 9c57f9eb bl #0xa02a70ec
0xa0451278 1c209de5 ldr r2, [sp, #0x1c]
0xa045127c 0030a0e3 mov r3, #0
0xa0451280 140084e2 add r0, r4, #0x14
0xa0451284 003082e5 str r3, [r2]
0xa0451288 82acfdeb bl #0xa03bc498
0xa045128c 480084e2 add r0, r4, #0x48
0xa0451290 80acfdeb bl #0xa03bc498
0xa0451294 0000e0e3 mvn r0, #0
0xa0451298 a2feffea b #0xa0450d28
0xa045129c 886094e5 ldr r6, [r4, #0x88]
0xa04512a0 0030a0e3 mov r3, #0
0xa04512a4 d009c4e1 ldrd r0, r1, [r4, #0x90]
0xa04512a8 0620a0e1 mov r2, r6
0xa04512ac f803cde1 strd r0, r1, [sp, #0x38]
0xa04512b0 20d702fa blx #0xa0506f38
0xa04512b4 d809c4e1 ldrd r0, r1, [r4, #0x98]
0xa04512b8 0290a0e1 mov sb, r2
0xa04512bc 0030a0e3 mov r3, #0
0xa04512c0 0620a0e1 mov r2, r6
0xa04512c4 1bd702fa blx #0xa0506f38
0xa04512c8 280097e5 ldr r0, [r7, #0x28]
0xa04512cc 008052e2 subs r8, r2, #0
0xa04512d0 3cc097e5 ldr ip, [r7, #0x3c]
0xa04512d4 7ee34812 subne lr, r8, #0xf8000001
0xa04512d8 803094e5 ldr r3, [r4, #0x80]
0xa04512dc 381097e5 ldr r1, [r7, #0x38]
0xa04512e0 2ca097e5 ldr sl, [r7, #0x2c]
0xa04512e4 900c0ce0 mul ip, r0, ip
0xa04512e8 38b097e5 ldr fp, [r7, #0x38]
0xa04512ec 895283e0 add r5, r3, sb, lsl #5
0xa04512f0 4020d7e5 ldrb r2, [r7, #0x40]
0xa04512f4 900181e0 umull r0, r1, r0, r1
0xa04512f8 8ee28310 addne lr, r3, lr, lsl #5
0xa04512fc 05e0a001 moveq lr, r5
0xa0451300 30308de5 str r3, [sp, #0x30]
0xa0451304 34208de5 str r2, [sp, #0x34]
0xa0451308 0030a0e3 mov r3, #0
0xa045130c fa2fa0e3 mov r2, #0x3e8
0xa0451310 9bca2ce0 mla ip, fp, sl, ip
0xa0451314 d8a0cee1 ldrd sl, fp, [lr, #8]
0xa0451318 f8a4cde1 strd sl, fp, [sp, #0x48]
0xa045131c 01108ce0 add r1, ip, r1
0xa0451320 04d702fa blx #0xa0506f38
0xa0451324 080059e1 cmp sb, r8
0xa0451328 f002cde1 strd r0, r1, [sp, #0x20]
0xa045132c b2ffff0a beq #0xa04511fc
0xa0451330 d8a3cde1 ldrd sl, fp, [sp, #0x38]
0xa0451334 28608de5 str r6, [sp, #0x28]
0xa0451338 40708de5 str r7, [sp, #0x40]
0xa045133c d820c5e1 ldrd r2, r3, [r5, #8]
0xa0451340 010089e2 add r0, sb, #1
0xa0451344 d062cde1 ldrd r6, r7, [sp, #0x20]
0xa0451348 28109de5 ldr r1, [sp, #0x28]
0xa045134c 030057e1 cmp r7, r3
0xa0451350 02005601 cmpeq r6, r2
0xa0451354 0300002a bhs #0xa0451368
0xa0451358 10c0d5e5 ldrb ip, [r5, #0x10]
0xa045135c 34e09de5 ldr lr, [sp, #0x34]
0xa0451360 0e005ce1 cmp ip, lr
0xa0451364 4100000a beq #0xa0451470
0xa0451368 c1d402fa blx #0xa0506674
0xa045136c 01a09ae2 adds sl, sl, #1
0xa0451370 205085e2 add r5, r5, #0x20
0xa0451374 00b0abe2 adc fp, fp, #0
0xa0451378 009051e2 subs sb, r1, #0
0xa045137c 30509d05 ldreq r5, [sp, #0x30]
0xa0451380 090058e1 cmp r8, sb
0xa0451384 f0a9c4e1 strd sl, fp, [r4, #0x90]
0xa0451388 ebffff1a bne #0xa045133c
0xa045138c 40709de5 ldr r7, [sp, #0x40]
0xa0451390 99ffffea b #0xa04511fc
0xa0451394 07b0a0e1 mov fp, r7
0xa0451398 20709de5 ldr r7, [sp, #0x20]
0xa045139c d820cbe1 ldrd r2, r3, [fp, #8]
0xa04513a0 d802cde1 ldrd r0, r1, [sp, #0x28]
0xa04513a4 f824c7e1 strd r2, r3, [r7, #0x48]
0xa04513a8 d884c7e1 ldrd r8, sb, [r7, #0x48]
0xa04513ac d822c7e1 ldrd r2, r3, [r7, #0x28]
0xa04513b0 080050e0 subs r0, r0, r8
0xa04513b4 0910c1e0 sbc r1, r1, sb
0xa04513b8 00a1a0e1 lsl sl, r0, #2
0xa04513bc 01c1a0e1 lsl ip, r1, #2
0xa04513c0 20bf8ce1 orr fp, ip, r0, lsr #30
0xa04513c4 8bc2a0e1 lsl ip, fp, #5
0xa04513c8 aacd8ce1 orr ip, ip, sl, lsr #27
0xa04513cc 24c08de5 str ip, [sp, #0x24]
0xa04513d0 8ac2a0e1 lsl ip, sl, #5
0xa04513d4 20c08de5 str ip, [sp, #0x20]
0xa04513d8 d082cde1 ldrd r8, sb, [sp, #0x20]
0xa04513dc 0a8058e0 subs r8, r8, sl
0xa04513e0 0b90c9e0 sbc sb, sb, fp
0xa04513e4 08a090e0 adds sl, r0, r8
0xa04513e8 09b0a1e0 adc fp, r1, sb
0xa04513ec 8ae1a0e1 lsl lr, sl, #3
0xa04513f0 8bc1a0e1 lsl ip, fp, #3
0xa04513f4 0e00a0e1 mov r0, lr
0xa04513f8 aace8ce1 orr ip, ip, sl, lsr #29
0xa04513fc 0c10a0e1 mov r1, ip
0xa0451400 ccd602fa blx #0xa0506f38
0xa0451404 ff30a0e3 mov r3, #0xff
0xa0451408 f005c7e1 strd r0, r1, [r7, #0x50]
0xa045140c c03084e5 str r3, [r4, #0xc0]
0xa0451410 981094e5 ldr r1, [r4, #0x98]
0xa0451414 900094e5 ldr r0, [r4, #0x90]
0xa0451418 28feffea b #0xa0450cc0
0xa045141c 0020a0e3 mov r2, #0
0xa0451420 0030a0e3 mov r3, #0
0xa0451424 f022cde1 strd r2, r3, [sp, #0x20]
0xa0451428 59ffffea b #0xa0451194
0xa045142c 080059e1 cmp sb, r8
0xa0451430 48709de5 ldr r7, [sp, #0x48]
0xa0451434 70ffff0a beq #0xa04511fc
0xa0451438 d004cde1 ldrd r0, r1, [sp, #0x40]
0xa045143c 020050e0 subs r0, r0, r2
0xa0451440 f824c7e1 strd r2, r3, [r7, #0x48]
0xa0451444 0310c1e0 sbc r1, r1, r3
0xa0451448 00a1a0e1 lsl sl, r0, #2
0xa045144c 01c1a0e1 lsl ip, r1, #2
0xa0451450 d822c7e1 ldrd r2, r3, [r7, #0x28]
0xa0451454 20bf8ce1 orr fp, ip, r0, lsr #30
0xa0451458 8bc2a0e1 lsl ip, fp, #5
0xa045145c aacd8ce1 orr ip, ip, sl, lsr #27
0xa0451460 0c90a0e1 mov sb, ip
0xa0451464 8ac2a0e1 lsl ip, sl, #5
0xa0451468 0c80a0e1 mov r8, ip
0xa045146c daffffea b #0xa04513dc
0xa0451470 080059e1 cmp sb, r8
0xa0451474 40709de5 ldr r7, [sp, #0x40]
0xa0451478 5fffff0a beq #0xa04511fc
0xa045147c d804cde1 ldrd r0, r1, [sp, #0x48]
0xa0451480 edffffea b #0xa045143c
0xa0451484 c0030de3 movw r0, #0xd3c0
0xa0451488 dc1901e3 movw r1, #0x19dc
0xa045148c 74290de3 movw r2, #0xd974
0xa0451490 00308de5 str r3, [sp]
0xa0451494 61004ae3 movt r0, #0xa061
0xa0451498 60104ae3 movt r1, #0xa060
0xa045149c 61204ae3 movt r2, #0xa061
0xa04514a0 173600e3 movw r3, #0x617
0xa04514a4 1057f9eb bl #0xa02a70ec
0xa04514a8 0000e0e3 mvn r0, #0
0xa04514ac 1dfeffea b #0xa0450d28
0xa04514b0 80040de3 movw r0, #0xd480
0xa04514b4 dc1901e3 movw r1, #0x19dc
0xa04514b8 74290de3 movw r2, #0xd974
0xa04514bc 00c08de5 str ip, [sp]
0xa04514c0 61004ae3 movt r0, #0xa061
0xa04514c4 60104ae3 movt r1, #0xa060
0xa04514c8 61204ae3 movt r2, #0xa061
0xa04514cc 7b3600e3 movw r3, #0x67b
0xa04514d0 0557f9eb bl #0xa02a70ec
0xa04514d4 0000e0e3 mvn r0, #0
0xa04514d8 12feffea b #0xa0450d28
0xa04514e4 f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
0xa04514e8 00a0a0e3 mov sl, #0
0xa04514ec 045090e5 ldr r5, [r0, #4]
0xa04514f0 18d04de2 sub sp, sp, #0x18
0xa04514f4 632700e3 movw r2, #0x763
0xa04514f8 0060a0e1 mov r6, r0
0xa04514fc 0c10a0e3 mov r1, #0xc
0xa0451500 0200a0e3 mov r0, #2
0xa0451504 0530a0e1 mov r3, r5
0xa0451508 00a08de5 str sl, [sp]
0xa045150c 04a08de5 str sl, [sp, #4]
0xa0451510 488085e2 add r8, r5, #0x48
0xa0451514 08a08de5 str sl, [sp, #8]
0xa0451518 149085e2 add sb, r5, #0x14
0xa045151c 84f4ffeb bl #0xa044e734
0xa0451520 0010e0e3 mvn r1, #0
0xa0451524 0800a0e1 mov r0, r8
0xa0451528 cfabfdeb bl #0xa03bc46c
0xa045152c 0900a0e1 mov r0, sb
0xa0451530 0010e0e3 mvn r1, #0
0xa0451534 ccabfdeb bl #0xa03bc46c
0xa0451538 003096e5 ldr r3, [r6]
0xa045153c 3f0053e3 cmp r3, #0x3f
0xa0451540 4300008a bhi #0xa0451654
0xa0451544 980095e5 ldr r0, [r5, #0x98]
0xa0451548 b0130de3 movw r1, #0xd3b0
0xa045154c 103095e5 ldr r3, [r5, #0x10]
0xa0451550 61104ae3 movt r1, #0xa061
0xa0451554 b8230de3 movw r2, #0xd3b8
0xa0451558 8c7006e3 movw r7, #0x608c
0xa045155c 00008de5 str r0, [sp]
0xa0451560 54050de3 movw r0, #0xd554
0xa0451564 90c095e5 ldr ip, [r5, #0x90]
0xa0451568 000053e3 cmp r3, #0
0xa045156c 61204ae3 movt r2, #0xa061
0xa0451570 61004ae3 movt r0, #0xa061
0xa0451574 0120a001 moveq r2, r1
0xa0451578 0510a0e1 mov r1, r5
0xa045157c 04c08de5 str ip, [sp, #4]
0xa0451580 96714ae3 movt r7, #0xa196
0xa0451584 88c095e5 ldr ip, [r5, #0x88]
0xa0451588 08c08de5 str ip, [sp, #8]
0xa045158c 80c095e5 ldr ip, [r5, #0x80]
0xa0451590 0cc08de5 str ip, [sp, #0xc]
0xa0451594 84c095e5 ldr ip, [r5, #0x84]
0xa0451598 10c08de5 str ip, [sp, #0x10]
0xa045159c d256f9eb bl #0xa02a70ec
0xa04515a0 003096e5 ldr r3, [r6]
0xa04515a4 034197e7 ldr r4, [r7, r3, lsl #2]
0xa04515a8 000054e3 cmp r4, #0
0xa04515ac 3100000a beq #0xa0451678
0xa04515b0 0c4095e5 ldr r4, [r5, #0xc]
0xa04515b4 000054e3 cmp r4, #0
0xa04515b8 5a00000a beq #0xa0451728
0xa04515bc a00095e5 ldr r0, [r5, #0xa0]
0xa04515c0 000050e3 cmp r0, #0
0xa04515c4 0200000a beq #0xa04515d4
0xa04515c8 51acfdeb bl #0xa03bc714
0xa04515cc 004050e2 subs r4, r0, #0
0xa04515d0 3c00001a bne #0xa04516c8
0xa04515d4 80c095e5 ldr ip, [r5, #0x80]
0xa04515d8 0040a0e3 mov r4, #0
0xa04515dc 0530a0e1 mov r3, r5
0xa04515e0 0c10a0e3 mov r1, #0xc
0xa04515e4 882700e3 movw r2, #0x788
0xa04515e8 0100a0e3 mov r0, #1
0xa04515ec 00c08de5 str ip, [sp]
0xa04515f0 84c095e5 ldr ip, [r5, #0x84]
0xa04515f4 08408de5 str r4, [sp, #8]
0xa04515f8 04c08de5 str ip, [sp, #4]
0xa04515fc 4cf4ffeb bl #0xa044e734
0xa0451600 a04085e5 str r4, [r5, #0xa0]
0xa0451604 0900a0e1 mov r0, sb
0xa0451608 804085e5 str r4, [r5, #0x80]
0xa045160c 0c4085e5 str r4, [r5, #0xc]
0xa0451610 084085e5 str r4, [r5, #8]
0xa0451614 9fabfdeb bl #0xa03bc498
0xa0451618 0800a0e1 mov r0, r8
0xa045161c 9dabfdeb bl #0xa03bc498
0xa0451620 00c096e5 ldr ip, [r6]
0xa0451624 0530a0e1 mov r3, r5
0xa0451628 00408de5 str r4, [sp]
0xa045162c 0c10a0e3 mov r1, #0xc
0xa0451630 04408de5 str r4, [sp, #4]
0xa0451634 922700e3 movw r2, #0x792
0xa0451638 08408de5 str r4, [sp, #8]
0xa045163c 0400a0e3 mov r0, #4
0xa0451640 0c4187e7 str r4, [r7, ip, lsl #2]
0xa0451644 3af4ffeb bl #0xa044e734
0xa0451648 0400a0e1 mov r0, r4
0xa045164c 18d08de2 add sp, sp, #0x18
0xa0451650 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
0xa0451654 a80b0ae3 movw r0, #0xaba8
0xa0451658 68190ce3 movw r1, #0xc968
0xa045165c 61104ae3 movt r1, #0xa061
0xa0451660 672700e3 movw r2, #0x767
0xa0451664 53004ae3 movt r0, #0xa053
0xa0451668 9f56f9eb bl #0xa02a70ec
0xa045166c ac57f9eb bl #0xa02a7524
0xa0451670 c0000cf1 cpsid if
0xa0451674 feffffea b #0xa0451674
0xa0451678 a4050de3 movw r0, #0xd5a4
0xa045167c 441d0ce3 movw r1, #0xcd44
0xa0451680 68290ce3 movw r2, #0xc968
0xa0451684 00408de5 str r4, [sp]
0xa0451688 61104ae3 movt r1, #0xa061
0xa045168c 61204ae3 movt r2, #0xa061
0xa0451690 773ea0e3 mov r3, #0x770
0xa0451694 61004ae3 movt r0, #0xa061
0xa0451698 9356f9eb bl #0xa02a70ec
0xa045169c 00408de5 str r4, [sp]
0xa04516a0 0530a0e1 mov r3, r5
0xa04516a4 04408de5 str r4, [sp, #4]
0xa04516a8 0c10a0e3 mov r1, #0xc
0xa04516ac 08408de5 str r4, [sp, #8]
0xa04516b0 722700e3 movw r2, #0x772
0xa04516b4 0400a0e3 mov r0, #4
0xa04516b8 1df4ffeb bl #0xa044e734
0xa04516bc 0400a0e1 mov r0, r4
0xa04516c0 18d08de2 add sp, sp, #0x18
0xa04516c4 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
0xa04516c8 f4050de3 movw r0, #0xd5f4
0xa04516cc dc1901e3 movw r1, #0x19dc
0xa04516d0 68290ce3 movw r2, #0xc968
0xa04516d4 60104ae3 movt r1, #0xa060
0xa04516d8 61204ae3 movt r2, #0xa061
0xa04516dc 813700e3 movw r3, #0x781
0xa04516e0 00408de5 str r4, [sp]
0xa04516e4 61004ae3 movt r0, #0xa061
0xa04516e8 7f56f9eb bl #0xa02a70ec
0xa04516ec 0900a0e1 mov r0, sb
0xa04516f0 68abfdeb bl #0xa03bc498
0xa04516f4 0800a0e1 mov r0, r8
0xa04516f8 66abfdeb bl #0xa03bc498
0xa04516fc 00408de5 str r4, [sp]
0xa0451700 0530a0e1 mov r3, r5
0xa0451704 04a08de5 str sl, [sp, #4]
0xa0451708 0c10a0e3 mov r1, #0xc
0xa045170c 08a08de5 str sl, [sp, #8]
0xa0451710 842700e3 movw r2, #0x784
0xa0451714 0400a0e3 mov r0, #4
0xa0451718 05f4ffeb bl #0xa044e734
0xa045171c 0000e0e3 mvn r0, #0
0xa0451720 18d08de2 add sp, sp, #0x18
0xa0451724 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
0xa0451728 c4050de3 movw r0, #0xd5c4
0xa045172c dc1901e3 movw r1, #0x19dc
0xa0451730 68290ce3 movw r2, #0xc968
0xa0451734 50008de8 stm sp, {r4, r6}
0xa0451738 60104ae3 movt r1, #0xa060
0xa045173c 61204ae3 movt r2, #0xa061
0xa0451740 773700e3 movw r3, #0x777
0xa0451744 61004ae3 movt r0, #0xa061
0xa0451748 6756f9eb bl #0xa02a70ec
0xa045174c 0020e0e3 mvn r2, #0
0xa0451750 04408de5 str r4, [sp, #4]
0xa0451754 00208de5 str r2, [sp]
0xa0451758 0530a0e1 mov r3, r5
0xa045175c 08408de5 str r4, [sp, #8]
0xa0451760 0c10a0e3 mov r1, #0xc
0xa0451764 782700e3 movw r2, #0x778
0xa0451768 0400a0e3 mov r0, #4
0xa045176c f0f3ffeb bl #0xa044e734
0xa0451770 0400a0e1 mov r0, r4
0xa0451774 18d08de2 add sp, sp, #0x18
0xa0451778 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
0xa0451960 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa0451964 14d04de2 sub sp, sp, #0x14
0xa0451968 044090e5 ldr r4, [r0, #4]
0xa045196c 0c3094e5 ldr r3, [r4, #0xc]
0xa0451970 000053e3 cmp r3, #0
0xa0451974 5500000a beq #0xa0451ad0
0xa0451978 0090a0e3 mov sb, #0
0xa045197c 00108de5 str r1, [sp]
0xa0451980 04208de5 str r2, [sp, #4]
0xa0451984 0430a0e1 mov r3, r4
0xa0451988 0160a0e1 mov r6, r1
0xa045198c 0250a0e1 mov r5, r2
0xa0451990 0e10a0e3 mov r1, #0xe
0xa0451994 dd2700e3 movw r2, #0x7dd
0xa0451998 0200a0e3 mov r0, #2
0xa045199c 08908de5 str sb, [sp, #8]
0xa04519a0 147084e2 add r7, r4, #0x14
0xa04519a4 62f3ffeb bl #0xa044e734
0xa04519a8 0700a0e1 mov r0, r7
0xa04519ac 0010e0e3 mvn r1, #0
0xa04519b0 adaafdeb bl #0xa03bc46c
0xa04519b4 008050e2 subs r8, r0, #0
0xa04519b8 1d00001a bne #0xa0451a34
0xa04519bc 882094e5 ldr r2, [r4, #0x88]
0xa04519c0 020055e1 cmp r5, r2
0xa04519c4 0030a023 movhs r3, #0
0xa04519c8 00308625 strhs r3, [r6]
0xa04519cc 0a00002a bhs #0xa04519fc
0xa04519d0 d089c4e1 ldrd r8, sb, [r4, #0x90]
0xa04519d4 0030a0e3 mov r3, #0
0xa04519d8 d8a9c4e1 ldrd sl, fp, [r4, #0x98]
0xa04519dc 08005ae0 subs r0, sl, r8
0xa04519e0 0910cbe0 sbc r1, fp, sb
0xa04519e4 030051e1 cmp r1, r3
0xa04519e8 02005001 cmpeq r0, r2
0xa04519ec 1b00009a bls #0xa0451a60
0xa04519f0 0880e0e3 mvn r8, #8
0xa04519f4 0030a0e3 mov r3, #0
0xa04519f8 003086e5 str r3, [r6]
0xa04519fc 0700a0e1 mov r0, r7
0xa0451a00 a4aafdeb bl #0xa03bc498
0xa0451a04 0020a0e3 mov r2, #0
0xa0451a08 00608de5 str r6, [sp]
0xa0451a0c 08208de5 str r2, [sp, #8]
0xa0451a10 0430a0e1 mov r3, r4
0xa0451a14 04508de5 str r5, [sp, #4]
0xa0451a18 0400a0e3 mov r0, #4
0xa0451a1c 0e10a0e3 mov r1, #0xe
0xa0451a20 fe2700e3 movw r2, #0x7fe
0xa0451a24 42f3ffeb bl #0xa044e734
0xa0451a28 0800a0e1 mov r0, r8
0xa0451a2c 14d08de2 add sp, sp, #0x14
0xa0451a30 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa0451a34 14060de3 movw r0, #0xd614
0xa0451a38 dc1901e3 movw r1, #0x19dc
0xa0451a3c 0c290de3 movw r2, #0xd90c
0xa0451a40 00908de5 str sb, [sp]
0xa0451a44 04408de5 str r4, [sp, #4]
0xa0451a48 60104ae3 movt r1, #0xa060
0xa0451a4c 61204ae3 movt r2, #0xa061
0xa0451a50 e13700e3 movw r3, #0x7e1
0xa0451a54 61004ae3 movt r0, #0xa061
0xa0451a58 a355f9eb bl #0xa02a70ec
0xa0451a5c d6ffffea b #0xa04519bc
0xa0451a60 050098e0 adds r0, r8, r5
0xa0451a64 0010a9e2 adc r1, sb, #0
0xa0451a68 0b0051e1 cmp r1, fp
0xa0451a6c 0a005001 cmpeq r0, sl
0xa0451a70 0030a023 movhs r3, #0
0xa0451a74 0780e023 mvnhs r8, #7
0xa0451a78 00308625 strhs r3, [r6]
0xa0451a7c deffff2a bhs #0xa04519fc
0xa0451a80 809094e5 ldr sb, [r4, #0x80]
0xa0451a84 0030a0e3 mov r3, #0
0xa0451a88 0380a0e1 mov r8, r3
0xa0451a8c 009086e5 str sb, [r6]
0xa0451a90 882094e5 ldr r2, [r4, #0x88]
0xa0451a94 27d502fa blx #0xa0506f38
0xa0451a98 82c289e0 add ip, sb, r2, lsl #5
0xa0451a9c 0e10a0e3 mov r1, #0xe
0xa0451aa0 fa2700e3 movw r2, #0x7fa
0xa0451aa4 00c086e5 str ip, [r6]
0xa0451aa8 0430a0e1 mov r3, r4
0xa0451aac 08e09ce5 ldr lr, [ip, #8]
0xa0451ab0 0100a0e3 mov r0, #1
0xa0451ab4 00e08de5 str lr, [sp]
0xa0451ab8 14e09ce5 ldr lr, [ip, #0x14]
0xa0451abc 04e08de5 str lr, [sp, #4]
0xa0451ac0 18c09ce5 ldr ip, [ip, #0x18]
0xa0451ac4 08c08de5 str ip, [sp, #8]
0xa0451ac8 19f3ffeb bl #0xa044e734
0xa0451acc caffffea b #0xa04519fc
0xa0451ad0 5c0c0ce3 movw r0, #0xcc5c
0xa0451ad4 dc1901e3 movw r1, #0x19dc
0xa0451ad8 0c290de3 movw r2, #0xd90c
0xa0451adc 18008de8 stm sp, {r3, r4}
0xa0451ae0 61004ae3 movt r0, #0xa061
0xa0451ae4 60104ae3 movt r1, #0xa060
0xa0451ae8 61204ae3 movt r2, #0xa061
0xa0451aec d93700e3 movw r3, #0x7d9
0xa0451af0 7d55f9eb bl #0xa02a70ec
0xa0451af4 0000e0e3 mvn r0, #0
0xa0451af8 cbffffea b #0xa0451a2c
0xa0451afc f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa0451b00 14d04de2 sub sp, sp, #0x14
0xa0451c94 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa0451c98 0080a0e3 mov r8, #0
0xa0451c9c 044090e5 ldr r4, [r0, #4]
0xa0451ca0 5cd04de2 sub sp, sp, #0x5c
0xa0451ca4 0060a0e1 mov r6, r0
0xa0451ca8 103094e5 ldr r3, [r4, #0x10]
0xa0451cac 30808de5 str r8, [sp, #0x30]
0xa0451cb0 34808de5 str r8, [sp, #0x34]
0xa0451cb4 24308de5 str r3, [sp, #0x24]
0xa0451cb8 38808de5 str r8, [sp, #0x38]
0xa0451cbc 3c808de5 str r8, [sp, #0x3c]
0xa0451cc0 40808de5 str r8, [sp, #0x40]
0xa0451cc4 44808de5 str r8, [sp, #0x44]
0xa0451cc8 48808de5 str r8, [sp, #0x48]
0xa0451ccc 4c808de5 str r8, [sp, #0x4c]
0xa0451cd0 50808de5 str r8, [sp, #0x50]
0xa0451cd4 54808de5 str r8, [sp, #0x54]
0xa0451cd8 0c3094e5 ldr r3, [r4, #0xc]
0xa0451cdc 080053e1 cmp r3, r8
0xa0451ce0 c500000a beq #0xa0451ffc
0xa0451ce4 48c084e2 add ip, r4, #0x48
0xa0451ce8 0430a0e1 mov r3, r4
0xa0451cec 0c90a0e1 mov sb, ip
0xa0451cf0 5e2800e3 movw r2, #0x85e
0xa0451cf4 00008de5 str r0, [sp]
0xa0451cf8 0150a0e1 mov r5, r1
0xa0451cfc 04108de5 str r1, [sp, #4]
0xa0451d00 0200a0e3 mov r0, #2
0xa0451d04 1010a0e3 mov r1, #0x10
0xa0451d08 08808de5 str r8, [sp, #8]
0xa0451d0c 28c08de5 str ip, [sp, #0x28]
0xa0451d10 147084e2 add r7, r4, #0x14
0xa0451d14 86f2ffeb bl #0xa044e734
0xa0451d18 0010e0e3 mvn r1, #0
0xa0451d1c 0900a0e1 mov r0, sb
0xa0451d20 d1a9fdeb bl #0xa03bc46c
0xa0451d24 0700a0e1 mov r0, r7
0xa0451d28 0010e0e3 mvn r1, #0
0xa0451d2c cea9fdeb bl #0xa03bc46c
0xa0451d30 003050e2 subs r3, r0, #0
0xa0451d34 2c308de5 str r3, [sp, #0x2c]
0xa0451d38 8100001a bne #0xa0451f44
0xa0451d3c d009c4e1 ldrd r0, r1, [r4, #0x90]
0xa0451d40 d889c4e1 ldrd r8, sb, [r4, #0x98]
0xa0451d44 80b094e5 ldr fp, [r4, #0x80]
0xa0451d48 008058e0 subs r8, r8, r0
0xa0451d4c 080055e1 cmp r5, r8
0xa0451d50 8600008a bhi #0xa0451f70
0xa0451d54 882094e5 ldr r2, [r4, #0x88]
0xa0451d58 0030a0e3 mov r3, #0
0xa0451d5c 75d402fa blx #0xa0506f38
0xa0451d60 0200a0e1 mov r0, r2
0xa0451d64 0310a0e1 mov r1, r3
0xa0451d68 80a28be0 add sl, fp, r0, lsl #5
0xa0451d6c f801cde1 strd r0, r1, [sp, #0x18]
0xa0451d70 742800e3 movw r2, #0x874
0xa0451d74 08e09ae5 ldr lr, [sl, #8]
0xa0451d78 1010a0e3 mov r1, #0x10
0xa0451d7c 0430a0e1 mov r3, r4
0xa0451d80 0090a0e3 mov sb, #0
0xa0451d84 0100a0e3 mov r0, #1
0xa0451d88 0580a0e1 mov r8, r5
0xa0451d8c 00e08de5 str lr, [sp]
0xa0451d90 14e09ae5 ldr lr, [sl, #0x14]
0xa0451d94 f081cde1 strd r8, sb, [sp, #0x10]
0xa0451d98 04e08de5 str lr, [sp, #4]
0xa0451d9c 18e09ae5 ldr lr, [sl, #0x18]
0xa0451da0 08e08de5 str lr, [sp, #8]
0xa0451da4 62f2ffeb bl #0xa044e734
0xa0451da8 d021cde1 ldrd r2, r3, [sp, #0x10]
0xa0451dac d801cde1 ldrd r0, r1, [sp, #0x18]
0xa0451db0 889094e5 ldr sb, [r4, #0x88]
0xa0451db4 020090e0 adds r0, r0, r2
0xa0451db8 0310a1e0 adc r1, r1, r3
0xa0451dbc 0030a0e3 mov r3, #0
0xa0451dc0 030051e1 cmp r1, r3
0xa0451dc4 09005001 cmpeq r0, sb
0xa0451dc8 3b00008a bhi #0xa0451ebc
0xa0451dcc 8592a0e1 lsl sb, r5, #5
0xa0451dd0 0010a0e3 mov r1, #0
0xa0451dd4 0a00a0e1 mov r0, sl
0xa0451dd8 0920a0e1 mov r2, sb
0xa0451ddc 029c02fa blx #0xa04f8dec
0xa0451de0 0030a0e3 mov r3, #0
0xa0451de4 08908de5 str sb, [sp, #8]
0xa0451de8 04308de5 str r3, [sp, #4]
0xa0451dec 0800a0e3 mov r0, #8
0xa0451df0 00a08de5 str sl, [sp]
0xa0451df4 1010a0e3 mov r1, #0x10
0xa0451df8 812800e3 movw r2, #0x881
0xa0451dfc 0430a0e1 mov r3, r4
0xa0451e00 4bf2ffeb bl #0xa044e734
0xa0451e04 d029c4e1 ldrd r2, r3, [r4, #0x90]
0xa0451e08 0080a0e3 mov r8, #0
0xa0451e0c d0a1cde1 ldrd sl, fp, [sp, #0x10]
0xa0451e10 1010a0e3 mov r1, #0x10
0xa0451e14 0100a0e3 mov r0, #1
0xa0451e18 02a09ae0 adds sl, sl, r2
0xa0451e1c 852800e3 movw r2, #0x885
0xa0451e20 03b0abe0 adc fp, fp, r3
0xa0451e24 0430a0e1 mov r3, r4
0xa0451e28 f0a9c4e1 strd sl, fp, [r4, #0x90]
0xa0451e2c 20018de8 stm sp, {r5, r8}
0xa0451e30 08808de5 str r8, [sp, #8]
0xa0451e34 3ef2ffeb bl #0xa044e734
0xa0451e38 0700a0e1 mov r0, r7
0xa0451e3c 95a9fdeb bl #0xa03bc498
0xa0451e40 24309de5 ldr r3, [sp, #0x24]
0xa0451e44 080053e1 cmp r3, r8
0xa0451e48 0200000a beq #0xa0451e58
0xa0451e4c b030d3e5 ldrb r3, [r3, #0xb0]
0xa0451e50 010053e3 cmp r3, #1
0xa0451e54 5c00000a beq #0xa0451fcc
0xa0451e58 04c096e5 ldr ip, [r6, #4]
0xa0451e5c 0133a0e3 mov r3, #0x4000000
0xa0451e60 c0019fe5 ldr r0, [pc, #0x1c0]
0xa0451e64 30108de2 add r1, sp, #0x30
0xa0451e68 0020a0e3 mov r2, #0
0xa0451e6c 38508de5 str r5, [sp, #0x38]
0xa0451e70 34c08de5 str ip, [sp, #0x34]
0xa0451e74 30308de5 str r3, [sp, #0x30]
0xa0451e78 c6a9fdeb bl #0xa03bc598
0xa0451e7c 007050e2 subs r7, r0, #0
0xa0451e80 4700001a bne #0xa0451fa4
0xa0451e84 28009de5 ldr r0, [sp, #0x28]
0xa0451e88 82a9fdeb bl #0xa03bc498
0xa0451e8c 0020a0e3 mov r2, #0
0xa0451e90 00608de5 str r6, [sp]
0xa0451e94 08208de5 str r2, [sp, #8]
0xa0451e98 0430a0e1 mov r3, r4
0xa0451e9c 04508de5 str r5, [sp, #4]
0xa0451ea0 0400a0e3 mov r0, #4
0xa0451ea4 1010a0e3 mov r1, #0x10
0xa0451ea8 992800e3 movw r2, #0x899
0xa0451eac 20f2ffeb bl #0xa044e734
0xa0451eb0 0700a0e1 mov r0, r7
0xa0451eb4 5cd08de2 add sp, sp, #0x5c
0xa0451eb8 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa0451ebc 18309de5 ldr r3, [sp, #0x18]
0xa0451ec0 0a00a0e1 mov r0, sl
0xa0451ec4 0010a0e3 mov r1, #0
0xa0451ec8 099063e0 rsb sb, r3, sb
0xa0451ecc 8932a0e1 lsl r3, sb, #5
0xa0451ed0 059069e0 rsb sb, sb, r5
0xa0451ed4 8992a0e1 lsl sb, sb, #5
0xa0451ed8 0320a0e1 mov r2, r3
0xa0451edc 18308de5 str r3, [sp, #0x18]
0xa0451ee0 c19b02fa blx #0xa04f8dec
0xa0451ee4 18309de5 ldr r3, [sp, #0x18]
0xa0451ee8 1010a0e3 mov r1, #0x10
0xa0451eec 00a08de5 str sl, [sp]
0xa0451ef0 7b2800e3 movw r2, #0x87b
0xa0451ef4 0800a0e3 mov r0, #8
0xa0451ef8 08308de5 str r3, [sp, #8]
0xa0451efc 0030a0e3 mov r3, #0
0xa0451f00 04308de5 str r3, [sp, #4]
0xa0451f04 0430a0e1 mov r3, r4
0xa0451f08 09f2ffeb bl #0xa044e734
0xa0451f0c 0920a0e1 mov r2, sb
0xa0451f10 0b00a0e1 mov r0, fp
0xa0451f14 0010a0e3 mov r1, #0
0xa0451f18 b39b02fa blx #0xa04f8dec
0xa0451f1c 0030a0e3 mov r3, #0
0xa0451f20 08908de5 str sb, [sp, #8]
0xa0451f24 04308de5 str r3, [sp, #4]
0xa0451f28 1010a0e3 mov r1, #0x10
0xa0451f2c 00b08de5 str fp, [sp]
0xa0451f30 7e2800e3 movw r2, #0x87e
0xa0451f34 0430a0e1 mov r3, r4
0xa0451f38 0800a0e3 mov r0, #8
0xa0451f3c fcf1ffeb bl #0xa044e734
0xa0451f40 afffffea b #0xa0451e04
0xa0451f44 14060de3 movw r0, #0xd614
0xa0451f48 dc1901e3 movw r1, #0x19dc
0xa0451f4c f8280de3 movw r2, #0xd8f8
0xa0451f50 00808de5 str r8, [sp]
0xa0451f54 04408de5 str r4, [sp, #4]
0xa0451f58 60104ae3 movt r1, #0xa060
0xa0451f5c 61204ae3 movt r2, #0xa061
0xa0451f60 633800e3 movw r3, #0x863
0xa0451f64 61004ae3 movt r0, #0xa061
0xa0451f68 5f54f9eb bl #0xa02a70ec
0xa0451f6c 72ffffea b #0xa0451d3c
0xa0451f70 0030a0e3 mov r3, #0
0xa0451f74 70060de3 movw r0, #0xd670
0xa0451f78 441d0ce3 movw r1, #0xcd44
0xa0451f7c f8280de3 movw r2, #0xd8f8
0xa0451f80 00308de5 str r3, [sp]
0xa0451f84 61104ae3 movt r1, #0xa061
0xa0451f88 61004ae3 movt r0, #0xa061
0xa0451f8c 61204ae3 movt r2, #0xa061
0xa0451f90 6d3800e3 movw r3, #0x86d
0xa0451f94 0850a0e1 mov r5, r8
0xa0451f98 5354f9eb bl #0xa02a70ec
0xa0451f9c d009c4e1 ldrd r0, r1, [r4, #0x90]
0xa0451fa0 6bffffea b #0xa0451d54
0xa0451fa4 94060de3 movw r0, #0xd694
0xa0451fa8 dc1901e3 movw r1, #0x19dc
0xa0451fac f8280de3 movw r2, #0xd8f8
0xa0451fb0 00708de5 str r7, [sp]
0xa0451fb4 60104ae3 movt r1, #0xa060
0xa0451fb8 61204ae3 movt r2, #0xa061
0xa0451fbc 953800e3 movw r3, #0x895
0xa0451fc0 61004ae3 movt r0, #0xa061
0xa0451fc4 4854f9eb bl #0xa02a70ec
0xa0451fc8 adffffea b #0xa0451e84
0xa0451fcc 28009de5 ldr r0, [sp, #0x28]
0xa0451fd0 30a9fdeb bl #0xa03bc498
0xa0451fd4 00608de5 str r6, [sp]
0xa0451fd8 0430a0e1 mov r3, r4
0xa0451fdc 04508de5 str r5, [sp, #4]
0xa0451fe0 0400a0e3 mov r0, #4
0xa0451fe4 08808de5 str r8, [sp, #8]
0xa0451fe8 1010a0e3 mov r1, #0x10
0xa0451fec 8b2800e3 movw r2, #0x88b
0xa0451ff0 cff1ffeb bl #0xa044e734
0xa0451ff4 2c009de5 ldr r0, [sp, #0x2c]
0xa0451ff8 adffffea b #0xa0451eb4
0xa0451ffc 5c0c0ce3 movw r0, #0xcc5c
0xa0452000 dc1901e3 movw r1, #0x19dc
0xa0452004 f8280de3 movw r2, #0xd8f8
0xa0452008 18008de8 stm sp, {r3, r4}
0xa045200c 61004ae3 movt r0, #0xa061
0xa0452010 60104ae3 movt r1, #0xa060
0xa0452014 61204ae3 movt r2, #0xa061
0xa0452018 5a3800e3 movw r3, #0x85a
0xa045201c 3254f9eb bl #0xa02a70ec
0xa0452020 0000e0e3 mvn r0, #0
0xa0452024 a2ffffea b #0xa0451eb4
0xa044e8d4 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa044e8d8 0050a0e3 mov r5, #0
0xa044e8dc 3cd04de2 sub sp, sp, #0x3c
0xa044e8e0 0030a0e1 mov r3, r0
0xa044e8e4 01b0a0e1 mov fp, r1
0xa044e8e8 ae2300e3 movw r2, #0x3ae
0xa044e8ec 10008de5 str r0, [sp, #0x10]
0xa044e8f0 0200a0e3 mov r0, #2
0xa044e8f4 00108de5 str r1, [sp]
0xa044e8f8 0310a0e3 mov r1, #3
0xa044e8fc 04508de5 str r5, [sp, #4]
0xa044e900 08508de5 str r5, [sp, #8]
0xa044e904 8affffeb bl #0xa044e734
0xa044e908 10309de5 ldr r3, [sp, #0x10]
0xa044e90c 0c4093e5 ldr r4, [r3, #0xc]
0xa044e910 050054e1 cmp r4, r5
0xa044e914 7b00000a beq #0xa044eb08
0xa044e918 10309de5 ldr r3, [sp, #0x10]
0xa044e91c 0010e0e3 mvn r1, #0
0xa044e920 146083e2 add r6, r3, #0x14
0xa044e924 0600a0e1 mov r0, r6
0xa044e928 cfb6fdeb bl #0xa03bc46c
0xa044e92c 14309be5 ldr r3, [fp, #0x14]
0xa044e930 0100a0e3 mov r0, #1
0xa044e934 08c09be5 ldr ip, [fp, #8]
0xa044e938 0310a0e3 mov r1, #3
0xa044e93c 08508de5 str r5, [sp, #8]
0xa044e940 ee2fa0e3 mov r2, #0x3b8
0xa044e944 00308de5 str r3, [sp]
0xa044e948 04c08de5 str ip, [sp, #4]
0xa044e94c 10309de5 ldr r3, [sp, #0x10]
0xa044e950 77ffffeb bl #0xa044e734
0xa044e954 10309de5 ldr r3, [sp, #0x10]
0xa044e958 104093e5 ldr r4, [r3, #0x10]
0xa044e95c 000054e3 cmp r4, #0
0xa044e960 ae00000a beq #0xa044ec20
0xa044e964 ac3094e5 ldr r3, [r4, #0xac]
0xa044e968 482084e2 add r2, r4, #0x48
0xa044e96c 0600a0e1 mov r0, r6
0xa044e970 14208de5 str r2, [sp, #0x14]
0xa044e974 14a084e2 add sl, r4, #0x14
0xa044e978 013083e2 add r3, r3, #1
0xa044e97c 34308de5 str r3, [sp, #0x34]
0xa044e980 c4b6fdeb bl #0xa03bc498
0xa044e984 0010e0e3 mvn r1, #0
0xa044e988 14009de5 ldr r0, [sp, #0x14]
0xa044e98c b6b6fdeb bl #0xa03bc46c
0xa044e990 0010e0e3 mvn r1, #0
0xa044e994 0a00a0e1 mov r0, sl
0xa044e998 b3b6fdeb bl #0xa03bc46c
0xa044e99c d809c4e1 ldrd r0, r1, [r4, #0x98]
0xa044e9a0 0530a0e1 mov r3, r5
0xa044e9a4 882094e5 ldr r2, [r4, #0x88]
0xa044e9a8 62e102fa blx #0xa0506f38
0xa044e9ac 806094e5 ldr r6, [r4, #0x80]
0xa044e9b0 0270a0e1 mov r7, r2
0xa044e9b4 00009be5 ldr r0, [fp]
0xa044e9b8 c52300e3 movw r2, #0x3c5
0xa044e9bc 04109be5 ldr r1, [fp, #4]
0xa044e9c0 08309be5 ldr r3, [fp, #8]
0xa044e9c4 0ce09be5 ldr lr, [fp, #0xc]
0xa044e9c8 87c286e0 add ip, r6, r7, lsl #5
0xa044e9cc 870286e7 str r0, [r6, r7, lsl #5]
0xa044e9d0 04108ce5 str r1, [ip, #4]
0xa044e9d4 08308ce5 str r3, [ip, #8]
0xa044e9d8 0ce08ce5 str lr, [ip, #0xc]
0xa044e9dc 1ce09be5 ldr lr, [fp, #0x1c]
0xa044e9e0 10009be5 ldr r0, [fp, #0x10]
0xa044e9e4 14109be5 ldr r1, [fp, #0x14]
0xa044e9e8 18309be5 ldr r3, [fp, #0x18]
0xa044e9ec 1ce08ce5 str lr, [ip, #0x1c]
0xa044e9f0 10008ce5 str r0, [ip, #0x10]
0xa044e9f4 0800a0e3 mov r0, #8
0xa044e9f8 14108ce5 str r1, [ip, #0x14]
0xa044e9fc 0310a0e3 mov r1, #3
0xa044ea00 18308ce5 str r3, [ip, #0x18]
0xa044ea04 0430a0e1 mov r3, r4
0xa044ea08 00c08de5 str ip, [sp]
0xa044ea0c 20c0a0e3 mov ip, #0x20
0xa044ea10 08c08de5 str ip, [sp, #8]
0xa044ea14 04b08de5 str fp, [sp, #4]
0xa044ea18 45ffffeb bl #0xa044e734
0xa044ea1c d869c4e1 ldrd r6, r7, [r4, #0x98]
0xa044ea20 0310a0e3 mov r1, #3
0xa044ea24 c72300e3 movw r2, #0x3c7
0xa044ea28 0430a0e1 mov r3, r4
0xa044ea2c 0100a0e3 mov r0, #1
0xa044ea30 018096e2 adds r8, r6, #1
0xa044ea34 0090a7e2 adc sb, r7, #0
0xa044ea38 0860a0e1 mov r6, r8
0xa044ea3c 0970a0e1 mov r7, sb
0xa044ea40 f869c4e1 strd r6, r7, [r4, #0x98]
0xa044ea44 00508de5 str r5, [sp]
0xa044ea48 04508de5 str r5, [sp, #4]
0xa044ea4c 08508de5 str r5, [sp, #8]
0xa044ea50 37ffffeb bl #0xa044e734
0xa044ea54 d069c4e1 ldrd r6, r7, [r4, #0x90]
0xa044ea58 0a00a0e1 mov r0, sl
0xa044ea5c d829c4e1 ldrd r2, r3, [r4, #0x98]
0xa044ea60 881094e5 ldr r1, [r4, #0x88]
0xa044ea64 062052e0 subs r2, r2, r6
0xa044ea68 0730c3e0 sbc r3, r3, r7
0xa044ea6c 0260a0e1 mov r6, r2
0xa044ea70 0370a0e1 mov r7, r3
0xa044ea74 0030a0e3 mov r3, #0
0xa044ea78 030057e1 cmp r7, r3
0xa044ea7c 01005601 cmpeq r6, r1
0xa044ea80 0160a003 moveq r6, #1
0xa044ea84 0060a013 movne r6, #0
0xa044ea88 82b6fdeb bl #0xa03bc498
0xa044ea8c a47094e5 ldr r7, [r4, #0xa4]
0xa044ea90 000057e3 cmp r7, #0
0xa044ea94 0800000a beq #0xa044eabc
0xa044ea98 d809c4e1 ldrd r0, r1, [r4, #0x98]
0xa044ea9c 0530a0e1 mov r3, r5
0xa044eaa0 34a09de5 ldr sl, [sp, #0x34]
0xa044eaa4 010050e2 subs r0, r0, #1
0xa044eaa8 0010c1e2 sbc r1, r1, #0
0xa044eaac 0a20a0e1 mov r2, sl
0xa044eab0 20e102fa blx #0xa0506f38
0xa044eab4 033092e1 orrs r3, r2, r3
0xa044eab8 3f00000a beq #0xa044ebbc
0xa044eabc 14009de5 ldr r0, [sp, #0x14]
0xa044eac0 74b6fdeb bl #0xa03bc498
0xa044eac4 a43094e5 ldr r3, [r4, #0xa4]
0xa044eac8 000053e3 cmp r3, #0
0xa044eacc 0060a003 moveq r6, #0
0xa044ead0 01600612 andne r6, r6, #1
0xa044ead4 000056e3 cmp r6, #0
0xa044ead8 1e00001a bne #0xa044eb58
0xa044eadc 0020a0e3 mov r2, #0
0xa044eae0 00b08de5 str fp, [sp]
0xa044eae4 04208de5 str r2, [sp, #4]
0xa044eae8 0310a0e3 mov r1, #3
0xa044eaec 08208de5 str r2, [sp, #8]
0xa044eaf0 0400a0e3 mov r0, #4
0xa044eaf4 10309de5 ldr r3, [sp, #0x10]
0xa044eaf8 3e2400e3 movw r2, #0x43e
0xa044eafc 0cffffeb bl #0xa044e734
0xa044eb00 3cd08de2 add sp, sp, #0x3c
0xa044eb04 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa044eb08 5c0c0ce3 movw r0, #0xcc5c
0xa044eb0c dc1901e3 movw r1, #0x19dc
0xa044eb10 38290de3 movw r2, #0xd938
0xa044eb14 04308de5 str r3, [sp, #4]
0xa044eb18 00408de5 str r4, [sp]
0xa044eb1c 60104ae3 movt r1, #0xa060
0xa044eb20 61204ae3 movt r2, #0xa061
0xa044eb24 b13300e3 movw r3, #0x3b1
0xa044eb28 61004ae3 movt r0, #0xa061
0xa044eb2c 6e61f9eb bl #0xa02a70ec
0xa044eb30 00b08de5 str fp, [sp]
0xa044eb34 0310a0e3 mov r1, #3
0xa044eb38 10309de5 ldr r3, [sp, #0x10]
0xa044eb3c b22300e3 movw r2, #0x3b2
0xa044eb40 04408de5 str r4, [sp, #4]
0xa044eb44 0400a0e3 mov r0, #4
0xa044eb48 08408de5 str r4, [sp, #8]
0xa044eb4c f8feffeb bl #0xa044e734
0xa044eb50 3cd08de2 add sp, sp, #0x3c
0xa044eb54 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa044eb58 0550a0e3 mov r5, #5
0xa044eb5c 0060a0e3 mov r6, #0
0xa044eb60 005440e3 movt r5, #0x400
0xa044eb64 08608de5 str r6, [sp, #8]
0xa044eb68 28008de8 stm sp, {r3, r5}
0xa044eb6c 0310a0e3 mov r1, #3
0xa044eb70 0430a0e1 mov r3, r4
0xa044eb74 d92300e3 movw r2, #0x3d9
0xa044eb78 1000a0e3 mov r0, #0x10
0xa044eb7c ecfeffeb bl #0xa044e734
0xa044eb80 0510a0e1 mov r1, r5
0xa044eb84 0620a0e1 mov r2, r6
0xa044eb88 a43094e5 ldr r3, [r4, #0xa4]
0xa044eb8c 0400a0e1 mov r0, r4
0xa044eb90 33ff2fe1 blx r3
0xa044eb94 a42094e5 ldr r2, [r4, #0xa4]
0xa044eb98 0430a0e1 mov r3, r4
0xa044eb9c 04508de5 str r5, [sp, #4]
0xa044eba0 0310a0e3 mov r1, #3
0xa044eba4 08608de5 str r6, [sp, #8]
0xa044eba8 2000a0e3 mov r0, #0x20
0xa044ebac 00208de5 str r2, [sp]
0xa044ebb0 db2300e3 movw r2, #0x3db
0xa044ebb4 defeffeb bl #0xa044e734
0xa044ebb8 c7ffffea b #0xa044eadc
0xa044ebbc 8153a0e3 mov r5, #0x4000002
0xa044ebc0 0430a0e1 mov r3, r4
0xa044ebc4 00708de5 str r7, [sp]
0xa044ebc8 0310a0e3 mov r1, #3
0xa044ebcc 08a08de5 str sl, [sp, #8]
0xa044ebd0 d12300e3 movw r2, #0x3d1
0xa044ebd4 04508de5 str r5, [sp, #4]
0xa044ebd8 1000a0e3 mov r0, #0x10
0xa044ebdc d4feffeb bl #0xa044e734
0xa044ebe0 0510a0e1 mov r1, r5
0xa044ebe4 a43094e5 ldr r3, [r4, #0xa4]
0xa044ebe8 34208de2 add r2, sp, #0x34
0xa044ebec 0400a0e1 mov r0, r4
0xa044ebf0 33ff2fe1 blx r3
0xa044ebf4 a43094e5 ldr r3, [r4, #0xa4]
0xa044ebf8 0310a0e3 mov r1, #3
0xa044ebfc 34c09de5 ldr ip, [sp, #0x34]
0xa044ec00 d32300e3 movw r2, #0x3d3
0xa044ec04 04508de5 str r5, [sp, #4]
0xa044ec08 2000a0e3 mov r0, #0x20
0xa044ec0c 00308de5 str r3, [sp]
0xa044ec10 0430a0e1 mov r3, r4
0xa044ec14 08c08de5 str ip, [sp, #8]
0xa044ec18 c5feffeb bl #0xa044e734
0xa044ec1c a6ffffea b #0xa044eabc
0xa044ec20 8c8106e3 movw r8, #0x618c
0xa044ec24 0600a0e1 mov r0, r6
0xa044ec28 96814ae3 movt r8, #0xa196
0xa044ec2c 10309de5 ldr r3, [sp, #0x10]
0xa044ec30 506098e5 ldr r6, [r8, #0x50]
0xa044ec34 08a098e5 ldr sl, [r8, #8]
0xa044ec38 087093e5 ldr r7, [r3, #8]
0xa044ec3c 15b6fdeb bl #0xa03bc498
0xa044ec40 000056e3 cmp r6, #0
0xa044ec44 a4ffffda ble #0xa044eadc
0xa044ec48 0530a0e3 mov r3, #5
0xa044ec4c 7c2003e3 movw r2, #0x307c
0xa044ec50 0450a0e1 mov r5, r4
0xa044ec54 003440e3 movt r3, #0x400
0xa044ec58 6f204ae3 movt r2, #0xa06f
0xa044ec5c 1c408de5 str r4, [sp, #0x1c]
0xa044ec60 20308de5 str r3, [sp, #0x20]
0xa044ec64 24208de5 str r2, [sp, #0x24]
0xa044ec68 14608de5 str r6, [sp, #0x14]
0xa044ec6c 18708de5 str r7, [sp, #0x18]
0xa044ec70 28808de5 str r8, [sp, #0x28]
0xa044ec74 0c309ae5 ldr r3, [sl, #0xc]
0xa044ec78 000053e3 cmp r3, #0
0xa044ec7c 0300000a beq #0xa044ec90
0xa044ec80 08309ae5 ldr r3, [sl, #8]
0xa044ec84 18209de5 ldr r2, [sp, #0x18]
0xa044ec88 020053e1 cmp r3, r2
0xa044ec8c 0500000a beq #0xa044eca8
0xa044ec90 14309de5 ldr r3, [sp, #0x14]
0xa044ec94 015085e2 add r5, r5, #1
0xa044ec98 f8a08ae2 add sl, sl, #0xf8
0xa044ec9c 050053e1 cmp r3, r5
0xa044eca0 f3ffff1a bne #0xa044ec74
0xa044eca4 8cffffea b #0xa044eadc
0xa044eca8 14308ae2 add r3, sl, #0x14
0xa044ecac 0010e0e3 mvn r1, #0
0xa044ecb0 0300a0e1 mov r0, r3
0xa044ecb4 2c308de5 str r3, [sp, #0x2c]
0xa044ecb8 ebb5fdeb bl #0xa03bc46c
0xa044ecbc c4309ae5 ldr r3, [sl, #0xc4]
0xa044ecc0 000053e3 cmp r3, #0
0xa044ecc4 bd00001a bne #0xa044efc0
0xa044ecc8 0c209ae5 ldr r2, [sl, #0xc]
0xa044eccc 000052e3 cmp r2, #0
0xa044ecd0 9c00001a bne #0xa044ef48
0xa044ecd4 80309ae5 ldr r3, [sl, #0x80]
0xa044ecd8 004053e2 subs r4, r3, #0
0xa044ecdc b100000a beq #0xa044efa8
0xa044ece0 ac109ae5 ldr r1, [sl, #0xac]
0xa044ece4 0230a0e1 mov r3, r2
0xa044ece8 012081e2 add r2, r1, #1
0xa044ecec 34208de5 str r2, [sp, #0x34]
0xa044ecf0 d809cae1 ldrd r0, r1, [sl, #0x98]
0xa044ecf4 88209ae5 ldr r2, [sl, #0x88]
0xa044ecf8 8ee002fa blx #0xa0506f38
0xa044ecfc 0280a0e1 mov r8, r2
0xa044ed00 00909be5 ldr sb, [fp]
0xa044ed04 0430a0e1 mov r3, r4
0xa044ed08 08e09be5 ldr lr, [fp, #8]
0xa044ed0c 884284e0 add r4, r4, r8, lsl #5
0xa044ed10 0cc09be5 ldr ip, [fp, #0xc]
0xa044ed14 0820a0e1 mov r2, r8
0xa044ed18 04809be5 ldr r8, [fp, #4]
0xa044ed1c 0310a0e3 mov r1, #3
0xa044ed20 829283e7 str sb, [r3, r2, lsl #5]
0xa044ed24 0800a0e3 mov r0, #8
0xa044ed28 08e084e5 str lr, [r4, #8]
0xa044ed2c 062400e3 movw r2, #0x406
0xa044ed30 048084e5 str r8, [r4, #4]
0xa044ed34 0a30a0e1 mov r3, sl
0xa044ed38 0cc084e5 str ip, [r4, #0xc]
0xa044ed3c 1cc09be5 ldr ip, [fp, #0x1c]
0xa044ed40 10909be5 ldr sb, [fp, #0x10]
0xa044ed44 14809be5 ldr r8, [fp, #0x14]
0xa044ed48 18e09be5 ldr lr, [fp, #0x18]
0xa044ed4c 1cc084e5 str ip, [r4, #0x1c]
0xa044ed50 20c0a0e3 mov ip, #0x20
0xa044ed54 109084e5 str sb, [r4, #0x10]
0xa044ed58 148084e5 str r8, [r4, #0x14]
0xa044ed5c 18e084e5 str lr, [r4, #0x18]
0xa044ed60 08c08de5 str ip, [sp, #8]
0xa044ed64 10088de8 stm sp, {r4, fp}
0xa044ed68 71feffeb bl #0xa044e734
0xa044ed6c d889cae1 ldrd r8, sb, [sl, #0x98]
0xa044ed70 0310a0e3 mov r1, #3
0xa044ed74 092400e3 movw r2, #0x409
0xa044ed78 0a30a0e1 mov r3, sl
0xa044ed7c 0100a0e3 mov r0, #1
0xa044ed80 016098e2 adds r6, r8, #1
0xa044ed84 0070a9e2 adc r7, sb, #0
0xa044ed88 0680a0e1 mov r8, r6
0xa044ed8c 0790a0e1 mov sb, r7
0xa044ed90 f889cae1 strd r8, sb, [sl, #0x98]
0xa044ed94 08809be5 ldr r8, [fp, #8]
0xa044ed98 14e09be5 ldr lr, [fp, #0x14]
0xa044ed9c 18c09be5 ldr ip, [fp, #0x18]
0xa044eda0 00418de8 stm sp, {r8, lr}
0xa044eda4 08c08de5 str ip, [sp, #8]
0xa044eda8 61feffeb bl #0xa044e734
0xa044edac d029cae1 ldrd r2, r3, [sl, #0x90]
0xa044edb0 d809cae1 ldrd r0, r1, [sl, #0x98]
0xa044edb4 88e09ae5 ldr lr, [sl, #0x88]
0xa044edb8 0260a0e1 mov r6, r2
0xa044edbc 0370a0e1 mov r7, r3
0xa044edc0 022050e0 subs r2, r0, r2
0xa044edc4 c0c09ae5 ldr ip, [sl, #0xc0]
0xa044edc8 0330c1e0 sbc r3, r1, r3
0xa044edcc 0280a0e1 mov r8, r2
0xa044edd0 0390a0e1 mov sb, r3
0xa044edd4 0030a0e3 mov r3, #0
0xa044edd8 030059e1 cmp sb, r3
0xa044eddc 1c309de5 ldr r3, [sp, #0x1c]
0xa044ede0 0e005801 cmpeq r8, lr
0xa044ede4 0130a003 moveq r3, #1
0xa044ede8 ff005ce3 cmp ip, #0xff
0xa044edec 1c308de5 str r3, [sp, #0x1c]
0xa044edf0 0a00000a beq #0xa044ee20
0xa044edf4 1030d4e5 ldrb r3, [r4, #0x10]
0xa044edf8 03005ce1 cmp ip, r3
0xa044edfc ff30a003 moveq r3, #0xff
0xa044ee00 c0308a05 streq r3, [sl, #0xc0]
0xa044ee04 0500000a beq #0xa044ee20
0xa044ee08 018096e2 adds r8, r6, #1
0xa044ee0c 2c009de5 ldr r0, [sp, #0x2c]
0xa044ee10 0090a7e2 adc sb, r7, #0
0xa044ee14 f089cae1 strd r8, sb, [sl, #0x90]
0xa044ee18 9eb5fdeb bl #0xa03bc498
0xa044ee1c 9bffffea b #0xa044ec90
0xa044ee20 182094e5 ldr r2, [r4, #0x18]
0xa044ee24 ff34e0e3 mvn r3, #0xff000000
0xa044ee28 030052e1 cmp r2, r3
0xa044ee2c 6600000a beq #0xa044efcc
0xa044ee30 1030d4e5 ldrb r3, [r4, #0x10]
0xa044ee34 ff0053e3 cmp r3, #0xff
0xa044ee38 6300000a beq #0xa044efcc
0xa044ee3c 34209de5 ldr r2, [sp, #0x34]
0xa044ee40 0030a0e3 mov r3, #0
0xa044ee44 3be002fa blx #0xa0506f38
0xa044ee48 033092e1 orrs r3, r2, r3
0xa044ee4c 2c009de5 ldr r0, [sp, #0x2c]
0xa044ee50 7f00001a bne #0xa044f054
0xa044ee54 8fb5fdeb bl #0xa03bc498
0xa044ee58 a4309ae5 ldr r3, [sl, #0xa4]
0xa044ee5c 000053e3 cmp r3, #0
0xa044ee60 8affff0a beq #0xa044ec90
0xa044ee64 38808de2 add r8, sp, #0x38
0xa044ee68 8143a0e3 mov r4, #0x4000002
0xa044ee6c 04c038e5 ldr ip, [r8, #-4]!
0xa044ee70 0310a0e3 mov r1, #3
0xa044ee74 00308de5 str r3, [sp]
0xa044ee78 2b2400e3 movw r2, #0x42b
0xa044ee7c 0a30a0e1 mov r3, sl
0xa044ee80 1000a0e3 mov r0, #0x10
0xa044ee84 08c08de5 str ip, [sp, #8]
0xa044ee88 04408de5 str r4, [sp, #4]
0xa044ee8c 28feffeb bl #0xa044e734
0xa044ee90 0820a0e1 mov r2, r8
0xa044ee94 0410a0e1 mov r1, r4
0xa044ee98 a4309ae5 ldr r3, [sl, #0xa4]
0xa044ee9c 0a00a0e1 mov r0, sl
0xa044eea0 33ff2fe1 blx r3
0xa044eea4 a4309ae5 ldr r3, [sl, #0xa4]
0xa044eea8 2000a0e3 mov r0, #0x20
0xa044eeac 34c09de5 ldr ip, [sp, #0x34]
0xa044eeb0 0310a0e3 mov r1, #3
0xa044eeb4 04408de5 str r4, [sp, #4]
0xa044eeb8 2d2400e3 movw r2, #0x42d
0xa044eebc 00308de5 str r3, [sp]
0xa044eec0 0a30a0e1 mov r3, sl
0xa044eec4 08c08de5 str ip, [sp, #8]
0xa044eec8 19feffeb bl #0xa044e734
0xa044eecc a4309ae5 ldr r3, [sl, #0xa4]
0xa044eed0 1c209de5 ldr r2, [sp, #0x1c]
0xa044eed4 000052e3 cmp r2, #0
0xa044eed8 00005313 cmpne r3, #0
0xa044eedc 6bffff0a beq #0xa044ec90
0xa044eee0 20809de5 ldr r8, [sp, #0x20]
0xa044eee4 0040a0e3 mov r4, #0
0xa044eee8 00308de5 str r3, [sp]
0xa044eeec 0310a0e3 mov r1, #3
0xa044eef0 0a30a0e1 mov r3, sl
0xa044eef4 08408de5 str r4, [sp, #8]
0xa044eef8 04808de5 str r8, [sp, #4]
0xa044eefc 372400e3 movw r2, #0x437
0xa044ef00 1000a0e3 mov r0, #0x10
0xa044ef04 0afeffeb bl #0xa044e734
0xa044ef08 0510a0e3 mov r1, #5
0xa044ef0c 0420a0e1 mov r2, r4
0xa044ef10 a4309ae5 ldr r3, [sl, #0xa4]
0xa044ef14 001440e3 movt r1, #0x400
0xa044ef18 0a00a0e1 mov r0, sl
0xa044ef1c 33ff2fe1 blx r3
0xa044ef20 a4309ae5 ldr r3, [sl, #0xa4]
0xa044ef24 0310a0e3 mov r1, #3
0xa044ef28 08408de5 str r4, [sp, #8]
0xa044ef2c 392400e3 movw r2, #0x439
0xa044ef30 04808de5 str r8, [sp, #4]
0xa044ef34 2000a0e3 mov r0, #0x20
0xa044ef38 00308de5 str r3, [sp]
0xa044ef3c 0a30a0e1 mov r3, sl
0xa044ef40 fbfdffeb bl #0xa044e734
0xa044ef44 51ffffea b #0xa044ec90
0xa044ef48 ac209ae5 ldr r2, [sl, #0xac]
0xa044ef4c 80109ae5 ldr r1, [sl, #0x80]
0xa044ef50 012082e2 add r2, r2, #1
0xa044ef54 34208de5 str r2, [sp, #0x34]
0xa044ef58 0140a0e1 mov r4, r1
0xa044ef5c 88209ae5 ldr r2, [sl, #0x88]
0xa044ef60 d809cae1 ldrd r0, r1, [sl, #0x98]
0xa044ef64 f3df02fa blx #0xa0506f38
0xa044ef68 000054e3 cmp r4, #0
0xa044ef6c 0280a0e1 mov r8, r2
0xa044ef70 62ffff1a bne #0xa044ed00
0xa044ef74 24309de5 ldr r3, [sp, #0x24]
0xa044ef78 a80c0ce3 movw r0, #0xcca8
0xa044ef7c 14209de5 ldr r2, [sp, #0x14]
0xa044ef80 61004ae3 movt r0, #0xa061
0xa044ef84 041093e5 ldr r1, [r3, #4]
0xa044ef88 28309de5 ldr r3, [sp, #0x28]
0xa044ef8c 083093e5 ldr r3, [r3, #8]
0xa044ef90 00208de5 str r2, [sp]
0xa044ef94 0420a0e1 mov r2, r4
0xa044ef98 08048de9 stmib sp, {r3, sl}
0xa044ef9c 0530a0e1 mov r3, r5
0xa044efa0 5160f9eb bl #0xa02a70ec
0xa044efa4 55ffffea b #0xa044ed00
0xa044efa8 840c0ce3 movw r0, #0xcc84
0xa044efac 38190de3 movw r1, #0xd938
0xa044efb0 61004ae3 movt r0, #0xa061
0xa044efb4 61104ae3 movt r1, #0xa061
0xa044efb8 0a20a0e1 mov r2, sl
0xa044efbc 4a60f9eb bl #0xa02a70ec
0xa044efc0 2c009de5 ldr r0, [sp, #0x2c]
0xa044efc4 33b5fdeb bl #0xa03bc498
0xa044efc8 30ffffea b #0xa044ec90
0xa044efcc ff34e0e3 mvn r3, #0xff000000
0xa044efd0 2c009de5 ldr r0, [sp, #0x2c]
0xa044efd4 34308de5 str r3, [sp, #0x34]
0xa044efd8 2eb5fdeb bl #0xa03bc498
0xa044efdc a4309ae5 ldr r3, [sl, #0xa4]
0xa044efe0 000053e3 cmp r3, #0
0xa044efe4 29ffff0a beq #0xa044ec90
0xa044efe8 38808de2 add r8, sp, #0x38
0xa044efec 4143a0e3 mov r4, #0x4000001
0xa044eff0 04c038e5 ldr ip, [r8, #-4]!
0xa044eff4 0310a0e3 mov r1, #3
0xa044eff8 00308de5 str r3, [sp]
0xa044effc 232400e3 movw r2, #0x423
0xa044f000 0a30a0e1 mov r3, sl
0xa044f004 04408de5 str r4, [sp, #4]
0xa044f008 08c08de5 str ip, [sp, #8]
0xa044f00c 1000a0e3 mov r0, #0x10
0xa044f010 c7fdffeb bl #0xa044e734
0xa044f014 0820a0e1 mov r2, r8
0xa044f018 0410a0e1 mov r1, r4
0xa044f01c a4309ae5 ldr r3, [sl, #0xa4]
0xa044f020 0a00a0e1 mov r0, sl
0xa044f024 33ff2fe1 blx r3
0xa044f028 a4309ae5 ldr r3, [sl, #0xa4]
0xa044f02c 0310a0e3 mov r1, #3
0xa044f030 34c09de5 ldr ip, [sp, #0x34]
0xa044f034 252400e3 movw r2, #0x425
0xa044f038 04408de5 str r4, [sp, #4]
0xa044f03c 2000a0e3 mov r0, #0x20
0xa044f040 00308de5 str r3, [sp]
0xa044f044 0a30a0e1 mov r3, sl
0xa044f048 08c08de5 str ip, [sp, #8]
0xa044f04c b8fdffeb bl #0xa044e734
0xa044f050 9dffffea b #0xa044eecc
0xa044f054 0fb5fdeb bl #0xa03bc498
0xa044f058 9bffffea b #0xa044eecc
0xa044f05c 0430a0e3 mov r3, #4
0xa044f060 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa044f064 003440e3 movt r3, #0x400
0xa044f068 6cd04de2 sub sp, sp, #0x6c
0xa044f06c 080d0ce3 movw r0, #0xcd08
0xa044f070 14308de5 str r3, [sp, #0x14]
0xa044f074 61004ae3 movt r0, #0xa061
0xa044f078 0030a0e3 mov r3, #0
0xa044f07c 40308de5 str r3, [sp, #0x40]
0xa044f080 44308de5 str r3, [sp, #0x44]
0xa044f084 48308de5 str r3, [sp, #0x48]
0xa044f088 4c308de5 str r3, [sp, #0x4c]
0xa044f08c 50308de5 str r3, [sp, #0x50]
0xa044f090 54308de5 str r3, [sp, #0x54]
0xa044f094 58308de5 str r3, [sp, #0x58]
0xa044f098 5c308de5 str r3, [sp, #0x5c]
0xa044f09c 60308de5 str r3, [sp, #0x60]
0xa044f0a0 64308de5 str r3, [sp, #0x64]
0xa044f0a4 1060f9eb bl #0xa02a70ec
0xa044f0a8 8c7106e3 movw r7, #0x618c
0xa044f0ac 40108de2 add r1, sp, #0x40
0xa044f0b0 96714ae3 movt r7, #0xa196
0xa044f0b4 0020e0e3 mvn r2, #0
0xa044f0b8 130e87e2 add r0, r7, #0x130
0xa044f0bc 2ab5fdeb bl #0xa03bc56c
0xa044f0c0 40309de5 ldr r3, [sp, #0x40]
0xa044f0c4 810353e3 cmp r3, #0x4000002
0xa044f0c8 3701000a beq #0xa044f5ac
0xa044f0cc 3d00009a bls #0xa044f1c8
0xa044f5ac 44009de5 ldr r0, [sp, #0x44]
0xa044f5b0 48108de2 add r1, sp, #0x48
0xa044f5b4 c6fcffeb bl #0xa044e8d4
0xa044f5b8 bafeffea b #0xa044f0a8
0xa0452448 0b00a0e1 mov r0, fp
0xa045244c 11a8fdeb bl #0xa03bc498
0xa0452450 10c094e5 ldr ip, [r4, #0x10]
0xa0452454 00005ce3 cmp ip, #0
0xa0452458 c400000a beq #0xa0452770
0xa045245c 04009ae5 ldr r0, [sl, #4]
0xa0452460 0510a0e1 mov r1, r5
0xa0452464 1af1ffeb bl #0xa044e8d4
0xa0452468 0900a0e1 mov r0, sb
0xa045246c 09a8fdeb bl #0xa03bc498
0xa01f845c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
0xa01f8460 2c4603e3 movw r4, #0x362c
0xa01f8464 3c414ae3 movt r4, #0xa13c
0xa01f8468 ecd04de2 sub sp, sp, #0xec
0xa01f846c 00c094e5 ldr ip, [r4]
0xa01f8470 00005ce3 cmp ip, #0
0xa01f8474 8e00000a beq #0xa01f86b4
0xa01f8478 745603e3 movw r5, #0x3674
0xa01f847c 3c514ae3 movt r5, #0xa13c
0xa01f8480 007095e5 ldr r7, [r5]
0xa01f8484 000057e3 cmp r7, #0
0xa01f8488 bc00000a beq #0xa01f8780
0xa01f848c 147603e3 movw r7, #0x3614
0xa01f8490 3c714ae3 movt r7, #0xa13c
0xa01f8494 003097e5 ldr r3, [r7]
0xa01f8498 000053e3 cmp r3, #0
0xa01f849c 3401000a beq #0xa01f8974
0xa01f84a0 246603e3 movw r6, #0x3624
0xa01f84a4 3c614ae3 movt r6, #0xa13c
0xa01f84a8 003096e5 ldr r3, [r6]
0xa01f84ac 000053e3 cmp r3, #0
0xa01f84b0 3c00000a beq #0xa01f85a8
0xa01f84b4 f69c00eb bl #0xa021f894
0xa01f84b8 000050e3 cmp r0, #0
0xa01f84bc 0700001a bne #0xa01f84e0
0xa01f84c0 904603e3 movw r4, #0x3690
0xa01f84c4 3c414ae3 movt r4, #0xa13c
0xa01f84c8 003094e5 ldr r3, [r4]
0xa01f84cc 000053e3 cmp r3, #0
0xa01f84d0 0000a013 movne r0, #0
0xa01f84d4 4e00000a beq #0xa01f8614
0xa01f84d8 ecd08de2 add sp, sp, #0xec
0xa01f84dc f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
0xa01f84e0 65daffeb bl #0xa01eee7c
0xa01f84e4 000050e3 cmp r0, #0
0xa01f84e8 f4ffff0a beq #0xa01f84c0
0xa01f84ec 8c7603e3 movw r7, #0x368c
0xa01f84f0 3c714ae3 movt r7, #0xa13c
0xa01f84f4 00c097e5 ldr ip, [r7]
0xa01f84f8 00005ce3 cmp ip, #0
0xa01f84fc 6c01000a beq #0xa01f8ab4
0xa01f8500 949603e3 movw sb, #0x3694
0xa01f8504 3c914ae3 movt sb, #0xa13c
0xa01f8508 00a099e5 ldr sl, [sb]
0xa01f850c 00005ae3 cmp sl, #0
0xa01f8510 9d01000a beq #0xa01f8b8c
0xa01f8514 7c4603e3 movw r4, #0x367c
0xa01f8518 3c414ae3 movt r4, #0xa13c
0xa01f851c 003094e5 ldr r3, [r4]
0xa01f8520 000053e3 cmp r3, #0
0xa01f8524 ff01000a beq #0xa01f8d28
0xa01f8528 848603e3 movw r8, #0x3684
0xa01f852c 3c814ae3 movt r8, #0xa13c
0xa01f8530 003098e5 ldr r3, [r8]
0xa01f8534 000053e3 cmp r3, #0
0xa01f8538 e0ffff1a bne #0xa01f84c0
0xa01f853c 400f04e3 movw r0, #0x4f40
0xa01f8540 58004ae3 movt r0, #0xa058
0xa01f8544 e8ba02eb bl #0xa02a70ec
0xa01f8548 10008de2 add r0, sp, #0x10
0xa01f854c de1908eb bl #0xa03feccc
0xa01f8550 00c097e5 ldr ip, [r7]
0xa01f8554 0130a0e3 mov r3, #1
0xa01f8558 002094e5 ldr r2, [r4]
0xa01f855c 10008de2 add r0, sp, #0x10
0xa01f8560 0810a0e1 mov r1, r8
0xa01f8564 1c308de5 str r3, [sp, #0x1c]
0xa01f8568 10c08de5 str ip, [sp, #0x10]
0xa01f856c 14208de5 str r2, [sp, #0x14]
0xa01f8570 f31908eb bl #0xa03fed44
0xa01f8574 000050e3 cmp r0, #0
0xa01f8578 d0ffff0a beq #0xa01f84c0
0xa01f857c 7c3003e3 movw r3, #0x307c
0xa01f8580 440a04e3 movw r0, #0x4a44
0xa01f8584 6f304ae3 movt r3, #0xa06f
0xa01f8588 882205e3 movw r2, #0x5288
0xa01f858c 041093e5 ldr r1, [r3, #4]
0xa01f8590 58004ae3 movt r0, #0xa058
0xa01f8594 58204ae3 movt r2, #0xa058
0xa01f8598 673200e3 movw r3, #0x267
0xa01f859c d2ba02eb bl #0xa02a70ec
0xa01f85a0 0000e0e3 mvn r0, #0
0xa01f85a4 cbffffea b #0xa01f84d8
0xa01f85a8 400f04e3 movw r0, #0x4f40
0xa01f85ac 58004ae3 movt r0, #0xa058
0xa01f85b0 cdba02eb bl #0xa02a70ec
0xa01f85b4 10008de2 add r0, sp, #0x10
0xa01f85b8 c31908eb bl #0xa03feccc
0xa01f85bc 002094e5 ldr r2, [r4]
0xa01f85c0 01c0a0e3 mov ip, #1
0xa01f85c4 003097e5 ldr r3, [r7]
0xa01f85c8 10008de2 add r0, sp, #0x10
0xa01f85cc 0610a0e1 mov r1, r6
0xa01f85d0 1cc08de5 str ip, [sp, #0x1c]
0xa01f85d4 10208de5 str r2, [sp, #0x10]
0xa01f85d8 14308de5 str r3, [sp, #0x14]
0xa01f85dc d81908eb bl #0xa03fed44
0xa01f85e0 000050e3 cmp r0, #0
0xa01f85e4 b2ffff0a beq #0xa01f84b4
0xa01f85e8 7c3003e3 movw r3, #0x307c
0xa01f85ec 440a04e3 movw r0, #0x4a44
0xa01f85f0 6f304ae3 movt r3, #0xa06f
0xa01f85f4 882205e3 movw r2, #0x5288
0xa01f85f8 041093e5 ldr r1, [r3, #4]
0xa01f85fc 58004ae3 movt r0, #0xa058
0xa01f8600 58204ae3 movt r2, #0xa058
0xa01f8604 e63100e3 movw r3, #0x1e6
0xa01f8608 b7ba02eb bl #0xa02a70ec
0xa01f860c 0000e0e3 mvn r0, #0
0xa01f8610 b0ffffea b #0xa01f84d8
0xa01f8614 10808de2 add r8, sp, #0x10
0xa01f8618 0800a0e1 mov r0, r8
0xa01f861c 261c09eb bl #0xa043f6bc
0xa01f8620 002096e5 ldr r2, [r6]
0xa01f8624 003095e5 ldr r3, [r5]
0xa01f8628 10208de5 str r2, [sp, #0x10]
0xa01f862c 20308de5 str r3, [sp, #0x20]
0xa01f8630 979c00eb bl #0xa021f894
0xa01f8634 000050e3 cmp r0, #0
0xa01f8638 e400001a bne #0xa01f89d0
0xa01f863c 0130a0e3 mov r3, #1
0xa01f8640 5030cde5 strb r3, [sp, #0x50]
0xa01f8644 cc3204e3 movw r3, #0x42cc
0xa01f8648 d8c204e3 movw ip, #0x42d8
0xa01f864c 6d304ae3 movt r3, #0xa06d
0xa01f8650 d02204e3 movw r2, #0x42d0
0xa01f8654 00e093e5 ldr lr, [r3]
0xa01f8658 901603e3 movw r1, #0x3690
0xa01f865c 8c3308e3 movw r3, #0x838c
0xa01f8660 0060a0e3 mov r6, #0
0xa01f8664 6dc04ae3 movt ip, #0xa06d
0xa01f8668 6d204ae3 movt r2, #0xa06d
0xa01f866c 1f304ae3 movt r3, #0xa01f
0xa01f8670 3c114ae3 movt r1, #0xa13c
0xa01f8674 606a4ee3 movt r6, #0xea60
0xa01f8678 0070a0e3 mov r7, #0
0xa01f867c 0800a0e1 mov r0, r8
0xa01f8680 40e08de5 str lr, [sp, #0x40]
0xa01f8684 00e08ce5 str lr, [ip]
0xa01f8688 f060c2e1 strd r6, r7, [r2]
0xa01f868c 34308de5 str r3, [sp, #0x34]
0xa01f8690 f864cde1 strd r6, r7, [sp, #0x48]
0xa01f8694 221c09eb bl #0xa043f724
0xa01f8698 000094e5 ldr r0, [r4]
0xa01f869c 961c09eb bl #0xa043f8fc
0xa01f86a0 000094e5 ldr r0, [r4]
0xa01f86a4 0010a0e3 mov r1, #0
0xa01f86a8 fb1c09eb bl #0xa043fa9c
0xa01f86ac 0000a0e3 mov r0, #0
0xa01f86b0 88ffffea b #0xa01f84d8
0xa01f86b4 306603e3 movw r6, #0x3630
0xa01f86b8 cc2108e3 movw r2, #0x81cc
0xa01f86bc 3c614ae3 movt r6, #0xa13c
0xa01f86c0 0c30a0e1 mov r3, ip
0xa01f86c4 00608de5 str r6, [sp]
0xa01f86c8 55204ae3 movt r2, #0xa055
0xa01f86cc 0200a0e3 mov r0, #2
0xa01f86d0 0510a0e3 mov r1, #5
0xa01f86d4 10c08de5 str ip, [sp, #0x10]
0xa01f86d8 14c08de5 str ip, [sp, #0x14]
0xa01f86dc 18c08de5 str ip, [sp, #0x18]
0xa01f86e0 60b100eb bl #0xa0224c68
0xa01f86e4 005050e2 subs r5, r0, #0
0xa01f86e8 a40000da ble #0xa01f8980
0xa01f86ec d03503e3 movw r3, #0x35d0
0xa01f86f0 10008de2 add r0, sp, #0x10
0xa01f86f4 3c314ae3 movt r3, #0xa13c
0xa01f86f8 0270a0e3 mov r7, #2
0xa01f86fc 005083e5 str r5, [r3]
0xa01f8700 ac3409eb bl #0xa04459b8
0xa01f8704 f40904e3 movw r0, #0x49f4
0xa01f8708 0120a0e3 mov r2, #1
0xa01f870c 013aa0e3 mov r3, #0x1000
0xa01f8710 0710a0e1 mov r1, r7
0xa01f8714 58004ae3 movt r0, #0xa058
0xa01f8718 1920cde5 strb r2, [sp, #0x19]
0xa01f871c 14308de5 str r3, [sp, #0x14]
0xa01f8720 1870cde5 strb r7, [sp, #0x18]
0xa01f8724 70ba02eb bl #0xa02a70ec
0xa01f8728 0410a0e1 mov r1, r4
0xa01f872c 10008de2 add r0, sp, #0x10
0xa01f8730 df3409eb bl #0xa0445ab4
0xa01f8734 000094e5 ldr r0, [r4]
0xa01f8738 0720a0e1 mov r2, r7
0xa01f873c 0610a0e1 mov r1, r6
0xa01f8740 003090e5 ldr r3, [r0]
0xa01f8744 003093e5 ldr r3, [r3]
0xa01f8748 33ff2fe1 blx r3
0xa01f874c 000050e3 cmp r0, #0
0xa01f8750 48ffff0a beq #0xa01f8478
0xa01f8754 7c3003e3 movw r3, #0x307c
0xa01f8758 440a04e3 movw r0, #0x4a44
0xa01f875c 6f304ae3 movt r3, #0xa06f
0xa01f8760 882205e3 movw r2, #0x5288
0xa01f8764 041093e5 ldr r1, [r3, #4]
0xa01f8768 58004ae3 movt r0, #0xa058
0xa01f876c 58204ae3 movt r2, #0xa058
0xa01f8770 823100e3 movw r3, #0x182
0xa01f8774 5cba02eb bl #0xa02a70ec
0xa01f8778 0000e0e3 mvn r0, #0
0xa01f877c 55ffffea b #0xa01f84d8
0xa01f8780 339c00eb bl #0xa021f854
0xa01f8784 ebb400eb bl #0xa0225b38
0xa01f8788 10808de2 add r8, sp, #0x10
0xa01f878c 0090a0e1 mov sb, r0
0xa01f8790 2f9c00eb bl #0xa021f854
0xa01f8794 07b500eb bl #0xa0225bb8
0xa01f8798 0710a0e1 mov r1, r7
0xa01f879c d420a0e3 mov r2, #0xd4
0xa01f87a0 00a0a0e1 mov sl, r0
0xa01f87a4 0800a0e1 mov r0, r8
0xa01f87a8 8f010cfa blx #0xa04f8dec
0xa01f87ac 300603e3 movw r0, #0x3630
0xa01f87b0 0510a0e1 mov r1, r5
0xa01f87b4 3c014ae3 movt r0, #0xa13c
0xa01f87b8 d0ad07eb bl #0xa03e3f00
0xa01f87bc 006050e2 subs r6, r0, #0
0xa01f87c0 790000ba blt #0xa01f89ac
0xa01f87c4 0800a0e1 mov r0, r8
0xa01f87c8 0160a0e3 mov r6, #1
0xa01f87cc 2f2109eb bl #0xa0440c90
0xa01f87d0 e83208e3 movw r3, #0x82e8
0xa01f87d4 881603e3 movw r1, #0x3688
0xa01f87d8 3c314ae3 movt r3, #0xa13c
0xa01f87dc 3c114ae3 movt r1, #0xa13c
0xa01f87e0 202603e3 movw r2, #0x3620
0xa01f87e4 003093e5 ldr r3, [r3]
0xa01f87e8 001091e5 ldr r1, [r1]
0xa01f87ec 3c214ae3 movt r2, #0xa13c
0xa01f87f0 002092e5 ldr r2, [r2]
0xa01f87f4 02b0a0e3 mov fp, #2
0xa01f87f8 24308de5 str r3, [sp, #0x24]
0xa01f87fc 013083e0 add r3, r3, r1
0xa01f8800 4060cde5 strb r6, [sp, #0x40]
0xa01f8804 28308de5 str r3, [sp, #0x28]
0xa01f8808 20208de5 str r2, [sp, #0x20]
0xa01f880c 10b08de5 str fp, [sp, #0x10]
0xa01f8810 103099e5 ldr r3, [sb, #0x10]
0xa01f8814 14308de5 str r3, [sp, #0x14]
0xa01f8818 0c309ae5 ldr r3, [sl, #0xc]
0xa01f881c 2c308de5 str r3, [sp, #0x2c]
0xa01f8820 0c3099e5 ldr r3, [sb, #0xc]
0xa01f8824 18308de5 str r3, [sp, #0x18]
0xa01f8828 103099e5 ldr r3, [sb, #0x10]
0xa01f882c 30308de5 str r3, [sp, #0x30]
0xa01f8830 b430d9e1 ldrh r3, [sb, #4]
0xa01f8834 b433cde1 strh r3, [sp, #0x34]
0xa01f8838 b630d9e1 ldrh r3, [sb, #6]
0xa01f883c b633cde1 strh r3, [sp, #0x36]
0xa01f8840 04309ae5 ldr r3, [sl, #4]
0xa01f8844 b833cde1 strh r3, [sp, #0x38]
0xa01f8848 08309ae5 ldr r3, [sl, #8]
0xa01f884c 3c60cde5 strb r6, [sp, #0x3c]
0xa01f8850 3d70cde5 strb r7, [sp, #0x3d]
0xa01f8854 ba33cde1 strh r3, [sp, #0x3a]
0xa01f8858 b69c00eb bl #0xa021fb38
0xa01f885c 000050e3 cmp r0, #0
0xa01f8860 e060cd15 strbne r6, [sp, #0xe0]
0xa01f8864 6700000a beq #0xa01f8a08
0xa01f8868 1c3603e3 movw r3, #0x361c
0xa01f886c 3c314ae3 movt r3, #0xa13c
0xa01f8870 001093e5 ldr r1, [r3]
0xa01f8874 000051e3 cmp r1, #0
0xa01f8878 0100000a beq #0xa01f8884
0xa01f887c 0800a0e1 mov r0, r8
0xa01f8880 90feffeb bl #0xa01f82c8
0xa01f8884 0810a0e1 mov r1, r8
0xa01f8888 000095e5 ldr r0, [r5]
0xa01f888c 102109eb bl #0xa0440cd4
0xa01f8890 006050e2 subs r6, r0, #0
0xa01f8894 7c3003e3 movw r3, #0x307c
0xa01f8898 7d0000ba blt #0xa01f8a94
0xa01f889c 6f304ae3 movt r3, #0xa06f
0xa01f88a0 300b04e3 movw r0, #0x4b30
0xa01f88a4 081093e5 ldr r1, [r3, #8]
0xa01f88a8 58004ae3 movt r0, #0xa058
0xa01f88ac 0eba02eb bl #0xa02a70ec
0xa01f88b0 680b04e3 movw r0, #0x4b68
0xa01f88b4 20109de5 ldr r1, [sp, #0x20]
0xa01f88b8 58004ae3 movt r0, #0xa058
0xa01f88bc 0aba02eb bl #0xa02a70ec
0xa01f88c0 b00b04e3 movw r0, #0x4bb0
0xa01f88c4 14109de5 ldr r1, [sp, #0x14]
0xa01f88c8 58004ae3 movt r0, #0xa058
0xa01f88cc 06ba02eb bl #0xa02a70ec
0xa01f88d0 fc0b04e3 movw r0, #0x4bfc
0xa01f88d4 18109de5 ldr r1, [sp, #0x18]
0xa01f88d8 58004ae3 movt r0, #0xa058
0xa01f88dc 02ba02eb bl #0xa02a70ec
0xa01f88e0 4c0c04e3 movw r0, #0x4c4c
0xa01f88e4 b813dde1 ldrh r1, [sp, #0x38]
0xa01f88e8 58004ae3 movt r0, #0xa058
0xa01f88ec feb902eb bl #0xa02a70ec
0xa01f88f0 9c0c04e3 movw r0, #0x4c9c
0xa01f88f4 ba13dde1 ldrh r1, [sp, #0x3a]
0xa01f88f8 58004ae3 movt r0, #0xa058
0xa01f88fc fab902eb bl #0xa02a70ec
0xa01f8900 ec0c04e3 movw r0, #0x4cec
0xa01f8904 2c109de5 ldr r1, [sp, #0x2c]
0xa01f8908 58004ae3 movt r0, #0xa058
0xa01f890c f6b902eb bl #0xa02a70ec
0xa01f8910 400d04e3 movw r0, #0x4d40
0xa01f8914 b413dde1 ldrh r1, [sp, #0x34]
0xa01f8918 58004ae3 movt r0, #0xa058
0xa01f891c f2b902eb bl #0xa02a70ec
0xa01f8920 940d04e3 movw r0, #0x4d94
0xa01f8924 b613dde1 ldrh r1, [sp, #0x36]
0xa01f8928 58004ae3 movt r0, #0xa058
0xa01f892c eeb902eb bl #0xa02a70ec
0xa01f8930 e80d04e3 movw r0, #0x4de8
0xa01f8934 30109de5 ldr r1, [sp, #0x30]
0xa01f8938 58004ae3 movt r0, #0xa058
0xa01f893c eab902eb bl #0xa02a70ec
0xa01f8940 440e04e3 movw r0, #0x4e44
0xa01f8944 44109de5 ldr r1, [sp, #0x44]
0xa01f8948 58004ae3 movt r0, #0xa058
0xa01f894c e6b902eb bl #0xa02a70ec
0xa01f8950 900e04e3 movw r0, #0x4e90
0xa01f8954 60109de5 ldr r1, [sp, #0x60]
0xa01f8958 58004ae3 movt r0, #0xa058
0xa01f895c e2b902eb bl #0xa02a70ec
0xa01f8960 e80e04e3 movw r0, #0x4ee8
0xa01f8964 6510dde5 ldrb r1, [sp, #0x65]
0xa01f8968 58004ae3 movt r0, #0xa058
0xa01f896c deb902eb bl #0xa02a70ec
0xa01f8970 c5feffea b #0xa01f848c
0xa01f8974 0700a0e1 mov r0, r7
0xa01f8978 4a2e00eb bl #0xa02042a8
0xa01f897c c7feffea b #0xa01f84a0
0xa01f8980 7c3003e3 movw r3, #0x307c
0xa01f8984 a80904e3 movw r0, #0x49a8
0xa01f8988 6f304ae3 movt r3, #0xa06f
0xa01f898c 882205e3 movw r2, #0x5288
0xa01f8990 041093e5 ldr r1, [r3, #4]
0xa01f8994 58004ae3 movt r0, #0xa058
0xa01f8998 58204ae3 movt r2, #0xa058
0xa01f899c 733100e3 movw r3, #0x173
0xa01f89a0 d1b902eb bl #0xa02a70ec
0xa01f89a4 0500a0e1 mov r0, r5
0xa01f89a8 cafeffea b #0xa01f84d8
0xa01f89ac 7c3003e3 movw r3, #0x307c
0xa01f89b0 780a04e3 movw r0, #0x4a78
0xa01f89b4 6f304ae3 movt r3, #0xa06f
0xa01f89b8 58004ae3 movt r0, #0xa058
0xa01f89bc 041093e5 ldr r1, [r3, #4]
0xa01f89c0 0620a0e1 mov r2, r6
0xa01f89c4 c8b902eb bl #0xa02a70ec
0xa01f89c8 0600a0e1 mov r0, r6
0xa01f89cc c1feffea b #0xa01f84d8
0xa01f89d0 29d9ffeb bl #0xa01eee7c
0xa01f89d4 000050e3 cmp r0, #0
0xa01f89d8 17ffff0a beq #0xa01f863c
0xa01f89dc 842603e3 movw r2, #0x3684
0xa01f89e0 943603e3 movw r3, #0x3694
0xa01f89e4 3c214ae3 movt r2, #0xa13c
0xa01f89e8 3c314ae3 movt r3, #0xa13c
0xa01f89ec 002092e5 ldr r2, [r2]
0xa01f89f0 0210a0e3 mov r1, #2
0xa01f89f4 003093e5 ldr r3, [r3]
0xa01f89f8 5010cde5 strb r1, [sp, #0x50]
0xa01f89fc 14208de5 str r2, [sp, #0x14]
0xa01f8a00 24308de5 str r3, [sp, #0x24]
0xa01f8a04 0effffea b #0xa01f8644
0xa01f8a08 442c07e3 movw r2, #0x7c44
0xa01f8a0c 703603e3 movw r3, #0x3670
0xa01f8a10 3c214ae3 movt r2, #0xa13c
0xa01f8a14 3c314ae3 movt r3, #0xa13c
0xa01f8a18 002092e5 ldr r2, [r2]
0xa01f8a1c 003093e5 ldr r3, [r3]
0xa01f8a20 e0b0cde5 strb fp, [sp, #0xe0]
0xa01f8a24 0a1682e2 add r1, r2, #0xa00000
0xa01f8a28 74b0cde5 strb fp, [sp, #0x74]
0xa01f8a2c 54308de5 str r3, [sp, #0x54]
0xa01f8a30 58208de5 str r2, [sp, #0x58]
0xa01f8a34 5c108de5 str r1, [sp, #0x5c]
0xa01f8a38 095d00eb bl #0xa020fe64
0xa01f8a3c 060050e1 cmp r0, r6
0xa01f8a40 2130a003 moveq r3, #0x21
0xa01f8a44 44308d05 streq r3, [sp, #0x44]
0xa01f8a48 0300000a beq #0xa01f8a5c
0xa01f8a4c 045d00eb bl #0xa020fe64
0xa01f8a50 000050e3 cmp r0, #0
0xa01f8a54 2230a003 moveq r3, #0x22
0xa01f8a58 44308d05 streq r3, [sp, #0x44]
0xa01f8a5c 14309de5 ldr r3, [sp, #0x14]
0xa01f8a60 48308de5 str r3, [sp, #0x48]
0xa01f8a64 025d00eb bl #0xa020fe74
0xa01f8a68 48109de5 ldr r1, [sp, #0x48]
0xa01f8a6c 0020a0e1 mov r2, r0
0xa01f8a70 0030a0e3 mov r3, #0
0xa01f8a74 60008de5 str r0, [sp, #0x60]
0xa01f8a78 0105a0e1 lsl r0, r1, #0xa
0xa01f8a7c 211ba0e1 lsr r1, r1, #0x16
0xa01f8a80 2c390cfa blx #0xa0506f38
0xa01f8a84 4c008de5 str r0, [sp, #0x4c]
0xa01f8a88 035d00eb bl #0xa020fe9c
0xa01f8a8c 6500cde5 strb r0, [sp, #0x65]
0xa01f8a90 74ffffea b #0xa01f8868
0xa01f8a94 6f304ae3 movt r3, #0xa06f
0xa01f8a98 d40a04e3 movw r0, #0x4ad4
0xa01f8a9c 58004ae3 movt r0, #0xa058
0xa01f8aa0 041093e5 ldr r1, [r3, #4]
0xa01f8aa4 0620a0e1 mov r2, r6
0xa01f8aa8 8fb902eb bl #0xa02a70ec
0xa01f8aac 0600a0e1 mov r0, r6
0xa01f8ab0 88feffea b #0xa01f84d8
0xa01f8ab4 d08503e3 movw r8, #0x35d0
0xa01f8ab8 d49503e3 movw sb, #0x35d4
0xa01f8abc 3c814ae3 movt r8, #0xa13c
0xa01f8ac0 3c914ae3 movt sb, #0xa13c
0xa01f8ac4 cc2108e3 movw r2, #0x81cc
0xa01f8ac8 001098e5 ldr r1, [r8]
0xa01f8acc 55204ae3 movt r2, #0xa055
0xa01f8ad0 00c08de5 str ip, [sp]
0xa01f8ad4 04c08de5 str ip, [sp, #4]
0xa01f8ad8 0200a0e3 mov r0, #2
0xa01f8adc 08908de5 str sb, [sp, #8]
0xa01f8ae0 0130a0e3 mov r3, #1
0xa01f8ae4 10c08de5 str ip, [sp, #0x10]
0xa01f8ae8 14c08de5 str ip, [sp, #0x14]
0xa01f8aec 18c08de5 str ip, [sp, #0x18]
0xa01f8af0 f3b000eb bl #0xa0224ec4
0xa01f8af4 004050e2 subs r4, r0, #0
0xa01f8af8 8d0000ba blt #0xa01f8d34
0xa01f8afc 002098e5 ldr r2, [r8]
0xa01f8b00 803603e3 movw r3, #0x3680
0xa01f8b04 3c314ae3 movt r3, #0xa13c
0xa01f8b08 10008de2 add r0, sp, #0x10
0xa01f8b0c 0280a0e3 mov r8, #2
0xa01f8b10 002083e5 str r2, [r3]
0xa01f8b14 a73309eb bl #0xa04459b8
0xa01f8b18 0120a0e3 mov r2, #1
0xa01f8b1c 013aa0e3 mov r3, #0x1000
0xa01f8b20 10008de2 add r0, sp, #0x10
0xa01f8b24 0710a0e1 mov r1, r7
0xa01f8b28 1920cde5 strb r2, [sp, #0x19]
0xa01f8b2c 14308de5 str r3, [sp, #0x14]
0xa01f8b30 1880cde5 strb r8, [sp, #0x18]
0xa01f8b34 de3309eb bl #0xa0445ab4
0xa01f8b38 004050e2 subs r4, r0, #0
0xa01f8b3c b60000ba blt #0xa01f8e1c
0xa01f8b40 000097e5 ldr r0, [r7]
0xa01f8b44 0910a0e1 mov r1, sb
0xa01f8b48 0820a0e1 mov r2, r8
0xa01f8b4c 003090e5 ldr r3, [r0]
0xa01f8b50 003093e5 ldr r3, [r3]
0xa01f8b54 33ff2fe1 blx r3
0xa01f8b58 000050e3 cmp r0, #0
0xa01f8b5c 67feff0a beq #0xa01f8500
0xa01f8b60 7c3003e3 movw r3, #0x307c
0xa01f8b64 440a04e3 movw r0, #0x4a44
0xa01f8b68 6f304ae3 movt r3, #0xa06f
0xa01f8b6c 882205e3 movw r2, #0x5288
0xa01f8b70 041093e5 ldr r1, [r3, #4]
0xa01f8b74 58004ae3 movt r0, #0xa058
0xa01f8b78 58204ae3 movt r2, #0xa058
0xa01f8b7c 813fa0e3 mov r3, #0x204
0xa01f8b80 59b902eb bl #0xa02a70ec
0xa01f8b84 0000e0e3 mvn r0, #0
0xa01f8b88 52feffea b #0xa01f84d8
0xa01f8b8c 10808de2 add r8, sp, #0x10
0xa01f8b90 0a10a0e1 mov r1, sl
0xa01f8b94 d420a0e3 mov r2, #0xd4
0xa01f8b98 0800a0e1 mov r0, r8
0xa01f8b9c 92000cfa blx #0xa04f8dec
0xa01f8ba0 d40503e3 movw r0, #0x35d4
0xa01f8ba4 0910a0e1 mov r1, sb
0xa01f8ba8 3c014ae3 movt r0, #0xa13c
0xa01f8bac d3ac07eb bl #0xa03e3f00
0xa01f8bb0 004050e2 subs r4, r0, #0
0xa01f8bb4 690000ba blt #0xa01f8d60
0xa01f8bb8 0800a0e1 mov r0, r8
0xa01f8bbc 0140a0e3 mov r4, #1
0xa01f8bc0 322009eb bl #0xa0440c90
0xa01f8bc4 e83208e3 movw r3, #0x82e8
0xa01f8bc8 881603e3 movw r1, #0x3688
0xa01f8bcc 3c314ae3 movt r3, #0xa13c
0xa01f8bd0 3c114ae3 movt r1, #0xa13c
0xa01f8bd4 182603e3 movw r2, #0x3618
0xa01f8bd8 001091e5 ldr r1, [r1]
0xa01f8bdc 003093e5 ldr r3, [r3]
0xa01f8be0 3c214ae3 movt r2, #0xa13c
0xa01f8be4 002092e5 ldr r2, [r2]
0xa01f8be8 02b0a0e3 mov fp, #2
0xa01f8bec 4040cde5 strb r4, [sp, #0x40]
0xa01f8bf0 24308de5 str r3, [sp, #0x24]
0xa01f8bf4 013083e0 add r3, r3, r1
0xa01f8bf8 20208de5 str r2, [sp, #0x20]
0xa01f8bfc 28308de5 str r3, [sp, #0x28]
0xa01f8c00 10b08de5 str fp, [sp, #0x10]
0xa01f8c04 d79b00eb bl #0xa021fb68
0xa01f8c08 14008de5 str r0, [sp, #0x14]
0xa01f8c0c d99b00eb bl #0xa021fb78
0xa01f8c10 3da0cde5 strb sl, [sp, #0x3d]
0xa01f8c14 18008de5 str r0, [sp, #0x18]
0xa01f8c18 da9b00eb bl #0xa021fb88
0xa01f8c1c b803cde1 strh r0, [sp, #0x38]
0xa01f8c20 dc9b00eb bl #0xa021fb98
0xa01f8c24 ba03cde1 strh r0, [sp, #0x3a]
0xa01f8c28 de9b00eb bl #0xa021fba8
0xa01f8c2c 14309de5 ldr r3, [sp, #0x14]
0xa01f8c30 2c008de5 str r0, [sp, #0x2c]
0xa01f8c34 30308de5 str r3, [sp, #0x30]
0xa01f8c38 c29b00eb bl #0xa021fb48
0xa01f8c3c b403cde1 strh r0, [sp, #0x34]
0xa01f8c40 c49b00eb bl #0xa021fb58
0xa01f8c44 3c40cde5 strb r4, [sp, #0x3c]
0xa01f8c48 b603cde1 strh r0, [sp, #0x36]
0xa01f8c4c b99b00eb bl #0xa021fb38
0xa01f8c50 000050e3 cmp r0, #0
0xa01f8c54 e040cd15 strbne r4, [sp, #0xe0]
0xa01f8c58 4900000a beq #0xa01f8d84
0xa01f8c5c 283603e3 movw r3, #0x3628
0xa01f8c60 3c314ae3 movt r3, #0xa13c
0xa01f8c64 001093e5 ldr r1, [r3]
0xa01f8c68 000051e3 cmp r1, #0
0xa01f8c6c 0100000a beq #0xa01f8c78
0xa01f8c70 0800a0e1 mov r0, r8
0xa01f8c74 93fdffeb bl #0xa01f82c8
0xa01f8c78 000099e5 ldr r0, [sb]
0xa01f8c7c 0810a0e1 mov r1, r8
0xa01f8c80 132009eb bl #0xa0440cd4
0xa01f8c84 004050e2 subs r4, r0, #0
0xa01f8c88 7c3003e3 movw r3, #0x307c
0xa01f8c8c 6d0000ba blt #0xa01f8e48
0xa01f8c90 6f304ae3 movt r3, #0xa06f
0xa01f8c94 240103e3 movw r0, #0x3124
0xa01f8c98 081093e5 ldr r1, [r3, #8]
0xa01f8c9c 58004ae3 movt r0, #0xa058
0xa01f8ca0 11b902eb bl #0xa02a70ec
0xa01f8ca4 680b04e3 movw r0, #0x4b68
0xa01f8ca8 20109de5 ldr r1, [sp, #0x20]
0xa01f8cac 58004ae3 movt r0, #0xa058
0xa01f8cb0 0db902eb bl #0xa02a70ec
0xa01f8cb4 cc0f04e3 movw r0, #0x4fcc
0xa01f8cb8 14109de5 ldr r1, [sp, #0x14]
0xa01f8cbc 58004ae3 movt r0, #0xa058
0xa01f8cc0 09b902eb bl #0xa02a70ec
0xa01f8cc4 240005e3 movw r0, #0x5024
0xa01f8cc8 18109de5 ldr r1, [sp, #0x18]
0xa01f8ccc 58004ae3 movt r0, #0xa058
0xa01f8cd0 05b902eb bl #0xa02a70ec
0xa01f8cd4 4c0c04e3 movw r0, #0x4c4c
0xa01f8cd8 b813dde1 ldrh r1, [sp, #0x38]
0xa01f8cdc 58004ae3 movt r0, #0xa058
0xa01f8ce0 01b902eb bl #0xa02a70ec
0xa01f8ce4 9c0c04e3 movw r0, #0x4c9c
0xa01f8ce8 ba13dde1 ldrh r1, [sp, #0x3a]
0xa01f8cec 58004ae3 movt r0, #0xa058
0xa01f8cf0 fdb802eb bl #0xa02a70ec
0xa01f8cf4 ec0c04e3 movw r0, #0x4cec
0xa01f8cf8 2c109de5 ldr r1, [sp, #0x2c]
0xa01f8cfc 58004ae3 movt r0, #0xa058
0xa01f8d00 f9b802eb bl #0xa02a70ec
0xa01f8d04 400d04e3 movw r0, #0x4d40
0xa01f8d08 b413dde1 ldrh r1, [sp, #0x34]
0xa01f8d0c 58004ae3 movt r0, #0xa058
0xa01f8d10 f5b802eb bl #0xa02a70ec
0xa01f8d14 940d04e3 movw r0, #0x4d94
0xa01f8d18 b613dde1 ldrh r1, [sp, #0x36]
0xa01f8d1c 58004ae3 movt r0, #0xa058
0xa01f8d20 f1b802eb bl #0xa02a70ec
0xa01f8d24 fafdffea b #0xa01f8514
0xa01f8d28 0400a0e1 mov r0, r4
0xa01f8d2c 5d2d00eb bl #0xa02042a8
0xa01f8d30 fcfdffea b #0xa01f8528
0xa01f8d34 7c3003e3 movw r3, #0x307c
0xa01f8d38 a80904e3 movw r0, #0x49a8
0xa01f8d3c 6f304ae3 movt r3, #0xa06f
0xa01f8d40 882205e3 movw r2, #0x5288
0xa01f8d44 041093e5 ldr r1, [r3, #4]
0xa01f8d48 58004ae3 movt r0, #0xa058
0xa01f8d4c 58204ae3 movt r2, #0xa058
0xa01f8d50 7d3fa0e3 mov r3, #0x1f4
0xa01f8d54 e4b802eb bl #0xa02a70ec
0xa01f8d58 0400a0e1 mov r0, r4
0xa01f8d5c ddfdffea b #0xa01f84d8
0xa01f8d60 7c3003e3 movw r3, #0x307c
0xa01f8d64 780a04e3 movw r0, #0x4a78
0xa01f8d68 6f304ae3 movt r3, #0xa06f
0xa01f8d6c 58004ae3 movt r0, #0xa058
0xa01f8d70 041093e5 ldr r1, [r3, #4]
0xa01f8d74 0420a0e1 mov r2, r4
0xa01f8d78 dbb802eb bl #0xa02a70ec
0xa01f8d7c 0400a0e1 mov r0, r4
0xa01f8d80 d4fdffea b #0xa01f84d8
0xa01f8d84 783603e3 movw r3, #0x3678
0xa01f8d88 e0b0cde5 strb fp, [sp, #0xe0]
0xa01f8d8c 3c314ae3 movt r3, #0xa13c
0xa01f8d90 74b0cde5 strb fp, [sp, #0x74]
0xa01f8d94 003093e5 ldr r3, [r3]
0xa01f8d98 54308de5 str r3, [sp, #0x54]
0xa01f8d9c 525c00eb bl #0xa020feec
0xa01f8da0 000050e3 cmp r0, #0
0xa01f8da4 343c0713 movwne r3, #0x7c34
0xa01f8da8 443c0703 movweq r3, #0x7c44
0xa01f8dac 3c314a13 movtne r3, #0xa13c
0xa01f8db0 3c314a03 movteq r3, #0xa13c
0xa01f8db4 003093e5 ldr r3, [r3]
0xa01f8db8 0a2683e2 add r2, r3, #0xa00000
0xa01f8dbc 58308de5 str r3, [sp, #0x58]
0xa01f8dc0 5c208de5 str r2, [sp, #0x5c]
0xa01f8dc4 265c00eb bl #0xa020fe64
0xa01f8dc8 010050e3 cmp r0, #1
0xa01f8dcc 2130a003 moveq r3, #0x21
0xa01f8dd0 44308d05 streq r3, [sp, #0x44]
0xa01f8dd4 0300000a beq #0xa01f8de8
0xa01f8dd8 215c00eb bl #0xa020fe64
0xa01f8ddc 000050e3 cmp r0, #0
0xa01f8de0 2230a003 moveq r3, #0x22
0xa01f8de4 44308d05 streq r3, [sp, #0x44]
0xa01f8de8 215c00eb bl #0xa020fe74
0xa01f8dec 14109de5 ldr r1, [sp, #0x14]
0xa01f8df0 0020a0e1 mov r2, r0
0xa01f8df4 0030a0e3 mov r3, #0
0xa01f8df8 60008de5 str r0, [sp, #0x60]
0xa01f8dfc 48108de5 str r1, [sp, #0x48]
0xa01f8e00 0105a0e1 lsl r0, r1, #0xa
0xa01f8e04 211ba0e1 lsr r1, r1, #0x16
0xa01f8e08 4a380cfa blx #0xa0506f38
0xa01f8e0c 4c008de5 str r0, [sp, #0x4c]
0xa01f8e10 215c00eb bl #0xa020fe9c
0xa01f8e14 6500cde5 strb r0, [sp, #0x65]
0xa01f8e18 8fffffea b #0xa01f8c5c
0xa01f8e1c 7c3003e3 movw r3, #0x307c
0xa01f8e20 7c0f04e3 movw r0, #0x4f7c
0xa01f8e24 6f304ae3 movt r3, #0xa06f
0xa01f8e28 882205e3 movw r2, #0x5288
0xa01f8e2c 041093e5 ldr r1, [r3, #4]
0xa01f8e30 58004ae3 movt r0, #0xa058
0xa01f8e34 58204ae3 movt r2, #0xa058
0xa01f8e38 023ca0e3 mov r3, #0x200
0xa01f8e3c aab802eb bl #0xa02a70ec
0xa01f8e40 0400a0e1 mov r0, r4
0xa01f8e44 a3fdffea b #0xa01f84d8
0xa01f8e48 6f304ae3 movt r3, #0xa06f
0xa01f8e4c d40a04e3 movw r0, #0x4ad4
0xa01f8e50 58004ae3 movt r0, #0xa058
0xa01f8e54 041093e5 ldr r1, [r3, #4]
0xa01f8e58 0420a0e1 mov r2, r4
0xa01f8e5c a2b802eb bl #0xa02a70ec
0xa01f8e60 0400a0e1 mov r0, r4
0xa01f8e64 9bfdffea b #0xa01f84d8
0xa01f8e68 cc3503e3 movw r3, #0x35cc
0xa01f8e6c 3c314ae3 movt r3, #0xa13c
0xa01f8e70 000093e5 ldr r0, [r3]
0xa01f8e74 000050e3 cmp r0, #0
0xa01f8e78 1eff2f01 bxeq lr
0xa01f8e7c 76fdffea b #0xa01f845c
0xa01f8f08 70402de9 push {r4, r5, r6, lr}
0xa01f8f0c d00005e3 movw r0, #0x50d0
0xa01f8f10 ac1205e3 movw r1, #0x52ac
0xa01f8f14 904603e3 movw r4, #0x3690
0xa01f8f18 58104ae3 movt r1, #0xa058
0xa01f8f1c 3c414ae3 movt r4, #0xa13c
0xa01f8f20 58004ae3 movt r0, #0xa058
0xa01f8f24 70b802eb bl #0xa02a70ec
0xa01f8f28 0010e0e3 mvn r1, #0
0xa01f8f2c 000094e5 ldr r0, [r4]
0xa01f8f30 e21b09eb bl #0xa043fec0
0xa01f8f34 0010a0e1 mov r1, r0
0xa01f8f38 0c0105e3 movw r0, #0x510c
0xa01f8f3c 58004ae3 movt r0, #0xa058
0xa01f8f40 69b802eb bl #0xa02a70ec
0xa01f8f44 540105e3 movw r0, #0x5154
0xa01f8f48 ac1205e3 movw r1, #0x52ac
0xa01f8f4c 58104ae3 movt r1, #0xa058
0xa01f8f50 58004ae3 movt r0, #0xa058
0xa01f8f54 64b802eb bl #0xa02a70ec
0xa01f8f58 d7ffffeb bl #0xa01f8ebc
0xa01f8f5c 000094e5 ldr r0, [r4]
0xa01f8f60 000050e3 cmp r0, #0
0xa01f8f64 0400000a beq #0xa01f8f7c
0xa01f8f68 971a09eb bl #0xa043f9cc
0xa01f8f6c 000094e5 ldr r0, [r4]
0xa01f8f70 2d1a09eb bl #0xa043f82c
0xa01f8f74 0030a0e3 mov r3, #0
0xa01f8f78 003084e5 str r3, [r4]
0xa01f8f7c 244603e3 movw r4, #0x3624
0xa01f8f80 3c414ae3 movt r4, #0xa13c
0xa01f8f84 000094e5 ldr r0, [r4]
0xa01f8f88 000050e3 cmp r0, #0
0xa01f8f8c 0200000a beq #0xa01f8f9c
0xa01f8f90 a21708eb bl #0xa03fee20
0xa01f8f94 002050e2 subs r2, r0, #0
0xa01f8f98 7a0000ba blt #0xa01f9188
0xa01f8f9c 145603e3 movw r5, #0x3614
0xa01f8fa0 3c514ae3 movt r5, #0xa13c
0xa01f8fa4 000095e5 ldr r0, [r5]
0xa01f8fa8 000050e3 cmp r0, #0
0xa01f8fac 0200000a beq #0xa01f8fbc
0xa01f8fb0 172d00eb bl #0xa0204414
0xa01f8fb4 0030a0e3 mov r3, #0
0xa01f8fb8 003085e5 str r3, [r5]
0xa01f8fbc 205603e3 movw r5, #0x3620
0xa01f8fc0 0060a0e3 mov r6, #0
0xa01f8fc4 3c514ae3 movt r5, #0xa13c
0xa01f8fc8 006084e5 str r6, [r4]
0xa01f8fcc 000095e5 ldr r0, [r5]
0xa01f8fd0 060050e1 cmp r0, r6
0xa01f8fd4 0100000a beq #0xa01f8fe0
0xa01f8fd8 416109eb bl #0xa04514e4
0xa01f8fdc 006085e5 str r6, [r5]
0xa01f8fe0 184603e3 movw r4, #0x3618
0xa01f8fe4 3c414ae3 movt r4, #0xa13c
0xa01f8fe8 000094e5 ldr r0, [r4]
0xa01f8fec 000050e3 cmp r0, #0
0xa01f8ff0 0200000a beq #0xa01f9000
0xa01f8ff4 3a6109eb bl #0xa04514e4
0xa01f8ff8 0030a0e3 mov r3, #0
0xa01f8ffc 003084e5 str r3, [r4]
0xa01f9000 704603e3 movw r4, #0x3670
0xa01f9004 3c414ae3 movt r4, #0xa13c
0xa01f9008 000094e5 ldr r0, [r4]
0xa01f900c 000050e3 cmp r0, #0
0xa01f9010 0200000a beq #0xa01f9020
0xa01f9014 326109eb bl #0xa04514e4
0xa01f9018 0030a0e3 mov r3, #0
0xa01f901c 003084e5 str r3, [r4]
0xa01f9020 784603e3 movw r4, #0x3678
0xa01f9024 3c414ae3 movt r4, #0xa13c
0xa01f9028 000094e5 ldr r0, [r4]
0xa01f902c 000050e3 cmp r0, #0
0xa01f9030 0200000a beq #0xa01f9040
0xa01f9034 2a6109eb bl #0xa04514e4
0xa01f9038 0030a0e3 mov r3, #0
0xa01f903c 003084e5 str r3, [r4]
0xa01f9040 2c4603e3 movw r4, #0x362c
0xa01f9044 3c414ae3 movt r4, #0xa13c
0xa01f9048 000094e5 ldr r0, [r4]
0xa01f904c 000050e3 cmp r0, #0
0xa01f9050 0600000a beq #0xa01f9070
0xa01f9054 003090e5 ldr r3, [r0]
0xa01f9058 043093e5 ldr r3, [r3, #4]
0xa01f905c 33ff2fe1 blx r3
0xa01f9060 000094e5 ldr r0, [r4]
0xa01f9064 bd3209eb bl #0xa0445b60
0xa01f9068 0030a0e3 mov r3, #0
0xa01f906c 003084e5 str r3, [r4]
0xa01f9070 744603e3 movw r4, #0x3674
0xa01f9074 3c414ae3 movt r4, #0xa13c
0xa01f9078 000094e5 ldr r0, [r4]
0xa01f907c 000050e3 cmp r0, #0
0xa01f9080 0300000a beq #0xa01f9094
0xa01f9084 0110a0e3 mov r1, #1
0xa01f9088 0eac07eb bl #0xa03e40c8
0xa01f908c 0030a0e3 mov r3, #0
0xa01f9090 003084e5 str r3, [r4]
0xa01f9094 845603e3 movw r5, #0x3684
0xa01f9098 3c514ae3 movt r5, #0xa13c
0xa01f909c 000095e5 ldr r0, [r5]
0xa01f90a0 000050e3 cmp r0, #0
0xa01f90a4 0200000a beq #0xa01f90b4
0xa01f90a8 5c1708eb bl #0xa03fee20
0xa01f90ac 002050e2 subs r2, r0, #0
0xa01f90b0 3b0000ba blt #0xa01f91a4
0xa01f90b4 7c4603e3 movw r4, #0x367c
0xa01f90b8 3c414ae3 movt r4, #0xa13c
0xa01f90bc 000094e5 ldr r0, [r4]
0xa01f90c0 000050e3 cmp r0, #0
0xa01f90c4 0200000a beq #0xa01f90d4
0xa01f90c8 d12c00eb bl #0xa0204414
0xa01f90cc 0030a0e3 mov r3, #0
0xa01f90d0 003084e5 str r3, [r4]
0xa01f90d4 8c4603e3 movw r4, #0x368c
0xa01f90d8 0060a0e3 mov r6, #0
0xa01f90dc 3c414ae3 movt r4, #0xa13c
0xa01f90e0 006085e5 str r6, [r5]
0xa01f90e4 000094e5 ldr r0, [r4]
0xa01f90e8 060050e1 cmp r0, r6
0xa01f90ec 0500000a beq #0xa01f9108
0xa01f90f0 003090e5 ldr r3, [r0]
0xa01f90f4 043093e5 ldr r3, [r3, #4]
0xa01f90f8 33ff2fe1 blx r3
0xa01f90fc 000094e5 ldr r0, [r4]
0xa01f9100 963209eb bl #0xa0445b60
0xa01f9104 006084e5 str r6, [r4]
0xa01f9108 944603e3 movw r4, #0x3694
0xa01f910c 3c414ae3 movt r4, #0xa13c
0xa01f9110 000094e5 ldr r0, [r4]
0xa01f9114 000050e3 cmp r0, #0
0xa01f9118 0300000a beq #0xa01f912c
0xa01f911c 0110a0e3 mov r1, #1
0xa01f9120 e8ab07eb bl #0xa03e40c8
0xa01f9124 0030a0e3 mov r3, #0
0xa01f9128 003084e5 str r3, [r4]
0xa01f912c 1c4603e3 movw r4, #0x361c
0xa01f9130 3c414ae3 movt r4, #0xa13c
0xa01f9134 000094e5 ldr r0, [r4]
0xa01f9138 000050e3 cmp r0, #0
0xa01f913c 0200000a beq #0xa01f914c
0xa01f9140 e76009eb bl #0xa04514e4
0xa01f9144 0030a0e3 mov r3, #0
0xa01f9148 003084e5 str r3, [r4]
0xa01f914c 284603e3 movw r4, #0x3628
0xa01f9150 3c414ae3 movt r4, #0xa13c
0xa01f9154 000094e5 ldr r0, [r4]
0xa01f9158 000050e3 cmp r0, #0
0xa01f915c 0200000a beq #0xa01f916c
0xa01f9160 df6009eb bl #0xa04514e4
0xa01f9164 0030a0e3 mov r3, #0
0xa01f9168 003084e5 str r3, [r4]
0xa01f916c e00105e3 movw r0, #0x51e0
0xa01f9170 ac1205e3 movw r1, #0x52ac
0xa01f9174 58104ae3 movt r1, #0xa058
0xa01f9178 58004ae3 movt r0, #0xa058
0xa01f917c dab702eb bl #0xa02a70ec
0xa01f9180 0000a0e3 mov r0, #0
0xa01f9184 7080bde8 pop {r4, r5, r6, pc}
0xa01f9188 7c3003e3 movw r3, #0x307c
0xa01f918c 880105e3 movw r0, #0x5188
0xa01f9190 6f304ae3 movt r3, #0xa06f
0xa01f9194 58004ae3 movt r0, #0xa058
0xa01f9198 041093e5 ldr r1, [r3, #4]
0xa01f919c d2b702eb bl #0xa02a70ec
0xa01f91a0 7dffffea b #0xa01f8f9c
0xa01f91a4 7c3003e3 movw r3, #0x307c
0xa01f91a8 880105e3 movw r0, #0x5188
0xa01f91ac 6f304ae3 movt r3, #0xa06f
0xa01f91b0 58004ae3 movt r0, #0xa058
0xa01f91b4 041093e5 ldr r1, [r3, #4]
0xa01f91b8 cbb702eb bl #0xa02a70ec
0xa01f91bc bcffffea b #0xa01f90b4
