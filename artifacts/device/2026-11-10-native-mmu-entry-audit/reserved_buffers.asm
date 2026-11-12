a02c6c5c 30402de9 push {r4, r5, lr}
a02c6c60 00c000e3 movw ip, #0
a02c6c64 005000e3 movw r5, #0
a02c6c68 004000e3 movw r4, #0
a02c6c6c 00e000e3 movw lr, #0
a02c6c70 b0514ae3 movt r5, #0xa1b0
a02c6c74 f8414ae3 movt r4, #0xa1f8
a02c6c78 00e24ae3 movt lr, #0xa200
a02c6c7c 08c24ae3 movt ip, #0xa208
a02c6c80 005080e5 str r5, [r0]
a02c6c84 004081e5 str r4, [r1]
a02c6c88 00e082e5 str lr, [r2]
a02c6c8c 00c083e5 str ip, [r3]
a02c6c90 3080bde8 pop {r4, r5, pc}
