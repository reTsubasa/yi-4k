a04af634 010050e3 cmp r0, #1
a04af638 f0402de9 push {r4, r5, r6, r7, lr}
a04af63c 0150a0e1 mov r5, r1
a04af640 14d04de2 sub sp, sp, #0x14
a04af644 0260a0e1 mov r6, r2
a04af648 400000da ble #0xa04af750
a04af64c 045091e5 ldr r5, [r1, #4]
a04af650 041f0ce3 movw r1, #0xcf04
a04af654 5f104ae3 movt r1, #0xa05f
a04af658 0500a0e1 mov r0, r5
a04af65c 382801fa blx #0xa04f9744
a04af660 004050e2 subs r4, r0, #0
a04af664 2800000a beq #0xa04af70c
a04af668 d41b0be3 movw r1, #0xbbd4
a04af66c 0500a0e1 mov r0, r5
a04af670 57104ae3 movt r1, #0xa057
a04af674 322801fa blx #0xa04f9744
a04af678 004050e2 subs r4, r0, #0
a04af67c 2f00000a beq #0xa04af740
a04af680 0010a0e3 mov r1, #0
a04af684 0500a0e1 mov r0, r5
a04af688 0120a0e1 mov r2, r1
a04af68c 0070a0e3 mov r7, #0
a04af690 242f01fa blx #0xa04fb328
a04af694 0020a0e1 mov r2, r0
a04af698 0ac0a0e3 mov ip, #0xa
a04af69c 8233a0e1 lsl r3, r2, #7
a04af6a0 0150a0e3 mov r5, #1
a04af6a4 540207e3 movw r0, #0x7254
a04af6a8 05c0cde5 strb ip, [sp, #5]
a04af6ac 023143e0 sub r3, r3, r2, lsl #2
a04af6b0 0210a0e1 mov r1, r2
a04af6b4 63004ae3 movt r0, #0xa063
a04af6b8 0450cde5 strb r5, [sp, #4]
a04af6bc 023083e0 add r3, r3, r2
a04af6c0 0c708de5 str r7, [sp, #0xc]
a04af6c4 8331a0e1 lsl r3, r3, #3
a04af6c8 0740a0e1 mov r4, r7
a04af6cc 08308de5 str r3, [sp, #8]
a04af6d0 36ff2fe1 blx r6
a04af6d4 04008de2 add r0, sp, #4
a04af6d8 507dffeb bl #0xa048ec20
a04af6dc 0510a0e1 mov r1, r5
a04af6e0 0d20a0e1 mov r2, sp
a04af6e4 0030e0e3 mvn r3, #0
a04af6e8 0700a0e1 mov r0, r7
a04af6ec f17cffeb bl #0xa048eab8
a04af6f0 617dffeb bl #0xa048ec7c
a04af6f4 a40207e3 movw r0, #0x72a4
a04af6f8 63004ae3 movt r0, #0xa063
a04af6fc 36ff2fe1 blx r6
a04af700 0400a0e1 mov r0, r4
a04af704 14d08de2 add sp, sp, #0x14
a04af708 f080bde8 pop {r4, r5, r6, r7, pc}
a04af70c 8c3c0de3 movw r3, #0xdc8c
a04af710 62304ae3 movt r3, #0xa062
a04af714 003093e5 ldr r3, [r3]
a04af718 783093e5 ldr r3, [r3, #0x78]
a04af71c 010013e3 tst r3, #1
a04af720 20020703 movweq r0, #0x7220
a04af724 38020713 movwne r0, #0x7238
a04af728 63004a03 movteq r0, #0xa063
a04af72c 63004a13 movtne r0, #0xa063
a04af730 36ff2fe1 blx r6
a04af734 0400a0e1 mov r0, r4
a04af738 14d08de2 add sp, sp, #0x14
a04af73c f080bde8 pop {r4, r5, r6, r7, pc}
a04af740 4449ffeb bl #0xa0481c58
a04af744 0400a0e1 mov r0, r4
a04af748 14d08de2 add sp, sp, #0x14
a04af74c f080bde8 pop {r4, r5, r6, r7, pc}
a04af750 6c0107e3 movw r0, #0x716c
a04af754 001091e5 ldr r1, [r1]
a04af758 63004ae3 movt r0, #0xa063
a04af75c 0040e0e3 mvn r4, #0
a04af760 32ff2fe1 blx r2
a04af764 c40107e3 movw r0, #0x71c4
a04af768 63004ae3 movt r0, #0xa063
a04af76c 36ff2fe1 blx r6
a04af770 100207e3 movw r0, #0x7210
a04af774 001095e5 ldr r1, [r5]
a04af778 63004ae3 movt r0, #0xa063
a04af77c 36ff2fe1 blx r6
a04af780 deffffea b #0xa04af700
