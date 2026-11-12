001a156c: 9de4ffff  l.addi r15,r4,-1
001a1570: fc606000  .word (unsupported encoding)
001a1574: a62f0003  l.andi r17,r15,0x3
001a1578: bc110000  l.sfeqi r17,0
001a157c: 0c000002  l.bnf 0x1a1584
001a1580: f0000049  .word (unsupported encoding)
001a1584: e40f0000  l.sfeq r15,r0
001a1588: 9defffff  l.addi r15,r15,-1
001a158c: 0ffffff9  l.bnf 0x1a1570
001a1590: 15000000  l.nop 0x0
001a1594: fc60001c  .word (unsupported encoding)
001a1598: f0000049  .word (unsupported encoding)
001a159c: 44004800  l.jr r9
