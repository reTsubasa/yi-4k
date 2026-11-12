001a15d4: 9de4ffff  l.addi r15,r4,-1
001a15d8: fc606001  .word (unsupported encoding)
001a15dc: a62f0003  l.andi r17,r15,0x3
001a15e0: bc110000  l.sfeqi r17,0
001a15e4: 0c000002  l.bnf 0x1a15ec
001a15e8: f0000049  .word (unsupported encoding)
001a15ec: e40f0000  l.sfeq r15,r0
001a15f0: 9defffff  l.addi r15,r15,-1
001a15f4: 0ffffff9  l.bnf 0x1a15d8
001a15f8: 15000000  l.nop 0x0
001a15fc: fc600008  .word (unsupported encoding)
001a1600: f0000049  .word (unsupported encoding)
001a1604: 44004800  l.jr r9
