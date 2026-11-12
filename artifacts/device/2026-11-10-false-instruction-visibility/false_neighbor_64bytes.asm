a02a0a80 36ff2fe1 blx r6
a02a0a84 070054e1 cmp r4, r7
a02a0a88 18090ce3 movw r0, #0xc918
a02a0a8c 5f004ae3 movt r0, #0xa05f
a02a0a90 f5ffff1a bne #0xa02a0a6c
a02a0a94 2c0500e3 movw r0, #0x52c
a02a0a98 58004ae3 movt r0, #0xa058
a02a0a9c 36ff2fe1 blx r6
a02a0aa0 0000a0e3 mov r0, #0
a02a0aa4 f880bde8 pop {r3, r4, r5, r6, r7, pc}
a02a0aa8 0000e0e3 mvn r0, #0
a02a0aac 1eff2fe1 bx lr
a02a0ab0 010050e3 cmp r0, #1
a02a0ab4 38402de9 push {r3, r4, r5, lr}
a02a0ab8 0250a0e1 mov r5, r2
a02a0abc 240000da ble #0xa02a0b54
