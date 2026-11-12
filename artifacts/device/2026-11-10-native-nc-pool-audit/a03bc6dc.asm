a03bc6dc 010073e3 cmn r3, #1
a03bc6e0 0a00000a beq #0xa03bc710
a03bc6e4 83c3a0e1 lsl ip, r3, #7
a03bc6e8 30002de9 push {r4, r5}
a03bc6ec d34d04e3 movw r4, #0x4dd3
a03bc6f0 03c14ce0 sub ip, ip, r3, lsl #2
a03bc6f4 624041e3 movt r4, #0x1062
a03bc6f8 03308ce0 add r3, ip, r3
a03bc6fc 8331a0e1 lsl r3, r3, #3
a03bc700 934485e0 umull r4, r5, r3, r4
a03bc704 2533a0e1 lsr r3, r5, #6
a03bc708 3000bde8 pop {r4, r5}
a03bc70c 4d1b00ea b #0xa03c3448
a03bc710 4c1b00ea b #0xa03c3448
a03bcd20 f0472de9 push {r4, r5, r6, r7, r8, sb, sl, lr}
a03bcd24 032082e2 add r2, r2, #3
a03bcd28 0380c2e3 bic r8, r2, #3
a03bcd2c 0190a0e1 mov sb, r1
a03bcd30 03a0a0e1 mov sl, r3
a03bcd34 0040a0e1 mov r4, r0
a03bcd38 9c1100eb bl #0xa03c13b0
a03bcd3c 0050a0e1 mov r5, r0
a03bcd40 011000eb bl #0xa03c0d4c
a03bcd44 0060a0e1 mov r6, r0
a03bcd48 020000ea b #0xa03bcd58
a03bcd4c 203094e5 ldr r3, [r4, #0x20]
a03bcd50 060053e1 cmp r3, r6
a03bcd54 1000000a beq #0xa03bcd9c
a03bcd58 0500a0e1 mov r0, r5
a03bcd5c 206084e5 str r6, [r4, #0x20]
a03bcd60 b01100eb bl #0xa03c1428
a03bcd64 0810a0e1 mov r1, r8
a03bcd68 0400a0e1 mov r0, r4
a03bcd6c ef0000eb bl #0xa03bd130
a03bcd70 0070a0e1 mov r7, r0
a03bcd74 8d1100eb bl #0xa03c13b0
a03bcd78 000057e3 cmp r7, #0
a03bcd7c 0050a0e1 mov r5, r0
a03bcd80 f1ffff0a beq #0xa03bcd4c
a03bcd84 0040a0e3 mov r4, #0
a03bcd88 007089e5 str r7, [sb]
a03bcd8c 0500a0e1 mov r0, r5
a03bcd90 a41100eb bl #0xa03c1428
a03bcd94 0400a0e1 mov r0, r4
a03bcd98 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03bcd9c 00005ae3 cmp sl, #0
a03bcda0 2100000a beq #0xa03bce2c
a03bcda4 343e0ce3 movw r3, #0xce34
a03bcda8 704086e5 str r4, [r6, #0x70]
a03bcdac 3b304ae3 movt r3, #0xa03b
a03bcdb0 809086e5 str sb, [r6, #0x80]
a03bcdb4 7c8086e5 str r8, [r6, #0x7c]
a03bcdb8 0110a0e3 mov r1, #1
a03bcdbc 6c3086e5 str r3, [r6, #0x6c]
a03bcdc0 09c0a0e3 mov ip, #9
a03bcdc4 283094e5 ldr r3, [r4, #0x28]
a03bcdc8 000053e3 cmp r3, #0
a03bcdcc 013083e2 add r3, r3, #1
a03bcdd0 283084e5 str r3, [r4, #0x28]
a03bcdd4 24309415 ldrne r3, [r4, #0x24]
a03bcdd8 24608405 streq r6, [r4, #0x24]
a03bcddc 74608605 streq r6, [r6, #0x74]
a03bcde0 74308615 strne r3, [r6, #0x74]
a03bcde4 78209315 ldrne r2, [r3, #0x78]
a03bcde8 78608605 streq r6, [r6, #0x78]
a03bcdec 78208615 strne r2, [r6, #0x78]
a03bcdf0 74608215 strne r6, [r2, #0x74]
a03bcdf4 78608315 strne r6, [r3, #0x78]
a03bcdf8 803706e3 movw r3, #0x6780
a03bcdfc 79314ae3 movt r3, #0xa179
a03bce00 30c086e5 str ip, [r6, #0x30]
a03bce04 002093e5 ldr r2, [r3]
a03bce08 381086e5 str r1, [r6, #0x38]
a03bce0c 4ca086e5 str sl, [r6, #0x4c]
a03bce10 012082e0 add r2, r2, r1
a03bce14 002083e5 str r2, [r3]
a03bce18 821100eb bl #0xa03c1428
a03bce1c 0600a0e1 mov r0, r6
a03bce20 cd1300eb bl #0xa03c1d5c
a03bce24 880096e5 ldr r0, [r6, #0x88]
a03bce28 f087bde8 pop {r4, r5, r6, r7, r8, sb, sl, pc}
a03bce2c 1040a0e3 mov r4, #0x10
a03bce30 d5ffffea b #0xa03bcd8c
