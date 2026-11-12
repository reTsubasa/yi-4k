a032d0c8: 7df5ffeb bl #0xa032a6c4
a032d0cc: 0040a0e1 mov r4, r0
a032d0d0: 08709de5 ldr r7, [sp, #8]
a032d0d4: 0130a0e3 mov r3, #1
a032d0d8: 2c509de5 ldr r5, [sp, #0x2c]
a032d0dc: 18609de5 ldr r6, [sp, #0x18]
a032d0e0: 0700a0e1 mov r0, r7
a032d0e4: 003085e5 str r3, [r5]
a032d0e8: 0610a0e1 mov r1, r6
a032d0ec: 82a3ffeb bl #0xa0315efc
a032d0f0: 14c09de5 ldr ip, [sp, #0x14]
a032d0f4: 1ce09de5 ldr lr, [sp, #0x1c]
a032d0f8: b830dce1 ldrh r3, [ip, #8]
a032d0fc: 0520dee5 ldrb r2, [lr, #5]
a032d100: 030050e1 cmp r0, r3
a032d104: 0300a021 movhs r0, r3
a032d108: 020050e1 cmp r0, r2
a032d10c: 0400a001 moveq r0, r4
a032d110: 1f00000a beq #0xa032d194
a032d114: 0030a0e3 mov r3, #0
a032d118: 0700a0e1 mov r0, r7
a032d11c: 50108de2 add r1, sp, #0x50
a032d120: 58208de2 add r2, sp, #0x58
a032d124: 58308de5 str r3, [sp, #0x58]
a032d128: 50c08de5 str ip, [sp, #0x50]
a032d12c: 54608de5 str r6, [sp, #0x54]
a032d130: 5ce08de5 str lr, [sp, #0x5c]
a032d134: 0ea4ffeb bl #0xa0316174
a032d138: 58309de5 ldr r3, [sp, #0x58]
a032d13c: 0400a0e1 mov r0, r4
