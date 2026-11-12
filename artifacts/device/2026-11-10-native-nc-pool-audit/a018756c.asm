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
a0187740 cab0a0e3 mov fp, #0xca
a0187744 34308de5 str r3, [sp, #0x34]
a0187748 1b1c0ceb bl #0xa048e7bc
a018774c 0f0098e8 ldm r8, {r0, r1, r2, r3}
a0187750 54e207e3 movw lr, #0x7254
a0187754 fee04ae3 movt lr, #0xa0fe
a0187758 108088e2 add r8, r8, #0x10
a018775c 24e08de5 str lr, [sp, #0x24]
a0187760 01e7a0e3 mov lr, #0x40000
a0187764 20e08de5 str lr, [sp, #0x20]
a0187768 0f0087e8 stm r7, {r0, r1, r2, r3}
a018776c 18008de2 add r0, sp, #0x18
a0187770 18b08de5 str fp, [sp, #0x18]
a0187774 1c408de5 str r4, [sp, #0x1c]
a0187778 af7d04eb bl #0xa02a6e3c
a018777c 0700a0e1 mov r0, r7
a0187780 297e04eb bl #0xa02a702c
a0187784 000606e3 movw r0, #0x6600
a0187788 29004ae3 movt r0, #0xa029
a018778c 077e04eb bl #0xa02a6fb0
a0187790 b00b0be3 movw r0, #0xbbb0
a0187794 55004ae3 movt r0, #0xa055
a0187798 537e04eb bl #0xa02a70ec
a018779c 1c3095e5 ldr r3, [r5, #0x1c]
a01877a0 dc0b0be3 movw r0, #0xbbdc
a01877a4 181095e5 ldr r1, [r5, #0x18]
a01877a8 55004ae3 movt r0, #0xa055
a01877ac 012043e2 sub r2, r3, #1
a01877b0 022081e0 add r2, r1, r2
a01877b4 233aa0e1 lsr r3, r3, #0x14
a01877b8 4b7e04eb bl #0xa02a70ec
a01877bc 10c09de5 ldr ip, [sp, #0x10]
a01877c0 040c0be3 movw r0, #0xbc04
a01877c4 00109ae5 ldr r1, [sl]
a01877c8 55004ae3 movt r0, #0xa055
a01877cc 002099e5 ldr r2, [sb]
a01877d0 00309ce5 ldr r3, [ip]
a01877d4 233aa0e1 lsr r3, r3, #0x14
a01877d8 437e04eb bl #0xa02a70ec
a01877dc 1c3096e5 ldr r3, [r6, #0x1c]
a01877e0 2c0c0be3 movw r0, #0xbc2c
a01877e4 181096e5 ldr r1, [r6, #0x18]
a01877e8 55004ae3 movt r0, #0xa055
a01877ec 012043e2 sub r2, r3, #1
a01877f0 022081e0 add r2, r1, r2
a01877f4 233aa0e1 lsr r3, r3, #0x14
a01877f8 3b7e04eb bl #0xa02a70ec
a01877fc 002000e3 movw r2, #0
a0187800 001000e3 movw r1, #0
a0187804 001c4de3 movt r1, #0xdc00
a0187808 00204ee3 movt r2, #0xe000
a018780c 023061e0 rsb r3, r1, r2
a0187810 540c0be3 movw r0, #0xbc54
a0187814 233aa0e1 lsr r3, r3, #0x14
a0187818 012042e2 sub r2, r2, #1
a018781c 55004ae3 movt r0, #0xa055
a0187820 317e04eb bl #0xa02a70ec
a0187824 b00b0be3 movw r0, #0xbbb0
a0187828 55004ae3 movt r0, #0xa055
a018782c 2e7e04eb bl #0xa02a70ec
a0187830 71060ceb bl #0xa04891fc
a0187834 a3ea0beb bl #0xa04822c8
a0187838 0b5a04eb bl #0xa029e06c
a018783c e79906eb bl #0xa032dfe0
a0187840 295104eb bl #0xa029bcec
a0187844 070098e8 ldm r8, {r0, r1, r2}
a0187848 383908e3 movw r3, #0x8938
a018784c 62304ae3 movt r3, #0xa062
a0187850 070087e8 stm r7, {r0, r1, r2}
a0187854 400801e3 movw r0, #0x1840
a0187858 38170be3 movw r1, #0xb738
a018785c 002093e5 ldr r2, [r3]
a0187860 55104ae3 movt r1, #0xa055
a0187864 62004ae3 movt r0, #0xa062
a0187868 1f7e04eb bl #0xa02a70ec
a018786c 33ee0beb bl #0xa0483140
a0187870 000050e3 cmp r0, #0
a0187874 2c01001a bne #0xa0187d2c
a0187878 0700a0e1 mov r0, r7
a018787c a6ee0beb bl #0xa048331c
a0187880 000050e3 cmp r0, #0
a0187884 2401001a bne #0xa0187d1c
a0187888 0700a0e3 mov r0, #7
a018788c f8630ceb bl #0xa04a0874
a0187890 000050e3 cmp r0, #0
a0187894 1c01001a bne #0xa0187d0c
a0187898 0800a0e3 mov r0, #8
a018789c f4630ceb bl #0xa04a0874
a01878a0 000050e3 cmp r0, #0
a01878a4 1401001a bne #0xa0187cfc
a01878a8 0900a0e3 mov r0, #9
a01878ac f0630ceb bl #0xa04a0874
a01878b0 000050e3 cmp r0, #0
a01878b4 0c01001a bne #0xa0187cec
a01878b8 0a00a0e3 mov r0, #0xa
a01878bc ec630ceb bl #0xa04a0874
a01878c0 000050e3 cmp r0, #0
a01878c4 0401001a bne #0xa0187cdc
a01878c8 0b00a0e3 mov r0, #0xb
a01878cc e8630ceb bl #0xa04a0874
a01878d0 000050e3 cmp r0, #0
a01878d4 fc00001a bne #0xa0187ccc
a01878d8 a80d0be3 movw r0, #0xbda8
a01878dc 55004ae3 movt r0, #0xa055
a01878e0 5a9a06eb bl #0xa032e250
a01878e4 000050e3 cmp r0, #0
a01878e8 c600001a bne #0xa0187c08
a01878ec d6fe0beb bl #0xa048744c
a01878f0 00b050e2 subs fp, r0, #0
a01878f4 de00001a bne #0xa0187c74
a01878f8 f14104eb bl #0xa02980c4
a01878fc 00a050e2 subs sl, r0, #0
a0187900 e50000da ble #0xa0187c9c
a0187904 0050a0e3 mov r5, #0
a0187908 446006e3 movw r6, #0x6044
a018790c e09309e3 movw sb, #0x93e0
a0187910 80810de3 movw r8, #0xd180
a0187914 0140a0e3 mov r4, #1
a0187918 4bcfa0e3 mov ip, #0x12c
a018791c 0220a0e3 mov r2, #2
a0187920 2030a0e3 mov r3, #0x20
a0187924 29604ae3 movt r6, #0xa029
a0187928 049040e3 movt sb, #4
a018792c f08840e3 movt r8, #0x8f0
a0187930 0710a0e1 mov r1, r7
a0187934 0500a0e1 mov r0, r5
a0187938 30508de5 str r5, [sp, #0x30]
a018793c 34c08de5 str ip, [sp, #0x34]
a0187940 14c08de5 str ip, [sp, #0x14]
a0187944 48208de5 str r2, [sp, #0x48]
a0187948 10208de5 str r2, [sp, #0x10]
a018794c 4c308de5 str r3, [sp, #0x4c]
a0187950 0c308de5 str r3, [sp, #0xc]
a0187954 38508de5 str r5, [sp, #0x38]
a0187958 3c508de5 str r5, [sp, #0x3c]
a018795c 50508de5 str r5, [sp, #0x50]
a0187960 54508de5 str r5, [sp, #0x54]
a0187964 28608de5 str r6, [sp, #0x28]
a0187968 40908de5 str sb, [sp, #0x40]
a018796c 44808de5 str r8, [sp, #0x44]
a0187970 2c40cde5 strb r4, [sp, #0x2c]
a0187974 2d40cde5 strb r4, [sp, #0x2d]
a0187978 2e40cde5 strb r4, [sp, #0x2e]
a018797c 3040cde5 strb r4, [sp, #0x30]
a0187980 2f40cde5 strb r4, [sp, #0x2f]
a0187984 98080ceb bl #0xa0489bec
a0187988 14c09de5 ldr ip, [sp, #0x14]
a018798c 0710a0e1 mov r1, r7
a0187990 10209de5 ldr r2, [sp, #0x10]
a0187994 0400a0e1 mov r0, r4
a0187998 0c309de5 ldr r3, [sp, #0xc]
a018799c 30508de5 str r5, [sp, #0x30]
a01879a0 34c08de5 str ip, [sp, #0x34]
a01879a4 48208de5 str r2, [sp, #0x48]
a01879a8 4c308de5 str r3, [sp, #0x4c]
a01879ac 28608de5 str r6, [sp, #0x28]
a01879b0 40908de5 str sb, [sp, #0x40]
a01879b4 44808de5 str r8, [sp, #0x44]
a01879b8 38508de5 str r5, [sp, #0x38]
a01879bc 3c508de5 str r5, [sp, #0x3c]
a01879c0 50508de5 str r5, [sp, #0x50]
a01879c4 54508de5 str r5, [sp, #0x54]
a01879c8 2c40cde5 strb r4, [sp, #0x2c]
a01879cc 2d40cde5 strb r4, [sp, #0x2d]
a01879d0 2e40cde5 strb r4, [sp, #0x2e]
a01879d4 3040cde5 strb r4, [sp, #0x30]
a01879d8 2f40cde5 strb r4, [sp, #0x2f]
a01879dc 82080ceb bl #0xa0489bec
a01879e0 55fdffeb bl #0xa0186f3c
a01879e4 05005ae1 cmp sl, r5
a01879e8 da0000da ble #0xa0187d58
a01879ec 0000a0e3 mov r0, #0
a01879f0 e3ef0beb bl #0xa0483984
a01879f4 00005be3 cmp fp, #0
a01879f8 dc0000ba blt #0xa0187d70
a01879fc 0700a0e1 mov r0, r7
a0187a00 88450ee3 movw r4, #0xe588
a0187a04 4b220beb bl #0xa0450338
a0187a08 04414ae3 movt r4, #0xa104
a0187a0c 2030a0e3 mov r3, #0x20
a0187a10 140107e3 movw r0, #0x7114
a0187a14 d02007e3 movw r2, #0x70d0
a0187a18 00308de5 str r3, [sp]
a0187a1c 0410a0e1 mov r1, r4
a0187a20 fd004ae3 movt r0, #0xa0fd
a0187a24 fd204ae3 movt r2, #0xa0fd
a0187a28 0536a0e3 mov r3, #0x500000
a0187a2c 694b04eb bl #0xa029a7d8
a0187a30 000050e3 cmp r0, #0
a0187a34 dd00001a bne #0xa0187db0
a0187a38 005094e5 ldr r5, [r4]
a0187a3c 02e9a0e3 mov lr, #0x8000
a0187a40 19c0a0e3 mov ip, #0x19
a0187a44 0210a0e3 mov r1, #2
a0187a48 0e20a0e3 mov r2, #0xe
a0187a4c 1630a0e3 mov r3, #0x16
a0187a50 0700a0e1 mov r0, r7
a0187a54 0546a0e3 mov r4, #0x500000
a0187a58 28508de5 str r5, [sp, #0x28]
a0187a5c 2c408de5 str r4, [sp, #0x2c]
a0187a60 3ce08de5 str lr, [sp, #0x3c]
a0187a64 38c08de5 str ip, [sp, #0x38]
a0187a68 40108de5 str r1, [sp, #0x40]
a0187a6c 34208de5 str r2, [sp, #0x34]
a0187a70 30308de5 str r3, [sp, #0x30]
a0187a74 40220beb bl #0xa045037c
a0187a78 000050e3 cmp r0, #0
a0187a7c ae00001a bne #0xa0187d3c
a0187a80 22feffeb bl #0xa0187310
a0187a84 540f0be3 movw r0, #0xbf54
a0187a88 8c450ee3 movw r4, #0xe58c
a0187a8c 55004ae3 movt r0, #0xa055
a0187a90 04414ae3 movt r4, #0xa104
a0187a94 947d04eb bl #0xa02a70ec
a0187a98 953b04eb bl #0xa02968f4
a0187a9c 5df301eb bl #0xa0204818
a0187aa0 d44d04eb bl #0xa029b1f8
a0187aa4 700f0be3 movw r0, #0xbf70
a0187aa8 55004ae3 movt r0, #0xa055
a0187aac 8e7d04eb bl #0xa02a70ec
a0187ab0 a00f0be3 movw r0, #0xbfa0
a0187ab4 a81f0be3 movw r1, #0xbfa8
a0187ab8 55104ae3 movt r1, #0xa055
a0187abc 55004ae3 movt r0, #0xa055
a0187ac0 897d04eb bl #0xa02a70ec
a0187ac4 700f0be3 movw r0, #0xbf70
a0187ac8 55004ae3 movt r0, #0xa055
a0187acc 867d04eb bl #0xa02a70ec
a0187ad0 19490ceb bl #0xa0499f3c
a0187ad4 0010a0e1 mov r1, r0
a0187ad8 b40f0be3 movw r0, #0xbfb4
a0187adc 55004ae3 movt r0, #0xa055
a0187ae0 817d04eb bl #0xa02a70ec
a0187ae4 25490ceb bl #0xa0499f80
a0187ae8 0010a0e1 mov r1, r0
a0187aec c80f0be3 movw r0, #0xbfc8
a0187af0 55004ae3 movt r0, #0xa055
a0187af4 7c7d04eb bl #0xa02a70ec
a0187af8 30490ceb bl #0xa0499fc0
a0187afc 0010a0e1 mov r1, r0
a0187b00 d80f0be3 movw r0, #0xbfd8
a0187b04 55004ae3 movt r0, #0xa055
a0187b08 777d04eb bl #0xa02a70ec
a0187b0c f9480ceb bl #0xa0499ef8
a0187b10 0010a0e1 mov r1, r0
a0187b14 e80f0be3 movw r0, #0xbfe8
a0187b18 55004ae3 movt r0, #0xa055
a0187b1c 727d04eb bl #0xa02a70ec
a0187b20 7a490ceb bl #0xa049a110
a0187b24 0010a0e1 mov r1, r0
a0187b28 f80f0be3 movw r0, #0xbff8
a0187b2c 55004ae3 movt r0, #0xa055
a0187b30 6d7d04eb bl #0xa02a70ec
a0187b34 85490ceb bl #0xa049a150
a0187b38 0010a0e1 mov r1, r0
a0187b3c 08000ce3 movw r0, #0xc008
a0187b40 55004ae3 movt r0, #0xa055
a0187b44 687d04eb bl #0xa02a70ec
a0187b48 90490ceb bl #0xa049a190
a0187b4c 0010a0e1 mov r1, r0
a0187b50 18000ce3 movw r0, #0xc018
a0187b54 55004ae3 movt r0, #0xa055
a0187b58 637d04eb bl #0xa02a70ec
a0187b5c 700f0be3 movw r0, #0xbf70
a0187b60 55004ae3 movt r0, #0xa055
a0187b64 607d04eb bl #0xa02a70ec
a0187b68 28000ce3 movw r0, #0xc028
a0187b6c 55004ae3 movt r0, #0xa055
a0187b70 5d7d04eb bl #0xa02a70ec
a0187b74 ec4e04eb bl #0xa029b72c
a0187b78 fb4e04eb bl #0xa029b76c
a0187b7c 740505e3 movw r0, #0x5574
a0187b80 d01106e3 movw r1, #0x61d0
a0187b84 53104ae3 movt r1, #0xa053
a0187b88 63004ae3 movt r0, #0xa063
a0187b8c 567d04eb bl #0xa02a70ec
a0187b90 700f0be3 movw r0, #0xbf70
a0187b94 55004ae3 movt r0, #0xa055
a0187b98 537d04eb bl #0xa02a70ec
a0187b9c 204b04eb bl #0xa029a824
a0187ba0 423f04eb bl #0xa02978b0
a0187ba4 0c010de3 movw r0, #0xd10c
a0187ba8 19004ae3 movt r0, #0xa019
a0187bac f23b04eb bl #0xa0296b7c
a0187bb0 480f0ce3 movw r0, #0xcf48
a0187bb4 19004ae3 movt r0, #0xa019
a0187bb8 f33b04eb bl #0xa0296b8c
a0187bbc f63b04eb bl #0xa0296b9c
a0187bc0 2ffeffeb bl #0xa0187484
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
a0187c08 ac0d0be3 movw r0, #0xbdac
a0187c0c 55004ae3 movt r0, #0xa055
a0187c10 357d04eb bl #0xa02a70ec
a0187c14 0000a0e3 mov r0, #0
a0187c18 0110a0e3 mov r1, #1
a0187c1c 0b20a0e3 mov r2, #0xb
a0187c20 883301e3 movw r3, #0x1388
a0187c24 13f00beb bl #0xa0483c78
a0187c28 000050e3 cmp r0, #0
a0187c2c 5b00001a bne #0xa0187da0
a0187c30 180e0be3 movw r0, #0xbe18
a0187c34 55004ae3 movt r0, #0xa055
a0187c38 2b7d04eb bl #0xa02a70ec
a0187c3c 0b00a0e3 mov r0, #0xb
a0187c40 0b630ceb bl #0xa04a0874
a0187c44 000050e3 cmp r0, #0
a0187c48 5000001a bne #0xa0187d90
a0187c4c 540e0be3 movw r0, #0xbe54
a0187c50 55004ae3 movt r0, #0xa055
a0187c54 247d04eb bl #0xa02a70ec
a0187c58 901c06e3 movw r1, #0x6c90
a0187c5c 4200a0e3 mov r0, #0x42
a0187c60 5a104ae3 movt r1, #0xa05a
a0187c64 859906eb bl #0xa032e280
a0187c68 f7fd0beb bl #0xa048744c
a0187c6c 00b050e2 subs fp, r0, #0
a0187c70 20ffff0a beq #0xa01878f8
a0187c74 7c3003e3 movw r3, #0x307c
a0187c78 740e0be3 movw r0, #0xbe74
a0187c7c 6f304ae3 movt r3, #0xa06f
a0187c80 0b20a0e1 mov r2, fp
a0187c84 041093e5 ldr r1, [r3, #4]
a0187c88 55004ae3 movt r0, #0xa055
a0187c8c 167d04eb bl #0xa02a70ec
a0187c90 0b4104eb bl #0xa02980c4
a0187c94 00a050e2 subs sl, r0, #0
a0187c98 19ffffca bgt #0xa0187904
a0187c9c dfff0beb bl #0xa0487c20
a0187ca0 002050e2 subs r2, r0, #0
a0187ca4 4800001a bne #0xa0187dcc
a0187ca8 08360be3 movw r3, #0xb608
a0187cac 00b0a0e3 mov fp, #0
a0187cb0 78304ae3 movt r3, #0xa078
a0187cb4 003093e5 ldr r3, [r3]
a0187cb8 0500d3e5 ldrb r0, [r3, #5]
a0187cbc 0b0050e0 subs r0, r0, fp
a0187cc0 0100a013 movne r0, #1
a0187cc4 d63d00eb bl #0xa0197424
a0187cc8 0dffffea b #0xa0187904
a0187ccc 6c0d0be3 movw r0, #0xbd6c
a0187cd0 55004ae3 movt r0, #0xa055
a0187cd4 047d04eb bl #0xa02a70ec
a0187cd8 fefeffea b #0xa01878d8
a0187cdc f40a0be3 movw r0, #0xbaf4
a0187ce0 55004ae3 movt r0, #0xa055
a0187ce4 007d04eb bl #0xa02a70ec
a0187ce8 f6feffea b #0xa01878c8
a0187cec 300d0be3 movw r0, #0xbd30
a0187cf0 55004ae3 movt r0, #0xa055
a0187cf4 fc7c04eb bl #0xa02a70ec
a0187cf8 eefeffea b #0xa01878b8
a0187cfc f00c0be3 movw r0, #0xbcf0
a0187d00 55004ae3 movt r0, #0xa055
a0187d04 f87c04eb bl #0xa02a70ec
a0187d08 e6feffea b #0xa01878a8
a0187d0c b00c0be3 movw r0, #0xbcb0
a0187d10 55004ae3 movt r0, #0xa055
a0187d14 f47c04eb bl #0xa02a70ec
a0187d18 defeffea b #0xa0187898
a0187d1c 940c0be3 movw r0, #0xbc94
a0187d20 55004ae3 movt r0, #0xa055
a0187d24 f07c04eb bl #0xa02a70ec
a0187d28 d6feffea b #0xa0187888
a0187d2c 7c0c0be3 movw r0, #0xbc7c
a0187d30 55004ae3 movt r0, #0xa055
a0187d34 ec7c04eb bl #0xa02a70ec
a0187d38 cefeffea b #0xa0187878
a0187d3c 7c3003e3 movw r3, #0x307c
a0187d40 2c0f0be3 movw r0, #0xbf2c
a0187d44 6f304ae3 movt r3, #0xa06f
a0187d48 55004ae3 movt r0, #0xa055
a0187d4c 041093e5 ldr r1, [r3, #4]
a0187d50 e57c04eb bl #0xa02a70ec
a0187d54 49ffffea b #0xa0187a80
a0187d58 f9de0beb bl #0xa047f944
a0187d5c 21e20beb bl #0xa04805e8
a0187d60 0000a0e3 mov r0, #0
a0187d64 06ef0beb bl #0xa0483984
a0187d68 00005be3 cmp fp, #0
a0187d6c 22ffffaa bge #0xa01879fc
a0187d70 7c3003e3 movw r3, #0x307c
a0187d74 d00e0be3 movw r0, #0xbed0
a0187d78 6f304ae3 movt r3, #0xa06f
a0187d7c 0b20a0e1 mov r2, fp
a0187d80 041093e5 ldr r1, [r3, #4]
a0187d84 55004ae3 movt r0, #0xa055
a0187d88 d77c04eb bl #0xa02a70ec
a0187d8c 1affffea b #0xa01879fc
a0187d90 6c0d0be3 movw r0, #0xbd6c
a0187d94 55004ae3 movt r0, #0xa055
a0187d98 d37c04eb bl #0xa02a70ec
a0187d9c aaffffea b #0xa0187c4c
a0187da0 d40d0be3 movw r0, #0xbdd4
a0187da4 55004ae3 movt r0, #0xa055
a0187da8 cf7c04eb bl #0xa02a70ec
a0187dac 9fffffea b #0xa0187c30
a0187db0 7c3003e3 movw r3, #0x307c
a0187db4 fc0e0be3 movw r0, #0xbefc
a0187db8 6f304ae3 movt r3, #0xa06f
a0187dbc 55004ae3 movt r0, #0xa055
a0187dc0 041093e5 ldr r1, [r3, #4]
a0187dc4 c87c04eb bl #0xa02a70ec
a0187dc8 2cffffea b #0xa0187a80
a0187dcc 7c3003e3 movw r3, #0x307c
a0187dd0 a40e0be3 movw r0, #0xbea4
a0187dd4 6f304ae3 movt r3, #0xa06f
a0187dd8 55004ae3 movt r0, #0xa055
a0187ddc 041093e5 ldr r1, [r3, #4]
a0187de0 c17c04eb bl #0xa02a70ec
a0187de4 afffffea b #0xa0187ca8
