; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a037d9e0 04e02de5 str      lr, [sp, #-4]!
a037d9e4 0cd04de2 sub      sp, sp, #0xc
a037d9e8 40090ee3 movw     r0, #0xe940
a037d9ec 5f004ae3 movt     r0, #0xa05f
a037d9f0 bda5fceb bl       #0xa02a70ec
a037d9f4 10330be3 movw     r3, #0xb310
a037d9f8 70314ae3 movt     r3, #0xa170
a037d9fc 0030d3e5 ldrb     r3, [r3]
a037da00 000053e3 cmp      r3, #0
a037da04 7500001a bne      #0xa037dbe0
a037da08 10330be3 movw     r3, #0xb310
a037da0c 70314ae3 movt     r3, #0xa170
a037da10 0120a0e3 mov      r2, #1
a037da14 0020c3e5 strb     r2, [r3]
a037da18 f03204e3 movw     r3, #0x42f0
a037da1c 70314ae3 movt     r3, #0xa170
a037da20 0128a0e3 mov      r2, #0x10000
a037da24 082083e5 str      r2, [r3, #8]
a037da28 f03204e3 movw     r3, #0x42f0
a037da2c 70314ae3 movt     r3, #0xa170
a037da30 082093e5 ldr      r2, [r3, #8]
a037da34 4c3c02e3 movw     r3, #0x2c4c
a037da38 70314ae3 movt     r3, #0xa170
a037da3c 002083e5 str      r2, [r3]
a037da40 a43505e3 movw     r3, #0x55a4
a037da44 a3314ae3 movt     r3, #0xa1a3
a037da48 003093e5 ldr      r3, [r3]
a037da4c 003093e5 ldr      r3, [r3]
a037da50 000053e3 cmp      r3, #0
a037da54 0600000a beq      #0xa037da74
a037da58 a43505e3 movw     r3, #0x55a4
a037da5c a3314ae3 movt     r3, #0xa1a3
a037da60 003093e5 ldr      r3, [r3]
a037da64 003093e5 ldr      r3, [r3]
a037da68 c00c02e3 movw     r0, #0x2cc0
a037da6c 70014ae3 movt     r0, #0xa170
a037da70 33ff2fe1 blx      r3
a037da74 c03c02e3 movw     r3, #0x2cc0
a037da78 70314ae3 movt     r3, #0xa170
a037da7c 0030d3e5 ldrb     r3, [r3]
a037da80 000053e3 cmp      r3, #0
a037da84 5500000a beq      #0xa037dbe0
a037da88 583a07e3 movw     r3, #0x7a58
a037da8c 75304ae3 movt     r3, #0xa075
a037da90 003093e5 ldr      r3, [r3]
a037da94 0324a0e1 lsl      r2, r3, #8
a037da98 483b07e3 movw     r3, #0x7b48
a037da9c 75304ae3 movt     r3, #0xa075
a037daa0 b030d3e1 ldrh     r3, [r3]
a037daa4 930202e0 mul      r2, r3, r2
a037daa8 593701e3 movw     r3, #0x1759
a037daac b7314de3 movt     r3, #0xd1b7
a037dab0 922383e0 umull    r2, r3, r2, r3
a037dab4 a326a0e1 lsr      r2, r3, #0xd
a037dab8 543a07e3 movw     r3, #0x7a54
a037dabc 75304ae3 movt     r3, #0xa075
a037dac0 002083e5 str      r2, [r3]
a037dac4 c03c02e3 movw     r3, #0x2cc0
a037dac8 70314ae3 movt     r3, #0xa170
a037dacc 0030d3e5 ldrb     r3, [r3]
a037dad0 020053e3 cmp      r3, #2
a037dad4 4100000a beq      #0xa037dbe0
a037dad8 c03c02e3 movw     r3, #0x2cc0
a037dadc 70314ae3 movt     r3, #0xa170
a037dae0 be31d3e1 ldrh     r3, [r3, #0x1e]
a037dae4 0320a0e1 mov      r2, r3
a037dae8 c03c02e3 movw     r3, #0x2cc0
a037daec 70314ae3 movt     r3, #0xa170
a037daf0 b032d3e1 ldrh     r3, [r3, #0x20]
a037daf4 033082e0 add      r3, r2, r3
a037daf8 c330a0e1 asr      r3, r3, #1
a037dafc 04308de5 str      r3, [sp, #4]
a037db00 c03c02e3 movw     r3, #0x2cc0
a037db04 70314ae3 movt     r3, #0xa170
a037db08 1330d3e5 ldrb     r3, [r3, #0x13]
a037db0c 0320a0e1 mov      r2, r3
a037db10 0130a0e3 mov      r3, #1
a037db14 1332a0e1 lsl      r3, r3, r2
a037db18 00308de5 str      r3, [sp]
a037db1c 00309de5 ldr      r3, [sp]
a037db20 8333a0e1 lsl      r3, r3, #7
a037db24 903a07ee vmov     s15, r3
a037db28 670bf8ee vcvt.f64.u32 d16, s15
a037db2c 311bdfed vldr     d17, [pc, #0xc4]
a037db30 a11b60ee vmul.f64 d17, d16, d17
a037db34 04309de5 ldr      r3, [sp, #4]
a037db38 903a07ee vmov     s15, r3
a037db3c 670bf8ee vcvt.f64.u32 d16, s15
a037db40 a00bc1ee vdiv.f64 d16, d17, d16
a037db44 2d1bdfed vldr     d17, [pc, #0xb4]
a037db48 a10bc0ee vdiv.f64 d16, d16, d17
a037db4c 607bb0ee vmov.f64 d7, d16
a037db50 c77bfcee vcvt.u32.f64 s15, d7
a037db54 902a17ee vmov     r2, s15
a037db58 8c3c02e3 movw     r3, #0x2c8c
a037db5c 70314ae3 movt     r3, #0xa170
a037db60 1c2083e5 str      r2, [r3, #0x1c]
a037db64 8c3c02e3 movw     r3, #0x2c8c
a037db68 70314ae3 movt     r3, #0xa170
a037db6c 1c2093e5 ldr      r2, [r3, #0x1c]
a037db70 8c3c02e3 movw     r3, #0x2c8c
a037db74 70314ae3 movt     r3, #0xa170
a037db78 182083e5 str      r2, [r3, #0x18]
a037db7c 64090ee3 movw     r0, #0xe964
a037db80 5f004ae3 movt     r0, #0xa05f
a037db84 00109de5 ldr      r1, [sp]
a037db88 57a5fceb bl       #0xa02a70ec
a037db8c 543a07e3 movw     r3, #0x7a54
a037db90 75304ae3 movt     r3, #0xa075
a037db94 003093e5 ldr      r3, [r3]
a037db98 70090ee3 movw     r0, #0xe970
a037db9c 5f004ae3 movt     r0, #0xa05f
a037dba0 0310a0e1 mov      r1, r3
a037dba4 50a5fceb bl       #0xa02a70ec
a037dba8 8c3c02e3 movw     r3, #0x2c8c
a037dbac 70314ae3 movt     r3, #0xa170
a037dbb0 183093e5 ldr      r3, [r3, #0x18]
a037dbb4 80090ee3 movw     r0, #0xe980
a037dbb8 5f004ae3 movt     r0, #0xa05f
a037dbbc 0310a0e1 mov      r1, r3
a037dbc0 49a5fceb bl       #0xa02a70ec
a037dbc4 8c3c02e3 movw     r3, #0x2c8c
a037dbc8 70314ae3 movt     r3, #0xa170
a037dbcc 1c3093e5 ldr      r3, [r3, #0x1c]
a037dbd0 94090ee3 movw     r0, #0xe994
a037dbd4 5f004ae3 movt     r0, #0xa05f
a037dbd8 0310a0e1 mov      r1, r3
a037dbdc 42a5fceb bl       #0xa02a70ec
a037dbe0 a8090ee3 movw     r0, #0xe9a8
a037dbe4 5f004ae3 movt     r0, #0xa05f
a037dbe8 3fa5fceb bl       #0xa02a70ec
a037dbec 0cd08de2 add      sp, sp, #0xc
a037dbf0 04f09de4 pop      {pc}
a037dbf4 00f020e3 nop      
a037dbf8 182d4454 strbpl   r2, [r4], #-0xd18
a037dbfc fb210940 strdmi   r2, r3, [sb], -fp
a037dc00 00000000 andeq    r0, r0, r0
a037dc04 00806640 rsbmi    r8, r6, r0
