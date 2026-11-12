a048fca0 d43206e3 movw r3, #0x62d4
a048fca4 000050e3 cmp r0, #0
a048fca8 79314ae3 movt r3, #0xa179
a048fcac f04f2de9 push {r4, r5, r6, r7, r8, sb, sl, fp, lr}
a048fcb0 14d04de2 sub sp, sp, #0x14
a048fcb4 00b093e5 ldr fp, [r3]
a048fcb8 5800000a beq #0xa048fe20
a048fcbc 0050a0e1 mov r5, r0
a048fcc0 880d0ce3 movw r0, #0xcd88
a048fcc4 b49206e3 movw sb, #0x62b4
a048fcc8 62004ae3 movt r0, #0xa062
a048fccc 35ff2fe1 blx r5
a048fcd0 79914ae3 movt sb, #0xa179
a048fcd4 b00d0ce3 movw r0, #0xcdb0
a048fcd8 001099e5 ldr r1, [sb]
a048fcdc 62004ae3 movt r0, #0xa062
a048fce0 35ff2fe1 blx r5
a048fce4 880d0ce3 movw r0, #0xcd88
a048fce8 62004ae3 movt r0, #0xa062
a048fcec 35ff2fe1 blx r5
a048fcf0 300e0ce3 movw r0, #0xce30
a048fcf4 62004ae3 movt r0, #0xa062
a048fcf8 35ff2fe1 blx r5
a048fcfc 003099e5 ldr r3, [sb]
a048fd00 000053e3 cmp r3, #0
a048fd04 3b00000a beq #0xa048fdf8
a048fd08 18319fe5 ldr r3, [pc, #0x118]
a048fd0c ee6e0ee3 movw r6, #0xeeee
a048fd10 ff6f4fe3 movt r6, #0xffff
a048fd14 0070a0e3 mov r7, #0
a048fd18 0c8043e2 sub r8, r3, #0xc
a048fd1c 04319fe5 ldr r3, [pc, #0x104]
a048fd20 e01b09e3 movw r1, #0x9be0
a048fd24 a3114ae3 movt r1, #0xa1a3
a048fd28 0b00a0e1 mov r0, fp
a048fd2c 042081e2 add r2, r1, #4
a048fd30 00308de5 str r3, [sp]
a048fd34 043083e2 add r3, r3, #4
a048fd38 04308de5 str r3, [sp, #4]
a048fd3c 043083e2 add r3, r3, #4
a048fd40 08308de5 str r3, [sp, #8]
a048fd44 083081e2 add r3, r1, #8
a048fd48 5dcefceb bl #0xa03c36c4
a048fd4c 004050e2 subs r4, r0, #0
a048fd50 2b00001a bne #0xa048fe04
a048fd54 1cc09be5 ldr ip, [fp, #0x1c]
a048fd58 600e0ce3 movw r0, #0xce60
a048fd5c 083098e5 ldr r3, [r8, #8]
a048fd60 0710a0e1 mov r1, r7
a048fd64 042098e5 ldr r2, [r8, #4]
a048fd68 62004ae3 movt r0, #0xa062
a048fd6c 00c08de5 str ip, [sp]
a048fd70 18c09be5 ldr ip, [fp, #0x18]
a048fd74 04c08de5 str ip, [sp, #4]
a048fd78 35ff2fe1 blx r5
a048fd7c 7c0e0ce3 movw r0, #0xce7c
a048fd80 62004ae3 movt r0, #0xa062
a048fd84 35ff2fe1 blx r5
a048fd88 0c309be5 ldr r3, [fp, #0xc]
a048fd8c 10c09be5 ldr ip, [fp, #0x10]
a048fd90 000053e3 cmp r3, #0
a048fd94 1200000a beq #0xa048fde4
a048fd98 00a09ce5 ldr sl, [ip]
a048fd9c 0c20a0e1 mov r2, ip
a048fda0 b40e0ce3 movw r0, #0xceb4
a048fda4 0410a0e1 mov r1, r4
a048fda8 62004ae3 movt r0, #0xa062
a048fdac 014084e2 add r4, r4, #1
a048fdb0 0a306ce0 rsb r3, ip, sl
a048fdb4 00308de5 str r3, [sp]
a048fdb8 0a30a0e1 mov r3, sl
a048fdbc 04c09ce5 ldr ip, [ip, #4]
a048fdc0 0cc066e0 rsb ip, r6, ip
a048fdc4 1ccf6fe1 clz ip, ip
a048fdc8 acc2a0e1 lsr ip, ip, #5
a048fdcc 04c08de5 str ip, [sp, #4]
a048fdd0 35ff2fe1 blx r5
a048fdd4 0c309be5 ldr r3, [fp, #0xc]
a048fdd8 0ac0a0e1 mov ip, sl
a048fddc 030054e1 cmp r4, r3
a048fde0 ecffff3a blo #0xa048fd98
a048fde4 003099e5 ldr r3, [sb]
a048fde8 017087e2 add r7, r7, #1
a048fdec 2cb09be5 ldr fp, [fp, #0x2c]
a048fdf0 030057e1 cmp r7, r3
a048fdf4 c8ffff3a blo #0xa048fd1c
a048fdf8 0000a0e3 mov r0, #0
a048fdfc 14d08de2 add sp, sp, #0x14
a048fe00 f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a048fe04 fc0d0ce3 movw r0, #0xcdfc
a048fe08 0710a0e1 mov r1, r7
a048fe0c 62004ae3 movt r0, #0xa062
a048fe10 35ff2fe1 blx r5
a048fe14 0400a0e1 mov r0, r4
a048fe18 14d08de2 add sp, sp, #0x14
a048fe1c f08fbde8 pop {r4, r5, r6, r7, r8, sb, sl, fp, pc}
a048fe20 0000e0e3 mvn r0, #0
a048fe24 f4ffffea b #0xa048fdfc
