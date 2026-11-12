a03d0780 f0412de9 push {r4, r5, r6, r7, r8, lr}
a03d0784 b03205e3 movw r3, #0x52b0
a03d0788 002090e5 ldr r2, [r0]
a03d078c 44314ae3 movt r3, #0xa144
a03d0790 10d04de2 sub sp, sp, #0x10
a03d0794 587093e5 ldr r7, [r3, #0x58]
a03d0798 ac4092e5 ldr r4, [r2, #0xac]
a03d079c 024044e2 sub r4, r4, #2
a03d07a0 0240d4e3 bics r4, r4, #2
a03d07a4 6500001a bne #0xa03d0940
a03d07a8 0050a0e1 mov r5, r0
a03d07ac e03601e3 movw r3, #0x16e0
a03d07b0 400401e3 movw r0, #0x1440
a03d07b4 7e314ae3 movt r3, #0xa17e
a03d07b8 0180a0e3 mov r8, #1
a03d07bc 7e014ae3 movt r0, #0xa17e
a03d07c0 008083e5 str r8, [r3]
a03d07c4 0460a0e1 mov r6, r4
a03d07c8 d3aeffeb bl #0xa03bc31c
a03d07cc fc3b0fe3 movw r3, #0xfbfc
a03d07d0 08108de2 add r1, sp, #8
a03d07d4 3c304ae3 movt r3, #0xa03c
a03d07d8 5400a0e3 mov r0, #0x54
a03d07dc 08408de5 str r4, [sp, #8]
a03d07e0 0c308de5 str r3, [sp, #0xc]
a03d07e4 0a80cde5 strb r8, [sp, #0xa]
a03d07e8 9bc902eb bl #0xa0482e5c
a03d07ec 08008de2 add r0, sp, #8
a03d07f0 e9aeffeb bl #0xa03bc39c
a03d07f4 00600fe1 mrs r6, apsr
a03d07f8 c0000cf1 cpsid if
a03d07fc 000003e3 movw r0, #0x3000
a03d0800 0710a0e1 mov r1, r7
a03d0804 012aa0e3 mov r2, #0x1000
a03d0808 3d004ae3 movt r0, #0xa03d
a03d080c 9b2ffbeb bl #0xa029c680
a03d0810 04008de2 add r0, sp, #4
a03d0814 344f03eb bl #0xa04a44ec
a03d0818 011a87e2 add r1, r7, #0x1000
a03d081c 04009de5 ldr r0, [sp, #4]
a03d0820 0129a0e3 mov r2, #0x4000
a03d0824 952ffbeb bl #0xa029c680
a03d0828 04209de5 ldr r2, [sp, #4]
a03d082c fc1f03e3 movw r1, #0x3ffc
a03d0830 ff3d82e2 add r3, r2, #0x3fc0
a03d0834 3c3083e2 add r3, r3, #0x3c
a03d0838 04308de5 str r3, [sp, #4]
a03d083c 023091e7 ldr r3, [r1, r2]
a03d0840 ff3ec3e3 bic r3, r3, #0xff0
a03d0844 0f30c3e3 bic r3, r3, #0xf
a03d0848 0300a0e1 mov r0, r3
a03d084c 04308de5 str r3, [sp, #4]
a03d0850 df4c03eb bl #0xa04a3bd4
a03d0854 051a87e2 add r1, r7, #0x5000
a03d0858 012aa0e3 mov r2, #0x1000
a03d085c 04008de5 str r0, [sp, #4]
a03d0860 862ffbeb bl #0xa029c680
a03d0864 06ea87e2 add lr, r7, #0x6000
a03d0868 20c004e3 movw ip, #0x4020
a03d086c 00009ee5 ldr r0, [lr]
a03d0870 3dc04ae3 movt ip, #0xa03d
a03d0874 04109ee5 ldr r1, [lr, #4]
a03d0878 08209ee5 ldr r2, [lr, #8]
a03d087c 0c309ee5 ldr r3, [lr, #0xc]
a03d0880 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03d0884 10009ee5 ldr r0, [lr, #0x10]
a03d0888 14109ee5 ldr r1, [lr, #0x14]
a03d088c 18209ee5 ldr r2, [lr, #0x18]
a03d0890 1c309ee5 ldr r3, [lr, #0x1c]
a03d0894 0f00ace8 stm ip!, {r0, r1, r2, r3}
a03d0898 cefcffeb bl #0xa03cfbd8
a03d089c ac4503eb bl #0xa04a1f54
a03d08a0 4ff07ff5 dsb sy
a03d08a4 0430a0e1 mov r3, r4
a03d08a8 00300fe1 mrs r3, apsr
a03d08ac c030c3e3 bic r3, r3, #0xc0
a03d08b0 c06006e2 and r6, r6, #0xc0
a03d08b4 063083e1 orr r3, r3, r6
a03d08b8 03f021e1 msr cpsr_c, r3
a03d08bc 08009de5 ldr r0, [sp, #8]
a03d08c0 c1aeffeb bl #0xa03bc3cc
a03d08c4 3c3401e3 movw r3, #0x143c
a03d08c8 d8cb0fe3 movw ip, #0xfbd8
a03d08cc 7e314ae3 movt r3, #0xa17e
a03d08d0 3cc04ae3 movt ip, #0xa03c
a03d08d4 0810a0e1 mov r1, r8
a03d08d8 0420a0e1 mov r2, r4
a03d08dc 5400a0e3 mov r0, #0x54
a03d08e0 00c083e5 str ip, [r3]
a03d08e4 94c902eb bl #0xa0482f3c
a03d08e8 061a87e2 add r1, r7, #0x6000
a03d08ec d820a0e3 mov r2, #0xd8
a03d08f0 201081e2 add r1, r1, #0x20
a03d08f4 000095e5 ldr r0, [r5]
a03d08f8 602ffbeb bl #0xa029c680
a03d08fc 000095e5 ldr r0, [r5]
a03d0900 10ffffeb bl #0xa03d0548
a03d0904 114f07ee mcr p15, #0, r4, c7, c1, #0
a03d0908 080095e5 ldr r0, [r5, #8]
a03d090c 000050e3 cmp r0, #0
a03d0910 0000000a beq #0xa03d0918
a03d0914 80aeffeb bl #0xa03bc31c
a03d0918 003095e5 ldr r3, [r5]
a03d091c 0110a0e3 mov r1, #1
a03d0920 0000a0e3 mov r0, #0
a03d0924 0220a0e3 mov r2, #2
a03d0928 103093e5 ldr r3, [r3, #0x10]
a03d092c 001083e5 str r1, [r3]
a03d0930 003095e5 ldr r3, [r5]
a03d0934 ac2083e5 str r2, [r3, #0xac]
a03d0938 10d08de2 add sp, sp, #0x10
a03d093c f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03d0940 0000e0e3 mvn r0, #0
a03d0944 fbffffea b #0xa03d0938
