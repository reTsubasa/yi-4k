
; 0xa02c5fd8..0xa02c61d0
A02C5FD8  d83b06e3  movw     r3, #0x6bd8
A02C5FDC  f0472de9  push     {r4, r5, r6, r7, r8, sb, sl, lr}
A02C5FE0  45314ae3  movt     r3, #0xa145
A02C5FE4  0040a0e1  mov      r4, r0
A02C5FE8  0150a0e1  mov      r5, r1
A02C5FEC  0280a0e1  mov      r8, r2
A02C5FF0  0930d3e5  ldrb     r3, [r3, #9]
A02C5FF4  000053e3  cmp      r3, #0
A02C5FF8  3f00001a  bne      #0xa02c60fc
A02C5FFC  286308e3  movw     r6, #0x8328
A02C6000  45614ae3  movt     r6, #0xa145
A02C6004  0030d6e5  ldrb     r3, [r6]
A02C6008  050053e1  cmp      r3, r5
A02C600C  e0700903  movweq   r7, #0x90e0
A02C6010  69704a03  movteq   r7, #0xa069
A02C6014  0a00000a  beq      #0xa02c6044
A02C6018  000055e3  cmp      r5, #0
A02C601C  5c00001a  bne      #0xa02c6194
A02C6020  803303e3  movw     r3, #0x3380
A02C6024  e07009e3  movw     r7, #0x90e0
A02C6028  6f304ae3  movt     r3, #0xa06f
A02C602C  69704ae3  movt     r7, #0xa069
A02C6030  003093e5  ldr      r3, [r3]
A02C6034  585083e5  str      r5, [r3, #0x58]
A02C6038  285083e5  str      r5, [r3, #0x28]
A02C603C  805087e5  str      r5, [r7, #0x80]
A02C6040  0050c6e5  strb     r5, [r6]
A02C6044  000054e3  cmp      r4, #0
A02C6048  80408705  streq    r4, [r7, #0x80]
A02C604C  2800000a  beq      #0xa02c60f4
A02C6050  d86f07e3  movw     r6, #0x7fd8
A02C6054  003094e5  ldr      r3, [r4]
A02C6058  45614ae3  movt     r6, #0xa145
A02C605C  0050d6e5  ldrb     r5, [r6]
A02C6060  053387e7  str      r3, [r7, r5, lsl #6]
A02C6064  042094e5  ldr      r2, [r4, #4]
A02C6068  055387e0  add      r5, r7, r5, lsl #6
A02C606C  042085e5  str      r2, [r5, #4]
A02C6070  082094e5  ldr      r2, [r4, #8]
A02C6074  082085e5  str      r2, [r5, #8]
A02C6078  0c2094e5  ldr      r2, [r4, #0xc]
A02C607C  0c2085e5  str      r2, [r5, #0xc]
A02C6080  202094e5  ldr      r2, [r4, #0x20]
A02C6084  202085e5  str      r2, [r5, #0x20]
A02C6088  be21d4e1  ldrh     r2, [r4, #0x1e]
A02C608C  be21c5e1  strh     r2, [r5, #0x1e]
A02C6090  bc21d4e1  ldrh     r2, [r4, #0x1c]
A02C6094  bc21c5e1  strh     r2, [r5, #0x1c]
A02C6098  b821d4e1  ldrh     r2, [r4, #0x18]
A02C609C  b821c5e1  strh     r2, [r5, #0x18]
A02C60A0  ba21d4e1  ldrh     r2, [r4, #0x1a]
A02C60A4  ba21c5e1  strh     r2, [r5, #0x1a]
A02C60A8  103094e5  ldr      r3, [r4, #0x10]
A02C60AC  103085e5  str      r3, [r5, #0x10]
A02C60B0  143094e5  ldr      r3, [r4, #0x14]
A02C60B4  143085e5  str      r3, [r5, #0x14]
A02C60B8  243094e5  ldr      r3, [r4, #0x24]
A02C60BC  000053e3  cmp      r3, #0
A02C60C0  24308505  streq    r3, [r5, #0x24]
A02C60C4  1600001a  bne      #0xa02c6124
A02C60C8  0500a0e1  mov      r0, r5
A02C60CC  947607eb  bl       #0xa04a3b24
A02C60D0  0030d6e5  ldrb     r3, [r6]
A02C60D4  d82f07e3  movw     r2, #0x7fd8
A02C60D8  45214ae3  movt     r2, #0xa145
A02C60DC  800087e5  str      r0, [r7, #0x80]
A02C60E0  013083e2  add      r3, r3, #1
A02C60E4  7330efe6  uxtb     r3, r3
A02C60E8  010053e3  cmp      r3, #1
A02C60EC  0030a083  movhi    r3, #0
A02C60F0  0030c2e5  strb     r3, [r2]
A02C60F4  0000a0e3  mov      r0, #0
A02C60F8  f087bde8  pop      {r4, r5, r6, r7, r8, sb, sl, pc}
A02C60FC  7c3003e3  movw     r3, #0x307c
A02C6100  f80b06e3  movw     r0, #0x6bf8
A02C6104  6f304ae3  movt     r3, #0xa06f
A02C6108  942207e3  movw     r2, #0x7294
A02C610C  081093e5  ldr      r1, [r3, #8]
A02C6110  5c204ae3  movt     r2, #0xa05c
A02C6114  873800e3  movw     r3, #0x887
A02C6118  5c004ae3  movt     r0, #0xa05c
A02C611C  f283ffeb  bl       #0xa02a70ec
A02C6120  b5ffffea  b        #0xa02c5ffc
A02C6124  0c9403e3  movw     sb, #0x340c
A02C6128  6f904ae3  movt     sb, #0xa06f
A02C612C  008099e5  ldr      r8, [sb]
A02C6130  043088e5  str      r3, [r8, #4]
A02C6134  2830d4e5  ldrb     r3, [r4, #0x28]
A02C6138  3030c8e5  strb     r3, [r8, #0x30]
A02C613C  2930d4e5  ldrb     r3, [r4, #0x29]
A02C6140  3130c8e5  strb     r3, [r8, #0x31]
A02C6144  2a30d4e5  ldrb     r3, [r4, #0x2a]
A02C6148  3230c8e5  strb     r3, [r8, #0x32]
A02C614C  2b30d4e5  ldrb     r3, [r4, #0x2b]
A02C6150  3330c8e5  strb     r3, [r8, #0x33]
A02C6154  2c0094e5  ldr      r0, [r4, #0x2c]
A02C6158  717607eb  bl       #0xa04a3b24
A02C615C  00a099e5  ldr      sl, [sb]
A02C6160  080088e5  str      r0, [r8, #8]
A02C6164  300094e5  ldr      r0, [r4, #0x30]
A02C6168  6d7607eb  bl       #0xa04a3b24
A02C616C  003099e5  ldr      r3, [sb]
A02C6170  0c008ae5  str      r0, [sl, #0xc]
A02C6174  3420d4e5  ldrb     r2, [r4, #0x34]
A02C6178  0300a0e1  mov      r0, r3
A02C617C  3720c3e5  strb     r2, [r3, #0x37]
A02C6180  3520d4e5  ldrb     r2, [r4, #0x35]
A02C6184  3820c3e5  strb     r2, [r3, #0x38]
A02C6188  657607eb  bl       #0xa04a3b24
A02C618C  240085e5  str      r0, [r5, #0x24]
A02C6190  ccffffea  b        #0xa02c60c8
A02C6194  34009fe5  ldr      r0, [pc, #0x34]
A02C6198  809303e3  movw     sb, #0x3380
A02C619C  6f904ae3  movt     sb, #0xa06f
A02C61A0  00a099e5  ldr      sl, [sb]
A02C61A4  807040e2  sub      r7, r0, #0x80
A02C61A8  5d7607eb  bl       #0xa04a3b24
A02C61AC  001099e5  ldr      r1, [sb]
A02C61B0  d83f07e3  movw     r3, #0x7fd8
A02C61B4  0020a0e3  mov      r2, #0
A02C61B8  45314ae3  movt     r3, #0xa145
A02C61BC  58008ae5  str      r0, [sl, #0x58]
A02C61C0  0020c3e5  strb     r2, [r3]
A02C61C4  288081e5  str      r8, [r1, #0x28]
A02C61C8  802087e5  str      r2, [r7, #0x80]
A02C61CC  9bffffea  b        #0xa02c6040

; 0xa02c4ee8..0xa02c4f80
A02C4EE8  806303e3  movw     r6, #0x3380
A02C4EEC  6f604ae3  movt     r6, #0xa06f
A02C4EF0  003096e5  ldr      r3, [r6]
A02C4EF4  5d20d3e5  ldrb     r2, [r3, #0x5d]
A02C4EF8  000052e3  cmp      r2, #0
A02C4EFC  0800000a  beq      #0xa02c4f24
A02C4F00  3020d3e5  ldrb     r2, [r3, #0x30]
A02C4F04  b87103e3  movw     r7, #0x31b8
A02C4F08  6f704ae3  movt     r7, #0xa06f
A02C4F0C  1f20c1e7  bfc      r2, #0, #2
A02C4F10  3020c3e5  strb     r2, [r3, #0x30]
A02C4F14  002097e5  ldr      r2, [r7]
A02C4F18  0410d2e5  ldrb     r1, [r2, #4]
A02C4F1C  1f10c1e7  bfc      r1, #0, #2
A02C4F20  0410c2e5  strb     r1, [r2, #4]
A02C4F24  3b30d3e5  ldrb     r3, [r3, #0x3b]
A02C4F28  f03003e2  and      r3, r3, #0xf0
A02C4F2C  300053e3  cmp      r3, #0x30
A02C4F30  0402000a  beq      #0xa02c5748
A02C4F34  543403e3  movw     r3, #0x3454
A02C4F38  0100a0e3  mov      r0, #1
A02C4F3C  6f304ae3  movt     r3, #0xa06f
A02C4F40  001093e5  ldr      r1, [r3]
A02C4F44  05d9ffeb  bl       #0xa02bb360
A02C4F48  010070e3  cmn      r0, #1
A02C4F4C  f901000a  beq      #0xa02c5738
A02C4F50  bc3303e3  movw     r3, #0x33bc
A02C4F54  0100a0e3  mov      r0, #1
A02C4F58  6f304ae3  movt     r3, #0xa06f
A02C4F5C  001093e5  ldr      r1, [r3]
A02C4F60  ecc8ffeb  bl       #0xa02b7318
A02C4F64  010070e3  cmn      r0, #1
A02C4F68  f201000a  beq      #0xa02c5738
A02C4F6C  0100a0e3  mov      r0, #1
A02C4F70  001096e5  ldr      r1, [r6]
A02C4F74  7de5ffeb  bl       #0xa02be570
A02C4F78  010070e3  cmn      r0, #1
A02C4F7C  ed01000a  beq      #0xa02c5738

; 0xa02be4c8..0xa02be54c
A02BE4C8  70402de9  push     {r4, r5, r6, lr}
A02BE4CC  0040a0e1  mov      r4, r0
A02BE4D0  0160a0e1  mov      r6, r1
A02BE4D4  0250a0e1  mov      r5, r2
A02BE4D8  923400eb  bl       #0xa02cb728
A02BE4DC  010050e3  cmp      r0, #1
A02BE4E0  1100000a  beq      #0xa02be52c
A02BE4E4  8f3400eb  bl       #0xa02cb728
A02BE4E8  ff0050e3  cmp      r0, #0xff
A02BE4EC  0800000a  beq      #0xa02be514
A02BE4F0  f83003e3  movw     r3, #0x30f8
A02BE4F4  400a01e3  movw     r0, #0x1a40
A02BE4F8  6f304ae3  movt     r3, #0xa06f
A02BE4FC  0610a0e1  mov      r1, r6
A02BE500  0520a0e1  mov      r2, r5
A02BE504  043193e7  ldr      r3, [r3, r4, lsl #2]
A02BE508  65004ae3  movt     r0, #0xa065
A02BE50C  7040bde8  pop      {r4, r5, r6, lr}
A02BE510  13ff2fe1  bx       r3
A02BE514  663308e3  movw     r3, #0x8366
A02BE518  45314ae3  movt     r3, #0xa145
A02BE51C  0000d3e5  ldrb     r0, [r3]
A02BE520  000050e3  cmp      r0, #0
A02BE524  f1ffff1a  bne      #0xa02be4f0
A02BE528  7080bde8  pop      {r4, r5, r6, pc}
A02BE52C  f83003e3  movw     r3, #0x30f8
A02BE530  0610a0e1  mov      r1, r6
A02BE534  6f304ae3  movt     r3, #0xa06f
A02BE538  0520a0e1  mov      r2, r5
A02BE53C  043193e7  ldr      r3, [r3, r4, lsl #2]
A02BE540  04009fe5  ldr      r0, [pc, #4]
A02BE544  7040bde8  pop      {r4, r5, r6, lr}
A02BE548  13ff2fe1  bx       r3

; 0xa02be570..0xa02be61c
A02BE570  38402de9  push     {r3, r4, r5, lr}
A02BE574  4233a0e3  mov      r3, #0x8000001
A02BE578  0140a0e1  mov      r4, r1
A02BE57C  003081e5  str      r3, [r1]
A02BE580  0050a0e1  mov      r5, r0
A02BE584  580091e5  ldr      r0, [r1, #0x58]
A02BE588  659507eb  bl       #0xa04a3b24
A02BE58C  580084e5  str      r0, [r4, #0x58]
A02BE590  780094e5  ldr      r0, [r4, #0x78]
A02BE594  629507eb  bl       #0xa04a3b24
A02BE598  3b30d4e5  ldrb     r3, [r4, #0x3b]
A02BE59C  780084e5  str      r0, [r4, #0x78]
A02BE5A0  813003e2  and      r3, r3, #0x81
A02BE5A4  010053e3  cmp      r3, #1
A02BE5A8  1400000a  beq      #0xa02be600
A02BE5AC  102094e5  ldr      r2, [r4, #0x10]
A02BE5B0  0f3ca0e3  mov      r3, #0xf00
A02BE5B4  703840e3  movt     r3, #0x870
A02BE5B8  030052e1  cmp      r2, r3
A02BE5BC  0f00000a  beq      #0xa02be600
A02BE5C0  0500a0e1  mov      r0, r5
A02BE5C4  8020a0e3  mov      r2, #0x80
A02BE5C8  0410a0e1  mov      r1, r4
A02BE5CC  bdffffeb  bl       #0xa02be4c8
A02BE5D0  d83b06e3  movw     r3, #0x6bd8
A02BE5D4  0050a0e1  mov      r5, r0
A02BE5D8  45314ae3  movt     r3, #0xa145
A02BE5DC  0520d3e5  ldrb     r2, [r3, #5]
A02BE5E0  103f6fe1  clz      r3, r0
A02BE5E4  a332a0e1  lsr      r3, r3, #5
A02BE5E8  000052e3  cmp      r2, #0
A02BE5EC  0030a003  moveq    r3, #0
A02BE5F0  000053e3  cmp      r3, #0
A02BE5F4  0800001a  bne      #0xa02be61c
A02BE5F8  0500a0e1  mov      r0, r5
A02BE5FC  3880bde8  pop      {r3, r4, r5, pc}
A02BE600  20370de3  movw     r3, #0xd720
A02BE604  1e304ae3  movt     r3, #0xa01e
A02BE608  000053e3  cmp      r3, #0
A02BE60C  ebffff0a  beq      #0xa02be5c0
A02BE610  42bcfceb  bl       #0xa01ed720
A02BE614  b401c4e1  strh     r0, [r4, #0x14]
A02BE618  e8ffffea  b        #0xa02be5c0

; 0xa02b4858..0xa02b48e4
A02B4858  f0412de9  push     {r4, r5, r6, r7, r8, lr}
A02B485C  b54a06e3  movw     r4, #0x6ab5
A02B4860  45414ae3  movt     r4, #0xa145
A02B4864  0050a0e1  mov      r5, r0
A02B4868  0180a0e1  mov      r8, r1
A02B486C  0270a0e1  mov      r7, r2
A02B4870  0030d4e5  ldrb     r3, [r4]
A02B4874  546090e5  ldr      r6, [r0, #0x54]
A02B4878  000053e3  cmp      r3, #0
A02B487C  1200000a  beq      #0xa02b48cc
A02B4880  0500a0e1  mov      r0, r5
A02B4884  4affffeb  bl       #0xa02b45b4
A02B4888  084096e5  ldr      r4, [r6, #8]
A02B488C  4930d5e5  ldrb     r3, [r5, #0x49]
A02B4890  014084e2  add      r4, r4, #1
A02B4894  030054e1  cmp      r4, r3
A02B4898  0f00002a  bhs      #0xa02b48dc
A02B489C  845386e0  add      r5, r6, r4, lsl #7
A02B48A0  0010a0e3  mov      r1, #0
A02B48A4  8020a0e3  mov      r2, #0x80
A02B48A8  0500a0e1  mov      r0, r5
A02B48AC  4e1109fa  blx      #0xa04f8dec
A02B48B0  0500a0e1  mov      r0, r5
A02B48B4  084086e5  str      r4, [r6, #8]
A02B48B8  0810a0e1  mov      r1, r8
A02B48BC  0720a0e1  mov      r2, r7
A02B48C0  171109fa  blx      #0xa04f8d24
A02B48C4  0000a0e3  mov      r0, #0
A02B48C8  f081bde8  pop      {r4, r5, r6, r7, r8, pc}
A02B48CC  ccfeffeb  bl       #0xa02b4404
A02B48D0  0130a0e3  mov      r3, #1
A02B48D4  0030c4e5  strb     r3, [r4]
A02B48D8  e8ffffea  b        #0xa02b4880
A02B48DC  0000e0e3  mvn      r0, #0
A02B48E0  f081bde8  pop      {r4, r5, r6, r7, r8, pc}

; 0xa02c61d4..0xa02c6268
A02C61D4  38402de9  push     {r3, r4, r5, lr}
A02C61D8  004050e2  subs     r4, r0, #0
A02C61DC  0500000a  beq      #0xa02c61f8
A02C61E0  803303e3  movw     r3, #0x3380
A02C61E4  6f304ae3  movt     r3, #0xa06f
A02C61E8  003093e5  ldr      r3, [r3]
A02C61EC  580093e5  ldr      r0, [r3, #0x58]
A02C61F0  000050e3  cmp      r0, #0
A02C61F4  0100001a  bne      #0xa02c6200
A02C61F8  0000a0e3  mov      r0, #0
A02C61FC  3880bde8  pop      {r3, r4, r5, pc}
A02C6200  0150a0e1  mov      r5, r1
A02C6204  727607eb  bl       #0xa04a3bd4
A02C6208  000055e3  cmp      r5, #0
A02C620C  0300000a  beq      #0xa02c6220
A02C6210  203094e5  ldr      r3, [r4, #0x20]
A02C6214  3c3080e5  str      r3, [r0, #0x3c]
A02C6218  0000a0e3  mov      r0, #0
A02C621C  3880bde8  pop      {r3, r4, r5, pc}
A02C6220  103090e5  ldr      r3, [r0, #0x10]
A02C6224  003084e5  str      r3, [r4]
A02C6228  203090e5  ldr      r3, [r0, #0x20]
A02C622C  043084e5  str      r3, [r4, #4]
A02C6230  243090e5  ldr      r3, [r0, #0x24]
A02C6234  083084e5  str      r3, [r4, #8]
A02C6238  283090e5  ldr      r3, [r0, #0x28]
A02C623C  0c3084e5  str      r3, [r4, #0xc]
A02C6240  2c3090e5  ldr      r3, [r0, #0x2c]
A02C6244  103084e5  str      r3, [r4, #0x10]
A02C6248  303090e5  ldr      r3, [r0, #0x30]
A02C624C  143084e5  str      r3, [r4, #0x14]
A02C6250  343090e5  ldr      r3, [r0, #0x34]
A02C6254  183084e5  str      r3, [r4, #0x18]
A02C6258  383090e5  ldr      r3, [r0, #0x38]
A02C625C  1c3084e5  str      r3, [r4, #0x1c]
A02C6260  3c3090e5  ldr      r3, [r0, #0x3c]
A02C6264  0000a0e3  mov      r0, #0
