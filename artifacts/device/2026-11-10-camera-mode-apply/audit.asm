a01649a0  push {r4, r5, r6, r7, r8, lr}
a01649a4  mov r4, #0
a01649a8  sub sp, sp, #0x88
a01649ac  mov r2, #0x40
a01649b0  mov r5, r0
a01649b4  mov r8, r1
a01649b8  add r0, sp, #8
a01649bc  mov r1, r4
a01649c0  str r4, [sp, #4]
a01649c4  blx #0xa04f8dec
a01649c8  mov r1, r4
a01649cc  mov r2, #0x40
a01649d0  add r0, sp, #0x48
a01649d4  blx #0xa04f8dec
a01649d8  bl #0xa016326c
a01649dc  mov r6, r0
a01649e0  bl #0xa015522c
a01649e4  cmp r0, r4
a01649e8  bne #0xa0164b10
a01649ec  cmp r8, #0
a01649f0  cmpne r5, #0
a01649f4  beq #0xa0164b64
a01649f8  mov r1, r5
a01649fc  add r0, sp, #4
a0164a00  bl #0xa0246ff4
a0164a04  cmp r0, #0
a0164a08  bne #0xa0164b90
a0164a0c  movw r1, #0x6d88
a0164a10  mov r3, #0x40
a0164a14  ldr r0, [sp, #4]
a0164a18  movt r1, #0xa061
a0164a1c  add r2, sp, #8
a0164a20  bl #0xa02470f0
a0164a24  cmp r0, #0
a0164a28  movwne r3, #0x307c
a0164a2c  movwne r0, #0x1360
a0164a30  movtne r3, #0xa06f
a0164a34  movtne r0, #0xa055
a0164a38  bne #0xa0164b38
a0164a3c  movw r1, #0x619c
a0164a40  ldr r0, [sp, #4]
a0164a44  movt r1, #0xa053
a0164a48  add r2, sp, #0x48
a0164a4c  mov r3, #0x40
a0164a50  bl #0xa02470f0
a0164a54  subs r7, r0, #0
a0164a58  bne #0xa0164b28
a0164a5c  cmp r6, #0
a0164a60  ldrgt r5, [pc, #0x144]
a0164a64  movgt r4, r7
a0164a68  bgt #0xa0164a7c
a0164a6c  b #0xa0164afc
a0164a70  add r4, r4, #1
a0164a74  cmp r4, r6
a0164a78  beq #0xa0164afc
a0164a7c  mov r1, r5
a0164a80  add r0, sp, #8
a0164a84  blx #0xa04f95d0
a0164a88  cmp r0, #0
a0164a8c  add r5, r5, #0x64
a0164a90  bne #0xa0164a70
a0164a94  lsl r3, r4, #4
a0164a98  movw r2, #0x5fa4
a0164a9c  movt r2, #0xa06a
a0164aa0  add r3, r3, r4, lsl #2
a0164aa4  add r3, r3, r3, lsl #2
a0164aa8  add r5, r2, r3
a0164aac  ldr r3, [r5, #0x60]
a0164ab0  cmp r3, #0
a0164ab4  beq #0xa0164b18
a0164ab8  mov r1, r0
a0164abc  mov r0, #0xca
a0164ac0  bl #0xa01345a8
a0164ac4  ldr r3, [r5, #0x60]
a0164ac8  add r0, sp, #8
a0164acc  add r1, sp, #0x48
a0164ad0  blx r3
a0164ad4  mov r7, r0
a0164ad8  cmp r6, r4
a0164adc  ble #0xa0164afc
a0164ae0  ldr r0, [sp, #4]
a0164ae4  bl #0xa02471d0
a0164ae8  mov r0, r8
a0164aec  bl #0xa03bc714
a0164af0  mov r0, r7
a0164af4  add sp, sp, #0x88
a0164af8  pop {r4, r5, r6, r7, r8, pc}
a0164afc  mov r0, #2
a0164b00  mvn r1, #0
a0164b04  bl #0xa023fa94
a0164b08  mvn r7, #0
a0164b0c  b #0xa0164ae0
a0164b10  bl #0xa01549fc
a0164b14  b #0xa01649ec
a0164b18  mvn r1, #0xd
a0164b1c  mov r0, #2
a0164b20  bl #0xa023fa94
a0164b24  b #0xa0164ad8
a0164b28  movw r3, #0x307c
a0164b2c  movw r0, #0x13a0
a0164b30  movt r3, #0xa06f
a0164b34  movt r0, #0xa055
a0164b38  ldr r1, [r3, #4]
a0164b3c  bl #0xa02a70ec
a0164b40  mvn r1, #6
a0164b44  mov r0, #2
a0164b48  bl #0xa023fa94
a0164b4c  ldr r0, [sp, #4]
a0164b50  bl #0xa02471d0
a0164b54  mov r0, r8
a0164b58  bl #0xa03bc714
a0164b5c  mvn r0, #0
a0164b60  b #0xa0164af4
a0164b64  movw r3, #0x307c
a0164b68  movw r0, #0x1314
a0164b6c  movt r3, #0xa06f
a0164b70  movt r0, #0xa055
a0164b74  ldr r1, [r3, #4]
a0164b78  bl #0xa02a70ec
a0164b7c  mov r0, #2
a0164b80  mvn r1, #6
a0164b84  bl #0xa023fa94
a0164b88  mvn r0, #0
a0164b8c  b #0xa0164af4
a0164b90  mvn r1, #6
a0164b94  mov r0, #2
a0164b98  bl #0xa023fa94
a0164b9c  mov r0, r8
a0164ba0  bl #0xa03bc714
a0164ba4  mvn r0, #0
a0164ba8  b #0xa0164af4
a0158844  push {r4, r5, r6, lr}
a0158848  sub sp, sp, #8
a015884c  add r3, sp, #8
a0158850  mov r4, #0
a0158854  mov r5, r0
a0158858  mov r6, r1
a015885c  str r4, [r3, #-4]!
a0158860  mov r0, r3
a0158864  bl #0xa0247160
a0158868  movw r1, #0x618c
a015886c  mov r2, r4
a0158870  movt r1, #0xa053
a0158874  ldr r0, [sp, #4]
a0158878  bl #0xa0247230
a015887c  movw r1, #0x6194
a0158880  ldr r0, [sp, #4]
a0158884  movt r1, #0xa053
a0158888  mov r2, #2
a015888c  bl #0xa0247230
a0158890  movw r1, #0x619c
a0158894  mov r2, r6
a0158898  movt r1, #0xa053
a015889c  ldr r0, [sp, #4]
a01588a0  bl #0xa0247290
a01588a4  movw r1, #0x6d88
a01588a8  mov r2, r5
a01588ac  movt r1, #0xa061
a01588b0  ldr r0, [sp, #4]
a01588b4  bl #0xa0247290
a01588b8  mov r0, r5
a01588bc  bl #0xa01555c8
a01588c0  movw r1, #0xf510
a01588c4  cmp r0, r4
a01588c8  ldrgt r0, [sp, #4]
a01588cc  movtgt r1, #0xa054
a01588d0  movgt r2, #1
a01588d4  movle r2, r4
a01588d8  movtle r1, #0xa054
a01588dc  ldrle r0, [sp, #4]
a01588e0  bl #0xa0247230
a01588e4  ldr r0, [sp, #4]
a01588e8  bl #0xa0192724
a01588ec  ldr r0, [sp, #4]
a01588f0  bl #0xa02471d0
a01588f4  mov r0, #0
a01588f8  add sp, sp, #8
a01588fc  pop {r4, r5, r6, pc}
a01555c8  push {r4, r5, r6, r7, lr}
a01555cc  sub sp, sp, #0x4c
a01555d0  mov r5, r0
a01555d4  mvn r3, #0
a01555d8  add r0, sp, #8
a01555dc  mov r1, #0
a01555e0  mov r2, #0x40
a01555e4  str r3, [sp, #4]
a01555e8  blx #0xa04f8dec
a01555ec  cmp r5, #0
a01555f0  beq #0xa01556ac
a01555f4  ldrb r3, [r5]
a01555f8  cmp r3, #0
a01555fc  beq #0xa015569c
a0155600  bl #0xa016326c
a0155604  subs r7, r0, #1
a0155608  bmi #0xa0155690
a015560c  lsl r4, r7, #4
a0155610  movw r6, #0x5fa4
a0155614  movt r6, #0xa06a
a0155618  add r4, r4, r7, lsl #2
a015561c  add r4, r4, r4, lsl #2
a0155620  add r4, r4, #8
a0155624  add r4, r6, r4
a0155628  b #0xa0155634
a015562c  subs r7, r7, #1
a0155630  blo #0xa0155690
a0155634  mov r0, r4
a0155638  mov r1, r5
a015563c  blx #0xa04f9744
a0155640  cmp r0, #0
a0155644  sub r4, r4, #0x64
a0155648  bne #0xa015562c
a015564c  lsl r3, r7, #4
a0155650  add r7, r3, r7, lsl #2
a0155654  add r7, r7, r7, lsl #2
a0155658  ldr r0, [r6, r7]
a015565c  cmp r0, #0
a0155660  ble #0xa0155690
a0155664  add r1, sp, #8
a0155668  mov r2, #0x10
a015566c  add r3, sp, #4
a0155670  bl #0xa01554bc
a0155674  cmp r0, #0
a0155678  bne #0xa01556a4
a015567c  ldr r0, [sp, #4]
a0155680  cmp r0, #0
a0155684  mvnle r0, #5
a0155688  add sp, sp, #0x4c
a015568c  pop {r4, r5, r6, r7, pc}
a0155690  mvn r0, #3
a0155694  add sp, sp, #0x4c
a0155698  pop {r4, r5, r6, r7, pc}
a015569c  mvn r0, #2
a01556a0  b #0xa0155688
a01556a4  mvn r0, #4
a01556a8  b #0xa0155688
a01556ac  mvn r0, #1
a01556b0  b #0xa0155688
a01554bc  cmp r2, #0
a01554c0  ble #0xa01555b8
a01554c4  cmp r3, #0
a01554c8  beq #0xa01555c0
a01554cc  push {r3, r4, r5, r6, r7, r8, sb, lr}
a01554d0  mov sb, r3
a01554d4  mov r7, r1
a01554d8  mov r4, r0
a01554dc  mov r8, r2
a01554e0  bl #0xa0163284
a01554e4  cmp r0, #0
a01554e8  ble #0xa01555b0
a01554ec  movw r2, #0x8524
a01554f0  movt r2, #0xa06a
a01554f4  ldr r3, [r2]
a01554f8  cmp r3, r4
a01554fc  beq #0xa01555a8
a0155500  mov r3, r2
a0155504  mov r6, #0
a0155508  add r6, r6, #1
a015550c  cmp r6, r0
a0155510  beq #0xa01555b0
a0155514  ldr r1, [r3, #0x44]!
a0155518  cmp r1, r4
a015551c  bne #0xa0155508
a0155520  lsl r0, r6, #6
a0155524  mov r4, #0
a0155528  add r6, r0, r6, lsl #2
a015552c  add r3, r6, #0x40
a0155530  add r6, r6, r2
a0155534  add r3, r3, r2
a0155538  ldr r5, [r6, #4]!
a015553c  cmp r5, #0
a0155540  ble #0xa0155594
a0155544  cmp r4, #0
a0155548  ble #0xa015557c
a015554c  ldr r1, [r7]
a0155550  cmp r5, r1
a0155554  beq #0xa015558c
a0155558  mov ip, r7
a015555c  mov r0, #0
a0155560  b #0xa0155570
a0155564  ldr lr, [ip, #4]!
a0155568  cmp r5, lr
a015556c  beq #0xa015558c
a0155570  add r0, r0, #1
a0155574  cmp r0, r4
a0155578  bne #0xa0155564
a015557c  str r5, [r7, r4, lsl #2]
a0155580  add r4, r4, #1
a0155584  cmp r8, r4
a0155588  ble #0xa015559c
a015558c  cmp r6, r3
a0155590  bne #0xa0155538
a0155594  cmp r4, #0
a0155598  beq #0xa01555b0
a015559c  str r4, [sb]
a01555a0  mov r0, #0
a01555a4  pop {r3, r4, r5, r6, r7, r8, sb, pc}
a01555a8  mov r6, #0
a01555ac  b #0xa0155520
a01555b0  mvn r0, #3
a01555b4  pop {r3, r4, r5, r6, r7, r8, sb, pc}
a01555b8  mvn r0, #1
a01555bc  bx lr
a01555c0  mvn r0, #2
a01555c4  bx lr
a015663c  push {r3, lr}
a0156640  movw r3, #0x5cd8
a0156644  movt r3, #0xa105
a0156648  movw r2, #0x5574
a015664c  ldrb r3, [r3, #0x22]
a0156650  cmp r3, #3
a0156654  movwhi r3, #0xaf98
a0156658  movwls r3, #0x9a2c
a015665c  movthi r2, #0xa063
a0156660  movthi r3, #0xa053
a0156664  movtls r2, #0xa063
a0156668  movtls r3, #0xa05c
a015666c  blx #0xa04f93c4
a0156670  mov r0, #0
a0156674  pop {r3, pc}
a0157204  push {r4, r5, r6, r7, r8, sb, lr}
a0157208  adds r6, r0, #0
a015720c  movne r6, #1
a0157210  mov r5, #0
a0157214  mov r7, r1
a0157218  mov r4, #1
a015721c  movw ip, #0x5cd8
a0157220  sub sp, sp, #0xc
a0157224  movt ip, #0xa105
a0157228  mov r8, r0
a015722c  mov r1, r6
a0157230  mov r0, r7
a0157234  mov r3, r4
a0157238  mov r2, r5
a015723c  strb r4, [ip, #0x1e5]
a0157240  str r5, [sp, #4]
a0157244  bl #0xa014bdd0
a0157248  cmp r6, r5
a015724c  beq #0xa01572e0
a0157250  mov sb, r0
a0157254  add r0, sp, #4
a0157258  bl #0xa0247160
a015725c  movw r1, #0x618c
a0157260  mov r2, sb
a0157264  movt r1, #0xa053
a0157268  ldr r0, [sp, #4]
a015726c  bl #0xa0247230
a0157270  movw r1, #0x6194
a0157274  mov r2, #2
a0157278  movt r1, #0xa053
a015727c  ldr r0, [sp, #4]
a0157280  bl #0xa0247230
a0157284  movw r1, #0x619c
a0157288  mov r2, r7
a015728c  movt r1, #0xa053
a0157290  ldr r0, [sp, #4]
a0157294  bl #0xa0247290
a0157298  movw r1, #0x6d88
a015729c  mov r2, r8
a01572a0  movt r1, #0xa061
a01572a4  ldr r0, [sp, #4]
a01572a8  bl #0xa0247290
a01572ac  mov r0, r8
a01572b0  bl #0xa01555c8
a01572b4  movw r1, #0xf510
a01572b8  cmp r0, r5
a01572bc  movgt r2, r4
a01572c0  movle r2, r5
a01572c4  movt r1, #0xa054
a01572c8  ldr r0, [sp, #4]
a01572cc  bl #0xa0247230
a01572d0  ldr r0, [sp, #4]
a01572d4  bl #0xa0192724
a01572d8  ldr r0, [sp, #4]
a01572dc  bl #0xa02471d0
a01572e0  mov r0, #0
a01572e4  add sp, sp, #0xc
a01572e8  pop {r4, r5, r6, r7, r8, sb, pc}
a014bdd0  push {r4, r5, r6, r7, r8, sb, lr}
a014bdd4  mov ip, #0
a014bdd8  sub sp, sp, #0x9c
a014bddc  mov r6, r0
a014bde0  mov sb, r1
a014bde4  mov r8, r2
a014bde8  mov r1, ip
a014bdec  add r0, sp, #0x18
a014bdf0  mov r2, #0x80
a014bdf4  mov r7, r3
a014bdf8  str ip, [sp, #0x14]
a014bdfc  strb ip, [sp, #0x13]
a014be00  blx #0xa04f8dec
a014be04  cmp r6, #0
a014be08  beq #0xa014bf1c
a014be0c  bl #0xa0104ac8
a014be10  mov r0, #1
a014be14  bl #0xa012f38c
a014be18  mov r1, sb
a014be1c  add r2, sp, #0x14
a014be20  mov r0, r6
a014be24  bl #0xa0145e10
a014be28  add r1, sp, #0x18
a014be2c  mov r5, r0
a014be30  mov r2, #0x80
a014be34  add r0, sp, #0x13
a014be38  bl #0xa0151254
a014be3c  cmp r5, #0
a014be40  ldr ip, [sp, #0x14]
a014be44  rsblt r4, r5, #0
a014be48  lslge r3, r5, #0x18
a014be4c  orrlt r4, r4, #0x80
a014be50  lsllt r3, r4, #0x18
a014be54  cmp r0, #0
a014be58  rsblt r0, r0, #0
a014be5c  str ip, [sp]
a014be60  orrlt r0, r0, #0x80
a014be64  add r1, sp, #0x18
a014be68  lsl r4, r0, #0x10
a014be6c  mov r2, sb
a014be70  ldrb r0, [sp, #0x13]
a014be74  orr r4, r4, r3
a014be78  mov r3, r4
a014be7c  bl #0xa0143644
a014be80  lsl r2, r4, #8
a014be84  cmp r4, #0
a014be88  mvnlt r1, #0
a014be8c  str r0, [sp]
a014be90  movge r1, #1
a014be94  cmp r2, #0
a014be98  mvnlt ip, #0
a014be9c  movge ip, #1
a014bea0  ubfx r2, r2, #0x18, #7
a014bea4  ubfx r4, r4, #0x18, #7
a014bea8  mul ip, ip, r2
a014beac  movw lr, #0x307c
a014beb0  movt lr, #0xa06f
a014beb4  movw r0, #0xf080
a014beb8  mul r4, r1, r4
a014bebc  movw r2, #0xe798
a014bec0  ldr r1, [lr, #0xc]
a014bec4  movt r0, #0xa054
a014bec8  ldr r3, [sp, #0x14]
a014becc  movt r2, #0xa054
a014bed0  str ip, [sp, #8]
a014bed4  str r4, [sp, #4]
a014bed8  bl #0xa02a70ec
a014bedc  cmp r5, #0
a014bee0  bne #0xa014bef0
a014bee4  ldr r3, [sp, #0x14]
a014bee8  cmp r3, #0
a014beec  beq #0xa014befc
a014bef0  mov r0, r5
a014bef4  add sp, sp, #0x9c
a014bef8  pop {r4, r5, r6, r7, r8, sb, pc}
a014befc  mov r1, r6
a014bf00  mov r2, r8
a014bf04  mov r3, r7
a014bf08  mov r0, #7
a014bf0c  bl #0xa0155800
a014bf10  mov r0, r5
a014bf14  add sp, sp, #0x9c
a014bf18  pop {r4, r5, r6, r7, r8, sb, pc}
a014bf1c  mvn r5, #0x18
a014bf20  b #0xa014bef0
a0145e10  cmp r0, #0
a0145e14  push {r4, r5, r6, lr}
a0145e18  mov r3, #0
a0145e1c  sub sp, sp, #8
a0145e20  str r3, [sp, #4]
a0145e24  beq #0xa0145ff0
a0145e28  mov r4, r2
a0145e2c  mov r6, r1
a0145e30  mov r5, r0
a0145e34  bl #0xa011f0c8
a0145e38  cmp r0, #0
a0145e3c  bne #0xa0145fe4
a0145e40  bl #0xa011efc4
a0145e44  cmp r0, #0
a0145e48  bne #0xa0145fe4
a0145e4c  cmp r4, #0
a0145e50  movw r1, #0x5c34
a0145e54  strne r0, [r4]
a0145e58  movt r1, #0xa053
a0145e5c  mov r0, r5
a0145e60  blx #0xa04f95d0
a0145e64  cmp r0, #0
a0145e68  moveq r3, r0
a0145e6c  moveq r5, r3
a0145e70  bne #0xa0145f68
a0145e74  movw r2, #0x5cd8
a0145e78  movt r2, #0xa105
a0145e7c  ldrb r2, [r2, #0x22]
a0145e80  cmp r2, r5
a0145e84  beq #0xa0145f4c
a0145e88  movw r4, #0x5cd4
a0145e8c  mov r0, r3
a0145e90  movt r4, #0xa105
a0145e94  ldr r2, [r4]
a0145e98  ldrb r1, [r2, #0x1c]
a0145e9c  bfi r1, r3, #3, #3
a0145ea0  strb r1, [r2, #0x1c]
a0145ea4  bl #0xa0213b5c
a0145ea8  ldr r3, [r4]
a0145eac  ldrb r0, [r3, #0x1d]
a0145eb0  bl #0xa0213c0c
a0145eb4  bl #0xa0213c80
a0145eb8  movw r2, #0xdb3c
a0145ebc  mov r3, r0
a0145ec0  movw r0, #0xdc84
a0145ec4  movt r2, #0xa054
a0145ec8  movw r1, #0x2a2
a0145ecc  movt r0, #0xa054
a0145ed0  bl #0xa02a70ec
a0145ed4  bl #0xa0213c80
a0145ed8  cmp r0, #0
a0145edc  bne #0xa0145fcc
a0145ee0  bl #0xa0213c90
a0145ee4  bl #0xa0213b5c
a0145ee8  mov r0, #2
a0145eec  mov r1, #1
a0145ef0  bl #0xa017888c
a0145ef4  add r0, sp, #4
a0145ef8  bl #0xa01881f4
a0145efc  ldr r3, [sp, #4]
a0145f00  mov r1, #0
a0145f04  movw r0, #0x309
a0145f08  mov r2, r1
a0145f0c  movt r0, #0xf001
a0145f10  ldr r3, [r3, #0x28]
a0145f14  blx r3
a0145f18  ldr r3, [sp, #4]
a0145f1c  mov r0, #4
a0145f20  mov r1, r5
a0145f24  movt r0, #0xd809
a0145f28  mov r2, #0
a0145f2c  ldr r3, [r3, #0x28]
a0145f30  blx r3
a0145f34  cmp r6, #0
a0145f38  beq #0xa0145f40
a0145f3c  bl #0xa018c6d8
a0145f40  mov r0, #0
a0145f44  add sp, sp, #8
a0145f48  pop {r4, r5, r6, pc}
a0145f4c  cmp r4, #0
a0145f50  movne r3, #1
a0145f54  movne r0, #0
a0145f58  strne r3, [r4]
a0145f5c  beq #0xa0145f40
a0145f60  add sp, sp, #8
a0145f64  pop {r4, r5, r6, pc}
a0145f68  movw r1, #0x5c6c
a0145f6c  mov r0, r5
a0145f70  movt r1, #0xa053
a0145f74  blx #0xa04f95d0
a0145f78  cmp r0, #0
a0145f7c  moveq r3, #1
a0145f80  moveq r5, #3
a0145f84  beq #0xa0145e74
a0145f88  movw r1, #0x5c5c
a0145f8c  mov r0, r5
a0145f90  movt r1, #0xa053
a0145f94  blx #0xa04f95d0
a0145f98  cmp r0, #0
a0145f9c  moveq r3, #2
a0145fa0  moveq r5, r3
a0145fa4  beq #0xa0145e74
a0145fa8  movw r1, #0x5c44
a0145fac  mov r0, r5
a0145fb0  movt r1, #0xa053
a0145fb4  blx #0xa04f95d0
a0145fb8  cmp r0, #0
a0145fbc  bne #0xa0145ff8
a0145fc0  mov r3, #4
a0145fc4  mov r5, #1
a0145fc8  b #0xa0145e74
a0145fcc  bl #0xa0213c80
a0145fd0  bl #0xa0213af8
a0145fd4  mov r1, #1
a0145fd8  mov r0, #2
a0145fdc  bl #0xa0178868
a0145fe0  b #0xa0145ef4
a0145fe4  mvn r0, #0x14
a0145fe8  add sp, sp, #8
a0145fec  pop {r4, r5, r6, pc}
a0145ff0  mvn r0, #0
a0145ff4  b #0xa0145f44
a0145ff8  mvn r0, #0x18
a0145ffc  b #0xa0145f44
a0158aa8  push {r4, r5, r6, r7, r8, lr}
a0158aac  adds r5, r0, #0
a0158ab0  movne r5, #1
a0158ab4  mov r4, #0
a0158ab8  mov r6, r1
a0158abc  sub sp, sp, #8
a0158ac0  mov r7, r0
a0158ac4  mov r1, r5
a0158ac8  mov r0, r6
a0158acc  mov r2, r4
a0158ad0  mov r3, #1
a0158ad4  str r4, [sp, #4]
a0158ad8  bl #0xa014bf24
a0158adc  cmp r5, r4
a0158ae0  beq #0xa0158b7c
a0158ae4  mov r8, r0
a0158ae8  add r0, sp, #4
a0158aec  bl #0xa0247160
a0158af0  movw r1, #0x618c
a0158af4  mov r2, r8
a0158af8  movt r1, #0xa053
a0158afc  ldr r0, [sp, #4]
a0158b00  bl #0xa0247230
a0158b04  movw r1, #0x6194
a0158b08  mov r2, #2
a0158b0c  movt r1, #0xa053
a0158b10  ldr r0, [sp, #4]
a0158b14  bl #0xa0247230
a0158b18  movw r1, #0x619c
a0158b1c  mov r2, r6
a0158b20  movt r1, #0xa053
a0158b24  ldr r0, [sp, #4]
a0158b28  bl #0xa0247290
a0158b2c  movw r1, #0x6d88
a0158b30  mov r2, r7
a0158b34  movt r1, #0xa061
a0158b38  ldr r0, [sp, #4]
a0158b3c  bl #0xa0247290
a0158b40  mov r0, r7
a0158b44  bl #0xa01555c8
a0158b48  movw r1, #0xf510
a0158b4c  cmp r0, r4
a0158b50  ldrgt r0, [sp, #4]
a0158b54  movtgt r1, #0xa054
a0158b58  movgt r2, #1
a0158b5c  movle r2, r4
a0158b60  movtle r1, #0xa054
a0158b64  ldrle r0, [sp, #4]
a0158b68  bl #0xa0247230
a0158b6c  ldr r0, [sp, #4]
a0158b70  bl #0xa0192724
a0158b74  ldr r0, [sp, #4]
a0158b78  bl #0xa02471d0
a0158b7c  mov r0, #0
a0158b80  add sp, sp, #8
a0158b84  pop {r4, r5, r6, r7, r8, pc}
a014bf24  push {r4, r5, r6, r7, r8, sb, lr}
a014bf28  mov ip, #0
a014bf2c  sub sp, sp, #0x9c
a014bf30  mov r6, r0
a014bf34  mov sb, r1
a014bf38  mov r8, r2
a014bf3c  mov r1, ip
a014bf40  add r0, sp, #0x18
a014bf44  mov r2, #0x80
a014bf48  mov r7, r3
a014bf4c  str ip, [sp, #0x14]
a014bf50  strb ip, [sp, #0x13]
a014bf54  blx #0xa04f8dec
a014bf58  cmp r6, #0
a014bf5c  beq #0xa014c070
a014bf60  bl #0xa0104ac8
a014bf64  mov r0, #1
a014bf68  bl #0xa012f38c
a014bf6c  mov r1, sb
a014bf70  add r2, sp, #0x14
a014bf74  mov r0, r6
a014bf78  bl #0xa0146228
a014bf7c  add r1, sp, #0x18
a014bf80  mov r5, r0
a014bf84  mov r2, #0x80
a014bf88  add r0, sp, #0x13
a014bf8c  bl #0xa0151344
a014bf90  cmp r5, #0
a014bf94  ldr ip, [sp, #0x14]
a014bf98  rsblt r4, r5, #0
a014bf9c  lslge r3, r5, #0x18
a014bfa0  orrlt r4, r4, #0x80
a014bfa4  lsllt r3, r4, #0x18
a014bfa8  cmp r0, #0
a014bfac  rsblt r0, r0, #0
a014bfb0  str ip, [sp]
a014bfb4  orrlt r0, r0, #0x80
a014bfb8  add r1, sp, #0x18
a014bfbc  lsl r4, r0, #0x10
a014bfc0  mov r2, sb
a014bfc4  ldrb r0, [sp, #0x13]
a014bfc8  orr r4, r4, r3
a014bfcc  mov r3, r4
a014bfd0  bl #0xa0143658
a014bfd4  lsl r2, r4, #8
a014bfd8  cmp r4, #0
a014bfdc  mvnlt r1, #0
a014bfe0  str r0, [sp]
a014bfe4  movge r1, #1
a014bfe8  cmp r2, #0
a014bfec  mvnlt ip, #0
a014bff0  movge ip, #1
a014bff4  ubfx r2, r2, #0x18, #7
a014bff8  ubfx r4, r4, #0x18, #7
a014bffc  mul ip, ip, r2
a014c000  movw lr, #0x307c
a014c004  movt lr, #0xa06f
a014c008  movw r0, #0xf080
a014c00c  mul r4, r1, r4
a014c010  movw r2, #0xe8f4
a014c014  ldr r1, [lr, #0xc]
a014c018  movt r0, #0xa054
a014c01c  ldr r3, [sp, #0x14]
a014c020  movt r2, #0xa054
a014c024  str ip, [sp, #8]
a014c028  str r4, [sp, #4]
a014c02c  bl #0xa02a70ec
a014c030  cmp r5, #0
a014c034  bne #0xa014c044
a014c038  ldr r3, [sp, #0x14]
a014c03c  cmp r3, #0
a014c040  beq #0xa014c050
a014c044  mov r0, r5
a014c048  add sp, sp, #0x9c
a014c04c  pop {r4, r5, r6, r7, r8, sb, pc}
a014c050  mov r1, r6
a014c054  mov r2, r8
a014c058  mov r3, r7
a014c05c  mov r0, #0x3d
a014c060  bl #0xa0155800
a014c064  mov r0, r5
a014c068  add sp, sp, #0x9c
a014c06c  pop {r4, r5, r6, r7, r8, sb, pc}
a014c070  mvn r5, #0x18
a014c074  b #0xa014c044
a0146228  cmp r0, #0
a014622c  push {r4, r5, lr}
a0146230  mov r3, #0
a0146234  sub sp, sp, #0xc
a0146238  str r3, [sp, #4]
a014623c  beq #0xa0146380
a0146240  mov r4, r2
a0146244  mov r5, r0
a0146248  bl #0xa011f084
a014624c  cmp r0, #0
a0146250  bne #0xa0146374
a0146254  bl #0xa011efc4
a0146258  cmp r0, #0
a014625c  bne #0xa0146374
a0146260  cmp r4, #0
a0146264  movw r1, #0xaf98
a0146268  strne r0, [r4]
a014626c  movt r1, #0xa053
a0146270  mov r0, r5
a0146274  blx #0xa04f95d0
a0146278  cmp r0, #0
a014627c  moveq r1, #0x40
a0146280  moveq r5, #4
a0146284  bne #0xa01462f0
a0146288  movw r3, #0x5cd8
a014628c  movt r3, #0xa105
a0146290  ldrb r2, [r3, #0x22]
a0146294  cmp r2, r5
a0146298  beq #0xa01462d0
a014629c  add r0, sp, #4
a01462a0  strb r1, [r3, #0x2d]
a01462a4  bl #0xa01881f4
a01462a8  ldr r3, [sp, #4]
a01462ac  mov r0, #4
a01462b0  mov r1, r5
a01462b4  movt r0, #0xd809
a01462b8  mov r2, #0
a01462bc  ldr r3, [r3, #0x28]
a01462c0  blx r3
a01462c4  mov r0, #0
a01462c8  add sp, sp, #0xc
a01462cc  pop {r4, r5, pc}
a01462d0  cmp r4, #0
a01462d4  moveq r0, r4
a01462d8  beq #0xa01462c8
a01462dc  mov r3, #1
a01462e0  mov r0, #0
a01462e4  str r3, [r4]
a01462e8  add sp, sp, #0xc
a01462ec  pop {r4, r5, pc}
a01462f0  movw r1, #0x5c84
a01462f4  mov r0, r5
a01462f8  movt r1, #0xa053
a01462fc  blx #0xa04f95d0
a0146300  cmp r0, #0
a0146304  moveq r1, #0x80
a0146308  moveq r5, #5
a014630c  beq #0xa0146288
a0146310  movw r1, #0x5ca4
a0146314  mov r0, r5
a0146318  movt r1, #0xa053
a014631c  blx #0xa04f95d0
a0146320  cmp r0, #0
a0146324  moveq r1, #0xc0
a0146328  moveq r5, #7
a014632c  beq #0xa0146288
a0146330  movw r1, #0x5c98
a0146334  mov r0, r5
a0146338  movt r1, #0xa053
a014633c  blx #0xa04f95d0
a0146340  cmp r0, #0
a0146344  moveq r1, #0x20
a0146348  moveq r5, #6
a014634c  beq #0xa0146288
a0146350  movw r1, #0x5cb4
a0146354  mov r0, r5
a0146358  movt r1, #0xa053
a014635c  blx #0xa04f95d0
a0146360  cmp r0, #0
a0146364  bne #0xa0146388
a0146368  mov r1, #0x60
a014636c  mov r5, #8
a0146370  b #0xa0146288
a0146374  mvn r0, #0x14
a0146378  add sp, sp, #0xc
a014637c  pop {r4, r5, pc}
a0146380  mvn r0, #0
a0146384  b #0xa01462c8
a0146388  mvn r0, #0x18
a014638c  b #0xa01462c8
