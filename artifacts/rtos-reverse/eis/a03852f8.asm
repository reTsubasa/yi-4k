; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a03852f8 04e02de5 str      lr, [sp, #-4]!
a03852fc 4cd04de2 sub      sp, sp, #0x4c
a0385300 1c008de5 str      r0, [sp, #0x1c]
a0385304 0030a0e3 mov      r3, #0
a0385308 44308de5 str      r3, [sp, #0x44]
a038530c bc3c02e3 movw     r3, #0x2cbc
a0385310 70314ae3 movt     r3, #0xa170
a0385314 0030d3e5 ldrb     r3, [r3]
a0385318 000053e3 cmp      r3, #0
a038531c 0000001a bne      #0xa0385324
a0385320 0b0100ea b        #0xa0385754
a0385324 ba3f0ae3 movw     r3, #0xafba
a0385328 70314ae3 movt     r3, #0xa170
a038532c 0030d3e5 ldrb     r3, [r3]
a0385330 000053e3 cmp      r3, #0
a0385334 0000001a bne      #0xa038533c
a0385338 050100ea b        #0xa0385754
a038533c b93f0ae3 movw     r3, #0xafb9
a0385340 70314ae3 movt     r3, #0xa170
a0385344 0030d3e5 ldrb     r3, [r3]
a0385348 000053e3 cmp      r3, #0
a038534c 0700001a bne      #0xa0385370
a0385350 f83a07e3 movw     r3, #0x7af8
a0385354 75304ae3 movt     r3, #0xa075
a0385358 b030d3e1 ldrh     r3, [r3]
a038535c 000053e3 cmp      r3, #0
a0385360 0200000a beq      #0xa0385370
a0385364 680d0fe3 movw     r0, #0xfd68
a0385368 5f004ae3 movt     r0, #0xa05f
a038536c 5e87fceb bl       #0xa02a70ec
a0385370 24308de2 add      r3, sp, #0x24
a0385374 0020a0e3 mov      r2, #0
a0385378 002083e5 str      r2, [r3]
a038537c 043083e2 add      r3, r3, #4
a0385380 0020a0e3 mov      r2, #0
a0385384 002083e5 str      r2, [r3]
a0385388 043083e2 add      r3, r3, #4
a038538c 0020a0e3 mov      r2, #0
a0385390 002083e5 str      r2, [r3]
a0385394 043083e2 add      r3, r3, #4
a0385398 0030a0e3 mov      r3, #0
a038539c 2630cde5 strb     r3, [sp, #0x26]
a03853a0 0030a0e3 mov      r3, #0
a03853a4 2430cde5 strb     r3, [sp, #0x24]
a03853a8 0030a0e3 mov      r3, #0
a03853ac 28308de5 str      r3, [sp, #0x28]
a03853b0 0130a0e3 mov      r3, #1
a03853b4 2530cde5 strb     r3, [sp, #0x25]
a03853b8 0e2404eb bl       #0xa048e3f8
a03853bc 40008de5 str      r0, [sp, #0x40]
a03853c0 043304e3 movw     r3, #0x4304
a03853c4 70314ae3 movt     r3, #0xa170
a03853c8 003093e5 ldr      r3, [r3]
a03853cc 40209de5 ldr      r2, [sp, #0x40]
a03853d0 023063e0 rsb      r3, r3, r2
a03853d4 3c308de5 str      r3, [sp, #0x3c]
a03853d8 d43504e3 movw     r3, #0x45d4
a03853dc 70314ae3 movt     r3, #0xa170
a03853e0 0030d3e5 ldrb     r3, [r3]
a03853e4 000053e3 cmp      r3, #0
a03853e8 5000000a beq      #0xa0385530
a03853ec 872404e3 movw     r2, #0x4487
a03853f0 e72a44e3 movt     r2, #0x4ae7
a03853f4 183705e3 movw     r3, #0x5718
a03853f8 b63f43e3 movt     r3, #0x3fb6
a03853fc f023cde1 strd     r2, r3, [sp, #0x30]
a0385400 a43a07e3 movw     r3, #0x7aa4
a0385404 75304ae3 movt     r3, #0xa075
a0385408 007ad3ed vldr     s15, [r3]
a038540c c07af5ee vcmpe.f32 s15, #0
a0385410 10faf1ee vmrs     apsr_nzcv, fpscr
a0385414 150000da ble      #0xa0385470
a0385418 a43a07e3 movw     r3, #0x7aa4
a038541c 75304ae3 movt     r3, #0xa075
a0385420 007ad3ed vldr     s15, [r3]
a0385424 a77a77ee vadd.f32 s15, s15, s15
a0385428 e70af7ee vcvt.f64.f32 d16, s15
a038542c cb1bdfed vldr     d17, [pc, #0x32c]
a0385430 a11b60ee vmul.f64 d17, d16, d17
a0385434 40309de5 ldr      r3, [sp, #0x40]
a0385438 903a07ee vmov     s15, r3
a038543c 670bf8ee vcvt.f64.u32 d16, s15
a0385440 a00b61ee vmul.f64 d16, d17, d16
a0385444 c71bdfed vldr     d17, [pc, #0x31c]
a0385448 a10bc0ee vdiv.f64 d16, d16, d17
a038544c 600bb0ee vmov.f64 d0, d16
a0385450 5cfa05fa blx      #0xa0503dc8
a0385454 401bf0ee vmov.f64 d17, d0
a0385458 0c0bdded vldr     d16, [sp, #0x30]
a038545c a00b61ee vmul.f64 d16, d17, d16
a0385460 48330be3 movw     r3, #0xb348
a0385464 70314ae3 movt     r3, #0xa170
a0385468 000bc3ed vstr     d16, [r3]
a038546c 110000ea b        #0xa03854b8
a0385470 a43a07e3 movw     r3, #0x7aa4
a0385474 75304ae3 movt     r3, #0xa075
a0385478 007ad3ed vldr     s15, [r3]
a038547c bd7a9fed vldr     s14, [pc, #0x2f4]
a0385480 477af4ee vcmp.f32 s15, s14
a0385484 10faf1ee vmrs     apsr_nzcv, fpscr
a0385488 0a00000a beq      #0xa03854b8
a038548c a43a07e3 movw     r3, #0x7aa4
a0385490 75304ae3 movt     r3, #0xa075
a0385494 007ad3ed vldr     s15, [r3]
a0385498 e70af7ee vcvt.f64.f32 d16, s15
a038549c af1bdfed vldr     d17, [pc, #0x2bc]
a03854a0 a10b60ee vmul.f64 d16, d16, d17
a03854a4 b11bdfed vldr     d17, [pc, #0x2c4]
a03854a8 a10bc0ee vdiv.f64 d16, d16, d17
a03854ac 48330be3 movw     r3, #0xb348
a03854b0 70314ae3 movt     r3, #0xa170
a03854b4 000bc3ed vstr     d16, [r3]
a03854b8 48330be3 movw     r3, #0xb348
a03854bc 70314ae3 movt     r3, #0xa170
a03854c0 001bd3ed vldr     d17, [r3]
a03854c4 50330be3 movw     r3, #0xb350
a03854c8 70314ae3 movt     r3, #0xa170
a03854cc 000bd3ed vldr     d16, [r3]
a03854d0 601bf4ee vcmp.f64 d17, d16
a03854d4 10faf1ee vmrs     apsr_nzcv, fpscr
a03854d8 0a00000a beq      #0xa0385508
a03854dc 48330be3 movw     r3, #0xb348
a03854e0 70314ae3 movt     r3, #0xa170
a03854e4 000bd3ed vldr     d16, [r3]
a03854e8 24308de2 add      r3, sp, #0x24
a03854ec 0300a0e1 mov      r0, r3
a03854f0 600bb0ee vmov.f64 d0, d16
a03854f4 a351fdeb bl       #0xa02d9b88
a03854f8 24308de2 add      r3, sp, #0x24
a03854fc 0300a0e1 mov      r0, r3
a0385500 0010a0e3 mov      r1, #0
a0385504 1653fdeb bl       #0xa02da164
a0385508 48330be3 movw     r3, #0xb348
a038550c 70314ae3 movt     r3, #0xa170
a0385510 d000c3e1 ldrd     r0, r1, [r3]
a0385514 50330be3 movw     r3, #0xb350
a0385518 70314ae3 movt     r3, #0xa170
a038551c f000c3e1 strd     r0, r1, [r3]
a0385520 24308de2 add      r3, sp, #0x24
a0385524 0300a0e1 mov      r0, r3
a0385528 f953fdeb bl       #0xa02da514
a038552c 100000ea b        #0xa0385574
a0385530 f83a07e3 movw     r3, #0x7af8
a0385534 75304ae3 movt     r3, #0xa075
a0385538 b631d3e1 ldrh     r3, [r3, #0x16]
a038553c 000053e3 cmp      r3, #0
a0385540 0b00001a bne      #0xa0385574
a0385544 f83a07e3 movw     r3, #0x7af8
a0385548 75304ae3 movt     r3, #0xa075
a038554c bc33d3e1 ldrh     r3, [r3, #0x3c]
a0385550 000053e3 cmp      r3, #0
a0385554 0600001a bne      #0xa0385574
a0385558 da3504e3 movw     r3, #0x45da
a038555c 70314ae3 movt     r3, #0xa170
a0385560 0030d3e5 ldrb     r3, [r3]
a0385564 000053e3 cmp      r3, #0
a0385568 0000000a beq      #0xa0385570
a038556c 8de6ffeb bl       #0xa037efa8
a0385570 ce3500eb bl       #0xa0392cb0
a0385574 9f2304eb bl       #0xa048e3f8
a0385578 0020a0e1 mov      r2, r0
a038557c 40309de5 ldr      r3, [sp, #0x40]
a0385580 023063e0 rsb      r3, r3, r2
a0385584 44308de5 str      r3, [sp, #0x44]
a0385588 ba3f0ae3 movw     r3, #0xafba
a038558c 70314ae3 movt     r3, #0xa170
a0385590 0030d3e5 ldrb     r3, [r3]
a0385594 000053e3 cmp      r3, #0
a0385598 1e00000a beq      #0xa0385618
a038559c da3504e3 movw     r3, #0x45da
a03855a0 70314ae3 movt     r3, #0xa170
a03855a4 0030d3e5 ldrb     r3, [r3]
a03855a8 000053e3 cmp      r3, #0
a03855ac 1900000a beq      #0xa0385618
a03855b0 b13a07e3 movw     r3, #0x7ab1
a03855b4 75304ae3 movt     r3, #0xa075
a03855b8 0030d3e5 ldrb     r3, [r3]
a03855bc 000053e3 cmp      r3, #0
a03855c0 1400000a beq      #0xa0385618
a03855c4 8b2304eb bl       #0xa048e3f8
a03855c8 0020a0e1 mov      r2, r0
a03855cc 5c3b0ae3 movw     r3, #0xab5c
a03855d0 70314ae3 movt     r3, #0xa170
a03855d4 003093e5 ldr      r3, [r3]
a03855d8 022063e0 rsb      r2, r3, r2
a03855dc b13a07e3 movw     r3, #0x7ab1
a03855e0 75304ae3 movt     r3, #0xa075
a03855e4 0030d3e5 ldrb     r3, [r3]
a03855e8 030052e1 cmp      r2, r3
a03855ec 0900003a blo      #0xa0385618
a03855f0 802304eb bl       #0xa048e3f8
a03855f4 0020a0e1 mov      r2, r0
a03855f8 b13a07e3 movw     r3, #0x7ab1
a03855fc 75304ae3 movt     r3, #0xa075
a0385600 0030d3e5 ldrb     r3, [r3]
a0385604 a40d0fe3 movw     r0, #0xfda4
a0385608 5f004ae3 movt     r0, #0xa05f
a038560c 0210a0e1 mov      r1, r2
a0385610 0320a0e1 mov      r2, r3
a0385614 b486fceb bl       #0xa02a70ec
a0385618 f83a07e3 movw     r3, #0x7af8
a038561c 75304ae3 movt     r3, #0xa075
a0385620 b230d3e1 ldrh     r3, [r3, #2]
a0385624 000053e3 cmp      r3, #0
a0385628 4900000a beq      #0xa0385754
a038562c da3504e3 movw     r3, #0x45da
a0385630 70314ae3 movt     r3, #0xa170
a0385634 0030d3e5 ldrb     r3, [r3]
a0385638 000053e3 cmp      r3, #0
a038563c 2200000a beq      #0xa03856cc
a0385640 283204e3 movw     r3, #0x4228
a0385644 70314ae3 movt     r3, #0xa170
a0385648 0030d3e5 ldrb     r3, [r3]
a038564c 73e0afe6 sxtb     lr, r3
a0385650 2b3204e3 movw     r3, #0x422b
a0385654 70314ae3 movt     r3, #0xa170
a0385658 0030d3e5 ldrb     r3, [r3]
a038565c 73c0afe6 sxtb     ip, r3
a0385660 003404e3 movw     r3, #0x4400
a0385664 70314ae3 movt     r3, #0xa170
a0385668 1c3093e5 ldr      r3, [r3, #0x1c]
a038566c 4318a0e1 asr      r1, r3, #0x10
a0385670 003404e3 movw     r3, #0x4400
a0385674 70314ae3 movt     r3, #0xa170
a0385678 203093e5 ldr      r3, [r3, #0x20]
a038567c 4328a0e1 asr      r2, r3, #0x10
a0385680 e03504e3 movw     r3, #0x45e0
a0385684 70314ae3 movt     r3, #0xa170
a0385688 000bd3ed vldr     d16, [r3]
a038568c 371bdfed vldr     d17, [pc, #0xdc]
a0385690 a10b60ee vmul.f64 d16, d16, d17
a0385694 311bdfed vldr     d17, [pc, #0xc4]
a0385698 a10bc0ee vdiv.f64 d16, d16, d17
a038569c 44309de5 ldr      r3, [sp, #0x44]
a03856a0 00308de5 str      r3, [sp]
a03856a4 04108de5 str      r1, [sp, #4]
a03856a8 08208de5 str      r2, [sp, #8]
a03856ac 040bcded vstr     d16, [sp, #0x10]
a03856b0 d80d0fe3 movw     r0, #0xfdd8
a03856b4 5f004ae3 movt     r0, #0xa05f
a03856b8 0e10a0e1 mov      r1, lr
a03856bc 3c209de5 ldr      r2, [sp, #0x3c]
a03856c0 0c30a0e1 mov      r3, ip
a03856c4 8886fceb bl       #0xa02a70ec
a03856c8 210000ea b        #0xa0385754
a03856cc 2b3204e3 movw     r3, #0x422b
a03856d0 70314ae3 movt     r3, #0xa170
a03856d4 0030d3e5 ldrb     r3, [r3]
a03856d8 73e0afe6 sxtb     lr, r3
a03856dc 283204e3 movw     r3, #0x4228
a03856e0 70314ae3 movt     r3, #0xa170
a03856e4 0030d3e5 ldrb     r3, [r3]
a03856e8 73c0afe6 sxtb     ip, r3
a03856ec 003404e3 movw     r3, #0x4400
a03856f0 70314ae3 movt     r3, #0xa170
a03856f4 1c3093e5 ldr      r3, [r3, #0x1c]
a03856f8 4318a0e1 asr      r1, r3, #0x10
a03856fc 003404e3 movw     r3, #0x4400
a0385700 70314ae3 movt     r3, #0xa170
a0385704 203093e5 ldr      r3, [r3, #0x20]
a0385708 4328a0e1 asr      r2, r3, #0x10
a038570c e03504e3 movw     r3, #0x45e0
a0385710 70314ae3 movt     r3, #0xa170
a0385714 000bd3ed vldr     d16, [r3]
a0385718 141bdfed vldr     d17, [pc, #0x50]
a038571c a10b60ee vmul.f64 d16, d16, d17
a0385720 0e1bdfed vldr     d17, [pc, #0x38]
a0385724 a10bc0ee vdiv.f64 d16, d16, d17
a0385728 44309de5 ldr      r3, [sp, #0x44]
a038572c 00308de5 str      r3, [sp]
a0385730 04108de5 str      r1, [sp, #4]
a0385734 08208de5 str      r2, [sp, #8]
a0385738 040bcded vstr     d16, [sp, #0x10]
a038573c 080e0fe3 movw     r0, #0xfe08
a0385740 5f004ae3 movt     r0, #0xa05f
a0385744 3c109de5 ldr      r1, [sp, #0x3c]
a0385748 0e20a0e1 mov      r2, lr
a038574c 0c30a0e1 mov      r3, ip
a0385750 6586fceb bl       #0xa02a70ec
a0385754 4cd08de2 add      sp, sp, #0x4c
a0385758 04f09de4 pop      {pc}
a038575c 00f020e3 nop      
a0385760 182d4454 strbpl   r2, [r4], #-0xd18
a0385764 fb210940 strdmi   r2, r3, [sb], -fp
a0385768 00000000 andeq    r0, r0, r0
a038576c 00408f40 addmi    r4, pc, r0
a0385770 00000000 andeq    r0, r0, r0
a0385774 00806640 rsbmi    r8, r6, r0
a0385778 cdccf6c2 rscsgt   ip, r6, #0xcd00
a038577c 00f020e3 nop      
a0385780 f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0385784 65df4de2 sub      sp, sp, #0x194
a0385788 512f8de2 add      r2, sp, #0x144
a038578c 0030a0e3 mov      r3, #0
a0385790 003082e5 str      r3, [r2]
a0385794 042082e2 add      r2, r2, #4
a0385798 0030a0e3 mov      r3, #0
a038579c 003082e5 str      r3, [r2]
a03857a0 042082e2 add      r2, r2, #4
a03857a4 0030a0e3 mov      r3, #0
a03857a8 003082e5 str      r3, [r2]
a03857ac 042082e2 add      r2, r2, #4
a03857b0 0030a0e3 mov      r3, #0
a03857b4 78318de5 str      r3, [sp, #0x178]
a03857b8 0030a0e3 mov      r3, #0
a03857bc 74318de5 str      r3, [sp, #0x174]
a03857c0 bc3c02e3 movw     r3, #0x2cbc
a03857c4 70314ae3 movt     r3, #0xa170
a03857c8 0030d3e5 ldrb     r3, [r3]
a03857cc 000053e3 cmp      r3, #0
a03857d0 0000001a bne      #0xa03857d8
a03857d4 142200ea b        #0xa038e02c
a03857d8 f83a07e3 movw     r3, #0x7af8
a03857dc 75304ae3 movt     r3, #0xa075
a03857e0 ba33d3e1 ldrh     r3, [r3, #0x3a]
a03857e4 000053e3 cmp      r3, #0
a03857e8 a200000a beq      #0xa0385a78
a03857ec f83a07e3 movw     r3, #0x7af8
a03857f0 75304ae3 movt     r3, #0xa075
a03857f4 ba33d3e1 ldrh     r3, [r3, #0x3a]
a03857f8 013003e2 and      r3, r3, #1
a03857fc 000053e3 cmp      r3, #0
a0385800 1000000a beq      #0xa0385848
a0385804 8c3c0de3 movw     r3, #0xdc8c
a0385808 62304ae3 movt     r3, #0xa062
a038580c 002093e5 ldr      r2, [r3]
a0385810 0130a0e3 mov      r3, #1
a0385814 583282e5 str      r3, [r2, #0x258]
a0385818 8c3c0de3 movw     r3, #0xdc8c
a038581c 62304ae3 movt     r3, #0xa062
a0385820 002093e5 ldr      r2, [r3]
a0385824 0030a0e3 mov      r3, #0
a0385828 583282e5 str      r3, [r2, #0x258]
a038582c 8c3c0de3 movw     r3, #0xdc8c
a0385830 62304ae3 movt     r3, #0xa062
a0385834 003093e5 ldr      r3, [r3]
a0385838 542293e5 ldr      r2, [r3, #0x254]
a038583c 58330be3 movw     r3, #0xb358
a0385840 70314ae3 movt     r3, #0xa170
a0385844 002083e5 str      r2, [r3]
a0385848 f83a07e3 movw     r3, #0x7af8
a038584c 75304ae3 movt     r3, #0xa075
a0385850 ba33d3e1 ldrh     r3, [r3, #0x3a]
a0385854 023003e2 and      r3, r3, #2
a0385858 000053e3 cmp      r3, #0
a038585c 1000000a beq      #0xa03858a4
a0385860 8c3c0de3 movw     r3, #0xdc8c
a0385864 62304ae3 movt     r3, #0xa062
a0385868 002093e5 ldr      r2, [r3]
a038586c 0130a0e3 mov      r3, #1
a0385870 583282e5 str      r3, [r2, #0x258]
a0385874 8c3c0de3 movw     r3, #0xdc8c
a0385878 62304ae3 movt     r3, #0xa062
a038587c 002093e5 ldr      r2, [r3]
a0385880 0030a0e3 mov      r3, #0
a0385884 583282e5 str      r3, [r2, #0x258]
a0385888 8c3c0de3 movw     r3, #0xdc8c
a038588c 62304ae3 movt     r3, #0xa062
a0385890 003093e5 ldr      r3, [r3]
a0385894 542293e5 ldr      r2, [r3, #0x254]
a0385898 58330be3 movw     r3, #0xb358
a038589c 70314ae3 movt     r3, #0xa170
a03858a0 002083e5 str      r2, [r3]
a03858a4 f83a07e3 movw     r3, #0x7af8
a03858a8 75304ae3 movt     r3, #0xa075
a03858ac ba33d3e1 ldrh     r3, [r3, #0x3a]
a03858b0 043003e2 and      r3, r3, #4
a03858b4 000053e3 cmp      r3, #0
a03858b8 2c00000a beq      #0xa0385970
a03858bc 8c3c0de3 movw     r3, #0xdc8c
a03858c0 62304ae3 movt     r3, #0xa062
a03858c4 003093e5 ldr      r3, [r3]
a03858c8 542293e5 ldr      r2, [r3, #0x254]
a03858cc 58330be3 movw     r3, #0xb358
a03858d0 70314ae3 movt     r3, #0xa170
a03858d4 002083e5 str      r2, [r3]
a03858d8 8c3c0de3 movw     r3, #0xdc8c
a03858dc 62304ae3 movt     r3, #0xa062
a03858e0 002093e5 ldr      r2, [r3]
a03858e4 0130a0e3 mov      r3, #1
a03858e8 583282e5 str      r3, [r2, #0x258]
a03858ec 8c3c0de3 movw     r3, #0xdc8c
a03858f0 62304ae3 movt     r3, #0xa062
a03858f4 002093e5 ldr      r2, [r3]
a03858f8 0030a0e3 mov      r3, #0
a03858fc 583282e5 str      r3, [r2, #0x258]
a0385900 8c3c0de3 movw     r3, #0xdc8c
a0385904 62304ae3 movt     r3, #0xa062
a0385908 003093e5 ldr      r3, [r3]
a038590c 542293e5 ldr      r2, [r3, #0x254]
a0385910 5c330be3 movw     r3, #0xb35c
a0385914 70314ae3 movt     r3, #0xa170
a0385918 002083e5 str      r2, [r3]
a038591c 58330be3 movw     r3, #0xb358
a0385920 70314ae3 movt     r3, #0xa170
a0385924 002093e5 ldr      r2, [r3]
a0385928 5c330be3 movw     r3, #0xb35c
a038592c 70314ae3 movt     r3, #0xa170
a0385930 003093e5 ldr      r3, [r3]
a0385934 021063e0 rsb      r1, r3, r2
a0385938 58330be3 movw     r3, #0xb358
a038593c 70314ae3 movt     r3, #0xa170
a0385940 002093e5 ldr      r2, [r3]
a0385944 5c330be3 movw     r3, #0xb35c
a0385948 70314ae3 movt     r3, #0xa170
a038594c 00c093e5 ldr      ip, [r3]
a0385950 2c3204e3 movw     r3, #0x422c
a0385954 70314ae3 movt     r3, #0xa170
a0385958 003093e5 ldr      r3, [r3]
a038595c 00308de5 str      r3, [sp]
a0385960 380e0fe3 movw     r0, #0xfe38
a0385964 5f004ae3 movt     r0, #0xa05f
a0385968 0c30a0e1 mov      r3, ip
a038596c de85fceb bl       #0xa02a70ec
a0385970 f83a07e3 movw     r3, #0x7af8
a0385974 75304ae3 movt     r3, #0xa075
a0385978 ba33d3e1 ldrh     r3, [r3, #0x3a]
a038597c 083003e2 and      r3, r3, #8
a0385980 000053e3 cmp      r3, #0
a0385984 3b00000a beq      #0xa0385a78
a0385988 8c3c0de3 movw     r3, #0xdc8c
a038598c 62304ae3 movt     r3, #0xa062
a0385990 003093e5 ldr      r3, [r3]
a0385994 542293e5 ldr      r2, [r3, #0x254]
a0385998 58330be3 movw     r3, #0xb358
a038599c 70314ae3 movt     r3, #0xa170
a03859a0 002083e5 str      r2, [r3]
a03859a4 8c3c0de3 movw     r3, #0xdc8c
a03859a8 62304ae3 movt     r3, #0xa062
a03859ac 002093e5 ldr      r2, [r3]
a03859b0 0130a0e3 mov      r3, #1
a03859b4 583282e5 str      r3, [r2, #0x258]
a03859b8 8c3c0de3 movw     r3, #0xdc8c
a03859bc 62304ae3 movt     r3, #0xa062
a03859c0 002093e5 ldr      r2, [r3]
a03859c4 0030a0e3 mov      r3, #0
a03859c8 583282e5 str      r3, [r2, #0x258]
a03859cc 8c3c0de3 movw     r3, #0xdc8c
a03859d0 62304ae3 movt     r3, #0xa062
a03859d4 003093e5 ldr      r3, [r3]
a03859d8 542293e5 ldr      r2, [r3, #0x254]
a03859dc 5c330be3 movw     r3, #0xb35c
a03859e0 70314ae3 movt     r3, #0xa170
a03859e4 002083e5 str      r2, [r3]
a03859e8 58330be3 movw     r3, #0xb358
a03859ec 70314ae3 movt     r3, #0xa170
a03859f0 002093e5 ldr      r2, [r3]
a03859f4 5c330be3 movw     r3, #0xb35c
a03859f8 70314ae3 movt     r3, #0xa170
a03859fc 003093e5 ldr      r3, [r3]
a0385a00 022063e0 rsb      r2, r3, r2
a0385a04 9f3c08e3 movw     r3, #0x8c9f
a0385a08 030052e1 cmp      r2, r3
a0385a0c 1900009a bls      #0xa0385a78
a0385a10 7c3003e3 movw     r3, #0x307c
a0385a14 6f304ae3 movt     r3, #0xa06f
a0385a18 041093e5 ldr      r1, [r3, #4]
a0385a1c 58330be3 movw     r3, #0xb358
a0385a20 70314ae3 movt     r3, #0xa170
a0385a24 002093e5 ldr      r2, [r3]
a0385a28 5c330be3 movw     r3, #0xb35c
a0385a2c 70314ae3 movt     r3, #0xa170
a0385a30 003093e5 ldr      r3, [r3]
a0385a34 02e063e0 rsb      lr, r3, r2
a0385a38 58330be3 movw     r3, #0xb358
a0385a3c 70314ae3 movt     r3, #0xa170
a0385a40 00c093e5 ldr      ip, [r3]
a0385a44 5c330be3 movw     r3, #0xb35c
a0385a48 70314ae3 movt     r3, #0xa170
a0385a4c 002093e5 ldr      r2, [r3]
a0385a50 2c3204e3 movw     r3, #0x422c
a0385a54 70314ae3 movt     r3, #0xa170
a0385a58 003093e5 ldr      r3, [r3]
a0385a5c 00208de5 str      r2, [sp]
a0385a60 04308de5 str      r3, [sp, #4]
a0385a64 740e0fe3 movw     r0, #0xfe74
a0385a68 5f004ae3 movt     r0, #0xa05f
a0385a6c 0e20a0e1 mov      r2, lr
a0385a70 0c30a0e1 mov      r3, ip
a0385a74 9c85fceb bl       #0xa02a70ec
a0385a78 0030a0e3 mov      r3, #0
a0385a7c 4631cde5 strb     r3, [sp, #0x146]
a0385a80 0030a0e3 mov      r3, #0
a0385a84 4431cde5 strb     r3, [sp, #0x144]
a0385a88 0030a0e3 mov      r3, #0
a0385a8c 48318de5 str      r3, [sp, #0x148]
a0385a90 0130a0e3 mov      r3, #1
a0385a94 4531cde5 strb     r3, [sp, #0x145]
a0385a98 562204eb bl       #0xa048e3f8
a0385a9c 0020a0e1 mov      r2, r0
a0385aa0 403c02e3 movw     r3, #0x2c40
a0385aa4 70314ae3 movt     r3, #0xa170
a0385aa8 002083e5 str      r2, [r3]
a0385aac 443c02e3 movw     r3, #0x2c44
a0385ab0 70314ae3 movt     r3, #0xa170
a0385ab4 0030d3e5 ldrb     r3, [r3]
a0385ab8 000053e3 cmp      r3, #0
a0385abc 2b00001a bne      #0xa0385b70
a0385ac0 403c02e3 movw     r3, #0x2c40
a0385ac4 70314ae3 movt     r3, #0xa170
a0385ac8 002093e5 ldr      r2, [r3]
a0385acc 483c02e3 movw     r3, #0x2c48
a0385ad0 70314ae3 movt     r3, #0xa170
a0385ad4 003093e5 ldr      r3, [r3]
a0385ad8 022063e0 rsb      r2, r3, r2
a0385adc c03c02e3 movw     r3, #0x2cc0
a0385ae0 70314ae3 movt     r3, #0xa170
a0385ae4 b232d3e1 ldrh     r3, [r3, #0x22]
a0385ae8 030052e1 cmp      r2, r3
a0385aec 1800003a blo      #0xa0385b54
a0385af0 a43505e3 movw     r3, #0x55a4
a0385af4 a3314ae3 movt     r3, #0xa1a3
a0385af8 003093e5 ldr      r3, [r3]
a0385afc 043093e5 ldr      r3, [r3, #4]
a0385b00 000053e3 cmp      r3, #0
a0385b04 0700000a beq      #0xa0385b28
a0385b08 a43505e3 movw     r3, #0x55a4
a0385b0c a3314ae3 movt     r3, #0xa1a3
a0385b10 003093e5 ldr      r3, [r3]
a0385b14 043093e5 ldr      r3, [r3, #4]
a0385b18 33ff2fe1 blx      r3
a0385b1c 0030a0e1 mov      r3, r0
a0385b20 010073e3 cmn      r3, #1
a0385b24 0500001a bne      #0xa0385b40
a0385b28 443004e3 movw     r3, #0x4044
a0385b2c 70314ae3 movt     r3, #0xa170
a0385b30 0120a0e3 mov      r2, #1
a0385b34 0820c3e5 strb     r2, [r3, #8]
a0385b38 18f4ffeb bl       #0xa0382ba0
a0385b3c 0a0000ea b        #0xa0385b6c
a0385b40 443c02e3 movw     r3, #0x2c44
a0385b44 70314ae3 movt     r3, #0xa170
a0385b48 0120a0e3 mov      r2, #1
a0385b4c 0020c3e5 strb     r2, [r3]
a0385b50 050000ea b        #0xa0385b6c
a0385b54 c03c02e3 movw     r3, #0x2cc0
a0385b58 70314ae3 movt     r3, #0xa170
a0385b5c b232d3e1 ldrh     r3, [r3, #0x22]
a0385b60 0300a0e1 mov      r0, r3
a0385b64 edd900eb bl       #0xa03bc320
a0385b68 2e2100ea b        #0xa038e028
a0385b6c 2d2100ea b        #0xa038e028
a0385b70 383b0ae3 movw     r3, #0xab38
a0385b74 70314ae3 movt     r3, #0xa170
a0385b78 002093e5 ldr      r2, [r3]
a0385b7c 3c3b0ae3 movw     r3, #0xab3c
a0385b80 70314ae3 movt     r3, #0xa170
a0385b84 002083e5 str      r2, [r3]
a0385b88 003d02e3 movw     r3, #0x2d00
a0385b8c 70314ae3 movt     r3, #0xa170
a0385b90 142293e5 ldr      r2, [r3, #0x214]
a0385b94 383b0ae3 movw     r3, #0xab38
a0385b98 70314ae3 movt     r3, #0xa170
a0385b9c 002083e5 str      r2, [r3]
a0385ba0 383b0ae3 movw     r3, #0xab38
a0385ba4 70314ae3 movt     r3, #0xa170
a0385ba8 002093e5 ldr      r2, [r3]
a0385bac 803b0ae3 movw     r3, #0xab80
a0385bb0 70314ae3 movt     r3, #0xa170
a0385bb4 002083e5 str      r2, [r3]
a0385bb8 f83a07e3 movw     r3, #0x7af8
a0385bbc 75304ae3 movt     r3, #0xa075
a0385bc0 ba32d3e1 ldrh     r3, [r3, #0x2a]
a0385bc4 000053e3 cmp      r3, #0
a0385bc8 0d00001a bne      #0xa0385c04
a0385bcc a43505e3 movw     r3, #0x55a4
a0385bd0 a3314ae3 movt     r3, #0xa1a3
a0385bd4 003093e5 ldr      r3, [r3]
a0385bd8 083093e5 ldr      r3, [r3, #8]
a0385bdc 000053e3 cmp      r3, #0
a0385be0 0700000a beq      #0xa0385c04
a0385be4 a43505e3 movw     r3, #0x55a4
a0385be8 a3314ae3 movt     r3, #0xa1a3
a0385bec 003093e5 ldr      r3, [r3]
a0385bf0 083093e5 ldr      r3, [r3, #8]
a0385bf4 0100a0e3 mov      r0, #1
a0385bf8 301c02e3 movw     r1, #0x2c30
a0385bfc 70114ae3 movt     r1, #0xa170
a0385c00 33ff2fe1 blx      r3
a0385c04 383b0ae3 movw     r3, #0xab38
a0385c08 70314ae3 movt     r3, #0xa170
a0385c0c 001093e5 ldr      r1, [r3]
a0385c10 303c02e3 movw     r3, #0x2c30
a0385c14 70314ae3 movt     r3, #0xa170
a0385c18 b030d3e1 ldrh     r3, [r3]
a0385c1c 0320a0e1 mov      r2, r3
a0385c20 003d02e3 movw     r3, #0x2d00
a0385c24 70314ae3 movt     r3, #0xa170
a0385c28 012183e7 str      r2, [r3, r1, lsl #2]
a0385c2c 383b0ae3 movw     r3, #0xab38
a0385c30 70314ae3 movt     r3, #0xa170
a0385c34 001093e5 ldr      r1, [r3]
a0385c38 303c02e3 movw     r3, #0x2c30
a0385c3c 70314ae3 movt     r3, #0xa170
a0385c40 b230d3e1 ldrh     r3, [r3, #2]
a0385c44 0300a0e1 mov      r0, r3
a0385c48 002d02e3 movw     r2, #0x2d00
a0385c4c 70214ae3 movt     r2, #0xa170
a0385c50 893081e2 add      r3, r1, #0x89
a0385c54 030182e7 str      r0, [r2, r3, lsl #2]
a0385c58 c03c02e3 movw     r3, #0x2cc0
a0385c5c 70314ae3 movt     r3, #0xa170
a0385c60 1130d3e5 ldrb     r3, [r3, #0x11]
a0385c64 010053e3 cmp      r3, #1
a0385c68 0400000a beq      #0xa0385c80
a0385c6c c03c02e3 movw     r3, #0x2cc0
a0385c70 70314ae3 movt     r3, #0xa170
a0385c74 1130d3e5 ldrb     r3, [r3, #0x11]
a0385c78 020053e3 cmp      r3, #2
a0385c7c 0b00001a bne      #0xa0385cb0
a0385c80 383b0ae3 movw     r3, #0xab38
a0385c84 70314ae3 movt     r3, #0xa170
a0385c88 001093e5 ldr      r1, [r3]
a0385c8c 303c02e3 movw     r3, #0x2c30
a0385c90 70314ae3 movt     r3, #0xa170
a0385c94 b430d3e1 ldrh     r3, [r3, #4]
a0385c98 0300a0e1 mov      r0, r3
a0385c9c 002d02e3 movw     r2, #0x2d00
a0385ca0 70214ae3 movt     r2, #0xa170
a0385ca4 113e81e2 add      r3, r1, #0x110
a0385ca8 023083e2 add      r3, r3, #2
a0385cac 030182e7 str      r0, [r2, r3, lsl #2]
a0385cb0 f83a07e3 movw     r3, #0x7af8
a0385cb4 75304ae3 movt     r3, #0xa075
a0385cb8 b832d3e1 ldrh     r3, [r3, #0x28]
a0385cbc 000053e3 cmp      r3, #0
a0385cc0 6f00000a beq      #0xa0385e84
a0385cc4 f83a07e3 movw     r3, #0x7af8
a0385cc8 75304ae3 movt     r3, #0xa075
a0385ccc bc32d3e1 ldrh     r3, [r3, #0x2c]
a0385cd0 000053e3 cmp      r3, #0
a0385cd4 0b00000a beq      #0xa0385d08
a0385cd8 603b0ae3 movw     r3, #0xab60
a0385cdc 70314ae3 movt     r3, #0xa170
a0385ce0 002093e5 ldr      r2, [r3]
a0385ce4 f83a07e3 movw     r3, #0x7af8
a0385ce8 75304ae3 movt     r3, #0xa075
a0385cec bc32d3e1 ldrh     r3, [r3, #0x2c]
a0385cf0 0200a0e1 mov      r0, r2
a0385cf4 0310a0e1 mov      r1, r3
a0385cf8 5d0206fa blx      #0xa0506674
a0385cfc 0130a0e1 mov      r3, r1
a0385d00 000053e3 cmp      r3, #0
a0385d04 5e00001a bne      #0xa0385e84
a0385d08 f83a07e3 movw     r3, #0x7af8
a0385d0c 75304ae3 movt     r3, #0xa075
a0385d10 b832d3e1 ldrh     r3, [r3, #0x28]
a0385d14 013003e2 and      r3, r3, #1
a0385d18 000053e3 cmp      r3, #0
a0385d1c 1300000a beq      #0xa0385d70
a0385d20 303c02e3 movw     r3, #0x2c30
a0385d24 70314ae3 movt     r3, #0xa170
a0385d28 b030d3e1 ldrh     r3, [r3]
a0385d2c 0310a0e1 mov      r1, r3
a0385d30 303c02e3 movw     r3, #0x2c30
a0385d34 70314ae3 movt     r3, #0xa170
a0385d38 b230d3e1 ldrh     r3, [r3, #2]
a0385d3c 0320a0e1 mov      r2, r3
a0385d40 303c02e3 movw     r3, #0x2c30
a0385d44 70314ae3 movt     r3, #0xa170
a0385d48 b430d3e1 ldrh     r3, [r3, #4]
a0385d4c 03c0a0e1 mov      ip, r3
a0385d50 303c02e3 movw     r3, #0x2c30
a0385d54 70314ae3 movt     r3, #0xa170
a0385d58 b630d3e1 ldrh     r3, [r3, #6]
a0385d5c 00308de5 str      r3, [sp]
a0385d60 b40e0fe3 movw     r0, #0xfeb4
a0385d64 5f004ae3 movt     r0, #0xa05f
a0385d68 0c30a0e1 mov      r3, ip
a0385d6c de84fceb bl       #0xa02a70ec
a0385d70 f83a07e3 movw     r3, #0x7af8
a0385d74 75304ae3 movt     r3, #0xa075
a0385d78 b832d3e1 ldrh     r3, [r3, #0x28]
a0385d7c 023003e2 and      r3, r3, #2
a0385d80 000053e3 cmp      r3, #0
a0385d84 1a00000a beq      #0xa0385df4
a0385d88 383b0ae3 movw     r3, #0xab38
a0385d8c 70314ae3 movt     r3, #0xa170
a0385d90 002093e5 ldr      r2, [r3]
a0385d94 003d02e3 movw     r3, #0x2d00
a0385d98 70314ae3 movt     r3, #0xa170
a0385d9c 023193e7 ldr      r3, [r3, r2, lsl #2]
a0385da0 0310a0e1 mov      r1, r3
a0385da4 383b0ae3 movw     r3, #0xab38
a0385da8 70314ae3 movt     r3, #0xa170
a0385dac 003093e5 ldr      r3, [r3]
a0385db0 002d02e3 movw     r2, #0x2d00
a0385db4 70214ae3 movt     r2, #0xa170
a0385db8 893083e2 add      r3, r3, #0x89
a0385dbc 033192e7 ldr      r3, [r2, r3, lsl #2]
a0385dc0 03c0a0e1 mov      ip, r3
a0385dc4 383b0ae3 movw     r3, #0xab38
a0385dc8 70314ae3 movt     r3, #0xa170
a0385dcc 003093e5 ldr      r3, [r3]
a0385dd0 002d02e3 movw     r2, #0x2d00
a0385dd4 70214ae3 movt     r2, #0xa170
a0385dd8 113e83e2 add      r3, r3, #0x110
a0385ddc 023083e2 add      r3, r3, #2
a0385de0 033192e7 ldr      r3, [r2, r3, lsl #2]
a0385de4 d40e0fe3 movw     r0, #0xfed4
a0385de8 5f004ae3 movt     r0, #0xa05f
a0385dec 0c20a0e1 mov      r2, ip
a0385df0 bd84fceb bl       #0xa02a70ec
a0385df4 f83a07e3 movw     r3, #0x7af8
a0385df8 75304ae3 movt     r3, #0xa075
a0385dfc b832d3e1 ldrh     r3, [r3, #0x28]
a0385e00 043003e2 and      r3, r3, #4
a0385e04 000053e3 cmp      r3, #0
a0385e08 1d00000a beq      #0xa0385e84
a0385e0c 383b0ae3 movw     r3, #0xab38
a0385e10 70314ae3 movt     r3, #0xa170
a0385e14 003093e5 ldr      r3, [r3]
a0385e18 002d02e3 movw     r2, #0x2d00
a0385e1c 70214ae3 movt     r2, #0xa170
a0385e20 663f83e2 add      r3, r3, #0x198
a0385e24 033083e2 add      r3, r3, #3
a0385e28 033192e7 ldr      r3, [r2, r3, lsl #2]
a0385e2c 2314a0e1 lsr      r1, r3, #8
a0385e30 383b0ae3 movw     r3, #0xab38
a0385e34 70314ae3 movt     r3, #0xa170
a0385e38 003093e5 ldr      r3, [r3]
a0385e3c 002d02e3 movw     r2, #0x2d00
a0385e40 70214ae3 movt     r2, #0xa170
a0385e44 893f83e2 add      r3, r3, #0x224
a0385e48 033192e7 ldr      r3, [r2, r3, lsl #2]
a0385e4c 23c4a0e1 lsr      ip, r3, #8
a0385e50 383b0ae3 movw     r3, #0xab38
a0385e54 70314ae3 movt     r3, #0xa170
a0385e58 003093e5 ldr      r3, [r3]
a0385e5c 002d02e3 movw     r2, #0x2d00
a0385e60 70214ae3 movt     r2, #0xa170
a0385e64 ab3f83e2 add      r3, r3, #0x2ac
a0385e68 013083e2 add      r3, r3, #1
a0385e6c 033192e7 ldr      r3, [r2, r3, lsl #2]
a0385e70 2334a0e1 lsr      r3, r3, #8
a0385e74 ec0e0fe3 movw     r0, #0xfeec
a0385e78 5f004ae3 movt     r0, #0xa05f
a0385e7c 0c20a0e1 mov      r2, ip
a0385e80 9984fceb bl       #0xa02a70ec
a0385e84 403c02e3 movw     r3, #0x2c40
a0385e88 70314ae3 movt     r3, #0xa170
a0385e8c 002093e5 ldr      r2, [r3]
a0385e90 603b0ae3 movw     r3, #0xab60
a0385e94 70314ae3 movt     r3, #0xa170
a0385e98 002083e5 str      r2, [r3]
a0385e9c fc3204e3 movw     r3, #0x42fc
a0385ea0 70314ae3 movt     r3, #0xa170
a0385ea4 002093e5 ldr      r2, [r3]
a0385ea8 043304e3 movw     r3, #0x4304
a0385eac 70314ae3 movt     r3, #0xa170
a0385eb0 003093e5 ldr      r3, [r3]
a0385eb4 021063e0 rsb      r1, r3, r2
a0385eb8 503c02e3 movw     r3, #0x2c50
a0385ebc 70314ae3 movt     r3, #0xa170
a0385ec0 0030d3e5 ldrb     r3, [r3]
a0385ec4 0320a0e1 mov      r2, r3
a0385ec8 0230a0e1 mov      r3, r2
a0385ecc 8330a0e1 lsl      r3, r3, #1
a0385ed0 022083e0 add      r2, r3, r2
a0385ed4 a23fa0e1 lsr      r3, r2, #0x1f
a0385ed8 023083e0 add      r3, r3, r2
a0385edc c330a0e1 asr      r3, r3, #1
a0385ee0 030051e1 cmp      r1, r3
a0385ee4 1000009a bls      #0xa0385f2c
a0385ee8 f83a07e3 movw     r3, #0x7af8
a0385eec 75304ae3 movt     r3, #0xa075
a0385ef0 b031d3e1 ldrh     r3, [r3, #0x10]
a0385ef4 000053e3 cmp      r3, #0
a0385ef8 0b00000a beq      #0xa0385f2c
a0385efc 7c3003e3 movw     r3, #0x307c
a0385f00 6f304ae3 movt     r3, #0xa06f
a0385f04 081093e5 ldr      r1, [r3, #8]
a0385f08 fc3204e3 movw     r3, #0x42fc
a0385f0c 70314ae3 movt     r3, #0xa170
a0385f10 002093e5 ldr      r2, [r3]
a0385f14 043304e3 movw     r3, #0x4304
a0385f18 70314ae3 movt     r3, #0xa170
a0385f1c 003093e5 ldr      r3, [r3]
a0385f20 040f0fe3 movw     r0, #0xff04
a0385f24 5f004ae3 movt     r0, #0xa05f
a0385f28 6f84fceb bl       #0xa02a70ec
a0385f2c fc3204e3 movw     r3, #0x42fc
a0385f30 70314ae3 movt     r3, #0xa170
a0385f34 002093e5 ldr      r2, [r3]
a0385f38 043304e3 movw     r3, #0x4304
a0385f3c 70314ae3 movt     r3, #0xa170
a0385f40 002083e5 str      r2, [r3]
a0385f44 003304e3 movw     r3, #0x4300
a0385f48 70314ae3 movt     r3, #0xa170
a0385f4c 002093e5 ldr      r2, [r3]
a0385f50 083304e3 movw     r3, #0x4308
a0385f54 70314ae3 movt     r3, #0xa170
a0385f58 003093e5 ldr      r3, [r3]
a0385f5c 021063e0 rsb      r1, r3, r2
a0385f60 503c02e3 movw     r3, #0x2c50
a0385f64 70314ae3 movt     r3, #0xa170
a0385f68 0030d3e5 ldrb     r3, [r3]
a0385f6c 0320a0e1 mov      r2, r3
a0385f70 0230a0e1 mov      r3, r2
a0385f74 8330a0e1 lsl      r3, r3, #1
a0385f78 022083e0 add      r2, r3, r2
a0385f7c a23fa0e1 lsr      r3, r2, #0x1f
a0385f80 023083e0 add      r3, r3, r2
a0385f84 c330a0e1 asr      r3, r3, #1
a0385f88 030051e1 cmp      r1, r3
a0385f8c 1000009a bls      #0xa0385fd4
a0385f90 f83a07e3 movw     r3, #0x7af8
a0385f94 75304ae3 movt     r3, #0xa075
a0385f98 b031d3e1 ldrh     r3, [r3, #0x10]
a0385f9c 000053e3 cmp      r3, #0
a0385fa0 0b00000a beq      #0xa0385fd4
a0385fa4 7c3003e3 movw     r3, #0x307c
a0385fa8 6f304ae3 movt     r3, #0xa06f
a0385fac 041093e5 ldr      r1, [r3, #4]
a0385fb0 003304e3 movw     r3, #0x4300
a0385fb4 70314ae3 movt     r3, #0xa170
a0385fb8 002093e5 ldr      r2, [r3]
a0385fbc 083304e3 movw     r3, #0x4308
a0385fc0 70314ae3 movt     r3, #0xa170
a0385fc4 003093e5 ldr      r3, [r3]
a0385fc8 1c0f0fe3 movw     r0, #0xff1c
a0385fcc 5f004ae3 movt     r0, #0xa05f
a0385fd0 4584fceb bl       #0xa02a70ec
a0385fd4 003304e3 movw     r3, #0x4300
a0385fd8 70314ae3 movt     r3, #0xa170
a0385fdc 002093e5 ldr      r2, [r3]
a0385fe0 083304e3 movw     r3, #0x4308
a0385fe4 70314ae3 movt     r3, #0xa170
a0385fe8 002083e5 str      r2, [r3]
a0385fec 143b0ae3 movw     r3, #0xab14
a0385ff0 70314ae3 movt     r3, #0xa170
a0385ff4 0030d3e5 ldrb     r3, [r3]
a0385ff8 000053e3 cmp      r3, #0
a0385ffc 3f00000a beq      #0xa0386100
a0386000 b23a07e3 movw     r3, #0x7ab2
a0386004 75304ae3 movt     r3, #0xa075
a0386008 b030d3e1 ldrh     r3, [r3]
a038600c 0320a0e1 mov      r2, r3
a0386010 603b0ae3 movw     r3, #0xab60
a0386014 70314ae3 movt     r3, #0xa170
a0386018 003093e5 ldr      r3, [r3]
a038601c 030052e1 cmp      r2, r3
a0386020 3600008a bhi      #0xa0386100
a0386024 5c3b0ae3 movw     r3, #0xab5c
a0386028 70314ae3 movt     r3, #0xa170
a038602c 002093e5 ldr      r2, [r3]
a0386030 043304e3 movw     r3, #0x4304
a0386034 70314ae3 movt     r3, #0xa170
a0386038 003093e5 ldr      r3, [r3]
a038603c 030052e1 cmp      r2, r3
a0386040 2e00000a beq      #0xa0386100
a0386044 423f8de2 add      r3, sp, #0x108
a0386048 510a00e3 movw     r0, #0xa51
a038604c 0010a0e3 mov      r1, #0
a0386050 0020a0e3 mov      r2, #0
a0386054 21ab00eb bl       #0xa03b0ce0
a0386058 b43a07e3 movw     r3, #0x7ab4
a038605c 75304ae3 movt     r3, #0xa075
a0386060 007a93ed vldr     s14, [r3]
a0386064 60330be3 movw     r3, #0xb360
a0386068 70314ae3 movt     r3, #0xa170
a038606c 007ad3ed vldr     s15, [r3]
a0386070 677ab4ee vcmp.f32 s14, s15
a0386074 10faf1ee vmrs     apsr_nzcv, fpscr
a0386078 2000000a beq      #0xa0386100
a038607c b43a07e3 movw     r3, #0x7ab4
a0386080 75304ae3 movt     r3, #0xa075
a0386084 002093e5 ldr      r2, [r3]
a0386088 60330be3 movw     r3, #0xb360
a038608c 70314ae3 movt     r3, #0xa170
a0386090 002083e5 str      r2, [r3]
a0386094 4f3f8de2 add      r3, sp, #0x13c
a0386098 0000a0e3 mov      r0, #0
a038609c 0310a0e1 mov      r1, r3
a03860a0 929200eb bl       #0xa03aaaf0
a03860a4 0030a0e3 mov      r3, #0
a03860a8 3c31cde5 strb     r3, [sp, #0x13c]
a03860ac 4f3f8de2 add      r3, sp, #0x13c
a03860b0 0000a0e3 mov      r0, #0
a03860b4 0310a0e1 mov      r1, r3
a03860b8 d99400eb bl       #0xa03ab424
a03860bc 487a9ded vldr     s14, [sp, #0x120]
a03860c0 b43a07e3 movw     r3, #0x7ab4
a03860c4 75304ae3 movt     r3, #0xa075
a03860c8 007ad3ed vldr     s15, [r3]
a03860cc 277a87ee vdiv.f32 s14, s14, s15
a03860d0 497added vldr     s15, [sp, #0x124]
a03860d4 277a67ee vmul.f32 s15, s14, s15
a03860d8 497acded vstr     s15, [sp, #0x124]
a03860dc b43a07e3 movw     r3, #0x7ab4
a03860e0 75304ae3 movt     r3, #0xa075
a03860e4 003093e5 ldr      r3, [r3]
a03860e8 20318de5 str      r3, [sp, #0x120]
a03860ec 423f8de2 add      r3, sp, #0x108
a03860f0 a50ea0e3 mov      r0, #0xa50
a03860f4 0010a0e3 mov      r1, #0
a03860f8 0020a0e3 mov      r2, #0
a03860fc f7aa00eb bl       #0xa03b0ce0
a0386100 003d02e3 movw     r3, #0x2d00
a0386104 70314ae3 movt     r3, #0xa170
a0386108 143293e5 ldr      r3, [r3, #0x214]
a038610c 012083e2 add      r2, r3, #1
a0386110 003d02e3 movw     r3, #0x2d00
a0386114 70314ae3 movt     r3, #0xa170
a0386118 142283e5 str      r2, [r3, #0x214]
a038611c 003d02e3 movw     r3, #0x2d00
a0386120 70314ae3 movt     r3, #0xa170
a0386124 142293e5 ldr      r2, [r3, #0x214]
a0386128 003d02e3 movw     r3, #0x2d00
a038612c 70314ae3 movt     r3, #0xa170
a0386130 103293e5 ldr      r3, [r3, #0x210]
a0386134 030052e1 cmp      r2, r3
a0386138 0300001a bne      #0xa038614c
a038613c 002d02e3 movw     r2, #0x2d00
a0386140 70214ae3 movt     r2, #0xa170
a0386144 0030a0e3 mov      r3, #0
a0386148 143282e5 str      r3, [r2, #0x214]
a038614c 383b0ae3 movw     r3, #0xab38
a0386150 70314ae3 movt     r3, #0xa170
a0386154 001093e5 ldr      r1, [r3]
a0386158 383b0ae3 movw     r3, #0xab38
a038615c 70314ae3 movt     r3, #0xa170
a0386160 002093e5 ldr      r2, [r3]
a0386164 003d02e3 movw     r3, #0x2d00
a0386168 70314ae3 movt     r3, #0xa170
a038616c 023193e7 ldr      r3, [r3, r2, lsl #2]
a0386170 0324a0e1 lsl      r2, r3, #8
a0386174 003d02e3 movw     r3, #0x2d00
a0386178 70314ae3 movt     r3, #0xa170
a038617c 012183e7 str      r2, [r3, r1, lsl #2]
a0386180 383b0ae3 movw     r3, #0xab38
a0386184 70314ae3 movt     r3, #0xa170
a0386188 000093e5 ldr      r0, [r3]
a038618c 383b0ae3 movw     r3, #0xab38
a0386190 70314ae3 movt     r3, #0xa170
a0386194 003093e5 ldr      r3, [r3]
a0386198 002d02e3 movw     r2, #0x2d00
a038619c 70214ae3 movt     r2, #0xa170
a03861a0 893083e2 add      r3, r3, #0x89
a03861a4 033192e7 ldr      r3, [r2, r3, lsl #2]
a03861a8 0314a0e1 lsl      r1, r3, #8
a03861ac 002d02e3 movw     r2, #0x2d00
a03861b0 70214ae3 movt     r2, #0xa170
a03861b4 893080e2 add      r3, r0, #0x89
a03861b8 031182e7 str      r1, [r2, r3, lsl #2]
a03861bc c03c02e3 movw     r3, #0x2cc0
a03861c0 70314ae3 movt     r3, #0xa170
a03861c4 1130d3e5 ldrb     r3, [r3, #0x11]
a03861c8 010053e3 cmp      r3, #1
a03861cc 0400000a beq      #0xa03861e4
a03861d0 c03c02e3 movw     r3, #0x2cc0
a03861d4 70314ae3 movt     r3, #0xa170
a03861d8 1130d3e5 ldrb     r3, [r3, #0x11]
a03861dc 020053e3 cmp      r3, #2
a03861e0 1000001a bne      #0xa0386228
a03861e4 383b0ae3 movw     r3, #0xab38
a03861e8 70314ae3 movt     r3, #0xa170
a03861ec 000093e5 ldr      r0, [r3]
a03861f0 383b0ae3 movw     r3, #0xab38
a03861f4 70314ae3 movt     r3, #0xa170
a03861f8 003093e5 ldr      r3, [r3]
a03861fc 002d02e3 movw     r2, #0x2d00
a0386200 70214ae3 movt     r2, #0xa170
a0386204 113e83e2 add      r3, r3, #0x110
a0386208 023083e2 add      r3, r3, #2
a038620c 033192e7 ldr      r3, [r2, r3, lsl #2]
a0386210 0314a0e1 lsl      r1, r3, #8
a0386214 002d02e3 movw     r2, #0x2d00
a0386218 70214ae3 movt     r2, #0xa170
a038621c 113e80e2 add      r3, r0, #0x110
a0386220 023083e2 add      r3, r3, #2
a0386224 031182e7 str      r1, [r2, r3, lsl #2]
a0386228 343204e3 movw     r3, #0x4234
a038622c 70314ae3 movt     r3, #0xa170
a0386230 002093e5 ldr      r2, [r3]
a0386234 c03504e3 movw     r3, #0x45c0
a0386238 70314ae3 movt     r3, #0xa170
a038623c 003093e5 ldr      r3, [r3]
a0386240 030052e1 cmp      r2, r3
a0386244 4600000a beq      #0xa0386364
a0386248 c03504e3 movw     r3, #0x45c0
a038624c 70314ae3 movt     r3, #0xa170
a0386250 002093e5 ldr      r2, [r3]
a0386254 343204e3 movw     r3, #0x4234
a0386258 70314ae3 movt     r3, #0xa170
a038625c 003093e5 ldr      r3, [r3]
a0386260 380f0fe3 movw     r0, #0xff38
a0386264 5f004ae3 movt     r0, #0xa05f
a0386268 0210a0e1 mov      r1, r2
a038626c 0320a0e1 mov      r2, r3
a0386270 9d83fceb bl       #0xa02a70ec
a0386274 343204e3 movw     r3, #0x4234
a0386278 70314ae3 movt     r3, #0xa170
a038627c 002093e5 ldr      r2, [r3]
a0386280 c03504e3 movw     r3, #0x45c0
a0386284 70314ae3 movt     r3, #0xa170
a0386288 002083e5 str      r2, [r3]
a038628c 343204e3 movw     r3, #0x4234
a0386290 70314ae3 movt     r3, #0xa170
a0386294 003093e5 ldr      r3, [r3]
a0386298 0a0053e3 cmp      r3, #0xa
a038629c 3000001a bne      #0xa0386364
a03862a0 c83004e3 movw     r3, #0x40c8
a03862a4 70314ae3 movt     r3, #0xa170
a03862a8 d020c3e1 ldrd     r2, r3, [r3]
a03862ac 341204e3 movw     r1, #0x4234
a03862b0 70114ae3 movt     r1, #0xa170
a03862b4 001091e5 ldr      r1, [r1]
a03862b8 20c041e2 sub      ip, r1, #0x20
a03862bc 200061e2 rsb      r0, r1, #0x20
a03862c0 1351a0e1 lsl      r5, r3, r1
a03862c4 125c85e1 orr      r5, r5, r2, lsl ip
a03862c8 325085e1 orr      r5, r5, r2, lsr r0
a03862cc 1241a0e1 lsl      r4, r2, r1
a03862d0 c83004e3 movw     r3, #0x40c8
a03862d4 70314ae3 movt     r3, #0xa170
a03862d8 f040c3e1 strd     r4, r5, [r3]
a03862dc c83004e3 movw     r3, #0x40c8
a03862e0 70314ae3 movt     r3, #0xa170
a03862e4 d820c3e1 ldrd     r2, r3, [r3, #8]
a03862e8 341204e3 movw     r1, #0x4234
a03862ec 70114ae3 movt     r1, #0xa170
a03862f0 001091e5 ldr      r1, [r1]
a03862f4 20c041e2 sub      ip, r1, #0x20
a03862f8 200061e2 rsb      r0, r1, #0x20
a03862fc 1371a0e1 lsl      r7, r3, r1
a0386300 127c87e1 orr      r7, r7, r2, lsl ip
a0386304 327087e1 orr      r7, r7, r2, lsr r0
a0386308 1261a0e1 lsl      r6, r2, r1
a038630c c83004e3 movw     r3, #0x40c8
a0386310 70314ae3 movt     r3, #0xa170
a0386314 f860c3e1 strd     r6, r7, [r3, #8]
a0386318 c83004e3 movw     r3, #0x40c8
a038631c 70314ae3 movt     r3, #0xa170
a0386320 d021c3e1 ldrd     r2, r3, [r3, #0x10]
a0386324 381204e3 movw     r1, #0x4238
a0386328 70114ae3 movt     r1, #0xa170
a038632c 001091e5 ldr      r1, [r1]
a0386330 20c041e2 sub      ip, r1, #0x20
a0386334 200061e2 rsb      r0, r1, #0x20
a0386338 1391a0e1 lsl      sb, r3, r1
a038633c 129c89e1 orr      sb, sb, r2, lsl ip
a0386340 329089e1 orr      sb, sb, r2, lsr r0
a0386344 1281a0e1 lsl      r8, r2, r1
a0386348 c83004e3 movw     r3, #0x40c8
a038634c 70314ae3 movt     r3, #0xa170
a0386350 f081c3e1 strd     r8, sb, [r3, #0x10]
a0386354 ba2f0ae3 movw     r2, #0xafba
a0386358 70214ae3 movt     r2, #0xa170
a038635c 0130a0e3 mov      r3, #1
a0386360 0030c2e5 strb     r3, [r2]
a0386364 343204e3 movw     r3, #0x4234
a0386368 70314ae3 movt     r3, #0xa170
a038636c 003093e5 ldr      r3, [r3]
a0386370 0a0053e3 cmp      r3, #0xa
a0386374 7b00001a bne      #0xa0386568
a0386378 c83004e3 movw     r3, #0x40c8
a038637c 70314ae3 movt     r3, #0xa170
a0386380 d040c3e1 ldrd     r4, r5, [r3]
a0386384 c83004e3 movw     r3, #0x40c8
a0386388 70314ae3 movt     r3, #0xa170
a038638c d020c3e1 ldrd     r2, r3, [r3]
a0386390 341204e3 movw     r1, #0x4234
a0386394 70114ae3 movt     r1, #0xa170
a0386398 001091e5 ldr      r1, [r1]
a038639c 20c061e2 rsb      ip, r1, #0x20
a03863a0 200041e2 sub      r0, r1, #0x20
a03863a4 32a1a0e1 lsr      sl, r2, r1
a03863a8 13ac8ae1 orr      sl, sl, r3, lsl ip
a03863ac 33a08ae1 orr      sl, sl, r3, lsr r0
a03863b0 33b1a0e1 lsr      fp, r3, r1
a03863b4 0400a0e1 mov      r0, r4
a03863b8 0510a0e1 mov      r1, r5
a03863bc 0a0050e0 subs     r0, r0, sl
a03863c0 0b10c1e0 sbc      r1, r1, fp
a03863c4 383b0ae3 movw     r3, #0xab38
a03863c8 70314ae3 movt     r3, #0xa170
a03863cc 002093e5 ldr      r2, [r3]
a03863d0 003d02e3 movw     r3, #0x2d00
a03863d4 70314ae3 movt     r3, #0xa170
a03863d8 023193e7 ldr      r3, [r3, r2, lsl #2]
a03863dc 0320a0e1 mov      r2, r3
a03863e0 c23fa0e1 asr      r3, r2, #0x1f
a03863e4 020090e0 adds     r0, r0, r2
a03863e8 0310a1e0 adc      r1, r1, r3
a03863ec c83004e3 movw     r3, #0x40c8
a03863f0 70314ae3 movt     r3, #0xa170
a03863f4 f000c3e1 strd     r0, r1, [r3]
a03863f8 c83004e3 movw     r3, #0x40c8
a03863fc 70314ae3 movt     r3, #0xa170
a0386400 d840c3e1 ldrd     r4, r5, [r3, #8]
a0386404 c83004e3 movw     r3, #0x40c8
a0386408 70314ae3 movt     r3, #0xa170
a038640c d820c3e1 ldrd     r2, r3, [r3, #8]
a0386410 341204e3 movw     r1, #0x4234
a0386414 70114ae3 movt     r1, #0xa170
a0386418 001091e5 ldr      r1, [r1]
a038641c 20c061e2 rsb      ip, r1, #0x20
a0386420 200041e2 sub      r0, r1, #0x20
a0386424 32e1a0e1 lsr      lr, r2, r1
a0386428 88e08de5 str      lr, [sp, #0x88]
a038642c 88e09de5 ldr      lr, [sp, #0x88]
a0386430 13cc8ee1 orr      ip, lr, r3, lsl ip
a0386434 88c08de5 str      ip, [sp, #0x88]
a0386438 88c09de5 ldr      ip, [sp, #0x88]
a038643c 33008ce1 orr      r0, ip, r3, lsr r0
a0386440 88008de5 str      r0, [sp, #0x88]
a0386444 3331a0e1 lsr      r3, r3, r1
a0386448 8c308de5 str      r3, [sp, #0x8c]
a038644c d808cde1 ldrd     r0, r1, [sp, #0x88]
a0386450 000054e0 subs     r0, r4, r0
a0386454 0110c5e0 sbc      r1, r5, r1
a0386458 383b0ae3 movw     r3, #0xab38
a038645c 70314ae3 movt     r3, #0xa170
a0386460 003093e5 ldr      r3, [r3]
a0386464 002d02e3 movw     r2, #0x2d00
a0386468 70214ae3 movt     r2, #0xa170
a038646c 893083e2 add      r3, r3, #0x89
a0386470 033192e7 ldr      r3, [r2, r3, lsl #2]
a0386474 0320a0e1 mov      r2, r3
a0386478 c23fa0e1 asr      r3, r2, #0x1f
a038647c 020090e0 adds     r0, r0, r2
a0386480 0310a1e0 adc      r1, r1, r3
a0386484 c83004e3 movw     r3, #0x40c8
a0386488 70314ae3 movt     r3, #0xa170
a038648c f800c3e1 strd     r0, r1, [r3, #8]
a0386490 003d02e3 movw     r3, #0x2d00
a0386494 70314ae3 movt     r3, #0xa170
a0386498 14e293e5 ldr      lr, [r3, #0x214]
a038649c c83004e3 movw     r3, #0x40c8
a03864a0 70314ae3 movt     r3, #0xa170
a03864a4 d020c3e1 ldrd     r2, r3, [r3]
a03864a8 341204e3 movw     r1, #0x4234
a03864ac 70114ae3 movt     r1, #0xa170
a03864b0 001091e5 ldr      r1, [r1]
a03864b4 20c061e2 rsb      ip, r1, #0x20
a03864b8 200041e2 sub      r0, r1, #0x20
a03864bc 3241a0e1 lsr      r4, r2, r1
a03864c0 90408de5 str      r4, [sp, #0x90]
a03864c4 90409de5 ldr      r4, [sp, #0x90]
a03864c8 13cc84e1 orr      ip, r4, r3, lsl ip
a03864cc 90c08de5 str      ip, [sp, #0x90]
a03864d0 90c09de5 ldr      ip, [sp, #0x90]
a03864d4 33008ce1 orr      r0, ip, r3, lsr r0
a03864d8 90008de5 str      r0, [sp, #0x90]
a03864dc 3331a0e1 lsr      r3, r3, r1
a03864e0 94308de5 str      r3, [sp, #0x94]
a03864e4 90109de5 ldr      r1, [sp, #0x90]
a03864e8 002d02e3 movw     r2, #0x2d00
a03864ec 70214ae3 movt     r2, #0xa170
a03864f0 663f8ee2 add      r3, lr, #0x198
a03864f4 033083e2 add      r3, r3, #3
a03864f8 031182e7 str      r1, [r2, r3, lsl #2]
a03864fc 003d02e3 movw     r3, #0x2d00
a0386500 70314ae3 movt     r3, #0xa170
a0386504 14e293e5 ldr      lr, [r3, #0x214]
a0386508 c83004e3 movw     r3, #0x40c8
a038650c 70314ae3 movt     r3, #0xa170
a0386510 d820c3e1 ldrd     r2, r3, [r3, #8]
a0386514 341204e3 movw     r1, #0x4234
a0386518 70114ae3 movt     r1, #0xa170
a038651c 001091e5 ldr      r1, [r1]
a0386520 20c061e2 rsb      ip, r1, #0x20
a0386524 200041e2 sub      r0, r1, #0x20
a0386528 3241a0e1 lsr      r4, r2, r1
a038652c 98408de5 str      r4, [sp, #0x98]
a0386530 98409de5 ldr      r4, [sp, #0x98]
a0386534 13cc84e1 orr      ip, r4, r3, lsl ip
a0386538 98c08de5 str      ip, [sp, #0x98]
a038653c 98c09de5 ldr      ip, [sp, #0x98]
a0386540 33008ce1 orr      r0, ip, r3, lsr r0
a0386544 98008de5 str      r0, [sp, #0x98]
a0386548 3331a0e1 lsr      r3, r3, r1
a038654c 9c308de5 str      r3, [sp, #0x9c]
a0386550 98109de5 ldr      r1, [sp, #0x98]
a0386554 002d02e3 movw     r2, #0x2d00
a0386558 70214ae3 movt     r2, #0xa170
a038655c 893f8ee2 add      r3, lr, #0x224
a0386560 031182e7 str      r1, [r2, r3, lsl #2]
a0386564 810000ea b        #0xa0386770
a0386568 c83004e3 movw     r3, #0x40c8
a038656c 70314ae3 movt     r3, #0xa170
a0386570 d020c3e1 ldrd     r2, r3, [r3]
a0386574 341204e3 movw     r1, #0x4234
a0386578 70114ae3 movt     r1, #0xa170
a038657c 001091e5 ldr      r1, [r1]
a0386580 20c041e2 sub      ip, r1, #0x20
a0386584 200061e2 rsb      r0, r1, #0x20
a0386588 13e1a0e1 lsl      lr, r3, r1
a038658c a4e08de5 str      lr, [sp, #0xa4]
a0386590 a4e09de5 ldr      lr, [sp, #0xa4]
a0386594 12cc8ee1 orr      ip, lr, r2, lsl ip
a0386598 a4c08de5 str      ip, [sp, #0xa4]
a038659c a4c09de5 ldr      ip, [sp, #0xa4]
a03865a0 32008ce1 orr      r0, ip, r2, lsr r0
a03865a4 a4008de5 str      r0, [sp, #0xa4]
a03865a8 1231a0e1 lsl      r3, r2, r1
a03865ac a0308de5 str      r3, [sp, #0xa0]
a03865b0 c83004e3 movw     r3, #0x40c8
a03865b4 70314ae3 movt     r3, #0xa170
a03865b8 d020c3e1 ldrd     r2, r3, [r3]
a03865bc d00acde1 ldrd     r0, r1, [sp, #0xa0]
a03865c0 020050e0 subs     r0, r0, r2
a03865c4 0310c1e0 sbc      r1, r1, r3
a03865c8 383b0ae3 movw     r3, #0xab38
a03865cc 70314ae3 movt     r3, #0xa170
a03865d0 002093e5 ldr      r2, [r3]
a03865d4 003d02e3 movw     r3, #0x2d00
a03865d8 70314ae3 movt     r3, #0xa170
a03865dc 023193e7 ldr      r3, [r3, r2, lsl #2]
a03865e0 0320a0e1 mov      r2, r3
a03865e4 c23fa0e1 asr      r3, r2, #0x1f
a03865e8 002092e0 adds     r2, r2, r0
a03865ec 0130a3e0 adc      r3, r3, r1
a03865f0 341204e3 movw     r1, #0x4234
a03865f4 70114ae3 movt     r1, #0xa170
a03865f8 001091e5 ldr      r1, [r1]
a03865fc 20c061e2 rsb      ip, r1, #0x20
a0386600 200041e2 sub      r0, r1, #0x20
a0386604 32e1a0e1 lsr      lr, r2, r1
a0386608 a8e08de5 str      lr, [sp, #0xa8]
a038660c a8e09de5 ldr      lr, [sp, #0xa8]
a0386610 13cc8ee1 orr      ip, lr, r3, lsl ip
a0386614 a8c08de5 str      ip, [sp, #0xa8]
a0386618 a8c09de5 ldr      ip, [sp, #0xa8]
a038661c 33008ce1 orr      r0, ip, r3, lsr r0
a0386620 a8008de5 str      r0, [sp, #0xa8]
a0386624 3331a0e1 lsr      r3, r3, r1
a0386628 ac308de5 str      r3, [sp, #0xac]
a038662c c83004e3 movw     r3, #0x40c8
a0386630 70314ae3 movt     r3, #0xa170
a0386634 d80acde1 ldrd     r0, r1, [sp, #0xa8]
a0386638 f000c3e1 strd     r0, r1, [r3]
a038663c c83004e3 movw     r3, #0x40c8
a0386640 70314ae3 movt     r3, #0xa170
a0386644 d820c3e1 ldrd     r2, r3, [r3, #8]
a0386648 341204e3 movw     r1, #0x4234
a038664c 70114ae3 movt     r1, #0xa170
a0386650 001091e5 ldr      r1, [r1]
a0386654 20c041e2 sub      ip, r1, #0x20
a0386658 200061e2 rsb      r0, r1, #0x20
a038665c 13e1a0e1 lsl      lr, r3, r1
a0386660 b4e08de5 str      lr, [sp, #0xb4]
a0386664 b4e09de5 ldr      lr, [sp, #0xb4]
a0386668 12cc8ee1 orr      ip, lr, r2, lsl ip
a038666c b4c08de5 str      ip, [sp, #0xb4]
a0386670 b4c09de5 ldr      ip, [sp, #0xb4]
a0386674 32008ce1 orr      r0, ip, r2, lsr r0
a0386678 b4008de5 str      r0, [sp, #0xb4]
a038667c 1231a0e1 lsl      r3, r2, r1
a0386680 b0308de5 str      r3, [sp, #0xb0]
a0386684 c83004e3 movw     r3, #0x40c8
a0386688 70314ae3 movt     r3, #0xa170
a038668c d820c3e1 ldrd     r2, r3, [r3, #8]
a0386690 d00bcde1 ldrd     r0, r1, [sp, #0xb0]
a0386694 020050e0 subs     r0, r0, r2
a0386698 0310c1e0 sbc      r1, r1, r3
a038669c 383b0ae3 movw     r3, #0xab38
a03866a0 70314ae3 movt     r3, #0xa170
a03866a4 003093e5 ldr      r3, [r3]
a03866a8 002d02e3 movw     r2, #0x2d00
a03866ac 70214ae3 movt     r2, #0xa170
a03866b0 893083e2 add      r3, r3, #0x89
a03866b4 033192e7 ldr      r3, [r2, r3, lsl #2]
a03866b8 0320a0e1 mov      r2, r3
a03866bc c23fa0e1 asr      r3, r2, #0x1f
a03866c0 002092e0 adds     r2, r2, r0
a03866c4 0130a3e0 adc      r3, r3, r1
a03866c8 341204e3 movw     r1, #0x4234
a03866cc 70114ae3 movt     r1, #0xa170
a03866d0 001091e5 ldr      r1, [r1]
a03866d4 20c061e2 rsb      ip, r1, #0x20
a03866d8 200041e2 sub      r0, r1, #0x20
a03866dc 32e1a0e1 lsr      lr, r2, r1
a03866e0 b8e08de5 str      lr, [sp, #0xb8]
a03866e4 b8e09de5 ldr      lr, [sp, #0xb8]
a03866e8 13cc8ee1 orr      ip, lr, r3, lsl ip
a03866ec b8c08de5 str      ip, [sp, #0xb8]
a03866f0 b8c09de5 ldr      ip, [sp, #0xb8]
a03866f4 33008ce1 orr      r0, ip, r3, lsr r0
a03866f8 b8008de5 str      r0, [sp, #0xb8]
a03866fc 3331a0e1 lsr      r3, r3, r1
a0386700 bc308de5 str      r3, [sp, #0xbc]
a0386704 c83004e3 movw     r3, #0x40c8
a0386708 70314ae3 movt     r3, #0xa170
a038670c d80bcde1 ldrd     r0, r1, [sp, #0xb8]
a0386710 f800c3e1 strd     r0, r1, [r3, #8]
a0386714 003d02e3 movw     r3, #0x2d00
a0386718 70314ae3 movt     r3, #0xa170
a038671c 141293e5 ldr      r1, [r3, #0x214]
a0386720 c83004e3 movw     r3, #0x40c8
a0386724 70314ae3 movt     r3, #0xa170
a0386728 d020c3e1 ldrd     r2, r3, [r3]
a038672c 0200a0e1 mov      r0, r2
a0386730 002d02e3 movw     r2, #0x2d00
a0386734 70214ae3 movt     r2, #0xa170
a0386738 663f81e2 add      r3, r1, #0x198
a038673c 033083e2 add      r3, r3, #3
a0386740 030182e7 str      r0, [r2, r3, lsl #2]
a0386744 003d02e3 movw     r3, #0x2d00
a0386748 70314ae3 movt     r3, #0xa170
a038674c 141293e5 ldr      r1, [r3, #0x214]
a0386750 c83004e3 movw     r3, #0x40c8
a0386754 70314ae3 movt     r3, #0xa170
a0386758 d820c3e1 ldrd     r2, r3, [r3, #8]
a038675c 0200a0e1 mov      r0, r2
a0386760 002d02e3 movw     r2, #0x2d00
a0386764 70214ae3 movt     r2, #0xa170
a0386768 893f81e2 add      r3, r1, #0x224
a038676c 030182e7 str      r0, [r2, r3, lsl #2]
a0386770 c03c02e3 movw     r3, #0x2cc0
a0386774 70314ae3 movt     r3, #0xa170
a0386778 1130d3e5 ldrb     r3, [r3, #0x11]
a038677c 010053e3 cmp      r3, #1
a0386780 0400000a beq      #0xa0386798
a0386784 c03c02e3 movw     r3, #0x2cc0
a0386788 70314ae3 movt     r3, #0xa170
a038678c 1130d3e5 ldrb     r3, [r3, #0x11]
a0386790 020053e3 cmp      r3, #2
a0386794 8f00001a bne      #0xa03869d8
a0386798 f83a07e3 movw     r3, #0x7af8
a038679c 75304ae3 movt     r3, #0xa075
a03867a0 b833d3e1 ldrh     r3, [r3, #0x38]
a03867a4 000053e3 cmp      r3, #0
a03867a8 8a00001a bne      #0xa03869d8
a03867ac 343204e3 movw     r3, #0x4234
a03867b0 70314ae3 movt     r3, #0xa170
a03867b4 003093e5 ldr      r3, [r3]
a03867b8 0a0053e3 cmp      r3, #0xa
a03867bc 4200001a bne      #0xa03868cc
a03867c0 c83004e3 movw     r3, #0x40c8
a03867c4 70314ae3 movt     r3, #0xa170
a03867c8 d041c3e1 ldrd     r4, r5, [r3, #0x10]
a03867cc c83004e3 movw     r3, #0x40c8
a03867d0 70314ae3 movt     r3, #0xa170
a03867d4 d021c3e1 ldrd     r2, r3, [r3, #0x10]
a03867d8 381204e3 movw     r1, #0x4238
a03867dc 70114ae3 movt     r1, #0xa170
a03867e0 001091e5 ldr      r1, [r1]
a03867e4 20c061e2 rsb      ip, r1, #0x20
a03867e8 200041e2 sub      r0, r1, #0x20
a03867ec 32e1a0e1 lsr      lr, r2, r1
a03867f0 c0e08de5 str      lr, [sp, #0xc0]
a03867f4 c0e09de5 ldr      lr, [sp, #0xc0]
a03867f8 13cc8ee1 orr      ip, lr, r3, lsl ip
a03867fc c0c08de5 str      ip, [sp, #0xc0]
a0386800 c0c09de5 ldr      ip, [sp, #0xc0]
a0386804 33008ce1 orr      r0, ip, r3, lsr r0
a0386808 c0008de5 str      r0, [sp, #0xc0]
a038680c 3331a0e1 lsr      r3, r3, r1
a0386810 c4308de5 str      r3, [sp, #0xc4]
a0386814 d00ccde1 ldrd     r0, r1, [sp, #0xc0]
a0386818 000054e0 subs     r0, r4, r0
a038681c 0110c5e0 sbc      r1, r5, r1
a0386820 383b0ae3 movw     r3, #0xab38
a0386824 70314ae3 movt     r3, #0xa170
a0386828 003093e5 ldr      r3, [r3]
a038682c 002d02e3 movw     r2, #0x2d00
a0386830 70214ae3 movt     r2, #0xa170
a0386834 113e83e2 add      r3, r3, #0x110
a0386838 023083e2 add      r3, r3, #2
a038683c 033192e7 ldr      r3, [r2, r3, lsl #2]
a0386840 0320a0e1 mov      r2, r3
a0386844 c23fa0e1 asr      r3, r2, #0x1f
a0386848 020090e0 adds     r0, r0, r2
a038684c 0310a1e0 adc      r1, r1, r3
a0386850 c83004e3 movw     r3, #0x40c8
a0386854 70314ae3 movt     r3, #0xa170
a0386858 f001c3e1 strd     r0, r1, [r3, #0x10]
a038685c 003d02e3 movw     r3, #0x2d00
a0386860 70314ae3 movt     r3, #0xa170
a0386864 14e293e5 ldr      lr, [r3, #0x214]
a0386868 c83004e3 movw     r3, #0x40c8
a038686c 70314ae3 movt     r3, #0xa170
a0386870 d021c3e1 ldrd     r2, r3, [r3, #0x10]
a0386874 381204e3 movw     r1, #0x4238
a0386878 70114ae3 movt     r1, #0xa170
a038687c 001091e5 ldr      r1, [r1]
a0386880 20c061e2 rsb      ip, r1, #0x20
a0386884 200041e2 sub      r0, r1, #0x20
a0386888 3241a0e1 lsr      r4, r2, r1
a038688c c8408de5 str      r4, [sp, #0xc8]
a0386890 c8409de5 ldr      r4, [sp, #0xc8]
a0386894 13cc84e1 orr      ip, r4, r3, lsl ip
a0386898 c8c08de5 str      ip, [sp, #0xc8]
a038689c c8c09de5 ldr      ip, [sp, #0xc8]
a03868a0 33008ce1 orr      r0, ip, r3, lsr r0
a03868a4 c8008de5 str      r0, [sp, #0xc8]
a03868a8 3331a0e1 lsr      r3, r3, r1
a03868ac cc308de5 str      r3, [sp, #0xcc]
a03868b0 c8109de5 ldr      r1, [sp, #0xc8]
a03868b4 002d02e3 movw     r2, #0x2d00
a03868b8 70214ae3 movt     r2, #0xa170
a03868bc ab3f8ee2 add      r3, lr, #0x2ac
a03868c0 013083e2 add      r3, r3, #1
a03868c4 031182e7 str      r1, [r2, r3, lsl #2]
a03868c8 420000ea b        #0xa03869d8
a03868cc c83004e3 movw     r3, #0x40c8
a03868d0 70314ae3 movt     r3, #0xa170
a03868d4 d021c3e1 ldrd     r2, r3, [r3, #0x10]
a03868d8 381204e3 movw     r1, #0x4238
a03868dc 70114ae3 movt     r1, #0xa170
a03868e0 001091e5 ldr      r1, [r1]
a03868e4 20c041e2 sub      ip, r1, #0x20
a03868e8 200061e2 rsb      r0, r1, #0x20
a03868ec 13e1a0e1 lsl      lr, r3, r1
a03868f0 d4e08de5 str      lr, [sp, #0xd4]
a03868f4 d4e09de5 ldr      lr, [sp, #0xd4]
a03868f8 12cc8ee1 orr      ip, lr, r2, lsl ip
a03868fc d4c08de5 str      ip, [sp, #0xd4]
a0386900 d4c09de5 ldr      ip, [sp, #0xd4]
a0386904 32008ce1 orr      r0, ip, r2, lsr r0
a0386908 d4008de5 str      r0, [sp, #0xd4]
a038690c 1231a0e1 lsl      r3, r2, r1
a0386910 d0308de5 str      r3, [sp, #0xd0]
a0386914 c83004e3 movw     r3, #0x40c8
a0386918 70314ae3 movt     r3, #0xa170
a038691c d021c3e1 ldrd     r2, r3, [r3, #0x10]
a0386920 d00dcde1 ldrd     r0, r1, [sp, #0xd0]
a0386924 020050e0 subs     r0, r0, r2
a0386928 0310c1e0 sbc      r1, r1, r3
a038692c 383b0ae3 movw     r3, #0xab38
a0386930 70314ae3 movt     r3, #0xa170
a0386934 003093e5 ldr      r3, [r3]
a0386938 002d02e3 movw     r2, #0x2d00
a038693c 70214ae3 movt     r2, #0xa170
a0386940 113e83e2 add      r3, r3, #0x110
a0386944 023083e2 add      r3, r3, #2
a0386948 033192e7 ldr      r3, [r2, r3, lsl #2]
a038694c 0320a0e1 mov      r2, r3
a0386950 c23fa0e1 asr      r3, r2, #0x1f
a0386954 020090e0 adds     r0, r0, r2
a0386958 0310a1e0 adc      r1, r1, r3
a038695c 383204e3 movw     r3, #0x4238
a0386960 70314ae3 movt     r3, #0xa170
a0386964 003093e5 ldr      r3, [r3]
a0386968 20c063e2 rsb      ip, r3, #0x20
a038696c 202043e2 sub      r2, r3, #0x20
a0386970 30e3a0e1 lsr      lr, r0, r3
a0386974 d8e08de5 str      lr, [sp, #0xd8]
a0386978 d8e09de5 ldr      lr, [sp, #0xd8]
a038697c 11cc8ee1 orr      ip, lr, r1, lsl ip
a0386980 d8c08de5 str      ip, [sp, #0xd8]
a0386984 d8c09de5 ldr      ip, [sp, #0xd8]
a0386988 31228ce1 orr      r2, ip, r1, lsr r2
a038698c d8208de5 str      r2, [sp, #0xd8]
a0386990 3133a0e1 lsr      r3, r1, r3
a0386994 dc308de5 str      r3, [sp, #0xdc]
a0386998 c83004e3 movw     r3, #0x40c8
a038699c 70314ae3 movt     r3, #0xa170
a03869a0 d80dcde1 ldrd     r0, r1, [sp, #0xd8]
a03869a4 f001c3e1 strd     r0, r1, [r3, #0x10]
a03869a8 003d02e3 movw     r3, #0x2d00
a03869ac 70314ae3 movt     r3, #0xa170
a03869b0 141293e5 ldr      r1, [r3, #0x214]
a03869b4 c83004e3 movw     r3, #0x40c8
a03869b8 70314ae3 movt     r3, #0xa170
a03869bc d021c3e1 ldrd     r2, r3, [r3, #0x10]
a03869c0 0200a0e1 mov      r0, r2
a03869c4 002d02e3 movw     r2, #0x2d00
a03869c8 70214ae3 movt     r2, #0xa170
a03869cc ab3f81e2 add      r3, r1, #0x2ac
a03869d0 013083e2 add      r3, r3, #1
a03869d4 030182e7 str      r0, [r2, r3, lsl #2]
a03869d8 64330be3 movw     r3, #0xb364
a03869dc 70314ae3 movt     r3, #0xa170
a03869e0 b030d3e1 ldrh     r3, [r3]
a03869e4 0320a0e1 mov      r2, r3
a03869e8 003d02e3 movw     r3, #0x2d00
a03869ec 70314ae3 movt     r3, #0xa170
a03869f0 103293e5 ldr      r3, [r3, #0x210]
a03869f4 030052e1 cmp      r2, r3
a03869f8 0800002a bhs      #0xa0386a20
a03869fc 64330be3 movw     r3, #0xb364
a0386a00 70314ae3 movt     r3, #0xa170
a0386a04 b030d3e1 ldrh     r3, [r3]
a0386a08 013083e2 add      r3, r3, #1
a0386a0c 7320ffe6 uxth     r2, r3
a0386a10 64330be3 movw     r3, #0xb364
a0386a14 70314ae3 movt     r3, #0xa170
a0386a18 b020c3e1 strh     r2, [r3]
a0386a1c 811d00ea b        #0xa038e028
a0386a20 443004e3 movw     r3, #0x4044
a0386a24 70314ae3 movt     r3, #0xa170
a0386a28 0020d3e5 ldrb     r2, [r3]
a0386a2c 153b0ae3 movw     r3, #0xab15
a0386a30 70314ae3 movt     r3, #0xa170
a0386a34 0020c3e5 strb     r2, [r3]
a0386a38 443004e3 movw     r3, #0x4044
a0386a3c 70314ae3 movt     r3, #0xa170
a0386a40 0120d3e5 ldrb     r2, [r3, #1]
a0386a44 163b0ae3 movw     r3, #0xab16
a0386a48 70314ae3 movt     r3, #0xa170
a0386a4c 0020c3e5 strb     r2, [r3]
a0386a50 443004e3 movw     r3, #0x4044
a0386a54 70314ae3 movt     r3, #0xa170
a0386a58 0220d3e5 ldrb     r2, [r3, #2]
a0386a5c 173b0ae3 movw     r3, #0xab17
a0386a60 70314ae3 movt     r3, #0xa170
a0386a64 0020c3e5 strb     r2, [r3]
a0386a68 443004e3 movw     r3, #0x4044
a0386a6c 70314ae3 movt     r3, #0xa170
a0386a70 0420d3e5 ldrb     r2, [r3, #4]
a0386a74 193b0ae3 movw     r3, #0xab19
a0386a78 70314ae3 movt     r3, #0xa170
a0386a7c 0020c3e5 strb     r2, [r3]
a0386a80 5c3b0ae3 movw     r3, #0xab5c
a0386a84 70314ae3 movt     r3, #0xa170
a0386a88 002093e5 ldr      r2, [r3]
a0386a8c 043304e3 movw     r3, #0x4304
a0386a90 70314ae3 movt     r3, #0xa170
a0386a94 003093e5 ldr      r3, [r3]
a0386a98 030052e1 cmp      r2, r3
a0386a9c 8c02000a beq      #0xa03874d4
a0386aa0 66330be3 movw     r3, #0xb366
a0386aa4 70314ae3 movt     r3, #0xa170
a0386aa8 0020a0e3 mov      r2, #0
a0386aac b020c3e1 strh     r2, [r3]
a0386ab0 2c3b0ae3 movw     r3, #0xab2c
a0386ab4 70314ae3 movt     r3, #0xa170
a0386ab8 002093e5 ldr      r2, [r3]
a0386abc 303b0ae3 movw     r3, #0xab30
a0386ac0 70314ae3 movt     r3, #0xa170
a0386ac4 002083e5 str      r2, [r3]
a0386ac8 283b0ae3 movw     r3, #0xab28
a0386acc 70314ae3 movt     r3, #0xa170
a0386ad0 002093e5 ldr      r2, [r3]
a0386ad4 2c3b0ae3 movw     r3, #0xab2c
a0386ad8 70314ae3 movt     r3, #0xa170
a0386adc 002083e5 str      r2, [r3]
a0386ae0 383b0ae3 movw     r3, #0xab38
a0386ae4 70314ae3 movt     r3, #0xa170
a0386ae8 002093e5 ldr      r2, [r3]
a0386aec 283b0ae3 movw     r3, #0xab28
a0386af0 70314ae3 movt     r3, #0xa170
a0386af4 002083e5 str      r2, [r3]
a0386af8 d03a07e3 movw     r3, #0x7ad0
a0386afc 75304ae3 movt     r3, #0xa075
a0386b00 0030d3e5 ldrb     r3, [r3]
a0386b04 090053e3 cmp      r3, #9
a0386b08 0e00008a bhi      #0xa0386b48
a0386b0c 383b0ae3 movw     r3, #0xab38
a0386b10 70314ae3 movt     r3, #0xa170
a0386b14 003093e5 ldr      r3, [r3]
a0386b18 640f0fe3 movw     r0, #0xff64
a0386b1c 5f004ae3 movt     r0, #0xa05f
a0386b20 0310a0e1 mov      r1, r3
a0386b24 7081fceb bl       #0xa02a70ec
a0386b28 d03a07e3 movw     r3, #0x7ad0
a0386b2c 75304ae3 movt     r3, #0xa075
a0386b30 0030d3e5 ldrb     r3, [r3]
a0386b34 013083e2 add      r3, r3, #1
a0386b38 7320efe6 uxtb     r2, r3
a0386b3c d03a07e3 movw     r3, #0x7ad0
a0386b40 75304ae3 movt     r3, #0xa075
a0386b44 0020c3e5 strb     r2, [r3]
a0386b48 c83a07e3 movw     r3, #0x7ac8
a0386b4c 75304ae3 movt     r3, #0xa075
a0386b50 0030d3e5 ldrb     r3, [r3]
a0386b54 010053e3 cmp      r3, #1
a0386b58 0700008a bhi      #0xa0386b7c
a0386b5c c83a07e3 movw     r3, #0x7ac8
a0386b60 75304ae3 movt     r3, #0xa075
a0386b64 0030d3e5 ldrb     r3, [r3]
a0386b68 013083e2 add      r3, r3, #1
a0386b6c 7320efe6 uxtb     r2, r3
a0386b70 c83a07e3 movw     r3, #0x7ac8
a0386b74 75304ae3 movt     r3, #0xa075
a0386b78 0020c3e5 strb     r2, [r3]
a0386b7c 5c3b0ae3 movw     r3, #0xab5c
a0386b80 70314ae3 movt     r3, #0xa170
a0386b84 002093e5 ldr      r2, [r3]
a0386b88 a43e0ae3 movw     r3, #0xaea4
a0386b8c 70314ae3 movt     r3, #0xa170
a0386b90 002083e5 str      r2, [r3]
a0386b94 043304e3 movw     r3, #0x4304
a0386b98 70314ae3 movt     r3, #0xa170
a0386b9c 002093e5 ldr      r2, [r3]
a0386ba0 5c3b0ae3 movw     r3, #0xab5c
a0386ba4 70314ae3 movt     r3, #0xa170
a0386ba8 002083e5 str      r2, [r3]
a0386bac da3504e3 movw     r3, #0x45da
a0386bb0 70314ae3 movt     r3, #0xa170
a0386bb4 0030d3e5 ldrb     r3, [r3]
a0386bb8 000053e3 cmp      r3, #0
a0386bbc 0d00000a beq      #0xa0386bf8
a0386bc0 b93f0ae3 movw     r3, #0xafb9
a0386bc4 70314ae3 movt     r3, #0xa170
a0386bc8 0020a0e3 mov      r2, #0
a0386bcc 0020c3e5 strb     r2, [r3]
a0386bd0 b93f0ae3 movw     r3, #0xafb9
a0386bd4 70314ae3 movt     r3, #0xa170
a0386bd8 0020d3e5 ldrb     r2, [r3]
a0386bdc b83f0ae3 movw     r3, #0xafb8
a0386be0 70314ae3 movt     r3, #0xa170
a0386be4 0020c3e5 strb     r2, [r3]
a0386be8 1b3b0ae3 movw     r3, #0xab1b
a0386bec 70314ae3 movt     r3, #0xa170
a0386bf0 0020a0e3 mov      r2, #0
a0386bf4 0020c3e5 strb     r2, [r3]
a0386bf8 9af3ffeb bl       #0xa0383a68
a0386bfc 0030a0e3 mov      r3, #0
a0386c00 4e2f8de2 add      r2, sp, #0x138
a0386c04 022082e2 add      r2, r2, #2
a0386c08 b030c2e1 strh     r3, [r2]
a0386c0c 3a31dde5 ldrb     r3, [sp, #0x13a]
a0386c10 0120a0e3 mov      r2, #1
a0386c14 1231c7e7 bfi      r3, r2, #2, #6
a0386c18 3a31cde5 strb     r3, [sp, #0x13a]
a0386c1c 3a31dde5 ldrb     r3, [sp, #0x13a]
a0386c20 5330e1e7 ubfx     r3, r3, #0, #2
a0386c24 7330efe6 uxtb     r3, r3
a0386c28 0320a0e1 mov      r2, r3
a0386c2c 203f00e3 movw     r3, #0xf20
a0386c30 a3314ae3 movt     r3, #0xa1a3
a0386c34 023193e7 ldr      r3, [r3, r2, lsl #2]
a0386c38 283093e5 ldr      r3, [r3, #0x28]
a0386c3c 000053e3 cmp      r3, #0
a0386c40 0d00000a beq      #0xa0386c7c
a0386c44 3a31dde5 ldrb     r3, [sp, #0x13a]
a0386c48 5330e1e7 ubfx     r3, r3, #0, #2
a0386c4c 7330efe6 uxtb     r3, r3
a0386c50 0320a0e1 mov      r2, r3
a0386c54 203f00e3 movw     r3, #0xf20
a0386c58 a3314ae3 movt     r3, #0xa1a3
a0386c5c 023193e7 ldr      r3, [r3, r2, lsl #2]
a0386c60 283093e5 ldr      r3, [r3, #0x28]
a0386c64 4d2f8de2 add      r2, sp, #0x134
a0386c68 4e1f8de2 add      r1, sp, #0x138
a0386c6c 021081e2 add      r1, r1, #2
a0386c70 b000d1e1 ldrh     r0, [r1]
a0386c74 0210a0e1 mov      r1, r2
a0386c78 33ff2fe1 blx      r3
a0386c7c 4d7added vldr     s15, [sp, #0x134]
a0386c80 907a9fed vldr     s14, [pc, #0x240]
a0386c84 877a67ee vmul.f32 s15, s15, s14
a0386c88 e77afcee vcvt.u32.f32 s15, s15
a0386c8c 227acded vstr     s15, [sp, #0x88]
a0386c90 b838dde1 ldrh     r3, [sp, #0x88]
a0386c94 7320ffe6 uxth     r2, r3
a0386c98 203b0ae3 movw     r3, #0xab20
a0386c9c 70314ae3 movt     r3, #0xa170
a0386ca0 b020c3e1 strh     r2, [r3]
a0386ca4 8c3a07e3 movw     r3, #0x7a8c
a0386ca8 75304ae3 movt     r3, #0xa075
a0386cac 003093e5 ldr      r3, [r3]
a0386cb0 010053e3 cmp      r3, #1
a0386cb4 8c00009a bls      #0xa0386eec
a0386cb8 503c02e3 movw     r3, #0x2c50
a0386cbc 70314ae3 movt     r3, #0xa170
a0386cc0 0030d3e5 ldrb     r3, [r3]
a0386cc4 1e0053e3 cmp      r3, #0x1e
a0386cc8 3f00009a bls      #0xa0386dcc
a0386ccc 203b0ae3 movw     r3, #0xab20
a0386cd0 70314ae3 movt     r3, #0xa170
a0386cd4 b030d3e1 ldrh     r3, [r3]
a0386cd8 0d3043e2 sub      r3, r3, #0xd
a0386cdc 010053e3 cmp      r3, #1
a0386ce0 0b00009a bls      #0xa0386d14
a0386ce4 203b0ae3 movw     r3, #0xab20
a0386ce8 70314ae3 movt     r3, #0xa170
a0386cec b030d3e1 ldrh     r3, [r3]
a0386cf0 093043e2 sub      r3, r3, #9
a0386cf4 010053e3 cmp      r3, #1
a0386cf8 0500009a bls      #0xa0386d14
a0386cfc 203b0ae3 movw     r3, #0xab20
a0386d00 70314ae3 movt     r3, #0xa170
a0386d04 b030d3e1 ldrh     r3, [r3]
a0386d08 053043e2 sub      r3, r3, #5
a0386d0c 010053e3 cmp      r3, #1
a0386d10 0800008a bhi      #0xa0386d38
a0386d14 b03a07e3 movw     r3, #0x7ab0
a0386d18 75304ae3 movt     r3, #0xa075
a0386d1c 0420e0e3 mvn      r2, #4
a0386d20 0020c3e5 strb     r2, [r3]
a0386d24 e83504e3 movw     r3, #0x45e8
a0386d28 70314ae3 movt     r3, #0xa170
a0386d2c 0120a0e3 mov      r2, #1
a0386d30 0020c3e5 strb     r2, [r3]
a0386d34 230000ea b        #0xa0386dc8
a0386d38 203b0ae3 movw     r3, #0xab20
a0386d3c 70314ae3 movt     r3, #0xa170
a0386d40 b030d3e1 ldrh     r3, [r3]
a0386d44 0f3043e2 sub      r3, r3, #0xf
a0386d48 010053e3 cmp      r3, #1
a0386d4c 0b00009a bls      #0xa0386d80
a0386d50 203b0ae3 movw     r3, #0xab20
a0386d54 70314ae3 movt     r3, #0xa170
a0386d58 b030d3e1 ldrh     r3, [r3]
a0386d5c 0b3043e2 sub      r3, r3, #0xb
a0386d60 010053e3 cmp      r3, #1
a0386d64 0500009a bls      #0xa0386d80
a0386d68 203b0ae3 movw     r3, #0xab20
a0386d6c 70314ae3 movt     r3, #0xa170
a0386d70 b030d3e1 ldrh     r3, [r3]
a0386d74 073043e2 sub      r3, r3, #7
a0386d78 010053e3 cmp      r3, #1
a0386d7c 0800008a bhi      #0xa0386da4
a0386d80 b03a07e3 movw     r3, #0x7ab0
a0386d84 75304ae3 movt     r3, #0xa075
a0386d88 0320e0e3 mvn      r2, #3
a0386d8c 0020c3e5 strb     r2, [r3]
a0386d90 e83504e3 movw     r3, #0x45e8
a0386d94 70314ae3 movt     r3, #0xa170
a0386d98 0120a0e3 mov      r2, #1
a0386d9c 0020c3e5 strb     r2, [r3]
a0386da0 080000ea b        #0xa0386dc8
a0386da4 b03a07e3 movw     r3, #0x7ab0
a0386da8 75304ae3 movt     r3, #0xa075
a0386dac 0120e0e3 mvn      r2, #1
a0386db0 0020c3e5 strb     r2, [r3]
a0386db4 e83504e3 movw     r3, #0x45e8
a0386db8 70314ae3 movt     r3, #0xa170
a0386dbc 0020a0e3 mov      r2, #0
a0386dc0 0020c3e5 strb     r2, [r3]
a0386dc4 480000ea b        #0xa0386eec
a0386dc8 470000ea b        #0xa0386eec
a0386dcc 203b0ae3 movw     r3, #0xab20
a0386dd0 70314ae3 movt     r3, #0xa170
a0386dd4 b030d3e1 ldrh     r3, [r3]
a0386dd8 0f3043e2 sub      r3, r3, #0xf
a0386ddc 010053e3 cmp      r3, #1
a0386de0 0b00009a bls      #0xa0386e14
a0386de4 203b0ae3 movw     r3, #0xab20
a0386de8 70314ae3 movt     r3, #0xa170
a0386dec b030d3e1 ldrh     r3, [r3]
a0386df0 0b3043e2 sub      r3, r3, #0xb
a0386df4 010053e3 cmp      r3, #1
a0386df8 0500009a bls      #0xa0386e14
a0386dfc 203b0ae3 movw     r3, #0xab20
a0386e00 70314ae3 movt     r3, #0xa170
a0386e04 b030d3e1 ldrh     r3, [r3]
a0386e08 073043e2 sub      r3, r3, #7
a0386e0c 010053e3 cmp      r3, #1
a0386e10 0800008a bhi      #0xa0386e38
a0386e14 b03a07e3 movw     r3, #0x7ab0
a0386e18 75304ae3 movt     r3, #0xa075
a0386e1c 0420e0e3 mvn      r2, #4
a0386e20 0020c3e5 strb     r2, [r3]
a0386e24 e83504e3 movw     r3, #0x45e8
a0386e28 70314ae3 movt     r3, #0xa170
a0386e2c 0120a0e3 mov      r2, #1
a0386e30 0020c3e5 strb     r2, [r3]
a0386e34 2c0000ea b        #0xa0386eec
a0386e38 203b0ae3 movw     r3, #0xab20
a0386e3c 70314ae3 movt     r3, #0xa170
a0386e40 b030d3e1 ldrh     r3, [r3]
a0386e44 0d3043e2 sub      r3, r3, #0xd
a0386e48 010053e3 cmp      r3, #1
a0386e4c 0500009a bls      #0xa0386e68
a0386e50 203b0ae3 movw     r3, #0xab20
a0386e54 70314ae3 movt     r3, #0xa170
a0386e58 b030d3e1 ldrh     r3, [r3]
a0386e5c 093043e2 sub      r3, r3, #9
a0386e60 010053e3 cmp      r3, #1
a0386e64 0800008a bhi      #0xa0386e8c
a0386e68 b03a07e3 movw     r3, #0x7ab0
a0386e6c 75304ae3 movt     r3, #0xa075
a0386e70 0320e0e3 mvn      r2, #3
a0386e74 0020c3e5 strb     r2, [r3]
a0386e78 e83504e3 movw     r3, #0x45e8
a0386e7c 70314ae3 movt     r3, #0xa170
a0386e80 0120a0e3 mov      r2, #1
a0386e84 0020c3e5 strb     r2, [r3]
a0386e88 170000ea b        #0xa0386eec
a0386e8c 203b0ae3 movw     r3, #0xab20
a0386e90 70314ae3 movt     r3, #0xa170
a0386e94 b030d3e1 ldrh     r3, [r3]
a0386e98 053043e2 sub      r3, r3, #5
a0386e9c 010053e3 cmp      r3, #1
a0386ea0 0900008a bhi      #0xa0386ecc
a0386ea4 b03a07e3 movw     r3, #0x7ab0
a0386ea8 75304ae3 movt     r3, #0xa075
a0386eac 0220e0e3 mvn      r2, #2
a0386eb0 0020c3e5 strb     r2, [r3]
a0386eb4 e83504e3 movw     r3, #0x45e8
a0386eb8 70314ae3 movt     r3, #0xa170
a0386ebc 0120a0e3 mov      r2, #1
a0386ec0 0020c3e5 strb     r2, [r3]
a0386ec4 080000ea b        #0xa0386eec
a0386ec8 00007a44 ldrbtmi  r0, [sl], #-0
a0386ecc b03a07e3 movw     r3, #0x7ab0
a0386ed0 75304ae3 movt     r3, #0xa075
a0386ed4 0120e0e3 mvn      r2, #1
a0386ed8 0020c3e5 strb     r2, [r3]
a0386edc e83504e3 movw     r3, #0x45e8
a0386ee0 70314ae3 movt     r3, #0xa170
a0386ee4 0020a0e3 mov      r2, #0
a0386ee8 0020c3e5 strb     r2, [r3]
a0386eec 443004e3 movw     r3, #0x4044
a0386ef0 70314ae3 movt     r3, #0xa170
a0386ef4 0320d3e5 ldrb     r2, [r3, #3]
a0386ef8 183b0ae3 movw     r3, #0xab18
a0386efc 70314ae3 movt     r3, #0xa170
a0386f00 0020c3e5 strb     r2, [r3]
a0386f04 3a31dde5 ldrb     r3, [sp, #0x13a]
a0386f08 5330e1e7 ubfx     r3, r3, #0, #2
a0386f0c 7330efe6 uxtb     r3, r3
a0386f10 0320a0e1 mov      r2, r3
a0386f14 203f00e3 movw     r3, #0xf20
a0386f18 a3314ae3 movt     r3, #0xa1a3
a0386f1c 023193e7 ldr      r3, [r3, r2, lsl #2]
a0386f20 183093e5 ldr      r3, [r3, #0x18]
a0386f24 000053e3 cmp      r3, #0
a0386f28 0d00000a beq      #0xa0386f64
a0386f2c 3a31dde5 ldrb     r3, [sp, #0x13a]
a0386f30 5330e1e7 ubfx     r3, r3, #0, #2
a0386f34 7330efe6 uxtb     r3, r3
a0386f38 0320a0e1 mov      r2, r3
a0386f3c 203f00e3 movw     r3, #0xf20
a0386f40 a3314ae3 movt     r3, #0xa1a3
a0386f44 023193e7 ldr      r3, [r3, r2, lsl #2]
a0386f48 183093e5 ldr      r3, [r3, #0x18]
a0386f4c 4e2f8de2 add      r2, sp, #0x138
a0386f50 022082e2 add      r2, r2, #2
a0386f54 b000d2e1 ldrh     r0, [r2]
a0386f58 281104e3 movw     r1, #0x4128
a0386f5c 70114ae3 movt     r1, #0xa170
a0386f60 33ff2fe1 blx      r3
a0386f64 283104e3 movw     r3, #0x4128
a0386f68 70314ae3 movt     r3, #0xa170
a0386f6c 643093e5 ldr      r3, [r3, #0x64]
a0386f70 903a07ee vmov     s15, r3
a0386f74 671bf8ee vcvt.f64.u32 d17, s15
a0386f78 283104e3 movw     r3, #0x4128
a0386f7c 70314ae3 movt     r3, #0xa170
a0386f80 682093e5 ldr      r2, [r3, #0x68]
a0386f84 283104e3 movw     r3, #0x4128
a0386f88 70314ae3 movt     r3, #0xa170
a0386f8c 6030d3e5 ldrb     r3, [r3, #0x60]
a0386f90 013083e2 add      r3, r3, #1
a0386f94 930203e0 mul      r3, r3, r2
a0386f98 903a07ee vmov     s15, r3
a0386f9c 670bf8ee vcvt.f64.u32 d16, s15
a0386fa0 a00bc1ee vdiv.f64 d16, d17, d16
a0386fa4 6b1bdfed vldr     d17, [pc, #0x1ac]
a0386fa8 a10b70ee vadd.f64 d16, d16, d17
a0386fac 607bb0ee vmov.f64 d7, d16
a0386fb0 c77bfcee vcvt.u32.f64 s15, d7
a0386fb4 227acded vstr     s15, [sp, #0x88]
a0386fb8 b828dde1 ldrh     r2, [sp, #0x88]
a0386fbc 66330be3 movw     r3, #0xb366
a0386fc0 70314ae3 movt     r3, #0xa170
a0386fc4 b020c3e1 strh     r2, [r3]
a0386fc8 883c02e3 movw     r3, #0x2c88
a0386fcc 70314ae3 movt     r3, #0xa170
a0386fd0 b020d3e1 ldrh     r2, [r3]
a0386fd4 66330be3 movw     r3, #0xb366
a0386fd8 70314ae3 movt     r3, #0xa170
a0386fdc b030d3e1 ldrh     r3, [r3]
a0386fe0 030052e1 cmp      r2, r3
a0386fe4 ba00000a beq      #0xa03872d4
a0386fe8 66330be3 movw     r3, #0xb366
a0386fec 70314ae3 movt     r3, #0xa170
a0386ff0 b020d3e1 ldrh     r2, [r3]
a0386ff4 883c02e3 movw     r3, #0x2c88
a0386ff8 70314ae3 movt     r3, #0xa170
a0386ffc b020c3e1 strh     r2, [r3]
a0387000 283104e3 movw     r3, #0x4128
a0387004 70314ae3 movt     r3, #0xa170
a0387008 0c2093e5 ldr      r2, [r3, #0xc]
a038700c 003404e3 movw     r3, #0x4400
a0387010 70314ae3 movt     r3, #0xa170
a0387014 0c3093e5 ldr      r3, [r3, #0xc]
a0387018 022063e0 rsb      r2, r3, r2
a038701c 283104e3 movw     r3, #0x4128
a0387020 70314ae3 movt     r3, #0xa170
a0387024 067ad3ed vldr     s15, [r3, #0x18]
a0387028 4c7a9fed vldr     s14, [pc, #0x130]
a038702c 877a67ee vmul.f32 s15, s15, s14
a0387030 e77afcee vcvt.u32.f32 s15, s15
a0387034 903a17ee vmov     r3, s15
a0387038 930203e0 mul      r3, r3, r2
a038703c 7a3a83e2 add      r3, r3, #0x7a000
a0387040 123e83e2 add      r3, r3, #0x120
a0387044 832e0de3 movw     r2, #0xde83
a0387048 1b2344e3 movt     r2, #0x431b
a038704c 932283e0 umull    r2, r3, r3, r2
a0387050 2329a0e1 lsr      r2, r3, #0x12
a0387054 c03004e3 movw     r3, #0x40c0
a0387058 70314ae3 movt     r3, #0xa170
a038705c 002083e5 str      r2, [r3]
a0387060 883c02e3 movw     r3, #0x2c88
a0387064 70314ae3 movt     r3, #0xa170
a0387068 b030d3e1 ldrh     r3, [r3]
a038706c fa0ba0e3 mov      r0, #0x3e800
a0387070 0310a0e1 mov      r1, r3
a0387074 85fd05fa blx      #0xa0506690
a0387078 0030a0e1 mov      r3, r0
a038707c 0320a0e1 mov      r2, r3
a0387080 243b0ae3 movw     r3, #0xab24
a0387084 70314ae3 movt     r3, #0xa170
a0387088 002083e5 str      r2, [r3]
a038708c da3504e3 movw     r3, #0x45da
a0387090 70314ae3 movt     r3, #0xa170
a0387094 0030d3e5 ldrb     r3, [r3]
a0387098 000053e3 cmp      r3, #0
a038709c 1500000a beq      #0xa03870f8
a03870a0 503a07e3 movw     r3, #0x7a50
a03870a4 75304ae3 movt     r3, #0xa075
a03870a8 0030d3e5 ldrb     r3, [r3]
a03870ac 7320efe6 uxtb     r2, r3
a03870b0 283204e3 movw     r3, #0x4228
a03870b4 70314ae3 movt     r3, #0xa170
a03870b8 0020c3e5 strb     r2, [r3]
a03870bc 503c02e3 movw     r3, #0x2c50
a03870c0 70314ae3 movt     r3, #0xa170
a03870c4 0030d3e5 ldrb     r3, [r3]
a03870c8 7320efe6 uxtb     r2, r3
a03870cc 293204e3 movw     r3, #0x4229
a03870d0 70314ae3 movt     r3, #0xa170
a03870d4 0020c3e5 strb     r2, [r3]
a03870d8 513a07e3 movw     r3, #0x7a51
a03870dc 75304ae3 movt     r3, #0xa075
a03870e0 0030d3e5 ldrb     r3, [r3]
a03870e4 7320efe6 uxtb     r2, r3
a03870e8 2b3204e3 movw     r3, #0x422b
a03870ec 70314ae3 movt     r3, #0xa170
a03870f0 0020c3e5 strb     r2, [r3]
a03870f4 660000ea b        #0xa0387294
a03870f8 2a3204e3 movw     r3, #0x422a
a03870fc 70314ae3 movt     r3, #0xa170
a0387100 0030d3e5 ldrb     r3, [r3]
a0387104 7320efe6 uxtb     r2, r3
a0387108 503a07e3 movw     r3, #0x7a50
a038710c 75304ae3 movt     r3, #0xa075
a0387110 0030d3e5 ldrb     r3, [r3]
a0387114 023063e0 rsb      r3, r3, r2
a0387118 7330efe6 uxtb     r3, r3
a038711c 7320efe6 uxtb     r2, r3
a0387120 283204e3 movw     r3, #0x4228
a0387124 70314ae3 movt     r3, #0xa170
a0387128 0020c3e5 strb     r2, [r3]
a038712c ac3504e3 movw     r3, #0x45ac
a0387130 70314ae3 movt     r3, #0xa170
a0387134 0030d3e5 ldrb     r3, [r3]
a0387138 000053e3 cmp      r3, #0
a038713c 0800001a bne      #0xa0387164
a0387140 503c02e3 movw     r3, #0x2c50
a0387144 70314ae3 movt     r3, #0xa170
a0387148 0030d3e5 ldrb     r3, [r3]
a038714c 7320efe6 uxtb     r2, r3
a0387150 060000ea b        #0xa0387170
a0387154 00f020e3 nop      
a0387158 e90b21e7 str      r0, [r1, -sb, ror #23]!
a038715c fdffef3f svclo    #0xeffffd
a0387160 286b6e4e vmulmi.f64 d22, d14, d24
a0387164 2a3204e3 movw     r3, #0x422a
a0387168 70314ae3 movt     r3, #0xa170
a038716c 0020d3e5 ldrb     r2, [r3]
a0387170 293204e3 movw     r3, #0x4229
a0387174 70314ae3 movt     r3, #0xa170
a0387178 0020c3e5 strb     r2, [r3]
a038717c 2a3204e3 movw     r3, #0x422a
a0387180 70314ae3 movt     r3, #0xa170
a0387184 0030d3e5 ldrb     r3, [r3]
a0387188 7320efe6 uxtb     r2, r3
a038718c 513a07e3 movw     r3, #0x7a51
a0387190 75304ae3 movt     r3, #0xa075
a0387194 0030d3e5 ldrb     r3, [r3]
a0387198 023063e0 rsb      r3, r3, r2
a038719c 7330efe6 uxtb     r3, r3
a03871a0 7320efe6 uxtb     r2, r3
a03871a4 2b3204e3 movw     r3, #0x422b
a03871a8 70314ae3 movt     r3, #0xa170
a03871ac 0020c3e5 strb     r2, [r3]
a03871b0 283204e3 movw     r3, #0x4228
a03871b4 70314ae3 movt     r3, #0xa170
a03871b8 0030d3e5 ldrb     r3, [r3]
a03871bc 7330afe6 sxtb     r3, r3
a03871c0 000053e3 cmp      r3, #0
a03871c4 0c0000aa bge      #0xa03871fc
a03871c8 283204e3 movw     r3, #0x4228
a03871cc 70314ae3 movt     r3, #0xa170
a03871d0 0030d3e5 ldrb     r3, [r3]
a03871d4 7320efe6 uxtb     r2, r3
a03871d8 503c02e3 movw     r3, #0x2c50
a03871dc 70314ae3 movt     r3, #0xa170
a03871e0 0030d3e5 ldrb     r3, [r3]
a03871e4 033082e0 add      r3, r2, r3
a03871e8 7330efe6 uxtb     r3, r3
a03871ec 7320efe6 uxtb     r2, r3
a03871f0 283204e3 movw     r3, #0x4228
a03871f4 70314ae3 movt     r3, #0xa170
a03871f8 0020c3e5 strb     r2, [r3]
a03871fc 293204e3 movw     r3, #0x4229
a0387200 70314ae3 movt     r3, #0xa170
a0387204 0030d3e5 ldrb     r3, [r3]
a0387208 7330afe6 sxtb     r3, r3
a038720c 000053e3 cmp      r3, #0
a0387210 0c0000ca bgt      #0xa0387248
a0387214 293204e3 movw     r3, #0x4229
a0387218 70314ae3 movt     r3, #0xa170
a038721c 0030d3e5 ldrb     r3, [r3]
a0387220 7320efe6 uxtb     r2, r3
a0387224 503c02e3 movw     r3, #0x2c50
a0387228 70314ae3 movt     r3, #0xa170
a038722c 0030d3e5 ldrb     r3, [r3]
a0387230 033082e0 add      r3, r2, r3
a0387234 7330efe6 uxtb     r3, r3
a0387238 7320efe6 uxtb     r2, r3
a038723c 293204e3 movw     r3, #0x4229
a0387240 70314ae3 movt     r3, #0xa170
a0387244 0020c3e5 strb     r2, [r3]
a0387248 2b3204e3 movw     r3, #0x422b
a038724c 70314ae3 movt     r3, #0xa170
a0387250 0030d3e5 ldrb     r3, [r3]
a0387254 7330afe6 sxtb     r3, r3
a0387258 000053e3 cmp      r3, #0
a038725c 0c0000aa bge      #0xa0387294
a0387260 2b3204e3 movw     r3, #0x422b
a0387264 70314ae3 movt     r3, #0xa170
a0387268 0030d3e5 ldrb     r3, [r3]
a038726c 7320efe6 uxtb     r2, r3
a0387270 503c02e3 movw     r3, #0x2c50
a0387274 70314ae3 movt     r3, #0xa170
a0387278 0030d3e5 ldrb     r3, [r3]
a038727c 033082e0 add      r3, r2, r3
a0387280 7330efe6 uxtb     r3, r3
a0387284 7320efe6 uxtb     r2, r3
a0387288 2b3204e3 movw     r3, #0x422b
a038728c 70314ae3 movt     r3, #0xa170
a0387290 0020c3e5 strb     r2, [r3]
a0387294 68330be3 movw     r3, #0xb368
a0387298 70314ae3 movt     r3, #0xa170
a038729c 0120a0e3 mov      r2, #1
a03872a0 0020c3e5 strb     r2, [r3]
a03872a4 503c02e3 movw     r3, #0x2c50
a03872a8 70314ae3 movt     r3, #0xa170
a03872ac 0030d3e5 ldrb     r3, [r3]
a03872b0 0320a0e1 mov      r2, r3
a03872b4 69330be3 movw     r3, #0xb369
a03872b8 70314ae3 movt     r3, #0xa170
a03872bc 0030d3e5 ldrb     r3, [r3]
a03872c0 023063e0 rsb      r3, r3, r2
a03872c4 0320a0e1 mov      r2, r3
a03872c8 683b0ae3 movw     r3, #0xab68
a03872cc 70314ae3 movt     r3, #0xa170
a03872d0 002083e5 str      r2, [r3]
a03872d4 68330be3 movw     r3, #0xb368
a03872d8 70314ae3 movt     r3, #0xa170
a03872dc 0030d3e5 ldrb     r3, [r3]
a03872e0 000053e3 cmp      r3, #0
a03872e4 0400001a bne      #0xa03872fc
a03872e8 6a330be3 movw     r3, #0xb36a
a03872ec 70314ae3 movt     r3, #0xa170
a03872f0 0030d3e5 ldrb     r3, [r3]
a03872f4 000053e3 cmp      r3, #0
a03872f8 3900000a beq      #0xa03873e4
a03872fc 8c3c02e3 movw     r3, #0x2c8c
a0387300 70314ae3 movt     r3, #0xa170
a0387304 182093e5 ldr      r2, [r3, #0x18]
a0387308 543a07e3 movw     r3, #0x7a54
a038730c 75304ae3 movt     r3, #0xa075
a0387310 003093e5 ldr      r3, [r3]
a0387314 930202e0 mul      r2, r3, r2
a0387318 503c02e3 movw     r3, #0x2c50
a038731c 70314ae3 movt     r3, #0xa170
a0387320 0030d3e5 ldrb     r3, [r3]
a0387324 930202e0 mul      r2, r3, r2
a0387328 783204e3 movw     r3, #0x4278
a038732c 70314ae3 movt     r3, #0xa170
a0387330 203093e5 ldr      r3, [r3, #0x20]
a0387334 0200a0e1 mov      r0, r2
a0387338 0310a0e1 mov      r1, r3
a038733c 35fc05fa blx      #0xa0506418
a0387340 0030a0e1 mov      r3, r0
a0387344 0320a0e1 mov      r2, r3
a0387348 8c3c02e3 movw     r3, #0x2c8c
a038734c 70314ae3 movt     r3, #0xa170
a0387350 082083e5 str      r2, [r3, #8]
a0387354 8c3c02e3 movw     r3, #0x2c8c
a0387358 70314ae3 movt     r3, #0xa170
a038735c 083093e5 ldr      r3, [r3, #8]
a0387360 2324a0e1 lsr      r2, r3, #8
a0387364 8c3c02e3 movw     r3, #0x2c8c
a0387368 70314ae3 movt     r3, #0xa170
a038736c 082083e5 str      r2, [r3, #8]
a0387370 8c3c02e3 movw     r3, #0x2c8c
a0387374 70314ae3 movt     r3, #0xa170
a0387378 1c2093e5 ldr      r2, [r3, #0x1c]
a038737c 543a07e3 movw     r3, #0x7a54
a0387380 75304ae3 movt     r3, #0xa075
a0387384 003093e5 ldr      r3, [r3]
a0387388 930202e0 mul      r2, r3, r2
a038738c 503c02e3 movw     r3, #0x2c50
a0387390 70314ae3 movt     r3, #0xa170
a0387394 0030d3e5 ldrb     r3, [r3]
a0387398 930202e0 mul      r2, r3, r2
a038739c 783204e3 movw     r3, #0x4278
a03873a0 70314ae3 movt     r3, #0xa170
a03873a4 243093e5 ldr      r3, [r3, #0x24]
a03873a8 0200a0e1 mov      r0, r2
a03873ac 0310a0e1 mov      r1, r3
a03873b0 18fc05fa blx      #0xa0506418
a03873b4 0030a0e1 mov      r3, r0
a03873b8 0320a0e1 mov      r2, r3
a03873bc 8c3c02e3 movw     r3, #0x2c8c
a03873c0 70314ae3 movt     r3, #0xa170
a03873c4 0c2083e5 str      r2, [r3, #0xc]
a03873c8 8c3c02e3 movw     r3, #0x2c8c
a03873cc 70314ae3 movt     r3, #0xa170
a03873d0 0c3093e5 ldr      r3, [r3, #0xc]
a03873d4 2324a0e1 lsr      r2, r3, #8
a03873d8 8c3c02e3 movw     r3, #0x2c8c
a03873dc 70314ae3 movt     r3, #0xa170
a03873e0 0c2083e5 str      r2, [r3, #0xc]
a03873e4 1a3b0ae3 movw     r3, #0xab1a
a03873e8 70314ae3 movt     r3, #0xa170
a03873ec 0030d3e5 ldrb     r3, [r3]
a03873f0 0320a0e1 mov      r2, r3
a03873f4 e03e0ae3 movw     r3, #0xaee0
a03873f8 70314ae3 movt     r3, #0xa170
a03873fc 003093e5 ldr      r3, [r3]
a0387400 033082e0 add      r3, r2, r3
a0387404 012043e2 sub      r2, r3, #1
a0387408 c03a07e3 movw     r3, #0x7ac0
a038740c 75304ae3 movt     r3, #0xa075
a0387410 002083e5 str      r2, [r3]
a0387414 1a3b0ae3 movw     r3, #0xab1a
a0387418 70314ae3 movt     r3, #0xa170
a038741c 0020a0e3 mov      r2, #0
a0387420 0020c3e5 strb     r2, [r3]
a0387424 e03e0ae3 movw     r3, #0xaee0
a0387428 70314ae3 movt     r3, #0xa170
a038742c 0020a0e3 mov      r2, #0
a0387430 002083e5 str      r2, [r3]
a0387434 6c330be3 movw     r3, #0xb36c
a0387438 70314ae3 movt     r3, #0xa170
a038743c 0020a0e3 mov      r2, #0
a0387440 002083e5 str      r2, [r3]
a0387444 6c330be3 movw     r3, #0xb36c
a0387448 70314ae3 movt     r3, #0xa170
a038744c 002093e5 ldr      r2, [r3]
a0387450 70330be3 movw     r3, #0xb370
a0387454 70314ae3 movt     r3, #0xa170
a0387458 002083e5 str      r2, [r3]
a038745c 74330be3 movw     r3, #0xb374
a0387460 70314ae3 movt     r3, #0xa170
a0387464 0020a0e3 mov      r2, #0
a0387468 002083e5 str      r2, [r3]
a038746c 74330be3 movw     r3, #0xb374
a0387470 70314ae3 movt     r3, #0xa170
a0387474 002093e5 ldr      r2, [r3]
a0387478 78330be3 movw     r3, #0xb378
a038747c 70314ae3 movt     r3, #0xa170
a0387480 002083e5 str      r2, [r3]
a0387484 483b0ae3 movw     r3, #0xab48
a0387488 70314ae3 movt     r3, #0xa170
a038748c 0020a0e3 mov      r2, #0
a0387490 002083e5 str      r2, [r3]
a0387494 483b0ae3 movw     r3, #0xab48
a0387498 70314ae3 movt     r3, #0xa170
a038749c 002093e5 ldr      r2, [r3]
a03874a0 443b0ae3 movw     r3, #0xab44
a03874a4 70314ae3 movt     r3, #0xa170
a03874a8 002083e5 str      r2, [r3]
a03874ac 7c330be3 movw     r3, #0xb37c
a03874b0 70314ae3 movt     r3, #0xa170
a03874b4 0020a0e3 mov      r2, #0
a03874b8 042083e5 str      r2, [r3, #4]
a03874bc 7c330be3 movw     r3, #0xb37c
a03874c0 70314ae3 movt     r3, #0xa170
a03874c4 042093e5 ldr      r2, [r3, #4]
a03874c8 7c330be3 movw     r3, #0xb37c
a03874cc 70314ae3 movt     r3, #0xa170
a03874d0 002083e5 str      r2, [r3]
a03874d4 603b0ae3 movw     r3, #0xab60
a03874d8 70314ae3 movt     r3, #0xa170
a03874dc 002093e5 ldr      r2, [r3]
a03874e0 5c3b0ae3 movw     r3, #0xab5c
a03874e4 70314ae3 movt     r3, #0xa170
a03874e8 003093e5 ldr      r3, [r3]
a03874ec 022063e0 rsb      r2, r3, r2
a03874f0 2c3204e3 movw     r3, #0x422c
a03874f4 70314ae3 movt     r3, #0xa170
a03874f8 002083e5 str      r2, [r3]
a03874fc 603b0ae3 movw     r3, #0xab60
a0387500 70314ae3 movt     r3, #0xa170
a0387504 002093e5 ldr      r2, [r3]
a0387508 083304e3 movw     r3, #0x4308
a038750c 70314ae3 movt     r3, #0xa170
a0387510 003093e5 ldr      r3, [r3]
a0387514 022063e0 rsb      r2, r3, r2
a0387518 303204e3 movw     r3, #0x4230
a038751c 70314ae3 movt     r3, #0xa170
a0387520 002083e5 str      r2, [r3]
a0387524 443004e3 movw     r3, #0x4044
a0387528 70314ae3 movt     r3, #0xa170
a038752c 0930d3e5 ldrb     r3, [r3, #9]
a0387530 0320a0e1 mov      r2, r3
a0387534 84330be3 movw     r3, #0xb384
a0387538 70314ae3 movt     r3, #0xa170
a038753c 003093e5 ldr      r3, [r3]
a0387540 032082e0 add      r2, r2, r3
a0387544 603b0ae3 movw     r3, #0xab60
a0387548 70314ae3 movt     r3, #0xa170
a038754c 003093e5 ldr      r3, [r3]
a0387550 030052e1 cmp      r2, r3
a0387554 3300002a bhs      #0xa0387628
a0387558 f83a07e3 movw     r3, #0x7af8
a038755c 75304ae3 movt     r3, #0xa075
a0387560 b031d3e1 ldrh     r3, [r3, #0x10]
a0387564 000053e3 cmp      r3, #0
a0387568 1000000a beq      #0xa03875b0
a038756c 443004e3 movw     r3, #0x4044
a0387570 70314ae3 movt     r3, #0xa170
a0387574 0930d3e5 ldrb     r3, [r3, #9]
a0387578 0310a0e1 mov      r1, r3
a038757c 603b0ae3 movw     r3, #0xab60
a0387580 70314ae3 movt     r3, #0xa170
a0387584 002093e5 ldr      r2, [r3]
a0387588 84330be3 movw     r3, #0xb384
a038758c 70314ae3 movt     r3, #0xa170
a0387590 003093e5 ldr      r3, [r3]
a0387594 022063e0 rsb      r2, r3, r2
a0387598 2c3204e3 movw     r3, #0x422c
a038759c 70314ae3 movt     r3, #0xa170
a03875a0 003093e5 ldr      r3, [r3]
a03875a4 840f0fe3 movw     r0, #0xff84
a03875a8 5f004ae3 movt     r0, #0xa05f
a03875ac ce7efceb bl       #0xa02a70ec
a03875b0 603b0ae3 movw     r3, #0xab60
a03875b4 70314ae3 movt     r3, #0xa170
a03875b8 003093e5 ldr      r3, [r3]
a03875bc 7320efe6 uxtb     r2, r3
a03875c0 443004e3 movw     r3, #0x4044
a03875c4 70314ae3 movt     r3, #0xa170
a03875c8 0910d3e5 ldrb     r1, [r3, #9]
a03875cc 84330be3 movw     r3, #0xb384
a03875d0 70314ae3 movt     r3, #0xa170
a03875d4 003093e5 ldr      r3, [r3]
a03875d8 7330efe6 uxtb     r3, r3
a03875dc 033081e0 add      r3, r1, r3
a03875e0 7330efe6 uxtb     r3, r3
a03875e4 023063e0 rsb      r3, r3, r2
a03875e8 7320efe6 uxtb     r2, r3
a03875ec 88330be3 movw     r3, #0xb388
a03875f0 70314ae3 movt     r3, #0xa170
a03875f4 0030d3e5 ldrb     r3, [r3]
a03875f8 033082e0 add      r3, r2, r3
a03875fc 7320efe6 uxtb     r2, r3
a0387600 88330be3 movw     r3, #0xb388
a0387604 70314ae3 movt     r3, #0xa170
a0387608 0020c3e5 strb     r2, [r3]
a038760c 2c3204e3 movw     r3, #0x422c
a0387610 70314ae3 movt     r3, #0xa170
a0387614 002093e5 ldr      r2, [r3]
a0387618 8c330be3 movw     r3, #0xb38c
a038761c 70314ae3 movt     r3, #0xa170
a0387620 002083e5 str      r2, [r3]
a0387624 4f0000ea b        #0xa0387768
a0387628 443004e3 movw     r3, #0x4044
a038762c 70314ae3 movt     r3, #0xa170
a0387630 0930d3e5 ldrb     r3, [r3, #9]
a0387634 0320a0e1 mov      r2, r3
a0387638 84330be3 movw     r3, #0xb384
a038763c 70314ae3 movt     r3, #0xa170
a0387640 003093e5 ldr      r3, [r3]
a0387644 032082e0 add      r2, r2, r3
a0387648 603b0ae3 movw     r3, #0xab60
a038764c 70314ae3 movt     r3, #0xa170
a0387650 003093e5 ldr      r3, [r3]
a0387654 030052e1 cmp      r2, r3
a0387658 4200009a bls      #0xa0387768
a038765c f83a07e3 movw     r3, #0x7af8
a0387660 75304ae3 movt     r3, #0xa075
a0387664 b031d3e1 ldrh     r3, [r3, #0x10]
a0387668 000053e3 cmp      r3, #0
a038766c 1600000a beq      #0xa03876cc
a0387670 7c3003e3 movw     r3, #0x307c
a0387674 6f304ae3 movt     r3, #0xa06f
a0387678 081093e5 ldr      r1, [r3, #8]
a038767c 443004e3 movw     r3, #0x4044
a0387680 70314ae3 movt     r3, #0xa170
a0387684 0930d3e5 ldrb     r3, [r3, #9]
a0387688 03e0a0e1 mov      lr, r3
a038768c 603b0ae3 movw     r3, #0xab60
a0387690 70314ae3 movt     r3, #0xa170
a0387694 002093e5 ldr      r2, [r3]
a0387698 84330be3 movw     r3, #0xb384
a038769c 70314ae3 movt     r3, #0xa170
a03876a0 003093e5 ldr      r3, [r3]
a03876a4 02c063e0 rsb      ip, r3, r2
a03876a8 2c3204e3 movw     r3, #0x422c
a03876ac 70314ae3 movt     r3, #0xa170
a03876b0 003093e5 ldr      r3, [r3]
a03876b4 00308de5 str      r3, [sp]
a03876b8 ac0f0fe3 movw     r0, #0xffac
a03876bc 5f004ae3 movt     r0, #0xa05f
a03876c0 0e20a0e1 mov      r2, lr
a03876c4 0c30a0e1 mov      r3, ip
a03876c8 877efceb bl       #0xa02a70ec
a03876cc 88330be3 movw     r3, #0xb388
a03876d0 70314ae3 movt     r3, #0xa170
a03876d4 0030d3e5 ldrb     r3, [r3]
a03876d8 000053e3 cmp      r3, #0
a03876dc 0700000a beq      #0xa0387700
a03876e0 88330be3 movw     r3, #0xb388
a03876e4 70314ae3 movt     r3, #0xa170
a03876e8 0030d3e5 ldrb     r3, [r3]
a03876ec 013043e2 sub      r3, r3, #1
a03876f0 7320efe6 uxtb     r2, r3
a03876f4 88330be3 movw     r3, #0xb388
a03876f8 70314ae3 movt     r3, #0xa170
a03876fc 0020c3e5 strb     r2, [r3]
a0387700 88330be3 movw     r3, #0xb388
a0387704 70314ae3 movt     r3, #0xa170
a0387708 0030d3e5 ldrb     r3, [r3]
a038770c 000053e3 cmp      r3, #0
a0387710 1400000a beq      #0xa0387768
a0387714 f83a07e3 movw     r3, #0x7af8
a0387718 75304ae3 movt     r3, #0xa075
a038771c b431d3e1 ldrh     r3, [r3, #0x14]
a0387720 000053e3 cmp      r3, #0
a0387724 0b00000a beq      #0xa0387758
a0387728 88330be3 movw     r3, #0xb388
a038772c 70314ae3 movt     r3, #0xa170
a0387730 0030d3e5 ldrb     r3, [r3]
a0387734 0320a0e1 mov      r2, r3
a0387738 8c330be3 movw     r3, #0xb38c
a038773c 70314ae3 movt     r3, #0xa170
a0387740 003093e5 ldr      r3, [r3]
a0387744 d80f0fe3 movw     r0, #0xffd8
a0387748 5f004ae3 movt     r0, #0xa05f
a038774c 0210a0e1 mov      r1, r2
a0387750 0320a0e1 mov      r2, r3
a0387754 647efceb bl       #0xa02a70ec
a0387758 88330be3 movw     r3, #0xb388
a038775c 70314ae3 movt     r3, #0xa170
a0387760 0020a0e3 mov      r2, #0
a0387764 0020c3e5 strb     r2, [r3]
a0387768 603b0ae3 movw     r3, #0xab60
a038776c 70314ae3 movt     r3, #0xa170
a0387770 002093e5 ldr      r2, [r3]
a0387774 84330be3 movw     r3, #0xb384
a0387778 70314ae3 movt     r3, #0xa170
a038777c 002083e5 str      r2, [r3]
a0387780 da3504e3 movw     r3, #0x45da
a0387784 70314ae3 movt     r3, #0xa170
a0387788 0030d3e5 ldrb     r3, [r3]
a038778c 000053e3 cmp      r3, #0
a0387790 0a03001a bne      #0xa03883c0
a0387794 c80f0ae3 movw     r0, #0xafc8
a0387798 70014ae3 movt     r0, #0xa170
a038779c 0010a0e3 mov      r1, #0
a03877a0 8bfafceb bl       #0xa02c61d4
a03877a4 c83f0ae3 movw     r3, #0xafc8
a03877a8 70314ae3 movt     r3, #0xa170
a03877ac 203093e5 ldr      r3, [r3, #0x20]
a03877b0 010073e3 cmn      r3, #1
a03877b4 ea02000a beq      #0xa0388364
a03877b8 c83f0ae3 movw     r3, #0xafc8
a03877bc 70314ae3 movt     r3, #0xa170
a03877c0 202093e5 ldr      r2, [r3, #0x20]
a03877c4 ef3e0be3 movw     r3, #0xbeef
a03877c8 ad3e4de3 movt     r3, #0xdead
a03877cc 030052e1 cmp      r2, r3
a03877d0 e302000a beq      #0xa0388364
a03877d4 403c02e3 movw     r3, #0x2c40
a03877d8 70314ae3 movt     r3, #0xa170
a03877dc 002093e5 ldr      r2, [r3]
a03877e0 90330be3 movw     r3, #0xb390
a03877e4 70314ae3 movt     r3, #0xa170
a03877e8 003093e5 ldr      r3, [r3]
a03877ec 022063e0 rsb      r2, r3, r2
a03877f0 503c02e3 movw     r3, #0x2c50
a03877f4 70314ae3 movt     r3, #0xa170
a03877f8 0030d3e5 ldrb     r3, [r3]
a03877fc 0310a0e1 mov      r1, r3
a0387800 0130a0e1 mov      r3, r1
a0387804 8330a0e1 lsl      r3, r3, #1
a0387808 013083e0 add      r3, r3, r1
a038780c c330a0e1 asr      r3, r3, #1
a0387810 030052e1 cmp      r2, r3
a0387814 1400009a bls      #0xa038786c
a0387818 f83a07e3 movw     r3, #0x7af8
a038781c 75304ae3 movt     r3, #0xa075
a0387820 b030d3e1 ldrh     r3, [r3]
a0387824 000053e3 cmp      r3, #0
a0387828 3200000a beq      #0xa03878f8
a038782c 403c02e3 movw     r3, #0x2c40
a0387830 70314ae3 movt     r3, #0xa170
a0387834 002093e5 ldr      r2, [r3]
a0387838 90330be3 movw     r3, #0xb390
a038783c 70314ae3 movt     r3, #0xa170
a0387840 003093e5 ldr      r3, [r3]
a0387844 022063e0 rsb      r2, r3, r2
a0387848 503c02e3 movw     r3, #0x2c50
a038784c 70314ae3 movt     r3, #0xa170
a0387850 0030d3e5 ldrb     r3, [r3]
a0387854 140000e3 movw     r0, #0x14
a0387858 60004ae3 movt     r0, #0xa060
a038785c 0210a0e1 mov      r1, r2
a0387860 0320a0e1 mov      r2, r3
a0387864 207efceb bl       #0xa02a70ec
a0387868 220000ea b        #0xa03878f8
a038786c 403c02e3 movw     r3, #0x2c40
a0387870 70314ae3 movt     r3, #0xa170
a0387874 002093e5 ldr      r2, [r3]
a0387878 90330be3 movw     r3, #0xb390
a038787c 70314ae3 movt     r3, #0xa170
a0387880 003093e5 ldr      r3, [r3]
a0387884 022063e0 rsb      r2, r3, r2
a0387888 503c02e3 movw     r3, #0x2c50
a038788c 70314ae3 movt     r3, #0xa170
a0387890 0030d3e5 ldrb     r3, [r3]
a0387894 a330a0e1 lsr      r3, r3, #1
a0387898 7330efe6 uxtb     r3, r3
a038789c 030052e1 cmp      r2, r3
a03878a0 1400002a bhs      #0xa03878f8
a03878a4 f83a07e3 movw     r3, #0x7af8
a03878a8 75304ae3 movt     r3, #0xa075
a03878ac b030d3e1 ldrh     r3, [r3]
a03878b0 000053e3 cmp      r3, #0
a03878b4 0f00000a beq      #0xa03878f8
a03878b8 7c3003e3 movw     r3, #0x307c
a03878bc 6f304ae3 movt     r3, #0xa06f
a03878c0 041093e5 ldr      r1, [r3, #4]
a03878c4 403c02e3 movw     r3, #0x2c40
a03878c8 70314ae3 movt     r3, #0xa170
a03878cc 002093e5 ldr      r2, [r3]
a03878d0 90330be3 movw     r3, #0xb390
a03878d4 70314ae3 movt     r3, #0xa170
a03878d8 003093e5 ldr      r3, [r3]
a03878dc 022063e0 rsb      r2, r3, r2
a03878e0 503c02e3 movw     r3, #0x2c50
a03878e4 70314ae3 movt     r3, #0xa170
a03878e8 0030d3e5 ldrb     r3, [r3]
a03878ec 440000e3 movw     r0, #0x44
a03878f0 60004ae3 movt     r0, #0xa060
a03878f4 fc7dfceb bl       #0xa02a70ec
a03878f8 b93f0ae3 movw     r3, #0xafb9
a03878fc 70314ae3 movt     r3, #0xa170
a0387900 0020a0e3 mov      r2, #0
a0387904 0020c3e5 strb     r2, [r3]
a0387908 b93f0ae3 movw     r3, #0xafb9
a038790c 70314ae3 movt     r3, #0xa170
a0387910 0020d3e5 ldrb     r2, [r3]
a0387914 b83f0ae3 movw     r3, #0xafb8
a0387918 70314ae3 movt     r3, #0xa170
a038791c 0020c3e5 strb     r2, [r3]
a0387920 c83f0ae3 movw     r3, #0xafc8
a0387924 70314ae3 movt     r3, #0xa170
a0387928 203093e5 ldr      r3, [r3, #0x20]
a038792c 7320efe6 uxtb     r2, r3
a0387930 c03f0ae3 movw     r3, #0xafc0
a0387934 70314ae3 movt     r3, #0xa170
a0387938 002083e5 str      r2, [r3]
a038793c c83f0ae3 movw     r3, #0xafc8
a0387940 70314ae3 movt     r3, #0xa170
a0387944 203093e5 ldr      r3, [r3, #0x20]
a0387948 7330ffe6 uxth     r3, r3
a038794c 013c03e2 and      r3, r3, #0x100
a0387950 7320ffe6 uxth     r2, r3
a0387954 c43f0ae3 movw     r3, #0xafc4
a0387958 70314ae3 movt     r3, #0xa170
a038795c b020c3e1 strh     r2, [r3]
a0387960 f83a07e3 movw     r3, #0x7af8
a0387964 75304ae3 movt     r3, #0xa075
a0387968 be31d3e1 ldrh     r3, [r3, #0x1e]
a038796c 013003e2 and      r3, r3, #1
a0387970 000053e3 cmp      r3, #0
a0387974 0b00000a beq      #0xa03879a8
a0387978 c83f0ae3 movw     r3, #0xafc8
a038797c 70314ae3 movt     r3, #0xa170
a0387980 201093e5 ldr      r1, [r3, #0x20]
a0387984 94330be3 movw     r3, #0xb394
a0387988 70314ae3 movt     r3, #0xa170
a038798c 002093e5 ldr      r2, [r3]
a0387990 2c3204e3 movw     r3, #0x422c
a0387994 70314ae3 movt     r3, #0xa170
a0387998 003093e5 ldr      r3, [r3]
a038799c 780000e3 movw     r0, #0x78
a03879a0 60004ae3 movt     r0, #0xa060
a03879a4 d07dfceb bl       #0xa02a70ec
a03879a8 d73504e3 movw     r3, #0x45d7
a03879ac 70314ae3 movt     r3, #0xa170
a03879b0 0030d3e5 ldrb     r3, [r3]
a03879b4 000053e3 cmp      r3, #0
a03879b8 0900001a bne      #0xa03879e4
a03879bc d93504e3 movw     r3, #0x45d9
a03879c0 70314ae3 movt     r3, #0xa170
a03879c4 0030d3e5 ldrb     r3, [r3]
a03879c8 000053e3 cmp      r3, #0
a03879cc 0400001a bne      #0xa03879e4
a03879d0 dc3504e3 movw     r3, #0x45dc
a03879d4 70314ae3 movt     r3, #0xa170
a03879d8 0030d3e5 ldrb     r3, [r3]
a03879dc 000053e3 cmp      r3, #0
a03879e0 0100000a beq      #0xa03879ec
a03879e4 0130a0e3 mov      r3, #1
a03879e8 000000ea b        #0xa03879f0
a03879ec 0030a0e3 mov      r3, #0
a03879f0 7320efe6 uxtb     r2, r3
a03879f4 d53504e3 movw     r3, #0x45d5
a03879f8 70314ae3 movt     r3, #0xa170
a03879fc 0020c3e5 strb     r2, [r3]
a0387a00 c43f0ae3 movw     r3, #0xafc4
a0387a04 70314ae3 movt     r3, #0xa170
a0387a08 b030d3e1 ldrh     r3, [r3]
a0387a0c 000053e3 cmp      r3, #0
a0387a10 2400001a bne      #0xa0387aa8
a0387a14 d43504e3 movw     r3, #0x45d4
a0387a18 70314ae3 movt     r3, #0xa170
a0387a1c 0030d3e5 ldrb     r3, [r3]
a0387a20 000053e3 cmp      r3, #0
a0387a24 1f00001a bne      #0xa0387aa8
a0387a28 d53504e3 movw     r3, #0x45d5
a0387a2c 70314ae3 movt     r3, #0xa170
a0387a30 0030d3e5 ldrb     r3, [r3]
a0387a34 000053e3 cmp      r3, #0
a0387a38 1a00000a beq      #0xa0387aa8
a0387a3c f83a07e3 movw     r3, #0x7af8
a0387a40 75304ae3 movt     r3, #0xa075
a0387a44 b030d3e1 ldrh     r3, [r3]
a0387a48 000053e3 cmp      r3, #0
a0387a4c 1500000a beq      #0xa0387aa8
a0387a50 c03f0ae3 movw     r3, #0xafc0
a0387a54 70314ae3 movt     r3, #0xa170
a0387a58 002093e5 ldr      r2, [r3]
a0387a5c c43f0ae3 movw     r3, #0xafc4
a0387a60 70314ae3 movt     r3, #0xa170
a0387a64 b030d3e1 ldrh     r3, [r3]
a0387a68 03e0a0e1 mov      lr, r3
a0387a6c 513a07e3 movw     r3, #0x7a51
a0387a70 75304ae3 movt     r3, #0xa075
a0387a74 0030d3e5 ldrb     r3, [r3]
a0387a78 03c0a0e1 mov      ip, r3
a0387a7c 2b3204e3 movw     r3, #0x422b
a0387a80 70314ae3 movt     r3, #0xa170
a0387a84 0030d3e5 ldrb     r3, [r3]
a0387a88 7330afe6 sxtb     r3, r3
a0387a8c 00308de5 str      r3, [sp]
a0387a90 cc0000e3 movw     r0, #0xcc
a0387a94 60004ae3 movt     r0, #0xa060
a0387a98 0210a0e1 mov      r1, r2
a0387a9c 0e20a0e1 mov      r2, lr
a0387aa0 0c30a0e1 mov      r3, ip
a0387aa4 907dfceb bl       #0xa02a70ec
a0387aa8 f83a07e3 movw     r3, #0x7af8
a0387aac 75304ae3 movt     r3, #0xa075
a0387ab0 b030d3e1 ldrh     r3, [r3]
a0387ab4 023003e2 and      r3, r3, #2
a0387ab8 000053e3 cmp      r3, #0
a0387abc 2e00000a beq      #0xa0387b7c
a0387ac0 c03f0ae3 movw     r3, #0xafc0
a0387ac4 70314ae3 movt     r3, #0xa170
a0387ac8 002093e5 ldr      r2, [r3]
a0387acc 983f0ae3 movw     r3, #0xaf98
a0387ad0 70314ae3 movt     r3, #0xa170
a0387ad4 0230d3e7 ldrb     r3, [r3, r2]
a0387ad8 0340a0e1 mov      r4, r3
a0387adc 983f0ae3 movw     r3, #0xaf98
a0387ae0 70314ae3 movt     r3, #0xa170
a0387ae4 0030d3e5 ldrb     r3, [r3]
a0387ae8 03e0a0e1 mov      lr, r3
a0387aec c03f0ae3 movw     r3, #0xafc0
a0387af0 70314ae3 movt     r3, #0xa170
a0387af4 00c093e5 ldr      ip, [r3]
a0387af8 283204e3 movw     r3, #0x4228
a0387afc 70314ae3 movt     r3, #0xa170
a0387b00 0030d3e5 ldrb     r3, [r3]
a0387b04 7310afe6 sxtb     r1, r3
a0387b08 443004e3 movw     r3, #0x4044
a0387b0c 70314ae3 movt     r3, #0xa170
a0387b10 0930d3e5 ldrb     r3, [r3, #9]
a0387b14 0320a0e1 mov      r2, r3
a0387b18 c03f0ae3 movw     r3, #0xafc0
a0387b1c 70314ae3 movt     r3, #0xa170
a0387b20 003093e5 ldr      r3, [r3]
a0387b24 930203e0 mul      r3, r3, r2
a0387b28 031081e0 add      r1, r1, r3
a0387b2c c43f0ae3 movw     r3, #0xafc4
a0387b30 70314ae3 movt     r3, #0xa170
a0387b34 b030d3e1 ldrh     r3, [r3]
a0387b38 0300a0e1 mov      r0, r3
a0387b3c e43e0ae3 movw     r3, #0xaee4
a0387b40 70314ae3 movt     r3, #0xa170
a0387b44 002093e5 ldr      r2, [r3]
a0387b48 fc3e0ae3 movw     r3, #0xaefc
a0387b4c 70314ae3 movt     r3, #0xa170
a0387b50 003093e5 ldr      r3, [r3]
a0387b54 00108de5 str      r1, [sp]
a0387b58 04008de5 str      r0, [sp, #4]
a0387b5c 08208de5 str      r2, [sp, #8]
a0387b60 0c308de5 str      r3, [sp, #0xc]
a0387b64 300100e3 movw     r0, #0x130
a0387b68 60004ae3 movt     r0, #0xa060
a0387b6c 0410a0e1 mov      r1, r4
a0387b70 0e20a0e1 mov      r2, lr
a0387b74 0c30a0e1 mov      r3, ip
a0387b78 5b7dfceb bl       #0xa02a70ec
a0387b7c f83a07e3 movw     r3, #0x7af8
a0387b80 75304ae3 movt     r3, #0xa075
a0387b84 b030d3e1 ldrh     r3, [r3]
a0387b88 000053e3 cmp      r3, #0
a0387b8c 3e00000a beq      #0xa0387c8c
a0387b90 c03f0ae3 movw     r3, #0xafc0
a0387b94 70314ae3 movt     r3, #0xa170
a0387b98 002093e5 ldr      r2, [r3]
a0387b9c 983f0ae3 movw     r3, #0xaf98
a0387ba0 70314ae3 movt     r3, #0xa170
a0387ba4 0230d3e7 ldrb     r3, [r3, r2]
a0387ba8 0310a0e1 mov      r1, r3
a0387bac 503c02e3 movw     r3, #0x2c50
a0387bb0 70314ae3 movt     r3, #0xa170
a0387bb4 0030d3e5 ldrb     r3, [r3]
a0387bb8 0320a0e1 mov      r2, r3
a0387bbc 0230a0e1 mov      r3, r2
a0387bc0 8330a0e1 lsl      r3, r3, #1
a0387bc4 023083e0 add      r3, r3, r2
a0387bc8 c330a0e1 asr      r3, r3, #1
a0387bcc 030051e1 cmp      r1, r3
a0387bd0 2d0000da ble      #0xa0387c8c
a0387bd4 7c3003e3 movw     r3, #0x307c
a0387bd8 6f304ae3 movt     r3, #0xa06f
a0387bdc 04c093e5 ldr      ip, [r3, #4]
a0387be0 c03f0ae3 movw     r3, #0xafc0
a0387be4 70314ae3 movt     r3, #0xa170
a0387be8 002093e5 ldr      r2, [r3]
a0387bec 983f0ae3 movw     r3, #0xaf98
a0387bf0 70314ae3 movt     r3, #0xa170
a0387bf4 0230d3e7 ldrb     r3, [r3, r2]
a0387bf8 0340a0e1 mov      r4, r3
a0387bfc 983f0ae3 movw     r3, #0xaf98
a0387c00 70314ae3 movt     r3, #0xa170
a0387c04 0030d3e5 ldrb     r3, [r3]
a0387c08 03e0a0e1 mov      lr, r3
a0387c0c c03f0ae3 movw     r3, #0xafc0
a0387c10 70314ae3 movt     r3, #0xa170
a0387c14 000093e5 ldr      r0, [r3]
a0387c18 283204e3 movw     r3, #0x4228
a0387c1c 70314ae3 movt     r3, #0xa170
a0387c20 0030d3e5 ldrb     r3, [r3]
a0387c24 7310afe6 sxtb     r1, r3
a0387c28 443004e3 movw     r3, #0x4044
a0387c2c 70314ae3 movt     r3, #0xa170
a0387c30 0930d3e5 ldrb     r3, [r3, #9]
a0387c34 0320a0e1 mov      r2, r3
a0387c38 c03f0ae3 movw     r3, #0xafc0
a0387c3c 70314ae3 movt     r3, #0xa170
a0387c40 003093e5 ldr      r3, [r3]
a0387c44 930203e0 mul      r3, r3, r2
a0387c48 031081e0 add      r1, r1, r3
a0387c4c e43e0ae3 movw     r3, #0xaee4
a0387c50 70314ae3 movt     r3, #0xa170
a0387c54 002093e5 ldr      r2, [r3]
a0387c58 fc3e0ae3 movw     r3, #0xaefc
a0387c5c 70314ae3 movt     r3, #0xa170
a0387c60 003093e5 ldr      r3, [r3]
a0387c64 00008de5 str      r0, [sp]
a0387c68 04108de5 str      r1, [sp, #4]
a0387c6c 08208de5 str      r2, [sp, #8]
a0387c70 0c308de5 str      r3, [sp, #0xc]
a0387c74 8c0100e3 movw     r0, #0x18c
a0387c78 60004ae3 movt     r0, #0xa060
a0387c7c 0c10a0e1 mov      r1, ip
a0387c80 0420a0e1 mov      r2, r4
a0387c84 0e30a0e1 mov      r3, lr
a0387c88 177dfceb bl       #0xa02a70ec
a0387c8c c82f0ae3 movw     r2, #0xafc8
a0387c90 70214ae3 movt     r2, #0xa170
a0387c94 ef3e0be3 movw     r3, #0xbeef
a0387c98 ad3e4de3 movt     r3, #0xdead
a0387c9c 203082e5 str      r3, [r2, #0x20]
a0387ca0 c80f0ae3 movw     r0, #0xafc8
a0387ca4 70014ae3 movt     r0, #0xa170
a0387ca8 0110a0e3 mov      r1, #1
a0387cac 48f9fceb bl       #0xa02c61d4
a0387cb0 403c02e3 movw     r3, #0x2c40
a0387cb4 70314ae3 movt     r3, #0xa170
a0387cb8 002093e5 ldr      r2, [r3]
a0387cbc 90330be3 movw     r3, #0xb390
a0387cc0 70314ae3 movt     r3, #0xa170
a0387cc4 002083e5 str      r2, [r3]
a0387cc8 98330be3 movw     r3, #0xb398
a0387ccc 70314ae3 movt     r3, #0xa170
a0387cd0 0030d3e5 ldrb     r3, [r3]
a0387cd4 000053e3 cmp      r3, #0
a0387cd8 a001000a beq      #0xa0388360
a0387cdc c03f0ae3 movw     r3, #0xafc0
a0387ce0 70314ae3 movt     r3, #0xa170
a0387ce4 002093e5 ldr      r2, [r3]
a0387ce8 9c330be3 movw     r3, #0xb39c
a0387cec 70314ae3 movt     r3, #0xa170
a0387cf0 002083e5 str      r2, [r3]
a0387cf4 9c330be3 movw     r3, #0xb39c
a0387cf8 70314ae3 movt     r3, #0xa170
a0387cfc 003093e5 ldr      r3, [r3]
a0387d00 a0230be3 movw     r2, #0xb3a0
a0387d04 70214ae3 movt     r2, #0xa170
a0387d08 0310a0e1 mov      r1, r3
a0387d0c 8131a0e1 lsl      r3, r1, #3
a0387d10 0310a0e1 mov      r1, r3
a0387d14 0131a0e1 lsl      r3, r1, #2
a0387d18 033061e0 rsb      r3, r1, r3
a0387d1c 033082e0 add      r3, r2, r3
a0387d20 043093e5 ldr      r3, [r3, #4]
a0387d24 0320a0e1 mov      r2, r3
a0387d28 d03204e3 movw     r3, #0x42d0
a0387d2c 70314ae3 movt     r3, #0xa170
a0387d30 003093e5 ldr      r3, [r3]
a0387d34 022063e0 rsb      r2, r3, r2
a0387d38 a03204e3 movw     r3, #0x42a0
a0387d3c 70314ae3 movt     r3, #0xa170
a0387d40 002083e5 str      r2, [r3]
a0387d44 9c330be3 movw     r3, #0xb39c
a0387d48 70314ae3 movt     r3, #0xa170
a0387d4c 003093e5 ldr      r3, [r3]
a0387d50 a0230be3 movw     r2, #0xb3a0
a0387d54 70214ae3 movt     r2, #0xa170
a0387d58 0310a0e1 mov      r1, r3
a0387d5c 8131a0e1 lsl      r3, r1, #3
a0387d60 0310a0e1 mov      r1, r3
a0387d64 0131a0e1 lsl      r3, r1, #2
a0387d68 033061e0 rsb      r3, r1, r3
a0387d6c 033082e0 add      r3, r2, r3
a0387d70 083083e2 add      r3, r3, #8
a0387d74 003093e5 ldr      r3, [r3]
a0387d78 0320a0e1 mov      r2, r3
a0387d7c d03204e3 movw     r3, #0x42d0
a0387d80 70314ae3 movt     r3, #0xa170
a0387d84 043093e5 ldr      r3, [r3, #4]
a0387d88 022063e0 rsb      r2, r3, r2
a0387d8c a03204e3 movw     r3, #0x42a0
a0387d90 70314ae3 movt     r3, #0xa170
a0387d94 042083e5 str      r2, [r3, #4]
a0387d98 a03204e3 movw     r3, #0x42a0
a0387d9c 70314ae3 movt     r3, #0xa170
a0387da0 043093e5 ldr      r3, [r3, #4]
a0387da4 000053e3 cmp      r3, #0
a0387da8 0e0000da ble      #0xa0387de8
a0387dac 9c330be3 movw     r3, #0xb39c
a0387db0 70314ae3 movt     r3, #0xa170
a0387db4 003093e5 ldr      r3, [r3]
a0387db8 a0230be3 movw     r2, #0xb3a0
a0387dbc 70214ae3 movt     r2, #0xa170
a0387dc0 0310a0e1 mov      r1, r3
a0387dc4 8131a0e1 lsl      r3, r1, #3
a0387dc8 0310a0e1 mov      r1, r3
a0387dcc 0131a0e1 lsl      r3, r1, #2
a0387dd0 033061e0 rsb      r3, r1, r3
a0387dd4 033082e0 add      r3, r2, r3
a0387dd8 103083e2 add      r3, r3, #0x10
a0387ddc 043093e5 ldr      r3, [r3, #4]
a0387de0 000053e3 cmp      r3, #0
a0387de4 130000ba blt      #0xa0387e38
a0387de8 a03204e3 movw     r3, #0x42a0
a0387dec 70314ae3 movt     r3, #0xa170
a0387df0 043093e5 ldr      r3, [r3, #4]
a0387df4 000053e3 cmp      r3, #0
a0387df8 2c0000aa bge      #0xa0387eb0
a0387dfc 9c330be3 movw     r3, #0xb39c
a0387e00 70314ae3 movt     r3, #0xa170
a0387e04 003093e5 ldr      r3, [r3]
a0387e08 a0230be3 movw     r2, #0xb3a0
a0387e0c 70214ae3 movt     r2, #0xa170
a0387e10 0310a0e1 mov      r1, r3
a0387e14 8131a0e1 lsl      r3, r1, #3
a0387e18 0310a0e1 mov      r1, r3
a0387e1c 0131a0e1 lsl      r3, r1, #2
a0387e20 033061e0 rsb      r3, r1, r3
a0387e24 033082e0 add      r3, r2, r3
a0387e28 103083e2 add      r3, r3, #0x10
a0387e2c 043093e5 ldr      r3, [r3, #4]
a0387e30 000053e3 cmp      r3, #0
a0387e34 1d0000da ble      #0xa0387eb0
a0387e38 b93c02e3 movw     r3, #0x2cb9
a0387e3c 70314ae3 movt     r3, #0xa170
a0387e40 0030d3e5 ldrb     r3, [r3]
a0387e44 000053e3 cmp      r3, #0
a0387e48 1400001a bne      #0xa0387ea0
a0387e4c a03204e3 movw     r3, #0x42a0
a0387e50 70314ae3 movt     r3, #0xa170
a0387e54 04c093e5 ldr      ip, [r3, #4]
a0387e58 9c330be3 movw     r3, #0xb39c
a0387e5c 70314ae3 movt     r3, #0xa170
a0387e60 003093e5 ldr      r3, [r3]
a0387e64 a0230be3 movw     r2, #0xb3a0
a0387e68 70214ae3 movt     r2, #0xa170
a0387e6c 0310a0e1 mov      r1, r3
a0387e70 8131a0e1 lsl      r3, r1, #3
a0387e74 0310a0e1 mov      r1, r3
a0387e78 0131a0e1 lsl      r3, r1, #2
a0387e7c 033061e0 rsb      r3, r1, r3
a0387e80 033082e0 add      r3, r2, r3
a0387e84 103083e2 add      r3, r3, #0x10
a0387e88 043093e5 ldr      r3, [r3, #4]
a0387e8c e80100e3 movw     r0, #0x1e8
a0387e90 60004ae3 movt     r0, #0xa060
a0387e94 0c10a0e1 mov      r1, ip
a0387e98 0320a0e1 mov      r2, r3
a0387e9c 927cfceb bl       #0xa02a70ec
a0387ea0 b93c02e3 movw     r3, #0x2cb9
a0387ea4 70314ae3 movt     r3, #0xa170
a0387ea8 0120a0e3 mov      r2, #1
a0387eac 0020c3e5 strb     r2, [r3]
a0387eb0 b93c02e3 movw     r3, #0x2cb9
a0387eb4 70314ae3 movt     r3, #0xa170
a0387eb8 0030d3e5 ldrb     r3, [r3]
a0387ebc 000053e3 cmp      r3, #0
a0387ec0 0400001a bne      #0xa0387ed8
a0387ec4 ba3c02e3 movw     r3, #0x2cba
a0387ec8 70314ae3 movt     r3, #0xa170
a0387ecc 0030d3e5 ldrb     r3, [r3]
a0387ed0 000053e3 cmp      r3, #0
a0387ed4 0600000a beq      #0xa0387ef4
a0387ed8 a03204e3 movw     r3, #0x42a0
a0387edc 70314ae3 movt     r3, #0xa170
a0387ee0 043093e5 ldr      r3, [r3, #4]
a0387ee4 002063e2 rsb      r2, r3, #0
a0387ee8 a03204e3 movw     r3, #0x42a0
a0387eec 70314ae3 movt     r3, #0xa170
a0387ef0 042083e5 str      r2, [r3, #4]
a0387ef4 283104e3 movw     r3, #0x4128
a0387ef8 70314ae3 movt     r3, #0xa170
a0387efc 067ad3ed vldr     s15, [r3, #0x18]
a0387f00 fa7a9fed vldr     s14, [pc, #0x3e8]
a0387f04 877a67ee vmul.f32 s15, s15, s14
a0387f08 e70af7ee vcvt.f64.f32 d16, s15
a0387f0c 001bf6ee vmov.f64 d17, #5.000000e-01
a0387f10 a10b70ee vadd.f64 d16, d16, d17
a0387f14 607bb0ee vmov.f64 d7, d16
a0387f18 c77bfcee vcvt.u32.f64 s15, d7
a0387f1c 900a17ee vmov     r0, s15
a0387f20 c43504e3 movw     r3, #0x45c4
a0387f24 70314ae3 movt     r3, #0xa170
a0387f28 b030d3e1 ldrh     r3, [r3]
a0387f2c 0320a0e1 mov      r2, r3
a0387f30 a03204e3 movw     r3, #0x42a0
a0387f34 70314ae3 movt     r3, #0xa170
a0387f38 043093e5 ldr      r3, [r3, #4]
a0387f3c 4338a0e1 asr      r3, r3, #0x10
a0387f40 0310a0e1 mov      r1, r3
a0387f44 c43004e3 movw     r3, #0x40c4
a0387f48 70314ae3 movt     r3, #0xa170
a0387f4c 003093e5 ldr      r3, [r3]
a0387f50 033081e0 add      r3, r1, r3
a0387f54 033082e0 add      r3, r2, r3
a0387f58 930002e0 mul      r2, r3, r0
a0387f5c 833e0de3 movw     r3, #0xde83
a0387f60 1b3344e3 movt     r3, #0x431b
a0387f64 922383e0 umull    r2, r3, r2, r3
a0387f68 2339a0e1 lsr      r3, r3, #0x12
a0387f6c 7320efe6 uxtb     r2, r3
a0387f70 a0390be3 movw     r3, #0xb9a0
a0387f74 70314ae3 movt     r3, #0xa170
a0387f78 0020c3e5 strb     r2, [r3]
a0387f7c f83a07e3 movw     r3, #0x7af8
a0387f80 75304ae3 movt     r3, #0xa075
a0387f84 b032d3e1 ldrh     r3, [r3, #0x20]
a0387f88 000053e3 cmp      r3, #0
a0387f8c 0b00000a beq      #0xa0387fc0
a0387f90 a03204e3 movw     r3, #0x42a0
a0387f94 70314ae3 movt     r3, #0xa170
a0387f98 001093e5 ldr      r1, [r3]
a0387f9c a03204e3 movw     r3, #0x42a0
a0387fa0 70314ae3 movt     r3, #0xa170
a0387fa4 002093e5 ldr      r2, [r3]
a0387fa8 9c330be3 movw     r3, #0xb39c
a0387fac 70314ae3 movt     r3, #0xa170
a0387fb0 003093e5 ldr      r3, [r3]
a0387fb4 080200e3 movw     r0, #0x208
a0387fb8 60004ae3 movt     r0, #0xa060
a0387fbc 4a7cfceb bl       #0xa02a70ec
a0387fc0 a0390be3 movw     r3, #0xb9a0
a0387fc4 70314ae3 movt     r3, #0xa170
a0387fc8 0020d3e5 ldrb     r2, [r3]
a0387fcc a1390be3 movw     r3, #0xb9a1
a0387fd0 70314ae3 movt     r3, #0xa170
a0387fd4 0030d3e5 ldrb     r3, [r3]
a0387fd8 030052e1 cmp      r2, r3
a0387fdc 0500002a bhs      #0xa0387ff8
a0387fe0 a1390be3 movw     r3, #0xb9a1
a0387fe4 70314ae3 movt     r3, #0xa170
a0387fe8 0020d3e5 ldrb     r2, [r3]
a0387fec a0390be3 movw     r3, #0xb9a0
a0387ff0 70314ae3 movt     r3, #0xa170
a0387ff4 0020c3e5 strb     r2, [r3]
a0387ff8 a0390be3 movw     r3, #0xb9a0
a0387ffc 70314ae3 movt     r3, #0xa170
a0388000 0030d3e5 ldrb     r3, [r3]
a0388004 0320a0e1 mov      r2, r3
a0388008 c03004e3 movw     r3, #0x40c0
a038800c 70314ae3 movt     r3, #0xa170
a0388010 003093e5 ldr      r3, [r3]
a0388014 032082e0 add      r2, r2, r3
a0388018 643b0ae3 movw     r3, #0xab64
a038801c 70314ae3 movt     r3, #0xa170
a0388020 002083e5 str      r2, [r3]
a0388024 263204e3 movw     r3, #0x4226
a0388028 70314ae3 movt     r3, #0xa170
a038802c 0030d3e5 ldrb     r3, [r3]
a0388030 ff0053e3 cmp      r3, #0xff
a0388034 0a00001a bne      #0xa0388064
a0388038 a03204e3 movw     r3, #0x42a0
a038803c 70314ae3 movt     r3, #0xa170
a0388040 002093e5 ldr      r2, [r3]
a0388044 243204e3 movw     r3, #0x4224
a0388048 70314ae3 movt     r3, #0xa170
a038804c 0030d3e5 ldrb     r3, [r3]
a0388050 930202e0 mul      r2, r3, r2
a0388054 a03204e3 movw     r3, #0x42a0
a0388058 70314ae3 movt     r3, #0xa170
a038805c 002083e5 str      r2, [r3]
a0388060 090000ea b        #0xa038808c
a0388064 a03204e3 movw     r3, #0x42a0
a0388068 70314ae3 movt     r3, #0xa170
a038806c 002093e5 ldr      r2, [r3]
a0388070 263204e3 movw     r3, #0x4226
a0388074 70314ae3 movt     r3, #0xa170
a0388078 0030d3e5 ldrb     r3, [r3]
a038807c 1223a0e1 lsl      r2, r2, r3
a0388080 a03204e3 movw     r3, #0x42a0
a0388084 70314ae3 movt     r3, #0xa170
a0388088 002083e5 str      r2, [r3]
a038808c 273204e3 movw     r3, #0x4227
a0388090 70314ae3 movt     r3, #0xa170
a0388094 0030d3e5 ldrb     r3, [r3]
a0388098 ff0053e3 cmp      r3, #0xff
a038809c 0a00001a bne      #0xa03880cc
a03880a0 a03204e3 movw     r3, #0x42a0
a03880a4 70314ae3 movt     r3, #0xa170
a03880a8 042093e5 ldr      r2, [r3, #4]
a03880ac 253204e3 movw     r3, #0x4225
a03880b0 70314ae3 movt     r3, #0xa170
a03880b4 0030d3e5 ldrb     r3, [r3]
a03880b8 930202e0 mul      r2, r3, r2
a03880bc a03204e3 movw     r3, #0x42a0
a03880c0 70314ae3 movt     r3, #0xa170
a03880c4 042083e5 str      r2, [r3, #4]
a03880c8 090000ea b        #0xa03880f4
a03880cc a03204e3 movw     r3, #0x42a0
a03880d0 70314ae3 movt     r3, #0xa170
a03880d4 042093e5 ldr      r2, [r3, #4]
a03880d8 273204e3 movw     r3, #0x4227
a03880dc 70314ae3 movt     r3, #0xa170
a03880e0 0030d3e5 ldrb     r3, [r3]
a03880e4 1223a0e1 lsl      r2, r2, r3
a03880e8 a03204e3 movw     r3, #0x42a0
a03880ec 70314ae3 movt     r3, #0xa170
a03880f0 042083e5 str      r2, [r3, #4]
a03880f4 9c330be3 movw     r3, #0xb39c
a03880f8 70314ae3 movt     r3, #0xa170
a03880fc 003093e5 ldr      r3, [r3]
a0388100 a0230be3 movw     r2, #0xb3a0
a0388104 70214ae3 movt     r2, #0xa170
a0388108 0310a0e1 mov      r1, r3
a038810c 8131a0e1 lsl      r3, r1, #3
a0388110 0310a0e1 mov      r1, r3
a0388114 0131a0e1 lsl      r3, r1, #2
a0388118 033061e0 rsb      r3, r1, r3
a038811c 033082e0 add      r3, r2, r3
a0388120 083083e2 add      r3, r3, #8
a0388124 042093e5 ldr      r2, [r3, #4]
a0388128 e43e0ae3 movw     r3, #0xaee4
a038812c 70314ae3 movt     r3, #0xa170
a0388130 002083e5 str      r2, [r3]
a0388134 9c330be3 movw     r3, #0xb39c
a0388138 70314ae3 movt     r3, #0xa170
a038813c 003093e5 ldr      r3, [r3]
a0388140 a0230be3 movw     r2, #0xb3a0
a0388144 70214ae3 movt     r2, #0xa170
a0388148 0310a0e1 mov      r1, r3
a038814c 8131a0e1 lsl      r3, r1, #3
a0388150 0310a0e1 mov      r1, r3
a0388154 0131a0e1 lsl      r3, r1, #2
a0388158 033061e0 rsb      r3, r1, r3
a038815c 033082e0 add      r3, r2, r3
a0388160 103083e2 add      r3, r3, #0x10
a0388164 002093e5 ldr      r2, [r3]
a0388168 fc3e0ae3 movw     r3, #0xaefc
a038816c 70314ae3 movt     r3, #0xa170
a0388170 002083e5 str      r2, [r3]
a0388174 da3504e3 movw     r3, #0x45da
a0388178 70314ae3 movt     r3, #0xa170
a038817c 0030d3e5 ldrb     r3, [r3]
a0388180 000053e3 cmp      r3, #0
a0388184 7500001a bne      #0xa0388360
a0388188 643204e3 movw     r3, #0x4264
a038818c 70314ae3 movt     r3, #0xa170
a0388190 002093e5 ldr      r2, [r3]
a0388194 243b0ae3 movw     r3, #0xab24
a0388198 70314ae3 movt     r3, #0xa170
a038819c 003093e5 ldr      r3, [r3]
a03881a0 930202e0 mul      r2, r3, r2
a03881a4 283104e3 movw     r3, #0x4128
a03881a8 70314ae3 movt     r3, #0xa170
a03881ac 0c3093e5 ldr      r3, [r3, #0xc]
a03881b0 0200a0e1 mov      r0, r2
a03881b4 0310a0e1 mov      r1, r3
a03881b8 96f805fa blx      #0xa0506418
a03881bc 0030a0e1 mov      r3, r0
a03881c0 2334a0e1 lsr      r3, r3, #8
a03881c4 0320a0e1 mov      r2, r3
a03881c8 2c3f0ae3 movw     r3, #0xaf2c
a03881cc 70314ae3 movt     r3, #0xa170
a03881d0 002083e5 str      r2, [r3]
a03881d4 2c3f0ae3 movw     r3, #0xaf2c
a03881d8 70314ae3 movt     r3, #0xa170
a03881dc 003093e5 ldr      r3, [r3]
a03881e0 a32fa0e1 lsr      r2, r3, #0x1f
a03881e4 033082e0 add      r3, r2, r3
a03881e8 c330a0e1 asr      r3, r3, #1
a03881ec 0320a0e1 mov      r2, r3
a03881f0 2c3f0ae3 movw     r3, #0xaf2c
a03881f4 70314ae3 movt     r3, #0xa170
a03881f8 002083e5 str      r2, [r3]
a03881fc a0390be3 movw     r3, #0xb9a0
a0388200 70314ae3 movt     r3, #0xa170
a0388204 0030d3e5 ldrb     r3, [r3]
a0388208 0320a0e1 mov      r2, r3
a038820c 2c3f0ae3 movw     r3, #0xaf2c
a0388210 70314ae3 movt     r3, #0xa170
a0388214 003093e5 ldr      r3, [r3]
a0388218 032082e0 add      r2, r2, r3
a038821c 2c3f0ae3 movw     r3, #0xaf2c
a0388220 70314ae3 movt     r3, #0xa170
a0388224 002083e5 str      r2, [r3]
a0388228 2c3f0ae3 movw     r3, #0xaf2c
a038822c 70314ae3 movt     r3, #0xa170
a0388230 003093e5 ldr      r3, [r3]
a0388234 0320a0e1 mov      r2, r3
a0388238 c03004e3 movw     r3, #0x40c0
a038823c 70314ae3 movt     r3, #0xa170
a0388240 003093e5 ldr      r3, [r3]
a0388244 033082e0 add      r3, r2, r3
a0388248 0320a0e1 mov      r2, r3
a038824c 2c3f0ae3 movw     r3, #0xaf2c
a0388250 70314ae3 movt     r3, #0xa170
a0388254 002083e5 str      r2, [r3]
a0388258 503a07e3 movw     r3, #0x7a50
a038825c 75304ae3 movt     r3, #0xa075
a0388260 0030d3e5 ldrb     r3, [r3]
a0388264 0320a0e1 mov      r2, r3
a0388268 2c3f0ae3 movw     r3, #0xaf2c
a038826c 70314ae3 movt     r3, #0xa170
a0388270 003093e5 ldr      r3, [r3]
a0388274 032082e0 add      r2, r2, r3
a0388278 2a3204e3 movw     r3, #0x422a
a038827c 70314ae3 movt     r3, #0xa170
a0388280 0030d3e5 ldrb     r3, [r3]
a0388284 7330afe6 sxtb     r3, r3
a0388288 022063e0 rsb      r2, r3, r2
a038828c 2c3f0ae3 movw     r3, #0xaf2c
a0388290 70314ae3 movt     r3, #0xa170
a0388294 002083e5 str      r2, [r3]
a0388298 2c3f0ae3 movw     r3, #0xaf2c
a038829c 70314ae3 movt     r3, #0xa170
a03882a0 002093e5 ldr      r2, [r3]
a03882a4 203b0ae3 movw     r3, #0xab20
a03882a8 70314ae3 movt     r3, #0xa170
a03882ac b030d3e1 ldrh     r3, [r3]
a03882b0 013083e2 add      r3, r3, #1
a03882b4 a31fa0e1 lsr      r1, r3, #0x1f
a03882b8 033081e0 add      r3, r1, r3
a03882bc c330a0e1 asr      r3, r3, #1
a03882c0 022063e0 rsb      r2, r3, r2
a03882c4 2c3f0ae3 movw     r3, #0xaf2c
a03882c8 70314ae3 movt     r3, #0xa170
a03882cc 002083e5 str      r2, [r3]
a03882d0 2c3f0ae3 movw     r3, #0xaf2c
a03882d4 70314ae3 movt     r3, #0xa170
a03882d8 003093e5 ldr      r3, [r3]
a03882dc 180053e3 cmp      r3, #0x18
a03882e0 030000da ble      #0xa03882f4
a03882e4 1830a0e3 mov      r3, #0x18
a03882e8 8c318de5 str      r3, [sp, #0x18c]
a03882ec 0c0000ea b        #0xa0388324
a03882f0 286b6e4e vmulmi.f64 d22, d14, d24
a03882f4 2c3f0ae3 movw     r3, #0xaf2c
a03882f8 70314ae3 movt     r3, #0xa170
a03882fc 003093e5 ldr      r3, [r3]
a0388300 0f0053e3 cmp      r3, #0xf
a0388304 020000ca bgt      #0xa0388314
a0388308 1030a0e3 mov      r3, #0x10
a038830c 8c318de5 str      r3, [sp, #0x18c]
a0388310 030000ea b        #0xa0388324
a0388314 2c3f0ae3 movw     r3, #0xaf2c
a0388318 70314ae3 movt     r3, #0xa170
a038831c 003093e5 ldr      r3, [r3]
a0388320 8c318de5 str      r3, [sp, #0x18c]
a0388324 8c319de5 ldr      r3, [sp, #0x18c]
a0388328 103043e2 sub      r3, r3, #0x10
a038832c 903a07ee vmov     s15, r3
a0388330 e70bf8ee vcvt.f64.s32 d16, s15
a0388334 c51bdfed vldr     d17, [pc, #0x314]
a0388338 a10b60ee vmul.f64 d16, d16, d17
a038833c 001bf2ee vmov.f64 d17, #8.000000e+00
a0388340 a10bc0ee vdiv.f64 d16, d16, d17
a0388344 001bf7ee vmov.f64 d17, #1.000000e+00
a0388348 e00b71ee vsub.f64 d16, d17, d16
a038834c e07bf7ee vcvt.f32.f64 s15, d16
a0388350 cc3a07e3 movw     r3, #0x7acc
a0388354 75304ae3 movt     r3, #0xa075
a0388358 007ac3ed vstr     s15, [r3]
a038835c 110000ea b        #0xa03883a8
a0388360 100000ea b        #0xa03883a8
a0388364 f83a07e3 movw     r3, #0x7af8
a0388368 75304ae3 movt     r3, #0xa075
a038836c be31d3e1 ldrh     r3, [r3, #0x1e]
a0388370 023003e2 and      r3, r3, #2
a0388374 000053e3 cmp      r3, #0
a0388378 0a00000a beq      #0xa03883a8
a038837c c83f0ae3 movw     r3, #0xafc8
a0388380 70314ae3 movt     r3, #0xa170
a0388384 202093e5 ldr      r2, [r3, #0x20]
a0388388 94330be3 movw     r3, #0xb394
a038838c 70314ae3 movt     r3, #0xa170
a0388390 003093e5 ldr      r3, [r3]
a0388394 280200e3 movw     r0, #0x228
a0388398 60004ae3 movt     r0, #0xa060
a038839c 0210a0e1 mov      r1, r2
a03883a0 0320a0e1 mov      r2, r3
a03883a4 507bfceb bl       #0xa02a70ec
a03883a8 c83f0ae3 movw     r3, #0xafc8
a03883ac 70314ae3 movt     r3, #0xa170
a03883b0 202093e5 ldr      r2, [r3, #0x20]
a03883b4 94330be3 movw     r3, #0xb394
a03883b8 70314ae3 movt     r3, #0xa170
a03883bc 002083e5 str      r2, [r3]
a03883c0 1c3b0ae3 movw     r3, #0xab1c
a03883c4 70314ae3 movt     r3, #0xa170
a03883c8 0020a0e3 mov      r2, #0
a03883cc 0020c3e5 strb     r2, [r3]
a03883d0 153b0ae3 movw     r3, #0xab15
a03883d4 70314ae3 movt     r3, #0xa170
a03883d8 0030d3e5 ldrb     r3, [r3]
a03883dc 000053e3 cmp      r3, #0
a03883e0 0800001a bne      #0xa0388408
a03883e4 193b0ae3 movw     r3, #0xab19
a03883e8 70314ae3 movt     r3, #0xa170
a03883ec 0030d3e5 ldrb     r3, [r3]
a03883f0 000053e3 cmp      r3, #0
a03883f4 0300000a beq      #0xa0388408
a03883f8 1c3b0ae3 movw     r3, #0xab1c
a03883fc 70314ae3 movt     r3, #0xa170
a0388400 0220a0e3 mov      r2, #2
a0388404 0020c3e5 strb     r2, [r3]
a0388408 153b0ae3 movw     r3, #0xab15
a038840c 70314ae3 movt     r3, #0xa170
a0388410 0030d3e5 ldrb     r3, [r3]
a0388414 000053e3 cmp      r3, #0
a0388418 0400000a beq      #0xa0388430
a038841c 163b0ae3 movw     r3, #0xab16
a0388420 70314ae3 movt     r3, #0xa170
a0388424 0030d3e5 ldrb     r3, [r3]
a0388428 000053e3 cmp      r3, #0
a038842c 0400001a bne      #0xa0388444
a0388430 1c3b0ae3 movw     r3, #0xab1c
a0388434 70314ae3 movt     r3, #0xa170
a0388438 0030d3e5 ldrb     r3, [r3]
a038843c 000053e3 cmp      r3, #0
a0388440 2701000a beq      #0xa03888e4
a0388444 da3504e3 movw     r3, #0x45da
a0388448 70314ae3 movt     r3, #0xa170
a038844c 0030d3e5 ldrb     r3, [r3]
a0388450 000053e3 cmp      r3, #0
a0388454 3900000a beq      #0xa0388540
a0388458 283204e3 movw     r3, #0x4228
a038845c 70314ae3 movt     r3, #0xa170
a0388460 0030d3e5 ldrb     r3, [r3]
a0388464 7320afe6 sxtb     r2, r3
a0388468 2c3204e3 movw     r3, #0x422c
a038846c 70314ae3 movt     r3, #0xa170
a0388470 003093e5 ldr      r3, [r3]
a0388474 030052e1 cmp      r2, r3
a0388478 3000008a bhi      #0xa0388540
a038847c 293204e3 movw     r3, #0x4229
a0388480 70314ae3 movt     r3, #0xa170
a0388484 0030d3e5 ldrb     r3, [r3]
a0388488 7320afe6 sxtb     r2, r3
a038848c 2c3204e3 movw     r3, #0x422c
a0388490 70314ae3 movt     r3, #0xa170
a0388494 003093e5 ldr      r3, [r3]
a0388498 030052e1 cmp      r2, r3
a038849c 2700003a blo      #0xa0388540
a03884a0 1c3b0ae3 movw     r3, #0xab1c
a03884a4 70314ae3 movt     r3, #0xa170
a03884a8 0030d3e5 ldrb     r3, [r3]
a03884ac 013083e3 orr      r3, r3, #1
a03884b0 7320efe6 uxtb     r2, r3
a03884b4 1c3b0ae3 movw     r3, #0xab1c
a03884b8 70314ae3 movt     r3, #0xa170
a03884bc 0020c3e5 strb     r2, [r3]
a03884c0 1b3b0ae3 movw     r3, #0xab1b
a03884c4 70314ae3 movt     r3, #0xa170
a03884c8 0030d3e5 ldrb     r3, [r3]
a03884cc 013083e2 add      r3, r3, #1
a03884d0 7320efe6 uxtb     r2, r3
a03884d4 1b3b0ae3 movw     r3, #0xab1b
a03884d8 70314ae3 movt     r3, #0xa170
a03884dc 0020c3e5 strb     r2, [r3]
a03884e0 a2390be3 movw     r3, #0xb9a2
a03884e4 70314ae3 movt     r3, #0xa170
a03884e8 0020a0e3 mov      r2, #0
a03884ec 0020c3e5 strb     r2, [r3]
a03884f0 ac3504e3 movw     r3, #0x45ac
a03884f4 70314ae3 movt     r3, #0xa170
a03884f8 0030d3e5 ldrb     r3, [r3]
a03884fc 7330afe6 sxtb     r3, r3
a0388500 000053e3 cmp      r3, #0
a0388504 060000da ble      #0xa0388524
a0388508 2c3b0ae3 movw     r3, #0xab2c
a038850c 70314ae3 movt     r3, #0xa170
a0388510 002093e5 ldr      r2, [r3]
a0388514 343b0ae3 movw     r3, #0xab34
a0388518 70314ae3 movt     r3, #0xa170
a038851c 002083e5 str      r2, [r3]
a0388520 c20000ea b        #0xa0388830
a0388524 283b0ae3 movw     r3, #0xab28
a0388528 70314ae3 movt     r3, #0xa170
a038852c 002093e5 ldr      r2, [r3]
a0388530 343b0ae3 movw     r3, #0xab34
a0388534 70314ae3 movt     r3, #0xa170
a0388538 002083e5 str      r2, [r3]
a038853c bb0000ea b        #0xa0388830
a0388540 283204e3 movw     r3, #0x4228
a0388544 70314ae3 movt     r3, #0xa170
a0388548 0020d3e5 ldrb     r2, [r3]
a038854c 293204e3 movw     r3, #0x4229
a0388550 70314ae3 movt     r3, #0xa170
a0388554 0030d3e5 ldrb     r3, [r3]
a0388558 7220afe6 sxtb     r2, r2
a038855c 7330afe6 sxtb     r3, r3
a0388560 030052e1 cmp      r2, r3
a0388564 3c0000aa bge      #0xa038865c
a0388568 283204e3 movw     r3, #0x4228
a038856c 70314ae3 movt     r3, #0xa170
a0388570 0030d3e5 ldrb     r3, [r3]
a0388574 7320afe6 sxtb     r2, r3
a0388578 2c3204e3 movw     r3, #0x422c
a038857c 70314ae3 movt     r3, #0xa170
a0388580 003093e5 ldr      r3, [r3]
a0388584 030052e1 cmp      r2, r3
a0388588 3300008a bhi      #0xa038865c
a038858c 293204e3 movw     r3, #0x4229
a0388590 70314ae3 movt     r3, #0xa170
a0388594 0030d3e5 ldrb     r3, [r3]
a0388598 7320afe6 sxtb     r2, r3
a038859c 2c3204e3 movw     r3, #0x422c
a03885a0 70314ae3 movt     r3, #0xa170
a03885a4 003093e5 ldr      r3, [r3]
a03885a8 030052e1 cmp      r2, r3
a03885ac 2a00003a blo      #0xa038865c
a03885b0 1c3b0ae3 movw     r3, #0xab1c
a03885b4 70314ae3 movt     r3, #0xa170
a03885b8 0030d3e5 ldrb     r3, [r3]
a03885bc 013083e3 orr      r3, r3, #1
a03885c0 7320efe6 uxtb     r2, r3
a03885c4 1c3b0ae3 movw     r3, #0xab1c
a03885c8 70314ae3 movt     r3, #0xa170
a03885cc 0020c3e5 strb     r2, [r3]
a03885d0 1b3b0ae3 movw     r3, #0xab1b
a03885d4 70314ae3 movt     r3, #0xa170
a03885d8 0030d3e5 ldrb     r3, [r3]
a03885dc 013083e2 add      r3, r3, #1
a03885e0 7320efe6 uxtb     r2, r3
a03885e4 1b3b0ae3 movw     r3, #0xab1b
a03885e8 70314ae3 movt     r3, #0xa170
a03885ec 0020c3e5 strb     r2, [r3]
a03885f0 a2390be3 movw     r3, #0xb9a2
a03885f4 70314ae3 movt     r3, #0xa170
a03885f8 0020a0e3 mov      r2, #0
a03885fc 0020c3e5 strb     r2, [r3]
a0388600 ac3504e3 movw     r3, #0x45ac
a0388604 70314ae3 movt     r3, #0xa170
a0388608 0030d3e5 ldrb     r3, [r3]
a038860c 7330afe6 sxtb     r3, r3
a0388610 000053e3 cmp      r3, #0
a0388614 060000da ble      #0xa0388634
a0388618 2c3b0ae3 movw     r3, #0xab2c
a038861c 70314ae3 movt     r3, #0xa170
a0388620 002093e5 ldr      r2, [r3]
a0388624 343b0ae3 movw     r3, #0xab34
a0388628 70314ae3 movt     r3, #0xa170
a038862c 002083e5 str      r2, [r3]
a0388630 7e0000ea b        #0xa0388830
a0388634 283b0ae3 movw     r3, #0xab28
a0388638 70314ae3 movt     r3, #0xa170
a038863c 002093e5 ldr      r2, [r3]
a0388640 343b0ae3 movw     r3, #0xab34
a0388644 70314ae3 movt     r3, #0xa170
a0388648 002083e5 str      r2, [r3]
a038864c 770000ea b        #0xa0388830
a0388650 33333333 teqlo    r3, #0xcc000000
a0388654 3333e33f svclo    #0xe33333
a0388658 286b6e4e vmulmi.f64 d22, d14, d24
a038865c 283204e3 movw     r3, #0x4228
a0388660 70314ae3 movt     r3, #0xa170
a0388664 0020d3e5 ldrb     r2, [r3]
a0388668 293204e3 movw     r3, #0x4229
a038866c 70314ae3 movt     r3, #0xa170
a0388670 0030d3e5 ldrb     r3, [r3]
a0388674 7220afe6 sxtb     r2, r2
a0388678 7330afe6 sxtb     r3, r3
a038867c 030052e1 cmp      r2, r3
a0388680 5a0000da ble      #0xa03887f0
a0388684 283204e3 movw     r3, #0x4228
a0388688 70314ae3 movt     r3, #0xa170
a038868c 0030d3e5 ldrb     r3, [r3]
a0388690 7320afe6 sxtb     r2, r3
a0388694 2c3204e3 movw     r3, #0x422c
a0388698 70314ae3 movt     r3, #0xa170
a038869c 003093e5 ldr      r3, [r3]
a03886a0 030052e1 cmp      r2, r3
a03886a4 0800009a bls      #0xa03886cc
a03886a8 293204e3 movw     r3, #0x4229
a03886ac 70314ae3 movt     r3, #0xa170
a03886b0 0030d3e5 ldrb     r3, [r3]
a03886b4 7320afe6 sxtb     r2, r3
a03886b8 2c3204e3 movw     r3, #0x422c
a03886bc 70314ae3 movt     r3, #0xa170
a03886c0 003093e5 ldr      r3, [r3]
a03886c4 030052e1 cmp      r2, r3
a03886c8 4800003a blo      #0xa03887f0
a03886cc 283204e3 movw     r3, #0x4228
a03886d0 70314ae3 movt     r3, #0xa170
a03886d4 0030d3e5 ldrb     r3, [r3]
a03886d8 7320afe6 sxtb     r2, r3
a03886dc 2c3204e3 movw     r3, #0x422c
a03886e0 70314ae3 movt     r3, #0xa170
a03886e4 003093e5 ldr      r3, [r3]
a03886e8 030052e1 cmp      r2, r3
a03886ec 1a00008a bhi      #0xa038875c
a03886f0 1c3b0ae3 movw     r3, #0xab1c
a03886f4 70314ae3 movt     r3, #0xa170
a03886f8 0030d3e5 ldrb     r3, [r3]
a03886fc 013083e3 orr      r3, r3, #1
a0388700 7320efe6 uxtb     r2, r3
a0388704 1c3b0ae3 movw     r3, #0xab1c
a0388708 70314ae3 movt     r3, #0xa170
a038870c 0020c3e5 strb     r2, [r3]
a0388710 1b3b0ae3 movw     r3, #0xab1b
a0388714 70314ae3 movt     r3, #0xa170
a0388718 0030d3e5 ldrb     r3, [r3]
a038871c 013083e2 add      r3, r3, #1
a0388720 7320efe6 uxtb     r2, r3
a0388724 1b3b0ae3 movw     r3, #0xab1b
a0388728 70314ae3 movt     r3, #0xa170
a038872c 0020c3e5 strb     r2, [r3]
a0388730 a2390be3 movw     r3, #0xb9a2
a0388734 70314ae3 movt     r3, #0xa170
a0388738 0020a0e3 mov      r2, #0
a038873c 0020c3e5 strb     r2, [r3]
a0388740 283b0ae3 movw     r3, #0xab28
a0388744 70314ae3 movt     r3, #0xa170
a0388748 002093e5 ldr      r2, [r3]
a038874c 343b0ae3 movw     r3, #0xab34
a0388750 70314ae3 movt     r3, #0xa170
a0388754 002083e5 str      r2, [r3]
a0388758 230000ea b        #0xa03887ec
a038875c 293204e3 movw     r3, #0x4229
a0388760 70314ae3 movt     r3, #0xa170
a0388764 0030d3e5 ldrb     r3, [r3]
a0388768 7320afe6 sxtb     r2, r3
a038876c 2c3204e3 movw     r3, #0x422c
a0388770 70314ae3 movt     r3, #0xa170
a0388774 003093e5 ldr      r3, [r3]
a0388778 030052e1 cmp      r2, r3
a038877c 1a00003a blo      #0xa03887ec
a0388780 1c3b0ae3 movw     r3, #0xab1c
a0388784 70314ae3 movt     r3, #0xa170
a0388788 0030d3e5 ldrb     r3, [r3]
a038878c 013083e3 orr      r3, r3, #1
a0388790 7320efe6 uxtb     r2, r3
a0388794 1c3b0ae3 movw     r3, #0xab1c
a0388798 70314ae3 movt     r3, #0xa170
a038879c 0020c3e5 strb     r2, [r3]
a03887a0 1b3b0ae3 movw     r3, #0xab1b
a03887a4 70314ae3 movt     r3, #0xa170
a03887a8 0030d3e5 ldrb     r3, [r3]
a03887ac 013083e2 add      r3, r3, #1
a03887b0 7320efe6 uxtb     r2, r3
a03887b4 1b3b0ae3 movw     r3, #0xab1b
a03887b8 70314ae3 movt     r3, #0xa170
a03887bc 0020c3e5 strb     r2, [r3]
a03887c0 a2390be3 movw     r3, #0xb9a2
a03887c4 70314ae3 movt     r3, #0xa170
a03887c8 0020a0e3 mov      r2, #0
a03887cc 0020c3e5 strb     r2, [r3]
a03887d0 2c3b0ae3 movw     r3, #0xab2c
a03887d4 70314ae3 movt     r3, #0xa170
a03887d8 002093e5 ldr      r2, [r3]
a03887dc 343b0ae3 movw     r3, #0xab34
a03887e0 70314ae3 movt     r3, #0xa170
a03887e4 002083e5 str      r2, [r3]
a03887e8 100000ea b        #0xa0388830
a03887ec 0f0000ea b        #0xa0388830
a03887f0 a2390be3 movw     r3, #0xb9a2
a03887f4 70314ae3 movt     r3, #0xa170
a03887f8 0030d3e5 ldrb     r3, [r3]
a03887fc 013083e2 add      r3, r3, #1
a0388800 7320efe6 uxtb     r2, r3
a0388804 a2390be3 movw     r3, #0xb9a2
a0388808 70314ae3 movt     r3, #0xa170
a038880c 0020c3e5 strb     r2, [r3]
a0388810 1b3b0ae3 movw     r3, #0xab1b
a0388814 70314ae3 movt     r3, #0xa170
a0388818 0020a0e3 mov      r2, #0
a038881c 0020c3e5 strb     r2, [r3]
a0388820 1e3b0ae3 movw     r3, #0xab1e
a0388824 70314ae3 movt     r3, #0xa170
a0388828 0020a0e3 mov      r2, #0
a038882c 0020c3e5 strb     r2, [r3]
a0388830 1b3b0ae3 movw     r3, #0xab1b
a0388834 70314ae3 movt     r3, #0xa170
a0388838 0030d3e5 ldrb     r3, [r3]
a038883c 3f0053e3 cmp      r3, #0x3f
a0388840 0d00009a bls      #0xa038887c
a0388844 1b3b0ae3 movw     r3, #0xab1b
a0388848 70314ae3 movt     r3, #0xa170
a038884c 4020a0e3 mov      r2, #0x40
a0388850 0020c3e5 strb     r2, [r3]
a0388854 f83a07e3 movw     r3, #0x7af8
a0388858 75304ae3 movt     r3, #0xa075
a038885c b433d3e1 ldrh     r3, [r3, #0x34]
a0388860 013003e2 and      r3, r3, #1
a0388864 000053e3 cmp      r3, #0
a0388868 0300000a beq      #0xa038887c
a038886c 700200e3 movw     r0, #0x270
a0388870 60004ae3 movt     r0, #0xa060
a0388874 4010a0e3 mov      r1, #0x40
a0388878 1b7afceb bl       #0xa02a70ec
a038887c f83a07e3 movw     r3, #0x7af8
a0388880 75304ae3 movt     r3, #0xa075
a0388884 b433d3e1 ldrh     r3, [r3, #0x34]
a0388888 023003e2 and      r3, r3, #2
a038888c 000053e3 cmp      r3, #0
a0388890 1300000a beq      #0xa03888e4
a0388894 1b3b0ae3 movw     r3, #0xab1b
a0388898 70314ae3 movt     r3, #0xa170
a038889c 0030d3e5 ldrb     r3, [r3]
a03888a0 0310a0e1 mov      r1, r3
a03888a4 2c3204e3 movw     r3, #0x422c
a03888a8 70314ae3 movt     r3, #0xa170
a03888ac 002093e5 ldr      r2, [r3]
a03888b0 283204e3 movw     r3, #0x4228
a03888b4 70314ae3 movt     r3, #0xa170
a03888b8 0030d3e5 ldrb     r3, [r3]
a03888bc 73c0afe6 sxtb     ip, r3
a03888c0 293204e3 movw     r3, #0x4229
a03888c4 70314ae3 movt     r3, #0xa170
a03888c8 0030d3e5 ldrb     r3, [r3]
a03888cc 7330afe6 sxtb     r3, r3
a03888d0 00308de5 str      r3, [sp]
a03888d4 9c0200e3 movw     r0, #0x29c
a03888d8 60004ae3 movt     r0, #0xa060
a03888dc 0c30a0e1 mov      r3, ip
a03888e0 017afceb bl       #0xa02a70ec
a03888e4 1c3b0ae3 movw     r3, #0xab1c
a03888e8 70314ae3 movt     r3, #0xa170
a03888ec 0030d3e5 ldrb     r3, [r3]
a03888f0 013003e2 and      r3, r3, #1
a03888f4 000053e3 cmp      r3, #0
a03888f8 7a0a000a beq      #0xa038b2e8
a03888fc 1c3b0ae3 movw     r3, #0xab1c
a0388900 70314ae3 movt     r3, #0xa170
a0388904 0030d3e5 ldrb     r3, [r3]
a0388908 023003e2 and      r3, r3, #2
a038890c 000053e3 cmp      r3, #0
a0388910 0130a013 movne    r3, #1
a0388914 0030a003 moveq    r3, #0
a0388918 7330efe6 uxtb     r3, r3
a038891c 7331cde5 strb     r3, [sp, #0x173]
a0388920 1b3b0ae3 movw     r3, #0xab1b
a0388924 70314ae3 movt     r3, #0xa170
a0388928 0030d3e5 ldrb     r3, [r3]
a038892c 010053e3 cmp      r3, #1
a0388930 cb01001a bne      #0xa0389064
a0388934 a4390be3 movw     r3, #0xb9a4
a0388938 70314ae3 movt     r3, #0xa170
a038893c 002093e5 ldr      r2, [r3]
a0388940 003d02e3 movw     r3, #0x2d00
a0388944 70314ae3 movt     r3, #0xa170
a0388948 1c2283e5 str      r2, [r3, #0x21c]
a038894c 383b0ae3 movw     r3, #0xab38
a0388950 70314ae3 movt     r3, #0xa170
a0388954 003093e5 ldr      r3, [r3]
a0388958 0320a0e1 mov      r2, r3
a038895c a4390be3 movw     r3, #0xb9a4
a0388960 70314ae3 movt     r3, #0xa170
a0388964 002083e5 str      r2, [r3]
a0388968 f83a07e3 movw     r3, #0x7af8
a038896c 75304ae3 movt     r3, #0xa075
a0388970 b834d3e1 ldrh     r3, [r3, #0x48]
a0388974 000053e3 cmp      r3, #0
a0388978 6f00000a beq      #0xa0388b3c
a038897c 273204e3 movw     r3, #0x4227
a0388980 70314ae3 movt     r3, #0xa170
a0388984 0030d3e5 ldrb     r3, [r3]
a0388988 ff0053e3 cmp      r3, #0xff
a038898c 3600001a bne      #0xa0388a6c
a0388990 283104e3 movw     r3, #0x4128
a0388994 70314ae3 movt     r3, #0xa170
a0388998 067ad3ed vldr     s15, [r3, #0x18]
a038899c d37a1fed vldr     s14, [pc, #-0x34c]
a03889a0 877a67ee vmul.f32 s15, s15, s14
a03889a4 e70af7ee vcvt.f64.f32 d16, s15
a03889a8 001bf6ee vmov.f64 d17, #5.000000e-01
a03889ac a10b70ee vadd.f64 d16, d16, d17
a03889b0 607bb0ee vmov.f64 d7, d16
a03889b4 c77bfcee vcvt.u32.f64 s15, d7
a03889b8 905a17ee vmov     r5, s15
a03889bc c43504e3 movw     r3, #0x45c4
a03889c0 70314ae3 movt     r3, #0xa170
a03889c4 b030d3e1 ldrh     r3, [r3]
a03889c8 0320a0e1 mov      r2, r3
a03889cc c43004e3 movw     r3, #0x40c4
a03889d0 70314ae3 movt     r3, #0xa170
a03889d4 003093e5 ldr      r3, [r3]
a03889d8 034082e0 add      r4, r2, r3
a03889dc a03204e3 movw     r3, #0x42a0
a03889e0 70314ae3 movt     r3, #0xa170
a03889e4 042093e5 ldr      r2, [r3, #4]
a03889e8 253204e3 movw     r3, #0x4225
a03889ec 70314ae3 movt     r3, #0xa170
a03889f0 0030d3e5 ldrb     r3, [r3]
a03889f4 0200a0e1 mov      r0, r2
a03889f8 0310a0e1 mov      r1, r3
a03889fc 23f705fa blx      #0xa0506690
a0388a00 0030a0e1 mov      r3, r0
a0388a04 4338a0e1 asr      r3, r3, #0x10
a0388a08 043063e0 rsb      r3, r3, r4
a0388a0c 930502e0 mul      r2, r3, r5
a0388a10 833e0de3 movw     r3, #0xde83
a0388a14 1b3344e3 movt     r3, #0x431b
a0388a18 922383e0 umull    r2, r3, r2, r3
a0388a1c 2329a0e1 lsr      r2, r3, #0x12
a0388a20 c03004e3 movw     r3, #0x40c0
a0388a24 70314ae3 movt     r3, #0xa170
a0388a28 003093e5 ldr      r3, [r3]
a0388a2c 032082e0 add      r2, r2, r3
a0388a30 c03c02e3 movw     r3, #0x2cc0
a0388a34 70314ae3 movt     r3, #0xa170
a0388a38 1430d3e5 ldrb     r3, [r3, #0x14]
a0388a3c 7330afe6 sxtb     r3, r3
a0388a40 032082e0 add      r2, r2, r3
a0388a44 b03a07e3 movw     r3, #0x7ab0
a0388a48 75304ae3 movt     r3, #0xa075
a0388a4c 0030d3e5 ldrb     r3, [r3]
a0388a50 7330afe6 sxtb     r3, r3
a0388a54 033082e0 add      r3, r2, r3
a0388a58 0320a0e1 mov      r2, r3
a0388a5c 703204e3 movw     r3, #0x4270
a0388a60 70314ae3 movt     r3, #0xa170
a0388a64 002083e5 str      r2, [r3]
a0388a68 a20000ea b        #0xa0388cf8
a0388a6c 283104e3 movw     r3, #0x4128
a0388a70 70314ae3 movt     r3, #0xa170
a0388a74 067ad3ed vldr     s15, [r3, #0x18]
a0388a78 fb7a9fed vldr     s14, [pc, #0x3ec]
a0388a7c 877a67ee vmul.f32 s15, s15, s14
a0388a80 e70af7ee vcvt.f64.f32 d16, s15
a0388a84 001bf6ee vmov.f64 d17, #5.000000e-01
a0388a88 a10b70ee vadd.f64 d16, d16, d17
a0388a8c 607bb0ee vmov.f64 d7, d16
a0388a90 c77bfcee vcvt.u32.f64 s15, d7
a0388a94 900a17ee vmov     r0, s15
a0388a98 c43504e3 movw     r3, #0x45c4
a0388a9c 70314ae3 movt     r3, #0xa170
a0388aa0 b030d3e1 ldrh     r3, [r3]
a0388aa4 0320a0e1 mov      r2, r3
a0388aa8 c43004e3 movw     r3, #0x40c4
a0388aac 70314ae3 movt     r3, #0xa170
a0388ab0 003093e5 ldr      r3, [r3]
a0388ab4 032082e0 add      r2, r2, r3
a0388ab8 a03204e3 movw     r3, #0x42a0
a0388abc 70314ae3 movt     r3, #0xa170
a0388ac0 041093e5 ldr      r1, [r3, #4]
a0388ac4 273204e3 movw     r3, #0x4227
a0388ac8 70314ae3 movt     r3, #0xa170
a0388acc 0030d3e5 ldrb     r3, [r3]
a0388ad0 103083e2 add      r3, r3, #0x10
a0388ad4 5133a0e1 asr      r3, r1, r3
a0388ad8 023063e0 rsb      r3, r3, r2
a0388adc 930002e0 mul      r2, r3, r0
a0388ae0 833e0de3 movw     r3, #0xde83
a0388ae4 1b3344e3 movt     r3, #0x431b
a0388ae8 922383e0 umull    r2, r3, r2, r3
a0388aec 2329a0e1 lsr      r2, r3, #0x12
a0388af0 c03004e3 movw     r3, #0x40c0
a0388af4 70314ae3 movt     r3, #0xa170
a0388af8 003093e5 ldr      r3, [r3]
a0388afc 032082e0 add      r2, r2, r3
a0388b00 c03c02e3 movw     r3, #0x2cc0
a0388b04 70314ae3 movt     r3, #0xa170
a0388b08 1430d3e5 ldrb     r3, [r3, #0x14]
a0388b0c 7330afe6 sxtb     r3, r3
a0388b10 032082e0 add      r2, r2, r3
a0388b14 b03a07e3 movw     r3, #0x7ab0
a0388b18 75304ae3 movt     r3, #0xa075
a0388b1c 0030d3e5 ldrb     r3, [r3]
a0388b20 7330afe6 sxtb     r3, r3
a0388b24 033082e0 add      r3, r2, r3
a0388b28 0320a0e1 mov      r2, r3
a0388b2c 703204e3 movw     r3, #0x4270
a0388b30 70314ae3 movt     r3, #0xa170
a0388b34 002083e5 str      r2, [r3]
a0388b38 6e0000ea b        #0xa0388cf8
a0388b3c 273204e3 movw     r3, #0x4227
a0388b40 70314ae3 movt     r3, #0xa170
a0388b44 0030d3e5 ldrb     r3, [r3]
a0388b48 ff0053e3 cmp      r3, #0xff
a0388b4c 3600001a bne      #0xa0388c2c
a0388b50 283104e3 movw     r3, #0x4128
a0388b54 70314ae3 movt     r3, #0xa170
a0388b58 067ad3ed vldr     s15, [r3, #0x18]
a0388b5c c27a9fed vldr     s14, [pc, #0x308]
a0388b60 877a67ee vmul.f32 s15, s15, s14
a0388b64 e70af7ee vcvt.f64.f32 d16, s15
a0388b68 001bf6ee vmov.f64 d17, #5.000000e-01
a0388b6c a10b70ee vadd.f64 d16, d16, d17
a0388b70 607bb0ee vmov.f64 d7, d16
a0388b74 c77bfcee vcvt.u32.f64 s15, d7
a0388b78 905a17ee vmov     r5, s15
a0388b7c c43504e3 movw     r3, #0x45c4
a0388b80 70314ae3 movt     r3, #0xa170
a0388b84 b030d3e1 ldrh     r3, [r3]
a0388b88 0320a0e1 mov      r2, r3
a0388b8c c43004e3 movw     r3, #0x40c4
a0388b90 70314ae3 movt     r3, #0xa170
a0388b94 003093e5 ldr      r3, [r3]
a0388b98 034082e0 add      r4, r2, r3
a0388b9c a03204e3 movw     r3, #0x42a0
a0388ba0 70314ae3 movt     r3, #0xa170
a0388ba4 042093e5 ldr      r2, [r3, #4]
a0388ba8 253204e3 movw     r3, #0x4225
a0388bac 70314ae3 movt     r3, #0xa170
a0388bb0 0030d3e5 ldrb     r3, [r3]
a0388bb4 0200a0e1 mov      r0, r2
a0388bb8 0310a0e1 mov      r1, r3
a0388bbc b3f605fa blx      #0xa0506690
a0388bc0 0030a0e1 mov      r3, r0
a0388bc4 4338a0e1 asr      r3, r3, #0x10
a0388bc8 033084e0 add      r3, r4, r3
a0388bcc 930502e0 mul      r2, r3, r5
a0388bd0 833e0de3 movw     r3, #0xde83
a0388bd4 1b3344e3 movt     r3, #0x431b
a0388bd8 922383e0 umull    r2, r3, r2, r3
a0388bdc 2329a0e1 lsr      r2, r3, #0x12
a0388be0 c03004e3 movw     r3, #0x40c0
a0388be4 70314ae3 movt     r3, #0xa170
a0388be8 003093e5 ldr      r3, [r3]
a0388bec 032082e0 add      r2, r2, r3
a0388bf0 c03c02e3 movw     r3, #0x2cc0
a0388bf4 70314ae3 movt     r3, #0xa170
a0388bf8 1430d3e5 ldrb     r3, [r3, #0x14]
a0388bfc 7330afe6 sxtb     r3, r3
a0388c00 032082e0 add      r2, r2, r3
a0388c04 b03a07e3 movw     r3, #0x7ab0
a0388c08 75304ae3 movt     r3, #0xa075
a0388c0c 0030d3e5 ldrb     r3, [r3]
a0388c10 7330afe6 sxtb     r3, r3
a0388c14 033082e0 add      r3, r2, r3
a0388c18 0320a0e1 mov      r2, r3
a0388c1c 703204e3 movw     r3, #0x4270
a0388c20 70314ae3 movt     r3, #0xa170
a0388c24 002083e5 str      r2, [r3]
a0388c28 320000ea b        #0xa0388cf8
a0388c2c 283104e3 movw     r3, #0x4128
a0388c30 70314ae3 movt     r3, #0xa170
a0388c34 067ad3ed vldr     s15, [r3, #0x18]
a0388c38 8b7a9fed vldr     s14, [pc, #0x22c]
a0388c3c 877a67ee vmul.f32 s15, s15, s14
a0388c40 e70af7ee vcvt.f64.f32 d16, s15
a0388c44 001bf6ee vmov.f64 d17, #5.000000e-01
a0388c48 a10b70ee vadd.f64 d16, d16, d17
a0388c4c 607bb0ee vmov.f64 d7, d16
a0388c50 c77bfcee vcvt.u32.f64 s15, d7
a0388c54 900a17ee vmov     r0, s15
a0388c58 c43504e3 movw     r3, #0x45c4
a0388c5c 70314ae3 movt     r3, #0xa170
a0388c60 b030d3e1 ldrh     r3, [r3]
a0388c64 0320a0e1 mov      r2, r3
a0388c68 c43004e3 movw     r3, #0x40c4
a0388c6c 70314ae3 movt     r3, #0xa170
a0388c70 003093e5 ldr      r3, [r3]
a0388c74 032082e0 add      r2, r2, r3
a0388c78 a03204e3 movw     r3, #0x42a0
a0388c7c 70314ae3 movt     r3, #0xa170
a0388c80 041093e5 ldr      r1, [r3, #4]
a0388c84 273204e3 movw     r3, #0x4227
a0388c88 70314ae3 movt     r3, #0xa170
a0388c8c 0030d3e5 ldrb     r3, [r3]
a0388c90 103083e2 add      r3, r3, #0x10
a0388c94 5133a0e1 asr      r3, r1, r3
a0388c98 033082e0 add      r3, r2, r3
a0388c9c 930002e0 mul      r2, r3, r0
a0388ca0 833e0de3 movw     r3, #0xde83
a0388ca4 1b3344e3 movt     r3, #0x431b
a0388ca8 922383e0 umull    r2, r3, r2, r3
a0388cac 2329a0e1 lsr      r2, r3, #0x12
a0388cb0 c03004e3 movw     r3, #0x40c0
a0388cb4 70314ae3 movt     r3, #0xa170
a0388cb8 003093e5 ldr      r3, [r3]
a0388cbc 032082e0 add      r2, r2, r3
a0388cc0 c03c02e3 movw     r3, #0x2cc0
a0388cc4 70314ae3 movt     r3, #0xa170
a0388cc8 1430d3e5 ldrb     r3, [r3, #0x14]
a0388ccc 7330afe6 sxtb     r3, r3
a0388cd0 032082e0 add      r2, r2, r3
a0388cd4 b03a07e3 movw     r3, #0x7ab0
a0388cd8 75304ae3 movt     r3, #0xa075
a0388cdc 0030d3e5 ldrb     r3, [r3]
a0388ce0 7330afe6 sxtb     r3, r3
a0388ce4 033082e0 add      r3, r2, r3
a0388ce8 0320a0e1 mov      r2, r3
a0388cec 703204e3 movw     r3, #0x4270
a0388cf0 70314ae3 movt     r3, #0xa170
a0388cf4 002083e5 str      r2, [r3]
a0388cf8 f83a07e3 movw     r3, #0x7af8
a0388cfc 75304ae3 movt     r3, #0xa075
a0388d00 bc31d3e1 ldrh     r3, [r3, #0x1c]
a0388d04 000053e3 cmp      r3, #0
a0388d08 1100000a beq      #0xa0388d54
a0388d0c 703204e3 movw     r3, #0x4270
a0388d10 70314ae3 movt     r3, #0xa170
a0388d14 002093e5 ldr      r2, [r3]
a0388d18 203b0ae3 movw     r3, #0xab20
a0388d1c 70314ae3 movt     r3, #0xa170
a0388d20 b030d3e1 ldrh     r3, [r3]
a0388d24 a330a0e1 lsr      r3, r3, #1
a0388d28 7330ffe6 uxth     r3, r3
a0388d2c 021063e0 rsb      r1, r3, r2
a0388d30 703204e3 movw     r3, #0x4270
a0388d34 70314ae3 movt     r3, #0xa170
a0388d38 002093e5 ldr      r2, [r3]
a0388d3c 203b0ae3 movw     r3, #0xab20
a0388d40 70314ae3 movt     r3, #0xa170
a0388d44 b030d3e1 ldrh     r3, [r3]
a0388d48 c80200e3 movw     r0, #0x2c8
a0388d4c 60004ae3 movt     r0, #0xa060
a0388d50 e578fceb bl       #0xa02a70ec
a0388d54 703204e3 movw     r3, #0x4270
a0388d58 70314ae3 movt     r3, #0xa170
a0388d5c 002093e5 ldr      r2, [r3]
a0388d60 203b0ae3 movw     r3, #0xab20
a0388d64 70314ae3 movt     r3, #0xa170
a0388d68 b030d3e1 ldrh     r3, [r3]
a0388d6c 013083e2 add      r3, r3, #1
a0388d70 c330a0e1 asr      r3, r3, #1
a0388d74 022063e0 rsb      r2, r3, r2
a0388d78 703204e3 movw     r3, #0x4270
a0388d7c 70314ae3 movt     r3, #0xa170
a0388d80 002083e5 str      r2, [r3]
a0388d84 da3504e3 movw     r3, #0x45da
a0388d88 70314ae3 movt     r3, #0xa170
a0388d8c 0030d3e5 ldrb     r3, [r3]
a0388d90 000053e3 cmp      r3, #0
a0388d94 0c00000a beq      #0xa0388dcc
a0388d98 503c02e3 movw     r3, #0x2c50
a0388d9c 70314ae3 movt     r3, #0xa170
a0388da0 0030d3e5 ldrb     r3, [r3]
a0388da4 8330a0e1 lsl      r3, r3, #1
a0388da8 002063e2 rsb      r2, r3, #0
a0388dac 703204e3 movw     r3, #0x4270
a0388db0 70314ae3 movt     r3, #0xa170
a0388db4 003093e5 ldr      r3, [r3]
a0388db8 032082e0 add      r2, r2, r3
a0388dbc 703204e3 movw     r3, #0x4270
a0388dc0 70314ae3 movt     r3, #0xa170
a0388dc4 002083e5 str      r2, [r3]
a0388dc8 160000ea b        #0xa0388e28
a0388dcc ac3504e3 movw     r3, #0x45ac
a0388dd0 70314ae3 movt     r3, #0xa170
a0388dd4 0030d3e5 ldrb     r3, [r3]
a0388dd8 7330afe6 sxtb     r3, r3
a0388ddc 000053e3 cmp      r3, #0
a0388de0 100000da ble      #0xa0388e28
a0388de4 703204e3 movw     r3, #0x4270
a0388de8 70314ae3 movt     r3, #0xa170
a0388dec 002093e5 ldr      r2, [r3]
a0388df0 ac3504e3 movw     r3, #0x45ac
a0388df4 70314ae3 movt     r3, #0xa170
a0388df8 0030d3e5 ldrb     r3, [r3]
a0388dfc 7330afe6 sxtb     r3, r3
a0388e00 022063e0 rsb      r2, r3, r2
a0388e04 703204e3 movw     r3, #0x4270
a0388e08 70314ae3 movt     r3, #0xa170
a0388e0c 002083e5 str      r2, [r3]
a0388e10 703204e3 movw     r3, #0x4270
a0388e14 70314ae3 movt     r3, #0xa170
a0388e18 002093e5 ldr      r2, [r3]
a0388e1c 703204e3 movw     r3, #0x4270
a0388e20 70314ae3 movt     r3, #0xa170
a0388e24 002083e5 str      r2, [r3]
a0388e28 003d02e3 movw     r3, #0x2d00
a0388e2c 70314ae3 movt     r3, #0xa170
a0388e30 202293e5 ldr      r2, [r3, #0x220]
a0388e34 003d02e3 movw     r3, #0x2d00
a0388e38 70314ae3 movt     r3, #0xa170
a0388e3c 1c3293e5 ldr      r3, [r3, #0x21c]
a0388e40 030052e1 cmp      r2, r3
a0388e44 0a0000da ble      #0xa0388e74
a0388e48 003d02e3 movw     r3, #0x2d00
a0388e4c 70314ae3 movt     r3, #0xa170
a0388e50 202293e5 ldr      r2, [r3, #0x220]
a0388e54 003d02e3 movw     r3, #0x2d00
a0388e58 70314ae3 movt     r3, #0xa170
a0388e5c 1c3293e5 ldr      r3, [r3, #0x21c]
a0388e60 023063e0 rsb      r3, r3, r2
a0388e64 012083e2 add      r2, r3, #1
a0388e68 0f0000ea b        #0xa0388eac
a0388e6c 286b6e4e vmulmi.f64 d22, d14, d24
a0388e70 144470a1 cmnge    r0, r4, lsl r4
a0388e74 003d02e3 movw     r3, #0x2d00
a0388e78 70314ae3 movt     r3, #0xa170
a0388e7c 203293e5 ldr      r3, [r3, #0x220]
a0388e80 0320a0e1 mov      r2, r3
a0388e84 003d02e3 movw     r3, #0x2d00
a0388e88 70314ae3 movt     r3, #0xa170
a0388e8c 103293e5 ldr      r3, [r3, #0x210]
a0388e90 032082e0 add      r2, r2, r3
a0388e94 003d02e3 movw     r3, #0x2d00
a0388e98 70314ae3 movt     r3, #0xa170
a0388e9c 1c3293e5 ldr      r3, [r3, #0x21c]
a0388ea0 023063e0 rsb      r3, r3, r2
a0388ea4 013083e2 add      r3, r3, #1
a0388ea8 0320a0e1 mov      r2, r3
a0388eac a8390be3 movw     r3, #0xb9a8
a0388eb0 70314ae3 movt     r3, #0xa170
a0388eb4 002083e5 str      r2, [r3]
a0388eb8 c03c02e3 movw     r3, #0x2cc0
a0388ebc 70314ae3 movt     r3, #0xa170
a0388ec0 0b30d3e5 ldrb     r3, [r3, #0xb]
a0388ec4 7320afe6 sxtb     r2, r3
a0388ec8 a03204e3 movw     r3, #0x42a0
a0388ecc 70314ae3 movt     r3, #0xa170
a0388ed0 003093e5 ldr      r3, [r3]
a0388ed4 4334a0e1 asr      r3, r3, #8
a0388ed8 930202e0 mul      r2, r3, r2
a0388edc ac390be3 movw     r3, #0xb9ac
a0388ee0 70314ae3 movt     r3, #0xa170
a0388ee4 002083e5 str      r2, [r3]
a0388ee8 c03c02e3 movw     r3, #0x2cc0
a0388eec 70314ae3 movt     r3, #0xa170
a0388ef0 0c30d3e5 ldrb     r3, [r3, #0xc]
a0388ef4 7320afe6 sxtb     r2, r3
a0388ef8 a03204e3 movw     r3, #0x42a0
a0388efc 70314ae3 movt     r3, #0xa170
a0388f00 043093e5 ldr      r3, [r3, #4]
a0388f04 4334a0e1 asr      r3, r3, #8
a0388f08 930202e0 mul      r2, r3, r2
a0388f0c ac390be3 movw     r3, #0xb9ac
a0388f10 70314ae3 movt     r3, #0xa170
a0388f14 042083e5 str      r2, [r3, #4]
a0388f18 403b0ae3 movw     r3, #0xab40
a0388f1c 70314ae3 movt     r3, #0xa170
a0388f20 0020a0e3 mov      r2, #0
a0388f24 002083e5 str      r2, [r3]
a0388f28 3d0000ea b        #0xa0389024
a0388f2c 003d02e3 movw     r3, #0x2d00
a0388f30 70314ae3 movt     r3, #0xa170
a0388f34 1c3293e5 ldr      r3, [r3, #0x21c]
a0388f38 0320a0e1 mov      r2, r3
a0388f3c 403b0ae3 movw     r3, #0xab40
a0388f40 70314ae3 movt     r3, #0xa170
a0388f44 003093e5 ldr      r3, [r3]
a0388f48 033082e0 add      r3, r2, r3
a0388f4c 0320a0e1 mov      r2, r3
a0388f50 4c3b0ae3 movw     r3, #0xab4c
a0388f54 70314ae3 movt     r3, #0xa170
a0388f58 002083e5 str      r2, [r3]
a0388f5c 4c3b0ae3 movw     r3, #0xab4c
a0388f60 70314ae3 movt     r3, #0xa170
a0388f64 003093e5 ldr      r3, [r3]
a0388f68 0320a0e1 mov      r2, r3
a0388f6c 003d02e3 movw     r3, #0x2d00
a0388f70 70314ae3 movt     r3, #0xa170
a0388f74 103293e5 ldr      r3, [r3, #0x210]
a0388f78 030052e1 cmp      r2, r3
a0388f7c 0b00003a blo      #0xa0388fb0
a0388f80 4c3b0ae3 movw     r3, #0xab4c
a0388f84 70314ae3 movt     r3, #0xa170
a0388f88 003093e5 ldr      r3, [r3]
a0388f8c 0320a0e1 mov      r2, r3
a0388f90 003d02e3 movw     r3, #0x2d00
a0388f94 70314ae3 movt     r3, #0xa170
a0388f98 103293e5 ldr      r3, [r3, #0x210]
a0388f9c 023063e0 rsb      r3, r3, r2
a0388fa0 0320a0e1 mov      r2, r3
a0388fa4 4c3b0ae3 movw     r3, #0xab4c
a0388fa8 70314ae3 movt     r3, #0xa170
a0388fac 002083e5 str      r2, [r3]
a0388fb0 4c3b0ae3 movw     r3, #0xab4c
a0388fb4 70314ae3 movt     r3, #0xa170
a0388fb8 000093e5 ldr      r0, [r3]
a0388fbc ac390be3 movw     r3, #0xb9ac
a0388fc0 70314ae3 movt     r3, #0xa170
a0388fc4 001093e5 ldr      r1, [r3]
a0388fc8 002d02e3 movw     r2, #0x2d00
a0388fcc 70214ae3 movt     r2, #0xa170
a0388fd0 cd3f80e2 add      r3, r0, #0x334
a0388fd4 023083e2 add      r3, r3, #2
a0388fd8 031182e7 str      r1, [r2, r3, lsl #2]
a0388fdc 4c3b0ae3 movw     r3, #0xab4c
a0388fe0 70314ae3 movt     r3, #0xa170
a0388fe4 000093e5 ldr      r0, [r3]
a0388fe8 ac390be3 movw     r3, #0xb9ac
a0388fec 70314ae3 movt     r3, #0xa170
a0388ff0 041093e5 ldr      r1, [r3, #4]
a0388ff4 002d02e3 movw     r2, #0x2d00
a0388ff8 70214ae3 movt     r2, #0xa170
a0388ffc ef3f80e2 add      r3, r0, #0x3bc
a0389000 033083e2 add      r3, r3, #3
a0389004 031182e7 str      r1, [r2, r3, lsl #2]
a0389008 403b0ae3 movw     r3, #0xab40
a038900c 70314ae3 movt     r3, #0xa170
a0389010 003093e5 ldr      r3, [r3]
a0389014 012083e2 add      r2, r3, #1
a0389018 403b0ae3 movw     r3, #0xab40
a038901c 70314ae3 movt     r3, #0xa170
a0389020 002083e5 str      r2, [r3]
a0389024 a8390be3 movw     r3, #0xb9a8
a0389028 70314ae3 movt     r3, #0xa170
a038902c 003093e5 ldr      r3, [r3]
a0389030 0320a0e1 mov      r2, r3
a0389034 403b0ae3 movw     r3, #0xab40
a0389038 70314ae3 movt     r3, #0xa170
a038903c 003093e5 ldr      r3, [r3]
a0389040 030052e1 cmp      r2, r3
a0389044 b8ffff8a bhi      #0xa0388f2c
a0389048 e43e0ae3 movw     r3, #0xaee4
a038904c 70314ae3 movt     r3, #0xa170
a0389050 002093e5 ldr      r2, [r3]
a0389054 043f0ae3 movw     r3, #0xaf04
a0389058 70314ae3 movt     r3, #0xa170
a038905c 002083e5 str      r2, [r3]
a0389060 0a0000ea b        #0xa0389090
a0389064 d93504e3 movw     r3, #0x45d9
a0389068 70314ae3 movt     r3, #0xa170
a038906c 0030d3e5 ldrb     r3, [r3]
a0389070 000053e3 cmp      r3, #0
a0389074 0500000a beq      #0xa0389090
a0389078 1b3b0ae3 movw     r3, #0xab1b
a038907c 70314ae3 movt     r3, #0xa170
a0389080 0030d3e5 ldrb     r3, [r3]
a0389084 010053e3 cmp      r3, #1
a0389088 0000009a bls      #0xa0389090
a038908c a10800ea b        #0xa038b318
a0389090 343b0ae3 movw     r3, #0xab34
a0389094 70314ae3 movt     r3, #0xa170
a0389098 005093e5 ldr      r5, [r3]
a038909c 383b0ae3 movw     r3, #0xab38
a03890a0 70314ae3 movt     r3, #0xa170
a03890a4 004093e5 ldr      r4, [r3]
a03890a8 203b0ae3 movw     r3, #0xab20
a03890ac 70314ae3 movt     r3, #0xa170
a03890b0 b0e0d3e1 ldrh     lr, [r3]
a03890b4 183b0ae3 movw     r3, #0xab18
a03890b8 70314ae3 movt     r3, #0xa170
a03890bc 0010d3e5 ldrb     r1, [r3]
a03890c0 283104e3 movw     r3, #0x4128
a03890c4 70314ae3 movt     r3, #0xa170
a03890c8 0c3093e5 ldr      r3, [r3, #0xc]
a03890cc 03c0a0e1 mov      ip, r3
a03890d0 643204e3 movw     r3, #0x4264
a03890d4 70314ae3 movt     r3, #0xa170
a03890d8 003093e5 ldr      r3, [r3]
a03890dc 0300a0e1 mov      r0, r3
a03890e0 243b0ae3 movw     r3, #0xab24
a03890e4 70314ae3 movt     r3, #0xa170
a03890e8 002093e5 ldr      r2, [r3]
a03890ec ac390be3 movw     r3, #0xb9ac
a03890f0 70314ae3 movt     r3, #0xa170
a03890f4 00308de5 str      r3, [sp]
a03890f8 04108de5 str      r1, [sp, #4]
a03890fc 08c08de5 str      ip, [sp, #8]
a0389100 0c008de5 str      r0, [sp, #0xc]
a0389104 a03204e3 movw     r3, #0x42a0
a0389108 70314ae3 movt     r3, #0xa170
a038910c 10308de5 str      r3, [sp, #0x10]
a0389110 a83204e3 movw     r3, #0x42a8
a0389114 70314ae3 movt     r3, #0xa170
a0389118 14308de5 str      r3, [sp, #0x14]
a038911c 7331dde5 ldrb     r3, [sp, #0x173]
a0389120 18308de5 str      r3, [sp, #0x18]
a0389124 1c208de5 str      r2, [sp, #0x1c]
a0389128 000d02e3 movw     r0, #0x2d00
a038912c 70014ae3 movt     r0, #0xa170
a0389130 0510a0e1 mov      r1, r5
a0389134 0420a0e1 mov      r2, r4
a0389138 0e30a0e1 mov      r3, lr
a038913c 18cdffeb bl       #0xa037c5a4
a0389140 b93f0ae3 movw     r3, #0xafb9
a0389144 70314ae3 movt     r3, #0xa170
a0389148 0120a0e3 mov      r2, #1
a038914c 0020c3e5 strb     r2, [r3]
a0389150 743b0ae3 movw     r3, #0xab74
a0389154 70314ae3 movt     r3, #0xa170
a0389158 0030d3e5 ldrb     r3, [r3]
a038915c 000053e3 cmp      r3, #0
a0389160 2800000a beq      #0xa0389208
a0389164 a03204e3 movw     r3, #0x42a0
a0389168 70314ae3 movt     r3, #0xa170
a038916c 003093e5 ldr      r3, [r3]
a0389170 000053e3 cmp      r3, #0
a0389174 0f0000da ble      #0xa03891b8
a0389178 a03204e3 movw     r3, #0x42a0
a038917c 70314ae3 movt     r3, #0xa170
a0389180 002093e5 ldr      r2, [r3]
a0389184 743b0ae3 movw     r3, #0xab74
a0389188 70314ae3 movt     r3, #0xa170
a038918c 0030d3e5 ldrb     r3, [r3]
a0389190 0f3083e2 add      r3, r3, #0xf
a0389194 0110a0e3 mov      r1, #1
a0389198 1133a0e1 lsl      r3, r1, r3
a038919c 030052e1 cmp      r2, r3
a03891a0 040000aa bge      #0xa03891b8
a03891a4 a03204e3 movw     r3, #0x42a0
a03891a8 70314ae3 movt     r3, #0xa170
a03891ac 0020a0e3 mov      r2, #0
a03891b0 002083e5 str      r2, [r3]
a03891b4 130000ea b        #0xa0389208
a03891b8 a03204e3 movw     r3, #0x42a0
a03891bc 70314ae3 movt     r3, #0xa170
a03891c0 003093e5 ldr      r3, [r3]
a03891c4 000053e3 cmp      r3, #0
a03891c8 0e0000aa bge      #0xa0389208
a03891cc a03204e3 movw     r3, #0x42a0
a03891d0 70314ae3 movt     r3, #0xa170
a03891d4 002093e5 ldr      r2, [r3]
a03891d8 743b0ae3 movw     r3, #0xab74
a03891dc 70314ae3 movt     r3, #0xa170
a03891e0 0030d3e5 ldrb     r3, [r3]
a03891e4 0f3083e2 add      r3, r3, #0xf
a03891e8 0010e0e3 mvn      r1, #0
a03891ec 1133a0e1 lsl      r3, r1, r3
a03891f0 030052e1 cmp      r2, r3
a03891f4 030000da ble      #0xa0389208
a03891f8 a03204e3 movw     r3, #0x42a0
a03891fc 70314ae3 movt     r3, #0xa170
a0389200 0020a0e3 mov      r2, #0
a0389204 002083e5 str      r2, [r3]
a0389208 b83a07e3 movw     r3, #0x7ab8
a038920c 75304ae3 movt     r3, #0xa075
a0389210 0030d3e5 ldrb     r3, [r3]
a0389214 000053e3 cmp      r3, #0
a0389218 2800000a beq      #0xa03892c0
a038921c a03204e3 movw     r3, #0x42a0
a0389220 70314ae3 movt     r3, #0xa170
a0389224 043093e5 ldr      r3, [r3, #4]
a0389228 000053e3 cmp      r3, #0
a038922c 0f0000da ble      #0xa0389270
a0389230 a03204e3 movw     r3, #0x42a0
a0389234 70314ae3 movt     r3, #0xa170
a0389238 042093e5 ldr      r2, [r3, #4]
a038923c b83a07e3 movw     r3, #0x7ab8
a0389240 75304ae3 movt     r3, #0xa075
a0389244 0030d3e5 ldrb     r3, [r3]
a0389248 0f3083e2 add      r3, r3, #0xf
a038924c 0110a0e3 mov      r1, #1
a0389250 1133a0e1 lsl      r3, r1, r3
a0389254 030052e1 cmp      r2, r3
a0389258 040000aa bge      #0xa0389270
a038925c a03204e3 movw     r3, #0x42a0
a0389260 70314ae3 movt     r3, #0xa170
a0389264 0020a0e3 mov      r2, #0
a0389268 042083e5 str      r2, [r3, #4]
a038926c 130000ea b        #0xa03892c0
a0389270 a03204e3 movw     r3, #0x42a0
a0389274 70314ae3 movt     r3, #0xa170
a0389278 043093e5 ldr      r3, [r3, #4]
a038927c 000053e3 cmp      r3, #0
a0389280 0e0000aa bge      #0xa03892c0
a0389284 a03204e3 movw     r3, #0x42a0
a0389288 70314ae3 movt     r3, #0xa170
a038928c 042093e5 ldr      r2, [r3, #4]
a0389290 b83a07e3 movw     r3, #0x7ab8
a0389294 75304ae3 movt     r3, #0xa075
a0389298 0030d3e5 ldrb     r3, [r3]
a038929c 0f3083e2 add      r3, r3, #0xf
a03892a0 0010e0e3 mvn      r1, #0
a03892a4 1133a0e1 lsl      r3, r1, r3
a03892a8 030052e1 cmp      r2, r3
a03892ac 030000da ble      #0xa03892c0
a03892b0 a03204e3 movw     r3, #0x42a0
a03892b4 70314ae3 movt     r3, #0xa170
a03892b8 0020a0e3 mov      r2, #0
a03892bc 042083e5 str      r2, [r3, #4]
a03892c0 1b3b0ae3 movw     r3, #0xab1b
a03892c4 70314ae3 movt     r3, #0xa170
a03892c8 0030d3e5 ldrb     r3, [r3]
a03892cc 010053e3 cmp      r3, #1
a03892d0 0000001a bne      #0xa03892d8
a03892d4 faedffeb bl       #0xa0384ac4
a03892d8 2deeffeb bl       #0xa0384b94
a03892dc 2a3f0ae3 movw     r3, #0xaf2a
a03892e0 70314ae3 movt     r3, #0xa170
a03892e4 0030d3e5 ldrb     r3, [r3]
a03892e8 000053e3 cmp      r3, #0
a03892ec 0700000a beq      #0xa0389310
a03892f0 a03204e3 movw     r3, #0x42a0
a03892f4 70314ae3 movt     r3, #0xa170
a03892f8 0020a0e3 mov      r2, #0
a03892fc 002083e5 str      r2, [r3]
a0389300 a03204e3 movw     r3, #0x42a0
a0389304 70314ae3 movt     r3, #0xa170
a0389308 0020a0e3 mov      r2, #0
a038930c 042083e5 str      r2, [r3, #4]
a0389310 7331dde5 ldrb     r3, [sp, #0x173]
a0389314 000053e3 cmp      r3, #0
a0389318 f107001a bne      #0xa038b2e4
a038931c c03c02e3 movw     r3, #0x2cc0
a0389320 70314ae3 movt     r3, #0xa170
a0389324 0b30d3e5 ldrb     r3, [r3, #0xb]
a0389328 7330afe6 sxtb     r3, r3
a038932c 010073e3 cmn      r3, #1
a0389330 1400001a bne      #0xa0389388
a0389334 a03204e3 movw     r3, #0x42a0
a0389338 70314ae3 movt     r3, #0xa170
a038933c 003093e5 ldr      r3, [r3]
a0389340 002063e2 rsb      r2, r3, #0
a0389344 a03204e3 movw     r3, #0x42a0
a0389348 70314ae3 movt     r3, #0xa170
a038934c 002083e5 str      r2, [r3]
a0389350 a83204e3 movw     r3, #0x42a8
a0389354 70314ae3 movt     r3, #0xa170
a0389358 003093e5 ldr      r3, [r3]
a038935c 002063e2 rsb      r2, r3, #0
a0389360 a83204e3 movw     r3, #0x42a8
a0389364 70314ae3 movt     r3, #0xa170
a0389368 002083e5 str      r2, [r3]
a038936c ac390be3 movw     r3, #0xb9ac
a0389370 70314ae3 movt     r3, #0xa170
a0389374 003093e5 ldr      r3, [r3]
a0389378 002063e2 rsb      r2, r3, #0
a038937c ac390be3 movw     r3, #0xb9ac
a0389380 70314ae3 movt     r3, #0xa170
a0389384 002083e5 str      r2, [r3]
a0389388 c03c02e3 movw     r3, #0x2cc0
a038938c 70314ae3 movt     r3, #0xa170
a0389390 0c30d3e5 ldrb     r3, [r3, #0xc]
a0389394 7330afe6 sxtb     r3, r3
a0389398 010073e3 cmn      r3, #1
a038939c 1900001a bne      #0xa0389408
a03893a0 a03204e3 movw     r3, #0x42a0
a03893a4 70314ae3 movt     r3, #0xa170
a03893a8 043093e5 ldr      r3, [r3, #4]
a03893ac 002063e2 rsb      r2, r3, #0
a03893b0 a03204e3 movw     r3, #0x42a0
a03893b4 70314ae3 movt     r3, #0xa170
a03893b8 042083e5 str      r2, [r3, #4]
a03893bc ac390be3 movw     r3, #0xb9ac
a03893c0 70314ae3 movt     r3, #0xa170
a03893c4 043093e5 ldr      r3, [r3, #4]
a03893c8 002063e2 rsb      r2, r3, #0
a03893cc ac390be3 movw     r3, #0xb9ac
a03893d0 70314ae3 movt     r3, #0xa170
a03893d4 042083e5 str      r2, [r3, #4]
a03893d8 183b0ae3 movw     r3, #0xab18
a03893dc 70314ae3 movt     r3, #0xa170
a03893e0 0030d3e5 ldrb     r3, [r3]
a03893e4 000053e3 cmp      r3, #0
a03893e8 0600001a bne      #0xa0389408
a03893ec a83204e3 movw     r3, #0x42a8
a03893f0 70314ae3 movt     r3, #0xa170
a03893f4 043093e5 ldr      r3, [r3, #4]
a03893f8 002063e2 rsb      r2, r3, #0
a03893fc a83204e3 movw     r3, #0x42a8
a0389400 70314ae3 movt     r3, #0xa170
a0389404 042083e5 str      r2, [r3, #4]
a0389408 da3504e3 movw     r3, #0x45da
a038940c 70314ae3 movt     r3, #0xa170
a0389410 0030d3e5 ldrb     r3, [r3]
a0389414 000053e3 cmp      r3, #0
a0389418 3c00000a beq      #0xa0389510
a038941c 263204e3 movw     r3, #0x4226
a0389420 70314ae3 movt     r3, #0xa170
a0389424 0030d3e5 ldrb     r3, [r3]
a0389428 ff0053e3 cmp      r3, #0xff
a038942c 0e00001a bne      #0xa038946c
a0389430 a03204e3 movw     r3, #0x42a0
a0389434 70314ae3 movt     r3, #0xa170
a0389438 002093e5 ldr      r2, [r3]
a038943c 243204e3 movw     r3, #0x4224
a0389440 70314ae3 movt     r3, #0xa170
a0389444 0030d3e5 ldrb     r3, [r3]
a0389448 0200a0e1 mov      r0, r2
a038944c 0310a0e1 mov      r1, r3
a0389450 8ef405fa blx      #0xa0506690
a0389454 0030a0e1 mov      r3, r0
a0389458 0320a0e1 mov      r2, r3
a038945c 003404e3 movw     r3, #0x4400
a0389460 70314ae3 movt     r3, #0xa170
a0389464 1c2083e5 str      r2, [r3, #0x1c]
a0389468 090000ea b        #0xa0389494
a038946c a03204e3 movw     r3, #0x42a0
a0389470 70314ae3 movt     r3, #0xa170
a0389474 002093e5 ldr      r2, [r3]
a0389478 263204e3 movw     r3, #0x4226
a038947c 70314ae3 movt     r3, #0xa170
a0389480 0030d3e5 ldrb     r3, [r3]
a0389484 5223a0e1 asr      r2, r2, r3
a0389488 003404e3 movw     r3, #0x4400
a038948c 70314ae3 movt     r3, #0xa170
a0389490 1c2083e5 str      r2, [r3, #0x1c]
a0389494 273204e3 movw     r3, #0x4227
a0389498 70314ae3 movt     r3, #0xa170
a038949c 0030d3e5 ldrb     r3, [r3]
a03894a0 ff0053e3 cmp      r3, #0xff
a03894a4 0e00001a bne      #0xa03894e4
a03894a8 a03204e3 movw     r3, #0x42a0
a03894ac 70314ae3 movt     r3, #0xa170
a03894b0 042093e5 ldr      r2, [r3, #4]
a03894b4 253204e3 movw     r3, #0x4225
a03894b8 70314ae3 movt     r3, #0xa170
a03894bc 0030d3e5 ldrb     r3, [r3]
a03894c0 0200a0e1 mov      r0, r2
a03894c4 0310a0e1 mov      r1, r3
a03894c8 70f405fa blx      #0xa0506690
a03894cc 0030a0e1 mov      r3, r0
a03894d0 0320a0e1 mov      r2, r3
a03894d4 003404e3 movw     r3, #0x4400
a03894d8 70314ae3 movt     r3, #0xa170
a03894dc 202083e5 str      r2, [r3, #0x20]
a03894e0 7f0700ea b        #0xa038b2e4
a03894e4 a03204e3 movw     r3, #0x42a0
a03894e8 70314ae3 movt     r3, #0xa170
a03894ec 042093e5 ldr      r2, [r3, #4]
a03894f0 273204e3 movw     r3, #0x4227
a03894f4 70314ae3 movt     r3, #0xa170
a03894f8 0030d3e5 ldrb     r3, [r3]
a03894fc 5223a0e1 asr      r2, r2, r3
a0389500 003404e3 movw     r3, #0x4400
a0389504 70314ae3 movt     r3, #0xa170
a0389508 202083e5 str      r2, [r3, #0x20]
a038950c 810700ea b        #0xa038b318
a0389510 513f8de2 add      r3, sp, #0x144
a0389514 0300a0e1 mov      r0, r3
a0389518 401604e3 movw     r1, #0x4640
a038951c 70114ae3 movt     r1, #0xa170
a0389520 c124feeb bl       #0xa031282c
a0389524 513f8de2 add      r3, sp, #0x144
a0389528 0300a0e1 mov      r0, r3
a038952c 641504e3 movw     r1, #0x4564
a0389530 70114ae3 movt     r1, #0xa170
a0389534 bd42fdeb bl       #0xa02da030
a0389538 643504e3 movw     r3, #0x4564
a038953c 70314ae3 movt     r3, #0xa170
a0389540 3c3093e5 ldr      r3, [r3, #0x3c]
a0389544 0320a0e1 mov      r2, r3
a0389548 0030a0e3 mov      r3, #0
a038954c 0230a0e1 mov      r3, r2
a0389550 f4308de5 str      r3, [sp, #0xf4]
a0389554 0030a0e3 mov      r3, #0
a0389558 f0308de5 str      r3, [sp, #0xf0]
a038955c 643504e3 movw     r3, #0x4564
a0389560 70314ae3 movt     r3, #0xa170
a0389564 342093e5 ldr      r2, [r3, #0x34]
a0389568 643504e3 movw     r3, #0x4564
a038956c 70314ae3 movt     r3, #0xa170
a0389570 2c3093e5 ldr      r3, [r3, #0x2c]
a0389574 023063e0 rsb      r3, r3, r2
a0389578 0320a0e1 mov      r2, r3
a038957c 0030a0e3 mov      r3, #0
a0389580 d00fcde1 ldrd     r0, r1, [sp, #0xf0]
a0389584 6bf605fa blx      #0xa0506f38
a0389588 0020a0e1 mov      r2, r0
a038958c 0130a0e1 mov      r3, r1
a0389590 7c3a07e3 movw     r3, #0x7a7c
a0389594 75304ae3 movt     r3, #0xa075
a0389598 002083e5 str      r2, [r3]
a038959c 643504e3 movw     r3, #0x4564
a03895a0 70314ae3 movt     r3, #0xa170
a03895a4 383093e5 ldr      r3, [r3, #0x38]
a03895a8 0320a0e1 mov      r2, r3
a03895ac 0030a0e3 mov      r3, #0
a03895b0 0230a0e1 mov      r3, r2
a03895b4 fc308de5 str      r3, [sp, #0xfc]
a03895b8 0030a0e3 mov      r3, #0
a03895bc f8308de5 str      r3, [sp, #0xf8]
a03895c0 643504e3 movw     r3, #0x4564
a03895c4 70314ae3 movt     r3, #0xa170
a03895c8 302093e5 ldr      r2, [r3, #0x30]
a03895cc 643504e3 movw     r3, #0x4564
a03895d0 70314ae3 movt     r3, #0xa170
a03895d4 283093e5 ldr      r3, [r3, #0x28]
a03895d8 023063e0 rsb      r3, r3, r2
a03895dc 0320a0e1 mov      r2, r3
a03895e0 0030a0e3 mov      r3, #0
a03895e4 d80fcde1 ldrd     r0, r1, [sp, #0xf8]
a03895e8 52f605fa blx      #0xa0506f38
a03895ec 0020a0e1 mov      r2, r0
a03895f0 0130a0e1 mov      r3, r1
a03895f4 783a07e3 movw     r3, #0x7a78
a03895f8 75304ae3 movt     r3, #0xa075
a03895fc 002083e5 str      r2, [r3]
a0389600 513f8de2 add      r3, sp, #0x144
a0389604 0300a0e1 mov      r0, r3
a0389608 001404e3 movw     r1, #0x4400
a038960c 70114ae3 movt     r1, #0xa170
a0389610 b442fdeb bl       #0xa02da0e8
a0389614 643504e3 movw     r3, #0x4564
a0389618 70314ae3 movt     r3, #0xa170
a038961c 002093e5 ldr      r2, [r3]
a0389620 003404e3 movw     r3, #0x4400
a0389624 70314ae3 movt     r3, #0xa170
a0389628 142083e5 str      r2, [r3, #0x14]
a038962c 643504e3 movw     r3, #0x4564
a0389630 70314ae3 movt     r3, #0xa170
a0389634 042093e5 ldr      r2, [r3, #4]
a0389638 003404e3 movw     r3, #0x4400
a038963c 70314ae3 movt     r3, #0xa170
a0389640 182083e5 str      r2, [r3, #0x18]
a0389644 403604e3 movw     r3, #0x4640
a0389648 70314ae3 movt     r3, #0xa170
a038964c 842093e5 ldr      r2, [r3, #0x84]
a0389650 003404e3 movw     r3, #0x4400
a0389654 70314ae3 movt     r3, #0xa170
a0389658 242083e5 str      r2, [r3, #0x24]
a038965c 403604e3 movw     r3, #0x4640
a0389660 70314ae3 movt     r3, #0xa170
a0389664 882093e5 ldr      r2, [r3, #0x88]
a0389668 003404e3 movw     r3, #0x4400
a038966c 70314ae3 movt     r3, #0xa170
a0389670 282083e5 str      r2, [r3, #0x28]
a0389674 b03504e3 movw     r3, #0x45b0
a0389678 70314ae3 movt     r3, #0xa170
a038967c 002093e5 ldr      r2, [r3]
a0389680 003404e3 movw     r3, #0x4400
a0389684 70314ae3 movt     r3, #0xa170
a0389688 542083e5 str      r2, [r3, #0x54]
a038968c b03504e3 movw     r3, #0x45b0
a0389690 70314ae3 movt     r3, #0xa170
a0389694 042093e5 ldr      r2, [r3, #4]
a0389698 003404e3 movw     r3, #0x4400
a038969c 70314ae3 movt     r3, #0xa170
a03896a0 582083e5 str      r2, [r3, #0x58]
a03896a4 b03504e3 movw     r3, #0x45b0
a03896a8 70314ae3 movt     r3, #0xa170
a03896ac 082093e5 ldr      r2, [r3, #8]
a03896b0 003404e3 movw     r3, #0x4400
a03896b4 70314ae3 movt     r3, #0xa170
a03896b8 5c2083e5 str      r2, [r3, #0x5c]
a03896bc b03504e3 movw     r3, #0x45b0
a03896c0 70314ae3 movt     r3, #0xa170
a03896c4 0c2093e5 ldr      r2, [r3, #0xc]
a03896c8 003404e3 movw     r3, #0x4400
a03896cc 70314ae3 movt     r3, #0xa170
a03896d0 602083e5 str      r2, [r3, #0x60]
a03896d4 173b0ae3 movw     r3, #0xab17
a03896d8 70314ae3 movt     r3, #0xa170
a03896dc 0030d3e5 ldrb     r3, [r3]
a03896e0 000053e3 cmp      r3, #0
a03896e4 0900001a bne      #0xa0389710
a03896e8 a83204e3 movw     r3, #0x42a8
a03896ec 70314ae3 movt     r3, #0xa170
a03896f0 0020a0e3 mov      r2, #0
a03896f4 042083e5 str      r2, [r3, #4]
a03896f8 a83204e3 movw     r3, #0x42a8
a03896fc 70314ae3 movt     r3, #0xa170
a0389700 042093e5 ldr      r2, [r3, #4]
a0389704 a83204e3 movw     r3, #0x42a8
a0389708 70314ae3 movt     r3, #0xa170
a038970c 002083e5 str      r2, [r3]
a0389710 263204e3 movw     r3, #0x4226
a0389714 70314ae3 movt     r3, #0xa170
a0389718 0030d3e5 ldrb     r3, [r3]
a038971c ff0053e3 cmp      r3, #0xff
a0389720 1c00001a bne      #0xa0389798
a0389724 a03204e3 movw     r3, #0x42a0
a0389728 70314ae3 movt     r3, #0xa170
a038972c 002093e5 ldr      r2, [r3]
a0389730 243204e3 movw     r3, #0x4224
a0389734 70314ae3 movt     r3, #0xa170
a0389738 0030d3e5 ldrb     r3, [r3]
a038973c 0200a0e1 mov      r0, r2
a0389740 0310a0e1 mov      r1, r3
a0389744 d1f305fa blx      #0xa0506690
a0389748 0030a0e1 mov      r3, r0
a038974c 0320a0e1 mov      r2, r3
a0389750 003404e3 movw     r3, #0x4400
a0389754 70314ae3 movt     r3, #0xa170
a0389758 1c2083e5 str      r2, [r3, #0x1c]
a038975c a83204e3 movw     r3, #0x42a8
a0389760 70314ae3 movt     r3, #0xa170
a0389764 002093e5 ldr      r2, [r3]
a0389768 243204e3 movw     r3, #0x4224
a038976c 70314ae3 movt     r3, #0xa170
a0389770 0030d3e5 ldrb     r3, [r3]
a0389774 0200a0e1 mov      r0, r2
a0389778 0310a0e1 mov      r1, r3
a038977c c3f305fa blx      #0xa0506690
a0389780 0030a0e1 mov      r3, r0
a0389784 0320a0e1 mov      r2, r3
a0389788 003404e3 movw     r3, #0x4400
a038978c 70314ae3 movt     r3, #0xa170
a0389790 4c2083e5 str      r2, [r3, #0x4c]
a0389794 140000ea b        #0xa03897ec
a0389798 a03204e3 movw     r3, #0x42a0
a038979c 70314ae3 movt     r3, #0xa170
a03897a0 002093e5 ldr      r2, [r3]
a03897a4 263204e3 movw     r3, #0x4226
a03897a8 70314ae3 movt     r3, #0xa170
a03897ac 0030d3e5 ldrb     r3, [r3]
a03897b0 5223a0e1 asr      r2, r2, r3
a03897b4 003404e3 movw     r3, #0x4400
a03897b8 70314ae3 movt     r3, #0xa170
a03897bc 1c2083e5 str      r2, [r3, #0x1c]
a03897c0 a83204e3 movw     r3, #0x42a8
a03897c4 70314ae3 movt     r3, #0xa170
a03897c8 002093e5 ldr      r2, [r3]
a03897cc 263204e3 movw     r3, #0x4226
a03897d0 70314ae3 movt     r3, #0xa170
a03897d4 0030d3e5 ldrb     r3, [r3]
a03897d8 5233a0e1 asr      r3, r2, r3
a03897dc 0320a0e1 mov      r2, r3
a03897e0 003404e3 movw     r3, #0x4400
a03897e4 70314ae3 movt     r3, #0xa170
a03897e8 4c2083e5 str      r2, [r3, #0x4c]
a03897ec 003404e3 movw     r3, #0x4400
a03897f0 70314ae3 movt     r3, #0xa170
a03897f4 1c2093e5 ldr      r2, [r3, #0x1c]
a03897f8 b83e0ae3 movw     r3, #0xaeb8
a03897fc 70314ae3 movt     r3, #0xa170
a0389800 002083e5 str      r2, [r3]
a0389804 f83a07e3 movw     r3, #0x7af8
a0389808 75304ae3 movt     r3, #0xa075
a038980c ba31d3e1 ldrh     r3, [r3, #0x1a]
a0389810 000053e3 cmp      r3, #0
a0389814 0600000a beq      #0xa0389834
a0389818 f83a07e3 movw     r3, #0x7af8
a038981c 75304ae3 movt     r3, #0xa075
a0389820 ba31d3e1 ldrh     r3, [r3, #0x1a]
a0389824 0320a0e1 mov      r2, r3
a0389828 003404e3 movw     r3, #0x4400
a038982c 70314ae3 movt     r3, #0xa170
a0389830 4c2083e5 str      r2, [r3, #0x4c]
a0389834 003404e3 movw     r3, #0x4400
a0389838 70314ae3 movt     r3, #0xa170
a038983c 0020a0e3 mov      r2, #0
a0389840 502083e5 str      r2, [r3, #0x50]
a0389844 273204e3 movw     r3, #0x4227
a0389848 70314ae3 movt     r3, #0xa170
a038984c 0030d3e5 ldrb     r3, [r3]
a0389850 ff0053e3 cmp      r3, #0xff
a0389854 0e00001a bne      #0xa0389894
a0389858 a03204e3 movw     r3, #0x42a0
a038985c 70314ae3 movt     r3, #0xa170
a0389860 042093e5 ldr      r2, [r3, #4]
a0389864 253204e3 movw     r3, #0x4225
a0389868 70314ae3 movt     r3, #0xa170
a038986c 0030d3e5 ldrb     r3, [r3]
a0389870 0200a0e1 mov      r0, r2
a0389874 0310a0e1 mov      r1, r3
a0389878 84f305fa blx      #0xa0506690
a038987c 0030a0e1 mov      r3, r0
a0389880 0320a0e1 mov      r2, r3
a0389884 003404e3 movw     r3, #0x4400
a0389888 70314ae3 movt     r3, #0xa170
a038988c 202083e5 str      r2, [r3, #0x20]
a0389890 090000ea b        #0xa03898bc
a0389894 a03204e3 movw     r3, #0x42a0
a0389898 70314ae3 movt     r3, #0xa170
a038989c 042093e5 ldr      r2, [r3, #4]
a03898a0 273204e3 movw     r3, #0x4227
a03898a4 70314ae3 movt     r3, #0xa170
a03898a8 0030d3e5 ldrb     r3, [r3]
a03898ac 5223a0e1 asr      r2, r2, r3
a03898b0 003404e3 movw     r3, #0x4400
a03898b4 70314ae3 movt     r3, #0xa170
a03898b8 202083e5 str      r2, [r3, #0x20]
a03898bc 003404e3 movw     r3, #0x4400
a03898c0 70314ae3 movt     r3, #0xa170
a03898c4 202093e5 ldr      r2, [r3, #0x20]
a03898c8 bc3e0ae3 movw     r3, #0xaebc
a03898cc 70314ae3 movt     r3, #0xa170
a03898d0 002083e5 str      r2, [r3]
a03898d4 643a07e3 movw     r3, #0x7a64
a03898d8 75304ae3 movt     r3, #0xa075
a03898dc 003093e5 ldr      r3, [r3]
a03898e0 000053e3 cmp      r3, #0
a03898e4 0e00000a beq      #0xa0389924
a03898e8 003404e3 movw     r3, #0x4400
a03898ec 70314ae3 movt     r3, #0xa170
a03898f0 1c3093e5 ldr      r3, [r3, #0x1c]
a03898f4 0320a0e1 mov      r2, r3
a03898f8 b4390be3 movw     r3, #0xb9b4
a03898fc 70314ae3 movt     r3, #0xa170
a0389900 002083e5 str      r2, [r3]
a0389904 003404e3 movw     r3, #0x4400
a0389908 70314ae3 movt     r3, #0xa170
a038990c 203093e5 ldr      r3, [r3, #0x20]
a0389910 0320a0e1 mov      r2, r3
a0389914 b8390be3 movw     r3, #0xb9b8
a0389918 70314ae3 movt     r3, #0xa170
a038991c 002083e5 str      r2, [r3]
a0389920 0d0000ea b        #0xa038995c
a0389924 b4390be3 movw     r3, #0xb9b4
a0389928 70314ae3 movt     r3, #0xa170
a038992c 003093e5 ldr      r3, [r3]
a0389930 0320a0e1 mov      r2, r3
a0389934 003404e3 movw     r3, #0x4400
a0389938 70314ae3 movt     r3, #0xa170
a038993c 1c2083e5 str      r2, [r3, #0x1c]
a0389940 b8390be3 movw     r3, #0xb9b8
a0389944 70314ae3 movt     r3, #0xa170
a0389948 003093e5 ldr      r3, [r3]
a038994c 0320a0e1 mov      r2, r3
a0389950 003404e3 movw     r3, #0x4400
a0389954 70314ae3 movt     r3, #0xa170
a0389958 202083e5 str      r2, [r3, #0x20]
a038995c 6c3a07e3 movw     r3, #0x7a6c
a0389960 75304ae3 movt     r3, #0xa075
a0389964 003093e5 ldr      r3, [r3]
a0389968 000053e3 cmp      r3, #0
a038996c 4700001a bne      #0xa0389a90
a0389970 bc390be3 movw     r3, #0xb9bc
a0389974 70314ae3 movt     r3, #0xa170
a0389978 002093e5 ldr      r2, [r3]
a038997c 003404e3 movw     r3, #0x4400
a0389980 70314ae3 movt     r3, #0xa170
a0389984 1c2083e5 str      r2, [r3, #0x1c]
a0389988 c0390be3 movw     r3, #0xb9c0
a038998c 70314ae3 movt     r3, #0xa170
a0389990 002093e5 ldr      r2, [r3]
a0389994 003404e3 movw     r3, #0x4400
a0389998 70314ae3 movt     r3, #0xa170
a038999c 202083e5 str      r2, [r3, #0x20]
a03899a0 583b07e3 movw     r3, #0x7b58
a03899a4 75304ae3 movt     r3, #0xa075
a03899a8 003093e5 ldr      r3, [r3]
a03899ac 0328a0e1 lsl      r2, r3, #0x10
a03899b0 bc390be3 movw     r3, #0xb9bc
a03899b4 70314ae3 movt     r3, #0xa170
a03899b8 003093e5 ldr      r3, [r3]
a03899bc 032082e0 add      r2, r2, r3
a03899c0 bc390be3 movw     r3, #0xb9bc
a03899c4 70314ae3 movt     r3, #0xa170
a03899c8 002083e5 str      r2, [r3]
a03899cc 5c3b07e3 movw     r3, #0x7b5c
a03899d0 75304ae3 movt     r3, #0xa075
a03899d4 003093e5 ldr      r3, [r3]
a03899d8 0328a0e1 lsl      r2, r3, #0x10
a03899dc c0390be3 movw     r3, #0xb9c0
a03899e0 70314ae3 movt     r3, #0xa170
a03899e4 003093e5 ldr      r3, [r3]
a03899e8 032082e0 add      r2, r2, r3
a03899ec c0390be3 movw     r3, #0xb9c0
a03899f0 70314ae3 movt     r3, #0xa170
a03899f4 002083e5 str      r2, [r3]
a03899f8 bc390be3 movw     r3, #0xb9bc
a03899fc 70314ae3 movt     r3, #0xa170
a0389a00 003093e5 ldr      r3, [r3]
a0389a04 190753e3 cmp      r3, #0x640000
a0389a08 040000da ble      #0xa0389a20
a0389a0c 583b07e3 movw     r3, #0x7b58
a0389a10 75304ae3 movt     r3, #0xa075
a0389a14 0020e0e3 mvn      r2, #0
a0389a18 002083e5 str      r2, [r3]
a0389a1c 080000ea b        #0xa0389a44
a0389a20 bc390be3 movw     r3, #0xb9bc
a0389a24 70314ae3 movt     r3, #0xa170
a0389a28 003093e5 ldr      r3, [r3]
a0389a2c 190773e3 cmn      r3, #0x640000
a0389a30 030000aa bge      #0xa0389a44
a0389a34 583b07e3 movw     r3, #0x7b58
a0389a38 75304ae3 movt     r3, #0xa075
a0389a3c 0120a0e3 mov      r2, #1
a0389a40 002083e5 str      r2, [r3]
a0389a44 c0390be3 movw     r3, #0xb9c0
a0389a48 70314ae3 movt     r3, #0xa170
a0389a4c 003093e5 ldr      r3, [r3]
a0389a50 320853e3 cmp      r3, #0x320000
a0389a54 040000da ble      #0xa0389a6c
a0389a58 5c3b07e3 movw     r3, #0x7b5c
a0389a5c 75304ae3 movt     r3, #0xa075
a0389a60 0020e0e3 mvn      r2, #0
a0389a64 002083e5 str      r2, [r3]
a0389a68 080000ea b        #0xa0389a90
a0389a6c c0390be3 movw     r3, #0xb9c0
a0389a70 70314ae3 movt     r3, #0xa170
a0389a74 003093e5 ldr      r3, [r3]
a0389a78 320873e3 cmn      r3, #0x320000
a0389a7c 030000aa bge      #0xa0389a90
a0389a80 5c3b07e3 movw     r3, #0x7b5c
a0389a84 75304ae3 movt     r3, #0xa075
a0389a88 0120a0e3 mov      r2, #1
a0389a8c 002083e5 str      r2, [r3]
a0389a90 f83a07e3 movw     r3, #0x7af8
a0389a94 75304ae3 movt     r3, #0xa075
a0389a98 b432d3e1 ldrh     r3, [r3, #0x24]
a0389a9c 000053e3 cmp      r3, #0
a0389aa0 7700000a beq      #0xa0389c84
a0389aa4 1b3b0ae3 movw     r3, #0xab1b
a0389aa8 70314ae3 movt     r3, #0xa170
a0389aac 0030d3e5 ldrb     r3, [r3]
a0389ab0 010053e3 cmp      r3, #1
a0389ab4 7200001a bne      #0xa0389c84
a0389ab8 f40200e3 movw     r0, #0x2f4
a0389abc 60004ae3 movt     r0, #0xa060
a0389ac0 8975fceb bl       #0xa02a70ec
a0389ac4 003404e3 movw     r3, #0x4400
a0389ac8 70314ae3 movt     r3, #0xa170
a0389acc 003093e5 ldr      r3, [r3]
a0389ad0 200300e3 movw     r0, #0x320
a0389ad4 60004ae3 movt     r0, #0xa060
a0389ad8 0310a0e1 mov      r1, r3
a0389adc 8275fceb bl       #0xa02a70ec
a0389ae0 003404e3 movw     r3, #0x4400
a0389ae4 70314ae3 movt     r3, #0xa170
a0389ae8 043093e5 ldr      r3, [r3, #4]
a0389aec 480300e3 movw     r0, #0x348
a0389af0 60004ae3 movt     r0, #0xa060
a0389af4 0310a0e1 mov      r1, r3
a0389af8 7b75fceb bl       #0xa02a70ec
a0389afc 003404e3 movw     r3, #0x4400
a0389b00 70314ae3 movt     r3, #0xa170
a0389b04 083093e5 ldr      r3, [r3, #8]
a0389b08 700300e3 movw     r0, #0x370
a0389b0c 60004ae3 movt     r0, #0xa060
a0389b10 0310a0e1 mov      r1, r3
a0389b14 7475fceb bl       #0xa02a70ec
a0389b18 003404e3 movw     r3, #0x4400
a0389b1c 70314ae3 movt     r3, #0xa170
a0389b20 0c3093e5 ldr      r3, [r3, #0xc]
a0389b24 980300e3 movw     r0, #0x398
a0389b28 60004ae3 movt     r0, #0xa060
a0389b2c 0310a0e1 mov      r1, r3
a0389b30 6d75fceb bl       #0xa02a70ec
a0389b34 003404e3 movw     r3, #0x4400
a0389b38 70314ae3 movt     r3, #0xa170
a0389b3c 143093e5 ldr      r3, [r3, #0x14]
a0389b40 c00300e3 movw     r0, #0x3c0
a0389b44 60004ae3 movt     r0, #0xa060
a0389b48 0310a0e1 mov      r1, r3
a0389b4c 6675fceb bl       #0xa02a70ec
a0389b50 003404e3 movw     r3, #0x4400
a0389b54 70314ae3 movt     r3, #0xa170
a0389b58 183093e5 ldr      r3, [r3, #0x18]
a0389b5c e80300e3 movw     r0, #0x3e8
a0389b60 60004ae3 movt     r0, #0xa060
a0389b64 0310a0e1 mov      r1, r3
a0389b68 5f75fceb bl       #0xa02a70ec
a0389b6c 003404e3 movw     r3, #0x4400
a0389b70 70314ae3 movt     r3, #0xa170
a0389b74 1c3093e5 ldr      r3, [r3, #0x1c]
a0389b78 100400e3 movw     r0, #0x410
a0389b7c 60004ae3 movt     r0, #0xa060
a0389b80 0310a0e1 mov      r1, r3
a0389b84 5875fceb bl       #0xa02a70ec
a0389b88 003404e3 movw     r3, #0x4400
a0389b8c 70314ae3 movt     r3, #0xa170
a0389b90 203093e5 ldr      r3, [r3, #0x20]
a0389b94 380400e3 movw     r0, #0x438
a0389b98 60004ae3 movt     r0, #0xa060
a0389b9c 0310a0e1 mov      r1, r3
a0389ba0 5175fceb bl       #0xa02a70ec
a0389ba4 003404e3 movw     r3, #0x4400
a0389ba8 70314ae3 movt     r3, #0xa170
a0389bac 243093e5 ldr      r3, [r3, #0x24]
a0389bb0 5c0400e3 movw     r0, #0x45c
a0389bb4 60004ae3 movt     r0, #0xa060
a0389bb8 0310a0e1 mov      r1, r3
a0389bbc 4a75fceb bl       #0xa02a70ec
a0389bc0 003404e3 movw     r3, #0x4400
a0389bc4 70314ae3 movt     r3, #0xa170
a0389bc8 283093e5 ldr      r3, [r3, #0x28]
a0389bcc 8c0400e3 movw     r0, #0x48c
a0389bd0 60004ae3 movt     r0, #0xa060
a0389bd4 0310a0e1 mov      r1, r3
a0389bd8 4375fceb bl       #0xa02a70ec
a0389bdc 003404e3 movw     r3, #0x4400
a0389be0 70314ae3 movt     r3, #0xa170
a0389be4 4c3093e5 ldr      r3, [r3, #0x4c]
a0389be8 bc0400e3 movw     r0, #0x4bc
a0389bec 60004ae3 movt     r0, #0xa060
a0389bf0 0310a0e1 mov      r1, r3
a0389bf4 3c75fceb bl       #0xa02a70ec
a0389bf8 003404e3 movw     r3, #0x4400
a0389bfc 70314ae3 movt     r3, #0xa170
a0389c00 503093e5 ldr      r3, [r3, #0x50]
a0389c04 e80400e3 movw     r0, #0x4e8
a0389c08 60004ae3 movt     r0, #0xa060
a0389c0c 0310a0e1 mov      r1, r3
a0389c10 3575fceb bl       #0xa02a70ec
a0389c14 003404e3 movw     r3, #0x4400
a0389c18 70314ae3 movt     r3, #0xa170
a0389c1c 543093e5 ldr      r3, [r3, #0x54]
a0389c20 140500e3 movw     r0, #0x514
a0389c24 60004ae3 movt     r0, #0xa060
a0389c28 0310a0e1 mov      r1, r3
a0389c2c 2e75fceb bl       #0xa02a70ec
a0389c30 003404e3 movw     r3, #0x4400
a0389c34 70314ae3 movt     r3, #0xa170
a0389c38 583093e5 ldr      r3, [r3, #0x58]
a0389c3c 380500e3 movw     r0, #0x538
a0389c40 60004ae3 movt     r0, #0xa060
a0389c44 0310a0e1 mov      r1, r3
a0389c48 2775fceb bl       #0xa02a70ec
a0389c4c 003404e3 movw     r3, #0x4400
a0389c50 70314ae3 movt     r3, #0xa170
a0389c54 5c3093e5 ldr      r3, [r3, #0x5c]
a0389c58 5c0500e3 movw     r0, #0x55c
a0389c5c 60004ae3 movt     r0, #0xa060
a0389c60 0310a0e1 mov      r1, r3
a0389c64 2075fceb bl       #0xa02a70ec
a0389c68 003404e3 movw     r3, #0x4400
a0389c6c 70314ae3 movt     r3, #0xa170
a0389c70 603093e5 ldr      r3, [r3, #0x60]
a0389c74 7c0500e3 movw     r0, #0x57c
a0389c78 60004ae3 movt     r0, #0xa060
a0389c7c 0310a0e1 mov      r1, r3
a0389c80 1975fceb bl       #0xa02a70ec
a0389c84 d73504e3 movw     r3, #0x45d7
a0389c88 70314ae3 movt     r3, #0xa170
a0389c8c 0030d3e5 ldrb     r3, [r3]
a0389c90 000053e3 cmp      r3, #0
a0389c94 0400001a bne      #0xa0389cac
a0389c98 d93504e3 movw     r3, #0x45d9
a0389c9c 70314ae3 movt     r3, #0xa170
a0389ca0 0030d3e5 ldrb     r3, [r3]
a0389ca4 000053e3 cmp      r3, #0
a0389ca8 0100000a beq      #0xa0389cb4
a0389cac 0130a0e3 mov      r3, #1
a0389cb0 000000ea b        #0xa0389cb8
a0389cb4 0030a0e3 mov      r3, #0
a0389cb8 0320a0e1 mov      r2, r3
a0389cbc 003404e3 movw     r3, #0x4400
a0389cc0 70314ae3 movt     r3, #0xa170
a0389cc4 642083e5 str      r2, [r3, #0x64]
a0389cc8 003404e3 movw     r3, #0x4400
a0389ccc 70314ae3 movt     r3, #0xa170
a0389cd0 0020a0e3 mov      r2, #0
a0389cd4 682083e5 str      r2, [r3, #0x68]
a0389cd8 003404e3 movw     r3, #0x4400
a0389cdc 70314ae3 movt     r3, #0xa170
a0389ce0 0020a0e3 mov      r2, #0
a0389ce4 6c2083e5 str      r2, [r3, #0x6c]
a0389ce8 db3504e3 movw     r3, #0x45db
a0389cec 70314ae3 movt     r3, #0xa170
a0389cf0 0030d3e5 ldrb     r3, [r3]
a0389cf4 013003e2 and      r3, r3, #1
a0389cf8 000053e3 cmp      r3, #0
a0389cfc 0e00000a beq      #0xa0389d3c
a0389d00 1e3b0ae3 movw     r3, #0xab1e
a0389d04 70314ae3 movt     r3, #0xa170
a0389d08 0030d3e5 ldrb     r3, [r3]
a0389d0c 000053e3 cmp      r3, #0
a0389d10 0900000a beq      #0xa0389d3c
a0389d14 003404e3 movw     r3, #0x4400
a0389d18 70314ae3 movt     r3, #0xa170
a0389d1c 0120a0e3 mov      r2, #1
a0389d20 682083e5 str      r2, [r3, #0x68]
a0389d24 f03304e3 movw     r3, #0x43f0
a0389d28 70314ae3 movt     r3, #0xa170
a0389d2c 0c2093e5 ldr      r2, [r3, #0xc]
a0389d30 003404e3 movw     r3, #0x4400
a0389d34 70314ae3 movt     r3, #0xa170
a0389d38 6c2083e5 str      r2, [r3, #0x6c]
a0389d3c 513f8de2 add      r3, sp, #0x144
a0389d40 0300a0e1 mov      r0, r3
a0389d44 001404e3 movw     r1, #0x4400
a0389d48 70114ae3 movt     r1, #0xa170
a0389d4c cc3ffdeb bl       #0xa02d9c84
a0389d50 513f8de2 add      r3, sp, #0x144
a0389d54 0300a0e1 mov      r0, r3
a0389d58 f01e1fe5 ldr      r1, [pc, #-0xef0]
a0389d5c e73efdeb bl       #0xa02d9900
a0389d60 f83a07e3 movw     r3, #0x7af8
a0389d64 75304ae3 movt     r3, #0xa075
a0389d68 b432d3e1 ldrh     r3, [r3, #0x24]
a0389d6c 000053e3 cmp      r3, #0
a0389d70 3f00000a beq      #0xa0389e74
a0389d74 1b3b0ae3 movw     r3, #0xab1b
a0389d78 70314ae3 movt     r3, #0xa170
a0389d7c 0030d3e5 ldrb     r3, [r3]
a0389d80 010053e3 cmp      r3, #1
a0389d84 3a00001a bne      #0xa0389e74
a0389d88 f40200e3 movw     r0, #0x2f4
a0389d8c 60004ae3 movt     r0, #0xa060
a0389d90 d574fceb bl       #0xa02a70ec
a0389d94 003404e3 movw     r3, #0x4400
a0389d98 70314ae3 movt     r3, #0xa170
a0389d9c 883093e5 ldr      r3, [r3, #0x88]
a0389da0 a00500e3 movw     r0, #0x5a0
a0389da4 60004ae3 movt     r0, #0xa060
a0389da8 0310a0e1 mov      r1, r3
a0389dac ce74fceb bl       #0xa02a70ec
a0389db0 003404e3 movw     r3, #0x4400
a0389db4 70314ae3 movt     r3, #0xa170
a0389db8 8c3093e5 ldr      r3, [r3, #0x8c]
a0389dbc c80500e3 movw     r0, #0x5c8
a0389dc0 60004ae3 movt     r0, #0xa060
a0389dc4 0310a0e1 mov      r1, r3
a0389dc8 c774fceb bl       #0xa02a70ec
a0389dcc 003404e3 movw     r3, #0x4400
a0389dd0 70314ae3 movt     r3, #0xa170
a0389dd4 903093e5 ldr      r3, [r3, #0x90]
a0389dd8 f00500e3 movw     r0, #0x5f0
a0389ddc 60004ae3 movt     r0, #0xa060
a0389de0 0310a0e1 mov      r1, r3
a0389de4 c074fceb bl       #0xa02a70ec
a0389de8 003404e3 movw     r3, #0x4400
a0389dec 70314ae3 movt     r3, #0xa170
a0389df0 943093e5 ldr      r3, [r3, #0x94]
a0389df4 180600e3 movw     r0, #0x618
a0389df8 60004ae3 movt     r0, #0xa060
a0389dfc 0310a0e1 mov      r1, r3
a0389e00 b974fceb bl       #0xa02a70ec
a0389e04 003404e3 movw     r3, #0x4400
a0389e08 70314ae3 movt     r3, #0xa170
a0389e0c 703093e5 ldr      r3, [r3, #0x70]
a0389e10 400600e3 movw     r0, #0x640
a0389e14 60004ae3 movt     r0, #0xa060
a0389e18 0310a0e1 mov      r1, r3
a0389e1c b274fceb bl       #0xa02a70ec
a0389e20 003404e3 movw     r3, #0x4400
a0389e24 70314ae3 movt     r3, #0xa170
a0389e28 743093e5 ldr      r3, [r3, #0x74]
a0389e2c 640600e3 movw     r0, #0x664
a0389e30 60004ae3 movt     r0, #0xa060
a0389e34 0310a0e1 mov      r1, r3
a0389e38 ab74fceb bl       #0xa02a70ec
a0389e3c 003404e3 movw     r3, #0x4400
a0389e40 70314ae3 movt     r3, #0xa170
a0389e44 783093e5 ldr      r3, [r3, #0x78]
a0389e48 880600e3 movw     r0, #0x688
a0389e4c 60004ae3 movt     r0, #0xa060
a0389e50 0310a0e1 mov      r1, r3
a0389e54 a474fceb bl       #0xa02a70ec
a0389e58 003404e3 movw     r3, #0x4400
a0389e5c 70314ae3 movt     r3, #0xa170
a0389e60 7c3093e5 ldr      r3, [r3, #0x7c]
a0389e64 ac0600e3 movw     r0, #0x6ac
a0389e68 60004ae3 movt     r0, #0xa060
a0389e6c 0310a0e1 mov      r1, r3
a0389e70 9d74fceb bl       #0xa02a70ec
a0389e74 f83a07e3 movw     r3, #0x7af8
a0389e78 75304ae3 movt     r3, #0xa075
a0389e7c b434d3e1 ldrh     r3, [r3, #0x44]
a0389e80 000053e3 cmp      r3, #0
a0389e84 0700000a beq      #0xa0389ea8
a0389e88 003404e3 movw     r3, #0x4400
a0389e8c 70314ae3 movt     r3, #0xa170
a0389e90 4c3093e5 ldr      r3, [r3, #0x4c]
a0389e94 0320a0e1 mov      r2, r3
a0389e98 103304e3 movw     r3, #0x4310
a0389e9c 70314ae3 movt     r3, #0xa170
a0389ea0 102083e5 str      r2, [r3, #0x10]
a0389ea4 030000ea b        #0xa0389eb8
a0389ea8 103304e3 movw     r3, #0x4310
a0389eac 70314ae3 movt     r3, #0xa170
a0389eb0 0020a0e3 mov      r2, #0
a0389eb4 102083e5 str      r2, [r3, #0x10]
a0389eb8 183b0ae3 movw     r3, #0xab18
a0389ebc 70314ae3 movt     r3, #0xa170
a0389ec0 0030d3e5 ldrb     r3, [r3]
a0389ec4 000053e3 cmp      r3, #0
a0389ec8 0600000a beq      #0xa0389ee8
a0389ecc 7c3a07e3 movw     r3, #0x7a7c
a0389ed0 75304ae3 movt     r3, #0xa075
a0389ed4 002093e5 ldr      r2, [r3]
a0389ed8 103304e3 movw     r3, #0x4310
a0389edc 70314ae3 movt     r3, #0xa170
a0389ee0 142083e5 str      r2, [r3, #0x14]
a0389ee4 190000ea b        #0xa0389f50
a0389ee8 bc3004e3 movw     r3, #0x40bc
a0389eec 70314ae3 movt     r3, #0xa170
a0389ef0 003093e5 ldr      r3, [r3]
a0389ef4 0320a0e1 mov      r2, r3
a0389ef8 0030a0e3 mov      r3, #0
a0389efc 0230a0e1 mov      r3, r2
a0389f00 04318de5 str      r3, [sp, #0x104]
a0389f04 0030a0e3 mov      r3, #0
a0389f08 00318de5 str      r3, [sp, #0x100]
a0389f0c 643504e3 movw     r3, #0x4564
a0389f10 70314ae3 movt     r3, #0xa170
a0389f14 342093e5 ldr      r2, [r3, #0x34]
a0389f18 643504e3 movw     r3, #0x4564
a0389f1c 70314ae3 movt     r3, #0xa170
a0389f20 2c3093e5 ldr      r3, [r3, #0x2c]
a0389f24 023063e0 rsb      r3, r3, r2
a0389f28 0320a0e1 mov      r2, r3
a0389f2c 0030a0e3 mov      r3, #0
a0389f30 011c8de2 add      r1, sp, #0x100
a0389f34 d000c1e1 ldrd     r0, r1, [r1]
a0389f38 fef305fa blx      #0xa0506f38
a0389f3c 0020a0e1 mov      r2, r0
a0389f40 0130a0e1 mov      r3, r1
a0389f44 103304e3 movw     r3, #0x4310
a0389f48 70314ae3 movt     r3, #0xa170
a0389f4c 142083e5 str      r2, [r3, #0x14]
a0389f50 003404e3 movw     r3, #0x4400
a0389f54 70314ae3 movt     r3, #0xa170
a0389f58 703093e5 ldr      r3, [r3, #0x70]
a0389f5c 7320ffe6 uxth     r2, r3
a0389f60 103304e3 movw     r3, #0x4310
a0389f64 70314ae3 movt     r3, #0xa170
a0389f68 b821c3e1 strh     r2, [r3, #0x18]
a0389f6c 003404e3 movw     r3, #0x4400
a0389f70 70314ae3 movt     r3, #0xa170
a0389f74 743093e5 ldr      r3, [r3, #0x74]
a0389f78 7320ffe6 uxth     r2, r3
a0389f7c 103304e3 movw     r3, #0x4310
a0389f80 70314ae3 movt     r3, #0xa170
a0389f84 ba21c3e1 strh     r2, [r3, #0x1a]
a0389f88 103304e3 movw     r3, #0x4310
a0389f8c 70314ae3 movt     r3, #0xa170
a0389f90 0020a0e3 mov      r2, #0
a0389f94 bc21c3e1 strh     r2, [r3, #0x1c]
a0389f98 103304e3 movw     r3, #0x4310
a0389f9c 70314ae3 movt     r3, #0xa170
a0389fa0 0020a0e3 mov      r2, #0
a0389fa4 be21c3e1 strh     r2, [r3, #0x1e]
a0389fa8 1b3b0ae3 movw     r3, #0xab1b
a0389fac 70314ae3 movt     r3, #0xa170
a0389fb0 0030d3e5 ldrb     r3, [r3]
a0389fb4 013043e2 sub      r3, r3, #1
a0389fb8 0320a0e1 mov      r2, r3
a0389fbc 103304e3 movw     r3, #0x4310
a0389fc0 70314ae3 movt     r3, #0xa170
a0389fc4 202083e5 str      r2, [r3, #0x20]
a0389fc8 1b3b0ae3 movw     r3, #0xab1b
a0389fcc 70314ae3 movt     r3, #0xa170
a0389fd0 0030d3e5 ldrb     r3, [r3]
a0389fd4 011043e2 sub      r1, r3, #1
a0389fd8 2c3204e3 movw     r3, #0x422c
a0389fdc 70314ae3 movt     r3, #0xa170
a0389fe0 000093e5 ldr      r0, [r3]
a0389fe4 a0230be3 movw     r2, #0xb3a0
a0389fe8 70214ae3 movt     r2, #0xa170
a0389fec 8131a0e1 lsl      r3, r1, #3
a0389ff0 0310a0e1 mov      r1, r3
a0389ff4 0131a0e1 lsl      r3, r1, #2
a0389ff8 033061e0 rsb      r3, r1, r3
a0389ffc 033082e0 add      r3, r2, r3
a038a000 000083e5 str      r0, [r3]
a038a004 1b3b0ae3 movw     r3, #0xab1b
a038a008 70314ae3 movt     r3, #0xa170
a038a00c 0030d3e5 ldrb     r3, [r3]
a038a010 011043e2 sub      r1, r3, #1
a038a014 003404e3 movw     r3, #0x4400
a038a018 70314ae3 movt     r3, #0xa170
a038a01c 880093e5 ldr      r0, [r3, #0x88]
a038a020 a0230be3 movw     r2, #0xb3a0
a038a024 70214ae3 movt     r2, #0xa170
a038a028 8131a0e1 lsl      r3, r1, #3
a038a02c 0310a0e1 mov      r1, r3
a038a030 0131a0e1 lsl      r3, r1, #2
a038a034 033061e0 rsb      r3, r1, r3
a038a038 033082e0 add      r3, r2, r3
a038a03c 040083e5 str      r0, [r3, #4]
a038a040 1b3b0ae3 movw     r3, #0xab1b
a038a044 70314ae3 movt     r3, #0xa170
a038a048 0030d3e5 ldrb     r3, [r3]
a038a04c 011043e2 sub      r1, r3, #1
a038a050 003404e3 movw     r3, #0x4400
a038a054 70314ae3 movt     r3, #0xa170
a038a058 8c0093e5 ldr      r0, [r3, #0x8c]
a038a05c a0230be3 movw     r2, #0xb3a0
a038a060 70214ae3 movt     r2, #0xa170
a038a064 8131a0e1 lsl      r3, r1, #3
a038a068 0310a0e1 mov      r1, r3
a038a06c 0131a0e1 lsl      r3, r1, #2
a038a070 033061e0 rsb      r3, r1, r3
a038a074 033082e0 add      r3, r2, r3
a038a078 083083e2 add      r3, r3, #8
a038a07c 000083e5 str      r0, [r3]
a038a080 1b3b0ae3 movw     r3, #0xab1b
a038a084 70314ae3 movt     r3, #0xa170
a038a088 0030d3e5 ldrb     r3, [r3]
a038a08c 011043e2 sub      r1, r3, #1
a038a090 ac3e0ae3 movw     r3, #0xaeac
a038a094 70314ae3 movt     r3, #0xa170
a038a098 000093e5 ldr      r0, [r3]
a038a09c a0230be3 movw     r2, #0xb3a0
a038a0a0 70214ae3 movt     r2, #0xa170
a038a0a4 8131a0e1 lsl      r3, r1, #3
a038a0a8 0310a0e1 mov      r1, r3
a038a0ac 0131a0e1 lsl      r3, r1, #2
a038a0b0 033061e0 rsb      r3, r1, r3
a038a0b4 033082e0 add      r3, r2, r3
a038a0b8 083083e2 add      r3, r3, #8
a038a0bc 040083e5 str      r0, [r3, #4]
a038a0c0 1b3b0ae3 movw     r3, #0xab1b
a038a0c4 70314ae3 movt     r3, #0xa170
a038a0c8 0030d3e5 ldrb     r3, [r3]
a038a0cc 011043e2 sub      r1, r3, #1
a038a0d0 003f0ae3 movw     r3, #0xaf00
a038a0d4 70314ae3 movt     r3, #0xa170
a038a0d8 000093e5 ldr      r0, [r3]
a038a0dc a0230be3 movw     r2, #0xb3a0
a038a0e0 70214ae3 movt     r2, #0xa170
a038a0e4 8131a0e1 lsl      r3, r1, #3
a038a0e8 0310a0e1 mov      r1, r3
a038a0ec 0131a0e1 lsl      r3, r1, #2
a038a0f0 033061e0 rsb      r3, r1, r3
a038a0f4 033082e0 add      r3, r2, r3
a038a0f8 103083e2 add      r3, r3, #0x10
a038a0fc 000083e5 str      r0, [r3]
a038a100 1b3b0ae3 movw     r3, #0xab1b
a038a104 70314ae3 movt     r3, #0xa170
a038a108 0030d3e5 ldrb     r3, [r3]
a038a10c 011043e2 sub      r1, r3, #1
a038a110 003404e3 movw     r3, #0x4400
a038a114 70314ae3 movt     r3, #0xa170
a038a118 200093e5 ldr      r0, [r3, #0x20]
a038a11c a0230be3 movw     r2, #0xb3a0
a038a120 70214ae3 movt     r2, #0xa170
a038a124 8131a0e1 lsl      r3, r1, #3
a038a128 0310a0e1 mov      r1, r3
a038a12c 0131a0e1 lsl      r3, r1, #2
a038a130 033061e0 rsb      r3, r1, r3
a038a134 033082e0 add      r3, r2, r3
a038a138 103083e2 add      r3, r3, #0x10
a038a13c 040083e5 str      r0, [r3, #4]
a038a140 f83a07e3 movw     r3, #0x7af8
a038a144 75304ae3 movt     r3, #0xa075
a038a148 b232d3e1 ldrh     r3, [r3, #0x22]
a038a14c 000053e3 cmp      r3, #0
a038a150 1900000a beq      #0xa038a1bc
a038a154 1b3b0ae3 movw     r3, #0xab1b
a038a158 70314ae3 movt     r3, #0xa170
a038a15c 0030d3e5 ldrb     r3, [r3]
a038a160 0310a0e1 mov      r1, r3
a038a164 1d3b0ae3 movw     r3, #0xab1d
a038a168 70314ae3 movt     r3, #0xa170
a038a16c 0030d3e5 ldrb     r3, [r3]
a038a170 03e0a0e1 mov      lr, r3
a038a174 2c3204e3 movw     r3, #0x422c
a038a178 70314ae3 movt     r3, #0xa170
a038a17c 00c093e5 ldr      ip, [r3]
a038a180 283204e3 movw     r3, #0x4228
a038a184 70314ae3 movt     r3, #0xa170
a038a188 0030d3e5 ldrb     r3, [r3]
a038a18c 7320afe6 sxtb     r2, r3
a038a190 293204e3 movw     r3, #0x4229
a038a194 70314ae3 movt     r3, #0xa170
a038a198 0030d3e5 ldrb     r3, [r3]
a038a19c 7330afe6 sxtb     r3, r3
a038a1a0 00208de5 str      r2, [sp]
a038a1a4 04308de5 str      r3, [sp, #4]
a038a1a8 d00600e3 movw     r0, #0x6d0
a038a1ac 60004ae3 movt     r0, #0xa060
a038a1b0 0e20a0e1 mov      r2, lr
a038a1b4 0c30a0e1 mov      r3, ip
a038a1b8 cb73fceb bl       #0xa02a70ec
a038a1bc 98330be3 movw     r3, #0xb398
a038a1c0 70314ae3 movt     r3, #0xa170
a038a1c4 0030d3e5 ldrb     r3, [r3]
a038a1c8 000053e3 cmp      r3, #0
a038a1cc 0300001a bne      #0xa038a1e0
a038a1d0 98330be3 movw     r3, #0xb398
a038a1d4 70314ae3 movt     r3, #0xa170
a038a1d8 0120a0e3 mov      r2, #1
a038a1dc 0020c3e5 strb     r2, [r3]
a038a1e0 003404e3 movw     r3, #0x4400
a038a1e4 70314ae3 movt     r3, #0xa170
a038a1e8 882093e5 ldr      r2, [r3, #0x88]
a038a1ec 003404e3 movw     r3, #0x4400
a038a1f0 70314ae3 movt     r3, #0xa170
a038a1f4 703093e5 ldr      r3, [r3, #0x70]
a038a1f8 0338a0e1 lsl      r3, r3, #0x10
a038a1fc 022063e0 rsb      r2, r3, r2
a038a200 103304e3 movw     r3, #0x4310
a038a204 70314ae3 movt     r3, #0xa170
a038a208 002083e5 str      r2, [r3]
a038a20c 003404e3 movw     r3, #0x4400
a038a210 70314ae3 movt     r3, #0xa170
a038a214 8c2093e5 ldr      r2, [r3, #0x8c]
a038a218 003404e3 movw     r3, #0x4400
a038a21c 70314ae3 movt     r3, #0xa170
a038a220 743093e5 ldr      r3, [r3, #0x74]
a038a224 0338a0e1 lsl      r3, r3, #0x10
a038a228 022063e0 rsb      r2, r3, r2
a038a22c 103304e3 movw     r3, #0x4310
a038a230 70314ae3 movt     r3, #0xa170
a038a234 042083e5 str      r2, [r3, #4]
a038a238 003404e3 movw     r3, #0x4400
a038a23c 70314ae3 movt     r3, #0xa170
a038a240 902093e5 ldr      r2, [r3, #0x90]
a038a244 003404e3 movw     r3, #0x4400
a038a248 70314ae3 movt     r3, #0xa170
a038a24c 703093e5 ldr      r3, [r3, #0x70]
a038a250 0338a0e1 lsl      r3, r3, #0x10
a038a254 022063e0 rsb      r2, r3, r2
a038a258 103304e3 movw     r3, #0x4310
a038a25c 70314ae3 movt     r3, #0xa170
a038a260 082083e5 str      r2, [r3, #8]
a038a264 003404e3 movw     r3, #0x4400
a038a268 70314ae3 movt     r3, #0xa170
a038a26c 942093e5 ldr      r2, [r3, #0x94]
a038a270 003404e3 movw     r3, #0x4400
a038a274 70314ae3 movt     r3, #0xa170
a038a278 743093e5 ldr      r3, [r3, #0x74]
a038a27c 0338a0e1 lsl      r3, r3, #0x10
a038a280 022063e0 rsb      r2, r3, r2
a038a284 103304e3 movw     r3, #0x4310
a038a288 70314ae3 movt     r3, #0xa170
a038a28c 0c2083e5 str      r2, [r3, #0xc]
a038a290 482304e3 movw     r2, #0x4348
a038a294 70214ae3 movt     r2, #0xa170
a038a298 103304e3 movw     r3, #0x4310
a038a29c 70314ae3 movt     r3, #0xa170
a038a2a0 02c0a0e1 mov      ip, r2
a038a2a4 03e0a0e1 mov      lr, r3
a038a2a8 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a038a2ac 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a038a2b0 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a038a2b4 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a038a2b8 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a038a2bc 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a038a2c0 03009ee8 ldm      lr, {r0, r1}
a038a2c4 03008ce8 stm      ip, {r0, r1}
a038a2c8 003404e3 movw     r3, #0x4400
a038a2cc 70314ae3 movt     r3, #0xa170
a038a2d0 643093e5 ldr      r3, [r3, #0x64]
a038a2d4 010053e3 cmp      r3, #1
a038a2d8 7000001a bne      #0xa038a4a0
a038a2dc 003404e3 movw     r3, #0x4400
a038a2e0 70314ae3 movt     r3, #0xa170
a038a2e4 9c2093e5 ldr      r2, [r3, #0x9c]
a038a2e8 003404e3 movw     r3, #0x4400
a038a2ec 70314ae3 movt     r3, #0xa170
a038a2f0 743093e5 ldr      r3, [r3, #0x74]
a038a2f4 0338a0e1 lsl      r3, r3, #0x10
a038a2f8 022063e0 rsb      r2, r3, r2
a038a2fc 103304e3 movw     r3, #0x4310
a038a300 70314ae3 movt     r3, #0xa170
a038a304 042083e5 str      r2, [r3, #4]
a038a308 003404e3 movw     r3, #0x4400
a038a30c 70314ae3 movt     r3, #0xa170
a038a310 a42093e5 ldr      r2, [r3, #0xa4]
a038a314 003404e3 movw     r3, #0x4400
a038a318 70314ae3 movt     r3, #0xa170
a038a31c 743093e5 ldr      r3, [r3, #0x74]
a038a320 0338a0e1 lsl      r3, r3, #0x10
a038a324 022063e0 rsb      r2, r3, r2
a038a328 103304e3 movw     r3, #0x4310
a038a32c 70314ae3 movt     r3, #0xa170
a038a330 0c2083e5 str      r2, [r3, #0xc]
a038a334 b82304e3 movw     r2, #0x43b8
a038a338 70214ae3 movt     r2, #0xa170
a038a33c 103304e3 movw     r3, #0x4310
a038a340 70314ae3 movt     r3, #0xa170
a038a344 02c0a0e1 mov      ip, r2
a038a348 03e0a0e1 mov      lr, r3
a038a34c 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a038a350 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a038a354 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a038a358 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a038a35c 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a038a360 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a038a364 03009ee8 ldm      lr, {r0, r1}
a038a368 03008ce8 stm      ip, {r0, r1}
a038a36c db3504e3 movw     r3, #0x45db
a038a370 70314ae3 movt     r3, #0xa170
a038a374 0030d3e5 ldrb     r3, [r3]
a038a378 023003e2 and      r3, r3, #2
a038a37c 000053e3 cmp      r3, #0
a038a380 4600000a beq      #0xa038a4a0
a038a384 1e3b0ae3 movw     r3, #0xab1e
a038a388 70314ae3 movt     r3, #0xa170
a038a38c 0030d3e5 ldrb     r3, [r3]
a038a390 000053e3 cmp      r3, #0
a038a394 4100000a beq      #0xa038a4a0
a038a398 483304e3 movw     r3, #0x4348
a038a39c 70314ae3 movt     r3, #0xa170
a038a3a0 042093e5 ldr      r2, [r3, #4]
a038a3a4 803304e3 movw     r3, #0x4380
a038a3a8 70314ae3 movt     r3, #0xa170
a038a3ac 043093e5 ldr      r3, [r3, #4]
a038a3b0 022063e0 rsb      r2, r3, r2
a038a3b4 c4390be3 movw     r3, #0xb9c4
a038a3b8 70314ae3 movt     r3, #0xa170
a038a3bc 002083e5 str      r2, [r3]
a038a3c0 483304e3 movw     r3, #0x4348
a038a3c4 70314ae3 movt     r3, #0xa170
a038a3c8 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038a3cc 0320a0e1 mov      r2, r3
a038a3d0 c8390be3 movw     r3, #0xb9c8
a038a3d4 70314ae3 movt     r3, #0xa170
a038a3d8 002083e5 str      r2, [r3]
a038a3dc 483304e3 movw     r3, #0x4348
a038a3e0 70314ae3 movt     r3, #0xa170
a038a3e4 042093e5 ldr      r2, [r3, #4]
a038a3e8 803304e3 movw     r3, #0x4380
a038a3ec 70314ae3 movt     r3, #0xa170
a038a3f0 043093e5 ldr      r3, [r3, #4]
a038a3f4 030052e1 cmp      r2, r3
a038a3f8 0d00002a bhs      #0xa038a434
a038a3fc c8390be3 movw     r3, #0xb9c8
a038a400 70314ae3 movt     r3, #0xa170
a038a404 003093e5 ldr      r3, [r3]
a038a408 022043e2 sub      r2, r3, #2
a038a40c c8390be3 movw     r3, #0xb9c8
a038a410 70314ae3 movt     r3, #0xa170
a038a414 002083e5 str      r2, [r3]
a038a418 c4390be3 movw     r3, #0xb9c4
a038a41c 70314ae3 movt     r3, #0xa170
a038a420 003093e5 ldr      r3, [r3]
a038a424 022883e2 add      r2, r3, #0x20000
a038a428 c4390be3 movw     r3, #0xb9c4
a038a42c 70314ae3 movt     r3, #0xa170
a038a430 002083e5 str      r2, [r3]
a038a434 103304e3 movw     r3, #0x4310
a038a438 70314ae3 movt     r3, #0xa170
a038a43c 042093e5 ldr      r2, [r3, #4]
a038a440 c4390be3 movw     r3, #0xb9c4
a038a444 70314ae3 movt     r3, #0xa170
a038a448 003093e5 ldr      r3, [r3]
a038a44c 032082e0 add      r2, r2, r3
a038a450 103304e3 movw     r3, #0x4310
a038a454 70314ae3 movt     r3, #0xa170
a038a458 042083e5 str      r2, [r3, #4]
a038a45c 103304e3 movw     r3, #0x4310
a038a460 70314ae3 movt     r3, #0xa170
a038a464 0c2093e5 ldr      r2, [r3, #0xc]
a038a468 c4390be3 movw     r3, #0xb9c4
a038a46c 70314ae3 movt     r3, #0xa170
a038a470 003093e5 ldr      r3, [r3]
a038a474 032082e0 add      r2, r2, r3
a038a478 103304e3 movw     r3, #0x4310
a038a47c 70314ae3 movt     r3, #0xa170
a038a480 0c2083e5 str      r2, [r3, #0xc]
a038a484 c8390be3 movw     r3, #0xb9c8
a038a488 70314ae3 movt     r3, #0xa170
a038a48c 003093e5 ldr      r3, [r3]
a038a490 7320ffe6 uxth     r2, r3
a038a494 103304e3 movw     r3, #0x4310
a038a498 70314ae3 movt     r3, #0xa170
a038a49c ba21c3e1 strh     r2, [r3, #0x1a]
a038a4a0 d93504e3 movw     r3, #0x45d9
a038a4a4 70314ae3 movt     r3, #0xa170
a038a4a8 0030d3e5 ldrb     r3, [r3]
a038a4ac 000053e3 cmp      r3, #0
a038a4b0 5b00000a beq      #0xa038a624
a038a4b4 643504e3 movw     r3, #0x4564
a038a4b8 70314ae3 movt     r3, #0xa170
a038a4bc 282093e5 ldr      r2, [r3, #0x28]
a038a4c0 643504e3 movw     r3, #0x4564
a038a4c4 70314ae3 movt     r3, #0xa170
a038a4c8 103093e5 ldr      r3, [r3, #0x10]
a038a4cc 0338a0e1 lsl      r3, r3, #0x10
a038a4d0 022063e0 rsb      r2, r3, r2
a038a4d4 cc390be3 movw     r3, #0xb9cc
a038a4d8 70314ae3 movt     r3, #0xa170
a038a4dc 003093e5 ldr      r3, [r3]
a038a4e0 032082e0 add      r2, r2, r3
a038a4e4 103304e3 movw     r3, #0x4310
a038a4e8 70314ae3 movt     r3, #0xa170
a038a4ec 002083e5 str      r2, [r3]
a038a4f0 643504e3 movw     r3, #0x4564
a038a4f4 70314ae3 movt     r3, #0xa170
a038a4f8 2c2093e5 ldr      r2, [r3, #0x2c]
a038a4fc 643504e3 movw     r3, #0x4564
a038a500 70314ae3 movt     r3, #0xa170
a038a504 143093e5 ldr      r3, [r3, #0x14]
a038a508 0338a0e1 lsl      r3, r3, #0x10
a038a50c 022063e0 rsb      r2, r3, r2
a038a510 103304e3 movw     r3, #0x4310
a038a514 70314ae3 movt     r3, #0xa170
a038a518 042083e5 str      r2, [r3, #4]
a038a51c 643504e3 movw     r3, #0x4564
a038a520 70314ae3 movt     r3, #0xa170
a038a524 302093e5 ldr      r2, [r3, #0x30]
a038a528 643504e3 movw     r3, #0x4564
a038a52c 70314ae3 movt     r3, #0xa170
a038a530 103093e5 ldr      r3, [r3, #0x10]
a038a534 0338a0e1 lsl      r3, r3, #0x10
a038a538 022063e0 rsb      r2, r3, r2
a038a53c d0390be3 movw     r3, #0xb9d0
a038a540 70314ae3 movt     r3, #0xa170
a038a544 003093e5 ldr      r3, [r3]
a038a548 032082e0 add      r2, r2, r3
a038a54c 103304e3 movw     r3, #0x4310
a038a550 70314ae3 movt     r3, #0xa170
a038a554 082083e5 str      r2, [r3, #8]
a038a558 643504e3 movw     r3, #0x4564
a038a55c 70314ae3 movt     r3, #0xa170
a038a560 342093e5 ldr      r2, [r3, #0x34]
a038a564 643504e3 movw     r3, #0x4564
a038a568 70314ae3 movt     r3, #0xa170
a038a56c 143093e5 ldr      r3, [r3, #0x14]
a038a570 0338a0e1 lsl      r3, r3, #0x10
a038a574 022063e0 rsb      r2, r3, r2
a038a578 103304e3 movw     r3, #0x4310
a038a57c 70314ae3 movt     r3, #0xa170
a038a580 0c2083e5 str      r2, [r3, #0xc]
a038a584 003404e3 movw     r3, #0x4400
a038a588 70314ae3 movt     r3, #0xa170
a038a58c 643093e5 ldr      r3, [r3, #0x64]
a038a590 010053e3 cmp      r3, #1
a038a594 0a00001a bne      #0xa038a5c4
a038a598 103304e3 movw     r3, #0x4310
a038a59c 70314ae3 movt     r3, #0xa170
a038a5a0 0020a0e3 mov      r2, #0
a038a5a4 042083e5 str      r2, [r3, #4]
a038a5a8 643504e3 movw     r3, #0x4564
a038a5ac 70314ae3 movt     r3, #0xa170
a038a5b0 1c3093e5 ldr      r3, [r3, #0x1c]
a038a5b4 0328a0e1 lsl      r2, r3, #0x10
a038a5b8 103304e3 movw     r3, #0x4310
a038a5bc 70314ae3 movt     r3, #0xa170
a038a5c0 0c2083e5 str      r2, [r3, #0xc]
a038a5c4 643504e3 movw     r3, #0x4564
a038a5c8 70314ae3 movt     r3, #0xa170
a038a5cc 103093e5 ldr      r3, [r3, #0x10]
a038a5d0 7320ffe6 uxth     r2, r3
a038a5d4 103304e3 movw     r3, #0x4310
a038a5d8 70314ae3 movt     r3, #0xa170
a038a5dc b821c3e1 strh     r2, [r3, #0x18]
a038a5e0 643504e3 movw     r3, #0x4564
a038a5e4 70314ae3 movt     r3, #0xa170
a038a5e8 143093e5 ldr      r3, [r3, #0x14]
a038a5ec 7320ffe6 uxth     r2, r3
a038a5f0 c8390be3 movw     r3, #0xb9c8
a038a5f4 70314ae3 movt     r3, #0xa170
a038a5f8 003093e5 ldr      r3, [r3]
a038a5fc 7330ffe6 uxth     r3, r3
a038a600 033082e0 add      r3, r2, r3
a038a604 7320ffe6 uxth     r2, r3
a038a608 103304e3 movw     r3, #0x4310
a038a60c 70314ae3 movt     r3, #0xa170
a038a610 ba21c3e1 strh     r2, [r3, #0x1a]
a038a614 103304e3 movw     r3, #0x4310
a038a618 70314ae3 movt     r3, #0xa170
a038a61c 0020a0e3 mov      r2, #0
a038a620 102083e5 str      r2, [r3, #0x10]
a038a624 b83f0ae3 movw     r3, #0xafb8
a038a628 70314ae3 movt     r3, #0xa170
a038a62c 0030d3e5 ldrb     r3, [r3]
a038a630 000053e3 cmp      r3, #0
a038a634 1000000a beq      #0xa038a67c
a038a638 103304e3 movw     r3, #0x4310
a038a63c 70314ae3 movt     r3, #0xa170
a038a640 203093e5 ldr      r3, [r3, #0x20]
a038a644 012c83e3 orr      r2, r3, #0x100
a038a648 103304e3 movw     r3, #0x4310
a038a64c 70314ae3 movt     r3, #0xa170
a038a650 202083e5 str      r2, [r3, #0x20]
a038a654 f83a07e3 movw     r3, #0x7af8
a038a658 75304ae3 movt     r3, #0xa075
a038a65c be30d3e1 ldrh     r3, [r3, #0xe]
a038a660 000053e3 cmp      r3, #0
a038a664 0800000a beq      #0xa038a68c
a038a668 103304e3 movw     r3, #0x4310
a038a66c 70314ae3 movt     r3, #0xa170
a038a670 0020a0e3 mov      r2, #0
a038a674 242083e5 str      r2, [r3, #0x24]
a038a678 030000ea b        #0xa038a68c
a038a67c 103304e3 movw     r3, #0x4310
a038a680 70314ae3 movt     r3, #0xa170
a038a684 0020a0e3 mov      r2, #0
a038a688 242083e5 str      r2, [r3, #0x24]
a038a68c f83a07e3 movw     r3, #0x7af8
a038a690 75304ae3 movt     r3, #0xa075
a038a694 b430d3e1 ldrh     r3, [r3, #4]
a038a698 010053e3 cmp      r3, #1
a038a69c 6100001a bne      #0xa038a828
a038a6a0 1b3b0ae3 movw     r3, #0xab1b
a038a6a4 70314ae3 movt     r3, #0xa170
a038a6a8 0030d3e5 ldrb     r3, [r3]
a038a6ac 010053e3 cmp      r3, #1
a038a6b0 5c00001a bne      #0xa038a828
a038a6b4 103304e3 movw     r3, #0x4310
a038a6b8 70314ae3 movt     r3, #0xa170
a038a6bc 003093e5 ldr      r3, [r3]
a038a6c0 2338a0e1 lsr      r3, r3, #0x10
a038a6c4 88308de5 str      r3, [sp, #0x88]
a038a6c8 103304e3 movw     r3, #0x4310
a038a6cc 70314ae3 movt     r3, #0xa170
a038a6d0 043093e5 ldr      r3, [r3, #4]
a038a6d4 2328a0e1 lsr      r2, r3, #0x10
a038a6d8 90208de5 str      r2, [sp, #0x90]
a038a6dc 103304e3 movw     r3, #0x4310
a038a6e0 70314ae3 movt     r3, #0xa170
a038a6e4 082093e5 ldr      r2, [r3, #8]
a038a6e8 103304e3 movw     r3, #0x4310
a038a6ec 70314ae3 movt     r3, #0xa170
a038a6f0 003093e5 ldr      r3, [r3]
a038a6f4 023063e0 rsb      r3, r3, r2
a038a6f8 23b8a0e1 lsr      fp, r3, #0x10
a038a6fc 103304e3 movw     r3, #0x4310
a038a700 70314ae3 movt     r3, #0xa170
a038a704 0c2093e5 ldr      r2, [r3, #0xc]
a038a708 103304e3 movw     r3, #0x4310
a038a70c 70314ae3 movt     r3, #0xa170
a038a710 043093e5 ldr      r3, [r3, #4]
a038a714 023063e0 rsb      r3, r3, r2
a038a718 23e8a0e1 lsr      lr, r3, #0x10
a038a71c 103304e3 movw     r3, #0x4310
a038a720 70314ae3 movt     r3, #0xa170
a038a724 b831d3e1 ldrh     r3, [r3, #0x18]
a038a728 0370a0e1 mov      r7, r3
a038a72c 103304e3 movw     r3, #0x4310
a038a730 70314ae3 movt     r3, #0xa170
a038a734 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038a738 0380a0e1 mov      r8, r3
a038a73c 103304e3 movw     r3, #0x4310
a038a740 70314ae3 movt     r3, #0xa170
a038a744 bc31d3e1 ldrh     r3, [r3, #0x1c]
a038a748 0390a0e1 mov      sb, r3
a038a74c 103304e3 movw     r3, #0x4310
a038a750 70314ae3 movt     r3, #0xa170
a038a754 be31d3e1 ldrh     r3, [r3, #0x1e]
a038a758 03a0a0e1 mov      sl, r3
a038a75c 103304e3 movw     r3, #0x4310
a038a760 70314ae3 movt     r3, #0xa170
a038a764 106093e5 ldr      r6, [r3, #0x10]
a038a768 003404e3 movw     r3, #0x4400
a038a76c 70314ae3 movt     r3, #0xa170
a038a770 1c3093e5 ldr      r3, [r3, #0x1c]
a038a774 4358a0e1 asr      r5, r3, #0x10
a038a778 003404e3 movw     r3, #0x4400
a038a77c 70314ae3 movt     r3, #0xa170
a038a780 203093e5 ldr      r3, [r3, #0x20]
a038a784 4348a0e1 asr      r4, r3, #0x10
a038a788 cc390be3 movw     r3, #0xb9cc
a038a78c 70314ae3 movt     r3, #0xa170
a038a790 003093e5 ldr      r3, [r3]
a038a794 43c8a0e1 asr      ip, r3, #0x10
a038a798 d0390be3 movw     r3, #0xb9d0
a038a79c 70314ae3 movt     r3, #0xa170
a038a7a0 003093e5 ldr      r3, [r3]
a038a7a4 4308a0e1 asr      r0, r3, #0x10
a038a7a8 c8390be3 movw     r3, #0xb9c8
a038a7ac 70314ae3 movt     r3, #0xa170
a038a7b0 003093e5 ldr      r3, [r3]
a038a7b4 4318a0e1 asr      r1, r3, #0x10
a038a7b8 d03204e3 movw     r3, #0x42d0
a038a7bc 70314ae3 movt     r3, #0xa170
a038a7c0 003093e5 ldr      r3, [r3]
a038a7c4 4328a0e1 asr      r2, r3, #0x10
a038a7c8 d03204e3 movw     r3, #0x42d0
a038a7cc 70314ae3 movt     r3, #0xa170
a038a7d0 043093e5 ldr      r3, [r3, #4]
a038a7d4 4338a0e1 asr      r3, r3, #0x10
a038a7d8 00e08de5 str      lr, [sp]
a038a7dc 04708de5 str      r7, [sp, #4]
a038a7e0 08808de5 str      r8, [sp, #8]
a038a7e4 0c908de5 str      sb, [sp, #0xc]
a038a7e8 10a08de5 str      sl, [sp, #0x10]
a038a7ec 14608de5 str      r6, [sp, #0x14]
a038a7f0 18508de5 str      r5, [sp, #0x18]
a038a7f4 1c408de5 str      r4, [sp, #0x1c]
a038a7f8 20c08de5 str      ip, [sp, #0x20]
a038a7fc 24008de5 str      r0, [sp, #0x24]
a038a800 28108de5 str      r1, [sp, #0x28]
a038a804 2c208de5 str      r2, [sp, #0x2c]
a038a808 30308de5 str      r3, [sp, #0x30]
a038a80c f80600e3 movw     r0, #0x6f8
a038a810 60004ae3 movt     r0, #0xa060
a038a814 88109de5 ldr      r1, [sp, #0x88]
a038a818 90209de5 ldr      r2, [sp, #0x90]
a038a81c 0b30a0e1 mov      r3, fp
a038a820 3172fceb bl       #0xa02a70ec
a038a824 8e0200ea b        #0xa038b264
a038a828 f83a07e3 movw     r3, #0x7af8
a038a82c 75304ae3 movt     r3, #0xa075
a038a830 b430d3e1 ldrh     r3, [r3, #4]
a038a834 020053e3 cmp      r3, #2
a038a838 5a00001a bne      #0xa038a9a8
a038a83c 1b3b0ae3 movw     r3, #0xab1b
a038a840 70314ae3 movt     r3, #0xa170
a038a844 0030d3e5 ldrb     r3, [r3]
a038a848 010053e3 cmp      r3, #1
a038a84c 5500001a bne      #0xa038a9a8
a038a850 483304e3 movw     r3, #0x4348
a038a854 70314ae3 movt     r3, #0xa170
a038a858 003093e5 ldr      r3, [r3]
a038a85c 88308de5 str      r3, [sp, #0x88]
a038a860 483304e3 movw     r3, #0x4348
a038a864 70314ae3 movt     r3, #0xa170
a038a868 04b093e5 ldr      fp, [r3, #4]
a038a86c 483304e3 movw     r3, #0x4348
a038a870 70314ae3 movt     r3, #0xa170
a038a874 043093e5 ldr      r3, [r3, #4]
a038a878 903a07ee vmov     s15, r3
a038a87c 677af8ee vcvt.f32.u32 s15, s15
a038a880 cd7a9fed vldr     s14, [pc, #0x334]
a038a884 877ac7ee vdiv.f32 s15, s15, s14
a038a888 e70af7ee vcvt.f64.f32 d16, s15
a038a88c 483304e3 movw     r3, #0x4348
a038a890 70314ae3 movt     r3, #0xa170
a038a894 08e093e5 ldr      lr, [r3, #8]
a038a898 483304e3 movw     r3, #0x4348
a038a89c 70314ae3 movt     r3, #0xa170
a038a8a0 0c4093e5 ldr      r4, [r3, #0xc]
a038a8a4 103304e3 movw     r3, #0x4310
a038a8a8 70314ae3 movt     r3, #0xa170
a038a8ac b831d3e1 ldrh     r3, [r3, #0x18]
a038a8b0 0380a0e1 mov      r8, r3
a038a8b4 103304e3 movw     r3, #0x4310
a038a8b8 70314ae3 movt     r3, #0xa170
a038a8bc ba31d3e1 ldrh     r3, [r3, #0x1a]
a038a8c0 0390a0e1 mov      sb, r3
a038a8c4 103304e3 movw     r3, #0x4310
a038a8c8 70314ae3 movt     r3, #0xa170
a038a8cc bc31d3e1 ldrh     r3, [r3, #0x1c]
a038a8d0 03a0a0e1 mov      sl, r3
a038a8d4 103304e3 movw     r3, #0x4310
a038a8d8 70314ae3 movt     r3, #0xa170
a038a8dc be31d3e1 ldrh     r3, [r3, #0x1e]
a038a8e0 90308de5 str      r3, [sp, #0x90]
a038a8e4 103304e3 movw     r3, #0x4310
a038a8e8 70314ae3 movt     r3, #0xa170
a038a8ec 107093e5 ldr      r7, [r3, #0x10]
a038a8f0 003404e3 movw     r3, #0x4400
a038a8f4 70314ae3 movt     r3, #0xa170
a038a8f8 1c6093e5 ldr      r6, [r3, #0x1c]
a038a8fc 003404e3 movw     r3, #0x4400
a038a900 70314ae3 movt     r3, #0xa170
a038a904 205093e5 ldr      r5, [r3, #0x20]
a038a908 cc390be3 movw     r3, #0xb9cc
a038a90c 70314ae3 movt     r3, #0xa170
a038a910 003093e5 ldr      r3, [r3]
a038a914 43c8a0e1 asr      ip, r3, #0x10
a038a918 d0390be3 movw     r3, #0xb9d0
a038a91c 70314ae3 movt     r3, #0xa170
a038a920 003093e5 ldr      r3, [r3]
a038a924 4308a0e1 asr      r0, r3, #0x10
a038a928 c8390be3 movw     r3, #0xb9c8
a038a92c 70314ae3 movt     r3, #0xa170
a038a930 003093e5 ldr      r3, [r3]
a038a934 4318a0e1 asr      r1, r3, #0x10
a038a938 003404e3 movw     r3, #0x4400
a038a93c 70314ae3 movt     r3, #0xa170
a038a940 142093e5 ldr      r2, [r3, #0x14]
a038a944 003404e3 movw     r3, #0x4400
a038a948 70314ae3 movt     r3, #0xa170
a038a94c 183093e5 ldr      r3, [r3, #0x18]
a038a950 000bcded vstr     d16, [sp]
a038a954 08e08de5 str      lr, [sp, #8]
a038a958 0c408de5 str      r4, [sp, #0xc]
a038a95c 10808de5 str      r8, [sp, #0x10]
a038a960 14908de5 str      sb, [sp, #0x14]
a038a964 18a08de5 str      sl, [sp, #0x18]
a038a968 90e09de5 ldr      lr, [sp, #0x90]
a038a96c 1ce08de5 str      lr, [sp, #0x1c]
a038a970 20708de5 str      r7, [sp, #0x20]
a038a974 24608de5 str      r6, [sp, #0x24]
a038a978 28508de5 str      r5, [sp, #0x28]
a038a97c 2cc08de5 str      ip, [sp, #0x2c]
a038a980 30008de5 str      r0, [sp, #0x30]
a038a984 34108de5 str      r1, [sp, #0x34]
a038a988 38208de5 str      r2, [sp, #0x38]
a038a98c 3c308de5 str      r3, [sp, #0x3c]
a038a990 3c0700e3 movw     r0, #0x73c
a038a994 60004ae3 movt     r0, #0xa060
a038a998 88109de5 ldr      r1, [sp, #0x88]
a038a99c 0b20a0e1 mov      r2, fp
a038a9a0 d171fceb bl       #0xa02a70ec
a038a9a4 2e0200ea b        #0xa038b264
a038a9a8 f83a07e3 movw     r3, #0x7af8
a038a9ac 75304ae3 movt     r3, #0xa075
a038a9b0 b430d3e1 ldrh     r3, [r3, #4]
a038a9b4 030053e3 cmp      r3, #3
a038a9b8 8000001a bne      #0xa038abc0
a038a9bc 1e3b0ae3 movw     r3, #0xab1e
a038a9c0 70314ae3 movt     r3, #0xa170
a038a9c4 0030d3e5 ldrb     r3, [r3]
a038a9c8 000053e3 cmp      r3, #0
a038a9cc 7b00000a beq      #0xa038abc0
a038a9d0 103304e3 movw     r3, #0x4310
a038a9d4 70314ae3 movt     r3, #0xa170
a038a9d8 003093e5 ldr      r3, [r3]
a038a9dc 2338a0e1 lsr      r3, r3, #0x10
a038a9e0 88308de5 str      r3, [sp, #0x88]
a038a9e4 103304e3 movw     r3, #0x4310
a038a9e8 70314ae3 movt     r3, #0xa170
a038a9ec 043093e5 ldr      r3, [r3, #4]
a038a9f0 2328a0e1 lsr      r2, r3, #0x10
a038a9f4 90208de5 str      r2, [sp, #0x90]
a038a9f8 103304e3 movw     r3, #0x4310
a038a9fc 70314ae3 movt     r3, #0xa170
a038aa00 082093e5 ldr      r2, [r3, #8]
a038aa04 103304e3 movw     r3, #0x4310
a038aa08 70314ae3 movt     r3, #0xa170
a038aa0c 003093e5 ldr      r3, [r3]
a038aa10 023063e0 rsb      r3, r3, r2
a038aa14 2308a0e1 lsr      r0, r3, #0x10
a038aa18 98008de5 str      r0, [sp, #0x98]
a038aa1c 103304e3 movw     r3, #0x4310
a038aa20 70314ae3 movt     r3, #0xa170
a038aa24 0c2093e5 ldr      r2, [r3, #0xc]
a038aa28 103304e3 movw     r3, #0x4310
a038aa2c 70314ae3 movt     r3, #0xa170
a038aa30 043093e5 ldr      r3, [r3, #4]
a038aa34 023063e0 rsb      r3, r3, r2
a038aa38 2368a0e1 lsr      r6, r3, #0x10
a038aa3c 103304e3 movw     r3, #0x4310
a038aa40 70314ae3 movt     r3, #0xa170
a038aa44 b831d3e1 ldrh     r3, [r3, #0x18]
a038aa48 a0308de5 str      r3, [sp, #0xa0]
a038aa4c 103304e3 movw     r3, #0x4310
a038aa50 70314ae3 movt     r3, #0xa170
a038aa54 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038aa58 a8308de5 str      r3, [sp, #0xa8]
a038aa5c 103304e3 movw     r3, #0x4310
a038aa60 70314ae3 movt     r3, #0xa170
a038aa64 bc31d3e1 ldrh     r3, [r3, #0x1c]
a038aa68 b0308de5 str      r3, [sp, #0xb0]
a038aa6c 103304e3 movw     r3, #0x4310
a038aa70 70314ae3 movt     r3, #0xa170
a038aa74 be31d3e1 ldrh     r3, [r3, #0x1e]
a038aa78 b8308de5 str      r3, [sp, #0xb8]
a038aa7c 103304e3 movw     r3, #0x4310
a038aa80 70314ae3 movt     r3, #0xa170
a038aa84 10a093e5 ldr      sl, [r3, #0x10]
a038aa88 003404e3 movw     r3, #0x4400
a038aa8c 70314ae3 movt     r3, #0xa170
a038aa90 1c3093e5 ldr      r3, [r3, #0x1c]
a038aa94 43b8a0e1 asr      fp, r3, #0x10
a038aa98 003404e3 movw     r3, #0x4400
a038aa9c 70314ae3 movt     r3, #0xa170
a038aaa0 203093e5 ldr      r3, [r3, #0x20]
a038aaa4 4398a0e1 asr      sb, r3, #0x10
a038aaa8 cc390be3 movw     r3, #0xb9cc
a038aaac 70314ae3 movt     r3, #0xa170
a038aab0 003093e5 ldr      r3, [r3]
a038aab4 2378a0e1 lsr      r7, r3, #0x10
a038aab8 d0390be3 movw     r3, #0xb9d0
a038aabc 70314ae3 movt     r3, #0xa170
a038aac0 003093e5 ldr      r3, [r3]
a038aac4 2358a0e1 lsr      r5, r3, #0x10
a038aac8 c8390be3 movw     r3, #0xb9c8
a038aacc 70314ae3 movt     r3, #0xa170
a038aad0 004093e5 ldr      r4, [r3]
a038aad4 c4390be3 movw     r3, #0xb9c4
a038aad8 70314ae3 movt     r3, #0xa170
a038aadc 00c093e5 ldr      ip, [r3]
a038aae0 d03204e3 movw     r3, #0x42d0
a038aae4 70314ae3 movt     r3, #0xa170
a038aae8 003093e5 ldr      r3, [r3]
a038aaec 4308a0e1 asr      r0, r3, #0x10
a038aaf0 d03204e3 movw     r3, #0x42d0
a038aaf4 70314ae3 movt     r3, #0xa170
a038aaf8 043093e5 ldr      r3, [r3, #4]
a038aafc 4318a0e1 asr      r1, r3, #0x10
a038ab00 1e3b0ae3 movw     r3, #0xab1e
a038ab04 70314ae3 movt     r3, #0xa170
a038ab08 0030d3e5 ldrb     r3, [r3]
a038ab0c 0380a0e1 mov      r8, r3
a038ab10 1b3b0ae3 movw     r3, #0xab1b
a038ab14 70314ae3 movt     r3, #0xa170
a038ab18 0030d3e5 ldrb     r3, [r3]
a038ab1c 03e0a0e1 mov      lr, r3
a038ab20 483304e3 movw     r3, #0x4348
a038ab24 70314ae3 movt     r3, #0xa170
a038ab28 042093e5 ldr      r2, [r3, #4]
a038ab2c 803304e3 movw     r3, #0x4380
a038ab30 70314ae3 movt     r3, #0xa170
a038ab34 043093e5 ldr      r3, [r3, #4]
a038ab38 022063e0 rsb      r2, r3, r2
a038ab3c 803304e3 movw     r3, #0x4380
a038ab40 70314ae3 movt     r3, #0xa170
a038ab44 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038ab48 00608de5 str      r6, [sp]
a038ab4c a0609de5 ldr      r6, [sp, #0xa0]
a038ab50 04608de5 str      r6, [sp, #4]
a038ab54 a8609de5 ldr      r6, [sp, #0xa8]
a038ab58 08608de5 str      r6, [sp, #8]
a038ab5c b0609de5 ldr      r6, [sp, #0xb0]
a038ab60 0c608de5 str      r6, [sp, #0xc]
a038ab64 b8609de5 ldr      r6, [sp, #0xb8]
a038ab68 10608de5 str      r6, [sp, #0x10]
a038ab6c 14a08de5 str      sl, [sp, #0x14]
a038ab70 18b08de5 str      fp, [sp, #0x18]
a038ab74 1c908de5 str      sb, [sp, #0x1c]
a038ab78 20708de5 str      r7, [sp, #0x20]
a038ab7c 24508de5 str      r5, [sp, #0x24]
a038ab80 28408de5 str      r4, [sp, #0x28]
a038ab84 2cc08de5 str      ip, [sp, #0x2c]
a038ab88 30008de5 str      r0, [sp, #0x30]
a038ab8c 34108de5 str      r1, [sp, #0x34]
a038ab90 38808de5 str      r8, [sp, #0x38]
a038ab94 3ce08de5 str      lr, [sp, #0x3c]
a038ab98 40208de5 str      r2, [sp, #0x40]
a038ab9c 44308de5 str      r3, [sp, #0x44]
a038aba0 980700e3 movw     r0, #0x798
a038aba4 60004ae3 movt     r0, #0xa060
a038aba8 88109de5 ldr      r1, [sp, #0x88]
a038abac 90209de5 ldr      r2, [sp, #0x90]
a038abb0 98309de5 ldr      r3, [sp, #0x98]
a038abb4 4c71fceb bl       #0xa02a70ec
a038abb8 a90100ea b        #0xa038b264
a038abbc 00008045 strmi    r0, [r0]
a038abc0 f83a07e3 movw     r3, #0x7af8
a038abc4 75304ae3 movt     r3, #0xa075
a038abc8 b430d3e1 ldrh     r3, [r3, #4]
a038abcc 040053e3 cmp      r3, #4
a038abd0 7a00001a bne      #0xa038adc0
a038abd4 1e3b0ae3 movw     r3, #0xab1e
a038abd8 70314ae3 movt     r3, #0xa170
a038abdc 0030d3e5 ldrb     r3, [r3]
a038abe0 000053e3 cmp      r3, #0
a038abe4 7500000a beq      #0xa038adc0
a038abe8 103304e3 movw     r3, #0x4310
a038abec 70314ae3 movt     r3, #0xa170
a038abf0 008093e5 ldr      r8, [r3]
a038abf4 103304e3 movw     r3, #0x4310
a038abf8 70314ae3 movt     r3, #0xa170
a038abfc 043093e5 ldr      r3, [r3, #4]
a038ac00 903a07ee vmov     s15, r3
a038ac04 670bf8ee vcvt.f64.u32 d16, s15
a038ac08 6a1bdfed vldr     d17, [pc, #0x1a8]
a038ac0c a15bc0ee vdiv.f64 d21, d16, d17
a038ac10 003404e3 movw     r3, #0x4400
a038ac14 70314ae3 movt     r3, #0xa170
a038ac18 8c3093e5 ldr      r3, [r3, #0x8c]
a038ac1c 903a07ee vmov     s15, r3
a038ac20 670bf8ee vcvt.f64.u32 d16, s15
a038ac24 631bdfed vldr     d17, [pc, #0x18c]
a038ac28 a13bc0ee vdiv.f64 d19, d16, d17
a038ac2c 003404e3 movw     r3, #0x4400
a038ac30 70314ae3 movt     r3, #0xa170
a038ac34 9c3093e5 ldr      r3, [r3, #0x9c]
a038ac38 903a07ee vmov     s15, r3
a038ac3c 670bf8ee vcvt.f64.u32 d16, s15
a038ac40 5c1bdfed vldr     d17, [pc, #0x170]
a038ac44 a12bc0ee vdiv.f64 d18, d16, d17
a038ac48 483304e3 movw     r3, #0x4348
a038ac4c 70314ae3 movt     r3, #0xa170
a038ac50 043093e5 ldr      r3, [r3, #4]
a038ac54 903a07ee vmov     s15, r3
a038ac58 670bf8ee vcvt.f64.u32 d16, s15
a038ac5c 551bdfed vldr     d17, [pc, #0x154]
a038ac60 a11bc0ee vdiv.f64 d17, d16, d17
a038ac64 803304e3 movw     r3, #0x4380
a038ac68 70314ae3 movt     r3, #0xa170
a038ac6c 043093e5 ldr      r3, [r3, #4]
a038ac70 903a07ee vmov     s15, r3
a038ac74 670bf8ee vcvt.f64.u32 d16, s15
a038ac78 4e4bdfed vldr     d20, [pc, #0x138]
a038ac7c a40bc0ee vdiv.f64 d16, d16, d20
a038ac80 103304e3 movw     r3, #0x4310
a038ac84 70314ae3 movt     r3, #0xa170
a038ac88 082093e5 ldr      r2, [r3, #8]
a038ac8c 103304e3 movw     r3, #0x4310
a038ac90 70314ae3 movt     r3, #0xa170
a038ac94 003093e5 ldr      r3, [r3]
a038ac98 023063e0 rsb      r3, r3, r2
a038ac9c 2318a0e1 lsr      r1, r3, #0x10
a038aca0 103304e3 movw     r3, #0x4310
a038aca4 70314ae3 movt     r3, #0xa170
a038aca8 0c2093e5 ldr      r2, [r3, #0xc]
a038acac 103304e3 movw     r3, #0x4310
a038acb0 70314ae3 movt     r3, #0xa170
a038acb4 043093e5 ldr      r3, [r3, #4]
a038acb8 023063e0 rsb      r3, r3, r2
a038acbc 23c8a0e1 lsr      ip, r3, #0x10
a038acc0 103304e3 movw     r3, #0x4310
a038acc4 70314ae3 movt     r3, #0xa170
a038acc8 b831d3e1 ldrh     r3, [r3, #0x18]
a038accc 0370a0e1 mov      r7, r3
a038acd0 103304e3 movw     r3, #0x4310
a038acd4 70314ae3 movt     r3, #0xa170
a038acd8 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038acdc 03b0a0e1 mov      fp, r3
a038ace0 103304e3 movw     r3, #0x4310
a038ace4 70314ae3 movt     r3, #0xa170
a038ace8 bc31d3e1 ldrh     r3, [r3, #0x1c]
a038acec 03a0a0e1 mov      sl, r3
a038acf0 103304e3 movw     r3, #0x4310
a038acf4 70314ae3 movt     r3, #0xa170
a038acf8 be31d3e1 ldrh     r3, [r3, #0x1e]
a038acfc 0390a0e1 mov      sb, r3
a038ad00 103304e3 movw     r3, #0x4310
a038ad04 70314ae3 movt     r3, #0xa170
a038ad08 105093e5 ldr      r5, [r3, #0x10]
a038ad0c 003404e3 movw     r3, #0x4400
a038ad10 70314ae3 movt     r3, #0xa170
a038ad14 204093e5 ldr      r4, [r3, #0x20]
a038ad18 003404e3 movw     r3, #0x4400
a038ad1c 70314ae3 movt     r3, #0xa170
a038ad20 6ce093e5 ldr      lr, [r3, #0x6c]
a038ad24 d03204e3 movw     r3, #0x42d0
a038ad28 70314ae3 movt     r3, #0xa170
a038ad2c 000093e5 ldr      r0, [r3]
a038ad30 d03204e3 movw     r3, #0x42d0
a038ad34 70314ae3 movt     r3, #0xa170
a038ad38 042093e5 ldr      r2, [r3, #4]
a038ad3c 1e3b0ae3 movw     r3, #0xab1e
a038ad40 70314ae3 movt     r3, #0xa170
a038ad44 0030d3e5 ldrb     r3, [r3]
a038ad48 0360a0e1 mov      r6, r3
a038ad4c 1b3b0ae3 movw     r3, #0xab1b
a038ad50 70314ae3 movt     r3, #0xa170
a038ad54 0030d3e5 ldrb     r3, [r3]
a038ad58 003bcded vstr     d19, [sp]
a038ad5c 022bcded vstr     d18, [sp, #8]
a038ad60 041bcded vstr     d17, [sp, #0x10]
a038ad64 060bcded vstr     d16, [sp, #0x18]
a038ad68 20108de5 str      r1, [sp, #0x20]
a038ad6c 24c08de5 str      ip, [sp, #0x24]
a038ad70 28708de5 str      r7, [sp, #0x28]
a038ad74 2cb08de5 str      fp, [sp, #0x2c]
a038ad78 30a08de5 str      sl, [sp, #0x30]
a038ad7c 34908de5 str      sb, [sp, #0x34]
a038ad80 38508de5 str      r5, [sp, #0x38]
a038ad84 3c408de5 str      r4, [sp, #0x3c]
a038ad88 40e08de5 str      lr, [sp, #0x40]
a038ad8c 44008de5 str      r0, [sp, #0x44]
a038ad90 48208de5 str      r2, [sp, #0x48]
a038ad94 4c608de5 str      r6, [sp, #0x4c]
a038ad98 50308de5 str      r3, [sp, #0x50]
a038ad9c 080800e3 movw     r0, #0x808
a038ada0 60004ae3 movt     r0, #0xa060
a038ada4 0810a0e1 mov      r1, r8
a038ada8 352b53ec vmov     r2, r3, d21
a038adac ce70fceb bl       #0xa02a70ec
a038adb0 2b0100ea b        #0xa038b264
a038adb4 00f020e3 nop      
a038adb8 00000000 andeq    r0, r0, r0
a038adbc 0000f040 rscsmi   r0, r0, r0
a038adc0 f83a07e3 movw     r3, #0x7af8
a038adc4 75304ae3 movt     r3, #0xa075
a038adc8 b430d3e1 ldrh     r3, [r3, #4]
a038adcc 050053e3 cmp      r3, #5
a038add0 9800001a bne      #0xa038b038
a038add4 1e3b0ae3 movw     r3, #0xab1e
a038add8 70314ae3 movt     r3, #0xa170
a038addc 0030d3e5 ldrb     r3, [r3]
a038ade0 000053e3 cmp      r3, #0
a038ade4 9300000a beq      #0xa038b038
a038ade8 103304e3 movw     r3, #0x4310
a038adec 70314ae3 movt     r3, #0xa170
a038adf0 00a093e5 ldr      sl, [r3]
a038adf4 103304e3 movw     r3, #0x4310
a038adf8 70314ae3 movt     r3, #0xa170
a038adfc 043093e5 ldr      r3, [r3, #4]
a038ae00 903a07ee vmov     s15, r3
a038ae04 670bf8ee vcvt.f64.u32 d16, s15
a038ae08 161b5fed vldr     d17, [pc, #-0x58]
a038ae0c a1abc0ee vdiv.f64 d26, d16, d17
a038ae10 103304e3 movw     r3, #0x4310
a038ae14 70314ae3 movt     r3, #0xa170
a038ae18 0c3093e5 ldr      r3, [r3, #0xc]
a038ae1c 903a07ee vmov     s15, r3
a038ae20 670bf8ee vcvt.f64.u32 d16, s15
a038ae24 1d1b5fed vldr     d17, [pc, #-0x74]
a038ae28 a18bc0ee vdiv.f64 d24, d16, d17
a038ae2c 103304e3 movw     r3, #0x4310
a038ae30 70314ae3 movt     r3, #0xa170
a038ae34 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038ae38 0380a0e1 mov      r8, r3
a038ae3c 003404e3 movw     r3, #0x4400
a038ae40 70314ae3 movt     r3, #0xa170
a038ae44 8c3093e5 ldr      r3, [r3, #0x8c]
a038ae48 903a07ee vmov     s15, r3
a038ae4c 670bf8ee vcvt.f64.u32 d16, s15
a038ae50 281b5fed vldr     d17, [pc, #-0xa0]
a038ae54 a17bc0ee vdiv.f64 d23, d16, d17
a038ae58 003404e3 movw     r3, #0x4400
a038ae5c 70314ae3 movt     r3, #0xa170
a038ae60 9c3093e5 ldr      r3, [r3, #0x9c]
a038ae64 903a07ee vmov     s15, r3
a038ae68 670bf8ee vcvt.f64.u32 d16, s15
a038ae6c 2f1b5fed vldr     d17, [pc, #-0xbc]
a038ae70 a16bc0ee vdiv.f64 d22, d16, d17
a038ae74 003404e3 movw     r3, #0x4400
a038ae78 70314ae3 movt     r3, #0xa170
a038ae7c a43093e5 ldr      r3, [r3, #0xa4]
a038ae80 903a07ee vmov     s15, r3
a038ae84 670bf8ee vcvt.f64.u32 d16, s15
a038ae88 361b5fed vldr     d17, [pc, #-0xd8]
a038ae8c a15bc0ee vdiv.f64 d21, d16, d17
a038ae90 003404e3 movw     r3, #0x4400
a038ae94 70314ae3 movt     r3, #0xa170
a038ae98 741093e5 ldr      r1, [r3, #0x74]
a038ae9c a83404e3 movw     r3, #0x44a8
a038aea0 70314ae3 movt     r3, #0xa170
a038aea4 8c3093e5 ldr      r3, [r3, #0x8c]
a038aea8 903a07ee vmov     s15, r3
a038aeac 670bf8ee vcvt.f64.u32 d16, s15
a038aeb0 401b5fed vldr     d17, [pc, #-0x100]
a038aeb4 a14bc0ee vdiv.f64 d20, d16, d17
a038aeb8 a83404e3 movw     r3, #0x44a8
a038aebc 70314ae3 movt     r3, #0xa170
a038aec0 9c3093e5 ldr      r3, [r3, #0x9c]
a038aec4 903a07ee vmov     s15, r3
a038aec8 670bf8ee vcvt.f64.u32 d16, s15
a038aecc 471b5fed vldr     d17, [pc, #-0x11c]
a038aed0 a13bc0ee vdiv.f64 d19, d16, d17
a038aed4 a83404e3 movw     r3, #0x44a8
a038aed8 70314ae3 movt     r3, #0xa170
a038aedc a43093e5 ldr      r3, [r3, #0xa4]
a038aee0 903a07ee vmov     s15, r3
a038aee4 670bf8ee vcvt.f64.u32 d16, s15
a038aee8 4e1b5fed vldr     d17, [pc, #-0x138]
a038aeec a12bc0ee vdiv.f64 d18, d16, d17
a038aef0 a83404e3 movw     r3, #0x44a8
a038aef4 70314ae3 movt     r3, #0xa170
a038aef8 747093e5 ldr      r7, [r3, #0x74]
a038aefc 483304e3 movw     r3, #0x4348
a038af00 70314ae3 movt     r3, #0xa170
a038af04 043093e5 ldr      r3, [r3, #4]
a038af08 903a07ee vmov     s15, r3
a038af0c 670bf8ee vcvt.f64.u32 d16, s15
a038af10 581b5fed vldr     d17, [pc, #-0x160]
a038af14 a11bc0ee vdiv.f64 d17, d16, d17
a038af18 803304e3 movw     r3, #0x4380
a038af1c 70314ae3 movt     r3, #0xa170
a038af20 043093e5 ldr      r3, [r3, #4]
a038af24 903a07ee vmov     s15, r3
a038af28 670bf8ee vcvt.f64.u32 d16, s15
a038af2c 5f9b5fed vldr     d25, [pc, #-0x17c]
a038af30 a90bc0ee vdiv.f64 d16, d16, d25
a038af34 103304e3 movw     r3, #0x4310
a038af38 70314ae3 movt     r3, #0xa170
a038af3c 082093e5 ldr      r2, [r3, #8]
a038af40 103304e3 movw     r3, #0x4310
a038af44 70314ae3 movt     r3, #0xa170
a038af48 003093e5 ldr      r3, [r3]
a038af4c 023063e0 rsb      r3, r3, r2
a038af50 2368a0e1 lsr      r6, r3, #0x10
a038af54 103304e3 movw     r3, #0x4310
a038af58 70314ae3 movt     r3, #0xa170
a038af5c 0c2093e5 ldr      r2, [r3, #0xc]
a038af60 103304e3 movw     r3, #0x4310
a038af64 70314ae3 movt     r3, #0xa170
a038af68 043093e5 ldr      r3, [r3, #4]
a038af6c 023063e0 rsb      r3, r3, r2
a038af70 2358a0e1 lsr      r5, r3, #0x10
a038af74 103304e3 movw     r3, #0x4310
a038af78 70314ae3 movt     r3, #0xa170
a038af7c 104093e5 ldr      r4, [r3, #0x10]
a038af80 003404e3 movw     r3, #0x4400
a038af84 70314ae3 movt     r3, #0xa170
a038af88 50e093e5 ldr      lr, [r3, #0x50]
a038af8c 003404e3 movw     r3, #0x4400
a038af90 70314ae3 movt     r3, #0xa170
a038af94 20c093e5 ldr      ip, [r3, #0x20]
a038af98 a83404e3 movw     r3, #0x44a8
a038af9c 70314ae3 movt     r3, #0xa170
a038afa0 200093e5 ldr      r0, [r3, #0x20]
a038afa4 003404e3 movw     r3, #0x4400
a038afa8 70314ae3 movt     r3, #0xa170
a038afac 6c2093e5 ldr      r2, [r3, #0x6c]
a038afb0 1e3b0ae3 movw     r3, #0xab1e
a038afb4 70314ae3 movt     r3, #0xa170
a038afb8 0030d3e5 ldrb     r3, [r3]
a038afbc 0390a0e1 mov      sb, r3
a038afc0 1b3b0ae3 movw     r3, #0xab1b
a038afc4 70314ae3 movt     r3, #0xa170
a038afc8 0030d3e5 ldrb     r3, [r3]
a038afcc 008bcded vstr     d24, [sp]
a038afd0 08808de5 str      r8, [sp, #8]
a038afd4 047bcded vstr     d23, [sp, #0x10]
a038afd8 066bcded vstr     d22, [sp, #0x18]
a038afdc 085bcded vstr     d21, [sp, #0x20]
a038afe0 28108de5 str      r1, [sp, #0x28]
a038afe4 0c4bcded vstr     d20, [sp, #0x30]
a038afe8 0e3bcded vstr     d19, [sp, #0x38]
a038afec 102bcded vstr     d18, [sp, #0x40]
a038aff0 48708de5 str      r7, [sp, #0x48]
a038aff4 141bcded vstr     d17, [sp, #0x50]
a038aff8 160bcded vstr     d16, [sp, #0x58]
a038affc 60608de5 str      r6, [sp, #0x60]
a038b000 64508de5 str      r5, [sp, #0x64]
a038b004 68408de5 str      r4, [sp, #0x68]
a038b008 6ce08de5 str      lr, [sp, #0x6c]
a038b00c 70c08de5 str      ip, [sp, #0x70]
a038b010 74008de5 str      r0, [sp, #0x74]
a038b014 78208de5 str      r2, [sp, #0x78]
a038b018 7c908de5 str      sb, [sp, #0x7c]
a038b01c 80308de5 str      r3, [sp, #0x80]
a038b020 740800e3 movw     r0, #0x874
a038b024 60004ae3 movt     r0, #0xa060
a038b028 0a10a0e1 mov      r1, sl
a038b02c 3a2b53ec vmov     r2, r3, d26
a038b030 2d70fceb bl       #0xa02a70ec
a038b034 8a0000ea b        #0xa038b264
a038b038 f83a07e3 movw     r3, #0x7af8
a038b03c 75304ae3 movt     r3, #0xa075
a038b040 b430d3e1 ldrh     r3, [r3, #4]
a038b044 060053e3 cmp      r3, #6
a038b048 8500001a bne      #0xa038b264
a038b04c 1e3b0ae3 movw     r3, #0xab1e
a038b050 70314ae3 movt     r3, #0xa170
a038b054 0030d3e5 ldrb     r3, [r3]
a038b058 000053e3 cmp      r3, #0
a038b05c 8000000a beq      #0xa038b264
a038b060 103304e3 movw     r3, #0x4310
a038b064 70314ae3 movt     r3, #0xa170
a038b068 043093e5 ldr      r3, [r3, #4]
a038b06c 903a07ee vmov     s15, r3
a038b070 670bf8ee vcvt.f64.u32 d16, s15
a038b074 b11b5fed vldr     d17, [pc, #-0x2c4]
a038b078 a1cbc0ee vdiv.f64 d28, d16, d17
a038b07c 103304e3 movw     r3, #0x4310
a038b080 70314ae3 movt     r3, #0xa170
a038b084 0c3093e5 ldr      r3, [r3, #0xc]
a038b088 903a07ee vmov     s15, r3
a038b08c 670bf8ee vcvt.f64.u32 d16, s15
a038b090 b81b5fed vldr     d17, [pc, #-0x2e0]
a038b094 a1abc0ee vdiv.f64 d26, d16, d17
a038b098 103304e3 movw     r3, #0x4310
a038b09c 70314ae3 movt     r3, #0xa170
a038b0a0 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038b0a4 0340a0e1 mov      r4, r3
a038b0a8 b83304e3 movw     r3, #0x43b8
a038b0ac 70314ae3 movt     r3, #0xa170
a038b0b0 043093e5 ldr      r3, [r3, #4]
a038b0b4 903a07ee vmov     s15, r3
a038b0b8 670bf8ee vcvt.f64.u32 d16, s15
a038b0bc c31b5fed vldr     d17, [pc, #-0x30c]
a038b0c0 a19bc0ee vdiv.f64 d25, d16, d17
a038b0c4 b83304e3 movw     r3, #0x43b8
a038b0c8 70314ae3 movt     r3, #0xa170
a038b0cc 0c3093e5 ldr      r3, [r3, #0xc]
a038b0d0 903a07ee vmov     s15, r3
a038b0d4 670bf8ee vcvt.f64.u32 d16, s15
a038b0d8 ca1b5fed vldr     d17, [pc, #-0x328]
a038b0dc a18bc0ee vdiv.f64 d24, d16, d17
a038b0e0 b83304e3 movw     r3, #0x43b8
a038b0e4 70314ae3 movt     r3, #0xa170
a038b0e8 ba31d3e1 ldrh     r3, [r3, #0x1a]
a038b0ec 03e0a0e1 mov      lr, r3
a038b0f0 003404e3 movw     r3, #0x4400
a038b0f4 70314ae3 movt     r3, #0xa170
a038b0f8 8c3093e5 ldr      r3, [r3, #0x8c]
a038b0fc 903a07ee vmov     s15, r3
a038b100 670bf8ee vcvt.f64.u32 d16, s15
a038b104 d51b5fed vldr     d17, [pc, #-0x354]
a038b108 a17bc0ee vdiv.f64 d23, d16, d17
a038b10c 003404e3 movw     r3, #0x4400
a038b110 70314ae3 movt     r3, #0xa170
a038b114 9c3093e5 ldr      r3, [r3, #0x9c]
a038b118 903a07ee vmov     s15, r3
a038b11c 670bf8ee vcvt.f64.u32 d16, s15
a038b120 dc1b5fed vldr     d17, [pc, #-0x370]
a038b124 a16bc0ee vdiv.f64 d22, d16, d17
a038b128 003404e3 movw     r3, #0x4400
a038b12c 70314ae3 movt     r3, #0xa170
a038b130 a43093e5 ldr      r3, [r3, #0xa4]
a038b134 903a07ee vmov     s15, r3
a038b138 670bf8ee vcvt.f64.u32 d16, s15
a038b13c e31b5fed vldr     d17, [pc, #-0x38c]
a038b140 a15bc0ee vdiv.f64 d21, d16, d17
a038b144 003404e3 movw     r3, #0x4400
a038b148 70314ae3 movt     r3, #0xa170
a038b14c 74c093e5 ldr      ip, [r3, #0x74]
a038b150 a83404e3 movw     r3, #0x44a8
a038b154 70314ae3 movt     r3, #0xa170
a038b158 8c3093e5 ldr      r3, [r3, #0x8c]
a038b15c 903a07ee vmov     s15, r3
a038b160 670bf8ee vcvt.f64.u32 d16, s15
a038b164 ed1b5fed vldr     d17, [pc, #-0x3b4]
a038b168 a14bc0ee vdiv.f64 d20, d16, d17
a038b16c a83404e3 movw     r3, #0x44a8
a038b170 70314ae3 movt     r3, #0xa170
a038b174 9c3093e5 ldr      r3, [r3, #0x9c]
a038b178 903a07ee vmov     s15, r3
a038b17c 670bf8ee vcvt.f64.u32 d16, s15
a038b180 f41b5fed vldr     d17, [pc, #-0x3d0]
a038b184 a13bc0ee vdiv.f64 d19, d16, d17
a038b188 a83404e3 movw     r3, #0x44a8
a038b18c 70314ae3 movt     r3, #0xa170
a038b190 a43093e5 ldr      r3, [r3, #0xa4]
a038b194 903a07ee vmov     s15, r3
a038b198 670bf8ee vcvt.f64.u32 d16, s15
a038b19c fb1b5fed vldr     d17, [pc, #-0x3ec]
a038b1a0 a12bc0ee vdiv.f64 d18, d16, d17
a038b1a4 a83404e3 movw     r3, #0x44a8
a038b1a8 70314ae3 movt     r3, #0xa170
a038b1ac 740093e5 ldr      r0, [r3, #0x74]
a038b1b0 483304e3 movw     r3, #0x4348
a038b1b4 70314ae3 movt     r3, #0xa170
a038b1b8 043093e5 ldr      r3, [r3, #4]
a038b1bc 903a07ee vmov     s15, r3
a038b1c0 670bf8ee vcvt.f64.u32 d16, s15
a038b1c4 f51bdfed vldr     d17, [pc, #0x3d4]
a038b1c8 a11bc0ee vdiv.f64 d17, d16, d17
a038b1cc 803304e3 movw     r3, #0x4380
a038b1d0 70314ae3 movt     r3, #0xa170
a038b1d4 043093e5 ldr      r3, [r3, #4]
a038b1d8 903a07ee vmov     s15, r3
a038b1dc 670bf8ee vcvt.f64.u32 d16, s15
a038b1e0 eebbdfed vldr     d27, [pc, #0x3b8]
a038b1e4 ab0bc0ee vdiv.f64 d16, d16, d27
a038b1e8 003404e3 movw     r3, #0x4400
a038b1ec 70314ae3 movt     r3, #0xa170
a038b1f0 201093e5 ldr      r1, [r3, #0x20]
a038b1f4 a83404e3 movw     r3, #0x44a8
a038b1f8 70314ae3 movt     r3, #0xa170
a038b1fc 202093e5 ldr      r2, [r3, #0x20]
a038b200 003404e3 movw     r3, #0x4400
a038b204 70314ae3 movt     r3, #0xa170
a038b208 6c3093e5 ldr      r3, [r3, #0x6c]
a038b20c 00abcded vstr     d26, [sp]
a038b210 08408de5 str      r4, [sp, #8]
a038b214 049bcded vstr     d25, [sp, #0x10]
a038b218 068bcded vstr     d24, [sp, #0x18]
a038b21c 20e08de5 str      lr, [sp, #0x20]
a038b220 0a7bcded vstr     d23, [sp, #0x28]
a038b224 0c6bcded vstr     d22, [sp, #0x30]
a038b228 0e5bcded vstr     d21, [sp, #0x38]
a038b22c 40c08de5 str      ip, [sp, #0x40]
a038b230 124bcded vstr     d20, [sp, #0x48]
a038b234 143bcded vstr     d19, [sp, #0x50]
a038b238 162bcded vstr     d18, [sp, #0x58]
a038b23c 60008de5 str      r0, [sp, #0x60]
a038b240 1a1bcded vstr     d17, [sp, #0x68]
a038b244 1c0bcded vstr     d16, [sp, #0x70]
a038b248 78108de5 str      r1, [sp, #0x78]
a038b24c 7c208de5 str      r2, [sp, #0x7c]
a038b250 80308de5 str      r3, [sp, #0x80]
a038b254 f00800e3 movw     r0, #0x8f0
a038b258 60004ae3 movt     r0, #0xa060
a038b25c 3c2b53ec vmov     r2, r3, d28
a038b260 a16ffceb bl       #0xa02a70ec
a038b264 da3504e3 movw     r3, #0x45da
a038b268 70314ae3 movt     r3, #0xa170
a038b26c 0030d3e5 ldrb     r3, [r3]
a038b270 000053e3 cmp      r3, #0
a038b274 0d00001a bne      #0xa038b2b0
a038b278 f83a07e3 movw     r3, #0x7af8
a038b27c 75304ae3 movt     r3, #0xa075
a038b280 bc33d3e1 ldrh     r3, [r3, #0x3c]
a038b284 000053e3 cmp      r3, #0
a038b288 0800001a bne      #0xa038b2b0
a038b28c 503504e3 movw     r3, #0x4550
a038b290 70314ae3 movt     r3, #0xa170
a038b294 003093e5 ldr      r3, [r3]
a038b298 100304e3 movw     r0, #0x4310
a038b29c 70014ae3 movt     r0, #0xa170
a038b2a0 0110a0e3 mov      r1, #1
a038b2a4 0320a0e1 mov      r2, r3
a038b2a8 4aebfceb bl       #0xa02c5fd8
a038b2ac 0c0000ea b        #0xa038b2e4
a038b2b0 f83a07e3 movw     r3, #0x7af8
a038b2b4 75304ae3 movt     r3, #0xa075
a038b2b8 bc33d3e1 ldrh     r3, [r3, #0x3c]
a038b2bc 7b0053e3 cmp      r3, #0x7b
a038b2c0 0700001a bne      #0xa038b2e4
a038b2c4 503504e3 movw     r3, #0x4550
a038b2c8 70314ae3 movt     r3, #0xa170
a038b2cc 003093e5 ldr      r3, [r3]
a038b2d0 0000a0e3 mov      r0, #0
a038b2d4 0110a0e3 mov      r1, #1
a038b2d8 0320a0e1 mov      r2, r3
a038b2dc 3debfceb bl       #0xa02c5fd8
a038b2e0 0c0000ea b        #0xa038b318
a038b2e4 0b0000ea b        #0xa038b318
a038b2e8 a2390be3 movw     r3, #0xb9a2
a038b2ec 70314ae3 movt     r3, #0xa170
a038b2f0 0030d3e5 ldrb     r3, [r3]
a038b2f4 010053e3 cmp      r3, #1
a038b2f8 0600001a bne      #0xa038b318
a038b2fc 3c3b0ae3 movw     r3, #0xab3c
a038b300 70314ae3 movt     r3, #0xa170
a038b304 003093e5 ldr      r3, [r3]
a038b308 0320a0e1 mov      r2, r3
a038b30c 003d02e3 movw     r3, #0x2d00
a038b310 70314ae3 movt     r3, #0xa170
a038b314 202283e5 str      r2, [r3, #0x220]
a038b318 da3504e3 movw     r3, #0x45da
a038b31c 70314ae3 movt     r3, #0xa170
a038b320 0030d3e5 ldrb     r3, [r3]
a038b324 000053e3 cmp      r3, #0
a038b328 ed0a001a bne      #0xa038dee4
a038b32c 153b0ae3 movw     r3, #0xab15
a038b330 70314ae3 movt     r3, #0xa170
a038b334 0030d3e5 ldrb     r3, [r3]
a038b338 000053e3 cmp      r3, #0
a038b33c b60a000a beq      #0xa038de1c
a038b340 173b0ae3 movw     r3, #0xab17
a038b344 70314ae3 movt     r3, #0xa170
a038b348 0030d3e5 ldrb     r3, [r3]
a038b34c 000053e3 cmp      r3, #0
a038b350 b10a000a beq      #0xa038de1c
a038b354 183b0ae3 movw     r3, #0xab18
a038b358 70314ae3 movt     r3, #0xa170
a038b35c 0030d3e5 ldrb     r3, [r3]
a038b360 000053e3 cmp      r3, #0
a038b364 ac0a000a beq      #0xa038de1c
a038b368 643a07e3 movw     r3, #0x7a64
a038b36c 75304ae3 movt     r3, #0xa075
a038b370 003093e5 ldr      r3, [r3]
a038b374 000053e3 cmp      r3, #0
a038b378 a70a000a beq      #0xa038de1c
a038b37c 683a07e3 movw     r3, #0x7a68
a038b380 75304ae3 movt     r3, #0xa075
a038b384 003093e5 ldr      r3, [r3]
a038b388 000053e3 cmp      r3, #0
a038b38c a20a000a beq      #0xa038de1c
a038b390 f83a07e3 movw     r3, #0x7af8
a038b394 75304ae3 movt     r3, #0xa075
a038b398 be33d3e1 ldrh     r3, [r3, #0x3e]
a038b39c 000053e3 cmp      r3, #0
a038b3a0 9d0a001a bne      #0xa038de1c
a038b3a4 2a3f0ae3 movw     r3, #0xaf2a
a038b3a8 70314ae3 movt     r3, #0xa170
a038b3ac 0030d3e5 ldrb     r3, [r3]
a038b3b0 000053e3 cmp      r3, #0
a038b3b4 980a001a bne      #0xa038de1c
a038b3b8 d4390be3 movw     r3, #0xb9d4
a038b3bc 70314ae3 movt     r3, #0xa170
a038b3c0 0020a0e3 mov      r2, #0
a038b3c4 0020c3e5 strb     r2, [r3]
a038b3c8 1a3b0ae3 movw     r3, #0xab1a
a038b3cc 70314ae3 movt     r3, #0xa170
a038b3d0 0030d3e5 ldrb     r3, [r3]
a038b3d4 013083e2 add      r3, r3, #1
a038b3d8 7320efe6 uxtb     r2, r3
a038b3dc 1a3b0ae3 movw     r3, #0xab1a
a038b3e0 70314ae3 movt     r3, #0xa170
a038b3e4 0020c3e5 strb     r2, [r3]
a038b3e8 2c3204e3 movw     r3, #0x422c
a038b3ec 70314ae3 movt     r3, #0xa170
a038b3f0 002093e5 ldr      r2, [r3]
a038b3f4 643b0ae3 movw     r3, #0xab64
a038b3f8 70314ae3 movt     r3, #0xa170
a038b3fc 003093e5 ldr      r3, [r3]
a038b400 030052e1 cmp      r2, r3
a038b404 0700003a blo      #0xa038b428
a038b408 2c3204e3 movw     r3, #0x422c
a038b40c 70314ae3 movt     r3, #0xa170
a038b410 002093e5 ldr      r2, [r3]
a038b414 683b0ae3 movw     r3, #0xab68
a038b418 70314ae3 movt     r3, #0xa170
a038b41c 003093e5 ldr      r3, [r3]
a038b420 030052e1 cmp      r2, r3
a038b424 0a00009a bls      #0xa038b454
a038b428 1a3b0ae3 movw     r3, #0xab1a
a038b42c 70314ae3 movt     r3, #0xa170
a038b430 0020a0e3 mov      r2, #0
a038b434 0020c3e5 strb     r2, [r3]
a038b438 e03e0ae3 movw     r3, #0xaee0
a038b43c 70314ae3 movt     r3, #0xa170
a038b440 003093e5 ldr      r3, [r3]
a038b444 012083e2 add      r2, r3, #1
a038b448 e03e0ae3 movw     r3, #0xaee0
a038b44c 70314ae3 movt     r3, #0xa170
a038b450 002083e5 str      r2, [r3]
a038b454 1a3b0ae3 movw     r3, #0xab1a
a038b458 70314ae3 movt     r3, #0xa170
a038b45c 0030d3e5 ldrb     r3, [r3]
a038b460 000053e3 cmp      r3, #0
a038b464 6b0a000a beq      #0xa038de18
a038b468 c83f0ae3 movw     r3, #0xafc8
a038b46c 70314ae3 movt     r3, #0xa170
a038b470 1c3093e5 ldr      r3, [r3, #0x1c]
a038b474 000053e3 cmp      r3, #0
a038b478 660a001a bne      #0xa038de18
a038b47c 1a3b0ae3 movw     r3, #0xab1a
a038b480 70314ae3 movt     r3, #0xa170
a038b484 0030d3e5 ldrb     r3, [r3]
a038b488 010053e3 cmp      r3, #1
a038b48c 8100001a bne      #0xa038b698
a038b490 e43e0ae3 movw     r3, #0xaee4
a038b494 70314ae3 movt     r3, #0xa170
a038b498 002093e5 ldr      r2, [r3]
a038b49c 083f0ae3 movw     r3, #0xaf08
a038b4a0 70314ae3 movt     r3, #0xa170
a038b4a4 002083e5 str      r2, [r3]
a038b4a8 fc3e0ae3 movw     r3, #0xaefc
a038b4ac 70314ae3 movt     r3, #0xa170
a038b4b0 002093e5 ldr      r2, [r3]
a038b4b4 0c3f0ae3 movw     r3, #0xaf0c
a038b4b8 70314ae3 movt     r3, #0xa170
a038b4bc 002083e5 str      r2, [r3]
a038b4c0 d5390be3 movw     r3, #0xb9d5
a038b4c4 70314ae3 movt     r3, #0xa170
a038b4c8 0020a0e3 mov      r2, #0
a038b4cc 0020c3e5 strb     r2, [r3]
a038b4d0 a03204e3 movw     r3, #0x42a0
a038b4d4 70314ae3 movt     r3, #0xa170
a038b4d8 003093e5 ldr      r3, [r3]
a038b4dc 4324a0e1 asr      r2, r3, #8
a038b4e0 d8390be3 movw     r3, #0xb9d8
a038b4e4 70314ae3 movt     r3, #0xa170
a038b4e8 002083e5 str      r2, [r3]
a038b4ec c03c02e3 movw     r3, #0x2cc0
a038b4f0 70314ae3 movt     r3, #0xa170
a038b4f4 0b30d3e5 ldrb     r3, [r3, #0xb]
a038b4f8 7330afe6 sxtb     r3, r3
a038b4fc 010073e3 cmn      r3, #1
a038b500 0600001a bne      #0xa038b520
a038b504 d8390be3 movw     r3, #0xb9d8
a038b508 70314ae3 movt     r3, #0xa170
a038b50c 003093e5 ldr      r3, [r3]
a038b510 002063e2 rsb      r2, r3, #0
a038b514 d8390be3 movw     r3, #0xb9d8
a038b518 70314ae3 movt     r3, #0xa170
a038b51c 002083e5 str      r2, [r3]
a038b520 99f5fdeb bl       #0xa0308b8c
a038b524 0030a0e1 mov      r3, r0
a038b528 000053e3 cmp      r3, #0
a038b52c 0200000a beq      #0xa038b53c
a038b530 0239a0e3 mov      r3, #0x8000
a038b534 11384ee3 movt     r3, #0xe811
a038b538 010000ea b        #0xa038b544
a038b53c 0239a0e3 mov      r3, #0x8000
a038b540 113047e3 movt     r3, #0x7011
a038b544 6c318de5 str      r3, [sp, #0x16c]
a038b548 6c319de5 ldr      r3, [sp, #0x16c]
a038b54c 102102e3 movw     r2, #0x2110
a038b550 002083e5 str      r2, [r3]
a038b554 8cf5fdeb bl       #0xa0308b8c
a038b558 0030a0e1 mov      r3, r0
a038b55c 000053e3 cmp      r3, #0
a038b560 0200000a beq      #0xa038b570
a038b564 2030a0e3 mov      r3, #0x20
a038b568 11384ee3 movt     r3, #0xe811
a038b56c 010000ea b        #0xa038b578
a038b570 2030a0e3 mov      r3, #0x20
a038b574 113047e3 movt     r3, #0x7011
a038b578 003093e5 ldr      r3, [r3]
a038b57c 7330ffe6 uxth     r3, r3
a038b580 68318de5 str      r3, [sp, #0x168]
a038b584 80f5fdeb bl       #0xa0308b8c
a038b588 0030a0e1 mov      r3, r0
a038b58c 000053e3 cmp      r3, #0
a038b590 0400000a beq      #0xa038b5a8
a038b594 1c30a0e3 mov      r3, #0x1c
a038b598 11384ee3 movt     r3, #0xe811
a038b59c 030000ea b        #0xa038b5b0
a038b5a0 00000000 andeq    r0, r0, r0
a038b5a4 0000f040 rscsmi   r0, r0, r0
a038b5a8 1c30a0e3 mov      r3, #0x1c
a038b5ac 113047e3 movt     r3, #0x7011
a038b5b0 003093e5 ldr      r3, [r3]
a038b5b4 7330ffe6 uxth     r3, r3
a038b5b8 64318de5 str      r3, [sp, #0x164]
a038b5bc 6c319de5 ldr      r3, [sp, #0x16c]
a038b5c0 202102e3 movw     r2, #0x2120
a038b5c4 002083e5 str      r2, [r3]
a038b5c8 6ff5fdeb bl       #0xa0308b8c
a038b5cc 0030a0e1 mov      r3, r0
a038b5d0 000053e3 cmp      r3, #0
a038b5d4 0200000a beq      #0xa038b5e4
a038b5d8 2030a0e3 mov      r3, #0x20
a038b5dc 11384ee3 movt     r3, #0xe811
a038b5e0 010000ea b        #0xa038b5ec
a038b5e4 2030a0e3 mov      r3, #0x20
a038b5e8 113047e3 movt     r3, #0x7011
a038b5ec 003093e5 ldr      r3, [r3]
a038b5f0 7330ffe6 uxth     r3, r3
a038b5f4 60318de5 str      r3, [sp, #0x160]
a038b5f8 63f5fdeb bl       #0xa0308b8c
a038b5fc 0030a0e1 mov      r3, r0
a038b600 000053e3 cmp      r3, #0
a038b604 0200000a beq      #0xa038b614
a038b608 1c30a0e3 mov      r3, #0x1c
a038b60c 11384ee3 movt     r3, #0xe811
a038b610 010000ea b        #0xa038b61c
a038b614 1c30a0e3 mov      r3, #0x1c
a038b618 113047e3 movt     r3, #0x7011
a038b61c 003093e5 ldr      r3, [r3]
a038b620 7330ffe6 uxth     r3, r3
a038b624 5c318de5 str      r3, [sp, #0x15c]
a038b628 68319de5 ldr      r3, [sp, #0x168]
a038b62c 7330ffe6 uxth     r3, r3
a038b630 68318de5 str      r3, [sp, #0x168]
a038b634 60319de5 ldr      r3, [sp, #0x160]
a038b638 7330ffe6 uxth     r3, r3
a038b63c 60318de5 str      r3, [sp, #0x160]
a038b640 68319de5 ldr      r3, [sp, #0x168]
a038b644 000053e3 cmp      r3, #0
a038b648 0400001a bne      #0xa038b660
a038b64c 603a07e3 movw     r3, #0x7a60
a038b650 75304ae3 movt     r3, #0xa075
a038b654 6420a0e3 mov      r2, #0x64
a038b658 002083e5 str      r2, [r3]
a038b65c 0d0000ea b        #0xa038b698
a038b660 60319de5 ldr      r3, [sp, #0x160]
a038b664 0331a0e1 lsl      r3, r3, #2
a038b668 0321a0e1 lsl      r2, r3, #2
a038b66c 023083e0 add      r3, r3, r2
a038b670 0321a0e1 lsl      r2, r3, #2
a038b674 023083e0 add      r3, r3, r2
a038b678 0300a0e1 mov      r0, r3
a038b67c 68119de5 ldr      r1, [sp, #0x168]
a038b680 02ec05fa blx      #0xa0506690
a038b684 0030a0e1 mov      r3, r0
a038b688 0320a0e1 mov      r2, r3
a038b68c 603a07e3 movw     r3, #0x7a60
a038b690 75304ae3 movt     r3, #0xa075
a038b694 002083e5 str      r2, [r3]
a038b698 443004e3 movw     r3, #0x4044
a038b69c 70314ae3 movt     r3, #0xa170
a038b6a0 0930d3e5 ldrb     r3, [r3, #9]
a038b6a4 010053e3 cmp      r3, #1
a038b6a8 2400009a bls      #0xa038b740
a038b6ac c03c02e3 movw     r3, #0x2cc0
a038b6b0 70314ae3 movt     r3, #0xa170
a038b6b4 1430d3e5 ldrb     r3, [r3, #0x14]
a038b6b8 7320afe6 sxtb     r2, r3
a038b6bc b03a07e3 movw     r3, #0x7ab0
a038b6c0 75304ae3 movt     r3, #0xa075
a038b6c4 0030d3e5 ldrb     r3, [r3]
a038b6c8 7330afe6 sxtb     r3, r3
a038b6cc 032082e0 add      r2, r2, r3
a038b6d0 203b0ae3 movw     r3, #0xab20
a038b6d4 70314ae3 movt     r3, #0xa170
a038b6d8 b030d3e1 ldrh     r3, [r3]
a038b6dc 013083e2 add      r3, r3, #1
a038b6e0 c330a0e1 asr      r3, r3, #1
a038b6e4 022063e0 rsb      r2, r3, r2
a038b6e8 443004e3 movw     r3, #0x4044
a038b6ec 70314ae3 movt     r3, #0xa170
a038b6f0 0930d3e5 ldrb     r3, [r3, #9]
a038b6f4 a330a0e1 lsr      r3, r3, #1
a038b6f8 7330efe6 uxtb     r3, r3
a038b6fc 032082e0 add      r2, r2, r3
a038b700 443004e3 movw     r3, #0x4044
a038b704 70314ae3 movt     r3, #0xa170
a038b708 0930d3e5 ldrb     r3, [r3, #9]
a038b70c 0200a0e1 mov      r0, r2
a038b710 0310a0e1 mov      r1, r3
a038b714 ddeb05fa blx      #0xa0506690
a038b718 0030a0e1 mov      r3, r0
a038b71c 0320a0e1 mov      r2, r3
a038b720 383b0ae3 movw     r3, #0xab38
a038b724 70314ae3 movt     r3, #0xa170
a038b728 003093e5 ldr      r3, [r3]
a038b72c 032082e0 add      r2, r2, r3
a038b730 e0390be3 movw     r3, #0xb9e0
a038b734 70314ae3 movt     r3, #0xa170
a038b738 002083e5 str      r2, [r3]
a038b73c 150000ea b        #0xa038b798
a038b740 c03c02e3 movw     r3, #0x2cc0
a038b744 70314ae3 movt     r3, #0xa170
a038b748 1430d3e5 ldrb     r3, [r3, #0x14]
a038b74c 7320afe6 sxtb     r2, r3
a038b750 383b0ae3 movw     r3, #0xab38
a038b754 70314ae3 movt     r3, #0xa170
a038b758 003093e5 ldr      r3, [r3]
a038b75c 032082e0 add      r2, r2, r3
a038b760 b03a07e3 movw     r3, #0x7ab0
a038b764 75304ae3 movt     r3, #0xa075
a038b768 0030d3e5 ldrb     r3, [r3]
a038b76c 7330afe6 sxtb     r3, r3
a038b770 032082e0 add      r2, r2, r3
a038b774 203b0ae3 movw     r3, #0xab20
a038b778 70314ae3 movt     r3, #0xa170
a038b77c b030d3e1 ldrh     r3, [r3]
a038b780 013083e2 add      r3, r3, #1
a038b784 c330a0e1 asr      r3, r3, #1
a038b788 022063e0 rsb      r2, r3, r2
a038b78c e0390be3 movw     r3, #0xb9e0
a038b790 70314ae3 movt     r3, #0xa170
a038b794 002083e5 str      r2, [r3]
a038b798 e83504e3 movw     r3, #0x45e8
a038b79c 70314ae3 movt     r3, #0xa170
a038b7a0 0030d3e5 ldrb     r3, [r3]
a038b7a4 7320afe6 sxtb     r2, r3
a038b7a8 e0390be3 movw     r3, #0xb9e0
a038b7ac 70314ae3 movt     r3, #0xa170
a038b7b0 003093e5 ldr      r3, [r3]
a038b7b4 032082e0 add      r2, r2, r3
a038b7b8 e0390be3 movw     r3, #0xb9e0
a038b7bc 70314ae3 movt     r3, #0xa170
a038b7c0 002083e5 str      r2, [r3]
a038b7c4 c03c02e3 movw     r3, #0x2cc0
a038b7c8 70314ae3 movt     r3, #0xa170
a038b7cc 1430d3e5 ldrb     r3, [r3, #0x14]
a038b7d0 7320efe6 uxtb     r2, r3
a038b7d4 b03a07e3 movw     r3, #0x7ab0
a038b7d8 75304ae3 movt     r3, #0xa075
a038b7dc 0030d3e5 ldrb     r3, [r3]
a038b7e0 7330efe6 uxtb     r3, r3
a038b7e4 033082e0 add      r3, r2, r3
a038b7e8 7320efe6 uxtb     r2, r3
a038b7ec 203b0ae3 movw     r3, #0xab20
a038b7f0 70314ae3 movt     r3, #0xa170
a038b7f4 b030d3e1 ldrh     r3, [r3]
a038b7f8 013083e2 add      r3, r3, #1
a038b7fc c330a0e1 asr      r3, r3, #1
a038b800 7330efe6 uxtb     r3, r3
a038b804 023063e0 rsb      r3, r3, r2
a038b808 7320efe6 uxtb     r2, r3
a038b80c e83504e3 movw     r3, #0x45e8
a038b810 70314ae3 movt     r3, #0xa170
a038b814 0030d3e5 ldrb     r3, [r3]
a038b818 7330efe6 uxtb     r3, r3
a038b81c 033082e0 add      r3, r2, r3
a038b820 7330efe6 uxtb     r3, r3
a038b824 7320efe6 uxtb     r2, r3
a038b828 283f0ae3 movw     r3, #0xaf28
a038b82c 70314ae3 movt     r3, #0xa170
a038b830 0020c3e5 strb     r2, [r3]
a038b834 283f0ae3 movw     r3, #0xaf28
a038b838 70314ae3 movt     r3, #0xa170
a038b83c 0030d3e5 ldrb     r3, [r3]
a038b840 7330afe6 sxtb     r3, r3
a038b844 000053e3 cmp      r3, #0
a038b848 030000ca bgt      #0xa038b85c
a038b84c 283f0ae3 movw     r3, #0xaf28
a038b850 70314ae3 movt     r3, #0xa170
a038b854 0020a0e3 mov      r2, #0
a038b858 0020c3e5 strb     r2, [r3]
a038b85c 383b0ae3 movw     r3, #0xab38
a038b860 70314ae3 movt     r3, #0xa170
a038b864 003093e5 ldr      r3, [r3]
a038b868 0320a0e1 mov      r2, r3
a038b86c e0390be3 movw     r3, #0xb9e0
a038b870 70314ae3 movt     r3, #0xa170
a038b874 003093e5 ldr      r3, [r3]
a038b878 030052e1 cmp      r2, r3
a038b87c 070000aa bge      #0xa038b8a0
a038b880 383b0ae3 movw     r3, #0xab38
a038b884 70314ae3 movt     r3, #0xa170
a038b888 003093e5 ldr      r3, [r3]
a038b88c 0320a0e1 mov      r2, r3
a038b890 e0390be3 movw     r3, #0xb9e0
a038b894 70314ae3 movt     r3, #0xa170
a038b898 002083e5 str      r2, [r3]
a038b89c 0f0000ea b        #0xa038b8e0
a038b8a0 e0390be3 movw     r3, #0xb9e0
a038b8a4 70314ae3 movt     r3, #0xa170
a038b8a8 003093e5 ldr      r3, [r3]
a038b8ac 000053e3 cmp      r3, #0
a038b8b0 0a0000aa bge      #0xa038b8e0
a038b8b4 003d02e3 movw     r3, #0x2d00
a038b8b8 70314ae3 movt     r3, #0xa170
a038b8bc 102293e5 ldr      r2, [r3, #0x210]
a038b8c0 e0390be3 movw     r3, #0xb9e0
a038b8c4 70314ae3 movt     r3, #0xa170
a038b8c8 003093e5 ldr      r3, [r3]
a038b8cc 033082e0 add      r3, r2, r3
a038b8d0 0320a0e1 mov      r2, r3
a038b8d4 e0390be3 movw     r3, #0xb9e0
a038b8d8 70314ae3 movt     r3, #0xa170
a038b8dc 002083e5 str      r2, [r3]
a038b8e0 d03a07e3 movw     r3, #0x7ad0
a038b8e4 75304ae3 movt     r3, #0xa075
a038b8e8 0030d3e5 ldrb     r3, [r3]
a038b8ec 090053e3 cmp      r3, #9
a038b8f0 0a00008a bhi      #0xa038b920
a038b8f4 e0390be3 movw     r3, #0xb9e0
a038b8f8 70314ae3 movt     r3, #0xa170
a038b8fc 002093e5 ldr      r2, [r3]
a038b900 383b0ae3 movw     r3, #0xab38
a038b904 70314ae3 movt     r3, #0xa170
a038b908 003093e5 ldr      r3, [r3]
a038b90c 600900e3 movw     r0, #0x960
a038b910 60004ae3 movt     r0, #0xa060
a038b914 0210a0e1 mov      r1, r2
a038b918 0320a0e1 mov      r2, r3
a038b91c f26dfceb bl       #0xa02a70ec
a038b920 f83e0ae3 movw     r3, #0xaef8
a038b924 70314ae3 movt     r3, #0xa170
a038b928 0030d3e5 ldrb     r3, [r3]
a038b92c 010053e3 cmp      r3, #1
a038b930 1200000a beq      #0xa038b980
a038b934 e0390be3 movw     r3, #0xb9e0
a038b938 70314ae3 movt     r3, #0xa170
a038b93c 002093e5 ldr      r2, [r3]
a038b940 003d02e3 movw     r3, #0x2d00
a038b944 70314ae3 movt     r3, #0xa170
a038b948 021193e7 ldr      r1, [r3, r2, lsl #2]
a038b94c e0390be3 movw     r3, #0xb9e0
a038b950 70314ae3 movt     r3, #0xa170
a038b954 003093e5 ldr      r3, [r3]
a038b958 002d02e3 movw     r2, #0x2d00
a038b95c 70214ae3 movt     r2, #0xa170
a038b960 663f83e2 add      r3, r3, #0x198
a038b964 033083e2 add      r3, r3, #3
a038b968 033192e7 ldr      r3, [r2, r3, lsl #2]
a038b96c 012063e0 rsb      r2, r3, r1
a038b970 4c3b0ae3 movw     r3, #0xab4c
a038b974 70314ae3 movt     r3, #0xa170
a038b978 002083e5 str      r2, [r3]
a038b97c 9e0200ea b        #0xa038c3fc
a038b980 d5390be3 movw     r3, #0xb9d5
a038b984 70314ae3 movt     r3, #0xa170
a038b988 0030d3e5 ldrb     r3, [r3]
a038b98c 000053e3 cmp      r3, #0
a038b990 1e01001a bne      #0xa038be10
a038b994 0030a0e3 mov      r3, #0
a038b998 8b31cde5 strb     r3, [sp, #0x18b]
a038b99c 0030a0e3 mov      r3, #0
a038b9a0 84318de5 str      r3, [sp, #0x184]
a038b9a4 183f0ae3 movw     r3, #0xaf18
a038b9a8 70314ae3 movt     r3, #0xa170
a038b9ac 0020a0e3 mov      r2, #0
a038b9b0 002083e5 str      r2, [r3]
a038b9b4 d03a07e3 movw     r3, #0x7ad0
a038b9b8 75304ae3 movt     r3, #0xa075
a038b9bc 0030d3e5 ldrb     r3, [r3]
a038b9c0 090053e3 cmp      r3, #9
a038b9c4 0a00008a bhi      #0xa038b9f4
a038b9c8 0c3f0ae3 movw     r3, #0xaf0c
a038b9cc 70314ae3 movt     r3, #0xa170
a038b9d0 002093e5 ldr      r2, [r3]
a038b9d4 083f0ae3 movw     r3, #0xaf08
a038b9d8 70314ae3 movt     r3, #0xa170
a038b9dc 003093e5 ldr      r3, [r3]
a038b9e0 800900e3 movw     r0, #0x980
a038b9e4 60004ae3 movt     r0, #0xa060
a038b9e8 0210a0e1 mov      r1, r2
a038b9ec 0320a0e1 mov      r2, r3
a038b9f0 bd6dfceb bl       #0xa02a70ec
a038b9f4 083f0ae3 movw     r3, #0xaf08
a038b9f8 70314ae3 movt     r3, #0xa170
a038b9fc 002093e5 ldr      r2, [r3]
a038ba00 0c3f0ae3 movw     r3, #0xaf0c
a038ba04 70314ae3 movt     r3, #0xa170
a038ba08 003093e5 ldr      r3, [r3]
a038ba0c 030052e1 cmp      r2, r3
a038ba10 7100002a bhs      #0xa038bbdc
a038ba14 e0390be3 movw     r3, #0xb9e0
a038ba18 70314ae3 movt     r3, #0xa170
a038ba1c 003093e5 ldr      r3, [r3]
a038ba20 0320a0e1 mov      r2, r3
a038ba24 0c3f0ae3 movw     r3, #0xaf0c
a038ba28 70314ae3 movt     r3, #0xa170
a038ba2c 003093e5 ldr      r3, [r3]
a038ba30 030052e1 cmp      r2, r3
a038ba34 0800008a bhi      #0xa038ba5c
a038ba38 e0390be3 movw     r3, #0xb9e0
a038ba3c 70314ae3 movt     r3, #0xa170
a038ba40 003093e5 ldr      r3, [r3]
a038ba44 0320a0e1 mov      r2, r3
a038ba48 083f0ae3 movw     r3, #0xaf08
a038ba4c 70314ae3 movt     r3, #0xa170
a038ba50 003093e5 ldr      r3, [r3]
a038ba54 030052e1 cmp      r2, r3
a038ba58 0400008a bhi      #0xa038ba70
a038ba5c 4c3b0ae3 movw     r3, #0xab4c
a038ba60 70314ae3 movt     r3, #0xa170
a038ba64 0020a0e3 mov      r2, #0
a038ba68 002083e5 str      r2, [r3]
a038ba6c 620200ea b        #0xa038c3fc
a038ba70 e0390be3 movw     r3, #0xb9e0
a038ba74 70314ae3 movt     r3, #0xa170
a038ba78 003093e5 ldr      r3, [r3]
a038ba7c 7320efe6 uxtb     r2, r3
a038ba80 083f0ae3 movw     r3, #0xaf08
a038ba84 70314ae3 movt     r3, #0xa170
a038ba88 003093e5 ldr      r3, [r3]
a038ba8c 7330efe6 uxtb     r3, r3
a038ba90 023063e0 rsb      r3, r3, r2
a038ba94 7330efe6 uxtb     r3, r3
a038ba98 8b31cde5 strb     r3, [sp, #0x18b]
a038ba9c 0030a0e3 mov      r3, #0
a038baa0 80318de5 str      r3, [sp, #0x180]
a038baa4 270000ea b        #0xa038bb48
a038baa8 083f0ae3 movw     r3, #0xaf08
a038baac 70314ae3 movt     r3, #0xa170
a038bab0 002093e5 ldr      r2, [r3]
a038bab4 80319de5 ldr      r3, [sp, #0x180]
a038bab8 033082e0 add      r3, r2, r3
a038babc 013083e2 add      r3, r3, #1
a038bac0 84318de5 str      r3, [sp, #0x184]
a038bac4 84219de5 ldr      r2, [sp, #0x184]
a038bac8 003d02e3 movw     r3, #0x2d00
a038bacc 70314ae3 movt     r3, #0xa170
a038bad0 103293e5 ldr      r3, [r3, #0x210]
a038bad4 030052e1 cmp      r2, r3
a038bad8 0500003a blo      #0xa038baf4
a038badc 84219de5 ldr      r2, [sp, #0x184]
a038bae0 003d02e3 movw     r3, #0x2d00
a038bae4 70314ae3 movt     r3, #0xa170
a038bae8 103293e5 ldr      r3, [r3, #0x210]
a038baec 023063e0 rsb      r3, r3, r2
a038baf0 84318de5 str      r3, [sp, #0x184]
a038baf4 003d02e3 movw     r3, #0x2d00
a038baf8 70314ae3 movt     r3, #0xa170
a038bafc 84219de5 ldr      r2, [sp, #0x184]
a038bb00 021193e7 ldr      r1, [r3, r2, lsl #2]
a038bb04 002d02e3 movw     r2, #0x2d00
a038bb08 70214ae3 movt     r2, #0xa170
a038bb0c 84319de5 ldr      r3, [sp, #0x184]
a038bb10 663f83e2 add      r3, r3, #0x198
a038bb14 033083e2 add      r3, r3, #3
a038bb18 033192e7 ldr      r3, [r2, r3, lsl #2]
a038bb1c 012063e0 rsb      r2, r3, r1
a038bb20 183f0ae3 movw     r3, #0xaf18
a038bb24 70314ae3 movt     r3, #0xa170
a038bb28 003093e5 ldr      r3, [r3]
a038bb2c 032082e0 add      r2, r2, r3
a038bb30 183f0ae3 movw     r3, #0xaf18
a038bb34 70314ae3 movt     r3, #0xa170
a038bb38 002083e5 str      r2, [r3]
a038bb3c 80319de5 ldr      r3, [sp, #0x180]
a038bb40 013083e2 add      r3, r3, #1
a038bb44 80318de5 str      r3, [sp, #0x180]
a038bb48 623f8de2 add      r3, sp, #0x188
a038bb4c 033083e2 add      r3, r3, #3
a038bb50 d030d3e1 ldrsb    r3, [r3]
a038bb54 012043e2 sub      r2, r3, #1
a038bb58 80319de5 ldr      r3, [sp, #0x180]
a038bb5c 030052e1 cmp      r2, r3
a038bb60 d0ffffca bgt      #0xa038baa8
a038bb64 e0390be3 movw     r3, #0xb9e0
a038bb68 70314ae3 movt     r3, #0xa170
a038bb6c 002093e5 ldr      r2, [r3]
a038bb70 003d02e3 movw     r3, #0x2d00
a038bb74 70314ae3 movt     r3, #0xa170
a038bb78 021193e7 ldr      r1, [r3, r2, lsl #2]
a038bb7c e0390be3 movw     r3, #0xb9e0
a038bb80 70314ae3 movt     r3, #0xa170
a038bb84 003093e5 ldr      r3, [r3]
a038bb88 002d02e3 movw     r2, #0x2d00
a038bb8c 70214ae3 movt     r2, #0xa170
a038bb90 663f83e2 add      r3, r3, #0x198
a038bb94 033083e2 add      r3, r3, #3
a038bb98 033192e7 ldr      r3, [r2, r3, lsl #2]
a038bb9c 014063e0 rsb      r4, r3, r1
a038bba0 183f0ae3 movw     r3, #0xaf18
a038bba4 70314ae3 movt     r3, #0xa170
a038bba8 002093e5 ldr      r2, [r3]
a038bbac cb3a07e3 movw     r3, #0x7acb
a038bbb0 75304ae3 movt     r3, #0xa075
a038bbb4 0030d3e5 ldrb     r3, [r3]
a038bbb8 0200a0e1 mov      r0, r2
a038bbbc 0310a0e1 mov      r1, r3
a038bbc0 b2ea05fa blx      #0xa0506690
a038bbc4 0030a0e1 mov      r3, r0
a038bbc8 032084e0 add      r2, r4, r3
a038bbcc 4c3b0ae3 movw     r3, #0xab4c
a038bbd0 70314ae3 movt     r3, #0xa170
a038bbd4 002083e5 str      r2, [r3]
a038bbd8 070200ea b        #0xa038c3fc
a038bbdc e0390be3 movw     r3, #0xb9e0
a038bbe0 70314ae3 movt     r3, #0xa170
a038bbe4 003093e5 ldr      r3, [r3]
a038bbe8 0320a0e1 mov      r2, r3
a038bbec 0c3f0ae3 movw     r3, #0xaf0c
a038bbf0 70314ae3 movt     r3, #0xa170
a038bbf4 003093e5 ldr      r3, [r3]
a038bbf8 030052e1 cmp      r2, r3
a038bbfc 0d00009a bls      #0xa038bc38
a038bc00 e0390be3 movw     r3, #0xb9e0
a038bc04 70314ae3 movt     r3, #0xa170
a038bc08 003093e5 ldr      r3, [r3]
a038bc0c 0320a0e1 mov      r2, r3
a038bc10 083f0ae3 movw     r3, #0xaf08
a038bc14 70314ae3 movt     r3, #0xa170
a038bc18 003093e5 ldr      r3, [r3]
a038bc1c 030052e1 cmp      r2, r3
a038bc20 0400008a bhi      #0xa038bc38
a038bc24 4c3b0ae3 movw     r3, #0xab4c
a038bc28 70314ae3 movt     r3, #0xa170
a038bc2c 0020a0e3 mov      r2, #0
a038bc30 002083e5 str      r2, [r3]
a038bc34 f00100ea b        #0xa038c3fc
a038bc38 e0390be3 movw     r3, #0xb9e0
a038bc3c 70314ae3 movt     r3, #0xa170
a038bc40 003093e5 ldr      r3, [r3]
a038bc44 0320a0e1 mov      r2, r3
a038bc48 083f0ae3 movw     r3, #0xaf08
a038bc4c 70314ae3 movt     r3, #0xa170
a038bc50 003093e5 ldr      r3, [r3]
a038bc54 030052e1 cmp      r2, r3
a038bc58 1100002a bhs      #0xa038bca4
a038bc5c 003d02e3 movw     r3, #0x2d00
a038bc60 70314ae3 movt     r3, #0xa170
a038bc64 102293e5 ldr      r2, [r3, #0x210]
a038bc68 e0390be3 movw     r3, #0xb9e0
a038bc6c 70314ae3 movt     r3, #0xa170
a038bc70 003093e5 ldr      r3, [r3]
a038bc74 033082e0 add      r3, r2, r3
a038bc78 58318de5 str      r3, [sp, #0x158]
a038bc7c 58319de5 ldr      r3, [sp, #0x158]
a038bc80 7320efe6 uxtb     r2, r3
a038bc84 083f0ae3 movw     r3, #0xaf08
a038bc88 70314ae3 movt     r3, #0xa170
a038bc8c 003093e5 ldr      r3, [r3]
a038bc90 7330efe6 uxtb     r3, r3
a038bc94 023063e0 rsb      r3, r3, r2
a038bc98 7330efe6 uxtb     r3, r3
a038bc9c 8b31cde5 strb     r3, [sp, #0x18b]
a038bca0 0a0000ea b        #0xa038bcd0
a038bca4 e0390be3 movw     r3, #0xb9e0
a038bca8 70314ae3 movt     r3, #0xa170
a038bcac 003093e5 ldr      r3, [r3]
a038bcb0 7320efe6 uxtb     r2, r3
a038bcb4 083f0ae3 movw     r3, #0xaf08
a038bcb8 70314ae3 movt     r3, #0xa170
a038bcbc 003093e5 ldr      r3, [r3]
a038bcc0 7330efe6 uxtb     r3, r3
a038bcc4 023063e0 rsb      r3, r3, r2
a038bcc8 7330efe6 uxtb     r3, r3
a038bccc 8b31cde5 strb     r3, [sp, #0x18b]
a038bcd0 0030a0e3 mov      r3, #0
a038bcd4 80318de5 str      r3, [sp, #0x180]
a038bcd8 270000ea b        #0xa038bd7c
a038bcdc 083f0ae3 movw     r3, #0xaf08
a038bce0 70314ae3 movt     r3, #0xa170
a038bce4 002093e5 ldr      r2, [r3]
a038bce8 80319de5 ldr      r3, [sp, #0x180]
a038bcec 033082e0 add      r3, r2, r3
a038bcf0 013083e2 add      r3, r3, #1
a038bcf4 84318de5 str      r3, [sp, #0x184]
a038bcf8 84219de5 ldr      r2, [sp, #0x184]
a038bcfc 003d02e3 movw     r3, #0x2d00
a038bd00 70314ae3 movt     r3, #0xa170
a038bd04 103293e5 ldr      r3, [r3, #0x210]
a038bd08 030052e1 cmp      r2, r3
a038bd0c 0500003a blo      #0xa038bd28
a038bd10 84219de5 ldr      r2, [sp, #0x184]
a038bd14 003d02e3 movw     r3, #0x2d00
a038bd18 70314ae3 movt     r3, #0xa170
a038bd1c 103293e5 ldr      r3, [r3, #0x210]
a038bd20 023063e0 rsb      r3, r3, r2
a038bd24 84318de5 str      r3, [sp, #0x184]
a038bd28 003d02e3 movw     r3, #0x2d00
a038bd2c 70314ae3 movt     r3, #0xa170
a038bd30 84219de5 ldr      r2, [sp, #0x184]
a038bd34 021193e7 ldr      r1, [r3, r2, lsl #2]
a038bd38 002d02e3 movw     r2, #0x2d00
a038bd3c 70214ae3 movt     r2, #0xa170
a038bd40 84319de5 ldr      r3, [sp, #0x184]
a038bd44 663f83e2 add      r3, r3, #0x198
a038bd48 033083e2 add      r3, r3, #3
a038bd4c 033192e7 ldr      r3, [r2, r3, lsl #2]
a038bd50 012063e0 rsb      r2, r3, r1
a038bd54 183f0ae3 movw     r3, #0xaf18
a038bd58 70314ae3 movt     r3, #0xa170
a038bd5c 003093e5 ldr      r3, [r3]
a038bd60 032082e0 add      r2, r2, r3
a038bd64 183f0ae3 movw     r3, #0xaf18
a038bd68 70314ae3 movt     r3, #0xa170
a038bd6c 002083e5 str      r2, [r3]
a038bd70 80319de5 ldr      r3, [sp, #0x180]
a038bd74 013083e2 add      r3, r3, #1
a038bd78 80318de5 str      r3, [sp, #0x180]
a038bd7c 623f8de2 add      r3, sp, #0x188
a038bd80 033083e2 add      r3, r3, #3
a038bd84 d030d3e1 ldrsb    r3, [r3]
a038bd88 012043e2 sub      r2, r3, #1
a038bd8c 80319de5 ldr      r3, [sp, #0x180]
a038bd90 030052e1 cmp      r2, r3
a038bd94 d0ffffca bgt      #0xa038bcdc
a038bd98 e0390be3 movw     r3, #0xb9e0
a038bd9c 70314ae3 movt     r3, #0xa170
a038bda0 002093e5 ldr      r2, [r3]
a038bda4 003d02e3 movw     r3, #0x2d00
a038bda8 70314ae3 movt     r3, #0xa170
a038bdac 021193e7 ldr      r1, [r3, r2, lsl #2]
a038bdb0 e0390be3 movw     r3, #0xb9e0
a038bdb4 70314ae3 movt     r3, #0xa170
a038bdb8 003093e5 ldr      r3, [r3]
a038bdbc 002d02e3 movw     r2, #0x2d00
a038bdc0 70214ae3 movt     r2, #0xa170
a038bdc4 663f83e2 add      r3, r3, #0x198
a038bdc8 033083e2 add      r3, r3, #3
a038bdcc 033192e7 ldr      r3, [r2, r3, lsl #2]
a038bdd0 014063e0 rsb      r4, r3, r1
a038bdd4 183f0ae3 movw     r3, #0xaf18
a038bdd8 70314ae3 movt     r3, #0xa170
a038bddc 002093e5 ldr      r2, [r3]
a038bde0 cb3a07e3 movw     r3, #0x7acb
a038bde4 75304ae3 movt     r3, #0xa075
a038bde8 0030d3e5 ldrb     r3, [r3]
a038bdec 0200a0e1 mov      r0, r2
a038bdf0 0310a0e1 mov      r1, r3
a038bdf4 25ea05fa blx      #0xa0506690
a038bdf8 0030a0e1 mov      r3, r0
a038bdfc 032084e0 add      r2, r4, r3
a038be00 4c3b0ae3 movw     r3, #0xab4c
a038be04 70314ae3 movt     r3, #0xa170
a038be08 002083e5 str      r2, [r3]
a038be0c 7a0100ea b        #0xa038c3fc
a038be10 d5390be3 movw     r3, #0xb9d5
a038be14 70314ae3 movt     r3, #0xa170
a038be18 0020d3e5 ldrb     r2, [r3]
a038be1c cb3a07e3 movw     r3, #0x7acb
a038be20 75304ae3 movt     r3, #0xa075
a038be24 0030d3e5 ldrb     r3, [r3]
a038be28 030052e1 cmp      r2, r3
a038be2c c400002a bhs      #0xa038c144
a038be30 d5390be3 movw     r3, #0xb9d5
a038be34 70314ae3 movt     r3, #0xa170
a038be38 0030d3e5 ldrb     r3, [r3]
a038be3c 0320a0e1 mov      r2, r3
a038be40 283f0ae3 movw     r3, #0xaf28
a038be44 70314ae3 movt     r3, #0xa170
a038be48 0030d3e5 ldrb     r3, [r3]
a038be4c 7330afe6 sxtb     r3, r3
a038be50 030052e1 cmp      r2, r3
a038be54 300000ba blt      #0xa038bf1c
a038be58 e0390be3 movw     r3, #0xb9e0
a038be5c 70314ae3 movt     r3, #0xa170
a038be60 002093e5 ldr      r2, [r3]
a038be64 283f0ae3 movw     r3, #0xaf28
a038be68 70314ae3 movt     r3, #0xa170
a038be6c 0030d3e5 ldrb     r3, [r3]
a038be70 7330afe6 sxtb     r3, r3
a038be74 023063e0 rsb      r3, r3, r2
a038be78 7c318de5 str      r3, [sp, #0x17c]
a038be7c 7c319de5 ldr      r3, [sp, #0x17c]
a038be80 000053e3 cmp      r3, #0
a038be84 050000aa bge      #0xa038bea0
a038be88 003d02e3 movw     r3, #0x2d00
a038be8c 70314ae3 movt     r3, #0xa170
a038be90 102293e5 ldr      r2, [r3, #0x210]
a038be94 7c319de5 ldr      r3, [sp, #0x17c]
a038be98 033082e0 add      r3, r2, r3
a038be9c 7c318de5 str      r3, [sp, #0x17c]
a038bea0 e0390be3 movw     r3, #0xb9e0
a038bea4 70314ae3 movt     r3, #0xa170
a038bea8 002093e5 ldr      r2, [r3]
a038beac 003d02e3 movw     r3, #0x2d00
a038beb0 70314ae3 movt     r3, #0xa170
a038beb4 021193e7 ldr      r1, [r3, r2, lsl #2]
a038beb8 e0390be3 movw     r3, #0xb9e0
a038bebc 70314ae3 movt     r3, #0xa170
a038bec0 003093e5 ldr      r3, [r3]
a038bec4 002d02e3 movw     r2, #0x2d00
a038bec8 70214ae3 movt     r2, #0xa170
a038becc 663f83e2 add      r3, r3, #0x198
a038bed0 033083e2 add      r3, r3, #3
a038bed4 033192e7 ldr      r3, [r2, r3, lsl #2]
a038bed8 011063e0 rsb      r1, r3, r1
a038bedc 002d02e3 movw     r2, #0x2d00
a038bee0 70214ae3 movt     r2, #0xa170
a038bee4 7c319de5 ldr      r3, [sp, #0x17c]
a038bee8 663f83e2 add      r3, r3, #0x198
a038beec 033083e2 add      r3, r3, #3
a038bef0 032192e7 ldr      r2, [r2, r3, lsl #2]
a038bef4 003d02e3 movw     r3, #0x2d00
a038bef8 70314ae3 movt     r3, #0xa170
a038befc 7c019de5 ldr      r0, [sp, #0x17c]
a038bf00 003193e7 ldr      r3, [r3, r0, lsl #2]
a038bf04 023063e0 rsb      r3, r3, r2
a038bf08 032081e0 add      r2, r1, r3
a038bf0c 203f0ae3 movw     r3, #0xaf20
a038bf10 70314ae3 movt     r3, #0xa170
a038bf14 002083e5 str      r2, [r3]
a038bf18 030000ea b        #0xa038bf2c
a038bf1c 203f0ae3 movw     r3, #0xaf20
a038bf20 70314ae3 movt     r3, #0xa170
a038bf24 0020a0e3 mov      r2, #0
a038bf28 002083e5 str      r2, [r3]
a038bf2c 083f0ae3 movw     r3, #0xaf08
a038bf30 70314ae3 movt     r3, #0xa170
a038bf34 002093e5 ldr      r2, [r3]
a038bf38 0c3f0ae3 movw     r3, #0xaf0c
a038bf3c 70314ae3 movt     r3, #0xa170
a038bf40 003093e5 ldr      r3, [r3]
a038bf44 030052e1 cmp      r2, r3
a038bf48 3e00002a bhs      #0xa038c048
a038bf4c e0390be3 movw     r3, #0xb9e0
a038bf50 70314ae3 movt     r3, #0xa170
a038bf54 003093e5 ldr      r3, [r3]
a038bf58 0320a0e1 mov      r2, r3
a038bf5c 0c3f0ae3 movw     r3, #0xaf0c
a038bf60 70314ae3 movt     r3, #0xa170
a038bf64 003093e5 ldr      r3, [r3]
a038bf68 030052e1 cmp      r2, r3
a038bf6c 0800008a bhi      #0xa038bf94
a038bf70 e0390be3 movw     r3, #0xb9e0
a038bf74 70314ae3 movt     r3, #0xa170
a038bf78 003093e5 ldr      r3, [r3]
a038bf7c 0320a0e1 mov      r2, r3
a038bf80 083f0ae3 movw     r3, #0xaf08
a038bf84 70314ae3 movt     r3, #0xa170
a038bf88 003093e5 ldr      r3, [r3]
a038bf8c 030052e1 cmp      r2, r3
a038bf90 0400008a bhi      #0xa038bfa8
a038bf94 4c3b0ae3 movw     r3, #0xab4c
a038bf98 70314ae3 movt     r3, #0xa170
a038bf9c 0020a0e3 mov      r2, #0
a038bfa0 002083e5 str      r2, [r3]
a038bfa4 140100ea b        #0xa038c3fc
a038bfa8 e0390be3 movw     r3, #0xb9e0
a038bfac 70314ae3 movt     r3, #0xa170
a038bfb0 002093e5 ldr      r2, [r3]
a038bfb4 003d02e3 movw     r3, #0x2d00
a038bfb8 70314ae3 movt     r3, #0xa170
a038bfbc 021193e7 ldr      r1, [r3, r2, lsl #2]
a038bfc0 e0390be3 movw     r3, #0xb9e0
a038bfc4 70314ae3 movt     r3, #0xa170
a038bfc8 003093e5 ldr      r3, [r3]
a038bfcc 002d02e3 movw     r2, #0x2d00
a038bfd0 70214ae3 movt     r2, #0xa170
a038bfd4 663f83e2 add      r3, r3, #0x198
a038bfd8 033083e2 add      r3, r3, #3
a038bfdc 033192e7 ldr      r3, [r2, r3, lsl #2]
a038bfe0 014063e0 rsb      r4, r3, r1
a038bfe4 183f0ae3 movw     r3, #0xaf18
a038bfe8 70314ae3 movt     r3, #0xa170
a038bfec 002093e5 ldr      r2, [r3]
a038bff0 cb3a07e3 movw     r3, #0x7acb
a038bff4 75304ae3 movt     r3, #0xa075
a038bff8 0030d3e5 ldrb     r3, [r3]
a038bffc 0200a0e1 mov      r0, r2
a038c000 0310a0e1 mov      r1, r3
a038c004 a1e905fa blx      #0xa0506690
a038c008 0030a0e1 mov      r3, r0
a038c00c 032084e0 add      r2, r4, r3
a038c010 4c3b0ae3 movw     r3, #0xab4c
a038c014 70314ae3 movt     r3, #0xa170
a038c018 002083e5 str      r2, [r3]
a038c01c 4c3b0ae3 movw     r3, #0xab4c
a038c020 70314ae3 movt     r3, #0xa170
a038c024 002093e5 ldr      r2, [r3]
a038c028 203f0ae3 movw     r3, #0xaf20
a038c02c 70314ae3 movt     r3, #0xa170
a038c030 003093e5 ldr      r3, [r3]
a038c034 032082e0 add      r2, r2, r3
a038c038 4c3b0ae3 movw     r3, #0xab4c
a038c03c 70314ae3 movt     r3, #0xa170
a038c040 002083e5 str      r2, [r3]
a038c044 ec0000ea b        #0xa038c3fc
a038c048 e0390be3 movw     r3, #0xb9e0
a038c04c 70314ae3 movt     r3, #0xa170
a038c050 003093e5 ldr      r3, [r3]
a038c054 0320a0e1 mov      r2, r3
a038c058 0c3f0ae3 movw     r3, #0xaf0c
a038c05c 70314ae3 movt     r3, #0xa170
a038c060 003093e5 ldr      r3, [r3]
a038c064 030052e1 cmp      r2, r3
a038c068 0d00009a bls      #0xa038c0a4
a038c06c e0390be3 movw     r3, #0xb9e0
a038c070 70314ae3 movt     r3, #0xa170
a038c074 003093e5 ldr      r3, [r3]
a038c078 0320a0e1 mov      r2, r3
a038c07c 083f0ae3 movw     r3, #0xaf08
a038c080 70314ae3 movt     r3, #0xa170
a038c084 003093e5 ldr      r3, [r3]
a038c088 030052e1 cmp      r2, r3
a038c08c 0400008a bhi      #0xa038c0a4
a038c090 4c3b0ae3 movw     r3, #0xab4c
a038c094 70314ae3 movt     r3, #0xa170
a038c098 0020a0e3 mov      r2, #0
a038c09c 002083e5 str      r2, [r3]
a038c0a0 d50000ea b        #0xa038c3fc
a038c0a4 e0390be3 movw     r3, #0xb9e0
a038c0a8 70314ae3 movt     r3, #0xa170
a038c0ac 002093e5 ldr      r2, [r3]
a038c0b0 003d02e3 movw     r3, #0x2d00
a038c0b4 70314ae3 movt     r3, #0xa170
a038c0b8 021193e7 ldr      r1, [r3, r2, lsl #2]
a038c0bc e0390be3 movw     r3, #0xb9e0
a038c0c0 70314ae3 movt     r3, #0xa170
a038c0c4 003093e5 ldr      r3, [r3]
a038c0c8 002d02e3 movw     r2, #0x2d00
a038c0cc 70214ae3 movt     r2, #0xa170
a038c0d0 663f83e2 add      r3, r3, #0x198
a038c0d4 033083e2 add      r3, r3, #3
a038c0d8 033192e7 ldr      r3, [r2, r3, lsl #2]
a038c0dc 014063e0 rsb      r4, r3, r1
a038c0e0 183f0ae3 movw     r3, #0xaf18
a038c0e4 70314ae3 movt     r3, #0xa170
a038c0e8 002093e5 ldr      r2, [r3]
a038c0ec cb3a07e3 movw     r3, #0x7acb
a038c0f0 75304ae3 movt     r3, #0xa075
a038c0f4 0030d3e5 ldrb     r3, [r3]
a038c0f8 0200a0e1 mov      r0, r2
a038c0fc 0310a0e1 mov      r1, r3
a038c100 62e905fa blx      #0xa0506690
a038c104 0030a0e1 mov      r3, r0
a038c108 032084e0 add      r2, r4, r3
a038c10c 4c3b0ae3 movw     r3, #0xab4c
a038c110 70314ae3 movt     r3, #0xa170
a038c114 002083e5 str      r2, [r3]
a038c118 4c3b0ae3 movw     r3, #0xab4c
a038c11c 70314ae3 movt     r3, #0xa170
a038c120 002093e5 ldr      r2, [r3]
a038c124 203f0ae3 movw     r3, #0xaf20
a038c128 70314ae3 movt     r3, #0xa170
a038c12c 003093e5 ldr      r3, [r3]
a038c130 032082e0 add      r2, r2, r3
a038c134 4c3b0ae3 movw     r3, #0xab4c
a038c138 70314ae3 movt     r3, #0xa170
a038c13c 002083e5 str      r2, [r3]
a038c140 ad0000ea b        #0xa038c3fc
a038c144 d5390be3 movw     r3, #0xb9d5
a038c148 70314ae3 movt     r3, #0xa170
a038c14c 0030d3e5 ldrb     r3, [r3]
a038c150 0320a0e1 mov      r2, r3
a038c154 283f0ae3 movw     r3, #0xaf28
a038c158 70314ae3 movt     r3, #0xa170
a038c15c 0030d3e5 ldrb     r3, [r3]
a038c160 7330afe6 sxtb     r3, r3
a038c164 030052e1 cmp      r2, r3
a038c168 300000ba blt      #0xa038c230
a038c16c e0390be3 movw     r3, #0xb9e0
a038c170 70314ae3 movt     r3, #0xa170
a038c174 002093e5 ldr      r2, [r3]
a038c178 283f0ae3 movw     r3, #0xaf28
a038c17c 70314ae3 movt     r3, #0xa170
a038c180 0030d3e5 ldrb     r3, [r3]
a038c184 7330afe6 sxtb     r3, r3
a038c188 023063e0 rsb      r3, r3, r2
a038c18c 7c318de5 str      r3, [sp, #0x17c]
a038c190 7c319de5 ldr      r3, [sp, #0x17c]
a038c194 000053e3 cmp      r3, #0
a038c198 050000aa bge      #0xa038c1b4
a038c19c 003d02e3 movw     r3, #0x2d00
a038c1a0 70314ae3 movt     r3, #0xa170
a038c1a4 102293e5 ldr      r2, [r3, #0x210]
a038c1a8 7c319de5 ldr      r3, [sp, #0x17c]
a038c1ac 033082e0 add      r3, r2, r3
a038c1b0 7c318de5 str      r3, [sp, #0x17c]
a038c1b4 e0390be3 movw     r3, #0xb9e0
a038c1b8 70314ae3 movt     r3, #0xa170
a038c1bc 002093e5 ldr      r2, [r3]
a038c1c0 003d02e3 movw     r3, #0x2d00
a038c1c4 70314ae3 movt     r3, #0xa170
a038c1c8 021193e7 ldr      r1, [r3, r2, lsl #2]
a038c1cc e0390be3 movw     r3, #0xb9e0
a038c1d0 70314ae3 movt     r3, #0xa170
a038c1d4 003093e5 ldr      r3, [r3]
a038c1d8 002d02e3 movw     r2, #0x2d00
a038c1dc 70214ae3 movt     r2, #0xa170
a038c1e0 663f83e2 add      r3, r3, #0x198
a038c1e4 033083e2 add      r3, r3, #3
a038c1e8 033192e7 ldr      r3, [r2, r3, lsl #2]
a038c1ec 011063e0 rsb      r1, r3, r1
a038c1f0 002d02e3 movw     r2, #0x2d00
a038c1f4 70214ae3 movt     r2, #0xa170
a038c1f8 7c319de5 ldr      r3, [sp, #0x17c]
a038c1fc 663f83e2 add      r3, r3, #0x198
a038c200 033083e2 add      r3, r3, #3
a038c204 032192e7 ldr      r2, [r2, r3, lsl #2]
a038c208 003d02e3 movw     r3, #0x2d00
a038c20c 70314ae3 movt     r3, #0xa170
a038c210 7c019de5 ldr      r0, [sp, #0x17c]
a038c214 003193e7 ldr      r3, [r3, r0, lsl #2]
a038c218 023063e0 rsb      r3, r3, r2
a038c21c 032081e0 add      r2, r1, r3
a038c220 203f0ae3 movw     r3, #0xaf20
a038c224 70314ae3 movt     r3, #0xa170
a038c228 002083e5 str      r2, [r3]
a038c22c 030000ea b        #0xa038c240
a038c230 203f0ae3 movw     r3, #0xaf20
a038c234 70314ae3 movt     r3, #0xa170
a038c238 0020a0e3 mov      r2, #0
a038c23c 002083e5 str      r2, [r3]
a038c240 083f0ae3 movw     r3, #0xaf08
a038c244 70314ae3 movt     r3, #0xa170
a038c248 002093e5 ldr      r2, [r3]
a038c24c 0c3f0ae3 movw     r3, #0xaf0c
a038c250 70314ae3 movt     r3, #0xa170
a038c254 003093e5 ldr      r3, [r3]
a038c258 030052e1 cmp      r2, r3
a038c25c 3300002a bhs      #0xa038c330
a038c260 e0390be3 movw     r3, #0xb9e0
a038c264 70314ae3 movt     r3, #0xa170
a038c268 003093e5 ldr      r3, [r3]
a038c26c 0320a0e1 mov      r2, r3
a038c270 0c3f0ae3 movw     r3, #0xaf0c
a038c274 70314ae3 movt     r3, #0xa170
a038c278 003093e5 ldr      r3, [r3]
a038c27c 030052e1 cmp      r2, r3
a038c280 0800008a bhi      #0xa038c2a8
a038c284 e0390be3 movw     r3, #0xb9e0
a038c288 70314ae3 movt     r3, #0xa170
a038c28c 003093e5 ldr      r3, [r3]
a038c290 0320a0e1 mov      r2, r3
a038c294 083f0ae3 movw     r3, #0xaf08
a038c298 70314ae3 movt     r3, #0xa170
a038c29c 003093e5 ldr      r3, [r3]
a038c2a0 030052e1 cmp      r2, r3
a038c2a4 0400008a bhi      #0xa038c2bc
a038c2a8 4c3b0ae3 movw     r3, #0xab4c
a038c2ac 70314ae3 movt     r3, #0xa170
a038c2b0 0020a0e3 mov      r2, #0
a038c2b4 002083e5 str      r2, [r3]
a038c2b8 4f0000ea b        #0xa038c3fc
a038c2bc e0390be3 movw     r3, #0xb9e0
a038c2c0 70314ae3 movt     r3, #0xa170
a038c2c4 002093e5 ldr      r2, [r3]
a038c2c8 003d02e3 movw     r3, #0x2d00
a038c2cc 70314ae3 movt     r3, #0xa170
a038c2d0 021193e7 ldr      r1, [r3, r2, lsl #2]
a038c2d4 e0390be3 movw     r3, #0xb9e0
a038c2d8 70314ae3 movt     r3, #0xa170
a038c2dc 003093e5 ldr      r3, [r3]
a038c2e0 002d02e3 movw     r2, #0x2d00
a038c2e4 70214ae3 movt     r2, #0xa170
a038c2e8 663f83e2 add      r3, r3, #0x198
a038c2ec 033083e2 add      r3, r3, #3
a038c2f0 033192e7 ldr      r3, [r2, r3, lsl #2]
a038c2f4 012063e0 rsb      r2, r3, r1
a038c2f8 4c3b0ae3 movw     r3, #0xab4c
a038c2fc 70314ae3 movt     r3, #0xa170
a038c300 002083e5 str      r2, [r3]
a038c304 4c3b0ae3 movw     r3, #0xab4c
a038c308 70314ae3 movt     r3, #0xa170
a038c30c 002093e5 ldr      r2, [r3]
a038c310 203f0ae3 movw     r3, #0xaf20
a038c314 70314ae3 movt     r3, #0xa170
a038c318 003093e5 ldr      r3, [r3]
a038c31c 032082e0 add      r2, r2, r3
a038c320 4c3b0ae3 movw     r3, #0xab4c
a038c324 70314ae3 movt     r3, #0xa170
a038c328 002083e5 str      r2, [r3]
a038c32c 320000ea b        #0xa038c3fc
a038c330 e0390be3 movw     r3, #0xb9e0
a038c334 70314ae3 movt     r3, #0xa170
a038c338 003093e5 ldr      r3, [r3]
a038c33c 0320a0e1 mov      r2, r3
a038c340 0c3f0ae3 movw     r3, #0xaf0c
a038c344 70314ae3 movt     r3, #0xa170
a038c348 003093e5 ldr      r3, [r3]
a038c34c 030052e1 cmp      r2, r3
a038c350 0d00009a bls      #0xa038c38c
a038c354 e0390be3 movw     r3, #0xb9e0
a038c358 70314ae3 movt     r3, #0xa170
a038c35c 003093e5 ldr      r3, [r3]
a038c360 0320a0e1 mov      r2, r3
a038c364 083f0ae3 movw     r3, #0xaf08
a038c368 70314ae3 movt     r3, #0xa170
a038c36c 003093e5 ldr      r3, [r3]
a038c370 030052e1 cmp      r2, r3
a038c374 0400008a bhi      #0xa038c38c
a038c378 4c3b0ae3 movw     r3, #0xab4c
a038c37c 70314ae3 movt     r3, #0xa170
a038c380 0020a0e3 mov      r2, #0
a038c384 002083e5 str      r2, [r3]
a038c388 1b0000ea b        #0xa038c3fc
a038c38c e0390be3 movw     r3, #0xb9e0
a038c390 70314ae3 movt     r3, #0xa170
a038c394 002093e5 ldr      r2, [r3]
a038c398 003d02e3 movw     r3, #0x2d00
a038c39c 70314ae3 movt     r3, #0xa170
a038c3a0 021193e7 ldr      r1, [r3, r2, lsl #2]
a038c3a4 e0390be3 movw     r3, #0xb9e0
a038c3a8 70314ae3 movt     r3, #0xa170
a038c3ac 003093e5 ldr      r3, [r3]
a038c3b0 002d02e3 movw     r2, #0x2d00
a038c3b4 70214ae3 movt     r2, #0xa170
a038c3b8 663f83e2 add      r3, r3, #0x198
a038c3bc 033083e2 add      r3, r3, #3
a038c3c0 033192e7 ldr      r3, [r2, r3, lsl #2]
a038c3c4 012063e0 rsb      r2, r3, r1
a038c3c8 4c3b0ae3 movw     r3, #0xab4c
a038c3cc 70314ae3 movt     r3, #0xa170
a038c3d0 002083e5 str      r2, [r3]
a038c3d4 4c3b0ae3 movw     r3, #0xab4c
a038c3d8 70314ae3 movt     r3, #0xa170
a038c3dc 002093e5 ldr      r2, [r3]
a038c3e0 203f0ae3 movw     r3, #0xaf20
a038c3e4 70314ae3 movt     r3, #0xa170
a038c3e8 003093e5 ldr      r3, [r3]
a038c3ec 032082e0 add      r2, r2, r3
a038c3f0 4c3b0ae3 movw     r3, #0xab4c
a038c3f4 70314ae3 movt     r3, #0xa170
a038c3f8 002083e5 str      r2, [r3]
a038c3fc e0390be3 movw     r3, #0xb9e0
a038c400 70314ae3 movt     r3, #0xa170
a038c404 003093e5 ldr      r3, [r3]
a038c408 0320a0e1 mov      r2, r3
a038c40c f03e0ae3 movw     r3, #0xaef0
a038c410 70314ae3 movt     r3, #0xa170
a038c414 002083e5 str      r2, [r3]
a038c418 4c3b0ae3 movw     r3, #0xab4c
a038c41c 70314ae3 movt     r3, #0xa170
a038c420 002093e5 ldr      r2, [r3]
a038c424 103f0ae3 movw     r3, #0xaf10
a038c428 70314ae3 movt     r3, #0xa170
a038c42c 002083e5 str      r2, [r3]
a038c430 443b0ae3 movw     r3, #0xab44
a038c434 70314ae3 movt     r3, #0xa170
a038c438 003093e5 ldr      r3, [r3]
a038c43c 000053e3 cmp      r3, #0
a038c440 4800000a beq      #0xa038c568
a038c444 e4390be3 movw     r3, #0xb9e4
a038c448 70314ae3 movt     r3, #0xa170
a038c44c 003093e5 ldr      r3, [r3]
a038c450 000053e3 cmp      r3, #0
a038c454 4300000a beq      #0xa038c568
a038c458 e8390be3 movw     r3, #0xb9e8
a038c45c 70314ae3 movt     r3, #0xa170
a038c460 0120a0e3 mov      r2, #1
a038c464 0020c3e5 strb     r2, [r3]
a038c468 4c3b0ae3 movw     r3, #0xab4c
a038c46c 70314ae3 movt     r3, #0xa170
a038c470 003093e5 ldr      r3, [r3]
a038c474 000053e3 cmp      r3, #0
a038c478 030000aa bge      #0xa038c48c
a038c47c e8390be3 movw     r3, #0xb9e8
a038c480 70314ae3 movt     r3, #0xa170
a038c484 0020e0e3 mvn      r2, #0
a038c488 0020c3e5 strb     r2, [r3]
a038c48c 443b0ae3 movw     r3, #0xab44
a038c490 70314ae3 movt     r3, #0xa170
a038c494 003093e5 ldr      r3, [r3]
a038c498 c32f23e0 eor      r2, r3, r3, asr #31
a038c49c c32f42e0 sub      r2, r2, r3, asr #31
a038c4a0 ec390be3 movw     r3, #0xb9ec
a038c4a4 70314ae3 movt     r3, #0xa170
a038c4a8 002083e5 str      r2, [r3]
a038c4ac ec390be3 movw     r3, #0xb9ec
a038c4b0 70314ae3 movt     r3, #0xa170
a038c4b4 003093e5 ldr      r3, [r3]
a038c4b8 0300a0e1 mov      r0, r3
a038c4bc c01fa0e1 asr      r1, r0, #0x1f
a038c4c0 4c3b0ae3 movw     r3, #0xab4c
a038c4c4 70314ae3 movt     r3, #0xa170
a038c4c8 003093e5 ldr      r3, [r3]
a038c4cc 000053e3 cmp      r3, #0
a038c4d0 003063b2 rsblt    r3, r3, #0
a038c4d4 0320a0e1 mov      r2, r3
a038c4d8 c23fa0e1 asr      r3, r2, #0x1f
a038c4dc 92010ee0 mul      lr, r2, r1
a038c4e0 90030ce0 mul      ip, r0, r3
a038c4e4 0cc08ee0 add      ip, lr, ip
a038c4e8 902283e0 umull    r2, r3, r0, r2
a038c4ec 03108ce0 add      r1, ip, r3
a038c4f0 0130a0e1 mov      r3, r1
a038c4f4 e4190be3 movw     r1, #0xb9e4
a038c4f8 70114ae3 movt     r1, #0xa170
a038c4fc 001091e5 ldr      r1, [r1]
a038c500 000051e3 cmp      r1, #0
a038c504 001061b2 rsblt    r1, r1, #0
a038c508 0140a0e1 mov      r4, r1
a038c50c c45fa0e1 asr      r5, r4, #0x1f
a038c510 0200a0e1 mov      r0, r2
a038c514 0310a0e1 mov      r1, r3
a038c518 0420a0e1 mov      r2, r4
a038c51c 0530a0e1 mov      r3, r5
a038c520 84ea05fa blx      #0xa0506f38
a038c524 0020a0e1 mov      r2, r0
a038c528 0130a0e1 mov      r3, r1
a038c52c ec390be3 movw     r3, #0xb9ec
a038c530 70314ae3 movt     r3, #0xa170
a038c534 002083e5 str      r2, [r3]
a038c538 ec390be3 movw     r3, #0xb9ec
a038c53c 70314ae3 movt     r3, #0xa170
a038c540 002093e5 ldr      r2, [r3]
a038c544 e8390be3 movw     r3, #0xb9e8
a038c548 70314ae3 movt     r3, #0xa170
a038c54c 0030d3e5 ldrb     r3, [r3]
a038c550 7330afe6 sxtb     r3, r3
a038c554 930202e0 mul      r2, r3, r2
a038c558 ec390be3 movw     r3, #0xb9ec
a038c55c 70314ae3 movt     r3, #0xa170
a038c560 002083e5 str      r2, [r3]
a038c564 190000ea b        #0xa038c5d0
a038c568 4c3b0ae3 movw     r3, #0xab4c
a038c56c 70314ae3 movt     r3, #0xa170
a038c570 002093e5 ldr      r2, [r3]
a038c574 243b0ae3 movw     r3, #0xab24
a038c578 70314ae3 movt     r3, #0xa170
a038c57c 003093e5 ldr      r3, [r3]
a038c580 0000a0e3 mov      r0, #0
a038c584 0210a0e1 mov      r1, r2
a038c588 0320a0e1 mov      r2, r3
a038c58c d1bdffeb bl       #0xa037bcd8
a038c590 0020a0e1 mov      r2, r0
a038c594 ec390be3 movw     r3, #0xb9ec
a038c598 70314ae3 movt     r3, #0xa170
a038c59c 002083e5 str      r2, [r3]
a038c5a0 ec390be3 movw     r3, #0xb9ec
a038c5a4 70314ae3 movt     r3, #0xa170
a038c5a8 002093e5 ldr      r2, [r3]
a038c5ac 443b0ae3 movw     r3, #0xab44
a038c5b0 70314ae3 movt     r3, #0xa170
a038c5b4 002083e5 str      r2, [r3]
a038c5b8 4c3b0ae3 movw     r3, #0xab4c
a038c5bc 70314ae3 movt     r3, #0xa170
a038c5c0 002093e5 ldr      r2, [r3]
a038c5c4 e4390be3 movw     r3, #0xb9e4
a038c5c8 70314ae3 movt     r3, #0xa170
a038c5cc 002083e5 str      r2, [r3]
a038c5d0 ec390be3 movw     r3, #0xb9ec
a038c5d4 70314ae3 movt     r3, #0xa170
a038c5d8 002093e5 ldr      r2, [r3]
a038c5dc f43e0ae3 movw     r3, #0xaef4
a038c5e0 70314ae3 movt     r3, #0xa170
a038c5e4 002083e5 str      r2, [r3]
a038c5e8 ec390be3 movw     r3, #0xb9ec
a038c5ec 70314ae3 movt     r3, #0xa170
a038c5f0 002093e5 ldr      r2, [r3]
a038c5f4 863a07e3 movw     r3, #0x7a86
a038c5f8 75304ae3 movt     r3, #0xa075
a038c5fc 0030d3e5 ldrb     r3, [r3]
a038c600 7330afe6 sxtb     r3, r3
a038c604 930201e0 mul      r1, r3, r2
a038c608 1f3508e3 movw     r3, #0x851f
a038c60c eb3145e3 movt     r3, #0x51eb
a038c610 9123c3e0 smull    r2, r3, r1, r3
a038c614 c322a0e1 asr      r2, r3, #5
a038c618 c13fa0e1 asr      r3, r1, #0x1f
a038c61c 022063e0 rsb      r2, r3, r2
a038c620 ec390be3 movw     r3, #0xb9ec
a038c624 70314ae3 movt     r3, #0xa170
a038c628 002083e5 str      r2, [r3]
a038c62c ec390be3 movw     r3, #0xb9ec
a038c630 70314ae3 movt     r3, #0xa170
a038c634 002093e5 ldr      r2, [r3]
a038c638 643204e3 movw     r3, #0x4264
a038c63c 70314ae3 movt     r3, #0xa170
a038c640 003093e5 ldr      r3, [r3]
a038c644 930202e0 mul      r2, r3, r2
a038c648 283104e3 movw     r3, #0x4128
a038c64c 70314ae3 movt     r3, #0xa170
a038c650 0c3093e5 ldr      r3, [r3, #0xc]
a038c654 0200a0e1 mov      r0, r2
a038c658 0310a0e1 mov      r1, r3
a038c65c 0be805fa blx      #0xa0506690
a038c660 0030a0e1 mov      r3, r0
a038c664 0320a0e1 mov      r2, r3
a038c668 f4390be3 movw     r3, #0xb9f4
a038c66c 70314ae3 movt     r3, #0xa170
a038c670 002083e5 str      r2, [r3]
a038c674 d8390be3 movw     r3, #0xb9d8
a038c678 70314ae3 movt     r3, #0xa170
a038c67c 003093e5 ldr      r3, [r3]
a038c680 000053e3 cmp      r3, #0
a038c684 180000ba blt      #0xa038c6ec
a038c688 b03204e3 movw     r3, #0x42b0
a038c68c 70314ae3 movt     r3, #0xa170
a038c690 002093e5 ldr      r2, [r3]
a038c694 c03204e3 movw     r3, #0x42c0
a038c698 70314ae3 movt     r3, #0xa170
a038c69c 003093e5 ldr      r3, [r3]
a038c6a0 032082e0 add      r2, r2, r3
a038c6a4 d8390be3 movw     r3, #0xb9d8
a038c6a8 70314ae3 movt     r3, #0xa170
a038c6ac 003093e5 ldr      r3, [r3]
a038c6b0 022063e0 rsb      r2, r3, r2
a038c6b4 fc390be3 movw     r3, #0xb9fc
a038c6b8 70314ae3 movt     r3, #0xa170
a038c6bc 002083e5 str      r2, [r3]
a038c6c0 b83204e3 movw     r3, #0x42b8
a038c6c4 70314ae3 movt     r3, #0xa170
a038c6c8 002093e5 ldr      r2, [r3]
a038c6cc c83204e3 movw     r3, #0x42c8
a038c6d0 70314ae3 movt     r3, #0xa170
a038c6d4 003093e5 ldr      r3, [r3]
a038c6d8 032082e0 add      r2, r2, r3
a038c6dc 043a0be3 movw     r3, #0xba04
a038c6e0 70314ae3 movt     r3, #0xa170
a038c6e4 002083e5 str      r2, [r3]
a038c6e8 170000ea b        #0xa038c74c
a038c6ec b03204e3 movw     r3, #0x42b0
a038c6f0 70314ae3 movt     r3, #0xa170
a038c6f4 002093e5 ldr      r2, [r3]
a038c6f8 c03204e3 movw     r3, #0x42c0
a038c6fc 70314ae3 movt     r3, #0xa170
a038c700 003093e5 ldr      r3, [r3]
a038c704 032082e0 add      r2, r2, r3
a038c708 fc390be3 movw     r3, #0xb9fc
a038c70c 70314ae3 movt     r3, #0xa170
a038c710 002083e5 str      r2, [r3]
a038c714 b83204e3 movw     r3, #0x42b8
a038c718 70314ae3 movt     r3, #0xa170
a038c71c 002093e5 ldr      r2, [r3]
a038c720 c83204e3 movw     r3, #0x42c8
a038c724 70314ae3 movt     r3, #0xa170
a038c728 003093e5 ldr      r3, [r3]
a038c72c 032082e0 add      r2, r2, r3
a038c730 d8390be3 movw     r3, #0xb9d8
a038c734 70314ae3 movt     r3, #0xa170
a038c738 003093e5 ldr      r3, [r3]
a038c73c 032082e0 add      r2, r2, r3
a038c740 043a0be3 movw     r3, #0xba04
a038c744 70314ae3 movt     r3, #0xa170
a038c748 002083e5 str      r2, [r3]
a038c74c f4390be3 movw     r3, #0xb9f4
a038c750 70314ae3 movt     r3, #0xa170
a038c754 002093e5 ldr      r2, [r3]
a038c758 fc390be3 movw     r3, #0xb9fc
a038c75c 70314ae3 movt     r3, #0xa170
a038c760 003093e5 ldr      r3, [r3]
a038c764 030052e1 cmp      r2, r3
a038c768 060000da ble      #0xa038c788
a038c76c fc390be3 movw     r3, #0xb9fc
a038c770 70314ae3 movt     r3, #0xa170
a038c774 002093e5 ldr      r2, [r3]
a038c778 f4390be3 movw     r3, #0xb9f4
a038c77c 70314ae3 movt     r3, #0xa170
a038c780 002083e5 str      r2, [r3]
a038c784 0f0000ea b        #0xa038c7c8
a038c788 f4390be3 movw     r3, #0xb9f4
a038c78c 70314ae3 movt     r3, #0xa170
a038c790 002093e5 ldr      r2, [r3]
a038c794 043a0be3 movw     r3, #0xba04
a038c798 70314ae3 movt     r3, #0xa170
a038c79c 003093e5 ldr      r3, [r3]
a038c7a0 003063e2 rsb      r3, r3, #0
a038c7a4 030052e1 cmp      r2, r3
a038c7a8 060000aa bge      #0xa038c7c8
a038c7ac 043a0be3 movw     r3, #0xba04
a038c7b0 70314ae3 movt     r3, #0xa170
a038c7b4 003093e5 ldr      r3, [r3]
a038c7b8 002063e2 rsb      r2, r3, #0
a038c7bc f4390be3 movw     r3, #0xb9f4
a038c7c0 70314ae3 movt     r3, #0xa170
a038c7c4 002083e5 str      r2, [r3]
a038c7c8 263204e3 movw     r3, #0x4226
a038c7cc 70314ae3 movt     r3, #0xa170
a038c7d0 0030d3e5 ldrb     r3, [r3]
a038c7d4 ff0053e3 cmp      r3, #0xff
a038c7d8 0e00001a bne      #0xa038c818
a038c7dc f4390be3 movw     r3, #0xb9f4
a038c7e0 70314ae3 movt     r3, #0xa170
a038c7e4 002093e5 ldr      r2, [r3]
a038c7e8 243204e3 movw     r3, #0x4224
a038c7ec 70314ae3 movt     r3, #0xa170
a038c7f0 0030d3e5 ldrb     r3, [r3]
a038c7f4 0200a0e1 mov      r0, r2
a038c7f8 0310a0e1 mov      r1, r3
a038c7fc a3e705fa blx      #0xa0506690
a038c800 0030a0e1 mov      r3, r0
a038c804 0320a0e1 mov      r2, r3
a038c808 f4390be3 movw     r3, #0xb9f4
a038c80c 70314ae3 movt     r3, #0xa170
a038c810 002083e5 str      r2, [r3]
a038c814 090000ea b        #0xa038c840
a038c818 f4390be3 movw     r3, #0xb9f4
a038c81c 70314ae3 movt     r3, #0xa170
a038c820 002093e5 ldr      r2, [r3]
a038c824 263204e3 movw     r3, #0x4226
a038c828 70314ae3 movt     r3, #0xa170
a038c82c 0030d3e5 ldrb     r3, [r3]
a038c830 5223a0e1 asr      r2, r2, r3
a038c834 f4390be3 movw     r3, #0xb9f4
a038c838 70314ae3 movt     r3, #0xa170
a038c83c 002083e5 str      r2, [r3]
a038c840 f4390be3 movw     r3, #0xb9f4
a038c844 70314ae3 movt     r3, #0xa170
a038c848 003093e5 ldr      r3, [r3]
a038c84c 0324a0e1 lsl      r2, r3, #8
a038c850 643204e3 movw     r3, #0x4264
a038c854 70314ae3 movt     r3, #0xa170
a038c858 003093e5 ldr      r3, [r3]
a038c85c 0200a0e1 mov      r0, r2
a038c860 0310a0e1 mov      r1, r3
a038c864 89e705fa blx      #0xa0506690
a038c868 0030a0e1 mov      r3, r0
a038c86c 0320a0e1 mov      r2, r3
a038c870 f4390be3 movw     r3, #0xb9f4
a038c874 70314ae3 movt     r3, #0xa170
a038c878 002083e5 str      r2, [r3]
a038c87c e8390be3 movw     r3, #0xb9e8
a038c880 70314ae3 movt     r3, #0xa170
a038c884 0120a0e3 mov      r2, #1
a038c888 0020c3e5 strb     r2, [r3]
a038c88c f4390be3 movw     r3, #0xb9f4
a038c890 70314ae3 movt     r3, #0xa170
a038c894 003093e5 ldr      r3, [r3]
a038c898 000053e3 cmp      r3, #0
a038c89c 0a0000aa bge      #0xa038c8cc
a038c8a0 f4390be3 movw     r3, #0xb9f4
a038c8a4 70314ae3 movt     r3, #0xa170
a038c8a8 003093e5 ldr      r3, [r3]
a038c8ac 002063e2 rsb      r2, r3, #0
a038c8b0 f4390be3 movw     r3, #0xb9f4
a038c8b4 70314ae3 movt     r3, #0xa170
a038c8b8 002083e5 str      r2, [r3]
a038c8bc e8390be3 movw     r3, #0xb9e8
a038c8c0 70314ae3 movt     r3, #0xa170
a038c8c4 0020e0e3 mvn      r2, #0
a038c8c8 0020c3e5 strb     r2, [r3]
a038c8cc f4390be3 movw     r3, #0xb9f4
a038c8d0 70314ae3 movt     r3, #0xa170
a038c8d4 003093e5 ldr      r3, [r3]
a038c8d8 0300a0e1 mov      r0, r3
a038c8dc c01fa0e1 asr      r1, r0, #0x1f
a038c8e0 4c3204e3 movw     r3, #0x424c
a038c8e4 70314ae3 movt     r3, #0xa170
a038c8e8 003093e5 ldr      r3, [r3]
a038c8ec 0320a0e1 mov      r2, r3
a038c8f0 0030a0e3 mov      r3, #0
a038c8f4 92010ee0 mul      lr, r2, r1
a038c8f8 90030ce0 mul      ip, r0, r3
a038c8fc 0cc08ee0 add      ip, lr, ip
a038c900 902283e0 umull    r2, r3, r0, r2
a038c904 03108ce0 add      r1, ip, r3
a038c908 0130a0e1 mov      r3, r1
a038c90c 501204e3 movw     r1, #0x4250
a038c910 70114ae3 movt     r1, #0xa170
a038c914 001091e5 ldr      r1, [r1]
a038c918 0140a0e1 mov      r4, r1
a038c91c 0050a0e3 mov      r5, #0
a038c920 0200a0e1 mov      r0, r2
a038c924 0310a0e1 mov      r1, r3
a038c928 0420a0e1 mov      r2, r4
a038c92c 0530a0e1 mov      r3, r5
a038c930 80e905fa blx      #0xa0506f38
a038c934 0020a0e1 mov      r2, r0
a038c938 0130a0e1 mov      r3, r1
a038c93c f4390be3 movw     r3, #0xb9f4
a038c940 70314ae3 movt     r3, #0xa170
a038c944 002083e5 str      r2, [r3]
a038c948 e8390be3 movw     r3, #0xb9e8
a038c94c 70314ae3 movt     r3, #0xa170
a038c950 0030d3e5 ldrb     r3, [r3]
a038c954 7330afe6 sxtb     r3, r3
a038c958 010073e3 cmn      r3, #1
a038c95c 0600001a bne      #0xa038c97c
a038c960 f4390be3 movw     r3, #0xb9f4
a038c964 70314ae3 movt     r3, #0xa170
a038c968 003093e5 ldr      r3, [r3]
a038c96c 002063e2 rsb      r2, r3, #0
a038c970 f4390be3 movw     r3, #0xb9f4
a038c974 70314ae3 movt     r3, #0xa170
a038c978 002083e5 str      r2, [r3]
a038c97c c03c02e3 movw     r3, #0x2cc0
a038c980 70314ae3 movt     r3, #0xa170
a038c984 0b30d3e5 ldrb     r3, [r3, #0xb]
a038c988 7330afe6 sxtb     r3, r3
a038c98c 010073e3 cmn      r3, #1
a038c990 0600001a bne      #0xa038c9b0
a038c994 f4390be3 movw     r3, #0xb9f4
a038c998 70314ae3 movt     r3, #0xa170
a038c99c 003093e5 ldr      r3, [r3]
a038c9a0 002063e2 rsb      r2, r3, #0
a038c9a4 f4390be3 movw     r3, #0xb9f4
a038c9a8 70314ae3 movt     r3, #0xa170
a038c9ac 002083e5 str      r2, [r3]
a038c9b0 b03c02e3 movw     r3, #0x2cb0
a038c9b4 70314ae3 movt     r3, #0xa170
a038c9b8 003093e5 ldr      r3, [r3]
a038c9bc 000053e3 cmp      r3, #0
a038c9c0 0600000a beq      #0xa038c9e0
a038c9c4 f4390be3 movw     r3, #0xb9f4
a038c9c8 70314ae3 movt     r3, #0xa170
a038c9cc 003093e5 ldr      r3, [r3]
a038c9d0 002063e2 rsb      r2, r3, #0
a038c9d4 f4390be3 movw     r3, #0xb9f4
a038c9d8 70314ae3 movt     r3, #0xa170
a038c9dc 002083e5 str      r2, [r3]
a038c9e0 7c330be3 movw     r3, #0xb37c
a038c9e4 70314ae3 movt     r3, #0xa170
a038c9e8 002093e5 ldr      r2, [r3]
a038c9ec 0c3a0be3 movw     r3, #0xba0c
a038c9f0 70314ae3 movt     r3, #0xa170
a038c9f4 002083e5 str      r2, [r3]
a038c9f8 7c330be3 movw     r3, #0xb37c
a038c9fc 70314ae3 movt     r3, #0xa170
a038ca00 042093e5 ldr      r2, [r3, #4]
a038ca04 0c3a0be3 movw     r3, #0xba0c
a038ca08 70314ae3 movt     r3, #0xa170
a038ca0c 042083e5 str      r2, [r3, #4]
a038ca10 d03a07e3 movw     r3, #0x7ad0
a038ca14 75304ae3 movt     r3, #0xa075
a038ca18 0030d3e5 ldrb     r3, [r3]
a038ca1c 090053e3 cmp      r3, #9
a038ca20 0a00008a bhi      #0xa038ca50
a038ca24 0c3a0be3 movw     r3, #0xba0c
a038ca28 70314ae3 movt     r3, #0xa170
a038ca2c 002093e5 ldr      r2, [r3]
a038ca30 0c3a0be3 movw     r3, #0xba0c
a038ca34 70314ae3 movt     r3, #0xa170
a038ca38 043093e5 ldr      r3, [r3, #4]
a038ca3c a40900e3 movw     r0, #0x9a4
a038ca40 60004ae3 movt     r0, #0xa060
a038ca44 0210a0e1 mov      r1, r2
a038ca48 0320a0e1 mov      r2, r3
a038ca4c a669fceb bl       #0xa02a70ec
a038ca50 f4390be3 movw     r3, #0xb9f4
a038ca54 70314ae3 movt     r3, #0xa170
a038ca58 003093e5 ldr      r3, [r3]
a038ca5c 0300a0e1 mov      r0, r3
a038ca60 7c130be3 movw     r1, #0xb37c
a038ca64 70114ae3 movt     r1, #0xa170
a038ca68 79deffeb bl       #0xa0384454
a038ca6c 0030a0e1 mov      r3, r0
a038ca70 000053e3 cmp      r3, #0
a038ca74 e704001a bne      #0xa038de18
a038ca78 f83e0ae3 movw     r3, #0xaef8
a038ca7c 70314ae3 movt     r3, #0xa170
a038ca80 0030d3e5 ldrb     r3, [r3]
a038ca84 010053e3 cmp      r3, #1
a038ca88 1200000a beq      #0xa038cad8
a038ca8c e0390be3 movw     r3, #0xb9e0
a038ca90 70314ae3 movt     r3, #0xa170
a038ca94 002093e5 ldr      r2, [r3]
a038ca98 003d02e3 movw     r3, #0x2d00
a038ca9c 70314ae3 movt     r3, #0xa170
a038caa0 892082e2 add      r2, r2, #0x89
a038caa4 022193e7 ldr      r2, [r3, r2, lsl #2]
a038caa8 e0390be3 movw     r3, #0xb9e0
a038caac 70314ae3 movt     r3, #0xa170
a038cab0 001093e5 ldr      r1, [r3]
a038cab4 003d02e3 movw     r3, #0x2d00
a038cab8 70314ae3 movt     r3, #0xa170
a038cabc 891f81e2 add      r1, r1, #0x224
a038cac0 013193e7 ldr      r3, [r3, r1, lsl #2]
a038cac4 022063e0 rsb      r2, r3, r2
a038cac8 503b0ae3 movw     r3, #0xab50
a038cacc 70314ae3 movt     r3, #0xa170
a038cad0 002083e5 str      r2, [r3]
a038cad4 8e0200ea b        #0xa038d514
a038cad8 d5390be3 movw     r3, #0xb9d5
a038cadc 70314ae3 movt     r3, #0xa170
a038cae0 0030d3e5 ldrb     r3, [r3]
a038cae4 000053e3 cmp      r3, #0
a038cae8 0e01001a bne      #0xa038cf28
a038caec 0030a0e3 mov      r3, #0
a038caf0 8b31cde5 strb     r3, [sp, #0x18b]
a038caf4 0030a0e3 mov      r3, #0
a038caf8 84318de5 str      r3, [sp, #0x184]
a038cafc 1c3f0ae3 movw     r3, #0xaf1c
a038cb00 70314ae3 movt     r3, #0xa170
a038cb04 0020a0e3 mov      r2, #0
a038cb08 002083e5 str      r2, [r3]
a038cb0c 083f0ae3 movw     r3, #0xaf08
a038cb10 70314ae3 movt     r3, #0xa170
a038cb14 002093e5 ldr      r2, [r3]
a038cb18 0c3f0ae3 movw     r3, #0xaf0c
a038cb1c 70314ae3 movt     r3, #0xa170
a038cb20 003093e5 ldr      r3, [r3]
a038cb24 030052e1 cmp      r2, r3
a038cb28 7100002a bhs      #0xa038ccf4
a038cb2c e0390be3 movw     r3, #0xb9e0
a038cb30 70314ae3 movt     r3, #0xa170
a038cb34 003093e5 ldr      r3, [r3]
a038cb38 0320a0e1 mov      r2, r3
a038cb3c 0c3f0ae3 movw     r3, #0xaf0c
a038cb40 70314ae3 movt     r3, #0xa170
a038cb44 003093e5 ldr      r3, [r3]
a038cb48 030052e1 cmp      r2, r3
a038cb4c 0800008a bhi      #0xa038cb74
a038cb50 e0390be3 movw     r3, #0xb9e0
a038cb54 70314ae3 movt     r3, #0xa170
a038cb58 003093e5 ldr      r3, [r3]
a038cb5c 0320a0e1 mov      r2, r3
a038cb60 083f0ae3 movw     r3, #0xaf08
a038cb64 70314ae3 movt     r3, #0xa170
a038cb68 003093e5 ldr      r3, [r3]
a038cb6c 030052e1 cmp      r2, r3
a038cb70 0400008a bhi      #0xa038cb88
a038cb74 503b0ae3 movw     r3, #0xab50
a038cb78 70314ae3 movt     r3, #0xa170
a038cb7c 0020a0e3 mov      r2, #0
a038cb80 002083e5 str      r2, [r3]
a038cb84 620200ea b        #0xa038d514
a038cb88 e0390be3 movw     r3, #0xb9e0
a038cb8c 70314ae3 movt     r3, #0xa170
a038cb90 003093e5 ldr      r3, [r3]
a038cb94 7320efe6 uxtb     r2, r3
a038cb98 083f0ae3 movw     r3, #0xaf08
a038cb9c 70314ae3 movt     r3, #0xa170
a038cba0 003093e5 ldr      r3, [r3]
a038cba4 7330efe6 uxtb     r3, r3
a038cba8 023063e0 rsb      r3, r3, r2
a038cbac 7330efe6 uxtb     r3, r3
a038cbb0 8b31cde5 strb     r3, [sp, #0x18b]
a038cbb4 0030a0e3 mov      r3, #0
a038cbb8 80318de5 str      r3, [sp, #0x180]
a038cbbc 270000ea b        #0xa038cc60
a038cbc0 083f0ae3 movw     r3, #0xaf08
a038cbc4 70314ae3 movt     r3, #0xa170
a038cbc8 002093e5 ldr      r2, [r3]
a038cbcc 80319de5 ldr      r3, [sp, #0x180]
a038cbd0 033082e0 add      r3, r2, r3
a038cbd4 013083e2 add      r3, r3, #1
a038cbd8 84318de5 str      r3, [sp, #0x184]
a038cbdc 84219de5 ldr      r2, [sp, #0x184]
a038cbe0 003d02e3 movw     r3, #0x2d00
a038cbe4 70314ae3 movt     r3, #0xa170
a038cbe8 103293e5 ldr      r3, [r3, #0x210]
a038cbec 030052e1 cmp      r2, r3
a038cbf0 0500003a blo      #0xa038cc0c
a038cbf4 84219de5 ldr      r2, [sp, #0x184]
a038cbf8 003d02e3 movw     r3, #0x2d00
a038cbfc 70314ae3 movt     r3, #0xa170
a038cc00 103293e5 ldr      r3, [r3, #0x210]
a038cc04 023063e0 rsb      r3, r3, r2
a038cc08 84318de5 str      r3, [sp, #0x184]
a038cc0c 003d02e3 movw     r3, #0x2d00
a038cc10 70314ae3 movt     r3, #0xa170
a038cc14 84219de5 ldr      r2, [sp, #0x184]
a038cc18 892082e2 add      r2, r2, #0x89
a038cc1c 022193e7 ldr      r2, [r3, r2, lsl #2]
a038cc20 003d02e3 movw     r3, #0x2d00
a038cc24 70314ae3 movt     r3, #0xa170
a038cc28 84119de5 ldr      r1, [sp, #0x184]
a038cc2c 891f81e2 add      r1, r1, #0x224
a038cc30 013193e7 ldr      r3, [r3, r1, lsl #2]
a038cc34 022063e0 rsb      r2, r3, r2
a038cc38 1c3f0ae3 movw     r3, #0xaf1c
a038cc3c 70314ae3 movt     r3, #0xa170
a038cc40 003093e5 ldr      r3, [r3]
a038cc44 032082e0 add      r2, r2, r3
a038cc48 1c3f0ae3 movw     r3, #0xaf1c
a038cc4c 70314ae3 movt     r3, #0xa170
a038cc50 002083e5 str      r2, [r3]
a038cc54 80319de5 ldr      r3, [sp, #0x180]
a038cc58 013083e2 add      r3, r3, #1
a038cc5c 80318de5 str      r3, [sp, #0x180]
a038cc60 623f8de2 add      r3, sp, #0x188
a038cc64 033083e2 add      r3, r3, #3
a038cc68 d030d3e1 ldrsb    r3, [r3]
a038cc6c 012043e2 sub      r2, r3, #1
a038cc70 80319de5 ldr      r3, [sp, #0x180]
a038cc74 030052e1 cmp      r2, r3
a038cc78 d0ffffca bgt      #0xa038cbc0
a038cc7c e0390be3 movw     r3, #0xb9e0
a038cc80 70314ae3 movt     r3, #0xa170
a038cc84 002093e5 ldr      r2, [r3]
a038cc88 003d02e3 movw     r3, #0x2d00
a038cc8c 70314ae3 movt     r3, #0xa170
a038cc90 892082e2 add      r2, r2, #0x89
a038cc94 022193e7 ldr      r2, [r3, r2, lsl #2]
a038cc98 e0390be3 movw     r3, #0xb9e0
a038cc9c 70314ae3 movt     r3, #0xa170
a038cca0 001093e5 ldr      r1, [r3]
a038cca4 003d02e3 movw     r3, #0x2d00
a038cca8 70314ae3 movt     r3, #0xa170
a038ccac 891f81e2 add      r1, r1, #0x224
a038ccb0 013193e7 ldr      r3, [r3, r1, lsl #2]
a038ccb4 024063e0 rsb      r4, r3, r2
a038ccb8 1c3f0ae3 movw     r3, #0xaf1c
a038ccbc 70314ae3 movt     r3, #0xa170
a038ccc0 002093e5 ldr      r2, [r3]
a038ccc4 cb3a07e3 movw     r3, #0x7acb
a038ccc8 75304ae3 movt     r3, #0xa075
a038cccc 0030d3e5 ldrb     r3, [r3]
a038ccd0 0200a0e1 mov      r0, r2
a038ccd4 0310a0e1 mov      r1, r3
a038ccd8 6ce605fa blx      #0xa0506690
a038ccdc 0030a0e1 mov      r3, r0
a038cce0 032084e0 add      r2, r4, r3
a038cce4 503b0ae3 movw     r3, #0xab50
a038cce8 70314ae3 movt     r3, #0xa170
a038ccec 002083e5 str      r2, [r3]
a038ccf0 070200ea b        #0xa038d514
a038ccf4 e0390be3 movw     r3, #0xb9e0
a038ccf8 70314ae3 movt     r3, #0xa170
a038ccfc 003093e5 ldr      r3, [r3]
a038cd00 0320a0e1 mov      r2, r3
a038cd04 0c3f0ae3 movw     r3, #0xaf0c
a038cd08 70314ae3 movt     r3, #0xa170
a038cd0c 003093e5 ldr      r3, [r3]
a038cd10 030052e1 cmp      r2, r3
a038cd14 0d00009a bls      #0xa038cd50
a038cd18 e0390be3 movw     r3, #0xb9e0
a038cd1c 70314ae3 movt     r3, #0xa170
a038cd20 003093e5 ldr      r3, [r3]
a038cd24 0320a0e1 mov      r2, r3
a038cd28 083f0ae3 movw     r3, #0xaf08
a038cd2c 70314ae3 movt     r3, #0xa170
a038cd30 003093e5 ldr      r3, [r3]
a038cd34 030052e1 cmp      r2, r3
a038cd38 0400008a bhi      #0xa038cd50
a038cd3c 503b0ae3 movw     r3, #0xab50
a038cd40 70314ae3 movt     r3, #0xa170
a038cd44 0020a0e3 mov      r2, #0
a038cd48 002083e5 str      r2, [r3]
a038cd4c f00100ea b        #0xa038d514
a038cd50 e0390be3 movw     r3, #0xb9e0
a038cd54 70314ae3 movt     r3, #0xa170
a038cd58 003093e5 ldr      r3, [r3]
a038cd5c 0320a0e1 mov      r2, r3
a038cd60 083f0ae3 movw     r3, #0xaf08
a038cd64 70314ae3 movt     r3, #0xa170
a038cd68 003093e5 ldr      r3, [r3]
a038cd6c 030052e1 cmp      r2, r3
a038cd70 1100002a bhs      #0xa038cdbc
a038cd74 003d02e3 movw     r3, #0x2d00
a038cd78 70314ae3 movt     r3, #0xa170
a038cd7c 102293e5 ldr      r2, [r3, #0x210]
a038cd80 e0390be3 movw     r3, #0xb9e0
a038cd84 70314ae3 movt     r3, #0xa170
a038cd88 003093e5 ldr      r3, [r3]
a038cd8c 033082e0 add      r3, r2, r3
a038cd90 58318de5 str      r3, [sp, #0x158]
a038cd94 58319de5 ldr      r3, [sp, #0x158]
a038cd98 7320efe6 uxtb     r2, r3
a038cd9c 083f0ae3 movw     r3, #0xaf08
a038cda0 70314ae3 movt     r3, #0xa170
a038cda4 003093e5 ldr      r3, [r3]
a038cda8 7330efe6 uxtb     r3, r3
a038cdac 023063e0 rsb      r3, r3, r2
a038cdb0 7330efe6 uxtb     r3, r3
a038cdb4 8b31cde5 strb     r3, [sp, #0x18b]
a038cdb8 0a0000ea b        #0xa038cde8
a038cdbc e0390be3 movw     r3, #0xb9e0
a038cdc0 70314ae3 movt     r3, #0xa170
a038cdc4 003093e5 ldr      r3, [r3]
a038cdc8 7320efe6 uxtb     r2, r3
a038cdcc 083f0ae3 movw     r3, #0xaf08
a038cdd0 70314ae3 movt     r3, #0xa170
a038cdd4 003093e5 ldr      r3, [r3]
a038cdd8 7330efe6 uxtb     r3, r3
a038cddc 023063e0 rsb      r3, r3, r2
a038cde0 7330efe6 uxtb     r3, r3
a038cde4 8b31cde5 strb     r3, [sp, #0x18b]
a038cde8 0030a0e3 mov      r3, #0
a038cdec 80318de5 str      r3, [sp, #0x180]
a038cdf0 270000ea b        #0xa038ce94
a038cdf4 083f0ae3 movw     r3, #0xaf08
a038cdf8 70314ae3 movt     r3, #0xa170
a038cdfc 002093e5 ldr      r2, [r3]
a038ce00 80319de5 ldr      r3, [sp, #0x180]
a038ce04 033082e0 add      r3, r2, r3
a038ce08 013083e2 add      r3, r3, #1
a038ce0c 84318de5 str      r3, [sp, #0x184]
a038ce10 84219de5 ldr      r2, [sp, #0x184]
a038ce14 003d02e3 movw     r3, #0x2d00
a038ce18 70314ae3 movt     r3, #0xa170
a038ce1c 103293e5 ldr      r3, [r3, #0x210]
a038ce20 030052e1 cmp      r2, r3
a038ce24 0500003a blo      #0xa038ce40
a038ce28 84219de5 ldr      r2, [sp, #0x184]
a038ce2c 003d02e3 movw     r3, #0x2d00
a038ce30 70314ae3 movt     r3, #0xa170
a038ce34 103293e5 ldr      r3, [r3, #0x210]
a038ce38 023063e0 rsb      r3, r3, r2
a038ce3c 84318de5 str      r3, [sp, #0x184]
a038ce40 003d02e3 movw     r3, #0x2d00
a038ce44 70314ae3 movt     r3, #0xa170
a038ce48 84219de5 ldr      r2, [sp, #0x184]
a038ce4c 892082e2 add      r2, r2, #0x89
a038ce50 022193e7 ldr      r2, [r3, r2, lsl #2]
a038ce54 003d02e3 movw     r3, #0x2d00
a038ce58 70314ae3 movt     r3, #0xa170
a038ce5c 84119de5 ldr      r1, [sp, #0x184]
a038ce60 891f81e2 add      r1, r1, #0x224
a038ce64 013193e7 ldr      r3, [r3, r1, lsl #2]
a038ce68 022063e0 rsb      r2, r3, r2
a038ce6c 1c3f0ae3 movw     r3, #0xaf1c
a038ce70 70314ae3 movt     r3, #0xa170
a038ce74 003093e5 ldr      r3, [r3]
a038ce78 032082e0 add      r2, r2, r3
a038ce7c 1c3f0ae3 movw     r3, #0xaf1c
a038ce80 70314ae3 movt     r3, #0xa170
a038ce84 002083e5 str      r2, [r3]
a038ce88 80319de5 ldr      r3, [sp, #0x180]
a038ce8c 013083e2 add      r3, r3, #1
a038ce90 80318de5 str      r3, [sp, #0x180]
a038ce94 623f8de2 add      r3, sp, #0x188
a038ce98 033083e2 add      r3, r3, #3
a038ce9c d030d3e1 ldrsb    r3, [r3]
a038cea0 012043e2 sub      r2, r3, #1
a038cea4 80319de5 ldr      r3, [sp, #0x180]
a038cea8 030052e1 cmp      r2, r3
a038ceac d0ffffca bgt      #0xa038cdf4
a038ceb0 e0390be3 movw     r3, #0xb9e0
a038ceb4 70314ae3 movt     r3, #0xa170
a038ceb8 002093e5 ldr      r2, [r3]
a038cebc 003d02e3 movw     r3, #0x2d00
a038cec0 70314ae3 movt     r3, #0xa170
a038cec4 892082e2 add      r2, r2, #0x89
a038cec8 022193e7 ldr      r2, [r3, r2, lsl #2]
a038cecc e0390be3 movw     r3, #0xb9e0
a038ced0 70314ae3 movt     r3, #0xa170
a038ced4 001093e5 ldr      r1, [r3]
a038ced8 003d02e3 movw     r3, #0x2d00
a038cedc 70314ae3 movt     r3, #0xa170
a038cee0 891f81e2 add      r1, r1, #0x224
a038cee4 013193e7 ldr      r3, [r3, r1, lsl #2]
a038cee8 024063e0 rsb      r4, r3, r2
a038ceec 1c3f0ae3 movw     r3, #0xaf1c
a038cef0 70314ae3 movt     r3, #0xa170
a038cef4 002093e5 ldr      r2, [r3]
a038cef8 cb3a07e3 movw     r3, #0x7acb
a038cefc 75304ae3 movt     r3, #0xa075
a038cf00 0030d3e5 ldrb     r3, [r3]
a038cf04 0200a0e1 mov      r0, r2
a038cf08 0310a0e1 mov      r1, r3
a038cf0c dfe505fa blx      #0xa0506690
a038cf10 0030a0e1 mov      r3, r0
a038cf14 032084e0 add      r2, r4, r3
a038cf18 503b0ae3 movw     r3, #0xab50
a038cf1c 70314ae3 movt     r3, #0xa170
a038cf20 002083e5 str      r2, [r3]
a038cf24 7a0100ea b        #0xa038d514
a038cf28 d5390be3 movw     r3, #0xb9d5
a038cf2c 70314ae3 movt     r3, #0xa170
a038cf30 0020d3e5 ldrb     r2, [r3]
a038cf34 cb3a07e3 movw     r3, #0x7acb
a038cf38 75304ae3 movt     r3, #0xa075
a038cf3c 0030d3e5 ldrb     r3, [r3]
a038cf40 030052e1 cmp      r2, r3
a038cf44 c400002a bhs      #0xa038d25c
a038cf48 d5390be3 movw     r3, #0xb9d5
a038cf4c 70314ae3 movt     r3, #0xa170
a038cf50 0030d3e5 ldrb     r3, [r3]
a038cf54 0320a0e1 mov      r2, r3
a038cf58 283f0ae3 movw     r3, #0xaf28
a038cf5c 70314ae3 movt     r3, #0xa170
a038cf60 0030d3e5 ldrb     r3, [r3]
a038cf64 7330afe6 sxtb     r3, r3
a038cf68 030052e1 cmp      r2, r3
a038cf6c 300000ba blt      #0xa038d034
a038cf70 e0390be3 movw     r3, #0xb9e0
a038cf74 70314ae3 movt     r3, #0xa170
a038cf78 002093e5 ldr      r2, [r3]
a038cf7c 283f0ae3 movw     r3, #0xaf28
a038cf80 70314ae3 movt     r3, #0xa170
a038cf84 0030d3e5 ldrb     r3, [r3]
a038cf88 7330afe6 sxtb     r3, r3
a038cf8c 023063e0 rsb      r3, r3, r2
a038cf90 7c318de5 str      r3, [sp, #0x17c]
a038cf94 7c319de5 ldr      r3, [sp, #0x17c]
a038cf98 000053e3 cmp      r3, #0
a038cf9c 050000aa bge      #0xa038cfb8
a038cfa0 003d02e3 movw     r3, #0x2d00
a038cfa4 70314ae3 movt     r3, #0xa170
a038cfa8 102293e5 ldr      r2, [r3, #0x210]
a038cfac 7c319de5 ldr      r3, [sp, #0x17c]
a038cfb0 033082e0 add      r3, r2, r3
a038cfb4 7c318de5 str      r3, [sp, #0x17c]
a038cfb8 e0390be3 movw     r3, #0xb9e0
a038cfbc 70314ae3 movt     r3, #0xa170
a038cfc0 002093e5 ldr      r2, [r3]
a038cfc4 003d02e3 movw     r3, #0x2d00
a038cfc8 70314ae3 movt     r3, #0xa170
a038cfcc 892082e2 add      r2, r2, #0x89
a038cfd0 022193e7 ldr      r2, [r3, r2, lsl #2]
a038cfd4 e0390be3 movw     r3, #0xb9e0
a038cfd8 70314ae3 movt     r3, #0xa170
a038cfdc 001093e5 ldr      r1, [r3]
a038cfe0 003d02e3 movw     r3, #0x2d00
a038cfe4 70314ae3 movt     r3, #0xa170
a038cfe8 891f81e2 add      r1, r1, #0x224
a038cfec 013193e7 ldr      r3, [r3, r1, lsl #2]
a038cff0 022063e0 rsb      r2, r3, r2
a038cff4 003d02e3 movw     r3, #0x2d00
a038cff8 70314ae3 movt     r3, #0xa170
a038cffc 7c119de5 ldr      r1, [sp, #0x17c]
a038d000 891f81e2 add      r1, r1, #0x224
a038d004 011193e7 ldr      r1, [r3, r1, lsl #2]
a038d008 003d02e3 movw     r3, #0x2d00
a038d00c 70314ae3 movt     r3, #0xa170
a038d010 7c019de5 ldr      r0, [sp, #0x17c]
a038d014 890080e2 add      r0, r0, #0x89
a038d018 003193e7 ldr      r3, [r3, r0, lsl #2]
a038d01c 013063e0 rsb      r3, r3, r1
a038d020 032082e0 add      r2, r2, r3
a038d024 243f0ae3 movw     r3, #0xaf24
a038d028 70314ae3 movt     r3, #0xa170
a038d02c 002083e5 str      r2, [r3]
a038d030 030000ea b        #0xa038d044
a038d034 243f0ae3 movw     r3, #0xaf24
a038d038 70314ae3 movt     r3, #0xa170
a038d03c 0020a0e3 mov      r2, #0
a038d040 002083e5 str      r2, [r3]
a038d044 083f0ae3 movw     r3, #0xaf08
a038d048 70314ae3 movt     r3, #0xa170
a038d04c 002093e5 ldr      r2, [r3]
a038d050 0c3f0ae3 movw     r3, #0xaf0c
a038d054 70314ae3 movt     r3, #0xa170
a038d058 003093e5 ldr      r3, [r3]
a038d05c 030052e1 cmp      r2, r3
a038d060 3e00002a bhs      #0xa038d160
a038d064 e0390be3 movw     r3, #0xb9e0
a038d068 70314ae3 movt     r3, #0xa170
a038d06c 003093e5 ldr      r3, [r3]
a038d070 0320a0e1 mov      r2, r3
a038d074 0c3f0ae3 movw     r3, #0xaf0c
a038d078 70314ae3 movt     r3, #0xa170
a038d07c 003093e5 ldr      r3, [r3]
a038d080 030052e1 cmp      r2, r3
a038d084 0800008a bhi      #0xa038d0ac
a038d088 e0390be3 movw     r3, #0xb9e0
a038d08c 70314ae3 movt     r3, #0xa170
a038d090 003093e5 ldr      r3, [r3]
a038d094 0320a0e1 mov      r2, r3
a038d098 083f0ae3 movw     r3, #0xaf08
a038d09c 70314ae3 movt     r3, #0xa170
a038d0a0 003093e5 ldr      r3, [r3]
a038d0a4 030052e1 cmp      r2, r3
a038d0a8 0400008a bhi      #0xa038d0c0
a038d0ac 503b0ae3 movw     r3, #0xab50
a038d0b0 70314ae3 movt     r3, #0xa170
a038d0b4 0020a0e3 mov      r2, #0
a038d0b8 002083e5 str      r2, [r3]
a038d0bc 140100ea b        #0xa038d514
a038d0c0 e0390be3 movw     r3, #0xb9e0
a038d0c4 70314ae3 movt     r3, #0xa170
a038d0c8 002093e5 ldr      r2, [r3]
a038d0cc 003d02e3 movw     r3, #0x2d00
a038d0d0 70314ae3 movt     r3, #0xa170
a038d0d4 892082e2 add      r2, r2, #0x89
a038d0d8 022193e7 ldr      r2, [r3, r2, lsl #2]
a038d0dc e0390be3 movw     r3, #0xb9e0
a038d0e0 70314ae3 movt     r3, #0xa170
a038d0e4 001093e5 ldr      r1, [r3]
a038d0e8 003d02e3 movw     r3, #0x2d00
a038d0ec 70314ae3 movt     r3, #0xa170
a038d0f0 891f81e2 add      r1, r1, #0x224
a038d0f4 013193e7 ldr      r3, [r3, r1, lsl #2]
a038d0f8 024063e0 rsb      r4, r3, r2
a038d0fc 1c3f0ae3 movw     r3, #0xaf1c
a038d100 70314ae3 movt     r3, #0xa170
a038d104 002093e5 ldr      r2, [r3]
a038d108 cb3a07e3 movw     r3, #0x7acb
a038d10c 75304ae3 movt     r3, #0xa075
a038d110 0030d3e5 ldrb     r3, [r3]
a038d114 0200a0e1 mov      r0, r2
a038d118 0310a0e1 mov      r1, r3
a038d11c 5be505fa blx      #0xa0506690
a038d120 0030a0e1 mov      r3, r0
a038d124 032084e0 add      r2, r4, r3
a038d128 503b0ae3 movw     r3, #0xab50
a038d12c 70314ae3 movt     r3, #0xa170
a038d130 002083e5 str      r2, [r3]
a038d134 503b0ae3 movw     r3, #0xab50
a038d138 70314ae3 movt     r3, #0xa170
a038d13c 002093e5 ldr      r2, [r3]
a038d140 243f0ae3 movw     r3, #0xaf24
a038d144 70314ae3 movt     r3, #0xa170
a038d148 003093e5 ldr      r3, [r3]
a038d14c 032082e0 add      r2, r2, r3
a038d150 503b0ae3 movw     r3, #0xab50
a038d154 70314ae3 movt     r3, #0xa170
a038d158 002083e5 str      r2, [r3]
a038d15c ec0000ea b        #0xa038d514
a038d160 e0390be3 movw     r3, #0xb9e0
a038d164 70314ae3 movt     r3, #0xa170
a038d168 003093e5 ldr      r3, [r3]
a038d16c 0320a0e1 mov      r2, r3
a038d170 0c3f0ae3 movw     r3, #0xaf0c
a038d174 70314ae3 movt     r3, #0xa170
a038d178 003093e5 ldr      r3, [r3]
a038d17c 030052e1 cmp      r2, r3
a038d180 0d00009a bls      #0xa038d1bc
a038d184 e0390be3 movw     r3, #0xb9e0
a038d188 70314ae3 movt     r3, #0xa170
a038d18c 003093e5 ldr      r3, [r3]
a038d190 0320a0e1 mov      r2, r3
a038d194 083f0ae3 movw     r3, #0xaf08
a038d198 70314ae3 movt     r3, #0xa170
a038d19c 003093e5 ldr      r3, [r3]
a038d1a0 030052e1 cmp      r2, r3
a038d1a4 0400008a bhi      #0xa038d1bc
a038d1a8 503b0ae3 movw     r3, #0xab50
a038d1ac 70314ae3 movt     r3, #0xa170
a038d1b0 0020a0e3 mov      r2, #0
a038d1b4 002083e5 str      r2, [r3]
a038d1b8 d50000ea b        #0xa038d514
a038d1bc e0390be3 movw     r3, #0xb9e0
a038d1c0 70314ae3 movt     r3, #0xa170
a038d1c4 002093e5 ldr      r2, [r3]
a038d1c8 003d02e3 movw     r3, #0x2d00
a038d1cc 70314ae3 movt     r3, #0xa170
a038d1d0 892082e2 add      r2, r2, #0x89
a038d1d4 022193e7 ldr      r2, [r3, r2, lsl #2]
a038d1d8 e0390be3 movw     r3, #0xb9e0
a038d1dc 70314ae3 movt     r3, #0xa170
a038d1e0 001093e5 ldr      r1, [r3]
a038d1e4 003d02e3 movw     r3, #0x2d00
a038d1e8 70314ae3 movt     r3, #0xa170
a038d1ec 891f81e2 add      r1, r1, #0x224
a038d1f0 013193e7 ldr      r3, [r3, r1, lsl #2]
a038d1f4 024063e0 rsb      r4, r3, r2
a038d1f8 1c3f0ae3 movw     r3, #0xaf1c
a038d1fc 70314ae3 movt     r3, #0xa170
a038d200 002093e5 ldr      r2, [r3]
a038d204 cb3a07e3 movw     r3, #0x7acb
a038d208 75304ae3 movt     r3, #0xa075
a038d20c 0030d3e5 ldrb     r3, [r3]
a038d210 0200a0e1 mov      r0, r2
a038d214 0310a0e1 mov      r1, r3
a038d218 1ce505fa blx      #0xa0506690
a038d21c 0030a0e1 mov      r3, r0
a038d220 032084e0 add      r2, r4, r3
a038d224 503b0ae3 movw     r3, #0xab50
a038d228 70314ae3 movt     r3, #0xa170
a038d22c 002083e5 str      r2, [r3]
a038d230 503b0ae3 movw     r3, #0xab50
a038d234 70314ae3 movt     r3, #0xa170
a038d238 002093e5 ldr      r2, [r3]
a038d23c 243f0ae3 movw     r3, #0xaf24
a038d240 70314ae3 movt     r3, #0xa170
a038d244 003093e5 ldr      r3, [r3]
a038d248 032082e0 add      r2, r2, r3
a038d24c 503b0ae3 movw     r3, #0xab50
a038d250 70314ae3 movt     r3, #0xa170
a038d254 002083e5 str      r2, [r3]
a038d258 ad0000ea b        #0xa038d514
a038d25c d5390be3 movw     r3, #0xb9d5
a038d260 70314ae3 movt     r3, #0xa170
a038d264 0030d3e5 ldrb     r3, [r3]
a038d268 0320a0e1 mov      r2, r3
a038d26c 283f0ae3 movw     r3, #0xaf28
a038d270 70314ae3 movt     r3, #0xa170
a038d274 0030d3e5 ldrb     r3, [r3]
a038d278 7330afe6 sxtb     r3, r3
a038d27c 030052e1 cmp      r2, r3
a038d280 300000ba blt      #0xa038d348
a038d284 e0390be3 movw     r3, #0xb9e0
a038d288 70314ae3 movt     r3, #0xa170
a038d28c 002093e5 ldr      r2, [r3]
a038d290 283f0ae3 movw     r3, #0xaf28
a038d294 70314ae3 movt     r3, #0xa170
a038d298 0030d3e5 ldrb     r3, [r3]
a038d29c 7330afe6 sxtb     r3, r3
a038d2a0 023063e0 rsb      r3, r3, r2
a038d2a4 7c318de5 str      r3, [sp, #0x17c]
a038d2a8 7c319de5 ldr      r3, [sp, #0x17c]
a038d2ac 000053e3 cmp      r3, #0
a038d2b0 050000aa bge      #0xa038d2cc
a038d2b4 003d02e3 movw     r3, #0x2d00
a038d2b8 70314ae3 movt     r3, #0xa170
a038d2bc 102293e5 ldr      r2, [r3, #0x210]
a038d2c0 7c319de5 ldr      r3, [sp, #0x17c]
a038d2c4 033082e0 add      r3, r2, r3
a038d2c8 7c318de5 str      r3, [sp, #0x17c]
a038d2cc e0390be3 movw     r3, #0xb9e0
a038d2d0 70314ae3 movt     r3, #0xa170
a038d2d4 002093e5 ldr      r2, [r3]
a038d2d8 003d02e3 movw     r3, #0x2d00
a038d2dc 70314ae3 movt     r3, #0xa170
a038d2e0 892082e2 add      r2, r2, #0x89
a038d2e4 022193e7 ldr      r2, [r3, r2, lsl #2]
a038d2e8 e0390be3 movw     r3, #0xb9e0
a038d2ec 70314ae3 movt     r3, #0xa170
a038d2f0 001093e5 ldr      r1, [r3]
a038d2f4 003d02e3 movw     r3, #0x2d00
a038d2f8 70314ae3 movt     r3, #0xa170
a038d2fc 891f81e2 add      r1, r1, #0x224
a038d300 013193e7 ldr      r3, [r3, r1, lsl #2]
a038d304 022063e0 rsb      r2, r3, r2
a038d308 003d02e3 movw     r3, #0x2d00
a038d30c 70314ae3 movt     r3, #0xa170
a038d310 7c119de5 ldr      r1, [sp, #0x17c]
a038d314 891f81e2 add      r1, r1, #0x224
a038d318 011193e7 ldr      r1, [r3, r1, lsl #2]
a038d31c 003d02e3 movw     r3, #0x2d00
a038d320 70314ae3 movt     r3, #0xa170
a038d324 7c019de5 ldr      r0, [sp, #0x17c]
a038d328 890080e2 add      r0, r0, #0x89
a038d32c 003193e7 ldr      r3, [r3, r0, lsl #2]
a038d330 013063e0 rsb      r3, r3, r1
a038d334 032082e0 add      r2, r2, r3
a038d338 243f0ae3 movw     r3, #0xaf24
a038d33c 70314ae3 movt     r3, #0xa170
a038d340 002083e5 str      r2, [r3]
a038d344 030000ea b        #0xa038d358
a038d348 243f0ae3 movw     r3, #0xaf24
a038d34c 70314ae3 movt     r3, #0xa170
a038d350 0020a0e3 mov      r2, #0
a038d354 002083e5 str      r2, [r3]
a038d358 083f0ae3 movw     r3, #0xaf08
a038d35c 70314ae3 movt     r3, #0xa170
a038d360 002093e5 ldr      r2, [r3]
a038d364 0c3f0ae3 movw     r3, #0xaf0c
a038d368 70314ae3 movt     r3, #0xa170
a038d36c 003093e5 ldr      r3, [r3]
a038d370 030052e1 cmp      r2, r3
a038d374 3300002a bhs      #0xa038d448
a038d378 e0390be3 movw     r3, #0xb9e0
a038d37c 70314ae3 movt     r3, #0xa170
a038d380 003093e5 ldr      r3, [r3]
a038d384 0320a0e1 mov      r2, r3
a038d388 0c3f0ae3 movw     r3, #0xaf0c
a038d38c 70314ae3 movt     r3, #0xa170
a038d390 003093e5 ldr      r3, [r3]
a038d394 030052e1 cmp      r2, r3
a038d398 0800008a bhi      #0xa038d3c0
a038d39c e0390be3 movw     r3, #0xb9e0
a038d3a0 70314ae3 movt     r3, #0xa170
a038d3a4 003093e5 ldr      r3, [r3]
a038d3a8 0320a0e1 mov      r2, r3
a038d3ac 083f0ae3 movw     r3, #0xaf08
a038d3b0 70314ae3 movt     r3, #0xa170
a038d3b4 003093e5 ldr      r3, [r3]
a038d3b8 030052e1 cmp      r2, r3
a038d3bc 0400008a bhi      #0xa038d3d4
a038d3c0 503b0ae3 movw     r3, #0xab50
a038d3c4 70314ae3 movt     r3, #0xa170
a038d3c8 0020a0e3 mov      r2, #0
a038d3cc 002083e5 str      r2, [r3]
a038d3d0 4f0000ea b        #0xa038d514
a038d3d4 e0390be3 movw     r3, #0xb9e0
a038d3d8 70314ae3 movt     r3, #0xa170
a038d3dc 002093e5 ldr      r2, [r3]
a038d3e0 003d02e3 movw     r3, #0x2d00
a038d3e4 70314ae3 movt     r3, #0xa170
a038d3e8 892082e2 add      r2, r2, #0x89
a038d3ec 022193e7 ldr      r2, [r3, r2, lsl #2]
a038d3f0 e0390be3 movw     r3, #0xb9e0
a038d3f4 70314ae3 movt     r3, #0xa170
a038d3f8 001093e5 ldr      r1, [r3]
a038d3fc 003d02e3 movw     r3, #0x2d00
a038d400 70314ae3 movt     r3, #0xa170
a038d404 891f81e2 add      r1, r1, #0x224
a038d408 013193e7 ldr      r3, [r3, r1, lsl #2]
a038d40c 022063e0 rsb      r2, r3, r2
a038d410 503b0ae3 movw     r3, #0xab50
a038d414 70314ae3 movt     r3, #0xa170
a038d418 002083e5 str      r2, [r3]
a038d41c 503b0ae3 movw     r3, #0xab50
a038d420 70314ae3 movt     r3, #0xa170
a038d424 002093e5 ldr      r2, [r3]
a038d428 243f0ae3 movw     r3, #0xaf24
a038d42c 70314ae3 movt     r3, #0xa170
a038d430 003093e5 ldr      r3, [r3]
a038d434 032082e0 add      r2, r2, r3
a038d438 503b0ae3 movw     r3, #0xab50
a038d43c 70314ae3 movt     r3, #0xa170
a038d440 002083e5 str      r2, [r3]
a038d444 320000ea b        #0xa038d514
a038d448 e0390be3 movw     r3, #0xb9e0
a038d44c 70314ae3 movt     r3, #0xa170
a038d450 003093e5 ldr      r3, [r3]
a038d454 0320a0e1 mov      r2, r3
a038d458 0c3f0ae3 movw     r3, #0xaf0c
a038d45c 70314ae3 movt     r3, #0xa170
a038d460 003093e5 ldr      r3, [r3]
a038d464 030052e1 cmp      r2, r3
a038d468 0d00009a bls      #0xa038d4a4
a038d46c e0390be3 movw     r3, #0xb9e0
a038d470 70314ae3 movt     r3, #0xa170
a038d474 003093e5 ldr      r3, [r3]
a038d478 0320a0e1 mov      r2, r3
a038d47c 083f0ae3 movw     r3, #0xaf08
a038d480 70314ae3 movt     r3, #0xa170
a038d484 003093e5 ldr      r3, [r3]
a038d488 030052e1 cmp      r2, r3
a038d48c 0400008a bhi      #0xa038d4a4
a038d490 503b0ae3 movw     r3, #0xab50
a038d494 70314ae3 movt     r3, #0xa170
a038d498 0020a0e3 mov      r2, #0
a038d49c 002083e5 str      r2, [r3]
a038d4a0 1b0000ea b        #0xa038d514
a038d4a4 e0390be3 movw     r3, #0xb9e0
a038d4a8 70314ae3 movt     r3, #0xa170
a038d4ac 002093e5 ldr      r2, [r3]
a038d4b0 003d02e3 movw     r3, #0x2d00
a038d4b4 70314ae3 movt     r3, #0xa170
a038d4b8 892082e2 add      r2, r2, #0x89
a038d4bc 022193e7 ldr      r2, [r3, r2, lsl #2]
a038d4c0 e0390be3 movw     r3, #0xb9e0
a038d4c4 70314ae3 movt     r3, #0xa170
a038d4c8 001093e5 ldr      r1, [r3]
a038d4cc 003d02e3 movw     r3, #0x2d00
a038d4d0 70314ae3 movt     r3, #0xa170
a038d4d4 891f81e2 add      r1, r1, #0x224
a038d4d8 013193e7 ldr      r3, [r3, r1, lsl #2]
a038d4dc 022063e0 rsb      r2, r3, r2
a038d4e0 503b0ae3 movw     r3, #0xab50
a038d4e4 70314ae3 movt     r3, #0xa170
a038d4e8 002083e5 str      r2, [r3]
a038d4ec 503b0ae3 movw     r3, #0xab50
a038d4f0 70314ae3 movt     r3, #0xa170
a038d4f4 002093e5 ldr      r2, [r3]
a038d4f8 243f0ae3 movw     r3, #0xaf24
a038d4fc 70314ae3 movt     r3, #0xa170
a038d500 003093e5 ldr      r3, [r3]
a038d504 032082e0 add      r2, r2, r3
a038d508 503b0ae3 movw     r3, #0xab50
a038d50c 70314ae3 movt     r3, #0xa170
a038d510 002083e5 str      r2, [r3]
a038d514 503b0ae3 movw     r3, #0xab50
a038d518 70314ae3 movt     r3, #0xa170
a038d51c 002093e5 ldr      r2, [r3]
a038d520 143f0ae3 movw     r3, #0xaf14
a038d524 70314ae3 movt     r3, #0xa170
a038d528 002083e5 str      r2, [r3]
a038d52c d5390be3 movw     r3, #0xb9d5
a038d530 70314ae3 movt     r3, #0xa170
a038d534 0030d3e5 ldrb     r3, [r3]
a038d538 013083e2 add      r3, r3, #1
a038d53c 7320efe6 uxtb     r2, r3
a038d540 d5390be3 movw     r3, #0xb9d5
a038d544 70314ae3 movt     r3, #0xa170
a038d548 0020c3e5 strb     r2, [r3]
a038d54c 483b0ae3 movw     r3, #0xab48
a038d550 70314ae3 movt     r3, #0xa170
a038d554 003093e5 ldr      r3, [r3]
a038d558 000053e3 cmp      r3, #0
a038d55c 4800000a beq      #0xa038d684
a038d560 143a0be3 movw     r3, #0xba14
a038d564 70314ae3 movt     r3, #0xa170
a038d568 003093e5 ldr      r3, [r3]
a038d56c 000053e3 cmp      r3, #0
a038d570 4300000a beq      #0xa038d684
a038d574 e8390be3 movw     r3, #0xb9e8
a038d578 70314ae3 movt     r3, #0xa170
a038d57c 0120a0e3 mov      r2, #1
a038d580 0020c3e5 strb     r2, [r3]
a038d584 503b0ae3 movw     r3, #0xab50
a038d588 70314ae3 movt     r3, #0xa170
a038d58c 003093e5 ldr      r3, [r3]
a038d590 000053e3 cmp      r3, #0
a038d594 030000aa bge      #0xa038d5a8
a038d598 e8390be3 movw     r3, #0xb9e8
a038d59c 70314ae3 movt     r3, #0xa170
a038d5a0 0020e0e3 mvn      r2, #0
a038d5a4 0020c3e5 strb     r2, [r3]
a038d5a8 483b0ae3 movw     r3, #0xab48
a038d5ac 70314ae3 movt     r3, #0xa170
a038d5b0 003093e5 ldr      r3, [r3]
a038d5b4 c32f23e0 eor      r2, r3, r3, asr #31
a038d5b8 c32f42e0 sub      r2, r2, r3, asr #31
a038d5bc ec390be3 movw     r3, #0xb9ec
a038d5c0 70314ae3 movt     r3, #0xa170
a038d5c4 042083e5 str      r2, [r3, #4]
a038d5c8 ec390be3 movw     r3, #0xb9ec
a038d5cc 70314ae3 movt     r3, #0xa170
a038d5d0 043093e5 ldr      r3, [r3, #4]
a038d5d4 0300a0e1 mov      r0, r3
a038d5d8 c01fa0e1 asr      r1, r0, #0x1f
a038d5dc 503b0ae3 movw     r3, #0xab50
a038d5e0 70314ae3 movt     r3, #0xa170
a038d5e4 003093e5 ldr      r3, [r3]
a038d5e8 000053e3 cmp      r3, #0
a038d5ec 003063b2 rsblt    r3, r3, #0
a038d5f0 0320a0e1 mov      r2, r3
a038d5f4 c23fa0e1 asr      r3, r2, #0x1f
a038d5f8 92010ee0 mul      lr, r2, r1
a038d5fc 90030ce0 mul      ip, r0, r3
a038d600 0cc08ee0 add      ip, lr, ip
a038d604 902283e0 umull    r2, r3, r0, r2
a038d608 03108ce0 add      r1, ip, r3
a038d60c 0130a0e1 mov      r3, r1
a038d610 141a0be3 movw     r1, #0xba14
a038d614 70114ae3 movt     r1, #0xa170
a038d618 001091e5 ldr      r1, [r1]
a038d61c 000051e3 cmp      r1, #0
a038d620 001061b2 rsblt    r1, r1, #0
a038d624 0140a0e1 mov      r4, r1
a038d628 c45fa0e1 asr      r5, r4, #0x1f
a038d62c 0200a0e1 mov      r0, r2
a038d630 0310a0e1 mov      r1, r3
a038d634 0420a0e1 mov      r2, r4
a038d638 0530a0e1 mov      r3, r5
a038d63c 3de605fa blx      #0xa0506f38
a038d640 0020a0e1 mov      r2, r0
a038d644 0130a0e1 mov      r3, r1
a038d648 ec390be3 movw     r3, #0xb9ec
a038d64c 70314ae3 movt     r3, #0xa170
a038d650 042083e5 str      r2, [r3, #4]
a038d654 ec390be3 movw     r3, #0xb9ec
a038d658 70314ae3 movt     r3, #0xa170
a038d65c 042093e5 ldr      r2, [r3, #4]
a038d660 e8390be3 movw     r3, #0xb9e8
a038d664 70314ae3 movt     r3, #0xa170
a038d668 0030d3e5 ldrb     r3, [r3]
a038d66c 7330afe6 sxtb     r3, r3
a038d670 930202e0 mul      r2, r3, r2
a038d674 ec390be3 movw     r3, #0xb9ec
a038d678 70314ae3 movt     r3, #0xa170
a038d67c 042083e5 str      r2, [r3, #4]
a038d680 190000ea b        #0xa038d6ec
a038d684 503b0ae3 movw     r3, #0xab50
a038d688 70314ae3 movt     r3, #0xa170
a038d68c 002093e5 ldr      r2, [r3]
a038d690 243b0ae3 movw     r3, #0xab24
a038d694 70314ae3 movt     r3, #0xa170
a038d698 003093e5 ldr      r3, [r3]
a038d69c 0100a0e3 mov      r0, #1
a038d6a0 0210a0e1 mov      r1, r2
a038d6a4 0320a0e1 mov      r2, r3
a038d6a8 8ab9ffeb bl       #0xa037bcd8
a038d6ac 0020a0e1 mov      r2, r0
a038d6b0 ec390be3 movw     r3, #0xb9ec
a038d6b4 70314ae3 movt     r3, #0xa170
a038d6b8 042083e5 str      r2, [r3, #4]
a038d6bc ec390be3 movw     r3, #0xb9ec
a038d6c0 70314ae3 movt     r3, #0xa170
a038d6c4 042093e5 ldr      r2, [r3, #4]
a038d6c8 483b0ae3 movw     r3, #0xab48
a038d6cc 70314ae3 movt     r3, #0xa170
a038d6d0 002083e5 str      r2, [r3]
a038d6d4 503b0ae3 movw     r3, #0xab50
a038d6d8 70314ae3 movt     r3, #0xa170
a038d6dc 002093e5 ldr      r2, [r3]
a038d6e0 143a0be3 movw     r3, #0xba14
a038d6e4 70314ae3 movt     r3, #0xa170
a038d6e8 002083e5 str      r2, [r3]
a038d6ec ec390be3 movw     r3, #0xb9ec
a038d6f0 70314ae3 movt     r3, #0xa170
a038d6f4 042093e5 ldr      r2, [r3, #4]
a038d6f8 873a07e3 movw     r3, #0x7a87
a038d6fc 75304ae3 movt     r3, #0xa075
a038d700 0030d3e5 ldrb     r3, [r3]
a038d704 7330afe6 sxtb     r3, r3
a038d708 930201e0 mul      r1, r3, r2
a038d70c 1f3508e3 movw     r3, #0x851f
a038d710 eb3145e3 movt     r3, #0x51eb
a038d714 9123c3e0 smull    r2, r3, r1, r3
a038d718 c322a0e1 asr      r2, r3, #5
a038d71c c13fa0e1 asr      r3, r1, #0x1f
a038d720 022063e0 rsb      r2, r3, r2
a038d724 ec390be3 movw     r3, #0xb9ec
a038d728 70314ae3 movt     r3, #0xa170
a038d72c 042083e5 str      r2, [r3, #4]
a038d730 ec390be3 movw     r3, #0xb9ec
a038d734 70314ae3 movt     r3, #0xa170
a038d738 042093e5 ldr      r2, [r3, #4]
a038d73c 643204e3 movw     r3, #0x4264
a038d740 70314ae3 movt     r3, #0xa170
a038d744 003093e5 ldr      r3, [r3]
a038d748 930202e0 mul      r2, r3, r2
a038d74c 283104e3 movw     r3, #0x4128
a038d750 70314ae3 movt     r3, #0xa170
a038d754 0c3093e5 ldr      r3, [r3, #0xc]
a038d758 0200a0e1 mov      r0, r2
a038d75c 0310a0e1 mov      r1, r3
a038d760 cae305fa blx      #0xa0506690
a038d764 0030a0e1 mov      r3, r0
a038d768 0320a0e1 mov      r2, r3
a038d76c f4390be3 movw     r3, #0xb9f4
a038d770 70314ae3 movt     r3, #0xa170
a038d774 042083e5 str      r2, [r3, #4]
a038d778 f4390be3 movw     r3, #0xb9f4
a038d77c 70314ae3 movt     r3, #0xa170
a038d780 042093e5 ldr      r2, [r3, #4]
a038d784 c03204e3 movw     r3, #0x42c0
a038d788 70314ae3 movt     r3, #0xa170
a038d78c 043093e5 ldr      r3, [r3, #4]
a038d790 030052e1 cmp      r2, r3
a038d794 060000da ble      #0xa038d7b4
a038d798 c03204e3 movw     r3, #0x42c0
a038d79c 70314ae3 movt     r3, #0xa170
a038d7a0 042093e5 ldr      r2, [r3, #4]
a038d7a4 f4390be3 movw     r3, #0xb9f4
a038d7a8 70314ae3 movt     r3, #0xa170
a038d7ac 042083e5 str      r2, [r3, #4]
a038d7b0 0f0000ea b        #0xa038d7f4
a038d7b4 f4390be3 movw     r3, #0xb9f4
a038d7b8 70314ae3 movt     r3, #0xa170
a038d7bc 042093e5 ldr      r2, [r3, #4]
a038d7c0 c83204e3 movw     r3, #0x42c8
a038d7c4 70314ae3 movt     r3, #0xa170
a038d7c8 043093e5 ldr      r3, [r3, #4]
a038d7cc 003063e2 rsb      r3, r3, #0
a038d7d0 030052e1 cmp      r2, r3
a038d7d4 060000aa bge      #0xa038d7f4
a038d7d8 c83204e3 movw     r3, #0x42c8
a038d7dc 70314ae3 movt     r3, #0xa170
a038d7e0 043093e5 ldr      r3, [r3, #4]
a038d7e4 002063e2 rsb      r2, r3, #0
a038d7e8 f4390be3 movw     r3, #0xb9f4
a038d7ec 70314ae3 movt     r3, #0xa170
a038d7f0 042083e5 str      r2, [r3, #4]
a038d7f4 273204e3 movw     r3, #0x4227
a038d7f8 70314ae3 movt     r3, #0xa170
a038d7fc 0030d3e5 ldrb     r3, [r3]
a038d800 ff0053e3 cmp      r3, #0xff
a038d804 0e00001a bne      #0xa038d844
a038d808 f4390be3 movw     r3, #0xb9f4
a038d80c 70314ae3 movt     r3, #0xa170
a038d810 042093e5 ldr      r2, [r3, #4]
a038d814 253204e3 movw     r3, #0x4225
a038d818 70314ae3 movt     r3, #0xa170
a038d81c 0030d3e5 ldrb     r3, [r3]
a038d820 0200a0e1 mov      r0, r2
a038d824 0310a0e1 mov      r1, r3
a038d828 98e305fa blx      #0xa0506690
a038d82c 0030a0e1 mov      r3, r0
a038d830 0320a0e1 mov      r2, r3
a038d834 f4390be3 movw     r3, #0xb9f4
a038d838 70314ae3 movt     r3, #0xa170
a038d83c 042083e5 str      r2, [r3, #4]
a038d840 090000ea b        #0xa038d86c
a038d844 f4390be3 movw     r3, #0xb9f4
a038d848 70314ae3 movt     r3, #0xa170
a038d84c 042093e5 ldr      r2, [r3, #4]
a038d850 273204e3 movw     r3, #0x4227
a038d854 70314ae3 movt     r3, #0xa170
a038d858 0030d3e5 ldrb     r3, [r3]
a038d85c 5223a0e1 asr      r2, r2, r3
a038d860 f4390be3 movw     r3, #0xb9f4
a038d864 70314ae3 movt     r3, #0xa170
a038d868 042083e5 str      r2, [r3, #4]
a038d86c f4390be3 movw     r3, #0xb9f4
a038d870 70314ae3 movt     r3, #0xa170
a038d874 043093e5 ldr      r3, [r3, #4]
a038d878 0324a0e1 lsl      r2, r3, #8
a038d87c 643204e3 movw     r3, #0x4264
a038d880 70314ae3 movt     r3, #0xa170
a038d884 003093e5 ldr      r3, [r3]
a038d888 0200a0e1 mov      r0, r2
a038d88c 0310a0e1 mov      r1, r3
a038d890 7ee305fa blx      #0xa0506690
a038d894 0030a0e1 mov      r3, r0
a038d898 0320a0e1 mov      r2, r3
a038d89c f4390be3 movw     r3, #0xb9f4
a038d8a0 70314ae3 movt     r3, #0xa170
a038d8a4 042083e5 str      r2, [r3, #4]
a038d8a8 c03c02e3 movw     r3, #0x2cc0
a038d8ac 70314ae3 movt     r3, #0xa170
a038d8b0 0c30d3e5 ldrb     r3, [r3, #0xc]
a038d8b4 7330afe6 sxtb     r3, r3
a038d8b8 010073e3 cmn      r3, #1
a038d8bc 0600001a bne      #0xa038d8dc
a038d8c0 f4390be3 movw     r3, #0xb9f4
a038d8c4 70314ae3 movt     r3, #0xa170
a038d8c8 043093e5 ldr      r3, [r3, #4]
a038d8cc 002063e2 rsb      r2, r3, #0
a038d8d0 f4390be3 movw     r3, #0xb9f4
a038d8d4 70314ae3 movt     r3, #0xa170
a038d8d8 042083e5 str      r2, [r3, #4]
a038d8dc b43c02e3 movw     r3, #0x2cb4
a038d8e0 70314ae3 movt     r3, #0xa170
a038d8e4 003093e5 ldr      r3, [r3]
a038d8e8 000053e3 cmp      r3, #0
a038d8ec 0900001a bne      #0xa038d918
a038d8f0 b93c02e3 movw     r3, #0x2cb9
a038d8f4 70314ae3 movt     r3, #0xa170
a038d8f8 0030d3e5 ldrb     r3, [r3]
a038d8fc 000053e3 cmp      r3, #0
a038d900 0400001a bne      #0xa038d918
a038d904 bb3c02e3 movw     r3, #0x2cbb
a038d908 70314ae3 movt     r3, #0xa170
a038d90c 0030d3e5 ldrb     r3, [r3]
a038d910 000053e3 cmp      r3, #0
a038d914 0600000a beq      #0xa038d934
a038d918 f4390be3 movw     r3, #0xb9f4
a038d91c 70314ae3 movt     r3, #0xa170
a038d920 043093e5 ldr      r3, [r3, #4]
a038d924 002063e2 rsb      r2, r3, #0
a038d928 f4390be3 movw     r3, #0xb9f4
a038d92c 70314ae3 movt     r3, #0xa170
a038d930 042083e5 str      r2, [r3, #4]
a038d934 7c330be3 movw     r3, #0xb37c
a038d938 70314ae3 movt     r3, #0xa170
a038d93c 003093e5 ldr      r3, [r3]
a038d940 000053e3 cmp      r3, #0
a038d944 0130a003 moveq    r3, #1
a038d948 0030a013 movne    r3, #0
a038d94c 7330efe6 uxtb     r3, r3
a038d950 0320a0e1 mov      r2, r3
a038d954 183a0be3 movw     r3, #0xba18
a038d958 70314ae3 movt     r3, #0xa170
a038d95c 0020c3e5 strb     r2, [r3]
a038d960 183a0be3 movw     r3, #0xba18
a038d964 70314ae3 movt     r3, #0xa170
a038d968 0030d3e5 ldrb     r3, [r3]
a038d96c 0320a0e1 mov      r2, r3
a038d970 7c330be3 movw     r3, #0xb37c
a038d974 70314ae3 movt     r3, #0xa170
a038d978 022193e7 ldr      r2, [r3, r2, lsl #2]
a038d97c 183a0be3 movw     r3, #0xba18
a038d980 70314ae3 movt     r3, #0xa170
a038d984 0030d3e5 ldrb     r3, [r3]
a038d988 0310a0e1 mov      r1, r3
a038d98c 0c3a0be3 movw     r3, #0xba0c
a038d990 70314ae3 movt     r3, #0xa170
a038d994 013193e7 ldr      r3, [r3, r1, lsl #2]
a038d998 023063e0 rsb      r3, r3, r2
a038d99c 54318de5 str      r3, [sp, #0x154]
a038d9a0 70330be3 movw     r3, #0xb370
a038d9a4 70314ae3 movt     r3, #0xa170
a038d9a8 002093e5 ldr      r2, [r3]
a038d9ac 6c330be3 movw     r3, #0xb36c
a038d9b0 70314ae3 movt     r3, #0xa170
a038d9b4 003093e5 ldr      r3, [r3]
a038d9b8 023063e0 rsb      r3, r3, r2
a038d9bc 78119de5 ldr      r1, [sp, #0x178]
a038d9c0 54219de5 ldr      r2, [sp, #0x154]
a038d9c4 022081e0 add      r2, r1, r2
a038d9c8 920302e0 mul      r2, r2, r3
a038d9cc a83504e3 movw     r3, #0x45a8
a038d9d0 70314ae3 movt     r3, #0xa170
a038d9d4 003093e5 ldr      r3, [r3]
a038d9d8 0200a0e1 mov      r0, r2
a038d9dc 0310a0e1 mov      r1, r3
a038d9e0 2ae305fa blx      #0xa0506690
a038d9e4 0030a0e1 mov      r3, r0
a038d9e8 0320a0e1 mov      r2, r3
a038d9ec 6c330be3 movw     r3, #0xb36c
a038d9f0 70314ae3 movt     r3, #0xa170
a038d9f4 003093e5 ldr      r3, [r3]
a038d9f8 032082e0 add      r2, r2, r3
a038d9fc 70330be3 movw     r3, #0xb370
a038da00 70314ae3 movt     r3, #0xa170
a038da04 002083e5 str      r2, [r3]
a038da08 f4390be3 movw     r3, #0xb9f4
a038da0c 70314ae3 movt     r3, #0xa170
a038da10 042093e5 ldr      r2, [r3, #4]
a038da14 70330be3 movw     r3, #0xb370
a038da18 70314ae3 movt     r3, #0xa170
a038da1c 003093e5 ldr      r3, [r3]
a038da20 022063e0 rsb      r2, r3, r2
a038da24 a8390be3 movw     r3, #0xb9a8
a038da28 70314ae3 movt     r3, #0xa170
a038da2c 002083e5 str      r2, [r3]
a038da30 e8390be3 movw     r3, #0xb9e8
a038da34 70314ae3 movt     r3, #0xa170
a038da38 0120a0e3 mov      r2, #1
a038da3c 0020c3e5 strb     r2, [r3]
a038da40 a8390be3 movw     r3, #0xb9a8
a038da44 70314ae3 movt     r3, #0xa170
a038da48 003093e5 ldr      r3, [r3]
a038da4c 000053e3 cmp      r3, #0
a038da50 0a0000aa bge      #0xa038da80
a038da54 e8390be3 movw     r3, #0xb9e8
a038da58 70314ae3 movt     r3, #0xa170
a038da5c 0020e0e3 mvn      r2, #0
a038da60 0020c3e5 strb     r2, [r3]
a038da64 a8390be3 movw     r3, #0xb9a8
a038da68 70314ae3 movt     r3, #0xa170
a038da6c 003093e5 ldr      r3, [r3]
a038da70 002063e2 rsb      r2, r3, #0
a038da74 a8390be3 movw     r3, #0xb9a8
a038da78 70314ae3 movt     r3, #0xa170
a038da7c 002083e5 str      r2, [r3]
a038da80 a8390be3 movw     r3, #0xb9a8
a038da84 70314ae3 movt     r3, #0xa170
a038da88 003093e5 ldr      r3, [r3]
a038da8c 0320a0e1 mov      r2, r3
a038da90 c23fa0e1 asr      r3, r2, #0x1f
a038da94 031ba0e1 lsl      r1, r3, #0x16
a038da98 e4108de5 str      r1, [sp, #0xe4]
a038da9c e4109de5 ldr      r1, [sp, #0xe4]
a038daa0 221581e1 orr      r1, r1, r2, lsr #10
a038daa4 e4108de5 str      r1, [sp, #0xe4]
a038daa8 023ba0e1 lsl      r3, r2, #0x16
a038daac e0308de5 str      r3, [sp, #0xe0]
a038dab0 483204e3 movw     r3, #0x4248
a038dab4 70314ae3 movt     r3, #0xa170
a038dab8 003093e5 ldr      r3, [r3]
a038dabc 0320a0e1 mov      r2, r3
a038dac0 0030a0e3 mov      r3, #0
a038dac4 d00ecde1 ldrd     r0, r1, [sp, #0xe0]
a038dac8 1ae505fa blx      #0xa0506f38
a038dacc 0020a0e1 mov      r2, r0
a038dad0 0130a0e1 mov      r3, r1
a038dad4 0200a0e1 mov      r0, r2
a038dad8 0310a0e1 mov      r1, r3
a038dadc a83504e3 movw     r3, #0x45a8
a038dae0 70314ae3 movt     r3, #0xa170
a038dae4 003093e5 ldr      r3, [r3]
a038dae8 0320a0e1 mov      r2, r3
a038daec c23fa0e1 asr      r3, r2, #0x1f
a038daf0 10e505fa blx      #0xa0506f38
a038daf4 0020a0e1 mov      r2, r0
a038daf8 0130a0e1 mov      r3, r1
a038dafc 1c3a0be3 movw     r3, #0xba1c
a038db00 70314ae3 movt     r3, #0xa170
a038db04 002083e5 str      r2, [r3]
a038db08 e8390be3 movw     r3, #0xb9e8
a038db0c 70314ae3 movt     r3, #0xa170
a038db10 0030d3e5 ldrb     r3, [r3]
a038db14 7330afe6 sxtb     r3, r3
a038db18 010073e3 cmn      r3, #1
a038db1c 0600001a bne      #0xa038db3c
a038db20 1c3a0be3 movw     r3, #0xba1c
a038db24 70314ae3 movt     r3, #0xa170
a038db28 003093e5 ldr      r3, [r3]
a038db2c 002063e2 rsb      r2, r3, #0
a038db30 1c3a0be3 movw     r3, #0xba1c
a038db34 70314ae3 movt     r3, #0xa170
a038db38 002083e5 str      r2, [r3]
a038db3c 78330be3 movw     r3, #0xb378
a038db40 70314ae3 movt     r3, #0xa170
a038db44 002093e5 ldr      r2, [r3]
a038db48 74330be3 movw     r3, #0xb374
a038db4c 70314ae3 movt     r3, #0xa170
a038db50 003093e5 ldr      r3, [r3]
a038db54 023063e0 rsb      r3, r3, r2
a038db58 74119de5 ldr      r1, [sp, #0x174]
a038db5c 54219de5 ldr      r2, [sp, #0x154]
a038db60 022081e0 add      r2, r1, r2
a038db64 920302e0 mul      r2, r2, r3
a038db68 a83504e3 movw     r3, #0x45a8
a038db6c 70314ae3 movt     r3, #0xa170
a038db70 003093e5 ldr      r3, [r3]
a038db74 0200a0e1 mov      r0, r2
a038db78 0310a0e1 mov      r1, r3
a038db7c c3e205fa blx      #0xa0506690
a038db80 0030a0e1 mov      r3, r0
a038db84 0320a0e1 mov      r2, r3
a038db88 74330be3 movw     r3, #0xb374
a038db8c 70314ae3 movt     r3, #0xa170
a038db90 003093e5 ldr      r3, [r3]
a038db94 032082e0 add      r2, r2, r3
a038db98 78330be3 movw     r3, #0xb378
a038db9c 70314ae3 movt     r3, #0xa170
a038dba0 002083e5 str      r2, [r3]
a038dba4 f4390be3 movw     r3, #0xb9f4
a038dba8 70314ae3 movt     r3, #0xa170
a038dbac 042093e5 ldr      r2, [r3, #4]
a038dbb0 78330be3 movw     r3, #0xb378
a038dbb4 70314ae3 movt     r3, #0xa170
a038dbb8 003093e5 ldr      r3, [r3]
a038dbbc 022063e0 rsb      r2, r3, r2
a038dbc0 a8390be3 movw     r3, #0xb9a8
a038dbc4 70314ae3 movt     r3, #0xa170
a038dbc8 002083e5 str      r2, [r3]
a038dbcc e8390be3 movw     r3, #0xb9e8
a038dbd0 70314ae3 movt     r3, #0xa170
a038dbd4 0120a0e3 mov      r2, #1
a038dbd8 0020c3e5 strb     r2, [r3]
a038dbdc a8390be3 movw     r3, #0xb9a8
a038dbe0 70314ae3 movt     r3, #0xa170
a038dbe4 003093e5 ldr      r3, [r3]
a038dbe8 000053e3 cmp      r3, #0
a038dbec 0a0000aa bge      #0xa038dc1c
a038dbf0 e8390be3 movw     r3, #0xb9e8
a038dbf4 70314ae3 movt     r3, #0xa170
a038dbf8 0020e0e3 mvn      r2, #0
a038dbfc 0020c3e5 strb     r2, [r3]
a038dc00 a8390be3 movw     r3, #0xb9a8
a038dc04 70314ae3 movt     r3, #0xa170
a038dc08 003093e5 ldr      r3, [r3]
a038dc0c 002063e2 rsb      r2, r3, #0
a038dc10 a8390be3 movw     r3, #0xb9a8
a038dc14 70314ae3 movt     r3, #0xa170
a038dc18 002083e5 str      r2, [r3]
a038dc1c a8390be3 movw     r3, #0xb9a8
a038dc20 70314ae3 movt     r3, #0xa170
a038dc24 003093e5 ldr      r3, [r3]
a038dc28 0320a0e1 mov      r2, r3
a038dc2c c23fa0e1 asr      r3, r2, #0x1f
a038dc30 031ba0e1 lsl      r1, r3, #0x16
a038dc34 ec108de5 str      r1, [sp, #0xec]
a038dc38 ec109de5 ldr      r1, [sp, #0xec]
a038dc3c 221581e1 orr      r1, r1, r2, lsr #10
a038dc40 ec108de5 str      r1, [sp, #0xec]
a038dc44 023ba0e1 lsl      r3, r2, #0x16
a038dc48 e8308de5 str      r3, [sp, #0xe8]
a038dc4c 483204e3 movw     r3, #0x4248
a038dc50 70314ae3 movt     r3, #0xa170
a038dc54 003093e5 ldr      r3, [r3]
a038dc58 0320a0e1 mov      r2, r3
a038dc5c 0030a0e3 mov      r3, #0
a038dc60 d80ecde1 ldrd     r0, r1, [sp, #0xe8]
a038dc64 b3e405fa blx      #0xa0506f38
a038dc68 0020a0e1 mov      r2, r0
a038dc6c 0130a0e1 mov      r3, r1
a038dc70 0200a0e1 mov      r0, r2
a038dc74 0310a0e1 mov      r1, r3
a038dc78 a83504e3 movw     r3, #0x45a8
a038dc7c 70314ae3 movt     r3, #0xa170
a038dc80 003093e5 ldr      r3, [r3]
a038dc84 0320a0e1 mov      r2, r3
a038dc88 c23fa0e1 asr      r3, r2, #0x1f
a038dc8c a9e405fa blx      #0xa0506f38
a038dc90 0020a0e1 mov      r2, r0
a038dc94 0130a0e1 mov      r3, r1
a038dc98 203a0be3 movw     r3, #0xba20
a038dc9c 70314ae3 movt     r3, #0xa170
a038dca0 002083e5 str      r2, [r3]
a038dca4 e8390be3 movw     r3, #0xb9e8
a038dca8 70314ae3 movt     r3, #0xa170
a038dcac 0030d3e5 ldrb     r3, [r3]
a038dcb0 7330afe6 sxtb     r3, r3
a038dcb4 010073e3 cmn      r3, #1
a038dcb8 0600001a bne      #0xa038dcd8
a038dcbc 203a0be3 movw     r3, #0xba20
a038dcc0 70314ae3 movt     r3, #0xa170
a038dcc4 003093e5 ldr      r3, [r3]
a038dcc8 002063e2 rsb      r2, r3, #0
a038dccc 203a0be3 movw     r3, #0xba20
a038dcd0 70314ae3 movt     r3, #0xa170
a038dcd4 002083e5 str      r2, [r3]
a038dcd8 1c3a0be3 movw     r3, #0xba1c
a038dcdc 70314ae3 movt     r3, #0xa170
a038dce0 000093e5 ldr      r0, [r3]
a038dce4 203a0be3 movw     r3, #0xba20
a038dce8 70314ae3 movt     r3, #0xa170
a038dcec 001093e5 ldr      r1, [r3]
a038dcf0 1a3b0ae3 movw     r3, #0xab1a
a038dcf4 70314ae3 movt     r3, #0xa170
a038dcf8 0020d3e5 ldrb     r2, [r3]
a038dcfc 183a0be3 movw     r3, #0xba18
a038dd00 70314ae3 movt     r3, #0xa170
a038dd04 0030d3e5 ldrb     r3, [r3]
a038dd08 1cd8ffeb bl       #0xa0383d80
a038dd0c 50018de5 str      r0, [sp, #0x150]
a038dd10 50319de5 ldr      r3, [sp, #0x150]
a038dd14 000053e3 cmp      r3, #0
a038dd18 1c00001a bne      #0xa038dd90
a038dd1c 70330be3 movw     r3, #0xb370
a038dd20 70314ae3 movt     r3, #0xa170
a038dd24 002093e5 ldr      r2, [r3]
a038dd28 6c330be3 movw     r3, #0xb36c
a038dd2c 70314ae3 movt     r3, #0xa170
a038dd30 002083e5 str      r2, [r3]
a038dd34 f4390be3 movw     r3, #0xb9f4
a038dd38 70314ae3 movt     r3, #0xa170
a038dd3c 042093e5 ldr      r2, [r3, #4]
a038dd40 70330be3 movw     r3, #0xb370
a038dd44 70314ae3 movt     r3, #0xa170
a038dd48 002083e5 str      r2, [r3]
a038dd4c 0030a0e3 mov      r3, #0
a038dd50 78318de5 str      r3, [sp, #0x178]
a038dd54 78330be3 movw     r3, #0xb378
a038dd58 70314ae3 movt     r3, #0xa170
a038dd5c 002093e5 ldr      r2, [r3]
a038dd60 74330be3 movw     r3, #0xb374
a038dd64 70314ae3 movt     r3, #0xa170
a038dd68 002083e5 str      r2, [r3]
a038dd6c f4390be3 movw     r3, #0xb9f4
a038dd70 70314ae3 movt     r3, #0xa170
a038dd74 042093e5 ldr      r2, [r3, #4]
a038dd78 78330be3 movw     r3, #0xb378
a038dd7c 70314ae3 movt     r3, #0xa170
a038dd80 002083e5 str      r2, [r3]
a038dd84 0030a0e3 mov      r3, #0
a038dd88 74318de5 str      r3, [sp, #0x174]
a038dd8c 210000ea b        #0xa038de18
a038dd90 50319de5 ldr      r3, [sp, #0x150]
a038dd94 010073e3 cmn      r3, #1
a038dd98 0800001a bne      #0xa038ddc0
a038dd9c 78219de5 ldr      r2, [sp, #0x178]
a038dda0 54319de5 ldr      r3, [sp, #0x154]
a038dda4 033082e0 add      r3, r2, r3
a038dda8 78318de5 str      r3, [sp, #0x178]
a038ddac 74219de5 ldr      r2, [sp, #0x174]
a038ddb0 54319de5 ldr      r3, [sp, #0x154]
a038ddb4 033082e0 add      r3, r2, r3
a038ddb8 74318de5 str      r3, [sp, #0x174]
a038ddbc 150000ea b        #0xa038de18
a038ddc0 50319de5 ldr      r3, [sp, #0x150]
a038ddc4 030073e3 cmn      r3, #3
a038ddc8 1200001a bne      #0xa038de18
a038ddcc 70330be3 movw     r3, #0xb370
a038ddd0 70314ae3 movt     r3, #0xa170
a038ddd4 002093e5 ldr      r2, [r3]
a038ddd8 6c330be3 movw     r3, #0xb36c
a038dddc 70314ae3 movt     r3, #0xa170
a038dde0 002083e5 str      r2, [r3]
a038dde4 f4390be3 movw     r3, #0xb9f4
a038dde8 70314ae3 movt     r3, #0xa170
a038ddec 042093e5 ldr      r2, [r3, #4]
a038ddf0 70330be3 movw     r3, #0xb370
a038ddf4 70314ae3 movt     r3, #0xa170
a038ddf8 002083e5 str      r2, [r3]
a038ddfc 0030a0e3 mov      r3, #0
a038de00 78318de5 str      r3, [sp, #0x178]
a038de04 74219de5 ldr      r2, [sp, #0x174]
a038de08 54319de5 ldr      r3, [sp, #0x154]
a038de0c 033082e0 add      r3, r2, r3
a038de10 74318de5 str      r3, [sp, #0x174]
a038de14 320000ea b        #0xa038dee4
a038de18 310000ea b        #0xa038dee4
a038de1c 153b0ae3 movw     r3, #0xab15
a038de20 70314ae3 movt     r3, #0xa170
a038de24 0030d3e5 ldrb     r3, [r3]
a038de28 000053e3 cmp      r3, #0
a038de2c 2c00000a beq      #0xa038dee4
a038de30 183b0ae3 movw     r3, #0xab18
a038de34 70314ae3 movt     r3, #0xa170
a038de38 0030d3e5 ldrb     r3, [r3]
a038de3c 000053e3 cmp      r3, #0
a038de40 2700000a beq      #0xa038dee4
a038de44 643a07e3 movw     r3, #0x7a64
a038de48 75304ae3 movt     r3, #0xa075
a038de4c 003093e5 ldr      r3, [r3]
a038de50 000053e3 cmp      r3, #0
a038de54 2200000a beq      #0xa038dee4
a038de58 f83a07e3 movw     r3, #0x7af8
a038de5c 75304ae3 movt     r3, #0xa075
a038de60 be33d3e1 ldrh     r3, [r3, #0x3e]
a038de64 000053e3 cmp      r3, #0
a038de68 1d00001a bne      #0xa038dee4
a038de6c 2a3f0ae3 movw     r3, #0xaf2a
a038de70 70314ae3 movt     r3, #0xa170
a038de74 0030d3e5 ldrb     r3, [r3]
a038de78 000053e3 cmp      r3, #0
a038de7c 1800001a bne      #0xa038dee4
a038de80 d4390be3 movw     r3, #0xb9d4
a038de84 70314ae3 movt     r3, #0xa170
a038de88 0030d3e5 ldrb     r3, [r3]
a038de8c 000053e3 cmp      r3, #0
a038de90 1300001a bne      #0xa038dee4
a038de94 d4390be3 movw     r3, #0xb9d4
a038de98 70314ae3 movt     r3, #0xa170
a038de9c 0120a0e3 mov      r2, #1
a038dea0 0020c3e5 strb     r2, [r3]
a038dea4 70330be3 movw     r3, #0xb370
a038dea8 70314ae3 movt     r3, #0xa170
a038deac 003093e5 ldr      r3, [r3]
a038deb0 000053e3 cmp      r3, #0
a038deb4 050000ba blt      #0xa038ded0
a038deb8 0000a0e3 mov      r0, #0
a038debc 0010a0e3 mov      r1, #0
a038dec0 ff20a0e3 mov      r2, #0xff
a038dec4 0030a0e3 mov      r3, #0
a038dec8 acd7ffeb bl       #0xa0383d80
a038decc 040000ea b        #0xa038dee4
a038ded0 0000e0e3 mvn      r0, #0
a038ded4 0010e0e3 mvn      r1, #0
a038ded8 ff20a0e3 mov      r2, #0xff
a038dedc 0030a0e3 mov      r3, #0
a038dee0 a6d7ffeb bl       #0xa0383d80
a038dee4 f83a07e3 movw     r3, #0x7af8
a038dee8 75304ae3 movt     r3, #0xa075
a038deec ba33d3e1 ldrh     r3, [r3, #0x3a]
a038def0 000053e3 cmp      r3, #0
a038def4 4b00000a beq      #0xa038e028
a038def8 8c3c0de3 movw     r3, #0xdc8c
a038defc 62304ae3 movt     r3, #0xa062
a038df00 003093e5 ldr      r3, [r3]
a038df04 542293e5 ldr      r2, [r3, #0x254]
a038df08 243a0be3 movw     r3, #0xba24
a038df0c 70314ae3 movt     r3, #0xa170
a038df10 002083e5 str      r2, [r3]
a038df14 f83a07e3 movw     r3, #0x7af8
a038df18 75304ae3 movt     r3, #0xa075
a038df1c ba33d3e1 ldrh     r3, [r3, #0x3a]
a038df20 013003e2 and      r3, r3, #1
a038df24 000053e3 cmp      r3, #0
a038df28 1400000a beq      #0xa038df80
a038df2c 243a0be3 movw     r3, #0xba24
a038df30 70314ae3 movt     r3, #0xa170
a038df34 002093e5 ldr      r2, [r3]
a038df38 58330be3 movw     r3, #0xb358
a038df3c 70314ae3 movt     r3, #0xa170
a038df40 003093e5 ldr      r3, [r3]
a038df44 021063e0 rsb      r1, r3, r2
a038df48 58330be3 movw     r3, #0xb358
a038df4c 70314ae3 movt     r3, #0xa170
a038df50 002093e5 ldr      r2, [r3]
a038df54 243a0be3 movw     r3, #0xba24
a038df58 70314ae3 movt     r3, #0xa170
a038df5c 00c093e5 ldr      ip, [r3]
a038df60 2c3204e3 movw     r3, #0x422c
a038df64 70314ae3 movt     r3, #0xa170
a038df68 003093e5 ldr      r3, [r3]
a038df6c 00308de5 str      r3, [sp]
a038df70 c80900e3 movw     r0, #0x9c8
a038df74 60004ae3 movt     r0, #0xa060
a038df78 0c30a0e1 mov      r3, ip
a038df7c 5a64fceb bl       #0xa02a70ec
a038df80 f83a07e3 movw     r3, #0x7af8
a038df84 75304ae3 movt     r3, #0xa075
a038df88 ba33d3e1 ldrh     r3, [r3, #0x3a]
a038df8c 023003e2 and      r3, r3, #2
a038df90 000053e3 cmp      r3, #0
a038df94 2300000a beq      #0xa038e028
a038df98 243a0be3 movw     r3, #0xba24
a038df9c 70314ae3 movt     r3, #0xa170
a038dfa0 002093e5 ldr      r2, [r3]
a038dfa4 58330be3 movw     r3, #0xb358
a038dfa8 70314ae3 movt     r3, #0xa170
a038dfac 003093e5 ldr      r3, [r3]
a038dfb0 023063e0 rsb      r3, r3, r2
a038dfb4 bf2d05e3 movw     r2, #0x5dbf
a038dfb8 020053e1 cmp      r3, r2
a038dfbc 1900009a bls      #0xa038e028
a038dfc0 7c3003e3 movw     r3, #0x307c
a038dfc4 6f304ae3 movt     r3, #0xa06f
a038dfc8 041093e5 ldr      r1, [r3, #4]
a038dfcc 243a0be3 movw     r3, #0xba24
a038dfd0 70314ae3 movt     r3, #0xa170
a038dfd4 002093e5 ldr      r2, [r3]
a038dfd8 58330be3 movw     r3, #0xb358
a038dfdc 70314ae3 movt     r3, #0xa170
a038dfe0 003093e5 ldr      r3, [r3]
a038dfe4 02e063e0 rsb      lr, r3, r2
a038dfe8 58330be3 movw     r3, #0xb358
a038dfec 70314ae3 movt     r3, #0xa170
a038dff0 00c093e5 ldr      ip, [r3]
a038dff4 243a0be3 movw     r3, #0xba24
a038dff8 70314ae3 movt     r3, #0xa170
a038dffc 002093e5 ldr      r2, [r3]
a038e000 2c3204e3 movw     r3, #0x422c
a038e004 70314ae3 movt     r3, #0xa170
a038e008 003093e5 ldr      r3, [r3]
a038e00c 00208de5 str      r2, [sp]
a038e010 04308de5 str      r3, [sp, #4]
a038e014 fc0900e3 movw     r0, #0x9fc
a038e018 60004ae3 movt     r0, #0xa060
a038e01c 0e20a0e1 mov      r2, lr
a038e020 0c30a0e1 mov      r3, ip
a038e024 3064fceb bl       #0xa02a70ec
a038e028 0000a0e1 mov      r0, r0
a038e02c 65df8de2 add      sp, sp, #0x194
a038e030 f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a038e034 00f020e3 nop      
