a04a3754 f0412de9 push {r4, r5, r6, r7, r8, lr}
a04a3758 0220a0e3 mov r2, #2
a04a375c 0c30d1e5 ldrb r3, [r1, #0xc]
a04a3760 0080a0e3 mov r8, #0
a04a3764 1280c1e7 bfi r8, r2, #0, #2
a04a3768 bc20d1e1 ldrh r2, [r1, #0xc]
a04a376c 5341e0e7 ubfx r4, r3, #2, #1
a04a3770 0dc0d1e5 ldrb ip, [r1, #0xd]
a04a3774 d3e1e0e7 ubfx lr, r3, #3, #1
a04a3778 1481c2e7 bfi r8, r4, #2, #1
a04a377c 005091e5 ldr r5, [r1]
a04a3780 5332e0e7 ubfx r3, r3, #4, #1
a04a3784 087091e5 ldr r7, [r1, #8]
a04a3788 9e81c3e7 bfi r8, lr, #3, #1
a04a378c d222e3e7 ubfx r2, r2, #5, #4
a04a3790 1382c4e7 bfi r8, r3, #4, #1
a04a3794 9282c8e7 bfi r8, r2, #5, #4
a04a3798 dc30e2e7 ubfx r3, ip, #1, #3
a04a379c 077085e0 add r7, r5, r7
a04a37a0 4321a0e1 asr r2, r3, #2
a04a37a4 1385cbe7 bfi r8, r3, #0xa, #2
a04a37a8 0e30d1e5 ldrb r3, [r1, #0xe]
a04a37ac 5cc2e2e7 ubfx ip, ip, #4, #3
a04a37b0 017047e2 sub r7, r7, #1
a04a37b4 255aa0e1 lsr r5, r5, #0x14
a04a37b8 1c86cee7 bfi r8, ip, #0xc, #3
a04a37bc 277aa0e1 lsr r7, r7, #0x14
a04a37c0 044091e5 ldr r4, [r1, #4]
a04a37c4 9287cfe7 bfi r8, r2, #0xf, #1
a04a37c8 050180e0 add r0, r0, r5, lsl #2
a04a37cc d320e0e7 ubfx r2, r3, #1, #1
a04a37d0 1388d0e7 bfi r8, r3, #0x10, #1
a04a37d4 070055e1 cmp r5, r7
a04a37d8 9288d1e7 bfi r8, r2, #0x11, #1
a04a37dc d331e0e7 ubfx r3, r3, #3, #1
a04a37e0 9389d3e7 bfi r8, r3, #0x13, #1
a04a37e4 244aa0e1 lsr r4, r4, #0x14
a04a37e8 0d00008a bhi #0xa04a3824
a04a37ec 0060a0e1 mov r6, r0
a04a37f0 2828a0e1 lsr r2, r8, #0x10
a04a37f4 0630a0e1 mov r3, r6
a04a37f8 015085e2 add r5, r5, #1
a04a37fc 048086e4 str r8, [r6], #4
a04a3800 1422cfe7 bfi r2, r4, #4, #0xc
a04a3804 0300a0e1 mov r0, r3
a04a3808 b220c3e1 strh r2, [r3, #2]
a04a380c 0410a0e3 mov r1, #4
a04a3810 54fbffeb bl #0xa04a2568
a04a3814 050057e1 cmp r7, r5
a04a3818 014084e2 add r4, r4, #1
a04a381c 5440ebe7 ubfx r4, r4, #0, #0xc
a04a3820 f2ffff2a bhs #0xa04a37f0
a04a3824 0000a0e3 mov r0, #0
a04a3828 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a04a382c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04a3830 0080a0e3 mov r8, #0
a04a3834 0d60d1e5 ldrb r6, [r1, #0xd]
a04a3838 2cd04de2 sub sp, sp, #0x2c
a04a383c 0120a0e3 mov r2, #1
a04a3840 00e091e5 ldr lr, [r1]
a04a3844 d650e2e7 ubfx r5, r6, #1, #3
a04a3848 08c091e5 ldr ip, [r1, #8]
a04a384c 4531a0e1 asr r3, r5, #2
a04a3850 0e90d1e5 ldrb sb, [r1, #0xe]
a04a3854 0c40d1e5 ldrb r4, [r1, #0xc]
a04a3858 5662e2e7 ubfx r6, r6, #4, #3
a04a385c 8330a0e1 lsl r3, r3, #1
a04a3860 0cc08ee0 add ip, lr, ip
a04a3864 2eaaa0e1 lsr sl, lr, #0x14
a04a3868 d970e0e7 ubfx r7, sb, #1, #1
a04a386c 1931c2e7 bfi r3, sb, #2, #1
a04a3870 24808de5 str r8, [sp, #0x24]
a04a3874 01c04ce2 sub ip, ip, #1
a04a3878 5481e0e7 ubfx r8, r4, #2, #1
a04a387c 9731c3e7 bfi r3, r7, #3, #1
a04a3880 2c7aa0e1 lsr r7, ip, #0x14
a04a3884 0ab0a0e1 mov fp, sl
a04a3888 04a08de5 str sl, [sp, #4]
a04a388c 1821c2e7 bfi r2, r8, #2, #1
a04a3890 d481e0e7 ubfx r8, r4, #3, #1
a04a3894 1632c6e7 bfi r3, r6, #4, #3
a04a3898 9821c3e7 bfi r2, r8, #3, #1
a04a389c 5442e0e7 ubfx r4, r4, #4, #1
a04a38a0 07005be1 cmp fp, r7
a04a38a4 9433c7e7 bfi r3, r4, #7, #1
a04a38a8 1522c5e7 bfi r2, r5, #4, #2
a04a38ac b6a0d1e1 ldrh sl, [r1, #6]
a04a38b0 2530cde5 strb r3, [sp, #0x25]
a04a38b4 2420cde5 strb r2, [sp, #0x24]
a04a38b8 6700008a bhi #0xa04a3a5c
a04a38bc 0b31d0e7 ldrb r3, [r0, fp, lsl #2]
a04a38c0 0b61a0e1 lsl r6, fp, #2
a04a38c4 0b80a0e1 mov r8, fp
a04a38c8 064080e0 add r4, r0, r6
a04a38cc 033003e2 and r3, r3, #3
a04a38d0 020053e3 cmp r3, #2
a04a38d4 6000000a beq #0xa04a3a5c
a04a38d8 04200fe3 movw r2, #0xf004
a04a38dc 0090a0e1 mov sb, r0
a04a38e0 3f2040e3 movt r2, #0x3f
a04a38e4 5e08e3e7 ubfx r0, lr, #0x10, #4
a04a38e8 02208be0 add r2, fp, r2
a04a38ec 00e0a0e1 mov lr, r0
a04a38f0 0225a0e1 lsl r2, r2, #0xa
a04a38f4 10008de5 str r0, [sp, #0x10]
a04a38f8 5c08e3e7 ubfx r0, ip, #0x10, #4
a04a38fc 0c108de5 str r1, [sp, #0xc]
a04a3900 00c0a0e1 mov ip, r0
a04a3904 14008de5 str r0, [sp, #0x14]
a04a3908 060064e0 rsb r0, r4, r6
a04a390c 016582e2 add r6, r2, #0x400000
a04a3910 001008e3 movw r1, #0x8000
a04a3914 036a86e2 add r6, r6, #0x3000
a04a3918 b9104ae3 movt r1, #0xa0b9
a04a391c 08008de5 str r0, [sp, #8]
a04a3920 066089e0 add r6, sb, r6
a04a3924 0e01a0e1 lsl r0, lr, #2
a04a3928 025081e0 add r5, r1, r2
a04a392c 01208ce2 add r2, ip, #1
a04a3930 1c008de5 str r0, [sp, #0x1c]
a04a3934 18208de5 str r2, [sp, #0x18]
a04a3938 010053e3 cmp r3, #1
a04a393c 4900000a beq #0xa04a3a68
a04a3940 fd3f00e3 movw r3, #0xffd
a04a3944 030058e1 cmp r8, r3
a04a3948 0520a081 movhi r2, r5
a04a394c 20508d85 strhi r5, [sp, #0x20]
a04a3950 5700009a bls #0xa04a3ab4
a04a3954 0811d9e7 ldrb r1, [sb, r8, lsl #2]
a04a3958 0100a0e3 mov r0, #1
a04a395c 0cb09de5 ldr fp, [sp, #0xc]
a04a3960 0831a0e1 lsl r3, r8, #2
a04a3964 2225a0e1 lsr r2, r2, #0xa
a04a3968 1010c1e7 bfi r1, r0, #0, #2
a04a396c 0811c9e7 strb r1, [sb, r8, lsl #2]
a04a3970 0400a0e1 mov r0, r4
a04a3974 0ec0dbe5 ldrb ip, [fp, #0xe]
a04a3978 0410a0e3 mov r1, #4
a04a397c 08e1d9e7 ldrb lr, [sb, r8, lsl #2]
a04a3980 dcc1e0e7 ubfx ip, ip, #3, #1
a04a3984 9ce1c3e7 bfi lr, ip, #3, #1
a04a3988 08e1c9e7 strb lr, [sb, r8, lsl #2]
a04a398c bcc0dbe1 ldrh ip, [fp, #0xc]
a04a3990 b3e099e1 ldrh lr, [sb, r3]
a04a3994 dcc2e3e7 ubfx ip, ip, #5, #4
a04a3998 9ce2c8e7 bfi lr, ip, #5, #4
a04a399c b3e089e1 strh lr, [sb, r3]
a04a39a0 083199e7 ldr r3, [sb, r8, lsl #2]
a04a39a4 1235dfe7 bfi r3, r2, #0xa, #0x16
a04a39a8 083189e7 str r3, [sb, r8, lsl #2]
a04a39ac edfaffeb bl #0xa04a2568
a04a39b0 04209de5 ldr r2, [sp, #4]
a04a39b4 20309de5 ldr r3, [sp, #0x20]
a04a39b8 020058e1 cmp r8, r2
a04a39bc 3000000a beq #0xa04a3a84
a04a39c0 070058e1 cmp r8, r7
a04a39c4 0020a0e3 mov r2, #0
a04a39c8 4400000a beq #0xa04a3ae0
a04a39cc 011ba0e3 mov r1, #0x400
a04a39d0 02b0a0e1 mov fp, r2
a04a39d4 0fe0a0e3 mov lr, #0xf
a04a39d8 0ac0a0e1 mov ip, sl
a04a39dc 02a06ae0 rsb sl, sl, r2
a04a39e0 7c00ffe6 uxth r0, ip
a04a39e4 402083e2 add r2, r3, #0x40
a04a39e8 00108de5 str r1, [sp]
a04a39ec 24109de5 ldr r1, [sp, #0x24]
a04a39f0 043083e2 add r3, r3, #4
a04a39f4 041003e5 str r1, [r3, #-4]
a04a39f8 b20043e1 strh r0, [r3, #-2]
a04a39fc 020053e1 cmp r3, r2
a04a3a00 f9ffff1a bne #0xa04a39ec
a04a3a04 01c08ce2 add ip, ip, #1
a04a3a08 00109de5 ldr r1, [sp]
a04a3a0c 0c208ae0 add r2, sl, ip
a04a3a10 0e0052e1 cmp r2, lr
a04a3a14 f1ffff9a bls #0xa04a39e0
a04a3a18 20309de5 ldr r3, [sp, #0x20]
a04a3a1c 0ca0a0e1 mov sl, ip
a04a3a20 0b0083e0 add r0, r3, fp
a04a3a24 018088e2 add r8, r8, #1
a04a3a28 cefaffeb bl #0xa04a2568
a04a3a2c 080057e1 cmp r7, r8
a04a3a30 0900003a blo #0xa04a3a5c
a04a3a34 0831d9e7 ldrb r3, [sb, r8, lsl #2]
a04a3a38 015b85e2 add r5, r5, #0x400
a04a3a3c 08209de5 ldr r2, [sp, #8]
a04a3a40 016b86e2 add r6, r6, #0x400
a04a3a44 033003e2 and r3, r3, #3
a04a3a48 042082e2 add r2, r2, #4
a04a3a4c 020053e3 cmp r3, #2
a04a3a50 024084e0 add r4, r4, r2
a04a3a54 044089e0 add r4, sb, r4
a04a3a58 b6ffff1a bne #0xa04a3938
a04a3a5c 0000a0e3 mov r0, #0
a04a3a60 2cd08de2 add sp, sp, #0x2c
a04a3a64 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a04a3a68 083199e7 ldr r3, [sb, r8, lsl #2]
a04a3a6c 04209de5 ldr r2, [sp, #4]
a04a3a70 ff3fc3e3 bic r3, r3, #0x3fc
a04a3a74 020058e1 cmp r8, r2
a04a3a78 0330c3e3 bic r3, r3, #3
a04a3a7c 20308de5 str r3, [sp, #0x20]
a04a3a80 ceffff1a bne #0xa04a39c0
a04a3a84 070058e1 cmp r8, r7
a04a3a88 2100000a beq #0xa04a3b14
a04a3a8c 1c209de5 ldr r2, [sp, #0x1c]
a04a3a90 1010a0e3 mov r1, #0x10
a04a3a94 0fe0a0e3 mov lr, #0xf
a04a3a98 023083e0 add r3, r3, r2
a04a3a9c 02b0a0e1 mov fp, r2
a04a3aa0 10209de5 ldr r2, [sp, #0x10]
a04a3aa4 0200a0e1 mov r0, r2
a04a3aa8 011060e0 rsb r1, r0, r1
a04a3aac 0113a0e1 lsl r1, r1, #6
a04a3ab0 c8ffffea b #0xa04a39d8
a04a3ab4 012ba0e3 mov r2, #0x400
a04a3ab8 28b08de2 add fp, sp, #0x28
a04a3abc 0010a0e3 mov r1, #0
a04a3ac0 0600a0e1 mov r0, r6
a04a3ac4 08602be5 str r6, [fp, #-8]!
a04a3ac8 c75401fa blx #0xa04f8dec
a04a3acc 0b00a0e1 mov r0, fp
a04a3ad0 011ba0e3 mov r1, #0x400
a04a3ad4 fcf9ffeb bl #0xa04a22cc
a04a3ad8 20209de5 ldr r2, [sp, #0x20]
a04a3adc 9cffffea b #0xa04a3954
a04a3ae0 02b0a0e1 mov fp, r2
a04a3ae4 0200a0e1 mov r0, r2
a04a3ae8 14109de5 ldr r1, [sp, #0x14]
a04a3aec 0b3083e0 add r3, r3, fp
a04a3af0 000051e1 cmp r1, r0
a04a3af4 18109d25 ldrhs r1, [sp, #0x18]
a04a3af8 14e09d25 ldrhs lr, [sp, #0x14]
a04a3afc e9ffff2a bhs #0xa04a3aa8
a04a3b00 18209de5 ldr r2, [sp, #0x18]
a04a3b04 021060e0 rsb r1, r0, r2
a04a3b08 0300a0e1 mov r0, r3
a04a3b0c 0113a0e1 lsl r1, r1, #6
a04a3b10 c3ffffea b #0xa04a3a24
a04a3b14 10009de5 ldr r0, [sp, #0x10]
a04a3b18 1cb09de5 ldr fp, [sp, #0x1c]
a04a3b1c 0020a0e1 mov r2, r0
a04a3b20 f0ffffea b #0xa04a3ae8
a04a3b24 fc300ce3 movw r3, #0xc0fc
a04a3b28 78304ae3 movt r3, #0xa078
a04a3b2c 40c083e2 add ip, r3, #0x40
a04a3b30 002093e5 ldr r2, [r3]
a04a3b34 020050e1 cmp r0, r2
a04a3b38 0300003a blo #0xa04a3b4c
a04a3b3c 081093e5 ldr r1, [r3, #8]
a04a3b40 011082e0 add r1, r2, r1
a04a3b44 010050e1 cmp r0, r1
a04a3b48 1d00003a blo #0xa04a3bc4
a04a3b4c 103083e2 add r3, r3, #0x10
a04a3b50 0c0053e1 cmp r3, ip
a04a3b54 f5ffff1a bne #0xa04a3b30
a04a3b58 f03202e3 movw r3, #0x22f0
a04a3b5c 10402de9 push {r4, lr}
a04a3b60 6f304ae3 movt r3, #0xa06f
a04a3b64 04e093e5 ldr lr, [r3, #4]
a04a3b68 084093e5 ldr r4, [r3, #8]
a04a3b6c 00005ee3 cmp lr, #0
a04a3b70 1080bd08 popeq {r4, pc}
a04a3b74 000054e3 cmp r4, #0
a04a3b78 1080bdd8 pople {r4, pc}
a04a3b7c 0e20a0e1 mov r2, lr
a04a3b80 0030a0e3 mov r3, #0
a04a3b84 03129ee7 ldr r1, [lr, r3, lsl #4]
a04a3b88 013083e2 add r3, r3, #1
a04a3b8c 010050e1 cmp r0, r1
a04a3b90 0300003a blo #0xa04a3ba4
a04a3b94 08c092e5 ldr ip, [r2, #8]
a04a3b98 0cc081e0 add ip, r1, ip
a04a3b9c 0c0050e1 cmp r0, ip
a04a3ba0 0300003a blo #0xa04a3bb4
a04a3ba4 040053e1 cmp r3, r4
a04a3ba8 102082e2 add r2, r2, #0x10
a04a3bac f4ffff1a bne #0xa04a3b84
a04a3bb0 1080bde8 pop {r4, pc}
a04a3bb4 043092e5 ldr r3, [r2, #4]
a04a3bb8 030080e0 add r0, r0, r3
a04a3bbc 000061e0 rsb r0, r1, r0
a04a3bc0 1080bde8 pop {r4, pc}
a04a3bc4 043093e5 ldr r3, [r3, #4]
a04a3bc8 030080e0 add r0, r0, r3
a04a3bcc 000062e0 rsb r0, r2, r0
a04a3bd0 1eff2fe1 bx lr
a04a3bd4 fc300ce3 movw r3, #0xc0fc
a04a3bd8 78304ae3 movt r3, #0xa078
a04a3bdc 40c083e2 add ip, r3, #0x40
a04a3be0 042093e5 ldr r2, [r3, #4]
a04a3be4 020050e1 cmp r0, r2
a04a3be8 0300003a blo #0xa04a3bfc
a04a3bec 081093e5 ldr r1, [r3, #8]
a04a3bf0 011082e0 add r1, r2, r1
a04a3bf4 010050e1 cmp r0, r1
a04a3bf8 1b00003a blo #0xa04a3c6c
a04a3bfc 103083e2 add r3, r3, #0x10
a04a3c00 0c0053e1 cmp r3, ip
a04a3c04 f5ffff1a bne #0xa04a3be0
a04a3c08 f02202e3 movw r2, #0x22f0
a04a3c0c 04e02de5 str lr, [sp, #-4]!
a04a3c10 6f204ae3 movt r2, #0xa06f
a04a3c14 084092e9 ldmib r2, {r3, lr}
a04a3c18 000053e3 cmp r3, #0
a04a3c1c 04f09d04 popeq {pc}
a04a3c20 00005ee3 cmp lr, #0
a04a3c24 04f09dd4 pople {pc}
a04a3c28 0020a0e3 mov r2, #0
a04a3c2c 041093e5 ldr r1, [r3, #4]
a04a3c30 012082e2 add r2, r2, #1
a04a3c34 010050e1 cmp r0, r1
a04a3c38 0300003a blo #0xa04a3c4c
a04a3c3c 08c093e5 ldr ip, [r3, #8]
a04a3c40 0cc081e0 add ip, r1, ip
a04a3c44 0c0050e1 cmp r0, ip
a04a3c48 0300003a blo #0xa04a3c5c
a04a3c4c 0e0052e1 cmp r2, lr
a04a3c50 103083e2 add r3, r3, #0x10
a04a3c54 f4ffff1a bne #0xa04a3c2c
a04a3c58 04f09de4 pop {pc}
a04a3c5c 003093e5 ldr r3, [r3]
a04a3c60 030080e0 add r0, r0, r3
a04a3c64 000061e0 rsb r0, r1, r0
a04a3c68 04f09de4 pop {pc}
a04a3c6c 003093e5 ldr r3, [r3]
a04a3c70 030080e0 add r0, r0, r3
a04a3c74 000062e0 rsb r0, r2, r0
a04a3c78 1eff2fe1 bx lr
a04a3c7c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04a3c80 0030a0e3 mov r3, #0
a04a3c84 0c20d1e5 ldrb r2, [r1, #0xc]
a04a3c88 34d04de2 sub sp, sp, #0x34
a04a3c8c 2c308de5 str r3, [sp, #0x2c]
a04a3c90 5232e0e7 ubfx r3, r2, #4, #1
a04a3c94 52e1e0e7 ubfx lr, r2, #2, #1
a04a3c98 023083e3 orr r3, r3, #2
a04a3c9c 0d40d1e5 ldrb r4, [r1, #0xd]
a04a3ca0 033003e2 and r3, r3, #3
a04a3ca4 d2c1e0e7 ubfx ip, r2, #3, #1
a04a3ca8 1e31c2e7 bfi r3, lr, #2, #1
a04a3cac 002091e5 ldr r2, [r1]
a04a3cb0 08e091e5 ldr lr, [r1, #8]
a04a3cb4 d450e2e7 ubfx r5, r4, #1, #3
a04a3cb8 9c31c3e7 bfi r3, ip, #3, #1
a04a3cbc 5442e2e7 ubfx r4, r4, #4, #3
a04a3cc0 1532c5e7 bfi r3, r5, #4, #2
a04a3cc4 0e60d1e5 ldrb r6, [r1, #0xe]
a04a3cc8 0ee082e0 add lr, r2, lr
a04a3ccc 2c30cde5 strb r3, [sp, #0x2c]
a04a3cd0 01e04ee2 sub lr, lr, #1
a04a3cd4 bcc2dde1 ldrh ip, [sp, #0x2c]
a04a3cd8 2e3aa0e1 lsr r3, lr, #0x14
a04a3cdc 4571a0e1 asr r7, r5, #2
a04a3ce0 045091e5 ldr r5, [r1, #4]
a04a3ce4 0390a0e1 mov sb, r3
a04a3ce8 04308de5 str r3, [sp, #4]
a04a3cec 223aa0e1 lsr r3, r2, #0x14
a04a3cf0 14c3c8e7 bfi ip, r4, #6, #3
a04a3cf4 d640e0e7 ubfx r4, r6, #1, #1
a04a3cf8 bcc2cde1 strh ip, [sp, #0x2c]
a04a3cfc 0380a0e1 mov r8, r3
a04a3d00 08308de5 str r3, [sp, #8]
a04a3d04 2c34a0e1 lsr r3, ip, #8
a04a3d08 090058e1 cmp r8, sb
a04a3d0c 2556a0e1 lsr r5, r5, #0xc
a04a3d10 9730c1e7 bfi r3, r7, #1, #1
a04a3d14 1631c2e7 bfi r3, r6, #2, #1
a04a3d18 9431c3e7 bfi r3, r4, #3, #1
a04a3d1c 2d30cde5 strb r3, [sp, #0x2d]
a04a3d20 6900008a bhi #0xa04a3ecc
a04a3d24 0831d0e7 ldrb r3, [r0, r8, lsl #2]
a04a3d28 08c1a0e1 lsl ip, r8, #2
a04a3d2c 0cb080e0 add fp, r0, ip
a04a3d30 033003e2 and r3, r3, #3
a04a3d34 020053e3 cmp r3, #2
a04a3d38 6300000a beq #0xa04a3ecc
a04a3d3c 0090a0e1 mov sb, r0
a04a3d40 04000fe3 movw r0, #0xf004
a04a3d44 3f0040e3 movt r0, #0x3f
a04a3d48 5226e7e7 ubfx r2, r2, #0xc, #8
a04a3d4c 000088e0 add r0, r8, r0
a04a3d50 1c208de5 str r2, [sp, #0x1c]
a04a3d54 0005a0e1 lsl r0, r0, #0xa
a04a3d58 0221a0e1 lsl r2, r2, #2
a04a3d5c 14108de5 str r1, [sp, #0x14]
a04a3d60 24208de5 str r2, [sp, #0x24]
a04a3d64 001008e3 movw r1, #0x8000
a04a3d68 012580e2 add r2, r0, #0x400000
a04a3d6c b9104ae3 movt r1, #0xa0b9
a04a3d70 032a82e2 add r2, r2, #0x3000
a04a3d74 5ee6e7e7 ubfx lr, lr, #0xc, #8
a04a3d78 022089e0 add r2, sb, r2
a04a3d7c 007081e0 add r7, r1, r0
a04a3d80 0860a0e1 mov r6, r8
a04a3d84 0cc06be0 rsb ip, fp, ip
a04a3d88 00208de5 str r2, [sp]
a04a3d8c 01208ee2 add r2, lr, #1
a04a3d90 20e08de5 str lr, [sp, #0x20]
a04a3d94 0cc08de5 str ip, [sp, #0xc]
a04a3d98 18208de5 str r2, [sp, #0x18]
a04a3d9c 010053e3 cmp r3, #1
a04a3da0 5800000a beq #0xa04a3f08
a04a3da4 fd3f00e3 movw r3, #0xffd
a04a3da8 030056e1 cmp r6, r3
a04a3dac 0700a081 movhi r0, r7
a04a3db0 28708d85 strhi r7, [sp, #0x28]
a04a3db4 4700009a bls #0xa04a3ed8
a04a3db8 0621d9e7 ldrb r2, [sb, r6, lsl #2]
a04a3dbc 0110a0e3 mov r1, #1
a04a3dc0 14c09de5 ldr ip, [sp, #0x14]
a04a3dc4 0631a0e1 lsl r3, r6, #2
a04a3dc8 1120c1e7 bfi r2, r1, #0, #2
a04a3dcc 0621c9e7 strb r2, [sb, r6, lsl #2]
a04a3dd0 0e20dce5 ldrb r2, [ip, #0xe]
a04a3dd4 0611d9e7 ldrb r1, [sb, r6, lsl #2]
a04a3dd8 d221e0e7 ubfx r2, r2, #3, #1
a04a3ddc 9211c3e7 bfi r1, r2, #3, #1
a04a3de0 0611c9e7 strb r1, [sb, r6, lsl #2]
a04a3de4 bc20dce1 ldrh r2, [ip, #0xc]
a04a3de8 b31099e1 ldrh r1, [sb, r3]
a04a3dec d222e3e7 ubfx r2, r2, #5, #4
a04a3df0 9212c8e7 bfi r1, r2, #5, #4
a04a3df4 b31089e1 strh r1, [sb, r3]
a04a3df8 49ffffeb bl #0xa04a3b24
a04a3dfc 063199e7 ldr r3, [sb, r6, lsl #2]
a04a3e00 2025a0e1 lsr r2, r0, #0xa
a04a3e04 0410a0e3 mov r1, #4
a04a3e08 0b00a0e1 mov r0, fp
a04a3e0c 1235dfe7 bfi r3, r2, #0xa, #0x16
a04a3e10 063189e7 str r3, [sb, r6, lsl #2]
a04a3e14 d3f9ffeb bl #0xa04a2568
a04a3e18 08309de5 ldr r3, [sp, #8]
a04a3e1c 030056e1 cmp r6, r3
a04a3e20 04309de5 ldr r3, [sp, #4]
a04a3e24 4100000a beq #0xa04a3f30
a04a3e28 030056e1 cmp r6, r3
a04a3e2c 4c00000a beq #0xa04a3f64
a04a3e30 28009de5 ldr r0, [sp, #0x28]
a04a3e34 011ba0e3 mov r1, #0x400
a04a3e38 ffa0a0e3 mov sl, #0xff
a04a3e3c 0080a0e3 mov r8, #0
a04a3e40 10808de5 str r8, [sp, #0x10]
a04a3e44 5530f3e7 ubfx r3, r5, #0, #0x14
a04a3e48 05e0a0e1 mov lr, r5
a04a3e4c 01e08ee2 add lr, lr, #1
a04a3e50 2cc09de5 ldr ip, [sp, #0x2c]
a04a3e54 0e4065e0 rsb r4, r5, lr
a04a3e58 040080e2 add r0, r0, #4
a04a3e5c 084084e0 add r4, r4, r8
a04a3e60 0a0054e1 cmp r4, sl
a04a3e64 13c6dfe7 bfi ip, r3, #0xc, #0x14
a04a3e68 013083e2 add r3, r3, #1
a04a3e6c 04c000e5 str ip, [r0, #-4]
a04a3e70 5330f3e7 ubfx r3, r3, #0, #0x14
a04a3e74 f4ffff9a bls #0xa04a3e4c
a04a3e78 28009de5 ldr r0, [sp, #0x28]
a04a3e7c 0e50a0e1 mov r5, lr
a04a3e80 10309de5 ldr r3, [sp, #0x10]
a04a3e84 030080e0 add r0, r0, r3
a04a3e88 b6f9ffeb bl #0xa04a2568
a04a3e8c 04309de5 ldr r3, [sp, #4]
a04a3e90 016086e2 add r6, r6, #1
a04a3e94 060053e1 cmp r3, r6
a04a3e98 0b00003a blo #0xa04a3ecc
a04a3e9c 0c209de5 ldr r2, [sp, #0xc]
a04a3ea0 017b87e2 add r7, r7, #0x400
a04a3ea4 0631d9e7 ldrb r3, [sb, r6, lsl #2]
a04a3ea8 042082e2 add r2, r2, #4
a04a3eac 02b08be0 add fp, fp, r2
a04a3eb0 00209de5 ldr r2, [sp]
a04a3eb4 033003e2 and r3, r3, #3
a04a3eb8 0bb089e0 add fp, sb, fp
a04a3ebc 020053e3 cmp r3, #2
a04a3ec0 012b82e2 add r2, r2, #0x400
a04a3ec4 00208de5 str r2, [sp]
a04a3ec8 b3ffff1a bne #0xa04a3d9c
a04a3ecc 0000a0e3 mov r0, #0
a04a3ed0 34d08de2 add sp, sp, #0x34
a04a3ed4 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a04a3ed8 00309de5 ldr r3, [sp]
a04a3edc 30408de2 add r4, sp, #0x30
a04a3ee0 0010a0e3 mov r1, #0
a04a3ee4 012ba0e3 mov r2, #0x400
a04a3ee8 0300a0e1 mov r0, r3
a04a3eec 083024e5 str r3, [r4, #-8]!
a04a3ef0 bd5301fa blx #0xa04f8dec
a04a3ef4 0400a0e1 mov r0, r4
a04a3ef8 011ba0e3 mov r1, #0x400
a04a3efc f2f8ffeb bl #0xa04a22cc
a04a3f00 28009de5 ldr r0, [sp, #0x28]
a04a3f04 abffffea b #0xa04a3db8
a04a3f08 063199e7 ldr r3, [sb, r6, lsl #2]
a04a3f0c ff3fc3e3 bic r3, r3, #0x3fc
a04a3f10 0330c3e3 bic r3, r3, #3
a04a3f14 0300a0e1 mov r0, r3
a04a3f18 28308de5 str r3, [sp, #0x28]
a04a3f1c 2cffffeb bl #0xa04a3bd4
a04a3f20 0410a0e3 mov r1, #4
a04a3f24 28008de5 str r0, [sp, #0x28]
a04a3f28 8ef9ffeb bl #0xa04a2568
a04a3f2c b9ffffea b #0xa04a3e18
a04a3f30 030056e1 cmp r6, r3
a04a3f34 1800000a beq #0xa04a3f9c
a04a3f38 24209de5 ldr r2, [sp, #0x24]
a04a3f3c 013ca0e3 mov r3, #0x100
a04a3f40 28009de5 ldr r0, [sp, #0x28]
a04a3f44 ffa0a0e3 mov sl, #0xff
a04a3f48 1c809de5 ldr r8, [sp, #0x1c]
a04a3f4c 10208de5 str r2, [sp, #0x10]
a04a3f50 020080e0 add r0, r0, r2
a04a3f54 0810a0e1 mov r1, r8
a04a3f58 031061e0 rsb r1, r1, r3
a04a3f5c 0111a0e1 lsl r1, r1, #2
a04a3f60 b7ffffea b #0xa04a3e44
a04a3f64 0080a0e3 mov r8, #0
a04a3f68 0810a0e1 mov r1, r8
a04a3f6c 10808de5 str r8, [sp, #0x10]
a04a3f70 20309de5 ldr r3, [sp, #0x20]
a04a3f74 28009de5 ldr r0, [sp, #0x28]
a04a3f78 010053e1 cmp r3, r1
a04a3f7c 10309de5 ldr r3, [sp, #0x10]
a04a3f80 030080e0 add r0, r0, r3
a04a3f84 18309de5 ldr r3, [sp, #0x18]
a04a3f88 03106130 rsblo r1, r1, r3
a04a3f8c 0111a031 lsllo r1, r1, #2
a04a3f90 bcffff3a blo #0xa04a3e88
a04a3f94 20a09de5 ldr sl, [sp, #0x20]
a04a3f98 eeffffea b #0xa04a3f58
a04a3f9c 1c109de5 ldr r1, [sp, #0x1c]
a04a3fa0 24309de5 ldr r3, [sp, #0x24]
a04a3fa4 0180a0e1 mov r8, r1
a04a3fa8 10308de5 str r3, [sp, #0x10]
a04a3fac efffffea b #0xa04a3f70
a04a3fb0 0c30d0e5 ldrb r3, [r0, #0xc]
a04a3fb4 033003e2 and r3, r3, #3
a04a3fb8 010053e3 cmp r3, #1
a04a3fbc 0800000a beq #0xa04a3fe4
a04a3fc0 020053e3 cmp r3, #2
a04a3fc4 0900000a beq #0xa04a3ff0
a04a3fc8 030053e3 cmp r3, #3
a04a3fcc 0200001a bne #0xa04a3fdc
a04a3fd0 0010a0e1 mov r1, r0
a04a3fd4 20009fe5 ldr r0, [pc, #0x20]
a04a3fd8 27ffffea b #0xa04a3c7c
a04a3fdc 0000e0e3 mvn r0, #0
a04a3fe0 1eff2fe1 bx lr
a04a3fe4 0010a0e1 mov r1, r0
a04a3fe8 0c009fe5 ldr r0, [pc, #0xc]
a04a3fec d8fdffea b #0xa04a3754
a04a3ff0 0010a0e1 mov r1, r0
a04a3ff4 00009fe5 ldr r0, [pc]
a04a3ff8 0bfeffea b #0xa04a382c
