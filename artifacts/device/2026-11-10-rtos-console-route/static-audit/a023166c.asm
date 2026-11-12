a023166c push {r4, r5, r6, r7, lr}
a0231670 movw r0, #0xfeb0
a0231674 movw r2, #0xfdf8
a0231678 movw r4, #0x63f4
a023167c sub sp, sp, #0x14
a0231680 movt r2, #0xa059
a0231684 mov r1, #0xbb
a0231688 movt r0, #0xa059
a023168c movt r4, #0xa06e
a0231690 movw r5, #0x6410
a0231694 bl #0xa02a70ec
a0231698 ldr r0, [r4, #4]
a023169c movt r5, #0xa06e
a02316a0 add r0, r0, #0xa
a02316a4 bl #0xa023229c
a02316a8 cmp r0, #0
a02316ac mov r6, r0
a02316b0 str r0, [r5]
a02316b4 bne #0xa023195c
a02316b8 ldr r0, [r4, #4]
a02316bc add r0, r0, #0xa
a02316c0 bl #0xa023229c
a02316c4 ldr r2, [r5]
a02316c8 movw r3, #0x6414
a02316cc movt r3, #0xa06e
a02316d0 str r0, [r3]
a02316d4 cmp r2, #0
a02316d8 bne #0xa02319bc
a02316dc movw r5, #0xf8d8
a02316e0 movt r5, #0xa142
a02316e4 ldr r3, [r5]
a02316e8 cmp r3, #0
a02316ec beq #0xa02318fc
a02316f0 movw r6, #0xf9b4
a02316f4 movt r6, #0xa142
a02316f8 ldr r3, [r6]
a02316fc cmp r3, #0
a0231700 beq #0xa023189c
a0231704 movw r0, #0xf7d8
a0231708 movt r0, #0xa142
a023170c ldr r3, [r0]
a0231710 cmp r3, #0
a0231714 beq #0xa0231830
a0231718 movw r0, #0xf7d8
a023171c mov r7, #1
a0231720 mov r1, #4
a0231724 movt r0, #0xa142
a0231728 str r7, [r4, #8]
a023172c mov r4, #0x1000
a0231730 bl #0xa03bc4e8
a0231734 ldr ip, [r5]
a0231738 mov r2, #0
a023173c movw r0, #0xf8dc
a0231740 movw r1, #0x24
a0231744 movw r3, #0x1538
a0231748 str r2, [sp]
a023174c str r7, [sp, #0xc]
a0231750 mov r2, #0xff
a0231754 str ip, [sp, #4]
a0231758 movt r0, #0xa142
a023175c movt r1, #0xa05a
a0231760 str r4, [sp, #8]
a0231764 movt r3, #0xa023
a0231768 bl #0xa03bc2bc
a023176c subs r2, r0, #0
a0231770 bne #0xa023198c
a0231774 ldr ip, [r6]
a0231778 movw r0, #0xf800
a023177c movw r1, #0x6c
a0231780 movw r3, #0x1408
a0231784 str r2, [sp]
a0231788 movt r0, #0xa142
a023178c str r4, [sp, #8]
a0231790 movt r1, #0xa05a
a0231794 str ip, [sp, #4]
a0231798 movt r3, #0xa023
a023179c str r7, [sp, #0xc]
a02317a0 mov r2, #0xa0
a02317a4 bl #0xa03bc2bc
a02317a8 subs r4, r0, #0
a02317ac bne #0xa02319ec
a02317b0 movw r3, #0xf9b8
a02317b4 movt r3, #0xa142
a02317b8 ldrb r3, [r3]
a02317bc cmp r3, #0
a02317c0 beq #0xa0231894
a02317c4 movw r0, #0xbc
a02317c8 movw r2, #0xfdf8
a02317cc movt r2, #0xa059
a02317d0 mov r1, #0x110
a02317d4 movt r0, #0xa05a
a02317d8 bl #0xa02a70ec
a02317dc movw r0, #0x104
a02317e0 movw r2, #0xfdf8
a02317e4 movt r2, #0xa059
a02317e8 movw r1, #0x111
a02317ec movt r0, #0xa05a
a02317f0 bl #0xa02a70ec
a02317f4 movw r0, #0x134
a02317f8 movw r2, #0xfdf8
a02317fc movt r2, #0xa059
a0231800 movw r1, #0x112
a0231804 movt r0, #0xa05a
a0231808 bl #0xa02a70ec
a023180c movw r0, #0xbc
a0231810 movw r2, #0xfdf8
a0231814 movt r2, #0xa059
a0231818 movw r1, #0x113
a023181c movt r0, #0xa05a
a0231820 bl #0xa02a70ec
a0231824 mov r0, r4
a0231828 add sp, sp, #0x14
a023182c pop {r4, r5, r6, r7, pc}
a0231830 bl #0xa03bc49c
a0231834 subs r2, r0, #0
a0231838 beq #0xa0231718
a023183c movw r5, #0x307c
a0231840 movw r0, #0xffe4
a0231844 movt r5, #0xa06f
a0231848 movw r3, #0xfdf8
a023184c ldr r1, [r5, #8]
a0231850 movt r0, #0xa059
a0231854 str r2, [sp]
a0231858 movt r3, #0xa059
a023185c mov r2, #0xed
a0231860 mvn r4, #4
a0231864 bl #0xa02a70ec
a0231868 movw r0, #0x164
a023186c movw r3, #0xfdf8
a0231870 ldr r1, [r5, #8]
a0231874 movt r3, #0xa059
a0231878 str r4, [sp]
a023187c movw r2, #0x116
a0231880 movt r0, #0xa05a
a0231884 bl #0xa02a70ec
a0231888 mov r0, r4
a023188c add sp, sp, #0x14
a0231890 pop {r4, r5, r6, r7, pc}
a0231894 bl #0xa01b8c20
a0231898 b #0xa02317c4
a023189c movw r3, #0x23e4
a02318a0 mov r1, #0x20
a02318a4 movt r3, #0xa13a
a02318a8 movw r2, #0xf9bc
a02318ac ldr r0, [r3]
a02318b0 movt r2, #0xa142
a02318b4 str r1, [sp]
a02318b8 mov r3, #0x1000
a02318bc mov r1, r6
a02318c0 bl #0xa029a7d8
a02318c4 subs r2, r0, #0
a02318c8 beq #0xa0231704
a02318cc movw r5, #0x307c
a02318d0 movw r0, #0xff94
a02318d4 movt r5, #0xa06f
a02318d8 movw r3, #0xfdf8
a02318dc ldr r1, [r5, #8]
a02318e0 movt r3, #0xa059
a02318e4 str r2, [sp]
a02318e8 movt r0, #0xa059
a02318ec mov r2, #0xe2
a02318f0 mvn r4, #3
a02318f4 bl #0xa02a70ec
a02318f8 b #0xa0231868
a02318fc movw r3, #0x23e4
a0231900 mov r1, #0x20
a0231904 movt r3, #0xa13a
a0231908 movw r2, #0xf9c4
a023190c ldr r0, [r3]
a0231910 movt r2, #0xa142
a0231914 str r1, [sp]
a0231918 mov r3, #0x1000
a023191c mov r1, r5
a0231920 bl #0xa029a7d8
a0231924 subs r2, r0, #0
a0231928 beq #0xa02316f0
a023192c movw r5, #0x307c
a0231930 movw r0, #0xff94
a0231934 movt r5, #0xa06f
a0231938 movw r3, #0xfdf8
a023193c ldr r1, [r5, #8]
a0231940 movt r3, #0xa059
a0231944 str r2, [sp]
a0231948 movt r0, #0xa059
a023194c mov r2, #0xd3
a0231950 mvn r4, #2
a0231954 bl #0xa02a70ec
a0231958 b #0xa0231868
a023195c movw r5, #0x307c
a0231960 movw r0, #0xfee4
a0231964 movt r5, #0xa06f
a0231968 movw r3, #0xfdf8
a023196c ldr r1, [r5, #8]
a0231970 movt r3, #0xa059
a0231974 str r6, [sp]
a0231978 mov r2, #0xbe
a023197c movt r0, #0xa059
a0231980 mvn r4, #0
a0231984 bl #0xa02a70ec
a0231988 b #0xa0231868
a023198c movw r5, #0x307c
a0231990 movw r0, #0x34
a0231994 movt r5, #0xa06f
a0231998 movw r3, #0xfdf8
a023199c ldr r1, [r5, #8]
a02319a0 movt r3, #0xa059
a02319a4 str r2, [sp]
a02319a8 movt r0, #0xa05a
a02319ac mov r2, #0xfc
a02319b0 mvn r4, #5
a02319b4 bl #0xa02a70ec
a02319b8 b #0xa0231868
a02319bc movw r5, #0x307c
a02319c0 movw r0, #0xff3c
a02319c4 movt r5, #0xa06f
a02319c8 movw r3, #0xfdf8
a02319cc ldr r1, [r5, #8]
a02319d0 movt r3, #0xa059
a02319d4 str r6, [sp]
a02319d8 mov r2, #0xc4
a02319dc movt r0, #0xa059
a02319e0 mvn r4, #1
a02319e4 bl #0xa02a70ec
a02319e8 b #0xa0231868
a02319ec movw r5, #0x307c
a02319f0 movw r0, #0x80
a02319f4 movt r5, #0xa06f
a02319f8 movw r3, #0xfdf8
a02319fc ldr r1, [r5, #8]
a0231a00 movt r3, #0xa059
a0231a04 str r4, [sp]
a0231a08 movw r2, #0x107
a0231a0c movt r0, #0xa05a
a0231a10 mvn r4, #6
a0231a14 bl #0xa02a70ec
a0231a18 b #0xa0231868
