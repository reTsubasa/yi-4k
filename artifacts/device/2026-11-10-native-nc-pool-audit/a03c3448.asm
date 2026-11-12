a03c3448 000050e3 cmp r0, #0
a03c344c 0700000a beq #0xa03c3470
a03c3450 f0412de9 push {r4, r5, r6, r7, r8, lr}
a03c3454 45c405e3 movw ip, #0x5445
a03c3458 00e090e5 ldr lr, [r0]
a03c345c 59c244e3 movt ip, #0x4259
a03c3460 0c005ee1 cmp lr, ip
a03c3464 0300000a beq #0xa03c3478
a03c3468 0200a0e3 mov r0, #2
a03c346c f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03c3470 0200a0e3 mov r0, #2
a03c3474 1eff2fe1 bx lr
a03c3478 000051e3 cmp r1, #0
a03c347c 0300000a beq #0xa03c3490
a03c3480 000052e3 cmp r2, #0
a03c3484 0300001a bne #0xa03c3498
a03c3488 0500a0e3 mov r0, #5
a03c348c f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03c3490 0300a0e3 mov r0, #3
a03c3494 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03c3498 1cc090e5 ldr ip, [r0, #0x1c]
a03c349c 0c0052e1 cmp r2, ip
a03c34a0 f8ffff8a bhi #0xa03c3488
a03c34a4 000053e3 cmp r3, #0
a03c34a8 0370a0e1 mov r7, r3
a03c34ac 0260a0e1 mov r6, r2
a03c34b0 0150a0e1 mov r5, r1
a03c34b4 0040a0e1 mov r4, r0
a03c34b8 0400000a beq #0xa03c34d0
a03c34bc 11f6ffeb bl #0xa03c0d08
a03c34c0 000050e3 cmp r0, #0
a03c34c4 0100000a beq #0xa03c34d0
a03c34c8 0400a0e3 mov r0, #4
a03c34cc f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03c34d0 1df6ffeb bl #0xa03c0d4c
a03c34d4 343c06e3 movw r3, #0x6c34
a03c34d8 79314ae3 movt r3, #0xa179
a03c34dc 000053e1 cmp r3, r0
a03c34e0 0700000a beq #0xa03c3504
a03c34e4 07f6ffeb bl #0xa03c0d08
a03c34e8 000050e3 cmp r0, #0
a03c34ec 0600000a beq #0xa03c350c
a03c34f0 04f6ffeb bl #0xa03c0d08
a03c34f4 ef300fe3 movw r3, #0xf0ef
a03c34f8 f0304fe3 movt r3, #0xf0f0
a03c34fc 030050e1 cmp r0, r3
a03c3500 0100008a bhi #0xa03c350c
a03c3504 1300a0e3 mov r0, #0x13
a03c3508 f081bde8 pop {r4, r5, r6, r7, r8, pc}
a03c350c 0400a0e1 mov r0, r4
a03c3510 0510a0e1 mov r1, r5
a03c3514 0620a0e1 mov r2, r6
a03c3518 0730a0e1 mov r3, r7
a03c351c f041bde8 pop {r4, r5, r6, r7, r8, lr}
a03c3520 fee5ffea b #0xa03bcd20
