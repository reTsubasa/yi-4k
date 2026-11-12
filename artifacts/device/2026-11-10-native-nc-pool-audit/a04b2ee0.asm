a04b2ee0 083509e3 movw r3, #0x9508
a04b2ee4 000051e3 cmp r1, #0
a04b2ee8 a4314ae3 movt r3, #0xa1a4
a04b2eec 000083e5 str r0, [r3]
a04b2ef0 0c3509e3 movw r3, #0x950c
a04b2ef4 a4314ae3 movt r3, #0xa1a4
a04b2ef8 00008305 streq r0, [r3]
a04b2efc 0000a0e3 mov r0, #0
a04b2f00 00108315 strne r1, [r3]
a04b2f04 1eff2fe1 bx lr
