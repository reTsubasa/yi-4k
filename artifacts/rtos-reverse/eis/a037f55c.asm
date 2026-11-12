; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a037f55c f0402de9 push     {r4, r5, r6, r7, lr}
a037f560 24d04de2 sub      sp, sp, #0x24
a037f564 1c0f0ee3 movw     r0, #0xef1c
a037f568 5f004ae3 movt     r0, #0xa05f
a037f56c de9efceb bl       #0xa02a70ec
a037f570 c03c02e3 movw     r3, #0x2cc0
a037f574 70314ae3 movt     r3, #0xa170
a037f578 bc31d3e1 ldrh     r3, [r3, #0x1c]
a037f57c 7320ffe6 uxth     r2, r3
a037f580 0030a0e3 mov      r3, #0
a037f584 f821cde1 strd     r2, r3, [sp, #0x18]
a037f588 c03c02e3 movw     r3, #0x2cc0
a037f58c 70314ae3 movt     r3, #0xa170
a037f590 ba31d3e1 ldrh     r3, [r3, #0x1a]
a037f594 7320ffe6 uxth     r2, r3
a037f598 0030a0e3 mov      r3, #0
a037f59c f021cde1 strd     r2, r3, [sp, #0x10]
a037f5a0 c03c02e3 movw     r3, #0x2cc0
a037f5a4 70314ae3 movt     r3, #0xa170
a037f5a8 1230d3e5 ldrb     r3, [r3, #0x12]
a037f5ac 7320efe6 uxtb     r2, r3
a037f5b0 0030a0e3 mov      r3, #0
a037f5b4 f820cde1 strd     r2, r3, [sp, #8]
a037f5b8 d821cde1 ldrd     r2, r3, [sp, #0x18]
a037f5bc 0374a0e1 lsl      r7, r3, #8
a037f5c0 227c87e1 orr      r7, r7, r2, lsr #24
a037f5c4 0264a0e1 lsl      r6, r2, #8
a037f5c8 c03c02e3 movw     r3, #0x2cc0
a037f5cc 70314ae3 movt     r3, #0xa170
a037f5d0 0e30d3e5 ldrb     r3, [r3, #0xe]
a037f5d4 7320efe6 uxtb     r2, r3
a037f5d8 0030a0e3 mov      r3, #0
a037f5dc 920700e0 mul      r0, r2, r7
a037f5e0 960301e0 mul      r1, r6, r3
a037f5e4 011080e0 add      r1, r0, r1
a037f5e8 962283e0 umull    r2, r3, r6, r2
a037f5ec 031081e0 add      r1, r1, r3
a037f5f0 0130a0e1 mov      r3, r1
a037f5f4 c01c02e3 movw     r1, #0x2cc0
a037f5f8 70114ae3 movt     r1, #0xa170
a037f5fc 0f10d1e5 ldrb     r1, [r1, #0xf]
a037f600 7160efe6 uxtb     r6, r1
a037f604 0070a0e3 mov      r7, #0
a037f608 0200a0e1 mov      r0, r2
a037f60c 0310a0e1 mov      r1, r3
a037f610 0620a0e1 mov      r2, r6
a037f614 0730a0e1 mov      r3, r7
a037f618 461e06fa blx      #0xa0506f38
a037f61c 0020a0e1 mov      r2, r0
a037f620 0130a0e1 mov      r3, r1
a037f624 f821cde1 strd     r2, r3, [sp, #0x18]
a037f628 d021cde1 ldrd     r2, r3, [sp, #0x10]
a037f62c 0354a0e1 lsl      r5, r3, #8
a037f630 225c85e1 orr      r5, r5, r2, lsr #24
a037f634 0244a0e1 lsl      r4, r2, #8
a037f638 c03c02e3 movw     r3, #0x2cc0
a037f63c 70314ae3 movt     r3, #0xa170
a037f640 0e30d3e5 ldrb     r3, [r3, #0xe]
a037f644 7320efe6 uxtb     r2, r3
a037f648 0030a0e3 mov      r3, #0
a037f64c 920500e0 mul      r0, r2, r5
a037f650 940301e0 mul      r1, r4, r3
a037f654 011080e0 add      r1, r0, r1
a037f658 942283e0 umull    r2, r3, r4, r2
a037f65c 031081e0 add      r1, r1, r3
a037f660 0130a0e1 mov      r3, r1
a037f664 c01c02e3 movw     r1, #0x2cc0
a037f668 70114ae3 movt     r1, #0xa170
a037f66c 0f10d1e5 ldrb     r1, [r1, #0xf]
a037f670 7140efe6 uxtb     r4, r1
a037f674 0050a0e3 mov      r5, #0
a037f678 0200a0e1 mov      r0, r2
a037f67c 0310a0e1 mov      r1, r3
a037f680 0420a0e1 mov      r2, r4
a037f684 0530a0e1 mov      r3, r5
a037f688 2a1e06fa blx      #0xa0506f38
a037f68c 0020a0e1 mov      r2, r0
a037f690 0130a0e1 mov      r3, r1
a037f694 f021cde1 strd     r2, r3, [sp, #0x10]
a037f698 c03c02e3 movw     r3, #0x2cc0
a037f69c 70314ae3 movt     r3, #0xa170
a037f6a0 1230d3e5 ldrb     r3, [r3, #0x12]
a037f6a4 0324a0e1 lsl      r2, r3, #8
a037f6a8 c03c02e3 movw     r3, #0x2cc0
a037f6ac 70314ae3 movt     r3, #0xa170
a037f6b0 0e30d3e5 ldrb     r3, [r3, #0xe]
a037f6b4 930202e0 mul      r2, r3, r2
a037f6b8 c03c02e3 movw     r3, #0x2cc0
a037f6bc 70314ae3 movt     r3, #0xa170
a037f6c0 0f30d3e5 ldrb     r3, [r3, #0xf]
a037f6c4 0200a0e1 mov      r0, r2
a037f6c8 0310a0e1 mov      r1, r3
a037f6cc ef1b06fa blx      #0xa0506690
a037f6d0 0030a0e1 mov      r3, r0
a037f6d4 0320a0e1 mov      r2, r3
a037f6d8 c23fa0e1 asr      r3, r2, #0x1f
a037f6dc f820cde1 strd     r2, r3, [sp, #8]
a037f6e0 d801cde1 ldrd     r0, r1, [sp, #0x18]
a037f6e4 d021cde1 ldrd     r2, r3, [sp, #0x10]
a037f6e8 002092e0 adds     r2, r2, r0
a037f6ec 0130a3e0 adc      r3, r3, r1
a037f6f0 a310b0e1 lsrs     r1, r3, #1
a037f6f4 6200a0e1 rrx      r0, r2
a037f6f8 c83004e3 movw     r3, #0x40c8
a037f6fc 70314ae3 movt     r3, #0xa170
a037f700 f000c3e1 strd     r0, r1, [r3]
a037f704 c83004e3 movw     r3, #0x40c8
a037f708 70314ae3 movt     r3, #0xa170
a037f70c d000c3e1 ldrd     r0, r1, [r3]
a037f710 c83004e3 movw     r3, #0x40c8
a037f714 70314ae3 movt     r3, #0xa170
a037f718 f800c3e1 strd     r0, r1, [r3, #8]
a037f71c c83004e3 movw     r3, #0x40c8
a037f720 70314ae3 movt     r3, #0xa170
a037f724 d000c3e1 ldrd     r0, r1, [r3]
a037f728 c83004e3 movw     r3, #0x40c8
a037f72c 70314ae3 movt     r3, #0xa170
a037f730 f001c3e1 strd     r0, r1, [r3, #0x10]
a037f734 c83004e3 movw     r3, #0x40c8
a037f738 70314ae3 movt     r3, #0xa170
a037f73c d000c3e1 ldrd     r0, r1, [r3]
a037f740 c83004e3 movw     r3, #0x40c8
a037f744 70314ae3 movt     r3, #0xa170
a037f748 f801c3e1 strd     r0, r1, [r3, #0x18]
a037f74c c83004e3 movw     r3, #0x40c8
a037f750 70314ae3 movt     r3, #0xa170
a037f754 0020a0e3 mov      r2, #0
a037f758 202083e5 str      r2, [r3, #0x20]
a037f75c c83004e3 movw     r3, #0x40c8
a037f760 70314ae3 movt     r3, #0xa170
a037f764 0020a0e3 mov      r2, #0
a037f768 242083e5 str      r2, [r3, #0x24]
a037f76c c83004e3 movw     r3, #0x40c8
a037f770 70314ae3 movt     r3, #0xa170
a037f774 0020a0e3 mov      r2, #0
a037f778 282083e5 str      r2, [r3, #0x28]
a037f77c c03c02e3 movw     r3, #0x2cc0
a037f780 70314ae3 movt     r3, #0xa170
a037f784 be31d3e1 ldrh     r3, [r3, #0x1e]
a037f788 04308de5 str      r3, [sp, #4]
a037f78c c03c02e3 movw     r3, #0x2cc0
a037f790 70314ae3 movt     r3, #0xa170
a037f794 b032d3e1 ldrh     r3, [r3, #0x20]
a037f798 00308de5 str      r3, [sp]
a037f79c 04309de5 ldr      r3, [sp, #4]
a037f7a0 0334a0e1 lsl      r3, r3, #8
a037f7a4 04308de5 str      r3, [sp, #4]
a037f7a8 00309de5 ldr      r3, [sp]
a037f7ac 0334a0e1 lsl      r3, r3, #8
a037f7b0 00308de5 str      r3, [sp]
a037f7b4 04209de5 ldr      r2, [sp, #4]
a037f7b8 00309de5 ldr      r3, [sp]
a037f7bc 033082e0 add      r3, r2, r3
a037f7c0 a320a0e1 lsr      r2, r3, #1
a037f7c4 543504e3 movw     r3, #0x4554
a037f7c8 70314ae3 movt     r3, #0xa170
a037f7cc 002083e5 str      r2, [r3]
a037f7d0 543504e3 movw     r3, #0x4554
a037f7d4 70314ae3 movt     r3, #0xa170
a037f7d8 002093e5 ldr      r2, [r3]
a037f7dc 543504e3 movw     r3, #0x4554
a037f7e0 70314ae3 movt     r3, #0xa170
a037f7e4 042083e5 str      r2, [r3, #4]
a037f7e8 543504e3 movw     r3, #0x4554
a037f7ec 70314ae3 movt     r3, #0xa170
a037f7f0 002093e5 ldr      r2, [r3]
a037f7f4 543504e3 movw     r3, #0x4554
a037f7f8 70314ae3 movt     r3, #0xa170
a037f7fc 082083e5 str      r2, [r3, #8]
a037f800 f82004e3 movw     r2, #0x40f8
a037f804 70214ae3 movt     r2, #0xa170
a037f808 c83004e3 movw     r3, #0x40c8
a037f80c 70314ae3 movt     r3, #0xa170
a037f810 02c0a0e1 mov      ip, r2
a037f814 03e0a0e1 mov      lr, r3
a037f818 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a037f81c 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a037f820 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a037f824 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a037f828 0f009ee8 ldm      lr, {r0, r1, r2, r3}
a037f82c 0f008ce8 stm      ip, {r0, r1, r2, r3}
a037f830 c83004e3 movw     r3, #0x40c8
a037f834 70314ae3 movt     r3, #0xa170
a037f838 d020c3e1 ldrd     r2, r3, [r3]
a037f83c 0230a0e1 mov      r3, r2
a037f840 540f0ee3 movw     r0, #0xef54
a037f844 5f004ae3 movt     r0, #0xa05f
a037f848 0310a0e1 mov      r1, r3
a037f84c 269efceb bl       #0xa02a70ec
a037f850 c83004e3 movw     r3, #0x40c8
a037f854 70314ae3 movt     r3, #0xa170
a037f858 d820c3e1 ldrd     r2, r3, [r3, #8]
a037f85c 0230a0e1 mov      r3, r2
a037f860 6c0f0ee3 movw     r0, #0xef6c
a037f864 5f004ae3 movt     r0, #0xa05f
a037f868 0310a0e1 mov      r1, r3
a037f86c 1e9efceb bl       #0xa02a70ec
a037f870 543504e3 movw     r3, #0x4554
a037f874 70314ae3 movt     r3, #0xa170
a037f878 003093e5 ldr      r3, [r3]
a037f87c 840f0ee3 movw     r0, #0xef84
a037f880 5f004ae3 movt     r0, #0xa05f
a037f884 0310a0e1 mov      r1, r3
a037f888 179efceb bl       #0xa02a70ec
a037f88c 543504e3 movw     r3, #0x4554
a037f890 70314ae3 movt     r3, #0xa170
a037f894 043093e5 ldr      r3, [r3, #4]
a037f898 9c0f0ee3 movw     r0, #0xef9c
a037f89c 5f004ae3 movt     r0, #0xa05f
a037f8a0 0310a0e1 mov      r1, r3
a037f8a4 109efceb bl       #0xa02a70ec
a037f8a8 b40f0ee3 movw     r0, #0xefb4
a037f8ac 5f004ae3 movt     r0, #0xa05f
a037f8b0 0d9efceb bl       #0xa02a70ec
a037f8b4 24d08de2 add      sp, sp, #0x24
a037f8b8 f080bde8 pop      {r4, r5, r6, r7, pc}
a037f8bc f04f2de9 push     {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a037f8c0 34d04de2 sub      sp, sp, #0x34
a037f8c4 ec0f0ee3 movw     r0, #0xefec
a037f8c8 5f004ae3 movt     r0, #0xa05f
a037f8cc 069efceb bl       #0xa02a70ec
a037f8d0 883004e3 movw     r3, #0x4088
a037f8d4 70314ae3 movt     r3, #0xa170
a037f8d8 203093e5 ldr      r3, [r3, #0x20]
a037f8dc 0300a0e1 mov      r0, r3
a037f8e0 0010a0e3 mov      r1, #0
a037f8e4 0020a0e1 mov      r2, r0
a037f8e8 0130a0e1 mov      r3, r1
a037f8ec 022092e0 adds     r2, r2, r2
a037f8f0 0330a3e0 adc      r3, r3, r3
a037f8f4 002092e0 adds     r2, r2, r0
a037f8f8 0130a3e0 adc      r3, r3, r1
a037f8fc 0352a0e1 lsl      r5, r3, #4
a037f900 225e85e1 orr      r5, r5, r2, lsr #28
a037f904 0242a0e1 lsl      r4, r2, #4
a037f908 024054e0 subs     r4, r4, r2
a037f90c 0350c5e0 sbc      r5, r5, r3
a037f910 0571a0e1 lsl      r7, r5, #2
a037f914 247f87e1 orr      r7, r7, r4, lsr #30
a037f918 0461a0e1 lsl      r6, r4, #2
a037f91c 0640a0e1 mov      r4, r6
a037f920 0750a0e1 mov      r5, r7
a037f924 0400a0e1 mov      r0, r4
a037f928 0510a0e1 mov      r1, r5
a037f92c 883004e3 movw     r3, #0x4088
a037f930 70314ae3 movt     r3, #0xa170
a037f934 f800c3e1 strd     r0, r1, [r3, #8]
a037f938 883004e3 movw     r3, #0x4088
a037f93c 70314ae3 movt     r3, #0xa170
a037f940 203093e5 ldr      r3, [r3, #0x20]
a037f944 20000fe3 movw     r0, #0xf020
a037f948 5f004ae3 movt     r0, #0xa05f
a037f94c 0310a0e1 mov      r1, r3
a037f950 e59dfceb bl       #0xa02a70ec
a037f954 883004e3 movw     r3, #0x4088
a037f958 70314ae3 movt     r3, #0xa170
a037f95c d840c3e1 ldrd     r4, r5, [r3, #8]
a037f960 c03c02e3 movw     r3, #0x2cc0
a037f964 70314ae3 movt     r3, #0xa170
a037f968 0f30d3e5 ldrb     r3, [r3, #0xf]
a037f96c 7320efe6 uxtb     r2, r3
a037f970 0030a0e3 mov      r3, #0
a037f974 920500e0 mul      r0, r2, r5
a037f978 940301e0 mul      r1, r4, r3
a037f97c 01c080e0 add      ip, r0, r1
a037f980 940281e0 umull    r0, r1, r4, r2
a037f984 01308ce0 add      r3, ip, r1
a037f988 0310a0e1 mov      r1, r3
a037f98c 883004e3 movw     r3, #0x4088
a037f990 70314ae3 movt     r3, #0xa170
a037f994 f800c3e1 strd     r0, r1, [r3, #8]
a037f998 c03c02e3 movw     r3, #0x2cc0
a037f99c 70314ae3 movt     r3, #0xa170
a037f9a0 0f30d3e5 ldrb     r3, [r3, #0xf]
a037f9a4 40000fe3 movw     r0, #0xf040
a037f9a8 5f004ae3 movt     r0, #0xa05f
a037f9ac 0310a0e1 mov      r1, r3
a037f9b0 cd9dfceb bl       #0xa02a70ec
a037f9b4 883004e3 movw     r3, #0x4088
a037f9b8 70314ae3 movt     r3, #0xa170
a037f9bc d820c3e1 ldrd     r2, r3, [r3, #8]
a037f9c0 0230a0e1 mov      r3, r2
a037f9c4 58000fe3 movw     r0, #0xf058
a037f9c8 5f004ae3 movt     r0, #0xa05f
a037f9cc 0310a0e1 mov      r1, r3
a037f9d0 c59dfceb bl       #0xa02a70ec
a037f9d4 883004e3 movw     r3, #0x4088
a037f9d8 70314ae3 movt     r3, #0xa170
a037f9dc 243093e5 ldr      r3, [r3, #0x24]
a037f9e0 0300a0e1 mov      r0, r3
a037f9e4 0010a0e3 mov      r1, #0
a037f9e8 0020a0e1 mov      r2, r0
a037f9ec 0130a0e1 mov      r3, r1
a037f9f0 022092e0 adds     r2, r2, r2
a037f9f4 0330a3e0 adc      r3, r3, r3
a037f9f8 002092e0 adds     r2, r2, r0
a037f9fc 0130a3e0 adc      r3, r3, r1
a037fa00 0392a0e1 lsl      sb, r3, #4
a037fa04 229e89e1 orr      sb, sb, r2, lsr #28
a037fa08 0282a0e1 lsl      r8, r2, #4
a037fa0c 028058e0 subs     r8, r8, r2
a037fa10 0390c9e0 sbc      sb, sb, r3
a037fa14 0931a0e1 lsl      r3, sb, #2
a037fa18 14308de5 str      r3, [sp, #0x14]
a037fa1c 14309de5 ldr      r3, [sp, #0x14]
a037fa20 283f83e1 orr      r3, r3, r8, lsr #30
a037fa24 14308de5 str      r3, [sp, #0x14]
a037fa28 0831a0e1 lsl      r3, r8, #2
a037fa2c 10308de5 str      r3, [sp, #0x10]
a037fa30 d081cde1 ldrd     r8, sb, [sp, #0x10]
a037fa34 0800a0e1 mov      r0, r8
a037fa38 0910a0e1 mov      r1, sb
a037fa3c 883004e3 movw     r3, #0x4088
a037fa40 70314ae3 movt     r3, #0xa170
a037fa44 f001c3e1 strd     r0, r1, [r3, #0x10]
a037fa48 883004e3 movw     r3, #0x4088
a037fa4c 70314ae3 movt     r3, #0xa170
a037fa50 243093e5 ldr      r3, [r3, #0x24]
a037fa54 7c000fe3 movw     r0, #0xf07c
a037fa58 5f004ae3 movt     r0, #0xa05f
a037fa5c 0310a0e1 mov      r1, r3
a037fa60 a19dfceb bl       #0xa02a70ec
a037fa64 883004e3 movw     r3, #0x4088
a037fa68 70314ae3 movt     r3, #0xa170
a037fa6c d021c3e1 ldrd     r2, r3, [r3, #0x10]
a037fa70 0230a0e1 mov      r3, r2
a037fa74 9c000fe3 movw     r0, #0xf09c
a037fa78 5f004ae3 movt     r0, #0xa05f
a037fa7c 0310a0e1 mov      r1, r3
a037fa80 999dfceb bl       #0xa02a70ec
a037fa84 883004e3 movw     r3, #0x4088
a037fa88 70314ae3 movt     r3, #0xa170
a037fa8c d001c3e1 ldrd     r0, r1, [r3, #0x10]
a037fa90 c03c02e3 movw     r3, #0x2cc0
a037fa94 70314ae3 movt     r3, #0xa170
a037fa98 0f30d3e5 ldrb     r3, [r3, #0xf]
a037fa9c 7320efe6 uxtb     r2, r3
a037faa0 0030a0e3 mov      r3, #0
a037faa4 92010ee0 mul      lr, r2, r1
a037faa8 90030ce0 mul      ip, r0, r3
a037faac 0cc08ee0 add      ip, lr, ip
a037fab0 900281e0 umull    r0, r1, r0, r2
a037fab4 01308ce0 add      r3, ip, r1
a037fab8 0310a0e1 mov      r1, r3
a037fabc 883004e3 movw     r3, #0x4088
a037fac0 70314ae3 movt     r3, #0xa170
a037fac4 f001c3e1 strd     r0, r1, [r3, #0x10]
a037fac8 883004e3 movw     r3, #0x4088
a037facc 70314ae3 movt     r3, #0xa170
a037fad0 c90fa0e3 mov      r0, #0x324
a037fad4 0010a0e3 mov      r1, #0
a037fad8 f000c3e1 strd     r0, r1, [r3]
a037fadc 883004e3 movw     r3, #0x4088
a037fae0 70314ae3 movt     r3, #0xa170
a037fae4 d000c3e1 ldrd     r0, r1, [r3]
a037fae8 c03c02e3 movw     r3, #0x2cc0
a037faec 70314ae3 movt     r3, #0xa170
a037faf0 0e30d3e5 ldrb     r3, [r3, #0xe]
a037faf4 7320efe6 uxtb     r2, r3
a037faf8 0030a0e3 mov      r3, #0
a037fafc 92010ee0 mul      lr, r2, r1
a037fb00 90030ce0 mul      ip, r0, r3
a037fb04 0cc08ee0 add      ip, lr, ip
a037fb08 900281e0 umull    r0, r1, r0, r2
a037fb0c 01308ce0 add      r3, ip, r1
a037fb10 0310a0e1 mov      r1, r3
a037fb14 883004e3 movw     r3, #0x4088
a037fb18 70314ae3 movt     r3, #0xa170
a037fb1c f000c3e1 strd     r0, r1, [r3]
a037fb20 883004e3 movw     r3, #0x4088
a037fb24 70314ae3 movt     r3, #0xa170
a037fb28 d800c3e1 ldrd     r0, r1, [r3, #8]
a037fb2c 543504e3 movw     r3, #0x4554
a037fb30 70314ae3 movt     r3, #0xa170
a037fb34 003093e5 ldr      r3, [r3]
a037fb38 0320a0e1 mov      r2, r3
a037fb3c 0030a0e3 mov      r3, #0
a037fb40 92010ee0 mul      lr, r2, r1
a037fb44 90030ce0 mul      ip, r0, r3
a037fb48 0cc08ee0 add      ip, lr, ip
a037fb4c 902283e0 umull    r2, r3, r0, r2
a037fb50 03108ce0 add      r1, ip, r3
a037fb54 0130a0e1 mov      r3, r1
a037fb58 0200a0e1 mov      r0, r2
a037fb5c 0310a0e1 mov      r1, r3
a037fb60 6420a0e3 mov      r2, #0x64
a037fb64 0030a0e3 mov      r3, #0
a037fb68 f21c06fa blx      #0xa0506f38
a037fb6c 0020a0e1 mov      r2, r0
a037fb70 0130a0e1 mov      r3, r1
a037fb74 0200a0e1 mov      r0, r2
a037fb78 0310a0e1 mov      r1, r3
a037fb7c 783204e3 movw     r3, #0x4278
a037fb80 70314ae3 movt     r3, #0xa170
a037fb84 f800c3e1 strd     r0, r1, [r3, #8]
a037fb88 783204e3 movw     r3, #0x4278
a037fb8c 70314ae3 movt     r3, #0xa170
a037fb90 d820c3e1 ldrd     r2, r3, [r3, #8]
a037fb94 2214a0e1 lsr      r1, r2, #8
a037fb98 00108de5 str      r1, [sp]
a037fb9c 00109de5 ldr      r1, [sp]
a037fba0 031c81e1 orr      r1, r1, r3, lsl #24
a037fba4 00108de5 str      r1, [sp]
a037fba8 2334a0e1 lsr      r3, r3, #8
a037fbac 04308de5 str      r3, [sp, #4]
a037fbb0 783204e3 movw     r3, #0x4278
a037fbb4 70314ae3 movt     r3, #0xa170
a037fbb8 d000cde1 ldrd     r0, r1, [sp]
a037fbbc f800c3e1 strd     r0, r1, [r3, #8]
a037fbc0 543504e3 movw     r3, #0x4554
a037fbc4 70314ae3 movt     r3, #0xa170
a037fbc8 003093e5 ldr      r3, [r3]
a037fbcc 840f0ee3 movw     r0, #0xef84
a037fbd0 5f004ae3 movt     r0, #0xa05f
a037fbd4 0310a0e1 mov      r1, r3
a037fbd8 439dfceb bl       #0xa02a70ec
a037fbdc 783204e3 movw     r3, #0x4278
a037fbe0 70314ae3 movt     r3, #0xa170
a037fbe4 d820c3e1 ldrd     r2, r3, [r3, #8]
a037fbe8 0230a0e1 mov      r3, r2
a037fbec c0000fe3 movw     r0, #0xf0c0
a037fbf0 5f004ae3 movt     r0, #0xa05f
a037fbf4 0310a0e1 mov      r1, r3
a037fbf8 3b9dfceb bl       #0xa02a70ec
a037fbfc 883004e3 movw     r3, #0x4088
a037fc00 70314ae3 movt     r3, #0xa170
a037fc04 d001c3e1 ldrd     r0, r1, [r3, #0x10]
a037fc08 543504e3 movw     r3, #0x4554
a037fc0c 70314ae3 movt     r3, #0xa170
a037fc10 043093e5 ldr      r3, [r3, #4]
a037fc14 0320a0e1 mov      r2, r3
a037fc18 0030a0e3 mov      r3, #0
a037fc1c 92010ee0 mul      lr, r2, r1
a037fc20 90030ce0 mul      ip, r0, r3
a037fc24 0cc08ee0 add      ip, lr, ip
a037fc28 902283e0 umull    r2, r3, r0, r2
a037fc2c 03108ce0 add      r1, ip, r3
a037fc30 0130a0e1 mov      r3, r1
a037fc34 0200a0e1 mov      r0, r2
a037fc38 0310a0e1 mov      r1, r3
a037fc3c 6420a0e3 mov      r2, #0x64
a037fc40 0030a0e3 mov      r3, #0
a037fc44 bb1c06fa blx      #0xa0506f38
a037fc48 0020a0e1 mov      r2, r0
a037fc4c 0130a0e1 mov      r3, r1
a037fc50 0200a0e1 mov      r0, r2
a037fc54 0310a0e1 mov      r1, r3
a037fc58 783204e3 movw     r3, #0x4278
a037fc5c 70314ae3 movt     r3, #0xa170
a037fc60 f001c3e1 strd     r0, r1, [r3, #0x10]
a037fc64 783204e3 movw     r3, #0x4278
a037fc68 70314ae3 movt     r3, #0xa170
a037fc6c d021c3e1 ldrd     r2, r3, [r3, #0x10]
a037fc70 2214a0e1 lsr      r1, r2, #8
a037fc74 08108de5 str      r1, [sp, #8]
a037fc78 08109de5 ldr      r1, [sp, #8]
a037fc7c 031c81e1 orr      r1, r1, r3, lsl #24
a037fc80 08108de5 str      r1, [sp, #8]
a037fc84 2334a0e1 lsr      r3, r3, #8
a037fc88 0c308de5 str      r3, [sp, #0xc]
a037fc8c 783204e3 movw     r3, #0x4278
a037fc90 70314ae3 movt     r3, #0xa170
a037fc94 d800cde1 ldrd     r0, r1, [sp, #8]
a037fc98 f001c3e1 strd     r0, r1, [r3, #0x10]
a037fc9c 543504e3 movw     r3, #0x4554
a037fca0 70314ae3 movt     r3, #0xa170
a037fca4 043093e5 ldr      r3, [r3, #4]
a037fca8 9c0f0ee3 movw     r0, #0xef9c
a037fcac 5f004ae3 movt     r0, #0xa05f
a037fcb0 0310a0e1 mov      r1, r3
a037fcb4 0c9dfceb bl       #0xa02a70ec
a037fcb8 783204e3 movw     r3, #0x4278
a037fcbc 70314ae3 movt     r3, #0xa170
a037fcc0 d021c3e1 ldrd     r2, r3, [r3, #0x10]
a037fcc4 0230a0e1 mov      r3, r2
a037fcc8 e0000fe3 movw     r0, #0xf0e0
a037fccc 5f004ae3 movt     r0, #0xa05f
a037fcd0 0310a0e1 mov      r1, r3
a037fcd4 049dfceb bl       #0xa02a70ec
a037fcd8 543504e3 movw     r3, #0x4554
a037fcdc 70314ae3 movt     r3, #0xa170
a037fce0 083093e5 ldr      r3, [r3, #8]
a037fce4 0300a0e1 mov      r0, r3
a037fce8 0010a0e3 mov      r1, #0
a037fcec 0020a0e1 mov      r2, r0
a037fcf0 0130a0e1 mov      r3, r1
a037fcf4 022092e0 adds     r2, r2, r2
a037fcf8 0330a3e0 adc      r3, r3, r3
a037fcfc 002092e0 adds     r2, r2, r0
a037fd00 0130a3e0 adc      r3, r3, r1
a037fd04 83c1a0e1 lsl      ip, r3, #3
a037fd08 1cc08de5 str      ip, [sp, #0x1c]
a037fd0c 1cc09de5 ldr      ip, [sp, #0x1c]
a037fd10 a2ce8ce1 orr      ip, ip, r2, lsr #29
a037fd14 1cc08de5 str      ip, [sp, #0x1c]
a037fd18 8231a0e1 lsl      r3, r2, #3
a037fd1c 18308de5 str      r3, [sp, #0x18]
a037fd20 d821cde1 ldrd     r2, r3, [sp, #0x18]
a037fd24 002092e0 adds     r2, r2, r0
a037fd28 0130a3e0 adc      r3, r3, r1
a037fd2c 03b2a0e1 lsl      fp, r3, #4
a037fd30 22be8be1 orr      fp, fp, r2, lsr #28
a037fd34 02a2a0e1 lsl      sl, r2, #4
a037fd38 02a05ae0 subs     sl, sl, r2
a037fd3c 03b0cbe0 sbc      fp, fp, r3
a037fd40 0b32a0e1 lsl      r3, fp, #4
a037fd44 24308de5 str      r3, [sp, #0x24]
a037fd48 24309de5 ldr      r3, [sp, #0x24]
a037fd4c 2a3e83e1 orr      r3, r3, sl, lsr #28
a037fd50 24308de5 str      r3, [sp, #0x24]
a037fd54 0a32a0e1 lsl      r3, sl, #4
a037fd58 20308de5 str      r3, [sp, #0x20]
a037fd5c d022cde1 ldrd     r2, r3, [sp, #0x20]
a037fd60 0a2052e0 subs     r2, r2, sl
a037fd64 0b30c3e0 sbc      r3, r3, fp
a037fd68 0310a0e1 mov      r1, r3
a037fd6c 8112a0e1 lsl      r1, r1, #5
a037fd70 2c108de5 str      r1, [sp, #0x2c]
a037fd74 2c109de5 ldr      r1, [sp, #0x2c]
a037fd78 0200a0e1 mov      r0, r2
a037fd7c a01d81e1 orr      r1, r1, r0, lsr #27
a037fd80 2c108de5 str      r1, [sp, #0x2c]
a037fd84 0230a0e1 mov      r3, r2
a037fd88 8332a0e1 lsl      r3, r3, #5
a037fd8c 28308de5 str      r3, [sp, #0x28]
a037fd90 d822cde1 ldrd     r2, r3, [sp, #0x28]
a037fd94 0200a0e1 mov      r0, r2
a037fd98 0310a0e1 mov      r1, r3
a037fd9c 783204e3 movw     r3, #0x4278
a037fda0 70314ae3 movt     r3, #0xa170
a037fda4 f801c3e1 strd     r0, r1, [r3, #0x18]
a037fda8 883004e3 movw     r3, #0x4088
a037fdac 70314ae3 movt     r3, #0xa170
a037fdb0 d000c3e1 ldrd     r0, r1, [r3]
a037fdb4 783204e3 movw     r3, #0x4278
a037fdb8 70314ae3 movt     r3, #0xa170
a037fdbc f000c3e1 strd     r0, r1, [r3]
a037fdc0 543504e3 movw     r3, #0x4554
a037fdc4 70314ae3 movt     r3, #0xa170
a037fdc8 083093e5 ldr      r3, [r3, #8]
a037fdcc 00010fe3 movw     r0, #0xf100
a037fdd0 5f004ae3 movt     r0, #0xa05f
a037fdd4 0310a0e1 mov      r1, r3
a037fdd8 c39cfceb bl       #0xa02a70ec
a037fddc 783204e3 movw     r3, #0x4278
a037fde0 70314ae3 movt     r3, #0xa170
a037fde4 d821c3e1 ldrd     r2, r3, [r3, #0x18]
a037fde8 0210a0e1 mov      r1, r2
a037fdec 783204e3 movw     r3, #0x4278
a037fdf0 70314ae3 movt     r3, #0xa170
a037fdf4 d020c3e1 ldrd     r2, r3, [r3]
a037fdf8 0230a0e1 mov      r3, r2
a037fdfc 18010fe3 movw     r0, #0xf118
a037fe00 5f004ae3 movt     r0, #0xa05f
a037fe04 0320a0e1 mov      r2, r3
a037fe08 b79cfceb bl       #0xa02a70ec
a037fe0c 58010fe3 movw     r0, #0xf158
a037fe10 5f004ae3 movt     r0, #0xa05f
a037fe14 b49cfceb bl       #0xa02a70ec
a037fe18 34d08de2 add      sp, sp, #0x34
a037fe1c f08fbde8 pop      {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a037fe20 04e02de5 str      lr, [sp, #-4]!
a037fe24 fcd04de2 sub      sp, sp, #0xfc
a037fe28 0030a0e3 mov      r3, #0
a037fe2c e8308de5 str      r3, [sp, #0xe8]
a037fe30 cc308de2 add      r3, sp, #0xcc
a037fe34 0020a0e3 mov      r2, #0
a037fe38 002083e5 str      r2, [r3]
a037fe3c 043083e2 add      r3, r3, #4
a037fe40 0020a0e3 mov      r2, #0
a037fe44 002083e5 str      r2, [r3]
a037fe48 043083e2 add      r3, r3, #4
a037fe4c 0020a0e3 mov      r2, #0
a037fe50 002083e5 str      r2, [r3]
a037fe54 043083e2 add      r3, r3, #4
a037fe58 0030a0e3 mov      r3, #0
a037fe5c ce30cde5 strb     r3, [sp, #0xce]
a037fe60 0030a0e3 mov      r3, #0
a037fe64 cc30cde5 strb     r3, [sp, #0xcc]
a037fe68 0030a0e3 mov      r3, #0
a037fe6c d0308de5 str      r3, [sp, #0xd0]
a037fe70 0130a0e3 mov      r3, #1
a037fe74 cd30cde5 strb     r3, [sp, #0xcd]
a037fe78 0030a0e3 mov      r3, #0
a037fe7c ba3ccde1 strh     r3, [sp, #0xca]
a037fe80 ca30dde5 ldrb     r3, [sp, #0xca]
a037fe84 0120a0e3 mov      r2, #1
a037fe88 1231c7e7 bfi      r3, r2, #2, #6
a037fe8c ca30cde5 strb     r3, [sp, #0xca]
a037fe90 08308de2 add      r3, sp, #8
a037fe94 c020a0e3 mov      r2, #0xc0
a037fe98 0300a0e1 mov      r0, r3
a037fe9c 0010a0e3 mov      r1, #0
a037fea0 d1e305fa blx      #0xa04f8dec
a037fea4 8c010fe3 movw     r0, #0xf18c
a037fea8 5f004ae3 movt     r0, #0xa05f
a037feac 8e9cfceb bl       #0xa02a70ec
a037feb0 ca30dde5 ldrb     r3, [sp, #0xca]
a037feb4 5330e1e7 ubfx     r3, r3, #0, #2
a037feb8 7330efe6 uxtb     r3, r3
a037febc 0320a0e1 mov      r2, r3
a037fec0 203f00e3 movw     r3, #0xf20
a037fec4 a3314ae3 movt     r3, #0xa1a3
a037fec8 023193e7 ldr      r3, [r3, r2, lsl #2]
a037fecc 203093e5 ldr      r3, [r3, #0x20]
a037fed0 000053e3 cmp      r3, #0
a037fed4 0b00000a beq      #0xa037ff08
a037fed8 ca30dde5 ldrb     r3, [sp, #0xca]
a037fedc 5330e1e7 ubfx     r3, r3, #0, #2
a037fee0 7330efe6 uxtb     r3, r3
a037fee4 0320a0e1 mov      r2, r3
a037fee8 203f00e3 movw     r3, #0xf20
a037feec a3314ae3 movt     r3, #0xa1a3
a037fef0 023193e7 ldr      r3, [r3, r2, lsl #2]
a037fef4 203093e5 ldr      r3, [r3, #0x20]
a037fef8 ba0cdde1 ldrh     r0, [sp, #0xca]
a037fefc 501004e3 movw     r1, #0x4050
a037ff00 70114ae3 movt     r1, #0xa170
a037ff04 33ff2fe1 blx      r3
a037ff08 cc308de2 add      r3, sp, #0xcc
a037ff0c 0300a0e1 mov      r0, r3
a037ff10 641504e3 movw     r1, #0x4564
a037ff14 70114ae3 movt     r1, #0xa170
a037ff18 4468fdeb bl       #0xa02da030
a037ff1c ca30dde5 ldrb     r3, [sp, #0xca]
a037ff20 5330e1e7 ubfx     r3, r3, #0, #2
a037ff24 7330efe6 uxtb     r3, r3
a037ff28 0320a0e1 mov      r2, r3
a037ff2c 203f00e3 movw     r3, #0xf20
a037ff30 a3314ae3 movt     r3, #0xa1a3
a037ff34 023193e7 ldr      r3, [r3, r2, lsl #2]
a037ff38 183093e5 ldr      r3, [r3, #0x18]
a037ff3c 000053e3 cmp      r3, #0
a037ff40 0b00000a beq      #0xa037ff74
a037ff44 ca30dde5 ldrb     r3, [sp, #0xca]
a037ff48 5330e1e7 ubfx     r3, r3, #0, #2
a037ff4c 7330efe6 uxtb     r3, r3
a037ff50 0320a0e1 mov      r2, r3
a037ff54 203f00e3 movw     r3, #0xf20
a037ff58 a3314ae3 movt     r3, #0xa1a3
a037ff5c 023193e7 ldr      r3, [r3, r2, lsl #2]
a037ff60 183093e5 ldr      r3, [r3, #0x18]
a037ff64 ba0cdde1 ldrh     r0, [sp, #0xca]
a037ff68 281104e3 movw     r1, #0x4128
a037ff6c 70114ae3 movt     r1, #0xa170
a037ff70 33ff2fe1 blx      r3
a037ff74 cc208de2 add      r2, sp, #0xcc
a037ff78 08308de2 add      r3, sp, #8
a037ff7c 0200a0e1 mov      r0, r2
a037ff80 0310a0e1 mov      r1, r3
a037ff84 284afeeb bl       #0xa031282c
a037ff88 cc308de2 add      r3, sp, #0xcc
a037ff8c 0300a0e1 mov      r0, r3
a037ff90 001404e3 movw     r1, #0x4400
a037ff94 70114ae3 movt     r1, #0xa170
a037ff98 5268fdeb bl       #0xa02da0e8
a037ff9c 503004e3 movw     r3, #0x4050
a037ffa0 70314ae3 movt     r3, #0xa170
a037ffa4 007ad3ed vldr     s15, [r3]
a037ffa8 787a9fed vldr     s14, [pc, #0x1e0]
a037ffac 877a67ee vmul.f32 s15, s15, s14
a037ffb0 e77afcee vcvt.u32.f32 s15, s15
a037ffb4 903a17ee vmov     r3, s15
a037ffb8 0324a0e1 lsl      r2, r3, #8
a037ffbc 883004e3 movw     r3, #0x4088
a037ffc0 70314ae3 movt     r3, #0xa170
a037ffc4 202083e5 str      r2, [r3, #0x20]
a037ffc8 503004e3 movw     r3, #0x4050
a037ffcc 70314ae3 movt     r3, #0xa170
a037ffd0 017ad3ed vldr     s15, [r3, #4]
a037ffd4 6d7a9fed vldr     s14, [pc, #0x1b4]
a037ffd8 877a67ee vmul.f32 s15, s15, s14
a037ffdc e77afcee vcvt.u32.f32 s15, s15
a037ffe0 903a17ee vmov     r3, s15
a037ffe4 0324a0e1 lsl      r2, r3, #8
a037ffe8 883004e3 movw     r3, #0x4088
a037ffec 70314ae3 movt     r3, #0xa170
a037fff0 242083e5 str      r2, [r3, #0x24]
a037fff4 703a07e3 movw     r3, #0x7a70
a037fff8 75304ae3 movt     r3, #0xa075
a037fffc 002093e5 ldr      r2, [r3]
a0380000 743a07e3 movw     r3, #0x7a74
a0380004 75304ae3 movt     r3, #0xa075
a0380008 003093e5 ldr      r3, [r3]
a038000c 030052e1 cmp      r2, r3
a0380010 0500002a bhs      #0xa038002c
a0380014 743a07e3 movw     r3, #0x7a74
a0380018 75304ae3 movt     r3, #0xa075
a038001c 002093e5 ldr      r2, [r3]
a0380020 703a07e3 movw     r3, #0x7a70
a0380024 75304ae3 movt     r3, #0xa075
a0380028 002083e5 str      r2, [r3]
a038002c 283104e3 movw     r3, #0x4128
a0380030 70314ae3 movt     r3, #0xa170
a0380034 643093e5 ldr      r3, [r3, #0x64]
a0380038 903a07ee vmov     s15, r3
a038003c 671bf8ee vcvt.f64.u32 d17, s15
a0380040 283104e3 movw     r3, #0x4128
a0380044 70314ae3 movt     r3, #0xa170
a0380048 682093e5 ldr      r2, [r3, #0x68]
a038004c 283104e3 movw     r3, #0x4128
a0380050 70314ae3 movt     r3, #0xa170
a0380054 6030d3e5 ldrb     r3, [r3, #0x60]
a0380058 013083e2 add      r3, r3, #1
a038005c 930203e0 mul      r3, r3, r2
a0380060 903a07ee vmov     s15, r3
a0380064 670bf8ee vcvt.f64.u32 d16, s15
a0380068 a00bc1ee vdiv.f64 d16, d17, d16
a038006c 451bdfed vldr     d17, [pc, #0x114]
a0380070 a10b70ee vadd.f64 d16, d16, d17
a0380074 607bb0ee vmov.f64 d7, d16
a0380078 c77bfcee vcvt.u32.f64 s15, d7
a038007c 902a17ee vmov     r2, s15
a0380080 b43004e3 movw     r3, #0x40b4
a0380084 70314ae3 movt     r3, #0xa170
a0380088 002083e5 str      r2, [r3]
a038008c b43004e3 movw     r3, #0x40b4
a0380090 70314ae3 movt     r3, #0xa170
a0380094 003093e5 ldr      r3, [r3]
a0380098 fa0fa0e3 mov      r0, #0x3e8
a038009c 0310a0e1 mov      r1, r3
a03800a0 dc1806fa blx      #0xa0506418
a03800a4 0030a0e1 mov      r3, r0
a03800a8 7330efe6 uxtb     r3, r3
a03800ac 013083e2 add      r3, r3, #1
a03800b0 7320efe6 uxtb     r2, r3
a03800b4 503c02e3 movw     r3, #0x2c50
a03800b8 70314ae3 movt     r3, #0xa170
a03800bc 0020c3e5 strb     r2, [r3]
a03800c0 b43004e3 movw     r3, #0x40b4
a03800c4 70314ae3 movt     r3, #0xa170
a03800c8 003093e5 ldr      r3, [r3]
a03800cc b4010fe3 movw     r0, #0xf1b4
a03800d0 5f004ae3 movt     r0, #0xa05f
a03800d4 0310a0e1 mov      r1, r3
a03800d8 039cfceb bl       #0xa02a70ec
a03800dc 503c02e3 movw     r3, #0x2c50
a03800e0 70314ae3 movt     r3, #0xa170
a03800e4 0030d3e5 ldrb     r3, [r3]
a03800e8 c8010fe3 movw     r0, #0xf1c8
a03800ec 5f004ae3 movt     r0, #0xa05f
a03800f0 0310a0e1 mov      r1, r3
a03800f4 fc9bfceb bl       #0xa02a70ec
a03800f8 643504e3 movw     r3, #0x4564
a03800fc 70314ae3 movt     r3, #0xa170
a0380100 382093e5 ldr      r2, [r3, #0x38]
a0380104 b83004e3 movw     r3, #0x40b8
a0380108 70314ae3 movt     r3, #0xa170
a038010c 002083e5 str      r2, [r3]
a0380110 643504e3 movw     r3, #0x4564
a0380114 70314ae3 movt     r3, #0xa170
a0380118 3c2093e5 ldr      r2, [r3, #0x3c]
a038011c bc3004e3 movw     r3, #0x40bc
a0380120 70314ae3 movt     r3, #0xa170
a0380124 002083e5 str      r2, [r3]
a0380128 283104e3 movw     r3, #0x4128
a038012c 70314ae3 movt     r3, #0xa170
a0380130 3220d3e5 ldrb     r2, [r3, #0x32]
a0380134 283104e3 movw     r3, #0x4128
a0380138 70314ae3 movt     r3, #0xa170
a038013c 3530d3e5 ldrb     r3, [r3, #0x35]
a0380140 030052e1 cmp      r2, r3
a0380144 1b00001a bne      #0xa03801b8
a0380148 283104e3 movw     r3, #0x4128
a038014c 70314ae3 movt     r3, #0xa170
a0380150 3230d3e5 ldrb     r3, [r3, #0x32]
a0380154 f4308de5 str      r3, [sp, #0xf4]
a0380158 283104e3 movw     r3, #0x4128
a038015c 70314ae3 movt     r3, #0xa170
a0380160 3130d3e5 ldrb     r3, [r3, #0x31]
a0380164 f0308de5 str      r3, [sp, #0xf0]
a0380168 f0309de5 ldr      r3, [sp, #0xf0]
a038016c 0324a0e1 lsl      r2, r3, #8
a0380170 283104e3 movw     r3, #0x4128
a0380174 70314ae3 movt     r3, #0xa170
a0380178 3430d3e5 ldrb     r3, [r3, #0x34]
a038017c 033082e1 orr      r3, r2, r3
a0380180 f0308de5 str      r3, [sp, #0xf0]
a0380184 290000ea b        #0xa0380230
a0380188 e90b21e7 str      r0, [r1, -sb, ror #23]!
a038018c fdffef3f svclo    #0xeffffd
a0380190 0000c842 sbcmi    r0, r8, #0
a0380194 242f70a1 cmnge    r0, r4, lsr #30
a0380198 483170a1 cmnge    r0, r8, asr #2
a038019c 6c3370a1 cmnge    r0, ip, ror #6
