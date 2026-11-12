a03cfbd8 4ff07ff5 dsb sy
a03cfbdc 0030a0e3 mov r3, #0
a03cfbe0 173f08ee mcr p15, #0, r3, c8, c7, #0
a03cfbe4 163f08ee mcr p15, #0, r3, c8, c6, #0
a03cfbe8 153f08ee mcr p15, #0, r3, c8, c5, #0
a03cfbec 133f08ee mcr p15, #0, r3, c8, c3, #0
a03cfbf0 4ff07ff5 dsb sy
a03cfbf4 6ff07ff5 isb sy
a03cfbf8 1eff2fe1 bx lr
a03cfbfc 3c3401e3 movw r3, #0x143c
a03cfc00 7e314ae3 movt r3, #0xa17e
a03cfc04 003093e5 ldr r3, [r3]
a03cfc08 13ff2fe1 bx r3
