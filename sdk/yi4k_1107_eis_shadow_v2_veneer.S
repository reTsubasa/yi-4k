.syntax unified
.arch armv7-a
.arm
.text
.align 2
.global yi4k_eis_shadow_v2_site1
.type yi4k_eis_shadow_v2_site1, %function
yi4k_eis_shadow_v2_site1:
    push {r3, lr}
    mov r3, #1
    bl yi4k_eis_shadow_v2_dispatch
    pop {r3, pc}
.size yi4k_eis_shadow_v2_site1, .-yi4k_eis_shadow_v2_site1
.global yi4k_eis_shadow_v2_site2
.type yi4k_eis_shadow_v2_site2, %function
yi4k_eis_shadow_v2_site2:
    push {r3, lr}
    mov r3, #2
    bl yi4k_eis_shadow_v2_dispatch
    pop {r3, pc}
.size yi4k_eis_shadow_v2_site2, .-yi4k_eis_shadow_v2_site2
.section .note.GNU-stack,"",%progbits
