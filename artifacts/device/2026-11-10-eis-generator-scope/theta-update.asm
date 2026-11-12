a02d9b88: 70402de9 push {r4, r5, r6, lr}
a02d9b8c: 0040a0e3 mov r4, #0
a02d9b90: 028b2ded vpush {d8}
a02d9b94: 08d04de2 sub sp, sp, #8
a02d9b98: 08208de2 add r2, sp, #8
a02d9b9c: 031080e2 add r1, r0, #3
a02d9ba0: 044022e5 str r4, [r2, #-4]!
a02d9ba4: 408bb0ee vmov.f64 d8, d0
a02d9ba8: a6f9ffeb bl #0xa02d8248
a02d9bac: 006050e2 subs r6, r0, #0
a02d9bb0: 0e0000ba blt #0xa02d9bf0
a02d9bb4: 04509de5 ldr r5, [sp, #4]
a02d9bb8: 0410a0e1 mov r1, r4
a02d9bbc: 0500a0e1 mov r0, r5
a02d9bc0: 298a03eb bl #0xa03bc46c
a02d9bc4: 04309de5 ldr r3, [sp, #4]
a02d9bc8: 0500a0e1 mov r0, r5
a02d9bcc: 342093e5 ldr r2, [r3, #0x34]
a02d9bd0: 448b83ed vstr d8, [r3, #0x110]
a02d9bd4: 012082e2 add r2, r2, #1
a02d9bd8: 342083e5 str r2, [r3, #0x34]
a02d9bdc: 2d8a03eb bl #0xa03bc498
a02d9be0: 0600a0e1 mov r0, r6
a02d9be4: 08d08de2 add sp, sp, #8
a02d9be8: 028bbdec vpop {d8}
a02d9bec: 7080bde8 pop {r4, r5, r6, pc}
a02d9bf0: 5c000ce3 movw r0, #0xc05c
a02d9bf4: 0060e0e3 mvn r6, #0
a02d9bf8: 5c004ae3 movt r0, #0xa05c
a02d9bfc: 3a35ffeb bl #0xa02a70ec
a02d9c00: f6ffffea b #0xa02d9be0
