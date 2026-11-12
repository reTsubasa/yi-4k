/* Synthetic emulator addresses only. No camera free-space claim. */
ENTRY(yi4k_1107_copy_payload)
SECTIONS {
  . = 0x10030000;
  .text : { *(.text*) }
  .rodata : { *(.rodata*) }
  .data : { *(.data*) }
  .bss (NOLOAD) : { *(.bss*) *(COMMON) }
  /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) *(.comment) }
}
