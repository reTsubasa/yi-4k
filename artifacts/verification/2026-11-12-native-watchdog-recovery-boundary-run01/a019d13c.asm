a019d13c 783401e3 movw r3, #0x1478
a019d140 04e02de5 str lr, [sp, #-4]!
a019d144 56304ae3 movt r3, #0xa056
a019d148 14d04de2 sub sp, sp, #0x14
a019d14c 04c08de2 add ip, sp, #4
a019d150 070093e8 ldm r3, {r0, r1, r2}
a019d154 07008ce8 stm ip, {r0, r1, r2}
a019d158 0c00a0e1 mov r0, ip
a019d15c afc60beb bl #0xa048ec20
a019d160 14d08de2 add sp, sp, #0x14
a019d164 04f09de4 pop {pc}
a019d168 08402de9 push {r3, lr}
a019d16c 85e0ffeb bl #0xa0195388
a019d170 000050e3 cmp r0, #0
a019d174 0880bd08 popeq {r3, pc}
a019d178 bfc60beb bl #0xa048ec7c
a019d17c 580a01e3 movw r0, #0x1a58
a019d180 942304e3 movw r2, #0x4394
a019d184 56004ae3 movt r0, #0xa056
a019d188 56204ae3 movt r2, #0xa056
a019d18c 321500e3 movw r1, #0x532
a019d190 0840bde8 pop {r3, lr}
a019d194 d42704ea b #0xa02a70ec
a019d198 10402de9 push {r4, lr}
a019d19c 79e0ffeb bl #0xa0195388
a019d1a0 004050e2 subs r4, r0, #0
a019d1a4 0b00000a beq #0xa019d1d8
a019d1a8 99c60beb bl #0xa048ec14
a019d1ac e2ffffeb bl #0xa019d13c
a019d1b0 bc130ce3 movw r1, #0xc3bc
a019d1b4 0700a0e3 mov r0, #7
a019d1b8 19104ae3 movt r1, #0xa019
a019d1bc 422601eb bl #0xa01e6acc
a019d1c0 580a01e3 movw r0, #0x1a58
a019d1c4 482304e3 movw r2, #0x4348
a019d1c8 56004ae3 movt r0, #0xa056
a019d1cc 56204ae3 movt r2, #0xa056
a019d1d0 4a1500e3 movw r1, #0x54a
a019d1d4 c42704eb bl #0xa02a70ec
a019d1d8 0400a0e1 mov r0, r4
a019d1dc 1080bde8 pop {r4, pc}
