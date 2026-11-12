a0187bc4 a37901eb bl #0xa01e6258
a0187bc8 00005ae3 cmp sl, #0
a0187bcc 3c010dd3 movwle r0, #0xd13c
a0187bd0 100801c3 movwgt r0, #0x1810
a0187bd4 6c004ad3 movtle r0, #0xa06c
a0187bd8 6d004ac3 movtgt r0, #0xa06d
a0187bdc 417801eb bl #0xa01e5ce8
a0187be0 a57901eb bl #0xa01e627c
a0187be4 0030d4e5 ldrb r3, [r4]
a0187be8 000053e3 cmp r3, #0
a0187bec 0300001a bne #0xa0187c00
a0187bf0 91fcffeb bl #0xa0186e3c
a0187bf4 bbfcffeb bl #0xa0186ee8
a0187bf8 0130a0e3 mov r3, #1
a0187bfc 0030c4e5 strb r3, [r4]
a0187c00 5cd08de2 add sp, sp, #0x5c
a0187c04 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
