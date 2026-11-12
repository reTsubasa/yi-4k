; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01a4f34+0x10fc; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01a4f34  010050e3  cmp      r0, #1
a01a4f38  f0412de9  push     {r4, r5, r6, r7, r8, lr}
a01a4f3c  0080a0e1  mov      r8, r0
a01a4f40  08d04de2  sub      sp, sp, #8
a01a4f44  0260a0e1  mov      r6, r2
a01a4f48  310000da  ble      #0xa01a5014
a01a4f4c  044091e5  ldr      r4, [r1, #4]
a01a4f50  0170a0e1  mov      r7, r1
a01a4f54  6c1104e3  movw     r1, #0x416c
a01a4f58  53104ae3  movt     r1, #0xa053 ; constant 0xa053416c: 'msg'
a01a4f5c  0400a0e1  mov      r0, r4
a01a4f60  f7510dfa  blx      #0xa04f9744
a01a4f64  005050e2  subs     r5, r0, #0
a01a4f68  5a00000a  beq      #0xa01a50d8
a01a4f6c  981806e3  movw     r1, #0x6898
a01a4f70  0400a0e1  mov      r0, r4
a01a4f74  56104ae3  movt     r1, #0xa056 ; constant 0xa0566898: 'key'
a01a4f78  f1510dfa  blx      #0xa04f9744
a01a4f7c  000050e3  cmp      r0, #0
a01a4f80  5d00000a  beq      #0xa01a50fc
a01a4f84  f41d06e3  movw     r1, #0x6df4
a01a4f88  0400a0e1  mov      r0, r4
a01a4f8c  56104ae3  movt     r1, #0xa056 ; constant 0xa0566df4: 'jack'
a01a4f90  eb510dfa  blx      #0xa04f9744
a01a4f94  000050e3  cmp      r0, #0
a01a4f98  2400000a  beq      #0xa01a5030
a01a4f9c  281201e3  movw     r1, #0x1228
a01a4fa0  0400a0e1  mov      r0, r4
a01a4fa4  53104ae3  movt     r1, #0xa053 ; constant 0xa0531228: 'test'
a01a4fa8  e5510dfa  blx      #0xa04f9744
a01a4fac  000050e3  cmp      r0, #0
a01a4fb0  5800000a  beq      #0xa01a5118
a01a4fb4  4c1e06e3  movw     r1, #0x6e4c
a01a4fb8  0400a0e1  mov      r0, r4
a01a4fbc  56104ae3  movt     r1, #0xa056 ; constant 0xa0566e4c: 'mem'
a01a4fc0  df510dfa  blx      #0xa04f9744
a01a4fc4  003050e2  subs     r3, r0, #0
a01a4fc8  e900000a  beq      #0xa01a5374
a01a4fcc  f41e06e3  movw     r1, #0x6ef4
a01a4fd0  0400a0e1  mov      r0, r4
a01a4fd4  56104ae3  movt     r1, #0xa056 ; constant 0xa0566ef4: 'sensor'
a01a4fd8  d9510dfa  blx      #0xa04f9744
a01a4fdc  000050e3  cmp      r0, #0
a01a4fe0  0a01000a  beq      #0xa01a5410
a01a4fe4  fc1e06e3  movw     r1, #0x6efc
a01a4fe8  0400a0e1  mov      r0, r4
a01a4fec  56104ae3  movt     r1, #0xa056 ; constant 0xa0566efc: 'aucodec'
a01a4ff0  d3510dfa  blx      #0xa04f9744
a01a4ff4  003050e2  subs     r3, r0, #0
a01a4ff8  0901000a  beq      #0xa01a5424
a01a4ffc  541007e3  movw     r1, #0x7054
a01a5000  0400a0e1  mov      r0, r4
a01a5004  56104ae3  movt     r1, #0xa056 ; constant 0xa0567054: 'powersaving'
a01a5008  cd510dfa  blx      #0xa04f9744
a01a500c  004050e2  subs     r4, r0, #0
a01a5010  2001000a  beq      #0xa01a5498
a01a5014  600007e3  movw     r0, #0x7060
a01a5018  56004ae3  movt     r0, #0xa056 ; constant 0xa0567060: 'App test command list:\n\t msg \n\t key \n\t jack \n\t test \n\t mem \n\t sensor \n\t aucodec \n\t powersaving \n'
a01a501c  36ff2fe1  blx      r6
a01a5020  0040a0e1  mov      r4, r0
a01a5024  0400a0e1  mov      r0, r4
a01a5028  08d08de2  add      sp, sp, #8
a01a502c  f081bde8  pop      {r4, r5, r6, r7, r8, pc}
a01a5030  030058e3  cmp      r8, #3
a01a5034  220000da  ble      #0xa01a50c4
a01a5038  0c4097e5  ldr      r4, [r7, #0xc]
a01a503c  dc1107e3  movw     r1, #0x71dc
a01a5040  54104ae3  movt     r1, #0xa054 ; constant 0xa05471dc: 'in'
a01a5044  0400a0e1  mov      r0, r4
a01a5048  bd510dfa  blx      #0xa04f9744
a01a504c  000050e3  cmp      r0, #0
a01a5050  1601000a  beq      #0xa01a54b0
a01a5054  781208e3  movw     r1, #0x8278
a01a5058  0400a0e1  mov      r0, r4
a01a505c  5c104ae3  movt     r1, #0xa05c ; constant 0xa05c8278: 'out'
a01a5060  b7510dfa  blx      #0xa04f9744
a01a5064  000050e3  cmp      r0, #0
a01a5068  1500001a  bne      #0xa01a50c4
a01a506c  0050a0e1  mov      r5, r0
a01a5070  084097e5  ldr      r4, [r7, #8]
a01a5074  cc1007e3  movw     r1, #0x70cc
a01a5078  56104ae3  movt     r1, #0xa056 ; constant 0xa05670cc: 'hdmi'
a01a507c  0400a0e1  mov      r0, r4
a01a5080  af510dfa  blx      #0xa04f9744
a01a5084  001050e2  subs     r1, r0, #0
a01a5088  2901000a  beq      #0xa01a5534
a01a508c  481e06e3  movw     r1, #0x6e48
a01a5090  0400a0e1  mov      r0, r4
a01a5094  56104ae3  movt     r1, #0xa056 ; constant 0xa0566e48: 'cs'
a01a5098  a9510dfa  blx      #0xa04f9744
a01a509c  001050e2  subs     r1, r0, #0
a01a50a0  0700001a  bne      #0xa01a50c4
a01a50a4  030ca0e3  mov      r0, #0x300
a01a50a8  02084ee3  movt     r0, #0xe802
a01a50ac  0120a0e1  mov      r2, r1
a01a50b0  000085e1  orr      r0, r5, r0
a01a50b4  370501eb  bl       #0xa01e6598
a01a50b8  020070e3  cmn      r0, #2
a01a50bc  0040a0e1  mov      r4, r0
a01a50c0  d7ffff1a  bne      #0xa01a5024
a01a50c4  fc0d06e3  movw     r0, #0x6dfc
a01a50c8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566dfc: 'Usage: t app jack <jack> <event>\nJack list:\n\thdmi\n\tcs\nEvent list:\n\tin\n\tout\n'
a01a50cc  36ff2fe1  blx      r6
a01a50d0  0040a0e1  mov      r4, r0
a01a50d4  d2ffffea  b        #0xa01a5024
a01a50d8  020058e3  cmp      r8, #2
a01a50dc  b700001a  bne      #0xa01a53c0
a01a50e0  6c0806e3  movw     r0, #0x686c
a01a50e4  56004ae3  movt     r0, #0xa056 ; constant 0xa056686c: 'Usage: t app msg <msg> <param1> <param2>\n'
a01a50e8  36ff2fe1  blx      r6
a01a50ec  0040a0e1  mov      r4, r0
a01a50f0  0400a0e1  mov      r0, r4
a01a50f4  08d08de2  add      sp, sp, #8
a01a50f8  f081bde8  pop      {r4, r5, r6, r7, r8, pc}
a01a50fc  020058e3  cmp      r8, #2
a01a5100  0a00001a  bne      #0xa01a5130
a01a5104  9c0806e3  movw     r0, #0x689c
a01a5108  56004ae3  movt     r0, #0xa056
a01a510c  36ff2fe1  blx      r6
a01a5110  0040a0e1  mov      r4, r0
a01a5114  c2ffffea  b        #0xa01a5024
a01a5118  0800a0e1  mov      r0, r8
a01a511c  0710a0e1  mov      r1, r7
a01a5120  0620a0e1  mov      r2, r6
a01a5124  f3f1ffeb  bl       #0xa01a18f8
a01a5128  0040a0e1  mov      r4, r0
a01a512c  bcffffea  b        #0xa01a5024
a01a5130  085097e5  ldr      r5, [r7, #8]
a01a5134  c41a04e3  movw     r1, #0x4ac4
a01a5138  56104ae3  movt     r1, #0xa056 ; constant 0xa0564ac4: 'up'
a01a513c  0500a0e1  mov      r0, r5
a01a5140  7f510dfa  blx      #0xa04f9744
a01a5144  001050e2  subs     r1, r0, #0
a01a5148  e300000a  beq      #0xa01a54dc
a01a514c  f01906e3  movw     r1, #0x69f0
a01a5150  0500a0e1  mov      r0, r5
a01a5154  56104ae3  movt     r1, #0xa056 ; constant 0xa05669f0: 'up_rel'
a01a5158  79510dfa  blx      #0xa04f9744
a01a515c  001050e2  subs     r1, r0, #0
a01a5160  d400000a  beq      #0xa01a54b8
a01a5164  f01006e3  movw     r1, #0x60f0
a01a5168  0500a0e1  mov      r0, r5
a01a516c  53104ae3  movt     r1, #0xa053 ; constant 0xa05360f0: 'down'
a01a5170  73510dfa  blx      #0xa04f9744
a01a5174  001050e2  subs     r1, r0, #0
a01a5178  e700000a  beq      #0xa01a551c
a01a517c  f81906e3  movw     r1, #0x69f8
a01a5180  0500a0e1  mov      r0, r5
a01a5184  56104ae3  movt     r1, #0xa056 ; constant 0xa05669f8: 'down_rel'
a01a5188  6d510dfa  blx      #0xa04f9744
a01a518c  001050e2  subs     r1, r0, #0
a01a5190  e900000a  beq      #0xa01a553c
a01a5194  7c1206e3  movw     r1, #0x627c
a01a5198  0500a0e1  mov      r0, r5
a01a519c  5e104ae3  movt     r1, #0xa05e ; constant 0xa05e627c: 'left'
a01a51a0  67510dfa  blx      #0xa04f9744
a01a51a4  001050e2  subs     r1, r0, #0
a01a51a8  2c01000a  beq      #0xa01a5660
a01a51ac  041a06e3  movw     r1, #0x6a04
a01a51b0  0500a0e1  mov      r0, r5
a01a51b4  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a04: 'left_rel'
a01a51b8  61510dfa  blx      #0xa04f9744
a01a51bc  000050e3  cmp      r0, #0
a01a51c0  02080003  movweq   r0, #0x802
a01a51c4  7001000a  beq      #0xa01a578c
a01a51c8  101a06e3  movw     r1, #0x6a10
a01a51cc  0500a0e1  mov      r0, r5
a01a51d0  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a10: 'right'
a01a51d4  5a510dfa  blx      #0xa04f9744
a01a51d8  001050e2  subs     r1, r0, #0
a01a51dc  7001000a  beq      #0xa01a57a4
a01a51e0  181a06e3  movw     r1, #0x6a18
a01a51e4  0500a0e1  mov      r0, r5
a01a51e8  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a18: 'right_rel'
a01a51ec  54510dfa  blx      #0xa04f9744
a01a51f0  001050e2  subs     r1, r0, #0
a01a51f4  7001000a  beq      #0xa01a57bc
a01a51f8  241a06e3  movw     r1, #0x6a24
a01a51fc  0500a0e1  mov      r0, r5
a01a5200  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a24: 'zoomin'
a01a5204  4e510dfa  blx      #0xa04f9744
a01a5208  001050e2  subs     r1, r0, #0
a01a520c  7001000a  beq      #0xa01a57d4
a01a5210  2c1a06e3  movw     r1, #0x6a2c
a01a5214  0500a0e1  mov      r0, r5
a01a5218  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a2c: 'zoomin_rel'
a01a521c  48510dfa  blx      #0xa04f9744
a01a5220  001050e2  subs     r1, r0, #0
a01a5224  7001000a  beq      #0xa01a57ec
a01a5228  381a06e3  movw     r1, #0x6a38
a01a522c  0500a0e1  mov      r0, r5
a01a5230  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a38: 'zoomout'
a01a5234  42510dfa  blx      #0xa04f9744
a01a5238  001050e2  subs     r1, r0, #0
a01a523c  7001000a  beq      #0xa01a5804
a01a5240  401a06e3  movw     r1, #0x6a40
a01a5244  0500a0e1  mov      r0, r5
a01a5248  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a40: 'zoomout_rel'
a01a524c  3c510dfa  blx      #0xa04f9744
a01a5250  001050e2  subs     r1, r0, #0
a01a5254  7001000a  beq      #0xa01a581c
a01a5258  c41e01e3  movw     r1, #0x1ec4
a01a525c  0500a0e1  mov      r0, r5
a01a5260  57104ae3  movt     r1, #0xa057 ; constant 0xa0571ec4: 'set'
a01a5264  36510dfa  blx      #0xa04f9744
a01a5268  001050e2  subs     r1, r0, #0
a01a526c  7001000a  beq      #0xa01a5834
a01a5270  4c1a06e3  movw     r1, #0x6a4c
a01a5274  0500a0e1  mov      r0, r5
a01a5278  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a4c: 'f4'
a01a527c  30510dfa  blx      #0xa04f9744
a01a5280  001050e2  subs     r1, r0, #0
a01a5284  7001000a  beq      #0xa01a584c
a01a5288  501a06e3  movw     r1, #0x6a50
a01a528c  0500a0e1  mov      r0, r5
a01a5290  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a50: 'focus'
a01a5294  2a510dfa  blx      #0xa04f9744
a01a5298  001050e2  subs     r1, r0, #0
a01a529c  7001000a  beq      #0xa01a5864
a01a52a0  581a06e3  movw     r1, #0x6a58
a01a52a4  0500a0e1  mov      r0, r5
a01a52a8  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a58: 'mc'
a01a52ac  24510dfa  blx      #0xa04f9744
a01a52b0  000050e3  cmp      r0, #0
a01a52b4  1f00a003  moveq    r0, #0x1f
a01a52b8  3301000a  beq      #0xa01a578c
a01a52bc  d41c01e3  movw     r1, #0x1cd4
a01a52c0  0500a0e1  mov      r0, r5
a01a52c4  60104ae3  movt     r1, #0xa060 ; constant 0xa0601cd4: 'ps'
a01a52c8  1d510dfa  blx      #0xa04f9744
a01a52cc  000050e3  cmp      r0, #0
a01a52d0  0040a001  moveq    r4, r0
a01a52d4  52ffff0a  beq      #0xa01a5024
a01a52d8  5c1a06e3  movw     r1, #0x6a5c
a01a52dc  0500a0e1  mov      r0, r5
a01a52e0  56104ae3  movt     r1, #0xa056 ; constant 0xa0566a5c: 'poweroff'
a01a52e4  16510dfa  blx      #0xa04f9744
a01a52e8  004050e2  subs     r4, r0, #0
a01a52ec  a502000a  beq      #0xa01a5d88
a01a52f0  c81a06e3  movw     r1, #0x6ac8
a01a52f4  0500a0e1  mov      r0, r5
a01a52f8  56104ae3  movt     r1, #0xa056 ; constant 0xa0566ac8: 'psexit'
a01a52fc  10510dfa  blx      #0xa04f9744
a01a5300  000050e3  cmp      r0, #0
a01a5304  b402000a  beq      #0xa01a5ddc
a01a5308  d01a06e3  movw     r1, #0x6ad0
a01a530c  0500a0e1  mov      r0, r5
a01a5310  56104ae3  movt     r1, #0xa056 ; constant 0xa0566ad0: 'focus_rel'
a01a5314  0a510dfa  blx      #0xa04f9744
a01a5318  001050e2  subs     r1, r0, #0
a01a531c  a802000a  beq      #0xa01a5dc4
a01a5320  b4150ce3  movw     r1, #0xc5b4
a01a5324  0500a0e1  mov      r0, r5
a01a5328  60104ae3  movt     r1, #0xa060 ; constant 0xa060c5b4: 'shutter'
a01a532c  04510dfa  blx      #0xa04f9744
a01a5330  004050e2  subs     r4, r0, #0
a01a5334  6401000a  beq      #0xa01a58cc
a01a5338  581b06e3  movw     r1, #0x6b58
a01a533c  0500a0e1  mov      r0, r5
a01a5340  56104ae3  movt     r1, #0xa056 ; constant 0xa0566b58: 'fac_test'
a01a5344  fe500dfa  blx      #0xa04f9744
a01a5348  004050e2  subs     r4, r0, #0
a01a534c  4a01001a  bne      #0xa01a587c
a01a5350  040058e3  cmp      r8, #4
a01a5354  7c3003e3  movw     r3, #0x307c
a01a5358  780200ca  bgt      #0xa01a5d40
a01a535c  6f304ae3  movt     r3, #0xa06f
a01a5360  640b06e3  movw     r0, #0x6b64
a01a5364  0c1093e5  ldr      r1, [r3, #0xc]
a01a5368  56004ae3  movt     r0, #0xa056 ; constant 0xa0566b64: '%s---------------> factory  fosd param < 5\n'
a01a536c  5e0704eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5370  2bffffea  b        #0xa01a5024
a01a5374  500e06e3  movw     r0, #0x6e50
a01a5378  0340a0e1  mov      r4, r3
a01a537c  56004ae3  movt     r0, #0xa056 ; constant 0xa0566e50: '========== MEMORY POOL STATISTICS ========='
a01a5380  590704eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5384  143107e3  movw     r3, #0x7114
a01a5388  7c0e06e3  movw     r0, #0x6e7c
a01a538c  fd304ae3  movt     r3, #0xa0fd
a01a5390  56004ae3  movt     r0, #0xa056 ; constant 0xa0566e7c: '    HEAP    : Available size  = %10d bytes = %4d Mbyte\n\r'
a01a5394  081093e5  ldr      r1, [r3, #8]
a01a5398  212aa0e1  lsr      r2, r1, #0x14
a01a539c  520704eb  bl       #0xa02a70ec ; analyst_printf_like
a01a53a0  203207e3  movw     r3, #0x7220
a01a53a4  b80e06e3  movw     r0, #0x6eb8
a01a53a8  fe304ae3  movt     r3, #0xa0fe
a01a53ac  56004ae3  movt     r0, #0xa056 ; constant 0xa0566eb8: 'NON-HEAP    : Available size  = %10d bytes = %4d Mbyte\n\r'
a01a53b0  081093e5  ldr      r1, [r3, #8]
a01a53b4  212aa0e1  lsr      r2, r1, #0x14
a01a53b8  4b0704eb  bl       #0xa02a70ec ; analyst_printf_like
a01a53bc  18ffffea  b        #0xa01a5024
a01a53c0  04108de2  add      r1, sp, #4
a01a53c4  0520a0e1  mov      r2, r5
a01a53c8  080097e5  ldr      r0, [r7, #8]
a01a53cc  d5570dfa  blx      #0xa04fb328
a01a53d0  04108de2  add      r1, sp, #4
a01a53d4  0060a0e1  mov      r6, r0
a01a53d8  0520a0e1  mov      r2, r5
a01a53dc  0c0097e5  ldr      r0, [r7, #0xc]
a01a53e0  d0570dfa  blx      #0xa04fb328
a01a53e4  04108de2  add      r1, sp, #4
a01a53e8  0040a0e1  mov      r4, r0
a01a53ec  0520a0e1  mov      r2, r5
a01a53f0  100097e5  ldr      r0, [r7, #0x10]
a01a53f4  cb570dfa  blx      #0xa04fb328
a01a53f8  0410a0e1  mov      r1, r4
a01a53fc  0020a0e1  mov      r2, r0
a01a5400  0600a0e1  mov      r0, r6
a01a5404  630401eb  bl       #0xa01e6598
a01a5408  0040a0e1  mov      r4, r0
a01a540c  04ffffea  b        #0xa01a5024
a01a5410  0800a0e1  mov      r0, r8
a01a5414  0710a0e1  mov      r1, r7
a01a5418  acfcffeb  bl       #0xa01a46d0
a01a541c  0040a0e1  mov      r4, r0
a01a5420  fffeffea  b        #0xa01a5024
a01a5424  020058e3  cmp      r8, #2
a01a5428  3000000a  beq      #0xa01a54f0
a01a542c  085097e5  ldr      r5, [r7, #8]
a01a5430  041f06e3  movw     r1, #0x6f04
a01a5434  56104ae3  movt     r1, #0xa056 ; constant 0xa0566f04: 'setoutput'
a01a5438  0500a0e1  mov      r0, r5
a01a543c  c0500dfa  blx      #0xa04f9744
a01a5440  000050e3  cmp      r0, #0
a01a5444  4200000a  beq      #0xa01a5554
a01a5448  441f06e3  movw     r1, #0x6f44
a01a544c  0500a0e1  mov      r0, r5
a01a5450  56104ae3  movt     r1, #0xa056 ; constant 0xa0566f44: 'setinput'
a01a5454  ba500dfa  blx      #0xa04f9744
a01a5458  004050e2  subs     r4, r0, #0
a01a545c  8500000a  beq      #0xa01a5678
a01a5460  241a0ee3  movw     r1, #0xea24
a01a5464  0500a0e1  mov      r0, r5
a01a5468  63104ae3  movt     r1, #0xa063 ; constant 0xa063ea24: 'write'
a01a546c  b4500dfa  blx      #0xa04f9744
a01a5470  004050e2  subs     r4, r0, #0
a01a5474  4900000a  beq      #0xa01a55a0
a01a5478  18100be3  movw     r1, #0xb018
a01a547c  0500a0e1  mov      r0, r5
a01a5480  62104ae3  movt     r1, #0xa062 ; constant 0xa062b018: 'read'
a01a5484  ae500dfa  blx      #0xa04f9744
a01a5488  000050e3  cmp      r0, #0
a01a548c  5800000a  beq      #0xa01a55f4
a01a5490  0040a0e3  mov      r4, #0
a01a5494  e2feffea  b        #0xa01a5024
a01a5498  1a0300e3  movw     r0, #0x31a
a01a549c  0410a0e1  mov      r1, r4
a01a54a0  0420a0e1  mov      r2, r4
a01a54a4  01004fe3  movt     r0, #0xf001
a01a54a8  3a0401eb  bl       #0xa01e6598
a01a54ac  dcfeffea  b        #0xa01a5024
a01a54b0  0150a0e3  mov      r5, #1
a01a54b4  edfeffea  b        #0xa01a5070
a01a54b8  020ba0e3  mov      r0, #0x800
a01a54bc  0120a0e1  mov      r2, r1
a01a54c0  01004ee3  movt     r0, #0xe001
a01a54c4  330401eb  bl       #0xa01e6598
a01a54c8  0040a0e1  mov      r4, r0
a01a54cc  020074e3  cmn      r4, #2
a01a54d0  d3feff1a  bne      #0xa01a5024
a01a54d4  0affffea  b        #0xa01a5104
a01a54d8  1800a0e3  mov      r0, #0x18
a01a54dc  01004ee3  movt     r0, #0xe001
a01a54e0  0120a0e1  mov      r2, r1
a01a54e4  2b0401eb  bl       #0xa01e6598
a01a54e8  0040a0e1  mov      r4, r0
a01a54ec  f6ffffea  b        #0xa01a54cc
a01a54f0  dc0f06e3  movw     r0, #0x6fdc
a01a54f4  0340a0e1  mov      r4, r3
a01a54f8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566fdc: 'Worng Setting for audio CODEC I/O mode setting'
a01a54fc  fa0604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5500  0c0007e3  movw     r0, #0x700c
a01a5504  56004ae3  movt     r0, #0xa056 ; constant 0xa056700c: 'eg: t svc aucodec setoutput 0 0x1'
a01a5508  f70604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a550c  300007e3  movw     r0, #0x7030
a01a5510  56004ae3  movt     r0, #0xa056 ; constant 0xa0567030: 'eg: t svc aucodec setinput 0 0x1'
a01a5514  f40604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5518  c1feffea  b        #0xa01a5024
a01a551c  0100a0e3  mov      r0, #1
a01a5520  0120a0e1  mov      r2, r1
a01a5524  01004ee3  movt     r0, #0xe001
a01a5528  1a0401eb  bl       #0xa01e6598
a01a552c  0040a0e1  mov      r4, r0
a01a5530  e5ffffea  b        #0xa01a54cc
a01a5534  020ca0e3  mov      r0, #0x200
a01a5538  dafeffea  b        #0xa01a50a8
a01a553c  010800e3  movw     r0, #0x801
a01a5540  0120a0e1  mov      r2, r1
a01a5544  01004ee3  movt     r0, #0xe001
a01a5548  120401eb  bl       #0xa01e6598
a01a554c  0040a0e1  mov      r4, r0
a01a5550  ddffffea  b        #0xa01a54cc
a01a5554  0c0097e5  ldr      r0, [r7, #0xc]
a01a5558  0040a0e3  mov      r4, #0
a01a555c  514a0dfa  blx      #0xa04f7ea8
a01a5560  0080a0e1  mov      r8, r0
a01a5564  100097e5  ldr      r0, [r7, #0x10]
a01a5568  4e4a0dfa  blx      #0xa04f7ea8
a01a556c  5c3001e3  movw     r3, #0x105c
a01a5570  0050a0e1  mov      r5, r0
a01a5574  a3314ae3  movt     r3, #0xa1a3
a01a5578  7000efe6  uxtb     r0, r0
a01a557c  083193e7  ldr      r3, [r3, r8, lsl #2]
a01a5580  0c3093e5  ldr      r3, [r3, #0xc]
a01a5584  33ff2fe1  blx      r3
a01a5588  100f06e3  movw     r0, #0x6f10
a01a558c  0810a0e1  mov      r1, r8
a01a5590  0520a0e1  mov      r2, r5
a01a5594  56004ae3  movt     r0, #0xa056 ; constant 0xa0566f10: '<AUCODEC> Set audio %d CODEC output mode as 0x%x\n'
a01a5598  36ff2fe1  blx      r6
a01a559c  a0feffea  b        #0xa01a5024
a01a55a0  0c0097e5  ldr      r0, [r7, #0xc]
a01a55a4  3f4a0dfa  blx      #0xa04f7ea8
a01a55a8  0050a0e1  mov      r5, r0
a01a55ac  100097e5  ldr      r0, [r7, #0x10]
a01a55b0  3c4a0dfa  blx      #0xa04f7ea8
a01a55b4  0080a0e1  mov      r8, r0
a01a55b8  140097e5  ldr      r0, [r7, #0x14]
a01a55bc  394a0dfa  blx      #0xa04f7ea8
a01a55c0  5c3001e3  movw     r3, #0x105c
a01a55c4  7010ffe6  uxth     r1, r0
a01a55c8  a3314ae3  movt     r3, #0xa1a3
a01a55cc  7800ffe6  uxth     r0, r8
a01a55d0  053193e7  ldr      r3, [r3, r5, lsl #2]
a01a55d4  203093e5  ldr      r3, [r3, #0x20]
a01a55d8  33ff2fe1  blx      r3
a01a55dc  000050e3  cmp      r0, #0
a01a55e0  aaffff0a  beq      #0xa01a5490
a01a55e4  840f06e3  movw     r0, #0x6f84
a01a55e8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566f84: '<AUCODEC> AmbaAudio_CodecWrite: NG\n'
a01a55ec  36ff2fe1  blx      r6
a01a55f0  8bfeffea  b        #0xa01a5024
a01a55f4  0c0097e5  ldr      r0, [r7, #0xc]
a01a55f8  2a4a0dfa  blx      #0xa04f7ea8
a01a55fc  0050a0e1  mov      r5, r0
a01a5600  100097e5  ldr      r0, [r7, #0x10]
a01a5604  274a0dfa  blx      #0xa04f7ea8
a01a5608  0040a0e1  mov      r4, r0
a01a560c  140097e5  ldr      r0, [r7, #0x14]
a01a5610  244a0dfa  blx      #0xa04f7ea8
a01a5614  000050e3  cmp      r0, #0
a01a5618  9cffff0a  beq      #0xa01a5490
a01a561c  5c8001e3  movw     r8, #0x105c
a01a5620  007084e0  add      r7, r4, r0
a01a5624  a3814ae3  movt     r8, #0xa1a3
a01a5628  053198e7  ldr      r3, [r8, r5, lsl #2]
a01a562c  7400ffe6  uxth     r0, r4
a01a5630  243093e5  ldr      r3, [r3, #0x24]
a01a5634  33ff2fe1  blx      r3
a01a5638  0030a0e1  mov      r3, r0
a01a563c  a80f06e3  movw     r0, #0x6fa8
a01a5640  0420a0e1  mov      r2, r4
a01a5644  56004ae3  movt     r0, #0xa056 ; constant 0xa0566fa8: '<AUCODEC> AmbaAudio_CodecRead: 0x%x, 0x%x, 0x%x\n'
a01a5648  0510a0e1  mov      r1, r5
a01a564c  014084e2  add      r4, r4, #1
a01a5650  36ff2fe1  blx      r6
a01a5654  070054e1  cmp      r4, r7
a01a5658  f2ffff1a  bne      #0xa01a5628
a01a565c  8bffffea  b        #0xa01a5490
a01a5660  0200a0e3  mov      r0, #2
a01a5664  0120a0e1  mov      r2, r1
a01a5668  01004ee3  movt     r0, #0xe001
a01a566c  c90301eb  bl       #0xa01e6598
a01a5670  0040a0e1  mov      r4, r0
a01a5674  94ffffea  b        #0xa01a54cc
a01a5678  0c0097e5  ldr      r0, [r7, #0xc]
a01a567c  094a0dfa  blx      #0xa04f7ea8
a01a5680  0080a0e1  mov      r8, r0
a01a5684  100097e5  ldr      r0, [r7, #0x10]
a01a5688  064a0dfa  blx      #0xa04f7ea8
a01a568c  5c3001e3  movw     r3, #0x105c
a01a5690  0050a0e1  mov      r5, r0
a01a5694  a3314ae3  movt     r3, #0xa1a3
a01a5698  7000efe6  uxtb     r0, r0
a01a569c  083193e7  ldr      r3, [r3, r8, lsl #2]
a01a56a0  103093e5  ldr      r3, [r3, #0x10]
a01a56a4  33ff2fe1  blx      r3
a01a56a8  500f06e3  movw     r0, #0x6f50
a01a56ac  0810a0e1  mov      r1, r8
a01a56b0  0520a0e1  mov      r2, r5
a01a56b4  56004ae3  movt     r0, #0xa056 ; constant 0xa0566f50: '<AUCODEC> Set audio %d CODEC input mode as 0x%x\n'
a01a56b8  36ff2fe1  blx      r6
a01a56bc  58feffea  b        #0xa01a5024
a01a56c0  781c06e3  movw     r1, #0x6c78
a01a56c4  0500a0e1  mov      r0, r5
a01a56c8  56104ae3  movt     r1, #0xa056 ; constant 0xa0566c78: 'shutter_piv'
a01a56cc  1c500dfa  blx      #0xa04f9744
a01a56d0  004050e2  subs     r4, r0, #0
a01a56d4  e001000a  beq      #0xa01a5e5c
a01a56d8  981c06e3  movw     r1, #0x6c98
a01a56dc  0500a0e1  mov      r0, r5
a01a56e0  56104ae3  movt     r1, #0xa056 ; constant 0xa0566c98: 'shutter_rel'
a01a56e4  16500dfa  blx      #0xa04f9744
a01a56e8  001050e2  subs     r1, r0, #0
a01a56ec  6501000a  beq      #0xa01a5c88
a01a56f0  981f0ae3  movw     r1, #0xaf98
a01a56f4  0500a0e1  mov      r0, r5
a01a56f8  53104ae3  movt     r1, #0xa053 ; constant 0xa053af98: 'record'
a01a56fc  10500dfa  blx      #0xa04f9744
a01a5700  000050e3  cmp      r0, #0
a01a5704  4601001a  bne      #0xa01a5c24
a01a5708  030058e3  cmp      r8, #3
a01a570c  4001000a  beq      #0xa01a5c14
a01a5710  0c0097e5  ldr      r0, [r7, #0xc]
a01a5714  e1490dfa  blx      #0xa04f7ea0
a01a5718  0040a0e1  mov      r4, r0
a01a571c  a40c06e3  movw     r0, #0x6ca4
a01a5720  0410a0e1  mov      r1, r4
a01a5724  56004ae3  movt     r0, #0xa056 ; constant 0xa0566ca4: 'input timelapse is %d'
a01a5728  6f0604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a572c  040054e3  cmp      r4, #4
a01a5730  2e01000a  beq      #0xa01a5bf0
a01a5734  2b0100da  ble      #0xa01a5be8
a01a5738  0a0054e3  cmp      r4, #0xa
a01a573c  2b01000a  beq      #0xa01a5bf0
a01a5740  3c0054e3  cmp      r4, #0x3c
a01a5744  2901000a  beq      #0xa01a5bf0
a01a5748  d80c06e3  movw     r0, #0x6cd8
a01a574c  56004ae3  movt     r0, #0xa056 ; constant 0xa0566cd8: 'invalid param ,please input 0/2/4/10/60/1'
a01a5750  650604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5754  040058e3  cmp      r8, #4
a01a5758  0a00000a  beq      #0xa01a5788
a01a575c  100097e5  ldr      r0, [r7, #0x10]
a01a5760  ce490dfa  blx      #0xa04f7ea0
a01a5764  0050a0e1  mov      r5, r0
a01a5768  300d06e3  movw     r0, #0x6d30
a01a576c  0510a0e1  mov      r1, r5
a01a5770  56004ae3  movt     r0, #0xa056 ; constant 0xa0566d30: 'int put recordpiv = %d'
a01a5774  5c0604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5778  000054e3  cmp      r4, #0
a01a577c  0500a001  moveq    r0, r5
a01a5780  0000a013  movne    r0, #0
a01a5784  05ee01eb  bl       #0xa0220fa0
a01a5788  0c00a0e3  mov      r0, #0xc
a01a578c  0010a0e3  mov      r1, #0
a01a5790  01004ee3  movt     r0, #0xe001
a01a5794  0120a0e1  mov      r2, r1
a01a5798  7e0301eb  bl       #0xa01e6598
a01a579c  0040a0e1  mov      r4, r0
a01a57a0  49ffffea  b        #0xa01a54cc
a01a57a4  0300a0e3  mov      r0, #3
a01a57a8  0120a0e1  mov      r2, r1
a01a57ac  01004ee3  movt     r0, #0xe001
a01a57b0  780301eb  bl       #0xa01e6598
a01a57b4  0040a0e1  mov      r4, r0
a01a57b8  43ffffea  b        #0xa01a54cc
a01a57bc  030800e3  movw     r0, #0x803
a01a57c0  0120a0e1  mov      r2, r1
a01a57c4  01004ee3  movt     r0, #0xe001
a01a57c8  720301eb  bl       #0xa01e6598
a01a57cc  0040a0e1  mov      r4, r0
a01a57d0  3dffffea  b        #0xa01a54cc
a01a57d4  0800a0e3  mov      r0, #8
a01a57d8  0120a0e1  mov      r2, r1
a01a57dc  01004ee3  movt     r0, #0xe001
a01a57e0  6c0301eb  bl       #0xa01e6598
a01a57e4  0040a0e1  mov      r4, r0
a01a57e8  37ffffea  b        #0xa01a54cc
a01a57ec  080800e3  movw     r0, #0x808
a01a57f0  0120a0e1  mov      r2, r1
a01a57f4  01004ee3  movt     r0, #0xe001
a01a57f8  660301eb  bl       #0xa01e6598
a01a57fc  0040a0e1  mov      r4, r0
a01a5800  31ffffea  b        #0xa01a54cc
a01a5804  0900a0e3  mov      r0, #9
a01a5808  0120a0e1  mov      r2, r1
a01a580c  01004ee3  movt     r0, #0xe001
a01a5810  600301eb  bl       #0xa01e6598
a01a5814  0040a0e1  mov      r4, r0
a01a5818  2bffffea  b        #0xa01a54cc
a01a581c  090800e3  movw     r0, #0x809
a01a5820  0120a0e1  mov      r2, r1
a01a5824  01004ee3  movt     r0, #0xe001
a01a5828  5a0301eb  bl       #0xa01e6598
a01a582c  0040a0e1  mov      r4, r0
a01a5830  25ffffea  b        #0xa01a54cc
a01a5834  1100a0e3  mov      r0, #0x11
a01a5838  0120a0e1  mov      r2, r1
a01a583c  01004ee3  movt     r0, #0xe001
a01a5840  540301eb  bl       #0xa01e6598
a01a5844  0040a0e1  mov      r4, r0
a01a5848  1fffffea  b        #0xa01a54cc
a01a584c  2200a0e3  mov      r0, #0x22
a01a5850  0120a0e1  mov      r2, r1
a01a5854  01004ee3  movt     r0, #0xe001
a01a5858  4e0301eb  bl       #0xa01e6598
a01a585c  0040a0e1  mov      r4, r0
a01a5860  19ffffea  b        #0xa01a54cc
a01a5864  0d00a0e3  mov      r0, #0xd
a01a5868  0120a0e1  mov      r2, r1
a01a586c  01004ee3  movt     r0, #0xe001
a01a5870  480301eb  bl       #0xa01e6598
a01a5874  0040a0e1  mov      r4, r0
a01a5878  13ffffea  b        #0xa01a54cc
a01a587c  c01b06e3  movw     r1, #0x6bc0
a01a5880  0500a0e1  mov      r0, r5
a01a5884  56104ae3  movt     r1, #0xa056 ; constant 0xa0566bc0: 'shutter_stamp'
a01a5888  ad4f0dfa  blx      #0xa04f9744
a01a588c  000050e3  cmp      r0, #0
a01a5890  2000001a  bne      #0xa01a5918
a01a5894  030058e3  cmp      r8, #3
a01a5898  d45c05e3  movw     r5, #0x5cd4
a01a589c  05514ae3  movt     r5, #0xa105
a01a58a0  1700001a  bne      #0xa01a5904
a01a58a4  003095e5  ldr      r3, [r5]
a01a58a8  2500c3e5  strb     r0, [r3, #0x25]
a01a58ac  003095e5  ldr      r3, [r5]
a01a58b0  0000a0e3  mov      r0, #0
a01a58b4  1c20d3e5  ldrb     r2, [r3, #0x1c]
a01a58b8  9f21c5e7  bfc      r2, #3, #3
a01a58bc  1c20c3e5  strb     r2, [r3, #0x1c]
a01a58c0  a5b801eb  bl       #0xa0213b5c
a01a58c4  0e00a0e3  mov      r0, #0xe
a01a58c8  afffffea  b        #0xa01a578c
a01a58cc  7c5003e3  movw     r5, #0x307c
a01a58d0  dc0a06e3  movw     r0, #0x6adc
a01a58d4  6f504ae3  movt     r5, #0xa06f
a01a58d8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566adc: '%s---------------> shutter to stop vf,Argc=%d\n'
a01a58dc  0c1095e5  ldr      r1, [r5, #0xc]
a01a58e0  0820a0e1  mov      r2, r8
a01a58e4  000604eb  bl       #0xa02a70ec ; analyst_printf_like
a01a58e8  030058e3  cmp      r8, #3
a01a58ec  2000001a  bne      #0xa01a5974
a01a58f0  0c0b06e3  movw     r0, #0x6b0c
a01a58f4  0c1095e5  ldr      r1, [r5, #0xc]
a01a58f8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566b0c: '%sinvalid pa ram---------------> Argc=4,precise:0,pes:1,burst:2,selftime:5\n'
a01a58fc  fa0504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5900  c7fdffea  b        #0xa01a5024
a01a5904  0c0097e5  ldr      r0, [r7, #0xc]
a01a5908  64490dfa  blx      #0xa04f7ea0
a01a590c  030050e3  cmp      r0, #3
a01a5910  e5ffff8a  bhi      #0xa01a58ac
a01a5914  e2ffffea  b        #0xa01a58a4
a01a5918  d01b06e3  movw     r1, #0x6bd0
a01a591c  0500a0e1  mov      r0, r5
a01a5920  56104ae3  movt     r1, #0xa056 ; constant 0xa0566bd0: 'shutter_precise'
a01a5924  864f0dfa  blx      #0xa04f9744
a01a5928  004050e2  subs     r4, r0, #0
a01a592c  5700000a  beq      #0xa01a5a90
a01a5930  f81b06e3  movw     r1, #0x6bf8
a01a5934  0500a0e1  mov      r0, r5
a01a5938  56104ae3  movt     r1, #0xa056 ; constant 0xa0566bf8: 'shutter_precise_selftimer'
a01a593c  804f0dfa  blx      #0xa04f9744
a01a5940  000050e3  cmp      r0, #0
a01a5944  3800001a  bne      #0xa01a5a2c
a01a5948  030058e3  cmp      r8, #3
a01a594c  1d00001a  bne      #0xa01a59c8
a01a5950  140c06e3  movw     r0, #0x6c14
a01a5954  0040a0e3  mov      r4, #0
a01a5958  56004ae3  movt     r0, #0xa056 ; constant 0xa0566c14: '--shutter_ precise selftimer--'
a01a595c  e20504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5960  d45c05e3  movw     r5, #0x5cd4
a01a5964  05514ae3  movt     r5, #0xa105
a01a5968  003095e5  ldr      r3, [r5]
a01a596c  1f40c3e5  strb     r4, [r3, #0x1f]
a01a5970  cdffffea  b        #0xa01a58ac
a01a5974  0c0097e5  ldr      r0, [r7, #0xc]
a01a5978  d45c05e3  movw     r5, #0x5cd4
a01a597c  47490dfa  blx      #0xa04f7ea0
a01a5980  050050e3  cmp      r0, #5
a01a5984  0030a0e1  mov      r3, r0
a01a5988  05514a03  movteq   r5, #0xa105
a01a598c  05514a13  movtne   r5, #0xa105
a01a5990  00209505  ldreq    r2, [r5]
a01a5994  0310a003  moveq    r1, #3
a01a5998  00209515  ldrne    r2, [r5]
a01a599c  0430a001  moveq    r3, r4
a01a59a0  0300a0e1  mov      r0, r3
a01a59a4  1f10c205  strbeq   r1, [r2, #0x1f]
a01a59a8  1f40c215  strbne   r4, [r2, #0x1f]
a01a59ac  002095e5  ldr      r2, [r5]
a01a59b0  1c10d2e5  ldrb     r1, [r2, #0x1c]
a01a59b4  9311c5e7  bfi      r1, r3, #3, #3
a01a59b8  1c10c2e5  strb     r1, [r2, #0x1c]
a01a59bc  66b801eb  bl       #0xa0213b5c
a01a59c0  0e00a0e3  mov      r0, #0xe
a01a59c4  70ffffea  b        #0xa01a578c
a01a59c8  0c0097e5  ldr      r0, [r7, #0xc]
a01a59cc  33490dfa  blx      #0xa04f7ea0
a01a59d0  0040a0e1  mov      r4, r0
a01a59d4  140c06e3  movw     r0, #0x6c14
a01a59d8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566c14: '--shutter_ precise selftimer--'
a01a59dc  c20504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a59e0  0f0054e3  cmp      r4, #0xf
a01a59e4  04f19f97  ldrls    pc, [pc, r4, lsl #2]
a01a59e8  3a0000ea  b        #0xa01a5ad8
a01a59ec  60591aa0  andsge   r5, sl, r0, ror #18
a01a59f0  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a59f4  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a59f8  60591aa0  andsge   r5, sl, r0, ror #18
a01a59fc  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a00  60591aa0  andsge   r5, sl, r0, ror #18
a01a5a04  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a08  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a0c  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a10  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a14  60591aa0  andsge   r5, sl, r0, ror #18
a01a5a18  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a1c  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a20  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a24  d85a1aa0  ldrsbge  r5, [sl], -r8
a01a5a28  60591aa0  andsge   r5, sl, r0, ror #18
a01a5a2c  341c06e3  movw     r1, #0x6c34
a01a5a30  0500a0e1  mov      r0, r5
a01a5a34  56104ae3  movt     r1, #0xa056 ; constant 0xa0566c34: 'shutter_pes'
a01a5a38  414f0dfa  blx      #0xa04f9744
a01a5a3c  000050e3  cmp      r0, #0
a01a5a40  3e00001a  bne      #0xa01a5b40
a01a5a44  030058e3  cmp      r8, #3
a01a5a48  2500001a  bne      #0xa01a5ae4
a01a5a4c  400c06e3  movw     r0, #0x6c40
a01a5a50  0040a0e3  mov      r4, #0
a01a5a54  56004ae3  movt     r0, #0xa056 ; constant 0xa0566c40: '--shutter_ pes--'
a01a5a58  a30504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5a5c  d45c05e3  movw     r5, #0x5cd4
a01a5a60  05514ae3  movt     r5, #0xa105
a01a5a64  003095e5  ldr      r3, [r5]
a01a5a68  b642c3e1  strh     r4, [r3, #0x26]
a01a5a6c  003095e5  ldr      r3, [r5]
a01a5a70  0110a0e3  mov      r1, #1
a01a5a74  1c20d3e5  ldrb     r2, [r3, #0x1c]
a01a5a78  0100a0e1  mov      r0, r1
a01a5a7c  9121c5e7  bfi      r2, r1, #3, #3
a01a5a80  1c20c3e5  strb     r2, [r3, #0x1c]
a01a5a84  34b801eb  bl       #0xa0213b5c
a01a5a88  0e00a0e3  mov      r0, #0xe
a01a5a8c  3effffea  b        #0xa01a578c
a01a5a90  e00b06e3  movw     r0, #0x6be0
a01a5a94  56004ae3  movt     r0, #0xa056 ; constant 0xa0566be0: '--shutter_ precise--'
a01a5a98  930504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5a9c  d43c05e3  movw     r3, #0x5cd4
a01a5aa0  0400a0e1  mov      r0, r4
a01a5aa4  05314ae3  movt     r3, #0xa105
a01a5aa8  003093e5  ldr      r3, [r3]
a01a5aac  1c20d3e5  ldrb     r2, [r3, #0x1c]
a01a5ab0  9421c5e7  bfi      r2, r4, #3, #3
a01a5ab4  1c20c3e5  strb     r2, [r3, #0x1c]
a01a5ab8  27b801eb  bl       #0xa0213b5c
a01a5abc  0e00a0e3  mov      r0, #0xe
a01a5ac0  0410a0e1  mov      r1, r4
a01a5ac4  0420a0e1  mov      r2, r4
a01a5ac8  01004ee3  movt     r0, #0xe001
a01a5acc  b10201eb  bl       #0xa01e6598
a01a5ad0  0040a0e1  mov      r4, r0
a01a5ad4  7cfeffea  b        #0xa01a54cc
a01a5ad8  d45c05e3  movw     r5, #0x5cd4
a01a5adc  05514ae3  movt     r5, #0xa105
a01a5ae0  71ffffea  b        #0xa01a58ac
a01a5ae4  0c0097e5  ldr      r0, [r7, #0xc]
a01a5ae8  ec480dfa  blx      #0xa04f7ea0
a01a5aec  0040a0e1  mov      r4, r0
a01a5af0  400c06e3  movw     r0, #0x6c40
a01a5af4  56004ae3  movt     r0, #0xa056 ; constant 0xa0566c40: '--shutter_ pes--'
a01a5af8  7b0504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5afc  780054e3  cmp      r4, #0x78
a01a5b00  d5ffff0a  beq      #0xa01a5a5c
a01a5b04  270000da  ble      #0xa01a5ba8
a01a5b08  4b0e54e3  cmp      r4, #0x4b0
a01a5b0c  d2ffff0a  beq      #0xa01a5a5c
a01a5b10  1f0000da  ble      #0xa01a5b94
a01a5b14  203c01e3  movw     r3, #0x1c20
a01a5b18  030054e1  cmp      r4, r3
a01a5b1c  ceffff0a  beq      #0xa01a5a5c
a01a5b20  ff3f0fe3  movw     r3, #0xffff
a01a5b24  030054e1  cmp      r4, r3
a01a5b28  cbffff0a  beq      #0xa01a5a5c
a01a5b2c  e10e54e3  cmp      r4, #0xe10
a01a5b30  c9ffff0a  beq      #0xa01a5a5c
a01a5b34  d45c05e3  movw     r5, #0x5cd4
a01a5b38  05514ae3  movt     r5, #0xa105
a01a5b3c  caffffea  b        #0xa01a5a6c
a01a5b40  541c06e3  movw     r1, #0x6c54
a01a5b44  0500a0e1  mov      r0, r5
a01a5b48  56104ae3  movt     r1, #0xa056 ; constant 0xa0566c54: 'shutter_burst'
a01a5b4c  fc4e0dfa  blx      #0xa04f9744
a01a5b50  000050e3  cmp      r0, #0
a01a5b54  d9feff1a  bne      #0xa01a56c0
a01a5b58  030058e3  cmp      r8, #3
a01a5b5c  0030a001  moveq    r3, r0
a01a5b60  1800001a  bne      #0xa01a5bc8
a01a5b64  d45c05e3  movw     r5, #0x5cd4
a01a5b68  0300a0e1  mov      r0, r3
a01a5b6c  05514ae3  movt     r5, #0xa105
a01a5b70  002095e5  ldr      r2, [r5]
a01a5b74  1d30c2e5  strb     r3, [r2, #0x1d]
a01a5b78  23b801eb  bl       #0xa0213c0c
a01a5b7c  640c06e3  movw     r0, #0x6c64
a01a5b80  56004ae3  movt     r0, #0xa056 ; constant 0xa0566c64: '--shutter_ burst--'
a01a5b84  580504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5b88  003095e5  ldr      r3, [r5]
a01a5b8c  0210a0e3  mov      r1, #2
a01a5b90  b7ffffea  b        #0xa01a5a74
a01a5b94  f00054e3  cmp      r4, #0xf0
a01a5b98  afffff0a  beq      #0xa01a5a5c
a01a5b9c  960f54e3  cmp      r4, #0x258
a01a5ba0  e3ffff1a  bne      #0xa01a5b34
a01a5ba4  acffffea  b        #0xa01a5a5c
a01a5ba8  0a0054e3  cmp      r4, #0xa
a01a5bac  aaffff0a  beq      #0xa01a5a5c
a01a5bb0  ad0000da  ble      #0xa01a5e6c
a01a5bb4  140054e3  cmp      r4, #0x14
a01a5bb8  a7ffff0a  beq      #0xa01a5a5c
a01a5bbc  3c0054e3  cmp      r4, #0x3c
a01a5bc0  dbffff1a  bne      #0xa01a5b34
a01a5bc4  a4ffffea  b        #0xa01a5a5c
a01a5bc8  0c0097e5  ldr      r0, [r7, #0xc]
a01a5bcc  b3480dfa  blx      #0xa04f7ea0
a01a5bd0  020050e3  cmp      r0, #2
a01a5bd4  0030a0e1  mov      r3, r0
a01a5bd8  e1ffff9a  bls      #0xa01a5b64
a01a5bdc  d45c05e3  movw     r5, #0x5cd4
a01a5be0  05514ae3  movt     r5, #0xa105
a01a5be4  e4ffffea  b        #0xa01a5b7c
a01a5be8  020054e3  cmp      r4, #2
a01a5bec  d5feff8a  bhi      #0xa01a5748
a01a5bf0  bc0c06e3  movw     r0, #0x6cbc
a01a5bf4  0410a0e1  mov      r1, r4
a01a5bf8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566cbc: '---input tim elapse is %d'
a01a5bfc  3a0504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5c00  0400a0e1  mov      r0, r4
a01a5c04  dee601eb  bl       #0xa021f784
a01a5c08  0000a0e3  mov      r0, #0
a01a5c0c  e3ec01eb  bl       #0xa0220fa0
a01a5c10  cffeffea  b        #0xa01a5754
a01a5c14  040d06e3  movw     r0, #0x6d04
a01a5c18  56004ae3  movt     r0, #0xa056 ; constant 0xa0566d04: 'default param,please input 0/2/4/10/60/1'
a01a5c1c  320504eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5c20  d8feffea  b        #0xa01a5788
a01a5c24  d81307e3  movw     r1, #0x73d8
a01a5c28  0500a0e1  mov      r0, r5
a01a5c2c  5c104ae3  movt     r1, #0xa05c ; constant 0xa05c73d8: 'mode'
a01a5c30  c34e0dfa  blx      #0xa04f9744
a01a5c34  001050e2  subs     r1, r0, #0
a01a5c38  8e00000a  beq      #0xa01a5e78
a01a5c3c  481d06e3  movw     r1, #0x6d48
a01a5c40  0500a0e1  mov      r0, r5
a01a5c44  56104ae3  movt     r1, #0xa056 ; constant 0xa0566d48: 'power'
a01a5c48  bd4e0dfa  blx      #0xa04f9744
a01a5c4c  001050e2  subs     r1, r0, #0
a01a5c50  3600000a  beq      #0xa01a5d30
a01a5c54  501d06e3  movw     r1, #0x6d50
a01a5c58  0500a0e1  mov      r0, r5
a01a5c5c  56104ae3  movt     r1, #0xa056 ; constant 0xa0566d50: 'autopf'
a01a5c60  b74e0dfa  blx      #0xa04f9744
a01a5c64  000050e3  cmp      r0, #0
a01a5c68  0c00001a  bne      #0xa01a5ca0
a01a5c6c  d43c05e3  movw     r3, #0x5cd4
a01a5c70  3c20a0e3  mov      r2, #0x3c
a01a5c74  05314ae3  movt     r3, #0xa105
a01a5c78  0040a0e1  mov      r4, r0
a01a5c7c  003093e5  ldr      r3, [r3]
a01a5c80  b827c3e1  strh     r2, [r3, #0x78]
a01a5c84  e6fcffea  b        #0xa01a5024
a01a5c88  0e0800e3  movw     r0, #0x80e
a01a5c8c  0120a0e1  mov      r2, r1
a01a5c90  01004ee3  movt     r0, #0xe001
a01a5c94  3f0201eb  bl       #0xa01e6598
a01a5c98  0040a0e1  mov      r4, r0
a01a5c9c  0afeffea  b        #0xa01a54cc
a01a5ca0  581d06e3  movw     r1, #0x6d58
a01a5ca4  0500a0e1  mov      r0, r5
a01a5ca8  56104ae3  movt     r1, #0xa056 ; constant 0xa0566d58: 'power_rel'
a01a5cac  a44e0dfa  blx      #0xa04f9744
a01a5cb0  001050e2  subs     r1, r0, #0
a01a5cb4  d700000a  beq      #0xa01a6018
a01a5cb8  201d0ce3  movw     r1, #0xcd20
a01a5cbc  0500a0e1  mov      r0, r5
a01a5cc0  55104ae3  movt     r1, #0xa055 ; constant 0xa055cd20: 'del'
a01a5cc4  9e4e0dfa  blx      #0xa04f9744
a01a5cc8  001050e2  subs     r1, r0, #0
a01a5ccc  01feff0a  beq      #0xa01a54d8
a01a5cd0  641d06e3  movw     r1, #0x6d64
a01a5cd4  0500a0e1  mov      r0, r5
a01a5cd8  56104ae3  movt     r1, #0xa056 ; constant 0xa0566d64: 'start_wifi'
a01a5cdc  984e0dfa  blx      #0xa04f9744
a01a5ce0  000050e3  cmp      r0, #0
a01a5ce4  7300000a  beq      #0xa01a5eb8
a01a5ce8  a81d06e3  movw     r1, #0x6da8
a01a5cec  0500a0e1  mov      r0, r5
a01a5cf0  56104ae3  movt     r1, #0xa056 ; constant 0xa0566da8: 'stop_wifi'
a01a5cf4  924e0dfa  blx      #0xa04f9744
a01a5cf8  004050e2  subs     r4, r0, #0
a01a5cfc  6900000a  beq      #0xa01a5ea8
a01a5d00  dc1d06e3  movw     r1, #0x6ddc
a01a5d04  0500a0e1  mov      r0, r5
a01a5d08  56104ae3  movt     r1, #0xa056 ; constant 0xa0566ddc: 'pc'
a01a5d0c  8c4e0dfa  blx      #0xa04f9744
a01a5d10  004050e2  subs     r4, r0, #0
a01a5d14  fafcff1a  bne      #0xa01a5104
a01a5d18  040058e3  cmp      r8, #4
a01a5d1c  5b00001a  bne      #0xa01a5e90
a01a5d20  0c0097e5  ldr      r0, [r7, #0xc]
a01a5d24  5d480dfa  blx      #0xa04f7ea0
a01a5d28  76fcffeb  bl       #0xa01a4f08
a01a5d2c  bcfcffea  b        #0xa01a5024
a01a5d30  0600a0e3  mov      r0, #6
a01a5d34  88dcffeb  bl       #0xa019cf5c
a01a5d38  0040a0e1  mov      r4, r0
a01a5d3c  e2fdffea  b        #0xa01a54cc
a01a5d40  6f304ae3  movt     r3, #0xa06f
a01a5d44  100097e5  ldr      r0, [r7, #0x10]
a01a5d48  0c5093e5  ldr      r5, [r3, #0xc]
a01a5d4c  53480dfa  blx      #0xa04f7ea0
a01a5d50  0020a0e1  mov      r2, r0
a01a5d54  900b06e3  movw     r0, #0x6b90
a01a5d58  0510a0e1  mov      r1, r5
a01a5d5c  56004ae3  movt     r0, #0xa056 ; constant 0xa0566b90: '%s---------------> factory  fosd,Argv[4]=%d\n'
a01a5d60  e10404eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5d64  0c5097e5  ldr      r5, [r7, #0xc]
a01a5d68  100097e5  ldr      r0, [r7, #0x10]
a01a5d6c  4b480dfa  blx      #0xa04f7ea0
a01a5d70  0020a0e1  mov      r2, r0
a01a5d74  0100a0e3  mov      r0, #1
a01a5d78  0510a0e1  mov      r1, r5
a01a5d7c  07084de3  movt     r0, #0xd807
a01a5d80  040201eb  bl       #0xa01e6598
a01a5d84  a6fcffea  b        #0xa01a5024
a01a5d88  0c0097e5  ldr      r0, [r7, #0xc]
a01a5d8c  43480dfa  blx      #0xa04f7ea0
a01a5d90  000050e3  cmp      r0, #0
a01a5d94  2d00000a  beq      #0xa01a5e50
a01a5d98  030050e3  cmp      r0, #3
a01a5d9c  2800000a  beq      #0xa01a5e44
a01a5da0  050050e3  cmp      r0, #5
a01a5da4  1e00000a  beq      #0xa01a5e24
a01a5da8  0a0050e3  cmp      r0, #0xa
a01a5dac  1100000a  beq      #0xa01a5df8
a01a5db0  680a06e3  movw     r0, #0x6a68
a01a5db4  0c1097e5  ldr      r1, [r7, #0xc]
a01a5db8  56004ae3  movt     r0, #0xa056 ; constant 0xa0566a68: '<save poweroff> invalid param: %s'
a01a5dbc  ca0404eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5dc0  97fcffea  b        #0xa01a5024
a01a5dc4  0d0800e3  movw     r0, #0x80d
a01a5dc8  0120a0e1  mov      r2, r1
a01a5dcc  01004ee3  movt     r0, #0xe001
a01a5dd0  f00101eb  bl       #0xa01e6598
a01a5dd4  0040a0e1  mov      r4, r0
a01a5dd8  bbfdffea  b        #0xa01a54cc
a01a5ddc  d43c05e3  movw     r3, #0x5cd4
a01a5de0  05314ae3  movt     r3, #0xa105
a01a5de4  003093e5  ldr      r3, [r3]
a01a5de8  7a00c3e5  strb     r0, [r3, #0x7a]
a01a5dec  8c7cfdeb  bl       #0xa0105024
a01a5df0  0040a0e1  mov      r4, r0
a01a5df4  b4fdffea  b        #0xa01a54cc
a01a5df8  d80f0de3  movw     r0, #0xdfd8
a01a5dfc  54004ae3  movt     r0, #0xa054 ; constant 0xa054dfd8: '10 minutes'
a01a5e00  0110a0e3  mov      r1, #1
a01a5e04  b1a4feeb  bl       #0xa014f0d0
a01a5e08  004050e2  subs     r4, r0, #0
a01a5e0c  0700001a  bne      #0xa01a5e30
a01a5e10  8c0a06e3  movw     r0, #0x6a8c
a01a5e14  0c1097e5  ldr      r1, [r7, #0xc]
a01a5e18  56004ae3  movt     r0, #0xa056 ; constant 0xa0566a8c: '<save poweroff> successfuly: %s'
a01a5e1c  b20404eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5e20  7ffcffea  b        #0xa01a5024
a01a5e24  680e0de3  movw     r0, #0xde68
a01a5e28  54004ae3  movt     r0, #0xa054 ; constant 0xa054de68: '5 minutes'
a01a5e2c  f3ffffea  b        #0xa01a5e00
a01a5e30  ac0a06e3  movw     r0, #0x6aac
a01a5e34  0410a0e1  mov      r1, r4
a01a5e38  56004ae3  movt     r0, #0xa056 ; constant 0xa0566aac: '<save poweroff> failed: %d'
a01a5e3c  aa0404eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5e40  a1fdffea  b        #0xa01a54cc
a01a5e44  cc0f0de3  movw     r0, #0xdfcc
a01a5e48  54004ae3  movt     r0, #0xa054 ; constant 0xa054dfcc: '3 minutes'
a01a5e4c  ebffffea  b        #0xa01a5e00
a01a5e50  fc0a0ce3  movw     r0, #0xcafc
a01a5e54  5c004ae3  movt     r0, #0xa05c ; constant 0xa05ccafc: 'off'
a01a5e58  e8ffffea  b        #0xa01a5e00
a01a5e5c  840c06e3  movw     r0, #0x6c84
a01a5e60  56004ae3  movt     r0, #0xa056 ; constant 0xa0566c84: 'shutter_ no stop--'
a01a5e64  a00404eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5e68  13ffffea  b        #0xa01a5abc
a01a5e6c  020054e3  cmp      r4, #2
a01a5e70  2fffff8a  bhi      #0xa01a5b34
a01a5e74  f8feffea  b        #0xa01a5a5c
a01a5e78  0f00a0e3  mov      r0, #0xf
a01a5e7c  0120a0e1  mov      r2, r1
a01a5e80  01004ee3  movt     r0, #0xe001
a01a5e84  c30101eb  bl       #0xa01e6598
a01a5e88  0040a0e1  mov      r4, r0
a01a5e8c  8efdffea  b        #0xa01a54cc
a01a5e90  e00d06e3  movw     r0, #0x6de0
a01a5e94  0510a0e1  mov      r1, r5
a01a5e98  56004ae3  movt     r0, #0xa056 ; constant 0xa0566de0: '[USAGE]:%s [0/1]\n'
a01a5e9c  0040e0e3  mvn      r4, #0
a01a5ea0  36ff2fe1  blx      r6
a01a5ea4  5efcffea  b        #0xa01a5024
a01a5ea8  b40d06e3  movw     r0, #0x6db4
a01a5eac  56004ae3  movt     r0, #0xa056 ; constant 0xa0566db4: '/usr/local/share/script/wifi_stop.sh'
a01a5eb0  144e0beb  bl       #0xa0479708
a01a5eb4  5afcffea  b        #0xa01a5024
a01a5eb8  010aa0e3  mov      r0, #0x1000
a01a5ebc  ea490dfa  blx      #0xa04f866c
a01a5ec0  004050e2  subs     r4, r0, #0
a01a5ec4  5100000a  beq      #0xa01a6010
a01a5ec8  030058e3  cmp      r8, #3
a01a5ecc  70ed06e3  movw     lr, #0x6d70
a01a5ed0  04c0a0e1  mov      ip, r4
a01a5ed4  56e04ae3  movt     lr, #0xa056 ; constant 0xa0566d70: '/usr/local/share/script/wifi_xy_start.sh'
a01a5ed8  4400000a  beq      #0xa01a5ff0
a01a5edc  0f00bee8  ldm      lr!, {r0, r1, r2, r3}
a01a5ee0  b45400e3  movw     r5, #0x4b4
a01a5ee4  55504ae3  movt     r5, #0xa055 ; constant 0xa05504b4: 'ssid'
a01a5ee8  0f00ace8  stm      ip!, {r0, r1, r2, r3}
a01a5eec  0f00bee8  ldm      lr!, {r0, r1, r2, r3}
a01a5ef0  0f00ace8  stm      ip!, {r0, r1, r2, r3}
a01a5ef4  07009ee8  ldm      lr, {r0, r1, r2}
a01a5ef8  0300ace8  stm      ip!, {r0, r1}
a01a5efc  0510a0e1  mov      r1, r5
a01a5f00  0020cce5  strb     r2, [ip]
a01a5f04  0c0097e5  ldr      r0, [r7, #0xc]
a01a5f08  0d4e0dfa  blx      #0xa04f9744
a01a5f0c  000050e3  cmp      r0, #0
a01a5f10  0c00001a  bne      #0xa01a5f48
a01a5f14  106097e5  ldr      r6, [r7, #0x10]
a01a5f18  0600a0e1  mov      r0, r6
a01a5f1c  b34e0dfa  blx      #0xa04f99f0
a01a5f20  1f0050e3  cmp      r0, #0x1f
a01a5f24  0700008a  bhi      #0xa01a5f48
a01a5f28  000095e5  ldr      r0, [r5]
a01a5f2c  2030a0e3  mov      r3, #0x20
a01a5f30  0610a0e1  mov      r1, r6
a01a5f34  2830c4e5  strb     r3, [r4, #0x28]
a01a5f38  2d30c4e5  strb     r3, [r4, #0x2d]
a01a5f3c  290084e5  str      r0, [r4, #0x29]
a01a5f40  2e0084e2  add      r0, r4, #0x2e
a01a5f44  6d4e0dfa  blx      #0xa04f9900
a01a5f48  145097e5  ldr      r5, [r7, #0x14]
a01a5f4c  9c1d06e3  movw     r1, #0x6d9c
a01a5f50  56104ae3  movt     r1, #0xa056 ; constant 0xa0566d9c: '5G'
a01a5f54  0500a0e1  mov      r0, r5
a01a5f58  f94d0dfa  blx      #0xa04f9744
a01a5f5c  000050e3  cmp      r0, #0
a01a5f60  0700001a  bne      #0xa01a5f84
a01a5f64  0400a0e1  mov      r0, r4
a01a5f68  a04e0dfa  blx      #0xa04f99f0
a01a5f6c  2020a0e3  mov      r2, #0x20
a01a5f70  013080e2  add      r3, r0, #1
a01a5f74  0020c4e7  strb     r2, [r4, r0]
a01a5f78  0510a0e1  mov      r1, r5
a01a5f7c  030084e0  add      r0, r4, r3
a01a5f80  5e4e0dfa  blx      #0xa04f9900
a01a5f84  c41007e3  movw     r1, #0x70c4
a01a5f88  0500a0e1  mov      r0, r5
a01a5f8c  56104ae3  movt     r1, #0xa056 ; constant 0xa05670c4: '2.4G'
a01a5f90  eb4d0dfa  blx      #0xa04f9744
a01a5f94  000050e3  cmp      r0, #0
a01a5f98  0700001a  bne      #0xa01a5fbc
a01a5f9c  0400a0e1  mov      r0, r4
a01a5fa0  924e0dfa  blx      #0xa04f99f0
a01a5fa4  2020a0e3  mov      r2, #0x20
a01a5fa8  013080e2  add      r3, r0, #1
a01a5fac  0020c4e7  strb     r2, [r4, r0]
a01a5fb0  0510a0e1  mov      r1, r5
a01a5fb4  030084e0  add      r0, r4, r3
a01a5fb8  504e0dfa  blx      #0xa04f9900
a01a5fbc  7c3003e3  movw     r3, #0x307c
a01a5fc0  a00d06e3  movw     r0, #0x6da0
a01a5fc4  6f304ae3  movt     r3, #0xa06f
a01a5fc8  0420a0e1  mov      r2, r4
a01a5fcc  0c1093e5  ldr      r1, [r3, #0xc]
a01a5fd0  56004ae3  movt     r0, #0xa056 ; constant 0xa0566da0: '%s%s\n\n'
a01a5fd4  440404eb  bl       #0xa02a70ec ; analyst_printf_like
a01a5fd8  0400a0e1  mov      r0, r4
a01a5fdc  c94d0beb  bl       #0xa0479708
a01a5fe0  0400a0e1  mov      r0, r4
a01a5fe4  0040a0e3  mov      r4, #0
a01a5fe8  a3490dfa  blx      #0xa04f867c
a01a5fec  0cfcffea  b        #0xa01a5024
a01a5ff0  0f00bee8  ldm      lr!, {r0, r1, r2, r3}
a01a5ff4  0f00ace8  stm      ip!, {r0, r1, r2, r3}
a01a5ff8  0f00bee8  ldm      lr!, {r0, r1, r2, r3}
a01a5ffc  0f00ace8  stm      ip!, {r0, r1, r2, r3}
a01a6000  07009ee8  ldm      lr, {r0, r1, r2}
a01a6004  0300ace8  stm      ip!, {r0, r1}
a01a6008  0020cce5  strb     r2, [ip]
a01a600c  eaffffea  b        #0xa01a5fbc
a01a6010  0040e0e3  mvn      r4, #0
a01a6014  02fcffea  b        #0xa01a5024
a01a6018  0a0800e3  movw     r0, #0x80a
a01a601c  0120a0e1  mov      r2, r1
a01a6020  01004ee3  movt     r0, #0xe001
a01a6024  5b0101eb  bl       #0xa01e6598
a01a6028  0040a0e1  mov      r4, r0
a01a602c  26fdffea  b        #0xa01a54cc
