; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a03cd3f0 020050e3 cmp      r0, #2
a03cd3f4 f8402de9 push     {r3, r4, r5, r6, r7, lr}
a03cd3f8 0150a0e1 mov      r5, r1
a03cd3fc 0260a0e1 mov      r6, r2
a03cd400 0500000a beq      #0xa03cd41c
a03cd404 e80d0ee3 movw     r0, #0xede8
a03cd408 001095e5 ldr      r1, [r5]
a03cd40c 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060ede8 'Usage: t %s <command>, where command is:\n\tload\n\tboot\n'
a03cd410 36ff2fe1 blx      r6
a03cd414 0000e0e3 mvn      r0, #0
a03cd418 f880bde8 pop      {r3, r4, r5, r6, r7, pc}
a03cd41c 044091e5 ldr      r4, [r1, #4]
a03cd420 e41c0ce3 movw     r1, #0xcce4
a03cd424 57104ae3 movt     r1, #0xa057 ; heuristic 0xa057cce4 'load'
a03cd428 0400a0e1 mov      r0, r4
a03cd42c c4b004fa blx      #0xa04f9744
a03cd430 007050e2 subs     r7, r0, #0
a03cd434 0800000a beq      #0xa03cd45c
a03cd438 e01d0ee3 movw     r1, #0xede0
a03cd43c 0400a0e1 mov      r0, r4
a03cd440 60104ae3 movt     r1, #0xa060 ; heuristic 0xa060ede0 'boot'
a03cd444 beb004fa blx      #0xa04f9744
a03cd448 000050e3 cmp      r0, #0
a03cd44c ecffff1a bne      #0xa03cd404
a03cd450 880301e3 movw     r0, #0x1388
a03cd454 f840bde8 pop      {r3, r4, r5, r6, r7, lr}
a03cd458 af0700ea b        #0xa03cf31c
a03cd45c d4ffffeb bl       #0xa03cd3b4
a03cd460 0700a0e1 mov      r0, r7
a03cd464 f880bde8 pop      {r3, r4, r5, r6, r7, pc}
a03cd468 ab0700ea b        #0xa03cf31c
a03cd46c 10402de9 push     {r4, lr}
a03cd470 b04205e3 movw     r4, #0x52b0
a03cd474 44414ae3 movt     r4, #0xa144
a03cd478 200e0ee3 movw     r0, #0xee20
a03cd47c 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060ee20 'AmbaLink: SpinLock 0x%08x, 0x%08x'
a03cd480 3c2094e5 ldr      r2, [r4, #0x3c]
a03cd484 381094e5 ldr      r1, [r4, #0x38]
a03cd488 1767fbeb bl       #0xa02a70ec
a03cd48c 440e0ee3 movw     r0, #0xee44
a03cd490 401094e5 ldr      r1, [r4, #0x40]
a03cd494 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060ee44 'AmbaLink: Mutex    0x%08x'
a03cd498 1367fbeb bl       #0xa02a70ec
a03cd49c 742094e5 ldr      r2, [r4, #0x74]
a03cd4a0 000052e3 cmp      r2, #0
a03cd4a4 2100000a beq      #0xa03cd530
a03cd4a8 180100e3 movw     r0, #0x118
a03cd4ac 4c3100e3 movw     r3, #0x14c
a03cd4b0 7e014ae3 movt     r0, #0xa17e
a03cd4b4 7e314ae3 movt     r3, #0xa17e
a03cd4b8 001090e5 ldr      r1, [r0]
a03cd4bc 002083e5 str      r2, [r3]
a03cd4c0 000051e3 cmp      r1, #0
a03cd4c4 0a00000a beq      #0xa03cd4f4
a03cd4c8 0000a0e3 mov      r0, #0
a03cd4cc 2e0700eb bl       #0xa03cf18c
a03cd4d0 002050e2 subs     r2, r0, #0
a03cd4d4 0f00001a bne      #0xa03cd518
a03cd4d8 e342fbeb bl       #0xa029e06c
a03cd4dc 700d0ee3 movw     r0, #0xed70
a03cd4e0 f0130de3 movw     r1, #0xd3f0
a03cd4e4 60004ae3 movt     r0, #0xa060 ; heuristic 0xa060ed70 'ambalink'
a03cd4e8 3c104ae3 movt     r1, #0xa03c
a03cd4ec 1040bde8 pop      {r4, lr}
a03cd4f0 e842fbea b        #0xa029e098
a03cd4f4 e8bbffeb bl       #0xa03bc49c
a03cd4f8 000050e3 cmp      r0, #0
a03cd4fc f1ffff0a beq      #0xa03cd4c8
