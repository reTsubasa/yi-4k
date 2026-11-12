0xa029a7d8  push {r4, r5, r6, lr}
0xa029a7dc  mov r5, r2
0xa029a7e0  ldr r4, [sp, #0x10]
0xa029a7e4  mov r6, r1
0xa029a7e8  mov r1, r5
0xa029a7ec  cmp r4, #0x1f
0xa029a7f0  lslhi r2, r4, #1
0xa029a7f4  movls r2, #0x40
0xa029a7f8  movls r4, #0x20
0xa029a7fc  add r2, r2, r3
0xa029a800  mov r3, #0x1f4
0xa029a804  bl #0xa03bc6dc
0xa029a808  cmp r0, #0
0xa029a80c  ldreq r3, [r5]
0xa029a810  subeq r2, r4, #1
0xa029a814  biceq r3, r3, r2
0xa029a818  addeq r4, r3, r4
0xa029a81c  streq r4, [r6]
0xa029a820  pop {r4, r5, r6, pc}
