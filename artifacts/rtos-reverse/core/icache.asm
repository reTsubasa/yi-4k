a04a2850 1c00002a   bhs      #0xa04a28c8
a04a2854 302f19ee   mrc      p15, #0, r2, c9, c0, #1
a04a2858 0f0012e3   tst      r2, #0xf
a04a285c 1900001a   bne      #0xa04a28c8
a04a2860 160270e3   cmn      r0, #0x60000001
a04a2864 0a028092   addls    r0, r0, #0xa0000000
a04a2868 160273e3   cmn      r3, #0x60000001
a04a286c 16324192   subls    r3, r1, #0x60000001
a04a2870 0010a0e3   mov      r1, #0
a04a2874 0120a0e1   mov      r2, r1
a04a2878 00200fe1   mrs      r2, apsr
a04a287c c0000cf1   cpsid    if
a04a2880 151f07ee   mcr      p15, #0, r1, c7, c5, #0
a04a2884 4ff07ff5   dsb      sy
a04a2888 0110e0e3   mvn      r1, #1
a04a288c 301f09ee   mcr      p15, #0, r1, c9, c0, #1
a04a2890 4ff07ff5   dsb      sy
a04a2894 030050e1   cmp      r0, r3
a04a2898 0300002a   bhs      #0xa04a28ac
a04a289c 3d0f07ee   mcr      p15, #0, r0, c7, c13, #1
a04a28a0 200080e2   add      r0, r0, #0x20
a04a28a4 000053e1   cmp      r3, r0
a04a28a8 fbffff8a   bhi      #0xa04a289c
a04a28ac 4ff07ff5   dsb      sy
a04a28b0 0e30e0e3   mvn      r3, #0xe
a04a28b4 303f09ee   mcr      p15, #0, r3, c9, c0, #1
a04a28b8 4ff07ff5   dsb      sy
a04a28bc 02f02fe1   msr      cpsr_fsxc, r2
a04a28c0 0000a0e3   mov      r0, #0
a04a28c4 1eff2fe1   bx       lr
a04a28c8 0000e0e3   mvn      r0, #0
a04a28cc 1eff2fe1   bx       lr
a04a28d0 4ff07ff5   dsb      sy
a04a28d4 0f30e0e3   mvn      r3, #0xf
a04a28d8 303f09ee   mcr      p15, #0, r3, c9, c0, #1
a04a28dc 4ff07ff5   dsb      sy
a04a28e0 1eff2fe1   bx       lr
a04a28e4 4ff07ff5   dsb      sy
a04a28e8 0f30e0e3   mvn      r3, #0xf
a04a28ec 103f09ee   mcr      p15, #0, r3, c9, c0, #0
