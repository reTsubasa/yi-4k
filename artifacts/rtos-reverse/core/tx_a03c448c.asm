a03c448c push     {r4, lr}
a03c4490 mov      r4, r0
a03c4494 bl       #0xa03c0d08
a03c4498 cmp      r0, #0
a03c449c beq      #0xa03c44a8
a03c44a0 mov      r0, #0x13
a03c44a4 pop      {r4, pc}
a03c44a8 cmp      r4, #0
a03c44ac beq      #0xa03c44c4
a03c44b0 ldr      r2, [r4]
a03c44b4 movw     r3, #0x5244
a03c44b8 movt     r3, #0x5448
a03c44bc cmp      r2, r3
a03c44c0 beq      #0xa03c44cc
a03c44c4 mov      r0, #0xe
a03c44c8 pop      {r4, pc}
a03c44cc mov      r0, r4
a03c44d0 pop      {r4, lr}
a03c44d4 b        #0xa03bfe70
a03c44d8 subs     r3, r0, #0
a03c44dc beq      #0xa03c44f4
a03c44e0 ldr      r2, [r3]
a03c44e4 movw     r3, #0x5244
a03c44e8 movt     r3, #0x5448
a03c44ec cmp      r2, r3
a03c44f0 beq      #0xa03c44fc
a03c44f4 mov      r0, #0xe
a03c44f8 bx       lr
a03c44fc b        #0xa03bff04
a03c4500 subs     ip, r0, #0
a03c4504 push     {r4, r5, r6, r7, r8, lr}
a03c4508 ldr      r8, [sp, #0x18]
a03c450c ldr      r7, [sp, #0x1c]
a03c4510 ldr      r6, [sp, #0x20]
a03c4514 ldr      r5, [sp, #0x24]
a03c4518 ldr      r4, [sp, #0x28]
a03c451c beq      #0xa03c4534
a03c4520 ldr      lr, [ip]
a03c4524 movw     ip, #0x5244
a03c4528 movt     ip, #0x5448
a03c452c cmp      lr, ip
a03c4530 beq      #0xa03c453c
a03c4534 mov      r0, #0xe
a03c4538 pop      {r4, r5, r6, r7, r8, pc}
a03c453c pop      {r4, r5, r6, r7, r8, lr}
a03c4540 b        #0xa03c0190
a03c4544 cmp      r0, #0
a03c4548 beq      #0xa03c4560
a03c454c ldr      ip, [r0]
a03c4550 movw     r3, #0x5244
a03c4554 movt     r3, #0x5448
a03c4558 cmp      ip, r3
a03c455c beq      #0xa03c4568
a03c4560 mov      r0, #0xe
a03c4564 bx       lr
a03c4568 cmp      r2, #0
a03c456c beq      #0xa03c4580
a03c4570 cmp      r1, #0xff
a03c4574 bls      #0xa03c4588
a03c4578 mov      r0, #0xf
a03c457c bx       lr
a03c4580 mov      r0, #3
a03c4584 bx       lr
a03c4588 push     {r4, r5, r6, lr}
a03c458c mov      r5, r2
a03c4590 mov      r6, r1
a03c4594 mov      r4, r0
a03c4598 bl       #0xa03c0d08
a03c459c cmp      r0, #0
a03c45a0 beq      #0xa03c45ac
a03c45a4 mov      r0, #0x13
a03c45a8 pop      {r4, r5, r6, pc}
a03c45ac mov      r0, r4
a03c45b0 mov      r1, r6
a03c45b4 mov      r2, r5
a03c45b8 pop      {r4, r5, r6, lr}
a03c45bc b        #0xa03c032c
a03c45c0 push     {r3, lr}
a03c45c4 bl       #0xa03c0d4c
a03c45c8 cmp      r0, #0
a03c45cc popeq    {r3, pc}
a03c45d0 bl       #0xa03c0d08
a03c45d4 cmp      r0, #0
a03c45d8 popne    {r3, pc}
a03c45dc pop      {r3, lr}
a03c45e0 b        #0xa03c052c
a03c45e4 cmp      r0, #0
a03c45e8 beq      #0xa03c4600
a03c45ec ldr      r2, [r0]
a03c45f0 movw     r3, #0x5244
a03c45f4 movt     r3, #0x5448
a03c45f8 cmp      r2, r3
a03c45fc beq      #0xa03c4608
a03c4600 mov      r0, #0xe
a03c4604 bx       lr
a03c4608 push     {r4, lr}
a03c460c mov      r4, r0
a03c4610 bl       #0xa03c0d4c
a03c4614 movw     r3, #0x6c34
a03c4618 movt     r3, #0xa179
a03c461c cmp      r3, r0
a03c4620 beq      #0xa03c4630
a03c4624 bl       #0xa03c0d08
a03c4628 cmp      r0, #0
a03c462c beq      #0xa03c4638
a03c4630 mov      r0, #0x13
a03c4634 pop      {r4, pc}
a03c4638 mov      r0, r4
a03c463c pop      {r4, lr}
a03c4640 b        #0xa03c0798
a03c4644 subs     r3, r0, #0
a03c4648 beq      #0xa03c4660
a03c464c ldr      r2, [r3]
a03c4650 movw     r3, #0x5244
a03c4654 movt     r3, #0x5448
a03c4658 cmp      r2, r3
a03c465c beq      #0xa03c4668
a03c4660 mov      r0, #0xe
a03c4664 bx       lr
a03c4668 b        #0xa03c081c
a03c466c subs     r3, r0, #0
a03c4670 beq      #0xa03c4688
a03c4674 ldr      r2, [r3]
a03c4678 movw     r3, #0x5244
a03c467c movt     r3, #0x5448
a03c4680 cmp      r2, r3
a03c4684 beq      #0xa03c4690
a03c4688 mov      r0, #0xe
a03c468c bx       lr
a03c4690 b        #0xa03c1658
