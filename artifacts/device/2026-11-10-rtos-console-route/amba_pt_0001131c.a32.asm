# Explicit A32 excerpt; not a complete mixed-mode ELF listing.
0001131c push {r4, r5, r6, lr}
00011320 mov r4, r1
00011324 mov r5, r0
00011328 bl #0x10b58
0001132c ldr r3, [pc, #0x24]
00011330 mov r2, r0
00011334 mov r1, r5
00011338 add ip, pc, r3
0001133c ldr r0, [ip]
00011340 bl #0x10b94
00011344 mov r2, #0
00011348 mov r0, #1
0001134c str r2, [r4, #0xc]
00011350 str r0, [r4, #8]
00011354 pop {r4, r5, r6, pc}
00011358 andeq r0, r1, r4, ror #7
0001135c ldr r1, [pc, #0x24]
00011360 mov r2, r0
00011364 push {r4, lr}
00011368 mov r0, #3
0001136c add r1, pc, r1
00011370 bl #0x10bdc
00011374 mov r1, #1
00011378 mov r0, #0x20000008
0001137c bl #0x10be8
00011380 mov r0, #0
00011384 bl #0x10b4c
00011388 andeq r0, r0, r8, lsr #1
0001138c push {r4, r5, lr}
00011390 sub sp, sp, #0x14
00011394 mov r4, r2
00011398 mov r5, r0
0001139c bl #0x10b58
000113a0 mov ip, #0
000113a4 add r3, r0, #1
000113a8 mov r2, r5
000113ac mov r0, r4
000113b0 str ip, [sp, #8]
000113b4 mov r1, #1
000113b8 str ip, [sp, #4]
000113bc str ip, [sp]
000113c0 bl #0x10bd0
000113c4 add sp, sp, #0x14
000113c8 pop {r4, r5, pc}
