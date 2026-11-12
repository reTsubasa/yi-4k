a03cffac 032082e1 orr r2, r2, r3
a03cffb0 02f021e1 msr cpsr_c, r2
a03cffb4 14009de5 ldr r0, [sp, #0x14]
a03cffb8 0160a0e3 mov r6, #1
a03cffbc 02b1ffeb bl #0xa03bc3cc
a03cffc0 3c3401e3 movw r3, #0x143c
a03cffc4 d8cb0fe3 movw ip, #0xfbd8
a03cffc8 3cc04ae3 movt ip, #0xa03c
a03cffcc 7e314ae3 movt r3, #0xa17e
a03cffd0 0420a0e1 mov r2, r4
a03cffd4 0110a0e3 mov r1, #1
a03cffd8 5400a0e3 mov r0, #0x54
a03cffdc 00c083e5 str ip, [r3]
a03cffe0 d5cb02eb bl #0xa0482f3c
a03cffe4 0420a0e1 mov r2, r4
a03cffe8 0410a0e1 mov r1, r4
a03cffec 5200a0e3 mov r0, #0x52
