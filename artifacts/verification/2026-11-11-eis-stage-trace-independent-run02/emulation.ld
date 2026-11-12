ENTRY(yi4k_eis_stage_trace_init)
SECTIONS { . = 0x10000000; .text : { *(.text*) } .rodata : { *(.rodata*) } .data : { *(.data*) } .bss : { *(.bss*) } }
