; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01ace50+0x94; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01ace50  440f0ae3  movw     r0, #0xaf44
a01ace54  bc180be3  movw     r1, #0xb8bc
a01ace58  08402de9  push     {r3, lr}
a01ace5c  1a104ae3  movt     r1, #0xa01a
a01ace60  56004ae3  movt     r0, #0xa056 ; constant 0xa056af44: 'ants'
a01ace64  8bc403eb  bl       #0xa029e098 ; analyst_t_command_register
a01ace68  4c0f0ae3  movw     r0, #0xaf4c
a01ace6c  f0170be3  movw     r1, #0xb7f0
a01ace70  1a104ae3  movt     r1, #0xa01a
a01ace74  56004ae3  movt     r0, #0xa056 ; constant 0xa056af4c: 'wi-fi'
a01ace78  86c403eb  bl       #0xa029e098 ; analyst_t_command_register
a01ace7c  540f0ae3  movw     r0, #0xaf54
a01ace80  04170be3  movw     r1, #0xb704
a01ace84  1a104ae3  movt     r1, #0xa01a
a01ace88  56004ae3  movt     r0, #0xa056 ; constant 0xa056af54: 'pref'
a01ace8c  81c403eb  bl       #0xa029e098 ; analyst_t_command_register
a01ace90  5c0f0ae3  movw     r0, #0xaf5c
a01ace94  d01e07e3  movw     r1, #0x7ed0
a01ace98  1a104ae3  movt     r1, #0xa01a
a01ace9c  56004ae3  movt     r0, #0xa056 ; constant 0xa056af5c: 'zl'
a01acea0  7cc403eb  bl       #0xa029e098 ; analyst_t_command_register
a01acea4  600f0ae3  movw     r0, #0xaf60
a01acea8  cc1c07e3  movw     r1, #0x7ccc
a01aceac  1a104ae3  movt     r1, #0xa01a
a01aceb0  56004ae3  movt     r0, #0xa056 ; constant 0xa056af60: 'stawpa'
a01aceb4  77c403eb  bl       #0xa029e098 ; analyst_t_command_register
a01aceb8  680f0ae3  movw     r0, #0xaf68
a01acebc  18120be3  movw     r1, #0xb218
a01acec0  18104ae3  movt     r1, #0xa018
a01acec4  56004ae3  movt     r0, #0xa056 ; constant 0xa056af68: 'audio-enc'
a01acec8  72c403eb  bl       #0xa029e098 ; analyst_t_command_register
a01acecc  740f0ae3  movw     r0, #0xaf74
a01aced0  c8140ce3  movw     r1, #0xc4c8
a01aced4  56004ae3  movt     r0, #0xa056 ; constant 0xa056af74: 'audio-dec'
a01aced8  18104ae3  movt     r1, #0xa018
a01acedc  0840bde8  pop      {r3, lr}
a01acee0  6cc403ea  b        #0xa029e098 ; analyst_t_command_register
