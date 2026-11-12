a01a0bcc 0030e0e3 mvn r3, #0
a01a0bd0 ff00a0e3 mov r0, #0xff
a01a0bd4 1830cae5 strb r3, [sl, #0x18]
a01a0bd8 760902eb bl #0xa02231b8
a01a0bdc 48109de5 ldr r1, [sp, #0x48]
a01a0be0 0900a0e1 mov r0, sb
a01a0be4 d60a02eb bl #0xa0223744
a01a0be8 f70a02eb bl #0xa02237cc
a01a0bec 00a0a0e1 mov sl, r0
a01a0bf0 9f0902eb bl #0xa0223274
a01a0bf4 582304e3 movw r2, #0x4358
a01a0bf8 00008de5 str r0, [sp]
a01a0bfc 980202e3 movw r0, #0x2298
a01a0c00 0a30a0e1 mov r3, sl
a01a0c04 56004ae3 movt r0, #0xa056
a01a0c08 56204ae3 movt r2, #0xa056
a01a0c0c cb1600e3 movw r1, #0x6cb
a01a0c10 351904eb bl #0xa02a70ec
a01a0c14 00005ae3 cmp sl, #0
a01a0c18 020000ba blt #0xa01a0c28
a01a0c1c 940902eb bl #0xa0223274
a01a0c20 00005ae1 cmp sl, r0
a01a0c24 2d0100ba blt #0xa01a10e0
a01a0c28 970902eb bl #0xa022328c
a01a0c2c 000059e1 cmp sb, r0
a01a0c30 bff3ff1a bne #0xa019db34
a01a0c34 54309de5 ldr r3, [sp, #0x54]
a01a0c38 e40202e3 movw r0, #0x22e4
a01a0c3c 582304e3 movw r2, #0x4358
a01a0c40 56004ae3 movt r0, #0xa056
a01a0c44 56204ae3 movt r2, #0xa056
a01a0c48 d21600e3 movw r1, #0x6d2
a01a0c4c 00c093e5 ldr ip, [r3]
a01a0c50 0930a0e1 mov r3, sb
a01a0c54 00c08de5 str ip, [sp]
a01a0c58 231904eb bl #0xa02a70ec
a01a0c5c 020059e3 cmp sb, #2
a01a0c60 cd01000a beq #0xa01a139c
a01a0c64 54309de5 ldr r3, [sp, #0x54]
a01a0c68 0510a0e1 mov r1, r5
a01a0c6c 0820a0e1 mov r2, r8
a01a0c70 58009de5 ldr r0, [sp, #0x58]
a01a0c74 283093e5 ldr r3, [r3, #0x28]
a01a0c78 33ff2fe1 blx r3
a01a0c7c 1cdcffeb bl #0xa0197cf4
a01a0c80 8a3f00eb bl #0xa01b0ab0
a01a0c84 b84000eb bl #0xa01b0f6c
a01a0c88 7ff0ffeb bl #0xa019ce8c
a01a0c8c 0000a0e3 mov r0, #0
a01a0c90 8dd9ffeb bl #0xa01972cc
a01a0c94 7bf403eb bl #0xa029de88
a01a0c98 55e9ffeb bl #0xa019b1f4
a01a0c9c a4f3ffea b #0xa019db34
