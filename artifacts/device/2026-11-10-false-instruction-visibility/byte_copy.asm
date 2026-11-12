a033a6c4 013080e1 orr r3, r0, r1
a033a6c8 10402de9 push {r4, lr}
a033a6cc 030013e3 tst r3, #3
a033a6d0 1000001a bne #0xa033a718
a033a6d4 030052e3 cmp r2, #3
a033a6d8 04e04082 subhi lr, r0, #4
a033a6dc 01c0a081 movhi ip, r1
a033a6e0 0230a081 movhi r3, r2
a033a6e4 0b00009a bls #0xa033a718
a033a6e8 043043e2 sub r3, r3, #4
a033a6ec 04409ce4 ldr r4, [ip], #4
a033a6f0 030053e3 cmp r3, #3
a033a6f4 0440aee5 str r4, [lr, #4]!
a033a6f8 faffff8a bhi #0xa033a6e8
a033a6fc 043042e2 sub r3, r2, #4
a033a700 032002e2 and r2, r2, #3
a033a704 0330c3e3 bic r3, r3, #3
a033a708 043083e2 add r3, r3, #4
a033a70c 031081e0 add r1, r1, r3
a033a710 033080e0 add r3, r0, r3
a033a714 000000ea b #0xa033a71c
a033a718 0030a0e1 mov r3, r0
a033a71c 000052e3 cmp r2, #0
a033a720 01304312 subne r3, r3, #1
a033a724 02208110 addne r2, r1, r2
a033a728 0400000a beq #0xa033a740
a033a72c 01c0d1e4 ldrb ip, [r1], #1
a033a730 020051e1 cmp r1, r2
a033a734 01c0e3e5 strb ip, [r3, #1]!
a033a738 fbffff1a bne #0xa033a72c
a033a73c 1080bde8 pop {r4, pc}
