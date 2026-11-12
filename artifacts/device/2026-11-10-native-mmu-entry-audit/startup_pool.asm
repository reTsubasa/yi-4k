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
a0187668 0600a0e1 mov r0, r6
a018766c 0fd408eb bl #0xa03bc6b0
a0187670 0500a0e1 mov r0, r5
a0187674 74879fe5 ldr r8, [pc, #0x774]
a0187678 9d8204eb bl #0xa02a80f4
a018767c f9eb0beb bl #0xa0482668
a0187680 fb3b04eb bl #0xa0296674
a0187684 9ae90beb bl #0xa0481cf4
a0187688 9ae90beb bl #0xa0481cf8
a018768c 0b060ceb bl #0xa0488ec0
a0187690 0610a0e1 mov r1, r6
a0187694 0500a0e1 mov r0, r5
a0187698 157c01eb bl #0xa01e66f4
a018769c 0cc09de5 ldr ip, [sp, #0xc]
a01876a0 001099e5 ldr r1, [sb]
a01876a4 00009ae5 ldr r0, [sl]
a01876a8 00209ce5 ldr r2, [ip]
a01876ac 10c08de5 str ip, [sp, #0x10]
a01876b0 177c01eb bl #0xa01e6714
a01876b4 56ffffeb bl #0xa0187414
a01876b8 0400a0e1 mov r0, r4
a01876bc 8ffbffeb bl #0xa0186500
a01876c0 a40505e3 movw r0, #0x55a4
a01876c4 bce00be3 movw lr, #0xb0bc
a01876c8 5c2001e3 movw r2, #0x105c
a01876cc 981f0ae3 movw r1, #0xaf98
a01876d0 a3014ae3 movt r0, #0xa1a3
a01876d4 78e04ae3 movt lr, #0xa078
a01876d8 a3214ae3 movt r2, #0xa1a3
a01876dc 78104ae3 movt r1, #0xa078
a01876e0 00e080e5 str lr, [r0]
a01876e4 001082e5 str r1, [r2]
a01876e8 503a04eb bl #0xa0296030
a01876ec 14309de5 ldr r3, [sp, #0x14]
a01876f0 c22ca0e3 mov r2, #0xc200
a01876f4 012040e3 movt r2, #1
a01876f8 03e0a0e3 mov lr, #3
a01876fc 0400a0e1 mov r0, r4
a0187700 0710a0e1 mov r1, r7
a0187704 2c408de5 str r4, [sp, #0x2c]
a0187708 28208de5 str r2, [sp, #0x28]
a018770c 2ce0cde5 strb lr, [sp, #0x2c]
a0187710 38408de5 str r4, [sp, #0x38]
a0187714 34308de5 str r3, [sp, #0x34]
a0187718 0c308de5 str r3, [sp, #0xc]
a018771c 30b08de5 str fp, [sp, #0x30]
a0187720 251c0ceb bl #0xa048e7bc
a0187724 0c309de5 ldr r3, [sp, #0xc]
a0187728 0710a0e1 mov r1, r7
a018772c 0200a0e3 mov r0, #2
a0187730 30b08de5 str fp, [sp, #0x30]
a0187734 38408de5 str r4, [sp, #0x38]
a0187738 0240a0e3 mov r4, #2
a018773c 0b3083e0 add r3, r3, fp
