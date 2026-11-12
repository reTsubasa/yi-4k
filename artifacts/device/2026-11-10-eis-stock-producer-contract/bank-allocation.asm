a03092b0: 015085e2 add r5, r5, #1
a03092b4: 070055e1 cmp r5, r7
a03092b8: 3dffff0a beq #0xa0308fb4
a03092bc: 923d05e3 movw r3, #0x5d92
a03092c0: 041016e5 ldr r1, [r6, #-4]
a03092c4: 033040e3 movt r3, #3
a03092c8: 200d02e3 movw r0, #0x2d20
a03092cc: 033085e0 add r3, r5, r3
a03092d0: 010040e3 movt r0, #1
a03092d4: 0391a0e1 lsl sb, r3, #2
a03092d8: 091081e0 add r1, r1, sb
a03092dc: 041081e2 add r1, r1, #4
a03092e0: f3fcffeb bl #0xa03086b4
a03092e4: 000050e3 cmp r0, #0
a03092e8: 53ffffba blt #0xa030903c
a03092ec: 043016e5 ldr r3, [r6, #-4]
a03092f0: 093083e0 add r3, r3, sb
a03092f4: 049093e5 ldr sb, [r3, #4]
a03092f8: 1f0019e3 tst sb, #0x1f
a03092fc: 9affff0a beq #0xa030916c
