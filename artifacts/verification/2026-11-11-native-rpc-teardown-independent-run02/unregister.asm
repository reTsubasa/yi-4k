a03cac1c 082609e3 movw r2, #0x9608
a03cac20 f0402de9 push {r4, r5, r6, r7, lr}
a03cac24 78204ae3 movt r2, #0xa078
a03cac28 1cd04de2 sub sp, sp, #0x1c
a03cac2c 004092e5 ldr r4, [r2]
a03cac30 040052e1 cmp r2, r4
a03cac34 784044e2 sub r4, r4, #0x78
a03cac38 0400001a bne #0xa03cac50
a03cac3c 2c0000ea b #0xa03cacf4
a03cac40 784094e5 ldr r4, [r4, #0x78]
a03cac44 040052e1 cmp r2, r4
a03cac48 784044e2 sub r4, r4, #0x78
a03cac4c 2800000a beq #0xa03cacf4
a03cac50 003094e5 ldr r3, [r4]
a03cac54 030050e1 cmp r0, r3
a03cac58 f8ffff1a bne #0xa03cac40
a03cac5c 043094e5 ldr r3, [r4, #4]
a03cac60 030051e1 cmp r1, r3
a03cac64 f5ffff1a bne #0xa03cac40
a03cac68 000054e3 cmp r4, #0
a03cac6c 0030a0e3 mov r3, #0
a03cac70 0c308de5 str r3, [sp, #0xc]
a03cac74 10308de5 str r3, [sp, #0x10]
a03cac78 14308de5 str r3, [sp, #0x14]
a03cac7c 1c00000a beq #0xa03cacf4
a03cac80 445084e2 add r5, r4, #0x44
a03cac84 0410a0e3 mov r1, #4
a03cac88 0500a0e1 mov r0, r5
a03cac8c 15c6ffeb bl #0xa03bc4e8
a03cac90 446394e5 ldr r6, [r4, #0x344]
a03cac94 000056e3 cmp r6, #0
a03cac98 1800000a beq #0xa03cad00
a03cac9c 0030e0e3 mvn r3, #0
a03caca0 0810a0e3 mov r1, #8
a03caca4 00308de5 str r3, [sp]
a03caca8 0500a0e1 mov r0, r5
a03cacac 01308de0 add r3, sp, r1
a03cacb0 0320a0e3 mov r2, #3
a03cacb4 fcc5ffeb bl #0xa03bc4ac
a03cacb8 443394e5 ldr r3, [r4, #0x344]
a03cacbc 000053e3 cmp r3, #0
a03cacc0 2500001a bne #0xa03cad5c
a03cacc4 783094e5 ldr r3, [r4, #0x78]
a03cacc8 080084e2 add r0, r4, #8
a03caccc 7c2094e5 ldr r2, [r4, #0x7c]
a03cacd0 042083e5 str r2, [r3, #4]
a03cacd4 7c3094e5 ldr r3, [r4, #0x7c]
a03cacd8 782094e5 ldr r2, [r4, #0x78]
a03cacdc 002083e5 str r2, [r3]
a03cace0 eef6ffeb bl #0xa03c88a0
a03cace4 4c0394e5 ldr r0, [r4, #0x34c]
a03cace8 5d0900eb bl #0xa03cd264
a03cacec 0400a0e1 mov r0, r4
a03cacf0 5b0900eb bl #0xa03cd264
a03cacf4 0000a0e3 mov r0, #0
a03cacf8 1cd08de2 add sp, sp, #0x1c
a03cacfc f080bde8 pop {r4, r5, r6, r7, pc}
a03cad00 487b07e3 movw r7, #0x7b48
a03cad04 0010e0e3 mvn r1, #0
a03cad08 79714ae3 movt r7, #0xa179
a03cad0c 000097e5 ldr r0, [r7]
a03cad10 d5c5ffeb bl #0xa03bc46c
a03cad14 000097e5 ldr r0, [r7]
a03cad18 702090e5 ldr r2, [r0, #0x70]
a03cad1c 6c3090e5 ldr r3, [r0, #0x6c]
a03cad20 030052e1 cmp r2, r3
a03cad24 8211a0b1 lsllt r1, r2, #3
a03cad28 090000aa bge #0xa03cad54
a03cad2c 383090e5 ldr r3, [r0, #0x38]
a03cad30 012082e2 add r2, r2, #1
a03cad34 013083e0 add r3, r3, r1
a03cad38 081081e2 add r1, r1, #8
a03cad3c 04c093e5 ldr ip, [r3, #4]
a03cad40 0c0054e1 cmp r4, ip
a03cad44 04608305 streq r6, [r3, #4]
a03cad48 6c3090e5 ldr r3, [r0, #0x6c]
a03cad4c 030052e1 cmp r2, r3
a03cad50 f5ffffba blt #0xa03cad2c
a03cad54 cfc5ffeb bl #0xa03bc498
a03cad58 cfffffea b #0xa03cac9c
a03cad5c 845084e2 add r5, r4, #0x84
a03cad60 0c108de2 add r1, sp, #0xc
a03cad64 0500a0e1 mov r0, r5
a03cad68 6dc5ffeb bl #0xa03bc324
a03cad6c 0c309de5 ldr r3, [sp, #0xc]
a03cad70 013043e2 sub r3, r3, #1
a03cad74 010053e3 cmp r3, #1
a03cad78 0700009a bls #0xa03cad9c
a03cad7c 50030ee3 movw r0, #0xe350
a03cad80 ac1094e5 ldr r1, [r4, #0xac]
a03cad84 60004ae3 movt r0, #0xa060
a03cad88 d770fbeb bl #0xa02a70ec
a03cad8c 0500a0e1 mov r0, r5
a03cad90 5ec5ffeb bl #0xa03bc310
a03cad94 001050e2 subs r1, r0, #0
a03cad98 0700001a bne #0xa03cadbc
a03cad9c 0500a0e1 mov r0, r5
a03cada0 59c5ffeb bl #0xa03bc30c
a03cada4 001050e2 subs r1, r0, #0
a03cada8 c5ffff0a beq #0xa03cacc4
a03cadac cc030ee3 movw r0, #0xe3cc
a03cadb0 60004ae3 movt r0, #0xa060
a03cadb4 cc70fbeb bl #0xa02a70ec
a03cadb8 c1ffffea b #0xa03cacc4
a03cadbc a4030ee3 movw r0, #0xe3a4
a03cadc0 60004ae3 movt r0, #0xa060
a03cadc4 c870fbeb bl #0xa02a70ec
a03cadc8 f3ffffea b #0xa03cad9c
