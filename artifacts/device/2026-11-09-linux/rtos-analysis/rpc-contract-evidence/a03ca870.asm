a03ca870 f0432de9 push {r4, r5, r6, r7, r8, sb, lr}
a03ca874 449080e2 add sb, r0, #0x44
a03ca878 3c1380e5 str r1, [r0, #0x33c]
a03ca87c 14d04de2 sub sp, sp, #0x14
a03ca880 0110a0e3 mov r1, #1
a03ca884 0080a0e1 mov r8, r0
a03ca888 402380e5 str r2, [r0, #0x340]
a03ca88c 0900a0e1 mov r0, sb
a03ca890 14c7ffeb bl #0xa03bc4e8
a03ca894 001050e2 subs r1, r0, #0
a03ca898 5b00001a bne #0xa03caa0c
a03ca89c 443398e5 ldr r3, [r8, #0x344]
a03ca8a0 000053e3 cmp r3, #0
a03ca8a4 0c508d12 addne r5, sp, #0xc
a03ca8a8 0e00000a beq #0xa03ca8e8
a03ca8ac 0020e0e3 mvn r2, #0
a03ca8b0 0210a0e3 mov r1, #2
a03ca8b4 00208de5 str r2, [sp]
a03ca8b8 0900a0e1 mov r0, sb
a03ca8bc 0530a0e1 mov r3, r5
a03ca8c0 0320a0e3 mov r2, #3
a03ca8c4 f8c6ffeb bl #0xa03bc4ac
a03ca8c8 001050e2 subs r1, r0, #0
a03ca8cc 0200000a beq #0xa03ca8dc
a03ca8d0 c4020ee3 movw r0, #0xe2c4
a03ca8d4 60004ae3 movt r0, #0xa060
a03ca8d8 0372fbeb bl #0xa02a70ec
a03ca8dc 0000a0e3 mov r0, #0
a03ca8e0 14d08de2 add sp, sp, #0x14
a03ca8e4 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a03ca8e8 483b07e3 movw r3, #0x7b48
a03ca8ec 0010e0e3 mvn r1, #0
a03ca8f0 79314ae3 movt r3, #0xa179
a03ca8f4 004093e5 ldr r4, [r3]
a03ca8f8 0400a0e1 mov r0, r4
a03ca8fc dac6ffeb bl #0xa03bc46c
a03ca900 001050e2 subs r1, r0, #0
a03ca904 4800001a bne #0xa03caa2c
a03ca908 3c6084e2 add r6, r4, #0x3c
a03ca90c 0c508de2 add r5, sp, #0xc
a03ca910 0070e0e3 mvn r7, #0
a03ca914 0c0000ea b #0xa03ca94c
a03ca918 0210a0e3 mov r1, #2
a03ca91c 00708de5 str r7, [sp]
a03ca920 0600a0e1 mov r0, r6
a03ca924 0320a0e3 mov r2, #3
a03ca928 0530a0e1 mov r3, r5
a03ca92c dec6ffeb bl #0xa03bc4ac
a03ca930 001050e2 subs r1, r0, #0
a03ca934 1100001a bne #0xa03ca980
a03ca938 0010e0e3 mvn r1, #0
a03ca93c 0400a0e1 mov r0, r4
a03ca940 c9c6ffeb bl #0xa03bc46c
a03ca944 001050e2 subs r1, r0, #0
a03ca948 3300001a bne #0xa03caa1c
a03ca94c 6c3094e5 ldr r3, [r4, #0x6c]
a03ca950 0400a0e1 mov r0, r4
a03ca954 682094e5 ldr r2, [r4, #0x68]
a03ca958 013083e2 add r3, r3, #1
a03ca95c 020053e1 cmp r3, r2
a03ca960 0a0000da ble #0xa03ca990
a03ca964 cbc6ffeb bl #0xa03bc498
a03ca968 001050e2 subs r1, r0, #0
a03ca96c e9ffff0a beq #0xa03ca918
a03ca970 d8010ee3 movw r0, #0xe1d8
a03ca974 60004ae3 movt r0, #0xa060
a03ca978 db71fbeb bl #0xa02a70ec
a03ca97c e5ffffea b #0xa03ca918
a03ca980 0c020ee3 movw r0, #0xe20c
a03ca984 60004ae3 movt r0, #0xa060
a03ca988 d771fbeb bl #0xa02a70ec
a03ca98c e9ffffea b #0xa03ca938
a03ca990 741094e5 ldr r1, [r4, #0x74]
a03ca994 843e0ae3 movw r3, #0xae84
a03ca998 382094e5 ldr r2, [r4, #0x38]
a03ca99c 3c304ae3 movt r3, #0xa03c
a03ca9a0 813182e7 str r3, [r2, r1, lsl #3]
a03ca9a4 742094e5 ldr r2, [r4, #0x74]
a03ca9a8 383094e5 ldr r3, [r4, #0x38]
a03ca9ac 823183e0 add r3, r3, r2, lsl #3
a03ca9b0 048083e5 str r8, [r3, #4]
a03ca9b4 740094e5 ldr r0, [r4, #0x74]
a03ca9b8 681094e5 ldr r1, [r4, #0x68]
a03ca9bc 010080e2 add r0, r0, #1
a03ca9c0 d7ef04fa blx #0xa0506924
a03ca9c4 0130a0e1 mov r3, r1
a03ca9c8 0110a0e3 mov r1, #1
a03ca9cc 743084e5 str r3, [r4, #0x74]
a03ca9d0 0600a0e1 mov r0, r6
a03ca9d4 6c3094e5 ldr r3, [r4, #0x6c]
a03ca9d8 013083e0 add r3, r3, r1
a03ca9dc 6c3084e5 str r3, [r4, #0x6c]
a03ca9e0 c0c6ffeb bl #0xa03bc4e8
a03ca9e4 001050e2 subs r1, r0, #0
a03ca9e8 1300001a bne #0xa03caa3c
a03ca9ec 0400a0e1 mov r0, r4
a03ca9f0 a8c6ffeb bl #0xa03bc498
a03ca9f4 001050e2 subs r1, r0, #0
a03ca9f8 abffff0a beq #0xa03ca8ac
a03ca9fc 98020ee3 movw r0, #0xe298
a03caa00 60004ae3 movt r0, #0xa060
a03caa04 b871fbeb bl #0xa02a70ec
a03caa08 a7ffffea b #0xa03ca8ac
a03caa0c a8010ee3 movw r0, #0xe1a8
a03caa10 60004ae3 movt r0, #0xa060
a03caa14 b471fbeb bl #0xa02a70ec
a03caa18 9fffffea b #0xa03ca89c
a03caa1c 30020ee3 movw r0, #0xe230
a03caa20 60004ae3 movt r0, #0xa060
a03caa24 b071fbeb bl #0xa02a70ec
a03caa28 b8ffffea b #0xa03ca910
a03caa2c e0010ee3 movw r0, #0xe1e0
a03caa30 60004ae3 movt r0, #0xa060
a03caa34 ac71fbeb bl #0xa02a70ec
a03caa38 b2ffffea b #0xa03ca908
a03caa3c 64020ee3 movw r0, #0xe264
a03caa40 60004ae3 movt r0, #0xa060
a03caa44 a871fbeb bl #0xa02a70ec
a03caa48 e7ffffea b #0xa03ca9ec
