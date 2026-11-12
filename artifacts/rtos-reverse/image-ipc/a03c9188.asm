; source SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; VA base 0xa0100000; A32 selected window, not function boundary proof
; MOVW/MOVT comments are proximity heuristics; cross-check Ghidra and raw instructions
a03c9188 70402de9 push     {r4, r5, r6, lr}
a03c918c 10d04de2 sub      sp, sp, #0x10
a03c9190 0160a0e1 mov      r6, r1
a03c9194 0250a0e1 mov      r5, r2
a03c9198 0040a0e1 mov      r4, r0
a03c919c 13c204fa blx      #0xa04f99f0
a03c91a0 02eba0e3 mov      lr, #0x800
a03c91a4 88c301e3 movw     ip, #0x1388
a03c91a8 023080e2 add      r3, r0, #2
a03c91ac 00608de5 str      r6, [sp]
a03c91b0 0500a0e1 mov      r0, r5
a03c91b4 0420a0e1 mov      r2, r4
a03c91b8 04e08de5 str      lr, [sp, #4]
a03c91bc 0110a0e3 mov      r1, #1
a03c91c0 08c08de5 str      ip, [sp, #8]
a03c91c4 5defffeb bl       #0xa03c4f40
a03c91c8 10d08de2 add      sp, sp, #0x10
a03c91cc 7080bde8 pop      {r4, r5, r6, pc}
a03c91d0 30402de9 push     {r4, r5, lr}
a03c91d4 14d04de2 sub      sp, sp, #0x14
a03c91d8 0250a0e1 mov      r5, r2
a03c91dc 0040a0e1 mov      r4, r0
a03c91e0 02c204fa blx      #0xa04f99f0
a03c91e4 00c0a0e3 mov      ip, #0
a03c91e8 023080e2 add      r3, r0, #2
a03c91ec 0420a0e1 mov      r2, r4
a03c91f0 0500a0e1 mov      r0, r5
a03c91f4 00c08de5 str      ip, [sp]
a03c91f8 0210a0e3 mov      r1, #2
a03c91fc 04c08de5 str      ip, [sp, #4]
a03c9200 08c08de5 str      ip, [sp, #8]
a03c9204 4defffeb bl       #0xa03c4f40
a03c9208 14d08de2 add      sp, sp, #0x14
a03c920c 3080bde8 pop      {r4, r5, pc}
a03c9210 04e02de5 str      lr, [sp, #-4]!
a03c9214 0cd04de2 sub      sp, sp, #0xc
a03c9218 04108de5 str      r1, [sp, #4]
a03c921c 0d10a0e1 mov      r1, sp
