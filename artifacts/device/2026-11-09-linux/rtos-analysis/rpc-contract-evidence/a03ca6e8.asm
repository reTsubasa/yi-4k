a03ca6e8 f0402de9 push {r4, r5, r6, r7, lr}
a03ca6ec 0040a0e1 mov r4, r0
a03ca6f0 14d04de2 sub sp, sp, #0x14
a03ca6f4 3c5080e2 add r5, r0, #0x3c
a03ca6f8 0010e0e3 mvn r1, #0
a03ca6fc 0400a0e1 mov r0, r4
a03ca700 59c7ffeb bl #0xa03bc46c
a03ca704 001050e2 subs r1, r0, #0
a03ca708 4a00001a bne #0xa03ca838
a03ca70c 6c3094e5 ldr r3, [r4, #0x6c]
a03ca710 000053e3 cmp r3, #0
a03ca714 1500001a bne #0xa03ca770
a03ca718 0060e0e3 mvn r6, #0
a03ca71c 050000ea b #0xa03ca738
a03ca720 0400a0e1 mov r0, r4
a03ca724 0010e0e3 mvn r1, #0
a03ca728 4fc7ffeb bl #0xa03bc46c
a03ca72c 6c3094e5 ldr r3, [r4, #0x6c]
a03ca730 000053e3 cmp r3, #0
a03ca734 0d00001a bne #0xa03ca770
a03ca738 0400a0e1 mov r0, r4
a03ca73c 55c7ffeb bl #0xa03bc498
a03ca740 0110a0e3 mov r1, #1
a03ca744 00608de5 str r6, [sp]
a03ca748 0500a0e1 mov r0, r5
a03ca74c 0320a0e3 mov r2, #3
a03ca750 0c308de2 add r3, sp, #0xc
a03ca754 54c7ffeb bl #0xa03bc4ac
a03ca758 001050e2 subs r1, r0, #0
a03ca75c efffff0a beq #0xa03ca720
a03ca760 1c010ee3 movw r0, #0xe11c
a03ca764 60004ae3 movt r0, #0xa060
a03ca768 5f72fbeb bl #0xa02a70ec
a03ca76c ebffffea b #0xa03ca720
a03ca770 386094e5 ldr r6, [r4, #0x38]
a03ca774 703094e5 ldr r3, [r4, #0x70]
a03ca778 833186e0 add r3, r6, r3, lsl #3
a03ca77c 043093e5 ldr r3, [r3, #4]
a03ca780 000053e3 cmp r3, #0
a03ca784 68709405 ldreq r7, [r4, #0x68]
a03ca788 3600001a bne #0xa03ca868
a03ca78c 6c3094e5 ldr r3, [r4, #0x6c]
a03ca790 0710a0e1 mov r1, r7
a03ca794 013043e2 sub r3, r3, #1
a03ca798 6c3084e5 str r3, [r4, #0x6c]
a03ca79c 700094e5 ldr r0, [r4, #0x70]
a03ca7a0 010080e2 add r0, r0, #1
a03ca7a4 5ef004fa blx #0xa0506924
a03ca7a8 701084e5 str r1, [r4, #0x70]
a03ca7ac 703094e5 ldr r3, [r4, #0x70]
a03ca7b0 833186e0 add r3, r6, r3, lsl #3
a03ca7b4 043093e5 ldr r3, [r3, #4]
a03ca7b8 000053e3 cmp r3, #0
a03ca7bc f2ffff0a beq #0xa03ca78c
a03ca7c0 700094e5 ldr r0, [r4, #0x70]
a03ca7c4 0710a0e1 mov r1, r7
a03ca7c8 702094e5 ldr r2, [r4, #0x70]
a03ca7cc 6c3094e5 ldr r3, [r4, #0x6c]
a03ca7d0 807196e7 ldr r7, [r6, r0, lsl #3]
a03ca7d4 826186e0 add r6, r6, r2, lsl #3
a03ca7d8 013043e2 sub r3, r3, #1
a03ca7dc 046096e5 ldr r6, [r6, #4]
a03ca7e0 6c3084e5 str r3, [r4, #0x6c]
a03ca7e4 700094e5 ldr r0, [r4, #0x70]
a03ca7e8 010080e2 add r0, r0, #1
a03ca7ec 4cf004fa blx #0xa0506924
a03ca7f0 0130a0e1 mov r3, r1
a03ca7f4 0500a0e1 mov r0, r5
a03ca7f8 0210a0e3 mov r1, #2
a03ca7fc 703084e5 str r3, [r4, #0x70]
a03ca800 38c7ffeb bl #0xa03bc4e8
a03ca804 001050e2 subs r1, r0, #0
a03ca808 1200001a bne #0xa03ca858
a03ca80c 0400a0e1 mov r0, r4
a03ca810 20c7ffeb bl #0xa03bc498
a03ca814 001050e2 subs r1, r0, #0
a03ca818 0a00001a bne #0xa03ca848
a03ca81c 0100a0e3 mov r0, #1
a03ca820 bec6ffeb bl #0xa03bc320
a03ca824 0600a0e1 mov r0, r6
a03ca828 37ff2fe1 blx r7
a03ca82c 0100a0e3 mov r0, #1
a03ca830 bac6ffeb bl #0xa03bc320
a03ca834 afffffea b #0xa03ca6f8
a03ca838 ec000ee3 movw r0, #0xe0ec
a03ca83c 60004ae3 movt r0, #0xa060
a03ca840 2972fbeb bl #0xa02a70ec
a03ca844 b0ffffea b #0xa03ca70c
a03ca848 78010ee3 movw r0, #0xe178
a03ca84c 60004ae3 movt r0, #0xa060
a03ca850 2572fbeb bl #0xa02a70ec
a03ca854 f0ffffea b #0xa03ca81c
a03ca858 4c010ee3 movw r0, #0xe14c
a03ca85c 60004ae3 movt r0, #0xa060
a03ca860 2172fbeb bl #0xa02a70ec
a03ca864 e8ffffea b #0xa03ca80c
a03ca868 687094e5 ldr r7, [r4, #0x68]
a03ca86c d3ffffea b #0xa03ca7c0
