a0233340 push {r4, lr}
a0233344 movw r0, #0xb94
a0233348 movw r4, #0xfa18
a023334c movt r0, #0xa05a
a0233350 movt r4, #0xa142
a0233354 bl #0xa02a70ec
a0233358 mov r0, r4
a023335c bl #0xa04b6174
a0233360 ldr r3, [r4, #0x10]
a0233364 cmp r3, #6
a0233368 beq #0xa02333b8
a023336c movw r0, #0xbd8
a0233370 movt r0, #0xa05a
a0233374 bl #0xa02a70ec
a0233378 movw r0, #0xc18
a023337c movt r0, #0xa05a
a0233380 bl #0xa02a70ec
a0233384 movw r0, #0xc30
a0233388 movt r0, #0xa05a
a023338c bl #0xa02a70ec
a0233390 movw r0, #0xbd8
a0233394 movt r0, #0xa05a
a0233398 bl #0xa02a70ec
a023339c movw r0, #0x1005
a02333a0 ldr r1, [r4]
a02333a4 ldr r2, [r4, #4]
a02333a8 movt r0, #0xe200
a02333ac bl #0xa01e6598
a02333b0 mov r0, #0
a02333b4 pop {r4, pc}
a02333b8 movw r0, #0xbb8
a02333bc ldr r1, [r4]
a02333c0 ldr r2, [r4, #4]
a02333c4 movt r0, #0xa05a
a02333c8 bl #0xa02a70ec
a02333cc mov r0, #0
a02333d0 pop {r4, pc}
