a029de40 push {r3, r4, r5, r6, r7, lr}
a029de44 movw r4, #0x63a8
a029de48 movt r4, #0xa144
a029de4c mov r7, r0
a029de50 add r5, r4, #0x240
a029de54 mov r6, r1
a029de58 mov r0, r5
a029de5c mvn r1, #0
a029de60 bl #0xa03bc46c
a029de64 mov r0, r5
a029de68 str r7, [r4, #0x278]
a029de6c str r6, [r4, #0x274]
a029de70 bl #0xa03bc498
a029de74 add r0, r4, #0x1b0
a029de78 mov r1, #4
a029de7c bl #0xa03bc4e8
a029de80 mov r0, #0
a029de84 pop {r3, r4, r5, r6, r7, pc}
