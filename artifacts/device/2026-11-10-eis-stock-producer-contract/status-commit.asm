a03122d8: 0800a0e1 mov r0, r8
a03122dc: 0410a0e1 mov r1, r4
a03122e0: c020a0e3 mov r2, #0xc0
a03122e4: e528feeb bl #0xa029c680
a03122e8: 54309de5 ldr r3, [sp, #0x54]
a03122ec: 003089e5 str r3, [sb]
a03122f0: 5c309de5 ldr r3, [sp, #0x5c]
a03122f4: 00308ae5 str r3, [sl]
a03122f8: a6feffea b #0xa0311d98
a03122fc: 0130d5e5 ldrb r3, [r5, #1]
a0312300: 010053e3 cmp r3, #1
a0312304: 0200a003 moveq r0, #2
a0312308: 0200000a beq #0xa0312318
a031230c: 020053e3 cmp r3, #2
a0312310: 0300a003 moveq r0, #3
a0312314: 2500001a bne #0xa03123b0
a0312318: 64309de5 ldr r3, [sp, #0x64]
a031231c: 0020a0e3 mov r2, #0
a0312320: 0210d5e5 ldrb r1, [r5, #2]
a0312324: b424cde1 strh r2, [sp, #0x44]
a0312328: 84b093e5 ldr fp, [r3, #0x84]
a031232c: 887093e5 ldr r7, [r3, #0x88]
a0312330: 020051e3 cmp r1, #2
a0312334: 5ce093e5 ldr lr, [r3, #0x5c]
a0312338: 641093e5 ldr r1, [r3, #0x64]
a031233c: 60c093e5 ldr ip, [r3, #0x60]
a0312340: 683093e5 ldr r3, [r3, #0x68]
a0312344: b015cde1 strh r1, [sp, #0x50]
a0312348: 44108de2 add r1, sp, #0x44
a031234c: b624cde1 strh r2, [sp, #0x46]
a0312350: 4c208de2 add r2, sp, #0x4c
a0312354: b8b4cde1 strh fp, [sp, #0x48]
a0312358: ba74cde1 strh r7, [sp, #0x4a]
a031235c: bce4cde1 strh lr, [sp, #0x4c]
a0312360: bec4cde1 strh ip, [sp, #0x4e]
a0312364: b235cde1 strh r3, [sp, #0x52]
a0312368: 2800000a beq #0xa0312410
a031236c: 5cf2feeb bl #0xa02cece4
a0312370: 70008de5 str r0, [sp, #0x70]
a0312374: 81feffea b #0xa0311d80
