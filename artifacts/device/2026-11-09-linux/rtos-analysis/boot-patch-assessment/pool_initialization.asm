a018756c f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0187570 145107e3 movw r5, #0x7114
a0187574 6cb89fe5 ldr fp, [pc, #0x86c]
a0187578 206207e3 movw r6, #0x7220
a018757c 0040a0e3 mov r4, #0
a0187580 fd504ae3 movt r5, #0xa0fd
a0187584 60289fe5 ldr r2, [pc, #0x860]
a0187588 fe604ae3 movt r6, #0xa0fe
a018758c 3fb0cbe3 bic fp, fp, #0x3f
a0187590 d49007e3 movw sb, #0x70d4
a0187594 1e748be2 add r7, fp, #0x1e000000
a0187598 dca007e3 movw sl, #0x70dc
a018759c 017047e2 sub r7, r7, #1
a01875a0 d8c007e3 movw ip, #0x70d8
a01875a4 003008e3 movw r3, #0x8000
a01875a8 5cd04de2 sub sp, sp, #0x5c
a01875ac 82304ae3 movt r3, #0xa082
a01875b0 fdc04ae3 movt ip, #0xa0fd
a01875b4 fd904ae3 movt sb, #0xa0fd
a01875b8 022067e0 rsb r2, r7, r2
a01875bc 1e148be2 add r1, fp, #0x1e000000
a01875c0 fda04ae3 movt sl, #0xa0fd
a01875c4 004085e5 str r4, [r5]
a01875c8 1e84a0e3 mov r8, #0x1e000000
a01875cc 044085e5 str r4, [r5, #4]
a01875d0 0500a0e1 mov r0, r5
a01875d4 084085e5 str r4, [r5, #8]
a01875d8 004086e5 str r4, [r6]
a01875dc 044086e5 str r4, [r6, #4]
a01875e0 084086e5 str r4, [r6, #8]
a01875e4 0c4085e5 str r4, [r5, #0xc]
a01875e8 0c4086e5 str r4, [r6, #0xc]
a01875ec 104085e5 str r4, [r5, #0x10]
a01875f0 104086e5 str r4, [r6, #0x10]
a01875f4 144085e5 str r4, [r5, #0x14]
a01875f8 144086e5 str r4, [r6, #0x14]
a01875fc 184085e5 str r4, [r5, #0x18]
a0187600 184086e5 str r4, [r6, #0x18]
a0187604 1c4085e5 str r4, [r5, #0x1c]
a0187608 1c4086e5 str r4, [r6, #0x1c]
a018760c 204085e5 str r4, [r5, #0x20]
a0187610 204086e5 str r4, [r6, #0x20]
a0187614 244085e5 str r4, [r5, #0x24]
a0187618 244086e5 str r4, [r6, #0x24]
a018761c 284085e5 str r4, [r5, #0x28]
a0187620 284086e5 str r4, [r6, #0x28]
a0187624 2c4085e5 str r4, [r5, #0x2c]
a0187628 2c4086e5 str r4, [r6, #0x2c]
a018762c 304085e5 str r4, [r5, #0x30]
a0187630 304086e5 str r4, [r6, #0x30]
a0187634 14308de5 str r3, [sp, #0x14]
a0187638 00808ce5 str r8, [ip]
a018763c 0cc08de5 str ip, [sp, #0xc]
a0187640 007089e5 str r7, [sb]
a0187644 28708de2 add r7, sp, #0x28
a0187648 00b08ae5 str fp, [sl]
a018764c 01bba0e3 mov fp, #0x400
a0187650 16d408eb bl #0xa03bc6b0
a0187654 001000e3 movw r1, #0
a0187658 002000e3 movw r2, #0
a018765c 10124ae3 movt r1, #0xa210
a0187660 10234ae3 movt r2, #0xa310
a0187664 022061e0 rsb r2, r1, r2
