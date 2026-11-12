a04f9744 80ea010c   eor.w    ip, r0, r1
a04f9748 1cf0030f   tst.w    ip, #3
a04f974c 37d1       bne      #0xa04f97be
a04f974e 10f0030c   ands     ip, r0, #3
a04f9752 20f00300   bic      r0, r0, #3
a04f9756 21f00301   bic      r1, r1, #3
a04f975a 50f8042b   ldr      r2, [r0], #4
a04f975e 08bf       it       eq
a04f9760 51f8043b   ldreq    r3, [r1], #4
a04f9764 0ed0       beq      #0xa04f9784
a04f9766 8cf0030c   eor      ip, ip, #3
a04f976a 6ff07f43   mvn      r3, #0xff000000
a04f976e 4feacc0c   lsl.w    ip, ip, #3
a04f9772 23fa0cfc   lsr.w    ip, r3, ip
a04f9776 51f8043b   ldr      r3, [r1], #4
a04f977a 42ea0c02   orr.w    r2, r2, ip
a04f977e 43ea0c03   orr.w    r3, r3, ip
a04f9782 00bf       nop      
a04f9784 a2f1013c   sub.w    ip, r2, #0x1010101
a04f9788 9a42       cmp      r2, r3
a04f978a 01bf       itttt    eq
a04f978c 2cea020c   biceq.w  ip, ip, r2
a04f9790 1cf0803f   tsteq.w  ip, #-0x7f7f7f80
a04f9794 50f8042b   ldreq    r2, [r0], #4
a04f9798 51f8043b   ldreq    r3, [r1], #4
a04f979c f2d0       beq      #0xa04f9784
a04f979e 4fea0260   lsl.w    r0, r2, #0x18
a04f97a2 4fea1222   lsr.w    r2, r2, #8
a04f97a6 0128       cmp      r0, #1
a04f97a8 28bf       it       hs
a04f97aa b0eb036f   cmphs.w  r0, r3, lsl #24
a04f97ae 08bf       it       eq
a04f97b0 1b0a       lsreq    r3, r3, #8
a04f97b2 f4d0       beq      #0xa04f979e
a04f97b4 03f0ff03   and      r3, r3, #0xff
a04f97b8 000e       lsrs     r0, r0, #0x18
a04f97ba c01a       subs     r0, r0, r3
a04f97bc 7047       bx       lr
a04f97be 10f0030f   tst.w    r0, #3
a04f97c2 0ad0       beq      #0xa04f97da
a04f97c4 10f8012b   ldrb     r2, [r0], #1
a04f97c8 11f8013b   ldrb     r3, [r1], #1
a04f97cc 012a       cmp      r2, #1
a04f97ce 28bf       it       hs
a04f97d0 9a42       cmphs    r2, r3
a04f97d2 f4d0       beq      #0xa04f97be
a04f97d4 a2eb0300   sub.w    r0, r2, r3
a04f97d8 7047       bx       lr
a04f97da 4df8045d   str      r5, [sp, #-0x4]!
a04f97de 50f8042b   ldr      r2, [r0], #4
a04f97e2 01f00305   and      r5, r1, #3
a04f97e6 21f00301   bic      r1, r1, #3
a04f97ea 51f8043b   ldr      r3, [r1], #4
a04f97ee 022d       cmp      r5, #2
a04f97f0 26d0       beq      #0xa04f9840
a04f97f2 4dd8       bhi      #0xa04f9890
a04f97f4 22f07f45   bic      r5, r2, #0xff000000
a04f97f8 b5eb132f   cmp.w    r5, r3, lsr #8
a04f97fc a2f1013c   sub.w    ip, r2, #0x1010101
a04f9800 2cea020c   bic.w    ip, ip, r2
a04f9804 0dd1       bne      #0xa04f9822
a04f9806 1cf0803c   ands     ip, ip, #0x80808080
a04f980a 08bf       it       eq
a04f980c 51f8043b   ldreq    r3, [r1], #4
a04f9810 0ad1       bne      #0xa04f9828
a04f9812 85ea0205   eor.w    r5, r5, r2
a04f9816 b5eb036f   cmp.w    r5, r3, lsl #24
a04f981a 0cd1       bne      #0xa04f9836
a04f981c 50f8042b   ldr      r2, [r0], #4
a04f9820 e8e7       b        #0xa04f97f4
