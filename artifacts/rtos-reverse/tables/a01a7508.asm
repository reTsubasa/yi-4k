; image sha256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; A32 disassembly window 0xa01a7508+0x25c; boundaries are analyst-selected
; This is offline disassembly, not original source or runtime evidence.
a01a7508  010050e3  cmp      r0, #1
a01a750c  70402de9  push     {r4, r5, r6, lr}
a01a7510  0260a0e1  mov      r6, r2
a01a7514  7900001a  bne      #0xa01a7700
a01a7518  005091e5  ldr      r5, [r1]
a01a751c  a01908e3  movw     r1, #0x89a0
a01a7520  56104ae3  movt     r1, #0xa056 ; constant 0xa05689a0: '64M'
a01a7524  0500a0e1  mov      r0, r5
a01a7528  85480dfa  blx      #0xa04f9744
a01a752c  004050e2  subs     r4, r0, #0
a01a7530  5100000a  beq      #0xa01a767c
a01a7534  c41908e3  movw     r1, #0x89c4
a01a7538  0500a0e1  mov      r0, r5
a01a753c  56104ae3  movt     r1, #0xa056 ; constant 0xa05689c4: '1G'
a01a7540  7f480dfa  blx      #0xa04f9744
a01a7544  004050e2  subs     r4, r0, #0
a01a7548  5000000a  beq      #0xa01a7690
a01a754c  e81908e3  movw     r1, #0x89e8
a01a7550  0500a0e1  mov      r0, r5
a01a7554  56104ae3  movt     r1, #0xa056 ; constant 0xa05689e8: '2G'
a01a7558  79480dfa  blx      #0xa04f9744
a01a755c  004050e2  subs     r4, r0, #0
a01a7560  4000000a  beq      #0xa01a7668
a01a7564  0c1a08e3  movw     r1, #0x8a0c
a01a7568  0500a0e1  mov      r0, r5
a01a756c  56104ae3  movt     r1, #0xa056 ; constant 0xa0568a0c: '4G'
a01a7570  73480dfa  blx      #0xa04f9744
a01a7574  004050e2  subs     r4, r0, #0
a01a7578  4900000a  beq      #0xa01a76a4
a01a757c  301a08e3  movw     r1, #0x8a30
a01a7580  0500a0e1  mov      r0, r5
a01a7584  56104ae3  movt     r1, #0xa056 ; constant 0xa0568a30: '30G'
a01a7588  6d480dfa  blx      #0xa04f9744
a01a758c  004050e2  subs     r4, r0, #0
a01a7590  4700000a  beq      #0xa01a76b4
a01a7594  c81e0de3  movw     r1, #0xdec8
a01a7598  0500a0e1  mov      r0, r5
a01a759c  54104ae3  movt     r1, #0xa054 ; constant 0xa054dec8: '10s'
a01a75a0  67480dfa  blx      #0xa04f9744
a01a75a4  004050e2  subs     r4, r0, #0
a01a75a8  4c00000a  beq      #0xa01a76e0
a01a75ac  d01e0de3  movw     r1, #0xded0
a01a75b0  0500a0e1  mov      r0, r5
a01a75b4  54104ae3  movt     r1, #0xa054 ; constant 0xa054ded0: '30s'
a01a75b8  61480dfa  blx      #0xa04f9744
a01a75bc  004050e2  subs     r4, r0, #0
a01a75c0  4a00000a  beq      #0xa01a76f0
a01a75c4  c01f0de3  movw     r1, #0xdfc0
a01a75c8  0500a0e1  mov      r0, r5
a01a75cc  54104ae3  movt     r1, #0xa054 ; constant 0xa054dfc0: '60s'
a01a75d0  5b480dfa  blx      #0xa04f9744
a01a75d4  004050e2  subs     r4, r0, #0
a01a75d8  4d00000a  beq      #0xa01a7714
a01a75dc  b81a08e3  movw     r1, #0x8ab8
a01a75e0  0500a0e1  mov      r0, r5
a01a75e4  56104ae3  movt     r1, #0xa056 ; constant 0xa0568ab8: '5m'
a01a75e8  55480dfa  blx      #0xa04f9744
a01a75ec  004050e2  subs     r4, r0, #0
a01a75f0  4b00000a  beq      #0xa01a7724
a01a75f4  dc1a08e3  movw     r1, #0x8adc
a01a75f8  0500a0e1  mov      r0, r5
a01a75fc  56104ae3  movt     r1, #0xa056 ; constant 0xa0568adc: '10m'
a01a7600  4f480dfa  blx      #0xa04f9744
a01a7604  004050e2  subs     r4, r0, #0
a01a7608  4900000a  beq      #0xa01a7734
a01a760c  001b08e3  movw     r1, #0x8b00
a01a7610  0500a0e1  mov      r0, r5
a01a7614  56104ae3  movt     r1, #0xa056 ; constant 0xa0568b00: '30m'
a01a7618  49480dfa  blx      #0xa04f9744
a01a761c  004050e2  subs     r4, r0, #0
a01a7620  4700000a  beq      #0xa01a7744
a01a7624  fc1a0ce3  movw     r1, #0xcafc
a01a7628  0500a0e1  mov      r0, r5
a01a762c  5c104ae3  movt     r1, #0xa05c ; constant 0xa05ccafc: 'off'
a01a7630  43480dfa  blx      #0xa04f9744
a01a7634  004050e2  subs     r4, r0, #0
a01a7638  4500000a  beq      #0xa01a7754
a01a763c  4c1206e3  movw     r1, #0x624c
a01a7640  0500a0e1  mov      r0, r5
a01a7644  53104ae3  movt     r1, #0xa053 ; constant 0xa053624c: 'auto'
a01a7648  3d480dfa  blx      #0xa04f9744
a01a764c  004050e2  subs     r4, r0, #0
a01a7650  2a00001a  bne      #0xa01a7700
a01a7654  440b08e3  movw     r0, #0x8b44
a01a7658  56004ae3  movt     r0, #0xa056 ; constant 0xa0568b44: 'set video split size to auto\r\n'
a01a765c  36ff2fe1  blx      r6
a01a7660  0400a0e1  mov      r0, r4
a01a7664  7080bde8  pop      {r4, r5, r6, pc}
a01a7668  ec0908e3  movw     r0, #0x89ec
a01a766c  56004ae3  movt     r0, #0xa056 ; constant 0xa05689ec: 'set video split size to 2G\r\n'
a01a7670  36ff2fe1  blx      r6
a01a7674  0400a0e1  mov      r0, r4
a01a7678  7080bde8  pop      {r4, r5, r6, pc}
a01a767c  a40908e3  movw     r0, #0x89a4
a01a7680  56004ae3  movt     r0, #0xa056 ; constant 0xa05689a4: 'set video split size to 64M\r\n'
a01a7684  36ff2fe1  blx      r6
a01a7688  0400a0e1  mov      r0, r4
a01a768c  7080bde8  pop      {r4, r5, r6, pc}
a01a7690  c80908e3  movw     r0, #0x89c8
a01a7694  56004ae3  movt     r0, #0xa056 ; constant 0xa05689c8: 'set video split size to 1G\r\n'
a01a7698  36ff2fe1  blx      r6
a01a769c  0400a0e1  mov      r0, r4
a01a76a0  7080bde8  pop      {r4, r5, r6, pc}
a01a76a4  100a08e3  movw     r0, #0x8a10
a01a76a8  56004ae3  movt     r0, #0xa056 ; constant 0xa0568a10: 'set video split size to 4G\r\n'
a01a76ac  36ff2fe1  blx      r6
a01a76b0  eaffffea  b        #0xa01a7660
a01a76b4  d43c05e3  movw     r3, #0x5cd4
a01a76b8  1e20a0e3  mov      r2, #0x1e
a01a76bc  05314ae3  movt     r3, #0xa105
a01a76c0  32c100e3  movw     ip, #0x132
a01a76c4  003093e5  ldr      r3, [r3]
a01a76c8  340a08e3  movw     r0, #0x8a34
a01a76cc  0210a0e1  mov      r1, r2
a01a76d0  56004ae3  movt     r0, #0xa056 ; constant 0xa0568a34: 'set video split size to 30G %d\r\n'
a01a76d4  bc2083e1  strh     r2, [r3, ip]
a01a76d8  36ff2fe1  blx      r6
a01a76dc  dfffffea  b        #0xa01a7660
a01a76e0  580a08e3  movw     r0, #0x8a58
a01a76e4  56004ae3  movt     r0, #0xa056 ; constant 0xa0568a58: 'set video split size to 10S\r\n'
a01a76e8  36ff2fe1  blx      r6
a01a76ec  dbffffea  b        #0xa01a7660
a01a76f0  780a08e3  movw     r0, #0x8a78
a01a76f4  56004ae3  movt     r0, #0xa056 ; constant 0xa0568a78: 'set video split size to 30s\r\n'
a01a76f8  36ff2fe1  blx      r6
a01a76fc  d7ffffea  b        #0xa01a7660
a01a7700  380908e3  movw     r0, #0x8938
a01a7704  0040e0e3  mvn      r4, #0
a01a7708  56004ae3  movt     r0, #0xa056 ; constant 0xa0568938: 'Usage: set_video_split_size 64M | 1G | 2G | 4G | 30G | 10s | 30s | 60s | 5m | 10m | 30m | off |  auto \n'
a01a770c  36ff2fe1  blx      r6
a01a7710  d2ffffea  b        #0xa01a7660
a01a7714  980a08e3  movw     r0, #0x8a98
a01a7718  56004ae3  movt     r0, #0xa056 ; constant 0xa0568a98: 'set video split size to 60s\r\n'
a01a771c  36ff2fe1  blx      r6
a01a7720  ceffffea  b        #0xa01a7660
a01a7724  bc0a08e3  movw     r0, #0x8abc
a01a7728  56004ae3  movt     r0, #0xa056 ; constant 0xa0568abc: 'set video split size to 5m\r\n'
a01a772c  36ff2fe1  blx      r6
a01a7730  caffffea  b        #0xa01a7660
a01a7734  e00a08e3  movw     r0, #0x8ae0
a01a7738  56004ae3  movt     r0, #0xa056 ; constant 0xa0568ae0: 'set video split size to 10m\r\n'
a01a773c  36ff2fe1  blx      r6
a01a7740  c6ffffea  b        #0xa01a7660
a01a7744  040b08e3  movw     r0, #0x8b04
a01a7748  56004ae3  movt     r0, #0xa056 ; constant 0xa0568b04: 'set video split size to 30m\r\n'
a01a774c  36ff2fe1  blx      r6
a01a7750  c2ffffea  b        #0xa01a7660
a01a7754  240b08e3  movw     r0, #0x8b24
a01a7758  56004ae3  movt     r0, #0xa056 ; constant 0xa0568b24: 'set video split size to off\r\n'
a01a775c  36ff2fe1  blx      r6
a01a7760  beffffea  b        #0xa01a7660
