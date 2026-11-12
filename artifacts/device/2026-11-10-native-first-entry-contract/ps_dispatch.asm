a02a3864 010050e3 cmp r0, #1
a02a3868 f0412de9 push {r4, r5, r6, r7, r8, lr}
a02a386c 0070a0e1 mov r7, r0
a02a3870 0180a0e1 mov r8, r1
a02a3874 0260a0e1 mov r6, r2
a02a3878 6700000a beq #0xa02a3a1c
a02a387c 045091e5 ldr r5, [r1, #4]
a02a3880 d41100e3 movw r1, #0x1d4
a02a3884 5b104ae3 movt r1, #0xa05b
a02a3888 0500a0e1 mov r0, r5
a02a388c ac5709fa blx #0xa04f9744
a02a3890 004050e2 subs r4, r0, #0
a02a3894 5500000a beq #0xa02a39f0
a02a3898 94110de3 movw r1, #0xd194
a02a389c 0500a0e1 mov r0, r5
a02a38a0 61104ae3 movt r1, #0xa061
a02a38a4 a65709fa blx #0xa04f9744
a02a38a8 004050e2 subs r4, r0, #0
a02a38ac 5300000a beq #0xa02a3a00
a02a38b0 d81100e3 movw r1, #0x1d8
a02a38b4 0500a0e1 mov r0, r5
a02a38b8 5b104ae3 movt r1, #0xa05b
a02a38bc a05709fa blx #0xa04f9744
a02a38c0 004050e2 subs r4, r0, #0
a02a38c4 4500000a beq #0xa02a39e0
a02a38c8 dc1100e3 movw r1, #0x1dc
a02a38cc 0500a0e1 mov r0, r5
a02a38d0 5b104ae3 movt r1, #0xa05b
a02a38d4 9a5709fa blx #0xa04f9744
a02a38d8 004050e2 subs r4, r0, #0
a02a38dc 4b00000a beq #0xa02a3a10
a02a38e0 6c1104e3 movw r1, #0x416c
a02a38e4 0500a0e1 mov r0, r5
a02a38e8 53104ae3 movt r1, #0xa053
a02a38ec 945709fa blx #0xa04f9744
a02a38f0 004050e2 subs r4, r0, #0
a02a38f4 4d00000a beq #0xa02a3a30
a02a38f8 4c1e06e3 movw r1, #0x6e4c
a02a38fc 0500a0e1 mov r0, r5
a02a3900 56104ae3 movt r1, #0xa056
a02a3904 8e5709fa blx #0xa04f9744
a02a3908 004050e2 subs r4, r0, #0
a02a390c 0d00001a bne #0xa02a3948
a02a3910 020057e3 cmp r7, #2
a02a3914 050000da ble #0xa02a3930
a02a3918 901206e3 movw r1, #0x6290
a02a391c 080098e5 ldr r0, [r8, #8]
a02a3920 56104ae3 movt r1, #0xa056
a02a3924 865709fa blx #0xa04f9744
a02a3928 000050e3 cmp r0, #0
a02a392c 5700000a beq #0xa02a3a90
a02a3930 0600a0e1 mov r0, r6
a02a3934 90b007eb bl #0xa048fb7c
a02a3938 0600a0e1 mov r0, r6
a02a393c 3ab107eb bl #0xa048fe2c
a02a3940 0400a0e1 mov r0, r4
a02a3944 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a02a3948 04150ee3 movw r1, #0xe504
a02a394c 0500a0e1 mov r0, r5
a02a3950 5c104ae3 movt r1, #0xa05c
a02a3954 7a5709fa blx #0xa04f9744
a02a3958 004050e2 subs r4, r0, #0
a02a395c 4e00000a beq #0xa02a3a9c
a02a3960 e01100e3 movw r1, #0x1e0
a02a3964 0500a0e1 mov r0, r5
a02a3968 5b104ae3 movt r1, #0xa05b
a02a396c 745709fa blx #0xa04f9744
a02a3970 004050e2 subs r4, r0, #0
a02a3974 3000001a bne #0xa02a3a3c
a02a3978 020057e3 cmp r7, #2
a02a397c 3f0000da ble #0xa02a3a80
a02a3980 085098e5 ldr r5, [r8, #8]
a02a3984 3c1008e3 movw r1, #0x803c
a02a3988 63104ae3 movt r1, #0xa063
a02a398c 0500a0e1 mov r0, r5
a02a3990 6b5709fa blx #0xa04f9744
a02a3994 007050e2 subs r7, r0, #0
a02a3998 5500000a beq #0xa02a3af4
a02a399c 04150ee3 movw r1, #0xe504
a02a39a0 0500a0e1 mov r0, r5
a02a39a4 5c104ae3 movt r1, #0xa05c
a02a39a8 655709fa blx #0xa04f9744
a02a39ac 000050e3 cmp r0, #0
a02a39b0 3200000a beq #0xa02a3a80
a02a39b4 941804e3 movw r1, #0x4894
a02a39b8 0500a0e1 mov r0, r5
a02a39bc 56104ae3 movt r1, #0xa056
a02a39c0 5f5709fa blx #0xa04f9744
a02a39c4 003050e2 subs r3, r0, #0
a02a39c8 3e00001a bne #0xa02a3ac8
a02a39cc 0600a0e1 mov r0, r6
a02a39d0 fa1fa0e3 mov r1, #0x3e8
a02a39d4 0340a0e1 mov r4, r3
a02a39d8 b8b107eb bl #0xa04900c0
a02a39dc d7ffffea b #0xa02a3940
a02a39e0 0600a0e1 mov r0, r6
a02a39e4 64af07eb bl #0xa048f77c
a02a39e8 0400a0e1 mov r0, r4
a02a39ec f081bde8 pop {r4, r5, r6, r7, r8, pc}
a02a39f0 0600a0e1 mov r0, r6
a02a39f4 90ae07eb bl #0xa048f43c
a02a39f8 0400a0e1 mov r0, r4
a02a39fc f081bde8 pop {r4, r5, r6, r7, r8, pc}
a02a3a00 0600a0e1 mov r0, r6
a02a3a04 feae07eb bl #0xa048f604
a02a3a08 0400a0e1 mov r0, r4
a02a3a0c f081bde8 pop {r4, r5, r6, r7, r8, pc}
a02a3a10 0600a0e1 mov r0, r6
a02a3a14 adaf07eb bl #0xa048f8d0
a02a3a18 c8ffffea b #0xa02a3940
a02a3a1c 0100a0e1 mov r0, r1
a02a3a20 0210a0e1 mov r1, r2
a02a3a24 51ffffeb bl #0xa02a3770
a02a3a28 0040a0e3 mov r4, #0
a02a3a2c c3ffffea b #0xa02a3940
a02a3a30 0600a0e1 mov r0, r6
a02a3a34 faaf07eb bl #0xa048fa24
a02a3a38 c0ffffea b #0xa02a3940
a02a3a3c 7c1d06e3 movw r1, #0x6d7c
a02a3a40 0500a0e1 mov r0, r5
a02a3a44 5a104ae3 movt r1, #0xa05a
a02a3a48 3d5709fa blx #0xa04f9744
a02a3a4c 004050e2 subs r4, r0, #0
a02a3a50 2a00001a bne #0xa02a3b00
a02a3a54 020057e3 cmp r7, #2
a02a3a58 050000da ble #0xa02a3a74
a02a3a5c 3c1008e3 movw r1, #0x803c
a02a3a60 080098e5 ldr r0, [r8, #8]
a02a3a64 63104ae3 movt r1, #0xa063
a02a3a68 355709fa blx #0xa04f9744
a02a3a6c 005050e2 subs r5, r0, #0
a02a3a70 1c00000a beq #0xa02a3ae8
a02a3a74 0600a0e1 mov r0, r6
a02a3a78 62ad07eb bl #0xa048f008
a02a3a7c afffffea b #0xa02a3940
a02a3a80 0600a0e1 mov r0, r6
a02a3a84 0010e0e3 mvn r1, #0
a02a3a88 30b107eb bl #0xa048ff50
a02a3a8c abffffea b #0xa02a3940
a02a3a90 0600a0e1 mov r0, r6
a02a3a94 81b007eb bl #0xa048fca0
a02a3a98 a8ffffea b #0xa02a3940
a02a3a9c 0600a0e1 mov r0, r6
a02a3aa0 65ae07eb bl #0xa048f43c
a02a3aa4 0600a0e1 mov r0, r6
a02a3aa8 d5ae07eb bl #0xa048f604
a02a3aac 0600a0e1 mov r0, r6
a02a3ab0 31af07eb bl #0xa048f77c
a02a3ab4 0600a0e1 mov r0, r6
a02a3ab8 84af07eb bl #0xa048f8d0
a02a3abc 0600a0e1 mov r0, r6
a02a3ac0 d7af07eb bl #0xa048fa24
a02a3ac4 99ffffea b #0xa02a3930
a02a3ac8 0010a0e3 mov r1, #0
a02a3acc 0500a0e1 mov r0, r5
a02a3ad0 0120a0e1 mov r2, r1
a02a3ad4 135e09fa blx #0xa04fb328
a02a3ad8 0010a0e1 mov r1, r0
a02a3adc 0600a0e1 mov r0, r6
a02a3ae0 1ab107eb bl #0xa048ff50
a02a3ae4 95ffffea b #0xa02a3940
a02a3ae8 1aae07eb bl #0xa048f358
a02a3aec 0540a0e1 mov r4, r5
a02a3af0 92ffffea b #0xa02a3940
a02a3af4 b9b107eb bl #0xa04901e0
a02a3af8 0740a0e1 mov r4, r7
a02a3afc 8fffffea b #0xa02a3940
a02a3b00 0800a0e1 mov r0, r8
a02a3b04 0610a0e1 mov r1, r6
a02a3b08 0040e0e3 mvn r4, #0
a02a3b0c 17ffffeb bl #0xa02a3770
a02a3b10 8affffea b #0xa02a3940
