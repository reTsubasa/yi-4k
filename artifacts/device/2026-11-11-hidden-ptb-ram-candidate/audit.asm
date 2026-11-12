a0492dc8: cmp r0, #0
a0492dcc: beq #0xa0492df4
a0492dd0: cmp r1, #0xc
a0492dd4: bhi #0xa0492e10
a0492dd8: movw r3, #0xb604
a0492ddc: lsl r0, r1, #6
a0492de0: movt r3, #0xa078
a0492de4: ldr r3, [r3]
a0492de8: add r0, r0, #8
a0492dec: add r0, r3, r0
a0492df0: bx lr
a0492df4: cmp r1, #2
a0492df8: movwls r3, #0xb600
a0492dfc: movtls r3, #0xa078
a0492e00: ldrls r3, [r3]
a0492e04: addls r0, r3, r1, lsl #6
a0492e08: addls r0, r0, #0xc
a0492e0c: bx lr
a0492e10: mov r0, #0
a0492e14: bx lr

a02a79f0: cmp r1, #0
a02a79f4: beq #0xa02a7a2c
a02a79f8: movw ip, #0x1558
a02a79fc: add r1, r0, r1
a02a7a00: movt ip, #0xa05b
a02a7a04: mvn r2, #0
a02a7a08: ldrb r3, [r0], #1
a02a7a0c: eor r3, r3, r2
a02a7a10: cmp r0, r1
a02a7a14: uxtb r3, r3
a02a7a18: ldr r3, [ip, r3, lsl #2]
a02a7a1c: eor r2, r3, r2, lsr #8
a02a7a20: bne #0xa02a7a08
a02a7a24: mvn r0, r2
a02a7a28: bx lr
a02a7a2c: mov r0, r1
a02a7a30: bx lr

a048498c: movw r3, #0xb244
a0484990: movw r2, #0x9c44
a0484994: movt r2, #0xa1a3
a0484998: movt r3, #0xa078
a048499c: push {r4, r5, r6, lr}
a04849a0: sub sp, sp, #8
a04849a4: ldr r4, [r3, #0x10]
a04849a8: mov r6, r0
a04849ac: mov r3, #0
a04849b0: ldrh ip, [r2, #0x26]
a04849b4: ldrh r0, [r2, #0x24]
a04849b8: mov r2, r4
a04849bc: str r1, [sp]
a04849c0: mov r1, ip
a04849c4: bl #0xa04831f0
a04849c8: subs r5, r0, #0
a04849cc: beq #0xa04849dc
a04849d0: mov r0, r5
a04849d4: add sp, sp, #8
a04849d8: pop {r4, r5, r6, pc}
a04849dc: movw r3, #0xb600
a04849e0: mov r1, r4
a04849e4: movt r3, #0xa078
a04849e8: mov r2, #0x1d0
a04849ec: ldr r0, [r3]
a04849f0: bl #0xa029c680
a04849f4: cmp r6, r4
a04849f8: cmpne r6, #0
a04849fc: beq #0xa04849d0
a0484a00: mov r0, r6
a0484a04: mov r1, r4
a0484a08: mov r2, #0x1d0
a0484a0c: bl #0xa029c680
a0484a10: mov r0, r5
a0484a14: add sp, sp, #8
a0484a18: pop {r4, r5, r6, pc}

a0484b0c: movw r3, #0x9c44
a0484b10: push {r4, r5, r6, lr}
a0484b14: movt r3, #0xa1a3
a0484b18: movw r2, #0xb244
a0484b1c: movt r2, #0xa078
a0484b20: sub sp, sp, #8
a0484b24: ldr lr, [r3]
a0484b28: ldr r6, [r2, #0x10]
a0484b2c: cmp lr, #0
a0484b30: beq #0xa0484bc0
a0484b34: movw r2, #0xb600
a0484b38: mov r4, r0
a0484b3c: movt r2, #0xa078
a0484b40: ldrb r0, [lr, #9]
a0484b44: ldr lr, [r2]
a0484b48: mov ip, r1
a0484b4c: mov r2, r6
a0484b50: ldrh r1, [r3, #0x28]
a0484b54: mov r3, #0
a0484b58: ldr lr, [lr, #8]
a0484b5c: str ip, [sp]
a0484b60: mul r0, lr, r0
a0484b64: bl #0xa04831f0
a0484b68: subs r5, r0, #0
a0484b6c: movne r0, r5
a0484b70: beq #0xa0484b7c
a0484b74: add sp, sp, #8
a0484b78: pop {r4, r5, r6, pc}
a0484b7c: movw r3, #0xb604
a0484b80: mov r1, r6
a0484b84: movt r3, #0xa078
a0484b88: mov r2, #0x354
a0484b8c: ldr r0, [r3]
a0484b90: bl #0xa029c680
a0484b94: cmp r4, r6
a0484b98: cmpne r4, #0
a0484b9c: movne r0, #1
a0484ba0: moveq r0, #0
a0484ba4: beq #0xa0484b74
a0484ba8: mov r0, r4
a0484bac: mov r1, r6
a0484bb0: mov r2, #0x354
a0484bb4: bl #0xa029c680
a0484bb8: mov r0, r5
a0484bbc: b #0xa0484b74
a0484bc0: mvn r0, #0
a0484bc4: b #0xa0484b74

a0484cf4: push {r3, r4, r5, r6, r7, lr}
a0484cf8: movw r4, #0xb600
a0484cfc: movt r4, #0xa078
a0484d00: mov r7, r0
a0484d04: mov r1, #0x1cc
a0484d08: ldr r0, [r4]
a0484d0c: bl #0xa02a79f0
a0484d10: ldr r3, [r4]
a0484d14: ldr r2, [r3, #0x1cc]
a0484d18: cmp r2, r0
a0484d1c: beq #0xa0484e34
a0484d20: mov r1, r7
a0484d24: mov r0, #0
a0484d28: bl #0xa048498c
a0484d2c: mov r1, #0x1cc
a0484d30: mov r6, r0
a0484d34: ldr r0, [r4]
a0484d38: movw r5, #0xb600
a0484d3c: bl #0xa02a79f0
a0484d40: cmp r6, #0
a0484d44: movt r5, #0xa078
a0484d48: bne #0xa0484d5c
a0484d4c: ldr r3, [r5]
a0484d50: ldr r2, [r3, #0x1cc]
a0484d54: cmp r2, r0
a0484d58: beq #0xa0484e68
a0484d5c: movw r0, #0xaf60
a0484d60: movw r6, #0xaf48
a0484d64: movt r0, #0xa062
a0484d68: movw r5, #0xaf84
a0484d6c: bl #0xa02a70ec
a0484d70: ldr r0, [r4]
a0484d74: mov r1, #0xff
a0484d78: mov r2, #0x1d0
a0484d7c: movt r6, #0xa062
a0484d80: blx #0xa04f8dec
a0484d84: movw r3, #0xb604
a0484d88: mov r1, #0xff
a0484d8c: movt r3, #0xa078
a0484d90: mov r2, #0x354
a0484d94: ldr r0, [r3]
a0484d98: movt r5, #0xa062
a0484d9c: blx #0xa04f8dec
a0484da0: mov r0, r7
a0484da4: bl #0xa048372c
a0484da8: cmp r0, #0
a0484dac: mov r4, r0
a0484db0: movw r0, #0xaf50
a0484db4: moveq r1, r6
a0484db8: movne r1, r5
a0484dbc: movt r0, #0xa062
a0484dc0: bl #0xa02a70ec
a0484dc4: bl #0xa0483d98
a0484dc8: orrs r4, r0, r4
a0484dcc: movw r0, #0xaf8c
a0484dd0: bne #0xa0484e20
a0484dd4: mov r1, r6
a0484dd8: movt r0, #0xa062
a0484ddc: bl #0xa02a70ec
a0484de0: movw r3, #0x6c34
a0484de4: movt r3, #0xa1a3
a0484de8: ldr r3, [r3]
a0484dec: cmp r3, #0
a0484df0: moveq r4, r3
a0484df4: beq #0xa0484e2c
a0484df8: mov r1, r7
a0484dfc: mov r0, r4
a0484e00: bl #0xa0484a1c
a0484e04: mov r1, r7
a0484e08: mov r5, r0
a0484e0c: mov r0, r4
a0484e10: bl #0xa0484bc8
a0484e14: orr r4, r0, r5
a0484e18: mov r0, r4
a0484e1c: pop {r3, r4, r5, r6, r7, pc}
a0484e20: mov r1, r5
a0484e24: movt r0, #0xa062
a0484e28: bl #0xa02a70ec
a0484e2c: mov r0, r4
a0484e30: pop {r3, r4, r5, r6, r7, pc}
a0484e34: ldr r3, [r3, #4]
a0484e38: cmp r3, #0
a0484e3c: beq #0xa0484d20
a0484e40: movw r3, #0x6c30
a0484e44: movt r3, #0xa1a3
a0484e48: ldr r3, [r3]
a0484e4c: cmp r3, #0
a0484e50: bne #0xa0484d20
a0484e54: movw r0, #0xaef8
a0484e58: mov r4, r3
a0484e5c: movt r0, #0xa062
a0484e60: bl #0xa02a70ec
a0484e64: b #0xa0484e2c
a0484e68: ldr r3, [r3, #4]
a0484e6c: cmp r3, #0
a0484e70: beq #0xa0484d5c
a0484e74: movw r3, #0x6c30
a0484e78: movt r3, #0xa1a3
a0484e7c: ldr r5, [r3]
a0484e80: cmp r5, #0
a0484e84: bne #0xa0484d5c
a0484e88: movw r0, #0xaf24
a0484e8c: movt r0, #0xa062
a0484e90: bl #0xa02a70ec
a0484e94: mov r0, r5
a0484e98: mov r1, r7
