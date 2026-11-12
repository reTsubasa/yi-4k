a03bc324 30402de9 push {r4, r5, lr}
a03bc328 3cd04de2 sub sp, sp, #0x3c
a03bc32c 28208de2 add r2, sp, #0x28
a03bc330 2c308de2 add r3, sp, #0x2c
a03bc334 30e08de2 add lr, sp, #0x30
a03bc338 34c08de2 add ip, sp, #0x34
a03bc33c 24508de2 add r5, sp, #0x24
a03bc340 0140a0e1 mov r4, r1
a03bc344 04208de5 str r2, [sp, #4]
a03bc348 18108de2 add r1, sp, #0x18
a03bc34c 1c208de2 add r2, sp, #0x1c
a03bc350 08308de5 str r3, [sp, #8]
a03bc354 00508de5 str r5, [sp]
a03bc358 20308de2 add r3, sp, #0x20
a03bc35c 0ce08de5 str lr, [sp, #0xc]
a03bc360 10c08de5 str ip, [sp, #0x10]
a03bc364 652000eb bl #0xa03c4500
a03bc368 1c109de5 ldr r1, [sp, #0x1c]
a03bc36c 24209de5 ldr r2, [sp, #0x24]
a03bc370 18309de5 ldr r3, [sp, #0x18]
a03bc374 0e0084e8 stm r4, {r1, r2, r3}
a03bc378 3cd08de2 add sp, sp, #0x3c
a03bc37c 3080bde8 pop {r4, r5, pc}
