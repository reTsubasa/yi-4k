/* Offline prototype for the pinned 1.10.7 image. Not a flashable image.
 * Proposed replacement of BL A0186EE8 at A0187BF4 with BL into text padding.
 * Runs stock initialization once, logs one marker, preserves stock r0 and
 * callee-saved registers, and returns to A0187BF8. No dynamic code loading.
 */
.syntax unified
.arch armv7-a
.arm
.section .text, "ax", %progbits
.balign 4
.global yi4k_1107_boot_marker
.type yi4k_1107_boot_marker, %function
yi4k_1107_boot_marker:
    push {r4, lr}                 /* Preserve 8-byte stack alignment. */
    movw ip, #0x6ee8
    movt ip, #0xa018
    blx ip                        /* Original A0186EE8 call, exactly once. */
    mov r4, r0
    adr r0, .Lmarker
    movw ip, #0x70ec
    movt ip, #0xa02a
    blx ip                        /* Existing RTOS logger, fixed literal. */
    mov r0, r4
    pop {r4, pc}
.size yi4k_1107_boot_marker, .-yi4k_1107_boot_marker
.Lmarker:
    .asciz "[yi4k-ext] stock init returned; wrapper reached\n"
.balign 4
