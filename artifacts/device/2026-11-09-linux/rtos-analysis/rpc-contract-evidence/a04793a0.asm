a04793a0 002050e2 subs r2, r0, #0
a04793a4 f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a04793a8 2cd04de2 sub sp, sp, #0x2c
a04793ac 8000000a beq #0xa04795b4
a04793b0 043f00e3 movw r3, #0xf04
a04793b4 a3314ae3 movt r3, #0xa1a3
a04793b8 0040d3e5 ldrb r4, [r3]
a04793bc 000054e3 cmp r4, #0
a04793c0 7200001a bne #0xa0479590
a04793c4 141092e5 ldr r1, [r2, #0x14]
a04793c8 0150a0e3 mov r5, #1
a04793cc 0050c3e5 strb r5, [r3]
a04793d0 006f00e3 movw r6, #0xf00
a04793d4 a3614ae3 movt r6, #0xa1a3
a04793d8 38ad08e3 movw sl, #0x8d38
a04793dc 01e0a0e1 mov lr, r1
a04793e0 001092e5 ldr r1, [r2]
a04793e4 0e00a0e1 mov r0, lr
a04793e8 14e08de5 str lr, [sp, #0x14]
a04793ec 47a04ae3 movt sl, #0xa047
a04793f0 c08d08e3 movw r8, #0x8dc0
a04793f4 041083e5 str r1, [r3, #4]
a04793f8 707e08e3 movw r7, #0x8e70
a04793fc 041092e5 ldr r1, [r2, #4]
a0479400 47804ae3 movt r8, #0xa047
a0479404 47704ae3 movt r7, #0xa047
a0479408 b0bc08e3 movw fp, #0x8cb0
a047940c 049009e3 movw sb, #0x9004
a0479410 47b04ae3 movt fp, #0xa047
a0479414 081083e5 str r1, [r3, #8]
a0479418 47904ae3 movt sb, #0xa047
a047941c 081092e5 ldr r1, [r2, #8]
a0479420 0c1083e5 str r1, [r3, #0xc]
a0479424 0c1092e5 ldr r1, [r2, #0xc]
a0479428 101083e5 str r1, [r3, #0x10]
a047942c 103092e5 ldr r3, [r2, #0x10]
a0479430 1c308de5 str r3, [sp, #0x1c]
a0479434 a74ffdeb bl #0xa03cd2d8
a0479438 0f20a0e3 mov r2, #0xf
a047943c 000086e5 str r0, [r6]
a0479440 7800a0e3 mov r0, #0x78
a0479444 20208de5 str r2, [sp, #0x20]
a0479448 a24ffdeb bl #0xa03cd2d8
a047944c 0020a0e1 mov r2, r0
a0479450 44c708e3 movw ip, #0x8744
a0479454 24208de5 str r2, [sp, #0x24]
a0479458 47c04ae3 movt ip, #0xa047
a047945c 044082e5 str r4, [r2, #4]
a0479460 643f08e3 movw r3, #0x8f64
a0479464 24e09de5 ldr lr, [sp, #0x24]
a0479468 47304ae3 movt r3, #0xa047
a047946c 18308de5 str r3, [sp, #0x18]
a0479470 202808e3 movw r2, #0x8820
a0479474 f41c08e3 movw r1, #0x8cf4
a0479478 47204ae3 movt r2, #0xa047
a047947c 00c08ee5 str ip, [lr]
a0479480 20ef08e3 movw lr, #0x8f20
a0479484 24c09de5 ldr ip, [sp, #0x24]
a0479488 47104ae3 movt r1, #0xa047
a047948c 47e04ae3 movt lr, #0xa047
a0479490 1c309de5 ldr r3, [sp, #0x1c]
a0479494 4102a0e3 mov r0, #0x10000004
a0479498 20a08ce5 str sl, [ip, #0x20]
a047949c 18a09de5 ldr sl, [sp, #0x18]
a04794a0 08208ce5 str r2, [ip, #8]
a04794a4 ac2608e3 movw r2, #0x86ac
a04794a8 18108ce5 str r1, [ip, #0x18]
a04794ac 381908e3 movw r1, #0x8938
a04794b0 28808ce5 str r8, [ip, #0x28]
a04794b4 008b08e3 movw r8, #0x8b00
a04794b8 30708ce5 str r7, [ip, #0x30]
a04794bc ac7b08e3 movw r7, #0x8bac
a04794c0 38e08ce5 str lr, [ip, #0x38]
a04794c4 20ec08e3 movw lr, #0x8c20
a04794c8 47204ae3 movt r2, #0xa047
a04794cc 47104ae3 movt r1, #0xa047
a04794d0 47e04ae3 movt lr, #0xa047
a04794d4 47804ae3 movt r8, #0xa047
a04794d8 47704ae3 movt r7, #0xa047
a04794dc 48908ce5 str sb, [ip, #0x48]
a04794e0 50208ce5 str r2, [ip, #0x50]
a04794e4 20908de2 add sb, sp, #0x20
a04794e8 58108ce5 str r1, [ip, #0x58]
a04794ec e82306e3 movw r2, #0x63e8
a04794f0 0c408ce5 str r4, [ip, #0xc]
a04794f4 0510a0e1 mov r1, r5
a04794f8 14408ce5 str r4, [ip, #0x14]
a04794fc 62204ae3 movt r2, #0xa062
a0479500 1c408ce5 str r4, [ip, #0x1c]
a0479504 24408ce5 str r4, [ip, #0x24]
a0479508 2c408ce5 str r4, [ip, #0x2c]
a047950c 34408ce5 str r4, [ip, #0x34]
a0479510 3c408ce5 str r4, [ip, #0x3c]
a0479514 44408ce5 str r4, [ip, #0x44]
a0479518 4c408ce5 str r4, [ip, #0x4c]
a047951c 54408ce5 str r4, [ip, #0x54]
a0479520 5c408ce5 str r4, [ip, #0x5c]
a0479524 64408ce5 str r4, [ip, #0x64]
a0479528 6c408ce5 str r4, [ip, #0x6c]
a047952c 74408ce5 str r4, [ip, #0x74]
a0479530 10b08ce5 str fp, [ip, #0x10]
a0479534 40a08ce5 str sl, [ip, #0x40]
a0479538 60808ce5 str r8, [ip, #0x60]
a047953c 70e08ce5 str lr, [ip, #0x70]
a0479540 68708ce5 str r7, [ip, #0x68]
a0479544 14e09de5 ldr lr, [sp, #0x14]
a0479548 00c096e5 ldr ip, [r6]
a047954c 0c508de5 str r5, [sp, #0xc]
a0479550 04e08de5 str lr, [sp, #4]
a0479554 00c08de5 str ip, [sp]
a0479558 08908de5 str sb, [sp, #8]
a047955c 5445fdeb bl #0xa03caab4
a0479560 24009de5 ldr r0, [sp, #0x24]
a0479564 3e4ffdeb bl #0xa03cd264
a0479568 0400a0e1 mov r0, r4
a047956c 0520a0e1 mov r2, r5
a0479570 4212a0e3 mov r1, #0x20000004
a0479574 462efdeb bl #0xa03c4e94
a0479578 183f00e3 movw r3, #0xf18
a047957c a3314ae3 movt r3, #0xa1a3
a0479580 000083e5 str r0, [r3]
a0479584 0400a0e1 mov r0, r4
a0479588 2cd08de2 add sp, sp, #0x2c
a047958c f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a0479590 d00306e3 movw r0, #0x63d0
a0479594 681206e3 movw r1, #0x6268
a0479598 62104ae3 movt r1, #0xa062
a047959c 0040a0e3 mov r4, #0
a04795a0 62004ae3 movt r0, #0xa062
a04795a4 d0b6f8eb bl #0xa02a70ec
a04795a8 0400a0e1 mov r0, r4
a04795ac 2cd08de2 add sp, sp, #0x2c
a04795b0 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a04795b4 b80106e3 movw r0, #0x61b8
a04795b8 681206e3 movw r1, #0x6268
a04795bc 62004ae3 movt r0, #0xa062
a04795c0 62104ae3 movt r1, #0xa062
a04795c4 c8b6f8eb bl #0xa02a70ec
a04795c8 0040e0e3 mvn r4, #0
a04795cc ecffffea b #0xa0479584
