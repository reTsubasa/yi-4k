/* Synthetic emulator addresses ONLY. No camera address or free-space claim. */
ENTRY(yi4k_eis_shadow_v2_site1)
SECTIONS {
  . = 0x10034000;
  .text : { *(.text*) }
  .rodata : { *(.rodata*) }
  . = ALIGN(0x1000);
  .data : { *(.data*) }
  .bss (NOLOAD) : { *(.bss*) *(COMMON) }
  /DISCARD/ : { *(.ARM.exidx*) *(.ARM.extab*) *(.comment) }
}
yi4k_eis_stock_filter = 0xA0384710;
