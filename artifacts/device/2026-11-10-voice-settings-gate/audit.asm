
FUNCTION 0xa016326c
a016326c 6000a0e3 mov r0, #0x60
a0163270 1eff2fe1 bx lr

FUNCTION 0xa0163294
a0163294 70402de9 push {r4, r5, r6, lr}
a0163298 006050e2 subs r6, r0, #0
a016329c 210000ba blt #0xa0163328
a01632a0 000051e3 cmp r1, #0
a01632a4 0100a0e1 mov r0, r1
a01632a8 2000000a beq #0xa0163330
a01632ac 000052e3 cmp r2, #0
a01632b0 1a00000a beq #0xa0163320
a01632b4 00c0a0e3 mov ip, #0
a01632b8 a45f05e3 movw r5, #0x5fa4
a01632bc 0ce0a0e1 mov lr, ip
a01632c0 6a504ae3 movt r5, #0xa06a
a01632c4 020000ea b #0xa01632d4
a01632c8 01e08ee2 add lr, lr, #1
a01632cc 60005ee3 cmp lr, #0x60
a01632d0 1000000a beq #0xa0163318
a01632d4 0c4095e7 ldr r4, [r5, ip]
a01632d8 a43f05e3 movw r3, #0x5fa4
a01632dc 6a304ae3 movt r3, #0xa06a
a01632e0 64c08ce2 add ip, ip, #0x64
a01632e4 060054e1 cmp r4, r6
a01632e8 f6ffff1a bne #0xa01632c8
a01632ec 0ec2a0e1 lsl ip, lr, #4
a01632f0 0ee18ce0 add lr, ip, lr, lsl #2
a01632f4 0ee18ee0 add lr, lr, lr, lsl #2
a01632f8 08c08ee2 add ip, lr, #8
a01632fc 0c3093e0 adds r3, r3, ip
a0163300 0400000a beq #0xa0163318
a0163304 0210a0e1 mov r1, r2
a0163308 0320a0e1 mov r2, r3
a016330c 2c580efa blx #0xa04f93c4
a0163310 0000a0e3 mov r0, #0
a0163314 7080bde8 pop {r4, r5, r6, pc}
a0163318 0500e0e3 mvn r0, #5
a016331c 7080bde8 pop {r4, r5, r6, pc}
a0163320 0300e0e3 mvn r0, #3
a0163324 7080bde8 pop {r4, r5, r6, pc}
a0163328 0100e0e3 mvn r0, #1
a016332c 7080bde8 pop {r4, r5, r6, pc}
a0163330 0200e0e3 mvn r0, #2
a0163334 7080bde8 pop {r4, r5, r6, pc}

FUNCTION 0xa0166274
a0166274 f0402de9 push {r4, r5, r6, r7, lr}
a0166278 0030a0e3 mov r3, #0
a016627c 3cd04de2 sub sp, sp, #0x3c
a0166280 08308de5 str r3, [sp, #8]
a0166284 0c308de5 str r3, [sp, #0xc]
a0166288 10308de5 str r3, [sp, #0x10]
a016628c 14308de5 str r3, [sp, #0x14]
a0166290 18308de5 str r3, [sp, #0x18]
a0166294 1c308de5 str r3, [sp, #0x1c]
a0166298 20308de5 str r3, [sp, #0x20]
a016629c 24308de5 str r3, [sp, #0x24]
a01662a0 28308de5 str r3, [sp, #0x28]
a01662a4 2c308de5 str r3, [sp, #0x2c]
a01662a8 30308de5 str r3, [sp, #0x30]
a01662ac 34308de5 str r3, [sp, #0x34]
a01662b0 edf3ffeb bl #0xa016326c
a01662b4 0060a0e1 mov r6, r0
a01662b8 dbbbffeb bl #0xa015522c
a01662bc 000050e3 cmp r0, #0
a01662c0 6200001a bne #0xa0166450
a01662c4 e43302e3 movw r3, #0x23e4
a01662c8 2020a0e3 mov r2, #0x20
a01662cc 3a314ae3 movt r3, #0xa13a
a01662d0 00208de5 str r2, [sp]
a01662d4 08108de2 add r1, sp, #8
a01662d8 000093e5 ldr r0, [r3]
a01662dc 0c208de2 add r2, sp, #0xc
a01662e0 4030a0e3 mov r3, #0x40
a01662e4 3bd104eb bl #0xa029a7d8
a01662e8 000050e3 cmp r0, #0
a01662ec 690000ba blt #0xa0166498
a01662f0 031ba0e3 mov r1, #0xc00
a01662f4 10008de2 add r0, sp, #0x10
a01662f8 93b100eb bl #0xa019294c
a01662fc 000050e3 cmp r0, #0
a0166300 5400001a bne #0xa0166458
a0166304 031ba0e3 mov r1, #0xc00
a0166308 24008de2 add r0, sp, #0x24
a016630c cdb100eb bl #0xa0192a48
a0166310 000050e3 cmp r0, #0
a0166314 5600001a bne #0xa0166474
a0166318 000056e3 cmp r6, #0
a016631c 180000da ble #0xa0166384
a0166320 787702e3 movw r7, #0x2778
a0166324 8c419fe5 ldr r4, [pc, #0x18c]
a0166328 0050a0e1 mov r5, r0
a016632c 55704ae3 movt r7, #0xa055
a0166330 0b0000ea b #0xa0166364
a0166334 08009de5 ldr r0, [sp, #8]
a0166338 33ff2fe1 blx r3
a016633c 003050e2 subs r3, r0, #0
a0166340 2900001a bne #0xa01663ec
a0166344 0410a0e1 mov r1, r4
a0166348 015085e2 add r5, r5, #1
a016634c 24008de2 add r0, sp, #0x24
a0166350 08209de5 ldr r2, [sp, #8]
a0166354 05b200eb bl #0xa0192b70
a0166358 060055e1 cmp r5, r6
a016635c 644084e2 add r4, r4, #0x64
a0166360 0700000a beq #0xa0166384
a0166364 503094e5 ldr r3, [r4, #0x50]
a0166368 4010a0e3 mov r1, #0x40
a016636c 000053e3 cmp r3, #0
a0166370 efffff1a bne #0xa0166334
a0166374 08309de5 ldr r3, [sp, #8]
a0166378 000097e5 ldr r0, [r7]
a016637c 000083e5 str r0, [r3]
a0166380 efffffea b #0xa0166344
a0166384 8c1106e3 movw r1, #0x618c
a0166388 0020a0e3 mov r2, #0
a016638c 53104ae3 movt r1, #0xa053
a0166390 10008de2 add r0, sp, #0x10
a0166394 f7b100eb bl #0xa0192b78
a0166398 941106e3 movw r1, #0x6194
a016639c 0320a0e3 mov r2, #3
a01663a0 53104ae3 movt r1, #0xa053
a01663a4 10008de2 add r0, sp, #0x10
a01663a8 f2b100eb bl #0xa0192b78
a01663ac 9c1106e3 movw r1, #0x619c
a01663b0 24208de2 add r2, sp, #0x24
a01663b4 53104ae3 movt r1, #0xa053
a01663b8 10008de2 add r0, sp, #0x10
a01663bc 03b200eb bl #0xa0192bd0
a01663c0 10008de2 add r0, sp, #0x10
a01663c4 edb000eb bl #0xa0192780
a01663c8 10008de2 add r0, sp, #0x10
a01663cc 85b100eb bl #0xa01929e8
a01663d0 24008de2 add r0, sp, #0x24
a01663d4 cdb100eb bl #0xa0192b10
a01663d8 0c009de5 ldr r0, [sp, #0xc]
a01663dc cc5809eb bl #0xa03bc714
a01663e0 0000a0e3 mov r0, #0
a01663e4 3cd08de2 add sp, sp, #0x3c
a01663e8 f080bde8 pop {r4, r5, r6, r7, pc}
a01663ec 0522a0e1 lsl r2, r5, #4
a01663f0 c0e09fe5 ldr lr, [pc, #0xc0]
a01663f4 7c1003e3 movw r1, #0x307c
a01663f8 052182e0 add r2, r2, r5, lsl #2
a01663fc 6f104ae3 movt r1, #0xa06f
a0166400 0c0702e3 movw r0, #0x270c
a0166404 041091e5 ldr r1, [r1, #4]
a0166408 02c182e0 add ip, r2, r2, lsl #2
a016640c 55004ae3 movt r0, #0xa055
a0166410 0520a0e1 mov r2, r5
a0166414 0ec08ce0 add ip, ip, lr
a0166418 00c08de5 str ip, [sp]
a016641c 320305eb bl #0xa02a70ec
a0166420 0610e0e3 mvn r1, #6
a0166424 0300a0e3 mov r0, #3
a0166428 996503eb bl #0xa023fa94
a016642c 10008de2 add r0, sp, #0x10
a0166430 6cb100eb bl #0xa01929e8
a0166434 24008de2 add r0, sp, #0x24
a0166438 b4b100eb bl #0xa0192b10
a016643c 0c009de5 ldr r0, [sp, #0xc]
a0166440 b35809eb bl #0xa03bc714
a0166444 0000e0e3 mvn r0, #0
a0166448 3cd08de2 add sp, sp, #0x3c
a016644c f080bde8 pop {r4, r5, r6, r7, pc}
a0166450 69b9ffeb bl #0xa01549fc
a0166454 9affffea b #0xa01662c4
a0166458 0610e0e3 mvn r1, #6
a016645c 0300a0e3 mov r0, #3
a0166460 8b6503eb bl #0xa023fa94
a0166464 0c009de5 ldr r0, [sp, #0xc]
a0166468 a95809eb bl #0xa03bc714
a016646c 0000e0e3 mvn r0, #0
a0166470 dbffffea b #0xa01663e4
a0166474 0610e0e3 mvn r1, #6
a0166478 0300a0e3 mov r0, #3
a016647c 846503eb bl #0xa023fa94
a0166480 10008de2 add r0, sp, #0x10
a0166484 57b100eb bl #0xa01929e8
a0166488 0c009de5 ldr r0, [sp, #0xc]
a016648c a05809eb bl #0xa03bc714
a0166490 0000e0e3 mvn r0, #0
a0166494 d2ffffea b #0xa01663e4
a0166498 7c3003e3 movw r3, #0x307c
a016649c b00602e3 movw r0, #0x26b0
a01664a0 6f304ae3 movt r3, #0xa06f
a01664a4 55004ae3 movt r0, #0xa055
a01664a8 041093e5 ldr r1, [r3, #4]
a01664ac 0e0305eb bl #0xa02a70ec
a01664b0 0000e0e3 mvn r0, #0
a01664b4 caffffea b #0xa01663e4

FUNCTION 0xa01647fc
a01647fc f0412de9 push {r4, r5, r6, r7, r8, lr}
a0164800 0030a0e3 mov r3, #0
a0164804 48d04de2 sub sp, sp, #0x48
a0164808 4020a0e3 mov r2, #0x40
a016480c 0040a0e1 mov r4, r0
a0164810 0180a0e1 mov r8, r1
a0164814 08008de2 add r0, sp, #8
a0164818 0310a0e1 mov r1, r3
a016481c 04308de5 str r3, [sp, #4]
a0164820 71510efa blx #0xa04f8dec
a0164824 90faffeb bl #0xa016326c
a0164828 0070a0e1 mov r7, r0
a016482c 7ec2ffeb bl #0xa015522c
a0164830 000050e3 cmp r0, #0
a0164834 3a00001a bne #0xa0164924
a0164838 000058e3 cmp r8, #0
a016483c 00005413 cmpne r4, #0
a0164840 3900000a beq #0xa016492c
a0164844 0410a0e1 mov r1, r4
a0164848 04008de2 add r0, sp, #4
a016484c e88903eb bl #0xa0246ff4
a0164850 000050e3 cmp r0, #0
a0164854 3f00001a bne #0xa0164958
a0164858 9c1106e3 movw r1, #0x619c
a016485c 04009de5 ldr r0, [sp, #4]
a0164860 53104ae3 movt r1, #0xa053
a0164864 08208de2 add r2, sp, #8
a0164868 4030a0e3 mov r3, #0x40
a016486c 1f8a03eb bl #0xa02470f0
a0164870 000050e3 cmp r0, #0
a0164874 3e00001a bne #0xa0164974
a0164878 000057e3 cmp r7, #0
a016487c 14519fc5 ldrgt r5, [pc, #0x114]
a0164880 0040a0c1 movgt r4, r0
a0164884 030000ca bgt #0xa0164898
a0164888 170000ea b #0xa01648ec
a016488c 014084e2 add r4, r4, #1
a0164890 070054e1 cmp r4, r7
a0164894 1400000a beq #0xa01648ec
a0164898 0500a0e1 mov r0, r5
a016489c 08108de2 add r1, sp, #8
a01648a0 4a530efa blx #0xa04f95d0
a01648a4 006050e2 subs r6, r0, #0
a01648a8 645085e2 add r5, r5, #0x64
a01648ac f6ffff1a bne #0xa016488c
a01648b0 0432a0e1 lsl r3, r4, #4
a01648b4 0400a0e1 mov r0, r4
a01648b8 dc209fe5 ldr r2, [pc, #0xdc]
a01648bc 044183e0 add r4, r3, r4, lsl #2
a01648c0 044184e0 add r4, r4, r4, lsl #2
a01648c4 024084e0 add r4, r4, r2
a01648c8 043094e5 ldr r3, [r4, #4]
a01648cc 33ff2fe1 blx r3
a01648d0 04009de5 ldr r0, [sp, #4]
a01648d4 3d8a03eb bl #0xa02471d0
a01648d8 0800a0e1 mov r0, r8
a01648dc 8c5f09eb bl #0xa03bc714
a01648e0 0600a0e1 mov r0, r6
a01648e4 48d08de2 add sp, sp, #0x48
a01648e8 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a01648ec 7c3003e3 movw r3, #0x307c
a01648f0 f80201e3 movw r0, #0x12f8
a01648f4 6f304ae3 movt r3, #0xa06f
a01648f8 55004ae3 movt r0, #0xa055
a01648fc 041093e5 ldr r1, [r3, #4]
a0164900 0060e0e3 mvn r6, #0
a0164904 f80905eb bl #0xa02a70ec
a0164908 04009de5 ldr r0, [sp, #4]
a016490c 2f8a03eb bl #0xa02471d0
a0164910 0800a0e1 mov r0, r8
a0164914 7e5f09eb bl #0xa03bc714
a0164918 0600a0e1 mov r0, r6
a016491c 48d08de2 add sp, sp, #0x48
a0164920 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a0164924 34c0ffeb bl #0xa01549fc
a0164928 c2ffffea b #0xa0164838
a016492c 7c3003e3 movw r3, #0x307c
a0164930 ac0201e3 movw r0, #0x12ac
a0164934 6f304ae3 movt r3, #0xa06f
a0164938 55004ae3 movt r0, #0xa055
a016493c 041093e5 ldr r1, [r3, #4]
a0164940 0060e0e3 mvn r6, #0
a0164944 e80905eb bl #0xa02a70ec
a0164948 0610e0e3 mvn r1, #6
a016494c 0900a0e3 mov r0, #9
a0164950 4f6c03eb bl #0xa023fa94
a0164954 e1ffffea b #0xa01648e0
a0164958 0610e0e3 mvn r1, #6
a016495c 0900a0e3 mov r0, #9
a0164960 4b6c03eb bl #0xa023fa94
a0164964 0800a0e1 mov r0, r8
a0164968 0060e0e3 mvn r6, #0
a016496c 685f09eb bl #0xa03bc714
a0164970 daffffea b #0xa01648e0
a0164974 0610e0e3 mvn r1, #6
a0164978 0900a0e3 mov r0, #9
a016497c 446c03eb bl #0xa023fa94
a0164980 04009de5 ldr r0, [sp, #4]
a0164984 0060e0e3 mvn r6, #0
a0164988 108a03eb bl #0xa02471d0
a016498c 0800a0e1 mov r0, r8
a0164990 5f5f09eb bl #0xa03bc714
a0164994 d1ffffea b #0xa01648e0

FUNCTION 0xa01649a0
a01649a0 f0412de9 push {r4, r5, r6, r7, r8, lr}
a01649a4 0040a0e3 mov r4, #0
a01649a8 88d04de2 sub sp, sp, #0x88
a01649ac 4020a0e3 mov r2, #0x40
a01649b0 0050a0e1 mov r5, r0
a01649b4 0180a0e1 mov r8, r1
a01649b8 08008de2 add r0, sp, #8
a01649bc 0410a0e1 mov r1, r4
a01649c0 04408de5 str r4, [sp, #4]
a01649c4 08510efa blx #0xa04f8dec
a01649c8 0410a0e1 mov r1, r4
a01649cc 4020a0e3 mov r2, #0x40
a01649d0 48008de2 add r0, sp, #0x48
a01649d4 04510efa blx #0xa04f8dec
a01649d8 23faffeb bl #0xa016326c
a01649dc 0060a0e1 mov r6, r0
a01649e0 11c2ffeb bl #0xa015522c
a01649e4 040050e1 cmp r0, r4
a01649e8 4800001a bne #0xa0164b10
a01649ec 000058e3 cmp r8, #0
a01649f0 00005513 cmpne r5, #0
a01649f4 5a00000a beq #0xa0164b64
a01649f8 0510a0e1 mov r1, r5
a01649fc 04008de2 add r0, sp, #4
a0164a00 7b8903eb bl #0xa0246ff4
a0164a04 000050e3 cmp r0, #0
a0164a08 6000001a bne #0xa0164b90
a0164a0c 881d06e3 movw r1, #0x6d88
a0164a10 4030a0e3 mov r3, #0x40
a0164a14 04009de5 ldr r0, [sp, #4]
a0164a18 61104ae3 movt r1, #0xa061
a0164a1c 08208de2 add r2, sp, #8
a0164a20 b28903eb bl #0xa02470f0
a0164a24 000050e3 cmp r0, #0
a0164a28 7c300313 movwne r3, #0x307c
a0164a2c 60030113 movwne r0, #0x1360
a0164a30 6f304a13 movtne r3, #0xa06f
a0164a34 55004a13 movtne r0, #0xa055
a0164a38 3e00001a bne #0xa0164b38
a0164a3c 9c1106e3 movw r1, #0x619c
a0164a40 04009de5 ldr r0, [sp, #4]
a0164a44 53104ae3 movt r1, #0xa053
a0164a48 48208de2 add r2, sp, #0x48
a0164a4c 4030a0e3 mov r3, #0x40
a0164a50 a68903eb bl #0xa02470f0
a0164a54 007050e2 subs r7, r0, #0
a0164a58 3200001a bne #0xa0164b28
a0164a5c 000056e3 cmp r6, #0
a0164a60 44519fc5 ldrgt r5, [pc, #0x144]
a0164a64 0740a0c1 movgt r4, r7
a0164a68 030000ca bgt #0xa0164a7c
a0164a6c 220000ea b #0xa0164afc
a0164a70 014084e2 add r4, r4, #1
a0164a74 060054e1 cmp r4, r6
a0164a78 1f00000a beq #0xa0164afc
a0164a7c 0510a0e1 mov r1, r5
a0164a80 08008de2 add r0, sp, #8
a0164a84 d1520efa blx #0xa04f95d0
a0164a88 000050e3 cmp r0, #0
a0164a8c 645085e2 add r5, r5, #0x64
a0164a90 f6ffff1a bne #0xa0164a70
a0164a94 0432a0e1 lsl r3, r4, #4
a0164a98 a42f05e3 movw r2, #0x5fa4
a0164a9c 6a204ae3 movt r2, #0xa06a
a0164aa0 043183e0 add r3, r3, r4, lsl #2
a0164aa4 033183e0 add r3, r3, r3, lsl #2
a0164aa8 035082e0 add r5, r2, r3
a0164aac 603095e5 ldr r3, [r5, #0x60]
a0164ab0 000053e3 cmp r3, #0
a0164ab4 1700000a beq #0xa0164b18
a0164ab8 0010a0e1 mov r1, r0
a0164abc ca00a0e3 mov r0, #0xca
a0164ac0 b83effeb bl #0xa01345a8
a0164ac4 603095e5 ldr r3, [r5, #0x60]
a0164ac8 08008de2 add r0, sp, #8
a0164acc 48108de2 add r1, sp, #0x48
a0164ad0 33ff2fe1 blx r3
a0164ad4 0070a0e1 mov r7, r0
a0164ad8 040056e1 cmp r6, r4
a0164adc 060000da ble #0xa0164afc
a0164ae0 04009de5 ldr r0, [sp, #4]
a0164ae4 b98903eb bl #0xa02471d0
a0164ae8 0800a0e1 mov r0, r8
a0164aec 085f09eb bl #0xa03bc714
a0164af0 0700a0e1 mov r0, r7
a0164af4 88d08de2 add sp, sp, #0x88
a0164af8 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a0164afc 0200a0e3 mov r0, #2
a0164b00 0010e0e3 mvn r1, #0
a0164b04 e26b03eb bl #0xa023fa94
a0164b08 0070e0e3 mvn r7, #0
a0164b0c f3ffffea b #0xa0164ae0
a0164b10 b9bfffeb bl #0xa01549fc
a0164b14 b4ffffea b #0xa01649ec
a0164b18 0d10e0e3 mvn r1, #0xd
a0164b1c 0200a0e3 mov r0, #2
a0164b20 db6b03eb bl #0xa023fa94
a0164b24 ebffffea b #0xa0164ad8
a0164b28 7c3003e3 movw r3, #0x307c
a0164b2c a00301e3 movw r0, #0x13a0
a0164b30 6f304ae3 movt r3, #0xa06f
a0164b34 55004ae3 movt r0, #0xa055
a0164b38 041093e5 ldr r1, [r3, #4]
a0164b3c 6a0905eb bl #0xa02a70ec
a0164b40 0610e0e3 mvn r1, #6
a0164b44 0200a0e3 mov r0, #2
a0164b48 d16b03eb bl #0xa023fa94
a0164b4c 04009de5 ldr r0, [sp, #4]
a0164b50 9e8903eb bl #0xa02471d0
a0164b54 0800a0e1 mov r0, r8
a0164b58 ed5e09eb bl #0xa03bc714
a0164b5c 0000e0e3 mvn r0, #0
a0164b60 e3ffffea b #0xa0164af4
a0164b64 7c3003e3 movw r3, #0x307c
a0164b68 140301e3 movw r0, #0x1314
a0164b6c 6f304ae3 movt r3, #0xa06f
a0164b70 55004ae3 movt r0, #0xa055
a0164b74 041093e5 ldr r1, [r3, #4]
a0164b78 5b0905eb bl #0xa02a70ec
a0164b7c 0200a0e3 mov r0, #2
a0164b80 0610e0e3 mvn r1, #6
a0164b84 c26b03eb bl #0xa023fa94
a0164b88 0000e0e3 mvn r0, #0
a0164b8c d8ffffea b #0xa0164af4
a0164b90 0610e0e3 mvn r1, #6
a0164b94 0200a0e3 mov r0, #2
a0164b98 bd6b03eb bl #0xa023fa94
a0164b9c 0800a0e1 mov r0, r8
a0164ba0 db5e09eb bl #0xa03bc714
a0164ba4 0000e0e3 mvn r0, #0
a0164ba8 d1ffffea b #0xa0164af4

FUNCTION 0xa0164bb0
a0164bb0 f0402de9 push {r4, r5, r6, r7, lr}
a0164bb4 0040a0e3 mov r4, #0
a0164bb8 8cd04de2 sub sp, sp, #0x8c
a0164bbc 4020a0e3 mov r2, #0x40
a0164bc0 0050a0e1 mov r5, r0
a0164bc4 0170a0e1 mov r7, r1
a0164bc8 08008de2 add r0, sp, #8
a0164bcc 0410a0e1 mov r1, r4
a0164bd0 00408de5 str r4, [sp]
a0164bd4 04408de5 str r4, [sp, #4]
a0164bd8 83500efa blx #0xa04f8dec
a0164bdc 0410a0e1 mov r1, r4
a0164be0 4020a0e3 mov r2, #0x40
a0164be4 48008de2 add r0, sp, #0x48
a0164be8 7f500efa blx #0xa04f8dec
a0164bec 9ef9ffeb bl #0xa016326c
a0164bf0 0060a0e1 mov r6, r0
a0164bf4 8cc1ffeb bl #0xa015522c
a0164bf8 040050e1 cmp r0, r4
a0164bfc 6b00001a bne #0xa0164db0
a0164c00 000057e3 cmp r7, #0
a0164c04 00005513 cmpne r5, #0
a0164c08 6a00000a beq #0xa0164db8
a0164c0c 0510a0e1 mov r1, r5
a0164c10 0d00a0e1 mov r0, sp
a0164c14 f68803eb bl #0xa0246ff4
a0164c18 000050e3 cmp r0, #0
a0164c1c 7000001a bne #0xa0164de4
a0164c20 881d06e3 movw r1, #0x6d88
a0164c24 00009de5 ldr r0, [sp]
a0164c28 61104ae3 movt r1, #0xa061
a0164c2c 08208de2 add r2, sp, #8
a0164c30 4030a0e3 mov r3, #0x40
a0164c34 2d8903eb bl #0xa02470f0
a0164c38 004050e2 subs r4, r0, #0
a0164c3c 0100a013 movne r0, #1
a0164c40 0610e013 mvnne r1, #6
a0164c44 4800001a bne #0xa0164d6c
a0164c48 e41200e3 movw r1, #0x2e4
a0164c4c 08008de2 add r0, sp, #8
a0164c50 55104ae3 movt r1, #0xa055
a0164c54 5d520efa blx #0xa04f95d0
a0164c58 000050e3 cmp r0, #0
a0164c5c 3b00000a beq #0xa0164d50
a0164c60 000056e3 cmp r6, #0
a0164c64 a0519fc5 ldrgt r5, [pc, #0x1a0]
a0164c68 030000ca bgt #0xa0164c7c
a0164c6c 460000ea b #0xa0164d8c
a0164c70 014084e2 add r4, r4, #1
a0164c74 060054e1 cmp r4, r6
a0164c78 4300000a beq #0xa0164d8c
a0164c7c 0510a0e1 mov r1, r5
a0164c80 08008de2 add r0, sp, #8
a0164c84 51520efa blx #0xa04f95d0
a0164c88 000050e3 cmp r0, #0
a0164c8c 645085e2 add r5, r5, #0x64
a0164c90 f6ffff1a bne #0xa0164c70
a0164c94 0432a0e1 lsl r3, r4, #4
a0164c98 a42f05e3 movw r2, #0x5fa4
a0164c9c 6a204ae3 movt r2, #0xa06a
a0164ca0 043183e0 add r3, r3, r4, lsl #2
a0164ca4 033183e0 add r3, r3, r3, lsl #2
a0164ca8 033082e0 add r3, r2, r3
a0164cac 583093e5 ldr r3, [r3, #0x58]
a0164cb0 000053e3 cmp r3, #0
a0164cb4 5100000a beq #0xa0164e00
a0164cb8 48008de2 add r0, sp, #0x48
a0164cbc 4010a0e3 mov r1, #0x40
a0164cc0 33ff2fe1 blx r3
a0164cc4 040056e1 cmp r6, r4
a0164cc8 2f0000da ble #0xa0164d8c
a0164ccc 04008de2 add r0, sp, #4
a0164cd0 228903eb bl #0xa0247160
a0164cd4 8c1106e3 movw r1, #0x618c
a0164cd8 0020a0e3 mov r2, #0
a0164cdc 53104ae3 movt r1, #0xa053
a0164ce0 04009de5 ldr r0, [sp, #4]
a0164ce4 518903eb bl #0xa0247230
a0164ce8 941106e3 movw r1, #0x6194
a0164cec 0120a0e3 mov r2, #1
a0164cf0 53104ae3 movt r1, #0xa053
a0164cf4 04009de5 ldr r0, [sp, #4]
a0164cf8 4c8903eb bl #0xa0247230
a0164cfc 881d06e3 movw r1, #0x6d88
a0164d00 08208de2 add r2, sp, #8
a0164d04 61104ae3 movt r1, #0xa061
a0164d08 04009de5 ldr r0, [sp, #4]
a0164d0c 5f8903eb bl #0xa0247290
a0164d10 9c1106e3 movw r1, #0x619c
a0164d14 48208de2 add r2, sp, #0x48
a0164d18 53104ae3 movt r1, #0xa053
a0164d1c 04009de5 ldr r0, [sp, #4]
a0164d20 5a8903eb bl #0xa0247290
a0164d24 04009de5 ldr r0, [sp, #4]
a0164d28 7db600eb bl #0xa0192724
a0164d2c 00009de5 ldr r0, [sp]
a0164d30 268903eb bl #0xa02471d0
a0164d34 04009de5 ldr r0, [sp, #4]
a0164d38 248903eb bl #0xa02471d0
a0164d3c 0700a0e1 mov r0, r7
a0164d40 735e09eb bl #0xa03bc714
a0164d44 0000a0e3 mov r0, #0
a0164d48 8cd08de2 add sp, sp, #0x8c
a0164d4c f080bde8 pop {r4, r5, r6, r7, pc}
a0164d50 48008de2 add r0, sp, #0x48
a0164d54 4010a0e3 mov r1, #0x40
a0164d58 0fc4ffeb bl #0xa0155d9c
a0164d5c 000050e3 cmp r0, #0
a0164d60 d9ffff0a beq #0xa0164ccc
a0164d64 0100a0e3 mov r0, #1
a0164d68 0010e0e3 mvn r1, #0
a0164d6c 486b03eb bl #0xa023fa94
a0164d70 00009de5 ldr r0, [sp]
a0164d74 158903eb bl #0xa02471d0
a0164d78 0700a0e1 mov r0, r7
a0164d7c 645e09eb bl #0xa03bc714
a0164d80 0000e0e3 mvn r0, #0
a0164d84 8cd08de2 add sp, sp, #0x8c
a0164d88 f080bde8 pop {r4, r5, r6, r7, pc}
a0164d8c 7c3003e3 movw r3, #0x307c
a0164d90 2c0401e3 movw r0, #0x142c
a0164d94 6f304ae3 movt r3, #0xa06f
a0164d98 55004ae3 movt r0, #0xa055
a0164d9c 041093e5 ldr r1, [r3, #4]
a0164da0 d10805eb bl #0xa02a70ec
a0164da4 0100a0e3 mov r0, #1
a0164da8 0c10e0e3 mvn r1, #0xc
a0164dac eeffffea b #0xa0164d6c
a0164db0 11bfffeb bl #0xa01549fc
a0164db4 91ffffea b #0xa0164c00
a0164db8 7c3003e3 movw r3, #0x307c
a0164dbc e00301e3 movw r0, #0x13e0
a0164dc0 6f304ae3 movt r3, #0xa06f
a0164dc4 55004ae3 movt r0, #0xa055
a0164dc8 041093e5 ldr r1, [r3, #4]
a0164dcc c60805eb bl #0xa02a70ec
a0164dd0 0100a0e3 mov r0, #1
a0164dd4 0610e0e3 mvn r1, #6
a0164dd8 2d6b03eb bl #0xa023fa94
a0164ddc 0000e0e3 mvn r0, #0
a0164de0 d8ffffea b #0xa0164d48
a0164de4 0610e0e3 mvn r1, #6
a0164de8 0100a0e3 mov r0, #1
a0164dec 286b03eb bl #0xa023fa94
a0164df0 0700a0e1 mov r0, r7
a0164df4 465e09eb bl #0xa03bc714
a0164df8 0000e0e3 mvn r0, #0
a0164dfc d1ffffea b #0xa0164d48
a0164e00 0100a0e3 mov r0, #1
a0164e04 1610e0e3 mvn r1, #0x16
a0164e08 d7ffffea b #0xa0164d6c

FUNCTION 0xa01549fc
a01549fc f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0154a00 2cd04de2 sub sp, sp, #0x2c
a0154a04 183a00eb bl #0xa016326c
a0154a08 006050e2 subs r6, r0, #0
a0154a0c a44f05c3 movwgt r4, #0x5fa4
a0154a10 0050a0c3 movgt r5, #0
a0154a14 6a404ac3 movtgt r4, #0xa06a
a0154a18 030000ca bgt #0xa0154a2c
a0154a1c 110000ea b #0xa0154a68
a0154a20 060055e1 cmp r5, r6
a0154a24 644084e2 add r4, r4, #0x64
a0154a28 0e00000a beq #0xa0154a68
a0154a2c 5430d4e5 ldrb r3, [r4, #0x54]
a0154a30 015085e2 add r5, r5, #1
a0154a34 020013e3 tst r3, #2
a0154a38 f8ffff1a bne #0xa0154a20
a0154a3c 4c00d4e5 ldrb r0, [r4, #0x4c]
a0154a40 644084e2 add r4, r4, #0x64
a0154a44 141014e5 ldr r1, [r4, #-0x14]
a0154a48 798f00eb bl #0xa0178834
a0154a4c 0130d0e5 ldrb r3, [r0, #1]
a0154a50 060055e1 cmp r5, r6
a0154a54 603004e5 str r3, [r4, #-0x60]
a0154a58 0130d0e5 ldrb r3, [r0, #1]
a0154a5c 5331e0e7 ubfx r3, r3, #2, #1
a0154a60 1c3004e5 str r3, [r4, #-0x1c]
a0154a64 f0ffff1a bne #0xa0154a2c
a0154a68 f4739fe5 ldr r7, [pc, #0x3f4]
a0154a6c 0010a0e3 mov r1, #0
a0154a70 20030ce3 movw r0, #0xc320
a0154a74 0150a0e1 mov r5, r1
a0154a78 5f2da0e3 mov r2, #0x17c0
a0154a7c fb004ae3 movt r0, #0xa0fb
a0154a80 d9900efa blx #0xa04f8dec
a0154a84 5f6d87e2 add r6, r7, #0x17c0
a0154a88 0580a0e1 mov r8, r5
a0154a8c 7c4303eb bl #0xa0225884
a0154a90 05a0a0e1 mov sl, r5
a0154a94 00b0a0e1 mov fp, r0
a0154a98 030000ea b #0xa0154aac
a0154a9c 987087e2 add r7, r7, #0x98
a0154aa0 01a08ae2 add sl, sl, #1
a0154aa4 060057e1 cmp r7, r6
a0154aa8 6000000a beq #0xa0154c30
a0154aac 0a005be1 cmp fp, sl
a0154ab0 218047d5 strble r8, [r7, #-0x21]
a0154ab4 f8ffffda ble #0xa0154a9c
a0154ab8 0a00a0e1 mov r0, sl
a0154abc 8f4303eb bl #0xa0225900
a0154ac0 0040a0e1 mov r4, r0
a0154ac4 994303eb bl #0xa0225930
a0154ac8 0050a0e1 mov r5, r0
a0154acc 0400a0e1 mov r0, r4
a0154ad0 9a4303eb bl #0xa0225940
a0154ad4 10008de5 str r0, [sp, #0x10]
a0154ad8 0400a0e1 mov r0, r4
a0154adc 9b4303eb bl #0xa0225950
a0154ae0 14008de5 str r0, [sp, #0x14]
a0154ae4 0400a0e1 mov r0, r4
a0154ae8 a04303eb bl #0xa0225970
a0154aec 18008de5 str r0, [sp, #0x18]
a0154af0 0400a0e1 mov r0, r4
a0154af4 a54303eb bl #0xa0225990
a0154af8 1c008de5 str r0, [sp, #0x1c]
a0154afc 0400a0e1 mov r0, r4
a0154b00 aa4303eb bl #0xa02259b0
a0154b04 20008de5 str r0, [sp, #0x20]
a0154b08 0400a0e1 mov r0, r4
a0154b0c af4303eb bl #0xa02259d0
a0154b10 24008de5 str r0, [sp, #0x24]
a0154b14 0400a0e1 mov r0, r4
a0154b18 b44303eb bl #0xa02259f0
a0154b1c 0090a0e1 mov sb, r0
a0154b20 0400a0e1 mov r0, r4
a0154b24 bb4303eb bl #0xa0225a18
a0154b28 000055e3 cmp r5, #0
a0154b2c 08008de5 str r0, [sp, #8]
a0154b30 21504705 strbeq r5, [r7, #-0x21]
a0154b34 d8ffff0a beq #0xa0154a9c
a0154b38 0500a0e1 mov r0, r5
a0154b3c 201047e2 sub r1, r7, #0x20
a0154b40 c04b05eb bl #0xa02a7a48
a0154b44 1cc09de5 ldr ip, [sp, #0x1c]
a0154b48 7990ffe6 uxth sb, sb
a0154b4c 0130a0e3 mov r3, #1
a0154b50 254007e5 str r4, [r7, #-0x25]
a0154b54 402087e2 add r2, r7, #0x40
a0154b58 205087e2 add r5, r7, #0x20
a0154b5c 63c087e5 str ip, [r7, #0x63]
a0154b60 0010a0e3 mov r1, #0
a0154b64 20c09de5 ldr ip, [sp, #0x20]
a0154b68 0500a0e1 mov r0, r5
a0154b6c 213047e5 strb r3, [r7, #-0x21]
a0154b70 0c208de5 str r2, [sp, #0xc]
a0154b74 2020a0e3 mov r2, #0x20
a0154b78 67c087e5 str ip, [r7, #0x67]
a0154b7c 24c09de5 ldr ip, [sp, #0x24]
a0154b80 bf96c7e1 strh sb, [r7, #0x6f]
a0154b84 6bc087e5 str ip, [r7, #0x6b]
a0154b88 b8c0dde1 ldrh ip, [sp, #8]
a0154b8c b1c7c7e1 strh ip, [r7, #0x71]
a0154b90 95900efa blx #0xa04f8dec
a0154b94 0c009de5 ldr r0, [sp, #0xc]
a0154b98 0010a0e3 mov r1, #0
a0154b9c 2020a0e3 mov r2, #0x20
a0154ba0 91900efa blx #0xa04f8dec
a0154ba4 14309de5 ldr r3, [sp, #0x14]
a0154ba8 000053e3 cmp r3, #0
a0154bac 0200000a beq #0xa0154bbc
a0154bb0 0500a0e1 mov r0, r5
a0154bb4 0310a0e1 mov r1, r3
a0154bb8 24920efa blx #0xa04f9450
a0154bbc 18309de5 ldr r3, [sp, #0x18]
a0154bc0 000053e3 cmp r3, #0
a0154bc4 0200000a beq #0xa0154bd4
a0154bc8 0c009de5 ldr r0, [sp, #0xc]
a0154bcc 0310a0e1 mov r1, r3
a0154bd0 1e920efa blx #0xa04f9450
a0154bd4 10309de5 ldr r3, [sp, #0x10]
a0154bd8 000053e3 cmp r3, #0
a0154bdc 0200000a beq #0xa0154bec
a0154be0 0310a0e1 mov r1, r3
a0154be4 0700a0e1 mov r0, r7
a0154be8 18920efa blx #0xa04f9450
a0154bec 7990bfe6 sxth sb, sb
a0154bf0 000059e3 cmp sb, #0
a0154bf4 a8ffffda ble #0xa0154a9c
a0154bf8 08309de5 ldr r3, [sp, #8]
a0154bfc 6c030fe3 movw r0, #0xf36c
a0154c00 18250fe3 movw r2, #0xf518
a0154c04 00908de5 str sb, [sp]
a0154c08 54004ae3 movt r0, #0xa054
a0154c0c 54204ae3 movt r2, #0xa054
a0154c10 04308de5 str r3, [sp, #4]
a0154c14 4c10a0e3 mov r1, #0x4c
a0154c18 0730a0e1 mov r3, r7
a0154c1c 987087e2 add r7, r7, #0x98
a0154c20 314905eb bl #0xa02a70ec
a0154c24 060057e1 cmp r7, r6
a0154c28 01a08ae2 add sl, sl, #1
a0154c2c 9effff1a bne #0xa0154aac
a0154c30 e07a0de3 movw r7, #0xdae0
a0154c34 0040a0e3 mov r4, #0
a0154c38 fb704ae3 movt r7, #0xa0fb
a0154c3c b0530fe3 movw r5, #0xf3b0
a0154c40 0700a0e1 mov r0, r7
a0154c44 0410a0e1 mov r1, r4
a0154c48 262ea0e3 mov r2, #0x260
a0154c4c 0460a0e1 mov r6, r4
a0154c50 54504ae3 movt r5, #0xa054
a0154c54 64900efa blx #0xa04f8dec
a0154c58 0310a0e3 mov r1, #3
a0154c5c 0620a0e1 mov r2, r6
a0154c60 0200a0e3 mov r0, #2
a0154c64 0180a0e3 mov r8, #1
a0154c68 f78e00eb bl #0xa017884c
a0154c6c 0411a0e1 lsl r1, r4, #2
a0154c70 0432a0e1 lsl r3, r4, #4
a0154c74 000050e3 cmp r0, #0
a0154c78 032081e0 add r2, r1, r3
a0154c7c 022064e0 rsb r2, r4, r2
a0154c80 82e187e0 add lr, r7, r2, lsl #3
a0154c84 1500000a beq #0xa0154ce0
a0154c88 01c0d0e5 ldrb ip, [r0, #1]
a0154c8c 01001ce3 tst ip, #1
a0154c90 1200000a beq #0xa0154ce0
a0154c94 10c090e5 ldr ip, [r0, #0x10]
a0154c98 0480cee5 strb r8, [lr, #4]
a0154c9c 82c187e7 str ip, [r7, r2, lsl #3]
a0154ca0 102090e5 ldr r2, [r0, #0x10]
a0154ca4 030052e3 cmp r2, #3
a0154ca8 02f19f97 ldrls pc, [pc, r2, lsl #2]
a0154cac 630000ea b #0xa0154e40
a0154cc0 033081e0 add r3, r1, r3
a0154cc4 000095e5 ldr r0, [r5]
a0154cc8 033064e0 rsb r3, r4, r3
a0154ccc 0420d5e5 ldrb r2, [r5, #4]
a0154cd0 833187e0 add r3, r7, r3, lsl #3
a0154cd4 050083e5 str r0, [r3, #5]
a0154cd8 0920c3e5 strb r2, [r3, #9]
a0154cdc 014084e2 add r4, r4, #1
a0154ce0 016086e2 add r6, r6, #1
a0154ce4 040056e3 cmp r6, #4
a0154ce8 daffff1a bne #0xa0154c58
a0154cec 400d0de3 movw r0, #0xdd40
a0154cf0 0010a0e3 mov r1, #0
a0154cf4 5f2ea0e3 mov r2, #0x5f0
a0154cf8 fb004ae3 movt r0, #0xa0fb
a0154cfc 455080e2 add r5, r0, #0x45
a0154d00 909c06e3 movw sb, #0x6c90
a0154d04 38900efa blx #0xa04f8dec
a0154d08 35fc02eb bl #0xa0213de4
a0154d0c e04203eb bl #0xa0225894
a0154d10 24130fe3 movw r1, #0xf324
a0154d14 0060a0e1 mov r6, r0
a0154d18 b8030fe3 movw r0, #0xf3b8
a0154d1c 0630a0e1 mov r3, r6
a0154d20 54104ae3 movt r1, #0xa054
a0154d24 9020a0e3 mov r2, #0x90
a0154d28 54004ae3 movt r0, #0xa054
a0154d2c 5a904ae3 movt sb, #0xa05a
a0154d30 0040a0e3 mov r4, #0
a0154d34 01a0a0e3 mov sl, #1
a0154d38 eb4805eb bl #0xa02a70ec
a0154d3c 030000ea b #0xa0154d50
a0154d40 014084e2 add r4, r4, #1
a0154d44 985085e2 add r5, r5, #0x98
a0154d48 0a0054e3 cmp r4, #0xa
a0154d4c 1900000a beq #0xa0154db8
a0154d50 040056e1 cmp r6, r4
a0154d54 f9ffffda ble #0xa0154d40
a0154d58 21fc02eb bl #0xa0213de4
a0154d5c 0410a0e1 mov r1, r4
a0154d60 344303eb bl #0xa0225a38
a0154d64 0070a0e1 mov r7, r0
a0154d68 1dfc02eb bl #0xa0213de4
a0154d6c 0410a0e1 mov r1, r4
a0154d70 344303eb bl #0xa0225a48
a0154d74 0080a0e1 mov r8, r0
a0154d78 000057e2 subs r0, r7, #0
a0154d7c 401045e2 sub r1, r5, #0x40
a0154d80 41704505 strbeq r7, [r5, #-0x41]
a0154d84 edffff0a beq #0xa0154d40
a0154d88 2e4b05eb bl #0xa02a7a48
a0154d8c 000058e3 cmp r8, #0
a0154d90 0500a0e1 mov r0, r5
a0154d94 0810a011 movne r1, r8
a0154d98 0910a001 moveq r1, sb
a0154d9c ab910efa blx #0xa04f9450
a0154da0 454005e5 str r4, [r5, #-0x45]
a0154da4 014084e2 add r4, r4, #1
a0154da8 0a0054e3 cmp r4, #0xa
a0154dac 41a045e5 strb sl, [r5, #-0x41]
a0154db0 985085e2 add r5, r5, #0x98
a0154db4 e5ffff1a bne #0xa0154d50
a0154db8 30330ee3 movw r3, #0xe330
a0154dbc 0120a0e3 mov r2, #1
a0154dc0 fb304ae3 movt r3, #0xa0fb
a0154dc4 0000a0e3 mov r0, #0
a0154dc8 0020c3e5 strb r2, [r3]
a0154dcc 2cd08de2 add sp, sp, #0x2c
a0154dd0 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0154dd4 033081e0 add r3, r1, r3
a0154dd8 702c0de3 movw r2, #0xdc70
a0154ddc 033064e0 rsb r3, r4, r3
a0154de0 54204ae3 movt r2, #0xa054
a0154de4 000092e5 ldr r0, [r2]
a0154de8 833187e0 add r3, r7, r3, lsl #3
a0154dec b4c0d2e1 ldrh ip, [r2, #4]
a0154df0 0610d2e5 ldrb r1, [r2, #6]
a0154df4 050083e5 str r0, [r3, #5]
a0154df8 b9c0c3e1 strh ip, [r3, #9]
a0154dfc 0b10c3e5 strb r1, [r3, #0xb]
a0154e00 b5ffffea b #0xa0154cdc
a0154e04 442e0ce3 movw r2, #0xce44
a0154e08 033081e0 add r3, r1, r3
a0154e0c 54204ae3 movt r2, #0xa054
a0154e10 033064e0 rsb r3, r4, r3
a0154e14 000092e5 ldr r0, [r2]
a0154e18 833187e0 add r3, r7, r3, lsl #3
a0154e1c 0420d2e5 ldrb r2, [r2, #4]
a0154e20 050083e5 str r0, [r3, #5]
a0154e24 0920c3e5 strb r2, [r3, #9]
a0154e28 abffffea b #0xa0154cdc
a0154e2c 033081e0 add r3, r1, r3
a0154e30 3c2e0ce3 movw r2, #0xce3c
a0154e34 033064e0 rsb r3, r4, r3
a0154e38 54204ae3 movt r2, #0xa054
a0154e3c e8ffffea b #0xa0154de4
a0154e40 84250be3 movw r2, #0xb584
a0154e44 033081e0 add r3, r1, r3
a0154e48 63204ae3 movt r2, #0xa063
a0154e4c 033064e0 rsb r3, r4, r3
a0154e50 0300b2e8 ldm r2!, {r0, r1}
a0154e54 833187e0 add r3, r7, r3, lsl #3
a0154e58 050083e5 str r0, [r3, #5]
a0154e5c 091083e5 str r1, [r3, #9]
a0154e60 9dffffea b #0xa0154cdc

FUNCTION 0xa0148aac
a0148aac 000050e3 cmp r0, #0
a0148ab0 3900000a beq #0xa0148b9c
a0148ab4 000051e3 cmp r1, #0
a0148ab8 70402de9 push {r4, r5, r6, lr}
a0148abc 0030a013 movne r3, #0
a0148ac0 0150a0e1 mov r5, r1
a0148ac4 0040a0e1 mov r4, r0
a0148ac8 00308115 strne r3, [r1]
a0148acc e41a0ce3 movw r1, #0xcae4
a0148ad0 5c104ae3 movt r1, #0xa05c
a0148ad4 bdc20efa blx #0xa04f95d0
a0148ad8 000050e3 cmp r0, #0
a0148adc 0160a003 moveq r6, #1
a0148ae0 1f00001a bne #0xa0148b64
a0148ae4 d44c05e3 movw r4, #0x5cd4
a0148ae8 05414ae3 movt r4, #0xa105
a0148aec 003094e5 ldr r3, [r4]
a0148af0 3631d3e5 ldrb r3, [r3, #0x136]
a0148af4 060053e1 cmp r3, r6
a0148af8 1300000a beq #0xa0148b4c
a0148afc 155bffeb bl #0xa011f758
a0148b00 005050e2 subs r5, r0, #0
a0148b04 1e00001a bne #0xa0148b84
a0148b08 c359ffeb bl #0xa011f21c
a0148b0c 000050e3 cmp r0, #0
a0148b10 1d00000a beq #0xa0148b8c
a0148b14 003094e5 ldr r3, [r4]
a0148b18 3661c3e5 strb r6, [r3, #0x136]
a0148b1c ed0e01eb bl #0xa018c6d8
a0148b20 4c3303e3 movw r3, #0x334c
a0148b24 010056e3 cmp r6, #1
a0148b28 fb304ae3 movt r3, #0xa0fb
a0148b2c 9300a003 moveq r0, #0x93
a0148b30 9400a013 movne r0, #0x94
a0148b34 0510a0e1 mov r1, r5
a0148b38 183093e5 ldr r3, [r3, #0x18]
a0148b3c 0520a0e1 mov r2, r5
a0148b40 33ff2fe1 blx r3
a0148b44 0500a0e1 mov r0, r5
a0148b48 7080bde8 pop {r4, r5, r6, pc}
a0148b4c 000055e3 cmp r5, #0
a0148b50 fbffff0a beq #0xa0148b44
a0148b54 0130a0e3 mov r3, #1
a0148b58 0000a0e3 mov r0, #0
a0148b5c 003085e5 str r3, [r5]
a0148b60 7080bde8 pop {r4, r5, r6, pc}
a0148b64 f41a0ce3 movw r1, #0xcaf4
a0148b68 0400a0e1 mov r0, r4
a0148b6c 5c104ae3 movt r1, #0xa05c
a0148b70 96c20efa blx #0xa04f95d0
a0148b74 000050e3 cmp r0, #0
a0148b78 0500001a bne #0xa0148b94
a0148b7c 0060a0e1 mov r6, r0
a0148b80 d7ffffea b #0xa0148ae4
a0148b84 2300e0e3 mvn r0, #0x23
a0148b88 7080bde8 pop {r4, r5, r6, pc}
a0148b8c 1400e0e3 mvn r0, #0x14
a0148b90 7080bde8 pop {r4, r5, r6, pc}
a0148b94 1800e0e3 mvn r0, #0x18
a0148b98 7080bde8 pop {r4, r5, r6, pc}
a0148b9c 0000e0e3 mvn r0, #0
a0148ba0 1eff2fe1 bx lr

FUNCTION 0xa014eecc
a014eecc f0432de9 push {r4, r5, r6, r7, r8, sb, lr}
a014eed0 0040a0e3 mov r4, #0
a014eed4 9fdf4de2 sub sp, sp, #0x27c
a014eed8 0050a0e1 mov r5, r0
a014eedc 0160a0e1 mov r6, r1
a014eee0 0270a0e1 mov r7, r2
a014eee4 0410a0e1 mov r1, r4
a014eee8 8020a0e3 mov r2, #0x80
a014eeec 18008de2 add r0, sp, #0x18
a014eef0 1340cde5 strb r4, [sp, #0x13]
a014eef4 14408de5 str r4, [sp, #0x14]
a014eef8 bba70efa blx #0xa04f8dec
a014eefc 0410a0e1 mov r1, r4
a014ef00 98008de2 add r0, sp, #0x98
a014ef04 1e2ea0e3 mov r2, #0x1e0
a014ef08 b7a70efa blx #0xa04f8dec
a014ef0c 040055e1 cmp r5, r4
a014ef10 6c00000a beq #0xa014f0c8
a014ef14 0500a0e1 mov r0, r5
a014ef18 14108de2 add r1, sp, #0x14
a014ef1c e2e6ffeb bl #0xa0148aac
a014ef20 240070e3 cmn r0, #0x24
a014ef24 0080a0e1 mov r8, r0
a014ef28 3500000a beq #0xa014f004
a014ef2c 13008de2 add r0, sp, #0x13
a014ef30 18108de2 add r1, sp, #0x18
a014ef34 8020a0e3 mov r2, #0x80
a014ef38 c51000eb bl #0xa0153254
a014ef3c 000058e3 cmp r8, #0
a014ef40 003068b2 rsblt r3, r8, #0
a014ef44 7c9003a3 movwge sb, #0x307c
a014ef48 803083b3 orrlt r3, r3, #0x80
a014ef4c 7c9003b3 movwlt sb, #0x307c
a014ef50 083ca0a1 lslge r3, r8, #0x18
a014ef54 033ca0b1 lsllt r3, r3, #0x18
a014ef58 6f904aa3 movtge sb, #0xa06f
a014ef5c 6f904ab3 movtlt sb, #0xa06f
a014ef60 000050e3 cmp r0, #0
a014ef64 18108de2 add r1, sp, #0x18
a014ef68 004060b2 rsblt r4, r0, #0
a014ef6c 0048a0a1 lslge r4, r0, #0x10
a014ef70 804084b3 orrlt r4, r4, #0x80
a014ef74 1300dde5 ldrb r0, [sp, #0x13]
a014ef78 0448a0b1 lsllt r4, r4, #0x10
a014ef7c 034084e1 orr r4, r4, r3
a014ef80 14309de5 ldr r3, [sp, #0x14]
a014ef84 0420a0e1 mov r2, r4
a014ef88 fad5ffeb bl #0xa0144778
a014ef8c 0434a0e1 lsl r3, r4, #8
a014ef90 000054e3 cmp r4, #0
a014ef94 0020e0b3 mvnlt r2, #0
a014ef98 00008de5 str r0, [sp]
a014ef9c 0120a0a3 movge r2, #1
a014efa0 000053e3 cmp r3, #0
a014efa4 00e0e0b3 mvnlt lr, #0
a014efa8 01e0a0a3 movge lr, #1
a014efac 53cce6e7 ubfx ip, r3, #0x18, #7
a014efb0 544ce6e7 ubfx r4, r4, #0x18, #7
a014efb4 920404e0 mul r4, r2, r4
a014efb8 80000fe3 movw r0, #0xf080
a014efbc d8280ee3 movw r2, #0xe8d8
a014efc0 0c1099e5 ldr r1, [sb, #0xc]
a014efc4 9e0c0ce0 mul ip, lr, ip
a014efc8 14309de5 ldr r3, [sp, #0x14]
a014efcc 54004ae3 movt r0, #0xa054
a014efd0 54204ae3 movt r2, #0xa054
a014efd4 04408de5 str r4, [sp, #4]
a014efd8 08c08de5 str ip, [sp, #8]
a014efdc 426005eb bl #0xa02a70ec
a014efe0 000058e3 cmp r8, #0
a014efe4 0300001a bne #0xa014eff8
a014efe8 14309de5 ldr r3, [sp, #0x14]
a014efec 000053e3 cmp r3, #0
a014eff0 2c00000a beq #0xa014f0a8
a014eff4 0080a0e3 mov r8, #0
a014eff8 0800a0e1 mov r0, r8
a014effc 9fdf8de2 add sp, sp, #0x27c
a014f000 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a014f004 acca08e3 movw ip, #0x8aac
a014f008 542203e3 movw r2, #0x3254
a014f00c 783704e3 movw r3, #0x4778
a014f010 14c04ae3 movt ip, #0xa014
a014f014 14304ae3 movt r3, #0xa014
a014f018 15204ae3 movt r2, #0xa015
a014f01c 54e0a0e3 mov lr, #0x54
a014f020 0510a0e1 mov r1, r5
a014f024 0140a0e3 mov r4, #1
a014f028 98008de2 add r0, sp, #0x98
a014f02c 60328de5 str r3, [sp, #0x260]
a014f030 30c28de5 str ip, [sp, #0x230]
a014f034 44228de5 str r2, [sp, #0x244]
a014f038 a4e18de5 str lr, [sp, #0x1a4]
a014f03c 98718de5 str r7, [sp, #0x198]
a014f040 a0618de5 str r6, [sp, #0x1a0]
a014f044 9c418de5 str r4, [sp, #0x19c]
a014f048 00a90efa blx #0xa04f9450
a014f04c 0510a0e1 mov r1, r5
a014f050 6a0f8de2 add r0, sp, #0x1a8
a014f054 fda80efa blx #0xa04f9450
a014f058 98108de2 add r1, sp, #0x98
a014f05c 0d00a0e3 mov r0, #0xd
a014f060 eaeeffeb bl #0xa014ac10
a014f064 003050e2 subs r3, r0, #0
a014f068 e1ffff0a beq #0xa014eff4
a014f06c 7c9003e3 movw sb, #0x307c
a014f070 b0000fe3 movw r0, #0xf0b0
a014f074 6f904ae3 movt sb, #0xa06f
a014f078 d8280ee3 movw r2, #0xe8d8
a014f07c 0c1099e5 ldr r1, [sb, #0xc]
a014f080 54204ae3 movt r2, #0xa054
a014f084 54004ae3 movt r0, #0xa054
a014f088 0080e0e3 mvn r8, #0
a014f08c 166005eb bl #0xa02a70ec
a014f090 13008de2 add r0, sp, #0x13
a014f094 18108de2 add r1, sp, #0x18
a014f098 8020a0e3 mov r2, #0x80
a014f09c 6c1000eb bl #0xa0153254
a014f0a0 8134a0e3 mov r3, #0x81000000
a014f0a4 adffffea b #0xa014ef60
a014f0a8 0510a0e1 mov r1, r5
a014f0ac 0720a0e1 mov r2, r7
a014f0b0 0630a0e1 mov r3, r6
a014f0b4 5400a0e3 mov r0, #0x54
a014f0b8 d01900eb bl #0xa0155800
a014f0bc 0800a0e1 mov r0, r8
a014f0c0 9fdf8de2 add sp, sp, #0x27c
a014f0c4 f083bde8 pop {r4, r5, r6, r7, r8, sb, pc}
a014f0c8 1880e0e3 mvn r8, #0x18
a014f0cc c9ffffea b #0xa014eff8

FUNCTION 0xa01abd80
a01abd80 000050e3 cmp r0, #0
a01abd84 230000da ble #0xa01abe18
a01abd88 0130a0e1 mov r3, r1
a01abd8c 0010a0e3 mov r1, #0
a01abd90 10402de9 push {r4, lr}
a01abd94 0120a0e1 mov r2, r1
a01abd98 000093e5 ldr r0, [r3]
a01abd9c 083d0dfa blx #0xa04fb1c4
a01abda0 010050e3 cmp r0, #1
a01abda4 d43c05e3 movw r3, #0x5cd4
a01abda8 0d00000a beq #0xa01abde4
a01abdac 05314ae3 movt r3, #0xa105
a01abdb0 0040a0e3 mov r4, #0
a01abdb4 003093e5 ldr r3, [r3]
a01abdb8 3641c3e5 strb r4, [r3, #0x136]
a01abdbc 4582ffeb bl #0xa018c6d8
a01abdc0 4c3303e3 movw r3, #0x334c
a01abdc4 0410a0e1 mov r1, r4
a01abdc8 fb304ae3 movt r3, #0xa0fb
a01abdcc 0420a0e1 mov r2, r4
a01abdd0 183093e5 ldr r3, [r3, #0x18]
a01abdd4 9400a0e3 mov r0, #0x94
a01abdd8 33ff2fe1 blx r3
a01abddc 0400a0e1 mov r0, r4
a01abde0 1080bde8 pop {r4, pc}
a01abde4 05314ae3 movt r3, #0xa105
a01abde8 003093e5 ldr r3, [r3]
a01abdec 3601c3e5 strb r0, [r3, #0x136]
a01abdf0 3882ffeb bl #0xa018c6d8
a01abdf4 4c3303e3 movw r3, #0x334c
a01abdf8 0010a0e3 mov r1, #0
a01abdfc fb304ae3 movt r3, #0xa0fb
a01abe00 0120a0e1 mov r2, r1
a01abe04 183093e5 ldr r3, [r3, #0x18]
a01abe08 9300a0e3 mov r0, #0x93
a01abe0c 33ff2fe1 blx r3
a01abe10 0000a0e3 mov r0, #0
a01abe14 1080bde8 pop {r4, pc}
a01abe18 0000e0e3 mvn r0, #0
a01abe1c 1eff2fe1 bx lr

FUNCTION 0xa012d5bc
a012d5bc 38402de9 push {r3, r4, r5, lr}
a012d5c0 010050e3 cmp r0, #1
a012d5c4 48410ce3 movw r4, #0xc148
a012d5c8 fb404ae3 movt r4, #0xa0fb
a012d5cc 4950d4e5 ldrb r5, [r4, #0x49]
a012d5d0 1300000a beq #0xa012d624
a012d5d4 020050e3 cmp r0, #2
a012d5d8 0d00000a beq #0xa012d614
a012d5dc 000050e3 cmp r0, #0
a012d5e0 0530a011 movne r3, r5
a012d5e4 0500000a beq #0xa012d600
a012d5e8 0300a0e1 mov r0, r3
a012d5ec 0110a0e3 mov r1, #1
a012d5f0 cef500eb bl #0xa016ad30
a012d5f4 000050e3 cmp r0, #0
a012d5f8 4950c415 strbne r5, [r4, #0x49]
a012d5fc 3880bde8 pop {r3, r4, r5, pc}
a012d600 000055e3 cmp r5, #0
a012d604 0a00000a beq #0xa012d634
a012d608 0030a0e1 mov r3, r0
a012d60c 4900c4e5 strb r0, [r4, #0x49]
a012d610 f4ffffea b #0xa012d5e8
a012d614 013055e2 subs r3, r5, #1
a012d618 0130a013 movne r3, #1
a012d61c 4930c4e5 strb r3, [r4, #0x49]
a012d620 f0ffffea b #0xa012d5e8
a012d624 010055e3 cmp r5, #1
a012d628 4900c415 strbne r0, [r4, #0x49]
a012d62c 0030a011 movne r3, r0
a012d630 ecffff1a bne #0xa012d5e8
a012d634 0000e0e3 mvn r0, #0
a012d638 3880bde8 pop {r3, r4, r5, pc}

FUNCTION 0xa016ad30
a016ad30 38402de9 push {r3, r4, r5, lr}
a016ad34 682905e3 movw r2, #0x5968
a016ad38 0040a0e1 mov r4, r0
a016ad3c 580a04e3 movw r0, #0x4a58
a016ad40 0430a0e1 mov r3, r4
a016ad44 55204ae3 movt r2, #0xa055
a016ad48 0150a0e1 mov r5, r1
a016ad4c 55004ae3 movt r0, #0xa055
a016ad50 de1900e3 movw r1, #0x9de
a016ad54 e4f004eb bl #0xa02a70ec
a016ad58 d6ffffeb bl #0xa016acb8
a016ad5c 040050e1 cmp r0, r4
a016ad60 0030a0e1 mov r3, r0
a016ad64 0e00000a beq #0xa016ada4
a016ad68 9c310ce3 movw r3, #0xc19c
a016ad6c 8c0a04e3 movw r0, #0x4a8c
a016ad70 6a304ae3 movt r3, #0xa06a
a016ad74 682905e3 movw r2, #0x5968
a016ad78 844383e0 add r4, r3, r4, lsl #7
a016ad7c 55204ae3 movt r2, #0xa055
a016ad80 e51900e3 movw r1, #0x9e5
a016ad84 0430a0e1 mov r3, r4
a016ad88 55004ae3 movt r0, #0xa055
a016ad8c d6f004eb bl #0xa02a70ec
a016ad90 0400a0e1 mov r0, r4
a016ad94 0510a0e1 mov r1, r5
a016ad98 0120a0e3 mov r2, #1
a016ad9c 3840bde8 pop {r3, r4, r5, lr}
a016ada0 4990ffea b #0xa014eecc
a016ada4 640104e3 movw r0, #0x4164
a016ada8 682905e3 movw r2, #0x5968
a016adac 55204ae3 movt r2, #0xa055
a016adb0 e11900e3 movw r1, #0x9e1
a016adb4 55004ae3 movt r0, #0xa055
a016adb8 cbf004eb bl #0xa02a70ec
a016adbc 0100a0e3 mov r0, #1
a016adc0 3880bde8 pop {r3, r4, r5, pc}

FUNCTION 0xa01321c0
a01321c0 74cf9fe5 ldr ip, [pc, #0xf74]
a01321c4 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01321c8 0070a0e1 mov r7, r0
a01321cc 0150a0e1 mov r5, r1
a01321d0 0280a0e1 mov r8, r2
a01321d4 77df4de2 sub sp, sp, #0x1dc
a01321d8 0f00bce8 ldm ip!, {r0, r1, r2, r3}
a01321dc 30408de2 add r4, sp, #0x30
a01321e0 44e08de2 add lr, sp, #0x44
a01321e4 0f00a4e8 stm r4!, {r0, r1, r2, r3}
a01321e8 04309ce4 ldr r3, [ip], #4
a01321ec 003084e5 str r3, [r4]
a01321f0 0f00bce8 ldm ip!, {r0, r1, r2, r3}
a01321f4 00c09ce5 ldr ip, [ip]
a01321f8 0f00aee8 stm lr!, {r0, r1, r2, r3}
a01321fc 28008de2 add r0, sp, #0x28
a0132200 00c08ee5 str ip, [lr]
a0132204 fa5701eb bl #0xa01881f4
a0132208 28209de5 ldr r2, [sp, #0x28]
a013220c 1c300be3 movw r3, #0xb01c
a0132210 69304ae3 movt r3, #0xa069
a0132214 003093e5 ldr r3, [r3]
a0132218 002092e5 ldr r2, [r2]
a013221c 030052e1 cmp r2, r3
a0132220 6c00000a beq #0xa01323d8
a0132224 d4a404e3 movw sl, #0x44d4
a0132228 e09204e3 movw sb, #0x42e0
a013222c 6da04ae3 movt sl, #0xa06d
a0132230 6d904ae3 movt sb, #0xa06d
a0132234 00009ae5 ldr r0, [sl]
a0132238 22fbffeb bl #0xa0130ec8
a013223c 00309ae5 ldr r3, [sl]
a0132240 210057e3 cmp r7, #0x21
a0132244 00708ae5 str r7, [sl]
a0132248 003089e5 str r3, [sb]
a013224c 5b00000a beq #0xa01323c0
a0132250 08650be3 movw r6, #0xb508
a0132254 6c604ae3 movt r6, #0xa06c
a0132258 003096e5 ldr r3, [r6]
a013225c 013c83e3 orr r3, r3, #0x100
a0132260 003086e5 str r3, [r6]
a0132264 8732a0e1 lsl r3, r7, #5
a0132268 d4b600e3 movw fp, #0x6d4
a013226c 6bb04ae3 movt fp, #0xa06b
a0132270 873183e0 add r3, r3, r7, lsl #3
a0132274 033183e0 add r3, r3, r3, lsl #2
a0132278 024043e2 sub r4, r3, #2
a013227c c63083e2 add r3, r3, #0xc6
a0132280 0b4084e0 add r4, r4, fp
a0132284 0bb083e0 add fp, r3, fp
a0132288 020000ea b #0xa0132298
a013228c 0d4003eb bl #0xa02022c8
a0132290 0b0054e1 cmp r4, fp
a0132294 0300000a beq #0xa01322a8
a0132298 b230f4e1 ldrh r3, [r4, #2]!
a013229c 0200a0e3 mov r0, #2
a01322a0 001053e2 subs r1, r3, #0
a01322a4 f8ffff1a bne #0xa013228c
a01322a8 002099e5 ldr r2, [sb]
a01322ac 003096e5 ldr r3, [r6]
a01322b0 320052e3 cmp r2, #0x32
a01322b4 803083e3 orr r3, r3, #0x80
a01322b8 003086e5 str r3, [r6]
a01322bc 3500000a beq #0xa0132398
a01322c0 013047e2 sub r3, r7, #1
a01322c4 310053e3 cmp r3, #0x31
a01322c8 03f19f97 ldrls pc, [pc, r3, lsl #2]
a01322cc 950300ea b #0xa0133128
a0132398 00309ae5 ldr r3, [sl]
a013239c 320053e3 cmp r3, #0x32
a01323a0 c6ffff0a beq #0xa01322c0
a01323a4 d84c05e3 movw r4, #0x5cd8
a01323a8 05414ae3 movt r4, #0xa105
a01323ac d132d4e5 ldrb r3, [r4, #0x2d1]
a01323b0 000053e3 cmp r3, #0
a01323b4 c1ffff0a beq #0xa01322c0
a01323b8 d6faffeb bl #0xa0130f18
a01323bc bfffffea b #0xa01322c0
a01323c0 08650be3 movw r6, #0xb508
a01323c4 6c604ae3 movt r6, #0xa06c
a01323c8 003096e5 ldr r3, [r6]
a01323cc 013cc3e3 bic r3, r3, #0x100
a01323d0 003086e5 str r3, [r6]
a01323d4 a2ffffea b #0xa0132264
a01323d8 d43c05e3 movw r3, #0x5cd4
a01323dc 05314ae3 movt r3, #0xa105
a01323e0 003093e5 ldr r3, [r3]
a01323e4 bc30d3e5 ldrb r3, [r3, #0xbc]
a01323e8 000053e3 cmp r3, #0
a01323ec 8cffff0a beq #0xa0132224
a01323f0 d84c05e3 movw r4, #0x5cd8
a01323f4 05414ae3 movt r4, #0xa105
a01323f8 aa30d4e5 ldrb r3, [r4, #0xaa]
a01323fc 000053e3 cmp r3, #0
a0132400 87ffff1a bne #0xa0132224
a0132404 d4a404e3 movw sl, #0x44d4
a0132408 e09204e3 movw sb, #0x42e0
a013240c 6da04ae3 movt sl, #0xa06d
a0132410 6d904ae3 movt sb, #0xa06d
a0132414 00009ae5 ldr r0, [sl]
a0132418 0c70a0e3 mov r7, #0xc
a013241c a9faffeb bl #0xa0130ec8
a0132420 00309ae5 ldr r3, [sl]
a0132424 00708ae5 str r7, [sl]
a0132428 003089e5 str r3, [sb]
a013242c 87ffffea b #0xa0132250
a0132430 7d0f58e3 cmp r8, #0x1f4
a0132434 8006000a beq #0xa0133e3c
a0132438 8b0055e3 cmp r5, #0x8b
a013243c 00005513 cmpne r5, #0
a0132440 4106001a bne #0xa0133d4c
a0132444 0200a0e3 mov r0, #2
a0132448 d84003eb bl #0xa02027b0
a013244c 0000a0e3 mov r0, #0
a0132450 77df8de2 add sp, sp, #0x1dc
a0132454 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0132458 af0f58e3 cmp r8, #0x2bc
a013245c 0030a0e3 mov r3, #0
a0132460 d8308de5 str r3, [sp, #0xd8]
a0132464 dc308de5 str r3, [sp, #0xdc]
a0132468 e0308de5 str r3, [sp, #0xe0]
a013246c e4308de5 str r3, [sp, #0xe4]
a0132470 e8308de5 str r3, [sp, #0xe8]
a0132474 ec308de5 str r3, [sp, #0xec]
a0132478 e106000a beq #0xa0134004
a013247c be3200e3 movw r3, #0x2be
a0132480 030058e1 cmp r8, r3
a0132484 eeffff1a bne #0xa0132444
a0132488 0030e0e3 mvn r3, #0
a013248c bb1fa0e3 mov r1, #0x2ec
a0132490 ed2200e3 movw r2, #0x2ed
a0132494 d8008de2 add r0, sp, #0xd8
a0132498 dc108de5 str r1, [sp, #0xdc]
a013249c d8208de5 str r2, [sp, #0xd8]
a01324a0 e0308de5 str r3, [sp, #0xe0]
a01324a4 ec308de5 str r3, [sp, #0xec]
a01324a8 e8308de5 str r3, [sp, #0xe8]
a01324ac e4308de5 str r3, [sp, #0xe4]
a01324b0 79f9ffeb bl #0xa0130a9c
a01324b4 e2ffffea b #0xa0132444
a01324b8 d84c05e3 movw r4, #0x5cd8
a01324bc fde100eb bl #0xa016acb8
a01324c0 05414ae3 movt r4, #0xa105
a01324c4 0050a0e1 mov r5, r0
a01324c8 c02606e3 movw r2, #0x66c0
a01324cc 9c0702e3 movw r0, #0x279c
a01324d0 a631d4e5 ldrb r3, [r4, #0x1a6]
a01324d4 4d1803e3 movw r1, #0x384d
a01324d8 54004ae3 movt r0, #0xa054
a01324dc 54204ae3 movt r2, #0xa054
a01324e0 01d305eb bl #0xa02a70ec
a01324e4 a631d4e5 ldrb r3, [r4, #0x1a6]
a01324e8 0200a0e3 mov r0, #2
a01324ec 5d1100e3 movw r1, #0x15d
a01324f0 010013e3 tst r3, #1
a01324f4 cd05001a bne #0xa0133c30
a01324f8 48310ce3 movw r3, #0xc148
a01324fc fb304ae3 movt r3, #0xa0fb
a0132500 4030d3e5 ldrb r3, [r3, #0x40]
a0132504 010053e3 cmp r3, #1
a0132508 c805000a beq #0xa0133c30
a013250c 0b2200e3 movw r2, #0x20b
a0132510 2c3e03eb bl #0xa0201dc8
a0132514 0200a0e3 mov r0, #2
a0132518 5d1100e3 movw r1, #0x15d
a013251c 693f03eb bl #0xa02022c8
a0132520 d7b2ffeb bl #0xa011f084
a0132524 000050e3 cmp r0, #0
a0132528 a705001a bne #0xa0133bcc
a013252c e5b2ffeb bl #0xa011f0c8
a0132530 000050e3 cmp r0, #0
a0132534 a405001a bne #0xa0133bcc
a0132538 010055e3 cmp r5, #1
a013253c 5e1100e3 movw r1, #0x15e
a0132540 0200a0e3 mov r0, #2
a0132544 0a220003 movweq r2, #0x20a
a0132548 09220013 movwne r2, #0x209
a013254c 1d3e03eb bl #0xa0201dc8
a0132550 0200a0e3 mov r0, #2
a0132554 5e1100e3 movw r1, #0x15e
a0132558 5a3f03eb bl #0xa02022c8
a013255c 87bdffeb bl #0xa0121b80
a0132560 010050e3 cmp r0, #1
a0132564 5f1100e3 movw r1, #0x15f
a0132568 0200a0e3 mov r0, #2
a013256c 0906000a beq #0xa0133d98
a0132570 032200e3 movw r2, #0x203
a0132574 133e03eb bl #0xa0201dc8
a0132578 5f1100e3 movw r1, #0x15f
a013257c 0200a0e3 mov r0, #2
a0132580 503f03eb bl #0xa02022c8
a0132584 611100e3 movw r1, #0x161
a0132588 072200e3 movw r2, #0x207
a013258c 0200a0e3 mov r0, #2
a0132590 0c3e03eb bl #0xa0201dc8
a0132594 611100e3 movw r1, #0x161
a0132598 0200a0e3 mov r0, #2
a013259c 493f03eb bl #0xa02022c8
a01325a0 a7ffffea b #0xa0132444
a01325a4 0800a0e1 mov r0, r8
a01325a8 703700eb bl #0xa0140370
a01325ac a4ffffea b #0xa0132444
a01325b0 640058e3 cmp r8, #0x64
a01325b4 a2ffff0a beq #0xa0132444
a01325b8 0500a0e1 mov r0, r5
a01325bc 0810a0e1 mov r1, r8
a01325c0 8defffeb bl #0xa012e3fc
a01325c4 9effffea b #0xa0132444
a01325c8 640058e3 cmp r8, #0x64
a01325cc 9cffff0a beq #0xa0132444
a01325d0 48310ce3 movw r3, #0xc148
a01325d4 542e05e3 movw r2, #0x5e54
a01325d8 fb304ae3 movt r3, #0xa0fb
a01325dc 306c03e3 movw r6, #0x3c30
a01325e0 0010d3e5 ldrb r1, [r3]
a01325e4 650058e3 cmp r8, #0x65
a01325e8 14308de5 str r3, [sp, #0x14]
a01325ec 0030a0e3 mov r3, #0
a01325f0 d8308de5 str r3, [sp, #0xd8]
a01325f4 54204ae3 movt r2, #0xa054
a01325f8 fb604ae3 movt r6, #0xa0fb
a01325fc 0200a0e3 mov r0, #2
a0132600 0132a0e1 lsl r3, r1, #4
a0132604 004096e5 ldr r4, [r6]
a0132608 013143e0 sub r3, r3, r1, lsl #2
a013260c 037092e7 ldr r7, [r2, r3]
a0132610 d906000a beq #0xa013417c
a0132614 680058e3 cmp r8, #0x68
a0132618 7206000a beq #0xa0133fe8
a013261c ef1100e3 movw r1, #0x1ef
a0132620 8f2400e3 movw r2, #0x48f
a0132624 e73d03eb bl #0xa0201dc8
a0132628 0200a0e3 mov r0, #2
a013262c ef1100e3 movw r1, #0x1ef
a0132630 243f03eb bl #0xa02022c8
a0132634 690058e3 cmp r8, #0x69
a0132638 b506000a beq #0xa0134114
a013263c 006096e5 ldr r6, [r6]
a0132640 683b02e3 movw r3, #0x2b68
a0132644 6a304ae3 movt r3, #0xa06a
a0132648 660058e3 cmp r8, #0x66
a013264c 0320a0e1 mov r2, r3
a0132650 10308de5 str r3, [sp, #0x10]
a0132654 0632a0e1 lsl r3, r6, #4
a0132658 066183e0 add r6, r3, r6, lsl #2
a013265c 066186e0 add r6, r6, r6, lsl #2
a0132660 066082e0 add r6, r2, r6
a0132664 9e06000a beq #0xa01340e4
a0132668 f35100e3 movw r5, #0x1f3
a013266c 118200e3 movw r8, #0x211
a0132670 0510a0e1 mov r1, r5
a0132674 c72300e3 movw r2, #0x3c7
a0132678 0200a0e3 mov r0, #2
a013267c d13d03eb bl #0xa0201dc8
a0132680 0510a0e1 mov r1, r5
a0132684 0200a0e3 mov r0, #2
a0132688 015085e2 add r5, r5, #1
a013268c 0d3f03eb bl #0xa02022c8
a0132690 080055e1 cmp r5, r8
a0132694 f5ffff1a bne #0xa0132670
a0132698 230054e3 cmp r4, #0x23
a013269c 04f19f97 ldrls pc, [pc, r4, lsl #2]
a01326a0 67ffffea b #0xa0132444
a0132734 7feeffeb bl #0xa012e138
a0132738 41ffffea b #0xa0132444
a013273c e40b02e3 movw r0, #0x2be4
a0132740 e82d05e3 movw r2, #0x5de8
a0132744 54204ae3 movt r2, #0xa054
a0132748 0f1e03e3 movw r1, #0x3e0f
a013274c 54004ae3 movt r0, #0xa054
a0132750 65d205eb bl #0xa02a70ec
a0132754 3affffea b #0xa0132444
a0132758 48310ce3 movw r3, #0xc148
a013275c d84c05e3 movw r4, #0x5cd8
a0132760 fb304ae3 movt r3, #0xa0fb
a0132764 0120a0e3 mov r2, #1
a0132768 0060a0e3 mov r6, #0
a013276c 05414ae3 movt r4, #0xa105
a0132770 6920c3e5 strb r2, [r3, #0x69]
a0132774 58608de5 str r6, [sp, #0x58]
a0132778 d8608de5 str r6, [sp, #0xd8]
a013277c 19faffeb bl #0xa0130fe8
a0132780 c252d4e5 ldrb r5, [r4, #0x2c2]
a0132784 020055e3 cmp r5, #2
a0132788 3505000a beq #0xa0133c64
a013278c 0200a0e3 mov r0, #2
a0132790 9e10a0e3 mov r1, #0x9e
a0132794 8a3f03eb bl #0xa02025c4
a0132798 0800a0e1 mov r0, r8
a013279c f7f9ffeb bl #0xa0130f80
a01327a0 27ffffea b #0xa0132444
a01327a4 d84c05e3 movw r4, #0x5cd8
a01327a8 05414ae3 movt r4, #0xa105
a01327ac 4830d4e5 ldrb r3, [r4, #0x48]
a01327b0 000053e3 cmp r3, #0
a01327b4 22ffff1a bne #0xa0132444
a01327b8 9910a0e3 mov r1, #0x99
a01327bc 0200a0e3 mov r0, #2
a01327c0 7f3f03eb bl #0xa02025c4
a01327c4 0200a0e3 mov r0, #2
a01327c8 9a10a0e3 mov r1, #0x9a
a01327cc 7c3f03eb bl #0xa02025c4
a01327d0 0130a0e3 mov r3, #1
a01327d4 4830c4e5 strb r3, [r4, #0x48]
a01327d8 19ffffea b #0xa0132444
a01327dc 0c3b05e3 movw r3, #0x5b0c
a01327e0 9110a0e3 mov r1, #0x91
a01327e4 54304ae3 movt r3, #0xa054
a01327e8 0200a0e3 mov r0, #2
a01327ec 052193e7 ldr r2, [r3, r5, lsl #2]
a01327f0 743d03eb bl #0xa0201dc8
a01327f4 9110a0e3 mov r1, #0x91
a01327f8 0200a0e3 mov r0, #2
a01327fc b13e03eb bl #0xa02022c8
a0132800 0fffffea b #0xa0132444
a0132804 0100a0e3 mov r0, #1
a0132808 0010a0e3 mov r1, #0
a013280c e4fdffeb bl #0xa0131fa4
a0132810 0bffffea b #0xa0132444
a0132814 d84c05e3 movw r4, #0x5cd8
a0132818 762f8de2 add r2, sp, #0x1d8
a013281c 05414ae3 movt r4, #0xa105
a0132820 0b1da0e3 mov r1, #0x2c0
a0132824 b232d4e5 ldrb r3, [r4, #0x2b2]
a0132828 0200a0e3 mov r0, #2
a013282c 033182e0 add r3, r2, r3, lsl #2
a0132830 a82113e5 ldr r2, [r3, #-0x1a8]
a0132834 633d03eb bl #0xa0201dc8
a0132838 0b1da0e3 mov r1, #0x2c0
a013283c 0200a0e3 mov r0, #2
a0132840 a03e03eb bl #0xa02022c8
a0132844 b232d4e5 ldrb r3, [r4, #0x2b2]
a0132848 c31200e3 movw r1, #0x2c3
a013284c 0200a0e3 mov r0, #2
a0132850 013083e2 add r3, r3, #1
a0132854 7330efe6 uxtb r3, r3
a0132858 040053e3 cmp r3, #4
a013285c b232c4e5 strb r3, [r4, #0x2b2]
a0132860 2a230093 movwls r2, #0x32a
a0132864 29230083 movwhi r2, #0x329
a0132868 563d03eb bl #0xa0201dc8
a013286c c31200e3 movw r1, #0x2c3
a0132870 0200a0e3 mov r0, #2
a0132874 933e03eb bl #0xa02022c8
a0132878 f1feffea b #0xa0132444
a013287c 7b2300e3 movw r2, #0x37b
a0132880 af1fa0e3 mov r1, #0x2bc
a0132884 0200a0e3 mov r0, #2
a0132888 d84c05e3 movw r4, #0x5cd8
a013288c 4d3d03eb bl #0xa0201dc8
a0132890 05414ae3 movt r4, #0xa105
a0132894 af1fa0e3 mov r1, #0x2bc
a0132898 0200a0e3 mov r0, #2
a013289c 893e03eb bl #0xa02022c8
a01328a0 b232d4e5 ldrb r3, [r4, #0x2b2]
a01328a4 762f8de2 add r2, sp, #0x1d8
a01328a8 bb1200e3 movw r1, #0x2bb
a01328ac 0200a0e3 mov r0, #2
a01328b0 033182e0 add r3, r2, r3, lsl #2
a01328b4 a82113e5 ldr r2, [r3, #-0x1a8]
a01328b8 423d03eb bl #0xa0201dc8
a01328bc bb1200e3 movw r1, #0x2bb
a01328c0 0200a0e3 mov r0, #2
a01328c4 7f3e03eb bl #0xa02022c8
a01328c8 b232d4e5 ldrb r3, [r4, #0x2b2]
a01328cc 762f8de2 add r2, sp, #0x1d8
a01328d0 bd1200e3 movw r1, #0x2bd
a01328d4 0200a0e3 mov r0, #2
a01328d8 033182e0 add r3, r2, r3, lsl #2
a01328dc 942113e5 ldr r2, [r3, #-0x194]
a01328e0 383d03eb bl #0xa0201dc8
a01328e4 bd1200e3 movw r1, #0x2bd
a01328e8 0200a0e3 mov r0, #2
a01328ec 753e03eb bl #0xa02022c8
a01328f0 5e2300e3 movw r2, #0x35e
a01328f4 be1200e3 movw r1, #0x2be
a01328f8 0200a0e3 mov r0, #2
a01328fc 313d03eb bl #0xa0201dc8
a0132900 be1200e3 movw r1, #0x2be
a0132904 0200a0e3 mov r0, #2
a0132908 6e3e03eb bl #0xa02022c8
a013290c 74120de3 movw r1, #0xd274
a0132910 0020a0e3 mov r2, #0
a0132914 13104ae3 movt r1, #0xa013
a0132918 0500a0e3 mov r0, #5
a013291c dad002eb bl #0xa01e6c8c
a0132920 c7feffea b #0xa0132444
a0132924 d84c05e3 movw r4, #0x5cd8
a0132928 762f8de2 add r2, sp, #0x1d8
a013292c 05414ae3 movt r4, #0xa105
a0132930 b51200e3 movw r1, #0x2b5
a0132934 b232d4e5 ldrb r3, [r4, #0x2b2]
a0132938 0200a0e3 mov r0, #2
a013293c 033182e0 add r3, r2, r3, lsl #2
a0132940 a82113e5 ldr r2, [r3, #-0x1a8]
a0132944 1f3d03eb bl #0xa0201dc8
a0132948 b51200e3 movw r1, #0x2b5
a013294c 0200a0e3 mov r0, #2
a0132950 5c3e03eb bl #0xa02022c8
a0132954 b232d4e5 ldrb r3, [r4, #0x2b2]
a0132958 762f8de2 add r2, sp, #0x1d8
a013295c ae1fa0e3 mov r1, #0x2b8
a0132960 0200a0e3 mov r0, #2
a0132964 033182e0 add r3, r2, r3, lsl #2
a0132968 942113e5 ldr r2, [r3, #-0x194]
a013296c 153d03eb bl #0xa0201dc8
a0132970 ae1fa0e3 mov r1, #0x2b8
a0132974 0200a0e3 mov r0, #2
a0132978 523e03eb bl #0xa02022c8
a013297c b0feffea b #0xa0132444
a0132980 347b0fe3 movw r7, #0xfb34
a0132984 646008e3 movw r6, #0x8064
a0132988 53704ae3 movt r7, #0xa053
a013298c fb604ae3 movt r6, #0xa0fb
a0132990 0750a0e1 mov r5, r7
a0132994 0680a0e1 mov r8, r6
a0132998 0040a0e3 mov r4, #0
a013299c 090000ea b #0xa01329c8
a01329a0 041095e5 ldr r1, [r5, #4]
a01329a4 0c2095e5 ldr r2, [r5, #0xc]
a01329a8 063d03eb bl #0xa0201dc8
a01329ac 0200a0e3 mov r0, #2
a01329b0 041095e5 ldr r1, [r5, #4]
a01329b4 433e03eb bl #0xa02022c8
a01329b8 014084e2 add r4, r4, #1
a01329bc 145085e2 add r5, r5, #0x14
a01329c0 0a0054e3 cmp r4, #0xa
a01329c4 4304000a beq #0xa0133ad8
a01329c8 0030d6e5 ldrb r3, [r6]
a01329cc 0200a0e3 mov r0, #2
a01329d0 040053e1 cmp r3, r4
a01329d4 f1ffff1a bne #0xa01329a0
a01329d8 0432a0e1 lsl r3, r4, #4
a01329dc 043183e0 add r3, r3, r4, lsl #2
a01329e0 033087e0 add r3, r7, r3
a01329e4 041093e5 ldr r1, [r3, #4]
a01329e8 102093e5 ldr r2, [r3, #0x10]
a01329ec f53c03eb bl #0xa0201dc8
a01329f0 0020d8e5 ldrb r2, [r8]
a01329f4 0200a0e3 mov r0, #2
a01329f8 0232a0e1 lsl r3, r2, #4
a01329fc 023183e0 add r3, r3, r2, lsl #2
a0132a00 033087e0 add r3, r7, r3
a0132a04 041093e5 ldr r1, [r3, #4]
a0132a08 2e3e03eb bl #0xa02022c8
a0132a0c e9ffffea b #0xa01329b8
a0132a10 0100a0e3 mov r0, #1
a0132a14 0010a0e3 mov r1, #0
a0132a18 b7fdffeb bl #0xa01320fc
a0132a1c 88feffea b #0xa0132444
a0132a20 640058e3 cmp r8, #0x64
a0132a24 86feff0a beq #0xa0132444
a0132a28 0500a0e1 mov r0, r5
a0132a2c 0810a0e1 mov r1, r8
a0132a30 7f1100eb bl #0xa0137034
a0132a34 82feffea b #0xa0132444
a0132a38 640058e3 cmp r8, #0x64
a0132a3c 80feff0a beq #0xa0132444
a0132a40 48310ce3 movw r3, #0xc148
a0132a44 54ee05e3 movw lr, #0x5e54
a0132a48 fb304ae3 movt r3, #0xa0fb
a0132a4c 54e04ae3 movt lr, #0xa054
a0132a50 0040d3e5 ldrb r4, [r3]
a0132a54 cc0702e3 movw r0, #0x27cc
a0132a58 14308de5 str r3, [sp, #0x14]
a0132a5c 6c2a05e3 movw r2, #0x5a6c
a0132a60 0060a0e3 mov r6, #0
a0132a64 04508de5 str r5, [sp, #4]
a0132a68 0430a0e1 mov r3, r4
a0132a6c 54004ae3 movt r0, #0xa054
a0132a70 04c2a0e1 lsl ip, r4, #4
a0132a74 54204ae3 movt r2, #0xa054
a0132a78 1b1601e3 movw r1, #0x161b
a0132a7c 58608de5 str r6, [sp, #0x58]
a0132a80 04c14ce0 sub ip, ip, r4, lsl #2
a0132a84 2760cde5 strb r6, [sp, #0x27]
a0132a88 0c408ee0 add r4, lr, ip
a0132a8c 0ca09ee7 ldr sl, [lr, ip]
a0132a90 049094e5 ldr sb, [r4, #4]
a0132a94 086094e5 ldr r6, [r4, #8]
a0132a98 00908de5 str sb, [sp]
a0132a9c 92d105eb bl #0xa02a70ec
a0132aa0 690058e3 cmp r8, #0x69
a0132aa4 2b05000a beq #0xa0133f58
a0132aa8 6b0058e3 cmp r8, #0x6b
a0132aac 0a05000a beq #0xa0133edc
a0132ab0 6c0058e3 cmp r8, #0x6c
a0132ab4 6b05000a beq #0xa0134068
a0132ab8 650058e3 cmp r8, #0x65
a0132abc 0e06000a beq #0xa01342fc
a0132ac0 000059e3 cmp sb, #0
a0132ac4 668048e2 sub r8, r8, #0x66
a0132ac8 188f6fe1 clz r8, r8
a0132acc a882a0e1 lsr r8, r8, #5
a0132ad0 0080a0d3 movle r8, #0
a0132ad4 000058e3 cmp r8, #0
a0132ad8 2906001a bne #0xa0134384
a0132adc 010059e3 cmp sb, #1
a0132ae0 160600da ble #0xa0134340
a0132ae4 0a50a0e1 mov r5, sl
a0132ae8 18a08de5 str sl, [sp, #0x18]
a0132aec 14a09de5 ldr sl, [sp, #0x14]
a0132af0 bd8100e3 movw r8, #0x1bd
a0132af4 ed4400e3 movw r4, #0x4ed
a0132af8 6f3f89e2 add r3, sb, #0x1bc
a0132afc 10308de5 str r3, [sp, #0x10]
a0132b00 243095e5 ldr r3, [r5, #0x24]
a0132b04 120053e3 cmp r3, #0x12
a0132b08 03f19f97 ldrls pc, [pc, r3, lsl #2]
a0132b0c 9a0100ea b #0xa013317c
a0132b5c 640058e3 cmp r8, #0x64
a0132b60 37feff0a beq #0xa0132444
a0132b64 64220ce3 movw r2, #0xc264
a0132b68 0030a0e3 mov r3, #0
a0132b6c fb204ae3 movt r2, #0xa0fb
a0132b70 e09c05e3 movw sb, #0x5ce0
a0132b74 002092e5 ldr r2, [r2]
a0132b78 3c7c05e3 movw r7, #0x5c3c
a0132b7c 760f8de2 add r0, sp, #0x1d8
a0132b80 0340a0e1 mov r4, r3
a0132b84 54904ae3 movt sb, #0xa054
a0132b88 54704ae3 movt r7, #0xa054
a0132b8c 10208de5 str r2, [sp, #0x10]
a0132b90 d8a08de2 add sl, sp, #0xd8
a0132b94 022180e0 add r2, r0, r2, lsl #2
a0132b98 0110a0e3 mov r1, #1
a0132b9c d8308de5 str r3, [sp, #0xd8]
a0132ba0 dc308de5 str r3, [sp, #0xdc]
a0132ba4 e0308de5 str r3, [sp, #0xe0]
a0132ba8 e4308de5 str r3, [sp, #0xe4]
a0132bac e8308de5 str r3, [sp, #0xe8]
a0132bb0 ec308de5 str r3, [sp, #0xec]
a0132bb4 f0308de5 str r3, [sp, #0xf0]
a0132bb8 f4308de5 str r3, [sp, #0xf4]
a0132bbc f8308de5 str r3, [sp, #0xf8]
a0132bc0 fc308de5 str r3, [sp, #0xfc]
a0132bc4 00318de5 str r3, [sp, #0x100]
a0132bc8 04318de5 str r3, [sp, #0x104]
a0132bcc 001102e5 str r1, [r2, #-0x100]
a0132bd0 04609ae4 ldr r6, [sl], #4
a0132bd4 843084e0 add r3, r4, r4, lsl #1
a0132bd8 67bf84e2 add fp, r4, #0x19c
a0132bdc 02b08be2 add fp, fp, #2
a0132be0 195e84e2 add r5, r4, #0x190
a0132be4 066083e0 add r6, r3, r6
a0132be8 0b10a0e1 mov r1, fp
a0132bec 062199e7 ldr r2, [sb, r6, lsl #2]
a0132bf0 0200a0e3 mov r0, #2
a0132bf4 733c03eb bl #0xa0201dc8
a0132bf8 025085e2 add r5, r5, #2
a0132bfc 0b10a0e1 mov r1, fp
a0132c00 0200a0e3 mov r0, #2
a0132c04 014084e2 add r4, r4, #1
a0132c08 ae3d03eb bl #0xa02022c8
a0132c0c 062197e7 ldr r2, [r7, r6, lsl #2]
a0132c10 0510a0e1 mov r1, r5
a0132c14 0200a0e3 mov r0, #2
a0132c18 6a3c03eb bl #0xa0201dc8
a0132c1c 0510a0e1 mov r1, r5
a0132c20 0200a0e3 mov r0, #2
a0132c24 a73d03eb bl #0xa02022c8
a0132c28 0c0054e3 cmp r4, #0xc
a0132c2c e7ffff1a bne #0xa0132bd0
a0132c30 690058e3 cmp r8, #0x69
a0132c34 02feff0a beq #0xa0132444
a0132c38 10209de5 ldr r2, [sp, #0x10]
a0132c3c 073042e2 sub r3, r2, #7
a0132c40 030052e3 cmp r2, #3
a0132c44 01005313 cmpne r3, #1
a0132c48 0100a093 movls r0, #1
a0132c4c 0000a083 movhi r0, #0
a0132c50 8100e093 mvnls r0, #0x81
a0132c54 36f0ffeb bl #0xa012ed34
a0132c58 920100e3 movw r0, #0x192
a0132c5c 911100e3 movw r1, #0x191
a0132c60 b6e8ffeb bl #0xa012cf40
a0132c64 f6fdffea b #0xa0132444
a0132c68 48310ce3 movw r3, #0xc148
a0132c6c 64220ce3 movw r2, #0xc264
a0132c70 fb304ae3 movt r3, #0xa0fb
a0132c74 00c0a0e3 mov ip, #0
a0132c78 0010d3e5 ldrb r1, [r3]
a0132c7c fb204ae3 movt r2, #0xa0fb
a0132c80 0800a0e1 mov r0, r8
a0132c84 69c0c3e5 strb ip, [r3, #0x69]
a0132c88 001082e5 str r1, [r2]
a0132c8c 4ffbffeb bl #0xa01319d0
a0132c90 ebfdffea b #0xa0132444
a0132c94 0800a0e1 mov r0, r8
a0132c98 8e3400eb bl #0xa013fed8
a0132c9c e8fdffea b #0xa0132444
a0132ca0 050055e3 cmp r5, #5
a0132ca4 0900000a beq #0xa0132cd0
a0132ca8 660058e3 cmp r8, #0x66
a0132cac 69005813 cmpne r8, #0x69
a0132cb0 e3fdff0a beq #0xa0132444
a0132cb4 461100e3 movw r1, #0x146
a0132cb8 0200a0e3 mov r0, #2
a0132cbc 012100e3 movw r2, #0x101
a0132cc0 403c03eb bl #0xa0201dc8
a0132cc4 0200a0e3 mov r0, #2
a0132cc8 461100e3 movw r1, #0x146
a0132ccc 7d3d03eb bl #0xa02022c8
a0132cd0 471100e3 movw r1, #0x147
a0132cd4 fc20a0e3 mov r2, #0xfc
a0132cd8 0200a0e3 mov r0, #2
a0132cdc 393c03eb bl #0xa0201dc8
a0132ce0 471100e3 movw r1, #0x147
a0132ce4 0200a0e3 mov r0, #2
a0132ce8 763d03eb bl #0xa02022c8
a0132cec d4fdffea b #0xa0132444
a0132cf0 640058e3 cmp r8, #0x64
a0132cf4 d2fdff0a beq #0xa0132444
a0132cf8 48410ce3 movw r4, #0xc148
a0132cfc 580c02e3 movw r0, #0x2c58
a0132d00 fb404ae3 movt r4, #0xa0fb
a0132d04 a82806e3 movw r2, #0x68a8
a0132d08 3e30d4e5 ldrb r3, [r4, #0x3e]
a0132d0c 54004ae3 movt r0, #0xa054
a0132d10 54204ae3 movt r2, #0xa054
a0132d14 e11203e3 movw r1, #0x32e1
a0132d18 f3d005eb bl #0xa02a70ec
a0132d1c 3e40d4e5 ldrb r4, [r4, #0x3e]
a0132d20 000054e3 cmp r4, #0
a0132d24 2804000a beq #0xa0133dcc
a0132d28 0040a0e3 mov r4, #0
a0132d2c 3f1100e3 movw r1, #0x13f
a0132d30 00408de5 str r4, [sp]
a0132d34 aa20a0e3 mov r2, #0xaa
a0132d38 6830a0e3 mov r3, #0x68
a0132d3c 0200a0e3 mov r0, #2
a0132d40 e23c03eb bl #0xa02020d0
a0132d44 00408de5 str r4, [sp]
a0132d48 051da0e3 mov r1, #0x140
a0132d4c aa20a0e3 mov r2, #0xaa
a0132d50 9b30a0e3 mov r3, #0x9b
a0132d54 0200a0e3 mov r0, #2
a0132d58 dc3c03eb bl #0xa02020d0
a0132d5c b8fdffea b #0xa0132444
a0132d60 41edffeb bl #0xa012e26c
a0132d64 b6fdffea b #0xa0132444
a0132d68 640058e3 cmp r8, #0x64
a0132d6c b4fdff0a beq #0xa0132444
a0132d70 48410ce3 movw r4, #0xc148
a0132d74 7c3003e3 movw r3, #0x307c
a0132d78 fb404ae3 movt r4, #0xa0fb
a0132d7c 6f304ae3 movt r3, #0xa06f
a0132d80 3f20d4e5 ldrb r2, [r4, #0x3f]
a0132d84 0070a0e3 mov r7, #0
a0132d88 041093e5 ldr r1, [r3, #4]
a0132d8c 240c02e3 movw r0, #0x2c24
a0132d90 443806e3 movw r3, #0x6844
a0132d94 04708de5 str r7, [sp, #4]
a0132d98 00208de5 str r2, [sp]
a0132d9c 54004ae3 movt r0, #0xa054
a0132da0 54304ae3 movt r3, #0xa054
a0132da4 422c03e3 movw r2, #0x3c42
a0132da8 cfd005eb bl #0xa02a70ec
a0132dac 3f60d4e5 ldrb r6, [r4, #0x3f]
a0132db0 115ea0e3 mov r5, #0x110
a0132db4 866086e0 add r6, r6, r6, lsl #1
a0132db8 066286e0 add r6, r6, r6, lsl #4
a0132dbc 006066e2 rsb r6, r6, #0
a0132dc0 9b4086e2 add r4, r6, #0x9b
a0132dc4 866e86e2 add r6, r6, #0x860
a0132dc8 0510a0e1 mov r1, r5
a0132dcc 0430a0e1 mov r3, r4
a0132dd0 00708de5 str r7, [sp]
a0132dd4 0200a0e3 mov r0, #2
a0132dd8 aa20a0e3 mov r2, #0xaa
a0132ddc 334084e2 add r4, r4, #0x33
a0132de0 ba3c03eb bl #0xa02020d0
a0132de4 060054e1 cmp r4, r6
a0132de8 015085e2 add r5, r5, #1
a0132dec 0080a0e3 mov r8, #0
a0132df0 f4ffff1a bne #0xa0132dc8
a0132df4 110ea0e3 mov r0, #0x110
a0132df8 894601e3 movw r4, #0x1689
a0132dfc 0ee8ffeb bl #0xa012ce3c
a0132e00 00c060e2 rsb ip, r0, #0
a0132e04 0200a0e3 mov r0, #2
a0132e08 0c33a0e1 lsl r3, ip, #6
a0132e0c 8a4142e3 movt r4, #0x218a
a0132e10 00808de5 str r8, [sp]
a0132e14 0f1100e3 movw r1, #0x10f
a0132e18 0c3183e0 add r3, r3, ip, lsl #2
a0132e1c 9b2fa0e3 mov r2, #0x26c
a0132e20 0c3083e0 add r3, r3, ip
a0132e24 1330a0e1 lsl r3, r3, r0
a0132e28 9344c5e0 smull r4, r5, r3, r4
a0132e2c c33fa0e1 asr r3, r3, #0x1f
a0132e30 453463e0 rsb r3, r3, r5, asr #8
a0132e34 a53c03eb bl #0xa02020d0
a0132e38 81fdffea b #0xa0132444
a0132e3c 880c02e3 movw r0, #0x2c88
a0132e40 e82d05e3 movw r2, #0x5de8
a0132e44 54004ae3 movt r0, #0xa054
a0132e48 54204ae3 movt r2, #0xa054
a0132e4c 6a1e03e3 movw r1, #0x3e6a
a0132e50 a5d005eb bl #0xa02a70ec
a0132e54 003099e5 ldr r3, [sb]
a0132e58 320053e3 cmp r3, #0x32
a0132e5c 3700000a beq #0xa0132f40
a0132e60 f40c02e3 movw r0, #0x2cf4
a0132e64 e82d05e3 movw r2, #0x5de8
a0132e68 d84c05e3 movw r4, #0x5cd8
a0132e6c 54204ae3 movt r2, #0xa054
a0132e70 05414ae3 movt r4, #0xa105
a0132e74 6d1e03e3 movw r1, #0x3e6d
a0132e78 54004ae3 movt r0, #0xa054
a0132e7c 9ad005eb bl #0xa02a70ec
a0132e80 c232d4e5 ldrb r3, [r4, #0x2c2]
a0132e84 c41294e5 ldr r1, [r4, #0x2c4]
a0132e88 c82294e5 ldr r2, [r4, #0x2c8]
a0132e8c 010043e2 sub r0, r3, #1
a0132e90 d132c4e5 strb r3, [r4, #0x2d1]
a0132e94 010050e3 cmp r0, #1
a0132e98 d41284e5 str r1, [r4, #0x2d4]
a0132e9c 0230a083 movhi r3, #2
a0132ea0 0010a0e3 mov r1, #0
a0132ea4 d132c485 strbhi r3, [r4, #0x2d1]
a0132ea8 4c3303e3 movw r3, #0x334c
a0132eac fb304ae3 movt r3, #0xa0fb
a0132eb0 d82284e5 str r2, [r4, #0x2d8]
a0132eb4 183093e5 ldr r3, [r3, #0x18]
a0132eb8 0120a0e1 mov r2, r1
a0132ebc 8f00a0e3 mov r0, #0x8f
a0132ec0 33ff2fe1 blx r3
a0132ec4 d152d4e5 ldrb r5, [r4, #0x2d1]
a0132ec8 020055e3 cmp r5, #2
a0132ecc cb03000a beq #0xa0133e00
a0132ed0 5c20a0e3 mov r2, #0x5c
a0132ed4 f71200e3 movw r1, #0x2f7
a0132ed8 0200a0e3 mov r0, #2
a0132edc b93b03eb bl #0xa0201dc8
a0132ee0 f71200e3 movw r1, #0x2f7
a0132ee4 0200a0e3 mov r0, #2
a0132ee8 f63c03eb bl #0xa02022c8
a0132eec bd1fa0e3 mov r1, #0x2f4
a0132ef0 0200a0e3 mov r0, #2
a0132ef4 5520a0e3 mov r2, #0x55
a0132ef8 b23b03eb bl #0xa0201dc8
a0132efc 0200a0e3 mov r0, #2
a0132f00 bd1fa0e3 mov r1, #0x2f4
a0132f04 ef3c03eb bl #0xa02022c8
a0132f08 f51200e3 movw r1, #0x2f5
a0132f0c 0200a0e3 mov r0, #2
a0132f10 ec3c03eb bl #0xa02022c8
a0132f14 f61200e3 movw r1, #0x2f6
a0132f18 0200a0e3 mov r0, #2
a0132f1c e93c03eb bl #0xa02022c8
a0132f20 00c096e5 ldr ip, [r6]
a0132f24 0020a0e3 mov r2, #0
a0132f28 d40294e5 ldr r0, [r4, #0x2d4]
a0132f2c 0130a0e3 mov r3, #1
a0132f30 d81294e5 ldr r1, [r4, #0x2d8]
a0132f34 80c0cce3 bic ip, ip, #0x80
a0132f38 00c086e5 str ip, [r6]
a0132f3c 29f4ffeb bl #0xa012ffe8
a0132f40 700d02e3 movw r0, #0x2d70
a0132f44 e82d05e3 movw r2, #0x5de8
a0132f48 54204ae3 movt r2, #0xa054
a0132f4c 831e03e3 movw r1, #0x3e83
a0132f50 54004ae3 movt r0, #0xa054
a0132f54 64d005eb bl #0xa02a70ec
a0132f58 39fdffea b #0xa0132444
a0132f5c 660058e3 cmp r8, #0x66
a0132f60 0904000a beq #0xa0133f8c
a0132f64 d4419fe5 ldr r4, [pc, #0x1d4]
a0132f68 845d00e3 movw r5, #0xd84
a0132f6c 6a504ae3 movt r5, #0xa06a
a0132f70 0a6084e2 add r6, r4, #0xa
a0132f74 043095e5 ldr r3, [r5, #4]
a0132f78 0200a0e3 mov r0, #2
a0132f7c b010d4e1 ldrh r1, [r4]
a0132f80 010053e3 cmp r3, #1
a0132f84 d102000a beq #0xa0133ad0
a0132f88 8d3d03eb bl #0xa02025c4
a0132f8c 024084e2 add r4, r4, #2
a0132f90 0c5085e2 add r5, r5, #0xc
a0132f94 060054e1 cmp r4, r6
a0132f98 f5ffff1a bne #0xa0132f74
a0132f9c 28fdffea b #0xa0132444
a0132fa0 080055e3 cmp r5, #8
a0132fa4 2a03000a beq #0xa0133c54
a0132fa8 260300da ble #0xa0133c48
a0132fac 310055e3 cmp r5, #0x31
a0132fb0 23fdff1a bne #0xa0132444
a0132fb4 4d1100e3 movw r1, #0x14d
a0132fb8 0200a0e3 mov r0, #2
a0132fbc 803d03eb bl #0xa02025c4
a0132fc0 531fa0e3 mov r1, #0x14c
a0132fc4 0200a0e3 mov r0, #2
a0132fc8 7d3d03eb bl #0xa02025c4
a0132fcc 4b1100e3 movw r1, #0x14b
a0132fd0 0200a0e3 mov r0, #2
a0132fd4 7a3d03eb bl #0xa02025c4
a0132fd8 19fdffea b #0xa0132444
a0132fdc 81ebffeb bl #0xa012dde8
a0132fe0 17fdffea b #0xa0132444
a0132fe4 d84c05e3 movw r4, #0x5cd8
a0132fe8 05414ae3 movt r4, #0xa105
a0132fec aa30d4e5 ldrb r3, [r4, #0xaa]
a0132ff0 000053e3 cmp r3, #0
a0132ff4 09005313 cmpne r3, #9
a0132ff8 fb02000a beq #0xa0133bec
a0132ffc 090053e3 cmp r3, #9
a0133000 060300ca bgt #0xa0133c20
a0133004 0050a0e3 mov r5, #0
a0133008 8020a0e3 mov r2, #0x80
a013300c 0510a0e1 mov r1, r5
a0133010 58008de2 add r0, sp, #0x58
a0133014 2c508de5 str r5, [sp, #0x2c]
a0133018 73170ffa blx #0xa04f8dec
a013301c 0510a0e1 mov r1, r5
a0133020 012ca0e3 mov r2, #0x100
a0133024 d8008de2 add r0, sp, #0xd8
a0133028 6f170ffa blx #0xa04f8dec
a013302c a551d4e5 ldrb r5, [r4, #0x1a5]
a0133030 0010a0e3 mov r1, #0
a0133034 a431d4e5 ldrb r3, [r4, #0x1a4]
a0133038 0120a0e1 mov r2, r1
a013303c 2c008de2 add r0, sp, #0x2c
a0133040 005095e2 adds r5, r5, #0
a0133044 0150a013 movne r5, #1
a0133048 000053e3 cmp r3, #0
a013304c bc3d0ce3 movw r3, #0xcdbc
a0133050 01508512 addne r5, r5, #1
a0133054 69304ae3 movt r3, #0xa069
a0133058 00308de5 str r3, [sp]
a013305c 0130a0e1 mov r3, r1
a0133060 d7eaffeb bl #0xa012dbc4
a0133064 000050e3 cmp r0, #0
a0133068 0200001a bne #0xa0133078
a013306c 2c309de5 ldr r3, [sp, #0x2c]
a0133070 010053e3 cmp r3, #1
a0133074 015085c2 addgt r5, r5, #1
a0133078 c01700e3 movw r1, #0x7c0
a013307c 093085e2 add r3, r5, #9
a0133080 aa20d4e5 ldrb r2, [r4, #0xaa]
a0133084 57104ae3 movt r1, #0xa057
a0133088 58008de2 add r0, sp, #0x58
a013308c ef180ffa blx #0xa04f9450
a0133090 58008de2 add r0, sp, #0x58
a0133094 d8108de2 add r1, sp, #0xd8
a0133098 65d205eb bl #0xa02a7a34
a013309c d8208de2 add r2, sp, #0xd8
a01330a0 0510a0e3 mov r1, #5
a01330a4 0000a0e3 mov r0, #0
a01330a8 aa3b03eb bl #0xa0201f58
a01330ac eb10a0e3 mov r1, #0xeb
a01330b0 0200a0e3 mov r0, #2
a01330b4 0520a0e3 mov r2, #5
a01330b8 743b03eb bl #0xa0201e90
a01330bc 0200a0e3 mov r0, #2
a01330c0 eb10a0e3 mov r1, #0xeb
a01330c4 7f3c03eb bl #0xa02022c8
a01330c8 ba3ad4e1 ldrh r3, [r4, #0xaa]
a01330cc 000053e3 cmp r3, #0
a01330d0 dbfcff1a bne #0xa0132444
a01330d4 68509fe5 ldr r5, [pc, #0x68]
a01330d8 586085e2 add r6, r5, #0x58
a01330dc 0420b5e5 ldr r2, [r5, #4]!
a01330e0 e910a0e3 mov r1, #0xe9
a01330e4 0200a0e3 mov r0, #2
a01330e8 363b03eb bl #0xa0201dc8
a01330ec e910a0e3 mov r1, #0xe9
a01330f0 0200a0e3 mov r0, #2
a01330f4 733c03eb bl #0xa02022c8
a01330f8 5a00a0e3 mov r0, #0x5a
a01330fc 87240aeb bl #0xa03bc320
a0133100 0200a0e3 mov r0, #2
a0133104 a93d03eb bl #0xa02027b0
a0133108 060055e1 cmp r5, r6
a013310c f2ffff1a bne #0xa01330dc
a0133110 0130a0e3 mov r3, #1
a0133114 ab30c4e5 strb r3, [r4, #0xab]
a0133118 c9fcffea b #0xa0132444
a013311c 0800a0e1 mov r0, r8
a0133120 8cebffeb bl #0xa012df58
a0133124 c6fcffea b #0xa0132444
a0133128 0c0057e3 cmp r7, #0xc
a013312c c4fcff1a bne #0xa0132444
a0133130 d84c05e3 movw r4, #0x5cd8
a0133134 05414ae3 movt r4, #0xa105
a0133138 e2ffffea b #0xa01330c8
a0133148 183095e5 ldr r3, [r5, #0x18]
a013314c 000053e3 cmp r3, #0
a0133150 5f04000a beq #0xa01342d4
a0133154 0020d3e5 ldrb r2, [r3]
a0133158 1c1095e5 ldr r1, [r5, #0x1c]
a013315c 0232a0e1 lsl r3, r2, #4
a0133160 023143e0 sub r3, r3, r2, lsl #2
a0133164 034091e7 ldr r4, [r1, r3]
a0133168 0c4086e5 str r4, [r6, #0xc]
a013316c 1c2095e5 ldr r2, [r5, #0x1c]
a0133170 033082e0 add r3, r2, r3
a0133174 043093e5 ldr r3, [r3, #4]
a0133178 103086e5 str r3, [r6, #0x10]
a013317c 142095e5 ldr r2, [r5, #0x14]
a0133180 020058e1 cmp r8, r2
a0133184 0a00000a beq #0xa01331b4
a0133188 7c1003e3 movw r1, #0x307c
a013318c 0c0802e3 movw r0, #0x280c
a0133190 6f104ae3 movt r1, #0xa06f
a0133194 6c3a05e3 movw r3, #0x5a6c
a0133198 041091e5 ldr r1, [r1, #4]
a013319c 54004ae3 movt r0, #0xa054
a01331a0 04208de5 str r2, [sp, #4]
a01331a4 54304ae3 movt r3, #0xa054
a01331a8 00808de5 str r8, [sp]
a01331ac 992701e3 movw r2, #0x1799
a01331b0 cdcf05eb bl #0xa02a70ec
a01331b4 0420a0e1 mov r2, r4
a01331b8 0810a0e1 mov r1, r8
a01331bc 0200a0e3 mov r0, #2
a01331c0 0f7048e2 sub r7, r8, #0xf
a01331c4 ff3a03eb bl #0xa0201dc8
a01331c8 c74300e3 movw r4, #0x3c7
a01331cc 0810a0e1 mov r1, r8
a01331d0 0200a0e3 mov r0, #2
a01331d4 3b3c03eb bl #0xa02022c8
a01331d8 0710a0e1 mov r1, r7
a01331dc 0200a0e3 mov r0, #2
a01331e0 0420a0e1 mov r2, r4
a01331e4 f73a03eb bl #0xa0201dc8
a01331e8 0710a0e1 mov r1, r7
a01331ec 0200a0e3 mov r0, #2
a01331f0 343c03eb bl #0xa02022c8
a01331f4 10309de5 ldr r3, [sp, #0x10]
a01331f8 018088e2 add r8, r8, #1
a01331fc 145085e2 add r5, r5, #0x14
a0133200 0c6086e2 add r6, r6, #0xc
a0133204 030058e1 cmp r8, r3
a0133208 3cfeff1a bne #0xa0132b00
a013320c 18a09de5 ldr sl, [sp, #0x18]
a0133210 0200a0e3 mov r0, #2
a0133214 08309ae5 ldr r3, [sl, #8]
a0133218 00409ae5 ldr r4, [sl]
a013321c 042093e5 ldr r2, [r3, #4]
a0133220 0410a0e1 mov r1, r4
a0133224 e73a03eb bl #0xa0201dc8
a0133228 0410a0e1 mov r1, r4
a013322c 0200a0e3 mov r0, #2
a0133230 243c03eb bl #0xa02022c8
a0133234 ab1100e3 movw r1, #0x1ab
a0133238 bb2300e3 movw r2, #0x3bb
a013323c 0200a0e3 mov r0, #2
a0133240 e03a03eb bl #0xa0201dc8
a0133244 0200a0e3 mov r0, #2
a0133248 ab1100e3 movw r1, #0x1ab
a013324c 1d3c03eb bl #0xa02022c8
a0133250 040059e3 cmp sb, #4
a0133254 7afcffca bgt #0xa0132444
a0133258 ad1100e3 movw r1, #0x1ad
a013325c 0200a0e3 mov r0, #2
a0133260 d73c03eb bl #0xa02025c4
a0133264 76fcffea b #0xa0132444
a0133268 4c0a02e3 movw r0, #0x2a4c
a013326c 6c2a05e3 movw r2, #0x5a6c
a0133270 54204ae3 movt r2, #0xa054
a0133274 2a1701e3 movw r1, #0x172a
a0133278 54004ae3 movt r0, #0xa054
a013327c 9acf05eb bl #0xa02a70ec
a0133280 0000a0e3 mov r0, #0
a0133284 3ae6ffeb bl #0xa012cb74
a0133288 0040a0e1 mov r4, r0
a013328c 0100a0e3 mov r0, #1
a0133290 0c4086e5 str r4, [r6, #0xc]
a0133294 36e6ffeb bl #0xa012cb74
a0133298 100086e5 str r0, [r6, #0x10]
a013329c b6ffffea b #0xa013317c
a01332a0 d87c05e3 movw r7, #0x5cd8
a01332a4 c80802e3 movw r0, #0x28c8
a01332a8 05714ae3 movt r7, #0xa105
a01332ac 6c2a05e3 movw r2, #0x5a6c
a01332b0 9f31d7e5 ldrb r3, [r7, #0x19f]
a01332b4 54004ae3 movt r0, #0xa054
a01332b8 54204ae3 movt r2, #0xa054
a01332bc 841701e3 movw r1, #0x1784
a01332c0 89cf05eb bl #0xa02a70ec
a01332c4 aa32d7e5 ldrb r3, [r7, #0x2aa]
a01332c8 000053e3 cmp r3, #0
a01332cc 114da003 moveq r4, #0x440
a01332d0 a9ffff0a beq #0xa013317c
a01332d4 183095e5 ldr r3, [r5, #0x18]
a01332d8 000053e3 cmp r3, #0
a01332dc 9cffff1a bne #0xa0133154
a01332e0 7c2003e3 movw r2, #0x307c
a01332e4 4c0802e3 movw r0, #0x284c
a01332e8 6f204ae3 movt r2, #0xa06f
a01332ec 6c3a05e3 movw r3, #0x5a6c
a01332f0 041092e5 ldr r1, [r2, #4]
a01332f4 54304ae3 movt r3, #0xa054
a01332f8 8e2701e3 movw r2, #0x178e
a01332fc 54004ae3 movt r0, #0xa054
a0133300 79cf05eb bl #0xa02a70ec
a0133304 9cffffea b #0xa013317c
a0133308 0010a0e3 mov r1, #0
a013330c 27008de2 add r0, sp, #0x27
a0133310 0120a0e1 mov r2, r1
a0133314 2c7a00eb bl #0xa0151bcc
a0133318 000050e3 cmp r0, #0
a013331c 0200001a bne #0xa013332c
a0133320 2730dde5 ldrb r3, [sp, #0x27]
a0133324 010053e3 cmp r3, #1
a0133328 d203000a beq #0xa0134278
a013332c 1c3095e5 ldr r3, [r5, #0x1c]
a0133330 0c4093e5 ldr r4, [r3, #0xc]
a0133334 0c4086e5 str r4, [r6, #0xc]
a0133338 104086e5 str r4, [r6, #0x10]
a013333c 8effffea b #0xa013317c
a0133340 183095e5 ldr r3, [r5, #0x18]
a0133344 000053e3 cmp r3, #0
a0133348 d703000a beq #0xa01342ac
a013334c 0000a0e3 mov r0, #0
a0133350 a1e6ffeb bl #0xa012cddc
a0133354 0040a0e1 mov r4, r0
a0133358 0000a0e3 mov r0, #0
a013335c 9ee6ffeb bl #0xa012cddc
a0133360 0c0086e5 str r0, [r6, #0xc]
a0133364 0100a0e3 mov r0, #1
a0133368 9be6ffeb bl #0xa012cddc
a013336c 100086e5 str r0, [r6, #0x10]
a0133370 81ffffea b #0xa013317c
a0133374 183095e5 ldr r3, [r5, #0x18]
a0133378 000053e3 cmp r3, #0
a013337c b303000a beq #0xa0134250
a0133380 0000a0e3 mov r0, #0
a0133384 58208de2 add r2, sp, #0x58
a0133388 0010a0e1 mov r1, r0
a013338c 393900eb bl #0xa0141878
a0133390 183095e5 ldr r3, [r5, #0x18]
a0133394 007050e2 subs r7, r0, #0
a0133398 00b0d3e5 ldrb fp, [r3]
a013339c 8c03000a beq #0xa01341d4
a01333a0 7c2003e3 movw r2, #0x307c
a01333a4 800a02e3 movw r0, #0x2a80
a01333a8 6f204ae3 movt r2, #0xa06f
a01333ac 6c3a05e3 movw r3, #0x5a6c
a01333b0 041092e5 ldr r1, [r2, #4]
a01333b4 54304ae3 movt r3, #0xa054
a01333b8 00708de5 str r7, [sp]
a01333bc 3e2701e3 movw r2, #0x173e
a01333c0 54004ae3 movt r0, #0xa054
a01333c4 48cf05eb bl #0xa02a70ec
a01333c8 89ffffea b #0xa01331f4
a01333cc d83c05e3 movw r3, #0x5cd8
a01333d0 05314ae3 movt r3, #0xa105
a01333d4 a932d3e5 ldrb r3, [r3, #0x2a9]
a01333d8 000053e3 cmp r3, #0
a01333dc 9903000a beq #0xa0134248
a01333e0 183095e5 ldr r3, [r5, #0x18]
a01333e4 000053e3 cmp r3, #0
a01333e8 59ffff1a bne #0xa0133154
a01333ec 7c2003e3 movw r2, #0x307c
a01333f0 4c0802e3 movw r0, #0x284c
a01333f4 6f204ae3 movt r2, #0xa06f
a01333f8 6c3a05e3 movw r3, #0x5a6c
a01333fc 041092e5 ldr r1, [r2, #4]
a0133400 54304ae3 movt r3, #0xa054
a0133404 642601e3 movw r2, #0x1664
a0133408 54004ae3 movt r0, #0xa054
a013340c 36cf05eb bl #0xa02a70ec
a0133410 77ffffea b #0xa01331f4
a0133414 183095e5 ldr r3, [r5, #0x18]
a0133418 000053e3 cmp r3, #0
a013341c 3e04000a beq #0xa013451c
a0133420 e43b00eb bl #0xa01423b8
a0133424 182095e5 ldr r2, [r5, #0x18]
a0133428 7c4003e3 movw r4, #0x307c
a013342c 00c0a0e1 mov ip, r0
a0133430 6f404ae3 movt r4, #0xa06f
a0133434 8c0802e3 movw r0, #0x288c
a0133438 6c3a05e3 movw r3, #0x5a6c
a013343c 00b0d2e5 ldrb fp, [r2]
a0133440 54304ae3 movt r3, #0xa054
a0133444 081094e5 ldr r1, [r4, #8]
a0133448 54004ae3 movt r0, #0xa054
a013344c 04c08de5 str ip, [sp, #4]
a0133450 6e2601e3 movw r2, #0x166e
a0133454 08908de5 str sb, [sp, #8]
a0133458 00b08de5 str fp, [sp]
a013345c 14c08de5 str ip, [sp, #0x14]
a0133460 21cf05eb bl #0xa02a70ec
a0133464 14c09de5 ldr ip, [sp, #0x14]
a0133468 0b005ce1 cmp ip, fp
a013346c 0030a0c3 movgt r3, #0
a0133470 0130a0d3 movle r3, #1
a0133474 ac3f93e1 orrs r3, r3, ip, lsr #31
a0133478 1f04001a bne #0xa01344fc
a013347c 0b71a0e1 lsl r7, fp, #2
a0133480 0b7267e0 rsb r7, r7, fp, lsl #4
a0133484 8c0802e3 movw r0, #0x288c
a0133488 081094e5 ldr r1, [r4, #8]
a013348c 6c3a05e3 movw r3, #0x5a6c
a0133490 54004ae3 movt r0, #0xa054
a0133494 54304ae3 movt r3, #0xa054
a0133498 742601e3 movw r2, #0x1674
a013349c 00188de8 stm sp, {fp, ip}
a01334a0 08908de5 str sb, [sp, #8]
a01334a4 10cf05eb bl #0xa02a70ec
a01334a8 1c3095e5 ldr r3, [r5, #0x1c]
a01334ac 074093e7 ldr r4, [r3, r7]
a01334b0 0c4086e5 str r4, [r6, #0xc]
a01334b4 1c3095e5 ldr r3, [r5, #0x1c]
a01334b8 077083e0 add r7, r3, r7
a01334bc 043097e5 ldr r3, [r7, #4]
a01334c0 103086e5 str r3, [r6, #0x10]
a01334c4 2cffffea b #0xa013317c
a01334c8 183095e5 ldr r3, [r5, #0x18]
a01334cc 000053e3 cmp r3, #0
a01334d0 d903000a beq #0xa013443c
a01334d4 a73b00eb bl #0xa0142378
a01334d8 182095e5 ldr r2, [r5, #0x18]
a01334dc 7c4003e3 movw r4, #0x307c
a01334e0 00b0a0e1 mov fp, r0
a01334e4 6f404ae3 movt r4, #0xa06f
a01334e8 8c0802e3 movw r0, #0x288c
a01334ec 6c3a05e3 movw r3, #0x5a6c
a01334f0 0070d2e5 ldrb r7, [r2]
a01334f4 54304ae3 movt r3, #0xa054
a01334f8 081094e5 ldr r1, [r4, #8]
a01334fc 54004ae3 movt r0, #0xa054
a0133500 04b08de5 str fp, [sp, #4]
a0133504 822601e3 movw r2, #0x1682
a0133508 00708de5 str r7, [sp]
a013350c 08908de5 str sb, [sp, #8]
a0133510 f5ce05eb bl #0xa02a70ec
a0133514 ab3fa0e1 lsr r3, fp, #0x1f
a0133518 07005be1 cmp fp, r7
a013351c 0370a0c1 movgt r7, r3
a0133520 017083d3 orrle r7, r3, #1
a0133524 000057e3 cmp r7, #0
a0133528 ad03000a beq #0xa01343e4
a013352c 0070a0e3 mov r7, #0
a0133530 0720a0e1 mov r2, r7
a0133534 4f70cae5 strb r7, [sl, #0x4f]
a0133538 8c0802e3 movw r0, #0x288c
a013353c 6c3a05e3 movw r3, #0x5a6c
a0133540 081094e5 ldr r1, [r4, #8]
a0133544 54004ae3 movt r0, #0xa054
a0133548 04088de8 stm sp, {r2, fp}
a013354c 54304ae3 movt r3, #0xa054
a0133550 08908de5 str sb, [sp, #8]
a0133554 8f2601e3 movw r2, #0x168f
a0133558 d1ffffea b #0xa01334a4
a013355c d87c05e3 movw r7, #0x5cd8
a0133560 c80802e3 movw r0, #0x28c8
a0133564 05714ae3 movt r7, #0xa105
a0133568 6c2a05e3 movw r2, #0x5a6c
a013356c 9f31d7e5 ldrb r3, [r7, #0x19f]
a0133570 54004ae3 movt r0, #0xa054
a0133574 54204ae3 movt r2, #0xa054
a0133578 a41601e3 movw r1, #0x16a4
a013357c dace05eb bl #0xa02a70ec
a0133580 9f31d7e5 ldrb r3, [r7, #0x19f]
a0133584 000053e3 cmp r3, #0
a0133588 7d440003 movweq r4, #0x47d
a013358c fafeff0a beq #0xa013317c
a0133590 183095e5 ldr r3, [r5, #0x18]
a0133594 000053e3 cmp r3, #0
a0133598 edfeff1a bne #0xa0133154
a013359c 7c2003e3 movw r2, #0x307c
a01335a0 4c0802e3 movw r0, #0x284c
a01335a4 6f204ae3 movt r2, #0xa06f
a01335a8 6c3a05e3 movw r3, #0x5a6c
a01335ac 041092e5 ldr r1, [r2, #4]
a01335b0 54304ae3 movt r3, #0xa054
a01335b4 ae2601e3 movw r2, #0x16ae
a01335b8 54004ae3 movt r0, #0xa054
a01335bc cace05eb bl #0xa02a70ec
a01335c0 edfeffea b #0xa013317c
a01335c4 d87c05e3 movw r7, #0x5cd8
a01335c8 000902e3 movw r0, #0x2900
a01335cc 05714ae3 movt r7, #0xa105
a01335d0 6c2a05e3 movw r2, #0x5a6c
a01335d4 2730d7e5 ldrb r3, [r7, #0x27]
a01335d8 54004ae3 movt r0, #0xa054
a01335dc 54204ae3 movt r2, #0xa054
a01335e0 bf1601e3 movw r1, #0x16bf
a01335e4 c0ce05eb bl #0xa02a70ec
a01335e8 2730d7e5 ldrb r3, [r7, #0x27]
a01335ec 000053e3 cmp r3, #0
a01335f0 4dffff0a beq #0xa013332c
a01335f4 183095e5 ldr r3, [r5, #0x18]
a01335f8 000053e3 cmp r3, #0
a01335fc d903000a beq #0xa0134568
a0133600 0030d3e5 ldrb r3, [r3]
a0133604 000053e3 cmp r3, #0
a0133608 1c3095e5 ldr r3, [r5, #0x1c]
a013360c 04409315 ldrne r4, [r3, #4]
a0133610 00409305 ldreq r4, [r3]
a0133614 0c4086e5 str r4, [r6, #0xc]
a0133618 d7feffea b #0xa013317c
a013361c 183095e5 ldr r3, [r5, #0x18]
a0133620 000053e3 cmp r3, #0
a0133624 aa03000a beq #0xa01344d4
a0133628 0030d3e5 ldrb r3, [r3]
a013362c 80c401e3 movw ip, #0x1480
a0133630 33e0dae5 ldrb lr, [sl, #0x33]
a0133634 0c0a02e3 movw r0, #0x2a0c
a0133638 6c2a05e3 movw r2, #0x5a6c
a013363c 6ac04ae3 movt ip, #0xa06a
a0133640 54004ae3 movt r0, #0xa054
a0133644 54204ae3 movt r2, #0xa054
a0133648 231701e3 movw r1, #0x1723
a013364c 0ee183e0 add lr, r3, lr, lsl #2
a0133650 0e42a0e1 lsl r4, lr, #4
a0133654 0e30a0e1 mov r3, lr
a0133658 0ee144e0 sub lr, r4, lr, lsl #2
a013365c 0e409ce7 ldr r4, [ip, lr]
a0133660 0ec08ce0 add ip, ip, lr
a0133664 0c4086e5 str r4, [r6, #0xc]
a0133668 04c09ce5 ldr ip, [ip, #4]
a013366c 10c086e5 str ip, [r6, #0x10]
a0133670 00408de5 str r4, [sp]
a0133674 9cce05eb bl #0xa02a70ec
a0133678 bffeffea b #0xa013317c
a013367c 740902e3 movw r0, #0x2974
a0133680 6c2a05e3 movw r2, #0x5a6c
a0133684 54204ae3 movt r2, #0xa054
a0133688 3830dae5 ldrb r3, [sl, #0x38]
a013368c 54004ae3 movt r0, #0xa054
a0133690 fd1601e3 movw r1, #0x16fd
a0133694 94ce05eb bl #0xa02a70ec
a0133698 0020dae5 ldrb r2, [sl]
a013369c 48310ce3 movw r3, #0xc148
a01336a0 fb304ae3 movt r3, #0xa0fb
a01336a4 010052e3 cmp r2, #1
a01336a8 aa03009a bls #0xa0134558
a01336ac 030052e3 cmp r2, #3
a01336b0 a303000a beq #0xa0134544
a01336b4 183095e5 ldr r3, [r5, #0x18]
a01336b8 000053e3 cmp r3, #0
a01336bc a4feff1a bne #0xa0133154
a01336c0 7c2003e3 movw r2, #0x307c
a01336c4 4c0802e3 movw r0, #0x284c
a01336c8 6f204ae3 movt r2, #0xa06f
a01336cc 6c3a05e3 movw r3, #0x5a6c
a01336d0 041092e5 ldr r1, [r2, #4]
a01336d4 54304ae3 movt r3, #0xa054
a01336d8 072701e3 movw r2, #0x1707
a01336dc 54004ae3 movt r0, #0xa054
a01336e0 81ce05eb bl #0xa02a70ec
a01336e4 c2feffea b #0xa01331f4
a01336e8 183095e5 ldr r3, [r5, #0x18]
a01336ec 000053e3 cmp r3, #0
a01336f0 6d03000a beq #0xa01344ac
a01336f4 0030d3e5 ldrb r3, [r3]
a01336f8 7cc600e3 movw ip, #0x67c
a01336fc 33e0dae5 ldrb lr, [sl, #0x33]
a0133700 c40902e3 movw r0, #0x29c4
a0133704 6c2a05e3 movw r2, #0x5a6c
a0133708 6ac04ae3 movt ip, #0xa06a
a013370c 54004ae3 movt r0, #0xa054
a0133710 54204ae3 movt r2, #0xa054
a0133714 181701e3 movw r1, #0x1718
a0133718 0ee183e0 add lr, r3, lr, lsl #2
a013371c cbffffea b #0xa0133650
a0133720 9c0902e3 movw r0, #0x299c
a0133724 6c2a05e3 movw r2, #0x5a6c
a0133728 54204ae3 movt r2, #0xa054
a013372c 0d1701e3 movw r1, #0x170d
a0133730 54004ae3 movt r0, #0xa054
a0133734 6cce05eb bl #0xa02a70ec
a0133738 0000a0e3 mov r0, #0
a013373c 31e5ffeb bl #0xa012cc08
a0133740 0040a0e1 mov r4, r0
a0133744 0100a0e3 mov r0, #1
a0133748 0c4086e5 str r4, [r6, #0xc]
a013374c 2de5ffeb bl #0xa012cc08
a0133750 100086e5 str r0, [r6, #0x10]
a0133754 88feffea b #0xa013317c
a0133758 d87c05e3 movw r7, #0x5cd8
a013375c 400902e3 movw r0, #0x2940
a0133760 05714ae3 movt r7, #0xa105
a0133764 6c2a05e3 movw r2, #0x5a6c
a0133768 9d31d7e5 ldrb r3, [r7, #0x19d]
a013376c 54004ae3 movt r0, #0xa054
a0133770 54204ae3 movt r2, #0xa054
a0133774 e91601e3 movw r1, #0x16e9
a0133778 5bce05eb bl #0xa02a70ec
a013377c 9d31d7e5 ldrb r3, [r7, #0x19d]
a0133780 000053e3 cmp r3, #0
a0133784 e8feff0a beq #0xa013332c
a0133788 183095e5 ldr r3, [r5, #0x18]
a013378c 000053e3 cmp r3, #0
a0133790 9affff1a bne #0xa0133600
a0133794 7c2003e3 movw r2, #0x307c
a0133798 4c0802e3 movw r0, #0x284c
a013379c 6f204ae3 movt r2, #0xa06f
a01337a0 6c3a05e3 movw r3, #0x5a6c
a01337a4 041092e5 ldr r1, [r2, #4]
a01337a8 54304ae3 movt r3, #0xa054
a01337ac f82601e3 movw r2, #0x16f8
a01337b0 54004ae3 movt r0, #0xa054
a01337b4 4cce05eb bl #0xa02a70ec
a01337b8 6ffeffea b #0xa013317c
a01337bc 0090a0e3 mov sb, #0
a01337c0 ac8800e3 movw r8, #0x8ac
a01337c4 d84c05e3 movw r4, #0x5cd8
a01337c8 1f1ea0e3 mov r1, #0x1f0
a01337cc 9e2300e3 movw r2, #0x39e
a01337d0 0200a0e3 mov r0, #2
a01337d4 09b0a0e1 mov fp, sb
a01337d8 6a804ae3 movt r8, #0xa06a
a01337dc 05414ae3 movt r4, #0xa105
a01337e0 03a0a0e3 mov sl, #3
a01337e4 773903eb bl #0xa0201dc8
a01337e8 0200a0e3 mov r0, #2
a01337ec 1f1ea0e3 mov r1, #0x1f0
a01337f0 b43a03eb bl #0xa02022c8
a01337f4 083097e5 ldr r3, [r7, #8]
a01337f8 7c2003e3 movw r2, #0x307c
a01337fc 02c0a0e1 mov ip, r2
a0133800 d82c05e3 movw r2, #0x5cd8
a0133804 02e0a0e1 mov lr, r2
a0133808 f11100e3 movw r1, #0x1f1
a013380c 002093e5 ldr r2, [r3]
a0133810 0c30a0e1 mov r3, ip
a0133814 6f304ae3 movt r3, #0xa06f
a0133818 0200a0e3 mov r0, #2
a013381c 18308de5 str r3, [sp, #0x18]
a0133820 0e30a0e1 mov r3, lr
a0133824 05314ae3 movt r3, #0xa105
a0133828 0070a0e3 mov r7, #0
a013382c 1c308de5 str r3, [sp, #0x1c]
a0133830 643903eb bl #0xa0201dc8
a0133834 f11100e3 movw r1, #0x1f1
a0133838 0200a0e3 mov r0, #2
a013383c a13a03eb bl #0xa02022c8
a0133840 1c0000ea b #0xa01338b8
a0133844 010059e3 cmp sb, #1
a0133848 1a01000a beq #0xa0133cb8
a013384c 0321a0e1 lsl r2, r3, #2
a0133850 0312a0e1 lsl r1, r3, #4
a0133854 10009de5 ldr r0, [sp, #0x10]
a0133858 01c082e0 add ip, r2, r1
a013385c 0cc18ce0 add ip, ip, ip, lsl #2
a0133860 0c6080e0 add r6, r0, ip
a0133864 400096e5 ldr r0, [r6, #0x40]
a0133868 010050e3 cmp r0, #1
a013386c a500000a beq #0xa0133b08
a0133870 050050e3 cmp r0, #5
a0133874 a300000a beq #0xa0133b08
a0133878 000050e3 cmp r0, #0
a013387c b100000a beq #0xa0133b48
a0133880 583096e5 ldr r3, [r6, #0x58]
a0133884 000053e3 cmp r3, #0
a0133888 0600000a beq #0xa01338a8
a013388c 002093e5 ldr r2, [r3]
a0133890 0510a0e1 mov r1, r5
a0133894 0200a0e3 mov r0, #2
a0133898 4a3903eb bl #0xa0201dc8
a013389c 0200a0e3 mov r0, #2
a01338a0 0510a0e1 mov r1, r5
a01338a4 873a03eb bl #0xa02022c8
a01338a8 017087e2 add r7, r7, #1
a01338ac 015085e2 add r5, r5, #1
a01338b0 0a0057e1 cmp r7, sl
a01338b4 0301000a beq #0xa0133cc8
a01338b8 18309de5 ldr r3, [sp, #0x18]
a01338bc 400b02e3 movw r0, #0x2b40
a01338c0 a521d4e5 ldrb r2, [r4, #0x1a5]
a01338c4 54004ae3 movt r0, #0xa054
a01338c8 081093e5 ldr r1, [r3, #8]
a01338cc b83106e3 movw r3, #0x61b8
a01338d0 04028de9 stmib sp, {r2, sb}
a01338d4 54304ae3 movt r3, #0xa054
a01338d8 00608de5 str r6, [sp]
a01338dc b52602e3 movw r2, #0x26b5
a01338e0 01ce05eb bl #0xa02a70ec
a01338e4 01005be3 cmp fp, #1
a01338e8 043098e4 ldr r3, [r8], #4
a01338ec d6ffff1a bne #0xa013384c
a01338f0 1c209de5 ldr r2, [sp, #0x1c]
a01338f4 a521d2e5 ldrb r2, [r2, #0x1a5]
a01338f8 000052e3 cmp r2, #0
a01338fc d0ffff1a bne #0xa0133844
a0133900 010059e3 cmp sb, #1
a0133904 0c01000a beq #0xa0133d3c
a0133908 02204ae2 sub r2, sl, #2
a013390c 070052e1 cmp r2, r7
a0133910 cdffffca bgt #0xa013384c
a0133914 003098e5 ldr r3, [r8]
a0133918 cbffffea b #0xa013384c
a013391c 1f1ea0e3 mov r1, #0x1f0
a0133920 9e2300e3 movw r2, #0x39e
a0133924 0200a0e3 mov r0, #2
a0133928 0090a0e3 mov sb, #0
a013392c 253903eb bl #0xa0201dc8
a0133930 6c8c0fe3 movw r8, #0xfc6c
a0133934 0200a0e3 mov r0, #2
a0133938 1f1ea0e3 mov r1, #0x1f0
a013393c d84c05e3 movw r4, #0x5cd8
a0133940 603a03eb bl #0xa02022c8
a0133944 09b0a0e1 mov fp, sb
a0133948 69804ae3 movt r8, #0xa069
a013394c 05414ae3 movt r4, #0xa105
a0133950 09a0a0e3 mov sl, #9
a0133954 a6ffffea b #0xa01337f4
a0133958 1f1ea0e3 mov r1, #0x1f0
a013395c 9e2300e3 movw r2, #0x39e
a0133960 0200a0e3 mov r0, #2
a0133964 0090a0e3 mov sb, #0
a0133968 163903eb bl #0xa0201dc8
a013396c c08d00e3 movw r8, #0xdc0
a0133970 0200a0e3 mov r0, #2
a0133974 1f1ea0e3 mov r1, #0x1f0
a0133978 d84c05e3 movw r4, #0x5cd8
a013397c 513a03eb bl #0xa02022c8
a0133980 09b0a0e1 mov fp, sb
a0133984 6a804ae3 movt r8, #0xa06a
a0133988 05414ae3 movt r4, #0xa105
a013398c 03a0a0e3 mov sl, #3
a0133990 97ffffea b #0xa01337f4
a0133994 1f1ea0e3 mov r1, #0x1f0
a0133998 9e2300e3 movw r2, #0x39e
a013399c 0200a0e3 mov r0, #2
a01339a0 0090a0e3 mov sb, #0
a01339a4 073903eb bl #0xa0201dc8
a01339a8 dc8d0ce3 movw r8, #0xcddc
a01339ac d84c05e3 movw r4, #0x5cd8
a01339b0 1f1ea0e3 mov r1, #0x1f0
a01339b4 0200a0e3 mov r0, #2
a01339b8 09b0a0e1 mov fp, sb
a01339bc 69804ae3 movt r8, #0xa069
a01339c0 05414ae3 movt r4, #0xa105
a01339c4 03a0a0e3 mov sl, #3
a01339c8 3e3a03eb bl #0xa02022c8
a01339cc 88ffffea b #0xa01337f4
a01339d0 d84c05e3 movw r4, #0x5cd8
a01339d4 0090a0e3 mov sb, #0
a01339d8 05414ae3 movt r4, #0xa105
a01339dc 1f1ea0e3 mov r1, #0x1f0
a01339e0 a431d4e5 ldrb r3, [r4, #0x1a4]
a01339e4 9e2300e3 movw r2, #0x39e
a01339e8 0200a0e3 mov r0, #2
a01339ec 008300e3 movw r8, #0x300
a01339f0 09b0a0e1 mov fp, sb
a01339f4 6a804ae3 movt r8, #0xa06a
a01339f8 090053e1 cmp r3, sb
a01339fc 04a0a013 movne sl, #4
a0133a00 03a0a003 moveq sl, #3
a0133a04 ef3803eb bl #0xa0201dc8
a0133a08 1f1ea0e3 mov r1, #0x1f0
a0133a0c 0200a0e3 mov r0, #2
a0133a10 2c3a03eb bl #0xa02022c8
a0133a14 76ffffea b #0xa01337f4
a0133a18 dc3601e3 movw r3, #0x16dc
a0133a1c 0010a0e3 mov r1, #0
a0133a20 6a304ae3 movt r3, #0xa06a
a0133a24 0120a0e1 mov r2, r1
a0133a28 00308de5 str r3, [sp]
a0133a2c d8008de2 add r0, sp, #0xd8
a0133a30 0130a0e1 mov r3, r1
a0133a34 62e8ffeb bl #0xa012dbc4
a0133a38 000050e3 cmp r0, #0
a0133a3c dc01001a bne #0xa01341b4
a0133a40 d8309de5 ldr r3, [sp, #0xd8]
a0133a44 010053e3 cmp r3, #1
a0133a48 d90100da ble #0xa01341b4
a0133a4c d84c05e3 movw r4, #0x5cd8
a0133a50 0090a0e1 mov sb, r0
a0133a54 05414ae3 movt r4, #0xa105
a0133a58 a531d4e5 ldrb r3, [r4, #0x1a5]
a0133a5c 000053e3 cmp r3, #0
a0133a60 12a0a003 moveq sl, #0x12
a0133a64 13a0a013 movne sl, #0x13
a0133a68 1f1ea0e3 mov r1, #0x1f0
a0133a6c bb2300e3 movw r2, #0x3bb
a0133a70 0200a0e3 mov r0, #2
a0133a74 388400e3 movw r8, #0x438
a0133a78 d23803eb bl #0xa0201dc8
a0133a7c 0200a0e3 mov r0, #2
a0133a80 1f1ea0e3 mov r1, #0x1f0
a0133a84 0f3a03eb bl #0xa02022c8
a0133a88 6a804ae3 movt r8, #0xa06a
a0133a8c 01b0a0e3 mov fp, #1
a0133a90 57ffffea b #0xa01337f4
a0133a94 1f1ea0e3 mov r1, #0x1f0
a0133a98 9e2300e3 movw r2, #0x39e
a0133a9c 0200a0e3 mov r0, #2
a0133aa0 0090a0e3 mov sb, #0
a0133aa4 c73803eb bl #0xa0201dc8
a0133aa8 648b02e3 movw r8, #0x2b64
a0133aac 0200a0e3 mov r0, #2
a0133ab0 1f1ea0e3 mov r1, #0x1f0
a0133ab4 d84c05e3 movw r4, #0x5cd8
a0133ab8 023a03eb bl #0xa02022c8
a0133abc 09b0a0e1 mov fp, sb
a0133ac0 6a804ae3 movt r8, #0xa06a
a0133ac4 05414ae3 movt r4, #0xa105
a0133ac8 01a0a0e3 mov sl, #1
a0133acc 48ffffea b #0xa01337f4
a0133ad0 fc3903eb bl #0xa02022c8
a0133ad4 2cfdffea b #0xa0132f8c
a0133ad8 0020d6e5 ldrb r2, [r6]
a0133adc e71200e3 movw r1, #0x2e7
a0133ae0 0200a0e3 mov r0, #2
a0133ae4 0232a0e1 lsl r3, r2, #4
a0133ae8 023183e0 add r3, r3, r2, lsl #2
a0133aec 037087e0 add r7, r7, r3
a0133af0 082097e5 ldr r2, [r7, #8]
a0133af4 b33803eb bl #0xa0201dc8
a0133af8 e71200e3 movw r1, #0x2e7
a0133afc 0200a0e3 mov r0, #2
a0133b00 f03903eb bl #0xa02022c8
a0133b04 4efaffea b #0xa0132444
a0133b08 012082e0 add r2, r2, r1
a0133b0c 10109de5 ldr r1, [sp, #0x10]
a0133b10 022182e0 add r2, r2, r2, lsl #2
a0133b14 022081e0 add r2, r1, r2
a0133b18 500092e5 ldr r0, [r2, #0x50]
a0133b1c 000050e3 cmp r0, #0
a0133b20 e900000a beq #0xa0133ecc
a0133b24 581092e5 ldr r1, [r2, #0x58]
a0133b28 040053e3 cmp r3, #4
a0133b2c 0030d0e5 ldrb r3, [r0]
a0133b30 032191e7 ldr r2, [r1, r3, lsl #2]
a0133b34 55ffff1a bne #0xa0133890
a0133b38 9c31d4e5 ldrb r3, [r4, #0x19c]
a0133b3c 000053e3 cmp r3, #0
a0133b40 0c209105 ldreq r2, [r1, #0xc]
a0133b44 51ffffea b #0xa0133890
a0133b48 502096e5 ldr r2, [r6, #0x50]
a0133b4c 000052e3 cmp r2, #0
a0133b50 4affff0a beq #0xa0133880
a0133b54 0010d2e5 ldrb r1, [r2]
a0133b58 110053e3 cmp r3, #0x11
a0133b5c 580096e5 ldr r0, [r6, #0x58]
a0133b60 0122a0e1 lsl r2, r1, #4
a0133b64 012142e0 sub r2, r2, r1, lsl #2
a0133b68 022090e7 ldr r2, [r0, r2]
a0133b6c 0801000a beq #0xa0133f94
a0133b70 120053e3 cmp r3, #0x12
a0133b74 45ffff1a bne #0xa0133890
a0133b78 14309de5 ldr r3, [sp, #0x14]
a0133b7c b00b02e3 movw r0, #0x2bb0
a0133b80 9c2106e3 movw r2, #0x619c
a0133b84 111e01e3 movw r1, #0x1e11
a0133b88 54204ae3 movt r2, #0xa054
a0133b8c 54004ae3 movt r0, #0xa054
a0133b90 6530d3e5 ldrb r3, [r3, #0x65]
a0133b94 54cd05eb bl #0xa02a70ec
a0133b98 c122d4e5 ldrb r2, [r4, #0x2c1]
a0133b9c 48310ce3 movw r3, #0xc148
a0133ba0 fb304ae3 movt r3, #0xa0fb
a0133ba4 6510d3e5 ldrb r1, [r3, #0x65]
a0133ba8 010052e3 cmp r2, #1
a0133bac 2c02000a beq #0xa0134464
a0133bb0 8122a0e1 lsl r2, r1, #5
a0133bb4 883f00e3 movw r3, #0xf88
a0133bb8 6a304ae3 movt r3, #0xa06a
a0133bbc 812142e0 sub r2, r2, r1, lsl #3
a0133bc0 023083e0 add r3, r3, r2
a0133bc4 0c2093e5 ldr r2, [r3, #0xc]
a0133bc8 30ffffea b #0xa0133890
a0133bcc 5e1100e3 movw r1, #0x15e
a0133bd0 822fa0e3 mov r2, #0x208
a0133bd4 0200a0e3 mov r0, #2
a0133bd8 7a3803eb bl #0xa0201dc8
a0133bdc 5e1100e3 movw r1, #0x15e
a0133be0 0200a0e3 mov r0, #2
a0133be4 b73903eb bl #0xa02022c8
a0133be8 5bfaffea b #0xa013255c
a0133bec 0200a0e3 mov r0, #2
a0133bf0 ea10a0e3 mov r1, #0xea
a0133bf4 723a03eb bl #0xa02025c4
a0133bf8 aa30d4e5 ldrb r3, [r4, #0xaa]
a0133bfc 000053e3 cmp r3, #0
a0133c00 fdfcff1a bne #0xa0132ffc
a0133c04 e81a0ce3 movw r1, #0xcae8
a0133c08 0100a0e3 mov r0, #1
a0133c0c 13104ae3 movt r1, #0xa013
a0133c10 adcb02eb bl #0xa01e6acc
a0133c14 aa30d4e5 ldrb r3, [r4, #0xaa]
a0133c18 000053e3 cmp r3, #0
a0133c1c f6fcff1a bne #0xa0132ffc
a0133c20 eb10a0e3 mov r1, #0xeb
a0133c24 0200a0e3 mov r0, #2
a0133c28 653a03eb bl #0xa02025c4
a0133c2c 25fdffea b #0xa01330c8
a0133c30 832fa0e3 mov r2, #0x20c
a0133c34 633803eb bl #0xa0201dc8
a0133c38 5d1100e3 movw r1, #0x15d
a0133c3c 0200a0e3 mov r0, #2
a0133c40 a03903eb bl #0xa02022c8
a0133c44 35faffea b #0xa0132520
a0133c48 060055e3 cmp r5, #6
a0133c4c fcf9ffba blt #0xa0132444
a0133c50 d7fcffea b #0xa0132fb4
a0133c54 4d1100e3 movw r1, #0x14d
a0133c58 0200a0e3 mov r0, #2
a0133c5c 583a03eb bl #0xa02025c4
a0133c60 f7f9ffea b #0xa0132444
a0133c64 5820a0e3 mov r2, #0x58
a0133c68 0500a0e1 mov r0, r5
a0133c6c 9e10a0e3 mov r1, #0x9e
a0133c70 543803eb bl #0xa0201dc8
a0133c74 0500a0e1 mov r0, r5
a0133c78 9e10a0e3 mov r1, #0x9e
a0133c7c 913903eb bl #0xa02022c8
a0133c80 c40294e5 ldr r0, [r4, #0x2c4]
a0133c84 58208de2 add r2, sp, #0x58
a0133c88 c81294e5 ldr r1, [r4, #0x2c8]
a0133c8c d8308de2 add r3, sp, #0xd8
a0133c90 fcebffeb bl #0xa012ec88
a0133c94 58209de5 ldr r2, [sp, #0x58]
a0133c98 0500a0e1 mov r0, r5
a0133c9c d8309de5 ldr r3, [sp, #0xd8]
a0133ca0 9e10a0e3 mov r1, #0x9e
a0133ca4 00608de5 str r6, [sp]
a0133ca8 2d2042e2 sub r2, r2, #0x2d
a0133cac 2d3043e2 sub r3, r3, #0x2d
a0133cb0 063903eb bl #0xa02020d0
a0133cb4 b7faffea b #0xa0132798
a0133cb8 01204ae2 sub r2, sl, #1
a0133cbc 070052e1 cmp r2, r7
a0133cc0 e1feffca bgt #0xa013384c
a0133cc4 12ffffea b #0xa0133914
a0133cc8 030057e3 cmp r7, #3
a0133ccc dcf9ffca bgt #0xa0132444
a0133cd0 0200a0e3 mov r0, #2
a0133cd4 f21100e3 movw r1, #0x1f2
a0133cd8 393a03eb bl #0xa02025c4
a0133cdc 020057e3 cmp r7, #2
a0133ce0 d7f9ffca bgt #0xa0132444
a0133ce4 1f7e87e2 add r7, r7, #0x1f0
a0133ce8 f65100e3 movw r5, #0x1f6
a0133cec 037087e2 add r7, r7, #3
a0133cf0 0710a0e1 mov r1, r7
a0133cf4 c72300e3 movw r2, #0x3c7
a0133cf8 0200a0e3 mov r0, #2
a0133cfc 1e4087e2 add r4, r7, #0x1e
a0133d00 303803eb bl #0xa0201dc8
a0133d04 0710a0e1 mov r1, r7
a0133d08 0200a0e3 mov r0, #2
a0133d0c 6d3903eb bl #0xa02022c8
a0133d10 0410a0e1 mov r1, r4
a0133d14 c72300e3 movw r2, #0x3c7
a0133d18 0200a0e3 mov r0, #2
a0133d1c 017087e2 add r7, r7, #1
a0133d20 283803eb bl #0xa0201dc8
a0133d24 0410a0e1 mov r1, r4
a0133d28 0200a0e3 mov r0, #2
a0133d2c 653903eb bl #0xa02022c8
a0133d30 050057e1 cmp r7, r5
a0133d34 edffff1a bne #0xa0133cf0
a0133d38 c1f9ffea b #0xa0132444
a0133d3c 01204ae2 sub r2, sl, #1
a0133d40 070052e1 cmp r2, r7
a0133d44 043098d5 ldrle r3, [r8, #4]
a0133d48 bffeffea b #0xa013384c
a0133d4c 8b2fa0e3 mov r2, #0x22c
a0133d50 0510a0e1 mov r1, r5
a0133d54 0200a0e3 mov r0, #2
a0133d58 1a3803eb bl #0xa0201dc8
a0133d5c 0510a0e1 mov r1, r5
a0133d60 0200a0e3 mov r0, #2
a0133d64 573903eb bl #0xa02022c8
a0133d68 a03d03e3 movw r3, #0x3da0
a0133d6c fb304ae3 movt r3, #0xa0fb
a0133d70 002093e5 ldr r2, [r3]
a0133d74 012082e2 add r2, r2, #1
a0133d78 040052e3 cmp r2, #4
a0133d7c 002083e5 str r2, [r3]
a0133d80 aff9ffda ble #0xa0132444
a0133d84 1910a0e3 mov r1, #0x19
a0133d88 0020a0e3 mov r2, #0
a0133d8c 0300a0e3 mov r0, #3
a0133d90 c2e901eb bl #0xa01ae4a0
a0133d94 aaf9ffea b #0xa0132444
a0133d98 022200e3 movw r2, #0x202
a0133d9c 093803eb bl #0xa0201dc8
a0133da0 5f1100e3 movw r1, #0x15f
a0133da4 0200a0e3 mov r0, #2
a0133da8 463903eb bl #0xa02022c8
a0133dac 611100e3 movw r1, #0x161
a0133db0 062200e3 movw r2, #0x206
a0133db4 0200a0e3 mov r0, #2
a0133db8 023803eb bl #0xa0201dc8
a0133dbc 611100e3 movw r1, #0x161
a0133dc0 0200a0e3 mov r0, #2
a0133dc4 3f3903eb bl #0xa02022c8
a0133dc8 9df9ffea b #0xa0132444
a0133dcc 00408de5 str r4, [sp]
a0133dd0 3f1100e3 movw r1, #0x13f
a0133dd4 aa20a0e3 mov r2, #0xaa
a0133dd8 9b30a0e3 mov r3, #0x9b
a0133ddc 0200a0e3 mov r0, #2
a0133de0 ba3803eb bl #0xa02020d0
a0133de4 00408de5 str r4, [sp]
a0133de8 051da0e3 mov r1, #0x140
a0133dec aa20a0e3 mov r2, #0xaa
a0133df0 ce30a0e3 mov r3, #0xce
a0133df4 0200a0e3 mov r0, #2
a0133df8 b43803eb bl #0xa02020d0
a0133dfc 90f9ffea b #0xa0132444
a0133e00 5d20a0e3 mov r2, #0x5d
a0133e04 0500a0e1 mov r0, r5
a0133e08 f71200e3 movw r1, #0x2f7
a0133e0c ed3703eb bl #0xa0201dc8
a0133e10 0500a0e1 mov r0, r5
a0133e14 f71200e3 movw r1, #0x2f7
a0133e18 2a3903eb bl #0xa02022c8
a0133e1c 0500a0e1 mov r0, r5
a0133e20 bd1fa0e3 mov r1, #0x2f4
a0133e24 5720a0e3 mov r2, #0x57
a0133e28 e63703eb bl #0xa0201dc8
a0133e2c 0500a0e1 mov r0, r5
a0133e30 bd1fa0e3 mov r1, #0x2f4
a0133e34 233903eb bl #0xa02022c8
a0133e38 32fcffea b #0xa0132f08
a0133e3c 2e2200e3 movw r2, #0x22e
a0133e40 8c10a0e3 mov r1, #0x8c
a0133e44 0200a0e3 mov r0, #2
a0133e48 de3703eb bl #0xa0201dc8
a0133e4c 8c10a0e3 mov r1, #0x8c
a0133e50 0200a0e3 mov r0, #2
a0133e54 1b3903eb bl #0xa02022c8
a0133e58 2e2200e3 movw r2, #0x22e
a0133e5c 8d10a0e3 mov r1, #0x8d
a0133e60 0200a0e3 mov r0, #2
a0133e64 d73703eb bl #0xa0201dc8
a0133e68 8d10a0e3 mov r1, #0x8d
a0133e6c 0200a0e3 mov r0, #2
a0133e70 143903eb bl #0xa02022c8
a0133e74 2e2200e3 movw r2, #0x22e
a0133e78 8e10a0e3 mov r1, #0x8e
a0133e7c 0200a0e3 mov r0, #2
a0133e80 d03703eb bl #0xa0201dc8
a0133e84 8e10a0e3 mov r1, #0x8e
a0133e88 0200a0e3 mov r0, #2
a0133e8c 0d3903eb bl #0xa02022c8
a0133e90 2e2200e3 movw r2, #0x22e
a0133e94 8f10a0e3 mov r1, #0x8f
a0133e98 0200a0e3 mov r0, #2
a0133e9c c93703eb bl #0xa0201dc8
a0133ea0 8f10a0e3 mov r1, #0x8f
a0133ea4 0200a0e3 mov r0, #2
a0133ea8 063903eb bl #0xa02022c8
a0133eac 9010a0e3 mov r1, #0x90
a0133eb0 2e2200e3 movw r2, #0x22e
a0133eb4 0200a0e3 mov r0, #2
a0133eb8 c23703eb bl #0xa0201dc8
a0133ebc 9010a0e3 mov r1, #0x90
a0133ec0 0200a0e3 mov r0, #2
a0133ec4 ff3803eb bl #0xa02022c8
a0133ec8 5df9ffea b #0xa0132444
a0133ecc 583092e5 ldr r3, [r2, #0x58]
a0133ed0 000053e3 cmp r3, #0
a0133ed4 6cfeff1a bne #0xa013388c
a0133ed8 72feffea b #0xa01338a8
a0133edc 012085e2 add r2, r5, #1
a0133ee0 020059e1 cmp sb, r2
a0133ee4 56f9ffda ble #0xa0132444
a0133ee8 0232a0e1 lsl r3, r2, #4
a0133eec 6f5f85e2 add r5, r5, #0x1bc
a0133ef0 015085e2 add r5, r5, #1
a0133ef4 023183e0 add r3, r3, r2, lsl #2
a0133ef8 03c09ae7 ldr ip, [sl, r3]
a0133efc 03a08ae0 add sl, sl, r3
a0133f00 0c0055e1 cmp r5, ip
a0133f04 0a00000a beq #0xa0133f34
a0133f08 7c2003e3 movw r2, #0x307c
a0133f0c 0c0802e3 movw r0, #0x280c
a0133f10 6f204ae3 movt r2, #0xa06f
a0133f14 6c3a05e3 movw r3, #0x5a6c
a0133f18 041092e5 ldr r1, [r2, #4]
a0133f1c 54004ae3 movt r0, #0xa054
a0133f20 00508de5 str r5, [sp]
a0133f24 54304ae3 movt r3, #0xa054
a0133f28 04c08de5 str ip, [sp, #4]
a0133f2c 312601e3 movw r2, #0x1631
a0133f30 6dcc05eb bl #0xa02a70ec
a0133f34 08309ae5 ldr r3, [sl, #8]
a0133f38 0510a0e1 mov r1, r5
a0133f3c 0200a0e3 mov r0, #2
a0133f40 042093e5 ldr r2, [r3, #4]
a0133f44 9f3703eb bl #0xa0201dc8
a0133f48 0510a0e1 mov r1, r5
a0133f4c 0200a0e3 mov r0, #2
a0133f50 dc3803eb bl #0xa02022c8
a0133f54 3af9ffea b #0xa0132444
a0133f58 013085e2 add r3, r5, #1
a0133f5c 030059e1 cmp sb, r3
a0133f60 37f9ffda ble #0xa0132444
a0133f64 6f5f85e2 add r5, r5, #0x1bc
a0133f68 c62300e3 movw r2, #0x3c6
a0133f6c 015085e2 add r5, r5, #1
a0133f70 0200a0e3 mov r0, #2
a0133f74 0510a0e1 mov r1, r5
a0133f78 923703eb bl #0xa0201dc8
a0133f7c 0510a0e1 mov r1, r5
a0133f80 0200a0e3 mov r0, #2
a0133f84 cf3803eb bl #0xa02022c8
a0133f88 2df9ffea b #0xa0132444
a0133f8c bce3ffeb bl #0xa012ce84
a0133f90 f3fbffea b #0xa0132f64
a0133f94 14309de5 ldr r3, [sp, #0x14]
a0133f98 800b02e3 movw r0, #0x2b80
a0133f9c 642806e3 movw r2, #0x6864
a0133fa0 071e01e3 movw r1, #0x1e07
a0133fa4 54204ae3 movt r2, #0xa054
a0133fa8 54004ae3 movt r0, #0xa054
a0133fac 4e30d3e5 ldrb r3, [r3, #0x4e]
a0133fb0 4dcc05eb bl #0xa02a70ec
a0133fb4 a422d4e5 ldrb r2, [r4, #0x2a4]
a0133fb8 48310ce3 movw r3, #0xc148
a0133fbc fb304ae3 movt r3, #0xa0fb
a0133fc0 4e10d3e5 ldrb r1, [r3, #0x4e]
a0133fc4 010052e3 cmp r2, #1
a0133fc8 ff00000a beq #0xa01343cc
a0133fcc 8122a0e1 lsl r2, r1, #5
a0133fd0 dc3802e3 movw r3, #0x28dc
a0133fd4 6a304ae3 movt r3, #0xa06a
a0133fd8 812142e0 sub r2, r2, r1, lsl #3
a0133fdc 023083e0 add r3, r3, r2
a0133fe0 0c2093e5 ldr r2, [r3, #0xc]
a0133fe4 29feffea b #0xa0133890
a0133fe8 1f1ea0e3 mov r1, #0x1f0
a0133fec 9d2300e3 movw r2, #0x39d
a0133ff0 743703eb bl #0xa0201dc8
a0133ff4 1f1ea0e3 mov r1, #0x1f0
a0133ff8 0200a0e3 mov r0, #2
a0133ffc b13803eb bl #0xa02022c8
a0134000 0ff9ffea b #0xa0132444
a0134004 ea1200e3 movw r1, #0x2ea
a0134008 0200a0e3 mov r0, #2
a013400c 6c3903eb bl #0xa02025c4
a0134010 eb1200e3 movw r1, #0x2eb
a0134014 0200a0e3 mov r0, #2
a0134018 693903eb bl #0xa02025c4
a013401c bb1fa0e3 mov r1, #0x2ec
a0134020 0200a0e3 mov r0, #2
a0134024 663903eb bl #0xa02025c4
a0134028 ed1200e3 movw r1, #0x2ed
a013402c 0200a0e3 mov r0, #2
a0134030 633903eb bl #0xa02025c4
a0134034 f11200e3 movw r1, #0x2f1
a0134038 0200a0e3 mov r0, #2
a013403c 603903eb bl #0xa02025c4
a0134040 2f1ea0e3 mov r1, #0x2f0
a0134044 0200a0e3 mov r0, #2
a0134048 5d3903eb bl #0xa02025c4
a013404c ef1200e3 movw r1, #0x2ef
a0134050 0200a0e3 mov r0, #2
a0134054 5a3903eb bl #0xa02025c4
a0134058 ee1200e3 movw r1, #0x2ee
a013405c 0200a0e3 mov r0, #2
a0134060 573903eb bl #0xa02025c4
a0134064 f6f8ffea b #0xa0132444
a0134068 012085e2 add r2, r5, #1
a013406c 020059e1 cmp sb, r2
a0134070 f3f8ffda ble #0xa0132444
a0134074 0232a0e1 lsl r3, r2, #4
a0134078 6f5f85e2 add r5, r5, #0x1bc
a013407c 015085e2 add r5, r5, #1
a0134080 023183e0 add r3, r3, r2, lsl #2
a0134084 03c09ae7 ldr ip, [sl, r3]
a0134088 03a08ae0 add sl, sl, r3
a013408c 0c0055e1 cmp r5, ip
a0134090 0a00000a beq #0xa01340c0
a0134094 7c2003e3 movw r2, #0x307c
a0134098 0c0802e3 movw r0, #0x280c
a013409c 6f204ae3 movt r2, #0xa06f
a01340a0 6c3a05e3 movw r3, #0x5a6c
a01340a4 041092e5 ldr r1, [r2, #4]
a01340a8 54004ae3 movt r0, #0xa054
a01340ac 00508de5 str r5, [sp]
a01340b0 54304ae3 movt r3, #0xa054
a01340b4 04c08de5 str ip, [sp, #4]
a01340b8 3f2601e3 movw r2, #0x163f
a01340bc 0acc05eb bl #0xa02a70ec
a01340c0 08309ae5 ldr r3, [sl, #8]
a01340c4 0510a0e1 mov r1, r5
a01340c8 0200a0e3 mov r0, #2
a01340cc 002093e5 ldr r2, [r3]
a01340d0 3c3703eb bl #0xa0201dc8
a01340d4 0510a0e1 mov r1, r5
a01340d8 0200a0e3 mov r0, #2
a01340dc 793803eb bl #0xa02022c8
a01340e0 d7f8ffea b #0xa0132444
a01340e4 f30100e3 movw r0, #0x1f3
a01340e8 1e10a0e3 mov r1, #0x1e
a01340ec 482096e5 ldr r2, [r6, #0x48]
a01340f0 cce3ffeb bl #0xa012d028
a01340f4 403096e5 ldr r3, [r6, #0x40]
a01340f8 060053e3 cmp r3, #6
a01340fc 59f9ff1a bne #0xa0132668
a0134100 f30100e3 movw r0, #0x1f3
a0134104 f21100e3 movw r1, #0x1f2
a0134108 542096e5 ldr r2, [r6, #0x54]
a013410c a7e3ffeb bl #0xa012cfb0
a0134110 54f9ffea b #0xa0132668
a0134114 1f5e85e2 add r5, r5, #0x1f0
a0134118 100b02e3 movw r0, #0x2b10
a013411c b82106e3 movw r2, #0x61b8
a0134120 035085e2 add r5, r5, #3
a0134124 54204ae3 movt r2, #0xa054
a0134128 651602e3 movw r1, #0x2665
a013412c 54004ae3 movt r0, #0xa054
a0134130 edcb05eb bl #0xa02a70ec
a0134134 c62300e3 movw r2, #0x3c6
a0134138 0510a0e1 mov r1, r5
a013413c 0200a0e3 mov r0, #2
a0134140 203703eb bl #0xa0201dc8
a0134144 0510a0e1 mov r1, r5
a0134148 0200a0e3 mov r0, #2
a013414c 5d3803eb bl #0xa02022c8
a0134150 004096e5 ldr r4, [r6]
a0134154 110200e3 movw r0, #0x211
a0134158 37e3ffeb bl #0xa012ce3c
a013415c 682b02e3 movw r2, #0x2b68
a0134160 6a204ae3 movt r2, #0xa06a
a0134164 0432a0e1 lsl r3, r4, #4
a0134168 043183e0 add r3, r3, r4, lsl #2
a013416c 033183e0 add r3, r3, r3, lsl #2
a0134170 033082e0 add r3, r2, r3
a0134174 480083e5 str r0, [r3, #0x48]
a0134178 b1f8ffea b #0xa0132444
a013417c 492ea0e3 mov r2, #0x490
a0134180 ef1100e3 movw r1, #0x1ef
a0134184 0f3703eb bl #0xa0201dc8
a0134188 ef1100e3 movw r1, #0x1ef
a013418c 0200a0e3 mov r0, #2
a0134190 4c3803eb bl #0xa02022c8
a0134194 1f1ea0e3 mov r1, #0x1f0
a0134198 ba2300e3 movw r2, #0x3ba
a013419c 0200a0e3 mov r0, #2
a01341a0 083703eb bl #0xa0201dc8
a01341a4 1f1ea0e3 mov r1, #0x1f0
a01341a8 0200a0e3 mov r0, #2
a01341ac 453803eb bl #0xa02022c8
a01341b0 a3f8ffea b #0xa0132444
a01341b4 d84c05e3 movw r4, #0x5cd8
a01341b8 0190a0e3 mov sb, #1
a01341bc 05414ae3 movt r4, #0xa105
a01341c0 a531d4e5 ldrb r3, [r4, #0x1a5]
a01341c4 000053e3 cmp r3, #0
a01341c8 11a0a003 moveq sl, #0x11
a01341cc 12a0a013 movne sl, #0x12
a01341d0 24feffea b #0xa0133a68
a01341d4 58209de5 ldr r2, [sp, #0x58]
a01341d8 7c4003e3 movw r4, #0x307c
a01341dc 6f404ae3 movt r4, #0xa06f
a01341e0 d40a02e3 movw r0, #0x2ad4
a01341e4 6c3a05e3 movw r3, #0x5a6c
a01341e8 081094e5 ldr r1, [r4, #8]
a01341ec 54004ae3 movt r0, #0xa054
a01341f0 04208de5 str r2, [sp, #4]
a01341f4 00b08de5 str fp, [sp]
a01341f8 432701e3 movw r2, #0x1743
a01341fc 08908de5 str sb, [sp, #8]
a0134200 54304ae3 movt r3, #0xa054
a0134204 b8cb05eb bl #0xa02a70ec
a0134208 58209de5 ldr r2, [sp, #0x58]
a013420c 02005be1 cmp fp, r2
a0134210 de0000aa bge #0xa0134590
a0134214 7b30bfe6 sxth r3, fp
a0134218 0372a0e1 lsl r7, r3, #4
a013421c 037147e0 sub r7, r7, r3, lsl #2
a0134220 d40a02e3 movw r0, #0x2ad4
a0134224 081094e5 ldr r1, [r4, #8]
a0134228 6c3a05e3 movw r3, #0x5a6c
a013422c 04208de5 str r2, [sp, #4]
a0134230 00b08de5 str fp, [sp]
a0134234 54004ae3 movt r0, #0xa054
a0134238 08908de5 str sb, [sp, #8]
a013423c 54304ae3 movt r3, #0xa054
a0134240 4a2701e3 movw r2, #0x174a
a0134244 96fcffea b #0xa01334a4
a0134248 824400e3 movw r4, #0x482
a013424c cafbffea b #0xa013317c
a0134250 7c2003e3 movw r2, #0x307c
a0134254 4c0802e3 movw r0, #0x284c
a0134258 6f204ae3 movt r2, #0xa06f
a013425c 6c3a05e3 movw r3, #0x5a6c
a0134260 041092e5 ldr r1, [r2, #4]
a0134264 54304ae3 movt r3, #0xa054
a0134268 362701e3 movw r2, #0x1736
a013426c 54004ae3 movt r0, #0xa054
a0134270 9dcb05eb bl #0xa02a70ec
a0134274 defbffea b #0xa01331f4
a0134278 183095e5 ldr r3, [r5, #0x18]
a013427c 000053e3 cmp r3, #0
a0134280 defcff1a bne #0xa0133600
a0134284 7c2003e3 movw r2, #0x307c
a0134288 4c0802e3 movw r0, #0x284c
a013428c 6f204ae3 movt r2, #0xa06f
a0134290 6c3a05e3 movw r3, #0x5a6c
a0134294 041092e5 ldr r1, [r2, #4]
a0134298 54304ae3 movt r3, #0xa054
a013429c df2601e3 movw r2, #0x16df
a01342a0 54004ae3 movt r0, #0xa054
a01342a4 90cb05eb bl #0xa02a70ec
a01342a8 b3fbffea b #0xa013317c
a01342ac 7c2003e3 movw r2, #0x307c
a01342b0 4c0802e3 movw r0, #0x284c
a01342b4 6f204ae3 movt r2, #0xa06f
a01342b8 6c3a05e3 movw r3, #0x5a6c
a01342bc 041092e5 ldr r1, [r2, #4]
a01342c0 54304ae3 movt r3, #0xa054
a01342c4 b92601e3 movw r2, #0x16b9
a01342c8 54004ae3 movt r0, #0xa054
a01342cc 86cb05eb bl #0xa02a70ec
a01342d0 c7fbffea b #0xa01331f4
a01342d4 7c2003e3 movw r2, #0x307c
a01342d8 4c0802e3 movw r0, #0x284c
a01342dc 6f204ae3 movt r2, #0xa06f
a01342e0 6c3a05e3 movw r3, #0x5a6c
a01342e4 041092e5 ldr r1, [r2, #4]
a01342e8 54304ae3 movt r3, #0xa054
a01342ec 9f2601e3 movw r2, #0x169f
a01342f0 54004ae3 movt r0, #0xa054
a01342f4 7ccb05eb bl #0xa02a70ec
a01342f8 bdfbffea b #0xa01331f4
a01342fc 08309ae5 ldr r3, [sl, #8]
a0134300 0200a0e3 mov r0, #2
a0134304 00409ae5 ldr r4, [sl]
a0134308 002093e5 ldr r2, [r3]
a013430c 0410a0e1 mov r1, r4
a0134310 ac3603eb bl #0xa0201dc8
a0134314 0410a0e1 mov r1, r4
a0134318 0200a0e3 mov r0, #2
a013431c e93703eb bl #0xa02022c8
a0134320 ab1100e3 movw r1, #0x1ab
a0134324 ba2300e3 movw r2, #0x3ba
a0134328 0200a0e3 mov r0, #2
a013432c a53603eb bl #0xa0201dc8
a0134330 ab1100e3 movw r1, #0x1ab
a0134334 0200a0e3 mov r0, #2
a0134338 e23703eb bl #0xa02022c8
a013433c 40f8ffea b #0xa0132444
a0134340 08309ae5 ldr r3, [sl, #8]
a0134344 0200a0e3 mov r0, #2
a0134348 00409ae5 ldr r4, [sl]
a013434c 042093e5 ldr r2, [r3, #4]
a0134350 0410a0e1 mov r1, r4
a0134354 9b3603eb bl #0xa0201dc8
a0134358 0410a0e1 mov r1, r4
a013435c 0200a0e3 mov r0, #2
a0134360 d83703eb bl #0xa02022c8
a0134364 ab1100e3 movw r1, #0x1ab
a0134368 bb2300e3 movw r2, #0x3bb
a013436c 0200a0e3 mov r0, #2
a0134370 943603eb bl #0xa0201dc8
a0134374 ab1100e3 movw r1, #0x1ab
a0134378 0200a0e3 mov r0, #2
a013437c d13703eb bl #0xa02022c8
a0134380 b4fbffea b #0xa0133258
a0134384 0200a0e3 mov r0, #2
a0134388 ad1100e3 movw r1, #0x1ad
a013438c d8208de2 add r2, sp, #0xd8
a0134390 0130a0e3 mov r3, #1
a0134394 623803eb bl #0xa0202524
a0134398 00c050e2 subs ip, r0, #0
a013439c 3600001a bne #0xa013447c
a01343a0 d8209de5 ldr r2, [sp, #0xd8]
a01343a4 0200a0e3 mov r0, #2
a01343a8 dc309de5 ldr r3, [sp, #0xdc]
a01343ac ad1100e3 movw r1, #0x1ad
a01343b0 00c08de5 str ip, [sp]
a01343b4 453703eb bl #0xa02020d0
a01343b8 ae0100e3 movw r0, #0x1ae
a01343bc 0f10a0e3 mov r1, #0xf
a01343c0 0020a0e3 mov r2, #0
a01343c4 17e3ffeb bl #0xa012d028
a01343c8 c3f9ffea b #0xa0132adc
a01343cc 8132a0e1 lsl r3, r1, #5
a01343d0 dc2802e3 movw r2, #0x28dc
a01343d4 6a204ae3 movt r2, #0xa06a
a01343d8 813143e0 sub r3, r3, r1, lsl #3
a01343dc 032092e7 ldr r2, [r2, r3]
a01343e0 2afdffea b #0xa0133890
a01343e4 d8108de2 add r1, sp, #0xd8
a01343e8 1f20a0e3 mov r2, #0x1f
a01343ec 2c008de2 add r0, sp, #0x2c
a01343f0 2c70cde5 strb r7, [sp, #0x2c]
a01343f4 d8708de5 str r7, [sp, #0xd8]
a01343f8 dc708de5 str r7, [sp, #0xdc]
a01343fc e0708de5 str r7, [sp, #0xe0]
a0134400 e4708de5 str r7, [sp, #0xe4]
a0134404 e8708de5 str r7, [sp, #0xe8]
a0134408 ec708de5 str r7, [sp, #0xec]
a013440c f0708de5 str r7, [sp, #0xf0]
a0134410 f4708de5 str r7, [sp, #0xf4]
a0134414 9a7d00eb bl #0xa0153a84
a0134418 0720a0e1 mov r2, r7
a013441c 0730a0e1 mov r3, r7
a0134420 d8108de2 add r1, sp, #0xd8
a0134424 2c00dde5 ldrb r0, [sp, #0x2c]
a0134428 bc4100eb bl #0xa0144b20
a013442c 4f20dae5 ldrb r2, [sl, #0x4f]
a0134430 0271a0e1 lsl r7, r2, #2
a0134434 027267e0 rsb r7, r7, r2, lsl #4
a0134438 3efcffea b #0xa0133538
a013443c 7c2003e3 movw r2, #0x307c
a0134440 4c0802e3 movw r0, #0x284c
a0134444 6f204ae3 movt r2, #0xa06f
a0134448 6c3a05e3 movw r3, #0x5a6c
a013444c 041092e5 ldr r1, [r2, #4]
a0134450 54304ae3 movt r3, #0xa054
a0134454 942601e3 movw r2, #0x1694
a0134458 54004ae3 movt r0, #0xa054
a013445c 22cb05eb bl #0xa02a70ec
a0134460 63fbffea b #0xa01331f4
a0134464 8132a0e1 lsl r3, r1, #5
a0134468 882f00e3 movw r2, #0xf88
a013446c 6a204ae3 movt r2, #0xa06a
a0134470 813143e0 sub r3, r3, r1, lsl #3
a0134474 032092e7 ldr r2, [r2, r3]
a0134478 04fdffea b #0xa0133890
a013447c 7c3003e3 movw r3, #0x307c
a0134480 ad2100e3 movw r2, #0x1ad
a0134484 6f304ae3 movt r3, #0xa06f
a0134488 a00102e3 movw r0, #0x21a0
a013448c 081093e5 ldr r1, [r3, #8]
a0134490 cc3b00e3 movw r3, #0xbcc
a0134494 00208de5 str r2, [sp]
a0134498 54304ae3 movt r3, #0xa054
a013449c 812300e3 movw r2, #0x381
a01344a0 54004ae3 movt r0, #0xa054
a01344a4 10cb05eb bl #0xa02a70ec
a01344a8 c2ffffea b #0xa01343b8
a01344ac 7c2003e3 movw r2, #0x307c
a01344b0 4c0802e3 movw r0, #0x284c
a01344b4 6f204ae3 movt r2, #0xa06f
a01344b8 6c3a05e3 movw r3, #0x5a6c
a01344bc 041092e5 ldr r1, [r2, #4]
a01344c0 54304ae3 movt r3, #0xa054
a01344c4 1a2701e3 movw r2, #0x171a
a01344c8 54004ae3 movt r0, #0xa054
a01344cc 06cb05eb bl #0xa02a70ec
a01344d0 29fbffea b #0xa013317c
a01344d4 7c2003e3 movw r2, #0x307c
a01344d8 4c0802e3 movw r0, #0x284c
a01344dc 6f204ae3 movt r2, #0xa06f
a01344e0 6c3a05e3 movw r3, #0x5a6c
a01344e4 041092e5 ldr r1, [r2, #4]
a01344e8 54304ae3 movt r3, #0xa054
a01344ec 252701e3 movw r2, #0x1725
a01344f0 54004ae3 movt r0, #0xa054
a01344f4 fcca05eb bl #0xa02a70ec
a01344f8 1ffbffea b #0xa013317c
a01344fc 0070a0e3 mov r7, #0
a0134500 14c08de5 str ip, [sp, #0x14]
a0134504 0700a0e1 mov r0, r7
a0134508 3170cae5 strb r7, [sl, #0x31]
a013450c 07b0a0e1 mov fp, r7
a0134510 e9db00eb bl #0xa016b4bc
a0134514 14c09de5 ldr ip, [sp, #0x14]
a0134518 d9fbffea b #0xa0133484
a013451c 7c2003e3 movw r2, #0x307c
a0134520 4c0802e3 movw r0, #0x284c
a0134524 6f204ae3 movt r2, #0xa06f
a0134528 6c3a05e3 movw r3, #0x5a6c
a013452c 041092e5 ldr r1, [r2, #4]
a0134530 54304ae3 movt r3, #0xa054
a0134534 792601e3 movw r2, #0x1679
a0134538 54004ae3 movt r0, #0xa054
a013453c eaca05eb bl #0xa02a70ec
a0134540 2bfbffea b #0xa01331f4
a0134544 3130d3e5 ldrb r3, [r3, #0x31]
a0134548 050053e3 cmp r3, #5
a013454c 58fcff9a bls #0xa01336b4
a0134550 2d4400e3 movw r4, #0x42d
a0134554 08fbffea b #0xa013317c
a0134558 3830d3e5 ldrb r3, [r3, #0x38]
a013455c 050053e3 cmp r3, #5
a0134560 faffff8a bhi #0xa0134550
a0134564 52fcffea b #0xa01336b4
a0134568 7c2003e3 movw r2, #0x307c
a013456c 4c0802e3 movw r0, #0x284c
a0134570 6f204ae3 movt r2, #0xa06f
a0134574 6c3a05e3 movw r3, #0x5a6c
a0134578 041092e5 ldr r1, [r2, #4]
a013457c 54304ae3 movt r3, #0xa054
a0134580 ce2601e3 movw r2, #0x16ce
a0134584 54004ae3 movt r0, #0xa054
a0134588 d7ca05eb bl #0xa02a70ec
a013458c fafaffea b #0xa013317c
a0134590 0700a0e1 mov r0, r7
a0134594 3570cae5 strb r7, [sl, #0x35]
a0134598 07b0a0e1 mov fp, r7
a013459c 7fd700eb bl #0xa016a3a0
a01345a0 58209de5 ldr r2, [sp, #0x58]
a01345a4 1dffffea b #0xa0134220

FUNCTION 0xa0138f84
a0138f84 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0138f88 0050a0e1 mov r5, r0
a0138f8c 24d04de2 sub sp, sp, #0x24
a0138f90 0270a0e1 mov r7, r2
a0138f94 f40f03e3 movw r0, #0x3ff4
a0138f98 182b0fe3 movw r2, #0xfb18
a0138f9c 00c0a0e3 mov ip, #0
a0138fa0 00108de5 str r1, [sp]
a0138fa4 01b0a0e1 mov fp, r1
a0138fa8 0360a0e1 mov r6, r3
a0138fac 54004ae3 movt r0, #0xa054
a0138fb0 0530a0e1 mov r3, r5
a0138fb4 53204ae3 movt r2, #0xa053
a0138fb8 011c02e3 movw r1, #0x2c01
a0138fbc 18c08de5 str ip, [sp, #0x18]
a0138fc0 1cc08de5 str ip, [sp, #0x1c]
a0138fc4 48b805eb bl #0xa02a70ec
a0138fc8 210055e3 cmp r5, #0x21
a0138fcc 8400000a beq #0xa01391e4
a0138fd0 48309de5 ldr r3, [sp, #0x48]
a0138fd4 000053e3 cmp r3, #0
a0138fd8 7d00001a bne #0xa01391d4
a0138fdc d84c05e3 movw r4, #0x5cd8
a0138fe0 05414ae3 movt r4, #0xa105
a0138fe4 3c3094e5 ldr r3, [r4, #0x3c]
a0138fe8 0c0053e3 cmp r3, #0xc
a0138fec 3600000a beq #0xa01390cc
a0138ff0 015045e2 sub r5, r5, #1
a0138ff4 42e1ffeb bl #0xa0131504
a0138ff8 310055e3 cmp r5, #0x31
a0138ffc 05f19f97 ldrls pc, [pc, r5, lsl #2]
a0139000 860e00ea b #0xa013ca20
a01390cc 015045e2 sub r5, r5, #1
a01390d0 310055e3 cmp r5, #0x31
a01390d4 05f19f97 ldrls pc, [pc, r5, lsl #2]
a01390d8 160300ea b #0xa0139d38
a01391a4 48310ce3 movw r3, #0xc148
a01391a8 fb304ae3 movt r3, #0xa0fb
a01391ac 4900d3e5 ldrb r0, [r3, #0x49]
a01391b0 010050e2 subs r0, r0, #1
a01391b4 0100a013 movne r0, #1
a01391b8 dcc600eb bl #0xa016ad30
a01391bc 000050e3 cmp r0, #0
a01391c0 7a06000a beq #0xa013abb0
a01391c4 0050a0e3 mov r5, #0
a01391c8 0500a0e1 mov r0, r5
a01391cc 24d08de2 add sp, sp, #0x24
a01391d0 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a01391d4 62daffeb bl #0xa012fb64
a01391d8 000050e3 cmp r0, #0
a01391dc 7effff0a beq #0xa0138fdc
a01391e0 f7ffffea b #0xa01391c4
a01391e4 ac4e07e3 movw r4, #0x7eac
a01391e8 240004e3 movw r0, #0x4024
a01391ec fb404ae3 movt r4, #0xa0fb
a01391f0 182b0fe3 movw r2, #0xfb18
a01391f4 00c094e5 ldr ip, [r4]
a01391f8 54004ae3 movt r0, #0xa054
a01391fc 53204ae3 movt r2, #0xa053
a0139200 041c02e3 movw r1, #0x2c04
a0139204 01c08ce2 add ip, ip, #1
a0139208 0c30a0e1 mov r3, ip
a013920c 00c084e5 str ip, [r4]
a0139210 b5b705eb bl #0xa02a70ec
a0139214 003094e5 ldr r3, [r4]
a0139218 010053e3 cmp r3, #1
a013921c a008000a beq #0xa013b4a4
a0139220 d83c05e3 movw r3, #0x5cd8
a0139224 05314ae3 movt r3, #0xa105
a0139228 3c3093e5 ldr r3, [r3, #0x3c]
a013922c 0c0053e3 cmp r3, #0xc
a0139230 e3ffff0a beq #0xa01391c4
a0139234 b2e0ffeb bl #0xa0131504
a0139238 0050a0e3 mov r5, #0
a013923c e1ffffea b #0xa01391c8
a0139240 eb3200e3 movw r3, #0x2eb
a0139244 03005be1 cmp fp, r3
a0139248 0050a013 movne r5, #0
a013924c ddffff1a bne #0xa01391c8
a0139250 98feffeb bl #0xa0138cb8
a0139254 0050a0e3 mov r5, #0
a0139258 daffffea b #0xa01391c8
a013925c 0b10a0e1 mov r1, fp
a0139260 f52100e3 movw r2, #0x1f5
a0139264 0100a0e3 mov r0, #1
a0139268 0050a0e3 mov r5, #0
a013926c d3e3ffeb bl #0xa01321c0
a0139270 d4ffffea b #0xa01391c8
a0139274 3c3094e5 ldr r3, [r4, #0x3c]
a0139278 0c0053e3 cmp r3, #0xc
a013927c d0ffff0a beq #0xa01391c4
a0139280 0010a0e3 mov r1, #0
a0139284 1b00a0e3 mov r0, #0x1b
a0139288 0120a0e1 mov r2, r1
a013928c 0150a0e1 mov r5, r1
a0139290 cae3ffeb bl #0xa01321c0
a0139294 cbffffea b #0xa01391c8
a0139298 a1005be3 cmp fp, #0xa1
a013929c 0050a013 movne r5, #0
a01392a0 c8ffff1a bne #0xa01391c8
a01392a4 a7c0d4e5 ldrb ip, [r4, #0xa7]
a01392a8 080104e3 movw r0, #0x4108
a01392ac 182b0fe3 movw r2, #0xfb18
a01392b0 a630d4e5 ldrb r3, [r4, #0xa6]
a01392b4 54004ae3 movt r0, #0xa054
a01392b8 53204ae3 movt r2, #0xa053
a01392bc f71c02e3 movw r1, #0x2cf7
a01392c0 00c08de5 str ip, [sp]
a01392c4 88b705eb bl #0xa02a70ec
a01392c8 a630d4e5 ldrb r3, [r4, #0xa6]
a01392cc 010053e3 cmp r3, #1
a01392d0 ab0a000a beq #0xa013bd84
a01392d4 a730d4e5 ldrb r3, [r4, #0xa7]
a01392d8 010053e3 cmp r3, #1
a01392dc b8ffff1a bne #0xa01391c4
a01392e0 740104e3 movw r0, #0x4174
a01392e4 182b0fe3 movw r2, #0xfb18
a01392e8 53204ae3 movt r2, #0xa053
a01392ec fd1c02e3 movw r1, #0x2cfd
a01392f0 54004ae3 movt r0, #0xa054
a01392f4 0050a0e3 mov r5, #0
a01392f8 7bb705eb bl #0xa02a70ec
a01392fc 0200a0e3 mov r0, #2
a0139300 92d9ffeb bl #0xa012f950
a0139304 afffffea b #0xa01391c8
a0139308 aa30d4e5 ldrb r3, [r4, #0xaa]
a013930c 000053e3 cmp r3, #0
a0139310 ce08000a beq #0xa013b650
a0139314 bc3d0ce3 movw r3, #0xcdbc
a0139318 0010a0e3 mov r1, #0
a013931c 69304ae3 movt r3, #0xa069
a0139320 0120a0e1 mov r2, r1
a0139324 00308de5 str r3, [sp]
a0139328 1c008de2 add r0, sp, #0x1c
a013932c 0130a0e1 mov r3, r1
a0139330 23d2ffeb bl #0xa012dbc4
a0139334 005050e2 subs r5, r0, #0
a0139338 5e08001a bne #0xa013b4b8
a013933c 1c309de5 ldr r3, [sp, #0x1c]
a0139340 010053e3 cmp r3, #1
a0139344 5b0800da ble #0xa013b4b8
a0139348 e9005be3 cmp fp, #0xe9
a013934c 6809000a beq #0xa013b8f4
a0139350 ea005be3 cmp fp, #0xea
a0139354 9bffff1a bne #0xa01391c8
a0139358 0510a0e1 mov r1, r5
a013935c 0520a0e1 mov r2, r5
a0139360 0d00a0e3 mov r0, #0xd
a0139364 95e3ffeb bl #0xa01321c0
a0139368 96ffffea b #0xa01391c8
a013936c ee005be3 cmp fp, #0xee
a0139370 5508000a beq #0xa013b4cc
a0139374 ef005be3 cmp fp, #0xef
a0139378 0200000a beq #0xa0139388
a013937c ed005be3 cmp fp, #0xed
a0139380 0050a013 movne r5, #0
a0139384 8fffff1a bne #0xa01391c8
a0139388 7c2003e3 movw r2, #0x307c
a013938c a00004e3 movw r0, #0x40a0
a0139390 6f204ae3 movt r2, #0xa06f
a0139394 183b0fe3 movw r3, #0xfb18
a0139398 041092e5 ldr r1, [r2, #4]
a013939c 0050a0e3 mov r5, #0
a01393a0 00b08de5 str fp, [sp]
a01393a4 53304ae3 movt r3, #0xa053
a01393a8 9b2c02e3 movw r2, #0x2c9b
a01393ac 54004ae3 movt r0, #0xa054
a01393b0 4db705eb bl #0xa02a70ec
a01393b4 0510a0e1 mov r1, r5
a01393b8 0520a0e1 mov r2, r5
a01393bc 0e00a0e3 mov r0, #0xe
a01393c0 7ee3ffeb bl #0xa01321c0
a01393c4 7fffffea b #0xa01391c8
a01393c8 bc2294e5 ldr r2, [r4, #0x2bc]
a01393cc 7c3003e3 movw r3, #0x307c
a01393d0 6f304ae3 movt r3, #0xa06f
a01393d4 c80004e3 movw r0, #0x40c8
a01393d8 041093e5 ldr r1, [r3, #4]
a01393dc 183b0fe3 movw r3, #0xfb18
a01393e0 04208de5 str r2, [sp, #4]
a01393e4 53304ae3 movt r3, #0xa053
a01393e8 a12c02e3 movw r2, #0x2ca1
a01393ec 54004ae3 movt r0, #0xa054
a01393f0 00b08de5 str fp, [sp]
a01393f4 3cb705eb bl #0xa02a70ec
a01393f8 072100e3 movw r2, #0x107
a01393fc d83c05e3 movw r3, #0x5cd8
a0139400 02005be1 cmp fp, r2
a0139404 05314ae3 movt r3, #0xa105
a0139408 6dffff1a bne #0xa01391c4
a013940c 0050a0e3 mov r5, #0
a0139410 bc0293e5 ldr r0, [r3, #0x2bc]
a0139414 e7f4ffeb bl #0xa01367b8
a0139418 0510a0e1 mov r1, r5
a013941c 0520a0e1 mov r2, r5
a0139420 0d00a0e3 mov r0, #0xd
a0139424 65e3ffeb bl #0xa01321c0
a0139428 66ffffea b #0xa01391c8
a013942c 42bf4be2 sub fp, fp, #0x108
a0139430 01b04be2 sub fp, fp, #1
a0139434 03005be3 cmp fp, #3
a0139438 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a013943c a60d00ea b #0xa013cadc
a0139450 7c2003e3 movw r2, #0x307c
a0139454 a00004e3 movw r0, #0x40a0
a0139458 6f204ae3 movt r2, #0xa06f
a013945c 183b0fe3 movw r3, #0xfb18
a0139460 041092e5 ldr r1, [r2, #4]
a0139464 53304ae3 movt r3, #0xa053
a0139468 54004ae3 movt r0, #0xa054
a013946c 00b08de5 str fp, [sp]
a0139470 bd2c02e3 movw r2, #0x2cbd
a0139474 1cb705eb bl #0xa02a70ec
a0139478 373100e3 movw r3, #0x137
a013947c 03005be1 cmp fp, r3
a0139480 4fffff1a bne #0xa01391c4
a0139484 48310ce3 movw r3, #0xc148
a0139488 0050a0e3 mov r5, #0
a013948c fb304ae3 movt r3, #0xa0fb
a0139490 3f00d3e5 ldrb r0, [r3, #0x3f]
a0139494 70c600eb bl #0xa016ae5c
a0139498 0510a0e1 mov r1, r5
a013949c 0520a0e1 mov r2, r5
a01394a0 0f00a0e3 mov r0, #0xf
a01394a4 45e3ffeb bl #0xa01321c0
a01394a8 46ffffea b #0xa01391c8
a01394ac bc3d0ce3 movw r3, #0xcdbc
a01394b0 0010a0e3 mov r1, #0
a01394b4 69304ae3 movt r3, #0xa069
a01394b8 0120a0e1 mov r2, r1
a01394bc 00308de5 str r3, [sp]
a01394c0 1c008de2 add r0, sp, #0x1c
a01394c4 0130a0e1 mov r3, r1
a01394c8 bdd1ffeb bl #0xa012dbc4
a01394cc 000050e3 cmp r0, #0
a01394d0 0030a013 movne r3, #0
a01394d4 0300001a bne #0xa01394e8
a01394d8 1c309de5 ldr r3, [sp, #0x1c]
a01394dc 010053e3 cmp r3, #1
a01394e0 0030a0d3 movle r3, #0
a01394e4 0130a0c3 movgt r3, #1
a01394e8 4ebf4be2 sub fp, fp, #0x138
a01394ec 01b04be2 sub fp, fp, #1
a01394f0 03005be3 cmp fp, #3
a01394f4 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a01394f8 750d00ea b #0xa013cad4
a013950c 7c2003e3 movw r2, #0x307c
a0139510 a00004e3 movw r0, #0x40a0
a0139514 6f204ae3 movt r2, #0xa06f
a0139518 183b0fe3 movw r3, #0xfb18
a013951c 041092e5 ldr r1, [r2, #4]
a0139520 53304ae3 movt r3, #0xa053
a0139524 54004ae3 movt r0, #0xa054
a0139528 00b08de5 str fp, [sp]
a013952c e82c02e3 movw r2, #0x2ce8
a0139530 edb605eb bl #0xa02a70ec
a0139534 413100e3 movw r3, #0x141
a0139538 03005be1 cmp fp, r3
a013953c 9708000a beq #0xa013b7a0
a0139540 0010a0e3 mov r1, #0
a0139544 1100a0e3 mov r0, #0x11
a0139548 0120a0e1 mov r2, r1
a013954c 0150a0e1 mov r5, r1
a0139550 1ae3ffeb bl #0xa01321c0
a0139554 1bffffea b #0xa01391c8
a0139558 d43c05e3 movw r3, #0x5cd4
a013955c 0040a0e3 mov r4, #0
a0139560 05314ae3 movt r3, #0xa105
a0139564 003093e5 ldr r3, [r3]
a0139568 bc40c3e5 strb r4, [r3, #0xbc]
a013956c 9e7a05eb bl #0xa0297fec
a0139570 002050e2 subs r2, r0, #0
a0139574 dd07001a bne #0xa013b4f0
a0139578 0810a0e3 mov r1, #8
a013957c 39f700eb bl #0xa0177268
a0139580 544c01eb bl #0xa018c6d8
a0139584 0050a0e3 mov r5, #0
a0139588 0effffea b #0xa01391c8
a013958c 5c3094e5 ldr r3, [r4, #0x5c]
a0139590 110053e3 cmp r3, #0x11
a0139594 03f19f97 ldrls pc, [pc, r3, lsl #2]
a0139598 770700ea b #0xa013b37c
a01395e4 5c3094e5 ldr r3, [r4, #0x5c]
a01395e8 0c3043e2 sub r3, r3, #0xc
a01395ec 090053e3 cmp r3, #9
a01395f0 03f19f97 ldrls pc, [pc, r3, lsl #2]
a01395f4 5c0700ea b #0xa013b36c
a0139620 19be4be2 sub fp, fp, #0x190
a0139624 0b005be3 cmp fp, #0xb
a0139628 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a013962c ac0500ea b #0xa013ace4
a0139660 6a3f4be2 sub r3, fp, #0x1a8
a0139664 023043e2 sub r3, r3, #2
a0139668 120053e3 cmp r3, #0x12
a013966c 03f19f97 ldrls pc, [pc, r3, lsl #2]
a0139670 9d0500ea b #0xa013acec
a01396c0 313200e3 movw r3, #0x231
a01396c4 03005be1 cmp fp, r3
a01396c8 e507000a beq #0xa013b664
a01396cc 930700ca bgt #0xa013b520
a01396d0 230e5be3 cmp fp, #0x230
a01396d4 e807001a bne #0xa013b67c
a01396d8 60320ce3 movw r3, #0xc260
a01396dc 306c03e3 movw r6, #0x3c30
a01396e0 fb304ae3 movt r3, #0xa0fb
a01396e4 684b02e3 movw r4, #0x2b68
a01396e8 00c093e5 ldr ip, [r3]
a01396ec fb604ae3 movt r6, #0xa0fb
a01396f0 00e096e5 ldr lr, [r6]
a01396f4 6a404ae3 movt r4, #0xa06a
a01396f8 c40904e3 movw r0, #0x49c4
a01396fc 182b0fe3 movw r2, #0xfb18
a0139700 53204ae3 movt r2, #0xa053
a0139704 371f02e3 movw r1, #0x2f37
a0139708 0c32a0e1 lsl r3, ip, #4
a013970c 04e08de5 str lr, [sp, #4]
a0139710 54004ae3 movt r0, #0xa054
a0139714 0c3183e0 add r3, r3, ip, lsl #2
a0139718 033183e0 add r3, r3, r3, lsl #2
a013971c 033084e0 add r3, r4, r3
a0139720 405083e2 add r5, r3, #0x40
a0139724 04c095e5 ldr ip, [r5, #4]
a0139728 00c08de5 str ip, [sp]
a013972c 6eb605eb bl #0xa02a70ec
a0139730 d43404e3 movw r3, #0x44d4
a0139734 0010a0e3 mov r1, #0
a0139738 6d304ae3 movt r3, #0xa06d
a013973c 6820a0e3 mov r2, #0x68
a0139740 000093e5 ldr r0, [r3]
a0139744 9de2ffeb bl #0xa01321c0
a0139748 1400a0e3 mov r0, #0x14
a013974c f30a0aeb bl #0xa03bc320
a0139750 043095e5 ldr r3, [r5, #4]
a0139754 000053e3 cmp r3, #0
a0139758 4a0900ba blt #0xa013bc88
a013975c 007096e5 ldr r7, [r6]
a0139760 110200e3 movw r0, #0x211
a0139764 b4cdffeb bl #0xa012ce3c
a0139768 04c095e5 ldr ip, [r5, #4]
a013976c 0010a0e3 mov r1, #0
a0139770 6620a0e3 mov r2, #0x66
a0139774 0150a0e1 mov r5, r1
a0139778 0732a0e1 lsl r3, r7, #4
a013977c 00c086e5 str ip, [r6]
a0139780 073183e0 add r3, r3, r7, lsl #2
a0139784 033183e0 add r3, r3, r3, lsl #2
a0139788 034084e0 add r4, r4, r3
a013978c 480084e5 str r0, [r4, #0x48]
a0139790 1f00a0e3 mov r0, #0x1f
a0139794 89e2ffeb bl #0xa01321c0
a0139798 8afeffea b #0xa01391c8
a013979c a30f5be3 cmp fp, #0x28c
a01397a0 0908000a beq #0xa013b7cc
a01397a4 640056e3 cmp r6, #0x64
a01397a8 334047e2 sub r4, r7, #0x33
a01397ac 0060a0d3 movle r6, #0
a01397b0 0160a0c3 movgt r6, #1
a01397b4 a60054e3 cmp r4, #0xa6
a01397b8 0040a083 movhi r4, #0
a01397bc 01400692 andls r4, r6, #1
a01397c0 000054e3 cmp r4, #0
a01397c4 2608001a bne #0xa013b864
a01397c8 f15047e2 sub r5, r7, #0xf1
a01397cc 9e0055e3 cmp r5, #0x9e
a01397d0 0050a083 movhi r5, #0
a01397d4 01500692 andls r5, r6, #1
a01397d8 000055e3 cmp r5, #0
a01397dc 6c08001a bne #0xa013b994
a01397e0 6a3f47e2 sub r3, r7, #0x1a8
a01397e4 013043e2 sub r3, r3, #1
a01397e8 a00053e3 cmp r3, #0xa0
a01397ec 0060a083 movhi r6, #0
a01397f0 01600692 andls r6, r6, #1
a01397f4 000056e3 cmp r6, #0
a01397f8 7d08001a bne #0xa013b9f4
a01397fc a3bf4be2 sub fp, fp, #0x28c
a0139800 01b04be2 sub fp, fp, #1
a0139804 07005be3 cmp fp, #7
a0139808 0050a083 movhi r5, #0
a013980c 6dfeff8a bhi #0xa01391c8
a0139810 0020a0e3 mov r2, #0
a0139814 0700a0e1 mov r0, r7
a0139818 0230a0e1 mov r3, r2
a013981c 0110a0e3 mov r1, #1
a0139820 6f1b00eb bl #0xa01405e4
a0139824 0050a0e3 mov r5, #0
a0139828 66feffea b #0xa01391c8
a013982c 9f3200e3 movw r3, #0x29f
a0139830 03005be1 cmp fp, r3
a0139834 f107000a beq #0xa013b800
a0139838 640056e3 cmp r6, #0x64
a013983c 334047e2 sub r4, r7, #0x33
a0139840 0060a0d3 movle r6, #0
a0139844 0160a0c3 movgt r6, #1
a0139848 a60054e3 cmp r4, #0xa6
a013984c 0040a083 movhi r4, #0
a0139850 01400692 andls r4, r6, #1
a0139854 000054e3 cmp r4, #0
a0139858 f507001a bne #0xa013b834
a013985c f15047e2 sub r5, r7, #0xf1
a0139860 9e0055e3 cmp r5, #0x9e
a0139864 0050a083 movhi r5, #0
a0139868 01500692 andls r5, r6, #1
a013986c 000055e3 cmp r5, #0
a0139870 3b08001a bne #0xa013b964
a0139874 6a3f47e2 sub r3, r7, #0x1a8
a0139878 013043e2 sub r3, r3, #1
a013987c a00053e3 cmp r3, #0xa0
a0139880 0060a083 movhi r6, #0
a0139884 01600692 andls r6, r6, #1
a0139888 000056e3 cmp r6, #0
a013988c 4c08001a bne #0xa013b9c4
a0139890 2abe4be2 sub fp, fp, #0x2a0
a0139894 04005be3 cmp fp, #4
a0139898 0050a083 movhi r5, #0
a013989c 49feff8a bhi #0xa01391c8
a01398a0 0020a0e3 mov r2, #0
a01398a4 0700a0e1 mov r0, r7
a01398a8 0230a0e1 mov r3, r2
a01398ac 0110a0e3 mov r1, #1
a01398b0 9a1b00eb bl #0xa0140720
a01398b4 0050a0e3 mov r5, #0
a01398b8 42feffea b #0xa01391c8
a01398bc af3200e3 movw r3, #0x2af
a01398c0 03005be1 cmp fp, r3
a01398c4 1d07000a beq #0xa013b540
a01398c8 2b0e5be3 cmp fp, #0x2b0
a01398cc 1907001a bne #0xa013b538
a01398d0 0b10a0e1 mov r1, fp
a01398d4 f820a0e3 mov r2, #0xf8
a01398d8 0200a0e3 mov r0, #2
a01398dc 0050a0e3 mov r5, #0
a01398e0 382103eb bl #0xa0201dc8
a01398e4 0b10a0e1 mov r1, fp
a01398e8 0200a0e3 mov r0, #2
a01398ec 752203eb bl #0xa02022c8
a01398f0 d43404e3 movw r3, #0x44d4
a01398f4 0510a0e1 mov r1, r5
a01398f8 6d304ae3 movt r3, #0xa06d
a01398fc 6620a0e3 mov r2, #0x66
a0139900 000093e5 ldr r0, [r3]
a0139904 2de2ffeb bl #0xa01321c0
a0139908 1400a0e3 mov r0, #0x14
a013990c 830a0aeb bl #0xa03bc320
a0139910 0510a0e1 mov r1, r5
a0139914 6620a0e3 mov r2, #0x66
a0139918 1f00a0e3 mov r0, #0x1f
a013991c 27e2ffeb bl #0xa01321c0
a0139920 28feffea b #0xa01391c8
a0139924 b07905eb bl #0xa0297fec
a0139928 005050e2 subs r5, r0, #0
a013992c 24feff1a bne #0xa01391c4
a0139930 69ebffeb bl #0xa01346dc
a0139934 23feffea b #0xa01391c8
a0139938 7c1b04e3 movw r1, #0x4b7c
a013993c 0050a0e3 mov r5, #0
a0139940 13104ae3 movt r1, #0xa013
a0139944 0100a0e3 mov r0, #1
a0139948 63b402eb bl #0xa01e6adc
a013994c 0510a0e1 mov r1, r5
a0139950 6620a0e3 mov r2, #0x66
a0139954 1f00a0e3 mov r0, #0x1f
a0139958 18e2ffeb bl #0xa01321c0
a013995c 19feffea b #0xa01391c8
a0139960 b23200e3 movw r3, #0x2b2
a0139964 03005be1 cmp fp, r3
a0139968 2c07000a beq #0xa013b620
a013996c b33200e3 movw r3, #0x2b3
a0139970 03005be1 cmp fp, r3
a0139974 2707001a bne #0xa013b618
a0139978 4c3303e3 movw r3, #0x334c
a013997c 0010a0e3 mov r1, #0
a0139980 fb304ae3 movt r3, #0xa0fb
a0139984 0120a0e1 mov r2, r1
a0139988 183093e5 ldr r3, [r3, #0x18]
a013998c 9600a0e3 mov r0, #0x96
a0139990 33ff2fe1 blx r3
a0139994 0060a0e3 mov r6, #0
a0139998 940b04e3 movw r0, #0x4b94
a013999c 0610a0e1 mov r1, r6
a01399a0 54004ae3 movt r0, #0xa054
a01399a4 b262c4e5 strb r6, [r4, #0x2b2]
a01399a8 0650a0e1 mov r5, r6
a01399ac b46284e5 str r6, [r4, #0x2b4]
a01399b0 b862c4e5 strb r6, [r4, #0x2b8]
a01399b4 e26301eb bl #0xa0192944
a01399b8 0610a0e1 mov r1, r6
a01399bc 6620a0e3 mov r2, #0x66
a01399c0 1f00a0e3 mov r0, #0x1f
a01399c4 fde1ffeb bl #0xa01321c0
a01399c8 fefdffea b #0xa01391c8
a01399cc b63200e3 movw r3, #0x2b6
a01399d0 03005be1 cmp fp, r3
a01399d4 0707000a beq #0xa013b5f8
a01399d8 b93200e3 movw r3, #0x2b9
a01399dc 03005be1 cmp fp, r3
a01399e0 0050a013 movne r5, #0
a01399e4 f7fdff1a bne #0xa01391c8
a01399e8 0010a0e3 mov r1, #0
a01399ec 2800a0e3 mov r0, #0x28
a01399f0 0120a0e1 mov r2, r1
a01399f4 0150a0e1 mov r5, r1
a01399f8 f0e1ffeb bl #0xa01321c0
a01399fc f1fdffea b #0xa01391c8
a0139a00 f63200e3 movw r3, #0x2f6
a0139a04 03005be1 cmp fp, r3
a0139a08 5307000a beq #0xa013b75c
a0139a0c f73200e3 movw r3, #0x2f7
a0139a10 03005be1 cmp fp, r3
a0139a14 2e07000a beq #0xa013b6d4
a0139a18 f53200e3 movw r3, #0x2f5
a0139a1c 03005be1 cmp fp, r3
a0139a20 0050a013 movne r5, #0
a0139a24 e7fdff1a bne #0xa01391c8
a0139a28 0100a0e3 mov r0, #1
a0139a2c 2fd9ffeb bl #0xa012fef0
a0139a30 0010a0e3 mov r1, #0
a0139a34 1b00a0e3 mov r0, #0x1b
a0139a38 0120a0e1 mov r2, r1
a0139a3c dfe1ffeb bl #0xa01321c0
a0139a40 4ea0ffeb bl #0xa0121b80
a0139a44 000050e3 cmp r0, #0
a0139a48 ddfdff1a bne #0xa01391c4
a0139a4c 0000a0e3 mov r0, #0
a0139a50 0050a0e1 mov r5, r0
a0139a54 c17701eb bl #0xa0197960
a0139a58 dafdffea b #0xa01391c8
a0139a5c 733f4be2 sub r3, fp, #0x1cc
a0139a60 130053e3 cmp r3, #0x13
a0139a64 03f19f97 ldrls pc, [pc, r3, lsl #2]
a0139a68 a30400ea b #0xa013acfc
a0139abc 1fbe4be2 sub fp, fp, #0x1f0
a0139ac0 20005be3 cmp fp, #0x20
a0139ac4 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a0139ac8 890400ea b #0xa013acf4
a0139b50 57bf4be2 sub fp, fp, #0x15c
a0139b54 06005be3 cmp fp, #6
a0139b58 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a0139b5c c70b00ea b #0xa013ca80
a0139b7c cb3200e3 movw r3, #0x2cb
a0139b80 03005be1 cmp fp, r3
a0139b84 0050a013 movne r5, #0
a0139b88 8efdff1a bne #0xa01391c8
a0139b8c 0010a0e3 mov r1, #0
a0139b90 6620a0e3 mov r2, #0x66
a0139b94 1f00a0e3 mov r0, #0x1f
a0139b98 0150a0e1 mov r5, r1
a0139b9c 87e1ffeb bl #0xa01321c0
a0139ba0 88fdffea b #0xa01391c8
a0139ba4 0010a0e3 mov r1, #0
a0139ba8 6620a0e3 mov r2, #0x66
a0139bac 1f00a0e3 mov r0, #0x1f
a0139bb0 0150a0e1 mov r5, r1
a0139bb4 81e1ffeb bl #0xa01321c0
a0139bb8 82fdffea b #0xa01391c8
a0139bbc b7bf4be2 sub fp, fp, #0x2dc
a0139bc0 643008e3 movw r3, #0x8064
a0139bc4 01b04be2 sub fp, fp, #1
a0139bc8 09005be3 cmp fp, #9
a0139bcc 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a0139bd0 930700ea b #0xa013ba24
a0139bfc c33200e3 movw r3, #0x2c3
a0139c00 03005be1 cmp fp, r3
a0139c04 a706000a beq #0xa013b6a8
a0139c08 b10f5be3 cmp fp, #0x2c4
a0139c0c 9c06000a beq #0xa013b684
a0139c10 c13200e3 movw r3, #0x2c1
a0139c14 03005be1 cmp fp, r3
a0139c18 0050a013 movne r5, #0
a0139c1c 69fdff1a bne #0xa01391c8
a0139c20 0010a0e3 mov r1, #0
a0139c24 2930a0e3 mov r3, #0x29
a0139c28 0120a0e1 mov r2, r1
a0139c2c 2a00a0e3 mov r0, #0x2a
a0139c30 b43284e5 str r3, [r4, #0x2b4]
a0139c34 0150a0e1 mov r5, r1
a0139c38 60e1ffeb bl #0xa01321c0
a0139c3c 61fdffea b #0xa01391c8
a0139c40 c73200e3 movw r3, #0x2c7
a0139c44 03005be1 cmp fp, r3
a0139c48 5506000a beq #0xa013b5a4
a0139c4c b20f5be3 cmp fp, #0x2c8
a0139c50 0050a013 movne r5, #0
a0139c54 5bfdff1a bne #0xa01391c8
a0139c58 b40294e5 ldr r0, [r4, #0x2b4]
a0139c5c d83c05e3 movw r3, #0x5cd8
a0139c60 05314ae3 movt r3, #0xa105
a0139c64 0010a0e3 mov r1, #0
a0139c68 0050a0e3 mov r5, #0
a0139c6c 290050e3 cmp r0, #0x29
a0139c70 b222d305 ldrbeq r2, [r3, #0x2b2]
a0139c74 01204202 subeq r2, r2, #1
a0139c78 b222c305 strbeq r2, [r3, #0x2b2]
a0139c7c 0120a0e1 mov r2, r1
a0139c80 4ee1ffeb bl #0xa01321c0
a0139c84 b45284e5 str r5, [r4, #0x2b4]
a0139c88 4efdffea b #0xa01391c8
a0139c8c d23200e3 movw r3, #0x2d2
a0139c90 03005be1 cmp fp, r3
a0139c94 0050a013 movne r5, #0
a0139c98 4afdff1a bne #0xa01391c8
a0139c9c 0010a0e3 mov r1, #0
a0139ca0 6620a0e3 mov r2, #0x66
a0139ca4 1f00a0e3 mov r0, #0x1f
a0139ca8 0150a0e1 mov r5, r1
a0139cac 43e1ffeb bl #0xa01321c0
a0139cb0 44fdffea b #0xa01391c8
a0139cb4 3c3094e5 ldr r3, [r4, #0x3c]
a0139cb8 0c0053e3 cmp r3, #0xc
a0139cbc 40fdff0a beq #0xa01391c4
a0139cc0 16be4be2 sub fp, fp, #0x160
a0139cc4 03b04be2 sub fp, fp, #3
a0139cc8 18005be3 cmp fp, #0x18
a0139ccc 0bf19f97 ldrls pc, [pc, fp, lsl #2]
a0139cd0 a70500ea b #0xa013b374
a0139d38 0050a0e3 mov r5, #0
a0139d3c 21fdffea b #0xa01391c8
a0139d40 a431d4e5 ldrb r3, [r4, #0x1a4]
a0139d44 000053e3 cmp r3, #0
a0139d48 fcfdff1a bne #0xa0139540
a0139d4c 0010a0e3 mov r1, #0
a0139d50 1300a0e3 mov r0, #0x13
a0139d54 0120a0e1 mov r2, r1
a0139d58 0150a0e1 mov r5, r1
a0139d5c 17e1ffeb bl #0xa01321c0
a0139d60 18fdffea b #0xa01391c8
a0139d64 0010a0e3 mov r1, #0
a0139d68 0d00a0e3 mov r0, #0xd
a0139d6c 0120a0e1 mov r2, r1
a0139d70 0150a0e1 mov r5, r1
a0139d74 11e1ffeb bl #0xa01321c0
a0139d78 12fdffea b #0xa01391c8
a0139d7c 0010a0e3 mov r1, #0
a0139d80 1000a0e3 mov r0, #0x10
a0139d84 0120a0e1 mov r2, r1
a0139d88 0150a0e1 mov r5, r1
a0139d8c 0be1ffeb bl #0xa01321c0
a0139d90 0cfdffea b #0xa01391c8
a0139d94 0010a0e3 mov r1, #0
a0139d98 1300a0e3 mov r0, #0x13
a0139d9c 0120a0e1 mov r2, r1
a0139da0 0150a0e1 mov r5, r1
a0139da4 05e1ffeb bl #0xa01321c0
a0139da8 06fdffea b #0xa01391c8
a0139dac a521d4e5 ldrb r2, [r4, #0x1a5]
a0139db0 000052e3 cmp r2, #0
a0139db4 1f06001a bne #0xa013b638
a0139db8 010053e3 cmp r3, #1
a0139dbc 00fdff1a bne #0xa01391c4
a0139dc0 0010a0e3 mov r1, #0
a0139dc4 0d00a0e3 mov r0, #0xd
a0139dc8 0120a0e1 mov r2, r1
a0139dcc 0150a0e1 mov r5, r1
a0139dd0 fae0ffeb bl #0xa01321c0
a0139dd4 fbfcffea b #0xa01391c8
a0139dd8 0010a0e3 mov r1, #0
a0139ddc 1200a0e3 mov r0, #0x12
a0139de0 0120a0e1 mov r2, r1
a0139de4 0150a0e1 mov r5, r1
a0139de8 f4e0ffeb bl #0xa01321c0
a0139dec f5fcffea b #0xa01391c8
a0139df0 d08d03e3 movw r8, #0x3dd0
a0139df4 28500de3 movw r5, #0xd028
a0139df8 fb804ae3 movt r8, #0xa0fb
a0139dfc 1d9e4be2 sub sb, fp, #0x1d0
a0139e00 007098e5 ldr r7, [r8]
a0139e04 69504ae3 movt r5, #0xa069
a0139e08 019049e2 sub sb, sb, #1
a0139e0c 640604e3 movw r0, #0x4664
a0139e10 182b0fe3 movw r2, #0xfb18
a0139e14 00b08de5 str fp, [sp]
a0139e18 04908de5 str sb, [sp, #4]
a0139e1c 53204ae3 movt r2, #0xa053
a0139e20 8733a0e1 lsl r3, r7, #7
a0139e24 611e02e3 movw r1, #0x2e61
a0139e28 54004ae3 movt r0, #0xa054
a0139e2c 877243e0 sub r7, r3, r7, lsl #5
a0139e30 077085e0 add r7, r5, r7
a0139e34 0730a0e1 mov r3, r7
a0139e38 54a097e5 ldr sl, [r7, #0x54]
a0139e3c aab405eb bl #0xa02a70ec
a0139e40 941604e3 movw r1, #0x4694
a0139e44 0700a0e1 mov r0, r7
a0139e48 54104ae3 movt r1, #0xa054
a0139e4c 3cfe0efa blx #0xa04f9744
a0139e50 000050e3 cmp r0, #0
a0139e54 6907000a beq #0xa013bc00
a0139e58 d81604e3 movw r1, #0x46d8
a0139e5c 0700a0e1 mov r0, r7
a0139e60 54104ae3 movt r1, #0xa054
a0139e64 36fe0efa blx #0xa04f9744
a0139e68 000050e3 cmp r0, #0
a0139e6c 6007000a beq #0xa013bbf4
a0139e70 f01604e3 movw r1, #0x46f0
a0139e74 0700a0e1 mov r0, r7
a0139e78 54104ae3 movt r1, #0xa054
a0139e7c 30fe0efa blx #0xa04f9744
a0139e80 000050e3 cmp r0, #0
a0139e84 5707000a beq #0xa013bbe8
a0139e88 141704e3 movw r1, #0x4714
a0139e8c 0700a0e1 mov r0, r7
a0139e90 54104ae3 movt r1, #0xa054
a0139e94 2afe0efa blx #0xa04f9744
a0139e98 000050e3 cmp r0, #0
a0139e9c 3807000a beq #0xa013bb84
a0139ea0 781704e3 movw r1, #0x4778
a0139ea4 0700a0e1 mov r0, r7
a0139ea8 54104ae3 movt r1, #0xa054
a0139eac 24fe0efa blx #0xa04f9744
a0139eb0 000050e3 cmp r0, #0
a0139eb4 1100000a beq #0xa0139f00
a0139eb8 901704e3 movw r1, #0x4790
a0139ebc 0700a0e1 mov r0, r7
a0139ec0 54104ae3 movt r1, #0xa054
a0139ec4 1efe0efa blx #0xa04f9744
a0139ec8 000050e3 cmp r0, #0
a0139ecc 0b00000a beq #0xa0139f00
a0139ed0 ac1704e3 movw r1, #0x47ac
a0139ed4 0700a0e1 mov r0, r7
a0139ed8 54104ae3 movt r1, #0xa054
a0139edc 18fe0efa blx #0xa04f9744
a0139ee0 000050e3 cmp r0, #0
a0139ee4 0500000a beq #0xa0139f00
a0139ee8 c81704e3 movw r1, #0x47c8
a0139eec 0700a0e1 mov r0, r7
a0139ef0 54104ae3 movt r1, #0xa054
a0139ef4 12fe0efa blx #0xa04f9744
a0139ef8 000050e3 cmp r0, #0
a0139efc 1e00001a bne #0xa0139f7c
a0139f00 0000a0e3 mov r0, #0
a0139f04 18208de2 add r2, sp, #0x18
a0139f08 0010a0e1 mov r1, r0
a0139f0c 591e00eb bl #0xa0141878
a0139f10 18c09de5 ldr ip, [sp, #0x18]
a0139f14 7c2003e3 movw r2, #0x307c
a0139f18 0060a0e1 mov r6, r0
a0139f1c 6f204ae3 movt r2, #0xa06f
a0139f20 e80704e3 movw r0, #0x47e8
a0139f24 183b0fe3 movw r3, #0xfb18
a0139f28 081092e5 ldr r1, [r2, #8]
a0139f2c 54004ae3 movt r0, #0xa054
a0139f30 04608de5 str r6, [sp, #4]
a0139f34 53304ae3 movt r3, #0xa053
a0139f38 00c08de5 str ip, [sp]
a0139f3c 862e02e3 movw r2, #0x2e86
a0139f40 69b405eb bl #0xa02a70ec
a0139f44 000056e3 cmp r6, #0
a0139f48 48610ce3 movw r6, #0xc148
a0139f4c fb604a13 movtne r6, #0xa0fb
a0139f50 0400001a bne #0xa0139f68
a0139f54 fb604ae3 movt r6, #0xa0fb
a0139f58 18a09de5 ldr sl, [sp, #0x18]
a0139f5c 3530d6e5 ldrb r3, [r6, #0x35]
a0139f60 0a0053e1 cmp r3, sl
a0139f64 0400003a blo #0xa0139f7c
a0139f68 0030a0e3 mov r3, #0
a0139f6c 01a0a0e3 mov sl, #1
a0139f70 0300a0e1 mov r0, r3
a0139f74 3530c6e5 strb r3, [r6, #0x35]
a0139f78 08c100eb bl #0xa016a3a0
a0139f7c 2c1804e3 movw r1, #0x482c
a0139f80 0700a0e1 mov r0, r7
a0139f84 54104ae3 movt r1, #0xa054
a0139f88 edfd0efa blx #0xa04f9744
a0139f8c 000050e3 cmp r0, #0
a0139f90 1100000a beq #0xa0139fdc
a0139f94 481804e3 movw r1, #0x4848
a0139f98 0700a0e1 mov r0, r7
a0139f9c 54104ae3 movt r1, #0xa054
a0139fa0 e7fd0efa blx #0xa04f9744
a0139fa4 000050e3 cmp r0, #0
a0139fa8 0b00000a beq #0xa0139fdc
a0139fac 701804e3 movw r1, #0x4870
a0139fb0 0700a0e1 mov r0, r7
a0139fb4 54104ae3 movt r1, #0xa054
a0139fb8 e1fd0efa blx #0xa04f9744
a0139fbc 000050e3 cmp r0, #0
a0139fc0 0500000a beq #0xa0139fdc
a0139fc4 901804e3 movw r1, #0x4890
a0139fc8 0700a0e1 mov r0, r7
a0139fcc 54104ae3 movt r1, #0xa054
a0139fd0 dbfd0efa blx #0xa04f9744
a0139fd4 000050e3 cmp r0, #0
a0139fd8 1e00001a bne #0xa013a058
a0139fdc 0000a0e3 mov r0, #0
a0139fe0 18208de2 add r2, sp, #0x18
a0139fe4 0010a0e1 mov r1, r0
a0139fe8 122300eb bl #0xa0142c38
a0139fec 18c09de5 ldr ip, [sp, #0x18]
a0139ff0 7c2003e3 movw r2, #0x307c
a0139ff4 0060a0e1 mov r6, r0
a0139ff8 6f204ae3 movt r2, #0xa06f
a0139ffc b00804e3 movw r0, #0x48b0
a013a000 183b0fe3 movw r3, #0xfb18
a013a004 081092e5 ldr r1, [r2, #8]
a013a008 54004ae3 movt r0, #0xa054
a013a00c 04608de5 str r6, [sp, #4]
a013a010 53304ae3 movt r3, #0xa053
a013a014 00c08de5 str ip, [sp]
a013a018 a62e02e3 movw r2, #0x2ea6
a013a01c 32b405eb bl #0xa02a70ec
a013a020 000056e3 cmp r6, #0
a013a024 48610ce3 movw r6, #0xc148
a013a028 fb604a13 movtne r6, #0xa0fb
a013a02c 0400001a bne #0xa013a044
a013a030 fb604ae3 movt r6, #0xa0fb
a013a034 18a09de5 ldr sl, [sp, #0x18]
a013a038 6630d6e5 ldrb r3, [r6, #0x66]
a013a03c 0a0053e1 cmp r3, sl
a013a040 0400003a blo #0xa013a058
a013a044 0030a0e3 mov r3, #0
a013a048 01a0a0e3 mov sl, #1
a013a04c 0300a0e1 mov r0, r3
a013a050 6630c6e5 strb r3, [r6, #0x66]
a013a054 d8f3ffeb bl #0xa0136fbc
a013a058 09005ae1 cmp sl, sb
a013a05c 58fcffda ble #0xa01391c4
a013a060 006098e5 ldr r6, [r8]
a013a064 fc0804e3 movw r0, #0x48fc
a013a068 742606e3 movw r2, #0x6674
a013a06c 54004ae3 movt r0, #0xa054
a013a070 54204ae3 movt r2, #0xa054
a013a074 d71701e3 movw r1, #0x17d7
a013a078 d08d03e3 movw r8, #0x3dd0
a013a07c 8673a0e1 lsl r7, r6, #7
a013a080 fb804ae3 movt r8, #0xa0fb
a013a084 867247e0 sub r7, r7, r6, lsl #5
a013a088 077085e0 add r7, r5, r7
a013a08c 503097e5 ldr r3, [r7, #0x50]
a013a090 0030d3e5 ldrb r3, [r3]
a013a094 14b405eb bl #0xa02a70ec
a013a098 50c097e5 ldr ip, [r7, #0x50]
a013a09c 00005ce3 cmp ip, #0
a013a0a0 1e0a000a beq #0xa013c920
a013a0a4 001098e5 ldr r1, [r8]
a013a0a8 320051e3 cmp r1, #0x32
a013a0ac 3509000a beq #0xa013c588
a013a0b0 4c0051e3 cmp r1, #0x4c
a013a0b4 8709000a beq #0xa013c6d8
a013a0b8 300051e3 cmp r1, #0x30
a013a0bc 56005113 cmpne r1, #0x56
a013a0c0 0090cce5 strb sb, [ip]
a013a0c4 0180a003 moveq r8, #1
a013a0c8 0080a013 movne r8, #0
a013a0cc 0e09000a beq #0xa013c50c
a013a0d0 4b0051e3 cmp r1, #0x4b
a013a0d4 1e00a0e3 mov r0, #0x1e
a013a0d8 6920a0e3 mov r2, #0x69
a013a0dc e809000a beq #0xa013c884
a013a0e0 36e0ffeb bl #0xa01321c0
a013a0e4 1400a0e3 mov r0, #0x14
a013a0e8 8c080aeb bl #0xa03bc320
a013a0ec 5c3097e5 ldr r3, [r7, #0x5c]
a013a0f0 000053e3 cmp r3, #0
a013a0f4 0100000a beq #0xa013a100
a013a0f8 0900a0e1 mov r0, sb
a013a0fc 33ff2fe1 blx r3
a013a100 6030a0e3 mov r3, #0x60
a013a104 2c1804e3 movw r1, #0x482c
a013a108 935625e0 mla r5, r3, r6, r5
a013a10c 54104ae3 movt r1, #0xa054
a013a110 0500a0e1 mov r0, r5
a013a114 8afd0efa blx #0xa04f9744
a013a118 000050e3 cmp r0, #0
a013a11c ab09000a beq #0xa013c7d0
a013a120 901804e3 movw r1, #0x4890
a013a124 0500a0e1 mov r0, r5
a013a128 54104ae3 movt r1, #0xa054
a013a12c 84fd0efa blx #0xa04f9744
a013a130 000050e3 cmp r0, #0
a013a134 a509000a beq #0xa013c7d0
a013a138 701804e3 movw r1, #0x4870
a013a13c 0500a0e1 mov r0, r5
a013a140 54104ae3 movt r1, #0xa054
a013a144 7efd0efa blx #0xa04f9744
a013a148 000050e3 cmp r0, #0
a013a14c 9f09000a beq #0xa013c7d0
a013a150 481804e3 movw r1, #0x4848
a013a154 0500a0e1 mov r0, r5
a013a158 54104ae3 movt r1, #0xa054
a013a15c 78fd0efa blx #0xa04f9744
a013a160 000050e3 cmp r0, #0
a013a164 9909000a beq #0xa013c7d0
a013a168 0010a0e3 mov r1, #0
a013a16c 6a20a0e3 mov r2, #0x6a
a013a170 1d00a0e3 mov r0, #0x1d
a013a174 0150a0e1 mov r5, r1
a013a178 10e0ffeb bl #0xa01321c0
a013a17c 11fcffea b #0xa01391c8
a013a180 d08d03e3 movw r8, #0x3dd0
a013a184 6820a0e3 mov r2, #0x68
a013a188 fb804ae3 movt r8, #0xa0fb
a013a18c 1e00a0e3 mov r0, #0x1e
a013a190 001098e5 ldr r1, [r8]
a013a194 09e0ffeb bl #0xa01321c0
a013a198 1400a0e3 mov r0, #0x14
a013a19c 5f080aeb bl #0xa03bc320
a013a1a0 003098e5 ldr r3, [r8]
a013a1a4 28e00de3 movw lr, #0xd028
a013a1a8 69e04ae3 movt lr, #0xa069
a013a1ac 3c0604e3 movw r0, #0x463c
a013a1b0 182b0fe3 movw r2, #0xfb18
a013a1b4 141e02e3 movw r1, #0x2e14
a013a1b8 54004ae3 movt r0, #0xa054
a013a1bc 53204ae3 movt r2, #0xa053
a013a1c0 83c3a0e1 lsl ip, r3, #7
a013a1c4 83324ce0 sub r3, ip, r3, lsl #5
a013a1c8 03308ee0 add r3, lr, r3
a013a1cc c6b305eb bl #0xa02a70ec
a013a1d0 001098e5 ldr r1, [r8]
a013a1d4 300051e3 cmp r1, #0x30
a013a1d8 56005113 cmpne r1, #0x56
a013a1dc 0140a003 moveq r4, #1
a013a1e0 0040a013 movne r4, #0
a013a1e4 4e06000a beq #0xa013bb24
a013a1e8 4b0051e3 cmp r1, #0x4b
a013a1ec ab08000a beq #0xa013c4a0
a013a1f0 320051e3 cmp r1, #0x32
a013a1f4 c706000a beq #0xa013bd18
a013a1f8 4c0051e3 cmp r1, #0x4c
a013a1fc a906001a bne #0xa013bca8
a013a200 48210ce3 movw r2, #0xc148
a013a204 1e00a0e3 mov r0, #0x1e
a013a208 fb204ae3 movt r2, #0xa0fb
a013a20c 0050a0e3 mov r5, #0
a013a210 0020d2e5 ldrb r2, [r2]
a013a214 060052e3 cmp r2, #6
a013a218 4b20a003 moveq r2, #0x4b
a013a21c 0210a001 moveq r1, r2
a013a220 00208805 streq r2, [r8]
a013a224 6a20a0e3 mov r2, #0x6a
a013a228 e4dfffeb bl #0xa01321c0
a013a22c e5fbffea b #0xa01391c8
a013a230 d04d03e3 movw r4, #0x3dd0
a013a234 fb404ae3 movt r4, #0xa0fb
a013a238 001094e5 ldr r1, [r4]
a013a23c 0230c1e3 bic r3, r1, #2
a013a240 560051e3 cmp r1, #0x56
a013a244 30005313 cmpne r3, #0x30
a013a248 0c00001a bne #0xa013a280
a013a24c 8123a0e1 lsl r2, r1, #7
a013a250 28300de3 movw r3, #0xd028
a013a254 69304ae3 movt r3, #0xa069
a013a258 811242e0 sub r1, r2, r1, lsl #5
a013a25c 3c0604e3 movw r0, #0x463c
a013a260 182b0fe3 movw r2, #0xfb18
a013a264 013083e0 add r3, r3, r1
a013a268 53204ae3 movt r2, #0xa053
a013a26c b91da0e3 mov r1, #0x2e40
a013a270 54004ae3 movt r0, #0xa054
a013a274 9cb305eb bl #0xa02a70ec
a013a278 1ad2ffeb bl #0xa012eae8
a013a27c 001094e5 ldr r1, [r4]
a013a280 4b3041e2 sub r3, r1, #0x4b
a013a284 010053e3 cmp r3, #1
a013a288 9907009a bls #0xa013c0f4
a013a28c 304c03e3 movw r4, #0x3c30
a013a290 110200e3 movw r0, #0x211
a013a294 fb404ae3 movt r4, #0xa0fb
a013a298 0060a0e3 mov r6, #0
a013a29c 007094e5 ldr r7, [r4]
a013a2a0 0650a0e1 mov r5, r6
a013a2a4 e4caffeb bl #0xa012ce3c
a013a2a8 68cb02e3 movw ip, #0x2b68
a013a2ac 0610a0e1 mov r1, r6
a013a2b0 6ac04ae3 movt ip, #0xa06a
a013a2b4 6620a0e3 mov r2, #0x66
a013a2b8 0732a0e1 lsl r3, r7, #4
a013a2bc 006084e5 str r6, [r4]
a013a2c0 073183e0 add r3, r3, r7, lsl #2
a013a2c4 033183e0 add r3, r3, r3, lsl #2
a013a2c8 03308ce0 add r3, ip, r3
a013a2cc 480083e5 str r0, [r3, #0x48]
a013a2d0 1f00a0e3 mov r0, #0x1f
a013a2d4 b9dfffeb bl #0xa01321c0
a013a2d8 bafbffea b #0xa01391c8
a013a2dc 0010a0e3 mov r1, #0
a013a2e0 6620a0e3 mov r2, #0x66
a013a2e4 1d00a0e3 mov r0, #0x1d
a013a2e8 0150a0e1 mov r5, r1
a013a2ec b3dfffeb bl #0xa01321c0
a013a2f0 b4fbffea b #0xa01391c8
a013a2f4 6420a0e3 mov r2, #0x64
a013a2f8 a71100e3 movw r1, #0x1a7
a013a2fc 0200a0e3 mov r0, #2
a013a300 b01e03eb bl #0xa0201dc8
a013a304 a71100e3 movw r1, #0x1a7
a013a308 0200a0e3 mov r0, #2
a013a30c ed1f03eb bl #0xa02022c8
a013a310 5e20a0e3 mov r2, #0x5e
a013a314 9b1100e3 movw r1, #0x19b
a013a318 0200a0e3 mov r0, #2
a013a31c a91e03eb bl #0xa0201dc8
a013a320 9b1100e3 movw r1, #0x19b
a013a324 0200a0e3 mov r0, #2
a013a328 e61f03eb bl #0xa02022c8
a013a32c 0200a0e3 mov r0, #2
a013a330 1e2103eb bl #0xa02027b0
a013a334 1400a0e3 mov r0, #0x14
a013a338 f8070aeb bl #0xa03bc320
a013a33c 6520a0e3 mov r2, #0x65
a013a340 a71100e3 movw r1, #0x1a7
a013a344 0200a0e3 mov r0, #2
a013a348 9e1e03eb bl #0xa0201dc8
a013a34c a71100e3 movw r1, #0x1a7
a013a350 0200a0e3 mov r0, #2
a013a354 db1f03eb bl #0xa02022c8
a013a358 5f20a0e3 mov r2, #0x5f
a013a35c 9b1100e3 movw r1, #0x19b
a013a360 0200a0e3 mov r0, #2
a013a364 971e03eb bl #0xa0201dc8
a013a368 9b1100e3 movw r1, #0x19b
a013a36c 0200a0e3 mov r0, #2
a013a370 d41f03eb bl #0xa02022c8
a013a374 b0500deb bl #0xa048e63c
a013a378 e651d4e5 ldrb r5, [r4, #0x1e6]
a013a37c 973a03e3 movw r3, #0x3a97
a013a380 d82c05e3 movw r2, #0x5cd8
a013a384 05214ae3 movt r2, #0xa105
a013a388 030050e1 cmp r0, r3
a013a38c 00005593 cmpls r5, #0
a013a390 0150a003 moveq r5, #1
a013a394 0050a013 movne r5, #0
a013a398 a306000a beq #0xa013be2c
a013a39c 1630d2e5 ldrb r3, [r2, #0x16]
a013a3a0 020013e3 tst r3, #2
a013a3a4 3d06000a beq #0xa013bca0
a013a3a8 0510a0e1 mov r1, r5
a013a3ac 2800a0e3 mov r0, #0x28
a013a3b0 73dcffeb bl #0xa0131584
a013a3b4 83fbffea b #0xa01391c8
a013a3b8 dea303eb bl #0xa0223338
a013a3bc 010050e3 cmp r0, #1
a013a3c0 a706000a beq #0xa013be64
a013a3c4 64320ce3 movw r3, #0xc264
a013a3c8 02b04be2 sub fp, fp, #2
a013a3cc fb304ae3 movt r3, #0xa0fb
a013a3d0 002093e5 ldr r2, [r3]
a013a3d4 02005be1 cmp fp, r2
a013a3d8 a8fbff0a beq #0xa0139280
a013a3dc 0010a0e3 mov r1, #0
a013a3e0 6920a0e3 mov r2, #0x69
a013a3e4 1c00a0e3 mov r0, #0x1c
a013a3e8 00b083e5 str fp, [r3]
a013a3ec 73dfffeb bl #0xa01321c0
a013a3f0 0b00a0e1 mov r0, fp
a013a3f4 d4d3ffeb bl #0xa012f34c
a013a3f8 a0fbffea b #0xa0139280
a013a3fc 309c03e3 movw sb, #0x3c30
a013a400 688b02e3 movw r8, #0x2b68
a013a404 fb904ae3 movt sb, #0xa0fb
a013a408 dc3601e3 movw r3, #0x16dc
a013a40c 007099e5 ldr r7, [sb]
a013a410 0010a0e3 mov r1, #0
a013a414 6a304ae3 movt r3, #0xa06a
a013a418 6a804ae3 movt r8, #0xa06a
a013a41c 00308de5 str r3, [sp]
a013a420 0120a0e1 mov r2, r1
a013a424 0130a0e1 mov r3, r1
a013a428 1c008de2 add r0, sp, #0x1c
a013a42c 0751a0e1 lsl r5, r7, #2
a013a430 0772a0e1 lsl r7, r7, #4
a013a434 07e085e0 add lr, r5, r7
a013a438 0ee18ee0 add lr, lr, lr, lsl #2
a013a43c 0ee088e0 add lr, r8, lr
a013a440 54a09ee5 ldr sl, [lr, #0x54]
a013a444 decdffeb bl #0xa012dbc4
a013a448 000050e3 cmp r0, #0
a013a44c 0130a013 movne r3, #1
a013a450 10308d15 strne r3, [sp, #0x10]
a013a454 0400001a bne #0xa013a46c
a013a458 1c309de5 ldr r3, [sp, #0x1c]
a013a45c 010053e3 cmp r3, #1
a013a460 0030a0c3 movgt r3, #0
a013a464 0130a0d3 movle r3, #1
a013a468 10308de5 str r3, [sp, #0x10]
a013a46c 076085e0 add r6, r5, r7
a013a470 080a04e3 movw r0, #0x4a08
a013a474 066186e0 add r6, r6, r6, lsl #2
a013a478 182b0fe3 movw r2, #0xfb18
a013a47c 53204ae3 movt r2, #0xa053
a013a480 066088e0 add r6, r8, r6
a013a484 fb1e02e3 movw r1, #0x2efb
a013a488 0630a0e1 mov r3, r6
a013a48c 54004ae3 movt r0, #0xa054
a013a490 15b305eb bl #0xa02a70ec
a013a494 341a04e3 movw r1, #0x4a34
a013a498 0600a0e1 mov r0, r6
a013a49c 54104ae3 movt r1, #0xa054
a013a4a0 a7fc0efa blx #0xa04f9744
a013a4a4 000050e3 cmp r0, #0
a013a4a8 0200001a bne #0xa013a4b8
a013a4ac a431d4e5 ldrb r3, [r4, #0x1a4]
a013a4b0 000053e3 cmp r3, #0
a013a4b4 01a04a02 subeq sl, sl, #1
a013a4b8 481a04e3 movw r1, #0x4a48
a013a4bc 0600a0e1 mov r0, r6
a013a4c0 54104ae3 movt r1, #0xa054
a013a4c4 9efc0efa blx #0xa04f9744
a013a4c8 000050e3 cmp r0, #0
a013a4cc 0500001a bne #0xa013a4e8
a013a4d0 a531d4e5 ldrb r3, [r4, #0x1a5]
a013a4d4 000053e3 cmp r3, #0
a013a4d8 10309de5 ldr r3, [sp, #0x10]
a013a4dc 01a04a02 subeq sl, sl, #1
a013a4e0 010053e3 cmp r3, #1
a013a4e4 4e06000a beq #0xa013be24
a013a4e8 075085e0 add r5, r5, r7
a013a4ec 03b04be2 sub fp, fp, #3
a013a4f0 055185e0 add r5, r5, r5, lsl #2
a013a4f4 001099e5 ldr r1, [sb]
a013a4f8 04b08de5 str fp, [sp, #4]
a013a4fc 5c0a04e3 movw r0, #0x4a5c
a013a500 055088e0 add r5, r8, r5
a013a504 182b0fe3 movw r2, #0xfb18
a013a508 4ce095e5 ldr lr, [r5, #0x4c]
a013a50c 0b30a0e1 mov r3, fp
a013a510 00108de5 str r1, [sp]
a013a514 54004ae3 movt r0, #0xa054
a013a518 53204ae3 movt r2, #0xa053
a013a51c 091f02e3 movw r1, #0x2f09
a013a520 08e08de5 str lr, [sp, #8]
a013a524 485085e2 add r5, r5, #0x48
a013a528 efb205eb bl #0xa02a70ec
a013a52c 0b005ae1 cmp sl, fp
a013a530 23fbffda ble #0xa01391c4
a013a534 043095e5 ldr r3, [r5, #4]
a013a538 000053e3 cmp r3, #0
a013a53c 20fbff0a beq #0xa01391c4
a013a540 0b10a0e1 mov r1, fp
a013a544 6920a0e3 mov r2, #0x69
a013a548 1f00a0e3 mov r0, #0x1f
a013a54c d87c05e3 movw r7, #0x5cd8
a013a550 1adfffeb bl #0xa01321c0
a013a554 1400a0e3 mov r0, #0x14
a013a558 05714ae3 movt r7, #0xa105
a013a55c 6f070aeb bl #0xa03bc320
a013a560 a521d4e5 ldrb r2, [r4, #0x1a5]
a013a564 7c3003e3 movw r3, #0x307c
a013a568 10c09de5 ldr ip, [sp, #0x10]
a013a56c 6f304ae3 movt r3, #0xa06f
a013a570 081093e5 ldr r1, [r3, #8]
a013a574 a00a04e3 movw r0, #0x4aa0
a013a578 183b0fe3 movw r3, #0xfb18
a013a57c 00208de5 str r2, [sp]
a013a580 53304ae3 movt r3, #0xa053
a013a584 04c08de5 str ip, [sp, #4]
a013a588 112f02e3 movw r2, #0x2f11
a013a58c 54004ae3 movt r0, #0xa054
a013a590 08b08de5 str fp, [sp, #8]
a013a594 0ca08de5 str sl, [sp, #0xc]
a013a598 d3b205eb bl #0xa02a70ec
a013a59c 481a04e3 movw r1, #0x4a48
a013a5a0 0600a0e1 mov r0, r6
a013a5a4 045095e5 ldr r5, [r5, #4]
a013a5a8 54104ae3 movt r1, #0xa054
a013a5ac 64fc0efa blx #0xa04f9744
a013a5b0 000050e3 cmp r0, #0
a013a5b4 0b31a0e1 lsl r3, fp, #2
a013a5b8 0b6195e7 ldr r6, [r5, fp, lsl #2]
a013a5bc 0a00001a bne #0xa013a5ec
a013a5c0 a521d7e5 ldrb r2, [r7, #0x1a5]
a013a5c4 000052e3 cmp r2, #0
a013a5c8 10209de5 ldr r2, [sp, #0x10]
a013a5cc c807001a bne #0xa013c4f4
a013a5d0 010052e3 cmp r2, #1
a013a5d4 9d08000a beq #0xa013c850
a013a5d8 02a04ae2 sub sl, sl, #2
a013a5dc 0a005be1 cmp fp, sl
a013a5e0 010000ba blt #0xa013a5ec
a013a5e4 035085e0 add r5, r5, r3
a013a5e8 046095e5 ldr r6, [r5, #4]
a013a5ec 0672a0e1 lsl r7, r6, #4
a013a5f0 003099e5 ldr r3, [sb]
a013a5f4 f40a04e3 movw r0, #0x4af4
a013a5f8 067187e0 add r7, r7, r6, lsl #2
a013a5fc 482e0fe3 movw r2, #0xfe48
a013a600 04308de5 str r3, [sp, #4]
a013a604 54004ae3 movt r0, #0xa054
a013a608 077187e0 add r7, r7, r7, lsl #2
a013a60c 53204ae3 movt r2, #0xa053
a013a610 281702e3 movw r1, #0x2728
a013a614 077088e0 add r7, r8, r7
a013a618 40c097e5 ldr ip, [r7, #0x40]
a013a61c 0730a0e1 mov r3, r7
a013a620 00c08de5 str ip, [sp]
a013a624 b0b205eb bl #0xa02a70ec
a013a628 405097e5 ldr r5, [r7, #0x40]
a013a62c 060055e3 cmp r5, #6
a013a630 05f19f97 ldrls pc, [pc, r5, lsl #2]
a013a634 980300ea b #0xa013b49c
a013a654 48910ce3 movw sb, #0xc148
a013a658 6b1f4be2 sub r1, fp, #0x1ac
a013a65c fb904ae3 movt sb, #0xa0fb
a013a660 021041e2 sub r1, r1, #2
a013a664 0030d9e5 ldrb r3, [sb]
a013a668 d40106e3 movw r0, #0x61d4
a013a66c 54004ae3 movt r0, #0xa054
a013a670 54ae05e3 movw sl, #0x5e54
a013a674 54a04ae3 movt sl, #0xa054
a013a678 b47e07e3 movw r7, #0x7eb4
a013a67c fb704ae3 movt r7, #0xa0fb
a013a680 28500de3 movw r5, #0xd028
a013a684 0361a0e1 lsl r6, r3, #2
a013a688 0332a0e1 lsl r3, r3, #4
a013a68c 00108de5 str r1, [sp]
a013a690 032086e0 add r2, r6, r3
a013a694 036066e0 rsb r6, r6, r3
a013a698 013082e0 add r3, r2, r1
a013a69c 06208ae0 add r2, sl, r6
a013a6a0 03c190e7 ldr ip, [r0, r3, lsl #2]
a013a6a4 0b30a0e1 mov r3, fp
a013a6a8 048092e5 ldr r8, [r2, #4]
a013a6ac 69504ae3 movt r5, #0xa069
a013a6b0 540404e3 movw r0, #0x4454
a013a6b4 182b0fe3 movw r2, #0xfb18
a013a6b8 04c08de5 str ip, [sp, #4]
a013a6bc 54004ae3 movt r0, #0xa054
a013a6c0 8ce2a0e1 lsl lr, ip, #5
a013a6c4 8cb3a0e1 lsl fp, ip, #7
a013a6c8 001087e5 str r1, [r7]
a013a6cc 0b106ee0 rsb r1, lr, fp
a013a6d0 018048e2 sub r8, r8, #1
a013a6d4 011085e0 add r1, r5, r1
a013a6d8 14e08de5 str lr, [sp, #0x14]
a013a6dc 0c808de5 str r8, [sp, #0xc]
a013a6e0 53204ae3 movt r2, #0xa053
a013a6e4 40e091e5 ldr lr, [r1, #0x40]
a013a6e8 de1d02e3 movw r1, #0x2dde
a013a6ec 10c08de5 str ip, [sp, #0x10]
a013a6f0 08e08de5 str lr, [sp, #8]
a013a6f4 7cb205eb bl #0xa02a70ec
a013a6f8 003097e5 ldr r3, [r7]
a013a6fc 10c09de5 ldr ip, [sp, #0x10]
a013a700 030058e1 cmp r8, r3
a013a704 aefaffda ble #0xa01391c4
a013a708 013083e2 add r3, r3, #1
a013a70c 06609ae7 ldr r6, [sl, r6]
a013a710 0322a0e1 lsl r2, r3, #4
a013a714 033182e0 add r3, r2, r3, lsl #2
a013a718 033086e0 add r3, r6, r3
a013a71c 103093e5 ldr r3, [r3, #0x10]
a013a720 060053e3 cmp r3, #6
a013a724 9d05000a beq #0xa013bda0
a013a728 070053e3 cmp r3, #7
a013a72c 6206000a beq #0xa013c0bc
a013a730 0f0053e3 cmp r3, #0xf
a013a734 c404001a bne #0xa013ba4c
a013a738 2420d4e5 ldrb r2, [r4, #0x24]
a013a73c 010052e3 cmp r2, #1
a013a740 c104000a beq #0xa013ba4c
a013a744 7c2003e3 movw r2, #0x307c
a013a748 280504e3 movw r0, #0x4528
a013a74c 6f204ae3 movt r2, #0xa06f
a013a750 183b0fe3 movw r3, #0xfb18
a013a754 041092e5 ldr r1, [r2, #4]
a013a758 54004ae3 movt r0, #0xa054
a013a75c 53304ae3 movt r3, #0xa053
a013a760 ee2d02e3 movw r2, #0x2dee
a013a764 60b205eb bl #0xa02a70ec
a013a768 0050a0e3 mov r5, #0
a013a76c 95faffea b #0xa01391c8
a013a770 0010a0e3 mov r1, #0
a013a774 1b00a0e3 mov r0, #0x1b
a013a778 0120a0e1 mov r2, r1
a013a77c 0150a0e1 mov r5, r1
a013a780 8edeffeb bl #0xa01321c0
a013a784 8ffaffea b #0xa01391c8
a013a788 306c03e3 movw r6, #0x3c30
a013a78c 684b02e3 movw r4, #0x2b68
a013a790 fb604ae3 movt r6, #0xa0fb
a013a794 6a404ae3 movt r4, #0xa06a
a013a798 00c096e5 ldr ip, [r6]
a013a79c c40904e3 movw r0, #0x49c4
a013a7a0 182b0fe3 movw r2, #0xfb18
a013a7a4 c21e02e3 movw r1, #0x2ec2
a013a7a8 54004ae3 movt r0, #0xa054
a013a7ac 53204ae3 movt r2, #0xa053
a013a7b0 04c08de5 str ip, [sp, #4]
a013a7b4 0c32a0e1 lsl r3, ip, #4
a013a7b8 0c3183e0 add r3, r3, ip, lsl #2
a013a7bc 033183e0 add r3, r3, r3, lsl #2
a013a7c0 033084e0 add r3, r4, r3
a013a7c4 407083e2 add r7, r3, #0x40
a013a7c8 04c097e5 ldr ip, [r7, #4]
a013a7cc 00c08de5 str ip, [sp]
a013a7d0 45b205eb bl #0xa02a70ec
a013a7d4 043097e5 ldr r3, [r7, #4]
a013a7d8 0010a0e3 mov r1, #0
a013a7dc 000053e3 cmp r3, #0
a013a7e0 d43404e3 movw r3, #0x44d4
a013a7e4 6d304ae3 movt r3, #0xa06d
a013a7e8 1b0500ba blt #0xa013bc5c
a013a7ec 6820a0e3 mov r2, #0x68
a013a7f0 000093e5 ldr r0, [r3]
a013a7f4 0150a0e1 mov r5, r1
a013a7f8 70deffeb bl #0xa01321c0
a013a7fc 1400a0e3 mov r0, #0x14
a013a800 c6060aeb bl #0xa03bc320
a013a804 008096e5 ldr r8, [r6]
a013a808 110200e3 movw r0, #0x211
a013a80c 8ac9ffeb bl #0xa012ce3c
a013a810 04c097e5 ldr ip, [r7, #4]
a013a814 0510a0e1 mov r1, r5
a013a818 6620a0e3 mov r2, #0x66
a013a81c 0832a0e1 lsl r3, r8, #4
a013a820 00c086e5 str ip, [r6]
a013a824 083183e0 add r3, r3, r8, lsl #2
a013a828 033183e0 add r3, r3, r3, lsl #2
a013a82c 034084e0 add r4, r4, r3
a013a830 480084e5 str r0, [r4, #0x48]
a013a834 1f00a0e3 mov r0, #0x1f
a013a838 60deffeb bl #0xa01321c0
a013a83c 61faffea b #0xa01391c8
a013a840 304c03e3 movw r4, #0x3c30
a013a844 110200e3 movw r0, #0x211
a013a848 fb404ae3 movt r4, #0xa0fb
a013a84c 0060a0e3 mov r6, #0
a013a850 007094e5 ldr r7, [r4]
a013a854 0650a0e1 mov r5, r6
a013a858 77c9ffeb bl #0xa012ce3c
a013a85c 68cb02e3 movw ip, #0x2b68
a013a860 0610a0e1 mov r1, r6
a013a864 6ac04ae3 movt ip, #0xa06a
a013a868 6620a0e3 mov r2, #0x66
a013a86c 0732a0e1 lsl r3, r7, #4
a013a870 006084e5 str r6, [r4]
a013a874 073183e0 add r3, r3, r7, lsl #2
a013a878 033183e0 add r3, r3, r3, lsl #2
a013a87c 03308ce0 add r3, ip, r3
a013a880 480083e5 str r0, [r3, #0x48]
a013a884 1f00a0e3 mov r0, #0x1f
a013a888 4cdeffeb bl #0xa01321c0
a013a88c 4dfaffea b #0xa01391c8
a013a890 0010a0e3 mov r1, #0
a013a894 6520a0e3 mov r2, #0x65
a013a898 1d00a0e3 mov r0, #0x1d
a013a89c 0150a0e1 mov r5, r1
a013a8a0 46deffeb bl #0xa01321c0
a013a8a4 1400a0e3 mov r0, #0x14
a013a8a8 9c060aeb bl #0xa03bc320
a013a8ac 0510a0e1 mov r1, r5
a013a8b0 6620a0e3 mov r2, #0x66
a013a8b4 1b00a0e3 mov r0, #0x1b
a013a8b8 40deffeb bl #0xa01321c0
a013a8bc 41faffea b #0xa01391c8
a013a8c0 012ca0e3 mov r2, #0x100
a013a8c4 491100e3 movw r1, #0x149
a013a8c8 0200a0e3 mov r0, #2
a013a8cc 0060a0e3 mov r6, #0
a013a8d0 3c1d03eb bl #0xa0201dc8
a013a8d4 491100e3 movw r1, #0x149
a013a8d8 0200a0e3 mov r0, #2
a013a8dc 791e03eb bl #0xa02022c8
a013a8e0 d43404e3 movw r3, #0x44d4
a013a8e4 0610a0e1 mov r1, r6
a013a8e8 6d304ae3 movt r3, #0xa06d
a013a8ec 6920a0e3 mov r2, #0x69
a013a8f0 000093e5 ldr r0, [r3]
a013a8f4 0650a0e1 mov r5, r6
a013a8f8 30deffeb bl #0xa01321c0
a013a8fc 1400a0e3 mov r0, #0x14
a013a900 86060aeb bl #0xa03bc320
a013a904 0120a0e3 mov r2, #1
a013a908 48310ce3 movw r3, #0xc148
a013a90c fb304ae3 movt r3, #0xa0fb
a013a910 0200a0e1 mov r0, r2
a013a914 4820c3e5 strb r2, [r3, #0x48]
a013a918 c2c000eb bl #0xa016ac28
a013a91c 0610a0e1 mov r1, r6
a013a920 6720a0e3 mov r2, #0x67
a013a924 1f00a0e3 mov r0, #0x1f
a013a928 6a60c4e5 strb r6, [r4, #0x6a]
a013a92c 23deffeb bl #0xa01321c0
a013a930 24faffea b #0xa01391c8
a013a934 c120a0e3 mov r2, #0xc1
a013a938 491100e3 movw r1, #0x149
a013a93c 0200a0e3 mov r0, #2
a013a940 0060a0e3 mov r6, #0
a013a944 1f1d03eb bl #0xa0201dc8
a013a948 491100e3 movw r1, #0x149
a013a94c 0200a0e3 mov r0, #2
a013a950 5c1e03eb bl #0xa02022c8
a013a954 d43404e3 movw r3, #0x44d4
a013a958 0610a0e1 mov r1, r6
a013a95c 6d304ae3 movt r3, #0xa06d
a013a960 6920a0e3 mov r2, #0x69
a013a964 000093e5 ldr r0, [r3]
a013a968 0650a0e1 mov r5, r6
a013a96c 13deffeb bl #0xa01321c0
a013a970 1400a0e3 mov r0, #0x14
a013a974 69060aeb bl #0xa03bc320
a013a978 0610a0e1 mov r1, r6
a013a97c 6620a0e3 mov r2, #0x66
a013a980 1b00a0e3 mov r0, #0x1b
a013a984 0ddeffeb bl #0xa01321c0
a013a988 b460c4e5 strb r6, [r4, #0xb4]
a013a98c 64d2ffeb bl #0xa012f324
a013a990 0cfaffea b #0xa01391c8
a013a994 c120a0e3 mov r2, #0xc1
a013a998 491100e3 movw r1, #0x149
a013a99c 0200a0e3 mov r0, #2
a013a9a0 0060a0e3 mov r6, #0
a013a9a4 071d03eb bl #0xa0201dc8
a013a9a8 491100e3 movw r1, #0x149
a013a9ac 0200a0e3 mov r0, #2
a013a9b0 441e03eb bl #0xa02022c8
a013a9b4 d43404e3 movw r3, #0x44d4
a013a9b8 0610a0e1 mov r1, r6
a013a9bc 6d304ae3 movt r3, #0xa06d
a013a9c0 6920a0e3 mov r2, #0x69
a013a9c4 000093e5 ldr r0, [r3]
a013a9c8 0650a0e1 mov r5, r6
a013a9cc fbddffeb bl #0xa01321c0
a013a9d0 1400a0e3 mov r0, #0x14
a013a9d4 51060aeb bl #0xa03bc320
a013a9d8 0610a0e1 mov r1, r6
a013a9dc 6620a0e3 mov r2, #0x66
a013a9e0 1b00a0e3 mov r0, #0x1b
a013a9e4 f5ddffeb bl #0xa01321c0
a013a9e8 0130a0e3 mov r3, #1
a013a9ec b460c4e5 strb r6, [r4, #0xb4]
a013a9f0 ad30c4e5 strb r3, [r4, #0xad]
a013a9f4 c9d4ffeb bl #0xa012fd20
a013a9f8 acd4ffeb bl #0xa012fcb0
a013a9fc f1f9ffea b #0xa01391c8
a013aa00 012ca0e3 mov r2, #0x100
a013aa04 491100e3 movw r1, #0x149
a013aa08 0200a0e3 mov r0, #2
a013aa0c 0060a0e3 mov r6, #0
a013aa10 ec1c03eb bl #0xa0201dc8
a013aa14 491100e3 movw r1, #0x149
a013aa18 0200a0e3 mov r0, #2
a013aa1c 291e03eb bl #0xa02022c8
a013aa20 d43404e3 movw r3, #0x44d4
a013aa24 0610a0e1 mov r1, r6
a013aa28 6d304ae3 movt r3, #0xa06d
a013aa2c 6920a0e3 mov r2, #0x69
a013aa30 000093e5 ldr r0, [r3]
a013aa34 0650a0e1 mov r5, r6
a013aa38 e0ddffeb bl #0xa01321c0
a013aa3c 1400a0e3 mov r0, #0x14
a013aa40 36060aeb bl #0xa03bc320
a013aa44 6c0094e5 ldr r0, [r4, #0x6c]
a013aa48 010040e2 sub r0, r0, #1
a013aa4c dbba00eb bl #0xa01695c0
a013aa50 0610a0e1 mov r1, r6
a013aa54 6720a0e3 mov r2, #0x67
a013aa58 1d00a0e3 mov r0, #0x1d
a013aa5c 6c6084e5 str r6, [r4, #0x6c]
a013aa60 d6ddffeb bl #0xa01321c0
a013aa64 d7f9ffea b #0xa01391c8
a013aa68 012ca0e3 mov r2, #0x100
a013aa6c 491100e3 movw r1, #0x149
a013aa70 0200a0e3 mov r0, #2
a013aa74 0060a0e3 mov r6, #0
a013aa78 d21c03eb bl #0xa0201dc8
a013aa7c 491100e3 movw r1, #0x149
a013aa80 0200a0e3 mov r0, #2
a013aa84 0f1e03eb bl #0xa02022c8
a013aa88 d43404e3 movw r3, #0x44d4
a013aa8c 0610a0e1 mov r1, r6
a013aa90 6d304ae3 movt r3, #0xa06d
a013aa94 6920a0e3 mov r2, #0x69
a013aa98 000093e5 ldr r0, [r3]
a013aa9c 0650a0e1 mov r5, r6
a013aaa0 c6ddffeb bl #0xa01321c0
a013aaa4 1400a0e3 mov r0, #0x14
a013aaa8 1c060aeb bl #0xa03bc320
a013aaac 48310ce3 movw r3, #0xc148
a013aab0 0600a0e1 mov r0, r6
a013aab4 fb304ae3 movt r3, #0xa0fb
a013aab8 0660c3e5 strb r6, [r3, #6]
a013aabc 25b300eb bl #0xa0167758
a013aac0 0610a0e1 mov r1, r6
a013aac4 6720a0e3 mov r2, #0x67
a013aac8 1d00a0e3 mov r0, #0x1d
a013aacc 6b60c4e5 strb r6, [r4, #0x6b]
a013aad0 baddffeb bl #0xa01321c0
a013aad4 bbf9ffea b #0xa01391c8
a013aad8 6991ffeb bl #0xa011f084
a013aadc 000050e3 cmp r0, #0
a013aae0 0200001a bne #0xa013aaf0
a013aae4 7791ffeb bl #0xa011f0c8
a013aae8 001050e2 subs r1, r0, #0
a013aaec acf9ff0a beq #0xa01391a4
a013aaf0 840204e3 movw r0, #0x4284
a013aaf4 182b0fe3 movw r2, #0xfb18
a013aaf8 53204ae3 movt r2, #0xa053
a013aafc 4c1d02e3 movw r1, #0x2d4c
a013ab00 54004ae3 movt r0, #0xa054
a013ab04 0050a0e3 mov r5, #0
a013ab08 77b105eb bl #0xa02a70ec
a013ab0c adf9ffea b #0xa01391c8
a013ab10 a731d4e5 ldrb r3, [r4, #0x1a7]
a013ab14 d84c05e3 movw r4, #0x5cd8
a013ab18 05414ae3 movt r4, #0xa105
a013ab1c 000053e3 cmp r3, #0
a013ab20 9e07000a beq #0xa013c9a0
a013ab24 0000a0e3 mov r0, #0
a013ab28 0010a0e1 mov r1, r0
a013ab2c b38201eb bl #0xa019b600
a013ab30 005050e2 subs r5, r0, #0
a013ab34 8f07001a bne #0xa013c978
a013ab38 9c0702e3 movw r0, #0x279c
a013ab3c e42e05e3 movw r2, #0x5ee4
a013ab40 54004ae3 movt r0, #0xa054
a013ab44 54204ae3 movt r2, #0xa054
a013ab48 411902e3 movw r1, #0x2941
a013ab4c a631d4e5 ldrb r3, [r4, #0x1a6]
a013ab50 65b105eb bl #0xa02a70ec
a013ab54 a661d4e5 ldrb r6, [r4, #0x1a6]
a013ab58 000056e3 cmp r6, #0
a013ab5c 6207001a bne #0xa013c8ec
a013ab60 48510ce3 movw r5, #0xc148
a013ab64 fb504ae3 movt r5, #0xa0fb
a013ab68 4030d5e5 ldrb r3, [r5, #0x40]
a013ab6c 010053e3 cmp r3, #1
a013ab70 5404000a beq #0xa013bcc8
a013ab74 9c0702e3 movw r0, #0x279c
a013ab78 e42e05e3 movw r2, #0x5ee4
a013ab7c 54204ae3 movt r2, #0xa054
a013ab80 491902e3 movw r1, #0x2949
a013ab84 0630a0e1 mov r3, r6
a013ab88 54004ae3 movt r0, #0xa054
a013ab8c 56b105eb bl #0xa02a70ec
a013ab90 0130a0e3 mov r3, #1
a013ab94 1a00a0e3 mov r0, #0x1a
a013ab98 0610a0e1 mov r1, r6
a013ab9c 6620a0e3 mov r2, #0x66
a013aba0 4030c5e5 strb r3, [r5, #0x40]
a013aba4 85ddffeb bl #0xa01321c0
a013aba8 0600a0e1 mov r0, r6
a013abac 20d3ffeb bl #0xa012f834
a013abb0 0010a0e3 mov r1, #0
a013abb4 6620a0e3 mov r2, #0x66
a013abb8 1a00a0e3 mov r0, #0x1a
a013abbc 0150a0e1 mov r5, r1
a013abc0 7eddffeb bl #0xa01321c0
a013abc4 7ff9ffea b #0xa01391c8
a013abc8 0010a0e3 mov r1, #0
a013abcc 6620a0e3 mov r2, #0x66
a013abd0 1b00a0e3 mov r0, #0x1b
a013abd4 0150a0e1 mov r5, r1
a013abd8 78ddffeb bl #0xa01321c0
a013abdc 79f9ffea b #0xa01391c8
a013abe0 2ec0d4e5 ldrb ip, [r4, #0x2e]
a013abe4 ec1f03e3 movw r1, #0x3fec
a013abe8 54104ae3 movt r1, #0xa054
a013abec e43f03e3 movw r3, #0x3fe4
a013abf0 ec0204e3 movw r0, #0x42ec
a013abf4 182b0fe3 movw r2, #0xfb18
a013abf8 01005ce3 cmp ip, #1
a013abfc 54304ae3 movt r3, #0xa054
a013ac00 53204ae3 movt r2, #0xa053
a013ac04 0130a011 movne r3, r1
a013ac08 54004ae3 movt r0, #0xa054
a013ac0c 5c1d02e3 movw r1, #0x2d5c
a013ac10 35b105eb bl #0xa02a70ec
a013ac14 180304e3 movw r0, #0x4318
a013ac18 902606e3 movw r2, #0x6690
a013ac1c 54204ae3 movt r2, #0xa054
a013ac20 e11802e3 movw r1, #0x28e1
a013ac24 54004ae3 movt r0, #0xa054
a013ac28 2fb105eb bl #0xa02a70ec
a013ac2c d928ffeb bl #0xa0104f98
a013ac30 010050e3 cmp r0, #1
a013ac34 0040a0e1 mov r4, r0
a013ac38 4604000a beq #0xa013bd58
a013ac3c 22e7ffeb bl #0xa01348cc
a013ac40 0050a0e3 mov r5, #0
a013ac44 5ff9ffea b #0xa01391c8
a013ac48 cc9bffeb bl #0xa0121b80
a013ac4c 010050e3 cmp r0, #1
a013ac50 3d07000a beq #0xa013c94c
a013ac54 0000a0e3 mov r0, #0
a013ac58 0050a0e1 mov r5, r0
a013ac5c 90e8ffeb bl #0xa0134ea4
a013ac60 58f9ffea b #0xa01391c8
a013ac64 c59bffeb bl #0xa0121b80
a013ac68 010050e3 cmp r0, #1
a013ac6c 5507000a beq #0xa013c9c8
a013ac70 4e2fa0e3 mov r2, #0x138
a013ac74 451100e3 movw r1, #0x145
a013ac78 0200a0e3 mov r0, #2
a013ac7c 0050a0e3 mov r5, #0
a013ac80 501c03eb bl #0xa0201dc8
a013ac84 451100e3 movw r1, #0x145
a013ac88 0200a0e3 mov r0, #2
a013ac8c 8d1d03eb bl #0xa02022c8
a013ac90 012100e3 movw r2, #0x101
a013ac94 461100e3 movw r1, #0x146
a013ac98 0200a0e3 mov r0, #2
a013ac9c 491c03eb bl #0xa0201dc8
a013aca0 461100e3 movw r1, #0x146
a013aca4 0200a0e3 mov r0, #2
a013aca8 861d03eb bl #0xa02022c8
a013acac fc20a0e3 mov r2, #0xfc
a013acb0 471100e3 movw r1, #0x147
a013acb4 0200a0e3 mov r0, #2
a013acb8 421c03eb bl #0xa0201dc8
a013acbc 471100e3 movw r1, #0x147
a013acc0 0200a0e3 mov r0, #2
a013acc4 7f1d03eb bl #0xa02022c8
a013acc8 0130a0e3 mov r3, #1
a013accc 0510a0e1 mov r1, r5
a013acd0 0520a0e1 mov r2, r5
a013acd4 1500a0e3 mov r0, #0x15
a013acd8 5c3084e5 str r3, [r4, #0x5c]
a013acdc 37ddffeb bl #0xa01321c0
a013ace0 38f9ffea b #0xa01391c8
a013ace4 0050a0e3 mov r5, #0
a013ace8 36f9ffea b #0xa01391c8
a013acec 0050a0e3 mov r5, #0
a013acf0 34f9ffea b #0xa01391c8
a013acf4 0050a0e3 mov r5, #0
a013acf8 32f9ffea b #0xa01391c8
a013acfc 0050a0e3 mov r5, #0
a013ad00 30f9ffea b #0xa01391c8
a013ad04 b00304e3 movw r0, #0x43b0
a013ad08 182b0fe3 movw r2, #0xfb18
a013ad0c 53204ae3 movt r2, #0xa053
a013ad10 8f1d02e3 movw r1, #0x2d8f
a013ad14 54004ae3 movt r0, #0xa054
a013ad18 0050a0e3 mov r5, #0
a013ad1c f2b005eb bl #0xa02a70ec
a013ad20 6e7901eb bl #0xa01992e0
a013ad24 010050e2 subs r0, r0, #1
a013ad28 0100a013 movne r0, #1
a013ad2c 727901eb bl #0xa01992fc
a013ad30 acd8ffeb bl #0xa0130fe8
a013ad34 0200a0e3 mov r0, #2
a013ad38 9c1e03eb bl #0xa02027b0
a013ad3c 21f9ffea b #0xa01391c8
a013ad40 a97405eb bl #0xa0297fec
a013ad44 000050e3 cmp r0, #0
a013ad48 0200001a bne #0xa013ad58
a013ad4c a751d4e5 ldrb r5, [r4, #0x1a7]
a013ad50 000055e3 cmp r5, #0
a013ad54 d805000a beq #0xa013c4bc
a013ad58 889bffeb bl #0xa0121b80
a013ad5c 010050e3 cmp r0, #1
a013ad60 2307000a beq #0xa013c9f4
a013ad64 0e2200e3 movw r2, #0x20e
a013ad68 771100e3 movw r1, #0x177
a013ad6c 0200a0e3 mov r0, #2
a013ad70 0050a0e3 mov r5, #0
a013ad74 131c03eb bl #0xa0201dc8
a013ad78 771100e3 movw r1, #0x177
a013ad7c 0200a0e3 mov r0, #2
a013ad80 501d03eb bl #0xa02022c8
a013ad84 0510a0e1 mov r1, r5
a013ad88 6920a0e3 mov r2, #0x69
a013ad8c 1b00a0e3 mov r0, #0x1b
a013ad90 0addffeb bl #0xa01321c0
a013ad94 1400a0e3 mov r0, #0x14
a013ad98 60050aeb bl #0xa03bc320
a013ad9c 0510a0e1 mov r1, r5
a013ada0 6620a0e3 mov r2, #0x66
a013ada4 1d00a0e3 mov r0, #0x1d
a013ada8 04ddffeb bl #0xa01321c0
a013adac 05f9ffea b #0xa01391c8
a013adb0 729bffeb bl #0xa0121b80
a013adb4 010050e3 cmp r0, #1
a013adb8 2507000a beq #0xa013ca54
a013adbc 0010a0e3 mov r1, #0
a013adc0 6620a0e3 mov r2, #0x66
a013adc4 1c00a0e3 mov r0, #0x1c
a013adc8 0150a0e1 mov r5, r1
a013adcc fbdcffeb bl #0xa01321c0
a013add0 fcf8ffea b #0xa01391c8
a013add4 0010a0e3 mov r1, #0
a013add8 0600a0e3 mov r0, #6
a013addc 0120a0e1 mov r2, r1
a013ade0 0150a0e1 mov r5, r1
a013ade4 f5dcffeb bl #0xa01321c0
a013ade8 f6f8ffea b #0xa01391c8
a013adec 639bffeb bl #0xa0121b80
a013adf0 010050e3 cmp r0, #1
a013adf4 0b07000a beq #0xa013ca28
a013adf8 7b7405eb bl #0xa0297fec
a013adfc 000050e3 cmp r0, #0
a013ae00 0200001a bne #0xa013ae10
a013ae04 a751d4e5 ldrb r5, [r4, #0x1a7]
a013ae08 000055e3 cmp r5, #0
a013ae0c b105000a beq #0xa013c4d8
a013ae10 0ea103eb bl #0xa0223250
a013ae14 010070e3 cmn r0, #1
a013ae18 9505000a beq #0xa013c474
a013ae1c 0300a0e3 mov r0, #3
a013ae20 0010a0e3 mov r1, #0
a013ae24 63a803eb bl #0xa0224fb8
a013ae28 005050e2 subs r5, r0, #0
a013ae2c dc04001a bne #0xa013c1a4
a013ae30 1c0404e3 movw r0, #0x441c
a013ae34 182b0fe3 movw r2, #0xfb18
a013ae38 53204ae3 movt r2, #0xa053
a013ae3c a21d02e3 movw r1, #0x2da2
a013ae40 54004ae3 movt r0, #0xa054
a013ae44 a8b005eb bl #0xa02a70ec
a013ae48 0500a0e1 mov r0, r5
a013ae4c 0510a0e1 mov r1, r5
a013ae50 cbd9ffeb bl #0xa0131584
a013ae54 dbf8ffea b #0xa01391c8
a013ae58 463100e3 movw r3, #0x146
a013ae5c 03005be1 cmp fp, r3
a013ae60 0c04000a beq #0xa013be98
a013ae64 473100e3 movw r3, #0x147
a013ae68 03005be1 cmp fp, r3
a013ae6c 0704001a bne #0xa013be90
a013ae70 0b10a0e1 mov r1, fp
a013ae74 fb20a0e3 mov r2, #0xfb
a013ae78 0200a0e3 mov r0, #2
a013ae7c 306c03e3 movw r6, #0x3c30
a013ae80 d01b03eb bl #0xa0201dc8
a013ae84 0b10a0e1 mov r1, fp
a013ae88 0200a0e3 mov r0, #2
a013ae8c 0d1d03eb bl #0xa02022c8
a013ae90 d43404e3 movw r3, #0x44d4
a013ae94 0010a0e3 mov r1, #0
a013ae98 6d304ae3 movt r3, #0xa06d
a013ae9c 6920a0e3 mov r2, #0x69
a013aea0 000093e5 ldr r0, [r3]
a013aea4 fb604ae3 movt r6, #0xa0fb
a013aea8 c4dcffeb bl #0xa01321c0
a013aeac 1400a0e3 mov r0, #0x14
a013aeb0 0050a0e3 mov r5, #0
a013aeb4 19050aeb bl #0xa03bc320
a013aeb8 004096e5 ldr r4, [r6]
a013aebc 110200e3 movw r0, #0x211
a013aec0 ddc7ffeb bl #0xa012ce3c
a013aec4 683b02e3 movw r3, #0x2b68
a013aec8 6410a0e3 mov r1, #0x64
a013aecc 6a304ae3 movt r3, #0xa06a
a013aed0 1e20a0e3 mov r2, #0x1e
a013aed4 913423e0 mla r3, r1, r4, r3
a013aed8 002086e5 str r2, [r6]
a013aedc 0510a0e1 mov r1, r5
a013aee0 6620a0e3 mov r2, #0x66
a013aee4 480083e5 str r0, [r3, #0x48]
a013aee8 1f00a0e3 mov r0, #0x1f
a013aeec b3dcffeb bl #0xa01321c0
a013aef0 b4f8ffea b #0xa01391c8
a013aef4 463100e3 movw r3, #0x146
a013aef8 03005be1 cmp fp, r3
a013aefc 2e05000a beq #0xa013c3bc
a013af00 473100e3 movw r3, #0x147
a013af04 03005be1 cmp fp, r3
a013af08 d404001a bne #0xa013c260
a013af0c 0b10a0e1 mov r1, fp
a013af10 fb20a0e3 mov r2, #0xfb
a013af14 0200a0e3 mov r0, #2
a013af18 306c03e3 movw r6, #0x3c30
a013af1c a91b03eb bl #0xa0201dc8
a013af20 0b10a0e1 mov r1, fp
a013af24 0200a0e3 mov r0, #2
a013af28 e61c03eb bl #0xa02022c8
a013af2c d43404e3 movw r3, #0x44d4
a013af30 0010a0e3 mov r1, #0
a013af34 6d304ae3 movt r3, #0xa06d
a013af38 6920a0e3 mov r2, #0x69
a013af3c 000093e5 ldr r0, [r3]
a013af40 fb604ae3 movt r6, #0xa0fb
a013af44 9ddcffeb bl #0xa01321c0
a013af48 1400a0e3 mov r0, #0x14
a013af4c 0050a0e3 mov r5, #0
a013af50 f2040aeb bl #0xa03bc320
a013af54 004096e5 ldr r4, [r6]
a013af58 110200e3 movw r0, #0x211
a013af5c b6c7ffeb bl #0xa012ce3c
a013af60 683b02e3 movw r3, #0x2b68
a013af64 6410a0e3 mov r1, #0x64
a013af68 6a304ae3 movt r3, #0xa06a
a013af6c 1e20a0e3 mov r2, #0x1e
a013af70 913423e0 mla r3, r1, r4, r3
a013af74 002086e5 str r2, [r6]
a013af78 0510a0e1 mov r1, r5
a013af7c 6620a0e3 mov r2, #0x66
a013af80 480083e5 str r0, [r3, #0x48]
a013af84 1f00a0e3 mov r0, #0x1f
a013af88 8cdcffeb bl #0xa01321c0
a013af8c 8df8ffea b #0xa01391c8
a013af90 463100e3 movw r3, #0x146
a013af94 03005be1 cmp fp, r3
a013af98 ee03000a beq #0xa013bf58
a013af9c 473100e3 movw r3, #0x147
a013afa0 03005be1 cmp fp, r3
a013afa4 e903001a bne #0xa013bf50
a013afa8 0b10a0e1 mov r1, fp
a013afac fb20a0e3 mov r2, #0xfb
a013afb0 0200a0e3 mov r0, #2
a013afb4 0050a0e3 mov r5, #0
a013afb8 821b03eb bl #0xa0201dc8
a013afbc 0b10a0e1 mov r1, fp
a013afc0 0200a0e3 mov r0, #2
a013afc4 bf1c03eb bl #0xa02022c8
a013afc8 d43404e3 movw r3, #0x44d4
a013afcc 0510a0e1 mov r1, r5
a013afd0 6d304ae3 movt r3, #0xa06d
a013afd4 6920a0e3 mov r2, #0x69
a013afd8 000093e5 ldr r0, [r3]
a013afdc 77dcffeb bl #0xa01321c0
a013afe0 1400a0e3 mov r0, #0x14
a013afe4 cd040aeb bl #0xa03bc320
a013afe8 0510a0e1 mov r1, r5
a013afec 6620a0e3 mov r2, #0x66
a013aff0 1b00a0e3 mov r0, #0x1b
a013aff4 71dcffeb bl #0xa01321c0
a013aff8 72f8ffea b #0xa01391c8
a013affc 463100e3 movw r3, #0x146
a013b000 03005be1 cmp fp, r3
a013b004 9904000a beq #0xa013c270
a013b008 473100e3 movw r3, #0x147
a013b00c 03005be1 cmp fp, r3
a013b010 9404001a bne #0xa013c268
a013b014 0b10a0e1 mov r1, fp
a013b018 c620a0e3 mov r2, #0xc6
a013b01c 0200a0e3 mov r0, #2
a013b020 0050a0e3 mov r5, #0
a013b024 671b03eb bl #0xa0201dc8
a013b028 0b10a0e1 mov r1, fp
a013b02c 0200a0e3 mov r0, #2
a013b030 a41c03eb bl #0xa02022c8
a013b034 d43404e3 movw r3, #0x44d4
a013b038 0510a0e1 mov r1, r5
a013b03c 6d304ae3 movt r3, #0xa06d
a013b040 6920a0e3 mov r2, #0x69
a013b044 000093e5 ldr r0, [r3]
a013b048 5cdcffeb bl #0xa01321c0
a013b04c 1400a0e3 mov r0, #0x14
a013b050 b2040aeb bl #0xa03bc320
a013b054 0510a0e1 mov r1, r5
a013b058 be2200e3 movw r2, #0x2be
a013b05c 3000a0e3 mov r0, #0x30
a013b060 56dcffeb bl #0xa01321c0
a013b064 57f8ffea b #0xa01391c8
a013b068 463100e3 movw r3, #0x146
a013b06c 03005be1 cmp fp, r3
a013b070 d903000a beq #0xa013bfdc
a013b074 473100e3 movw r3, #0x147
a013b078 03005be1 cmp fp, r3
a013b07c d403001a bne #0xa013bfd4
a013b080 0b10a0e1 mov r1, fp
a013b084 fb20a0e3 mov r2, #0xfb
a013b088 0200a0e3 mov r0, #2
a013b08c 304c03e3 movw r4, #0x3c30
a013b090 4c1b03eb bl #0xa0201dc8
a013b094 0b10a0e1 mov r1, fp
a013b098 0200a0e3 mov r0, #2
a013b09c 891c03eb bl #0xa02022c8
a013b0a0 d43404e3 movw r3, #0x44d4
a013b0a4 0010a0e3 mov r1, #0
a013b0a8 6d304ae3 movt r3, #0xa06d
a013b0ac 6920a0e3 mov r2, #0x69
a013b0b0 000093e5 ldr r0, [r3]
a013b0b4 fb404ae3 movt r4, #0xa0fb
a013b0b8 40dcffeb bl #0xa01321c0
a013b0bc 1400a0e3 mov r0, #0x14
a013b0c0 0060a0e3 mov r6, #0
a013b0c4 95040aeb bl #0xa03bc320
a013b0c8 005094e5 ldr r5, [r4]
a013b0cc 110200e3 movw r0, #0x211
a013b0d0 59c7ffeb bl #0xa012ce3c
a013b0d4 683b02e3 movw r3, #0x2b68
a013b0d8 6420a0e3 mov r2, #0x64
a013b0dc 6a304ae3 movt r3, #0xa06a
a013b0e0 0610a0e1 mov r1, r6
a013b0e4 923523e0 mla r3, r2, r5, r3
a013b0e8 006084e5 str r6, [r4]
a013b0ec 6620a0e3 mov r2, #0x66
a013b0f0 0650a0e1 mov r5, r6
a013b0f4 480083e5 str r0, [r3, #0x48]
a013b0f8 1f00a0e3 mov r0, #0x1f
a013b0fc 2fdcffeb bl #0xa01321c0
a013b100 30f8ffea b #0xa01391c8
a013b104 463100e3 movw r3, #0x146
a013b108 03005be1 cmp fp, r3
a013b10c 9204000a beq #0xa013c35c
a013b110 473100e3 movw r3, #0x147
a013b114 03005be1 cmp fp, r3
a013b118 8d04001a bne #0xa013c354
a013b11c 0b10a0e1 mov r1, fp
a013b120 fb20a0e3 mov r2, #0xfb
a013b124 0200a0e3 mov r0, #2
a013b128 0050a0e3 mov r5, #0
a013b12c 251b03eb bl #0xa0201dc8
a013b130 0b10a0e1 mov r1, fp
a013b134 0200a0e3 mov r0, #2
a013b138 621c03eb bl #0xa02022c8
a013b13c d43404e3 movw r3, #0x44d4
a013b140 0510a0e1 mov r1, r5
a013b144 6d304ae3 movt r3, #0xa06d
a013b148 6920a0e3 mov r2, #0x69
a013b14c 000093e5 ldr r0, [r3]
a013b150 1adcffeb bl #0xa01321c0
a013b154 1400a0e3 mov r0, #0x14
a013b158 70040aeb bl #0xa03bc320
a013b15c 0510a0e1 mov r1, r5
a013b160 6620a0e3 mov r2, #0x66
a013b164 1a00a0e3 mov r0, #0x1a
a013b168 14dcffeb bl #0xa01321c0
a013b16c 15f8ffea b #0xa01391c8
a013b170 463100e3 movw r3, #0x146
a013b174 03005be1 cmp fp, r3
a013b178 b103000a beq #0xa013c044
a013b17c 473100e3 movw r3, #0x147
a013b180 03005be1 cmp fp, r3
a013b184 ac03001a bne #0xa013c03c
a013b188 0b10a0e1 mov r1, fp
a013b18c fb20a0e3 mov r2, #0xfb
a013b190 0200a0e3 mov r0, #2
a013b194 0050a0e3 mov r5, #0
a013b198 0a1b03eb bl #0xa0201dc8
a013b19c 0b10a0e1 mov r1, fp
a013b1a0 0200a0e3 mov r0, #2
a013b1a4 471c03eb bl #0xa02022c8
a013b1a8 d43404e3 movw r3, #0x44d4
a013b1ac 0510a0e1 mov r1, r5
a013b1b0 6d304ae3 movt r3, #0xa06d
a013b1b4 6920a0e3 mov r2, #0x69
a013b1b8 000093e5 ldr r0, [r3]
a013b1bc ffdbffeb bl #0xa01321c0
a013b1c0 1400a0e3 mov r0, #0x14
a013b1c4 55040aeb bl #0xa03bc320
a013b1c8 0510a0e1 mov r1, r5
a013b1cc 6620a0e3 mov r2, #0x66
a013b1d0 1f00a0e3 mov r0, #0x1f
a013b1d4 f9dbffeb bl #0xa01321c0
a013b1d8 faf7ffea b #0xa01391c8
a013b1dc 463100e3 movw r3, #0x146
a013b1e0 03005be1 cmp fp, r3
a013b1e4 3b04000a beq #0xa013c2d8
a013b1e8 473100e3 movw r3, #0x147
a013b1ec 03005be1 cmp fp, r3
a013b1f0 3604001a bne #0xa013c2d0
a013b1f4 0b10a0e1 mov r1, fp
a013b1f8 fb20a0e3 mov r2, #0xfb
a013b1fc 0200a0e3 mov r0, #2
a013b200 0050a0e3 mov r5, #0
a013b204 ef1a03eb bl #0xa0201dc8
a013b208 0b10a0e1 mov r1, fp
a013b20c 0200a0e3 mov r0, #2
a013b210 2c1c03eb bl #0xa02022c8
a013b214 d43404e3 movw r3, #0x44d4
a013b218 0510a0e1 mov r1, r5
a013b21c 6d304ae3 movt r3, #0xa06d
a013b220 6920a0e3 mov r2, #0x69
a013b224 000093e5 ldr r0, [r3]
a013b228 e4dbffeb bl #0xa01321c0
a013b22c 1400a0e3 mov r0, #0x14
a013b230 3a040aeb bl #0xa03bc320
a013b234 0510a0e1 mov r1, r5
a013b238 6620a0e3 mov r2, #0x66
a013b23c 1f00a0e3 mov r0, #0x1f
a013b240 dedbffeb bl #0xa01321c0
a013b244 dff7ffea b #0xa01391c8
a013b248 463100e3 movw r3, #0x146
a013b24c 03005be1 cmp fp, r3
a013b250 b503000a beq #0xa013c12c
a013b254 473100e3 movw r3, #0x147
a013b258 03005be1 cmp fp, r3
a013b25c b003001a bne #0xa013c124
a013b260 0b10a0e1 mov r1, fp
a013b264 fb20a0e3 mov r2, #0xfb
a013b268 0200a0e3 mov r0, #2
a013b26c 306c03e3 movw r6, #0x3c30
a013b270 d41a03eb bl #0xa0201dc8
a013b274 0b10a0e1 mov r1, fp
a013b278 0200a0e3 mov r0, #2
a013b27c 111c03eb bl #0xa02022c8
a013b280 d43404e3 movw r3, #0x44d4
a013b284 0010a0e3 mov r1, #0
a013b288 6d304ae3 movt r3, #0xa06d
a013b28c 6920a0e3 mov r2, #0x69
a013b290 000093e5 ldr r0, [r3]
a013b294 fb604ae3 movt r6, #0xa0fb
a013b298 c8dbffeb bl #0xa01321c0
a013b29c 1400a0e3 mov r0, #0x14
a013b2a0 0050a0e3 mov r5, #0
a013b2a4 1d040aeb bl #0xa03bc320
a013b2a8 004096e5 ldr r4, [r6]
a013b2ac 110200e3 movw r0, #0x211
a013b2b0 e1c6ffeb bl #0xa012ce3c
a013b2b4 683b02e3 movw r3, #0x2b68
a013b2b8 6410a0e3 mov r1, #0x64
a013b2bc 6a304ae3 movt r3, #0xa06a
a013b2c0 1e20a0e3 mov r2, #0x1e
a013b2c4 913423e0 mla r3, r1, r4, r3
a013b2c8 002086e5 str r2, [r6]
a013b2cc 0510a0e1 mov r1, r5
a013b2d0 6620a0e3 mov r2, #0x66
a013b2d4 480083e5 str r0, [r3, #0x48]
a013b2d8 1f00a0e3 mov r0, #0x1f
a013b2dc b7dbffeb bl #0xa01321c0
a013b2e0 b8f7ffea b #0xa01391c8
a013b2e4 0120a0e3 mov r2, #1
a013b2e8 fb304ae3 movt r3, #0xa0fb
a013b2ec 0020c3e5 strb r2, [r3]
a013b2f0 0050a0e3 mov r5, #0
a013b2f4 a2f6ffeb bl #0xa0138d84
a013b2f8 cdf6ffeb bl #0xa0138e34
a013b2fc b1f7ffea b #0xa01391c8
a013b300 fb304ae3 movt r3, #0xa0fb
a013b304 0920a0e3 mov r2, #9
a013b308 f7ffffea b #0xa013b2ec
a013b30c 0020a0e3 mov r2, #0
a013b310 fb304ae3 movt r3, #0xa0fb
a013b314 f4ffffea b #0xa013b2ec
a013b318 0520a0e3 mov r2, #5
a013b31c fb304ae3 movt r3, #0xa0fb
a013b320 f1ffffea b #0xa013b2ec
a013b324 0420a0e3 mov r2, #4
a013b328 fb304ae3 movt r3, #0xa0fb
a013b32c eeffffea b #0xa013b2ec
a013b330 0320a0e3 mov r2, #3
a013b334 fb304ae3 movt r3, #0xa0fb
a013b338 ebffffea b #0xa013b2ec
a013b33c 0220a0e3 mov r2, #2
a013b340 fb304ae3 movt r3, #0xa0fb
a013b344 e8ffffea b #0xa013b2ec
a013b348 0720a0e3 mov r2, #7
a013b34c fb304ae3 movt r3, #0xa0fb
a013b350 e5ffffea b #0xa013b2ec
a013b354 0620a0e3 mov r2, #6
a013b358 fb304ae3 movt r3, #0xa0fb
a013b35c e2ffffea b #0xa013b2ec
a013b360 0820a0e3 mov r2, #8
a013b364 fb304ae3 movt r3, #0xa0fb
a013b368 dfffffea b #0xa013b2ec
a013b36c 0050a0e3 mov r5, #0
a013b370 94f7ffea b #0xa01391c8
a013b374 0050a0e3 mov r5, #0
a013b378 92f7ffea b #0xa01391c8
a013b37c 0050a0e3 mov r5, #0
a013b380 90f7ffea b #0xa01391c8
a013b384 6430a0e3 mov r3, #0x64
a013b388 938626e0 mla r6, r3, r6, r8
a013b38c 603096e5 ldr r3, [r6, #0x60]
a013b390 000053e3 cmp r3, #0
a013b394 8af7ff0a beq #0xa01391c4
a013b398 0000a0e3 mov r0, #0
a013b39c 0050a0e1 mov r5, r0
a013b3a0 33ff2fe1 blx r3
a013b3a4 87f7ffea b #0xa01391c8
a013b3a8 6430a0e3 mov r3, #0x64
a013b3ac 938626e0 mla r6, r3, r6, r8
a013b3b0 603096e5 ldr r3, [r6, #0x60]
a013b3b4 000053e3 cmp r3, #0
a013b3b8 81f7ff0a beq #0xa01391c4
a013b3bc 0200a0e3 mov r0, #2
a013b3c0 33ff2fe1 blx r3
a013b3c4 1400a0e3 mov r0, #0x14
a013b3c8 d4030aeb bl #0xa03bc320
a013b3cc 381b04e3 movw r1, #0x4b38
a013b3d0 0700a0e1 mov r0, r7
a013b3d4 54104ae3 movt r1, #0xa054
a013b3d8 d9f80efa blx #0xa04f9744
a013b3dc 000050e3 cmp r0, #0
a013b3e0 0700001a bne #0xa013b404
a013b3e4 48310ce3 movw r3, #0xc148
a013b3e8 fb304ae3 movt r3, #0xa0fb
a013b3ec 4830d3e5 ldrb r3, [r3, #0x48]
a013b3f0 010053e3 cmp r3, #1
a013b3f4 72f7ff0a beq #0xa01391c4
a013b3f8 6a30d4e5 ldrb r3, [r4, #0x6a]
a013b3fc 000053e3 cmp r3, #0
a013b400 6ff7ff1a bne #0xa01391c4
a013b404 0010a0e3 mov r1, #0
a013b408 6720a0e3 mov r2, #0x67
a013b40c 1f00a0e3 mov r0, #0x1f
a013b410 0150a0e1 mov r5, r1
a013b414 69dbffeb bl #0xa01321c0
a013b418 6af7ffea b #0xa01391c8
a013b41c 501b04e3 movw r1, #0x4b50
a013b420 0700a0e1 mov r0, r7
a013b424 54104ae3 movt r1, #0xa054
a013b428 c5f80efa blx #0xa04f9744
a013b42c 000050e3 cmp r0, #0
a013b430 0200001a bne #0xa013b440
a013b434 a432d4e5 ldrb r3, [r4, #0x2a4]
a013b438 010053e3 cmp r3, #1
a013b43c 60f7ff1a bne #0xa01391c4
a013b440 901c04e3 movw r1, #0x4c90
a013b444 0700a0e1 mov r0, r7
a013b448 54104ae3 movt r1, #0xa054
a013b44c bcf80efa blx #0xa04f9744
a013b450 000050e3 cmp r0, #0
a013b454 0200001a bne #0xa013b464
a013b458 c132d4e5 ldrb r3, [r4, #0x2c1]
a013b45c 010053e3 cmp r3, #1
a013b460 57f7ff1a bne #0xa01391c4
a013b464 0610a0e1 mov r1, r6
a013b468 6620a0e3 mov r2, #0x66
a013b46c 2000a0e3 mov r0, #0x20
a013b470 52dbffeb bl #0xa01321c0
a013b474 53f7ffea b #0xa01391c8
a013b478 6430a0e3 mov r3, #0x64
a013b47c 938626e0 mla r6, r3, r6, r8
a013b480 603096e5 ldr r3, [r6, #0x60]
a013b484 000053e3 cmp r3, #0
a013b488 4df7ff0a beq #0xa01391c4
a013b48c 0200a0e3 mov r0, #2
a013b490 0050a0e3 mov r5, #0
a013b494 33ff2fe1 blx r3
a013b498 4af7ffea b #0xa01391c8
a013b49c 0050a0e3 mov r5, #0
a013b4a0 48f7ffea b #0xa01391c8
a013b4a4 401c04e3 movw r1, #0x4c40
a013b4a8 0300a0e3 mov r0, #3
a013b4ac 13104ae3 movt r1, #0xa013
a013b4b0 85ad02eb bl #0xa01e6acc
a013b4b4 59f7ffea b #0xa0139220
a013b4b8 e9005be3 cmp fp, #0xe9
a013b4bc a800000a beq #0xa013b764
a013b4c0 ea005be3 cmp fp, #0xea
a013b4c4 0050a013 movne r5, #0
a013b4c8 3ef7ff1a bne #0xa01391c8
a013b4cc a521d4e5 ldrb r2, [r4, #0x1a5]
a013b4d0 d83c05e3 movw r3, #0x5cd8
a013b4d4 05314ae3 movt r3, #0xa105
a013b4d8 000052e3 cmp r2, #0
a013b4dc 5500001a bne #0xa013b638
a013b4e0 a431d3e5 ldrb r3, [r3, #0x1a4]
a013b4e4 000053e3 cmp r3, #0
a013b4e8 14f8ff1a bne #0xa0139540
a013b4ec 16faffea b #0xa0139d4c
a013b4f0 0400a0e1 mov r0, r4
a013b4f4 c25a01eb bl #0xa0192004
a013b4f8 b0330be3 movw r3, #0xb3b0
a013b4fc 69304ae3 movt r3, #0xa069
a013b500 143093e5 ldr r3, [r3, #0x14]
a013b504 040013e3 tst r3, #4
a013b508 1cf8ff0a beq #0xa0139580
a013b50c 0410a0e1 mov r1, r4
a013b510 0420a0e1 mov r2, r4
a013b514 1b00a0e3 mov r0, #0x1b
a013b518 28dbffeb bl #0xa01321c0
a013b51c 17f8ffea b #0xa0139580
a013b520 8d0f4be2 sub r0, fp, #0x234
a013b524 270050e3 cmp r0, #0x27
a013b528 5300008a bhi #0xa013b67c
a013b52c 0050a0e3 mov r5, #0
a013b530 1bf4ffeb bl #0xa01385a4
a013b534 23f7ffea b #0xa01391c8
a013b538 0050a0e3 mov r5, #0
a013b53c 21f7ffea b #0xa01391c8
a013b540 0b10a0e1 mov r1, fp
a013b544 fe20a0e3 mov r2, #0xfe
a013b548 0200a0e3 mov r0, #2
a013b54c 0050a0e3 mov r5, #0
a013b550 1c1a03eb bl #0xa0201dc8
a013b554 0b10a0e1 mov r1, fp
a013b558 0200a0e3 mov r0, #2
a013b55c 591b03eb bl #0xa02022c8
a013b560 d43404e3 movw r3, #0x44d4
a013b564 0510a0e1 mov r1, r5
a013b568 6d304ae3 movt r3, #0xa06d
a013b56c 6620a0e3 mov r2, #0x66
a013b570 000093e5 ldr r0, [r3]
a013b574 11dbffeb bl #0xa01321c0
a013b578 1400a0e3 mov r0, #0x14
a013b57c 67030aeb bl #0xa03bc320
a013b580 680b04e3 movw r0, #0x4b68
a013b584 182b0fe3 movw r2, #0xfb18
a013b588 53204ae3 movt r2, #0xa053
a013b58c 7f1f02e3 movw r1, #0x2f7f
a013b590 54004ae3 movt r0, #0xa054
a013b594 d4ae05eb bl #0xa02a70ec
a013b598 0500a0e1 mov r0, r5
a013b59c 21eaffeb bl #0xa0135e28
a013b5a0 08f7ffea b #0xa01391c8
a013b5a4 4c3303e3 movw r3, #0x334c
a013b5a8 0010a0e3 mov r1, #0
a013b5ac fb304ae3 movt r3, #0xa0fb
a013b5b0 0120a0e1 mov r2, r1
a013b5b4 183093e5 ldr r3, [r3, #0x18]
a013b5b8 9600a0e3 mov r0, #0x96
a013b5bc 33ff2fe1 blx r3
a013b5c0 0060a0e3 mov r6, #0
a013b5c4 940b04e3 movw r0, #0x4b94
a013b5c8 0610a0e1 mov r1, r6
a013b5cc 54004ae3 movt r0, #0xa054
a013b5d0 b262c4e5 strb r6, [r4, #0x2b2]
a013b5d4 0650a0e1 mov r5, r6
a013b5d8 b46284e5 str r6, [r4, #0x2b4]
a013b5dc b862c4e5 strb r6, [r4, #0x2b8]
a013b5e0 d75c01eb bl #0xa0192944
a013b5e4 0610a0e1 mov r1, r6
a013b5e8 6620a0e3 mov r2, #0x66
a013b5ec 1f00a0e3 mov r0, #0x1f
a013b5f0 f2daffeb bl #0xa01321c0
a013b5f4 f3f6ffea b #0xa01391c8
a013b5f8 0010a0e3 mov r1, #0
a013b5fc 2730a0e3 mov r3, #0x27
a013b600 0120a0e1 mov r2, r1
a013b604 2a00a0e3 mov r0, #0x2a
a013b608 b43284e5 str r3, [r4, #0x2b4]
a013b60c 0150a0e1 mov r5, r1
a013b610 eadaffeb bl #0xa01321c0
a013b614 ebf6ffea b #0xa01391c8
a013b618 0050a0e3 mov r5, #0
a013b61c e9f6ffea b #0xa01391c8
a013b620 0010a0e3 mov r1, #0
a013b624 2700a0e3 mov r0, #0x27
a013b628 0120a0e1 mov r2, r1
a013b62c 0150a0e1 mov r5, r1
a013b630 e2daffeb bl #0xa01321c0
a013b634 e3f6ffea b #0xa01391c8
a013b638 0010a0e3 mov r1, #0
a013b63c 0f00a0e3 mov r0, #0xf
a013b640 0120a0e1 mov r2, r1
a013b644 0150a0e1 mov r5, r1
a013b648 dcdaffeb bl #0xa01321c0
a013b64c ddf6ffea b #0xa01391c8
a013b650 e81a0ce3 movw r1, #0xcae8
a013b654 0100a0e3 mov r0, #1
a013b658 13104ae3 movt r1, #0xa013
a013b65c 1ead02eb bl #0xa01e6adc
a013b660 2bf7ffea b #0xa0139314
a013b664 0010a0e3 mov r1, #0
a013b668 6620a0e3 mov r2, #0x66
a013b66c 1d00a0e3 mov r0, #0x1d
a013b670 0150a0e1 mov r5, r1
a013b674 d1daffeb bl #0xa01321c0
a013b678 d2f6ffea b #0xa01391c8
a013b67c 0050a0e3 mov r5, #0
a013b680 d0f6ffea b #0xa01391c8
a013b684 b232d4e5 ldrb r3, [r4, #0x2b2]
a013b688 0010a0e3 mov r1, #0
a013b68c 0120a0e1 mov r2, r1
a013b690 2700a0e3 mov r0, #0x27
a013b694 0150a0e1 mov r5, r1
a013b698 013043e2 sub r3, r3, #1
a013b69c b232c4e5 strb r3, [r4, #0x2b2]
a013b6a0 c6daffeb bl #0xa01321c0
a013b6a4 c7f6ffea b #0xa01391c8
a013b6a8 b232d4e5 ldrb r3, [r4, #0x2b2]
a013b6ac d84c05e3 movw r4, #0x5cd8
a013b6b0 05414ae3 movt r4, #0xa105
a013b6b4 040053e3 cmp r3, #4
a013b6b8 7500008a bhi #0xa013b894
a013b6bc 0010a0e3 mov r1, #0
a013b6c0 2700a0e3 mov r0, #0x27
a013b6c4 0120a0e1 mov r2, r1
a013b6c8 0150a0e1 mov r5, r1
a013b6cc bbdaffeb bl #0xa01321c0
a013b6d0 bcf6ffea b #0xa01391c8
a013b6d4 d152d4e5 ldrb r5, [r4, #0x2d1]
a013b6d8 d84c05e3 movw r4, #0x5cd8
a013b6dc 05414ae3 movt r4, #0xa105
a013b6e0 020055e3 cmp r5, #2
a013b6e4 1501000a beq #0xa013bb40
a013b6e8 010055e3 cmp r5, #1
a013b6ec 0600000a beq #0xa013b70c
a013b6f0 500c04e3 movw r0, #0x4c50
a013b6f4 182b0fe3 movw r2, #0xfb18
a013b6f8 0530a0e1 mov r3, r5
a013b6fc 54004ae3 movt r0, #0xa054
a013b700 53204ae3 movt r2, #0xa053
a013b704 921103e3 movw r1, #0x3192
a013b708 77ae05eb bl #0xa02a70ec
a013b70c 0230a0e3 mov r3, #2
a013b710 5d20a0e3 mov r2, #0x5d
a013b714 f71200e3 movw r1, #0x2f7
a013b718 0200a0e3 mov r0, #2
a013b71c d132c4e5 strb r3, [r4, #0x2d1]
a013b720 a81903eb bl #0xa0201dc8
a013b724 f71200e3 movw r1, #0x2f7
a013b728 0200a0e3 mov r0, #2
a013b72c e51a03eb bl #0xa02022c8
a013b730 bd1fa0e3 mov r1, #0x2f4
a013b734 0200a0e3 mov r0, #2
a013b738 5720a0e3 mov r2, #0x57
a013b73c a11903eb bl #0xa0201dc8
a013b740 0200a0e3 mov r0, #2
a013b744 bd1fa0e3 mov r1, #0x2f4
a013b748 de1a03eb bl #0xa02022c8
a013b74c 0200a0e3 mov r0, #2
a013b750 0050a0e3 mov r5, #0
a013b754 151c03eb bl #0xa02027b0
a013b758 9af6ffea b #0xa01391c8
a013b75c c2d1ffeb bl #0xa012fe6c
a013b760 b2f8ffea b #0xa0139a30
a013b764 aa30d4e5 ldrb r3, [r4, #0xaa]
a013b768 d82c05e3 movw r2, #0x5cd8
a013b76c 05214ae3 movt r2, #0xa105
a013b770 013083e2 add r3, r3, #1
a013b774 7330efe6 uxtb r3, r3
a013b778 090053e3 cmp r3, #9
a013b77c aa30c4e5 strb r3, [r4, #0xaa]
a013b780 6100009a bls #0xa013b90c
a013b784 a531d2e5 ldrb r3, [r2, #0x1a5]
a013b788 000053e3 cmp r3, #0
a013b78c a9ffff1a bne #0xa013b638
a013b790 a431d2e5 ldrb r3, [r2, #0x1a4]
a013b794 000053e3 cmp r3, #0
a013b798 6bf9ff0a beq #0xa0139d4c
a013b79c 67f7ffea b #0xa0139540
a013b7a0 3f0100e3 movw r0, #0x13f
a013b7a4 a4c5ffeb bl #0xa012ce3c
a013b7a8 000060e2 rsb r0, r0, #0
a013b7ac 48310ce3 movw r3, #0xc148
a013b7b0 0a0050e3 cmp r0, #0xa
a013b7b4 fb304ae3 movt r3, #0xa0fb
a013b7b8 0120a0c3 movgt r2, #1
a013b7bc 0020a0d3 movle r2, #0
a013b7c0 3e20c3e5 strb r2, [r3, #0x3e]
a013b7c4 0dcdffeb bl #0xa012ec00
a013b7c8 5cf7ffea b #0xa0139540
a013b7cc 0010a0e3 mov r1, #0
a013b7d0 6520a0e3 mov r2, #0x65
a013b7d4 2300a0e3 mov r0, #0x23
a013b7d8 0150a0e1 mov r5, r1
a013b7dc 77daffeb bl #0xa01321c0
a013b7e0 95ccffeb bl #0xa012ea3c
a013b7e4 1400a0e3 mov r0, #0x14
a013b7e8 cc020aeb bl #0xa03bc320
a013b7ec 0510a0e1 mov r1, r5
a013b7f0 6620a0e3 mov r2, #0x66
a013b7f4 1f00a0e3 mov r0, #0x1f
a013b7f8 70daffeb bl #0xa01321c0
a013b7fc 71f6ffea b #0xa01391c8
a013b800 0010a0e3 mov r1, #0
a013b804 6520a0e3 mov r2, #0x65
a013b808 2400a0e3 mov r0, #0x24
a013b80c 0150a0e1 mov r5, r1
a013b810 6adaffeb bl #0xa01321c0
a013b814 88ccffeb bl #0xa012ea3c
a013b818 1400a0e3 mov r0, #0x14
a013b81c bf020aeb bl #0xa03bc320
a013b820 0510a0e1 mov r1, r5
a013b824 6620a0e3 mov r2, #0x66
a013b828 1f00a0e3 mov r0, #0x1f
a013b82c 63daffeb bl #0xa01321c0
a013b830 64f6ffea b #0xa01391c8
a013b834 722200e3 movw r2, #0x272
a013b838 9d1200e3 movw r1, #0x29d
a013b83c 0200a0e3 mov r0, #2
a013b840 601903eb bl #0xa0201dc8
a013b844 9d1200e3 movw r1, #0x29d
a013b848 0200a0e3 mov r0, #2
a013b84c 9d1a03eb bl #0xa02022c8
a013b850 0010a0e3 mov r1, #0
a013b854 2400a0e3 mov r0, #0x24
a013b858 0120a0e1 mov r2, r1
a013b85c 57daffeb bl #0xa01321c0
a013b860 0af8ffea b #0xa0139890
a013b864 992fa0e3 mov r2, #0x264
a013b868 8a1200e3 movw r1, #0x28a
a013b86c 0200a0e3 mov r0, #2
a013b870 541903eb bl #0xa0201dc8
a013b874 8a1200e3 movw r1, #0x28a
a013b878 0200a0e3 mov r0, #2
a013b87c 911a03eb bl #0xa02022c8
a013b880 0010a0e3 mov r1, #0
a013b884 2300a0e3 mov r0, #0x23
a013b888 0120a0e1 mov r2, r1
a013b88c 4bdaffeb bl #0xa01321c0
a013b890 d9f7ffea b #0xa01397fc
a013b894 4c3303e3 movw r3, #0x334c
a013b898 0010a0e3 mov r1, #0
a013b89c fb304ae3 movt r3, #0xa0fb
a013b8a0 0120a0e1 mov r2, r1
a013b8a4 183093e5 ldr r3, [r3, #0x18]
a013b8a8 9600a0e3 mov r0, #0x96
a013b8ac 33ff2fe1 blx r3
a013b8b0 0060a0e3 mov r6, #0
a013b8b4 940b04e3 movw r0, #0x4b94
a013b8b8 0610a0e1 mov r1, r6
a013b8bc 54004ae3 movt r0, #0xa054
a013b8c0 b262c4e5 strb r6, [r4, #0x2b2]
a013b8c4 0650a0e1 mov r5, r6
a013b8c8 b46284e5 str r6, [r4, #0x2b4]
a013b8cc b862c4e5 strb r6, [r4, #0x2b8]
a013b8d0 1b5c01eb bl #0xa0192944
a013b8d4 0610a0e1 mov r1, r6
a013b8d8 6620a0e3 mov r2, #0x66
a013b8dc 1b00a0e3 mov r0, #0x1b
a013b8e0 36daffeb bl #0xa01321c0
a013b8e4 0610a0e1 mov r1, r6
a013b8e8 0900a0e3 mov r0, #9
a013b8ec 24d7ffeb bl #0xa0131584
a013b8f0 34f6ffea b #0xa01391c8
a013b8f4 aa30d4e5 ldrb r3, [r4, #0xaa]
a013b8f8 013083e2 add r3, r3, #1
a013b8fc 7330efe6 uxtb r3, r3
a013b900 090053e3 cmp r3, #9
a013b904 aa30c4e5 strb r3, [r4, #0xaa]
a013b908 2cf9ff8a bhi #0xa0139dc0
a013b90c 700004e3 movw r0, #0x4070
a013b910 182b0fe3 movw r2, #0xfb18
a013b914 53204ae3 movt r2, #0xa053
a013b918 6c1c02e3 movw r1, #0x2c6c
a013b91c 54004ae3 movt r0, #0xa054
a013b920 0050a0e3 mov r5, #0
a013b924 f0ad05eb bl #0xa02a70ec
a013b928 aa20d4e5 ldrb r2, [r4, #0xaa]
a013b92c 443b00e3 movw r3, #0xb44
a013b930 54304ae3 movt r3, #0xa054
a013b934 e910a0e3 mov r1, #0xe9
a013b938 0200a0e3 mov r0, #2
a013b93c 022193e7 ldr r2, [r3, r2, lsl #2]
a013b940 201903eb bl #0xa0201dc8
a013b944 e910a0e3 mov r1, #0xe9
a013b948 0200a0e3 mov r0, #2
a013b94c 5d1a03eb bl #0xa02022c8
a013b950 0510a0e1 mov r1, r5
a013b954 0520a0e1 mov r2, r5
a013b958 0c00a0e3 mov r0, #0xc
a013b95c 17daffeb bl #0xa01321c0
a013b960 18f6ffea b #0xa01391c8
a013b964 732200e3 movw r2, #0x273
a013b968 9d1200e3 movw r1, #0x29d
a013b96c 0200a0e3 mov r0, #2
a013b970 141903eb bl #0xa0201dc8
a013b974 9d1200e3 movw r1, #0x29d
a013b978 0200a0e3 mov r0, #2
a013b97c 511a03eb bl #0xa02022c8
a013b980 0410a0e1 mov r1, r4
a013b984 0420a0e1 mov r2, r4
a013b988 2400a0e3 mov r0, #0x24
a013b98c 0bdaffeb bl #0xa01321c0
a013b990 bef7ffea b #0xa0139890
a013b994 652200e3 movw r2, #0x265
a013b998 8a1200e3 movw r1, #0x28a
a013b99c 0200a0e3 mov r0, #2
a013b9a0 081903eb bl #0xa0201dc8
a013b9a4 8a1200e3 movw r1, #0x28a
a013b9a8 0200a0e3 mov r0, #2
a013b9ac 451a03eb bl #0xa02022c8
a013b9b0 0410a0e1 mov r1, r4
a013b9b4 0420a0e1 mov r2, r4
a013b9b8 2300a0e3 mov r0, #0x23
a013b9bc ffd9ffeb bl #0xa01321c0
a013b9c0 8df7ffea b #0xa01397fc
a013b9c4 9d2fa0e3 mov r2, #0x274
a013b9c8 9d1200e3 movw r1, #0x29d
a013b9cc 0200a0e3 mov r0, #2
a013b9d0 fc1803eb bl #0xa0201dc8
a013b9d4 9d1200e3 movw r1, #0x29d
a013b9d8 0200a0e3 mov r0, #2
a013b9dc 391a03eb bl #0xa02022c8
a013b9e0 0510a0e1 mov r1, r5
a013b9e4 0520a0e1 mov r2, r5
a013b9e8 2400a0e3 mov r0, #0x24
a013b9ec f3d9ffeb bl #0xa01321c0
a013b9f0 a6f7ffea b #0xa0139890
a013b9f4 662200e3 movw r2, #0x266
a013b9f8 8a1200e3 movw r1, #0x28a
a013b9fc 0200a0e3 mov r0, #2
a013ba00 f01803eb bl #0xa0201dc8
a013ba04 8a1200e3 movw r1, #0x28a
a013ba08 0200a0e3 mov r0, #2
a013ba0c 2d1a03eb bl #0xa02022c8
a013ba10 0510a0e1 mov r1, r5
a013ba14 0520a0e1 mov r2, r5
a013ba18 2300a0e3 mov r0, #0x23
a013ba1c e7d9ffeb bl #0xa01321c0
a013ba20 75f7ffea b #0xa01397fc
a013ba24 fb304ae3 movt r3, #0xa0fb
a013ba28 0020d3e5 ldrb r2, [r3]
a013ba2c 000052e3 cmp r2, #0
a013ba30 01204212 subne r2, r2, #1
a013ba34 7220ef16 uxtbne r2, r2
a013ba38 31feff0a beq #0xa013b304
a013ba3c 2afeffea b #0xa013b2ec
a013ba40 3820d9e5 ldrb r2, [sb, #0x38]
a013ba44 050052e3 cmp r2, #5
a013ba48 dc00008a bhi #0xa013bdc0
a013ba4c a912d4e5 ldrb r1, [r4, #0x2a9]
a013ba50 600504e3 movw r0, #0x4560
a013ba54 182b0fe3 movw r2, #0xfb18
a013ba58 54004ae3 movt r0, #0xa054
a013ba5c 53204ae3 movt r2, #0xa053
a013ba60 10c08de5 str ip, [sp, #0x10]
a013ba64 00108de5 str r1, [sp]
a013ba68 f31d02e3 movw r1, #0x2df3
a013ba6c 9ead05eb bl #0xa02a70ec
a013ba70 003097e5 ldr r3, [r7]
a013ba74 d81c05e3 movw r1, #0x5cd8
a013ba78 05114ae3 movt r1, #0xa105
a013ba7c 10c09de5 ldr ip, [sp, #0x10]
a013ba80 012083e2 add r2, r3, #1
a013ba84 0232a0e1 lsl r3, r2, #4
a013ba88 023183e0 add r3, r3, r2, lsl #2
a013ba8c 033086e0 add r3, r6, r3
a013ba90 103093e5 ldr r3, [r3, #0x10]
a013ba94 0a2043e2 sub r2, r3, #0xa
a013ba98 010052e3 cmp r2, #1
a013ba9c d200009a bls #0xa013bdec
a013baa0 aa12d4e5 ldrb r1, [r4, #0x2aa]
a013baa4 c80504e3 movw r0, #0x45c8
a013baa8 182b0fe3 movw r2, #0xfb18
a013baac 54004ae3 movt r0, #0xa054
a013bab0 53204ae3 movt r2, #0xa053
a013bab4 10c08de5 str ip, [sp, #0x10]
a013bab8 00108de5 str r1, [sp]
a013babc fb1d02e3 movw r1, #0x2dfb
a013bac0 89ad05eb bl #0xa02a70ec
a013bac4 001097e5 ldr r1, [r7]
a013bac8 d83c05e3 movw r3, #0x5cd8
a013bacc 05314ae3 movt r3, #0xa105
a013bad0 10c09de5 ldr ip, [sp, #0x10]
a013bad4 010081e2 add r0, r1, #1
a013bad8 0022a0e1 lsl r2, r0, #4
a013badc 002182e0 add r2, r2, r0, lsl #2
a013bae0 026086e0 add r6, r6, r2
a013bae4 102096e5 ldr r2, [r6, #0x10]
a013bae8 110052e3 cmp r2, #0x11
a013baec eb02000a beq #0xa013c6a0
a013baf0 14309de5 ldr r3, [sp, #0x14]
a013baf4 0bb063e0 rsb fp, r3, fp
a013baf8 0b5085e0 add r5, r5, fp
a013bafc 403095e5 ldr r3, [r5, #0x40]
a013bb00 010053e3 cmp r3, #1
a013bb04 2501001a bne #0xa013bfa0
a013bb08 5c3095e5 ldr r3, [r5, #0x5c]
a013bb0c 000053e3 cmp r3, #0
a013bb10 abf5ff0a beq #0xa01391c4
a013bb14 0200a0e3 mov r0, #2
a013bb18 0050a0e3 mov r5, #0
a013bb1c 33ff2fe1 blx r3
a013bb20 a8f5ffea b #0xa01391c8
a013bb24 efcbffeb bl #0xa012eae8
a013bb28 0010a0e3 mov r1, #0
a013bb2c 6a20a0e3 mov r2, #0x6a
a013bb30 1d00a0e3 mov r0, #0x1d
a013bb34 0150a0e1 mov r5, r1
a013bb38 a0d9ffeb bl #0xa01321c0
a013bb3c a1f5ffea b #0xa01391c8
a013bb40 0130a0e3 mov r3, #1
a013bb44 0b10a0e1 mov r1, fp
a013bb48 5c20a0e3 mov r2, #0x5c
a013bb4c 0500a0e1 mov r0, r5
a013bb50 d132c4e5 strb r3, [r4, #0x2d1]
a013bb54 9b1803eb bl #0xa0201dc8
a013bb58 0b10a0e1 mov r1, fp
a013bb5c 0500a0e1 mov r0, r5
a013bb60 d81903eb bl #0xa02022c8
a013bb64 0500a0e1 mov r0, r5
a013bb68 bd1fa0e3 mov r1, #0x2f4
a013bb6c 5520a0e3 mov r2, #0x55
a013bb70 941803eb bl #0xa0201dc8
a013bb74 0500a0e1 mov r0, r5
a013bb78 bd1fa0e3 mov r1, #0x2f4
a013bb7c d11903eb bl #0xa02022c8
a013bb80 f1feffea b #0xa013b74c
a013bb84 0b1a00eb bl #0xa01423b8
a013bb88 7c2003e3 movw r2, #0x307c
a013bb8c 00a0a0e1 mov sl, r0
a013bb90 6f204ae3 movt r2, #0xa06f
a013bb94 340704e3 movw r0, #0x4734
a013bb98 183b0fe3 movw r3, #0xfb18
a013bb9c 00a08de5 str sl, [sp]
a013bba0 54004ae3 movt r0, #0xa054
a013bba4 081092e5 ldr r1, [r2, #8]
a013bba8 53304ae3 movt r3, #0xa053
a013bbac 782e02e3 movw r2, #0x2e78
a013bbb0 4dad05eb bl #0xa02a70ec
a013bbb4 00005ae3 cmp sl, #0
a013bbb8 48610ce3 movw r6, #0xc148
a013bbbc fb604ae3 movt r6, #0xa0fb
a013bbc0 020000ba blt #0xa013bbd0
a013bbc4 3130d6e5 ldrb r3, [r6, #0x31]
a013bbc8 03005ae1 cmp sl, r3
a013bbcc b3f8ffca bgt #0xa0139ea0
a013bbd0 0030a0e3 mov r3, #0
a013bbd4 01a0a0e3 mov sl, #1
a013bbd8 0300a0e1 mov r0, r3
a013bbdc 3130c6e5 strb r3, [r6, #0x31]
a013bbe0 35be00eb bl #0xa016b4bc
a013bbe4 adf8ffea b #0xa0139ea0
a013bbe8 56c4ffeb bl #0xa012cd48
a013bbec 00a0a0e1 mov sl, r0
a013bbf0 a4f8ffea b #0xa0139e88
a013bbf4 2cc4ffeb bl #0xa012ccac
a013bbf8 00a0a0e1 mov sl, r0
a013bbfc 9bf8ffea b #0xa0139e70
a013bc00 dc1900eb bl #0xa0142378
a013bc04 7c2003e3 movw r2, #0x307c
a013bc08 00a0a0e1 mov sl, r0
a013bc0c 6f204ae3 movt r2, #0xa06f
a013bc10 a80604e3 movw r0, #0x46a8
a013bc14 183b0fe3 movw r3, #0xfb18
a013bc18 00a08de5 str sl, [sp]
a013bc1c 54004ae3 movt r0, #0xa054
a013bc20 081092e5 ldr r1, [r2, #8]
a013bc24 53304ae3 movt r3, #0xa053
a013bc28 642e02e3 movw r2, #0x2e64
a013bc2c 2ead05eb bl #0xa02a70ec
a013bc30 00005ae3 cmp sl, #0
a013bc34 48610ce3 movw r6, #0xc148
a013bc38 fb604ae3 movt r6, #0xa0fb
a013bc3c 020000ba blt #0xa013bc4c
a013bc40 4f30d6e5 ldrb r3, [r6, #0x4f]
a013bc44 03005ae1 cmp sl, r3
a013bc48 82f8ffca bgt #0xa0139e58
a013bc4c 0030a0e3 mov r3, #0
a013bc50 01a0a0e3 mov sl, #1
a013bc54 4f30c6e5 strb r3, [r6, #0x4f]
a013bc58 7ef8ffea b #0xa0139e58
a013bc5c 6520a0e3 mov r2, #0x65
a013bc60 000093e5 ldr r0, [r3]
a013bc64 0150a0e1 mov r5, r1
a013bc68 54d9ffeb bl #0xa01321c0
a013bc6c 1400a0e3 mov r0, #0x14
a013bc70 aa010aeb bl #0xa03bc320
a013bc74 0510a0e1 mov r1, r5
a013bc78 6620a0e3 mov r2, #0x66
a013bc7c 1b00a0e3 mov r0, #0x1b
a013bc80 4ed9ffeb bl #0xa01321c0
a013bc84 4ff5ffea b #0xa01391c8
a013bc88 0010a0e3 mov r1, #0
a013bc8c 6620a0e3 mov r2, #0x66
a013bc90 1b00a0e3 mov r0, #0x1b
a013bc94 0150a0e1 mov r5, r1
a013bc98 48d9ffeb bl #0xa01321c0
a013bc9c 49f5ffea b #0xa01391c8
a013bca0 d1cfffeb bl #0xa012fbec
a013bca4 47f5ffea b #0xa01391c8
a013bca8 1400a0e3 mov r0, #0x14
a013bcac 0450a0e1 mov r5, r4
a013bcb0 9a010aeb bl #0xa03bc320
a013bcb4 0410a0e1 mov r1, r4
a013bcb8 6a20a0e3 mov r2, #0x6a
a013bcbc 1d00a0e3 mov r0, #0x1d
a013bcc0 3ed9ffeb bl #0xa01321c0
a013bcc4 3ff5ffea b #0xa01391c8
a013bcc8 02c0a0e3 mov ip, #2
a013bccc 9c0702e3 movw r0, #0x279c
a013bcd0 e42e05e3 movw r2, #0x5ee4
a013bcd4 0c30a0e1 mov r3, ip
a013bcd8 54204ae3 movt r2, #0xa054
a013bcdc 4f1902e3 movw r1, #0x294f
a013bce0 54004ae3 movt r0, #0xa054
a013bce4 a6c1c4e5 strb ip, [r4, #0x1a6]
a013bce8 ffac05eb bl #0xa02a70ec
a013bcec f00d9fe5 ldr r0, [pc, #0xdf0]
a013bcf0 86010aeb bl #0xa03bc310
a013bcf4 e80d9fe5 ldr r0, [pc, #0xde8]
a013bcf8 83010aeb bl #0xa03bc30c
a013bcfc 0610a0e1 mov r1, r6
a013bd00 6620a0e3 mov r2, #0x66
a013bd04 1a00a0e3 mov r0, #0x1a
a013bd08 4060c5e5 strb r6, [r5, #0x40]
a013bd0c 2bd9ffeb bl #0xa01321c0
a013bd10 69c7ffeb bl #0xa012dabc
a013bd14 a5fbffea b #0xa013abb0
a013bd18 48310ce3 movw r3, #0xc148
a013bd1c fb304ae3 movt r3, #0xa0fb
a013bd20 0030d3e5 ldrb r3, [r3]
a013bd24 040053e3 cmp r3, #4
a013bd28 3030a003 moveq r3, #0x30
a013bd2c 00308805 streq r3, [r8]
a013bd30 0200000a beq #0xa013bd40
a013bd34 070053e3 cmp r3, #7
a013bd38 5630a003 moveq r3, #0x56
a013bd3c 00308805 streq r3, [r8]
a013bd40 001098e5 ldr r1, [r8]
a013bd44 6a20a0e3 mov r2, #0x6a
a013bd48 1e00a0e3 mov r0, #0x1e
a013bd4c 0050a0e3 mov r5, #0
a013bd50 1ad9ffeb bl #0xa01321c0
a013bd54 1bf5ffea b #0xa01391c8
a013bd58 4e8effeb bl #0xa011f698
a013bd5c 005050e2 subs r5, r0, #0
a013bd60 4502000a beq #0xa013c67c
a013bd64 d8e2ffeb bl #0xa01348cc
a013bd68 901108e3 movw r1, #0x8190
a013bd6c 0420a0e1 mov r2, r4
a013bd70 12104ae3 movt r1, #0xa012
a013bd74 0700a0e3 mov r0, #7
a013bd78 c3ab02eb bl #0xa01e6c8c
a013bd7c 0050a0e3 mov r5, #0
a013bd80 10f5ffea b #0xa01391c8
a013bd84 440104e3 movw r0, #0x4144
a013bd88 182b0fe3 movw r2, #0xfb18
a013bd8c 53204ae3 movt r2, #0xa053
a013bd90 f91c02e3 movw r1, #0x2cf9
a013bd94 54004ae3 movt r0, #0xa054
a013bd98 d3ac05eb bl #0xa02a70ec
a013bd9c 4cf5ffea b #0xa01392d4
a013bda0 0020d9e5 ldrb r2, [sb]
a013bda4 010052e3 cmp r2, #1
a013bda8 24ffff9a bls #0xa013ba40
a013bdac 030052e3 cmp r2, #3
a013bdb0 25ffff1a bne #0xa013ba4c
a013bdb4 3120d9e5 ldrb r2, [sb, #0x31]
a013bdb8 050052e3 cmp r2, #5
a013bdbc 22ffff9a bls #0xa013ba4c
a013bdc0 7c2003e3 movw r2, #0x307c
a013bdc4 a40404e3 movw r0, #0x44a4
a013bdc8 6f204ae3 movt r2, #0xa06f
a013bdcc 183b0fe3 movw r3, #0xfb18
a013bdd0 041092e5 ldr r1, [r2, #4]
a013bdd4 54004ae3 movt r0, #0xa054
a013bdd8 53304ae3 movt r3, #0xa053
a013bddc e32d02e3 movw r2, #0x2de3
a013bde0 c1ac05eb bl #0xa02a70ec
a013bde4 0050a0e3 mov r5, #0
a013bde8 f6f4ffea b #0xa01391c8
a013bdec a9e2d1e5 ldrb lr, [r1, #0x2a9]
a013bdf0 00005ee3 cmp lr, #0
a013bdf4 29ffff1a bne #0xa013baa0
a013bdf8 7c2003e3 movw r2, #0x307c
a013bdfc 980504e3 movw r0, #0x4598
a013be00 6f204ae3 movt r2, #0xa06f
a013be04 183b0fe3 movw r3, #0xfb18
a013be08 041092e5 ldr r1, [r2, #4]
a013be0c 53304ae3 movt r3, #0xa053
a013be10 f72d02e3 movw r2, #0x2df7
a013be14 54004ae3 movt r0, #0xa054
a013be18 0e50a0e1 mov r5, lr
a013be1c b2ac05eb bl #0xa02a70ec
a013be20 e8f4ffea b #0xa01391c8
a013be24 01a04ae2 sub sl, sl, #1
a013be28 aef9ffea b #0xa013a4e8
a013be2c 0010a0e3 mov r1, #0
a013be30 1300a0e3 mov r0, #0x13
a013be34 d2d5ffeb bl #0xa0131584
a013be38 7c2003e3 movw r2, #0x307c
a013be3c a40104e3 movw r0, #0x41a4
a013be40 6f204ae3 movt r2, #0xa06f
a013be44 183b0fe3 movw r3, #0xfb18
a013be48 081092e5 ldr r1, [r2, #8]
a013be4c 54004ae3 movt r0, #0xa054
a013be50 53304ae3 movt r3, #0xa053
a013be54 122d02e3 movw r2, #0x2d12
a013be58 a3ac05eb bl #0xa02a70ec
a013be5c 0050a0e3 mov r5, #0
a013be60 d8f4ffea b #0xa01391c8
a013be64 0010a0e3 mov r1, #0
a013be68 1300a0e3 mov r0, #0x13
a013be6c c4d5ffeb bl #0xa0131584
a013be70 dc0104e3 movw r0, #0x41dc
a013be74 182b0fe3 movw r2, #0xfb18
a013be78 53204ae3 movt r2, #0xa053
a013be7c 261d02e3 movw r1, #0x2d26
a013be80 54004ae3 movt r0, #0xa054
a013be84 0050a0e3 mov r5, #0
a013be88 97ac05eb bl #0xa02a70ec
a013be8c cdf4ffea b #0xa01391c8
a013be90 0050a0e3 mov r5, #0
a013be94 cbf4ffea b #0xa01391c8
a013be98 200c04e3 movw r0, #0x4c20
a013be9c 182b0fe3 movw r2, #0xfb18
a013bea0 53204ae3 movt r2, #0xa053
a013bea4 5b1003e3 movw r1, #0x305b
a013bea8 54004ae3 movt r0, #0xa054
a013beac 304c03e3 movw r4, #0x3c30
a013beb0 8dac05eb bl #0xa02a70ec
a013beb4 0b10a0e1 mov r1, fp
a013beb8 012ca0e3 mov r2, #0x100
a013bebc 0200a0e3 mov r0, #2
a013bec0 fb404ae3 movt r4, #0xa0fb
a013bec4 bf1703eb bl #0xa0201dc8
a013bec8 0b10a0e1 mov r1, fp
a013becc 0200a0e3 mov r0, #2
a013bed0 fc1803eb bl #0xa02022c8
a013bed4 d43404e3 movw r3, #0x44d4
a013bed8 6920a0e3 mov r2, #0x69
a013bedc 6d304ae3 movt r3, #0xa06d
a013bee0 0010a0e3 mov r1, #0
a013bee4 000093e5 ldr r0, [r3]
a013bee8 0050a0e3 mov r5, #0
a013beec b3d8ffeb bl #0xa01321c0
a013bef0 1400a0e3 mov r0, #0x14
a013bef4 09010aeb bl #0xa03bc320
a013bef8 0100a0e3 mov r0, #1
a013befc 2b4300eb bl #0xa014cbb0
a013bf00 001050e2 subs r1, r0, #0
a013bf04 0010a013 movne r1, #0
a013bf08 3200a003 moveq r0, #0x32
a013bf0c 1300a013 movne r0, #0x13
a013bf10 9bd5ffeb bl #0xa0131584
a013bf14 006094e5 ldr r6, [r4]
a013bf18 110200e3 movw r0, #0x211
a013bf1c c6c3ffeb bl #0xa012ce3c
a013bf20 683b02e3 movw r3, #0x2b68
a013bf24 6410a0e3 mov r1, #0x64
a013bf28 6a304ae3 movt r3, #0xa06a
a013bf2c 1e20a0e3 mov r2, #0x1e
a013bf30 913623e0 mla r3, r1, r6, r3
a013bf34 002084e5 str r2, [r4]
a013bf38 0510a0e1 mov r1, r5
a013bf3c 6620a0e3 mov r2, #0x66
a013bf40 480083e5 str r0, [r3, #0x48]
a013bf44 1f00a0e3 mov r0, #0x1f
a013bf48 9cd8ffeb bl #0xa01321c0
a013bf4c 9df4ffea b #0xa01391c8
a013bf50 0050a0e3 mov r5, #0
a013bf54 9bf4ffea b #0xa01391c8
a013bf58 0b10a0e1 mov r1, fp
a013bf5c 012ca0e3 mov r2, #0x100
a013bf60 0200a0e3 mov r0, #2
a013bf64 0050a0e3 mov r5, #0
a013bf68 961703eb bl #0xa0201dc8
a013bf6c 0b10a0e1 mov r1, fp
a013bf70 0200a0e3 mov r0, #2
a013bf74 d31803eb bl #0xa02022c8
a013bf78 d43404e3 movw r3, #0x44d4
a013bf7c 0510a0e1 mov r1, r5
a013bf80 6d304ae3 movt r3, #0xa06d
a013bf84 6920a0e3 mov r2, #0x69
a013bf88 000093e5 ldr r0, [r3]
a013bf8c 8bd8ffeb bl #0xa01321c0
a013bf90 1400a0e3 mov r0, #0x14
a013bf94 e1000aeb bl #0xa03bc320
a013bf98 01d6ffeb bl #0xa01317a4
a013bf9c 89f4ffea b #0xa01391c8
a013bfa0 6920a0e3 mov r2, #0x69
a013bfa4 1d00a0e3 mov r0, #0x1d
a013bfa8 10c08de5 str ip, [sp, #0x10]
a013bfac 0050a0e3 mov r5, #0
a013bfb0 82d8ffeb bl #0xa01321c0
a013bfb4 1400a0e3 mov r0, #0x14
a013bfb8 d8000aeb bl #0xa03bc320
a013bfbc 10c09de5 ldr ip, [sp, #0x10]
a013bfc0 6620a0e3 mov r2, #0x66
a013bfc4 1e00a0e3 mov r0, #0x1e
a013bfc8 0c10a0e1 mov r1, ip
a013bfcc 7bd8ffeb bl #0xa01321c0
a013bfd0 7cf4ffea b #0xa01391c8
a013bfd4 0050a0e3 mov r5, #0
a013bfd8 7af4ffea b #0xa01391c8
a013bfdc 012ca0e3 mov r2, #0x100
a013bfe0 0b10a0e1 mov r1, fp
a013bfe4 0200a0e3 mov r0, #2
a013bfe8 761703eb bl #0xa0201dc8
a013bfec 0b10a0e1 mov r1, fp
a013bff0 0200a0e3 mov r0, #2
a013bff4 b31803eb bl #0xa02022c8
a013bff8 d43404e3 movw r3, #0x44d4
a013bffc 0010a0e3 mov r1, #0
a013c000 6d304ae3 movt r3, #0xa06d
a013c004 6920a0e3 mov r2, #0x69
a013c008 000093e5 ldr r0, [r3]
a013c00c 6bd8ffeb bl #0xa01321c0
a013c010 1400a0e3 mov r0, #0x14
a013c014 c1000aeb bl #0xa03bc320
a013c018 4c3303e3 movw r3, #0x334c
a013c01c 0010a0e3 mov r1, #0
a013c020 fb304ae3 movt r3, #0xa0fb
a013c024 0120a0e1 mov r2, r1
a013c028 183093e5 ldr r3, [r3, #0x18]
a013c02c 7000a0e3 mov r0, #0x70
a013c030 33ff2fe1 blx r3
a013c034 0050a0e1 mov r5, r0
a013c038 62f4ffea b #0xa01391c8
a013c03c 0050a0e3 mov r5, #0
a013c040 60f4ffea b #0xa01391c8
a013c044 0b10a0e1 mov r1, fp
a013c048 012ca0e3 mov r2, #0x100
a013c04c 0200a0e3 mov r0, #2
a013c050 48610ce3 movw r6, #0xc148
a013c054 5b1703eb bl #0xa0201dc8
a013c058 0b10a0e1 mov r1, fp
a013c05c 0200a0e3 mov r0, #2
a013c060 981803eb bl #0xa02022c8
a013c064 d43404e3 movw r3, #0x44d4
a013c068 0010a0e3 mov r1, #0
a013c06c 6d304ae3 movt r3, #0xa06d
a013c070 6920a0e3 mov r2, #0x69
a013c074 000093e5 ldr r0, [r3]
a013c078 fb604ae3 movt r6, #0xa0fb
a013c07c 4fd8ffeb bl #0xa01321c0
a013c080 1400a0e3 mov r0, #0x14
a013c084 a5000aeb bl #0xa03bc320
a013c088 3d30d6e5 ldrb r3, [r6, #0x3d]
a013c08c 000053e3 cmp r3, #0
a013c090 0130a003 moveq r3, #1
a013c094 0030a013 movne r3, #0
a013c098 3d30c6e5 strb r3, [r6, #0x3d]
a013c09c 3d00d6e5 ldrb r0, [r6, #0x3d]
a013c0a0 89c5ffeb bl #0xa012d6cc
a013c0a4 0010a0e3 mov r1, #0
a013c0a8 0050a0e1 mov r5, r0
a013c0ac 6620a0e3 mov r2, #0x66
a013c0b0 1f00a0e3 mov r0, #0x1f
a013c0b4 41d8ffeb bl #0xa01321c0
a013c0b8 42f4ffea b #0xa01391c8
a013c0bc 9fe1d4e5 ldrb lr, [r4, #0x19f]
a013c0c0 00005ee3 cmp lr, #0
a013c0c4 60feff1a bne #0xa013ba4c
a013c0c8 7c2003e3 movw r2, #0x307c
a013c0cc f00404e3 movw r0, #0x44f0
a013c0d0 6f204ae3 movt r2, #0xa06f
a013c0d4 183b0fe3 movw r3, #0xfb18
a013c0d8 041092e5 ldr r1, [r2, #4]
a013c0dc 53304ae3 movt r3, #0xa053
a013c0e0 e82d02e3 movw r2, #0x2de8
a013c0e4 54004ae3 movt r0, #0xa054
a013c0e8 0e50a0e1 mov r5, lr
a013c0ec feab05eb bl #0xa02a70ec
a013c0f0 34f4ffea b #0xa01391c8
a013c0f4 28300de3 movw r3, #0xd028
a013c0f8 60c0a0e3 mov ip, #0x60
a013c0fc 69304ae3 movt r3, #0xa069
a013c100 3c0604e3 movw r0, #0x463c
a013c104 182b0fe3 movw r2, #0xfb18
a013c108 54004ae3 movt r0, #0xa054
a013c10c 9c3123e0 mla r3, ip, r1, r3
a013c110 53204ae3 movt r2, #0xa053
a013c114 461e02e3 movw r1, #0x2e46
a013c118 f3ab05eb bl #0xa02a70ec
a013c11c 85caffeb bl #0xa012eb38
a013c120 59f8ffea b #0xa013a28c
a013c124 0050a0e3 mov r5, #0
a013c128 26f4ffea b #0xa01391c8
a013c12c b00b04e3 movw r0, #0x4bb0
a013c130 182b0fe3 movw r2, #0xfb18
a013c134 53204ae3 movt r2, #0xa053
a013c138 281003e3 movw r1, #0x3028
a013c13c 54004ae3 movt r0, #0xa054
a013c140 0050a0e3 mov r5, #0
a013c144 e8ab05eb bl #0xa02a70ec
a013c148 0b10a0e1 mov r1, fp
a013c14c 012ca0e3 mov r2, #0x100
a013c150 0200a0e3 mov r0, #2
a013c154 1b1703eb bl #0xa0201dc8
a013c158 0b10a0e1 mov r1, fp
a013c15c 0200a0e3 mov r0, #2
a013c160 581803eb bl #0xa02022c8
a013c164 d43404e3 movw r3, #0x44d4
a013c168 0510a0e1 mov r1, r5
a013c16c 6d304ae3 movt r3, #0xa06d
a013c170 6920a0e3 mov r2, #0x69
a013c174 000093e5 ldr r0, [r3]
a013c178 10d8ffeb bl #0xa01321c0
a013c17c 1400a0e3 mov r0, #0x14
a013c180 66000aeb bl #0xa03bc320
a013c184 0510a0e1 mov r1, r5
a013c188 0520a0e1 mov r2, r5
a013c18c 0300a0e3 mov r0, #3
a013c190 0ad8ffeb bl #0xa01321c0
a013c194 0100a0e3 mov r0, #1
a013c198 0010a0e1 mov r1, r0
a013c19c 274200eb bl #0xa014ca40
a013c1a0 08f4ffea b #0xa01391c8
a013c1a4 792100e3 movw r2, #0x179
a013c1a8 5d1fa0e3 mov r1, #0x174
a013c1ac 0200a0e3 mov r0, #2
a013c1b0 d86c05e3 movw r6, #0x5cd8
a013c1b4 031703eb bl #0xa0201dc8
a013c1b8 5d1fa0e3 mov r1, #0x174
a013c1bc 0200a0e3 mov r0, #2
a013c1c0 401803eb bl #0xa02022c8
a013c1c4 0010a0e3 mov r1, #0
a013c1c8 6920a0e3 mov r2, #0x69
a013c1cc 1b00a0e3 mov r0, #0x1b
a013c1d0 05614ae3 movt r6, #0xa105
a013c1d4 f9d7ffeb bl #0xa01321c0
a013c1d8 1400a0e3 mov r0, #0x14
a013c1dc 4f000aeb bl #0xa03bc320
a013c1e0 1630d4e5 ldrb r3, [r4, #0x16]
a013c1e4 020013e3 tst r3, #2
a013c1e8 7c01000a beq #0xa013c7e0
a013c1ec b020a0e3 mov r2, #0xb0
a013c1f0 451100e3 movw r1, #0x145
a013c1f4 0200a0e3 mov r0, #2
a013c1f8 0050a0e3 mov r5, #0
a013c1fc f11603eb bl #0xa0201dc8
a013c200 451100e3 movw r1, #0x145
a013c204 0200a0e3 mov r0, #2
a013c208 2e1803eb bl #0xa02022c8
a013c20c 012100e3 movw r2, #0x101
a013c210 461100e3 movw r1, #0x146
a013c214 0200a0e3 mov r0, #2
a013c218 ea1603eb bl #0xa0201dc8
a013c21c 461100e3 movw r1, #0x146
a013c220 0200a0e3 mov r0, #2
a013c224 271803eb bl #0xa02022c8
a013c228 fc20a0e3 mov r2, #0xfc
a013c22c 471100e3 movw r1, #0x147
a013c230 0200a0e3 mov r0, #2
a013c234 e31603eb bl #0xa0201dc8
a013c238 471100e3 movw r1, #0x147
a013c23c 0200a0e3 mov r0, #2
a013c240 201803eb bl #0xa02022c8
a013c244 0e30a0e3 mov r3, #0xe
a013c248 0510a0e1 mov r1, r5
a013c24c 0520a0e1 mov r2, r5
a013c250 1500a0e3 mov r0, #0x15
a013c254 5c3086e5 str r3, [r6, #0x5c]
a013c258 d8d7ffeb bl #0xa01321c0
a013c25c d9f3ffea b #0xa01391c8
a013c260 0050a0e3 mov r5, #0
a013c264 d7f3ffea b #0xa01391c8
a013c268 0050a0e3 mov r5, #0
a013c26c d5f3ffea b #0xa01391c8
a013c270 0b10a0e1 mov r1, fp
a013c274 c420a0e3 mov r2, #0xc4
a013c278 0200a0e3 mov r0, #2
a013c27c 0060a0e3 mov r6, #0
a013c280 d01603eb bl #0xa0201dc8
a013c284 0b10a0e1 mov r1, fp
a013c288 0200a0e3 mov r0, #2
a013c28c 0d1803eb bl #0xa02022c8
a013c290 d43404e3 movw r3, #0x44d4
a013c294 0610a0e1 mov r1, r6
a013c298 6d304ae3 movt r3, #0xa06d
a013c29c 6920a0e3 mov r2, #0x69
a013c2a0 000093e5 ldr r0, [r3]
a013c2a4 0650a0e1 mov r5, r6
a013c2a8 c4d7ffeb bl #0xa01321c0
a013c2ac 1400a0e3 mov r0, #0x14
a013c2b0 1a000aeb bl #0xa03bc320
a013c2b4 0610a0e1 mov r1, r6
a013c2b8 6620a0e3 mov r2, #0x66
a013c2bc 1b00a0e3 mov r0, #0x1b
a013c2c0 bed7ffeb bl #0xa01321c0
a013c2c4 b460c4e5 strb r6, [r4, #0xb4]
a013c2c8 15ccffeb bl #0xa012f324
a013c2cc bdf3ffea b #0xa01391c8
a013c2d0 0050a0e3 mov r5, #0
a013c2d4 bbf3ffea b #0xa01391c8
a013c2d8 0b10a0e1 mov r1, fp
a013c2dc 012ca0e3 mov r2, #0x100
a013c2e0 0200a0e3 mov r0, #2
a013c2e4 b71603eb bl #0xa0201dc8
a013c2e8 0b10a0e1 mov r1, fp
a013c2ec 0200a0e3 mov r0, #2
a013c2f0 f41703eb bl #0xa02022c8
a013c2f4 d43404e3 movw r3, #0x44d4
a013c2f8 0010a0e3 mov r1, #0
a013c2fc 6d304ae3 movt r3, #0xa06d
a013c300 6920a0e3 mov r2, #0x69
a013c304 000093e5 ldr r0, [r3]
a013c308 acd7ffeb bl #0xa01321c0
a013c30c 1400a0e3 mov r0, #0x14
a013c310 02000aeb bl #0xa03bc320
a013c314 48310ce3 movw r3, #0xc148
a013c318 fb304ae3 movt r3, #0xa0fb
a013c31c 3e20d3e5 ldrb r2, [r3, #0x3e]
a013c320 000052e3 cmp r2, #0
a013c324 0120a003 moveq r2, #1
a013c328 0020a013 movne r2, #0
a013c32c 3e20c3e5 strb r2, [r3, #0x3e]
a013c330 32caffeb bl #0xa012ec00
a013c334 0050a0e1 mov r5, r0
a013c338 0100a0e3 mov r0, #1
a013c33c a9e5ffeb bl #0xa01359e8
a013c340 0010a0e3 mov r1, #0
a013c344 6620a0e3 mov r2, #0x66
a013c348 1f00a0e3 mov r0, #0x1f
a013c34c 9bd7ffeb bl #0xa01321c0
a013c350 9cf3ffea b #0xa01391c8
a013c354 0050a0e3 mov r5, #0
a013c358 9af3ffea b #0xa01391c8
a013c35c 0b10a0e1 mov r1, fp
a013c360 012ca0e3 mov r2, #0x100
a013c364 0200a0e3 mov r0, #2
a013c368 0050a0e3 mov r5, #0
a013c36c 951603eb bl #0xa0201dc8
a013c370 0b10a0e1 mov r1, fp
a013c374 0200a0e3 mov r0, #2
a013c378 d21703eb bl #0xa02022c8
a013c37c d43404e3 movw r3, #0x44d4
a013c380 0510a0e1 mov r1, r5
a013c384 6d304ae3 movt r3, #0xa06d
a013c388 6920a0e3 mov r2, #0x69
a013c38c 000093e5 ldr r0, [r3]
a013c390 8ad7ffeb bl #0xa01321c0
a013c394 1400a0e3 mov r0, #0x14
a013c398 e0ff09eb bl #0xa03bc320
a013c39c 0510a0e1 mov r1, r5
a013c3a0 0300a0e3 mov r0, #3
a013c3a4 ec8201eb bl #0xa019cf5c
a013c3a8 0510a0e1 mov r1, r5
a013c3ac 6620a0e3 mov r2, #0x66
a013c3b0 1b00a0e3 mov r0, #0x1b
a013c3b4 81d7ffeb bl #0xa01321c0
a013c3b8 82f3ffea b #0xa01391c8
a013c3bc ec0b04e3 movw r0, #0x4bec
a013c3c0 182b0fe3 movw r2, #0xfb18
a013c3c4 53204ae3 movt r2, #0xa053
a013c3c8 3e1003e3 movw r1, #0x303e
a013c3cc 54004ae3 movt r0, #0xa054
a013c3d0 304c03e3 movw r4, #0x3c30
a013c3d4 44ab05eb bl #0xa02a70ec
a013c3d8 0b10a0e1 mov r1, fp
a013c3dc 012ca0e3 mov r2, #0x100
a013c3e0 0200a0e3 mov r0, #2
a013c3e4 fb404ae3 movt r4, #0xa0fb
a013c3e8 761603eb bl #0xa0201dc8
a013c3ec 0b10a0e1 mov r1, fp
a013c3f0 0200a0e3 mov r0, #2
a013c3f4 b31703eb bl #0xa02022c8
a013c3f8 d43404e3 movw r3, #0x44d4
a013c3fc 6920a0e3 mov r2, #0x69
a013c400 6d304ae3 movt r3, #0xa06d
a013c404 0010a0e3 mov r1, #0
a013c408 000093e5 ldr r0, [r3]
a013c40c 0050a0e3 mov r5, #0
a013c410 6ad7ffeb bl #0xa01321c0
a013c414 1400a0e3 mov r0, #0x14
a013c418 c0ff09eb bl #0xa03bc320
a013c41c 0100a0e3 mov r0, #1
a013c420 c74100eb bl #0xa014cb44
a013c424 001050e2 subs r1, r0, #0
a013c428 0010a013 movne r1, #0
a013c42c 3100a003 moveq r0, #0x31
a013c430 1300a013 movne r0, #0x13
a013c434 52d4ffeb bl #0xa0131584
a013c438 006094e5 ldr r6, [r4]
a013c43c 110200e3 movw r0, #0x211
a013c440 7dc2ffeb bl #0xa012ce3c
a013c444 683b02e3 movw r3, #0x2b68
a013c448 6410a0e3 mov r1, #0x64
a013c44c 6a304ae3 movt r3, #0xa06a
a013c450 1e20a0e3 mov r2, #0x1e
a013c454 913623e0 mla r3, r1, r6, r3
a013c458 002084e5 str r2, [r4]
a013c45c 0510a0e1 mov r1, r5
a013c460 6620a0e3 mov r2, #0x66
a013c464 480083e5 str r0, [r3, #0x48]
a013c468 1f00a0e3 mov r0, #0x1f
a013c46c 53d7ffeb bl #0xa01321c0
a013c470 54f3ffea b #0xa01391c8
a013c474 e80304e3 movw r0, #0x43e8
a013c478 182b0fe3 movw r2, #0xfb18
a013c47c 53204ae3 movt r2, #0xa053
a013c480 9c1d02e3 movw r1, #0x2d9c
a013c484 0050a0e3 mov r5, #0
a013c488 54004ae3 movt r0, #0xa054
a013c48c 16ab05eb bl #0xa02a70ec
a013c490 0510a0e1 mov r1, r5
a013c494 0100a0e3 mov r0, #1
a013c498 39d4ffeb bl #0xa0131584
a013c49c 49f3ffea b #0xa01391c8
a013c4a0 a4c9ffeb bl #0xa012eb38
a013c4a4 0410a0e1 mov r1, r4
a013c4a8 6a20a0e3 mov r2, #0x6a
a013c4ac 1d00a0e3 mov r0, #0x1d
a013c4b0 0450a0e1 mov r5, r4
a013c4b4 41d7ffeb bl #0xa01321c0
a013c4b8 42f3ffea b #0xa01391c8
a013c4bc 540304e3 movw r0, #0x4354
a013c4c0 182b0fe3 movw r2, #0xfb18
a013c4c4 53204ae3 movt r2, #0xa053
a013c4c8 851d02e3 movw r1, #0x2d85
a013c4cc 54004ae3 movt r0, #0xa054
a013c4d0 05ab05eb bl #0xa02a70ec
a013c4d4 3bf3ffea b #0xa01391c8
a013c4d8 540304e3 movw r0, #0x4354
a013c4dc 182b0fe3 movw r2, #0xfb18
a013c4e0 53204ae3 movt r2, #0xa053
a013c4e4 971d02e3 movw r1, #0x2d97
a013c4e8 54004ae3 movt r0, #0xa054
a013c4ec feaa05eb bl #0xa02a70ec
a013c4f0 34f3ffea b #0xa01391c8
a013c4f4 010052e3 cmp r2, #1
a013c4f8 3bf8ff1a bne #0xa013a5ec
a013c4fc 01a04ae2 sub sl, sl, #1
a013c500 0a005be1 cmp fp, sl
a013c504 38f8ffba blt #0xa013a5ec
a013c508 35f8ffea b #0xa013a5e4
a013c50c 6920a0e3 mov r2, #0x69
a013c510 1e00a0e3 mov r0, #0x1e
a013c514 48610ce3 movw r6, #0xc148
a013c518 e04901e3 movw r4, #0x19e0
a013c51c 27d7ffeb bl #0xa01321c0
a013c520 fb604ae3 movt r6, #0xa0fb
a013c524 1400a0e3 mov r0, #0x14
a013c528 7cff09eb bl #0xa03bc320
a013c52c 33e0d6e5 ldrb lr, [r6, #0x33]
a013c530 630ea0e3 mov r0, #0x630
a013c534 1cc0d6e5 ldrb ip, [r6, #0x1c]
a013c538 8410a0e3 mov r1, #0x84
a013c53c 0020a0e3 mov r2, #0
a013c540 6a404ae3 movt r4, #0xa06a
a013c544 0230a0e1 mov r3, r2
a013c548 900e00e0 mul r0, r0, lr
a013c54c 810c00e1 smlabb r0, r1, ip, r0
a013c550 000084e0 add r0, r4, r0
a013c554 027090e7 ldr r7, [r0, r2]
a013c558 0c2082e2 add r2, r2, #0xc
a013c55c 000057e3 cmp r7, #0
a013c560 a100000a beq #0xa013c7ec
a013c564 013083e2 add r3, r3, #1
a013c568 0b0053e3 cmp r3, #0xb
a013c56c f8ffff1a bne #0xa013c554
a013c570 3210a0e3 mov r1, #0x32
a013c574 6620a0e3 mov r2, #0x66
a013c578 1e00a0e3 mov r0, #0x1e
a013c57c 0050a0e3 mov r5, #0
a013c580 0ed7ffeb bl #0xa01321c0
a013c584 0ff3ffea b #0xa01391c8
a013c588 48610ce3 movw r6, #0xc148
a013c58c 631ea0e3 mov r1, #0x630
a013c590 fb604ae3 movt r6, #0xa0fb
a013c594 8420a0e3 mov r2, #0x84
a013c598 1c30d6e5 ldrb r3, [r6, #0x1c]
a013c59c e04901e3 movw r4, #0x19e0
a013c5a0 6a404ae3 movt r4, #0xa06a
a013c5a4 00e0a0e3 mov lr, #0
a013c5a8 0e00a0e1 mov r0, lr
a013c5ac 0390cce7 strb sb, [ip, r3]
a013c5b0 3330d6e5 ldrb r3, [r6, #0x33]
a013c5b4 1cc0d6e5 ldrb ip, [r6, #0x1c]
a013c5b8 910303e0 mul r3, r1, r3
a013c5bc 823c03e1 smlabb r3, r2, ip, r3
a013c5c0 033084e0 add r3, r4, r3
a013c5c4 0e2093e7 ldr r2, [r3, lr]
a013c5c8 0ce08ee2 add lr, lr, #0xc
a013c5cc 000052e3 cmp r2, #0
a013c5d0 0200000a beq #0xa013c5e0
a013c5d4 010080e2 add r0, r0, #1
a013c5d8 0b0050e3 cmp r0, #0xb
a013c5dc f8ffff1a bne #0xa013c5c4
a013c5e0 090050e1 cmp r0, sb
a013c5e4 910000da ble #0xa013c830
a013c5e8 3210a0e3 mov r1, #0x32
a013c5ec 6920a0e3 mov r2, #0x69
a013c5f0 1e00a0e3 mov r0, #0x1e
a013c5f4 0050a0e3 mov r5, #0
a013c5f8 f0d6ffeb bl #0xa01321c0
a013c5fc 1400a0e3 mov r0, #0x14
a013c600 46ff09eb bl #0xa03bc320
a013c604 1c30d6e5 ldrb r3, [r6, #0x1c]
a013c608 8400a0e3 mov r0, #0x84
a013c60c 0c10a0e3 mov r1, #0xc
a013c610 3320d6e5 ldrb r2, [r6, #0x33]
a013c614 63eea0e3 mov lr, #0x630
a013c618 03c086e0 add ip, r6, r3
a013c61c 900303e0 mul r3, r0, r3
a013c620 913923e0 mla r3, r1, sb, r3
a013c624 9e3223e0 mla r3, lr, r2, r3
a013c628 034084e0 add r4, r4, r3
a013c62c 083094e5 ldr r3, [r4, #8]
a013c630 1f30cce5 strb r3, [ip, #0x1f]
a013c634 2bc9ffeb bl #0xa012eae8
a013c638 0510a0e1 mov r1, r5
a013c63c 6620a0e3 mov r2, #0x66
a013c640 1d00a0e3 mov r0, #0x1d
a013c644 ddd6ffeb bl #0xa01321c0
a013c648 1c10d6e5 ldrb r1, [r6, #0x1c]
a013c64c 200904e3 movw r0, #0x4920
a013c650 742606e3 movw r2, #0x6674
a013c654 0930a0e1 mov r3, sb
a013c658 54204ae3 movt r2, #0xa054
a013c65c 54004ae3 movt r0, #0xa054
a013c660 016086e0 add r6, r6, r1
a013c664 00108de5 str r1, [sp]
a013c668 1fc0d6e5 ldrb ip, [r6, #0x1f]
a013c66c 271801e3 movw r1, #0x1827
a013c670 04c08de5 str ip, [sp, #4]
a013c674 9caa05eb bl #0xa02a70ec
a013c678 d2f2ffea b #0xa01391c8
a013c67c 0510a0e1 mov r1, r5
a013c680 ca00a0e3 mov r0, #0xca
a013c684 c7dfffeb bl #0xa01345a8
a013c688 1a0300e3 movw r0, #0x31a
a013c68c 0510a0e1 mov r1, r5
a013c690 0520a0e1 mov r2, r5
a013c694 01004fe3 movt r0, #0xf001
a013c698 bea702eb bl #0xa01e6598
a013c69c c9f2ffea b #0xa01391c8
a013c6a0 aae2d3e5 ldrb lr, [r3, #0x2aa]
a013c6a4 00005ee3 cmp lr, #0
a013c6a8 10fdff1a bne #0xa013baf0
a013c6ac 7c2003e3 movw r2, #0x307c
a013c6b0 000604e3 movw r0, #0x4600
a013c6b4 6f204ae3 movt r2, #0xa06f
a013c6b8 183b0fe3 movw r3, #0xfb18
a013c6bc 041092e5 ldr r1, [r2, #4]
a013c6c0 53304ae3 movt r3, #0xa053
a013c6c4 fe2d02e3 movw r2, #0x2dfe
a013c6c8 54004ae3 movt r0, #0xa054
a013c6cc 0e50a0e1 mov r5, lr
a013c6d0 85aa05eb bl #0xa02a70ec
a013c6d4 bbf2ffea b #0xa01391c8
a013c6d8 48610ce3 movw r6, #0xc148
a013c6dc 4810a0e3 mov r1, #0x48
a013c6e0 fb604ae3 movt r6, #0xa0fb
a013c6e4 2400a0e3 mov r0, #0x24
a013c6e8 0b30d6e5 ldrb r3, [r6, #0xb]
a013c6ec a44501e3 movw r4, #0x15a4
a013c6f0 6a404ae3 movt r4, #0xa06a
a013c6f4 0390cce7 strb sb, [ip, r3]
a013c6f8 3330d6e5 ldrb r3, [r6, #0x33]
a013c6fc 0b20d6e5 ldrb r2, [r6, #0xb]
a013c700 910303e0 mul r3, r1, r3
a013c704 903223e0 mla r3, r0, r2, r3
a013c708 032094e7 ldr r2, [r4, r3]
a013c70c 033084e0 add r3, r4, r3
a013c710 000052e3 cmp r2, #0
a013c714 ec00000a beq #0xa013cacc
a013c718 0c2093e5 ldr r2, [r3, #0xc]
a013c71c 000052e3 cmp r2, #0
a013c720 e700000a beq #0xa013cac4
a013c724 183093e5 ldr r3, [r3, #0x18]
a013c728 000053e3 cmp r3, #0
a013c72c 0230a003 moveq r3, #2
a013c730 0330a013 movne r3, #3
a013c734 030059e1 cmp sb, r3
a013c738 490000aa bge #0xa013c864
a013c73c 4c10a0e3 mov r1, #0x4c
a013c740 6920a0e3 mov r2, #0x69
a013c744 1e00a0e3 mov r0, #0x1e
a013c748 0050a0e3 mov r5, #0
a013c74c 9bd6ffeb bl #0xa01321c0
a013c750 1400a0e3 mov r0, #0x14
a013c754 f1fe09eb bl #0xa03bc320
a013c758 0b30d6e5 ldrb r3, [r6, #0xb]
a013c75c 2400a0e3 mov r0, #0x24
a013c760 0c10a0e3 mov r1, #0xc
a013c764 3320d6e5 ldrb r2, [r6, #0x33]
a013c768 48e0a0e3 mov lr, #0x48
a013c76c 03c086e0 add ip, r6, r3
a013c770 900303e0 mul r3, r0, r3
a013c774 913923e0 mla r3, r1, sb, r3
a013c778 9e3223e0 mla r3, lr, r2, r3
a013c77c 034084e0 add r4, r4, r3
a013c780 083094e5 ldr r3, [r4, #8]
a013c784 0c30cce5 strb r3, [ip, #0xc]
a013c788 eac8ffeb bl #0xa012eb38
a013c78c 0510a0e1 mov r1, r5
a013c790 6620a0e3 mov r2, #0x66
a013c794 1d00a0e3 mov r0, #0x1d
a013c798 88d6ffeb bl #0xa01321c0
a013c79c 0b10d6e5 ldrb r1, [r6, #0xb]
a013c7a0 7c0904e3 movw r0, #0x497c
a013c7a4 742606e3 movw r2, #0x6674
a013c7a8 0930a0e1 mov r3, sb
a013c7ac 54204ae3 movt r2, #0xa054
a013c7b0 54004ae3 movt r0, #0xa054
a013c7b4 016086e0 add r6, r6, r1
a013c7b8 00108de5 str r1, [sp]
a013c7bc 0cc0d6e5 ldrb ip, [r6, #0xc]
a013c7c0 491801e3 movw r1, #0x1849
a013c7c4 04c08de5 str ip, [sp, #4]
a013c7c8 47aa05eb bl #0xa02a70ec
a013c7cc 7df2ffea b #0xa01391c8
a013c7d0 6c3094e5 ldr r3, [r4, #0x6c]
a013c7d4 000053e3 cmp r3, #0
a013c7d8 79f2ffca bgt #0xa01391c4
a013c7dc 61f6ffea b #0xa013a168
a013c7e0 efd3ffeb bl #0xa01317a4
a013c7e4 0050a0e3 mov r5, #0
a013c7e8 76f2ffea b #0xa01391c8
a013c7ec 010053e3 cmp r3, #1
a013c7f0 5effffca bgt #0xa013c570
a013c7f4 632ea0e3 mov r2, #0x630
a013c7f8 8430a0e3 mov r3, #0x84
a013c7fc 920e02e0 mul r2, r2, lr
a013c800 0c6086e0 add r6, r6, ip
a013c804 0750a0e1 mov r5, r7
a013c808 932c23e0 mla r3, r3, ip, r2
a013c80c 034084e0 add r4, r4, r3
a013c810 083094e5 ldr r3, [r4, #8]
a013c814 1f30c6e5 strb r3, [r6, #0x1f]
a013c818 b2c8ffeb bl #0xa012eae8
a013c81c 0710a0e1 mov r1, r7
a013c820 6620a0e3 mov r2, #0x66
a013c824 1d00a0e3 mov r0, #0x1d
a013c828 64d6ffeb bl #0xa01321c0
a013c82c 65f2ffea b #0xa01391c8
a013c830 540904e3 movw r0, #0x4954
a013c834 742606e3 movw r2, #0x6674
a013c838 54204ae3 movt r2, #0xa054
a013c83c 291801e3 movw r1, #0x1829
a013c840 54004ae3 movt r0, #0xa054
a013c844 0050a0e3 mov r5, #0
a013c848 27aa05eb bl #0xa02a70ec
a013c84c 5df2ffea b #0xa01391c8
a013c850 01a04ae2 sub sl, sl, #1
a013c854 0a005be1 cmp fp, sl
a013c858 035085a0 addge r5, r5, r3
a013c85c 086095a5 ldrge r6, [r5, #8]
a013c860 61f7ffea b #0xa013a5ec
a013c864 540904e3 movw r0, #0x4954
a013c868 742606e3 movw r2, #0x6674
a013c86c 54204ae3 movt r2, #0xa054
a013c870 4b1801e3 movw r1, #0x184b
a013c874 54004ae3 movt r0, #0xa054
a013c878 0050a0e3 mov r5, #0
a013c87c 1aaa05eb bl #0xa02a70ec
a013c880 50f2ffea b #0xa01391c8
a013c884 48610ce3 movw r6, #0xc148
a013c888 a44501e3 movw r4, #0x15a4
a013c88c 4bd6ffeb bl #0xa01321c0
a013c890 fb604ae3 movt r6, #0xa0fb
a013c894 1400a0e3 mov r0, #0x14
a013c898 a0fe09eb bl #0xa03bc320
a013c89c 33c0d6e5 ldrb ip, [r6, #0x33]
a013c8a0 4810a0e3 mov r1, #0x48
a013c8a4 0b00d6e5 ldrb r0, [r6, #0xb]
a013c8a8 2430a0e3 mov r3, #0x24
a013c8ac 6a404ae3 movt r4, #0xa06a
a013c8b0 910c01e0 mul r1, r1, ip
a013c8b4 931023e0 mla r3, r3, r0, r1
a013c8b8 032094e7 ldr r2, [r4, r3]
a013c8bc 033084e0 add r3, r4, r3
a013c8c0 000052e3 cmp r2, #0
a013c8c4 6f00000a beq #0xa013ca88
a013c8c8 0c3093e5 ldr r3, [r3, #0xc]
a013c8cc 000053e3 cmp r3, #0
a013c8d0 6c00000a beq #0xa013ca88
a013c8d4 4c10a0e3 mov r1, #0x4c
a013c8d8 6620a0e3 mov r2, #0x66
a013c8dc 1e00a0e3 mov r0, #0x1e
a013c8e0 0850a0e1 mov r5, r8
a013c8e4 35d6ffeb bl #0xa01321c0
a013c8e8 36f2ffea b #0xa01391c8
a013c8ec 7c2003e3 movw r2, #0x307c
a013c8f0 300204e3 movw r0, #0x4230
a013c8f4 6f204ae3 movt r2, #0xa06f
a013c8f8 e43e05e3 movw r3, #0x5ee4
a013c8fc 081092e5 ldr r1, [r2, #8]
a013c900 54304ae3 movt r3, #0xa054
a013c904 432902e3 movw r2, #0x2943
a013c908 54004ae3 movt r0, #0xa054
a013c90c f6a905eb bl #0xa02a70ec
a013c910 0510a0e1 mov r1, r5
a013c914 1300a0e3 mov r0, #0x13
a013c918 19d3ffeb bl #0xa0131584
a013c91c a3f8ffea b #0xa013abb0
a013c920 7c2003e3 movw r2, #0x307c
a013c924 e80903e3 movw r0, #0x39e8
a013c928 6f204ae3 movt r2, #0xa06f
a013c92c 743606e3 movw r3, #0x6674
a013c930 041092e5 ldr r1, [r2, #4]
a013c934 54304ae3 movt r3, #0xa054
a013c938 e42701e3 movw r2, #0x17e4
a013c93c 54004ae3 movt r0, #0xa054
a013c940 0c50a0e1 mov r5, ip
a013c944 e8a905eb bl #0xa02a70ec
a013c948 1ef2ffea b #0xa01391c8
a013c94c 0010a0e3 mov r1, #0
a013c950 1300a0e3 mov r0, #0x13
a013c954 0ad3ffeb bl #0xa0131584
a013c958 580702e3 movw r0, #0x2758
a013c95c 182b0fe3 movw r2, #0xfb18
a013c960 53204ae3 movt r2, #0xa053
a013c964 571d02e3 movw r1, #0x2d57
a013c968 54004ae3 movt r0, #0xa054
a013c96c 0050e0e3 mvn r5, #0
a013c970 dda905eb bl #0xa02a70ec
a013c974 13f2ffea b #0xa01391c8
a013c978 7c2003e3 movw r2, #0x307c
a013c97c c00503e3 movw r0, #0x35c0
a013c980 6f204ae3 movt r2, #0xa06f
a013c984 e43e05e3 movw r3, #0x5ee4
a013c988 081092e5 ldr r1, [r2, #8]
a013c98c 54304ae3 movt r3, #0xa054
a013c990 3d2902e3 movw r2, #0x293d
a013c994 54004ae3 movt r0, #0xa054
a013c998 d3a905eb bl #0xa02a70ec
a013c99c 83f8ffea b #0xa013abb0
a013c9a0 7c2003e3 movw r2, #0x307c
a013c9a4 d00402e3 movw r0, #0x24d0
a013c9a8 6f204ae3 movt r2, #0xa06f
a013c9ac e43e05e3 movw r3, #0x5ee4
a013c9b0 081092e5 ldr r1, [r2, #8]
a013c9b4 54304ae3 movt r3, #0xa054
a013c9b8 392902e3 movw r2, #0x2939
a013c9bc 54004ae3 movt r0, #0xa054
a013c9c0 c9a905eb bl #0xa02a70ec
a013c9c4 79f8ffea b #0xa013abb0
a013c9c8 0010a0e3 mov r1, #0
a013c9cc 1300a0e3 mov r0, #0x13
a013c9d0 ebd2ffeb bl #0xa0131584
a013c9d4 580702e3 movw r0, #0x2758
a013c9d8 182b0fe3 movw r2, #0xfb18
a013c9dc 53204ae3 movt r2, #0xa053
a013c9e0 671d02e3 movw r1, #0x2d67
a013c9e4 54004ae3 movt r0, #0xa054
a013c9e8 0050e0e3 mvn r5, #0
a013c9ec bea905eb bl #0xa02a70ec
a013c9f0 f4f1ffea b #0xa01391c8
a013c9f4 0010a0e3 mov r1, #0
a013c9f8 1300a0e3 mov r0, #0x13
a013c9fc e0d2ffeb bl #0xa0131584
a013ca00 580702e3 movw r0, #0x2758
a013ca04 182b0fe3 movw r2, #0xfb18
a013ca08 53204ae3 movt r2, #0xa053
a013ca0c 881d02e3 movw r1, #0x2d88
a013ca10 54004ae3 movt r0, #0xa054
a013ca14 0050e0e3 mvn r5, #0
a013ca18 b3a905eb bl #0xa02a70ec
a013ca1c e9f1ffea b #0xa01391c8
a013ca20 0050a0e3 mov r5, #0
a013ca24 e7f1ffea b #0xa01391c8
a013ca28 0010a0e3 mov r1, #0
a013ca2c 1300a0e3 mov r0, #0x13
a013ca30 d3d2ffeb bl #0xa0131584
a013ca34 580702e3 movw r0, #0x2758
a013ca38 182b0fe3 movw r2, #0xfb18
a013ca3c 53204ae3 movt r2, #0xa053
a013ca40 951d02e3 movw r1, #0x2d95
a013ca44 54004ae3 movt r0, #0xa054
a013ca48 0050e0e3 mvn r5, #0
a013ca4c a6a905eb bl #0xa02a70ec
a013ca50 dcf1ffea b #0xa01391c8
a013ca54 0010a0e3 mov r1, #0
a013ca58 1300a0e3 mov r0, #0x13
a013ca5c c8d2ffeb bl #0xa0131584
a013ca60 580702e3 movw r0, #0x2758
a013ca64 182b0fe3 movw r2, #0xfb18
a013ca68 53204ae3 movt r2, #0xa053
a013ca6c b61da0e3 mov r1, #0x2d80
a013ca70 54004ae3 movt r0, #0xa054
a013ca74 0050e0e3 mvn r5, #0
a013ca78 9ba905eb bl #0xa02a70ec
a013ca7c d1f1ffea b #0xa01391c8
a013ca80 0050a0e3 mov r5, #0
a013ca84 cff1ffea b #0xa01391c8
a013ca88 4820a0e3 mov r2, #0x48
a013ca8c 2430a0e3 mov r3, #0x24
a013ca90 920c02e0 mul r2, r2, ip
a013ca94 006086e0 add r6, r6, r0
a013ca98 0050a0e3 mov r5, #0
a013ca9c 932023e0 mla r3, r3, r0, r2
a013caa0 034084e0 add r4, r4, r3
a013caa4 083094e5 ldr r3, [r4, #8]
a013caa8 0c30c6e5 strb r3, [r6, #0xc]
a013caac 21c8ffeb bl #0xa012eb38
a013cab0 0510a0e1 mov r1, r5
a013cab4 6620a0e3 mov r2, #0x66
a013cab8 1d00a0e3 mov r0, #0x1d
a013cabc bfd5ffeb bl #0xa01321c0
a013cac0 c0f1ffea b #0xa01391c8
a013cac4 0130a0e3 mov r3, #1
a013cac8 19ffffea b #0xa013c734
a013cacc 0230a0e1 mov r3, r2
a013cad0 17ffffea b #0xa013c734
a013cad4 0050a0e3 mov r5, #0
a013cad8 baf1ffea b #0xa01391c8
a013cadc 0050a0e3 mov r5, #0
a013cae0 b8f1ffea b #0xa01391c8

FUNCTION 0xa011f084
a011f084 4c3303e3 movw r3, #0x334c
a011f088 fb304ae3 movt r3, #0xa0fb
a011f08c 0000d3e5 ldrb r0, [r3]
a011f090 010050e3 cmp r0, #1
a011f094 1eff2f01 bxeq lr
a011f098 b0330be3 movw r3, #0xb3b0
a011f09c 69304ae3 movt r3, #0xa069
a011f0a0 180093e5 ldr r0, [r3, #0x18]
a011f0a4 020c10e2 ands r0, r0, #0x200
a011f0a8 1eff2f01 bxeq lr
a011f0ac d83c05e3 movw r3, #0x5cd8
a011f0b0 05314ae3 movt r3, #0xa105
a011f0b4 2200d3e5 ldrb r0, [r3, #0x22]
a011f0b8 030050e3 cmp r0, #3
a011f0bc 0000a093 movls r0, #0
a011f0c0 0100a083 movhi r0, #1
a011f0c4 1eff2fe1 bx lr

FUNCTION 0xa011f0c8
a011f0c8 4c3303e3 movw r3, #0x334c
a011f0cc fb304ae3 movt r3, #0xa0fb
a011f0d0 0030d3e5 ldrb r3, [r3]
a011f0d4 040053e3 cmp r3, #4
a011f0d8 0f00000a beq #0xa011f11c
a011f0dc 000053e3 cmp r3, #0
a011f0e0 0600000a beq #0xa011f100
a011f0e4 050053e3 cmp r3, #5
a011f0e8 0d00001a bne #0xa011f124
a011f0ec b0330be3 movw r3, #0xb3b0
a011f0f0 69304ae3 movt r3, #0xa069
a011f0f4 180093e5 ldr r0, [r3, #0x18]
a011f0f8 d000e0e7 ubfx r0, r0, #1, #1
a011f0fc 1eff2fe1 bx lr
a011f100 b0330be3 movw r3, #0xb3b0
a011f104 69304ae3 movt r3, #0xa069
a011f108 183093e5 ldr r3, [r3, #0x18]
a011f10c 220013e3 tst r3, #0x22
a011f110 0100a013 movne r0, #1
a011f114 0000a003 moveq r0, #0
a011f118 1eff2fe1 bx lr
a011f11c 0100a0e3 mov r0, #1
a011f120 1eff2fe1 bx lr
a011f124 0000a0e3 mov r0, #0
a011f128 1eff2fe1 bx lr

FUNCTION 0xa019317c
a019317c 070302e3 movw r0, #0x2307
a0193180 1eff2fe1 bx lr

FUNCTION 0xa01184c8
a01184c8 10402de9 push {r4, lr}
a01184cc 0030a0e3 mov r3, #0
a01184d0 38d04de2 sub sp, sp, #0x38
a01184d4 cdcfa0e3 mov ip, #0x334
a01184d8 08240fe3 movw r2, #0xf408
a01184dc 01c04fe3 movt ip, #0xf001
a01184e0 11204ae3 movt r2, #0xa011
a01184e4 024ca0e3 mov r4, #0x200
a01184e8 98ea03e3 movw lr, #0x3a98
a01184ec 0310a0e1 mov r1, r3
a01184f0 0c008de2 add r0, sp, #0xc
a01184f4 28408de5 str r4, [sp, #0x28]
a01184f8 0cc08de5 str ip, [sp, #0xc]
a01184fc 18c08de5 str ip, [sp, #0x18]
a0118500 20208de5 str r2, [sp, #0x20]
a0118504 10308de5 str r3, [sp, #0x10]
a0118508 14308de5 str r3, [sp, #0x14]
a011850c 1c308de5 str r3, [sp, #0x1c]
a0118510 24308de5 str r3, [sp, #0x24]
a0118514 2c308de5 str r3, [sp, #0x2c]
a0118518 34308de5 str r3, [sp, #0x34]
a011851c 30e08de5 str lr, [sp, #0x30]
a0118520 5c3603eb bl #0xa01e5e98
a0118524 7040efe6 uxtb r4, r0
a0118528 000054e3 cmp r4, #0
a011852c 0900000a beq #0xa0118558
a0118530 7c2003e3 movw r2, #0x307c
a0118534 c80c05e3 movw r0, #0x5cc8
a0118538 6f204ae3 movt r2, #0xa06f
a011853c ec3505e3 movw r3, #0x55ec
a0118540 081092e5 ldr r1, [r2, #8]
a0118544 53004ae3 movt r0, #0xa053
a0118548 00408de5 str r4, [sp]
a011854c 53304ae3 movt r3, #0xa053
a0118550 632702e3 movw r2, #0x2763
a0118554 e43a06eb bl #0xa02a70ec
a0118558 0400a0e1 mov r0, r4
a011855c 38d08de2 add sp, sp, #0x38
a0118560 1080bde8 pop {r4, pc}

FUNCTION 0xa0118564
a0118564 30402de9 push {r4, r5, lr}
a0118568 0030a0e3 mov r3, #0
a011856c 3cd04de2 sub sp, sp, #0x3c
a0118570 35e300e3 movw lr, #0x335
a0118574 cdcfa0e3 mov ip, #0x334
a0118578 08240fe3 movw r2, #0xf408
a011857c 01e04fe3 movt lr, #0xf001
a0118580 01c04fe3 movt ip, #0xf001
a0118584 11204ae3 movt r2, #0xa011
a0118588 984a03e3 movw r4, #0x3a98
a011858c 0310a0e1 mov r1, r3
a0118590 025ca0e3 mov r5, #0x200
a0118594 0c008de2 add r0, sp, #0xc
a0118598 30408de5 str r4, [sp, #0x30]
a011859c 0ce08de5 str lr, [sp, #0xc]
a01185a0 18c08de5 str ip, [sp, #0x18]
a01185a4 20208de5 str r2, [sp, #0x20]
a01185a8 10308de5 str r3, [sp, #0x10]
a01185ac 14308de5 str r3, [sp, #0x14]
a01185b0 1c308de5 str r3, [sp, #0x1c]
a01185b4 24308de5 str r3, [sp, #0x24]
a01185b8 2c308de5 str r3, [sp, #0x2c]
a01185bc 34308de5 str r3, [sp, #0x34]
a01185c0 28508de5 str r5, [sp, #0x28]
a01185c4 333603eb bl #0xa01e5e98
a01185c8 7040efe6 uxtb r4, r0
a01185cc 000054e3 cmp r4, #0
a01185d0 0900000a beq #0xa01185fc
a01185d4 7c2003e3 movw r2, #0x307c
a01185d8 c80c05e3 movw r0, #0x5cc8
a01185dc 6f204ae3 movt r2, #0xa06f
a01185e0 3c340ee3 movw r3, #0xe43c
a01185e4 081092e5 ldr r1, [r2, #8]
a01185e8 53004ae3 movt r0, #0xa053
a01185ec 00408de5 str r4, [sp]
a01185f0 53304ae3 movt r3, #0xa053
a01185f4 782702e3 movw r2, #0x2778
a01185f8 bb3a06eb bl #0xa02a70ec
a01185fc 0400a0e1 mov r0, r4
a0118600 3cd08de2 add sp, sp, #0x3c
a0118604 3080bde8 pop {r4, r5, pc}

FUNCTION 0xa01282e0
a01282e0 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a01282e4 0150a0e1 mov r5, r1
a01282e8 54d04de2 sub sp, sp, #0x54
a01282ec 0260a0e1 mov r6, r2
a01282f0 960050e3 cmp r0, #0x96
a01282f4 00f19f97 ldrls pc, [pc, r0, lsl #2]
a01282f8 650700ea b #0xa012a094
a0128558 9cc1ffeb bl #0xa0118bd0
a012855c 0040a0e1 mov r4, r0
a0128560 0400a0e1 mov r0, r4
a0128564 54d08de2 add sp, sp, #0x54
a0128568 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a012856c 0040a0e3 mov r4, #0
a0128570 1c208de2 add r2, sp, #0x1c
a0128574 0410a0e1 mov r1, r4
a0128578 0430a0e1 mov r3, r4
a012857c 010a00e3 movw r0, #0xa01
a0128580 20408de5 str r4, [sp, #0x20]
a0128584 1c408de5 str r4, [sp, #0x1c]
a0128588 b641cde1 strh r4, [sp, #0x16]
a012858c 1940cde5 strb r4, [sp, #0x19]
a0128590 1a40cde5 strb r4, [sp, #0x1a]
a0128594 1b40cde5 strb r4, [sp, #0x1b]
a0128598 1840cde5 strb r4, [sp, #0x18]
a012859c cf210aeb bl #0xa03b0ce0
a01285a0 19308de2 add r3, sp, #0x19
a01285a4 0410a0e1 mov r1, r4
a01285a8 16208de2 add r2, sp, #0x16
a01285ac 110a00e3 movw r0, #0xa11
a01285b0 ca210aeb bl #0xa03b0ce0
a01285b4 1a30dde5 ldrb r3, [sp, #0x1a]
a01285b8 020053e3 cmp r3, #2
a01285bc 0c00000a beq #0xa01285f4
a01285c0 16208de2 add r2, sp, #0x16
a01285c4 19308de2 add r3, sp, #0x19
a01285c8 0410a0e1 mov r1, r4
a01285cc 110a00e3 movw r0, #0xa11
a01285d0 c2210aeb bl #0xa03b0ce0
a01285d4 02c0a0e3 mov ip, #2
a01285d8 0410a0e1 mov r1, r4
a01285dc 0c20a0e1 mov r2, ip
a01285e0 0c30a0e1 mov r3, ip
a01285e4 130a00e3 movw r0, #0xa13
a01285e8 17c0cde5 strb ip, [sp, #0x17]
a01285ec 1ac0cde5 strb ip, [sp, #0x1a]
a01285f0 ba210aeb bl #0xa03b0ce0
a01285f4 0040a0e3 mov r4, #0
a01285f8 d8ffffea b #0xa0128560
a01285fc 4c3303e3 movw r3, #0x334c
a0128600 0110a0e3 mov r1, #1
a0128604 fb304ae3 movt r3, #0xa0fb
a0128608 0020a0e3 mov r2, #0
a012860c 183093e5 ldr r3, [r3, #0x18]
a0128610 8100a0e3 mov r0, #0x81
a0128614 33ff2fe1 blx r3
a0128618 0000a0e3 mov r0, #0
a012861c 0040a0e1 mov r4, r0
a0128620 3aae03eb bl #0xa0213f10
a0128624 cdffffea b #0xa0128560
a0128628 0100a0e1 mov r0, r1
a012862c adccffeb bl #0xa011b8e8
a0128630 0040a0e1 mov r4, r0
a0128634 c9ffffea b #0xa0128560
a0128638 0100a0e1 mov r0, r1
a012863c 0210a0e1 mov r1, r2
a0128640 87f3ffeb bl #0xa0125464
a0128644 0040a0e1 mov r4, r0
a0128648 c4ffffea b #0xa0128560
a012864c 7100ffe6 uxth r0, r1
a0128650 5ca701eb bl #0xa01923c8
a0128654 54dc03eb bl #0xa021f7ac
a0128658 8ac7ffeb bl #0xa011a488
a012865c 0040a0e1 mov r4, r0
a0128660 beffffea b #0xa0128560
a0128664 0100a0e1 mov r0, r1
a0128668 0040a0e3 mov r4, #0
a012866c 998102eb bl #0xa01c8cd8
a0128670 0400a0e1 mov r0, r4
a0128674 967d02eb bl #0xa01c7cd4
a0128678 b8ffffea b #0xa0128560
a012867c 0100a0e1 mov r0, r1
a0128680 0210a0e1 mov r1, r2
a0128684 5bf4ffeb bl #0xa01257f8
a0128688 0040a0e1 mov r4, r0
a012868c b3ffffea b #0xa0128560
a0128690 0100a0e1 mov r0, r1
a0128694 e6d0ffeb bl #0xa011ca34
a0128698 0040a0e1 mov r4, r0
a012869c afffffea b #0xa0128560
a01286a0 0100a0e1 mov r0, r1
a01286a4 0210a0e1 mov r1, r2
a01286a8 30ccffeb bl #0xa011b770
a01286ac 0040a0e1 mov r4, r0
a01286b0 aaffffea b #0xa0128560
a01286b4 4c7303e3 movw r7, #0x334c
a01286b8 fb704ae3 movt r7, #0xa0fb
a01286bc 043097e5 ldr r3, [r7, #4]
a01286c0 000053e3 cmp r3, #0
a01286c4 e306001a bne #0xa012a258
a01286c8 b0630be3 movw r6, #0xb3b0
a01286cc 69604ae3 movt r6, #0xa069
a01286d0 183096e5 ldr r3, [r6, #0x18]
a01286d4 040013e3 tst r3, #4
a01286d8 de06001a bne #0xa012a258
a01286dc 242097e5 ldr r2, [r7, #0x24]
a01286e0 143096e5 ldr r3, [r6, #0x14]
a01286e4 080012e3 tst r2, #8
a01286e8 2030c3e3 bic r3, r3, #0x20
a01286ec 143086e5 str r3, [r6, #0x14]
a01286f0 1c3096e5 ldr r3, [r6, #0x1c]
a01286f4 0100000a beq #0xa0128700
a01286f8 200013e3 tst r3, #0x20
a01286fc f809000a beq #0xa012aee4
a0128700 400013e3 tst r3, #0x40
a0128704 6709001a bne #0xa012aca8
a0128708 0040a0e3 mov r4, #0
a012870c 0030d7e5 ldrb r3, [r7]
a0128710 000053e3 cmp r3, #0
a0128714 0b00001a bne #0xa0128748
a0128718 183096e5 ldr r3, [r6, #0x18]
a012871c b0530be3 movw r5, #0xb3b0
a0128720 69504ae3 movt r5, #0xa069
a0128724 220013e3 tst r3, #0x22
a0128728 0600001a bne #0xa0128748
a012872c 1c2095e5 ldr r2, [r5, #0x1c]
a0128730 200012e3 tst r2, #0x20
a0128734 0300001a bne #0xa0128748
a0128738 000053e3 cmp r3, #0
a012873c 010000ba blt #0xa0128748
a0128740 020a13e2 ands r0, r3, #0x2000
a0128744 870a000a beq #0xa012b168
a0128748 0040a0e3 mov r4, #0
a012874c 83ffffea b #0xa0128560
a0128750 0100a0e1 mov r0, r1
a0128754 7fcbffeb bl #0xa011b558
a0128758 0040a0e1 mov r4, r0
a012875c 7fffffea b #0xa0128560
a0128760 10faffeb bl #0xa0126fa8
a0128764 0040a0e1 mov r4, r0
a0128768 7cffffea b #0xa0128560
a012876c 4c3303e3 movw r3, #0x334c
a0128770 0100a0e1 mov r0, r1
a0128774 fb304ae3 movt r3, #0xa0fb
a0128778 184093e5 ldr r4, [r3, #0x18]
a012877c 59c601eb bl #0xa019a0e8
a0128780 0020a0e3 mov r2, #0
a0128784 0010a0e1 mov r1, r0
a0128788 2a00a0e3 mov r0, #0x2a
a012878c 34ff2fe1 blx r4
a0128790 0040a0e1 mov r4, r0
a0128794 71ffffea b #0xa0128560
a0128798 7100efe6 uxtb r0, r1
a012879c b2c0ffeb bl #0xa0118a6c
a01287a0 0040a0e1 mov r4, r0
a01287a4 6dffffea b #0xa0128560
a01287a8 7100ffe6 uxth r0, r1
a01287ac e7caffeb bl #0xa011b350
a01287b0 0040a0e1 mov r4, r0
a01287b4 69ffffea b #0xa0128560
a01287b8 7100efe6 uxtb r0, r1
a01287bc 31c0ffeb bl #0xa0118888
a01287c0 0040a0e1 mov r4, r0
a01287c4 65ffffea b #0xa0128560
a01287c8 7100ffe6 uxth r0, r1
a01287cc 7210ffe6 uxth r1, r2
a01287d0 1ebbffeb bl #0xa0117450
a01287d4 0040a0e1 mov r4, r0
a01287d8 60ffffea b #0xa0128560
a01287dc 7100ffe6 uxth r0, r1
a01287e0 4ccaffeb bl #0xa011b118
a01287e4 0040a0e1 mov r4, r0
a01287e8 5cffffea b #0xa0128560
a01287ec 7100ffe6 uxth r0, r1
a01287f0 c3c0ffeb bl #0xa0118b04
a01287f4 0040a0e1 mov r4, r0
a01287f8 58ffffea b #0xa0128560
a01287fc c7ad03eb bl #0xa0213f20
a0128800 002050e2 subs r2, r0, #0
a0128804 7550ffe6 uxth r5, r5
a0128808 0500001a bne #0xa0128824
a012880c 4c3303e3 movw r3, #0x334c
a0128810 8100a0e3 mov r0, #0x81
a0128814 fb304ae3 movt r3, #0xa0fb
a0128818 0110a0e3 mov r1, #1
a012881c 183093e5 ldr r3, [r3, #0x18]
a0128820 33ff2fe1 blx r3
a0128824 880d0de3 movw r0, #0xdd88
a0128828 e0290ee3 movw r2, #0xe9e0
a012882c 0530a0e1 mov r3, r5
a0128830 53204ae3 movt r2, #0xa053
a0128834 661a02e3 movw r1, #0x2a66
a0128838 53004ae3 movt r0, #0xa053
a012883c 2afa05eb bl #0xa02a70ec
a0128840 0010a0e3 mov r1, #0
a0128844 1c208de2 add r2, sp, #0x1c
a0128848 0140a0e1 mov r4, r1
a012884c 0130a0e1 mov r3, r1
a0128850 030b00e3 movw r0, #0xb03
a0128854 21210aeb bl #0xa03b0ce0
a0128858 0410a0e1 mov r1, r4
a012885c 1c208de2 add r2, sp, #0x1c
a0128860 0430a0e1 mov r3, r4
a0128864 020b00e3 movw r0, #0xb02
a0128868 b653cde1 strh r5, [sp, #0x36]
a012886c 1b210aeb bl #0xa03b0ce0
a0128870 3affffea b #0xa0128560
a0128874 7100ffe6 uxth r0, r1
a0128878 c5bfffeb bl #0xa0118794
a012887c 0040a0e1 mov r4, r0
a0128880 36ffffea b #0xa0128560
a0128884 7100ffe6 uxth r0, r1
a0128888 7210ffe6 uxth r1, r2
a012888c d4c9ffeb bl #0xa011afe4
a0128890 0040a0e1 mov r4, r0
a0128894 31ffffea b #0xa0128560
a0128898 0100a0e1 mov r0, r1
a012889c abd8ffeb bl #0xa011eb50
a01288a0 0040a0e1 mov r4, r0
a01288a4 2dffffea b #0xa0128560
a01288a8 0100a0e1 mov r0, r1
a01288ac c4e4ffeb bl #0xa0121bc4
a01288b0 0040a0e1 mov r4, r0
a01288b4 29ffffea b #0xa0128560
a01288b8 a40f0de3 movw r0, #0xdfa4
a01288bc 742105e3 movw r2, #0x5174
a01288c0 00608de5 str r6, [sp]
a01288c4 53004ae3 movt r0, #0xa053
a01288c8 53204ae3 movt r2, #0xa053
a01288cc 881203e3 movw r1, #0x3288
a01288d0 0530a0e1 mov r3, r5
a01288d4 04fa05eb bl #0xa02a70ec
a01288d8 630056e3 cmp r6, #0x63
a01288dc 6f06008a bhi #0xa012a2a0
a01288e0 0a0056e3 cmp r6, #0xa
a01288e4 6a0a008a bhi #0xa012b294
a01288e8 0130a0e3 mov r3, #1
a01288ec 7c0408e3 movw r0, #0x847c
a01288f0 802d04e3 movw r2, #0x4d80
a01288f4 06a1a0e1 lsl sl, r6, #2
a01288f8 0692a0e1 lsl sb, r6, #4
a01288fc 04308de5 str r3, [sp, #4]
a0128900 53204ae3 movt r2, #0xa053
a0128904 00608de5 str r6, [sp]
a0128908 c71100e3 movw r1, #0x1c7
a012890c 0530a0e1 mov r3, r5
a0128910 53004ae3 movt r0, #0xa053
a0128914 dc730be3 movw r7, #0xb3dc
a0128918 f3f905eb bl #0xa02a70ec
a012891c 09306ae0 rsb r3, sl, sb
a0128920 69704ae3 movt r7, #0xa069
a0128924 834163e0 rsb r4, r3, r3, lsl #3
a0128928 0010a0e3 mov r1, #0
a012892c 4020a0e3 mov r2, #0x40
a0128930 043087e0 add r3, r7, r4
a0128934 0300a0e1 mov r0, r3
a0128938 0c308de5 str r3, [sp, #0xc]
a012893c 2a410ffa blx #0xa04f8dec
a0128940 000055e3 cmp r5, #0
a0128944 1800000a beq #0xa01289ac
a0128948 024044e2 sub r4, r4, #2
a012894c 018045e2 sub r8, r5, #1
a0128950 044087e0 add r4, r7, r4
a0128954 00b0a0e3 mov fp, #0
a0128958 040000ea b #0xa0128970
a012895c 20005be3 cmp fp, #0x20
a0128960 0600000a beq #0xa0128980
a0128964 0120f8e5 ldrb r2, [r8, #1]!
a0128968 01b08be2 add fp, fp, #1
a012896c b220e4e1 strh r2, [r4, #2]!
a0128970 0500a0e1 mov r0, r5
a0128974 1d440ffa blx #0xa04f99f0
a0128978 00005be1 cmp fp, r0
a012897c f6ffff3a blo #0xa012895c
a0128980 8621a0e1 lsl r2, r6, #3
a0128984 09106ae0 rsb r1, sl, sb
a0128988 811161e0 rsb r1, r1, r1, lsl #3
a012898c 0000a0e3 mov r0, #0
a0128990 866042e0 sub r6, r2, r6, lsl #1
a0128994 012087e0 add r2, r7, r1
a0128998 866166e0 rsb r6, r6, r6, lsl #3
a012899c 40b082e5 str fp, [r2, #0x40]
a01289a0 0b3086e0 add r3, r6, fp
a01289a4 8330a0e1 lsl r3, r3, #1
a01289a8 b30087e1 strh r0, [r7, r3]
a01289ac 09906ae0 rsb sb, sl, sb
a01289b0 0c209de5 ldr r2, [sp, #0xc]
a01289b4 899169e0 rsb sb, sb, sb, lsl #3
a01289b8 0000a0e3 mov r0, #0
a01289bc 0050a0e1 mov r5, r0
a01289c0 097087e0 add r7, r7, sb
a01289c4 0040a0e1 mov r4, r0
a01289c8 441097e5 ldr r1, [r7, #0x44]
a01289cc 616503eb bl #0xa0201f58
a01289d0 442097e5 ldr r2, [r7, #0x44]
a01289d4 0100a0e3 mov r0, #1
a01289d8 481097e5 ldr r1, [r7, #0x48]
a01289dc 2b6503eb bl #0xa0201e90
a01289e0 4c2097e5 ldr r2, [r7, #0x4c]
a01289e4 0100a0e3 mov r0, #1
a01289e8 503097e5 ldr r3, [r7, #0x50]
a01289ec 481097e5 ldr r1, [r7, #0x48]
a01289f0 00508de5 str r5, [sp]
a01289f4 1220a0e1 lsl r2, r2, r0
a01289f8 1330a0e1 lsl r3, r3, r0
a01289fc b36503eb bl #0xa02020d0
a0128a00 481097e5 ldr r1, [r7, #0x48]
a0128a04 0100a0e3 mov r0, #1
a0128a08 2e6603eb bl #0xa02022c8
a0128a0c 0100a0e3 mov r0, #1
a0128a10 666703eb bl #0xa02027b0
a0128a14 d1feffea b #0xa0128560
a0128a18 0100a0e1 mov r0, r1
a0128a1c 0210a0e1 mov r1, r2
a0128a20 79e1ffeb bl #0xa012100c
a0128a24 0040a0e3 mov r4, #0
a0128a28 ccfeffea b #0xa0128560
a0128a2c 16cfffeb bl #0xa011c68c
a0128a30 0040a0e3 mov r4, #0
a0128a34 c9feffea b #0xa0128560
a0128a38 0100a0e1 mov r0, r1
a0128a3c 0040a0e3 mov r4, #0
a0128a40 08cbffeb bl #0xa011b668
a0128a44 c5feffea b #0xa0128560
a0128a48 0100a0e1 mov r0, r1
a0128a4c 0040a0e3 mov r4, #0
a0128a50 d9cfffeb bl #0xa011c9bc
a0128a54 c1feffea b #0xa0128560
a0128a58 bc0e0de3 movw r0, #0xdebc
a0128a5c 742105e3 movw r2, #0x5174
a0128a60 53204ae3 movt r2, #0xa053
a0128a64 571203e3 movw r1, #0x3257
a0128a68 0530a0e1 mov r3, r5
a0128a6c 53004ae3 movt r0, #0xa053
a0128a70 9df905eb bl #0xa02a70ec
a0128a74 0500a0e1 mov r0, r5
a0128a78 0610a0e1 mov r1, r6
a0128a7c a2f1ffeb bl #0xa012510c
a0128a80 0040a0e1 mov r4, r0
a0128a84 b5feffea b #0xa0128560
a0128a88 bc0d0de3 movw r0, #0xddbc
a0128a8c 742105e3 movw r2, #0x5174
a0128a90 53204ae3 movt r2, #0xa053
a0128a94 531203e3 movw r1, #0x3253
a0128a98 53004ae3 movt r0, #0xa053
a0128a9c 92f905eb bl #0xa02a70ec
a0128aa0 001096e2 adds r1, r6, #0
a0128aa4 0500a0e1 mov r0, r5
a0128aa8 0110a013 movne r1, #1
a0128aac 1cbeffeb bl #0xa0118324
a0128ab0 0040a0e1 mov r4, r0
a0128ab4 a9feffea b #0xa0128560
a0128ab8 bc0d0de3 movw r0, #0xddbc
a0128abc 742105e3 movw r2, #0x5174
a0128ac0 d88c05e3 movw r8, #0x5cd8
a0128ac4 4c7303e3 movw r7, #0x334c
a0128ac8 53204ae3 movt r2, #0xa053
a0128acc 4f1203e3 movw r1, #0x324f
a0128ad0 53004ae3 movt r0, #0xa053
a0128ad4 05814ae3 movt r8, #0xa105
a0128ad8 fb704ae3 movt r7, #0xa0fb
a0128adc 82f905eb bl #0xa02a70ec
a0128ae0 0030d8e5 ldrb r3, [r8]
a0128ae4 4c020be3 movw r0, #0xb24c
a0128ae8 00c0d7e5 ldrb ip, [r7]
a0128aec 04290ee3 movw r2, #0xe904
a0128af0 53004ae3 movt r0, #0xa053
a0128af4 53204ae3 movt r2, #0xa053
a0128af8 d331e2e7 ubfx r3, r3, #3, #3
a0128afc 3d1802e3 movw r1, #0x283d
a0128b00 00c08de5 str ip, [sp]
a0128b04 78f905eb bl #0xa02a70ec
a0128b08 050056e3 cmp r6, #5
a0128b0c 1608000a beq #0xa012ab6c
a0128b10 0030d7e5 ldrb r3, [r7]
a0128b14 050053e3 cmp r3, #5
a0128b18 b405000a beq #0xa012a1f0
a0128b1c a8c301eb bl #0xa01999c4
a0128b20 000050e3 cmp r0, #0
a0128b24 b105001a bne #0xa012a1f0
a0128b28 0050d7e5 ldrb r5, [r7]
a0128b2c 000055e3 cmp r5, #0
a0128b30 04ffff1a bne #0xa0128748
a0128b34 030056e3 cmp r6, #3
a0128b38 0610a0e1 mov r1, r6
a0128b3c 2200d8e5 ldrb r0, [r8, #0x22]
a0128b40 6109000a beq #0xa012b0cc
a0128b44 f1f4ffeb bl #0xa0125f10
a0128b48 2230d8e5 ldrb r3, [r8, #0x22]
a0128b4c 030053e3 cmp r3, #3
a0128b50 5009008a bhi #0xa012b098
a0128b54 800e0de3 movw r0, #0xde80
a0128b58 04290ee3 movw r2, #0xe904
a0128b5c 53204ae3 movt r2, #0xa053
a0128b60 a61802e3 movw r1, #0x28a6
a0128b64 53004ae3 movt r0, #0xa053
a0128b68 5ff905eb bl #0xa02a70ec
a0128b6c 183097e5 ldr r3, [r7, #0x18]
a0128b70 0520a0e1 mov r2, r5
a0128b74 3200a0e3 mov r0, #0x32
a0128b78 0110a0e3 mov r1, #1
a0128b7c 33ff2fe1 blx r3
a0128b80 0040a0e1 mov r4, r0
a0128b84 75feffea b #0xa0128560
a0128b88 0100a0e1 mov r0, r1
a0128b8c 2aedffeb bl #0xa012403c
a0128b90 0040a0e1 mov r4, r0
a0128b94 71feffea b #0xa0128560
a0128b98 60c2ffeb bl #0xa0119520
a0128b9c 0040a0e1 mov r4, r0
a0128ba0 6efeffea b #0xa0128560
a0128ba4 b0330be3 movw r3, #0xb3b0
a0128ba8 0040a0e3 mov r4, #0
a0128bac 69304ae3 movt r3, #0xa069
a0128bb0 182093e5 ldr r2, [r3, #0x18]
a0128bb4 0129c2e3 bic r2, r2, #0x4000
a0128bb8 182083e5 str r2, [r3, #0x18]
a0128bbc 67feffea b #0xa0128560
a0128bc0 7c4003e3 movw r4, #0x307c
a0128bc4 bc0b0de3 movw r0, #0xdbbc
a0128bc8 6f404ae3 movt r4, #0xa06f
a0128bcc 53004ae3 movt r0, #0xa053
a0128bd0 081094e5 ldr r1, [r4, #8]
a0128bd4 4c7303e3 movw r7, #0x334c
a0128bd8 43f905eb bl #0xa02a70ec
a0128bdc d82c05e3 movw r2, #0x5cd8
a0128be0 fb704ae3 movt r7, #0xa0fb
a0128be4 05214ae3 movt r2, #0xa105
a0128be8 000c0de3 movw r0, #0xdc00
a0128bec 00c0d2e5 ldrb ip, [r2]
a0128bf0 a82f04e3 movw r2, #0x4fa8
a0128bf4 0030d7e5 ldrb r3, [r7]
a0128bf8 53204ae3 movt r2, #0xa053
a0128bfc 901202e3 movw r1, #0x2290
a0128c00 53004ae3 movt r0, #0xa053
a0128c04 dcc1e2e7 ubfx ip, ip, #3, #3
a0128c08 b0630be3 movw r6, #0xb3b0
a0128c0c 00c08de5 str ip, [sp]
a0128c10 69604ae3 movt r6, #0xa069
a0128c14 34f905eb bl #0xa02a70ec
a0128c18 480c0de3 movw r0, #0xdc48
a0128c1c a82f04e3 movw r2, #0x4fa8
a0128c20 921202e3 movw r1, #0x2292
a0128c24 53004ae3 movt r0, #0xa053
a0128c28 53204ae3 movt r2, #0xa053
a0128c2c 2ef905eb bl #0xa02a70ec
a0128c30 141096e5 ldr r1, [r6, #0x14]
a0128c34 183096e5 ldr r3, [r6, #0x18]
a0128c38 100011e3 tst r1, #0x10
a0128c3c 023ac3e3 bic r3, r3, #0x2000
a0128c40 183086e5 str r3, [r6, #0x18]
a0128c44 0200000a beq #0xa0128c54
a0128c48 0050d7e5 ldrb r5, [r7]
a0128c4c 000055e3 cmp r5, #0
a0128c50 b307000a beq #0xa012ab24
a0128c54 f80c0de3 movw r0, #0xdcf8
a0128c58 a82f04e3 movw r2, #0x4fa8
a0128c5c 00108de5 str r1, [sp]
a0128c60 53204ae3 movt r2, #0xa053
a0128c64 53004ae3 movt r0, #0xa053
a0128c68 9d1202e3 movw r1, #0x229d
a0128c6c 1ef905eb bl #0xa02a70ec
a0128c70 242097e5 ldr r2, [r7, #0x24]
a0128c74 4c3303e3 movw r3, #0x334c
a0128c78 fb304ae3 movt r3, #0xa0fb
a0128c7c 040012e3 tst r2, #4
a0128c80 af06001a bne #0xa012a744
a0128c84 1c3096e5 ldr r3, [r6, #0x1c]
a0128c88 b0430be3 movw r4, #0xb3b0
a0128c8c 69404ae3 movt r4, #0xa069
a0128c90 080013e3 tst r3, #8
a0128c94 0300000a beq #0xa0128ca8
a0128c98 0000a0e3 mov r0, #0
a0128c9c 0010a0e1 mov r1, r0
a0128ca0 36f501eb bl #0xa01a6180
a0128ca4 1c3094e5 ldr r3, [r4, #0x1c]
a0128ca8 0f30c3e3 bic r3, r3, #0xf
a0128cac 0040a0e3 mov r4, #0
a0128cb0 1c3086e5 str r3, [r6, #0x1c]
a0128cb4 29feffea b #0xa0128560
a0128cb8 740b0de3 movw r0, #0xdb74
a0128cbc 742105e3 movw r2, #0x5174
a0128cc0 53204ae3 movt r2, #0xa053
a0128cc4 071203e3 movw r1, #0x3207
a0128cc8 53004ae3 movt r0, #0xa053
a0128ccc 06f905eb bl #0xa02a70ec
a0128cd0 f7d3ffeb bl #0xa011dcb4
a0128cd4 0040a0e1 mov r4, r0
a0128cd8 20feffea b #0xa0128560
a0128cdc 900a0de3 movw r0, #0xda90
a0128ce0 742105e3 movw r2, #0x5174
a0128ce4 53204ae3 movt r2, #0xa053
a0128ce8 f81103e3 movw r1, #0x31f8
a0128cec 53004ae3 movt r0, #0xa053
a0128cf0 fdf805eb bl #0xa02a70ec
a0128cf4 bee5ffeb bl #0xa01223f4
a0128cf8 0040a0e1 mov r4, r0
a0128cfc 17feffea b #0xa0128560
a0128d00 e8fbffeb bl #0xa0127ca8
a0128d04 0040a0e1 mov r4, r0
a0128d08 14feffea b #0xa0128560
a0128d0c 1c0b0de3 movw r0, #0xdb1c
a0128d10 742105e3 movw r2, #0x5174
a0128d14 53204ae3 movt r2, #0xa053
a0128d18 321ca0e3 mov r1, #0x3200
a0128d1c 53004ae3 movt r0, #0xa053
a0128d20 f1f805eb bl #0xa02a70ec
a0128d24 2cbaffeb bl #0xa01175dc
a0128d28 0040a0e1 mov r4, r0
a0128d2c 0bfeffea b #0xa0128560
a0128d30 d40a0de3 movw r0, #0xdad4
a0128d34 742105e3 movw r2, #0x5174
a0128d38 53204ae3 movt r2, #0xa053
a0128d3c fc1103e3 movw r1, #0x31fc
a0128d40 53004ae3 movt r0, #0xa053
a0128d44 e8f805eb bl #0xa02a70ec
a0128d48 0ebaffeb bl #0xa0117588
a0128d4c 0040a0e1 mov r4, r0
a0128d50 02feffea b #0xa0128560
a0128d54 540a0de3 movw r0, #0xda54
a0128d58 742105e3 movw r2, #0x5174
a0128d5c 53204ae3 movt r2, #0xa053
a0128d60 f41103e3 movw r1, #0x31f4
a0128d64 53004ae3 movt r0, #0xa053
a0128d68 dff805eb bl #0xa02a70ec
a0128d6c 54d3ffeb bl #0xa011dac4
a0128d70 0040a0e1 mov r4, r0
a0128d74 f9fdffea b #0xa0128560
a0128d78 c8080de3 movw r0, #0xd8c8
a0128d7c 742105e3 movw r2, #0x5174
a0128d80 4c7303e3 movw r7, #0x334c
a0128d84 53004ae3 movt r0, #0xa053
a0128d88 53204ae3 movt r2, #0xa053
a0128d8c f01103e3 movw r1, #0x31f0
a0128d90 fb704ae3 movt r7, #0xa0fb
a0128d94 d4f805eb bl #0xa02a70ec
a0128d98 0030d7e5 ldrb r3, [r7]
a0128d9c 000053e3 cmp r3, #0
a0128da0 a109001a bne #0xa012b42c
a0128da4 b0530be3 movw r5, #0xb3b0
a0128da8 69504ae3 movt r5, #0xa069
a0128dac 143095e5 ldr r3, [r5, #0x14]
a0128db0 800013e3 tst r3, #0x80
a0128db4 9409001a bne #0xa012b40c
a0128db8 243097e5 ldr r3, [r7, #0x24]
a0128dbc 014013e2 ands r4, r3, #1
a0128dc0 ed08001a bne #0xa012b17c
a0128dc4 77f8ffeb bl #0xa0126fa8
a0128dc8 000050e3 cmp r0, #0
a0128dcc f90500da ble #0xa012a5b8
a0128dd0 7c3003e3 movw r3, #0x307c
a0128dd4 9c090de3 movw r0, #0xd99c
a0128dd8 6f304ae3 movt r3, #0xa06f
a0128ddc 53004ae3 movt r0, #0xa053
a0128de0 081093e5 ldr r1, [r3, #8]
a0128de4 c0f805eb bl #0xa02a70ec
a0128de8 183095e5 ldr r3, [r5, #0x18]
a0128dec 0020e0e3 mvn r2, #0
a0128df0 0020c7e5 strb r2, [r7]
a0128df4 013783e3 orr r3, r3, #0x40000
a0128df8 183085e5 str r3, [r5, #0x18]
a0128dfc d7fdffea b #0xa0128560
a0128e00 88080de3 movw r0, #0xd888
a0128e04 742105e3 movw r2, #0x5174
a0128e08 53204ae3 movt r2, #0xa053
a0128e0c ec1103e3 movw r1, #0x31ec
a0128e10 53004ae3 movt r0, #0xa053
a0128e14 b4f805eb bl #0xa02a70ec
a0128e18 95bfffeb bl #0xa0118c74
a0128e1c 0040a0e1 mov r4, r0
a0128e20 cefdffea b #0xa0128560
a0128e24 48080de3 movw r0, #0xd848
a0128e28 742105e3 movw r2, #0x5174
a0128e2c 53204ae3 movt r2, #0xa053
a0128e30 e81103e3 movw r1, #0x31e8
a0128e34 53004ae3 movt r0, #0xa053
a0128e38 abf805eb bl #0xa02a70ec
a0128e3c d6c7ffeb bl #0xa011ad9c
a0128e40 0040a0e1 mov r4, r0
a0128e44 c5fdffea b #0xa0128560
a0128e48 88040de3 movw r0, #0xd488
a0128e4c 742105e3 movw r2, #0x5174
a0128e50 53204ae3 movt r2, #0xa053
a0128e54 651103e3 movw r1, #0x3165
a0128e58 53004ae3 movt r0, #0xa053
a0128e5c a2f805eb bl #0xa02a70ec
a0128e60 0500a0e1 mov r0, r5
a0128e64 0110a0e3 mov r1, #1
a0128e68 83f7ffeb bl #0xa0126c7c
a0128e6c 0040a0e1 mov r4, r0
a0128e70 bafdffea b #0xa0128560
a0128e74 0100a0e1 mov r0, r1
a0128e78 23beffeb bl #0xa011870c
a0128e7c 0040a0e1 mov r4, r0
a0128e80 b6fdffea b #0xa0128560
a0128e84 0100a0e1 mov r0, r1
a0128e88 f3c7ffeb bl #0xa011ae5c
a0128e8c 0040a0e1 mov r4, r0
a0128e90 b2fdffea b #0xa0128560
a0128e94 600f0de3 movw r0, #0xdf60
a0128e98 742105e3 movw r2, #0x5174
a0128e9c 53204ae3 movt r2, #0xa053
a0128ea0 771203e3 movw r1, #0x3277
a0128ea4 53004ae3 movt r0, #0xa053
a0128ea8 0040a0e3 mov r4, #0
a0128eac 8ef805eb bl #0xa02a70ec
a0128eb0 f2a801eb bl #0xa0193280
a0128eb4 ca00a0e3 mov r0, #0xca
a0128eb8 d1dbffeb bl #0xa011fe04
a0128ebc a7fdffea b #0xa0128560
a0128ec0 d84c05e3 movw r4, #0x5cd8
a0128ec4 05414ae3 movt r4, #0xa105
a0128ec8 0450d4e5 ldrb r5, [r4, #4]
a0128ecc 0560d4e5 ldrb r6, [r4, #5]
a0128ed0 fe7501eb bl #0xa01866d0
a0128ed4 742105e3 movw r2, #0x5174
a0128ed8 04008de5 str r0, [sp, #4]
a0128edc 0c0f0de3 movw r0, #0xdf0c
a0128ee0 0530a0e1 mov r3, r5
a0128ee4 00608de5 str r6, [sp]
a0128ee8 53004ae3 movt r0, #0xa053
a0128eec 53204ae3 movt r2, #0xa053
a0128ef0 6d1203e3 movw r1, #0x326d
a0128ef4 7cf805eb bl #0xa02a70ec
a0128ef8 0430d4e5 ldrb r3, [r4, #4]
a0128efc 020053e3 cmp r3, #2
a0128f00 cb06000a beq #0xa012aa34
a0128f04 ca00a0e3 mov r0, #0xca
a0128f08 0040a0e3 mov r4, #0
a0128f0c bcdbffeb bl #0xa011fe04
a0128f10 92fdffea b #0xa0128560
a0128f14 ed7501eb bl #0xa01866d0
a0128f18 090050e3 cmp r0, #9
a0128f1c f8ffff8a bhi #0xa0128f04
a0128f20 0010a0e3 mov r1, #0
a0128f24 1d00a0e3 mov r0, #0x1d
a0128f28 952100eb bl #0xa0131584
a0128f2c f4ffffea b #0xa0128f04
a0128f30 6b2902eb bl #0xa01b34e4
a0128f34 010050e3 cmp r0, #1
a0128f38 9607000a beq #0xa012ad98
a0128f3c d43c05e3 movw r3, #0x5cd4
a0128f40 05314ae3 movt r3, #0xa105
a0128f44 003093e5 ldr r3, [r3]
a0128f48 3641d3e5 ldrb r4, [r3, #0x136]
a0128f4c 000054e3 cmp r4, #0
a0128f50 2f06001a bne #0xa012a814
a0128f54 4c5303e3 movw r5, #0x334c
a0128f58 fb504ae3 movt r5, #0xa0fb
a0128f5c 0060d5e5 ldrb r6, [r5]
a0128f60 050056e3 cmp r6, #5
a0128f64 9d07000a beq #0xa012ade0
a0128f68 000056e3 cmp r6, #0
a0128f6c 9506001a bne #0xa012a9c8
a0128f70 5ec901eb bl #0xa019b4f0
a0128f74 d83c05e3 movw r3, #0x5cd8
a0128f78 05314ae3 movt r3, #0xa105
a0128f7c 0040d3e5 ldrb r4, [r3]
a0128f80 384014e2 ands r4, r4, #0x38
a0128f84 ca06001a bne #0xa012aab4
a0128f88 0410a0e1 mov r1, r4
a0128f8c 0420a0e1 mov r2, r4
a0128f90 0400a0e1 mov r0, r4
a0128f94 91d1ffeb bl #0xa011d5e0
a0128f98 0100a0e3 mov r0, #1
a0128f9c 049c03eb bl #0xa020ffb4
a0128fa0 7cd203eb bl #0xa021d998
a0128fa4 0400a0e1 mov r0, r4
a0128fa8 0420a0e1 mov r2, r4
a0128fac 0110a0e3 mov r1, #1
a0128fb0 43d5ffeb bl #0xa011e4c4
a0128fb4 0100a0e3 mov r0, #1
a0128fb8 0040a0e3 mov r4, #0
a0128fbc ed9b03eb bl #0xa020ff78
a0128fc0 0100a0e3 mov r0, #1
a0128fc4 972902eb bl #0xa01b3628
a0128fc8 a12802eb bl #0xa01b3254
a0128fcc 0100a0e3 mov r0, #1
a0128fd0 6f2a02eb bl #0xa01b3994
a0128fd4 61fdffea b #0xa0128560
a0128fd8 440d0de3 movw r0, #0xdd44
a0128fdc 742105e3 movw r2, #0x5174
a0128fe0 53204ae3 movt r2, #0xa053
a0128fe4 151203e3 movw r1, #0x3215
a0128fe8 53004ae3 movt r0, #0xa053
a0128fec 3ef805eb bl #0xa02a70ec
a0128ff0 0500a0e1 mov r0, r5
a0128ff4 fcfbffeb bl #0xa0127fec
a0128ff8 0040a0e1 mov r4, r0
a0128ffc 57fdffea b #0xa0128560
a0129000 d0250ce3 movw r2, #0xc5d0
a0129004 010055e3 cmp r5, #1
a0129008 53204ae3 movt r2, #0xa053
a012900c 04130de3 movw r1, #0xd304
a0129010 4c3303e3 movw r3, #0x334c
a0129014 50000ee3 movw r0, #0xe050
a0129018 57104ae3 movt r1, #0xa057
a012901c fb304ae3 movt r3, #0xa0fb
a0129020 0210a011 movne r1, r2
a0129024 53004ae3 movt r0, #0xa053
a0129028 0540a0e1 mov r4, r5
a012902c 2c5083e5 str r5, [r3, #0x2c]
a0129030 2df805eb bl #0xa02a70ec
a0129034 49fdffea b #0xa0128560
a0129038 4c3303e3 movw r3, #0x334c
a012903c fb304ae3 movt r3, #0xa0fb
a0129040 0020d3e5 ldrb r2, [r3]
a0129044 050052e3 cmp r2, #5
a0129048 6e06000a beq #0xa012aa08
a012904c b0330be3 movw r3, #0xb3b0
a0129050 0040a0e3 mov r4, #0
a0129054 69304ae3 movt r3, #0xa069
a0129058 142093e5 ldr r2, [r3, #0x14]
a012905c 802082e3 orr r2, r2, #0x80
a0129060 142083e5 str r2, [r3, #0x14]
a0129064 3dfdffea b #0xa0128560
a0129068 b0230be3 movw r2, #0xb3b0
a012906c 34300be3 movw r3, #0xb034
a0129070 69204ae3 movt r2, #0xa069
a0129074 69304ae3 movt r3, #0xa069
a0129078 0c2092e5 ldr r2, [r2, #0xc]
a012907c 003093e5 ldr r3, [r3]
a0129080 030052e1 cmp r2, r3
a0129084 affdff0a beq #0xa0128748
a0129088 c800a0e3 mov r0, #0xc8
a012908c 0010a0e3 mov r1, #0
a0129090 442d00eb bl #0xa01345a8
a0129094 0040a0e3 mov r4, #0
a0129098 30fdffea b #0xa0128560
a012909c c5d3ffeb bl #0xa011dfb8
a01290a0 0040a0e1 mov r4, r0
a01290a4 2dfdffea b #0xa0128560
a01290a8 4c3303e3 movw r3, #0x334c
a01290ac fb304ae3 movt r3, #0xa0fb
a01290b0 0070d3e5 ldrb r7, [r3]
a01290b4 000057e3 cmp r7, #0
a01290b8 1c05001a bne #0xa012a530
a01290bc 18030ee3 movw r0, #0xe318
a01290c0 d48c05e3 movw r8, #0x5cd4
a01290c4 05814ae3 movt r8, #0xa105
a01290c8 53004ae3 movt r0, #0xa053
a01290cc 06f805eb bl #0xa02a70ec
a01290d0 003098e5 ldr r3, [r8]
a01290d4 0700a0e1 mov r0, r7
a01290d8 0740a0e1 mov r4, r7
a01290dc 0b70c3e5 strb r7, [r3, #0xb]
a01290e0 acd903eb bl #0xa021f798
a01290e4 003098e5 ldr r3, [r8]
a01290e8 0100a0e3 mov r0, #1
a01290ec 0d70c3e5 strb r7, [r3, #0xd]
a01290f0 b2d903eb bl #0xa021f7c0
a01290f4 47d403eb bl #0xa021e218
a01290f8 56d503eb bl #0xa021e658
a01290fc 25d203eb bl #0xa021d998
a0129100 26d403eb bl #0xa021e1a0
a0129104 b0330be3 movw r3, #0xb3b0
a0129108 69304ae3 movt r3, #0xa069
a012910c 182093e5 ldr r2, [r3, #0x18]
a0129110 012682e3 orr r2, r2, #0x100000
a0129114 182083e5 str r2, [r3, #0x18]
a0129118 10fdffea b #0xa0128560
a012911c d43c05e3 movw r3, #0x5cd4
a0129120 05314ae3 movt r3, #0xa105
a0129124 003093e5 ldr r3, [r3]
a0129128 7730d3e5 ldrb r3, [r3, #0x77]
a012912c 020053e3 cmp r3, #2
a0129130 84fdff1a bne #0xa0128748
a0129134 04080de3 movw r0, #0xd804
a0129138 b42105e3 movw r2, #0x51b4
a012913c 53204ae3 movt r2, #0xa053
a0129140 f51e01e3 movw r1, #0x1ef5
a0129144 53004ae3 movt r0, #0xa053
a0129148 0040a0e3 mov r4, #0
a012914c e6f705eb bl #0xa02a70ec
a0129150 032404eb bl #0xa0232164
a0129154 01fdffea b #0xa0128560
a0129158 d6c6ffeb bl #0xa011acb8
a012915c 0040a0e1 mov r4, r0
a0129160 fefcffea b #0xa0128560
a0129164 0200a0e3 mov r0, #2
a0129168 4c5303e3 movw r5, #0x334c
a012916c cd6003eb bl #0xa02014a8
a0129170 0200a0e3 mov r0, #2
a0129174 0040a0e3 mov r4, #0
a0129178 6d6203eb bl #0xa0201b34
a012917c fb504ae3 movt r5, #0xa0fb
a0129180 0200a0e3 mov r0, #2
a0129184 d46203eb bl #0xa0201cdc
a0129188 0410a0e1 mov r1, r4
a012918c 1c3095e5 ldr r3, [r5, #0x1c]
a0129190 0420a0e1 mov r2, r4
a0129194 0200a0e3 mov r0, #2
a0129198 33ff2fe1 blx r3
a012919c 0400a0e1 mov r0, r4
a01291a0 1c3095e5 ldr r3, [r5, #0x1c]
a01291a4 0410a0e1 mov r1, r4
a01291a8 0420a0e1 mov r2, r4
a01291ac 33ff2fe1 blx r3
a01291b0 eafcffea b #0xa0128560
a01291b4 aac5ffeb bl #0xa011a864
a01291b8 0040a0e1 mov r4, r0
a01291bc e7fcffea b #0xa0128560
a01291c0 56cdffeb bl #0xa011c720
a01291c4 0040a0e1 mov r4, r0
a01291c8 e4fcffea b #0xa0128560
a01291cc 0100a0e1 mov r0, r1
a01291d0 43e5ffeb bl #0xa01226e4
a01291d4 0040a0e1 mov r4, r0
a01291d8 e0fcffea b #0xa0128560
a01291dc c0070de3 movw r0, #0xd7c0
a01291e0 742105e3 movw r2, #0x5174
a01291e4 53204ae3 movt r2, #0xa053
a01291e8 b51103e3 movw r1, #0x31b5
a01291ec 53004ae3 movt r0, #0xa053
a01291f0 bdf705eb bl #0xa02a70ec
a01291f4 d5d5ffeb bl #0xa011e950
a01291f8 0040a0e1 mov r4, r0
a01291fc d7fcffea b #0xa0128560
a0129200 b0330be3 movw r3, #0xb3b0
a0129204 69304ae3 movt r3, #0xa069
a0129208 142093e5 ldr r2, [r3, #0x14]
a012920c 800012e3 tst r2, #0x80
a0129210 4cfdff0a beq #0xa0128748
a0129214 8020c2e3 bic r2, r2, #0x80
a0129218 0040a0e3 mov r4, #0
a012921c 142083e5 str r2, [r3, #0x14]
a0129220 cefcffea b #0xa0128560
a0129224 0100a0e1 mov r0, r1
a0129228 0210a0e1 mov r1, r2
a012922c 5cc5ffeb bl #0xa011a7a4
a0129230 0040a0e1 mov r4, r0
a0129234 c9fcffea b #0xa0128560
a0129238 74070de3 movw r0, #0xd774
a012923c 742105e3 movw r2, #0x5174
a0129240 53204ae3 movt r2, #0xa053
a0129244 ab1103e3 movw r1, #0x31ab
a0129248 53004ae3 movt r0, #0xa053
a012924c 0040a0e3 mov r4, #0
a0129250 a5f705eb bl #0xa02a70ec
a0129254 c1fcffea b #0xa0128560
a0129258 30070de3 movw r0, #0xd730
a012925c 742105e3 movw r2, #0x5174
a0129260 53204ae3 movt r2, #0xa053
a0129264 a71103e3 movw r1, #0x31a7
a0129268 53004ae3 movt r0, #0xa053
a012926c 9ef705eb bl #0xa02a70ec
a0129270 26dfffeb bl #0xa0120f10
a0129274 0040a0e1 mov r4, r0
a0129278 b8fcffea b #0xa0128560
a012927c 1befffeb bl #0xa0124ef0
a0129280 0040a0e1 mov r4, r0
a0129284 b5fcffea b #0xa0128560
a0129288 d83c05e3 movw r3, #0x5cd8
a012928c 05314ae3 movt r3, #0xa105
a0129290 0030d3e5 ldrb r3, [r3]
a0129294 384013e2 ands r4, r3, #0x38
a0129298 b004000a beq #0xa012a560
a012929c 0010a0e3 mov r1, #0
a01292a0 0100a0e3 mov r0, #1
a01292a4 0120a0e1 mov r2, r1
a01292a8 ccd0ffeb bl #0xa011d5e0
a01292ac 0500a0e1 mov r0, r5
a01292b0 3f9b03eb bl #0xa020ffb4
a01292b4 90a803eb bl #0xa02134fc
a01292b8 0100a0e3 mov r0, #1
a01292bc 0020a0e3 mov r2, #0
a01292c0 0010a0e1 mov r1, r0
a01292c4 7ed4ffeb bl #0xa011e4c4
a01292c8 0500a0e1 mov r0, r5
a01292cc 0040a0e3 mov r4, #0
a01292d0 289b03eb bl #0xa020ff78
a01292d4 7500efe6 uxtb r0, r5
a01292d8 ad2902eb bl #0xa01b3994
a01292dc 9ffcffea b #0xa0128560
a01292e0 e8060de3 movw r0, #0xd6e8
a01292e4 742105e3 movw r2, #0x5174
a01292e8 53204ae3 movt r2, #0xa053
a01292ec 9c1103e3 movw r1, #0x319c
a01292f0 53004ae3 movt r0, #0xa053
a01292f4 7cf705eb bl #0xa02a70ec
a01292f8 e7daffeb bl #0xa011fe9c
a01292fc 0040a0e1 mov r4, r0
a0129300 96fcffea b #0xa0128560
a0129304 44040de3 movw r0, #0xd444
a0129308 742105e3 movw r2, #0x5174
a012930c 53204ae3 movt r2, #0xa053
a0129310 611103e3 movw r1, #0x3161
a0129314 53004ae3 movt r0, #0xa053
a0129318 73f705eb bl #0xa02a70ec
a012931c 0500a0e1 mov r0, r5
a0129320 0010a0e3 mov r1, #0
a0129324 54f6ffeb bl #0xa0126c7c
a0129328 0040a0e1 mov r4, r0
a012932c 8bfcffea b #0xa0128560
a0129330 e8020de3 movw r0, #0xd2e8
a0129334 742105e3 movw r2, #0x5174
a0129338 d88c05e3 movw r8, #0x5cd8
a012933c 53204ae3 movt r2, #0xa053
a0129340 5d1103e3 movw r1, #0x315d
a0129344 53004ae3 movt r0, #0xa053
a0129348 05814ae3 movt r8, #0xa105
a012934c 4c7303e3 movw r7, #0x334c
a0129350 65f705eb bl #0xa02a70ec
a0129354 22c0d8e5 ldrb ip, [r8, #0x22]
a0129358 fb704ae3 movt r7, #0xa0fb
a012935c 28030de3 movw r0, #0xd328
a0129360 4c250ee3 movw r2, #0xe54c
a0129364 0030d7e5 ldrb r3, [r7]
a0129368 53204ae3 movt r2, #0xa053
a012936c 53004ae3 movt r0, #0xa053
a0129370 fd1801e3 movw r1, #0x18fd
a0129374 00c08de5 str ip, [sp]
a0129378 b0630be3 movw r6, #0xb3b0
a012937c 5af705eb bl #0xa02a70ec
a0129380 d43c05e3 movw r3, #0x5cd4
a0129384 69604ae3 movt r6, #0xa069
a0129388 05314ae3 movt r3, #0xa105
a012938c 182096e5 ldr r2, [r6, #0x18]
a0129390 003093e5 ldr r3, [r3]
a0129394 1c30d3e5 ldrb r3, [r3, #0x1c]
a0129398 383003e2 and r3, r3, #0x38
a012939c 200053e3 cmp r3, #0x20
a01293a0 ee04000a beq #0xa012a760
a01293a4 024c12e2 ands r4, r2, #0x200
a01293a8 a805001a bne #0xa012aa50
a01293ac 0000d7e5 ldrb r0, [r7]
a01293b0 4c1303e3 movw r1, #0x334c
a01293b4 fb104ae3 movt r1, #0xa0fb
a01293b8 01c040e2 sub ip, r0, #1
a01293bc 01005ce3 cmp ip, #1
a01293c0 fc06009a bls #0xa012afb8
a01293c4 200012e3 tst r2, #0x20
a01293c8 a504000a beq #0xa012a664
a01293cc 080053e3 cmp r3, #8
a01293d0 dcfcff1a bne #0xa0128748
a01293d4 e4030de3 movw r0, #0xd3e4
a01293d8 4c250ee3 movw r2, #0xe54c
a01293dc 53204ae3 movt r2, #0xa053
a01293e0 151901e3 movw r1, #0x1915
a01293e4 53004ae3 movt r0, #0xa053
a01293e8 3ff705eb bl #0xa02a70ec
a01293ec 183096e5 ldr r3, [r6, #0x18]
a01293f0 0500a0e3 mov r0, #5
a01293f4 2030c3e3 bic r3, r3, #0x20
a01293f8 183086e5 str r3, [r6, #0x18]
a01293fc e2dbffeb bl #0xa012038c
a0129400 48310ce3 movw r3, #0xc148
a0129404 942603e3 movw r2, #0x3694
a0129408 fb304ae3 movt r3, #0xa0fb
a012940c fb204ae3 movt r2, #0xa0fb
a0129410 0030d3e5 ldrb r3, [r3]
a0129414 004082e5 str r4, [r2]
a0129418 023043e2 sub r3, r3, #2
a012941c 010053e3 cmp r3, #1
a0129420 b107009a bls #0xa012b2ec
a0129424 183096e5 ldr r3, [r6, #0x18]
a0129428 ca00a0e3 mov r0, #0xca
a012942c 0040a0e3 mov r4, #0
a0129430 0234c3e3 bic r3, r3, #0x2000000
a0129434 183086e5 str r3, [r6, #0x18]
a0129438 71daffeb bl #0xa011fe04
a012943c 47fcffea b #0xa0128560
a0129440 78020de3 movw r0, #0xd278
a0129444 742105e3 movw r2, #0x5174
a0129448 53204ae3 movt r2, #0xa053
a012944c 591103e3 movw r1, #0x3159
a0129450 53004ae3 movt r0, #0xa053
a0129454 24f705eb bl #0xa02a70ec
a0129458 7c3003e3 movw r3, #0x307c
a012945c bc020de3 movw r0, #0xd2bc
a0129460 6f304ae3 movt r3, #0xa06f
a0129464 53004ae3 movt r0, #0xa053
a0129468 081093e5 ldr r1, [r3, #8]
a012946c 1ef705eb bl #0xa02a70ec
a0129470 0100a0e3 mov r0, #1
a0129474 376e03eb bl #0xa0204d58
a0129478 4c3303e3 movw r3, #0x334c
a012947c fb304ae3 movt r3, #0xa0fb
a0129480 0040d3e5 ldrb r4, [r3]
a0129484 000054e3 cmp r4, #0
a0129488 5805000a beq #0xa012a9f0
a012948c 050054e3 cmp r4, #5
a0129490 acfcff1a bne #0xa0128748
a0129494 0010a0e3 mov r1, #0
a0129498 183093e5 ldr r3, [r3, #0x18]
a012949c 0120a0e1 mov r2, r1
a01294a0 5900a0e3 mov r0, #0x59
a01294a4 33ff2fe1 blx r3
a01294a8 0040a0e3 mov r4, #0
a01294ac 2bfcffea b #0xa0128560
a01294b0 7c010de3 movw r0, #0xd17c
a01294b4 742105e3 movw r2, #0x5174
a01294b8 53204ae3 movt r2, #0xa053
a01294bc 551103e3 movw r1, #0x3155
a01294c0 53004ae3 movt r0, #0xa053
a01294c4 08f705eb bl #0xa02a70ec
a01294c8 0100a0e3 mov r0, #1
a01294cc 216e03eb bl #0xa0204d58
a01294d0 000055e3 cmp r5, #0
a01294d4 5105001a bne #0xa012aa20
a01294d8 4c6303e3 movw r6, #0x334c
a01294dc fb604ae3 movt r6, #0xa0fb
a01294e0 0030d6e5 ldrb r3, [r6]
a01294e4 010053e3 cmp r3, #1
a01294e8 7f05000a beq #0xa012aaec
a01294ec 40020de3 movw r0, #0xd240
a01294f0 0540a0e1 mov r4, r5
a01294f4 53004ae3 movt r0, #0xa053
a01294f8 fbf605eb bl #0xa02a70ec
a01294fc 17fcffea b #0xa0128560
a0129500 4c3303e3 movw r3, #0x334c
a0129504 fb304ae3 movt r3, #0xa0fb
a0129508 0020d3e5 ldrb r2, [r3]
a012950c 012042e2 sub r2, r2, #1
a0129510 010052e3 cmp r2, #1
a0129514 8bfcff8a bhi #0xa0128748
a0129518 0010a0e3 mov r1, #0
a012951c 183093e5 ldr r3, [r3, #0x18]
a0129520 0120a0e1 mov r2, r1
a0129524 1300a0e3 mov r0, #0x13
a0129528 33ff2fe1 blx r3
a012952c 0040a0e3 mov r4, #0
a0129530 0afcffea b #0xa0128560
a0129534 34010de3 movw r0, #0xd134
a0129538 742105e3 movw r2, #0x5174
a012953c 53204ae3 movt r2, #0xa053
a0129540 53004ae3 movt r0, #0xa053
a0129544 4e1103e3 movw r1, #0x314e
a0129548 e7f605eb bl #0xa02a70ec
a012954c 4c3303e3 movw r3, #0x334c
a0129550 fb304ae3 movt r3, #0xa0fb
a0129554 0020d3e5 ldrb r2, [r3]
a0129558 012042e2 sub r2, r2, #1
a012955c 010052e3 cmp r2, #1
a0129560 78fcff8a bhi #0xa0128748
a0129564 0010a0e3 mov r1, #0
a0129568 183093e5 ldr r3, [r3, #0x18]
a012956c 0120a0e1 mov r2, r1
a0129570 3b00a0e3 mov r0, #0x3b
a0129574 33ff2fe1 blx r3
a0129578 0040a0e3 mov r4, #0
a012957c f7fbffea b #0xa0128560
a0129580 10000de3 movw r0, #0xd010
a0129584 742105e3 movw r2, #0x5174
a0129588 4c5303e3 movw r5, #0x334c
a012958c 53004ae3 movt r0, #0xa053
a0129590 53204ae3 movt r2, #0xa053
a0129594 4a1103e3 movw r1, #0x314a
a0129598 fb504ae3 movt r5, #0xa0fb
a012959c d2f605eb bl #0xa02a70ec
a01295a0 0030d5e5 ldrb r3, [r5]
a01295a4 013043e2 sub r3, r3, #1
a01295a8 010053e3 cmp r3, #1
a01295ac 65fcff8a bhi #0xa0128748
a01295b0 b0430be3 movw r4, #0xb3b0
a01295b4 d82c05e3 movw r2, #0x5cd8
a01295b8 69404ae3 movt r4, #0xa069
a01295bc 05214ae3 movt r2, #0xa105
a01295c0 183094e5 ldr r3, [r4, #0x18]
a01295c4 0110a0e3 mov r1, #1
a01295c8 0f00e0e3 mvn r0, #0xf
a01295cc f111c2e5 strb r1, [r2, #0x1f1]
a01295d0 023c83e3 orr r3, r3, #0x200
a01295d4 183084e5 str r3, [r4, #0x18]
a01295d8 d3ddffeb bl #0xa0120d2c
a01295dc 183094e5 ldr r3, [r4, #0x18]
a01295e0 040013e3 tst r3, #4
a01295e4 6007000a beq #0xa012b36c
a01295e8 b41801e3 movw r1, #0x18b4
a01295ec e4000de3 movw r0, #0xd0e4
a01295f0 e42705e3 movw r2, #0x57e4
a01295f4 583005e3 movw r3, #0x5058
a01295f8 00108de5 str r1, [sp]
a01295fc 0040a0e3 mov r4, #0
a0129600 53204ae3 movt r2, #0xa053
a0129604 53304ae3 movt r3, #0xa053
a0129608 53004ae3 movt r0, #0xa053
a012960c b6f605eb bl #0xa02a70ec
a0129610 0410a0e1 mov r1, r4
a0129614 183095e5 ldr r3, [r5, #0x18]
a0129618 0420a0e1 mov r2, r4
a012961c 1300a0e3 mov r0, #0x13
a0129620 33ff2fe1 blx r3
a0129624 cdfbffea b #0xa0128560
a0129628 eddfffeb bl #0xa01215e4
a012962c 0040a0e1 mov r4, r0
a0129630 cafbffea b #0xa0128560
a0129634 113e03eb bl #0xa01f8e80
a0129638 0040a0e3 mov r4, #0
a012963c c7fbffea b #0xa0128560
a0129640 a0bbffeb bl #0xa01184c8
a0129644 0040a0e1 mov r4, r0
a0129648 c4fbffea b #0xa0128560
a012964c 0100a0e1 mov r0, r1
a0129650 ecc2ffeb bl #0xa011a208
a0129654 0040a0e1 mov r4, r0
a0129658 c0fbffea b #0xa0128560
a012965c c40f0ce3 movw r0, #0xcfc4
a0129660 742105e3 movw r2, #0x5174
a0129664 53204ae3 movt r2, #0xa053
a0129668 3a1103e3 movw r1, #0x313a
a012966c 0530a0e1 mov r3, r5
a0129670 53004ae3 movt r0, #0xa053
a0129674 9cf605eb bl #0xa02a70ec
a0129678 7500efe6 uxtb r0, r5
a012967c fcf7ffeb bl #0xa0127674
a0129680 0040a0e1 mov r4, r0
a0129684 b5fbffea b #0xa0128560
a0129688 7100efe6 uxtb r0, r1
a012968c 94b7ffeb bl #0xa01174e4
a0129690 0040a0e1 mov r4, r0
a0129694 b1fbffea b #0xa0128560
a0129698 ff4011e2 ands r4, r1, #0xff
a012969c 0040a013 movne r4, #0
a01296a0 aefbff1a bne #0xa0128560
a01296a4 b0330be3 movw r3, #0xb3b0
a01296a8 69304ae3 movt r3, #0xa069
a01296ac 1c2093e5 ldr r2, [r3, #0x1c]
a01296b0 802082e3 orr r2, r2, #0x80
a01296b4 1c2083e5 str r2, [r3, #0x1c]
a01296b8 a8fbffea b #0xa0128560
a01296bc 7c0f0ce3 movw r0, #0xcf7c
a01296c0 742105e3 movw r2, #0x5174
a01296c4 53204ae3 movt r2, #0xa053
a01296c8 301103e3 movw r1, #0x3130
a01296cc 53004ae3 movt r0, #0xa053
a01296d0 85f605eb bl #0xa02a70ec
a01296d4 13ddffeb bl #0xa0120b28
a01296d8 0040a0e1 mov r4, r0
a01296dc 9ffbffea b #0xa0128560
a01296e0 84d403eb bl #0xa021e8f8
a01296e4 d82c05e3 movw r2, #0x5cd8
a01296e8 b0330be3 movw r3, #0xb3b0
a01296ec 05214ae3 movt r2, #0xa105
a01296f0 69304ae3 movt r3, #0xa069
a01296f4 2210d2e5 ldrb r1, [r2, #0x22]
a01296f8 0040a0e3 mov r4, #0
a01296fc 182093e5 ldr r2, [r3, #0x18]
a0129700 050051e3 cmp r1, #5
a0129704 c0160d03 movweq r1, #0xd6c0
a0129708 8c180d13 movwne r1, #0xd88c
a012970c 0120c2e3 bic r2, r2, #1
a0129710 0a00a003 moveq r0, #0xa
a0129714 11104a03 movteq r1, #0xa011
a0129718 0100a013 movne r0, #1
a012971c 11104a13 movtne r1, #0xa011
a0129720 182083e5 str r2, [r3, #0x18]
a0129724 e8f402eb bl #0xa01e6acc
a0129728 8cfbffea b #0xa0128560
a012972c a1c2ffeb bl #0xa011a1b8
a0129730 0040a0e1 mov r4, r0
a0129734 89fbffea b #0xa0128560
a0129738 3c0f0ce3 movw r0, #0xcf3c
a012973c 742105e3 movw r2, #0x5174
a0129740 53204ae3 movt r2, #0xa053
a0129744 2c1103e3 movw r1, #0x312c
a0129748 53004ae3 movt r0, #0xa053
a012974c 66f605eb bl #0xa02a70ec
a0129750 18d2ffeb bl #0xa011dfb8
a0129754 0040a0e1 mov r4, r0
a0129758 80fbffea b #0xa0128560
a012975c fc0e0ce3 movw r0, #0xcefc
a0129760 742105e3 movw r2, #0x5174
a0129764 53204ae3 movt r2, #0xa053
a0129768 221103e3 movw r1, #0x3122
a012976c 53004ae3 movt r0, #0xa053
a0129770 5df605eb bl #0xa02a70ec
a0129774 3debffeb bl #0xa0124470
a0129778 0040a0e1 mov r4, r0
a012977c 77fbffea b #0xa0128560
a0129780 b00e0ce3 movw r0, #0xceb0
a0129784 742105e3 movw r2, #0x5174
a0129788 53204ae3 movt r2, #0xa053
a012978c 1e1103e3 movw r1, #0x311e
a0129790 53004ae3 movt r0, #0xa053
a0129794 54f605eb bl #0xa02a70ec
a0129798 54e7ffeb bl #0xa01234f0
a012979c 0040a0e1 mov r4, r0
a01297a0 6efbffea b #0xa0128560
a01297a4 600e0ce3 movw r0, #0xce60
a01297a8 742105e3 movw r2, #0x5174
a01297ac 53204ae3 movt r2, #0xa053
a01297b0 1a1103e3 movw r1, #0x311a
a01297b4 53004ae3 movt r0, #0xa053
a01297b8 0040a0e3 mov r4, #0
a01297bc 4af605eb bl #0xa02a70ec
a01297c0 66fbffea b #0xa0128560
a01297c4 1c0e0ce3 movw r0, #0xce1c
a01297c8 742105e3 movw r2, #0x5174
a01297cc 53204ae3 movt r2, #0xa053
a01297d0 161103e3 movw r1, #0x3116
a01297d4 53004ae3 movt r0, #0xa053
a01297d8 43f605eb bl #0xa02a70ec
a01297dc a4dcffeb bl #0xa0120a74
a01297e0 0040a0e1 mov r4, r0
a01297e4 5dfbffea b #0xa0128560
a01297e8 8c0b0ce3 movw r0, #0xcb8c
a01297ec 742105e3 movw r2, #0x5174
a01297f0 b0630be3 movw r6, #0xb3b0
a01297f4 53004ae3 movt r0, #0xa053
a01297f8 53204ae3 movt r2, #0xa053
a01297fc 121103e3 movw r1, #0x3112
a0129800 69604ae3 movt r6, #0xa069
a0129804 4c4303e3 movw r4, #0x334c
a0129808 37f605eb bl #0xa02a70ec
a012980c 183096e5 ldr r3, [r6, #0x18]
a0129810 fb404ae3 movt r4, #0xa0fb
a0129814 020013e3 tst r3, #2
a0129818 0c3094e5 ldr r3, [r4, #0xc]
a012981c f402000a beq #0xa012a3f4
a0129820 000053e3 cmp r3, #0
a0129824 0d0600da ble #0xa012b060
a0129828 020053e3 cmp r3, #2
a012982c 530400da ble #0xa012a980
a0129830 7c6003e3 movw r6, #0x307c
a0129834 040c0ce3 movw r0, #0xcc04
a0129838 6f604ae3 movt r6, #0xa06f
a012983c d82605e3 movw r2, #0x56d8
a0129840 f73d00e3 movw r3, #0xdf7
a0129844 081096e5 ldr r1, [r6, #8]
a0129848 53204ae3 movt r2, #0xa053
a012984c 53004ae3 movt r0, #0xa053
a0129850 25f605eb bl #0xa02a70ec
a0129854 0000a0e3 mov r0, #0
a0129858 0010a0e1 mov r1, r0
a012985c 0020a0e1 mov r2, r0
a0129860 c5c8ffeb bl #0xa011bb7c
a0129864 003050e2 subs r3, r0, #0
a0129868 9305001a bne #0xa012aebc
a012986c 0060d4e5 ldrb r6, [r4]
a0129870 000056e3 cmp r6, #0
a0129874 dd05000a beq #0xa012aff0
a0129878 d83c05e3 movw r3, #0x5cd8
a012987c 000055e3 cmp r5, #0
a0129880 05314ae3 movt r3, #0xa105
a0129884 0120a0e3 mov r2, #1
a0129888 d022c3e5 strb r2, [r3, #0x2d0]
a012988c 0300000a beq #0xa01298a0
a0129890 1600a0e3 mov r0, #0x16
a0129894 0010a0e3 mov r1, #0
a0129898 000140e3 movt r0, #0x100
a012989c 7c5804eb bl #0xa023fa94
a01298a0 0010a0e3 mov r1, #0
a01298a4 0600a0e3 mov r0, #6
a01298a8 d30f02eb bl #0xa01ad7fc
a01298ac 0000a0e3 mov r0, #0
a01298b0 0240a0e3 mov r4, #2
a01298b4 d2a101eb bl #0xa0192004
a01298b8 28fbffea b #0xa0128560
a01298bc 4c0b0ce3 movw r0, #0xcb4c
a01298c0 742105e3 movw r2, #0x5174
a01298c4 53204ae3 movt r2, #0xa053
a01298c8 0e1103e3 movw r1, #0x310e
a01298cc 53004ae3 movt r0, #0xa053
a01298d0 05f605eb bl #0xa02a70ec
a01298d4 0000a0e3 mov r0, #0
a01298d8 74e2ffeb bl #0xa01222b0
a01298dc 0040a0e1 mov r4, r0
a01298e0 1efbffea b #0xa0128560
a01298e4 f80a0ce3 movw r0, #0xcaf8
a01298e8 742105e3 movw r2, #0x5174
a01298ec 0130a0e1 mov r3, r1
a01298f0 53204ae3 movt r2, #0xa053
a01298f4 0a1103e3 movw r1, #0x310a
a01298f8 00608de5 str r6, [sp]
a01298fc 53004ae3 movt r0, #0xa053
a0129900 f9f505eb bl #0xa02a70ec
a0129904 2ce4ffeb bl #0xa01229bc
a0129908 0040a0e1 mov r4, r0
a012990c 13fbffea b #0xa0128560
a0129910 0000a0e3 mov r0, #0
a0129914 98c8ffeb bl #0xa011bb7c
a0129918 0040a0e1 mov r4, r0
a012991c 0ffbffea b #0xa0128560
a0129920 0100a0e3 mov r0, #1
a0129924 94c8ffeb bl #0xa011bb7c
a0129928 0040a0e1 mov r4, r0
a012992c 0bfbffea b #0xa0128560
a0129930 b00a0ce3 movw r0, #0xcab0
a0129934 742105e3 movw r2, #0x5174
a0129938 53204ae3 movt r2, #0xa053
a012993c 311ca0e3 mov r1, #0x3100
a0129940 53004ae3 movt r0, #0xa053
a0129944 e8f505eb bl #0xa02a70ec
a0129948 83c9ffeb bl #0xa011bf5c
a012994c 0040a0e1 mov r4, r0
a0129950 02fbffea b #0xa0128560
a0129954 e0060ce3 movw r0, #0xc6e0
a0129958 742105e3 movw r2, #0x5174
a012995c 53204ae3 movt r2, #0xa053
a0129960 fc1003e3 movw r1, #0x30fc
a0129964 53004ae3 movt r0, #0xa053
a0129968 d88c05e3 movw r8, #0x5cd8
a012996c def505eb bl #0xa02a70ec
a0129970 58270ee3 movw r2, #0xe758
a0129974 f40c06e3 movw r0, #0x6cf4
a0129978 53204ae3 movt r2, #0xa053
a012997c b0630be3 movw r6, #0xb3b0
a0129980 0230a0e1 mov r3, r2
a0129984 69604ae3 movt r6, #0xa069
a0129988 e51b00e3 movw r1, #0xbe5
a012998c 53004ae3 movt r0, #0xa053
a0129990 05814ae3 movt r8, #0xa105
a0129994 4c7303e3 movw r7, #0x334c
a0129998 d3f505eb bl #0xa02a70ec
a012999c 18c096e5 ldr ip, [r6, #0x18]
a01299a0 00e0a0e3 mov lr, #0
a01299a4 0030d8e5 ldrb r3, [r8]
a01299a8 240d06e3 movw r0, #0x6d24
a01299ac 58270ee3 movw r2, #0xe758
a01299b0 fb704ae3 movt r7, #0xa0fb
a01299b4 02c3cce3 bic ip, ip, #0x8000000
a01299b8 53004ae3 movt r0, #0xa053
a01299bc d331e2e7 ubfx r3, r3, #3, #3
a01299c0 53204ae3 movt r2, #0xa053
a01299c4 00308de5 str r3, [sp]
a01299c8 e81b00e3 movw r1, #0xbe8
a01299cc 0e30a0e1 mov r3, lr
a01299d0 18c086e5 str ip, [r6, #0x18]
a01299d4 00e0c7e5 strb lr, [r7]
a01299d8 c3f505eb bl #0xa02a70ec
a01299dc 143096e5 ldr r3, [r6, #0x14]
a01299e0 044013e2 ands r4, r3, #4
a01299e4 9d02000a beq #0xa012a460
a01299e8 24070ce3 movw r0, #0xc724
a01299ec 58270ee3 movw r2, #0xe758
a01299f0 53004ae3 movt r0, #0xa053
a01299f4 53204ae3 movt r2, #0xa053
a01299f8 fc1b00e3 movw r1, #0xbfc
a01299fc baf505eb bl #0xa02a70ec
a0129a00 143096e5 ldr r3, [r6, #0x14]
a0129a04 100013e3 tst r3, #0x10
a0129a08 9102000a beq #0xa012a454
a0129a0c 183096e5 ldr r3, [r6, #0x18]
a0129a10 400013e3 tst r3, #0x40
a0129a14 8204000a beq #0xa012ac24
a0129a18 6c070ce3 movw r0, #0xc76c
a0129a1c 58270ee3 movw r2, #0xe758
a0129a20 011c00e3 movw r1, #0xc01
a0129a24 53204ae3 movt r2, #0xa053
a0129a28 53004ae3 movt r0, #0xa053
a0129a2c aef505eb bl #0xa02a70ec
a0129a30 183096e5 ldr r3, [r6, #0x18]
a0129a34 4030c3e3 bic r3, r3, #0x40
a0129a38 183086e5 str r3, [r6, #0x18]
a0129a3c d9caffeb bl #0xa011c5a8
a0129a40 001050e2 subs r1, r0, #0
a0129a44 8202001a bne #0xa012a454
a0129a48 183096e5 ldr r3, [r6, #0x18]
a0129a4c 20c013e2 ands ip, r3, #0x20
a0129a50 d105001a bne #0xa012b19c
a0129a54 142096e5 ldr r2, [r6, #0x14]
a0129a58 010913e3 tst r3, #0x4000
a0129a5c 0138c3e3 bic r3, r3, #0x10000
a0129a60 183086e5 str r3, [r6, #0x18]
a0129a64 1030c2e3 bic r3, r2, #0x10
a0129a68 143086e5 str r3, [r6, #0x14]
a0129a6c 0400000a beq #0xa0129a84
a0129a70 183097e5 ldr r3, [r7, #0x18]
a0129a74 5e00a0e3 mov r0, #0x5e
a0129a78 0c10a0e1 mov r1, ip
a0129a7c 0c20a0e1 mov r2, ip
a0129a80 33ff2fe1 blx r3
a0129a84 0000a0e3 mov r0, #0
a0129a88 5da101eb bl #0xa0192004
a0129a8c 143096e5 ldr r3, [r6, #0x14]
a0129a90 040013e3 tst r3, #4
a0129a94 2bfbff0a beq #0xa0128748
a0129a98 7c4003e3 movw r4, #0x307c
a0129a9c 6f404ae3 movt r4, #0xa06f
a0129aa0 66e7ffeb bl #0xa0123840
a0129aa4 0010a0e3 mov r1, #0
a0129aa8 183097e5 ldr r3, [r7, #0x18]
a0129aac 0120a0e1 mov r2, r1
a0129ab0 0600a0e3 mov r0, #6
a0129ab4 33ff2fe1 blx r3
a0129ab8 ac3098e5 ldr r3, [r8, #0xac]
a0129abc 0120a0e3 mov r2, #1
a0129ac0 002640e3 movt r2, #0x600
a0129ac4 d85c05e3 movw r5, #0x5cd8
a0129ac8 05514ae3 movt r5, #0xa105
a0129acc ff38c3e3 bic r3, r3, #0xff0000
a0129ad0 ff3cc3e3 bic r3, r3, #0xff00
a0129ad4 020053e1 cmp r3, r2
a0129ad8 b604000a beq #0xa012adb8
a0129adc 182096e5 ldr r2, [r6, #0x18]
a0129ae0 b0730be3 movw r7, #0xb3b0
a0129ae4 69704ae3 movt r7, #0xa069
a0129ae8 020312e3 tst r2, #0x8000000
a0129aec 3503001a bne #0xa012a7c8
a0129af0 02c3a0e3 mov ip, #0x8000000
a0129af4 f4090ce3 movw r0, #0xc9f4
a0129af8 58370ee3 movw r3, #0xe758
a0129afc 081094e5 ldr r1, [r4, #8]
a0129b00 53304ae3 movt r3, #0xa053
a0129b04 00208de5 str r2, [sp]
a0129b08 53004ae3 movt r0, #0xa053
a0129b0c 682c00e3 movw r2, #0xc68
a0129b10 04c08de5 str ip, [sp, #4]
a0129b14 74f505eb bl #0xa02a70ec
a0129b18 ac3095e5 ldr r3, [r5, #0xac]
a0129b1c 0110a0e3 mov r1, #1
a0129b20 001b40e3 movt r1, #0xb00
a0129b24 7c2003e3 movw r2, #0x307c
a0129b28 6f204ae3 movt r2, #0xa06f
a0129b2c ff38c3e3 bic r3, r3, #0xff0000
a0129b30 ff3cc3e3 bic r3, r3, #0xff00
a0129b34 010053e1 cmp r3, r1
a0129b38 7f05000a beq #0xa012b13c
a0129b3c c40298e5 ldr r0, [r8, #0x2c4]
a0129b40 0020a0e3 mov r2, #0
a0129b44 c81298e5 ldr r1, [r8, #0x2c8]
a0129b48 0130a0e3 mov r3, #1
a0129b4c 251900eb bl #0xa012ffe8
a0129b50 b1d5ffeb bl #0xa011f21c
a0129b54 010050e3 cmp r0, #1
a0129b58 0400001a bne #0xa0129b70
a0129b5c 143096e5 ldr r3, [r6, #0x14]
a0129b60 b0430be3 movw r4, #0xb3b0
a0129b64 69404ae3 movt r4, #0xa069
a0129b68 200013e2 ands r0, r3, #0x20
a0129b6c 8404000a beq #0xa012ad84
a0129b70 58270ee3 movw r2, #0xe758
a0129b74 c00307e3 movw r0, #0x73c0
a0129b78 53204ae3 movt r2, #0xa053
a0129b7c 53004ae3 movt r0, #0xa053
a0129b80 0230a0e1 mov r3, r2
a0129b84 7d1c00e3 movw r1, #0xc7d
a0129b88 57f505eb bl #0xa02a70ec
a0129b8c 0040a0e3 mov r4, #0
a0129b90 72faffea b #0xa0128560
a0129b94 b0630be3 movw r6, #0xb3b0
a0129b98 4c7303e3 movw r7, #0x334c
a0129b9c 69604ae3 movt r6, #0xa069
a0129ba0 183096e5 ldr r3, [r6, #0x18]
a0129ba4 024013e2 ands r4, r3, #2
a0129ba8 fb704a03 movteq r7, #0xa0fb
a0129bac bb02001a bne #0xa012a6a0
a0129bb0 0010a0e3 mov r1, #0
a0129bb4 d85c05e3 movw r5, #0x5cd8
a0129bb8 05514ae3 movt r5, #0xa105
a0129bbc 0120a0e1 mov r2, r1
a0129bc0 183097e5 ldr r3, [r7, #0x18]
a0129bc4 4e00a0e3 mov r0, #0x4e
a0129bc8 33ff2fe1 blx r3
a0129bcc 18c096e5 ldr ip, [r6, #0x18]
a0129bd0 4c060ce3 movw r0, #0xc64c
a0129bd4 0010d5e5 ldrb r1, [r5]
a0129bd8 e4250ee3 movw r2, #0xe5e4
a0129bdc 22e0d5e5 ldrb lr, [r5, #0x22]
a0129be0 53204ae3 movt r2, #0xa053
a0129be4 10c0cce3 bic ip, ip, #0x10
a0129be8 0030d7e5 ldrb r3, [r7]
a0129bec d111e2e7 ubfx r1, r1, #3, #3
a0129bf0 53004ae3 movt r0, #0xa053
a0129bf4 04e08de5 str lr, [sp, #4]
a0129bf8 00108de5 str r1, [sp]
a0129bfc c21b00e3 movw r1, #0xbc2
a0129c00 18c086e5 str ip, [r6, #0x18]
a0129c04 38f505eb bl #0xa02a70ec
a0129c08 a8060ce3 movw r0, #0xc6a8
a0129c0c e4250ee3 movw r2, #0xe5e4
a0129c10 53204ae3 movt r2, #0xa053
a0129c14 c31b00e3 movw r1, #0xbc3
a0129c18 183096e5 ldr r3, [r6, #0x18]
a0129c1c 53004ae3 movt r0, #0xa053
a0129c20 31f505eb bl #0xa02a70ec
a0129c24 0030d5e5 ldrb r3, [r5]
a0129c28 380013e2 ands r0, r3, #0x38
a0129c2c 0010a013 movne r1, #0
a0129c30 0010a001 moveq r1, r0
a0129c34 0120a011 movne r2, r1
a0129c38 0020a001 moveq r2, r0
a0129c3c 0100a013 movne r0, #1
a0129c40 66ceffeb bl #0xa011d5e0
a0129c44 0211a0e3 mov r1, #0x80000000
a0129c48 0000e0e3 mvn r0, #0
a0129c4c 4a3301eb bl #0xa017697c
a0129c50 143096e5 ldr r3, [r6, #0x14]
a0129c54 0010a0e3 mov r1, #0
a0129c58 0100a0e3 mov r0, #1
a0129c5c 8030c3e3 bic r3, r3, #0x80
a0129c60 143086e5 str r3, [r6, #0x14]
a0129c64 300c03eb bl #0xa01ecd2c
a0129c68 0010a0e1 mov r1, r0
a0129c6c 0100a0e3 mov r0, #1
a0129c70 8f0d03eb bl #0xa01ed2b4
a0129c74 0010a0e3 mov r1, #0
a0129c78 0200a0e3 mov r0, #2
a0129c7c 2a0c03eb bl #0xa01ecd2c
a0129c80 0010a0e1 mov r1, r0
a0129c84 0200a0e3 mov r0, #2
a0129c88 890d03eb bl #0xa01ed2b4
a0129c8c 0100a0e3 mov r0, #1
a0129c90 f10b03eb bl #0xa01ecc5c
a0129c94 0010a0e3 mov r1, #0
a0129c98 1c3097e5 ldr r3, [r7, #0x1c]
a0129c9c 0120a0e1 mov r2, r1
a0129ca0 0100a0e3 mov r0, #1
a0129ca4 33ff2fe1 blx r3
a0129ca8 0000a0e3 mov r0, #0
a0129cac 1c3097e5 ldr r3, [r7, #0x1c]
a0129cb0 0010a0e1 mov r1, r0
a0129cb4 0020a0e1 mov r2, r0
a0129cb8 33ff2fe1 blx r3
a0129cbc 27faffea b #0xa0128560
a0129cc0 10060ce3 movw r0, #0xc610
a0129cc4 742105e3 movw r2, #0x5174
a0129cc8 d45c05e3 movw r5, #0x5cd4
a0129ccc 53204ae3 movt r2, #0xa053
a0129cd0 f51003e3 movw r1, #0x30f5
a0129cd4 05514ae3 movt r5, #0xa105
a0129cd8 53004ae3 movt r0, #0xa053
a0129cdc d88c05e3 movw r8, #0x5cd8
a0129ce0 01f505eb bl #0xa02a70ec
a0129ce4 002095e5 ldr r2, [r5]
a0129ce8 05814ae3 movt r8, #0xa105
a0129cec 0030d8e5 ldrb r3, [r8]
a0129cf0 0100a0e3 mov r0, #1
a0129cf4 0210a0e3 mov r1, #2
a0129cf8 0200c2e5 strb r0, [r2, #2]
a0129cfc 002095e5 ldr r2, [r5]
a0129d00 9131c5e7 bfi r3, r1, #3, #3
a0129d04 0030c8e5 strb r3, [r8]
a0129d08 9a30d2e5 ldrb r3, [r2, #0x9a]
a0129d0c 010053e1 cmp r3, r1
a0129d10 7f03000a beq #0xa012ab14
a0129d14 d43404e3 movw r3, #0x44d4
a0129d18 4c7303e3 movw r7, #0x334c
a0129d1c 6d304ae3 movt r3, #0xa06d
a0129d20 fb704ae3 movt r7, #0xa0fb
a0129d24 000093e5 ldr r0, [r3]
a0129d28 d84c05e3 movw r4, #0x5cd8
a0129d2c 651c00eb bl #0xa0130ec8
a0129d30 0200a0e3 mov r0, #2
a0129d34 05414ae3 movt r4, #0xa105
a0129d38 9c6203eb bl #0xa02027b0
a0129d3c 0130a0e3 mov r3, #1
a0129d40 b730c8e5 strb r3, [r8, #0xb7]
a0129d44 87c901eb bl #0xa019c368
a0129d48 7000ffe6 uxth r0, r0
a0129d4c bfef03eb bl #0xa0225c50
a0129d50 84c901eb bl #0xa019c368
a0129d54 0031a0e1 lsl r3, r0, #2
a0129d58 000263e0 rsb r0, r3, r0, lsl #4
a0129d5c 000260e0 rsb r0, r0, r0, lsl #4
a0129d60 05bcffeb bl #0xa0118d7c
a0129d64 066303eb bl #0xa0202984
a0129d68 2c3097e5 ldr r3, [r7, #0x2c]
a0129d6c 010053e3 cmp r3, #1
a0129d70 0020d405 ldrbeq r2, [r4]
a0129d74 9321c507 bfieq r2, r3, #3, #3
a0129d78 003095e5 ldr r3, [r5]
a0129d7c 0020c405 strbeq r2, [r4]
a0129d80 3601d3e5 ldrb r0, [r3, #0x136]
a0129d84 010050e3 cmp r0, #1
a0129d88 0000a013 movne r0, #0
a0129d8c 002702eb bl #0xa01b3994
a0129d90 2230d8e5 ldrb r3, [r8, #0x22]
a0129d94 080053e3 cmp r3, #8
a0129d98 03f19f97 ldrls pc, [pc, r3, lsl #2]
a0129d9c dc0000ea b #0xa012a114
a0129dc4 a8060de3 movw r0, #0xd6a8
a0129dc8 742105e3 movw r2, #0x5174
a0129dcc 53204ae3 movt r2, #0xa053
a0129dd0 8c1103e3 movw r1, #0x318c
a0129dd4 53004ae3 movt r0, #0xa053
a0129dd8 c3f405eb bl #0xa02a70ec
a0129ddc 0500a0e1 mov r0, r5
a0129de0 e4d1ffeb bl #0xa011e578
a0129de4 0040a0e1 mov r4, r0
a0129de8 dcf9ffea b #0xa0128560
a0129dec 0100a0e1 mov r0, r1
a0129df0 d88c05e3 movw r8, #0x5cd8
a0129df4 84a703eb bl #0xa0213c0c
a0129df8 70060de3 movw r0, #0xd670
a0129dfc d0260ee3 movw r2, #0xe6d0
a0129e00 0530a0e1 mov r3, r5
a0129e04 05814ae3 movt r8, #0xa105
a0129e08 53004ae3 movt r0, #0xa053
a0129e0c 53204ae3 movt r2, #0xa053
a0129e10 441f00e3 movw r1, #0xf44
a0129e14 b4f405eb bl #0xa02a70ec
a0129e18 0030d8e5 ldrb r3, [r8]
a0129e1c 383003e2 and r3, r3, #0x38
a0129e20 080053e3 cmp r3, #8
a0129e24 1630d8e5 ldrb r3, [r8, #0x16]
a0129e28 2f02000a beq #0xa012a6ec
a0129e2c 020013e3 tst r3, #2
a0129e30 0900000a beq #0xa0129e5c
a0129e34 4c3303e3 movw r3, #0x334c
a0129e38 fb304ae3 movt r3, #0xa0fb
a0129e3c 0020d3e5 ldrb r2, [r3]
a0129e40 050052e3 cmp r2, #5
a0129e44 0400000a beq #0xa0129e5c
a0129e48 0010a0e3 mov r1, #0
a0129e4c 183093e5 ldr r3, [r3, #0x18]
a0129e50 0120a0e1 mov r2, r1
a0129e54 8300a0e3 mov r0, #0x83
a0129e58 33ff2fe1 blx r3
a0129e5c 07a501eb bl #0xa0193280
a0129e60 2230d8e5 ldrb r3, [r8, #0x22]
a0129e64 030053e3 cmp r3, #3
a0129e68 ad01008a bhi #0xa012a524
a0129e6c 1da803eb bl #0xa0213ee8
a0129e70 093001e3 movw r3, #0x1009
a0129e74 0040a0e3 mov r4, #0
a0129e78 033050e0 subs r3, r0, r3
a0129e7c 0130a013 movne r3, #1
a0129e80 dc32c8e5 strb r3, [r8, #0x2dc]
a0129e84 b5f9ffea b #0xa0128560
a0129e88 52d3ffeb bl #0xa011ebd8
a0129e8c 0040a0e3 mov r4, #0
a0129e90 b2f9ffea b #0xa0128560
a0129e94 04c2ffeb bl #0xa011a6ac
a0129e98 0040a0e1 mov r4, r0
a0129e9c aff9ffea b #0xa0128560
a0129ea0 b8c1ffeb bl #0xa011a588
a0129ea4 0040a0e1 mov r4, r0
a0129ea8 acf9ffea b #0xa0128560
a0129eac 035041e2 sub r5, r1, #3
a0129eb0 070055e3 cmp r5, #7
a0129eb4 23faff8a bhi #0xa0128748
a0129eb8 103505e3 movw r3, #0x5510
a0129ebc 53304ae3 movt r3, #0xa053
a0129ec0 054193e7 ldr r4, [r3, r5, lsl #2]
a0129ec4 a5f9ffea b #0xa0128560
a0129ec8 7110efe6 uxtb r1, r1
a0129ecc 0200a0e3 mov r0, #2
a0129ed0 0020a0e3 mov r2, #0
a0129ed4 76ec03eb bl #0xa02250b4
a0129ed8 0040a0e3 mov r4, #0
a0129edc 9ff9ffea b #0xa0128560
a0129ee0 4c7303e3 movw r7, #0x334c
a0129ee4 0010a0e3 mov r1, #0
a0129ee8 fb704ae3 movt r7, #0xa0fb
a0129eec 0120a0e1 mov r2, r1
a0129ef0 183097e5 ldr r3, [r7, #0x18]
a0129ef4 4e00a0e3 mov r0, #0x4e
a0129ef8 33ff2fe1 blx r3
a0129efc b0330be3 movw r3, #0xb3b0
a0129f00 69304ae3 movt r3, #0xa069
a0129f04 183093e5 ldr r3, [r3, #0x18]
a0129f08 020013e3 tst r3, #2
a0129f0c 0400000a beq #0xa0129f24
a0129f10 0010a0e3 mov r1, #0
a0129f14 183097e5 ldr r3, [r7, #0x18]
a0129f18 0120a0e1 mov r2, r1
a0129f1c 0800a0e3 mov r0, #8
a0129f20 33ff2fe1 blx r3
a0129f24 0040a0e3 mov r4, #0
a0129f28 144087e5 str r4, [r7, #0x14]
a0129f2c 8bf9ffea b #0xa0128560
a0129f30 4eef03eb bl #0xa0225c70
a0129f34 eacb03eb bl #0xa021cee4
a0129f38 2ba403eb bl #0xa0212fec
a0129f3c 249803eb bl #0xa020ffd4
a0129f40 939d03eb bl #0xa0211594
a0129f44 0700a0e3 mov r0, #7
a0129f48 0310a0e3 mov r1, #3
a0129f4c e8b509eb bl #0xa03976f4
a0129f50 0c00a0e3 mov r0, #0xc
a0129f54 0310a0e3 mov r1, #3
a0129f58 e7b509eb bl #0xa03976fc
a0129f5c 4c3303e3 movw r3, #0x334c
a0129f60 d8050ce3 movw r0, #0xc5d8
a0129f64 ec280ee3 movw r2, #0xe8ec
a0129f68 fb304ae3 movt r3, #0xa0fb
a0129f6c 00c0e0e3 mvn ip, #0
a0129f70 0040a0e3 mov r4, #0
a0129f74 53004ae3 movt r0, #0xa053
a0129f78 53204ae3 movt r2, #0xa053
a0129f7c b31a00e3 movw r1, #0xab3
a0129f80 00c0c3e5 strb ip, [r3]
a0129f84 144083e5 str r4, [r3, #0x14]
a0129f88 57f405eb bl #0xa02a70ec
a0129f8c d43c05e3 movw r3, #0x5cd4
a0129f90 05314ae3 movt r3, #0xa105
a0129f94 003093e5 ldr r3, [r3]
a0129f98 0d30d3e5 ldrb r3, [r3, #0xd]
a0129f9c 010053e3 cmp r3, #1
a0129fa0 e8f9ff1a bne #0xa0128748
a0129fa4 0600a0e3 mov r0, #6
a0129fa8 aa6a04eb bl #0xa0244a58
a0129fac 6bf9ffea b #0xa0128560
a0129fb0 24060de3 movw r0, #0xd624
a0129fb4 742105e3 movw r2, #0x5174
a0129fb8 53004ae3 movt r0, #0xa053
a0129fbc 53204ae3 movt r2, #0xa053
a0129fc0 731103e3 movw r1, #0x3173
a0129fc4 48f405eb bl #0xa02a70ec
a0129fc8 000055e3 cmp r5, #0
a0129fcc a900000a beq #0xa012a278
a0129fd0 0000a0e3 mov r0, #0
a0129fd4 0010a0e1 mov r1, r0
a0129fd8 0020a0e1 mov r2, r0
a0129fdc 0040a0e1 mov r4, r0
a0129fe0 7ecdffeb bl #0xa011d5e0
a0129fe4 0100a0e3 mov r0, #1
a0129fe8 ead503eb bl #0xa021f798
a0129fec 69ce03eb bl #0xa021d998
a0129ff0 6ad003eb bl #0xa021e1a0
a0129ff4 59f9ffea b #0xa0128560
a0129ff8 54050de3 movw r0, #0xd554
a0129ffc 742105e3 movw r2, #0x5174
a012a000 53204ae3 movt r2, #0xa053
a012a004 6f1103e3 movw r1, #0x316f
a012a008 53004ae3 movt r0, #0xa053
a012a00c 36f405eb bl #0xa02a70ec
a012a010 0fd603eb bl #0xa021f854
a012a014 453040e2 sub r3, r0, #0x45
a012a018 0040a0e1 mov r4, r0
a012a01c 120053e3 cmp r3, #0x12
a012a020 a601009a bls #0xa012a6c0
a012a024 d8050de3 movw r0, #0xd5d8
a012a028 fc1305e3 movw r1, #0x53fc
a012a02c 53004ae3 movt r0, #0xa053
a012a030 53104ae3 movt r1, #0xa053
a012a034 0520a0e1 mov r2, r5
a012a038 2bf405eb bl #0xa02a70ec
a012a03c 0a0055e3 cmp r5, #0xa
a012a040 5801000a beq #0xa012a5a8
a012a044 5101008a bhi #0xa012a590
a012a048 020055e3 cmp r5, #2
a012a04c 5501009a bls #0xa012a5a8
a012a050 040055e3 cmp r5, #4
a012a054 5301000a beq #0xa012a5a8
a012a058 ec050de3 movw r0, #0xd5ec
a012a05c fc1305e3 movw r1, #0x53fc
a012a060 53104ae3 movt r1, #0xa053
a012a064 53004ae3 movt r0, #0xa053
a012a068 1ff405eb bl #0xa02a70ec
a012a06c 3bf9ffea b #0xa0128560
a012a070 0100a0e1 mov r0, r1
a012a074 eda603eb bl #0xa0213c30
a012a078 000055e3 cmp r5, #0
a012a07c 0540a001 moveq r4, r5
a012a080 36f9ff0a beq #0xa0128560
a012a084 010055e3 cmp r5, #1
a012a088 0140a003 moveq r4, #1
a012a08c 0240a013 movne r4, #2
a012a090 32f9ffea b #0xa0128560
a012a094 0040a0e3 mov r4, #0
a012a098 30f9ffea b #0xa0128560
a012a09c dc040de3 movw r0, #0xd4dc
a012a0a0 742105e3 movw r2, #0x5174
a012a0a4 53004ae3 movt r0, #0xa053
a012a0a8 53204ae3 movt r2, #0xa053
a012a0ac 691103e3 movw r1, #0x3169
a012a0b0 0df405eb bl #0xa02a70ec
a012a0b4 4c3303e3 movw r3, #0x334c
a012a0b8 fb304ae3 movt r3, #0xa0fb
a012a0bc 0030d3e5 ldrb r3, [r3]
a012a0c0 050053e3 cmp r3, #5
a012a0c4 a202000a beq #0xa012ab54
a012a0c8 013043e2 sub r3, r3, #1
a012a0cc 010053e3 cmp r3, #1
a012a0d0 f504009a bls #0xa012b4ac
a012a0d4 0500a0e1 mov r0, r5
a012a0d8 98d503eb bl #0xa021f740
a012a0dc 000055e3 cmp r5, #0
a012a0e0 0540a001 moveq r4, r5
a012a0e4 0200000a beq #0xa012a0f4
a012a0e8 010055e3 cmp r5, #1
a012a0ec 0140a003 moveq r4, #1
a012a0f0 0240a013 movne r4, #2
a012a0f4 61a401eb bl #0xa0193280
a012a0f8 e2c0ffeb bl #0xa011a488
a012a0fc 17f9ffea b #0xa0128560
a012a100 17b9ffeb bl #0xa0118564
a012a104 0040a0e1 mov r4, r0
a012a108 14f9ffea b #0xa0128560
a012a10c 3f30e0e3 mvn r3, #0x3f
a012a110 2d30c8e5 strb r3, [r8, #0x2d]
a012a114 0010a0e3 mov r1, #0
a012a118 1904a0e3 mov r0, #0x19000000
a012a11c 2ae403eb bl #0xa02231cc
a012a120 0010a0e3 mov r1, #0
a012a124 1904a0e3 mov r0, #0x19000000
a012a128 1f6b03eb bl #0xa0204dac
a012a12c 183097e5 ldr r3, [r7, #0x18]
a012a130 0120a0e3 mov r2, #1
a012a134 2210d8e5 ldrb r1, [r8, #0x22]
a012a138 6300a0e3 mov r0, #0x63
a012a13c 33ff2fe1 blx r3
a012a140 91f402eb bl #0xa01e738c
a012a144 093804eb bl #0xa0238170
a012a148 002095e5 ldr r2, [r5]
a012a14c 323100e3 movw r3, #0x132
a012a150 0040a0e3 mov r4, #0
a012a154 b30092e1 ldrh r0, [r2, r3]
a012a158 9aa001eb bl #0xa01923c8
a012a15c 92d503eb bl #0xa021f7ac
a012a160 fef8ffea b #0xa0128560
a012a164 2030a0e3 mov r3, #0x20
a012a168 2d30c8e5 strb r3, [r8, #0x2d]
a012a16c e8ffffea b #0xa012a114
a012a170 6030a0e3 mov r3, #0x60
a012a174 2d30c8e5 strb r3, [r8, #0x2d]
a012a178 e5ffffea b #0xa012a114
a012a17c 7f30e0e3 mvn r3, #0x7f
a012a180 2d30c8e5 strb r3, [r8, #0x2d]
a012a184 e2ffffea b #0xa012a114
a012a188 4030a0e3 mov r3, #0x40
a012a18c 2d30c8e5 strb r3, [r8, #0x2d]
a012a190 dfffffea b #0xa012a114
a012a194 003095e5 ldr r3, [r5]
a012a198 0410a0e3 mov r1, #4
a012a19c 1c20d3e5 ldrb r2, [r3, #0x1c]
a012a1a0 9121c5e7 bfi r2, r1, #3, #3
a012a1a4 1c20c3e5 strb r2, [r3, #0x1c]
a012a1a8 d9ffffea b #0xa012a114
a012a1ac 003095e5 ldr r3, [r5]
a012a1b0 1c20d3e5 ldrb r2, [r3, #0x1c]
a012a1b4 9f21c5e7 bfc r2, #3, #3
a012a1b8 1c20c3e5 strb r2, [r3, #0x1c]
a012a1bc d4ffffea b #0xa012a114
a012a1c0 003095e5 ldr r3, [r5]
a012a1c4 0110a0e3 mov r1, #1
a012a1c8 1c20d3e5 ldrb r2, [r3, #0x1c]
a012a1cc 9121c5e7 bfi r2, r1, #3, #3
a012a1d0 1c20c3e5 strb r2, [r3, #0x1c]
a012a1d4 ceffffea b #0xa012a114
a012a1d8 003095e5 ldr r3, [r5]
a012a1dc 0210a0e3 mov r1, #2
a012a1e0 1c20d3e5 ldrb r2, [r3, #0x1c]
a012a1e4 9121c5e7 bfi r2, r1, #3, #3
a012a1e8 1c20c3e5 strb r2, [r3, #0x1c]
a012a1ec c8ffffea b #0xa012a114
a012a1f0 2200d8e5 ldrb r0, [r8, #0x22]
a012a1f4 0410a0e3 mov r1, #4
a012a1f8 44efffeb bl #0xa0125f10
a012a1fc b0330be3 movw r3, #0xb3b0
a012a200 0050d7e5 ldrb r5, [r7]
a012a204 69304ae3 movt r3, #0xa069
a012a208 d86c05e3 movw r6, #0x5cd8
a012a20c 182093e5 ldr r2, [r3, #0x18]
a012a210 4c4303e3 movw r4, #0x334c
a012a214 050055e3 cmp r5, #5
a012a218 05614ae3 movt r6, #0xa105
a012a21c fb404ae3 movt r4, #0xa0fb
a012a220 022282e3 orr r2, r2, #0x20000000
a012a224 182083e5 str r2, [r3, #0x18]
a012a228 5103000a beq #0xa012af74
a012a22c 000055e3 cmp r5, #0
a012a230 44f9ff1a bne #0xa0128748
a012a234 a06603e3 movw r6, #0x36a0
a012a238 a83207e3 movw r3, #0x72a8
a012a23c fb604ae3 movt r6, #0xa0fb
a012a240 11304ae3 movt r3, #0xa011
a012a244 003086e5 str r3, [r6]
a012a248 0540a0e1 mov r4, r5
a012a24c 55f3ffeb bl #0xa0126fa8
a012a250 005086e5 str r5, [r6]
a012a254 c1f8ffea b #0xa0128560
a012a258 90000ee3 movw r0, #0xe090
a012a25c d82305e3 movw r2, #0x53d8
a012a260 53204ae3 movt r2, #0xa053
a012a264 a61d02e3 movw r1, #0x2da6
a012a268 53004ae3 movt r0, #0xa053
a012a26c 0040a0e3 mov r4, #0
a012a270 9df305eb bl #0xa02a70ec
a012a274 b9f8ffea b #0xa0128560
a012a278 0510a0e1 mov r1, r5
a012a27c 0520a0e1 mov r2, r5
a012a280 0500a0e1 mov r0, r5
a012a284 0540a0e1 mov r4, r5
a012a288 d4ccffeb bl #0xa011d5e0
a012a28c 0500a0e1 mov r0, r5
a012a290 40d503eb bl #0xa021f798
a012a294 bfcd03eb bl #0xa021d998
a012a298 c0cf03eb bl #0xa021e1a0
a012a29c aff8ffea b #0xa0128560
a012a2a0 646046e2 sub r6, r6, #0x64
a012a2a4 0500a0e1 mov r0, r5
a012a2a8 0681a0e1 lsl r8, r6, #2
a012a2ac 0652a0e1 lsl r5, r6, #4
a012a2b0 fa360ffa blx #0xa04f7ea0
a012a2b4 053068e0 rsb r3, r8, r5
a012a2b8 dc730be3 movw r7, #0xb3dc
a012a2bc 833163e0 rsb r3, r3, r3, lsl #3
a012a2c0 69704ae3 movt r7, #0xa069
a012a2c4 0b0056e3 cmp r6, #0xb
a012a2c8 0c008de5 str r0, [sp, #0xc]
a012a2cc 033087e0 add r3, r7, r3
a012a2d0 409093e5 ldr sb, [r3, #0x40]
a012a2d4 f90300ca bgt #0xa012b2c0
a012a2d8 d4a404e3 movw sl, #0x44d4
a012a2dc d44600e3 movw r4, #0x6d4
a012a2e0 6da04ae3 movt sl, #0xa06d
a012a2e4 6b404ae3 movt r4, #0xa06b
a012a2e8 00b0a0e3 mov fp, #0
a012a2ec 020000ea b #0xa012a2fc
a012a2f0 b36003eb bl #0xa02025c4
a012a2f4 64005be3 cmp fp, #0x64
a012a2f8 0a00000a beq #0xa012a328
a012a2fc 00109ae5 ldr r1, [sl]
a012a300 0100a0e3 mov r0, #1
a012a304 0132a0e1 lsl r3, r1, #4
a012a308 013183e0 add r3, r3, r1, lsl #2
a012a30c 033183e0 add r3, r3, r3, lsl #2
a012a310 0b3083e0 add r3, r3, fp
a012a314 00b08be0 add fp, fp, r0
a012a318 1330a0e1 lsl r3, r3, r0
a012a31c b33094e1 ldrh r3, [r4, r3]
a012a320 001053e2 subs r1, r3, #0
a012a324 f1ffff1a bne #0xa012a2f0
a012a328 0100a0e3 mov r0, #1
a012a32c 1f6103eb bl #0xa02027b0
a012a330 0c309de5 ldr r3, [sp, #0xc]
a012a334 000053e3 cmp r3, #0
a012a338 6201000a beq #0xa012a8c8
a012a33c 1f0059e3 cmp sb, #0x1f
a012a340 8620a0e1 lsl r2, r6, #1
a012a344 8661a0e1 lsl r6, r6, #3
a012a348 0d0000ca bgt #0xa012a384
a012a34c 063062e0 rsb r3, r2, r6
a012a350 050068e0 rsb r0, r8, r5
a012a354 83c163e0 rsb ip, r3, r3, lsl #3
a012a358 800160e0 rsb r0, r0, r0, lsl #3
a012a35c 901f9fe5 ldr r1, [pc, #0xf90]
a012a360 063149e2 sub r3, sb, #0x80000001
a012a364 0c3083e0 add r3, r3, ip
a012a368 3ec080e2 add ip, r0, #0x3e
a012a36c 833087e0 add r3, r7, r3, lsl #1
a012a370 0cc087e0 add ip, r7, ip
a012a374 0100f1e5 ldrb r0, [r1, #1]!
a012a378 b200e3e1 strh r0, [r3, #2]!
a012a37c 0c0053e1 cmp r3, ip
a012a380 fbffff1a bne #0xa012a374
a012a384 066062e0 rsb r6, r2, r6
a012a388 054068e0 rsb r4, r8, r5
a012a38c 866166e0 rsb r6, r6, r6, lsl #3
a012a390 844164e0 rsb r4, r4, r4, lsl #3
a012a394 093086e0 add r3, r6, sb
a012a398 044087e0 add r4, r7, r4
a012a39c 073083e2 add r3, r3, #7
a012a3a0 00c0a0e3 mov ip, #0
a012a3a4 8330a0e1 lsl r3, r3, #1
a012a3a8 441094e5 ldr r1, [r4, #0x44]
a012a3ac 0420a0e1 mov r2, r4
a012a3b0 0c00a0e1 mov r0, ip
a012a3b4 b3c087e1 strh ip, [r7, r3]
a012a3b8 e65e03eb bl #0xa0201f58
a012a3bc 442094e5 ldr r2, [r4, #0x44]
a012a3c0 0100a0e3 mov r0, #1
a012a3c4 481094e5 ldr r1, [r4, #0x48]
a012a3c8 b05e03eb bl #0xa0201e90
a012a3cc 055068e0 rsb r5, r8, r5
a012a3d0 0100a0e3 mov r0, #1
a012a3d4 855165e0 rsb r5, r5, r5, lsl #3
a012a3d8 0040a0e3 mov r4, #0
a012a3dc 057087e0 add r7, r7, r5
a012a3e0 481097e5 ldr r1, [r7, #0x48]
a012a3e4 b75f03eb bl #0xa02022c8
a012a3e8 0100a0e3 mov r0, #1
a012a3ec ef6003eb bl #0xa02027b0
a012a3f0 5af8ffea b #0xa0128560
a012a3f4 000053e3 cmp r3, #0
a012a3f8 fd01001a bne #0xa012abf4
a012a3fc 5ed6ffeb bl #0xa011fd7c
a012a400 002050e2 subs r2, r0, #0
a012a404 1001001a bne #0xa012a84c
a012a408 183094e5 ldr r3, [r4, #0x18]
a012a40c 3a00a0e3 mov r0, #0x3a
a012a410 0110a0e3 mov r1, #1
a012a414 33ff2fe1 blx r3
a012a418 004050e2 subs r4, r0, #0
a012a41c 0701000a beq #0xa012a840
a012a420 480b05e3 movw r0, #0x5b48
a012a424 94290ee3 movw r2, #0xe994
a012a428 271e00e3 movw r1, #0xe27
a012a42c 53204ae3 movt r2, #0xa053
a012a430 53004ae3 movt r0, #0xa053
a012a434 2cf305eb bl #0xa02a70ec
a012a438 0400a0e1 mov r0, r4
a012a43c a1f300eb bl #0xa01672c8
a012a440 0010a0e1 mov r1, r0
a012a444 000055e3 cmp r5, #0
a012a448 9602001a bne #0xa012aea8
a012a44c 0040e0e3 mvn r4, #0
a012a450 42f8ffea b #0xa0128560
a012a454 7c4003e3 movw r4, #0x307c
a012a458 6f404ae3 movt r4, #0xa06f
a012a45c 90fdffea b #0xa0129aa4
a012a460 98080ce3 movw r0, #0xc898
a012a464 58270ee3 movw r2, #0xe758
a012a468 53204ae3 movt r2, #0xa053
a012a46c 381c00e3 movw r1, #0xc38
a012a470 53004ae3 movt r0, #0xa053
a012a474 1cf305eb bl #0xa02a70ec
a012a478 143096e5 ldr r3, [r6, #0x14]
a012a47c 0410a0e1 mov r1, r4
a012a480 18c097e5 ldr ip, [r7, #0x18]
a012a484 0420a0e1 mov r2, r4
a012a488 4400a0e3 mov r0, #0x44
a012a48c 043083e3 orr r3, r3, #4
a012a490 143086e5 str r3, [r6, #0x14]
a012a494 3cff2fe1 blx ip
a012a498 0400a0e1 mov r0, r4
a012a49c e49d01eb bl #0xa0191c34
a012a4a0 143096e5 ldr r3, [r6, #0x14]
a012a4a4 040013e3 tst r3, #4
a012a4a8 a6f8ff0a beq #0xa0128748
a012a4ac 73a301eb bl #0xa0193280
a012a4b0 183097e5 ldr r3, [r7, #0x18]
a012a4b4 4b00a0e3 mov r0, #0x4b
a012a4b8 0410a0e1 mov r1, r4
a012a4bc 0420a0e1 mov r2, r4
a012a4c0 33ff2fe1 blx r3
a012a4c4 d43404e3 movw r3, #0x44d4
a012a4c8 6d304ae3 movt r3, #0xa06d
a012a4cc 003093e5 ldr r3, [r3]
a012a4d0 1b0053e3 cmp r3, #0x1b
a012a4d4 06005313 cmpne r3, #6
a012a4d8 c002000a beq #0xa012afe0
a012a4dc b76affeb bl #0xa0104fc0
a012a4e0 feab01eb bl #0xa01954e0
a012a4e4 36bd01eb bl #0xa01999c4
a012a4e8 000050e3 cmp r0, #0
a012a4ec d8ffff0a beq #0xa012a454
a012a4f0 0030d8e5 ldrb r3, [r8]
a012a4f4 7c4003e3 movw r4, #0x307c
a012a4f8 380013e3 tst r3, #0x38
a012a4fc ca02001a bne #0xa012b02c
a012a500 dc080ce3 movw r0, #0xc8dc
a012a504 6f404ae3 movt r4, #0xa06f
a012a508 53004ae3 movt r0, #0xa053
a012a50c 081094e5 ldr r1, [r4, #8]
a012a510 f5f205eb bl #0xa02a70ec
a012a514 183096e5 ldr r3, [r6, #0x18]
a012a518 013783e3 orr r3, r3, #0x40000
a012a51c 183086e5 str r3, [r6, #0x18]
a012a520 5ffdffea b #0xa0129aa4
a012a524 87e7ffeb bl #0xa0124348
a012a528 19dd03eb bl #0xa0221994
a012a52c 4ffeffea b #0xa0129e70
a012a530 c4020ee3 movw r0, #0xe2c4
a012a534 0040a0e3 mov r4, #0
a012a538 53004ae3 movt r0, #0xa053
a012a53c eaf205eb bl #0xa02a70ec
a012a540 3200a0e3 mov r0, #0x32
a012a544 75470aeb bl #0xa03bc320
a012a548 050001e3 movw r0, #0x1005
a012a54c 0510a0e1 mov r1, r5
a012a550 0620a0e1 mov r2, r6
a012a554 00024ee3 movt r0, #0xe200
a012a558 0ef002eb bl #0xa01e6598
a012a55c fff7ffea b #0xa0128560
a012a560 0410a0e1 mov r1, r4
a012a564 0420a0e1 mov r2, r4
a012a568 0400a0e1 mov r0, r4
a012a56c 1bccffeb bl #0xa011d5e0
a012a570 0500a0e1 mov r0, r5
a012a574 8e9603eb bl #0xa020ffb4
a012a578 06cd03eb bl #0xa021d998
a012a57c 0400a0e1 mov r0, r4
a012a580 0420a0e1 mov r2, r4
a012a584 0110a0e3 mov r1, #1
a012a588 cdcfffeb bl #0xa011e4c4
a012a58c 4dfbffea b #0xa01292c8
a012a590 3c0055e3 cmp r5, #0x3c
a012a594 0300000a beq #0xa012a5a8
a012a598 780055e3 cmp r5, #0x78
a012a59c 0100000a beq #0xa012a5a8
a012a5a0 140055e3 cmp r5, #0x14
a012a5a4 abfeff1a bne #0xa012a058
a012a5a8 0500a0e1 mov r0, r5
a012a5ac 74d403eb bl #0xa021f784
a012a5b0 0040a0e1 mov r4, r0
a012a5b4 e9f7ffea b #0xa0128560
a012a5b8 0400a0e1 mov r0, r4
a012a5bc 89d003eb bl #0xa021e7e8
a012a5c0 d83c05e3 movw r3, #0x5cd8
a012a5c4 05314ae3 movt r3, #0xa105
a012a5c8 ac30d3e5 ldrb r3, [r3, #0xac]
a012a5cc 000053e3 cmp r3, #0
a012a5d0 4301001a bne #0xa012aae4
a012a5d4 83d803eb bl #0xa02207e8
a012a5d8 d8090de3 movw r0, #0xd9d8
a012a5dc 7c270ee3 movw r2, #0xe77c
a012a5e0 53204ae3 movt r2, #0xa053
a012a5e4 a81102e3 movw r1, #0x21a8
a012a5e8 53004ae3 movt r0, #0xa053
a012a5ec bef205eb bl #0xa02a70ec
a012a5f0 9c0e05e3 movw r0, #0x5e9c
a012a5f4 7c270ee3 movw r2, #0xe77c
a012a5f8 53204ae3 movt r2, #0xa053
a012a5fc a91102e3 movw r1, #0x21a9
a012a600 53004ae3 movt r0, #0xa053
a012a604 b8f205eb bl #0xa02a70ec
a012a608 d00e05e3 movw r0, #0x5ed0
a012a60c 7c270ee3 movw r2, #0xe77c
a012a610 53004ae3 movt r0, #0xa053
a012a614 53204ae3 movt r2, #0xa053
a012a618 aa1102e3 movw r1, #0x21aa
a012a61c b2f205eb bl #0xa02a70ec
a012a620 d43c05e3 movw r3, #0x5cd4
a012a624 05314ae3 movt r3, #0xa105
a012a628 003093e5 ldr r3, [r3]
a012a62c 0d00d3e5 ldrb r0, [r3, #0xd]
a012a630 010050e3 cmp r0, #1
a012a634 8502000a beq #0xa012b050
a012a638 040a0de3 movw r0, #0xda04
a012a63c 7c270ee3 movw r2, #0xe77c
a012a640 0630a0e3 mov r3, #6
a012a644 53004ae3 movt r0, #0xa053
a012a648 53204ae3 movt r2, #0xa053
a012a64c ae1102e3 movw r1, #0x21ae
a012a650 0030c7e5 strb r3, [r7]
a012a654 a4f205eb bl #0xa02a70ec
a012a658 91e0ffeb bl #0xa01228a4
a012a65c 0040a0e3 mov r4, #0
a012a660 bef7ffea b #0xa0128560
a012a664 050050e3 cmp r0, #5
a012a668 36f8ff1a bne #0xa0128748
a012a66c 000000ea b #0xa012a674
a012a670 2a470aeb bl #0xa03bc320
a012a674 7ba006eb bl #0xa02d2868
a012a678 000050e3 cmp r0, #0
a012a67c 0100a0e3 mov r0, #1
a012a680 faffff0a beq #0xa012a670
a012a684 0010a0e3 mov r1, #0
a012a688 183097e5 ldr r3, [r7, #0x18]
a012a68c 0120a0e1 mov r2, r1
a012a690 5700a0e3 mov r0, #0x57
a012a694 33ff2fe1 blx r3
a012a698 0040a0e1 mov r4, r0
a012a69c aff7ffea b #0xa0128560
a012a6a0 0010a0e3 mov r1, #0
a012a6a4 fb704ae3 movt r7, #0xa0fb
a012a6a8 0120a0e1 mov r2, r1
a012a6ac 183097e5 ldr r3, [r7, #0x18]
a012a6b0 0800a0e3 mov r0, #8
a012a6b4 33ff2fe1 blx r3
a012a6b8 0040a0e1 mov r4, r0
a012a6bc 3bfdffea b #0xa0129bb0
a012a6c0 9c050de3 movw r0, #0xd59c
a012a6c4 53004ae3 movt r0, #0xa053
a012a6c8 87f205eb bl #0xa02a70ec
a012a6cc d8050de3 movw r0, #0xd5d8
a012a6d0 fc1305e3 movw r1, #0x53fc
a012a6d4 53004ae3 movt r0, #0xa053
a012a6d8 53104ae3 movt r1, #0xa053
a012a6dc 0020a0e3 mov r2, #0
a012a6e0 81f205eb bl #0xa02a70ec
a012a6e4 0000a0e3 mov r0, #0
a012a6e8 afffffea b #0xa012a5ac
a012a6ec 020013e3 tst r3, #2
a012a6f0 ed00000a beq #0xa012aaac
a012a6f4 4c4303e3 movw r4, #0x334c
a012a6f8 fb404ae3 movt r4, #0xa0fb
a012a6fc 0030d4e5 ldrb r3, [r4]
a012a700 050053e3 cmp r3, #5
a012a704 e800000a beq #0xa012aaac
a012a708 0100a0e3 mov r0, #1
a012a70c 0010a0e3 mov r1, #0
a012a710 0020a0e1 mov r2, r0
a012a714 b1cbffeb bl #0xa011d5e0
a012a718 77a303eb bl #0xa02134fc
a012a71c 0010a0e3 mov r1, #0
a012a720 183094e5 ldr r3, [r4, #0x18]
a012a724 0120a0e1 mov r2, r1
a012a728 4300a0e3 mov r0, #0x43
a012a72c 33ff2fe1 blx r3
a012a730 0100a0e3 mov r0, #1
a012a734 0020a0e3 mov r2, #0
a012a738 0010a0e1 mov r1, r0
a012a73c 60cfffeb bl #0xa011e4c4
a012a740 c5fdffea b #0xa0129e5c
a012a744 3c0d0de3 movw r0, #0xdd3c
a012a748 0420c2e3 bic r2, r2, #4
a012a74c 0010a0e3 mov r1, #0
a012a750 53004ae3 movt r0, #0xa053
a012a754 242083e5 str r2, [r3, #0x24]
a012a758 79a001eb bl #0xa0192944
a012a75c 48f9ffea b #0xa0128c84
a012a760 020012e3 tst r2, #2
a012a764 0efbff0a beq #0xa01293a4
a012a768 0010a0e3 mov r1, #0
a012a76c 183097e5 ldr r3, [r7, #0x18]
a012a770 0120a0e1 mov r2, r1
a012a774 0800a0e3 mov r0, #8
a012a778 33ff2fe1 blx r3
a012a77c 0040a0e1 mov r4, r0
a012a780 0000d7e5 ldrb r0, [r7]
a012a784 000050e3 cmp r0, #0
a012a788 0203000a beq #0xa012b398
a012a78c 050050e3 cmp r0, #5
a012a790 72f7ff1a bne #0xa0128560
a012a794 000000ea b #0xa012a79c
a012a798 e0460aeb bl #0xa03bc320
a012a79c 31a006eb bl #0xa02d2868
a012a7a0 000050e3 cmp r0, #0
a012a7a4 0100a0e3 mov r0, #1
a012a7a8 faffff0a beq #0xa012a798
a012a7ac 0010a0e3 mov r1, #0
a012a7b0 183097e5 ldr r3, [r7, #0x18]
a012a7b4 0120a0e1 mov r2, r1
a012a7b8 5700a0e3 mov r0, #0x57
a012a7bc 33ff2fe1 blx r3
a012a7c0 0040a0e1 mov r4, r0
a012a7c4 65f7ffea b #0xa0128560
a012a7c8 6c0a0ce3 movw r0, #0xca6c
a012a7cc 58370ee3 movw r3, #0xe758
a012a7d0 081094e5 ldr r1, [r4, #8]
a012a7d4 53304ae3 movt r3, #0xa053
a012a7d8 712c00e3 movw r2, #0xc71
a012a7dc 53004ae3 movt r0, #0xa053
a012a7e0 41f205eb bl #0xa02a70ec
a012a7e4 182097e5 ldr r2, [r7, #0x18]
a012a7e8 02c3a0e3 mov ip, #0x8000000
a012a7ec f4090ce3 movw r0, #0xc9f4
a012a7f0 58370ee3 movw r3, #0xe758
a012a7f4 081094e5 ldr r1, [r4, #8]
a012a7f8 53304ae3 movt r3, #0xa053
a012a7fc 00208de5 str r2, [sp]
a012a800 53004ae3 movt r0, #0xa053
a012a804 04c08de5 str ip, [sp, #4]
a012a808 722c00e3 movw r2, #0xc72
a012a80c 36f205eb bl #0xa02a70ec
a012a810 c9fcffea b #0xa0129b3c
a012a814 8c030ee3 movw r0, #0xe38c
a012a818 302805e3 movw r2, #0x5830
a012a81c 53204ae3 movt r2, #0xa053
a012a820 be1702e3 movw r1, #0x27be
a012a824 53004ae3 movt r0, #0xa053
a012a828 0040a0e3 mov r4, #0
a012a82c 2ef205eb bl #0xa02a70ec
a012a830 0100a0e3 mov r0, #1
a012a834 7b2302eb bl #0xa01b3628
a012a838 852202eb bl #0xa01b3254
a012a83c 47f7ffea b #0xa0128560
a012a840 0410a0e1 mov r1, r4
a012a844 dbe903eb bl #0xa0224fb8
a012a848 20a503eb bl #0xa0213cd0
a012a84c 7c4003e3 movw r4, #0x307c
a012a850 940d0ce3 movw r0, #0xcd94
a012a854 6f404ae3 movt r4, #0xa06f
a012a858 d82605e3 movw r2, #0x56d8
a012a85c 081094e5 ldr r1, [r4, #8]
a012a860 53204ae3 movt r2, #0xa053
a012a864 393e00e3 movw r3, #0xe39
a012a868 53004ae3 movt r0, #0xa053
a012a86c 1ef205eb bl #0xa02a70ec
a012a870 d43c05e3 movw r3, #0x5cd4
a012a874 0100a0e3 mov r0, #1
a012a878 05314ae3 movt r3, #0xa105
a012a87c 0020a0e3 mov r2, #0
a012a880 003093e5 ldr r3, [r3]
a012a884 9610d3e5 ldrb r1, [r3, #0x96]
a012a888 bbc4ffeb bl #0xa011bb7c
a012a88c 001050e2 subs r1, r0, #0
a012a890 7a01001a bne #0xa012ae80
a012a894 d83c05e3 movw r3, #0x5cd8
a012a898 000055e3 cmp r5, #0
a012a89c 05314ae3 movt r3, #0xa105
a012a8a0 d012c3e5 strb r1, [r3, #0x2d0]
a012a8a4 0200000a beq #0xa012a8b4
a012a8a8 0400a0e3 mov r0, #4
a012a8ac 000140e3 movt r0, #0x100
a012a8b0 775404eb bl #0xa023fa94
a012a8b4 0600a0e3 mov r0, #6
a012a8b8 0010a0e3 mov r1, #0
a012a8bc ce0b02eb bl #0xa01ad7fc
a012a8c0 0140a0e3 mov r4, #1
a012a8c4 25f7ffea b #0xa0128560
a012a8c8 1f0059e3 cmp sb, #0x1f
a012a8cc 8620a0e1 lsl r2, r6, #1
a012a8d0 8661a0e1 lsl r6, r6, #3
a012a8d4 0d0000ca bgt #0xa012a910
a012a8d8 063062e0 rsb r3, r2, r6
a012a8dc 050068e0 rsb r0, r8, r5
a012a8e0 83c163e0 rsb ip, r3, r3, lsl #3
a012a8e4 800160e0 rsb r0, r0, r0, lsl #3
a012a8e8 081a9fe5 ldr r1, [pc, #0xa08]
a012a8ec 063149e2 sub r3, sb, #0x80000001
a012a8f0 0c3083e0 add r3, r3, ip
a012a8f4 3ec080e2 add ip, r0, #0x3e
a012a8f8 833087e0 add r3, r7, r3, lsl #1
a012a8fc 0cc087e0 add ip, r7, ip
a012a900 0100f1e5 ldrb r0, [r1, #1]!
a012a904 b200e3e1 strh r0, [r3, #2]!
a012a908 0c0053e1 cmp r3, ip
a012a90c fbffff1a bne #0xa012a900
a012a910 066062e0 rsb r6, r2, r6
a012a914 054068e0 rsb r4, r8, r5
a012a918 866166e0 rsb r6, r6, r6, lsl #3
a012a91c 844164e0 rsb r4, r4, r4, lsl #3
a012a920 093086e0 add r3, r6, sb
a012a924 044087e0 add r4, r7, r4
a012a928 043083e2 add r3, r3, #4
a012a92c 00c0a0e3 mov ip, #0
a012a930 8330a0e1 lsl r3, r3, #1
a012a934 0c00a0e1 mov r0, ip
a012a938 441094e5 ldr r1, [r4, #0x44]
a012a93c 0420a0e1 mov r2, r4
a012a940 b3c087e1 strh ip, [r7, r3]
a012a944 835d03eb bl #0xa0201f58
a012a948 442094e5 ldr r2, [r4, #0x44]
a012a94c 0100a0e3 mov r0, #1
a012a950 481094e5 ldr r1, [r4, #0x48]
a012a954 4d5d03eb bl #0xa0201e90
a012a958 dc2003e3 movw r2, #0x30dc
a012a95c 003103e3 movw r3, #0x3100
a012a960 fd204ae3 movt r2, #0xa0fd
a012a964 fd304ae3 movt r3, #0xa0fd
a012a968 481094e5 ldr r1, [r4, #0x48]
a012a96c 0100a0e3 mov r0, #1
a012a970 002092e5 ldr r2, [r2]
a012a974 003093e5 ldr r3, [r3]
a012a978 9b5d03eb bl #0xa0201fec
a012a97c 92feffea b #0xa012a3cc
a012a980 7c1003e3 movw r1, #0x307c
a012a984 e40c0ce3 movw r0, #0xcce4
a012a988 6f104ae3 movt r1, #0xa06f
a012a98c d82605e3 movw r2, #0x56d8
a012a990 081091e5 ldr r1, [r1, #8]
a012a994 53004ae3 movt r0, #0xa053
a012a998 00308de5 str r3, [sp]
a012a99c 53204ae3 movt r2, #0xa053
a012a9a0 033e00e3 movw r3, #0xe03
a012a9a4 d0f105eb bl #0xa02a70ec
a012a9a8 0d10e0e3 mvn r1, #0xd
a012a9ac 000055e3 cmp r5, #0
a012a9b0 a5feff0a beq #0xa012a44c
a012a9b4 1600a0e3 mov r0, #0x16
a012a9b8 0040e0e3 mvn r4, #0
a012a9bc 000140e3 movt r0, #0x100
a012a9c0 335404eb bl #0xa023fa94
a012a9c4 e5f6ffea b #0xa0128560
a012a9c8 7c2003e3 movw r2, #0x307c
a012a9cc f40608e3 movw r0, #0x86f4
a012a9d0 6f204ae3 movt r2, #0xa06f
a012a9d4 303805e3 movw r3, #0x5830
a012a9d8 081092e5 ldr r1, [r2, #8]
a012a9dc 53304ae3 movt r3, #0xa053
a012a9e0 bb2702e3 movw r2, #0x27bb
a012a9e4 53004ae3 movt r0, #0xa053
a012a9e8 bff105eb bl #0xa02a70ec
a012a9ec dbf6ffea b #0xa0128560
a012a9f0 183093e5 ldr r3, [r3, #0x18]
a012a9f4 0410a0e1 mov r1, r4
a012a9f8 0420a0e1 mov r2, r4
a012a9fc 1600a0e3 mov r0, #0x16
a012aa00 33ff2fe1 blx r3
a012aa04 d5f6ffea b #0xa0128560
a012aa08 0010a0e3 mov r1, #0
a012aa0c 183093e5 ldr r3, [r3, #0x18]
a012aa10 0120a0e1 mov r2, r1
a012aa14 5700a0e3 mov r0, #0x57
a012aa18 33ff2fe1 blx r3
a012aa1c 8af9ffea b #0xa012904c
a012aa20 c4010de3 movw r0, #0xd1c4
a012aa24 0040a0e3 mov r4, #0
a012aa28 53004ae3 movt r0, #0xa053
a012aa2c aef105eb bl #0xa02a70ec
a012aa30 caf6ffea b #0xa0128560
a012aa34 256f01eb bl #0xa01866d0
a012aa38 0a0050e3 cmp r0, #0xa
a012aa3c 37f9ff0a beq #0xa0128f20
a012aa40 226f01eb bl #0xa01866d0
a012aa44 050050e3 cmp r0, #5
a012aa48 2df9ff1a bne #0xa0128f04
a012aa4c 33f9ffea b #0xa0128f20
a012aa50 7c3003e3 movw r3, #0x307c
a012aa54 78030de3 movw r0, #0xd378
a012aa58 6f304ae3 movt r3, #0xa06f
a012aa5c 182005e3 movw r2, #0x5018
a012aa60 081093e5 ldr r1, [r3, #8]
a012aa64 53204ae3 movt r2, #0xa053
a012aa68 0a3901e3 movw r3, #0x190a
a012aa6c 53004ae3 movt r0, #0xa053
a012aa70 9df105eb bl #0xa02a70ec
a012aa74 1c3096e5 ldr r3, [r6, #0x1c]
a012aa78 0100a0e3 mov r0, #1
a012aa7c 0040a0e3 mov r4, #0
a012aa80 2030c3e3 bic r3, r3, #0x20
a012aa84 1c3086e5 str r3, [r6, #0x1c]
a012aa88 3fd6ffeb bl #0xa012038c
a012aa8c 183096e5 ldr r3, [r6, #0x18]
a012aa90 ca00a0e3 mov r0, #0xca
a012aa94 0010a0e3 mov r1, #0
a012aa98 0133c3e3 bic r3, r3, #0x4000000
a012aa9c 183086e5 str r3, [r6, #0x18]
a012aaa0 c02600eb bl #0xa01345a8
a012aaa4 604088e5 str r4, [r8, #0x60]
a012aaa8 acf6ffea b #0xa0128560
a012aaac 92a203eb bl #0xa02134fc
a012aab0 e9fcffea b #0xa0129e5c
a012aab4 0610a0e1 mov r1, r6
a012aab8 0620a0e1 mov r2, r6
a012aabc 0100a0e3 mov r0, #1
a012aac0 c6caffeb bl #0xa011d5e0
a012aac4 0100a0e3 mov r0, #1
a012aac8 399503eb bl #0xa020ffb4
a012aacc 8aa203eb bl #0xa02134fc
a012aad0 0100a0e3 mov r0, #1
a012aad4 0620a0e1 mov r2, r6
a012aad8 0010a0e1 mov r1, r0
a012aadc 78ceffeb bl #0xa011e4c4
a012aae0 33f9ffea b #0xa0128fb4
a012aae4 35d503eb bl #0xa021ffc0
a012aae8 bafeffea b #0xa012a5d8
a012aaec f8010de3 movw r0, #0xd1f8
a012aaf0 0540a0e1 mov r4, r5
a012aaf4 53004ae3 movt r0, #0xa053
a012aaf8 7bf105eb bl #0xa02a70ec
a012aafc 183096e5 ldr r3, [r6, #0x18]
a012ab00 0510a0e1 mov r1, r5
a012ab04 0520a0e1 mov r2, r5
a012ab08 1300a0e3 mov r0, #0x13
a012ab0c 33ff2fe1 blx r3
a012ab10 92f6ffea b #0xa0128560
a012ab14 ccba01eb bl #0xa019964c
a012ab18 000050e3 cmp r0, #0
a012ab1c b600c8a5 strbge r0, [r8, #0xb6]
a012ab20 7bfcffea b #0xa0129d14
a012ab24 b00c0de3 movw r0, #0xdcb0
a012ab28 081094e5 ldr r1, [r4, #8]
a012ab2c 53004ae3 movt r0, #0xa053
a012ab30 6df105eb bl #0xa02a70ec
a012ab34 0100a0e3 mov r0, #1
a012ab38 0510a0e1 mov r1, r5
a012ab3c 010041e3 movt r0, #0x1001
a012ab40 0520a0e1 mov r2, r5
a012ab44 94ee02eb bl #0xa01e659c
a012ab48 183096e5 ldr r3, [r6, #0x18]
a012ab4c 141096e5 ldr r1, [r6, #0x14]
a012ab50 3ff8ffea b #0xa0128c54
a012ab54 0010a0e3 mov r1, #0
a012ab58 390100e3 movw r0, #0x139
a012ab5c 0120a0e1 mov r2, r1
a012ab60 ff004fe3 movt r0, #0xf0ff
a012ab64 8bee02eb bl #0xa01e6598
a012ab68 59fdffea b #0xa012a0d4
a012ab6c fc0d0de3 movw r0, #0xddfc
a012ab70 04290ee3 movw r2, #0xe904
a012ab74 53204ae3 movt r2, #0xa053
a012ab78 3f1802e3 movw r1, #0x283f
a012ab7c 53004ae3 movt r0, #0xa053
a012ab80 59f105eb bl #0xa02a70ec
a012ab84 8ebb01eb bl #0xa01999c4
a012ab88 000050e3 cmp r0, #0
a012ab8c 0200000a beq #0xa012ab9c
a012ab90 2200d8e5 ldrb r0, [r8, #0x22]
a012ab94 030050e3 cmp r0, #3
a012ab98 9801008a bhi #0xa012b200
a012ab9c 2200d8e5 ldrb r0, [r8, #0x22]
a012aba0 0210a0e3 mov r1, #2
a012aba4 d9ecffeb bl #0xa0125f10
a012aba8 2230d8e5 ldrb r3, [r8, #0x22]
a012abac 030053e3 cmp r3, #3
a012abb0 0200008a bhi #0xa012abc0
a012abb4 82bb01eb bl #0xa01999c4
a012abb8 004050e2 subs r4, r0, #0
a012abbc 9201000a beq #0xa012b20c
a012abc0 440e0de3 movw r0, #0xde44
a012abc4 04290ee3 movw r2, #0xe904
a012abc8 53204ae3 movt r2, #0xa053
a012abcc 471802e3 movw r1, #0x2847
a012abd0 53004ae3 movt r0, #0xa053
a012abd4 44f105eb bl #0xa02a70ec
a012abd8 0010a0e3 mov r1, #0
a012abdc 183097e5 ldr r3, [r7, #0x18]
a012abe0 0120a0e1 mov r2, r1
a012abe4 3200a0e3 mov r0, #0x32
a012abe8 33ff2fe1 blx r3
a012abec 0040a0e1 mov r4, r0
a012abf0 5af6ffea b #0xa0128560
a012abf4 7c1003e3 movw r1, #0x307c
a012abf8 3c0d0ce3 movw r0, #0xcd3c
a012abfc 6f104ae3 movt r1, #0xa06f
a012ac00 d82605e3 movw r2, #0x56d8
a012ac04 041091e5 ldr r1, [r1, #4]
a012ac08 53004ae3 movt r0, #0xa053
a012ac0c 00308de5 str r3, [sp]
a012ac10 53204ae3 movt r2, #0xa053
a012ac14 1c3e00e3 movw r3, #0xe1c
a012ac18 33f105eb bl #0xa02a70ec
a012ac1c 0010e0e3 mvn r1, #0
a012ac20 07feffea b #0xa012a444
a012ac24 b8070ce3 movw r0, #0xc7b8
a012ac28 58270ee3 movw r2, #0xe758
a012ac2c 53204ae3 movt r2, #0xa053
a012ac30 c21ea0e3 mov r1, #0xc20
a012ac34 53004ae3 movt r0, #0xa053
a012ac38 2bf105eb bl #0xa02a70ec
a012ac3c 59c6ffeb bl #0xa011c5a8
a012ac40 000050e3 cmp r0, #0
a012ac44 02feff1a bne #0xa012a454
a012ac48 182096e5 ldr r2, [r6, #0x18]
a012ac4c 143096e5 ldr r3, [r6, #0x14]
a012ac50 020c12e3 tst r2, #0x200
a012ac54 1020c3e3 bic r2, r3, #0x10
a012ac58 142086e5 str r2, [r6, #0x14]
a012ac5c 0100001a bne #0xa012ac68
a012ac60 e79c01eb bl #0xa0192004
a012ac64 143096e5 ldr r3, [r6, #0x14]
a012ac68 040013e3 tst r3, #4
a012ac6c b5f6ff0a beq #0xa0128748
a012ac70 243097e5 ldr r3, [r7, #0x24]
a012ac74 080013e3 tst r3, #8
a012ac78 c801000a beq #0xa012b3a0
a012ac7c 04080ce3 movw r0, #0xc804
a012ac80 58270ee3 movw r2, #0xe758
a012ac84 53204ae3 movt r2, #0xa053
a012ac88 2f1c00e3 movw r1, #0xc2f
a012ac8c 53004ae3 movt r0, #0xa053
a012ac90 7c4003e3 movw r4, #0x307c
a012ac94 14f105eb bl #0xa02a70ec
a012ac98 0100a0e3 mov r0, #1
a012ac9c 6f404ae3 movt r4, #0xa06f
a012aca0 f5f1ffeb bl #0xa012747c
a012aca4 7efbffea b #0xa0129aa4
a012aca8 d88c05e3 movw r8, #0x5cd8
a012acac 0100a0e3 mov r0, #1
a012acb0 05814ae3 movt r8, #0xa105
a012acb4 4c9303e3 movw sb, #0x334c
a012acb8 f91900eb bl #0xa01314a4
a012acbc ec3198e5 ldr r3, [r8, #0x1ec]
a012acc0 fb904ae3 movt sb, #0xa0fb
a012acc4 04a097e5 ldr sl, [r7, #4]
a012acc8 030055e1 cmp r5, r3
a012accc ec5188c5 strgt r5, [r8, #0x1ec]
a012acd0 00005ae3 cmp sl, #0
a012acd4 8bf6ff1a bne #0xa0128708
a012acd8 184096e5 ldr r4, [r6, #0x18]
a012acdc b0530be3 movw r5, #0xb3b0
a012ace0 69504ae3 movt r5, #0xa069
a012ace4 204014e2 ands r4, r4, #0x20
a012ace8 8301000a beq #0xa012b2fc
a012acec d43c05e3 movw r3, #0x5cd4
a012acf0 ff2f0fe3 movw r2, #0xffff
a012acf4 05314ae3 movt r3, #0xa105
a012acf8 003093e5 ldr r3, [r3]
a012acfc b612d3e1 ldrh r1, [r3, #0x26]
a012ad00 020051e1 cmp r1, r2
a012ad04 d901000a beq #0xa012b470
a012ad08 3531d3e5 ldrb r3, [r3, #0x135]
a012ad0c 000053e3 cmp r3, #0
a012ad10 4a01000a beq #0xa012b240
a012ad14 0bd2ffeb bl #0xa011f548
a012ad18 640050e3 cmp r0, #0x64
a012ad1c 470100da ble #0xa012b240
a012ad20 143095e5 ldr r3, [r5, #0x14]
a012ad24 1030c3e3 bic r3, r3, #0x10
a012ad28 143085e5 str r3, [r5, #0x14]
a012ad2c 59d2ffeb bl #0xa011f698
a012ad30 000050e3 cmp r0, #0
a012ad34 73f6ff0a beq #0xa0128708
a012ad38 9668ffeb bl #0xa0104f98
a012ad3c 000050e3 cmp r0, #0
a012ad40 70f6ff0a beq #0xa0128708
a012ad44 2e50d8e5 ldrb r5, [r8, #0x2e]
a012ad48 000055e3 cmp r5, #0
a012ad4c 6df6ff1a bne #0xa0128708
a012ad50 84010ee3 movw r0, #0xe184
a012ad54 d82305e3 movw r2, #0x53d8
a012ad58 53204ae3 movt r2, #0xa053
a012ad5c d81d02e3 movw r1, #0x2dd8
a012ad60 53004ae3 movt r0, #0xa053
a012ad64 0540a0e1 mov r4, r5
a012ad68 dff005eb bl #0xa02a70ec
a012ad6c 901108e3 movw r1, #0x8190
a012ad70 0520a0e1 mov r2, r5
a012ad74 12104ae3 movt r1, #0xa012
a012ad78 0700a0e3 mov r0, #7
a012ad7c c2ef02eb bl #0xa01e6c8c
a012ad80 61f6ffea b #0xa012870c
a012ad84 9e9c01eb bl #0xa0192004
a012ad88 143094e5 ldr r3, [r4, #0x14]
a012ad8c 040013e3 tst r3, #4
a012ad90 76fbff1a bne #0xa0129b70
a012ad94 6bf6ffea b #0xa0128748
a012ad98 50030ee3 movw r0, #0xe350
a012ad9c 302805e3 movw r2, #0x5830
a012ada0 53204ae3 movt r2, #0xa053
a012ada4 901702e3 movw r1, #0x2790
a012ada8 53004ae3 movt r0, #0xa053
a012adac 0040a0e3 mov r4, #0
a012adb0 cdf005eb bl #0xa02a70ec
a012adb4 e9f5ffea b #0xa0128560
a012adb8 ac090ce3 movw r0, #0xc9ac
a012adbc 58370ee3 movw r3, #0xe758
a012adc0 53304ae3 movt r3, #0xa053
a012adc4 081094e5 ldr r1, [r4, #8]
a012adc8 53004ae3 movt r0, #0xa053
a012adcc 622c00e3 movw r2, #0xc62
a012add0 c5f005eb bl #0xa02a70ec
a012add4 0530a0e3 mov r3, #5
a012add8 af30c5e5 strb r3, [r5, #0xaf]
a012addc 56fbffea b #0xa0129b3c
a012ade0 c2c101eb bl #0xa019b4f0
a012ade4 183095e5 ldr r3, [r5, #0x18]
a012ade8 5700a0e3 mov r0, #0x57
a012adec 0410a0e1 mov r1, r4
a012adf0 0420a0e1 mov r2, r4
a012adf4 33ff2fe1 blx r3
a012adf8 005050e2 subs r5, r0, #0
a012adfc c300001a bne #0xa012b110
a012ae00 0510a0e1 mov r1, r5
a012ae04 2c20a0e3 mov r2, #0x2c
a012ae08 1c008de2 add r0, sp, #0x1c
a012ae0c f6370ffa blx #0xa04f8dec
a012ae10 3d2300e3 movw r2, #0x33d
a012ae14 98340ce3 movw r3, #0xc498
a012ae18 01204fe3 movt r2, #0xf001
a012ae1c 0510a0e1 mov r1, r5
a012ae20 11304ae3 movt r3, #0xa011
a012ae24 02eca0e3 mov lr, #0x200
a012ae28 98ca03e3 movw ip, #0x3a98
a012ae2c 1c008de2 add r0, sp, #0x1c
a012ae30 1c208de5 str r2, [sp, #0x1c]
a012ae34 28208de5 str r2, [sp, #0x28]
a012ae38 2c308de5 str r3, [sp, #0x2c]
a012ae3c 34e08de5 str lr, [sp, #0x34]
a012ae40 3cc08de5 str ip, [sp, #0x3c]
a012ae44 13ec02eb bl #0xa01e5e98
a012ae48 001050e2 subs r1, r0, #0
a012ae4c 0900000a beq #0xa012ae78
a012ae50 7c2003e3 movw r2, #0x307c
a012ae54 c80c05e3 movw r0, #0x5cc8
a012ae58 6f204ae3 movt r2, #0xa06f
a012ae5c 303805e3 movw r3, #0x5830
a012ae60 00108de5 str r1, [sp]
a012ae64 53004ae3 movt r0, #0xa053
a012ae68 081092e5 ldr r1, [r2, #8]
a012ae6c 53304ae3 movt r3, #0xa053
a012ae70 a62702e3 movw r2, #0x27a6
a012ae74 9cf005eb bl #0xa02a70ec
a012ae78 0040a0e3 mov r4, #0
a012ae7c b7f5ffea b #0xa0128560
a012ae80 d00d0ce3 movw r0, #0xcdd0
a012ae84 d82605e3 movw r2, #0x56d8
a012ae88 00108de5 str r1, [sp]
a012ae8c 53004ae3 movt r0, #0xa053
a012ae90 041094e5 ldr r1, [r4, #4]
a012ae94 53204ae3 movt r2, #0xa053
a012ae98 3c3e00e3 movw r3, #0xe3c
a012ae9c 92f005eb bl #0xa02a70ec
a012aea0 0010e0e3 mvn r1, #0
a012aea4 66fdffea b #0xa012a444
a012aea8 0400a0e3 mov r0, #4
a012aeac 0040e0e3 mvn r4, #0
a012aeb0 000140e3 movt r0, #0x100
a012aeb4 f65204eb bl #0xa023fa94
a012aeb8 a8f5ffea b #0xa0128560
a012aebc 440c0ce3 movw r0, #0xcc44
a012aec0 d82605e3 movw r2, #0x56d8
a012aec4 00308de5 str r3, [sp]
a012aec8 53004ae3 movt r0, #0xa053
a012aecc 041096e5 ldr r1, [r6, #4]
a012aed0 53204ae3 movt r2, #0xa053
a012aed4 fa3d00e3 movw r3, #0xdfa
a012aed8 83f005eb bl #0xa02a70ec
a012aedc 0010e0e3 mvn r1, #0
a012aee0 b1feffea b #0xa012a9ac
a012aee4 0820c2e3 bic r2, r2, #8
a012aee8 0100a0e3 mov r0, #1
a012aeec 242087e5 str r2, [r7, #0x24]
a012aef0 25d5ffeb bl #0xa012038c
a012aef4 200b09e3 movw r0, #0x9b20
a012aef8 d82305e3 movw r2, #0x53d8
a012aefc 53204ae3 movt r2, #0xa053
a012af00 af1d02e3 movw r1, #0x2daf
a012af04 53004ae3 movt r0, #0xa053
a012af08 77f005eb bl #0xa02a70ec
a012af0c 99d8ffeb bl #0xa0121178
a012af10 004050e2 subs r4, r0, #0
a012af14 0900000a beq #0xa012af40
a012af18 7c2003e3 movw r2, #0x307c
a012af1c 680b09e3 movw r0, #0x9b68
a012af20 6f204ae3 movt r2, #0xa06f
a012af24 d83305e3 movw r3, #0x53d8
a012af28 00408de5 str r4, [sp]
a012af2c 53004ae3 movt r0, #0xa053
a012af30 081092e5 ldr r1, [r2, #8]
a012af34 53304ae3 movt r3, #0xa053
a012af38 b22d02e3 movw r2, #0x2db2
a012af3c 6af005eb bl #0xa02a70ec
a012af40 0000a0e3 mov r0, #0
a012af44 eb3a02eb bl #0xa01b9af8
a012af48 e8000ee3 movw r0, #0xe0e8
a012af4c d82305e3 movw r2, #0x53d8
a012af50 53204ae3 movt r2, #0xa053
a012af54 53004ae3 movt r0, #0xa053
a012af58 b91d02e3 movw r1, #0x2db9
a012af5c 62f005eb bl #0xa02a70ec
a012af60 143b02e3 movw r3, #0x2b14
a012af64 0020a0e3 mov r2, #0
a012af68 3a314ae3 movt r3, #0xa13a
a012af6c 002083e5 str r2, [r3]
a012af70 e5f5ffea b #0xa012870c
a012af74 4bf3ffeb bl #0xa0127ca8
a012af78 2230d6e5 ldrb r3, [r6, #0x22]
a012af7c 010053e3 cmp r3, #1
a012af80 0f01009a bls #0xa012b3c4
a012af84 030053e3 cmp r3, #3
a012af88 eef5ff1a bne #0xa0128748
a012af8c d43c05e3 movw r3, #0x5cd4
a012af90 18c094e5 ldr ip, [r4, #0x18]
a012af94 05314ae3 movt r3, #0xa105
a012af98 0020a0e3 mov r2, #0
a012af9c 003093e5 ldr r3, [r3]
a012afa0 7b00a0e3 mov r0, #0x7b
a012afa4 0240a0e1 mov r4, r2
a012afa8 4a3f83e2 add r3, r3, #0x128
a012afac b010d3e1 ldrh r1, [r3]
a012afb0 3cff2fe1 blx ip
a012afb4 69f5ffea b #0xa0128560
a012afb8 1c3096e5 ldr r3, [r6, #0x1c]
a012afbc 0420a0e1 mov r2, r4
a012afc0 18c091e5 ldr ip, [r1, #0x18]
a012afc4 1300a0e3 mov r0, #0x13
a012afc8 0410a0e1 mov r1, r4
a012afcc 2030c3e3 bic r3, r3, #0x20
a012afd0 1c3086e5 str r3, [r6, #0x1c]
a012afd4 3cff2fe1 blx ip
a012afd8 0040a0e1 mov r4, r0
a012afdc 5ff5ffea b #0xa0128560
a012afe0 ca00a0e3 mov r0, #0xca
a012afe4 0110a0e3 mov r1, #1
a012afe8 6e2500eb bl #0xa01345a8
a012afec 3afdffea b #0xa012a4dc
a012aff0 73ba01eb bl #0xa01999c4
a012aff4 000050e3 cmp r0, #0
a012aff8 1efaff0a beq #0xa0129878
a012affc 8c0c0ce3 movw r0, #0xcc8c
a012b000 d81605e3 movw r1, #0x56d8
a012b004 53104ae3 movt r1, #0xa053
a012b008 fe2d00e3 movw r2, #0xdfe
a012b00c 53004ae3 movt r0, #0xa053
a012b010 35f005eb bl #0xa02a70ec
a012b014 183094e5 ldr r3, [r4, #0x18]
a012b018 0610a0e1 mov r1, r6
a012b01c 0620a0e1 mov r2, r6
a012b020 5600a0e3 mov r0, #0x56
a012b024 33ff2fe1 blx r3
a012b028 12faffea b #0xa0129878
a012b02c 6f404ae3 movt r4, #0xa06f
a012b030 44090ce3 movw r0, #0xc944
a012b034 58370ee3 movw r3, #0xe758
a012b038 081094e5 ldr r1, [r4, #8]
a012b03c 53304ae3 movt r3, #0xa053
a012b040 592c00e3 movw r2, #0xc59
a012b044 53004ae3 movt r0, #0xa053
a012b048 27f005eb bl #0xa02a70ec
a012b04c 94faffea b #0xa0129aa4
a012b050 806604eb bl #0xa0244a58
a012b054 000050e3 cmp r0, #0
a012b058 7efdff1a bne #0xa012a658
a012b05c 75fdffea b #0xa012a638
a012b060 7c3003e3 movw r3, #0x307c
a012b064 cc0b0ce3 movw r0, #0xcbcc
a012b068 6f304ae3 movt r3, #0xa06f
a012b06c d82605e3 movw r2, #0x56d8
a012b070 081093e5 ldr r1, [r3, #8]
a012b074 53004ae3 movt r0, #0xa053
a012b078 f23d00e3 movw r3, #0xdf2
a012b07c 53204ae3 movt r2, #0xa053
a012b080 19f005eb bl #0xa02a70ec
a012b084 183096e5 ldr r3, [r6, #0x18]
a012b088 0040a0e3 mov r4, #0
a012b08c 0230c3e3 bic r3, r3, #2
a012b090 183086e5 str r3, [r6, #0x18]
a012b094 31f5ffea b #0xa0128560
a012b098 440e0de3 movw r0, #0xde44
a012b09c 04290ee3 movw r2, #0xe904
a012b0a0 53204ae3 movt r2, #0xa053
a012b0a4 a31802e3 movw r1, #0x28a3
a012b0a8 53004ae3 movt r0, #0xa053
a012b0ac 0ef005eb bl #0xa02a70ec
a012b0b0 183097e5 ldr r3, [r7, #0x18]
a012b0b4 3200a0e3 mov r0, #0x32
a012b0b8 0510a0e1 mov r1, r5
a012b0bc 0520a0e1 mov r2, r5
a012b0c0 33ff2fe1 blx r3
a012b0c4 0040a0e1 mov r4, r0
a012b0c8 24f5ffea b #0xa0128560
a012b0cc 8febffeb bl #0xa0125f10
a012b0d0 2230d8e5 ldrb r3, [r8, #0x22]
a012b0d4 0040a0e1 mov r4, r0
a012b0d8 010053e3 cmp r3, #1
a012b0dc da00009a bls #0xa012b44c
a012b0e0 030053e3 cmp r3, #3
a012b0e4 1df5ff1a bne #0xa0128560
a012b0e8 d43c05e3 movw r3, #0x5cd4
a012b0ec 18c097e5 ldr ip, [r7, #0x18]
a012b0f0 05314ae3 movt r3, #0xa105
a012b0f4 0520a0e1 mov r2, r5
a012b0f8 003093e5 ldr r3, [r3]
a012b0fc 7b00a0e3 mov r0, #0x7b
a012b100 4a3f83e2 add r3, r3, #0x128
a012b104 b010d3e1 ldrh r1, [r3]
a012b108 3cff2fe1 blx ip
a012b10c 13f5ffea b #0xa0128560
a012b110 7c2003e3 movw r2, #0x307c
a012b114 500608e3 movw r0, #0x8650
a012b118 6f204ae3 movt r2, #0xa06f
a012b11c 303805e3 movw r3, #0x5830
a012b120 00508de5 str r5, [sp]
a012b124 53304ae3 movt r3, #0xa053
a012b128 081092e5 ldr r1, [r2, #8]
a012b12c 53004ae3 movt r0, #0xa053
a012b130 992702e3 movw r2, #0x2799
a012b134 ecef05eb bl #0xa02a70ec
a012b138 08f5ffea b #0xa0128560
a012b13c 280a0ce3 movw r0, #0xca28
a012b140 58370ee3 movw r3, #0xe758
a012b144 081092e5 ldr r1, [r2, #8]
a012b148 53304ae3 movt r3, #0xa053
a012b14c 6c2c00e3 movw r2, #0xc6c
a012b150 53004ae3 movt r0, #0xa053
a012b154 e4ef05eb bl #0xa02a70ec
a012b158 0a30a0e3 mov r3, #0xa
a012b15c af30c5e5 strb r3, [r5, #0xaf]
a012b160 321300eb bl #0xa012fe30
a012b164 74faffea b #0xa0129b3c
a012b168 a59b01eb bl #0xa0192004
a012b16c 143095e5 ldr r3, [r5, #0x14]
a012b170 040013e3 tst r3, #4
a012b174 f9f4ff0a beq #0xa0128560
a012b178 72f5ffea b #0xa0128748
a012b17c 7c3003e3 movw r3, #0x307c
a012b180 50090de3 movw r0, #0xd950
a012b184 6f304ae3 movt r3, #0xa06f
a012b188 53004ae3 movt r0, #0xa053
a012b18c 081093e5 ldr r1, [r3, #8]
a012b190 0040e0e3 mvn r4, #0
a012b194 d4ef05eb bl #0xa02a70ec
a012b198 f0f4ffea b #0xa0128560
a012b19c d42c05e3 movw r2, #0x5cd4
a012b1a0 05214ae3 movt r2, #0xa105
a012b1a4 000092e5 ldr r0, [r2]
a012b1a8 1c20d0e5 ldrb r2, [r0, #0x1c]
a012b1ac 382002e2 and r2, r2, #0x38
a012b1b0 080052e3 cmp r2, #8
a012b1b4 a6fcff1a bne #0xa012a454
a012b1b8 b622d0e1 ldrh r2, [r0, #0x26]
a012b1bc 030052e3 cmp r2, #3
a012b1c0 a3fcff9a bls #0xa012a454
a012b1c4 020b13e3 tst r3, #0x800
a012b1c8 a1fcff0a beq #0xa012a454
a012b1cc 023bc3e3 bic r3, r3, #0x800
a012b1d0 0120a0e1 mov r2, r1
a012b1d4 18c097e5 ldr ip, [r7, #0x18]
a012b1d8 0b00a0e3 mov r0, #0xb
a012b1dc 183086e5 str r3, [r6, #0x18]
a012b1e0 7c4003e3 movw r4, #0x307c
a012b1e4 3cff2fe1 blx ip
a012b1e8 141b03e3 movw r1, #0x3b14
a012b1ec 0200a0e3 mov r0, #2
a012b1f0 12104ae3 movt r1, #0xa012
a012b1f4 6f404ae3 movt r4, #0xa06f
a012b1f8 33ee02eb bl #0xa01e6acc
a012b1fc 28faffea b #0xa0129aa4
a012b200 0410a0e3 mov r1, #4
a012b204 41ebffeb bl #0xa0125f10
a012b208 66feffea b #0xa012aba8
a012b20c 800e0de3 movw r0, #0xde80
a012b210 04290ee3 movw r2, #0xe904
a012b214 53204ae3 movt r2, #0xa053
a012b218 4a1802e3 movw r1, #0x284a
a012b21c 53004ae3 movt r0, #0xa053
a012b220 b1ef05eb bl #0xa02a70ec
a012b224 0420a0e1 mov r2, r4
a012b228 183097e5 ldr r3, [r7, #0x18]
a012b22c 3200a0e3 mov r0, #0x32
a012b230 0110a0e3 mov r1, #1
a012b234 33ff2fe1 blx r3
a012b238 0040a0e1 mov r4, r0
a012b23c c7f4ffea b #0xa0128560
a012b240 c0d0ffeb bl #0xa011f548
a012b244 080050e3 cmp r0, #8
a012b248 670000da ble #0xa012b3ec
a012b24c 143096e5 ldr r3, [r6, #0x14]
a012b250 1030c3e3 bic r3, r3, #0x10
a012b254 143086e5 str r3, [r6, #0x14]
a012b258 ded0ffeb bl #0xa011f5d8
a012b25c 000050e3 cmp r0, #0
a012b260 28f5ff0a beq #0xa0128708
a012b264 4b67ffeb bl #0xa0104f98
a012b268 000050e3 cmp r0, #0
a012b26c 25f5ff0a beq #0xa0128708
a012b270 2e40d8e5 ldrb r4, [r8, #0x2e]
a012b274 000054e3 cmp r4, #0
a012b278 22f5ff1a bne #0xa0128708
a012b27c 1a0300e3 movw r0, #0x31a
a012b280 0410a0e1 mov r1, r4
a012b284 0420a0e1 mov r2, r4
a012b288 01004fe3 movt r0, #0xf001
a012b28c c1ec02eb bl #0xa01e6598
a012b290 1df5ffea b #0xa012870c
a012b294 7c2003e3 movw r2, #0x307c
a012b298 00000ee3 movw r0, #0xe000
a012b29c 6f204ae3 movt r2, #0xa06f
a012b2a0 803d04e3 movw r3, #0x4d80
a012b2a4 081092e5 ldr r1, [r2, #8]
a012b2a8 53004ae3 movt r0, #0xa053
a012b2ac 53304ae3 movt r3, #0xa053
a012b2b0 712fa0e3 mov r2, #0x1c4
a012b2b4 8cef05eb bl #0xa02a70ec
a012b2b8 0040a0e3 mov r4, #0
a012b2bc a7f4ffea b #0xa0128560
a012b2c0 7c2003e3 movw r2, #0x307c
a012b2c4 3c0408e3 movw r0, #0x843c
a012b2c8 6f204ae3 movt r2, #0xa06f
a012b2cc 583605e3 movw r3, #0x5658
a012b2d0 081092e5 ldr r1, [r2, #8]
a012b2d4 53004ae3 movt r0, #0xa053
a012b2d8 53304ae3 movt r3, #0xa053
a012b2dc e92100e3 movw r2, #0x1e9
a012b2e0 81ef05eb bl #0xa02a70ec
a012b2e4 0040a0e3 mov r4, #0
a012b2e8 9cf4ffea b #0xa0128560
a012b2ec f1c9ffeb bl #0xa011dab8
a012b2f0 4bf8ffea b #0xa0129424
a012b2fc 0400a0e1 mov r0, r4
a012b300 19e603eb bl #0xa0224b6c
a012b304 83f202eb bl #0xa01e7d18
a012b308 ecc198e5 ldr ip, [r8, #0x1ec]
a012b30c 0090a0e1 mov sb, r0
a012b310 d82305e3 movw r2, #0x53d8
a012b314 2c020ee3 movw r0, #0xe22c
a012b318 0930a0e1 mov r3, sb
a012b31c 53004ae3 movt r0, #0xa053
a012b320 53204ae3 movt r2, #0xa053
a012b324 ec1d02e3 movw r1, #0x2dec
a012b328 00c08de5 str ip, [sp]
a012b32c 6eef05eb bl #0xa02a70ec
a012b330 ec3198e5 ldr r3, [r8, #0x1ec]
a012b334 030059e1 cmp sb, r3
a012b338 6000000a beq #0xa012b4c0
a012b33c 74020ee3 movw r0, #0xe274
a012b340 d82305e3 movw r2, #0x53d8
a012b344 53204ae3 movt r2, #0xa053
a012b348 53004ae3 movt r0, #0xa053
a012b34c fd1d02e3 movw r1, #0x2dfd
a012b350 65ef05eb bl #0xa02a70ec
a012b354 143b02e3 movw r3, #0x2b14
a012b358 0020a0e3 mov r2, #0
a012b35c 3a314ae3 movt r3, #0xa13a
a012b360 0240a0e1 mov r4, r2
a012b364 002083e5 str r2, [r3]
a012b368 e7f4ffea b #0xa012870c
a012b36c b11801e3 movw r1, #0x18b1
a012b370 58000de3 movw r0, #0xd058
a012b374 e42705e3 movw r2, #0x57e4
a012b378 583005e3 movw r3, #0x5058
a012b37c 00108de5 str r1, [sp]
a012b380 53204ae3 movt r2, #0xa053
a012b384 53304ae3 movt r3, #0xa053
a012b388 53004ae3 movt r0, #0xa053
a012b38c 0040e0e3 mvn r4, #0
a012b390 55ef05eb bl #0xa02a70ec
a012b394 71f4ffea b #0xa0128560
a012b398 199b01eb bl #0xa0192004
a012b39c 6ff4ffea b #0xa0128560
a012b3a0 4c080ce3 movw r0, #0xc84c
a012b3a4 58270ee3 movw r2, #0xe758
a012b3a8 53004ae3 movt r0, #0xa053
a012b3ac 53204ae3 movt r2, #0xa053
a012b3b0 321c00e3 movw r1, #0xc32
a012b3b4 7c4003e3 movw r4, #0x307c
a012b3b8 4bef05eb bl #0xa02a70ec
a012b3bc 6f404ae3 movt r4, #0xa06f
a012b3c0 b7f9ffea b #0xa0129aa4
a012b3c4 d43c05e3 movw r3, #0x5cd4
a012b3c8 18c094e5 ldr ip, [r4, #0x18]
a012b3cc 05314ae3 movt r3, #0xa105
a012b3d0 0020a0e3 mov r2, #0
a012b3d4 003093e5 ldr r3, [r3]
a012b3d8 7b00a0e3 mov r0, #0x7b
a012b3dc 0240a0e1 mov r4, r2
a012b3e0 bc18d3e1 ldrh r1, [r3, #0x8c]
a012b3e4 3cff2fe1 blx ip
a012b3e8 5cf4ffea b #0xa0128560
a012b3ec cc010ee3 movw r0, #0xe1cc
a012b3f0 d82305e3 movw r2, #0x53d8
a012b3f4 53204ae3 movt r2, #0xa053
a012b3f8 e81d02e3 movw r1, #0x2de8
a012b3fc 53004ae3 movt r0, #0xa053
a012b400 0040a0e3 mov r4, #0
a012b404 38ef05eb bl #0xa02a70ec
a012b408 bff4ffea b #0xa012870c
a012b40c 7c3003e3 movw r3, #0x307c
a012b410 500108e3 movw r0, #0x8150
a012b414 6f304ae3 movt r3, #0xa06f
a012b418 53004ae3 movt r0, #0xa053
a012b41c 081093e5 ldr r1, [r3, #8]
a012b420 0040e0e3 mvn r4, #0
a012b424 30ef05eb bl #0xa02a70ec
a012b428 4cf4ffea b #0xa0128560
a012b42c 7c3003e3 movw r3, #0x307c
a012b430 04090de3 movw r0, #0xd904
a012b434 6f304ae3 movt r3, #0xa06f
a012b438 53004ae3 movt r0, #0xa053
a012b43c 081093e5 ldr r1, [r3, #8]
a012b440 0040e0e3 mvn r4, #0
a012b444 28ef05eb bl #0xa02a70ec
a012b448 44f4ffea b #0xa0128560
a012b44c d43c05e3 movw r3, #0x5cd4
a012b450 18c097e5 ldr ip, [r7, #0x18]
a012b454 05314ae3 movt r3, #0xa105
a012b458 0520a0e1 mov r2, r5
a012b45c 003093e5 ldr r3, [r3]
a012b460 7b00a0e3 mov r0, #0x7b
a012b464 bc18d3e1 ldrh r1, [r3, #0x8c]
a012b468 3cff2fe1 blx ip
a012b46c 3bf4ffea b #0xa0128560
a012b470 0fdaffeb bl #0xa0121cb4
a012b474 008050e2 subs r8, r0, #0
a012b478 2300000a beq #0xa012b50c
a012b47c 943603e3 movw r3, #0x3694
a012b480 185099e5 ldr r5, [sb, #0x18]
a012b484 fb304ae3 movt r3, #0xa0fb
a012b488 0a10a0e1 mov r1, sl
a012b48c 00c093e5 ldr ip, [r3]
a012b490 0a20a0e1 mov r2, sl
a012b494 0b00a0e3 mov r0, #0xb
a012b498 0a40a0e1 mov r4, sl
a012b49c 01c08ce2 add ip, ip, #1
a012b4a0 00c083e5 str ip, [r3]
a012b4a4 35ff2fe1 blx r5
a012b4a8 97f4ffea b #0xa012870c
a012b4ac 24050de3 movw r0, #0xd524
a012b4b0 0040e0e3 mvn r4, #0
a012b4b4 53004ae3 movt r0, #0xa053
a012b4b8 0bef05eb bl #0xa02a70ec
a012b4bc 27f4ffea b #0xa0128560
a012b4c0 67d4ffeb bl #0xa0120664
a012b4c4 1c3095e5 ldr r3, [r5, #0x1c]
a012b4c8 021b13e2 ands r1, r3, #0x800
a012b4cc 1d00001a bne #0xa012b548
a012b4d0 010a13e3 tst r3, #0x1000
a012b4d4 98ffff0a beq #0xa012b33c
a012b4d8 013ac3e3 bic r3, r3, #0x1000
a012b4dc 330300e3 movw r0, #0x333
a012b4e0 1c3085e5 str r3, [r5, #0x1c]
a012b4e4 0120a0e1 mov r2, r1
a012b4e8 283095e5 ldr r3, [r5, #0x28]
a012b4ec 01004fe3 movt r0, #0xf001
a012b4f0 33ff2fe1 blx r3
a012b4f4 32b901eb bl #0xa01999c4
a012b4f8 000050e3 cmp r0, #0
a012b4fc 18309515 ldrne r3, [r5, #0x18]
a012b500 01378313 orrne r3, r3, #0x40000
a012b504 18308515 strne r3, [r5, #0x18]
a012b508 8bffffea b #0xa012b33c
a012b50c 183095e5 ldr r3, [r5, #0x18]
a012b510 0840a0e1 mov r4, r8
a012b514 2030c3e3 bic r3, r3, #0x20
a012b518 183085e5 str r3, [r5, #0x18]
a012b51c efe0ffeb bl #0xa01238e0
a012b520 34010ee3 movw r0, #0xe134
a012b524 d82305e3 movw r2, #0x53d8
a012b528 53004ae3 movt r0, #0xa053
a012b52c 53204ae3 movt r2, #0xa053
a012b530 cc1d02e3 movw r1, #0x2dcc
a012b534 ecee05eb bl #0xa02a70ec
a012b538 143b02e3 movw r3, #0x2b14
a012b53c 3a314ae3 movt r3, #0xa13a
a012b540 008083e5 str r8, [r3]
a012b544 70f4ffea b #0xa012870c
a012b548 023bc3e3 bic r3, r3, #0x800
a012b54c 0e00a0e3 mov r0, #0xe
a012b550 1c3085e5 str r3, [r5, #0x1c]
a012b554 0420a0e1 mov r2, r4
a012b558 283095e5 ldr r3, [r5, #0x28]
a012b55c 6410a0e3 mov r1, #0x64
a012b560 01004ee3 movt r0, #0xe001
a012b564 33ff2fe1 blx r3
a012b568 73ffffea b #0xa012b33c
