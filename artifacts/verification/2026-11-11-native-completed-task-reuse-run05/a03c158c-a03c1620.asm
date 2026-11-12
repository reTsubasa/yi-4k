a03c158c 102090e5 ldr r2, [r0, #0x10]
a03c1590 0720c2e3 bic r2, r2, #7
a03c1594 4c2042e2 sub r2, r2, #0x4c
a03c1598 0130a0e3 mov r3, #1
a03c159c 003082e5 str r3, [r2]
a03c15a0 0030a0e3 mov r3, #0
a03c15a4 083082e5 str r3, [r2, #8]
a03c15a8 0c3082e5 str r3, [r2, #0xc]
a03c15ac 103082e5 str r3, [r2, #0x10]
a03c15b0 143082e5 str r3, [r2, #0x14]
a03c15b4 183082e5 str r3, [r2, #0x18]
a03c15b8 1c3082e5 str r3, [r2, #0x1c]
a03c15bc 203082e5 str r3, [r2, #0x20]
a03c15c0 243082e5 str r3, [r2, #0x24]
a03c15c4 283082e5 str r3, [r2, #0x28]
a03c15c8 2c3082e5 str r3, [r2, #0x2c]
a03c15cc 0c3090e5 ldr r3, [r0, #0xc]
a03c15d0 303082e5 str r3, [r2, #0x30]
a03c15d4 0030a0e3 mov r3, #0
a03c15d8 343082e5 str r3, [r2, #0x34]
a03c15dc 383082e5 str r3, [r2, #0x38]
a03c15e0 3c3082e5 str r3, [r2, #0x3c]
a03c15e4 401082e5 str r1, [r2, #0x40]
a03c15e8 443082e5 str r3, [r2, #0x44]
a03c15ec 00100fe1 mrs r1, apsr
a03c15f0 df10c1e3 bic r1, r1, #0xdf
a03c15f4 133081e3 orr r3, r1, #0x13
a03c15f8 2030c3e3 bic r3, r3, #0x20
a03c15fc 011001e2 and r1, r1, #1
a03c1600 010051e3 cmp r1, #1
a03c1604 20308303 orreq r3, r3, #0x20
a03c1608 043082e5 str r3, [r2, #4]
a03c160c 082080e5 str r2, [r0, #8]
a03c1610 982090e5 ldr r2, [r0, #0x98]
a03c1614 022982e3 orr r2, r2, #0x8000
a03c1618 982080e5 str r2, [r0, #0x98]
a03c161c 1eff2fe1 bx lr
