a02a2584 030050e3 cmp r0, #3
a02a2588 70402de9 push {r4, r5, r6, lr}
a02a258c 0140a0e1 mov r4, r1
a02a2590 28d04de2 sub sp, sp, #0x28
a02a2594 0260a0e1 mov r6, r2
a02a2598 3900001a bne #0xa02a2684
a02a259c 040091e5 ldr r0, [r1, #4]
a02a25a0 0130d0e5 ldrb r3, [r0, #1]
a02a25a4 3a0053e3 cmp r3, #0x3a
a02a25a8 2500001a bne #0xa02a2644
a02a25ac 08108de2 add r1, sp, #8
a02a25b0 f72e02eb bl #0xa032e194
a02a25b4 000050e3 cmp r0, #0
a02a25b8 1900001a bne #0xa02a2624
a02a25bc 04108de2 add r1, sp, #4
a02a25c0 080094e5 ldr r0, [r4, #8]
a02a25c4 5a1500eb bl #0xa02a7b34
a02a25c8 e01a01e3 movw r1, #0x1ae0
a02a25cc 040094e5 ldr r0, [r4, #4]
a02a25d0 54104ae3 movt r1, #0xa054
a02a25d4 bb2e02eb bl #0xa032e0c8
a02a25d8 005050e2 subs r5, r0, #0
a02a25dc 2e00000a beq #0xa02a269c
a02a25e0 0110a0e3 mov r1, #1
a02a25e4 10209de5 ldr r2, [sp, #0x10]
a02a25e8 0530a0e1 mov r3, r5
a02a25ec 04009de5 ldr r0, [sp, #4]
a02a25f0 b72e02eb bl #0xa032e0d4
a02a25f4 d021cde1 ldrd r2, r3, [sp, #0x10]
a02a25f8 0010a0e3 mov r1, #0
a02a25fc 030051e1 cmp r1, r3
a02a2600 02005001 cmpeq r0, r2
a02a2604 1300001a bne #0xa02a2658
a02a2608 0500a0e1 mov r0, r5
a02a260c af2e02eb bl #0xa032e0d0
a02a2610 000050e3 cmp r0, #0
a02a2614 0000a0a3 movge r0, #0
a02a2618 2a0000ba blt #0xa02a26c8
a02a261c 28d08de2 add sp, sp, #0x28
a02a2620 7080bde8 pop {r4, r5, r6, pc}
a02a2624 045094e5 ldr r5, [r4, #4]
a02a2628 b92e02eb bl #0xa032e114
a02a262c 0020a0e1 mov r2, r0
a02a2630 680c0fe3 movw r0, #0xfc68
a02a2634 0510a0e1 mov r1, r5
a02a2638 5a004ae3 movt r0, #0xa05a
a02a263c 36ff2fe1 blx r6
a02a2640 ddffffea b #0xa02a25bc
a02a2644 540c0fe3 movw r0, #0xfc54
a02a2648 5a004ae3 movt r0, #0xa05a
a02a264c 32ff2fe1 blx r2
a02a2650 0100e0e3 mvn r0, #1
a02a2654 f0ffffea b #0xa02a261c
a02a2658 005094e5 ldr r5, [r4]
a02a265c 044094e5 ldr r4, [r4, #4]
a02a2660 ab2e02eb bl #0xa032e114
a02a2664 0030a0e1 mov r3, r0
a02a2668 880c0fe3 movw r0, #0xfc88
a02a266c 0510a0e1 mov r1, r5
a02a2670 0420a0e1 mov r2, r4
a02a2674 5a004ae3 movt r0, #0xa05a
a02a2678 36ff2fe1 blx r6
a02a267c 0300e0e3 mvn r0, #3
a02a2680 e5ffffea b #0xa02a261c
a02a2684 340c0fe3 movw r0, #0xfc34
a02a2688 001091e5 ldr r1, [r1]
a02a268c 5a004ae3 movt r0, #0xa05a
a02a2690 32ff2fe1 blx r2
a02a2694 0000e0e3 mvn r0, #0
a02a2698 dfffffea b #0xa02a261c
a02a269c 005094e5 ldr r5, [r4]
a02a26a0 044094e5 ldr r4, [r4, #4]
a02a26a4 9a2e02eb bl #0xa032e114
a02a26a8 0030a0e1 mov r3, r0
a02a26ac 880c0fe3 movw r0, #0xfc88
a02a26b0 0510a0e1 mov r1, r5
a02a26b4 0420a0e1 mov r2, r4
a02a26b8 5a004ae3 movt r0, #0xa05a
a02a26bc 36ff2fe1 blx r6
a02a26c0 0200e0e3 mvn r0, #2
a02a26c4 d4ffffea b #0xa02a261c
a02a26c8 005094e5 ldr r5, [r4]
a02a26cc 044094e5 ldr r4, [r4, #4]
a02a26d0 8f2e02eb bl #0xa032e114
a02a26d4 0030a0e1 mov r3, r0
a02a26d8 880c0fe3 movw r0, #0xfc88
a02a26dc 0510a0e1 mov r1, r5
a02a26e0 0420a0e1 mov r2, r4
a02a26e4 5a004ae3 movt r0, #0xa05a
a02a26e8 36ff2fe1 blx r6
a02a26ec 0400e0e3 mvn r0, #4
a02a26f0 c9ffffea b #0xa02a261c
