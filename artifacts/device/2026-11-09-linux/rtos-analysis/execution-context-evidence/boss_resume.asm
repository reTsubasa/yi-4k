a03d06c8 10402de9 push {r4, lr}
a03d06cc e03601e3 movw r3, #0x16e0
a03d06d0 0040a0e1 mov r4, r0
a03d06d4 400401e3 movw r0, #0x1440
a03d06d8 10d04de2 sub sp, sp, #0x10
a03d06dc 7e314ae3 movt r3, #0xa17e
a03d06e0 0120a0e3 mov r2, #1
a03d06e4 7e014ae3 movt r0, #0xa17e
a03d06e8 002083e5 str r2, [r3]
a03d06ec 0aafffeb bl #0xa03bc31c
a03d06f0 883301e3 movw r3, #0x1388
a03d06f4 180100e3 movw r0, #0x118
a03d06f8 00308de5 str r3, [sp]
a03d06fc 0320a0e3 mov r2, #3
a03d0700 7e014ae3 movt r0, #0xa17e
a03d0704 4010a0e3 mov r1, #0x40
a03d0708 0c308de2 add r3, sp, #0xc
a03d070c 66afffeb bl #0xa03bc4ac
a03d0710 002050e2 subs r2, r0, #0
a03d0714 0400000a beq #0xa03d072c
a03d0718 54000de3 movw r0, #0xd054
a03d071c a0180fe3 movw r1, #0xf8a0
a03d0720 60004ae3 movt r0, #0xa060
a03d0724 60104ae3 movt r1, #0xa060
a03d0728 6f5afbeb bl #0xa02a70ec
a03d072c 000094e5 ldr r0, [r4]
a03d0730 84ffffeb bl #0xa03d0548
a03d0734 0000a0e3 mov r0, #0
a03d0738 110f07ee mcr p15, #0, r0, c7, c1, #0
a03d073c 003094e5 ldr r3, [r4]
a03d0740 0220a0e3 mov r2, #2
a03d0744 ac2083e5 str r2, [r3, #0xac]
a03d0748 10d08de2 add sp, sp, #0x10
a03d074c 1080bde8 pop {r4, pc}
