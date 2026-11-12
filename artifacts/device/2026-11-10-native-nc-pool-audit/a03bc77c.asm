a03bc77c f8402de9 push {r3, r4, r5, r6, r7, lr}
a03bc780 0340a0e1 mov r4, r3
a03bc784 042082e0 add r2, r2, r4
a03bc788 0030a0e3 mov r3, #0
a03bc78c 0150a0e1 mov r5, r1
a03bc790 2c1b00eb bl #0xa03c3448
a03bc794 007050e2 subs r7, r0, #0
a03bc798 0300001a bne #0xa03bc7ac
a03bc79c 000054e3 cmp r4, #0
a03bc7a0 006095e5 ldr r6, [r5]
a03bc7a4 0200001a bne #0xa03bc7b4
a03bc7a8 046085e5 str r6, [r5, #4]
a03bc7ac 0700a0e1 mov r0, r7
a03bc7b0 f880bde8 pop {r3, r4, r5, r6, r7, pc}
a03bc7b4 0600a0e1 mov r0, r6
a03bc7b8 0410a0e1 mov r1, r4
a03bc7bc ac2705fa blx #0xa0506674
a03bc7c0 000051e3 cmp r1, #0
a03bc7c4 06608410 addne r6, r4, r6
a03bc7c8 06606110 rsbne r6, r1, r6
a03bc7cc f5ffffea b #0xa03bc7a8
