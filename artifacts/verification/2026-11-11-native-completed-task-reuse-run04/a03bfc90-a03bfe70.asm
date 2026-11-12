a03bfc90 f84f2de9 push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
a03bfc94 0040a0e1 mov r4, r0
a03bfc98 28c09de5 ldr ip, [sp, #0x28]
a03bfc9c 01a0a0e1 mov sl, r1
a03bfca0 0290a0e1 mov sb, r2
a03bfca4 ef10a0e3 mov r1, #0xef
a03bfca8 2c509de5 ldr r5, [sp, #0x2c]
a03bfcac 0380a0e1 mov r8, r3
a03bfcb0 0c00a0e1 mov r0, ip
a03bfcb4 30709de5 ldr r7, [sp, #0x30]
a03bfcb8 38609de5 ldr r6, [sp, #0x38]
a03bfcbc 0520a0e1 mov r2, r5
a03bfcc0 0350c5e3 bic r5, r5, #3
a03bfcc4 48e404fa blx #0xa04f8dec
a03bfcc8 03b080e2 add fp, r0, #3
a03bfccc 045045e2 sub r5, r5, #4
a03bfcd0 03b0cbe3 bic fp, fp, #3
a03bfcd4 0010a0e3 mov r1, #0
a03bfcd8 0b0050e1 cmp r0, fp
a03bfcdc d820a0e3 mov r2, #0xd8
a03bfce0 04504512 subne r5, r5, #4
a03bfce4 0400a0e1 mov r0, r4
a03bfce8 3fe404fa blx #0xa04f8dec
a03bfcec 012045e2 sub r2, r5, #1
a03bfcf0 583802e3 movw r3, #0x2858
a03bfcf4 02208be0 add r2, fp, r2
a03bfcf8 3c304ae3 movt r3, #0xa03c
a03bfcfc 102084e5 str r2, [r4, #0x10]
a03bfd00 01eca0e3 mov lr, #0x100
a03bfd04 34209de5 ldr r2, [sp, #0x34]
a03bfd08 02c0a0e3 mov ip, #2
a03bfd0c 28a084e5 str sl, [r4, #0x28]
a03bfd10 741a00e3 movw r1, #0xa74
a03bfd14 03a0a0e3 mov sl, #3
a03bfd18 3c104ae3 movt r1, #0xa03c
a03bfd1c 3c2084e5 str r2, [r4, #0x3c]
a03bfd20 0400a0e1 mov r0, r4
a03bfd24 b42084e5 str r2, [r4, #0xb4]
a03bfd28 543084e5 str r3, [r4, #0x54]
a03bfd2c b8e084e5 str lr, [r4, #0xb8]
a03bfd30 9cc084e5 str ip, [r4, #0x9c]
a03bfd34 449084e5 str sb, [r4, #0x44]
a03bfd38 488084e5 str r8, [r4, #0x48]
a03bfd3c 0cb084e5 str fp, [r4, #0xc]
a03bfd40 145084e5 str r5, [r4, #0x14]
a03bfd44 2c7084e5 str r7, [r4, #0x2c]
a03bfd48 b07084e5 str r7, [r4, #0xb0]
a03bfd4c 186084e5 str r6, [r4, #0x18]
a03bfd50 1c6084e5 str r6, [r4, #0x1c]
a03bfd54 584084e5 str r4, [r4, #0x58]
a03bfd58 30a084e5 str sl, [r4, #0x30]
a03bfd5c 0a0600eb bl #0xa03c158c
a03bfd60 083094e5 ldr r3, [r4, #8]
a03bfd64 c43084e5 str r3, [r4, #0xc4]
a03bfd68 900500eb bl #0xa03c13b0
a03bfd6c 442205e3 movw r2, #0x5244
a03bfd70 fc3206e3 movw r3, #0x62fc
a03bfd74 79314ae3 movt r3, #0xa179
a03bfd78 482445e3 movt r2, #0x5448
a03bfd7c 002084e5 str r2, [r4]
a03bfd80 002093e5 ldr r2, [r3]
a03bfd84 000052e3 cmp r2, #0
a03bfd88 012082e2 add r2, r2, #1
a03bfd8c 002083e5 str r2, [r3]
a03bfd90 043306e3 movw r3, #0x6304
a03bfd94 1800001a bne #0xa03bfdfc
a03bfd98 79314ae3 movt r3, #0xa179
a03bfd9c 8c4084e5 str r4, [r4, #0x8c]
a03bfda0 904084e5 str r4, [r4, #0x90]
a03bfda4 004083e5 str r4, [r3]
a03bfda8 3c309de5 ldr r3, [sp, #0x3c]
a03bfdac 000053e3 cmp r3, #0
a03bfdb0 0e00000a beq #0xa03bfdf0
a03bfdb4 803706e3 movw r3, #0x6780
a03bfdb8 79314ae3 movt r3, #0xa179
a03bfdbc 002093e5 ldr r2, [r3]
a03bfdc0 012082e2 add r2, r2, #1
a03bfdc4 002083e5 str r2, [r3]
a03bfdc8 960500eb bl #0xa03c1428
a03bfdcc 0400a0e1 mov r0, r4
a03bfdd0 7b0600eb bl #0xa03c17c4
a03bfdd4 cb0300eb bl #0xa03c0d08
a03bfdd8 ef300fe3 movw r3, #0xf0ef
a03bfddc f0304fe3 movt r3, #0xf0f0
a03bfde0 030050e1 cmp r0, r3
a03bfde4 0c00008a bhi #0xa03bfe1c
a03bfde8 0000a0e3 mov r0, #0
a03bfdec f88fbde8 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03bfdf0 8c0500eb bl #0xa03c1428
a03bfdf4 0000a0e3 mov r0, #0
a03bfdf8 f88fbde8 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
a03bfdfc 79314ae3 movt r3, #0xa179
a03bfe00 003093e5 ldr r3, [r3]
a03bfe04 902093e5 ldr r2, [r3, #0x90]
a03bfe08 904083e5 str r4, [r3, #0x90]
a03bfe0c 8c4082e5 str r4, [r2, #0x8c]
a03bfe10 902084e5 str r2, [r4, #0x90]
a03bfe14 8c3084e5 str r3, [r4, #0x8c]
a03bfe18 e2ffffea b #0xa03bfda8
a03bfe1c 241306e3 movw r1, #0x6324
a03bfe20 0020a0e3 mov r2, #0
a03bfe24 79114ae3 movt r1, #0xa179
a03bfe28 dcc206e3 movw ip, #0x62dc
a03bfe2c f80206e3 movw r0, #0x62f8
a03bfe30 79c14ae3 movt ip, #0xa179
a03bfe34 002081e5 str r2, [r1]
a03bfe38 79014ae3 movt r0, #0xa179
a03bfe3c 042081e5 str r2, [r1, #4]
a03bfe40 082081e5 str r2, [r1, #8]
a03bfe44 0c2081e5 str r2, [r1, #0xc]
a03bfe48 102081e5 str r2, [r1, #0x10]
a03bfe4c 142081e5 str r2, [r1, #0x14]
a03bfe50 182081e5 str r2, [r1, #0x18]
a03bfe54 1c2081e5 str r2, [r1, #0x1c]
a03bfe58 00208ce5 str r2, [ip]
a03bfe5c 002080e5 str r2, [r0]
a03bfe60 a10300eb bl #0xa03c0cec
a03bfe64 fc0300eb bl #0xa03c0e5c
a03bfe68 0000a0e3 mov r0, #0
a03bfe6c f88fbde8 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
