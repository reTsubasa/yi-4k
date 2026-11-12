a048ec20 000050e3 cmp r0, #0
a048ec24 1100000a beq #0xa048ec70
a048ec28 10402de9 push {r4, lr}
a048ec2c 0040a0e1 mov r4, r0
a048ec30 640409e3 movw r0, #0x9464
a048ec34 0010e0e3 mvn r1, #0
a048ec38 a3014ae3 movt r0, #0xa1a3
a048ec3c 0ab6fceb bl #0xa03bc46c
a048ec40 000050e3 cmp r0, #0
a048ec44 0700001a bne #0xa048ec68
a048ec48 0400a0e1 mov r0, r4
a048ec4c f12200eb bl #0xa0497818
a048ec50 0040a0e1 mov r4, r0
a048ec54 640409e3 movw r0, #0x9464
a048ec58 a3014ae3 movt r0, #0xa1a3
a048ec5c 0db6fceb bl #0xa03bc498
a048ec60 0400a0e1 mov r0, r4
a048ec64 1080bde8 pop {r4, pc}
a048ec68 0000e0e3 mvn r0, #0
a048ec6c 1080bde8 pop {r4, pc}
a048ec70 0000e0e3 mvn r0, #0
a048ec74 1eff2fe1 bx lr
a048ec78 242300ea b #0xa0497910
a048ec7c 640409e3 movw r0, #0x9464
a048ec80 10402de9 push {r4, lr}
a048ec84 0010a0e3 mov r1, #0
a048ec88 a3014ae3 movt r0, #0xa1a3
a048ec8c f6b5fceb bl #0xa03bc46c
a048ec90 004050e2 subs r4, r0, #0
a048ec94 0500001a bne #0xa048ecb0
a048ec98 222300eb bl #0xa0497928
a048ec9c 640409e3 movw r0, #0x9464
a048eca0 a3014ae3 movt r0, #0xa1a3
a048eca4 fbb5fceb bl #0xa03bc498
a048eca8 0400a0e1 mov r0, r4
a048ecac 1080bde8 pop {r4, pc}
a048ecb0 0040e0e3 mvn r4, #0
a048ecb4 fbffffea b #0xa048eca8
