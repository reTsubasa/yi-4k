WINDOW 0xa0394b90
a0394b90 mov      r3, r6
a0394b94 bl       #0xa02a70ec
a0394b98 add      sp, sp, #0x74
a0394b9c pop      {r4, r5, r6, r7, r8, sb, pc}
a0394ba0 mov      r0, r3
a0394ba4 bx       lr
a0394ba8 str      lr, [sp, #-4]!
a0394bac sub      sp, sp, #0xc
a0394bb0 str      r0, [sp, #4]
a0394bb4 str      r1, [sp]
a0394bb8 ldr      r3, [sp, #4]
a0394bbc cmp      r3, #2
a0394bc0 beq      #0xa0394c14
a0394bc4 cmp      r3, #3
a0394bc8 beq      #0xa0394c54
a0394bcc cmp      r3, #1
WINDOW 0xa0383740
a0383740 sub      sp, sp, #8
a0383744 mov      r3, r0
a0383748 mov      r2, r1
a038374c strb     r3, [sp, #7]
a0383750 mov      r3, r2
a0383754 strb     r3, [sp, #6]
a0383758 movw     r3, #0x4044
a038375c movt     r3, #0xa170
a0383760 ldrb     r2, [sp, #7]
a0383764 strb     r2, [r3, #0xa]
a0383768 movw     r3, #0x4044
a038376c movt     r3, #0xa170
