
; 0xA02C61D4..0xA02C6270 (end exclusive)
A02C61D4: 38402de9  push {r3, r4, r5, lr}
A02C61D8: 004050e2  subs r4, r0, #0
A02C61DC: 0500000a  beq #0xa02c61f8
A02C61E0: 803303e3  movw r3, #0x3380
A02C61E4: 6f304ae3  movt r3, #0xa06f
A02C61E8: 003093e5  ldr r3, [r3]
A02C61EC: 580093e5  ldr r0, [r3, #0x58]
A02C61F0: 000050e3  cmp r0, #0
A02C61F4: 0100001a  bne #0xa02c6200
A02C61F8: 0000a0e3  mov r0, #0
A02C61FC: 3880bde8  pop {r3, r4, r5, pc}
A02C6200: 0150a0e1  mov r5, r1
A02C6204: 727607eb  bl #0xa04a3bd4
A02C6208: 000055e3  cmp r5, #0
A02C620C: 0300000a  beq #0xa02c6220
A02C6210: 203094e5  ldr r3, [r4, #0x20]
A02C6214: 3c3080e5  str r3, [r0, #0x3c]
A02C6218: 0000a0e3  mov r0, #0
A02C621C: 3880bde8  pop {r3, r4, r5, pc}
A02C6220: 103090e5  ldr r3, [r0, #0x10]
A02C6224: 003084e5  str r3, [r4]
A02C6228: 203090e5  ldr r3, [r0, #0x20]
A02C622C: 043084e5  str r3, [r4, #4]
A02C6230: 243090e5  ldr r3, [r0, #0x24]
A02C6234: 083084e5  str r3, [r4, #8]
A02C6238: 283090e5  ldr r3, [r0, #0x28]
A02C623C: 0c3084e5  str r3, [r4, #0xc]
A02C6240: 2c3090e5  ldr r3, [r0, #0x2c]
A02C6244: 103084e5  str r3, [r4, #0x10]
A02C6248: 303090e5  ldr r3, [r0, #0x30]
A02C624C: 143084e5  str r3, [r4, #0x14]
A02C6250: 343090e5  ldr r3, [r0, #0x34]
A02C6254: 183084e5  str r3, [r4, #0x18]
A02C6258: 383090e5  ldr r3, [r0, #0x38]
A02C625C: 1c3084e5  str r3, [r4, #0x1c]
A02C6260: 3c3090e5  ldr r3, [r0, #0x3c]
A02C6264: 0000a0e3  mov r0, #0
A02C6268: 203084e5  str r3, [r4, #0x20]
A02C626C: 3880bde8  pop {r3, r4, r5, pc}

; 0xA0387794..0xA03877D4 (end exclusive)
A0387794: c80f0ae3  movw r0, #0xafc8
A0387798: 70014ae3  movt r0, #0xa170
A038779C: 0010a0e3  mov r1, #0
A03877A0: 8bfafceb  bl #0xa02c61d4
A03877A4: c83f0ae3  movw r3, #0xafc8
A03877A8: 70314ae3  movt r3, #0xa170
A03877AC: 203093e5  ldr r3, [r3, #0x20]
A03877B0: 010073e3  cmn r3, #1
A03877B4: ea02000a  beq #0xa0388364
A03877B8: c83f0ae3  movw r3, #0xafc8
A03877BC: 70314ae3  movt r3, #0xa170
A03877C0: 202093e5  ldr r2, [r3, #0x20]
A03877C4: ef3e0be3  movw r3, #0xbeef
A03877C8: ad3e4de3  movt r3, #0xdead
A03877CC: 030052e1  cmp r2, r3
A03877D0: e302000a  beq #0xa0388364

; 0xA0387920..0xA0387960 (end exclusive)
A0387920: c83f0ae3  movw r3, #0xafc8
A0387924: 70314ae3  movt r3, #0xa170
A0387928: 203093e5  ldr r3, [r3, #0x20]
A038792C: 7320efe6  uxtb r2, r3
A0387930: c03f0ae3  movw r3, #0xafc0
A0387934: 70314ae3  movt r3, #0xa170
A0387938: 002083e5  str r2, [r3]
A038793C: c83f0ae3  movw r3, #0xafc8
A0387940: 70314ae3  movt r3, #0xa170
A0387944: 203093e5  ldr r3, [r3, #0x20]
A0387948: 7330ffe6  uxth r3, r3
A038794C: 013c03e2  and r3, r3, #0x100
A0387950: 7320ffe6  uxth r2, r3
A0387954: c43f0ae3  movw r3, #0xafc4
A0387958: 70314ae3  movt r3, #0xa170
A038795C: b020c3e1  strh r2, [r3]

; 0xA0387C8C..0xA0387CB0 (end exclusive)
A0387C8C: c82f0ae3  movw r2, #0xafc8
A0387C90: 70214ae3  movt r2, #0xa170
A0387C94: ef3e0be3  movw r3, #0xbeef
A0387C98: ad3e4de3  movt r3, #0xdead
A0387C9C: 203082e5  str r3, [r2, #0x20]
A0387CA0: c80f0ae3  movw r0, #0xafc8
A0387CA4: 70014ae3  movt r0, #0xa170
A0387CA8: 0110a0e3  mov r1, #1
A0387CAC: 48f9fceb  bl #0xa02c61d4

; 0xA0389FA8..0xA038A104 (end exclusive)
A0389FA8: 1b3b0ae3  movw r3, #0xab1b
A0389FAC: 70314ae3  movt r3, #0xa170
A0389FB0: 0030d3e5  ldrb r3, [r3]
A0389FB4: 013043e2  sub r3, r3, #1
A0389FB8: 0320a0e1  mov r2, r3
A0389FBC: 103304e3  movw r3, #0x4310
A0389FC0: 70314ae3  movt r3, #0xa170
A0389FC4: 202083e5  str r2, [r3, #0x20]
A0389FC8: 1b3b0ae3  movw r3, #0xab1b
A0389FCC: 70314ae3  movt r3, #0xa170
A0389FD0: 0030d3e5  ldrb r3, [r3]
A0389FD4: 011043e2  sub r1, r3, #1
A0389FD8: 2c3204e3  movw r3, #0x422c
A0389FDC: 70314ae3  movt r3, #0xa170
A0389FE0: 000093e5  ldr r0, [r3]
A0389FE4: a0230be3  movw r2, #0xb3a0
A0389FE8: 70214ae3  movt r2, #0xa170
A0389FEC: 8131a0e1  lsl r3, r1, #3
A0389FF0: 0310a0e1  mov r1, r3
A0389FF4: 0131a0e1  lsl r3, r1, #2
A0389FF8: 033061e0  rsb r3, r1, r3
A0389FFC: 033082e0  add r3, r2, r3
A038A000: 000083e5  str r0, [r3]
A038A004: 1b3b0ae3  movw r3, #0xab1b
A038A008: 70314ae3  movt r3, #0xa170
A038A00C: 0030d3e5  ldrb r3, [r3]
A038A010: 011043e2  sub r1, r3, #1
A038A014: 003404e3  movw r3, #0x4400
A038A018: 70314ae3  movt r3, #0xa170
A038A01C: 880093e5  ldr r0, [r3, #0x88]
A038A020: a0230be3  movw r2, #0xb3a0
A038A024: 70214ae3  movt r2, #0xa170
A038A028: 8131a0e1  lsl r3, r1, #3
A038A02C: 0310a0e1  mov r1, r3
A038A030: 0131a0e1  lsl r3, r1, #2
A038A034: 033061e0  rsb r3, r1, r3
A038A038: 033082e0  add r3, r2, r3
A038A03C: 040083e5  str r0, [r3, #4]
A038A040: 1b3b0ae3  movw r3, #0xab1b
A038A044: 70314ae3  movt r3, #0xa170
A038A048: 0030d3e5  ldrb r3, [r3]
A038A04C: 011043e2  sub r1, r3, #1
A038A050: 003404e3  movw r3, #0x4400
A038A054: 70314ae3  movt r3, #0xa170
A038A058: 8c0093e5  ldr r0, [r3, #0x8c]
A038A05C: a0230be3  movw r2, #0xb3a0
A038A060: 70214ae3  movt r2, #0xa170
A038A064: 8131a0e1  lsl r3, r1, #3
A038A068: 0310a0e1  mov r1, r3
A038A06C: 0131a0e1  lsl r3, r1, #2
A038A070: 033061e0  rsb r3, r1, r3
A038A074: 033082e0  add r3, r2, r3
A038A078: 083083e2  add r3, r3, #8
A038A07C: 000083e5  str r0, [r3]
A038A080: 1b3b0ae3  movw r3, #0xab1b
A038A084: 70314ae3  movt r3, #0xa170
A038A088: 0030d3e5  ldrb r3, [r3]
A038A08C: 011043e2  sub r1, r3, #1
A038A090: ac3e0ae3  movw r3, #0xaeac
A038A094: 70314ae3  movt r3, #0xa170
A038A098: 000093e5  ldr r0, [r3]
A038A09C: a0230be3  movw r2, #0xb3a0
A038A0A0: 70214ae3  movt r2, #0xa170
A038A0A4: 8131a0e1  lsl r3, r1, #3
A038A0A8: 0310a0e1  mov r1, r3
A038A0AC: 0131a0e1  lsl r3, r1, #2
A038A0B0: 033061e0  rsb r3, r1, r3
A038A0B4: 033082e0  add r3, r2, r3
A038A0B8: 083083e2  add r3, r3, #8
A038A0BC: 040083e5  str r0, [r3, #4]
A038A0C0: 1b3b0ae3  movw r3, #0xab1b
A038A0C4: 70314ae3  movt r3, #0xa170
A038A0C8: 0030d3e5  ldrb r3, [r3]
A038A0CC: 011043e2  sub r1, r3, #1
A038A0D0: 003f0ae3  movw r3, #0xaf00
A038A0D4: 70314ae3  movt r3, #0xa170
A038A0D8: 000093e5  ldr r0, [r3]
A038A0DC: a0230be3  movw r2, #0xb3a0
A038A0E0: 70214ae3  movt r2, #0xa170
A038A0E4: 8131a0e1  lsl r3, r1, #3
A038A0E8: 0310a0e1  mov r1, r3
A038A0EC: 0131a0e1  lsl r3, r1, #2
A038A0F0: 033061e0  rsb r3, r1, r3
A038A0F4: 033082e0  add r3, r2, r3
A038A0F8: 103083e2  add r3, r3, #0x10
A038A0FC: 000083e5  str r0, [r3]
A038A100: 1b3b0ae3  movw r3, #0xab1b

; 0xA038A624..0xA038A68C (end exclusive)
A038A624: b83f0ae3  movw r3, #0xafb8
A038A628: 70314ae3  movt r3, #0xa170
A038A62C: 0030d3e5  ldrb r3, [r3]
A038A630: 000053e3  cmp r3, #0
A038A634: 1000000a  beq #0xa038a67c
A038A638: 103304e3  movw r3, #0x4310
A038A63C: 70314ae3  movt r3, #0xa170
A038A640: 203093e5  ldr r3, [r3, #0x20]
A038A644: 012c83e3  orr r2, r3, #0x100
A038A648: 103304e3  movw r3, #0x4310
A038A64C: 70314ae3  movt r3, #0xa170
A038A650: 202083e5  str r2, [r3, #0x20]
A038A654: f83a07e3  movw r3, #0x7af8
A038A658: 75304ae3  movt r3, #0xa075
A038A65C: be30d3e1  ldrh r3, [r3, #0xe]
A038A660: 000053e3  cmp r3, #0
A038A664: 0800000a  beq #0xa038a68c
A038A668: 103304e3  movw r3, #0x4310
A038A66C: 70314ae3  movt r3, #0xa170
A038A670: 0020a0e3  mov r2, #0
A038A674: 242083e5  str r2, [r3, #0x24]
A038A678: 030000ea  b #0xa038a68c
A038A67C: 103304e3  movw r3, #0x4310
A038A680: 70314ae3  movt r3, #0xa170
A038A684: 0020a0e3  mov r2, #0
A038A688: 242083e5  str r2, [r3, #0x24]

; 0xA038B264..0xA038B2AC (end exclusive)
A038B264: da3504e3  movw r3, #0x45da
A038B268: 70314ae3  movt r3, #0xa170
A038B26C: 0030d3e5  ldrb r3, [r3]
A038B270: 000053e3  cmp r3, #0
A038B274: 0d00001a  bne #0xa038b2b0
A038B278: f83a07e3  movw r3, #0x7af8
A038B27C: 75304ae3  movt r3, #0xa075
A038B280: bc33d3e1  ldrh r3, [r3, #0x3c]
A038B284: 000053e3  cmp r3, #0
A038B288: 0800001a  bne #0xa038b2b0
A038B28C: 503504e3  movw r3, #0x4550
A038B290: 70314ae3  movt r3, #0xa170
A038B294: 003093e5  ldr r3, [r3]
A038B298: 100304e3  movw r0, #0x4310
A038B29C: 70014ae3  movt r0, #0xa170
A038B2A0: 0110a0e3  mov r1, #1
A038B2A4: 0320a0e1  mov r2, r3
A038B2A8: 4aebfceb  bl #0xa02c5fd8

; 0xA02C605C..0xA02C60E8 (end exclusive)
A02C605C: 0050d6e5  ldrb r5, [r6]
A02C6060: 053387e7  str r3, [r7, r5, lsl #6]
A02C6064: 042094e5  ldr r2, [r4, #4]
A02C6068: 055387e0  add r5, r7, r5, lsl #6
A02C606C: 042085e5  str r2, [r5, #4]
A02C6070: 082094e5  ldr r2, [r4, #8]
A02C6074: 082085e5  str r2, [r5, #8]
A02C6078: 0c2094e5  ldr r2, [r4, #0xc]
A02C607C: 0c2085e5  str r2, [r5, #0xc]
A02C6080: 202094e5  ldr r2, [r4, #0x20]
A02C6084: 202085e5  str r2, [r5, #0x20]
A02C6088: be21d4e1  ldrh r2, [r4, #0x1e]
A02C608C: be21c5e1  strh r2, [r5, #0x1e]
A02C6090: bc21d4e1  ldrh r2, [r4, #0x1c]
A02C6094: bc21c5e1  strh r2, [r5, #0x1c]
A02C6098: b821d4e1  ldrh r2, [r4, #0x18]
A02C609C: b821c5e1  strh r2, [r5, #0x18]
A02C60A0: ba21d4e1  ldrh r2, [r4, #0x1a]
A02C60A4: ba21c5e1  strh r2, [r5, #0x1a]
A02C60A8: 103094e5  ldr r3, [r4, #0x10]
A02C60AC: 103085e5  str r3, [r5, #0x10]
A02C60B0: 143094e5  ldr r3, [r4, #0x14]
A02C60B4: 143085e5  str r3, [r5, #0x14]
A02C60B8: 243094e5  ldr r3, [r4, #0x24]
A02C60BC: 000053e3  cmp r3, #0
A02C60C0: 24308505  streq r3, [r5, #0x24]
A02C60C4: 1600001a  bne #0xa02c6124
A02C60C8: 0500a0e1  mov r0, r5
A02C60CC: 947607eb  bl #0xa04a3b24
A02C60D0: 0030d6e5  ldrb r3, [r6]
A02C60D4: d82f07e3  movw r2, #0x7fd8
A02C60D8: 45214ae3  movt r2, #0xa145
A02C60DC: 800087e5  str r0, [r7, #0x80]
A02C60E0: 013083e2  add r3, r3, #1
A02C60E4: 7330efe6  uxtb r3, r3

; 0xA03970AC..0xA0397104 (end exclusive)
A03970AC: 001507e3  movw r1, #0x7500
A03970B0: 1a00a0e3  mov r0, #0x1a
A03970B4: 39104ae3  movt r1, #0xa039
A03970B8: 0460a0e1  mov r6, r4
A03970BC: 3ba8fceb  bl #0xa02c11b0
A03970C0: d41407e3  movw r1, #0x74d4
A03970C4: 1c00a0e3  mov r0, #0x1c
A03970C8: 39104ae3  movt r1, #0xa039
A03970CC: 0c408de5  str r4, [sp, #0xc]
A03970D0: 36a8fceb  bl #0xa02c11b0
A03970D4: 20209de5  ldr r2, [sp, #0x20]
A03970D8: fa3fa0e3  mov r3, #0x3e8
A03970DC: 0010e0e3  mvn r1, #0
A03970E0: 5c308de5  str r3, [sp, #0x5c]
A03970E4: 58308de5  str r3, [sp, #0x58]
A03970E8: 58008de2  add r0, sp, #0x58
A03970EC: 0130a0e3  mov r3, #1
A03970F0: 60208de5  str r2, [sp, #0x60]
A03970F4: 10308de5  str r3, [sp, #0x10]
A03970F8: 0480a0e1  mov r8, r4
A03970FC: 64408de5  str r4, [sp, #0x64]
A0397100: eddc03eb  bl #0xa048e4bc

; 0xA0397460..0xA0397474 (end exclusive)
A0397460: 0010a0e3  mov r1, #0
A0397464: 0f0001e3  movw r0, #0x100f
A0397468: 0120a0e1  mov r2, r1
A039746C: 0130a0e1  mov r3, r1
A0397470: 1a6600eb  bl #0xa03b0ce0

; 0xA03974C4..0xA0397594 (end exclusive)
A03974C4: 880b0be3  movw r0, #0xbb88
A03974C8: 0110a0e3  mov r1, #1
A03974CC: 70014ae3  movt r0, #0xa170
A03974D0: 049400ea  b #0xa03bc4e8
A03974D4: 08402de9  push {r3, lr}
A03974D8: 57dc03eb  bl #0xa048e63c
A03974DC: 843a0be3  movw r3, #0xba84
A03974E0: 0810a0e3  mov r1, #8
A03974E4: 70314ae3  movt r3, #0xa170
A03974E8: 000083e5  str r0, [r3]
A03974EC: 880b0be3  movw r0, #0xbb88
A03974F0: 70014ae3  movt r0, #0xa170
A03974F4: fb9300eb  bl #0xa03bc4e8
A03974F8: 0000a0e3  mov r0, #0
A03974FC: 0880bde8  pop {r3, pc}
A0397500: 10402de9  push {r4, lr}
A0397504: 08d04de2  sub sp, sp, #8
A0397508: 4bdc03eb  bl #0xa048e63c
A039750C: 203f00e3  movw r3, #0xf20
A0397510: 904c0be3  movw r4, #0xbc90
A0397514: a3314ae3  movt r3, #0xa1a3
A0397518: 00c0a0e1  mov ip, r0
A039751C: 003093e5  ldr r3, [r3]
A0397520: 70414ae3  movt r4, #0xa170
A0397524: 0000a0e3  mov r0, #0
A0397528: 0120a0e3  mov r2, #1
A039752C: 00c084e5  str ip, [r4]
A0397530: 1201c7e7  bfi r0, r2, #2, #6
A0397534: 283093e5  ldr r3, [r3, #0x28]
A0397538: 000053e3  cmp r3, #0
A039753C: 0200000a  beq #0xa039754c
A0397540: 04108de2  add r1, sp, #4
A0397544: 33ff2fe1  blx r3
A0397548: 00c094e5  ldr ip, [r4]
A039754C: 107a9fed  vldr s14, [pc, #0x40]
A0397550: 243d0be3  movw r3, #0xbd24
A0397554: 017added  vldr s15, [sp, #4]
A0397558: 942c0be3  movw r2, #0xbc94
A039755C: 880b0be3  movw r0, #0xbb88
A0397560: 70314ae3  movt r3, #0xa170
A0397564: 70214ae3  movt r2, #0xa170
A0397568: 0410a0e3  mov r1, #4
A039756C: 70014ae3  movt r0, #0xa170
A0397570: 00c082e5  str ip, [r2]
A0397574: 877a67ee  vmul.f32 s15, s15, s14
A0397578: 877a67ee  vmul.f32 s15, s15, s14
A039757C: e77afcee  vcvt.u32.f32 s15, s15
A0397580: 007ac3ed  vstr s15, [r3]
A0397584: d79300eb  bl #0xa03bc4e8
A0397588: 0000a0e3  mov r0, #0
A039758C: 08d08de2  add sp, sp, #8
A0397590: 1080bde8  pop {r4, pc}

; 0xA02C13D4..0xA02C13F8 (end exclusive)
A02C13D4: 0430bae5  ldr r3, [sl, #4]!
A02C13D8: 000053e3  cmp r3, #0
A02C13DC: f9ffff0a  beq #0xa02c13c8
A02C13E0: 953407eb  bl #0xa048e63c
A02C13E4: 00309ae5  ldr r3, [sl]
A02C13E8: 00b0a0e1  mov fp, r0
A02C13EC: 0700a0e1  mov r0, r7
A02C13F0: 33ff2fe1  blx r3
A02C13F4: 903407eb  bl #0xa048e63c

; 0xA03B1EC0..0xA03B1ED0 (end exclusive)
A03B1EC0: 0e00a0e1  mov r0, lr
A03B1EC4: 0210a0e1  mov r1, r2
A03B1EC8: 0840bde8  pop {r3, lr}
A03B1ECC: 12f5ffea  b #0xa03af31c

; 0xA03AF31C..0xA03AF32C (end exclusive)
A03AF31C: 08402de9  push {r3, lr}
A03AF320: 1659ffeb  bl #0xa0385780
A03AF324: 0000a0e3  mov r0, #0
A03AF328: 0880bde8  pop {r3, pc}

; 0xA03887F0..0xA038887C (end exclusive)
A03887F0: a2390be3  movw r3, #0xb9a2
A03887F4: 70314ae3  movt r3, #0xa170
A03887F8: 0030d3e5  ldrb r3, [r3]
A03887FC: 013083e2  add r3, r3, #1
A0388800: 7320efe6  uxtb r2, r3
A0388804: a2390be3  movw r3, #0xb9a2
A0388808: 70314ae3  movt r3, #0xa170
A038880C: 0020c3e5  strb r2, [r3]
A0388810: 1b3b0ae3  movw r3, #0xab1b
A0388814: 70314ae3  movt r3, #0xa170
A0388818: 0020a0e3  mov r2, #0
A038881C: 0020c3e5  strb r2, [r3]
A0388820: 1e3b0ae3  movw r3, #0xab1e
A0388824: 70314ae3  movt r3, #0xa170
A0388828: 0020a0e3  mov r2, #0
A038882C: 0020c3e5  strb r2, [r3]
A0388830: 1b3b0ae3  movw r3, #0xab1b
A0388834: 70314ae3  movt r3, #0xa170
A0388838: 0030d3e5  ldrb r3, [r3]
A038883C: 3f0053e3  cmp r3, #0x3f
A0388840: 0d00009a  bls #0xa038887c
A0388844: 1b3b0ae3  movw r3, #0xab1b
A0388848: 70314ae3  movt r3, #0xa170
A038884C: 4020a0e3  mov r2, #0x40
A0388850: 0020c3e5  strb r2, [r3]
A0388854: f83a07e3  movw r3, #0x7af8
A0388858: 75304ae3  movt r3, #0xa075
A038885C: b433d3e1  ldrh r3, [r3, #0x34]
A0388860: 013003e2  and r3, r3, #1
A0388864: 000053e3  cmp r3, #0
A0388868: 0300000a  beq #0xa038887c
A038886C: 700200e3  movw r0, #0x270
A0388870: 60004ae3  movt r0, #0xa060
A0388874: 4010a0e3  mov r1, #0x40
A0388878: 1b7afceb  bl #0xa02a70ec

; 0xA03972CC..0xA03972D4 (end exclusive)
A03972CC: 010013e3  tst r3, #1
A03972D0: 6200001a  bne #0xa0397460
