a01b8710 push {r4, r5, r6, r7, lr}
a01b8714 sub sp, sp, #0x510
a01b8718 sub sp, sp, #0xc
a01b871c mov r6, #0
a01b8720 add r4, sp, #0x118
a01b8724 mov r1, r6
a01b8728 mov r2, #0x400
a01b872c mov r0, r4
a01b8730 str r6, [sp, #0xc]
a01b8734 movw r5, #0x5270
a01b8738 str r6, [sp, #0x10]
a01b873c movt r5, #0xa126
a01b8740 str r6, [sp, #0x14]
a01b8744 blx #0xa04f8dec
a01b8748 mov r1, r6
a01b874c mov r2, #0x80
a01b8750 add r0, sp, #0x18
a01b8754 blx #0xa04f8dec
a01b8758 mov r1, r6
a01b875c add r0, sp, #0x98
a01b8760 mov r2, #0x80
a01b8764 blx #0xa04f8dec
a01b8768 ldr r3, [r5, #0x1c0]
a01b876c cmp r3, r6
a01b8770 beq #0xa01b88c4
a01b8774 movw r6, #0x307c
a01b8778 movt r6, #0xa06f
a01b877c add r1, sp, #0xc
a01b8780 mvn r2, #0
a01b8784 ldr r0, [pc, #0x30c]
a01b8788 bl #0xa03bc56c
a01b878c ldr r1, [sp, #0x14]
a01b8790 mov r2, r4
a01b8794 ldr r0, [sp, #0xc]
a01b8798 mov r3, #0x400
a01b879c uxth r1, r1
a01b87a0 bl #0xa01b7b70
a01b87a4 subs lr, r0, #0
a01b87a8 beq #0xa01b89c4
a01b87ac ldrb r2, [sp, #0x11c]
a01b87b0 sub r1, lr, #7
a01b87b4 ldrb r3, [sp, #0x11d]
a01b87b8 add r2, r3, r2, lsl #8
a01b87bc cmp r1, r2
a01b87c0 bne #0xa01b89d4
a01b87c4 ldrb ip, [sp, #0x118]
a01b87c8 cmp ip, #4
a01b87cc bhi #0xa01b8a38
a01b87d0 ldrb r2, [sp, #0x11a]
a01b87d4 cmp r2, #2
a01b87d8 bhi #0xa01b8a08
a01b87dc ldrb r2, [sp, #0x11b]
a01b87e0 cmp r2, #2
a01b87e4 bhi #0xa01b8a68
a01b87e8 uxth r1, lr
a01b87ec cmp r1, #1
a01b87f0 beq #0xa01b8930
a01b87f4 sub r1, r1, #2
a01b87f8 mov r2, r4
a01b87fc uxtah r1, r4, r1
a01b8800 mov r3, #0
a01b8804 b #0xa01b880c
a01b8808 ldrb ip, [r2, #1]!
a01b880c cmp r2, r1
a01b8810 add r3, ip, r3
a01b8814 uxtb r3, r3
a01b8818 bne #0xa01b8808
a01b881c rsb r3, r3, #0
a01b8820 uxtb r2, r3
a01b8824 sub r3, lr, #1
a01b8828 ldrb ip, [r4, r3]
a01b882c cmp ip, r2
a01b8830 bne #0xa01b8944
a01b8834 add r2, sp, #0x510
a01b8838 add r2, r2, #8
a01b883c add r2, r2, lr
a01b8840 ldrb r2, [r2, #-0x402]
a01b8844 cmp r2, #0
a01b8848 movne r2, #0
a01b884c strbne r2, [r4, r3]
a01b8850 cmp lr, #0
a01b8854 blt #0xa01b8974
a01b8858 mov r2, #0x80
a01b885c mov r0, r4
a01b8860 str r2, [sp]
a01b8864 add r1, sp, #0x18
a01b8868 add r3, sp, #0x98
a01b886c bl #0xa01b83fc
a01b8870 cmp r0, #0
a01b8874 blt #0xa01b88d0
a01b8878 ldrb r3, [sp, #0x18]
a01b887c cmp r3, #0
a01b8880 beq #0xa01b8890
a01b8884 ldrb r3, [sp, #0x98]
a01b8888 cmp r3, #0
a01b888c bne #0xa01b88dc
a01b8890 mov r1, #0
a01b8894 mov r2, #0x80
a01b8898 add r0, sp, #0x18
a01b889c blx #0xa04f8dec
a01b88a0 add r0, sp, #0x98
a01b88a4 mov r1, #0
a01b88a8 mov r2, #0x80
a01b88ac blx #0xa04f8dec
a01b88b0 add r0, sp, #0xc
a01b88b4 bl #0xa03bc7d0
a01b88b8 ldr r3, [r5, #0x1c0]
a01b88bc cmp r3, #0
a01b88c0 bne #0xa01b877c
a01b88c4 add sp, sp, #0x510
a01b88c8 add sp, sp, #0xc
a01b88cc pop {r4, r5, r6, r7, pc}
a01b88d0 mov r0, r4
a01b88d4 bl #0xa01b8638
a01b88d8 b #0xa01b8890
a01b88dc movw r0, #0x557c
a01b88e0 mvn r1, #0
a01b88e4 movt r0, #0xa126
a01b88e8 bl #0xa03bc46c
a01b88ec movw r0, #0x54f8
a01b88f0 add r1, sp, #0x18
a01b88f4 movt r0, #0xa126
a01b88f8 blx #0xa04f9900
a01b88fc movw r0, #0x55b0
a01b8900 add r1, sp, #0x98
a01b8904 movt r0, #0xa126
a01b8908 blx #0xa04f9900
a01b890c movw r0, #0x557c
a01b8910 movt r0, #0xa126
a01b8914 bl #0xa03bc498
a01b8918 mov r1, #0
a01b891c mov r0, #0x10
a01b8920 mov r2, r1
a01b8924 movt r0, #0xd809
a01b8928 bl #0xa01e659c
a01b892c b #0xa01b8890
a01b8930 sub r3, lr, #1
a01b8934 mov r2, #0
a01b8938 ldrb ip, [r4, r3]
a01b893c cmp ip, r2
a01b8940 beq #0xa01b8834
a01b8944 movw r0, #0x150
a01b8948 movw r3, #0xfc6c
a01b894c ldr r1, [r6, #8]
a01b8950 movt r0, #0xa057
a01b8954 stm sp, {r2, ip}
a01b8958 movt r3, #0xa056
a01b895c mov r2, #0xf0
a01b8960 movw r7, #0x307c
a01b8964 bl #0xa02a70ec
a01b8968 movt r7, #0xa06f
a01b896c mvn lr, #6
a01b8970 b #0xa01b897c
a01b8974 movw r7, #0x307c
a01b8978 movt r7, #0xa06f
a01b897c movw r0, #0x188
a01b8980 movw r3, #0xfc6c
a01b8984 ldr r1, [r7, #8]
a01b8988 movt r3, #0xa056
a01b898c str lr, [sp]
a01b8990 mov r2, #0xfc
a01b8994 movt r0, #0xa057
a01b8998 bl #0xa02a70ec
a01b899c mov r0, r4
a01b89a0 bl #0xa01b8638
a01b89a4 movw r0, #0x1b4
a01b89a8 movw r3, #0xfca0
a01b89ac ldr r1, [r7, #8]
a01b89b0 movt r3, #0xa056
a01b89b4 movw r2, #0x2ca
a01b89b8 movt r0, #0xa057
a01b89bc bl #0xa02a70ec
a01b89c0 b #0xa01b88b0
a01b89c4 movw r7, #0x307c
a01b89c8 mvn lr, #1
a01b89cc movt r7, #0xa06f
a01b89d0 b #0xa01b897c
a01b89d4 movw r0, #0x88
a01b89d8 movw r3, #0xfc6c
a01b89dc ldr r1, [r6, #8]
a01b89e0 movt r0, #0xa057
a01b89e4 str lr, [sp]
a01b89e8 movt r3, #0xa056
a01b89ec str r2, [sp, #4]
a01b89f0 movw r7, #0x307c
a01b89f4 mov r2, #0xda
a01b89f8 movt r7, #0xa06f
a01b89fc bl #0xa02a70ec
a01b8a00 mvn lr, #2
a01b8a04 b #0xa01b897c
a01b8a08 movw r0, #0xec
a01b8a0c movw r3, #0xfc6c
a01b8a10 ldr r1, [r6, #8]
a01b8a14 movt r0, #0xa057
a01b8a18 str r2, [sp]
a01b8a1c movt r3, #0xa056
a01b8a20 mov r2, #0xe4
a01b8a24 movw r7, #0x307c
a01b8a28 bl #0xa02a70ec
a01b8a2c movt r7, #0xa06f
a01b8a30 mvn lr, #4
a01b8a34 b #0xa01b897c
a01b8a38 movw r0, #0xbc
a01b8a3c movw r3, #0xfc6c
a01b8a40 ldr r1, [r6, #8]
a01b8a44 movt r0, #0xa057
a01b8a48 str ip, [sp]
a01b8a4c movt r3, #0xa056
a01b8a50 mov r2, #0xdf
a01b8a54 movw r7, #0x307c
a01b8a58 bl #0xa02a70ec
a01b8a5c movt r7, #0xa06f
a01b8a60 mvn lr, #3
a01b8a64 b #0xa01b897c
a01b8a68 movw r0, #0x120
a01b8a6c movw r3, #0xfc6c
a01b8a70 ldr r1, [r6, #8]
a01b8a74 movt r0, #0xa057
a01b8a78 str r2, [sp]
a01b8a7c movt r3, #0xa056
a01b8a80 mov r2, #0xe9
a01b8a84 movw r7, #0x307c
a01b8a88 bl #0xa02a70ec
a01b8a8c movt r7, #0xa06f
a01b8a90 mvn lr, #5
a01b8a94 b #0xa01b897c
