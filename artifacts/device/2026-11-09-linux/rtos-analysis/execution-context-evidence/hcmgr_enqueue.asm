a01e5da4 70402de9 push {r4, r5, r6, lr}
a01e5da8 0160a0e1 mov r6, r1
a01e5dac 68409fe5 ldr r4, [pc, #0x68]
a01e5db0 0050a0e1 mov r5, r0
a01e5db4 395a07eb bl #0xa03bc6a0
a01e5db8 0620a0e1 mov r2, r6
a01e5dbc 0c0085e5 str r0, [r5, #0xc]
a01e5dc0 0510a0e1 mov r1, r5
a01e5dc4 400084e2 add r0, r4, #0x40
a01e5dc8 f25907eb bl #0xa03bc598
a01e5dcc 006050e2 subs r6, r0, #0
a01e5dd0 0600001a bne #0xa01e5df0
a01e5dd4 cc3194e5 ldr r3, [r4, #0x1cc]
a01e5dd8 630f84e2 add r0, r4, #0x18c
a01e5ddc 013083e2 add r3, r3, #1
a01e5de0 cc3184e5 str r3, [r4, #0x1cc]
a01e5de4 8c5907eb bl #0xa03bc41c
a01e5de8 0600a0e1 mov r0, r6
a01e5dec 7080bde8 pop {r4, r5, r6, pc}
a01e5df0 d03194e5 ldr r3, [r4, #0x1d0]
a01e5df4 013083e2 add r3, r3, #1
a01e5df8 d03184e5 str r3, [r4, #0x1d0]
a01e5dfc 55dbfeeb bl #0xa019cb58
a01e5e00 08000ee3 movw r0, #0xe008
a01e5e04 002095e5 ldr r2, [r5]
a01e5e08 0610a0e1 mov r1, r6
a01e5e0c 57004ae3 movt r0, #0xa057
a01e5e10 b50403eb bl #0xa02a70ec
a01e5e14 0600a0e1 mov r0, r6
a01e5e18 7080bde8 pop {r4, r5, r6, pc}
