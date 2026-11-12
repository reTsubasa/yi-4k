; RTOS SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; Selected A32 window; may include literal pools and adjacent functions.
a038ea48 10402de9 push     {r4, lr}
a038ea4c 28d04de2 sub      sp, sp, #0x28
a038ea50 04008de5 str      r0, [sp, #4]
a038ea54 403604e3 movw     r3, #0x4640
a038ea58 70314ae3 movt     r3, #0xa170
a038ea5c 0c3093e5 ldr      r3, [r3, #0xc]
a038ea60 b631cde1 strh     r3, [sp, #0x16]
a038ea64 403604e3 movw     r3, #0x4640
a038ea68 70314ae3 movt     r3, #0xa170
a038ea6c 103093e5 ldr      r3, [r3, #0x10]
a038ea70 b431cde1 strh     r3, [sp, #0x14]
a038ea74 003404e3 movw     r3, #0x4400
a038ea78 70314ae3 movt     r3, #0xa170
a038ea7c 1c3093e5 ldr      r3, [r3, #0x1c]
a038ea80 4338a0e1 asr      r3, r3, #0x10
a038ea84 000053e3 cmp      r3, #0
a038ea88 003063b2 rsblt    r3, r3, #0
a038ea8c 7320ffe6 uxth     r2, r3
a038ea90 6c3b0ae3 movw     r3, #0xab6c
a038ea94 70314ae3 movt     r3, #0xa170
a038ea98 b020c3e1 strh     r2, [r3]
a038ea9c 003404e3 movw     r3, #0x4400
a038eaa0 70314ae3 movt     r3, #0xa170
a038eaa4 203093e5 ldr      r3, [r3, #0x20]
a038eaa8 4338a0e1 asr      r3, r3, #0x10
a038eaac 000053e3 cmp      r3, #0
a038eab0 003063b2 rsblt    r3, r3, #0
a038eab4 7320ffe6 uxth     r2, r3
a038eab8 6e3b0ae3 movw     r3, #0xab6e
a038eabc 70314ae3 movt     r3, #0xa170
a038eac0 b020c3e1 strh     r2, [r3]
a038eac4 d83504e3 movw     r3, #0x45d8
a038eac8 70314ae3 movt     r3, #0xa170
a038eacc 0030d3e5 ldrb     r3, [r3]
a038ead0 000053e3 cmp      r3, #0
a038ead4 8001001a bne      #0xa038f0dc
a038ead8 0030a0e3 mov      r3, #0
a038eadc b432cde1 strh     r3, [sp, #0x24]
a038eae0 200100ea b        #0xa038ef68
a038eae4 0030a0e3 mov      r3, #0
a038eae8 b632cde1 strh     r3, [sp, #0x26]
a038eaec 160100ea b        #0xa038ef4c
a038eaf0 d93504e3 movw     r3, #0x45d9
a038eaf4 70314ae3 movt     r3, #0xa170
a038eaf8 0030d3e5 ldrb     r3, [r3]
a038eafc 000053e3 cmp      r3, #0
a038eb00 0d00000a beq      #0xa038eb3c
a038eb04 b432dde1 ldrh     r3, [sp, #0x24]
a038eb08 b621dde1 ldrh     r2, [sp, #0x16]
a038eb0c 920302e0 mul      r2, r2, r3
a038eb10 b632dde1 ldrh     r3, [sp, #0x26]
a038eb14 033082e0 add      r3, r2, r3
a038eb18 0331a0e1 lsl      r3, r3, #2
a038eb1c 04209de5 ldr      r2, [sp, #4]
a038eb20 032082e0 add      r2, r2, r3
a038eb24 003404e3 movw     r3, #0x4400
a038eb28 70314ae3 movt     r3, #0xa170
a038eb2c 203093e5 ldr      r3, [r3, #0x20]
a038eb30 4336a0e1 asr      r3, r3, #0xc
a038eb34 7330ffe6 uxth     r3, r3
a038eb38 b230c2e1 strh     r3, [r2, #2]
a038eb3c dc3504e3 movw     r3, #0x45dc
a038eb40 70314ae3 movt     r3, #0xa170
a038eb44 0030d3e5 ldrb     r3, [r3]
a038eb48 000053e3 cmp      r3, #0
a038eb4c 2000000a beq      #0xa038ebd4
a038eb50 b432dde1 ldrh     r3, [sp, #0x24]
a038eb54 b621dde1 ldrh     r2, [sp, #0x16]
a038eb58 920302e0 mul      r2, r2, r3
a038eb5c b632dde1 ldrh     r3, [sp, #0x26]
a038eb60 033082e0 add      r3, r2, r3
a038eb64 0331a0e1 lsl      r3, r3, #2
a038eb68 04209de5 ldr      r2, [sp, #4]
a038eb6c 032082e0 add      r2, r2, r3
a038eb70 b432dde1 ldrh     r3, [sp, #0x24]
a038eb74 b611dde1 ldrh     r1, [sp, #0x16]
a038eb78 910301e0 mul      r1, r1, r3
a038eb7c b632dde1 ldrh     r3, [sp, #0x26]
a038eb80 033081e0 add      r3, r1, r3
a038eb84 0331a0e1 lsl      r3, r3, #2
a038eb88 04109de5 ldr      r1, [sp, #4]
a038eb8c 033081e0 add      r3, r1, r3
a038eb90 b230d3e1 ldrh     r3, [r3, #2]
a038eb94 7310ffe6 uxth     r1, r3
a038eb98 b432dde1 ldrh     r3, [sp, #0x24]
a038eb9c b601dde1 ldrh     r0, [sp, #0x16]
a038eba0 900300e0 mul      r0, r0, r3
a038eba4 b632dde1 ldrh     r3, [sp, #0x26]
a038eba8 030080e0 add      r0, r0, r3
a038ebac 5c3806e3 movw     r3, #0x685c
a038ebb0 70314ae3 movt     r3, #0xa170
a038ebb4 0001a0e1 lsl      r0, r0, #2
a038ebb8 003083e0 add      r3, r3, r0
a038ebbc b230d3e1 ldrh     r3, [r3, #2]
a038ebc0 7330ffe6 uxth     r3, r3
a038ebc4 033081e0 add      r3, r1, r3
a038ebc8 7330ffe6 uxth     r3, r3
a038ebcc 7330ffe6 uxth     r3, r3
a038ebd0 b230c2e1 strh     r3, [r2, #2]
a038ebd4 dd3504e3 movw     r3, #0x45dd
a038ebd8 70314ae3 movt     r3, #0xa170
a038ebdc 0030d3e5 ldrb     r3, [r3]
a038ebe0 000053e3 cmp      r3, #0
a038ebe4 4b00000a beq      #0xa038ed18
a038ebe8 de3504e3 movw     r3, #0x45de
a038ebec 70314ae3 movt     r3, #0xa170
a038ebf0 0030d3e5 ldrb     r3, [r3]
a038ebf4 010053e3 cmp      r3, #1
a038ebf8 2000001a bne      #0xa038ec80
a038ebfc b432dde1 ldrh     r3, [sp, #0x24]
a038ec00 b621dde1 ldrh     r2, [sp, #0x16]
a038ec04 920302e0 mul      r2, r2, r3
a038ec08 b632dde1 ldrh     r3, [sp, #0x26]
a038ec0c 033082e0 add      r3, r2, r3
a038ec10 0331a0e1 lsl      r3, r3, #2
a038ec14 04209de5 ldr      r2, [sp, #4]
a038ec18 033082e0 add      r3, r2, r3
a038ec1c b422dde1 ldrh     r2, [sp, #0x24]
a038ec20 b611dde1 ldrh     r1, [sp, #0x16]
a038ec24 910201e0 mul      r1, r1, r2
a038ec28 b622dde1 ldrh     r2, [sp, #0x26]
a038ec2c 022081e0 add      r2, r1, r2
a038ec30 0221a0e1 lsl      r2, r2, #2
a038ec34 04109de5 ldr      r1, [sp, #4]
a038ec38 022081e0 add      r2, r1, r2
a038ec3c b220d2e1 ldrh     r2, [r2, #2]
a038ec40 7210ffe6 uxth     r1, r2
a038ec44 b422dde1 ldrh     r2, [sp, #0x24]
a038ec48 b601dde1 ldrh     r0, [sp, #0x16]
a038ec4c 900200e0 mul      r0, r0, r2
a038ec50 b622dde1 ldrh     r2, [sp, #0x26]
a038ec54 022080e0 add      r2, r0, r2
a038ec58 0221a0e1 lsl      r2, r2, #2
a038ec5c 10009de5 ldr      r0, [sp, #0x10]
a038ec60 022080e0 add      r2, r0, r2
a038ec64 b220d2e1 ldrh     r2, [r2, #2]
a038ec68 7220ffe6 uxth     r2, r2
a038ec6c 022081e0 add      r2, r1, r2
a038ec70 7220ffe6 uxth     r2, r2
a038ec74 7220ffe6 uxth     r2, r2
a038ec78 b220c3e1 strh     r2, [r3, #2]
a038ec7c 250000ea b        #0xa038ed18
a038ec80 de3504e3 movw     r3, #0x45de
a038ec84 70314ae3 movt     r3, #0xa170
a038ec88 0030d3e5 ldrb     r3, [r3]
a038ec8c 000053e3 cmp      r3, #0
a038ec90 2000001a bne      #0xa038ed18
a038ec94 b432dde1 ldrh     r3, [sp, #0x24]
a038ec98 b621dde1 ldrh     r2, [sp, #0x16]
a038ec9c 920302e0 mul      r2, r2, r3
a038eca0 b632dde1 ldrh     r3, [sp, #0x26]
a038eca4 033082e0 add      r3, r2, r3
a038eca8 0331a0e1 lsl      r3, r3, #2
a038ecac 04209de5 ldr      r2, [sp, #4]
a038ecb0 032082e0 add      r2, r2, r3
a038ecb4 b432dde1 ldrh     r3, [sp, #0x24]
a038ecb8 b611dde1 ldrh     r1, [sp, #0x16]
a038ecbc 910301e0 mul      r1, r1, r3
a038ecc0 b632dde1 ldrh     r3, [sp, #0x26]
a038ecc4 033081e0 add      r3, r1, r3
a038ecc8 0331a0e1 lsl      r3, r3, #2
a038eccc 04109de5 ldr      r1, [sp, #4]
a038ecd0 033081e0 add      r3, r1, r3
a038ecd4 b230d3e1 ldrh     r3, [r3, #2]
a038ecd8 7310ffe6 uxth     r1, r3
a038ecdc b432dde1 ldrh     r3, [sp, #0x24]
a038ece0 b601dde1 ldrh     r0, [sp, #0x16]
a038ece4 900300e0 mul      r0, r0, r3
a038ece8 b632dde1 ldrh     r3, [sp, #0x26]
a038ecec 030080e0 add      r0, r0, r3
a038ecf0 b83908e3 movw     r3, #0x89b8
a038ecf4 70314ae3 movt     r3, #0xa170
a038ecf8 0001a0e1 lsl      r0, r0, #2
a038ecfc 003083e0 add      r3, r3, r0
a038ed00 b230d3e1 ldrh     r3, [r3, #2]
a038ed04 7330ffe6 uxth     r3, r3
a038ed08 033081e0 add      r3, r1, r3
a038ed0c 7330ffe6 uxth     r3, r3
a038ed10 7330ffe6 uxth     r3, r3
a038ed14 b230c2e1 strh     r3, [r2, #2]
a038ed18 d93504e3 movw     r3, #0x45d9
a038ed1c 70314ae3 movt     r3, #0xa170
a038ed20 0030d3e5 ldrb     r3, [r3]
a038ed24 000053e3 cmp      r3, #0
a038ed28 0d00000a beq      #0xa038ed64
a038ed2c b432dde1 ldrh     r3, [sp, #0x24]
a038ed30 b621dde1 ldrh     r2, [sp, #0x16]
a038ed34 920302e0 mul      r2, r2, r3
a038ed38 b632dde1 ldrh     r3, [sp, #0x26]
a038ed3c 033082e0 add      r3, r2, r3
a038ed40 0331a0e1 lsl      r3, r3, #2
a038ed44 04209de5 ldr      r2, [sp, #4]
a038ed48 032082e0 add      r2, r2, r3
a038ed4c 003404e3 movw     r3, #0x4400
a038ed50 70314ae3 movt     r3, #0xa170
a038ed54 1c3093e5 ldr      r3, [r3, #0x1c]
a038ed58 4336a0e1 asr      r3, r3, #0xc
a038ed5c 7330ffe6 uxth     r3, r3
a038ed60 b030c2e1 strh     r3, [r2]
a038ed64 dc3504e3 movw     r3, #0x45dc
a038ed68 70314ae3 movt     r3, #0xa170
a038ed6c 0030d3e5 ldrb     r3, [r3]
a038ed70 000053e3 cmp      r3, #0
a038ed74 2000000a beq      #0xa038edfc
a038ed78 b432dde1 ldrh     r3, [sp, #0x24]
a038ed7c b621dde1 ldrh     r2, [sp, #0x16]
a038ed80 920302e0 mul      r2, r2, r3
a038ed84 b632dde1 ldrh     r3, [sp, #0x26]
a038ed88 033082e0 add      r3, r2, r3
a038ed8c 0331a0e1 lsl      r3, r3, #2
a038ed90 04209de5 ldr      r2, [sp, #4]
a038ed94 032082e0 add      r2, r2, r3
a038ed98 b432dde1 ldrh     r3, [sp, #0x24]
a038ed9c b611dde1 ldrh     r1, [sp, #0x16]
a038eda0 910301e0 mul      r1, r1, r3
a038eda4 b632dde1 ldrh     r3, [sp, #0x26]
a038eda8 033081e0 add      r3, r1, r3
a038edac 0331a0e1 lsl      r3, r3, #2
a038edb0 04109de5 ldr      r1, [sp, #4]
a038edb4 033081e0 add      r3, r1, r3
a038edb8 b030d3e1 ldrh     r3, [r3]
a038edbc 7310ffe6 uxth     r1, r3
a038edc0 b432dde1 ldrh     r3, [sp, #0x24]
a038edc4 b601dde1 ldrh     r0, [sp, #0x16]
a038edc8 900300e0 mul      r0, r0, r3
a038edcc b632dde1 ldrh     r3, [sp, #0x26]
a038edd0 030080e0 add      r0, r0, r3
a038edd4 5c3806e3 movw     r3, #0x685c
a038edd8 70314ae3 movt     r3, #0xa170
a038eddc 0001a0e1 lsl      r0, r0, #2
a038ede0 003083e0 add      r3, r3, r0
a038ede4 b030d3e1 ldrh     r3, [r3]
a038ede8 7330ffe6 uxth     r3, r3
a038edec 033081e0 add      r3, r1, r3
a038edf0 7330ffe6 uxth     r3, r3
a038edf4 7330ffe6 uxth     r3, r3
a038edf8 b030c2e1 strh     r3, [r2]
a038edfc dd3504e3 movw     r3, #0x45dd
a038ee00 70314ae3 movt     r3, #0xa170
a038ee04 0030d3e5 ldrb     r3, [r3]
a038ee08 000053e3 cmp      r3, #0
a038ee0c 4b00000a beq      #0xa038ef40
a038ee10 de3504e3 movw     r3, #0x45de
a038ee14 70314ae3 movt     r3, #0xa170
a038ee18 0030d3e5 ldrb     r3, [r3]
a038ee1c 010053e3 cmp      r3, #1
a038ee20 2000001a bne      #0xa038eea8
a038ee24 b432dde1 ldrh     r3, [sp, #0x24]
a038ee28 b621dde1 ldrh     r2, [sp, #0x16]
a038ee2c 920302e0 mul      r2, r2, r3
a038ee30 b632dde1 ldrh     r3, [sp, #0x26]
a038ee34 033082e0 add      r3, r2, r3
a038ee38 0331a0e1 lsl      r3, r3, #2
a038ee3c 04209de5 ldr      r2, [sp, #4]
a038ee40 033082e0 add      r3, r2, r3
a038ee44 b422dde1 ldrh     r2, [sp, #0x24]
a038ee48 b611dde1 ldrh     r1, [sp, #0x16]
a038ee4c 910201e0 mul      r1, r1, r2
a038ee50 b622dde1 ldrh     r2, [sp, #0x26]
a038ee54 022081e0 add      r2, r1, r2
a038ee58 0221a0e1 lsl      r2, r2, #2
a038ee5c 04109de5 ldr      r1, [sp, #4]
a038ee60 022081e0 add      r2, r1, r2
a038ee64 b020d2e1 ldrh     r2, [r2]
a038ee68 7210ffe6 uxth     r1, r2
a038ee6c b422dde1 ldrh     r2, [sp, #0x24]
a038ee70 b601dde1 ldrh     r0, [sp, #0x16]
a038ee74 900200e0 mul      r0, r0, r2
a038ee78 b622dde1 ldrh     r2, [sp, #0x26]
a038ee7c 022080e0 add      r2, r0, r2
a038ee80 0221a0e1 lsl      r2, r2, #2
a038ee84 0c009de5 ldr      r0, [sp, #0xc]
a038ee88 022080e0 add      r2, r0, r2
a038ee8c b020d2e1 ldrh     r2, [r2]
a038ee90 7220ffe6 uxth     r2, r2
a038ee94 022081e0 add      r2, r1, r2
a038ee98 7220ffe6 uxth     r2, r2
a038ee9c 7220ffe6 uxth     r2, r2
a038eea0 b020c3e1 strh     r2, [r3]
a038eea4 250000ea b        #0xa038ef40
a038eea8 de3504e3 movw     r3, #0x45de
a038eeac 70314ae3 movt     r3, #0xa170
a038eeb0 0030d3e5 ldrb     r3, [r3]
a038eeb4 000053e3 cmp      r3, #0
a038eeb8 2000001a bne      #0xa038ef40
a038eebc b432dde1 ldrh     r3, [sp, #0x24]
a038eec0 b621dde1 ldrh     r2, [sp, #0x16]
a038eec4 920302e0 mul      r2, r2, r3
a038eec8 b632dde1 ldrh     r3, [sp, #0x26]
a038eecc 033082e0 add      r3, r2, r3
a038eed0 0331a0e1 lsl      r3, r3, #2
a038eed4 04209de5 ldr      r2, [sp, #4]
a038eed8 032082e0 add      r2, r2, r3
a038eedc b432dde1 ldrh     r3, [sp, #0x24]
a038eee0 b611dde1 ldrh     r1, [sp, #0x16]
a038eee4 910301e0 mul      r1, r1, r3
a038eee8 b632dde1 ldrh     r3, [sp, #0x26]
a038eeec 033081e0 add      r3, r1, r3
a038eef0 0331a0e1 lsl      r3, r3, #2
a038eef4 04109de5 ldr      r1, [sp, #4]
a038eef8 033081e0 add      r3, r1, r3
a038eefc b030d3e1 ldrh     r3, [r3]
a038ef00 7310ffe6 uxth     r1, r3
a038ef04 b432dde1 ldrh     r3, [sp, #0x24]
a038ef08 b601dde1 ldrh     r0, [sp, #0x16]
a038ef0c 900300e0 mul      r0, r0, r3
a038ef10 b632dde1 ldrh     r3, [sp, #0x26]
a038ef14 030080e0 add      r0, r0, r3
a038ef18 b83908e3 movw     r3, #0x89b8
a038ef1c 70314ae3 movt     r3, #0xa170
a038ef20 0001a0e1 lsl      r0, r0, #2
a038ef24 003083e0 add      r3, r3, r0
a038ef28 b030d3e1 ldrh     r3, [r3]
a038ef2c 7330ffe6 uxth     r3, r3
a038ef30 033081e0 add      r3, r1, r3
a038ef34 7330ffe6 uxth     r3, r3
a038ef38 7330ffe6 uxth     r3, r3
a038ef3c b030c2e1 strh     r3, [r2]
a038ef40 b632dde1 ldrh     r3, [sp, #0x26]
a038ef44 013083e2 add      r3, r3, #1
a038ef48 b632cde1 strh     r3, [sp, #0x26]
a038ef4c b622dde1 ldrh     r2, [sp, #0x26]
a038ef50 b631dde1 ldrh     r3, [sp, #0x16]
a038ef54 030052e1 cmp      r2, r3
a038ef58 e4feff3a blo      #0xa038eaf0
a038ef5c b432dde1 ldrh     r3, [sp, #0x24]
a038ef60 013083e2 add      r3, r3, #1
a038ef64 b432cde1 strh     r3, [sp, #0x24]
a038ef68 b422dde1 ldrh     r2, [sp, #0x24]
a038ef6c b431dde1 ldrh     r3, [sp, #0x14]
a038ef70 030052e1 cmp      r2, r3
a038ef74 dafeff3a blo      #0xa038eae4
a038ef78 f83a07e3 movw     r3, #0x7af8
a038ef7c 75304ae3 movt     r3, #0xa075
a038ef80 bc30d3e1 ldrh     r3, [r3, #0xc]
a038ef84 000053e3 cmp      r3, #0
a038ef88 0b00000a beq      #0xa038efbc
a038ef8c 2c3204e3 movw     r3, #0x422c
a038ef90 70314ae3 movt     r3, #0xa170
a038ef94 001093e5 ldr      r1, [r3]
a038ef98 04309de5 ldr      r3, [sp, #4]
a038ef9c b030d3e1 ldrh     r3, [r3]
a038efa0 7320bfe6 sxth     r2, r3
a038efa4 04309de5 ldr      r3, [sp, #4]
a038efa8 b230d3e1 ldrh     r3, [r3, #2]
a038efac 7330bfe6 sxth     r3, r3
a038efb0 f80a00e3 movw     r0, #0xaf8
a038efb4 60004ae3 movt     r0, #0xa060
a038efb8 4b60fceb bl       #0xa02a70ec
a038efbc 283a0be3 movw     r3, #0xba28
a038efc0 70314ae3 movt     r3, #0xa170
a038efc4 b030d3e1 ldrh     r3, [r3]
a038efc8 7320ffe6 uxth     r2, r3
a038efcc 603b07e3 movw     r3, #0x7b60
a038efd0 75304ae3 movt     r3, #0xa075
a038efd4 b030d3e1 ldrh     r3, [r3]
a038efd8 7330ffe6 uxth     r3, r3
a038efdc 033082e0 add      r3, r2, r3
a038efe0 7330ffe6 uxth     r3, r3
a038efe4 7320ffe6 uxth     r2, r3
a038efe8 283a0be3 movw     r3, #0xba28
a038efec 70314ae3 movt     r3, #0xa170
a038eff0 b020c3e1 strh     r2, [r3]
a038eff4 283a0be3 movw     r3, #0xba28
a038eff8 70314ae3 movt     r3, #0xa170
a038effc b030d3e1 ldrh     r3, [r3]
a038f000 7330bfe6 sxth     r3, r3
a038f004 f90053e3 cmp      r3, #0xf9
a038f008 040000da ble      #0xa038f020
a038f00c 603b07e3 movw     r3, #0x7b60
a038f010 75304ae3 movt     r3, #0xa075
a038f014 0920e0e3 mvn      r2, #9
a038f018 b020c3e1 strh     r2, [r3]
a038f01c 090000ea b        #0xa038f048
a038f020 283a0be3 movw     r3, #0xba28
a038f024 70314ae3 movt     r3, #0xa170
a038f028 b030d3e1 ldrh     r3, [r3]
a038f02c 7330bfe6 sxth     r3, r3
a038f030 f90073e3 cmn      r3, #0xf9
a038f034 030000aa bge      #0xa038f048
a038f038 603b07e3 movw     r3, #0x7b60
a038f03c 75304ae3 movt     r3, #0xa075
a038f040 0a20a0e3 mov      r2, #0xa
a038f044 b020c3e1 strh     r2, [r3]
a038f048 2a3a0be3 movw     r3, #0xba2a
a038f04c 70314ae3 movt     r3, #0xa170
a038f050 b030d3e1 ldrh     r3, [r3]
a038f054 7320ffe6 uxth     r2, r3
a038f058 623b07e3 movw     r3, #0x7b62
a038f05c 75304ae3 movt     r3, #0xa075
a038f060 b030d3e1 ldrh     r3, [r3]
a038f064 7330ffe6 uxth     r3, r3
a038f068 033082e0 add      r3, r2, r3
a038f06c 7330ffe6 uxth     r3, r3
a038f070 7320ffe6 uxth     r2, r3
a038f074 2a3a0be3 movw     r3, #0xba2a
a038f078 70314ae3 movt     r3, #0xa170
a038f07c b020c3e1 strh     r2, [r3]
a038f080 2a3a0be3 movw     r3, #0xba2a
a038f084 70314ae3 movt     r3, #0xa170
a038f088 b030d3e1 ldrh     r3, [r3]
a038f08c 7330bfe6 sxth     r3, r3
a038f090 f90053e3 cmp      r3, #0xf9
a038f094 040000da ble      #0xa038f0ac
a038f098 623b07e3 movw     r3, #0x7b62
a038f09c 75304ae3 movt     r3, #0xa075
a038f0a0 0920e0e3 mvn      r2, #9
a038f0a4 b020c3e1 strh     r2, [r3]
a038f0a8 0a0000ea b        #0xa038f0d8
a038f0ac 2a3a0be3 movw     r3, #0xba2a
a038f0b0 70314ae3 movt     r3, #0xa170
a038f0b4 b030d3e1 ldrh     r3, [r3]
a038f0b8 7330bfe6 sxth     r3, r3
a038f0bc f90073e3 cmn      r3, #0xf9
a038f0c0 040000aa bge      #0xa038f0d8
a038f0c4 623b07e3 movw     r3, #0x7b62
a038f0c8 75304ae3 movt     r3, #0xa075
a038f0cc 0a20a0e3 mov      r2, #0xa
a038f0d0 b020c3e1 strh     r2, [r3]
a038f0d4 030b00ea b        #0xa0391ce8
a038f0d8 020b00ea b        #0xa0391ce8
a038f0dc 003404e3 movw     r3, #0x4400
a038f0e0 70314ae3 movt     r3, #0xa170
a038f0e4 1c3093e5 ldr      r3, [r3, #0x1c]
a038f0e8 4338a0e1 asr      r3, r3, #0x10
a038f0ec 7320ffe6 uxth     r2, r3
a038f0f0 6c3b0ae3 movw     r3, #0xab6c
a038f0f4 70314ae3 movt     r3, #0xa170
a038f0f8 b020c3e1 strh     r2, [r3]
a038f0fc 003404e3 movw     r3, #0x4400
a038f100 70314ae3 movt     r3, #0xa170
a038f104 203093e5 ldr      r3, [r3, #0x20]
a038f108 4338a0e1 asr      r3, r3, #0x10
a038f10c 7320ffe6 uxth     r2, r3
a038f110 6e3b0ae3 movw     r3, #0xab6e
a038f114 70314ae3 movt     r3, #0xa170
a038f118 b020c3e1 strh     r2, [r3]
a038f11c 6c3b0ae3 movw     r3, #0xab6c
a038f120 70314ae3 movt     r3, #0xa170
a038f124 b030d3e1 ldrh     r3, [r3]
a038f128 7330bfe6 sxth     r3, r3
a038f12c 000053e3 cmp      r3, #0
a038f130 1b0000aa bge      #0xa038f1a4
a038f134 703b0ae3 movw     r3, #0xab70
a038f138 70314ae3 movt     r3, #0xa170
a038f13c 0020e0e3 mvn      r2, #0
a038f140 b020c3e1 strh     r2, [r3]
a038f144 6c3b0ae3 movw     r3, #0xab6c
a038f148 70314ae3 movt     r3, #0xa170
a038f14c b030d3e1 ldrh     r3, [r3]
a038f150 7330ffe6 uxth     r3, r3
a038f154 003063e2 rsb      r3, r3, #0
a038f158 7330ffe6 uxth     r3, r3
a038f15c 7320ffe6 uxth     r2, r3
a038f160 6c3b0ae3 movw     r3, #0xab6c
a038f164 70314ae3 movt     r3, #0xa170
a038f168 b020c3e1 strh     r2, [r3]
a038f16c 6c3b0ae3 movw     r3, #0xab6c
a038f170 70314ae3 movt     r3, #0xa170
a038f174 b030d3e1 ldrh     r3, [r3]
a038f178 7320bfe6 sxth     r2, r3
a038f17c c63c01e3 movw     r3, #0x1cc6
a038f180 70304ae3 movt     r3, #0xa070
a038f184 b030d3e1 ldrh     r3, [r3]
a038f188 7330bfe6 sxth     r3, r3
a038f18c 0200a0e1 mov      r0, r2
a038f190 0310a0e1 mov      r1, r3
a038f194 3ddd05fa blx      #0xa0506690
a038f198 0030a0e1 mov      r3, r0
a038f19c b232cde1 strh     r3, [sp, #0x22]
a038f1a0 100000ea b        #0xa038f1e8
a038f1a4 703b0ae3 movw     r3, #0xab70
a038f1a8 70314ae3 movt     r3, #0xa170
a038f1ac 0120a0e3 mov      r2, #1
a038f1b0 b020c3e1 strh     r2, [r3]
a038f1b4 6c3b0ae3 movw     r3, #0xab6c
a038f1b8 70314ae3 movt     r3, #0xa170
a038f1bc b030d3e1 ldrh     r3, [r3]
a038f1c0 7320bfe6 sxth     r2, r3
a038f1c4 c63c01e3 movw     r3, #0x1cc6
a038f1c8 70304ae3 movt     r3, #0xa070
a038f1cc b030d3e1 ldrh     r3, [r3]
a038f1d0 7330bfe6 sxth     r3, r3
a038f1d4 0200a0e1 mov      r0, r2
a038f1d8 0310a0e1 mov      r1, r3
a038f1dc 2bdd05fa blx      #0xa0506690
a038f1e0 0030a0e1 mov      r3, r0
a038f1e4 b232cde1 strh     r3, [sp, #0x22]
a038f1e8 6e3b0ae3 movw     r3, #0xab6e
a038f1ec 70314ae3 movt     r3, #0xa170
a038f1f0 b030d3e1 ldrh     r3, [r3]
a038f1f4 7330bfe6 sxth     r3, r3
a038f1f8 000053e3 cmp      r3, #0
a038f1fc 1b0000aa bge      #0xa038f270
a038f200 723b0ae3 movw     r3, #0xab72
a038f204 70314ae3 movt     r3, #0xa170
a038f208 0020e0e3 mvn      r2, #0
a038f20c b020c3e1 strh     r2, [r3]
a038f210 6e3b0ae3 movw     r3, #0xab6e
a038f214 70314ae3 movt     r3, #0xa170
a038f218 b030d3e1 ldrh     r3, [r3]
a038f21c 7330ffe6 uxth     r3, r3
a038f220 003063e2 rsb      r3, r3, #0
a038f224 7330ffe6 uxth     r3, r3
a038f228 7320ffe6 uxth     r2, r3
a038f22c 6e3b0ae3 movw     r3, #0xab6e
a038f230 70314ae3 movt     r3, #0xa170
a038f234 b020c3e1 strh     r2, [r3]
a038f238 6e3b0ae3 movw     r3, #0xab6e
a038f23c 70314ae3 movt     r3, #0xa170
a038f240 b030d3e1 ldrh     r3, [r3]
a038f244 7320bfe6 sxth     r2, r3
a038f248 c63c01e3 movw     r3, #0x1cc6
a038f24c 70304ae3 movt     r3, #0xa070
a038f250 b030d3e1 ldrh     r3, [r3]
a038f254 7330bfe6 sxth     r3, r3
a038f258 0200a0e1 mov      r0, r2
a038f25c 0310a0e1 mov      r1, r3
a038f260 0add05fa blx      #0xa0506690
a038f264 0030a0e1 mov      r3, r0
a038f268 b032cde1 strh     r3, [sp, #0x20]
a038f26c 100000ea b        #0xa038f2b4
a038f270 723b0ae3 movw     r3, #0xab72
a038f274 70314ae3 movt     r3, #0xa170
a038f278 0120a0e3 mov      r2, #1
a038f27c b020c3e1 strh     r2, [r3]
a038f280 6e3b0ae3 movw     r3, #0xab6e
a038f284 70314ae3 movt     r3, #0xa170
a038f288 b030d3e1 ldrh     r3, [r3]
a038f28c 7320bfe6 sxth     r2, r3
a038f290 c63c01e3 movw     r3, #0x1cc6
a038f294 70304ae3 movt     r3, #0xa070
a038f298 b030d3e1 ldrh     r3, [r3]
a038f29c 7330bfe6 sxth     r3, r3
a038f2a0 0200a0e1 mov      r0, r2
a038f2a4 0310a0e1 mov      r1, r3
a038f2a8 f8dc05fa blx      #0xa0506690
a038f2ac 0030a0e1 mov      r3, r0
a038f2b0 b032cde1 strh     r3, [sp, #0x20]
a038f2b4 c23c01e3 movw     r3, #0x1cc2
a038f2b8 70304ae3 movt     r3, #0xa070
a038f2bc b030d3e1 ldrh     r3, [r3]
a038f2c0 f222dde1 ldrsh    r2, [sp, #0x22]
a038f2c4 7330bfe6 sxth     r3, r3
a038f2c8 030052e1 cmp      r2, r3
a038f2cc 110000da ble      #0xa038f318
a038f2d0 c23c01e3 movw     r3, #0x1cc2
a038f2d4 70304ae3 movt     r3, #0xa070
a038f2d8 b030d3e1 ldrh     r3, [r3]
a038f2dc b232cde1 strh     r3, [sp, #0x22]
a038f2e0 c23c01e3 movw     r3, #0x1cc2
a038f2e4 70304ae3 movt     r3, #0xa070
a038f2e8 b030d3e1 ldrh     r3, [r3]
a038f2ec 7320ffe6 uxth     r2, r3
a038f2f0 c63c01e3 movw     r3, #0x1cc6
a038f2f4 70304ae3 movt     r3, #0xa070
a038f2f8 b030d3e1 ldrh     r3, [r3]
a038f2fc 7330ffe6 uxth     r3, r3
a038f300 820363e1 smulbb   r3, r2, r3
a038f304 7330ffe6 uxth     r3, r3
a038f308 7320ffe6 uxth     r2, r3
a038f30c 6c3b0ae3 movw     r3, #0xab6c
a038f310 70314ae3 movt     r3, #0xa170
a038f314 b020c3e1 strh     r2, [r3]
a038f318 c43c01e3 movw     r3, #0x1cc4
a038f31c 70304ae3 movt     r3, #0xa070
a038f320 b030d3e1 ldrh     r3, [r3]
a038f324 f022dde1 ldrsh    r2, [sp, #0x20]
a038f328 7330bfe6 sxth     r3, r3
a038f32c 030052e1 cmp      r2, r3
a038f330 110000da ble      #0xa038f37c
a038f334 c43c01e3 movw     r3, #0x1cc4
a038f338 70304ae3 movt     r3, #0xa070
a038f33c b030d3e1 ldrh     r3, [r3]
a038f340 b032cde1 strh     r3, [sp, #0x20]
a038f344 c43c01e3 movw     r3, #0x1cc4
a038f348 70304ae3 movt     r3, #0xa070
a038f34c b030d3e1 ldrh     r3, [r3]
a038f350 7320ffe6 uxth     r2, r3
a038f354 c63c01e3 movw     r3, #0x1cc6
a038f358 70304ae3 movt     r3, #0xa070
a038f35c b030d3e1 ldrh     r3, [r3]
a038f360 7330ffe6 uxth     r3, r3
a038f364 820363e1 smulbb   r3, r2, r3
a038f368 7330ffe6 uxth     r3, r3
a038f36c 7320ffe6 uxth     r2, r3
a038f370 6e3b0ae3 movw     r3, #0xab6e
a038f374 70314ae3 movt     r3, #0xa170
a038f378 b020c3e1 strh     r2, [r3]
a038f37c 723b0ae3 movw     r3, #0xab72
a038f380 70314ae3 movt     r3, #0xa170
a038f384 b030d3e1 ldrh     r3, [r3]
a038f388 7330ffe6 uxth     r3, r3
a038f38c 003063e2 rsb      r3, r3, #0
a038f390 7330ffe6 uxth     r3, r3
a038f394 7320ffe6 uxth     r2, r3
a038f398 723b0ae3 movw     r3, #0xab72
a038f39c 70314ae3 movt     r3, #0xa170
a038f3a0 b020c3e1 strh     r2, [r3]
a038f3a4 703b0ae3 movw     r3, #0xab70
a038f3a8 70314ae3 movt     r3, #0xa170
a038f3ac b030d3e1 ldrh     r3, [r3]
a038f3b0 7330ffe6 uxth     r3, r3
a038f3b4 003063e2 rsb      r3, r3, #0
a038f3b8 7330ffe6 uxth     r3, r3
a038f3bc 7320ffe6 uxth     r2, r3
a038f3c0 703b0ae3 movw     r3, #0xab70
a038f3c4 70314ae3 movt     r3, #0xa170
a038f3c8 b020c3e1 strh     r2, [r3]
a038f3cc 703b0ae3 movw     r3, #0xab70
a038f3d0 70314ae3 movt     r3, #0xa170
a038f3d4 b030d3e1 ldrh     r3, [r3]
a038f3d8 7330bfe6 sxth     r3, r3
a038f3dc 000053e3 cmp      r3, #0
a038f3e0 8e0200da ble      #0xa038fe20
a038f3e4 723b0ae3 movw     r3, #0xab72
a038f3e8 70314ae3 movt     r3, #0xa170
a038f3ec b030d3e1 ldrh     r3, [r3]
a038f3f0 7330bfe6 sxth     r3, r3
a038f3f4 000053e3 cmp      r3, #0
a038f3f8 880200da ble      #0xa038fe20
a038f3fc 0030a0e3 mov      r3, #0
a038f400 18308de5 str      r3, [sp, #0x18]
a038f404 e80100ea b        #0xa038fbac
a038f408 0030a0e3 mov      r3, #0
a038f40c 1c308de5 str      r3, [sp, #0x1c]
a038f410 de0100ea b        #0xa038fb90
a038f414 b631dde1 ldrh     r3, [sp, #0x16]
a038f418 18209de5 ldr      r2, [sp, #0x18]
a038f41c 920302e0 mul      r2, r2, r3
a038f420 1c309de5 ldr      r3, [sp, #0x1c]
a038f424 034082e0 add      r4, r2, r3
a038f428 c23c01e3 movw     r3, #0x1cc2
a038f42c 70304ae3 movt     r3, #0xa070
a038f430 b030d3e1 ldrh     r3, [r3]
a038f434 7320bfe6 sxth     r2, r3
a038f438 f232dde1 ldrsh    r3, [sp, #0x22]
a038f43c 032082e0 add      r2, r2, r3
a038f440 c43c01e3 movw     r3, #0x1cc4
a038f444 70304ae3 movt     r3, #0xa070
a038f448 b030d3e1 ldrh     r3, [r3]
a038f44c 7330bfe6 sxth     r3, r3
a038f450 8330a0e1 lsl      r3, r3, #1
a038f454 013083e2 add      r3, r3, #1
a038f458 930202e0 mul      r2, r3, r2
a038f45c c43c01e3 movw     r3, #0x1cc4
a038f460 70304ae3 movt     r3, #0xa070
a038f464 b030d3e1 ldrh     r3, [r3]
a038f468 7310bfe6 sxth     r1, r3
a038f46c f032dde1 ldrsh    r3, [sp, #0x20]
a038f470 033081e0 add      r3, r1, r3
a038f474 033082e0 add      r3, r2, r3
a038f478 b621dde1 ldrh     r2, [sp, #0x16]
a038f47c 920303e0 mul      r3, r2, r3
a038f480 b421dde1 ldrh     r2, [sp, #0x14]
a038f484 920302e0 mul      r2, r2, r3
a038f488 b631dde1 ldrh     r3, [sp, #0x16]
a038f48c 18109de5 ldr      r1, [sp, #0x18]
a038f490 910303e0 mul      r3, r1, r3
a038f494 032082e0 add      r2, r2, r3
a038f498 1c309de5 ldr      r3, [sp, #0x1c]
a038f49c 032082e0 add      r2, r2, r3
a038f4a0 c83c01e3 movw     r3, #0x1cc8
a038f4a4 70304ae3 movt     r3, #0xa070
a038f4a8 8220a0e1 lsl      r2, r2, #1
a038f4ac 023083e0 add      r3, r3, r2
a038f4b0 b030d3e1 ldrh     r3, [r3]
a038f4b4 7320bfe6 sxth     r2, r3
a038f4b8 f032dde1 ldrsh    r3, [sp, #0x20]
a038f4bc 011083e2 add      r1, r3, #1
a038f4c0 c63c01e3 movw     r3, #0x1cc6
a038f4c4 70304ae3 movt     r3, #0xa070
a038f4c8 b030d3e1 ldrh     r3, [r3]
a038f4cc 7330bfe6 sxth     r3, r3
a038f4d0 930101e0 mul      r1, r3, r1
a038f4d4 6e3b0ae3 movw     r3, #0xab6e
a038f4d8 70314ae3 movt     r3, #0xa170
a038f4dc b030d3e1 ldrh     r3, [r3]
a038f4e0 7330bfe6 sxth     r3, r3
a038f4e4 013063e0 rsb      r3, r3, r1
a038f4e8 930202e0 mul      r2, r3, r2
a038f4ec c23c01e3 movw     r3, #0x1cc2
a038f4f0 70304ae3 movt     r3, #0xa070
a038f4f4 b030d3e1 ldrh     r3, [r3]
a038f4f8 7310bfe6 sxth     r1, r3
a038f4fc f232dde1 ldrsh    r3, [sp, #0x22]
a038f500 031081e0 add      r1, r1, r3
a038f504 c43c01e3 movw     r3, #0x1cc4
a038f508 70304ae3 movt     r3, #0xa070
a038f50c b030d3e1 ldrh     r3, [r3]
a038f510 7330bfe6 sxth     r3, r3
a038f514 8330a0e1 lsl      r3, r3, #1
a038f518 013083e2 add      r3, r3, #1
a038f51c 930101e0 mul      r1, r3, r1
a038f520 c43c01e3 movw     r3, #0x1cc4
a038f524 70304ae3 movt     r3, #0xa070
a038f528 b030d3e1 ldrh     r3, [r3]
a038f52c 7300bfe6 sxth     r0, r3
a038f530 f032dde1 ldrsh    r3, [sp, #0x20]
a038f534 033080e0 add      r3, r0, r3
a038f538 013083e2 add      r3, r3, #1
a038f53c 033081e0 add      r3, r1, r3
a038f540 b611dde1 ldrh     r1, [sp, #0x16]
a038f544 910303e0 mul      r3, r1, r3
a038f548 b411dde1 ldrh     r1, [sp, #0x14]
a038f54c 910301e0 mul      r1, r1, r3
a038f550 b631dde1 ldrh     r3, [sp, #0x16]
a038f554 18009de5 ldr      r0, [sp, #0x18]
a038f558 900303e0 mul      r3, r0, r3
a038f55c 031081e0 add      r1, r1, r3
a038f560 1c309de5 ldr      r3, [sp, #0x1c]
a038f564 031081e0 add      r1, r1, r3
a038f568 c83c01e3 movw     r3, #0x1cc8
a038f56c 70304ae3 movt     r3, #0xa070
a038f570 8110a0e1 lsl      r1, r1, #1
a038f574 013083e0 add      r3, r3, r1
a038f578 b030d3e1 ldrh     r3, [r3]
a038f57c 7310bfe6 sxth     r1, r3
a038f580 6e3b0ae3 movw     r3, #0xab6e
a038f584 70314ae3 movt     r3, #0xa170
a038f588 b030d3e1 ldrh     r3, [r3]
a038f58c 7300bfe6 sxth     r0, r3
a038f590 f0c2dde1 ldrsh    ip, [sp, #0x20]
a038f594 c63c01e3 movw     r3, #0x1cc6
a038f598 70304ae3 movt     r3, #0xa070
a038f59c b030d3e1 ldrh     r3, [r3]
a038f5a0 7330bfe6 sxth     r3, r3
a038f5a4 930c03e0 mul      r3, r3, ip
a038f5a8 003063e0 rsb      r3, r3, r0
a038f5ac 930103e0 mul      r3, r3, r1
a038f5b0 032082e0 add      r2, r2, r3
a038f5b4 c63c01e3 movw     r3, #0x1cc6
a038f5b8 70304ae3 movt     r3, #0xa070
a038f5bc b030d3e1 ldrh     r3, [r3]
a038f5c0 7330bfe6 sxth     r3, r3
a038f5c4 0200a0e1 mov      r0, r2
a038f5c8 0310a0e1 mov      r1, r3
a038f5cc 2fdc05fa blx      #0xa0506690
a038f5d0 0030a0e1 mov      r3, r0
a038f5d4 7320ffe6 uxth     r2, r3
a038f5d8 203202e3 movw     r3, #0x2220
a038f5dc 70314ae3 movt     r3, #0xa170
a038f5e0 8410a0e1 lsl      r1, r4, #1
a038f5e4 013083e0 add      r3, r3, r1
a038f5e8 b020c3e1 strh     r2, [r3]
a038f5ec b631dde1 ldrh     r3, [sp, #0x16]
a038f5f0 18209de5 ldr      r2, [sp, #0x18]
a038f5f4 920302e0 mul      r2, r2, r3
a038f5f8 1c309de5 ldr      r3, [sp, #0x1c]
a038f5fc 034082e0 add      r4, r2, r3
a038f600 c23c01e3 movw     r3, #0x1cc2
a038f604 70304ae3 movt     r3, #0xa070
a038f608 b030d3e1 ldrh     r3, [r3]
a038f60c 7320bfe6 sxth     r2, r3
a038f610 f232dde1 ldrsh    r3, [sp, #0x22]
a038f614 033082e0 add      r3, r2, r3
a038f618 012083e2 add      r2, r3, #1
a038f61c c43c01e3 movw     r3, #0x1cc4
a038f620 70304ae3 movt     r3, #0xa070
a038f624 b030d3e1 ldrh     r3, [r3]
a038f628 7330bfe6 sxth     r3, r3
a038f62c 8330a0e1 lsl      r3, r3, #1
a038f630 013083e2 add      r3, r3, #1
a038f634 930202e0 mul      r2, r3, r2
a038f638 c43c01e3 movw     r3, #0x1cc4
a038f63c 70304ae3 movt     r3, #0xa070
a038f640 b030d3e1 ldrh     r3, [r3]
a038f644 7310bfe6 sxth     r1, r3
a038f648 f032dde1 ldrsh    r3, [sp, #0x20]
a038f64c 033081e0 add      r3, r1, r3
a038f650 033082e0 add      r3, r2, r3
a038f654 b621dde1 ldrh     r2, [sp, #0x16]
a038f658 920303e0 mul      r3, r2, r3
a038f65c b421dde1 ldrh     r2, [sp, #0x14]
a038f660 920302e0 mul      r2, r2, r3
a038f664 b631dde1 ldrh     r3, [sp, #0x16]
a038f668 18109de5 ldr      r1, [sp, #0x18]
a038f66c 910303e0 mul      r3, r1, r3
a038f670 032082e0 add      r2, r2, r3
a038f674 1c309de5 ldr      r3, [sp, #0x1c]
a038f678 032082e0 add      r2, r2, r3
a038f67c c83c01e3 movw     r3, #0x1cc8
a038f680 70304ae3 movt     r3, #0xa070
a038f684 8220a0e1 lsl      r2, r2, #1
a038f688 023083e0 add      r3, r3, r2
a038f68c b030d3e1 ldrh     r3, [r3]
a038f690 7320bfe6 sxth     r2, r3
a038f694 f032dde1 ldrsh    r3, [sp, #0x20]
a038f698 011083e2 add      r1, r3, #1
a038f69c c63c01e3 movw     r3, #0x1cc6
a038f6a0 70304ae3 movt     r3, #0xa070
a038f6a4 b030d3e1 ldrh     r3, [r3]
a038f6a8 7330bfe6 sxth     r3, r3
a038f6ac 930101e0 mul      r1, r3, r1
a038f6b0 6e3b0ae3 movw     r3, #0xab6e
a038f6b4 70314ae3 movt     r3, #0xa170
a038f6b8 b030d3e1 ldrh     r3, [r3]
a038f6bc 7330bfe6 sxth     r3, r3
a038f6c0 013063e0 rsb      r3, r3, r1
a038f6c4 930202e0 mul      r2, r3, r2
a038f6c8 c23c01e3 movw     r3, #0x1cc2
a038f6cc 70304ae3 movt     r3, #0xa070
a038f6d0 b030d3e1 ldrh     r3, [r3]
a038f6d4 7310bfe6 sxth     r1, r3
a038f6d8 f232dde1 ldrsh    r3, [sp, #0x22]
a038f6dc 033081e0 add      r3, r1, r3
a038f6e0 011083e2 add      r1, r3, #1
a038f6e4 c43c01e3 movw     r3, #0x1cc4
a038f6e8 70304ae3 movt     r3, #0xa070
a038f6ec b030d3e1 ldrh     r3, [r3]
a038f6f0 7330bfe6 sxth     r3, r3
a038f6f4 8330a0e1 lsl      r3, r3, #1
a038f6f8 013083e2 add      r3, r3, #1
a038f6fc 930101e0 mul      r1, r3, r1
a038f700 c43c01e3 movw     r3, #0x1cc4
a038f704 70304ae3 movt     r3, #0xa070
a038f708 b030d3e1 ldrh     r3, [r3]
a038f70c 7300bfe6 sxth     r0, r3
a038f710 f032dde1 ldrsh    r3, [sp, #0x20]
a038f714 033080e0 add      r3, r0, r3
a038f718 013083e2 add      r3, r3, #1
a038f71c 033081e0 add      r3, r1, r3
a038f720 b611dde1 ldrh     r1, [sp, #0x16]
a038f724 910303e0 mul      r3, r1, r3
a038f728 b411dde1 ldrh     r1, [sp, #0x14]
a038f72c 910301e0 mul      r1, r1, r3
a038f730 b631dde1 ldrh     r3, [sp, #0x16]
a038f734 18009de5 ldr      r0, [sp, #0x18]
a038f738 900303e0 mul      r3, r0, r3
a038f73c 031081e0 add      r1, r1, r3
a038f740 1c309de5 ldr      r3, [sp, #0x1c]
a038f744 031081e0 add      r1, r1, r3
a038f748 c83c01e3 movw     r3, #0x1cc8
a038f74c 70304ae3 movt     r3, #0xa070
a038f750 8110a0e1 lsl      r1, r1, #1
a038f754 013083e0 add      r3, r3, r1
a038f758 b030d3e1 ldrh     r3, [r3]
a038f75c 7310bfe6 sxth     r1, r3
a038f760 6e3b0ae3 movw     r3, #0xab6e
a038f764 70314ae3 movt     r3, #0xa170
a038f768 b030d3e1 ldrh     r3, [r3]
a038f76c 7300bfe6 sxth     r0, r3
a038f770 f0c2dde1 ldrsh    ip, [sp, #0x20]
a038f774 c63c01e3 movw     r3, #0x1cc6
a038f778 70304ae3 movt     r3, #0xa070
a038f77c b030d3e1 ldrh     r3, [r3]
a038f780 7330bfe6 sxth     r3, r3
a038f784 930c03e0 mul      r3, r3, ip
a038f788 003063e0 rsb      r3, r3, r0
a038f78c 930103e0 mul      r3, r3, r1
a038f790 032082e0 add      r2, r2, r3
a038f794 c63c01e3 movw     r3, #0x1cc6
a038f798 70304ae3 movt     r3, #0xa070
a038f79c b030d3e1 ldrh     r3, [r3]
a038f7a0 7330bfe6 sxth     r3, r3
a038f7a4 0200a0e1 mov      r0, r2
a038f7a8 0310a0e1 mov      r1, r3
a038f7ac b7db05fa blx      #0xa0506690
a038f7b0 0030a0e1 mov      r3, r0
a038f7b4 7320ffe6 uxth     r2, r3
a038f7b8 a43402e3 movw     r3, #0x24a4
a038f7bc 70314ae3 movt     r3, #0xa170
a038f7c0 8410a0e1 lsl      r1, r4, #1
a038f7c4 013083e0 add      r3, r3, r1
a038f7c8 b020c3e1 strh     r2, [r3]
a038f7cc b631dde1 ldrh     r3, [sp, #0x16]
a038f7d0 18209de5 ldr      r2, [sp, #0x18]
a038f7d4 920302e0 mul      r2, r2, r3
a038f7d8 1c309de5 ldr      r3, [sp, #0x1c]
a038f7dc 034082e0 add      r4, r2, r3
a038f7e0 c23c01e3 movw     r3, #0x1cc2
a038f7e4 70304ae3 movt     r3, #0xa070
a038f7e8 b030d3e1 ldrh     r3, [r3]
a038f7ec 7320bfe6 sxth     r2, r3
a038f7f0 f232dde1 ldrsh    r3, [sp, #0x22]
a038f7f4 032082e0 add      r2, r2, r3
a038f7f8 c43c01e3 movw     r3, #0x1cc4
a038f7fc 70304ae3 movt     r3, #0xa070
a038f800 b030d3e1 ldrh     r3, [r3]
a038f804 7330bfe6 sxth     r3, r3
a038f808 8330a0e1 lsl      r3, r3, #1
a038f80c 013083e2 add      r3, r3, #1
a038f810 930202e0 mul      r2, r3, r2
a038f814 c43c01e3 movw     r3, #0x1cc4
a038f818 70304ae3 movt     r3, #0xa070
a038f81c b030d3e1 ldrh     r3, [r3]
a038f820 7310bfe6 sxth     r1, r3
a038f824 f032dde1 ldrsh    r3, [sp, #0x20]
a038f828 033081e0 add      r3, r1, r3
a038f82c 033082e0 add      r3, r2, r3
a038f830 b621dde1 ldrh     r2, [sp, #0x16]
a038f834 920303e0 mul      r3, r2, r3
a038f838 b421dde1 ldrh     r2, [sp, #0x14]
a038f83c 920302e0 mul      r2, r2, r3
a038f840 b631dde1 ldrh     r3, [sp, #0x16]
a038f844 18109de5 ldr      r1, [sp, #0x18]
a038f848 910303e0 mul      r3, r1, r3
a038f84c 032082e0 add      r2, r2, r3
a038f850 1c309de5 ldr      r3, [sp, #0x1c]
a038f854 032082e0 add      r2, r2, r3
a038f858 8c3b0ce3 movw     r3, #0xcb8c
a038f85c 72304ae3 movt     r3, #0xa072
a038f860 8220a0e1 lsl      r2, r2, #1
a038f864 023083e0 add      r3, r3, r2
a038f868 b030d3e1 ldrh     r3, [r3]
a038f86c 7320bfe6 sxth     r2, r3
a038f870 f032dde1 ldrsh    r3, [sp, #0x20]
a038f874 011083e2 add      r1, r3, #1
a038f878 c63c01e3 movw     r3, #0x1cc6
a038f87c 70304ae3 movt     r3, #0xa070
a038f880 b030d3e1 ldrh     r3, [r3]
a038f884 7330bfe6 sxth     r3, r3
a038f888 930101e0 mul      r1, r3, r1
a038f88c 6e3b0ae3 movw     r3, #0xab6e
a038f890 70314ae3 movt     r3, #0xa170
a038f894 b030d3e1 ldrh     r3, [r3]
a038f898 7330bfe6 sxth     r3, r3
a038f89c 013063e0 rsb      r3, r3, r1
a038f8a0 930202e0 mul      r2, r3, r2
a038f8a4 c23c01e3 movw     r3, #0x1cc2
a038f8a8 70304ae3 movt     r3, #0xa070
a038f8ac b030d3e1 ldrh     r3, [r3]
a038f8b0 7310bfe6 sxth     r1, r3
a038f8b4 f232dde1 ldrsh    r3, [sp, #0x22]
a038f8b8 031081e0 add      r1, r1, r3
a038f8bc c43c01e3 movw     r3, #0x1cc4
a038f8c0 70304ae3 movt     r3, #0xa070
a038f8c4 b030d3e1 ldrh     r3, [r3]
a038f8c8 7330bfe6 sxth     r3, r3
a038f8cc 8330a0e1 lsl      r3, r3, #1
a038f8d0 013083e2 add      r3, r3, #1
a038f8d4 930101e0 mul      r1, r3, r1
a038f8d8 c43c01e3 movw     r3, #0x1cc4
a038f8dc 70304ae3 movt     r3, #0xa070
a038f8e0 b030d3e1 ldrh     r3, [r3]
a038f8e4 7300bfe6 sxth     r0, r3
a038f8e8 f032dde1 ldrsh    r3, [sp, #0x20]
a038f8ec 033080e0 add      r3, r0, r3
a038f8f0 013083e2 add      r3, r3, #1
a038f8f4 033081e0 add      r3, r1, r3
a038f8f8 b611dde1 ldrh     r1, [sp, #0x16]
a038f8fc 910303e0 mul      r3, r1, r3
a038f900 b411dde1 ldrh     r1, [sp, #0x14]
a038f904 910301e0 mul      r1, r1, r3
a038f908 b631dde1 ldrh     r3, [sp, #0x16]
a038f90c 18009de5 ldr      r0, [sp, #0x18]
a038f910 900303e0 mul      r3, r0, r3
a038f914 031081e0 add      r1, r1, r3
a038f918 1c309de5 ldr      r3, [sp, #0x1c]
a038f91c 031081e0 add      r1, r1, r3
a038f920 8c3b0ce3 movw     r3, #0xcb8c
a038f924 72304ae3 movt     r3, #0xa072
a038f928 8110a0e1 lsl      r1, r1, #1
a038f92c 013083e0 add      r3, r3, r1
a038f930 b030d3e1 ldrh     r3, [r3]
a038f934 7310bfe6 sxth     r1, r3
a038f938 6e3b0ae3 movw     r3, #0xab6e
a038f93c 70314ae3 movt     r3, #0xa170
a038f940 b030d3e1 ldrh     r3, [r3]
a038f944 7300bfe6 sxth     r0, r3
a038f948 f0c2dde1 ldrsh    ip, [sp, #0x20]
a038f94c c63c01e3 movw     r3, #0x1cc6
a038f950 70304ae3 movt     r3, #0xa070
a038f954 b030d3e1 ldrh     r3, [r3]
a038f958 7330bfe6 sxth     r3, r3
a038f95c 930c03e0 mul      r3, r3, ip
a038f960 003063e0 rsb      r3, r3, r0
a038f964 930103e0 mul      r3, r3, r1
a038f968 032082e0 add      r2, r2, r3
a038f96c c63c01e3 movw     r3, #0x1cc6
a038f970 70304ae3 movt     r3, #0xa070
a038f974 b030d3e1 ldrh     r3, [r3]
a038f978 7330bfe6 sxth     r3, r3
a038f97c 0200a0e1 mov      r0, r2
a038f980 0310a0e1 mov      r1, r3
a038f984 41db05fa blx      #0xa0506690
a038f988 0030a0e1 mov      r3, r0
a038f98c 7320ffe6 uxth     r2, r3
a038f990 283702e3 movw     r3, #0x2728
a038f994 70314ae3 movt     r3, #0xa170
a038f998 8410a0e1 lsl      r1, r4, #1
a038f99c 013083e0 add      r3, r3, r1
a038f9a0 b020c3e1 strh     r2, [r3]
a038f9a4 b631dde1 ldrh     r3, [sp, #0x16]
a038f9a8 18209de5 ldr      r2, [sp, #0x18]
a038f9ac 920302e0 mul      r2, r2, r3
a038f9b0 1c309de5 ldr      r3, [sp, #0x1c]
a038f9b4 034082e0 add      r4, r2, r3
a038f9b8 c23c01e3 movw     r3, #0x1cc2
a038f9bc 70304ae3 movt     r3, #0xa070
a038f9c0 b030d3e1 ldrh     r3, [r3]
a038f9c4 7320bfe6 sxth     r2, r3
a038f9c8 f232dde1 ldrsh    r3, [sp, #0x22]
a038f9cc 033082e0 add      r3, r2, r3
a038f9d0 012083e2 add      r2, r3, #1
a038f9d4 c43c01e3 movw     r3, #0x1cc4
a038f9d8 70304ae3 movt     r3, #0xa070
a038f9dc b030d3e1 ldrh     r3, [r3]
a038f9e0 7330bfe6 sxth     r3, r3
a038f9e4 8330a0e1 lsl      r3, r3, #1
a038f9e8 013083e2 add      r3, r3, #1
a038f9ec 930202e0 mul      r2, r3, r2
a038f9f0 c43c01e3 movw     r3, #0x1cc4
a038f9f4 70304ae3 movt     r3, #0xa070
a038f9f8 b030d3e1 ldrh     r3, [r3]
a038f9fc 7310bfe6 sxth     r1, r3
a038fa00 f032dde1 ldrsh    r3, [sp, #0x20]
a038fa04 033081e0 add      r3, r1, r3
a038fa08 033082e0 add      r3, r2, r3
a038fa0c b621dde1 ldrh     r2, [sp, #0x16]
a038fa10 920303e0 mul      r3, r2, r3
a038fa14 b421dde1 ldrh     r2, [sp, #0x14]
a038fa18 920302e0 mul      r2, r2, r3
a038fa1c b631dde1 ldrh     r3, [sp, #0x16]
a038fa20 18109de5 ldr      r1, [sp, #0x18]
a038fa24 910303e0 mul      r3, r1, r3
a038fa28 032082e0 add      r2, r2, r3
a038fa2c 1c309de5 ldr      r3, [sp, #0x1c]
a038fa30 032082e0 add      r2, r2, r3
a038fa34 8c3b0ce3 movw     r3, #0xcb8c
a038fa38 72304ae3 movt     r3, #0xa072
a038fa3c 8220a0e1 lsl      r2, r2, #1
a038fa40 023083e0 add      r3, r3, r2
a038fa44 b030d3e1 ldrh     r3, [r3]
a038fa48 7320bfe6 sxth     r2, r3
a038fa4c f032dde1 ldrsh    r3, [sp, #0x20]
a038fa50 011083e2 add      r1, r3, #1
a038fa54 c63c01e3 movw     r3, #0x1cc6
a038fa58 70304ae3 movt     r3, #0xa070
a038fa5c b030d3e1 ldrh     r3, [r3]
a038fa60 7330bfe6 sxth     r3, r3
a038fa64 930101e0 mul      r1, r3, r1
a038fa68 6e3b0ae3 movw     r3, #0xab6e
a038fa6c 70314ae3 movt     r3, #0xa170
a038fa70 b030d3e1 ldrh     r3, [r3]
a038fa74 7330bfe6 sxth     r3, r3
a038fa78 013063e0 rsb      r3, r3, r1
a038fa7c 930202e0 mul      r2, r3, r2
a038fa80 c23c01e3 movw     r3, #0x1cc2
a038fa84 70304ae3 movt     r3, #0xa070
a038fa88 b030d3e1 ldrh     r3, [r3]
a038fa8c 7310bfe6 sxth     r1, r3
a038fa90 f232dde1 ldrsh    r3, [sp, #0x22]
a038fa94 033081e0 add      r3, r1, r3
a038fa98 011083e2 add      r1, r3, #1
a038fa9c c43c01e3 movw     r3, #0x1cc4
a038faa0 70304ae3 movt     r3, #0xa070
a038faa4 b030d3e1 ldrh     r3, [r3]
a038faa8 7330bfe6 sxth     r3, r3
a038faac 8330a0e1 lsl      r3, r3, #1
a038fab0 013083e2 add      r3, r3, #1
a038fab4 930101e0 mul      r1, r3, r1
a038fab8 c43c01e3 movw     r3, #0x1cc4
a038fabc 70304ae3 movt     r3, #0xa070
a038fac0 b030d3e1 ldrh     r3, [r3]
a038fac4 7300bfe6 sxth     r0, r3
a038fac8 f032dde1 ldrsh    r3, [sp, #0x20]
a038facc 033080e0 add      r3, r0, r3
a038fad0 013083e2 add      r3, r3, #1
a038fad4 033081e0 add      r3, r1, r3
a038fad8 b611dde1 ldrh     r1, [sp, #0x16]
a038fadc 910303e0 mul      r3, r1, r3
a038fae0 b411dde1 ldrh     r1, [sp, #0x14]
a038fae4 910301e0 mul      r1, r1, r3
a038fae8 b631dde1 ldrh     r3, [sp, #0x16]
a038faec 18009de5 ldr      r0, [sp, #0x18]
a038faf0 900303e0 mul      r3, r0, r3
a038faf4 031081e0 add      r1, r1, r3
a038faf8 1c309de5 ldr      r3, [sp, #0x1c]
a038fafc 031081e0 add      r1, r1, r3
a038fb00 8c3b0ce3 movw     r3, #0xcb8c
a038fb04 72304ae3 movt     r3, #0xa072
a038fb08 8110a0e1 lsl      r1, r1, #1
a038fb0c 013083e0 add      r3, r3, r1
a038fb10 b030d3e1 ldrh     r3, [r3]
a038fb14 7310bfe6 sxth     r1, r3
a038fb18 6e3b0ae3 movw     r3, #0xab6e
a038fb1c 70314ae3 movt     r3, #0xa170
a038fb20 b030d3e1 ldrh     r3, [r3]
a038fb24 7300bfe6 sxth     r0, r3
a038fb28 f0c2dde1 ldrsh    ip, [sp, #0x20]
a038fb2c c63c01e3 movw     r3, #0x1cc6
a038fb30 70304ae3 movt     r3, #0xa070
a038fb34 b030d3e1 ldrh     r3, [r3]
a038fb38 7330bfe6 sxth     r3, r3
a038fb3c 930c03e0 mul      r3, r3, ip
a038fb40 003063e0 rsb      r3, r3, r0
a038fb44 930103e0 mul      r3, r3, r1
a038fb48 032082e0 add      r2, r2, r3
a038fb4c c63c01e3 movw     r3, #0x1cc6
a038fb50 70304ae3 movt     r3, #0xa070
a038fb54 b030d3e1 ldrh     r3, [r3]
a038fb58 7330bfe6 sxth     r3, r3
a038fb5c 0200a0e1 mov      r0, r2
a038fb60 0310a0e1 mov      r1, r3
a038fb64 c9da05fa blx      #0xa0506690
a038fb68 0030a0e1 mov      r3, r0
a038fb6c 7320ffe6 uxth     r2, r3
a038fb70 ac3902e3 movw     r3, #0x29ac
a038fb74 70314ae3 movt     r3, #0xa170
a038fb78 8410a0e1 lsl      r1, r4, #1
a038fb7c 013083e0 add      r3, r3, r1
a038fb80 b020c3e1 strh     r2, [r3]
a038fb84 1c309de5 ldr      r3, [sp, #0x1c]
a038fb88 013083e2 add      r3, r3, #1
a038fb8c 1c308de5 str      r3, [sp, #0x1c]
a038fb90 b621dde1 ldrh     r2, [sp, #0x16]
a038fb94 1c309de5 ldr      r3, [sp, #0x1c]
a038fb98 030052e1 cmp      r2, r3
a038fb9c 1cfeffca bgt      #0xa038f414
a038fba0 18309de5 ldr      r3, [sp, #0x18]
a038fba4 013083e2 add      r3, r3, #1
a038fba8 18308de5 str      r3, [sp, #0x18]
a038fbac b421dde1 ldrh     r2, [sp, #0x14]
a038fbb0 18309de5 ldr      r3, [sp, #0x18]
a038fbb4 030052e1 cmp      r2, r3
a038fbb8 12feffca bgt      #0xa038f408
a038fbbc 0030a0e3 mov      r3, #0
a038fbc0 18308de5 str      r3, [sp, #0x18]
a038fbc4 900000ea b        #0xa038fe0c
a038fbc8 0030a0e3 mov      r3, #0
a038fbcc 1c308de5 str      r3, [sp, #0x1c]
a038fbd0 860000ea b        #0xa038fdf0
a038fbd4 b631dde1 ldrh     r3, [sp, #0x16]
a038fbd8 18209de5 ldr      r2, [sp, #0x18]
a038fbdc 920302e0 mul      r2, r2, r3
a038fbe0 1c309de5 ldr      r3, [sp, #0x1c]
a038fbe4 033082e0 add      r3, r2, r3
a038fbe8 0331a0e1 lsl      r3, r3, #2
a038fbec 04209de5 ldr      r2, [sp, #4]
a038fbf0 034082e0 add      r4, r2, r3
a038fbf4 b631dde1 ldrh     r3, [sp, #0x16]
a038fbf8 18209de5 ldr      r2, [sp, #0x18]
a038fbfc 920302e0 mul      r2, r2, r3
a038fc00 1c309de5 ldr      r3, [sp, #0x1c]
a038fc04 032082e0 add      r2, r2, r3
a038fc08 203202e3 movw     r3, #0x2220
a038fc0c 70314ae3 movt     r3, #0xa170
a038fc10 8220a0e1 lsl      r2, r2, #1
a038fc14 023083e0 add      r3, r3, r2
a038fc18 b030d3e1 ldrh     r3, [r3]
a038fc1c 7320bfe6 sxth     r2, r3
a038fc20 f232dde1 ldrsh    r3, [sp, #0x22]
a038fc24 011083e2 add      r1, r3, #1
a038fc28 c63c01e3 movw     r3, #0x1cc6
a038fc2c 70304ae3 movt     r3, #0xa070
a038fc30 b030d3e1 ldrh     r3, [r3]
a038fc34 7330bfe6 sxth     r3, r3
a038fc38 930101e0 mul      r1, r3, r1
a038fc3c 6c3b0ae3 movw     r3, #0xab6c
a038fc40 70314ae3 movt     r3, #0xa170
a038fc44 b030d3e1 ldrh     r3, [r3]
a038fc48 7330bfe6 sxth     r3, r3
a038fc4c 013063e0 rsb      r3, r3, r1
a038fc50 930202e0 mul      r2, r3, r2
a038fc54 b631dde1 ldrh     r3, [sp, #0x16]
a038fc58 18109de5 ldr      r1, [sp, #0x18]
a038fc5c 910301e0 mul      r1, r1, r3
a038fc60 1c309de5 ldr      r3, [sp, #0x1c]
a038fc64 031081e0 add      r1, r1, r3
a038fc68 a43402e3 movw     r3, #0x24a4
a038fc6c 70314ae3 movt     r3, #0xa170
a038fc70 8110a0e1 lsl      r1, r1, #1
a038fc74 013083e0 add      r3, r3, r1
a038fc78 b030d3e1 ldrh     r3, [r3]
a038fc7c 7310bfe6 sxth     r1, r3
a038fc80 6c3b0ae3 movw     r3, #0xab6c
a038fc84 70314ae3 movt     r3, #0xa170
a038fc88 b030d3e1 ldrh     r3, [r3]
a038fc8c 7300bfe6 sxth     r0, r3
a038fc90 f2c2dde1 ldrsh    ip, [sp, #0x22]
a038fc94 c63c01e3 movw     r3, #0x1cc6
a038fc98 70304ae3 movt     r3, #0xa070
a038fc9c b030d3e1 ldrh     r3, [r3]
a038fca0 7330bfe6 sxth     r3, r3
a038fca4 930c03e0 mul      r3, r3, ip
a038fca8 003063e0 rsb      r3, r3, r0
a038fcac 930103e0 mul      r3, r3, r1
a038fcb0 032082e0 add      r2, r2, r3
a038fcb4 c63c01e3 movw     r3, #0x1cc6
a038fcb8 70304ae3 movt     r3, #0xa070
a038fcbc b030d3e1 ldrh     r3, [r3]
a038fcc0 7330bfe6 sxth     r3, r3
a038fcc4 0200a0e1 mov      r0, r2
a038fcc8 0310a0e1 mov      r1, r3
a038fccc 6fda05fa blx      #0xa0506690
a038fcd0 0030a0e1 mov      r3, r0
a038fcd4 7330ffe6 uxth     r3, r3
a038fcd8 b030c4e1 strh     r3, [r4]
a038fcdc b631dde1 ldrh     r3, [sp, #0x16]
a038fce0 18209de5 ldr      r2, [sp, #0x18]
a038fce4 920302e0 mul      r2, r2, r3
a038fce8 1c309de5 ldr      r3, [sp, #0x1c]
a038fcec 033082e0 add      r3, r2, r3
a038fcf0 0331a0e1 lsl      r3, r3, #2
a038fcf4 04209de5 ldr      r2, [sp, #4]
a038fcf8 034082e0 add      r4, r2, r3
a038fcfc b631dde1 ldrh     r3, [sp, #0x16]
a038fd00 18209de5 ldr      r2, [sp, #0x18]
a038fd04 920302e0 mul      r2, r2, r3
a038fd08 1c309de5 ldr      r3, [sp, #0x1c]
a038fd0c 032082e0 add      r2, r2, r3
a038fd10 283702e3 movw     r3, #0x2728
a038fd14 70314ae3 movt     r3, #0xa170
a038fd18 8220a0e1 lsl      r2, r2, #1
a038fd1c 023083e0 add      r3, r3, r2
a038fd20 b030d3e1 ldrh     r3, [r3]
a038fd24 7320bfe6 sxth     r2, r3
a038fd28 f232dde1 ldrsh    r3, [sp, #0x22]
a038fd2c 011083e2 add      r1, r3, #1
a038fd30 c63c01e3 movw     r3, #0x1cc6
a038fd34 70304ae3 movt     r3, #0xa070
a038fd38 b030d3e1 ldrh     r3, [r3]
a038fd3c 7330bfe6 sxth     r3, r3
a038fd40 930101e0 mul      r1, r3, r1
a038fd44 6c3b0ae3 movw     r3, #0xab6c
a038fd48 70314ae3 movt     r3, #0xa170
a038fd4c b030d3e1 ldrh     r3, [r3]
a038fd50 7330bfe6 sxth     r3, r3
a038fd54 013063e0 rsb      r3, r3, r1
a038fd58 930202e0 mul      r2, r3, r2
a038fd5c b631dde1 ldrh     r3, [sp, #0x16]
a038fd60 18109de5 ldr      r1, [sp, #0x18]
a038fd64 910301e0 mul      r1, r1, r3
a038fd68 1c309de5 ldr      r3, [sp, #0x1c]
a038fd6c 031081e0 add      r1, r1, r3
a038fd70 ac3902e3 movw     r3, #0x29ac
a038fd74 70314ae3 movt     r3, #0xa170
a038fd78 8110a0e1 lsl      r1, r1, #1
a038fd7c 013083e0 add      r3, r3, r1
a038fd80 b030d3e1 ldrh     r3, [r3]
a038fd84 7310bfe6 sxth     r1, r3
a038fd88 6c3b0ae3 movw     r3, #0xab6c
a038fd8c 70314ae3 movt     r3, #0xa170
a038fd90 b030d3e1 ldrh     r3, [r3]
a038fd94 7300bfe6 sxth     r0, r3
a038fd98 f2c2dde1 ldrsh    ip, [sp, #0x22]
a038fd9c c63c01e3 movw     r3, #0x1cc6
a038fda0 70304ae3 movt     r3, #0xa070
a038fda4 b030d3e1 ldrh     r3, [r3]
a038fda8 7330bfe6 sxth     r3, r3
a038fdac 930c03e0 mul      r3, r3, ip
a038fdb0 003063e0 rsb      r3, r3, r0
a038fdb4 930103e0 mul      r3, r3, r1
a038fdb8 032082e0 add      r2, r2, r3
a038fdbc c63c01e3 movw     r3, #0x1cc6
a038fdc0 70304ae3 movt     r3, #0xa070
a038fdc4 b030d3e1 ldrh     r3, [r3]
a038fdc8 7330bfe6 sxth     r3, r3
a038fdcc 0200a0e1 mov      r0, r2
a038fdd0 0310a0e1 mov      r1, r3
a038fdd4 2dda05fa blx      #0xa0506690
a038fdd8 0030a0e1 mov      r3, r0
a038fddc 7330ffe6 uxth     r3, r3
a038fde0 b230c4e1 strh     r3, [r4, #2]
a038fde4 1c309de5 ldr      r3, [sp, #0x1c]
a038fde8 013083e2 add      r3, r3, #1
a038fdec 1c308de5 str      r3, [sp, #0x1c]
a038fdf0 b621dde1 ldrh     r2, [sp, #0x16]
a038fdf4 1c309de5 ldr      r3, [sp, #0x1c]
a038fdf8 030052e1 cmp      r2, r3
a038fdfc 74ffffca bgt      #0xa038fbd4
a038fe00 18309de5 ldr      r3, [sp, #0x18]
a038fe04 013083e2 add      r3, r3, #1
a038fe08 18308de5 str      r3, [sp, #0x18]
a038fe0c b421dde1 ldrh     r2, [sp, #0x14]
a038fe10 18309de5 ldr      r3, [sp, #0x18]
a038fe14 030052e1 cmp      r2, r3
a038fe18 6affffca bgt      #0xa038fbc8
a038fe1c b10700ea b        #0xa0391ce8
a038fe20 703b0ae3 movw     r3, #0xab70
a038fe24 70314ae3 movt     r3, #0xa170
a038fe28 b030d3e1 ldrh     r3, [r3]
a038fe2c 7330bfe6 sxth     r3, r3
a038fe30 000053e3 cmp      r3, #0
a038fe34 8e0200da ble      #0xa0390874
a038fe38 723b0ae3 movw     r3, #0xab72
a038fe3c 70314ae3 movt     r3, #0xa170
a038fe40 b030d3e1 ldrh     r3, [r3]
a038fe44 7330bfe6 sxth     r3, r3
a038fe48 000053e3 cmp      r3, #0
a038fe4c 880200aa bge      #0xa0390874
a038fe50 0030a0e3 mov      r3, #0
a038fe54 18308de5 str      r3, [sp, #0x18]
a038fe58 e80100ea b        #0xa0390600
a038fe5c 0030a0e3 mov      r3, #0
a038fe60 1c308de5 str      r3, [sp, #0x1c]
a038fe64 de0100ea b        #0xa03905e4
a038fe68 b631dde1 ldrh     r3, [sp, #0x16]
a038fe6c 18209de5 ldr      r2, [sp, #0x18]
a038fe70 920302e0 mul      r2, r2, r3
a038fe74 1c309de5 ldr      r3, [sp, #0x1c]
a038fe78 034082e0 add      r4, r2, r3
a038fe7c c23c01e3 movw     r3, #0x1cc2
a038fe80 70304ae3 movt     r3, #0xa070
a038fe84 b030d3e1 ldrh     r3, [r3]
a038fe88 7320bfe6 sxth     r2, r3
a038fe8c f232dde1 ldrsh    r3, [sp, #0x22]
a038fe90 032082e0 add      r2, r2, r3
a038fe94 c43c01e3 movw     r3, #0x1cc4
a038fe98 70304ae3 movt     r3, #0xa070
a038fe9c b030d3e1 ldrh     r3, [r3]
a038fea0 7330bfe6 sxth     r3, r3
a038fea4 8330a0e1 lsl      r3, r3, #1
a038fea8 013083e2 add      r3, r3, #1
a038feac 930202e0 mul      r2, r3, r2
a038feb0 c43c01e3 movw     r3, #0x1cc4
a038feb4 70304ae3 movt     r3, #0xa070
a038feb8 b030d3e1 ldrh     r3, [r3]
a038febc 7310bfe6 sxth     r1, r3
a038fec0 f032dde1 ldrsh    r3, [sp, #0x20]
a038fec4 013063e0 rsb      r3, r3, r1
a038fec8 033082e0 add      r3, r2, r3
a038fecc b621dde1 ldrh     r2, [sp, #0x16]
a038fed0 920303e0 mul      r3, r2, r3
a038fed4 b421dde1 ldrh     r2, [sp, #0x14]
a038fed8 920302e0 mul      r2, r2, r3
a038fedc b631dde1 ldrh     r3, [sp, #0x16]
a038fee0 18109de5 ldr      r1, [sp, #0x18]
a038fee4 910303e0 mul      r3, r1, r3
a038fee8 032082e0 add      r2, r2, r3
a038feec 1c309de5 ldr      r3, [sp, #0x1c]
a038fef0 032082e0 add      r2, r2, r3
a038fef4 c83c01e3 movw     r3, #0x1cc8
a038fef8 70304ae3 movt     r3, #0xa070
a038fefc 8220a0e1 lsl      r2, r2, #1
a038ff00 023083e0 add      r3, r3, r2
a038ff04 b030d3e1 ldrh     r3, [r3]
a038ff08 7320bfe6 sxth     r2, r3
a038ff0c f032dde1 ldrsh    r3, [sp, #0x20]
a038ff10 011083e2 add      r1, r3, #1
a038ff14 c63c01e3 movw     r3, #0x1cc6
a038ff18 70304ae3 movt     r3, #0xa070
a038ff1c b030d3e1 ldrh     r3, [r3]
a038ff20 7330bfe6 sxth     r3, r3
a038ff24 930101e0 mul      r1, r3, r1
a038ff28 6e3b0ae3 movw     r3, #0xab6e
a038ff2c 70314ae3 movt     r3, #0xa170
a038ff30 b030d3e1 ldrh     r3, [r3]
a038ff34 7330bfe6 sxth     r3, r3
a038ff38 013063e0 rsb      r3, r3, r1
a038ff3c 930202e0 mul      r2, r3, r2
a038ff40 c23c01e3 movw     r3, #0x1cc2
a038ff44 70304ae3 movt     r3, #0xa070
a038ff48 b030d3e1 ldrh     r3, [r3]
a038ff4c 7310bfe6 sxth     r1, r3
a038ff50 f232dde1 ldrsh    r3, [sp, #0x22]
a038ff54 031081e0 add      r1, r1, r3
a038ff58 c43c01e3 movw     r3, #0x1cc4
a038ff5c 70304ae3 movt     r3, #0xa070
a038ff60 b030d3e1 ldrh     r3, [r3]
a038ff64 7330bfe6 sxth     r3, r3
a038ff68 8330a0e1 lsl      r3, r3, #1
a038ff6c 013083e2 add      r3, r3, #1
a038ff70 930101e0 mul      r1, r3, r1
a038ff74 c43c01e3 movw     r3, #0x1cc4
a038ff78 70304ae3 movt     r3, #0xa070
a038ff7c b030d3e1 ldrh     r3, [r3]
a038ff80 7300bfe6 sxth     r0, r3
a038ff84 f032dde1 ldrsh    r3, [sp, #0x20]
a038ff88 003063e0 rsb      r3, r3, r0
a038ff8c 013043e2 sub      r3, r3, #1
a038ff90 033081e0 add      r3, r1, r3
a038ff94 b611dde1 ldrh     r1, [sp, #0x16]
a038ff98 910303e0 mul      r3, r1, r3
a038ff9c b411dde1 ldrh     r1, [sp, #0x14]
a038ffa0 910301e0 mul      r1, r1, r3
a038ffa4 b631dde1 ldrh     r3, [sp, #0x16]
a038ffa8 18009de5 ldr      r0, [sp, #0x18]
a038ffac 900303e0 mul      r3, r0, r3
a038ffb0 031081e0 add      r1, r1, r3
a038ffb4 1c309de5 ldr      r3, [sp, #0x1c]
a038ffb8 031081e0 add      r1, r1, r3
a038ffbc c83c01e3 movw     r3, #0x1cc8
a038ffc0 70304ae3 movt     r3, #0xa070
a038ffc4 8110a0e1 lsl      r1, r1, #1
a038ffc8 013083e0 add      r3, r3, r1
a038ffcc b030d3e1 ldrh     r3, [r3]
a038ffd0 7310bfe6 sxth     r1, r3
a038ffd4 6e3b0ae3 movw     r3, #0xab6e
a038ffd8 70314ae3 movt     r3, #0xa170
a038ffdc b030d3e1 ldrh     r3, [r3]
a038ffe0 7300bfe6 sxth     r0, r3
a038ffe4 f0c2dde1 ldrsh    ip, [sp, #0x20]
a038ffe8 c63c01e3 movw     r3, #0x1cc6
a038ffec 70304ae3 movt     r3, #0xa070
a038fff0 b030d3e1 ldrh     r3, [r3]
a038fff4 7330bfe6 sxth     r3, r3
a038fff8 930c03e0 mul      r3, r3, ip
a038fffc 003063e0 rsb      r3, r3, r0
a0390000 930103e0 mul      r3, r3, r1
a0390004 032082e0 add      r2, r2, r3
a0390008 c63c01e3 movw     r3, #0x1cc6
a039000c 70304ae3 movt     r3, #0xa070
a0390010 b030d3e1 ldrh     r3, [r3]
a0390014 7330bfe6 sxth     r3, r3
a0390018 0200a0e1 mov      r0, r2
a039001c 0310a0e1 mov      r1, r3
a0390020 9ad905fa blx      #0xa0506690
a0390024 0030a0e1 mov      r3, r0
a0390028 7320ffe6 uxth     r2, r3
a039002c 203202e3 movw     r3, #0x2220
a0390030 70314ae3 movt     r3, #0xa170
a0390034 8410a0e1 lsl      r1, r4, #1
a0390038 013083e0 add      r3, r3, r1
a039003c b020c3e1 strh     r2, [r3]
a0390040 b631dde1 ldrh     r3, [sp, #0x16]
a0390044 18209de5 ldr      r2, [sp, #0x18]
a0390048 920302e0 mul      r2, r2, r3
a039004c 1c309de5 ldr      r3, [sp, #0x1c]
a0390050 034082e0 add      r4, r2, r3
a0390054 c23c01e3 movw     r3, #0x1cc2
a0390058 70304ae3 movt     r3, #0xa070
a039005c b030d3e1 ldrh     r3, [r3]
a0390060 7320bfe6 sxth     r2, r3
a0390064 f232dde1 ldrsh    r3, [sp, #0x22]
a0390068 033082e0 add      r3, r2, r3
a039006c 012083e2 add      r2, r3, #1
a0390070 c43c01e3 movw     r3, #0x1cc4
a0390074 70304ae3 movt     r3, #0xa070
a0390078 b030d3e1 ldrh     r3, [r3]
a039007c 7330bfe6 sxth     r3, r3
a0390080 8330a0e1 lsl      r3, r3, #1
a0390084 013083e2 add      r3, r3, #1
a0390088 930202e0 mul      r2, r3, r2
a039008c c43c01e3 movw     r3, #0x1cc4
a0390090 70304ae3 movt     r3, #0xa070
a0390094 b030d3e1 ldrh     r3, [r3]
a0390098 7310bfe6 sxth     r1, r3
a039009c f032dde1 ldrsh    r3, [sp, #0x20]
a03900a0 013063e0 rsb      r3, r3, r1
a03900a4 033082e0 add      r3, r2, r3
a03900a8 b621dde1 ldrh     r2, [sp, #0x16]
a03900ac 920303e0 mul      r3, r2, r3
a03900b0 b421dde1 ldrh     r2, [sp, #0x14]
a03900b4 920302e0 mul      r2, r2, r3
a03900b8 b631dde1 ldrh     r3, [sp, #0x16]
a03900bc 18109de5 ldr      r1, [sp, #0x18]
a03900c0 910303e0 mul      r3, r1, r3
a03900c4 032082e0 add      r2, r2, r3
a03900c8 1c309de5 ldr      r3, [sp, #0x1c]
a03900cc 032082e0 add      r2, r2, r3
a03900d0 c83c01e3 movw     r3, #0x1cc8
a03900d4 70304ae3 movt     r3, #0xa070
a03900d8 8220a0e1 lsl      r2, r2, #1
a03900dc 023083e0 add      r3, r3, r2
a03900e0 b030d3e1 ldrh     r3, [r3]
a03900e4 7320bfe6 sxth     r2, r3
a03900e8 f032dde1 ldrsh    r3, [sp, #0x20]
a03900ec 011083e2 add      r1, r3, #1
a03900f0 c63c01e3 movw     r3, #0x1cc6
a03900f4 70304ae3 movt     r3, #0xa070
a03900f8 b030d3e1 ldrh     r3, [r3]
a03900fc 7330bfe6 sxth     r3, r3
a0390100 930101e0 mul      r1, r3, r1
a0390104 6e3b0ae3 movw     r3, #0xab6e
a0390108 70314ae3 movt     r3, #0xa170
a039010c b030d3e1 ldrh     r3, [r3]
a0390110 7330bfe6 sxth     r3, r3
a0390114 013063e0 rsb      r3, r3, r1
a0390118 930202e0 mul      r2, r3, r2
a039011c c23c01e3 movw     r3, #0x1cc2
a0390120 70304ae3 movt     r3, #0xa070
a0390124 b030d3e1 ldrh     r3, [r3]
a0390128 7310bfe6 sxth     r1, r3
a039012c f232dde1 ldrsh    r3, [sp, #0x22]
a0390130 033081e0 add      r3, r1, r3
a0390134 011083e2 add      r1, r3, #1
a0390138 c43c01e3 movw     r3, #0x1cc4
a039013c 70304ae3 movt     r3, #0xa070
a0390140 b030d3e1 ldrh     r3, [r3]
a0390144 7330bfe6 sxth     r3, r3
a0390148 8330a0e1 lsl      r3, r3, #1
a039014c 013083e2 add      r3, r3, #1
a0390150 930101e0 mul      r1, r3, r1
a0390154 c43c01e3 movw     r3, #0x1cc4
a0390158 70304ae3 movt     r3, #0xa070
a039015c b030d3e1 ldrh     r3, [r3]
a0390160 7300bfe6 sxth     r0, r3
a0390164 f032dde1 ldrsh    r3, [sp, #0x20]
a0390168 003063e0 rsb      r3, r3, r0
a039016c 013043e2 sub      r3, r3, #1
a0390170 033081e0 add      r3, r1, r3
a0390174 b611dde1 ldrh     r1, [sp, #0x16]
a0390178 910303e0 mul      r3, r1, r3
a039017c b411dde1 ldrh     r1, [sp, #0x14]
a0390180 910301e0 mul      r1, r1, r3
a0390184 b631dde1 ldrh     r3, [sp, #0x16]
a0390188 18009de5 ldr      r0, [sp, #0x18]
a039018c 900303e0 mul      r3, r0, r3
a0390190 031081e0 add      r1, r1, r3
a0390194 1c309de5 ldr      r3, [sp, #0x1c]
a0390198 031081e0 add      r1, r1, r3
a039019c c83c01e3 movw     r3, #0x1cc8
a03901a0 70304ae3 movt     r3, #0xa070
a03901a4 8110a0e1 lsl      r1, r1, #1
a03901a8 013083e0 add      r3, r3, r1
a03901ac b030d3e1 ldrh     r3, [r3]
a03901b0 7310bfe6 sxth     r1, r3
a03901b4 6e3b0ae3 movw     r3, #0xab6e
a03901b8 70314ae3 movt     r3, #0xa170
a03901bc b030d3e1 ldrh     r3, [r3]
a03901c0 7300bfe6 sxth     r0, r3
a03901c4 f0c2dde1 ldrsh    ip, [sp, #0x20]
a03901c8 c63c01e3 movw     r3, #0x1cc6
a03901cc 70304ae3 movt     r3, #0xa070
a03901d0 b030d3e1 ldrh     r3, [r3]
a03901d4 7330bfe6 sxth     r3, r3
a03901d8 930c03e0 mul      r3, r3, ip
a03901dc 003063e0 rsb      r3, r3, r0
a03901e0 930103e0 mul      r3, r3, r1
a03901e4 032082e0 add      r2, r2, r3
a03901e8 c63c01e3 movw     r3, #0x1cc6
a03901ec 70304ae3 movt     r3, #0xa070
a03901f0 b030d3e1 ldrh     r3, [r3]
a03901f4 7330bfe6 sxth     r3, r3
a03901f8 0200a0e1 mov      r0, r2
a03901fc 0310a0e1 mov      r1, r3
a0390200 22d905fa blx      #0xa0506690
a0390204 0030a0e1 mov      r3, r0
a0390208 7320ffe6 uxth     r2, r3
a039020c a43402e3 movw     r3, #0x24a4
a0390210 70314ae3 movt     r3, #0xa170
a0390214 8410a0e1 lsl      r1, r4, #1
a0390218 013083e0 add      r3, r3, r1
a039021c b020c3e1 strh     r2, [r3]
a0390220 b631dde1 ldrh     r3, [sp, #0x16]
a0390224 18209de5 ldr      r2, [sp, #0x18]
a0390228 920302e0 mul      r2, r2, r3
a039022c 1c309de5 ldr      r3, [sp, #0x1c]
a0390230 034082e0 add      r4, r2, r3
a0390234 c23c01e3 movw     r3, #0x1cc2
a0390238 70304ae3 movt     r3, #0xa070
a039023c b030d3e1 ldrh     r3, [r3]
a0390240 7320bfe6 sxth     r2, r3
a0390244 f232dde1 ldrsh    r3, [sp, #0x22]
a0390248 032082e0 add      r2, r2, r3
a039024c c43c01e3 movw     r3, #0x1cc4
a0390250 70304ae3 movt     r3, #0xa070
a0390254 b030d3e1 ldrh     r3, [r3]
a0390258 7330bfe6 sxth     r3, r3
a039025c 8330a0e1 lsl      r3, r3, #1
a0390260 013083e2 add      r3, r3, #1
a0390264 930202e0 mul      r2, r3, r2
a0390268 c43c01e3 movw     r3, #0x1cc4
a039026c 70304ae3 movt     r3, #0xa070
a0390270 b030d3e1 ldrh     r3, [r3]
a0390274 7310bfe6 sxth     r1, r3
a0390278 f032dde1 ldrsh    r3, [sp, #0x20]
a039027c 013063e0 rsb      r3, r3, r1
a0390280 033082e0 add      r3, r2, r3
a0390284 b621dde1 ldrh     r2, [sp, #0x16]
a0390288 920303e0 mul      r3, r2, r3
a039028c b421dde1 ldrh     r2, [sp, #0x14]
a0390290 920302e0 mul      r2, r2, r3
a0390294 b631dde1 ldrh     r3, [sp, #0x16]
a0390298 18109de5 ldr      r1, [sp, #0x18]
a039029c 910303e0 mul      r3, r1, r3
a03902a0 032082e0 add      r2, r2, r3
a03902a4 1c309de5 ldr      r3, [sp, #0x1c]
a03902a8 032082e0 add      r2, r2, r3
a03902ac 8c3b0ce3 movw     r3, #0xcb8c
a03902b0 72304ae3 movt     r3, #0xa072
a03902b4 8220a0e1 lsl      r2, r2, #1
a03902b8 023083e0 add      r3, r3, r2
a03902bc b030d3e1 ldrh     r3, [r3]
a03902c0 7320bfe6 sxth     r2, r3
a03902c4 f032dde1 ldrsh    r3, [sp, #0x20]
a03902c8 011083e2 add      r1, r3, #1
a03902cc c63c01e3 movw     r3, #0x1cc6
a03902d0 70304ae3 movt     r3, #0xa070
a03902d4 b030d3e1 ldrh     r3, [r3]
a03902d8 7330bfe6 sxth     r3, r3
a03902dc 930101e0 mul      r1, r3, r1
a03902e0 6e3b0ae3 movw     r3, #0xab6e
a03902e4 70314ae3 movt     r3, #0xa170
a03902e8 b030d3e1 ldrh     r3, [r3]
a03902ec 7330bfe6 sxth     r3, r3
a03902f0 013063e0 rsb      r3, r3, r1
a03902f4 930202e0 mul      r2, r3, r2
a03902f8 c23c01e3 movw     r3, #0x1cc2
a03902fc 70304ae3 movt     r3, #0xa070
a0390300 b030d3e1 ldrh     r3, [r3]
a0390304 7310bfe6 sxth     r1, r3
a0390308 f232dde1 ldrsh    r3, [sp, #0x22]
a039030c 031081e0 add      r1, r1, r3
a0390310 c43c01e3 movw     r3, #0x1cc4
a0390314 70304ae3 movt     r3, #0xa070
a0390318 b030d3e1 ldrh     r3, [r3]
a039031c 7330bfe6 sxth     r3, r3
a0390320 8330a0e1 lsl      r3, r3, #1
a0390324 013083e2 add      r3, r3, #1
a0390328 930101e0 mul      r1, r3, r1
a039032c c43c01e3 movw     r3, #0x1cc4
a0390330 70304ae3 movt     r3, #0xa070
a0390334 b030d3e1 ldrh     r3, [r3]
a0390338 7300bfe6 sxth     r0, r3
a039033c f032dde1 ldrsh    r3, [sp, #0x20]
a0390340 003063e0 rsb      r3, r3, r0
a0390344 013043e2 sub      r3, r3, #1
a0390348 033081e0 add      r3, r1, r3
a039034c b611dde1 ldrh     r1, [sp, #0x16]
a0390350 910303e0 mul      r3, r1, r3
a0390354 b411dde1 ldrh     r1, [sp, #0x14]
a0390358 910301e0 mul      r1, r1, r3
a039035c b631dde1 ldrh     r3, [sp, #0x16]
a0390360 18009de5 ldr      r0, [sp, #0x18]
a0390364 900303e0 mul      r3, r0, r3
a0390368 031081e0 add      r1, r1, r3
a039036c 1c309de5 ldr      r3, [sp, #0x1c]
a0390370 031081e0 add      r1, r1, r3
a0390374 8c3b0ce3 movw     r3, #0xcb8c
a0390378 72304ae3 movt     r3, #0xa072
a039037c 8110a0e1 lsl      r1, r1, #1
a0390380 013083e0 add      r3, r3, r1
a0390384 b030d3e1 ldrh     r3, [r3]
a0390388 7310bfe6 sxth     r1, r3
a039038c 6e3b0ae3 movw     r3, #0xab6e
a0390390 70314ae3 movt     r3, #0xa170
a0390394 b030d3e1 ldrh     r3, [r3]
a0390398 7300bfe6 sxth     r0, r3
a039039c f0c2dde1 ldrsh    ip, [sp, #0x20]
a03903a0 c63c01e3 movw     r3, #0x1cc6
a03903a4 70304ae3 movt     r3, #0xa070
a03903a8 b030d3e1 ldrh     r3, [r3]
a03903ac 7330bfe6 sxth     r3, r3
a03903b0 930c03e0 mul      r3, r3, ip
a03903b4 003063e0 rsb      r3, r3, r0
a03903b8 930103e0 mul      r3, r3, r1
a03903bc 032082e0 add      r2, r2, r3
a03903c0 c63c01e3 movw     r3, #0x1cc6
a03903c4 70304ae3 movt     r3, #0xa070
a03903c8 b030d3e1 ldrh     r3, [r3]
a03903cc 7330bfe6 sxth     r3, r3
a03903d0 0200a0e1 mov      r0, r2
a03903d4 0310a0e1 mov      r1, r3
a03903d8 acd805fa blx      #0xa0506690
a03903dc 0030a0e1 mov      r3, r0
a03903e0 7320ffe6 uxth     r2, r3
a03903e4 283702e3 movw     r3, #0x2728
a03903e8 70314ae3 movt     r3, #0xa170
a03903ec 8410a0e1 lsl      r1, r4, #1
a03903f0 013083e0 add      r3, r3, r1
a03903f4 b020c3e1 strh     r2, [r3]
a03903f8 b631dde1 ldrh     r3, [sp, #0x16]
a03903fc 18209de5 ldr      r2, [sp, #0x18]
a0390400 920302e0 mul      r2, r2, r3
a0390404 1c309de5 ldr      r3, [sp, #0x1c]
a0390408 034082e0 add      r4, r2, r3
a039040c c23c01e3 movw     r3, #0x1cc2
a0390410 70304ae3 movt     r3, #0xa070
a0390414 b030d3e1 ldrh     r3, [r3]
a0390418 7320bfe6 sxth     r2, r3
a039041c f232dde1 ldrsh    r3, [sp, #0x22]
a0390420 033082e0 add      r3, r2, r3
a0390424 012083e2 add      r2, r3, #1
a0390428 c43c01e3 movw     r3, #0x1cc4
a039042c 70304ae3 movt     r3, #0xa070
a0390430 b030d3e1 ldrh     r3, [r3]
a0390434 7330bfe6 sxth     r3, r3
a0390438 8330a0e1 lsl      r3, r3, #1
a039043c 013083e2 add      r3, r3, #1
a0390440 930202e0 mul      r2, r3, r2
a0390444 c43c01e3 movw     r3, #0x1cc4
a0390448 70304ae3 movt     r3, #0xa070
a039044c b030d3e1 ldrh     r3, [r3]
a0390450 7310bfe6 sxth     r1, r3
a0390454 f032dde1 ldrsh    r3, [sp, #0x20]
a0390458 013063e0 rsb      r3, r3, r1
a039045c 033082e0 add      r3, r2, r3
a0390460 b621dde1 ldrh     r2, [sp, #0x16]
a0390464 920303e0 mul      r3, r2, r3
a0390468 b421dde1 ldrh     r2, [sp, #0x14]
a039046c 920302e0 mul      r2, r2, r3
a0390470 b631dde1 ldrh     r3, [sp, #0x16]
a0390474 18109de5 ldr      r1, [sp, #0x18]
a0390478 910303e0 mul      r3, r1, r3
a039047c 032082e0 add      r2, r2, r3
a0390480 1c309de5 ldr      r3, [sp, #0x1c]
a0390484 032082e0 add      r2, r2, r3
a0390488 8c3b0ce3 movw     r3, #0xcb8c
a039048c 72304ae3 movt     r3, #0xa072
a0390490 8220a0e1 lsl      r2, r2, #1
a0390494 023083e0 add      r3, r3, r2
a0390498 b030d3e1 ldrh     r3, [r3]
a039049c 7320bfe6 sxth     r2, r3
a03904a0 f032dde1 ldrsh    r3, [sp, #0x20]
a03904a4 011083e2 add      r1, r3, #1
a03904a8 c63c01e3 movw     r3, #0x1cc6
a03904ac 70304ae3 movt     r3, #0xa070
a03904b0 b030d3e1 ldrh     r3, [r3]
a03904b4 7330bfe6 sxth     r3, r3
a03904b8 930101e0 mul      r1, r3, r1
a03904bc 6e3b0ae3 movw     r3, #0xab6e
a03904c0 70314ae3 movt     r3, #0xa170
a03904c4 b030d3e1 ldrh     r3, [r3]
a03904c8 7330bfe6 sxth     r3, r3
a03904cc 013063e0 rsb      r3, r3, r1
a03904d0 930202e0 mul      r2, r3, r2
a03904d4 c23c01e3 movw     r3, #0x1cc2
a03904d8 70304ae3 movt     r3, #0xa070
a03904dc b030d3e1 ldrh     r3, [r3]
a03904e0 7310bfe6 sxth     r1, r3
a03904e4 f232dde1 ldrsh    r3, [sp, #0x22]
a03904e8 033081e0 add      r3, r1, r3
a03904ec 011083e2 add      r1, r3, #1
a03904f0 c43c01e3 movw     r3, #0x1cc4
a03904f4 70304ae3 movt     r3, #0xa070
a03904f8 b030d3e1 ldrh     r3, [r3]
a03904fc 7330bfe6 sxth     r3, r3
a0390500 8330a0e1 lsl      r3, r3, #1
a0390504 013083e2 add      r3, r3, #1
a0390508 930101e0 mul      r1, r3, r1
a039050c c43c01e3 movw     r3, #0x1cc4
a0390510 70304ae3 movt     r3, #0xa070
a0390514 b030d3e1 ldrh     r3, [r3]
a0390518 7300bfe6 sxth     r0, r3
a039051c f032dde1 ldrsh    r3, [sp, #0x20]
a0390520 003063e0 rsb      r3, r3, r0
a0390524 013043e2 sub      r3, r3, #1
a0390528 033081e0 add      r3, r1, r3
a039052c b611dde1 ldrh     r1, [sp, #0x16]
a0390530 910303e0 mul      r3, r1, r3
a0390534 b411dde1 ldrh     r1, [sp, #0x14]
a0390538 910301e0 mul      r1, r1, r3
a039053c b631dde1 ldrh     r3, [sp, #0x16]
a0390540 18009de5 ldr      r0, [sp, #0x18]
a0390544 900303e0 mul      r3, r0, r3
a0390548 031081e0 add      r1, r1, r3
a039054c 1c309de5 ldr      r3, [sp, #0x1c]
a0390550 031081e0 add      r1, r1, r3
a0390554 8c3b0ce3 movw     r3, #0xcb8c
a0390558 72304ae3 movt     r3, #0xa072
a039055c 8110a0e1 lsl      r1, r1, #1
a0390560 013083e0 add      r3, r3, r1
a0390564 b030d3e1 ldrh     r3, [r3]
a0390568 7310bfe6 sxth     r1, r3
a039056c 6e3b0ae3 movw     r3, #0xab6e
a0390570 70314ae3 movt     r3, #0xa170
a0390574 b030d3e1 ldrh     r3, [r3]
a0390578 7300bfe6 sxth     r0, r3
a039057c f0c2dde1 ldrsh    ip, [sp, #0x20]
a0390580 c63c01e3 movw     r3, #0x1cc6
a0390584 70304ae3 movt     r3, #0xa070
a0390588 b030d3e1 ldrh     r3, [r3]
a039058c 7330bfe6 sxth     r3, r3
a0390590 930c03e0 mul      r3, r3, ip
a0390594 003063e0 rsb      r3, r3, r0
a0390598 930103e0 mul      r3, r3, r1
a039059c 032082e0 add      r2, r2, r3
a03905a0 c63c01e3 movw     r3, #0x1cc6
a03905a4 70304ae3 movt     r3, #0xa070
a03905a8 b030d3e1 ldrh     r3, [r3]
a03905ac 7330bfe6 sxth     r3, r3
a03905b0 0200a0e1 mov      r0, r2
a03905b4 0310a0e1 mov      r1, r3
a03905b8 34d805fa blx      #0xa0506690
a03905bc 0030a0e1 mov      r3, r0
a03905c0 7320ffe6 uxth     r2, r3
a03905c4 ac3902e3 movw     r3, #0x29ac
a03905c8 70314ae3 movt     r3, #0xa170
a03905cc 8410a0e1 lsl      r1, r4, #1
a03905d0 013083e0 add      r3, r3, r1
a03905d4 b020c3e1 strh     r2, [r3]
a03905d8 1c309de5 ldr      r3, [sp, #0x1c]
a03905dc 013083e2 add      r3, r3, #1
a03905e0 1c308de5 str      r3, [sp, #0x1c]
a03905e4 b621dde1 ldrh     r2, [sp, #0x16]
a03905e8 1c309de5 ldr      r3, [sp, #0x1c]
a03905ec 030052e1 cmp      r2, r3
a03905f0 1cfeffca bgt      #0xa038fe68
a03905f4 18309de5 ldr      r3, [sp, #0x18]
a03905f8 013083e2 add      r3, r3, #1
a03905fc 18308de5 str      r3, [sp, #0x18]
a0390600 b421dde1 ldrh     r2, [sp, #0x14]
a0390604 18309de5 ldr      r3, [sp, #0x18]
a0390608 030052e1 cmp      r2, r3
a039060c 12feffca bgt      #0xa038fe5c
a0390610 0030a0e3 mov      r3, #0
a0390614 18308de5 str      r3, [sp, #0x18]
a0390618 900000ea b        #0xa0390860
a039061c 0030a0e3 mov      r3, #0
a0390620 1c308de5 str      r3, [sp, #0x1c]
a0390624 860000ea b        #0xa0390844
a0390628 b631dde1 ldrh     r3, [sp, #0x16]
a039062c 18209de5 ldr      r2, [sp, #0x18]
a0390630 920302e0 mul      r2, r2, r3
a0390634 1c309de5 ldr      r3, [sp, #0x1c]
a0390638 033082e0 add      r3, r2, r3
a039063c 0331a0e1 lsl      r3, r3, #2
a0390640 04209de5 ldr      r2, [sp, #4]
a0390644 034082e0 add      r4, r2, r3
a0390648 b631dde1 ldrh     r3, [sp, #0x16]
a039064c 18209de5 ldr      r2, [sp, #0x18]
a0390650 920302e0 mul      r2, r2, r3
a0390654 1c309de5 ldr      r3, [sp, #0x1c]
a0390658 032082e0 add      r2, r2, r3
a039065c 203202e3 movw     r3, #0x2220
a0390660 70314ae3 movt     r3, #0xa170
a0390664 8220a0e1 lsl      r2, r2, #1
a0390668 023083e0 add      r3, r3, r2
a039066c b030d3e1 ldrh     r3, [r3]
a0390670 7320bfe6 sxth     r2, r3
a0390674 f232dde1 ldrsh    r3, [sp, #0x22]
a0390678 011083e2 add      r1, r3, #1
a039067c c63c01e3 movw     r3, #0x1cc6
a0390680 70304ae3 movt     r3, #0xa070
a0390684 b030d3e1 ldrh     r3, [r3]
a0390688 7330bfe6 sxth     r3, r3
a039068c 930101e0 mul      r1, r3, r1
a0390690 6c3b0ae3 movw     r3, #0xab6c
a0390694 70314ae3 movt     r3, #0xa170
a0390698 b030d3e1 ldrh     r3, [r3]
a039069c 7330bfe6 sxth     r3, r3
a03906a0 013063e0 rsb      r3, r3, r1
a03906a4 930202e0 mul      r2, r3, r2
a03906a8 b631dde1 ldrh     r3, [sp, #0x16]
a03906ac 18109de5 ldr      r1, [sp, #0x18]
a03906b0 910301e0 mul      r1, r1, r3
a03906b4 1c309de5 ldr      r3, [sp, #0x1c]
a03906b8 031081e0 add      r1, r1, r3
a03906bc a43402e3 movw     r3, #0x24a4
a03906c0 70314ae3 movt     r3, #0xa170
a03906c4 8110a0e1 lsl      r1, r1, #1
a03906c8 013083e0 add      r3, r3, r1
a03906cc b030d3e1 ldrh     r3, [r3]
a03906d0 7310bfe6 sxth     r1, r3
a03906d4 6c3b0ae3 movw     r3, #0xab6c
a03906d8 70314ae3 movt     r3, #0xa170
a03906dc b030d3e1 ldrh     r3, [r3]
a03906e0 7300bfe6 sxth     r0, r3
a03906e4 f2c2dde1 ldrsh    ip, [sp, #0x22]
a03906e8 c63c01e3 movw     r3, #0x1cc6
a03906ec 70304ae3 movt     r3, #0xa070
a03906f0 b030d3e1 ldrh     r3, [r3]
a03906f4 7330bfe6 sxth     r3, r3
a03906f8 930c03e0 mul      r3, r3, ip
a03906fc 003063e0 rsb      r3, r3, r0
a0390700 930103e0 mul      r3, r3, r1
a0390704 032082e0 add      r2, r2, r3
a0390708 c63c01e3 movw     r3, #0x1cc6
a039070c 70304ae3 movt     r3, #0xa070
a0390710 b030d3e1 ldrh     r3, [r3]
a0390714 7330bfe6 sxth     r3, r3
a0390718 0200a0e1 mov      r0, r2
a039071c 0310a0e1 mov      r1, r3
a0390720 dad705fa blx      #0xa0506690
a0390724 0030a0e1 mov      r3, r0
a0390728 7330ffe6 uxth     r3, r3
a039072c b030c4e1 strh     r3, [r4]
a0390730 b631dde1 ldrh     r3, [sp, #0x16]
a0390734 18209de5 ldr      r2, [sp, #0x18]
a0390738 920302e0 mul      r2, r2, r3
a039073c 1c309de5 ldr      r3, [sp, #0x1c]
a0390740 033082e0 add      r3, r2, r3
a0390744 0331a0e1 lsl      r3, r3, #2
a0390748 04209de5 ldr      r2, [sp, #4]
a039074c 034082e0 add      r4, r2, r3
a0390750 b631dde1 ldrh     r3, [sp, #0x16]
a0390754 18209de5 ldr      r2, [sp, #0x18]
a0390758 920302e0 mul      r2, r2, r3
a039075c 1c309de5 ldr      r3, [sp, #0x1c]
a0390760 032082e0 add      r2, r2, r3
a0390764 283702e3 movw     r3, #0x2728
a0390768 70314ae3 movt     r3, #0xa170
a039076c 8220a0e1 lsl      r2, r2, #1
a0390770 023083e0 add      r3, r3, r2
a0390774 b030d3e1 ldrh     r3, [r3]
a0390778 7320bfe6 sxth     r2, r3
a039077c f232dde1 ldrsh    r3, [sp, #0x22]
a0390780 011083e2 add      r1, r3, #1
a0390784 c63c01e3 movw     r3, #0x1cc6
a0390788 70304ae3 movt     r3, #0xa070
a039078c b030d3e1 ldrh     r3, [r3]
a0390790 7330bfe6 sxth     r3, r3
a0390794 930101e0 mul      r1, r3, r1
a0390798 6c3b0ae3 movw     r3, #0xab6c
a039079c 70314ae3 movt     r3, #0xa170
a03907a0 b030d3e1 ldrh     r3, [r3]
a03907a4 7330bfe6 sxth     r3, r3
a03907a8 013063e0 rsb      r3, r3, r1
a03907ac 930202e0 mul      r2, r3, r2
a03907b0 b631dde1 ldrh     r3, [sp, #0x16]
a03907b4 18109de5 ldr      r1, [sp, #0x18]
a03907b8 910301e0 mul      r1, r1, r3
a03907bc 1c309de5 ldr      r3, [sp, #0x1c]
a03907c0 031081e0 add      r1, r1, r3
a03907c4 ac3902e3 movw     r3, #0x29ac
a03907c8 70314ae3 movt     r3, #0xa170
a03907cc 8110a0e1 lsl      r1, r1, #1
a03907d0 013083e0 add      r3, r3, r1
a03907d4 b030d3e1 ldrh     r3, [r3]
a03907d8 7310bfe6 sxth     r1, r3
a03907dc 6c3b0ae3 movw     r3, #0xab6c
a03907e0 70314ae3 movt     r3, #0xa170
a03907e4 b030d3e1 ldrh     r3, [r3]
a03907e8 7300bfe6 sxth     r0, r3
a03907ec f2c2dde1 ldrsh    ip, [sp, #0x22]
a03907f0 c63c01e3 movw     r3, #0x1cc6
a03907f4 70304ae3 movt     r3, #0xa070
a03907f8 b030d3e1 ldrh     r3, [r3]
a03907fc 7330bfe6 sxth     r3, r3
a0390800 930c03e0 mul      r3, r3, ip
a0390804 003063e0 rsb      r3, r3, r0
a0390808 930103e0 mul      r3, r3, r1
a039080c 032082e0 add      r2, r2, r3
a0390810 c63c01e3 movw     r3, #0x1cc6
a0390814 70304ae3 movt     r3, #0xa070
a0390818 b030d3e1 ldrh     r3, [r3]
a039081c 7330bfe6 sxth     r3, r3
a0390820 0200a0e1 mov      r0, r2
a0390824 0310a0e1 mov      r1, r3
a0390828 98d705fa blx      #0xa0506690
a039082c 0030a0e1 mov      r3, r0
a0390830 7330ffe6 uxth     r3, r3
a0390834 b230c4e1 strh     r3, [r4, #2]
a0390838 1c309de5 ldr      r3, [sp, #0x1c]
a039083c 013083e2 add      r3, r3, #1
a0390840 1c308de5 str      r3, [sp, #0x1c]
a0390844 b621dde1 ldrh     r2, [sp, #0x16]
a0390848 1c309de5 ldr      r3, [sp, #0x1c]
a039084c 030052e1 cmp      r2, r3
a0390850 74ffffca bgt      #0xa0390628
a0390854 18309de5 ldr      r3, [sp, #0x18]
a0390858 013083e2 add      r3, r3, #1
a039085c 18308de5 str      r3, [sp, #0x18]
a0390860 b421dde1 ldrh     r2, [sp, #0x14]
a0390864 18309de5 ldr      r3, [sp, #0x18]
a0390868 030052e1 cmp      r2, r3
a039086c 6affffca bgt      #0xa039061c
a0390870 1c0500ea b        #0xa0391ce8
a0390874 703b0ae3 movw     r3, #0xab70
a0390878 70314ae3 movt     r3, #0xa170
a039087c b030d3e1 ldrh     r3, [r3]
a0390880 7330bfe6 sxth     r3, r3
a0390884 000053e3 cmp      r3, #0
a0390888 8e0200aa bge      #0xa03912c8
a039088c 723b0ae3 movw     r3, #0xab72
a0390890 70314ae3 movt     r3, #0xa170
a0390894 b030d3e1 ldrh     r3, [r3]
a0390898 7330bfe6 sxth     r3, r3
a039089c 000053e3 cmp      r3, #0
a03908a0 880200da ble      #0xa03912c8
a03908a4 0030a0e3 mov      r3, #0
a03908a8 18308de5 str      r3, [sp, #0x18]
a03908ac e80100ea b        #0xa0391054
a03908b0 0030a0e3 mov      r3, #0
a03908b4 1c308de5 str      r3, [sp, #0x1c]
a03908b8 de0100ea b        #0xa0391038
a03908bc b631dde1 ldrh     r3, [sp, #0x16]
a03908c0 18209de5 ldr      r2, [sp, #0x18]
a03908c4 920302e0 mul      r2, r2, r3
a03908c8 1c309de5 ldr      r3, [sp, #0x1c]
a03908cc 034082e0 add      r4, r2, r3
a03908d0 c23c01e3 movw     r3, #0x1cc2
a03908d4 70304ae3 movt     r3, #0xa070
a03908d8 b030d3e1 ldrh     r3, [r3]
a03908dc 7320bfe6 sxth     r2, r3
a03908e0 f232dde1 ldrsh    r3, [sp, #0x22]
a03908e4 022063e0 rsb      r2, r3, r2
a03908e8 c43c01e3 movw     r3, #0x1cc4
a03908ec 70304ae3 movt     r3, #0xa070
a03908f0 b030d3e1 ldrh     r3, [r3]
a03908f4 7330bfe6 sxth     r3, r3
a03908f8 8330a0e1 lsl      r3, r3, #1
a03908fc 013083e2 add      r3, r3, #1
a0390900 930202e0 mul      r2, r3, r2
a0390904 c43c01e3 movw     r3, #0x1cc4
a0390908 70304ae3 movt     r3, #0xa070
a039090c b030d3e1 ldrh     r3, [r3]
a0390910 7310bfe6 sxth     r1, r3
a0390914 f032dde1 ldrsh    r3, [sp, #0x20]
a0390918 033081e0 add      r3, r1, r3
a039091c 033082e0 add      r3, r2, r3
a0390920 b621dde1 ldrh     r2, [sp, #0x16]
a0390924 920303e0 mul      r3, r2, r3
a0390928 b421dde1 ldrh     r2, [sp, #0x14]
a039092c 920302e0 mul      r2, r2, r3
a0390930 b631dde1 ldrh     r3, [sp, #0x16]
a0390934 18109de5 ldr      r1, [sp, #0x18]
a0390938 910303e0 mul      r3, r1, r3
a039093c 032082e0 add      r2, r2, r3
a0390940 1c309de5 ldr      r3, [sp, #0x1c]
a0390944 032082e0 add      r2, r2, r3
a0390948 c83c01e3 movw     r3, #0x1cc8
a039094c 70304ae3 movt     r3, #0xa070
a0390950 8220a0e1 lsl      r2, r2, #1
a0390954 023083e0 add      r3, r3, r2
a0390958 b030d3e1 ldrh     r3, [r3]
a039095c 7320bfe6 sxth     r2, r3
a0390960 f032dde1 ldrsh    r3, [sp, #0x20]
a0390964 011083e2 add      r1, r3, #1
a0390968 c63c01e3 movw     r3, #0x1cc6
a039096c 70304ae3 movt     r3, #0xa070
a0390970 b030d3e1 ldrh     r3, [r3]
a0390974 7330bfe6 sxth     r3, r3
a0390978 930101e0 mul      r1, r3, r1
a039097c 6e3b0ae3 movw     r3, #0xab6e
a0390980 70314ae3 movt     r3, #0xa170
a0390984 b030d3e1 ldrh     r3, [r3]
a0390988 7330bfe6 sxth     r3, r3
a039098c 013063e0 rsb      r3, r3, r1
a0390990 930202e0 mul      r2, r3, r2
a0390994 c23c01e3 movw     r3, #0x1cc2
a0390998 70304ae3 movt     r3, #0xa070
a039099c b030d3e1 ldrh     r3, [r3]
a03909a0 7310bfe6 sxth     r1, r3
a03909a4 f232dde1 ldrsh    r3, [sp, #0x22]
a03909a8 011063e0 rsb      r1, r3, r1
a03909ac c43c01e3 movw     r3, #0x1cc4
a03909b0 70304ae3 movt     r3, #0xa070
a03909b4 b030d3e1 ldrh     r3, [r3]
a03909b8 7330bfe6 sxth     r3, r3
a03909bc 8330a0e1 lsl      r3, r3, #1
a03909c0 013083e2 add      r3, r3, #1
a03909c4 930101e0 mul      r1, r3, r1
a03909c8 c43c01e3 movw     r3, #0x1cc4
a03909cc 70304ae3 movt     r3, #0xa070
a03909d0 b030d3e1 ldrh     r3, [r3]
a03909d4 7300bfe6 sxth     r0, r3
a03909d8 f032dde1 ldrsh    r3, [sp, #0x20]
a03909dc 033080e0 add      r3, r0, r3
a03909e0 013083e2 add      r3, r3, #1
a03909e4 033081e0 add      r3, r1, r3
a03909e8 b611dde1 ldrh     r1, [sp, #0x16]
a03909ec 910303e0 mul      r3, r1, r3
a03909f0 b411dde1 ldrh     r1, [sp, #0x14]
a03909f4 910301e0 mul      r1, r1, r3
a03909f8 b631dde1 ldrh     r3, [sp, #0x16]
a03909fc 18009de5 ldr      r0, [sp, #0x18]
a0390a00 900303e0 mul      r3, r0, r3
a0390a04 031081e0 add      r1, r1, r3
a0390a08 1c309de5 ldr      r3, [sp, #0x1c]
a0390a0c 031081e0 add      r1, r1, r3
a0390a10 c83c01e3 movw     r3, #0x1cc8
a0390a14 70304ae3 movt     r3, #0xa070
a0390a18 8110a0e1 lsl      r1, r1, #1
a0390a1c 013083e0 add      r3, r3, r1
a0390a20 b030d3e1 ldrh     r3, [r3]
a0390a24 7310bfe6 sxth     r1, r3
a0390a28 6e3b0ae3 movw     r3, #0xab6e
a0390a2c 70314ae3 movt     r3, #0xa170
a0390a30 b030d3e1 ldrh     r3, [r3]
a0390a34 7300bfe6 sxth     r0, r3
a0390a38 f0c2dde1 ldrsh    ip, [sp, #0x20]
a0390a3c c63c01e3 movw     r3, #0x1cc6
a0390a40 70304ae3 movt     r3, #0xa070
a0390a44 b030d3e1 ldrh     r3, [r3]
a0390a48 7330bfe6 sxth     r3, r3
a0390a4c 930c03e0 mul      r3, r3, ip
a0390a50 003063e0 rsb      r3, r3, r0
a0390a54 930103e0 mul      r3, r3, r1
a0390a58 032082e0 add      r2, r2, r3
a0390a5c c63c01e3 movw     r3, #0x1cc6
a0390a60 70304ae3 movt     r3, #0xa070
a0390a64 b030d3e1 ldrh     r3, [r3]
a0390a68 7330bfe6 sxth     r3, r3
a0390a6c 0200a0e1 mov      r0, r2
a0390a70 0310a0e1 mov      r1, r3
a0390a74 05d705fa blx      #0xa0506690
a0390a78 0030a0e1 mov      r3, r0
a0390a7c 7320ffe6 uxth     r2, r3
a0390a80 203202e3 movw     r3, #0x2220
a0390a84 70314ae3 movt     r3, #0xa170
a0390a88 8410a0e1 lsl      r1, r4, #1
a0390a8c 013083e0 add      r3, r3, r1
a0390a90 b020c3e1 strh     r2, [r3]
a0390a94 b631dde1 ldrh     r3, [sp, #0x16]
a0390a98 18209de5 ldr      r2, [sp, #0x18]
a0390a9c 920302e0 mul      r2, r2, r3
a0390aa0 1c309de5 ldr      r3, [sp, #0x1c]
a0390aa4 034082e0 add      r4, r2, r3
a0390aa8 c23c01e3 movw     r3, #0x1cc2
a0390aac 70304ae3 movt     r3, #0xa070
a0390ab0 b030d3e1 ldrh     r3, [r3]
a0390ab4 7320bfe6 sxth     r2, r3
a0390ab8 f232dde1 ldrsh    r3, [sp, #0x22]
a0390abc 023063e0 rsb      r3, r3, r2
a0390ac0 012043e2 sub      r2, r3, #1
a0390ac4 c43c01e3 movw     r3, #0x1cc4
a0390ac8 70304ae3 movt     r3, #0xa070
a0390acc b030d3e1 ldrh     r3, [r3]
a0390ad0 7330bfe6 sxth     r3, r3
a0390ad4 8330a0e1 lsl      r3, r3, #1
a0390ad8 013083e2 add      r3, r3, #1
a0390adc 930202e0 mul      r2, r3, r2
a0390ae0 c43c01e3 movw     r3, #0x1cc4
a0390ae4 70304ae3 movt     r3, #0xa070
a0390ae8 b030d3e1 ldrh     r3, [r3]
a0390aec 7310bfe6 sxth     r1, r3
a0390af0 f032dde1 ldrsh    r3, [sp, #0x20]
a0390af4 033081e0 add      r3, r1, r3
a0390af8 033082e0 add      r3, r2, r3
a0390afc b621dde1 ldrh     r2, [sp, #0x16]
a0390b00 920303e0 mul      r3, r2, r3
a0390b04 b421dde1 ldrh     r2, [sp, #0x14]
a0390b08 920302e0 mul      r2, r2, r3
a0390b0c b631dde1 ldrh     r3, [sp, #0x16]
a0390b10 18109de5 ldr      r1, [sp, #0x18]
a0390b14 910303e0 mul      r3, r1, r3
a0390b18 032082e0 add      r2, r2, r3
a0390b1c 1c309de5 ldr      r3, [sp, #0x1c]
a0390b20 032082e0 add      r2, r2, r3
a0390b24 c83c01e3 movw     r3, #0x1cc8
a0390b28 70304ae3 movt     r3, #0xa070
a0390b2c 8220a0e1 lsl      r2, r2, #1
a0390b30 023083e0 add      r3, r3, r2
a0390b34 b030d3e1 ldrh     r3, [r3]
a0390b38 7320bfe6 sxth     r2, r3
a0390b3c f032dde1 ldrsh    r3, [sp, #0x20]
a0390b40 011083e2 add      r1, r3, #1
a0390b44 c63c01e3 movw     r3, #0x1cc6
a0390b48 70304ae3 movt     r3, #0xa070
a0390b4c b030d3e1 ldrh     r3, [r3]
a0390b50 7330bfe6 sxth     r3, r3
a0390b54 930101e0 mul      r1, r3, r1
a0390b58 6e3b0ae3 movw     r3, #0xab6e
a0390b5c 70314ae3 movt     r3, #0xa170
a0390b60 b030d3e1 ldrh     r3, [r3]
a0390b64 7330bfe6 sxth     r3, r3
a0390b68 013063e0 rsb      r3, r3, r1
a0390b6c 930202e0 mul      r2, r3, r2
a0390b70 c23c01e3 movw     r3, #0x1cc2
a0390b74 70304ae3 movt     r3, #0xa070
a0390b78 b030d3e1 ldrh     r3, [r3]
a0390b7c 7310bfe6 sxth     r1, r3
a0390b80 f232dde1 ldrsh    r3, [sp, #0x22]
a0390b84 013063e0 rsb      r3, r3, r1
a0390b88 011043e2 sub      r1, r3, #1
a0390b8c c43c01e3 movw     r3, #0x1cc4
a0390b90 70304ae3 movt     r3, #0xa070
a0390b94 b030d3e1 ldrh     r3, [r3]
a0390b98 7330bfe6 sxth     r3, r3
a0390b9c 8330a0e1 lsl      r3, r3, #1
a0390ba0 013083e2 add      r3, r3, #1
a0390ba4 930101e0 mul      r1, r3, r1
a0390ba8 c43c01e3 movw     r3, #0x1cc4
a0390bac 70304ae3 movt     r3, #0xa070
a0390bb0 b030d3e1 ldrh     r3, [r3]
a0390bb4 7300bfe6 sxth     r0, r3
a0390bb8 f032dde1 ldrsh    r3, [sp, #0x20]
a0390bbc 033080e0 add      r3, r0, r3
a0390bc0 013083e2 add      r3, r3, #1
a0390bc4 033081e0 add      r3, r1, r3
a0390bc8 b611dde1 ldrh     r1, [sp, #0x16]
a0390bcc 910303e0 mul      r3, r1, r3
a0390bd0 b411dde1 ldrh     r1, [sp, #0x14]
a0390bd4 910301e0 mul      r1, r1, r3
a0390bd8 b631dde1 ldrh     r3, [sp, #0x16]
a0390bdc 18009de5 ldr      r0, [sp, #0x18]
a0390be0 900303e0 mul      r3, r0, r3
a0390be4 031081e0 add      r1, r1, r3
a0390be8 1c309de5 ldr      r3, [sp, #0x1c]
a0390bec 031081e0 add      r1, r1, r3
a0390bf0 c83c01e3 movw     r3, #0x1cc8
a0390bf4 70304ae3 movt     r3, #0xa070
a0390bf8 8110a0e1 lsl      r1, r1, #1
a0390bfc 013083e0 add      r3, r3, r1
a0390c00 b030d3e1 ldrh     r3, [r3]
a0390c04 7310bfe6 sxth     r1, r3
a0390c08 6e3b0ae3 movw     r3, #0xab6e
a0390c0c 70314ae3 movt     r3, #0xa170
a0390c10 b030d3e1 ldrh     r3, [r3]
a0390c14 7300bfe6 sxth     r0, r3
a0390c18 f0c2dde1 ldrsh    ip, [sp, #0x20]
a0390c1c c63c01e3 movw     r3, #0x1cc6
a0390c20 70304ae3 movt     r3, #0xa070
a0390c24 b030d3e1 ldrh     r3, [r3]
a0390c28 7330bfe6 sxth     r3, r3
a0390c2c 930c03e0 mul      r3, r3, ip
a0390c30 003063e0 rsb      r3, r3, r0
a0390c34 930103e0 mul      r3, r3, r1
a0390c38 032082e0 add      r2, r2, r3
a0390c3c c63c01e3 movw     r3, #0x1cc6
a0390c40 70304ae3 movt     r3, #0xa070
a0390c44 b030d3e1 ldrh     r3, [r3]
a0390c48 7330bfe6 sxth     r3, r3
a0390c4c 0200a0e1 mov      r0, r2
a0390c50 0310a0e1 mov      r1, r3
a0390c54 8dd605fa blx      #0xa0506690
a0390c58 0030a0e1 mov      r3, r0
a0390c5c 7320ffe6 uxth     r2, r3
a0390c60 a43402e3 movw     r3, #0x24a4
a0390c64 70314ae3 movt     r3, #0xa170
a0390c68 8410a0e1 lsl      r1, r4, #1
a0390c6c 013083e0 add      r3, r3, r1
a0390c70 b020c3e1 strh     r2, [r3]
a0390c74 b631dde1 ldrh     r3, [sp, #0x16]
a0390c78 18209de5 ldr      r2, [sp, #0x18]
a0390c7c 920302e0 mul      r2, r2, r3
a0390c80 1c309de5 ldr      r3, [sp, #0x1c]
a0390c84 034082e0 add      r4, r2, r3
a0390c88 c23c01e3 movw     r3, #0x1cc2
a0390c8c 70304ae3 movt     r3, #0xa070
a0390c90 b030d3e1 ldrh     r3, [r3]
a0390c94 7320bfe6 sxth     r2, r3
a0390c98 f232dde1 ldrsh    r3, [sp, #0x22]
a0390c9c 022063e0 rsb      r2, r3, r2
a0390ca0 c43c01e3 movw     r3, #0x1cc4
a0390ca4 70304ae3 movt     r3, #0xa070
a0390ca8 b030d3e1 ldrh     r3, [r3]
a0390cac 7330bfe6 sxth     r3, r3
a0390cb0 8330a0e1 lsl      r3, r3, #1
a0390cb4 013083e2 add      r3, r3, #1
a0390cb8 930202e0 mul      r2, r3, r2
a0390cbc c43c01e3 movw     r3, #0x1cc4
a0390cc0 70304ae3 movt     r3, #0xa070
a0390cc4 b030d3e1 ldrh     r3, [r3]
a0390cc8 7310bfe6 sxth     r1, r3
a0390ccc f032dde1 ldrsh    r3, [sp, #0x20]
a0390cd0 033081e0 add      r3, r1, r3
a0390cd4 033082e0 add      r3, r2, r3
a0390cd8 b621dde1 ldrh     r2, [sp, #0x16]
a0390cdc 920303e0 mul      r3, r2, r3
a0390ce0 b421dde1 ldrh     r2, [sp, #0x14]
a0390ce4 920302e0 mul      r2, r2, r3
a0390ce8 b631dde1 ldrh     r3, [sp, #0x16]
a0390cec 18109de5 ldr      r1, [sp, #0x18]
a0390cf0 910303e0 mul      r3, r1, r3
a0390cf4 032082e0 add      r2, r2, r3
a0390cf8 1c309de5 ldr      r3, [sp, #0x1c]
a0390cfc 032082e0 add      r2, r2, r3
a0390d00 8c3b0ce3 movw     r3, #0xcb8c
a0390d04 72304ae3 movt     r3, #0xa072
a0390d08 8220a0e1 lsl      r2, r2, #1
a0390d0c 023083e0 add      r3, r3, r2
a0390d10 b030d3e1 ldrh     r3, [r3]
a0390d14 7320bfe6 sxth     r2, r3
a0390d18 f032dde1 ldrsh    r3, [sp, #0x20]
a0390d1c 011083e2 add      r1, r3, #1
a0390d20 c63c01e3 movw     r3, #0x1cc6
a0390d24 70304ae3 movt     r3, #0xa070
a0390d28 b030d3e1 ldrh     r3, [r3]
a0390d2c 7330bfe6 sxth     r3, r3
a0390d30 930101e0 mul      r1, r3, r1
a0390d34 6e3b0ae3 movw     r3, #0xab6e
a0390d38 70314ae3 movt     r3, #0xa170
a0390d3c b030d3e1 ldrh     r3, [r3]
a0390d40 7330bfe6 sxth     r3, r3
a0390d44 013063e0 rsb      r3, r3, r1
a0390d48 930202e0 mul      r2, r3, r2
a0390d4c c23c01e3 movw     r3, #0x1cc2
a0390d50 70304ae3 movt     r3, #0xa070
a0390d54 b030d3e1 ldrh     r3, [r3]
a0390d58 7310bfe6 sxth     r1, r3
a0390d5c f232dde1 ldrsh    r3, [sp, #0x22]
a0390d60 011063e0 rsb      r1, r3, r1
a0390d64 c43c01e3 movw     r3, #0x1cc4
a0390d68 70304ae3 movt     r3, #0xa070
a0390d6c b030d3e1 ldrh     r3, [r3]
a0390d70 7330bfe6 sxth     r3, r3
a0390d74 8330a0e1 lsl      r3, r3, #1
a0390d78 013083e2 add      r3, r3, #1
a0390d7c 930101e0 mul      r1, r3, r1
a0390d80 c43c01e3 movw     r3, #0x1cc4
a0390d84 70304ae3 movt     r3, #0xa070
a0390d88 b030d3e1 ldrh     r3, [r3]
a0390d8c 7300bfe6 sxth     r0, r3
a0390d90 f032dde1 ldrsh    r3, [sp, #0x20]
a0390d94 033080e0 add      r3, r0, r3
a0390d98 013083e2 add      r3, r3, #1
a0390d9c 033081e0 add      r3, r1, r3
a0390da0 b611dde1 ldrh     r1, [sp, #0x16]
a0390da4 910303e0 mul      r3, r1, r3
a0390da8 b411dde1 ldrh     r1, [sp, #0x14]
a0390dac 910301e0 mul      r1, r1, r3
a0390db0 b631dde1 ldrh     r3, [sp, #0x16]
a0390db4 18009de5 ldr      r0, [sp, #0x18]
a0390db8 900303e0 mul      r3, r0, r3
a0390dbc 031081e0 add      r1, r1, r3
a0390dc0 1c309de5 ldr      r3, [sp, #0x1c]
a0390dc4 031081e0 add      r1, r1, r3
a0390dc8 8c3b0ce3 movw     r3, #0xcb8c
a0390dcc 72304ae3 movt     r3, #0xa072
a0390dd0 8110a0e1 lsl      r1, r1, #1
a0390dd4 013083e0 add      r3, r3, r1
a0390dd8 b030d3e1 ldrh     r3, [r3]
a0390ddc 7310bfe6 sxth     r1, r3
a0390de0 6e3b0ae3 movw     r3, #0xab6e
a0390de4 70314ae3 movt     r3, #0xa170
a0390de8 b030d3e1 ldrh     r3, [r3]
a0390dec 7300bfe6 sxth     r0, r3
a0390df0 f0c2dde1 ldrsh    ip, [sp, #0x20]
a0390df4 c63c01e3 movw     r3, #0x1cc6
a0390df8 70304ae3 movt     r3, #0xa070
a0390dfc b030d3e1 ldrh     r3, [r3]
a0390e00 7330bfe6 sxth     r3, r3
a0390e04 930c03e0 mul      r3, r3, ip
a0390e08 003063e0 rsb      r3, r3, r0
a0390e0c 930103e0 mul      r3, r3, r1
a0390e10 032082e0 add      r2, r2, r3
a0390e14 c63c01e3 movw     r3, #0x1cc6
a0390e18 70304ae3 movt     r3, #0xa070
a0390e1c b030d3e1 ldrh     r3, [r3]
a0390e20 7330bfe6 sxth     r3, r3
a0390e24 0200a0e1 mov      r0, r2
a0390e28 0310a0e1 mov      r1, r3
a0390e2c 17d605fa blx      #0xa0506690
a0390e30 0030a0e1 mov      r3, r0
a0390e34 7320ffe6 uxth     r2, r3
a0390e38 283702e3 movw     r3, #0x2728
a0390e3c 70314ae3 movt     r3, #0xa170
a0390e40 8410a0e1 lsl      r1, r4, #1
a0390e44 013083e0 add      r3, r3, r1
a0390e48 b020c3e1 strh     r2, [r3]
a0390e4c b631dde1 ldrh     r3, [sp, #0x16]
a0390e50 18209de5 ldr      r2, [sp, #0x18]
a0390e54 920302e0 mul      r2, r2, r3
a0390e58 1c309de5 ldr      r3, [sp, #0x1c]
a0390e5c 034082e0 add      r4, r2, r3
a0390e60 c23c01e3 movw     r3, #0x1cc2
a0390e64 70304ae3 movt     r3, #0xa070
a0390e68 b030d3e1 ldrh     r3, [r3]
a0390e6c 7320bfe6 sxth     r2, r3
a0390e70 f232dde1 ldrsh    r3, [sp, #0x22]
a0390e74 023063e0 rsb      r3, r3, r2
a0390e78 012043e2 sub      r2, r3, #1
a0390e7c c43c01e3 movw     r3, #0x1cc4
a0390e80 70304ae3 movt     r3, #0xa070
a0390e84 b030d3e1 ldrh     r3, [r3]
a0390e88 7330bfe6 sxth     r3, r3
a0390e8c 8330a0e1 lsl      r3, r3, #1
a0390e90 013083e2 add      r3, r3, #1
a0390e94 930202e0 mul      r2, r3, r2
a0390e98 c43c01e3 movw     r3, #0x1cc4
a0390e9c 70304ae3 movt     r3, #0xa070
a0390ea0 b030d3e1 ldrh     r3, [r3]
a0390ea4 7310bfe6 sxth     r1, r3
a0390ea8 f032dde1 ldrsh    r3, [sp, #0x20]
a0390eac 033081e0 add      r3, r1, r3
a0390eb0 033082e0 add      r3, r2, r3
a0390eb4 b621dde1 ldrh     r2, [sp, #0x16]
a0390eb8 920303e0 mul      r3, r2, r3
a0390ebc b421dde1 ldrh     r2, [sp, #0x14]
a0390ec0 920302e0 mul      r2, r2, r3
a0390ec4 b631dde1 ldrh     r3, [sp, #0x16]
a0390ec8 18109de5 ldr      r1, [sp, #0x18]
a0390ecc 910303e0 mul      r3, r1, r3
a0390ed0 032082e0 add      r2, r2, r3
a0390ed4 1c309de5 ldr      r3, [sp, #0x1c]
a0390ed8 032082e0 add      r2, r2, r3
a0390edc 8c3b0ce3 movw     r3, #0xcb8c
a0390ee0 72304ae3 movt     r3, #0xa072
a0390ee4 8220a0e1 lsl      r2, r2, #1
a0390ee8 023083e0 add      r3, r3, r2
a0390eec b030d3e1 ldrh     r3, [r3]
a0390ef0 7320bfe6 sxth     r2, r3
a0390ef4 f032dde1 ldrsh    r3, [sp, #0x20]
a0390ef8 011083e2 add      r1, r3, #1
a0390efc c63c01e3 movw     r3, #0x1cc6
a0390f00 70304ae3 movt     r3, #0xa070
a0390f04 b030d3e1 ldrh     r3, [r3]
a0390f08 7330bfe6 sxth     r3, r3
a0390f0c 930101e0 mul      r1, r3, r1
a0390f10 6e3b0ae3 movw     r3, #0xab6e
a0390f14 70314ae3 movt     r3, #0xa170
a0390f18 b030d3e1 ldrh     r3, [r3]
a0390f1c 7330bfe6 sxth     r3, r3
a0390f20 013063e0 rsb      r3, r3, r1
a0390f24 930202e0 mul      r2, r3, r2
a0390f28 c23c01e3 movw     r3, #0x1cc2
a0390f2c 70304ae3 movt     r3, #0xa070
a0390f30 b030d3e1 ldrh     r3, [r3]
a0390f34 7310bfe6 sxth     r1, r3
a0390f38 f232dde1 ldrsh    r3, [sp, #0x22]
a0390f3c 013063e0 rsb      r3, r3, r1
a0390f40 011043e2 sub      r1, r3, #1
a0390f44 c43c01e3 movw     r3, #0x1cc4
a0390f48 70304ae3 movt     r3, #0xa070
a0390f4c b030d3e1 ldrh     r3, [r3]
a0390f50 7330bfe6 sxth     r3, r3
a0390f54 8330a0e1 lsl      r3, r3, #1
a0390f58 013083e2 add      r3, r3, #1
a0390f5c 930101e0 mul      r1, r3, r1
a0390f60 c43c01e3 movw     r3, #0x1cc4
a0390f64 70304ae3 movt     r3, #0xa070
a0390f68 b030d3e1 ldrh     r3, [r3]
a0390f6c 7300bfe6 sxth     r0, r3
a0390f70 f032dde1 ldrsh    r3, [sp, #0x20]
a0390f74 033080e0 add      r3, r0, r3
a0390f78 013083e2 add      r3, r3, #1
a0390f7c 033081e0 add      r3, r1, r3
a0390f80 b611dde1 ldrh     r1, [sp, #0x16]
a0390f84 910303e0 mul      r3, r1, r3
a0390f88 b411dde1 ldrh     r1, [sp, #0x14]
a0390f8c 910301e0 mul      r1, r1, r3
a0390f90 b631dde1 ldrh     r3, [sp, #0x16]
a0390f94 18009de5 ldr      r0, [sp, #0x18]
a0390f98 900303e0 mul      r3, r0, r3
a0390f9c 031081e0 add      r1, r1, r3
a0390fa0 1c309de5 ldr      r3, [sp, #0x1c]
a0390fa4 031081e0 add      r1, r1, r3
a0390fa8 8c3b0ce3 movw     r3, #0xcb8c
a0390fac 72304ae3 movt     r3, #0xa072
a0390fb0 8110a0e1 lsl      r1, r1, #1
a0390fb4 013083e0 add      r3, r3, r1
a0390fb8 b030d3e1 ldrh     r3, [r3]
a0390fbc 7310bfe6 sxth     r1, r3
a0390fc0 6e3b0ae3 movw     r3, #0xab6e
a0390fc4 70314ae3 movt     r3, #0xa170
a0390fc8 b030d3e1 ldrh     r3, [r3]
a0390fcc 7300bfe6 sxth     r0, r3
a0390fd0 f0c2dde1 ldrsh    ip, [sp, #0x20]
a0390fd4 c63c01e3 movw     r3, #0x1cc6
a0390fd8 70304ae3 movt     r3, #0xa070
a0390fdc b030d3e1 ldrh     r3, [r3]
a0390fe0 7330bfe6 sxth     r3, r3
a0390fe4 930c03e0 mul      r3, r3, ip
a0390fe8 003063e0 rsb      r3, r3, r0
a0390fec 930103e0 mul      r3, r3, r1
a0390ff0 032082e0 add      r2, r2, r3
a0390ff4 c63c01e3 movw     r3, #0x1cc6
a0390ff8 70304ae3 movt     r3, #0xa070
a0390ffc b030d3e1 ldrh     r3, [r3]
a0391000 7330bfe6 sxth     r3, r3
a0391004 0200a0e1 mov      r0, r2
a0391008 0310a0e1 mov      r1, r3
a039100c 9fd505fa blx      #0xa0506690
a0391010 0030a0e1 mov      r3, r0
a0391014 7320ffe6 uxth     r2, r3
a0391018 ac3902e3 movw     r3, #0x29ac
a039101c 70314ae3 movt     r3, #0xa170
a0391020 8410a0e1 lsl      r1, r4, #1
a0391024 013083e0 add      r3, r3, r1
a0391028 b020c3e1 strh     r2, [r3]
a039102c 1c309de5 ldr      r3, [sp, #0x1c]
a0391030 013083e2 add      r3, r3, #1
a0391034 1c308de5 str      r3, [sp, #0x1c]
a0391038 b621dde1 ldrh     r2, [sp, #0x16]
a039103c 1c309de5 ldr      r3, [sp, #0x1c]
a0391040 030052e1 cmp      r2, r3
a0391044 1cfeffca bgt      #0xa03908bc
a0391048 18309de5 ldr      r3, [sp, #0x18]
a039104c 013083e2 add      r3, r3, #1
a0391050 18308de5 str      r3, [sp, #0x18]
a0391054 b421dde1 ldrh     r2, [sp, #0x14]
a0391058 18309de5 ldr      r3, [sp, #0x18]
a039105c 030052e1 cmp      r2, r3
a0391060 12feffca bgt      #0xa03908b0
a0391064 0030a0e3 mov      r3, #0
a0391068 18308de5 str      r3, [sp, #0x18]
a039106c 900000ea b        #0xa03912b4
a0391070 0030a0e3 mov      r3, #0
a0391074 1c308de5 str      r3, [sp, #0x1c]
a0391078 860000ea b        #0xa0391298
a039107c b631dde1 ldrh     r3, [sp, #0x16]
a0391080 18209de5 ldr      r2, [sp, #0x18]
a0391084 920302e0 mul      r2, r2, r3
a0391088 1c309de5 ldr      r3, [sp, #0x1c]
a039108c 033082e0 add      r3, r2, r3
a0391090 0331a0e1 lsl      r3, r3, #2
a0391094 04209de5 ldr      r2, [sp, #4]
a0391098 034082e0 add      r4, r2, r3
a039109c b631dde1 ldrh     r3, [sp, #0x16]
a03910a0 18209de5 ldr      r2, [sp, #0x18]
a03910a4 920302e0 mul      r2, r2, r3
a03910a8 1c309de5 ldr      r3, [sp, #0x1c]
a03910ac 032082e0 add      r2, r2, r3
a03910b0 203202e3 movw     r3, #0x2220
a03910b4 70314ae3 movt     r3, #0xa170
a03910b8 8220a0e1 lsl      r2, r2, #1
a03910bc 023083e0 add      r3, r3, r2
a03910c0 b030d3e1 ldrh     r3, [r3]
a03910c4 7320bfe6 sxth     r2, r3
a03910c8 f232dde1 ldrsh    r3, [sp, #0x22]
a03910cc 011083e2 add      r1, r3, #1
a03910d0 c63c01e3 movw     r3, #0x1cc6
a03910d4 70304ae3 movt     r3, #0xa070
a03910d8 b030d3e1 ldrh     r3, [r3]
a03910dc 7330bfe6 sxth     r3, r3
a03910e0 930101e0 mul      r1, r3, r1
a03910e4 6c3b0ae3 movw     r3, #0xab6c
a03910e8 70314ae3 movt     r3, #0xa170
a03910ec b030d3e1 ldrh     r3, [r3]
a03910f0 7330bfe6 sxth     r3, r3
a03910f4 013063e0 rsb      r3, r3, r1
a03910f8 930202e0 mul      r2, r3, r2
a03910fc b631dde1 ldrh     r3, [sp, #0x16]
a0391100 18109de5 ldr      r1, [sp, #0x18]
a0391104 910301e0 mul      r1, r1, r3
a0391108 1c309de5 ldr      r3, [sp, #0x1c]
a039110c 031081e0 add      r1, r1, r3
a0391110 a43402e3 movw     r3, #0x24a4
a0391114 70314ae3 movt     r3, #0xa170
a0391118 8110a0e1 lsl      r1, r1, #1
a039111c 013083e0 add      r3, r3, r1
a0391120 b030d3e1 ldrh     r3, [r3]
a0391124 7310bfe6 sxth     r1, r3
a0391128 6c3b0ae3 movw     r3, #0xab6c
a039112c 70314ae3 movt     r3, #0xa170
a0391130 b030d3e1 ldrh     r3, [r3]
a0391134 7300bfe6 sxth     r0, r3
a0391138 f2c2dde1 ldrsh    ip, [sp, #0x22]
a039113c c63c01e3 movw     r3, #0x1cc6
a0391140 70304ae3 movt     r3, #0xa070
a0391144 b030d3e1 ldrh     r3, [r3]
a0391148 7330bfe6 sxth     r3, r3
a039114c 930c03e0 mul      r3, r3, ip
a0391150 003063e0 rsb      r3, r3, r0
a0391154 930103e0 mul      r3, r3, r1
a0391158 032082e0 add      r2, r2, r3
a039115c c63c01e3 movw     r3, #0x1cc6
a0391160 70304ae3 movt     r3, #0xa070
a0391164 b030d3e1 ldrh     r3, [r3]
a0391168 7330bfe6 sxth     r3, r3
a039116c 0200a0e1 mov      r0, r2
a0391170 0310a0e1 mov      r1, r3
a0391174 45d505fa blx      #0xa0506690
a0391178 0030a0e1 mov      r3, r0
a039117c 7330ffe6 uxth     r3, r3
a0391180 b030c4e1 strh     r3, [r4]
a0391184 b631dde1 ldrh     r3, [sp, #0x16]
a0391188 18209de5 ldr      r2, [sp, #0x18]
a039118c 920302e0 mul      r2, r2, r3
a0391190 1c309de5 ldr      r3, [sp, #0x1c]
a0391194 033082e0 add      r3, r2, r3
a0391198 0331a0e1 lsl      r3, r3, #2
a039119c 04209de5 ldr      r2, [sp, #4]
a03911a0 034082e0 add      r4, r2, r3
a03911a4 b631dde1 ldrh     r3, [sp, #0x16]
a03911a8 18209de5 ldr      r2, [sp, #0x18]
a03911ac 920302e0 mul      r2, r2, r3
a03911b0 1c309de5 ldr      r3, [sp, #0x1c]
a03911b4 032082e0 add      r2, r2, r3
a03911b8 283702e3 movw     r3, #0x2728
a03911bc 70314ae3 movt     r3, #0xa170
a03911c0 8220a0e1 lsl      r2, r2, #1
a03911c4 023083e0 add      r3, r3, r2
a03911c8 b030d3e1 ldrh     r3, [r3]
a03911cc 7320bfe6 sxth     r2, r3
a03911d0 f232dde1 ldrsh    r3, [sp, #0x22]
a03911d4 011083e2 add      r1, r3, #1
a03911d8 c63c01e3 movw     r3, #0x1cc6
a03911dc 70304ae3 movt     r3, #0xa070
a03911e0 b030d3e1 ldrh     r3, [r3]
a03911e4 7330bfe6 sxth     r3, r3
a03911e8 930101e0 mul      r1, r3, r1
a03911ec 6c3b0ae3 movw     r3, #0xab6c
a03911f0 70314ae3 movt     r3, #0xa170
a03911f4 b030d3e1 ldrh     r3, [r3]
a03911f8 7330bfe6 sxth     r3, r3
a03911fc 013063e0 rsb      r3, r3, r1
a0391200 930202e0 mul      r2, r3, r2
a0391204 b631dde1 ldrh     r3, [sp, #0x16]
a0391208 18109de5 ldr      r1, [sp, #0x18]
a039120c 910301e0 mul      r1, r1, r3
a0391210 1c309de5 ldr      r3, [sp, #0x1c]
a0391214 031081e0 add      r1, r1, r3
a0391218 ac3902e3 movw     r3, #0x29ac
a039121c 70314ae3 movt     r3, #0xa170
a0391220 8110a0e1 lsl      r1, r1, #1
a0391224 013083e0 add      r3, r3, r1
a0391228 b030d3e1 ldrh     r3, [r3]
a039122c 7310bfe6 sxth     r1, r3
a0391230 6c3b0ae3 movw     r3, #0xab6c
a0391234 70314ae3 movt     r3, #0xa170
a0391238 b030d3e1 ldrh     r3, [r3]
a039123c 7300bfe6 sxth     r0, r3
a0391240 f2c2dde1 ldrsh    ip, [sp, #0x22]
a0391244 c63c01e3 movw     r3, #0x1cc6
a0391248 70304ae3 movt     r3, #0xa070
a039124c b030d3e1 ldrh     r3, [r3]
a0391250 7330bfe6 sxth     r3, r3
a0391254 930c03e0 mul      r3, r3, ip
a0391258 003063e0 rsb      r3, r3, r0
a039125c 930103e0 mul      r3, r3, r1
a0391260 032082e0 add      r2, r2, r3
a0391264 c63c01e3 movw     r3, #0x1cc6
a0391268 70304ae3 movt     r3, #0xa070
a039126c b030d3e1 ldrh     r3, [r3]
a0391270 7330bfe6 sxth     r3, r3
a0391274 0200a0e1 mov      r0, r2
a0391278 0310a0e1 mov      r1, r3
a039127c 03d505fa blx      #0xa0506690
a0391280 0030a0e1 mov      r3, r0
a0391284 7330ffe6 uxth     r3, r3
a0391288 b230c4e1 strh     r3, [r4, #2]
a039128c 1c309de5 ldr      r3, [sp, #0x1c]
a0391290 013083e2 add      r3, r3, #1
a0391294 1c308de5 str      r3, [sp, #0x1c]
a0391298 b621dde1 ldrh     r2, [sp, #0x16]
a039129c 1c309de5 ldr      r3, [sp, #0x1c]
a03912a0 030052e1 cmp      r2, r3
a03912a4 74ffffca bgt      #0xa039107c
a03912a8 18309de5 ldr      r3, [sp, #0x18]
a03912ac 013083e2 add      r3, r3, #1
a03912b0 18308de5 str      r3, [sp, #0x18]
a03912b4 b421dde1 ldrh     r2, [sp, #0x14]
a03912b8 18309de5 ldr      r3, [sp, #0x18]
a03912bc 030052e1 cmp      r2, r3
a03912c0 6affffca bgt      #0xa0391070
a03912c4 870200ea b        #0xa0391ce8
a03912c8 0030a0e3 mov      r3, #0
a03912cc 18308de5 str      r3, [sp, #0x18]
a03912d0 e80100ea b        #0xa0391a78
a03912d4 0030a0e3 mov      r3, #0
a03912d8 1c308de5 str      r3, [sp, #0x1c]
a03912dc de0100ea b        #0xa0391a5c
a03912e0 b631dde1 ldrh     r3, [sp, #0x16]
a03912e4 18209de5 ldr      r2, [sp, #0x18]
a03912e8 920302e0 mul      r2, r2, r3
a03912ec 1c309de5 ldr      r3, [sp, #0x1c]
a03912f0 034082e0 add      r4, r2, r3
a03912f4 c23c01e3 movw     r3, #0x1cc2
a03912f8 70304ae3 movt     r3, #0xa070
a03912fc b030d3e1 ldrh     r3, [r3]
a0391300 7320bfe6 sxth     r2, r3
a0391304 f232dde1 ldrsh    r3, [sp, #0x22]
a0391308 022063e0 rsb      r2, r3, r2
a039130c c43c01e3 movw     r3, #0x1cc4
a0391310 70304ae3 movt     r3, #0xa070
a0391314 b030d3e1 ldrh     r3, [r3]
a0391318 7330bfe6 sxth     r3, r3
a039131c 8330a0e1 lsl      r3, r3, #1
a0391320 013083e2 add      r3, r3, #1
a0391324 930202e0 mul      r2, r3, r2
a0391328 c43c01e3 movw     r3, #0x1cc4
a039132c 70304ae3 movt     r3, #0xa070
a0391330 b030d3e1 ldrh     r3, [r3]
a0391334 7310bfe6 sxth     r1, r3
a0391338 f032dde1 ldrsh    r3, [sp, #0x20]
a039133c 013063e0 rsb      r3, r3, r1
a0391340 033082e0 add      r3, r2, r3
a0391344 b621dde1 ldrh     r2, [sp, #0x16]
a0391348 920303e0 mul      r3, r2, r3
a039134c b421dde1 ldrh     r2, [sp, #0x14]
a0391350 920302e0 mul      r2, r2, r3
a0391354 b631dde1 ldrh     r3, [sp, #0x16]
a0391358 18109de5 ldr      r1, [sp, #0x18]
a039135c 910303e0 mul      r3, r1, r3
a0391360 032082e0 add      r2, r2, r3
a0391364 1c309de5 ldr      r3, [sp, #0x1c]
a0391368 032082e0 add      r2, r2, r3
a039136c c83c01e3 movw     r3, #0x1cc8
a0391370 70304ae3 movt     r3, #0xa070
a0391374 8220a0e1 lsl      r2, r2, #1
a0391378 023083e0 add      r3, r3, r2
a039137c b030d3e1 ldrh     r3, [r3]
a0391380 7320bfe6 sxth     r2, r3
a0391384 f032dde1 ldrsh    r3, [sp, #0x20]
a0391388 011083e2 add      r1, r3, #1
a039138c c63c01e3 movw     r3, #0x1cc6
a0391390 70304ae3 movt     r3, #0xa070
a0391394 b030d3e1 ldrh     r3, [r3]
a0391398 7330bfe6 sxth     r3, r3
a039139c 930101e0 mul      r1, r3, r1
a03913a0 6e3b0ae3 movw     r3, #0xab6e
a03913a4 70314ae3 movt     r3, #0xa170
a03913a8 b030d3e1 ldrh     r3, [r3]
a03913ac 7330bfe6 sxth     r3, r3
a03913b0 013063e0 rsb      r3, r3, r1
a03913b4 930202e0 mul      r2, r3, r2
a03913b8 c23c01e3 movw     r3, #0x1cc2
a03913bc 70304ae3 movt     r3, #0xa070
a03913c0 b030d3e1 ldrh     r3, [r3]
a03913c4 7310bfe6 sxth     r1, r3
a03913c8 f232dde1 ldrsh    r3, [sp, #0x22]
a03913cc 011063e0 rsb      r1, r3, r1
a03913d0 c43c01e3 movw     r3, #0x1cc4
a03913d4 70304ae3 movt     r3, #0xa070
a03913d8 b030d3e1 ldrh     r3, [r3]
a03913dc 7330bfe6 sxth     r3, r3
a03913e0 8330a0e1 lsl      r3, r3, #1
a03913e4 013083e2 add      r3, r3, #1
a03913e8 930101e0 mul      r1, r3, r1
a03913ec c43c01e3 movw     r3, #0x1cc4
a03913f0 70304ae3 movt     r3, #0xa070
a03913f4 b030d3e1 ldrh     r3, [r3]
a03913f8 7300bfe6 sxth     r0, r3
a03913fc f032dde1 ldrsh    r3, [sp, #0x20]
a0391400 003063e0 rsb      r3, r3, r0
a0391404 013043e2 sub      r3, r3, #1
a0391408 033081e0 add      r3, r1, r3
a039140c b611dde1 ldrh     r1, [sp, #0x16]
a0391410 910303e0 mul      r3, r1, r3
a0391414 b411dde1 ldrh     r1, [sp, #0x14]
a0391418 910301e0 mul      r1, r1, r3
a039141c b631dde1 ldrh     r3, [sp, #0x16]
a0391420 18009de5 ldr      r0, [sp, #0x18]
a0391424 900303e0 mul      r3, r0, r3
a0391428 031081e0 add      r1, r1, r3
a039142c 1c309de5 ldr      r3, [sp, #0x1c]
a0391430 031081e0 add      r1, r1, r3
a0391434 c83c01e3 movw     r3, #0x1cc8
a0391438 70304ae3 movt     r3, #0xa070
a039143c 8110a0e1 lsl      r1, r1, #1
a0391440 013083e0 add      r3, r3, r1
a0391444 b030d3e1 ldrh     r3, [r3]
a0391448 7310bfe6 sxth     r1, r3
a039144c 6e3b0ae3 movw     r3, #0xab6e
a0391450 70314ae3 movt     r3, #0xa170
a0391454 b030d3e1 ldrh     r3, [r3]
a0391458 7300bfe6 sxth     r0, r3
a039145c f0c2dde1 ldrsh    ip, [sp, #0x20]
a0391460 c63c01e3 movw     r3, #0x1cc6
a0391464 70304ae3 movt     r3, #0xa070
a0391468 b030d3e1 ldrh     r3, [r3]
a039146c 7330bfe6 sxth     r3, r3
a0391470 930c03e0 mul      r3, r3, ip
a0391474 003063e0 rsb      r3, r3, r0
a0391478 930103e0 mul      r3, r3, r1
a039147c 032082e0 add      r2, r2, r3
a0391480 c63c01e3 movw     r3, #0x1cc6
a0391484 70304ae3 movt     r3, #0xa070
a0391488 b030d3e1 ldrh     r3, [r3]
a039148c 7330bfe6 sxth     r3, r3
a0391490 0200a0e1 mov      r0, r2
a0391494 0310a0e1 mov      r1, r3
a0391498 7cd405fa blx      #0xa0506690
a039149c 0030a0e1 mov      r3, r0
a03914a0 7320ffe6 uxth     r2, r3
a03914a4 203202e3 movw     r3, #0x2220
a03914a8 70314ae3 movt     r3, #0xa170
a03914ac 8410a0e1 lsl      r1, r4, #1
a03914b0 013083e0 add      r3, r3, r1
a03914b4 b020c3e1 strh     r2, [r3]
a03914b8 b631dde1 ldrh     r3, [sp, #0x16]
a03914bc 18209de5 ldr      r2, [sp, #0x18]
a03914c0 920302e0 mul      r2, r2, r3
a03914c4 1c309de5 ldr      r3, [sp, #0x1c]
a03914c8 034082e0 add      r4, r2, r3
a03914cc c23c01e3 movw     r3, #0x1cc2
a03914d0 70304ae3 movt     r3, #0xa070
a03914d4 b030d3e1 ldrh     r3, [r3]
a03914d8 7320bfe6 sxth     r2, r3
a03914dc f232dde1 ldrsh    r3, [sp, #0x22]
a03914e0 023063e0 rsb      r3, r3, r2
a03914e4 012043e2 sub      r2, r3, #1
a03914e8 c43c01e3 movw     r3, #0x1cc4
a03914ec 70304ae3 movt     r3, #0xa070
a03914f0 b030d3e1 ldrh     r3, [r3]
a03914f4 7330bfe6 sxth     r3, r3
a03914f8 8330a0e1 lsl      r3, r3, #1
a03914fc 013083e2 add      r3, r3, #1
a0391500 930202e0 mul      r2, r3, r2
a0391504 c43c01e3 movw     r3, #0x1cc4
a0391508 70304ae3 movt     r3, #0xa070
a039150c b030d3e1 ldrh     r3, [r3]
a0391510 7310bfe6 sxth     r1, r3
a0391514 f032dde1 ldrsh    r3, [sp, #0x20]
a0391518 013063e0 rsb      r3, r3, r1
a039151c 033082e0 add      r3, r2, r3
a0391520 b621dde1 ldrh     r2, [sp, #0x16]
a0391524 920303e0 mul      r3, r2, r3
a0391528 b421dde1 ldrh     r2, [sp, #0x14]
a039152c 920302e0 mul      r2, r2, r3
a0391530 b631dde1 ldrh     r3, [sp, #0x16]
a0391534 18109de5 ldr      r1, [sp, #0x18]
a0391538 910303e0 mul      r3, r1, r3
a039153c 032082e0 add      r2, r2, r3
a0391540 1c309de5 ldr      r3, [sp, #0x1c]
a0391544 032082e0 add      r2, r2, r3
a0391548 c83c01e3 movw     r3, #0x1cc8
a039154c 70304ae3 movt     r3, #0xa070
a0391550 8220a0e1 lsl      r2, r2, #1
a0391554 023083e0 add      r3, r3, r2
a0391558 b030d3e1 ldrh     r3, [r3]
a039155c 7320bfe6 sxth     r2, r3
a0391560 f032dde1 ldrsh    r3, [sp, #0x20]
a0391564 011083e2 add      r1, r3, #1
a0391568 c63c01e3 movw     r3, #0x1cc6
a039156c 70304ae3 movt     r3, #0xa070
a0391570 b030d3e1 ldrh     r3, [r3]
a0391574 7330bfe6 sxth     r3, r3
a0391578 930101e0 mul      r1, r3, r1
a039157c 6e3b0ae3 movw     r3, #0xab6e
a0391580 70314ae3 movt     r3, #0xa170
a0391584 b030d3e1 ldrh     r3, [r3]
a0391588 7330bfe6 sxth     r3, r3
a039158c 013063e0 rsb      r3, r3, r1
a0391590 930202e0 mul      r2, r3, r2
a0391594 c23c01e3 movw     r3, #0x1cc2
a0391598 70304ae3 movt     r3, #0xa070
a039159c b030d3e1 ldrh     r3, [r3]
a03915a0 7310bfe6 sxth     r1, r3
a03915a4 f232dde1 ldrsh    r3, [sp, #0x22]
a03915a8 013063e0 rsb      r3, r3, r1
a03915ac 011043e2 sub      r1, r3, #1
a03915b0 c43c01e3 movw     r3, #0x1cc4
a03915b4 70304ae3 movt     r3, #0xa070
a03915b8 b030d3e1 ldrh     r3, [r3]
a03915bc 7330bfe6 sxth     r3, r3
a03915c0 8330a0e1 lsl      r3, r3, #1
a03915c4 013083e2 add      r3, r3, #1
a03915c8 930101e0 mul      r1, r3, r1
a03915cc c43c01e3 movw     r3, #0x1cc4
a03915d0 70304ae3 movt     r3, #0xa070
a03915d4 b030d3e1 ldrh     r3, [r3]
a03915d8 7300bfe6 sxth     r0, r3
a03915dc f032dde1 ldrsh    r3, [sp, #0x20]
a03915e0 003063e0 rsb      r3, r3, r0
a03915e4 013043e2 sub      r3, r3, #1
a03915e8 033081e0 add      r3, r1, r3
a03915ec b611dde1 ldrh     r1, [sp, #0x16]
a03915f0 910303e0 mul      r3, r1, r3
a03915f4 b411dde1 ldrh     r1, [sp, #0x14]
a03915f8 910301e0 mul      r1, r1, r3
a03915fc b631dde1 ldrh     r3, [sp, #0x16]
a0391600 18009de5 ldr      r0, [sp, #0x18]
a0391604 900303e0 mul      r3, r0, r3
a0391608 031081e0 add      r1, r1, r3
a039160c 1c309de5 ldr      r3, [sp, #0x1c]
a0391610 031081e0 add      r1, r1, r3
a0391614 c83c01e3 movw     r3, #0x1cc8
a0391618 70304ae3 movt     r3, #0xa070
a039161c 8110a0e1 lsl      r1, r1, #1
a0391620 013083e0 add      r3, r3, r1
a0391624 b030d3e1 ldrh     r3, [r3]
a0391628 7310bfe6 sxth     r1, r3
a039162c 6e3b0ae3 movw     r3, #0xab6e
a0391630 70314ae3 movt     r3, #0xa170
a0391634 b030d3e1 ldrh     r3, [r3]
a0391638 7300bfe6 sxth     r0, r3
a039163c f0c2dde1 ldrsh    ip, [sp, #0x20]
a0391640 c63c01e3 movw     r3, #0x1cc6
a0391644 70304ae3 movt     r3, #0xa070
a0391648 b030d3e1 ldrh     r3, [r3]
a039164c 7330bfe6 sxth     r3, r3
a0391650 930c03e0 mul      r3, r3, ip
a0391654 003063e0 rsb      r3, r3, r0
a0391658 930103e0 mul      r3, r3, r1
a039165c 032082e0 add      r2, r2, r3
a0391660 c63c01e3 movw     r3, #0x1cc6
a0391664 70304ae3 movt     r3, #0xa070
a0391668 b030d3e1 ldrh     r3, [r3]
a039166c 7330bfe6 sxth     r3, r3
a0391670 0200a0e1 mov      r0, r2
a0391674 0310a0e1 mov      r1, r3
a0391678 04d405fa blx      #0xa0506690
a039167c 0030a0e1 mov      r3, r0
a0391680 7320ffe6 uxth     r2, r3
a0391684 a43402e3 movw     r3, #0x24a4
a0391688 70314ae3 movt     r3, #0xa170
a039168c 8410a0e1 lsl      r1, r4, #1
a0391690 013083e0 add      r3, r3, r1
a0391694 b020c3e1 strh     r2, [r3]
a0391698 b631dde1 ldrh     r3, [sp, #0x16]
a039169c 18209de5 ldr      r2, [sp, #0x18]
a03916a0 920302e0 mul      r2, r2, r3
a03916a4 1c309de5 ldr      r3, [sp, #0x1c]
a03916a8 034082e0 add      r4, r2, r3
a03916ac c23c01e3 movw     r3, #0x1cc2
a03916b0 70304ae3 movt     r3, #0xa070
a03916b4 b030d3e1 ldrh     r3, [r3]
a03916b8 7320bfe6 sxth     r2, r3
a03916bc f232dde1 ldrsh    r3, [sp, #0x22]
a03916c0 022063e0 rsb      r2, r3, r2
a03916c4 c43c01e3 movw     r3, #0x1cc4
a03916c8 70304ae3 movt     r3, #0xa070
a03916cc b030d3e1 ldrh     r3, [r3]
a03916d0 7330bfe6 sxth     r3, r3
a03916d4 8330a0e1 lsl      r3, r3, #1
a03916d8 013083e2 add      r3, r3, #1
a03916dc 930202e0 mul      r2, r3, r2
a03916e0 c43c01e3 movw     r3, #0x1cc4
a03916e4 70304ae3 movt     r3, #0xa070
a03916e8 b030d3e1 ldrh     r3, [r3]
a03916ec 7310bfe6 sxth     r1, r3
a03916f0 f032dde1 ldrsh    r3, [sp, #0x20]
a03916f4 013063e0 rsb      r3, r3, r1
a03916f8 033082e0 add      r3, r2, r3
a03916fc b621dde1 ldrh     r2, [sp, #0x16]
a0391700 920303e0 mul      r3, r2, r3
a0391704 b421dde1 ldrh     r2, [sp, #0x14]
a0391708 920302e0 mul      r2, r2, r3
a039170c b631dde1 ldrh     r3, [sp, #0x16]
a0391710 18109de5 ldr      r1, [sp, #0x18]
a0391714 910303e0 mul      r3, r1, r3
a0391718 032082e0 add      r2, r2, r3
a039171c 1c309de5 ldr      r3, [sp, #0x1c]
a0391720 032082e0 add      r2, r2, r3
a0391724 8c3b0ce3 movw     r3, #0xcb8c
a0391728 72304ae3 movt     r3, #0xa072
a039172c 8220a0e1 lsl      r2, r2, #1
a0391730 023083e0 add      r3, r3, r2
a0391734 b030d3e1 ldrh     r3, [r3]
a0391738 7320bfe6 sxth     r2, r3
a039173c f032dde1 ldrsh    r3, [sp, #0x20]
a0391740 011083e2 add      r1, r3, #1
a0391744 c63c01e3 movw     r3, #0x1cc6
a0391748 70304ae3 movt     r3, #0xa070
a039174c b030d3e1 ldrh     r3, [r3]
a0391750 7330bfe6 sxth     r3, r3
a0391754 930101e0 mul      r1, r3, r1
a0391758 6e3b0ae3 movw     r3, #0xab6e
a039175c 70314ae3 movt     r3, #0xa170
a0391760 b030d3e1 ldrh     r3, [r3]
a0391764 7330bfe6 sxth     r3, r3
a0391768 013063e0 rsb      r3, r3, r1
a039176c 930202e0 mul      r2, r3, r2
a0391770 c23c01e3 movw     r3, #0x1cc2
a0391774 70304ae3 movt     r3, #0xa070
a0391778 b030d3e1 ldrh     r3, [r3]
a039177c 7310bfe6 sxth     r1, r3
a0391780 f232dde1 ldrsh    r3, [sp, #0x22]
a0391784 011063e0 rsb      r1, r3, r1
a0391788 c43c01e3 movw     r3, #0x1cc4
a039178c 70304ae3 movt     r3, #0xa070
a0391790 b030d3e1 ldrh     r3, [r3]
a0391794 7330bfe6 sxth     r3, r3
a0391798 8330a0e1 lsl      r3, r3, #1
a039179c 013083e2 add      r3, r3, #1
a03917a0 930101e0 mul      r1, r3, r1
a03917a4 c43c01e3 movw     r3, #0x1cc4
a03917a8 70304ae3 movt     r3, #0xa070
a03917ac b030d3e1 ldrh     r3, [r3]
a03917b0 7300bfe6 sxth     r0, r3
a03917b4 f032dde1 ldrsh    r3, [sp, #0x20]
a03917b8 003063e0 rsb      r3, r3, r0
a03917bc 013043e2 sub      r3, r3, #1
a03917c0 033081e0 add      r3, r1, r3
a03917c4 b611dde1 ldrh     r1, [sp, #0x16]
a03917c8 910303e0 mul      r3, r1, r3
a03917cc b411dde1 ldrh     r1, [sp, #0x14]
a03917d0 910301e0 mul      r1, r1, r3
a03917d4 b631dde1 ldrh     r3, [sp, #0x16]
a03917d8 18009de5 ldr      r0, [sp, #0x18]
a03917dc 900303e0 mul      r3, r0, r3
a03917e0 031081e0 add      r1, r1, r3
a03917e4 1c309de5 ldr      r3, [sp, #0x1c]
a03917e8 031081e0 add      r1, r1, r3
a03917ec 8c3b0ce3 movw     r3, #0xcb8c
a03917f0 72304ae3 movt     r3, #0xa072
a03917f4 8110a0e1 lsl      r1, r1, #1
a03917f8 013083e0 add      r3, r3, r1
a03917fc b030d3e1 ldrh     r3, [r3]
a0391800 7310bfe6 sxth     r1, r3
a0391804 6e3b0ae3 movw     r3, #0xab6e
a0391808 70314ae3 movt     r3, #0xa170
a039180c b030d3e1 ldrh     r3, [r3]
a0391810 7300bfe6 sxth     r0, r3
a0391814 f0c2dde1 ldrsh    ip, [sp, #0x20]
a0391818 c63c01e3 movw     r3, #0x1cc6
a039181c 70304ae3 movt     r3, #0xa070
a0391820 b030d3e1 ldrh     r3, [r3]
a0391824 7330bfe6 sxth     r3, r3
a0391828 930c03e0 mul      r3, r3, ip
a039182c 003063e0 rsb      r3, r3, r0
a0391830 930103e0 mul      r3, r3, r1
a0391834 032082e0 add      r2, r2, r3
a0391838 c63c01e3 movw     r3, #0x1cc6
a039183c 70304ae3 movt     r3, #0xa070
a0391840 b030d3e1 ldrh     r3, [r3]
a0391844 7330bfe6 sxth     r3, r3
a0391848 0200a0e1 mov      r0, r2
a039184c 0310a0e1 mov      r1, r3
a0391850 8ed305fa blx      #0xa0506690
a0391854 0030a0e1 mov      r3, r0
a0391858 7320ffe6 uxth     r2, r3
a039185c 283702e3 movw     r3, #0x2728
a0391860 70314ae3 movt     r3, #0xa170
a0391864 8410a0e1 lsl      r1, r4, #1
a0391868 013083e0 add      r3, r3, r1
a039186c b020c3e1 strh     r2, [r3]
a0391870 b631dde1 ldrh     r3, [sp, #0x16]
a0391874 18209de5 ldr      r2, [sp, #0x18]
a0391878 920302e0 mul      r2, r2, r3
a039187c 1c309de5 ldr      r3, [sp, #0x1c]
a0391880 034082e0 add      r4, r2, r3
a0391884 c23c01e3 movw     r3, #0x1cc2
a0391888 70304ae3 movt     r3, #0xa070
a039188c b030d3e1 ldrh     r3, [r3]
a0391890 7320bfe6 sxth     r2, r3
a0391894 f232dde1 ldrsh    r3, [sp, #0x22]
a0391898 023063e0 rsb      r3, r3, r2
a039189c 012043e2 sub      r2, r3, #1
a03918a0 c43c01e3 movw     r3, #0x1cc4
a03918a4 70304ae3 movt     r3, #0xa070
a03918a8 b030d3e1 ldrh     r3, [r3]
a03918ac 7330bfe6 sxth     r3, r3
a03918b0 8330a0e1 lsl      r3, r3, #1
a03918b4 013083e2 add      r3, r3, #1
a03918b8 930202e0 mul      r2, r3, r2
a03918bc c43c01e3 movw     r3, #0x1cc4
a03918c0 70304ae3 movt     r3, #0xa070
a03918c4 b030d3e1 ldrh     r3, [r3]
a03918c8 7310bfe6 sxth     r1, r3
a03918cc f032dde1 ldrsh    r3, [sp, #0x20]
a03918d0 013063e0 rsb      r3, r3, r1
a03918d4 033082e0 add      r3, r2, r3
a03918d8 b621dde1 ldrh     r2, [sp, #0x16]
a03918dc 920303e0 mul      r3, r2, r3
a03918e0 b421dde1 ldrh     r2, [sp, #0x14]
a03918e4 920302e0 mul      r2, r2, r3
a03918e8 b631dde1 ldrh     r3, [sp, #0x16]
a03918ec 18109de5 ldr      r1, [sp, #0x18]
a03918f0 910303e0 mul      r3, r1, r3
a03918f4 032082e0 add      r2, r2, r3
a03918f8 1c309de5 ldr      r3, [sp, #0x1c]
a03918fc 032082e0 add      r2, r2, r3
a0391900 8c3b0ce3 movw     r3, #0xcb8c
a0391904 72304ae3 movt     r3, #0xa072
a0391908 8220a0e1 lsl      r2, r2, #1
a039190c 023083e0 add      r3, r3, r2
a0391910 b030d3e1 ldrh     r3, [r3]
a0391914 7320bfe6 sxth     r2, r3
a0391918 f032dde1 ldrsh    r3, [sp, #0x20]
a039191c 011083e2 add      r1, r3, #1
a0391920 c63c01e3 movw     r3, #0x1cc6
a0391924 70304ae3 movt     r3, #0xa070
a0391928 b030d3e1 ldrh     r3, [r3]
a039192c 7330bfe6 sxth     r3, r3
a0391930 930101e0 mul      r1, r3, r1
a0391934 6e3b0ae3 movw     r3, #0xab6e
a0391938 70314ae3 movt     r3, #0xa170
a039193c b030d3e1 ldrh     r3, [r3]
a0391940 7330bfe6 sxth     r3, r3
a0391944 013063e0 rsb      r3, r3, r1
a0391948 930202e0 mul      r2, r3, r2
a039194c c23c01e3 movw     r3, #0x1cc2
a0391950 70304ae3 movt     r3, #0xa070
a0391954 b030d3e1 ldrh     r3, [r3]
a0391958 7310bfe6 sxth     r1, r3
a039195c f232dde1 ldrsh    r3, [sp, #0x22]
a0391960 013063e0 rsb      r3, r3, r1
a0391964 011043e2 sub      r1, r3, #1
a0391968 c43c01e3 movw     r3, #0x1cc4
a039196c 70304ae3 movt     r3, #0xa070
a0391970 b030d3e1 ldrh     r3, [r3]
a0391974 7330bfe6 sxth     r3, r3
a0391978 8330a0e1 lsl      r3, r3, #1
a039197c 013083e2 add      r3, r3, #1
a0391980 930101e0 mul      r1, r3, r1
a0391984 c43c01e3 movw     r3, #0x1cc4
a0391988 70304ae3 movt     r3, #0xa070
a039198c b030d3e1 ldrh     r3, [r3]
a0391990 7300bfe6 sxth     r0, r3
a0391994 f032dde1 ldrsh    r3, [sp, #0x20]
a0391998 003063e0 rsb      r3, r3, r0
a039199c 013043e2 sub      r3, r3, #1
a03919a0 033081e0 add      r3, r1, r3
a03919a4 b611dde1 ldrh     r1, [sp, #0x16]
a03919a8 910303e0 mul      r3, r1, r3
a03919ac b411dde1 ldrh     r1, [sp, #0x14]
a03919b0 910301e0 mul      r1, r1, r3
a03919b4 b631dde1 ldrh     r3, [sp, #0x16]
a03919b8 18009de5 ldr      r0, [sp, #0x18]
a03919bc 900303e0 mul      r3, r0, r3
a03919c0 031081e0 add      r1, r1, r3
a03919c4 1c309de5 ldr      r3, [sp, #0x1c]
a03919c8 031081e0 add      r1, r1, r3
a03919cc 8c3b0ce3 movw     r3, #0xcb8c
a03919d0 72304ae3 movt     r3, #0xa072
a03919d4 8110a0e1 lsl      r1, r1, #1
a03919d8 013083e0 add      r3, r3, r1
a03919dc b030d3e1 ldrh     r3, [r3]
a03919e0 7310bfe6 sxth     r1, r3
a03919e4 6e3b0ae3 movw     r3, #0xab6e
a03919e8 70314ae3 movt     r3, #0xa170
a03919ec b030d3e1 ldrh     r3, [r3]
a03919f0 7300bfe6 sxth     r0, r3
a03919f4 f0c2dde1 ldrsh    ip, [sp, #0x20]
a03919f8 c63c01e3 movw     r3, #0x1cc6
a03919fc 70304ae3 movt     r3, #0xa070
a0391a00 b030d3e1 ldrh     r3, [r3]
a0391a04 7330bfe6 sxth     r3, r3
a0391a08 930c03e0 mul      r3, r3, ip
a0391a0c 003063e0 rsb      r3, r3, r0
a0391a10 930103e0 mul      r3, r3, r1
a0391a14 032082e0 add      r2, r2, r3
a0391a18 c63c01e3 movw     r3, #0x1cc6
a0391a1c 70304ae3 movt     r3, #0xa070
a0391a20 b030d3e1 ldrh     r3, [r3]
a0391a24 7330bfe6 sxth     r3, r3
a0391a28 0200a0e1 mov      r0, r2
a0391a2c 0310a0e1 mov      r1, r3
a0391a30 16d305fa blx      #0xa0506690
a0391a34 0030a0e1 mov      r3, r0
a0391a38 7320ffe6 uxth     r2, r3
a0391a3c ac3902e3 movw     r3, #0x29ac
a0391a40 70314ae3 movt     r3, #0xa170
a0391a44 8410a0e1 lsl      r1, r4, #1
a0391a48 013083e0 add      r3, r3, r1
a0391a4c b020c3e1 strh     r2, [r3]
a0391a50 1c309de5 ldr      r3, [sp, #0x1c]
a0391a54 013083e2 add      r3, r3, #1
a0391a58 1c308de5 str      r3, [sp, #0x1c]
a0391a5c b621dde1 ldrh     r2, [sp, #0x16]
a0391a60 1c309de5 ldr      r3, [sp, #0x1c]
a0391a64 030052e1 cmp      r2, r3
a0391a68 1cfeffca bgt      #0xa03912e0
a0391a6c 18309de5 ldr      r3, [sp, #0x18]
a0391a70 013083e2 add      r3, r3, #1
a0391a74 18308de5 str      r3, [sp, #0x18]
a0391a78 b421dde1 ldrh     r2, [sp, #0x14]
a0391a7c 18309de5 ldr      r3, [sp, #0x18]
a0391a80 030052e1 cmp      r2, r3
a0391a84 12feffca bgt      #0xa03912d4
a0391a88 0030a0e3 mov      r3, #0
a0391a8c 18308de5 str      r3, [sp, #0x18]
a0391a90 900000ea b        #0xa0391cd8
a0391a94 0030a0e3 mov      r3, #0
a0391a98 1c308de5 str      r3, [sp, #0x1c]
a0391a9c 860000ea b        #0xa0391cbc
a0391aa0 b631dde1 ldrh     r3, [sp, #0x16]
a0391aa4 18209de5 ldr      r2, [sp, #0x18]
a0391aa8 920302e0 mul      r2, r2, r3
a0391aac 1c309de5 ldr      r3, [sp, #0x1c]
a0391ab0 033082e0 add      r3, r2, r3
a0391ab4 0331a0e1 lsl      r3, r3, #2
a0391ab8 04209de5 ldr      r2, [sp, #4]
a0391abc 034082e0 add      r4, r2, r3
a0391ac0 b631dde1 ldrh     r3, [sp, #0x16]
a0391ac4 18209de5 ldr      r2, [sp, #0x18]
a0391ac8 920302e0 mul      r2, r2, r3
a0391acc 1c309de5 ldr      r3, [sp, #0x1c]
a0391ad0 032082e0 add      r2, r2, r3
a0391ad4 203202e3 movw     r3, #0x2220
a0391ad8 70314ae3 movt     r3, #0xa170
a0391adc 8220a0e1 lsl      r2, r2, #1
a0391ae0 023083e0 add      r3, r3, r2
a0391ae4 b030d3e1 ldrh     r3, [r3]
a0391ae8 7320bfe6 sxth     r2, r3
a0391aec f232dde1 ldrsh    r3, [sp, #0x22]
a0391af0 011083e2 add      r1, r3, #1
a0391af4 c63c01e3 movw     r3, #0x1cc6
a0391af8 70304ae3 movt     r3, #0xa070
a0391afc b030d3e1 ldrh     r3, [r3]
a0391b00 7330bfe6 sxth     r3, r3
a0391b04 930101e0 mul      r1, r3, r1
a0391b08 6c3b0ae3 movw     r3, #0xab6c
a0391b0c 70314ae3 movt     r3, #0xa170
a0391b10 b030d3e1 ldrh     r3, [r3]
a0391b14 7330bfe6 sxth     r3, r3
a0391b18 013063e0 rsb      r3, r3, r1
a0391b1c 930202e0 mul      r2, r3, r2
a0391b20 b631dde1 ldrh     r3, [sp, #0x16]
a0391b24 18109de5 ldr      r1, [sp, #0x18]
a0391b28 910301e0 mul      r1, r1, r3
a0391b2c 1c309de5 ldr      r3, [sp, #0x1c]
a0391b30 031081e0 add      r1, r1, r3
a0391b34 a43402e3 movw     r3, #0x24a4
a0391b38 70314ae3 movt     r3, #0xa170
a0391b3c 8110a0e1 lsl      r1, r1, #1
a0391b40 013083e0 add      r3, r3, r1
a0391b44 b030d3e1 ldrh     r3, [r3]
a0391b48 7310bfe6 sxth     r1, r3
a0391b4c 6c3b0ae3 movw     r3, #0xab6c
a0391b50 70314ae3 movt     r3, #0xa170
a0391b54 b030d3e1 ldrh     r3, [r3]
a0391b58 7300bfe6 sxth     r0, r3
a0391b5c f2c2dde1 ldrsh    ip, [sp, #0x22]
a0391b60 c63c01e3 movw     r3, #0x1cc6
a0391b64 70304ae3 movt     r3, #0xa070
a0391b68 b030d3e1 ldrh     r3, [r3]
a0391b6c 7330bfe6 sxth     r3, r3
a0391b70 930c03e0 mul      r3, r3, ip
a0391b74 003063e0 rsb      r3, r3, r0
a0391b78 930103e0 mul      r3, r3, r1
a0391b7c 032082e0 add      r2, r2, r3
a0391b80 c63c01e3 movw     r3, #0x1cc6
a0391b84 70304ae3 movt     r3, #0xa070
a0391b88 b030d3e1 ldrh     r3, [r3]
a0391b8c 7330bfe6 sxth     r3, r3
a0391b90 0200a0e1 mov      r0, r2
a0391b94 0310a0e1 mov      r1, r3
a0391b98 bcd205fa blx      #0xa0506690
a0391b9c 0030a0e1 mov      r3, r0
a0391ba0 7330ffe6 uxth     r3, r3
a0391ba4 b030c4e1 strh     r3, [r4]
a0391ba8 b631dde1 ldrh     r3, [sp, #0x16]
a0391bac 18209de5 ldr      r2, [sp, #0x18]
a0391bb0 920302e0 mul      r2, r2, r3
a0391bb4 1c309de5 ldr      r3, [sp, #0x1c]
a0391bb8 033082e0 add      r3, r2, r3
a0391bbc 0331a0e1 lsl      r3, r3, #2
a0391bc0 04209de5 ldr      r2, [sp, #4]
a0391bc4 034082e0 add      r4, r2, r3
a0391bc8 b631dde1 ldrh     r3, [sp, #0x16]
a0391bcc 18209de5 ldr      r2, [sp, #0x18]
a0391bd0 920302e0 mul      r2, r2, r3
a0391bd4 1c309de5 ldr      r3, [sp, #0x1c]
a0391bd8 032082e0 add      r2, r2, r3
a0391bdc 283702e3 movw     r3, #0x2728
a0391be0 70314ae3 movt     r3, #0xa170
a0391be4 8220a0e1 lsl      r2, r2, #1
a0391be8 023083e0 add      r3, r3, r2
a0391bec b030d3e1 ldrh     r3, [r3]
a0391bf0 7320bfe6 sxth     r2, r3
a0391bf4 f232dde1 ldrsh    r3, [sp, #0x22]
a0391bf8 011083e2 add      r1, r3, #1
a0391bfc c63c01e3 movw     r3, #0x1cc6
a0391c00 70304ae3 movt     r3, #0xa070
a0391c04 b030d3e1 ldrh     r3, [r3]
a0391c08 7330bfe6 sxth     r3, r3
a0391c0c 930101e0 mul      r1, r3, r1
a0391c10 6c3b0ae3 movw     r3, #0xab6c
a0391c14 70314ae3 movt     r3, #0xa170
a0391c18 b030d3e1 ldrh     r3, [r3]
a0391c1c 7330bfe6 sxth     r3, r3
a0391c20 013063e0 rsb      r3, r3, r1
a0391c24 930202e0 mul      r2, r3, r2
a0391c28 b631dde1 ldrh     r3, [sp, #0x16]
a0391c2c 18109de5 ldr      r1, [sp, #0x18]
a0391c30 910301e0 mul      r1, r1, r3
a0391c34 1c309de5 ldr      r3, [sp, #0x1c]
a0391c38 031081e0 add      r1, r1, r3
a0391c3c ac3902e3 movw     r3, #0x29ac
a0391c40 70314ae3 movt     r3, #0xa170
a0391c44 8110a0e1 lsl      r1, r1, #1
a0391c48 013083e0 add      r3, r3, r1
a0391c4c b030d3e1 ldrh     r3, [r3]
a0391c50 7310bfe6 sxth     r1, r3
a0391c54 6c3b0ae3 movw     r3, #0xab6c
a0391c58 70314ae3 movt     r3, #0xa170
a0391c5c b030d3e1 ldrh     r3, [r3]
a0391c60 7300bfe6 sxth     r0, r3
a0391c64 f2c2dde1 ldrsh    ip, [sp, #0x22]
a0391c68 c63c01e3 movw     r3, #0x1cc6
a0391c6c 70304ae3 movt     r3, #0xa070
a0391c70 b030d3e1 ldrh     r3, [r3]
a0391c74 7330bfe6 sxth     r3, r3
a0391c78 930c03e0 mul      r3, r3, ip
a0391c7c 003063e0 rsb      r3, r3, r0
a0391c80 930103e0 mul      r3, r3, r1
a0391c84 032082e0 add      r2, r2, r3
a0391c88 c63c01e3 movw     r3, #0x1cc6
a0391c8c 70304ae3 movt     r3, #0xa070
a0391c90 b030d3e1 ldrh     r3, [r3]
a0391c94 7330bfe6 sxth     r3, r3
a0391c98 0200a0e1 mov      r0, r2
a0391c9c 0310a0e1 mov      r1, r3
a0391ca0 7ad205fa blx      #0xa0506690
a0391ca4 0030a0e1 mov      r3, r0
a0391ca8 7330ffe6 uxth     r3, r3
a0391cac b230c4e1 strh     r3, [r4, #2]
a0391cb0 1c309de5 ldr      r3, [sp, #0x1c]
a0391cb4 013083e2 add      r3, r3, #1
a0391cb8 1c308de5 str      r3, [sp, #0x1c]
a0391cbc b621dde1 ldrh     r2, [sp, #0x16]
a0391cc0 1c309de5 ldr      r3, [sp, #0x1c]
a0391cc4 030052e1 cmp      r2, r3
a0391cc8 74ffffca bgt      #0xa0391aa0
a0391ccc 18309de5 ldr      r3, [sp, #0x18]
a0391cd0 013083e2 add      r3, r3, #1
a0391cd4 18308de5 str      r3, [sp, #0x18]
a0391cd8 b421dde1 ldrh     r2, [sp, #0x14]
a0391cdc 18309de5 ldr      r3, [sp, #0x18]
a0391ce0 030052e1 cmp      r2, r3
a0391ce4 6affffca bgt      #0xa0391a94
a0391ce8 28d08de2 add      sp, sp, #0x28
a0391cec 1080bde8 pop      {r4, pc}
a0391cf0 04e02de5 str      lr, [sp, #-4]!
a0391cf4 6cd04de2 sub      sp, sp, #0x6c
a0391cf8 04008de5 str      r0, [sp, #4]
a0391cfc 403604e3 movw     r3, #0x4640
a0391d00 70314ae3 movt     r3, #0xa170
a0391d04 0c3093e5 ldr      r3, [r3, #0xc]
a0391d08 40308de5 str      r3, [sp, #0x40]
a0391d0c 403604e3 movw     r3, #0x4640
a0391d10 70314ae3 movt     r3, #0xa170
a0391d14 103093e5 ldr      r3, [r3, #0x10]
a0391d18 3c308de5 str      r3, [sp, #0x3c]
a0391d1c c83a07e3 movw     r3, #0x7ac8
a0391d20 75304ae3 movt     r3, #0xa075
a0391d24 0030d3e5 ldrb     r3, [r3]
a0391d28 010053e3 cmp      r3, #1
a0391d2c 2800008a bhi      #0xa0391dd4
a0391d30 283b0ae3 movw     r3, #0xab28
a0391d34 70314ae3 movt     r3, #0xa170
a0391d38 002093e5 ldr      r2, [r3]
a0391d3c c03004e3 movw     r3, #0x40c0
a0391d40 70314ae3 movt     r3, #0xa170
a0391d44 003093e5 ldr      r3, [r3]
a0391d48 032082e0 add      r2, r2, r3
a0391d4c c03c02e3 movw     r3, #0x2cc0
a0391d50 70314ae3 movt     r3, #0xa170
a0391d54 1430d3e5 ldrb     r3, [r3, #0x14]
a0391d58 7330afe6 sxtb     r3, r3
a0391d5c 032082e0 add      r2, r2, r3
a0391d60 b03a07e3 movw     r3, #0x7ab0
a0391d64 75304ae3 movt     r3, #0xa075
a0391d68 0030d3e5 ldrb     r3, [r3]
a0391d6c 7330afe6 sxtb     r3, r3
a0391d70 033082e0 add      r3, r2, r3
a0391d74 44308de5 str      r3, [sp, #0x44]
a0391d78 203b0ae3 movw     r3, #0xab20
a0391d7c 70314ae3 movt     r3, #0xa170
a0391d80 b030d3e1 ldrh     r3, [r3]
a0391d84 013083e2 add      r3, r3, #1
a0391d88 c330a0e1 asr      r3, r3, #1
a0391d8c 44209de5 ldr      r2, [sp, #0x44]
a0391d90 023063e0 rsb      r3, r3, r2
a0391d94 44308de5 str      r3, [sp, #0x44]
a0391d98 503c02e3 movw     r3, #0x2c50
a0391d9c 70314ae3 movt     r3, #0xa170
a0391da0 0030d3e5 ldrb     r3, [r3]
a0391da4 0320a0e1 mov      r2, r3
a0391da8 44309de5 ldr      r3, [sp, #0x44]
a0391dac 033062e0 rsb      r3, r2, r3
a0391db0 44308de5 str      r3, [sp, #0x44]
a0391db4 e83504e3 movw     r3, #0x45e8
a0391db8 70314ae3 movt     r3, #0xa170
a0391dbc 0030d3e5 ldrb     r3, [r3]
a0391dc0 7330afe6 sxtb     r3, r3
a0391dc4 44209de5 ldr      r2, [sp, #0x44]
a0391dc8 033082e0 add      r3, r2, r3
a0391dcc 44308de5 str      r3, [sp, #0x44]
a0391dd0 200000ea b        #0xa0391e58
a0391dd4 2c3b0ae3 movw     r3, #0xab2c
a0391dd8 70314ae3 movt     r3, #0xa170
a0391ddc 002093e5 ldr      r2, [r3]
a0391de0 c03004e3 movw     r3, #0x40c0
a0391de4 70314ae3 movt     r3, #0xa170
a0391de8 003093e5 ldr      r3, [r3]
a0391dec 032082e0 add      r2, r2, r3
a0391df0 c03c02e3 movw     r3, #0x2cc0
a0391df4 70314ae3 movt     r3, #0xa170
a0391df8 1430d3e5 ldrb     r3, [r3, #0x14]
a0391dfc 7330afe6 sxtb     r3, r3
a0391e00 032082e0 add      r2, r2, r3
a0391e04 b03a07e3 movw     r3, #0x7ab0
a0391e08 75304ae3 movt     r3, #0xa075
a0391e0c 0030d3e5 ldrb     r3, [r3]
a0391e10 7330afe6 sxtb     r3, r3
a0391e14 033082e0 add      r3, r2, r3
a0391e18 44308de5 str      r3, [sp, #0x44]
a0391e1c 203b0ae3 movw     r3, #0xab20
a0391e20 70314ae3 movt     r3, #0xa170
a0391e24 b030d3e1 ldrh     r3, [r3]
a0391e28 013083e2 add      r3, r3, #1
a0391e2c c330a0e1 asr      r3, r3, #1
a0391e30 44209de5 ldr      r2, [sp, #0x44]
a0391e34 023063e0 rsb      r3, r3, r2
a0391e38 44308de5 str      r3, [sp, #0x44]
a0391e3c e83504e3 movw     r3, #0x45e8
a0391e40 70314ae3 movt     r3, #0xa170
a0391e44 0030d3e5 ldrb     r3, [r3]
a0391e48 7330afe6 sxtb     r3, r3
a0391e4c 44209de5 ldr      r2, [sp, #0x44]
a0391e50 033082e0 add      r3, r2, r3
a0391e54 44308de5 str      r3, [sp, #0x44]
a0391e58 043304e3 movw     r3, #0x4304
a0391e5c 70314ae3 movt     r3, #0xa170
a0391e60 002093e5 ldr      r2, [r3]
a0391e64 a43e0ae3 movw     r3, #0xaea4
a0391e68 70314ae3 movt     r3, #0xa170
a0391e6c 003093e5 ldr      r3, [r3]
a0391e70 022063e0 rsb      r2, r3, r2
a0391e74 c03004e3 movw     r3, #0x40c0
a0391e78 70314ae3 movt     r3, #0xa170
a0391e7c 003093e5 ldr      r3, [r3]
a0391e80 023063e0 rsb      r3, r3, r2
a0391e84 38308de5 str      r3, [sp, #0x38]
a0391e88 503c02e3 movw     r3, #0x2c50
a0391e8c 70314ae3 movt     r3, #0xa170
a0391e90 0030d3e5 ldrb     r3, [r3]
a0391e94 000053e3 cmp      r3, #0
a0391e98 8103000a beq      #0xa0392ca4
a0391e9c 503c02e3 movw     r3, #0x2c50
a0391ea0 70314ae3 movt     r3, #0xa170
a0391ea4 0030d3e5 ldrb     r3, [r3]
a0391ea8 0320a0e1 mov      r2, r3
a0391eac 38309de5 ldr      r3, [sp, #0x38]
a0391eb0 030052e1 cmp      r2, r3
a0391eb4 7a03003a blo      #0xa0392ca4
a0391eb8 ec3e0ae3 movw     r3, #0xaeec
a0391ebc 70314ae3 movt     r3, #0xa170
a0391ec0 003093e5 ldr      r3, [r3]
a0391ec4 0320a0e1 mov      r2, r3
a0391ec8 38309de5 ldr      r3, [sp, #0x38]
a0391ecc 023083e0 add      r3, r3, r2
a0391ed0 38308de5 str      r3, [sp, #0x38]
a0391ed4 0030a0e3 mov      r3, #0
a0391ed8 50308de5 str      r3, [sp, #0x50]
a0391edc f03f0ae3 movw     r3, #0xaff0
a0391ee0 70314ae3 movt     r3, #0xa170
a0391ee4 0020a0e3 mov      r2, #0
a0391ee8 002083e5 str      r2, [r3]
a0391eec 0130a0e3 mov      r3, #1
a0391ef0 60308de5 str      r3, [sp, #0x60]
a0391ef4 9c0000ea b        #0xa039216c
a0391ef8 60309de5 ldr      r3, [sp, #0x60]
a0391efc 012043e2 sub      r2, r3, #1
a0391f00 44309de5 ldr      r3, [sp, #0x44]
a0391f04 033082e0 add      r3, r2, r3
a0391f08 58308de5 str      r3, [sp, #0x58]
a0391f0c 58309de5 ldr      r3, [sp, #0x58]
a0391f10 000053e3 cmp      r3, #0
a0391f14 050000aa bge      #0xa0391f30
a0391f18 003d02e3 movw     r3, #0x2d00
a0391f1c 70314ae3 movt     r3, #0xa170
a0391f20 102293e5 ldr      r2, [r3, #0x210]
a0391f24 58309de5 ldr      r3, [sp, #0x58]
a0391f28 033082e0 add      r3, r2, r3
a0391f2c 58308de5 str      r3, [sp, #0x58]
a0391f30 58209de5 ldr      r2, [sp, #0x58]
a0391f34 003d02e3 movw     r3, #0x2d00
a0391f38 70314ae3 movt     r3, #0xa170
a0391f3c 103293e5 ldr      r3, [r3, #0x210]
a0391f40 013043e2 sub      r3, r3, #1
a0391f44 030052e1 cmp      r2, r3
a0391f48 0500009a bls      #0xa0391f64
a0391f4c 58209de5 ldr      r2, [sp, #0x58]
a0391f50 003d02e3 movw     r3, #0x2d00
a0391f54 70314ae3 movt     r3, #0xa170
a0391f58 103293e5 ldr      r3, [r3, #0x210]
a0391f5c 023063e0 rsb      r3, r3, r2
a0391f60 58308de5 str      r3, [sp, #0x58]
a0391f64 60309de5 ldr      r3, [sp, #0x60]
a0391f68 010053e3 cmp      r3, #1
a0391f6c 0300001a bne      #0xa0391f80
a0391f70 58209de5 ldr      r2, [sp, #0x58]
a0391f74 b03e0ae3 movw     r3, #0xaeb0
a0391f78 70314ae3 movt     r3, #0xa170
a0391f7c 002083e5 str      r2, [r3]
a0391f80 60209de5 ldr      r2, [sp, #0x60]
a0391f84 38309de5 ldr      r3, [sp, #0x38]
a0391f88 030052e1 cmp      r2, r3
a0391f8c 0300001a bne      #0xa0391fa0
a0391f90 58209de5 ldr      r2, [sp, #0x58]
a0391f94 b43e0ae3 movw     r3, #0xaeb4
a0391f98 70314ae3 movt     r3, #0xa170
a0391f9c 002083e5 str      r2, [r3]
a0391fa0 003d02e3 movw     r3, #0x2d00
a0391fa4 70314ae3 movt     r3, #0xa170
a0391fa8 58209de5 ldr      r2, [sp, #0x58]
a0391fac 021193e7 ldr      r1, [r3, r2, lsl #2]
a0391fb0 002d02e3 movw     r2, #0x2d00
a0391fb4 70214ae3 movt     r2, #0xa170
a0391fb8 58309de5 ldr      r3, [sp, #0x58]
a0391fbc 663f83e2 add      r3, r3, #0x198
a0391fc0 033083e2 add      r3, r3, #3
a0391fc4 033192e7 ldr      r3, [r2, r3, lsl #2]
a0391fc8 013063e0 rsb      r3, r3, r1
a0391fcc 34308de5 str      r3, [sp, #0x34]
a0391fd0 50209de5 ldr      r2, [sp, #0x50]
a0391fd4 34309de5 ldr      r3, [sp, #0x34]
a0391fd8 033082e0 add      r3, r2, r3
a0391fdc 50308de5 str      r3, [sp, #0x50]
a0391fe0 50309de5 ldr      r3, [sp, #0x50]
a0391fe4 000053e3 cmp      r3, #0
a0391fe8 020000aa bge      #0xa0391ff8
a0391fec 50309de5 ldr      r3, [sp, #0x50]
a0391ff0 4c308de5 str      r3, [sp, #0x4c]
a0391ff4 010000ea b        #0xa0392000
a0391ff8 50309de5 ldr      r3, [sp, #0x50]
a0391ffc 4c308de5 str      r3, [sp, #0x4c]
a0392000 4c309de5 ldr      r3, [sp, #0x4c]
a0392004 000053e3 cmp      r3, #0
a0392008 020000ba blt      #0xa0392018
a039200c 0130a0e3 mov      r3, #1
a0392010 4b30cde5 strb     r3, [sp, #0x4b]
a0392014 040000ea b        #0xa039202c
a0392018 0030e0e3 mvn      r3, #0
a039201c 4b30cde5 strb     r3, [sp, #0x4b]
a0392020 4c309de5 ldr      r3, [sp, #0x4c]
a0392024 003063e2 rsb      r3, r3, #0
a0392028 4c308de5 str      r3, [sp, #0x4c]
a039202c 0000a0e3 mov      r0, #0
a0392030 4c109de5 ldr      r1, [sp, #0x4c]
a0392034 012ca0e3 mov      r2, #0x100
a0392038 26a7ffeb bl       #0xa037bcd8
a039203c 0020a0e1 mov      r2, r0
a0392040 d83204e3 movw     r3, #0x42d8
a0392044 70314ae3 movt     r3, #0xa170
a0392048 002083e5 str      r2, [r3]
a039204c db34dde1 ldrsb    r3, [sp, #0x4b]
a0392050 010073e3 cmn      r3, #1
a0392054 0600001a bne      #0xa0392074
a0392058 d83204e3 movw     r3, #0x42d8
a039205c 70314ae3 movt     r3, #0xa170
a0392060 003093e5 ldr      r3, [r3]
a0392064 002063e2 rsb      r2, r3, #0
a0392068 d83204e3 movw     r3, #0x42d8
a039206c 70314ae3 movt     r3, #0xa170
a0392070 002083e5 str      r2, [r3]
a0392074 d83204e3 movw     r3, #0x42d8
a0392078 70314ae3 movt     r3, #0xa170
a039207c 002093e5 ldr      r2, [r3]
a0392080 863a07e3 movw     r3, #0x7a86
a0392084 75304ae3 movt     r3, #0xa075
a0392088 0030d3e5 ldrb     r3, [r3]
a039208c 7330afe6 sxtb     r3, r3
a0392090 930201e0 mul      r1, r3, r2
a0392094 1f3508e3 movw     r3, #0x851f
a0392098 eb3145e3 movt     r3, #0x51eb
a039209c 9123c3e0 smull    r2, r3, r1, r3
a03920a0 c322a0e1 asr      r2, r3, #5
a03920a4 c13fa0e1 asr      r3, r1, #0x1f
a03920a8 022063e0 rsb      r2, r3, r2
a03920ac d83204e3 movw     r3, #0x42d8
a03920b0 70314ae3 movt     r3, #0xa170
a03920b4 002083e5 str      r2, [r3]
a03920b8 d83204e3 movw     r3, #0x42d8
a03920bc 70314ae3 movt     r3, #0xa170
a03920c0 003093e5 ldr      r3, [r3]
a03920c4 0314a0e1 lsl      r1, r3, #8
a03920c8 f03f0ae3 movw     r3, #0xaff0
a03920cc 70314ae3 movt     r3, #0xa170
a03920d0 60209de5 ldr      r2, [sp, #0x60]
a03920d4 021183e7 str      r1, [r3, r2, lsl #2]
a03920d8 263204e3 movw     r3, #0x4226
a03920dc 70314ae3 movt     r3, #0xa170
a03920e0 0030d3e5 ldrb     r3, [r3]
a03920e4 ff0053e3 cmp      r3, #0xff
a03920e8 1000001a bne      #0xa0392130
a03920ec f03f0ae3 movw     r3, #0xaff0
a03920f0 70314ae3 movt     r3, #0xa170
a03920f4 60209de5 ldr      r2, [sp, #0x60]
a03920f8 022193e7 ldr      r2, [r3, r2, lsl #2]
a03920fc 243204e3 movw     r3, #0x4224
a0392100 70314ae3 movt     r3, #0xa170
a0392104 0030d3e5 ldrb     r3, [r3]
a0392108 0200a0e1 mov      r0, r2
a039210c 0310a0e1 mov      r1, r3
a0392110 5ed105fa blx      #0xa0506690
a0392114 0030a0e1 mov      r3, r0
a0392118 0310a0e1 mov      r1, r3
a039211c f03f0ae3 movw     r3, #0xaff0
a0392120 70314ae3 movt     r3, #0xa170
a0392124 60209de5 ldr      r2, [sp, #0x60]
a0392128 021183e7 str      r1, [r3, r2, lsl #2]
a039212c 0b0000ea b        #0xa0392160
a0392130 f03f0ae3 movw     r3, #0xaff0
a0392134 70314ae3 movt     r3, #0xa170
a0392138 60209de5 ldr      r2, [sp, #0x60]
a039213c 022193e7 ldr      r2, [r3, r2, lsl #2]
a0392140 263204e3 movw     r3, #0x4226
a0392144 70314ae3 movt     r3, #0xa170
a0392148 0030d3e5 ldrb     r3, [r3]
a039214c 5213a0e1 asr      r1, r2, r3
a0392150 f03f0ae3 movw     r3, #0xaff0
a0392154 70314ae3 movt     r3, #0xa170
a0392158 60209de5 ldr      r2, [sp, #0x60]
a039215c 021183e7 str      r1, [r3, r2, lsl #2]
a0392160 60309de5 ldr      r3, [sp, #0x60]
a0392164 013083e2 add      r3, r3, #1
a0392168 60308de5 str      r3, [sp, #0x60]
a039216c 60209de5 ldr      r2, [sp, #0x60]
a0392170 38309de5 ldr      r3, [sp, #0x38]
a0392174 013083e2 add      r3, r3, #1
a0392178 030052e1 cmp      r2, r3
a039217c 5dffff3a blo      #0xa0391ef8
a0392180 38309de5 ldr      r3, [sp, #0x38]
a0392184 013083e2 add      r3, r3, #1
a0392188 5c308de5 str      r3, [sp, #0x5c]
a039218c 0a0000ea b        #0xa03921bc
a0392190 f03f0ae3 movw     r3, #0xaff0
a0392194 70314ae3 movt     r3, #0xa170
a0392198 38209de5 ldr      r2, [sp, #0x38]
a039219c 021193e7 ldr      r1, [r3, r2, lsl #2]
a03921a0 f03f0ae3 movw     r3, #0xaff0
a03921a4 70314ae3 movt     r3, #0xa170
a03921a8 5c209de5 ldr      r2, [sp, #0x5c]
a03921ac 021183e7 str      r1, [r3, r2, lsl #2]
a03921b0 5c309de5 ldr      r3, [sp, #0x5c]
a03921b4 013083e2 add      r3, r3, #1
a03921b8 5c308de5 str      r3, [sp, #0x5c]
a03921bc 5c309de5 ldr      r3, [sp, #0x5c]
a03921c0 630053e3 cmp      r3, #0x63
a03921c4 f1ffffda ble      #0xa0392190
a03921c8 c03c02e3 movw     r3, #0x2cc0
a03921cc 70314ae3 movt     r3, #0xa170
a03921d0 0b30d3e5 ldrb     r3, [r3, #0xb]
a03921d4 7330afe6 sxtb     r3, r3
a03921d8 010073e3 cmn      r3, #1
a03921dc 1100001a bne      #0xa0392228
a03921e0 0030a0e3 mov      r3, #0
a03921e4 5c308de5 str      r3, [sp, #0x5c]
a03921e8 0b0000ea b        #0xa039221c
a03921ec f03f0ae3 movw     r3, #0xaff0
a03921f0 70314ae3 movt     r3, #0xa170
a03921f4 5c209de5 ldr      r2, [sp, #0x5c]
a03921f8 023193e7 ldr      r3, [r3, r2, lsl #2]
a03921fc 001063e2 rsb      r1, r3, #0
a0392200 f03f0ae3 movw     r3, #0xaff0
a0392204 70314ae3 movt     r3, #0xa170
a0392208 5c209de5 ldr      r2, [sp, #0x5c]
a039220c 021183e7 str      r1, [r3, r2, lsl #2]
a0392210 5c309de5 ldr      r3, [sp, #0x5c]
a0392214 013083e2 add      r3, r3, #1
a0392218 5c308de5 str      r3, [sp, #0x5c]
a039221c 5c309de5 ldr      r3, [sp, #0x5c]
a0392220 630053e3 cmp      r3, #0x63
a0392224 f0ffffda ble      #0xa03921ec
a0392228 0030a0e3 mov      r3, #0
a039222c 50308de5 str      r3, [sp, #0x50]
a0392230 80310be3 movw     r3, #0xb180
a0392234 70314ae3 movt     r3, #0xa170
a0392238 0020a0e3 mov      r2, #0
a039223c 002083e5 str      r2, [r3]
a0392240 0130a0e3 mov      r3, #1
a0392244 60308de5 str      r3, [sp, #0x60]
a0392248 8d0000ea b        #0xa0392484
a039224c 60309de5 ldr      r3, [sp, #0x60]
a0392250 012043e2 sub      r2, r3, #1
a0392254 44309de5 ldr      r3, [sp, #0x44]
a0392258 033082e0 add      r3, r2, r3
a039225c 54308de5 str      r3, [sp, #0x54]
a0392260 54309de5 ldr      r3, [sp, #0x54]
a0392264 000053e3 cmp      r3, #0
a0392268 050000aa bge      #0xa0392284
a039226c 003d02e3 movw     r3, #0x2d00
a0392270 70314ae3 movt     r3, #0xa170
a0392274 102293e5 ldr      r2, [r3, #0x210]
a0392278 54309de5 ldr      r3, [sp, #0x54]
a039227c 033082e0 add      r3, r2, r3
a0392280 54308de5 str      r3, [sp, #0x54]
a0392284 54209de5 ldr      r2, [sp, #0x54]
a0392288 003d02e3 movw     r3, #0x2d00
a039228c 70314ae3 movt     r3, #0xa170
a0392290 103293e5 ldr      r3, [r3, #0x210]
a0392294 013043e2 sub      r3, r3, #1
a0392298 030052e1 cmp      r2, r3
a039229c 0500009a bls      #0xa03922b8
a03922a0 54209de5 ldr      r2, [sp, #0x54]
a03922a4 003d02e3 movw     r3, #0x2d00
a03922a8 70314ae3 movt     r3, #0xa170
a03922ac 103293e5 ldr      r3, [r3, #0x210]
a03922b0 023063e0 rsb      r3, r3, r2
a03922b4 54308de5 str      r3, [sp, #0x54]
a03922b8 003d02e3 movw     r3, #0x2d00
a03922bc 70314ae3 movt     r3, #0xa170
a03922c0 54209de5 ldr      r2, [sp, #0x54]
a03922c4 892082e2 add      r2, r2, #0x89
a03922c8 022193e7 ldr      r2, [r3, r2, lsl #2]
a03922cc 003d02e3 movw     r3, #0x2d00
a03922d0 70314ae3 movt     r3, #0xa170
a03922d4 54109de5 ldr      r1, [sp, #0x54]
a03922d8 891f81e2 add      r1, r1, #0x224
a03922dc 013193e7 ldr      r3, [r3, r1, lsl #2]
a03922e0 023063e0 rsb      r3, r3, r2
a03922e4 34308de5 str      r3, [sp, #0x34]
a03922e8 50209de5 ldr      r2, [sp, #0x50]
a03922ec 34309de5 ldr      r3, [sp, #0x34]
a03922f0 033082e0 add      r3, r2, r3
a03922f4 50308de5 str      r3, [sp, #0x50]
a03922f8 50309de5 ldr      r3, [sp, #0x50]
a03922fc 000053e3 cmp      r3, #0
a0392300 020000aa bge      #0xa0392310
a0392304 50309de5 ldr      r3, [sp, #0x50]
a0392308 4c308de5 str      r3, [sp, #0x4c]
a039230c 010000ea b        #0xa0392318
a0392310 50309de5 ldr      r3, [sp, #0x50]
a0392314 4c308de5 str      r3, [sp, #0x4c]
a0392318 4c309de5 ldr      r3, [sp, #0x4c]
a039231c 000053e3 cmp      r3, #0
a0392320 020000ba blt      #0xa0392330
a0392324 0130a0e3 mov      r3, #1
a0392328 4a30cde5 strb     r3, [sp, #0x4a]
a039232c 040000ea b        #0xa0392344
a0392330 0030e0e3 mvn      r3, #0
a0392334 4a30cde5 strb     r3, [sp, #0x4a]
a0392338 4c309de5 ldr      r3, [sp, #0x4c]
a039233c 003063e2 rsb      r3, r3, #0
a0392340 4c308de5 str      r3, [sp, #0x4c]
a0392344 0100a0e3 mov      r0, #1
a0392348 4c109de5 ldr      r1, [sp, #0x4c]
a039234c 012ca0e3 mov      r2, #0x100
a0392350 60a6ffeb bl       #0xa037bcd8
a0392354 0020a0e1 mov      r2, r0
a0392358 d83204e3 movw     r3, #0x42d8
a039235c 70314ae3 movt     r3, #0xa170
a0392360 042083e5 str      r2, [r3, #4]
a0392364 da34dde1 ldrsb    r3, [sp, #0x4a]
a0392368 010073e3 cmn      r3, #1
a039236c 0600001a bne      #0xa039238c
a0392370 d83204e3 movw     r3, #0x42d8
a0392374 70314ae3 movt     r3, #0xa170
a0392378 043093e5 ldr      r3, [r3, #4]
a039237c 002063e2 rsb      r2, r3, #0
a0392380 d83204e3 movw     r3, #0x42d8
a0392384 70314ae3 movt     r3, #0xa170
a0392388 042083e5 str      r2, [r3, #4]
a039238c d83204e3 movw     r3, #0x42d8
a0392390 70314ae3 movt     r3, #0xa170
a0392394 042093e5 ldr      r2, [r3, #4]
a0392398 873a07e3 movw     r3, #0x7a87
a039239c 75304ae3 movt     r3, #0xa075
a03923a0 0030d3e5 ldrb     r3, [r3]
a03923a4 7330afe6 sxtb     r3, r3
a03923a8 930201e0 mul      r1, r3, r2
a03923ac 1f3508e3 movw     r3, #0x851f
a03923b0 eb3145e3 movt     r3, #0x51eb
a03923b4 9123c3e0 smull    r2, r3, r1, r3
a03923b8 c322a0e1 asr      r2, r3, #5
a03923bc c13fa0e1 asr      r3, r1, #0x1f
a03923c0 022063e0 rsb      r2, r3, r2
a03923c4 d83204e3 movw     r3, #0x42d8
a03923c8 70314ae3 movt     r3, #0xa170
a03923cc 042083e5 str      r2, [r3, #4]
a03923d0 d83204e3 movw     r3, #0x42d8
a03923d4 70314ae3 movt     r3, #0xa170
a03923d8 043093e5 ldr      r3, [r3, #4]
a03923dc 0314a0e1 lsl      r1, r3, #8
a03923e0 80310be3 movw     r3, #0xb180
a03923e4 70314ae3 movt     r3, #0xa170
a03923e8 60209de5 ldr      r2, [sp, #0x60]
a03923ec 021183e7 str      r1, [r3, r2, lsl #2]
a03923f0 273204e3 movw     r3, #0x4227
a03923f4 70314ae3 movt     r3, #0xa170
a03923f8 0030d3e5 ldrb     r3, [r3]
a03923fc ff0053e3 cmp      r3, #0xff
a0392400 1000001a bne      #0xa0392448
a0392404 80310be3 movw     r3, #0xb180
a0392408 70314ae3 movt     r3, #0xa170
a039240c 60209de5 ldr      r2, [sp, #0x60]
a0392410 022193e7 ldr      r2, [r3, r2, lsl #2]
a0392414 253204e3 movw     r3, #0x4225
a0392418 70314ae3 movt     r3, #0xa170
a039241c 0030d3e5 ldrb     r3, [r3]
a0392420 0200a0e1 mov      r0, r2
a0392424 0310a0e1 mov      r1, r3
a0392428 98d005fa blx      #0xa0506690
a039242c 0030a0e1 mov      r3, r0
a0392430 0310a0e1 mov      r1, r3
a0392434 80310be3 movw     r3, #0xb180
a0392438 70314ae3 movt     r3, #0xa170
a039243c 60209de5 ldr      r2, [sp, #0x60]
a0392440 021183e7 str      r1, [r3, r2, lsl #2]
a0392444 0b0000ea b        #0xa0392478
a0392448 80310be3 movw     r3, #0xb180
a039244c 70314ae3 movt     r3, #0xa170
a0392450 60209de5 ldr      r2, [sp, #0x60]
a0392454 022193e7 ldr      r2, [r3, r2, lsl #2]
a0392458 273204e3 movw     r3, #0x4227
a039245c 70314ae3 movt     r3, #0xa170
a0392460 0030d3e5 ldrb     r3, [r3]
a0392464 5213a0e1 asr      r1, r2, r3
a0392468 80310be3 movw     r3, #0xb180
a039246c 70314ae3 movt     r3, #0xa170
a0392470 60209de5 ldr      r2, [sp, #0x60]
a0392474 021183e7 str      r1, [r3, r2, lsl #2]
a0392478 60309de5 ldr      r3, [sp, #0x60]
a039247c 013083e2 add      r3, r3, #1
a0392480 60308de5 str      r3, [sp, #0x60]
a0392484 60209de5 ldr      r2, [sp, #0x60]
a0392488 38309de5 ldr      r3, [sp, #0x38]
a039248c 013083e2 add      r3, r3, #1
a0392490 030052e1 cmp      r2, r3
a0392494 6cffff3a blo      #0xa039224c
a0392498 38309de5 ldr      r3, [sp, #0x38]
a039249c 013083e2 add      r3, r3, #1
a03924a0 5c308de5 str      r3, [sp, #0x5c]
a03924a4 0a0000ea b        #0xa03924d4
a03924a8 80310be3 movw     r3, #0xb180
a03924ac 70314ae3 movt     r3, #0xa170
a03924b0 38209de5 ldr      r2, [sp, #0x38]
a03924b4 021193e7 ldr      r1, [r3, r2, lsl #2]
a03924b8 80310be3 movw     r3, #0xb180
a03924bc 70314ae3 movt     r3, #0xa170
a03924c0 5c209de5 ldr      r2, [sp, #0x5c]
a03924c4 021183e7 str      r1, [r3, r2, lsl #2]
a03924c8 5c309de5 ldr      r3, [sp, #0x5c]
a03924cc 013083e2 add      r3, r3, #1
a03924d0 5c308de5 str      r3, [sp, #0x5c]
a03924d4 5c309de5 ldr      r3, [sp, #0x5c]
a03924d8 630053e3 cmp      r3, #0x63
a03924dc f1ffffda ble      #0xa03924a8
a03924e0 c03c02e3 movw     r3, #0x2cc0
a03924e4 70314ae3 movt     r3, #0xa170
a03924e8 0c30d3e5 ldrb     r3, [r3, #0xc]
a03924ec 7330afe6 sxtb     r3, r3
a03924f0 010073e3 cmn      r3, #1
a03924f4 1100001a bne      #0xa0392540
a03924f8 0030a0e3 mov      r3, #0
a03924fc 5c308de5 str      r3, [sp, #0x5c]
a0392500 0b0000ea b        #0xa0392534
a0392504 80310be3 movw     r3, #0xb180
a0392508 70314ae3 movt     r3, #0xa170
a039250c 5c209de5 ldr      r2, [sp, #0x5c]
a0392510 023193e7 ldr      r3, [r3, r2, lsl #2]
a0392514 001063e2 rsb      r1, r3, #0
a0392518 80310be3 movw     r3, #0xb180
a039251c 70314ae3 movt     r3, #0xa170
a0392520 5c209de5 ldr      r2, [sp, #0x5c]
a0392524 021183e7 str      r1, [r3, r2, lsl #2]
a0392528 5c309de5 ldr      r3, [sp, #0x5c]
a039252c 013083e2 add      r3, r3, #1
a0392530 5c308de5 str      r3, [sp, #0x5c]
a0392534 5c309de5 ldr      r3, [sp, #0x5c]
a0392538 630053e3 cmp      r3, #0x63
a039253c f0ffffda ble      #0xa0392504
a0392540 603204e3 movw     r3, #0x4260
a0392544 70314ae3 movt     r3, #0xa170
a0392548 003093e5 ldr      r3, [r3]
a039254c 0300a0e1 mov      r0, r3
a0392550 38109de5 ldr      r1, [sp, #0x38]
a0392554 afcf05fa blx      #0xa0506418
a0392558 0030a0e1 mov      r3, r0
a039255c 30308de5 str      r3, [sp, #0x30]
a0392560 403604e3 movw     r3, #0x4640
a0392564 70314ae3 movt     r3, #0xa170
a0392568 143093e5 ldr      r3, [r3, #0x14]
a039256c 0120a0e3 mov      r2, #1
a0392570 1233a0e1 lsl      r3, r2, r3
a0392574 2c308de5 str      r3, [sp, #0x2c]
a0392578 403604e3 movw     r3, #0x4640
a039257c 70314ae3 movt     r3, #0xa170
a0392580 183093e5 ldr      r3, [r3, #0x18]
a0392584 0120a0e3 mov      r2, #1
a0392588 1233a0e1 lsl      r3, r2, r3
a039258c 28308de5 str      r3, [sp, #0x28]
a0392590 843b0ae3 movw     r3, #0xab84
a0392594 70314ae3 movt     r3, #0xa170
a0392598 0020a0e3 mov      r2, #0
a039259c 002083e5 str      r2, [r3]
a03925a0 0130a0e3 mov      r3, #1
a03925a4 60308de5 str      r3, [sp, #0x60]
a03925a8 300000ea b        #0xa0392670
a03925ac 60309de5 ldr      r3, [sp, #0x60]
a03925b0 28209de5 ldr      r2, [sp, #0x28]
a03925b4 920303e0 mul      r3, r2, r3
a03925b8 013083e2 add      r3, r3, #1
a03925bc 24308de5 str      r3, [sp, #0x24]
a03925c0 24009de5 ldr      r0, [sp, #0x24]
a03925c4 30109de5 ldr      r1, [sp, #0x30]
a03925c8 92cf05fa blx      #0xa0506418
a03925cc 0030a0e1 mov      r3, r0
a03925d0 20308de5 str      r3, [sp, #0x20]
a03925d4 20309de5 ldr      r3, [sp, #0x20]
a03925d8 013083e2 add      r3, r3, #1
a03925dc 1c308de5 str      r3, [sp, #0x1c]
a03925e0 f03f0ae3 movw     r3, #0xaff0
a03925e4 70314ae3 movt     r3, #0xa170
a03925e8 20209de5 ldr      r2, [sp, #0x20]
a03925ec 023193e7 ldr      r3, [r3, r2, lsl #2]
a03925f0 18308de5 str      r3, [sp, #0x18]
a03925f4 f03f0ae3 movw     r3, #0xaff0
a03925f8 70314ae3 movt     r3, #0xa170
a03925fc 1c209de5 ldr      r2, [sp, #0x1c]
a0392600 023193e7 ldr      r3, [r3, r2, lsl #2]
a0392604 14308de5 str      r3, [sp, #0x14]
a0392608 14209de5 ldr      r2, [sp, #0x14]
a039260c 18309de5 ldr      r3, [sp, #0x18]
a0392610 023063e0 rsb      r3, r3, r2
a0392614 20209de5 ldr      r2, [sp, #0x20]
a0392618 30109de5 ldr      r1, [sp, #0x30]
a039261c 910202e0 mul      r2, r1, r2
a0392620 24109de5 ldr      r1, [sp, #0x24]
a0392624 012062e0 rsb      r2, r2, r1
a0392628 920302e0 mul      r2, r2, r3
a039262c 30309de5 ldr      r3, [sp, #0x30]
a0392630 0200a0e1 mov      r0, r2
a0392634 0310a0e1 mov      r1, r3
a0392638 14d005fa blx      #0xa0506690
a039263c 0030a0e1 mov      r3, r0
a0392640 0320a0e1 mov      r2, r3
a0392644 18309de5 ldr      r3, [sp, #0x18]
a0392648 033082e0 add      r3, r2, r3
a039264c 10308de5 str      r3, [sp, #0x10]
a0392650 843b0ae3 movw     r3, #0xab84
a0392654 70314ae3 movt     r3, #0xa170
a0392658 60209de5 ldr      r2, [sp, #0x60]
a039265c 10109de5 ldr      r1, [sp, #0x10]
a0392660 021183e7 str      r1, [r3, r2, lsl #2]
a0392664 60309de5 ldr      r3, [sp, #0x60]
a0392668 013083e2 add      r3, r3, #1
a039266c 60308de5 str      r3, [sp, #0x60]
a0392670 60209de5 ldr      r2, [sp, #0x60]
a0392674 3c309de5 ldr      r3, [sp, #0x3c]
a0392678 030052e1 cmp      r2, r3
a039267c caffffba blt      #0xa03925ac
a0392680 143d0ae3 movw     r3, #0xad14
a0392684 70314ae3 movt     r3, #0xa170
a0392688 0020a0e3 mov      r2, #0
a039268c 002083e5 str      r2, [r3]
a0392690 0130a0e3 mov      r3, #1
a0392694 60308de5 str      r3, [sp, #0x60]
a0392698 300000ea b        #0xa0392760
a039269c 60309de5 ldr      r3, [sp, #0x60]
a03926a0 28209de5 ldr      r2, [sp, #0x28]
a03926a4 920303e0 mul      r3, r2, r3
a03926a8 013083e2 add      r3, r3, #1
a03926ac 24308de5 str      r3, [sp, #0x24]
a03926b0 24009de5 ldr      r0, [sp, #0x24]
a03926b4 30109de5 ldr      r1, [sp, #0x30]
a03926b8 56cf05fa blx      #0xa0506418
a03926bc 0030a0e1 mov      r3, r0
a03926c0 20308de5 str      r3, [sp, #0x20]
a03926c4 20309de5 ldr      r3, [sp, #0x20]
a03926c8 013083e2 add      r3, r3, #1
a03926cc 1c308de5 str      r3, [sp, #0x1c]
a03926d0 80310be3 movw     r3, #0xb180
a03926d4 70314ae3 movt     r3, #0xa170
a03926d8 20209de5 ldr      r2, [sp, #0x20]
a03926dc 023193e7 ldr      r3, [r3, r2, lsl #2]
a03926e0 18308de5 str      r3, [sp, #0x18]
a03926e4 80310be3 movw     r3, #0xb180
a03926e8 70314ae3 movt     r3, #0xa170
a03926ec 1c209de5 ldr      r2, [sp, #0x1c]
a03926f0 023193e7 ldr      r3, [r3, r2, lsl #2]
a03926f4 14308de5 str      r3, [sp, #0x14]
a03926f8 14209de5 ldr      r2, [sp, #0x14]
a03926fc 18309de5 ldr      r3, [sp, #0x18]
a0392700 023063e0 rsb      r3, r3, r2
a0392704 20209de5 ldr      r2, [sp, #0x20]
a0392708 30109de5 ldr      r1, [sp, #0x30]
a039270c 910202e0 mul      r2, r1, r2
a0392710 24109de5 ldr      r1, [sp, #0x24]
a0392714 012062e0 rsb      r2, r2, r1
a0392718 920302e0 mul      r2, r2, r3
a039271c 30309de5 ldr      r3, [sp, #0x30]
a0392720 0200a0e1 mov      r0, r2
a0392724 0310a0e1 mov      r1, r3
a0392728 d8cf05fa blx      #0xa0506690
a039272c 0030a0e1 mov      r3, r0
a0392730 0320a0e1 mov      r2, r3
a0392734 18309de5 ldr      r3, [sp, #0x18]
a0392738 033082e0 add      r3, r2, r3
a039273c 0c308de5 str      r3, [sp, #0xc]
a0392740 143d0ae3 movw     r3, #0xad14
a0392744 70314ae3 movt     r3, #0xa170
a0392748 60209de5 ldr      r2, [sp, #0x60]
a039274c 0c109de5 ldr      r1, [sp, #0xc]
a0392750 021183e7 str      r1, [r3, r2, lsl #2]
a0392754 60309de5 ldr      r3, [sp, #0x60]
a0392758 013083e2 add      r3, r3, #1
a039275c 60308de5 str      r3, [sp, #0x60]
a0392760 60209de5 ldr      r2, [sp, #0x60]
a0392764 3c309de5 ldr      r3, [sp, #0x3c]
a0392768 030052e1 cmp      r2, r3
a039276c caffffba blt      #0xa039269c
a0392770 a03204e3 movw     r3, #0x42a0
a0392774 70314ae3 movt     r3, #0xa170
a0392778 003093e5 ldr      r3, [r3]
a039277c 4324a0e1 asr      r2, r3, #8
a0392780 2c3a0be3 movw     r3, #0xba2c
a0392784 70314ae3 movt     r3, #0xa170
a0392788 002083e5 str      r2, [r3]
a039278c 2c3a0be3 movw     r3, #0xba2c
a0392790 70314ae3 movt     r3, #0xa170
a0392794 003093e5 ldr      r3, [r3]
a0392798 000053e3 cmp      r3, #0
a039279c 180000ba blt      #0xa0392804
a03927a0 b03204e3 movw     r3, #0x42b0
a03927a4 70314ae3 movt     r3, #0xa170
a03927a8 002093e5 ldr      r2, [r3]
a03927ac c03204e3 movw     r3, #0x42c0
a03927b0 70314ae3 movt     r3, #0xa170
a03927b4 003093e5 ldr      r3, [r3]
a03927b8 032082e0 add      r2, r2, r3
a03927bc 2c3a0be3 movw     r3, #0xba2c
a03927c0 70314ae3 movt     r3, #0xa170
a03927c4 003093e5 ldr      r3, [r3]
a03927c8 022063e0 rsb      r2, r3, r2
a03927cc 343a0be3 movw     r3, #0xba34
a03927d0 70314ae3 movt     r3, #0xa170
a03927d4 002083e5 str      r2, [r3]
a03927d8 b83204e3 movw     r3, #0x42b8
a03927dc 70314ae3 movt     r3, #0xa170
a03927e0 002093e5 ldr      r2, [r3]
a03927e4 c83204e3 movw     r3, #0x42c8
a03927e8 70314ae3 movt     r3, #0xa170
a03927ec 003093e5 ldr      r3, [r3]
a03927f0 032082e0 add      r2, r2, r3
a03927f4 3c3a0be3 movw     r3, #0xba3c
a03927f8 70314ae3 movt     r3, #0xa170
a03927fc 002083e5 str      r2, [r3]
a0392800 170000ea b        #0xa0392864
a0392804 b03204e3 movw     r3, #0x42b0
a0392808 70314ae3 movt     r3, #0xa170
a039280c 002093e5 ldr      r2, [r3]
a0392810 c03204e3 movw     r3, #0x42c0
a0392814 70314ae3 movt     r3, #0xa170
a0392818 003093e5 ldr      r3, [r3]
a039281c 032082e0 add      r2, r2, r3
a0392820 343a0be3 movw     r3, #0xba34
a0392824 70314ae3 movt     r3, #0xa170
a0392828 002083e5 str      r2, [r3]
a039282c b83204e3 movw     r3, #0x42b8
a0392830 70314ae3 movt     r3, #0xa170
a0392834 002093e5 ldr      r2, [r3]
a0392838 c83204e3 movw     r3, #0x42c8
a039283c 70314ae3 movt     r3, #0xa170
a0392840 003093e5 ldr      r3, [r3]
a0392844 032082e0 add      r2, r2, r3
a0392848 2c3a0be3 movw     r3, #0xba2c
a039284c 70314ae3 movt     r3, #0xa170
a0392850 003093e5 ldr      r3, [r3]
a0392854 032082e0 add      r2, r2, r3
a0392858 3c3a0be3 movw     r3, #0xba3c
a039285c 70314ae3 movt     r3, #0xa170
a0392860 002083e5 str      r2, [r3]
a0392864 0130a0e3 mov      r3, #1
a0392868 60308de5 str      r3, [sp, #0x60]
a039286c 290000ea b        #0xa0392918
a0392870 843b0ae3 movw     r3, #0xab84
a0392874 70314ae3 movt     r3, #0xa170
a0392878 60209de5 ldr      r2, [sp, #0x60]
a039287c 023193e7 ldr      r3, [r3, r2, lsl #2]
a0392880 4324a0e1 asr      r2, r3, #8
a0392884 343a0be3 movw     r3, #0xba34
a0392888 70314ae3 movt     r3, #0xa170
a039288c 003093e5 ldr      r3, [r3]
a0392890 030052e1 cmp      r2, r3
a0392894 080000da ble      #0xa03928bc
a0392898 343a0be3 movw     r3, #0xba34
a039289c 70314ae3 movt     r3, #0xa170
a03928a0 003093e5 ldr      r3, [r3]
a03928a4 0314a0e1 lsl      r1, r3, #8
a03928a8 843b0ae3 movw     r3, #0xab84
a03928ac 70314ae3 movt     r3, #0xa170
a03928b0 60209de5 ldr      r2, [sp, #0x60]
a03928b4 021183e7 str      r1, [r3, r2, lsl #2]
a03928b8 130000ea b        #0xa039290c
a03928bc 843b0ae3 movw     r3, #0xab84
a03928c0 70314ae3 movt     r3, #0xa170
a03928c4 60209de5 ldr      r2, [sp, #0x60]
a03928c8 023193e7 ldr      r3, [r3, r2, lsl #2]
a03928cc 4324a0e1 asr      r2, r3, #8
a03928d0 3c3a0be3 movw     r3, #0xba3c
a03928d4 70314ae3 movt     r3, #0xa170
a03928d8 003093e5 ldr      r3, [r3]
a03928dc 003063e2 rsb      r3, r3, #0
a03928e0 030052e1 cmp      r2, r3
a03928e4 080000aa bge      #0xa039290c
a03928e8 3c3a0be3 movw     r3, #0xba3c
a03928ec 70314ae3 movt     r3, #0xa170
a03928f0 003093e5 ldr      r3, [r3]
a03928f4 003063e2 rsb      r3, r3, #0
a03928f8 0314a0e1 lsl      r1, r3, #8
a03928fc 843b0ae3 movw     r3, #0xab84
a0392900 70314ae3 movt     r3, #0xa170
a0392904 60209de5 ldr      r2, [sp, #0x60]
a0392908 021183e7 str      r1, [r3, r2, lsl #2]
a039290c 60309de5 ldr      r3, [sp, #0x60]
a0392910 013083e2 add      r3, r3, #1
a0392914 60308de5 str      r3, [sp, #0x60]
a0392918 60209de5 ldr      r2, [sp, #0x60]
a039291c 3c309de5 ldr      r3, [sp, #0x3c]
a0392920 030052e1 cmp      r2, r3
a0392924 d1ffffba blt      #0xa0392870
a0392928 a03204e3 movw     r3, #0x42a0
a039292c 70314ae3 movt     r3, #0xa170
a0392930 043093e5 ldr      r3, [r3, #4]
a0392934 4324a0e1 asr      r2, r3, #8
a0392938 2c3a0be3 movw     r3, #0xba2c
a039293c 70314ae3 movt     r3, #0xa170
a0392940 042083e5 str      r2, [r3, #4]
a0392944 2c3a0be3 movw     r3, #0xba2c
a0392948 70314ae3 movt     r3, #0xa170
a039294c 043093e5 ldr      r3, [r3, #4]
a0392950 000053e3 cmp      r3, #0
a0392954 180000ba blt      #0xa03929bc
a0392958 b03204e3 movw     r3, #0x42b0
a039295c 70314ae3 movt     r3, #0xa170
a0392960 042093e5 ldr      r2, [r3, #4]
a0392964 c03204e3 movw     r3, #0x42c0
a0392968 70314ae3 movt     r3, #0xa170
a039296c 043093e5 ldr      r3, [r3, #4]
a0392970 032082e0 add      r2, r2, r3
a0392974 2c3a0be3 movw     r3, #0xba2c
a0392978 70314ae3 movt     r3, #0xa170
a039297c 043093e5 ldr      r3, [r3, #4]
a0392980 022063e0 rsb      r2, r3, r2
a0392984 343a0be3 movw     r3, #0xba34
a0392988 70314ae3 movt     r3, #0xa170
a039298c 042083e5 str      r2, [r3, #4]
a0392990 b83204e3 movw     r3, #0x42b8
a0392994 70314ae3 movt     r3, #0xa170
a0392998 042093e5 ldr      r2, [r3, #4]
a039299c c83204e3 movw     r3, #0x42c8
a03929a0 70314ae3 movt     r3, #0xa170
a03929a4 043093e5 ldr      r3, [r3, #4]
a03929a8 032082e0 add      r2, r2, r3
a03929ac 3c3a0be3 movw     r3, #0xba3c
a03929b0 70314ae3 movt     r3, #0xa170
a03929b4 042083e5 str      r2, [r3, #4]
a03929b8 170000ea b        #0xa0392a1c
a03929bc b03204e3 movw     r3, #0x42b0
a03929c0 70314ae3 movt     r3, #0xa170
a03929c4 042093e5 ldr      r2, [r3, #4]
a03929c8 c03204e3 movw     r3, #0x42c0
a03929cc 70314ae3 movt     r3, #0xa170
a03929d0 043093e5 ldr      r3, [r3, #4]
a03929d4 032082e0 add      r2, r2, r3
a03929d8 343a0be3 movw     r3, #0xba34
a03929dc 70314ae3 movt     r3, #0xa170
a03929e0 042083e5 str      r2, [r3, #4]
a03929e4 b83204e3 movw     r3, #0x42b8
a03929e8 70314ae3 movt     r3, #0xa170
a03929ec 042093e5 ldr      r2, [r3, #4]
a03929f0 c83204e3 movw     r3, #0x42c8
a03929f4 70314ae3 movt     r3, #0xa170
a03929f8 043093e5 ldr      r3, [r3, #4]
a03929fc 032082e0 add      r2, r2, r3
a0392a00 2c3a0be3 movw     r3, #0xba2c
a0392a04 70314ae3 movt     r3, #0xa170
a0392a08 043093e5 ldr      r3, [r3, #4]
a0392a0c 032082e0 add      r2, r2, r3
a0392a10 3c3a0be3 movw     r3, #0xba3c
a0392a14 70314ae3 movt     r3, #0xa170
a0392a18 042083e5 str      r2, [r3, #4]
a0392a1c 0130a0e3 mov      r3, #1
a0392a20 60308de5 str      r3, [sp, #0x60]
a0392a24 290000ea b        #0xa0392ad0
a0392a28 143d0ae3 movw     r3, #0xad14
a0392a2c 70314ae3 movt     r3, #0xa170
a0392a30 60209de5 ldr      r2, [sp, #0x60]
a0392a34 023193e7 ldr      r3, [r3, r2, lsl #2]
a0392a38 4324a0e1 asr      r2, r3, #8
a0392a3c 343a0be3 movw     r3, #0xba34
a0392a40 70314ae3 movt     r3, #0xa170
a0392a44 043093e5 ldr      r3, [r3, #4]
a0392a48 030052e1 cmp      r2, r3
a0392a4c 080000da ble      #0xa0392a74
a0392a50 343a0be3 movw     r3, #0xba34
a0392a54 70314ae3 movt     r3, #0xa170
a0392a58 043093e5 ldr      r3, [r3, #4]
a0392a5c 0314a0e1 lsl      r1, r3, #8
a0392a60 143d0ae3 movw     r3, #0xad14
a0392a64 70314ae3 movt     r3, #0xa170
a0392a68 60209de5 ldr      r2, [sp, #0x60]
a0392a6c 021183e7 str      r1, [r3, r2, lsl #2]
a0392a70 130000ea b        #0xa0392ac4
a0392a74 143d0ae3 movw     r3, #0xad14
a0392a78 70314ae3 movt     r3, #0xa170
a0392a7c 60209de5 ldr      r2, [sp, #0x60]
a0392a80 023193e7 ldr      r3, [r3, r2, lsl #2]
a0392a84 4324a0e1 asr      r2, r3, #8
a0392a88 3c3a0be3 movw     r3, #0xba3c
a0392a8c 70314ae3 movt     r3, #0xa170
a0392a90 043093e5 ldr      r3, [r3, #4]
a0392a94 003063e2 rsb      r3, r3, #0
a0392a98 030052e1 cmp      r2, r3
a0392a9c 080000aa bge      #0xa0392ac4
a0392aa0 3c3a0be3 movw     r3, #0xba3c
a0392aa4 70314ae3 movt     r3, #0xa170
a0392aa8 043093e5 ldr      r3, [r3, #4]
a0392aac 003063e2 rsb      r3, r3, #0
a0392ab0 0314a0e1 lsl      r1, r3, #8
a0392ab4 143d0ae3 movw     r3, #0xad14
a0392ab8 70314ae3 movt     r3, #0xa170
a0392abc 60209de5 ldr      r2, [sp, #0x60]
a0392ac0 021183e7 str      r1, [r3, r2, lsl #2]
a0392ac4 60309de5 ldr      r3, [sp, #0x60]
a0392ac8 013083e2 add      r3, r3, #1
a0392acc 60308de5 str      r3, [sp, #0x60]
a0392ad0 60209de5 ldr      r2, [sp, #0x60]
a0392ad4 3c309de5 ldr      r3, [sp, #0x3c]
a0392ad8 030052e1 cmp      r2, r3
a0392adc d1ffffba blt      #0xa0392a28
a0392ae0 0030a0e3 mov      r3, #0
a0392ae4 64308de5 str      r3, [sp, #0x64]
a0392ae8 690000ea b        #0xa0392c94
a0392aec 0030a0e3 mov      r3, #0
a0392af0 60308de5 str      r3, [sp, #0x60]
a0392af4 5f0000ea b        #0xa0392c78
a0392af8 64309de5 ldr      r3, [sp, #0x64]
a0392afc 40209de5 ldr      r2, [sp, #0x40]
a0392b00 920302e0 mul      r2, r2, r3
a0392b04 60309de5 ldr      r3, [sp, #0x60]
a0392b08 033082e0 add      r3, r2, r3
a0392b0c 0331a0e1 lsl      r3, r3, #2
a0392b10 04209de5 ldr      r2, [sp, #4]
a0392b14 032082e0 add      r2, r2, r3
a0392b18 64309de5 ldr      r3, [sp, #0x64]
a0392b1c 40109de5 ldr      r1, [sp, #0x40]
a0392b20 910301e0 mul      r1, r1, r3
a0392b24 60309de5 ldr      r3, [sp, #0x60]
a0392b28 033081e0 add      r3, r1, r3
a0392b2c 0331a0e1 lsl      r3, r3, #2
a0392b30 04109de5 ldr      r1, [sp, #4]
a0392b34 033081e0 add      r3, r1, r3
a0392b38 b030d3e1 ldrh     r3, [r3]
a0392b3c 7310ffe6 uxth     r1, r3
a0392b40 843b0ae3 movw     r3, #0xab84
a0392b44 70314ae3 movt     r3, #0xa170
a0392b48 64009de5 ldr      r0, [sp, #0x64]
a0392b4c 003193e7 ldr      r3, [r3, r0, lsl #2]
a0392b50 4336a0e1 asr      r3, r3, #0xc
a0392b54 7300ffe6 uxth     r0, r3
a0392b58 c43a07e3 movw     r3, #0x7ac4
a0392b5c 75304ae3 movt     r3, #0xa075
a0392b60 003093e5 ldr      r3, [r3]
a0392b64 7330ffe6 uxth     r3, r3
a0392b68 800363e1 smulbb   r3, r0, r3
a0392b6c 7330ffe6 uxth     r3, r3
a0392b70 033081e0 add      r3, r1, r3
a0392b74 7330ffe6 uxth     r3, r3
a0392b78 7330ffe6 uxth     r3, r3
a0392b7c b030c2e1 strh     r3, [r2]
a0392b80 64309de5 ldr      r3, [sp, #0x64]
a0392b84 40209de5 ldr      r2, [sp, #0x40]
a0392b88 920302e0 mul      r2, r2, r3
a0392b8c 60309de5 ldr      r3, [sp, #0x60]
a0392b90 033082e0 add      r3, r2, r3
a0392b94 0331a0e1 lsl      r3, r3, #2
a0392b98 04209de5 ldr      r2, [sp, #4]
a0392b9c 032082e0 add      r2, r2, r3
a0392ba0 64309de5 ldr      r3, [sp, #0x64]
a0392ba4 40109de5 ldr      r1, [sp, #0x40]
a0392ba8 910301e0 mul      r1, r1, r3
a0392bac 60309de5 ldr      r3, [sp, #0x60]
a0392bb0 033081e0 add      r3, r1, r3
a0392bb4 0331a0e1 lsl      r3, r3, #2
a0392bb8 04109de5 ldr      r1, [sp, #4]
a0392bbc 033081e0 add      r3, r1, r3
a0392bc0 b230d3e1 ldrh     r3, [r3, #2]
a0392bc4 7310ffe6 uxth     r1, r3
a0392bc8 143d0ae3 movw     r3, #0xad14
a0392bcc 70314ae3 movt     r3, #0xa170
a0392bd0 64009de5 ldr      r0, [sp, #0x64]
a0392bd4 003193e7 ldr      r3, [r3, r0, lsl #2]
a0392bd8 4336a0e1 asr      r3, r3, #0xc
a0392bdc 7300ffe6 uxth     r0, r3
a0392be0 c43a07e3 movw     r3, #0x7ac4
a0392be4 75304ae3 movt     r3, #0xa075
a0392be8 003093e5 ldr      r3, [r3]
a0392bec 7330ffe6 uxth     r3, r3
a0392bf0 800363e1 smulbb   r3, r0, r3
a0392bf4 7330ffe6 uxth     r3, r3
a0392bf8 033081e0 add      r3, r1, r3
a0392bfc 7330ffe6 uxth     r3, r3
a0392c00 7330ffe6 uxth     r3, r3
a0392c04 b230c2e1 strh     r3, [r2, #2]
a0392c08 293f0ae3 movw     r3, #0xaf29
a0392c0c 70314ae3 movt     r3, #0xa170
a0392c10 0030d3e5 ldrb     r3, [r3]
a0392c14 000053e3 cmp      r3, #0
a0392c18 1300000a beq      #0xa0392c6c
a0392c1c 64309de5 ldr      r3, [sp, #0x64]
a0392c20 40209de5 ldr      r2, [sp, #0x40]
a0392c24 920302e0 mul      r2, r2, r3
a0392c28 60309de5 ldr      r3, [sp, #0x60]
a0392c2c 033082e0 add      r3, r2, r3
a0392c30 0331a0e1 lsl      r3, r3, #2
a0392c34 04209de5 ldr      r2, [sp, #4]
a0392c38 033082e0 add      r3, r2, r3
a0392c3c 0020a0e3 mov      r2, #0
a0392c40 b020c3e1 strh     r2, [r3]
a0392c44 64309de5 ldr      r3, [sp, #0x64]
a0392c48 40209de5 ldr      r2, [sp, #0x40]
a0392c4c 920302e0 mul      r2, r2, r3
a0392c50 60309de5 ldr      r3, [sp, #0x60]
a0392c54 033082e0 add      r3, r2, r3
a0392c58 0331a0e1 lsl      r3, r3, #2
a0392c5c 04209de5 ldr      r2, [sp, #4]
a0392c60 033082e0 add      r3, r2, r3
a0392c64 0020a0e3 mov      r2, #0
a0392c68 b220c3e1 strh     r2, [r3, #2]
a0392c6c 60309de5 ldr      r3, [sp, #0x60]
a0392c70 013083e2 add      r3, r3, #1
a0392c74 60308de5 str      r3, [sp, #0x60]
a0392c78 60209de5 ldr      r2, [sp, #0x60]
a0392c7c 40309de5 ldr      r3, [sp, #0x40]
a0392c80 030052e1 cmp      r2, r3
a0392c84 9bffffba blt      #0xa0392af8
a0392c88 64309de5 ldr      r3, [sp, #0x64]
a0392c8c 013083e2 add      r3, r3, #1
a0392c90 64308de5 str      r3, [sp, #0x64]
a0392c94 64209de5 ldr      r2, [sp, #0x64]
a0392c98 3c309de5 ldr      r3, [sp, #0x3c]
a0392c9c 030052e1 cmp      r2, r3
a0392ca0 91ffffba blt      #0xa0392aec
a0392ca4 6cd08de2 add      sp, sp, #0x6c
a0392ca8 04f09de4 pop      {pc}
a0392cac 00000000 andeq    r0, r0, r0
a0392cb0 f0432de9 push     {r4, r5, r6, r7, r8, sb, lr}
a0392cb4 74d04de2 sub      sp, sp, #0x74
a0392cb8 2c308de2 add      r3, sp, #0x2c
a0392cbc 0020a0e3 mov      r2, #0
a0392cc0 002083e5 str      r2, [r3]
a0392cc4 043083e2 add      r3, r3, #4
a0392cc8 0020a0e3 mov      r2, #0
a0392ccc 002083e5 str      r2, [r3]
a0392cd0 043083e2 add      r3, r3, #4
a0392cd4 0020a0e3 mov      r2, #0
a0392cd8 002083e5 str      r2, [r3]
a0392cdc 043083e2 add      r3, r3, #4
a0392ce0 0030a0e3 mov      r3, #0
a0392ce4 2e30cde5 strb     r3, [sp, #0x2e]
a0392ce8 0030a0e3 mov      r3, #0
a0392cec 2c30cde5 strb     r3, [sp, #0x2c]
a0392cf0 0030a0e3 mov      r3, #0
a0392cf4 30308de5 str      r3, [sp, #0x30]
a0392cf8 0130a0e3 mov      r3, #1
a0392cfc 2d30cde5 strb     r3, [sp, #0x2d]
a0392d00 d73504e3 movw     r3, #0x45d7
a0392d04 70314ae3 movt     r3, #0xa170
a0392d08 0030d3e5 ldrb     r3, [r3]
a0392d0c 000053e3 cmp      r3, #0
a0392d10 0e00001a bne      #0xa0392d50
a0392d14 d93504e3 movw     r3, #0x45d9
a0392d18 70314ae3 movt     r3, #0xa170
a0392d1c 0030d3e5 ldrb     r3, [r3]
a0392d20 000053e3 cmp      r3, #0
a0392d24 0900001a bne      #0xa0392d50
a0392d28 dc3504e3 movw     r3, #0x45dc
a0392d2c 70314ae3 movt     r3, #0xa170
a0392d30 0030d3e5 ldrb     r3, [r3]
a0392d34 000053e3 cmp      r3, #0
a0392d38 0400001a bne      #0xa0392d50
a0392d3c dd3504e3 movw     r3, #0x45dd
a0392d40 70314ae3 movt     r3, #0xa170
a0392d44 0030d3e5 ldrb     r3, [r3]
a0392d48 000053e3 cmp      r3, #0
a0392d4c 0100000a beq      #0xa0392d58
a0392d50 0130a0e3 mov      r3, #1
a0392d54 000000ea b        #0xa0392d5c
a0392d58 0030a0e3 mov      r3, #0
a0392d5c 7320efe6 uxtb     r2, r3
a0392d60 d53504e3 movw     r3, #0x45d5
a0392d64 70314ae3 movt     r3, #0xa170
a0392d68 0020c3e5 strb     r2, [r3]
a0392d6c d43504e3 movw     r3, #0x45d4
a0392d70 70314ae3 movt     r3, #0xa170
a0392d74 0030d3e5 ldrb     r3, [r3]
a0392d78 000053e3 cmp      r3, #0
a0392d7c 8507001a bne      #0xa0394b98
a0392d80 d53504e3 movw     r3, #0x45d5
a0392d84 70314ae3 movt     r3, #0xa170
a0392d88 0030d3e5 ldrb     r3, [r3]
a0392d8c 000053e3 cmp      r3, #0
a0392d90 8007000a beq      #0xa0394b98
a0392d94 e03504e3 movw     r3, #0x45e0
a0392d98 70314ae3 movt     r3, #0xa170
a0392d9c 0000a0e3 mov      r0, #0
a0392da0 0010a0e3 mov      r1, #0
a0392da4 f000c3e1 strd     r0, r1, [r3]
a0392da8 d73504e3 movw     r3, #0x45d7
a0392dac 70314ae3 movt     r3, #0xa170
a0392db0 0030d3e5 ldrb     r3, [r3]
a0392db4 000053e3 cmp      r3, #0
a0392db8 db05000a beq      #0xa039452c
a0392dbc 243b0ae3 movw     r3, #0xab24
a0392dc0 70314ae3 movt     r3, #0xa170
a0392dc4 003093e5 ldr      r3, [r3]
a0392dc8 2334a0e1 lsr      r3, r3, #8
a0392dcc 50308de5 str      r3, [sp, #0x50]
a0392dd0 443004e3 movw     r3, #0x4044
a0392dd4 70314ae3 movt     r3, #0xa170
a0392dd8 0930d3e5 ldrb     r3, [r3, #9]
a0392ddc 010053e3 cmp      r3, #1
a0392de0 1a00009a bls      #0xa0392e50
a0392de4 443004e3 movw     r3, #0x4044
a0392de8 70314ae3 movt     r3, #0xa170
a0392dec 0930d3e5 ldrb     r3, [r3, #9]
a0392df0 a330a0e1 lsr      r3, r3, #1
a0392df4 7330efe6 uxtb     r3, r3
a0392df8 0320a0e1 mov      r2, r3
a0392dfc 703204e3 movw     r3, #0x4270
a0392e00 70314ae3 movt     r3, #0xa170
a0392e04 003093e5 ldr      r3, [r3]
a0392e08 032082e0 add      r2, r2, r3
a0392e0c 443004e3 movw     r3, #0x4044
a0392e10 70314ae3 movt     r3, #0xa170
a0392e14 0930d3e5 ldrb     r3, [r3, #9]
a0392e18 0200a0e1 mov      r0, r2
a0392e1c 0310a0e1 mov      r1, r3
a0392e20 1ace05fa blx      #0xa0506690
a0392e24 0030a0e1 mov      r3, r0
a0392e28 58308de5 str      r3, [sp, #0x58]
a0392e2c 443004e3 movw     r3, #0x4044
a0392e30 70314ae3 movt     r3, #0xa170
a0392e34 0930d3e5 ldrb     r3, [r3, #9]
a0392e38 50009de5 ldr      r0, [sp, #0x50]
a0392e3c 0310a0e1 mov      r1, r3
a0392e40 12ce05fa blx      #0xa0506690
a0392e44 0030a0e1 mov      r3, r0
a0392e48 50308de5 str      r3, [sp, #0x50]
a0392e4c 030000ea b        #0xa0392e60
a0392e50 703204e3 movw     r3, #0x4270
a0392e54 70314ae3 movt     r3, #0xa170
a0392e58 003093e5 ldr      r3, [r3]
a0392e5c 58308de5 str      r3, [sp, #0x58]
a0392e60 ac3504e3 movw     r3, #0x45ac
a0392e64 70314ae3 movt     r3, #0xa170
a0392e68 0030d3e5 ldrb     r3, [r3]
a0392e6c 7330afe6 sxtb     r3, r3
a0392e70 000053e3 cmp      r3, #0
a0392e74 070000da ble      #0xa0392e98
a0392e78 2c3b0ae3 movw     r3, #0xab2c
a0392e7c 70314ae3 movt     r3, #0xa170
a0392e80 003093e5 ldr      r3, [r3]
a0392e84 0320a0e1 mov      r2, r3
a0392e88 58309de5 ldr      r3, [sp, #0x58]
a0392e8c 033082e0 add      r3, r2, r3
a0392e90 64308de5 str      r3, [sp, #0x64]
a0392e94 060000ea b        #0xa0392eb4
a0392e98 283b0ae3 movw     r3, #0xab28
a0392e9c 70314ae3 movt     r3, #0xa170
a0392ea0 003093e5 ldr      r3, [r3]
a0392ea4 0320a0e1 mov      r2, r3
a0392ea8 58309de5 ldr      r3, [sp, #0x58]
a0392eac 033082e0 add      r3, r2, r3
a0392eb0 64308de5 str      r3, [sp, #0x64]
a0392eb4 da3504e3 movw     r3, #0x45da
a0392eb8 70314ae3 movt     r3, #0xa170
a0392ebc 0030d3e5 ldrb     r3, [r3]
a0392ec0 000053e3 cmp      r3, #0
a0392ec4 6000000a beq      #0xa039304c
a0392ec8 c83a07e3 movw     r3, #0x7ac8
a0392ecc 75304ae3 movt     r3, #0xa075
a0392ed0 0030d3e5 ldrb     r3, [r3]
a0392ed4 010053e3 cmp      r3, #1
a0392ed8 3100008a bhi      #0xa0392fa4
a0392edc 283b0ae3 movw     r3, #0xab28
a0392ee0 70314ae3 movt     r3, #0xa170
a0392ee4 002093e5 ldr      r2, [r3]
a0392ee8 c03004e3 movw     r3, #0x40c0
a0392eec 70314ae3 movt     r3, #0xa170
a0392ef0 003093e5 ldr      r3, [r3]
a0392ef4 032082e0 add      r2, r2, r3
a0392ef8 c03c02e3 movw     r3, #0x2cc0
a0392efc 70314ae3 movt     r3, #0xa170
a0392f00 1430d3e5 ldrb     r3, [r3, #0x14]
a0392f04 7330afe6 sxtb     r3, r3
a0392f08 032082e0 add      r2, r2, r3
a0392f0c b03a07e3 movw     r3, #0x7ab0
a0392f10 75304ae3 movt     r3, #0xa075
a0392f14 0030d3e5 ldrb     r3, [r3]
a0392f18 7330afe6 sxtb     r3, r3
a0392f1c 033082e0 add      r3, r2, r3
a0392f20 64308de5 str      r3, [sp, #0x64]
a0392f24 203b0ae3 movw     r3, #0xab20
a0392f28 70314ae3 movt     r3, #0xa170
a0392f2c b030d3e1 ldrh     r3, [r3]
a0392f30 013083e2 add      r3, r3, #1
a0392f34 c330a0e1 asr      r3, r3, #1
a0392f38 64209de5 ldr      r2, [sp, #0x64]
a0392f3c 023063e0 rsb      r3, r3, r2
a0392f40 64308de5 str      r3, [sp, #0x64]
a0392f44 503c02e3 movw     r3, #0x2c50
a0392f48 70314ae3 movt     r3, #0xa170
a0392f4c 0030d3e5 ldrb     r3, [r3]
a0392f50 8330a0e1 lsl      r3, r3, #1
a0392f54 003063e2 rsb      r3, r3, #0
a0392f58 64209de5 ldr      r2, [sp, #0x64]
a0392f5c 033082e0 add      r3, r2, r3
a0392f60 64308de5 str      r3, [sp, #0x64]
a0392f64 043304e3 movw     r3, #0x4304
a0392f68 70314ae3 movt     r3, #0xa170
a0392f6c 002093e5 ldr      r2, [r3]
a0392f70 a43e0ae3 movw     r3, #0xaea4
a0392f74 70314ae3 movt     r3, #0xa170
a0392f78 003093e5 ldr      r3, [r3]
a0392f7c 022063e0 rsb      r2, r3, r2
a0392f80 c03004e3 movw     r3, #0x40c0
a0392f84 70314ae3 movt     r3, #0xa170
a0392f88 003093e5 ldr      r3, [r3]
a0392f8c 023063e0 rsb      r3, r3, r2
a0392f90 a320a0e1 lsr      r2, r3, #1
a0392f94 64309de5 ldr      r3, [sp, #0x64]
a0392f98 033082e0 add      r3, r2, r3
a0392f9c 64308de5 str      r3, [sp, #0x64]
a0392fa0 3b0000ea b        #0xa0393094
a0392fa4 303b0ae3 movw     r3, #0xab30
a0392fa8 70314ae3 movt     r3, #0xa170
a0392fac 002093e5 ldr      r2, [r3]
a0392fb0 c03004e3 movw     r3, #0x40c0
a0392fb4 70314ae3 movt     r3, #0xa170
a0392fb8 003093e5 ldr      r3, [r3]
a0392fbc 032082e0 add      r2, r2, r3
a0392fc0 c03c02e3 movw     r3, #0x2cc0
a0392fc4 70314ae3 movt     r3, #0xa170
a0392fc8 1430d3e5 ldrb     r3, [r3, #0x14]
a0392fcc 7330afe6 sxtb     r3, r3
a0392fd0 032082e0 add      r2, r2, r3
a0392fd4 b03a07e3 movw     r3, #0x7ab0
a0392fd8 75304ae3 movt     r3, #0xa075
a0392fdc 0030d3e5 ldrb     r3, [r3]
a0392fe0 7330afe6 sxtb     r3, r3
a0392fe4 033082e0 add      r3, r2, r3
a0392fe8 64308de5 str      r3, [sp, #0x64]
a0392fec 203b0ae3 movw     r3, #0xab20
a0392ff0 70314ae3 movt     r3, #0xa170
a0392ff4 b030d3e1 ldrh     r3, [r3]
a0392ff8 013083e2 add      r3, r3, #1
a0392ffc c330a0e1 asr      r3, r3, #1
a0393000 64209de5 ldr      r2, [sp, #0x64]
a0393004 023063e0 rsb      r3, r3, r2
a0393008 64308de5 str      r3, [sp, #0x64]
a039300c 043304e3 movw     r3, #0x4304
a0393010 70314ae3 movt     r3, #0xa170
a0393014 002093e5 ldr      r2, [r3]
a0393018 a43e0ae3 movw     r3, #0xaea4
a039301c 70314ae3 movt     r3, #0xa170
a0393020 003093e5 ldr      r3, [r3]
a0393024 022063e0 rsb      r2, r3, r2
a0393028 c03004e3 movw     r3, #0x40c0
a039302c 70314ae3 movt     r3, #0xa170
a0393030 003093e5 ldr      r3, [r3]
a0393034 023063e0 rsb      r3, r3, r2
a0393038 a320a0e1 lsr      r2, r3, #1
a039303c 64309de5 ldr      r3, [sp, #0x64]
a0393040 033082e0 add      r3, r2, r3
a0393044 64308de5 str      r3, [sp, #0x64]
a0393048 110000ea b        #0xa0393094
a039304c ca3a07e3 movw     r3, #0x7aca
a0393050 75304ae3 movt     r3, #0xa075
a0393054 0030d3e5 ldrb     r3, [r3]
a0393058 000053e3 cmp      r3, #0
a039305c 0700000a beq      #0xa0393080
a0393060 64309de5 ldr      r3, [sp, #0x64]
a0393064 013083e2 add      r3, r3, #1
a0393068 64308de5 str      r3, [sp, #0x64]
a039306c ca3a07e3 movw     r3, #0x7aca
a0393070 75304ae3 movt     r3, #0xa075
a0393074 0020a0e3 mov      r2, #0
a0393078 0020c3e5 strb     r2, [r3]
a039307c 040000ea b        #0xa0393094
a0393080 e83e0ae3 movw     r3, #0xaee8
a0393084 70314ae3 movt     r3, #0xa170
a0393088 003093e5 ldr      r3, [r3]
a039308c 013083e2 add      r3, r3, #1
a0393090 64308de5 str      r3, [sp, #0x64]
a0393094 64309de5 ldr      r3, [sp, #0x64]
a0393098 000053e3 cmp      r3, #0
a039309c 060000aa bge      #0xa03930bc
a03930a0 003d02e3 movw     r3, #0x2d00
a03930a4 70314ae3 movt     r3, #0xa170
a03930a8 102293e5 ldr      r2, [r3, #0x210]
a03930ac 64309de5 ldr      r3, [sp, #0x64]
a03930b0 033082e0 add      r3, r2, r3
a03930b4 64308de5 str      r3, [sp, #0x64]
a03930b8 0b0000ea b        #0xa03930ec
a03930bc 64209de5 ldr      r2, [sp, #0x64]
a03930c0 003d02e3 movw     r3, #0x2d00
a03930c4 70314ae3 movt     r3, #0xa170
a03930c8 103293e5 ldr      r3, [r3, #0x210]
a03930cc 030052e1 cmp      r2, r3
a03930d0 0500003a blo      #0xa03930ec
a03930d4 64209de5 ldr      r2, [sp, #0x64]
a03930d8 003d02e3 movw     r3, #0x2d00
a03930dc 70314ae3 movt     r3, #0xa170
a03930e0 103293e5 ldr      r3, [r3, #0x210]
a03930e4 023063e0 rsb      r3, r3, r2
a03930e8 64308de5 str      r3, [sp, #0x64]
a03930ec da3504e3 movw     r3, #0x45da
a03930f0 70314ae3 movt     r3, #0xa170
a03930f4 0030d3e5 ldrb     r3, [r3]
a03930f8 000053e3 cmp      r3, #0
a03930fc 9800000a beq      #0xa0393364
a0393100 c83a07e3 movw     r3, #0x7ac8
a0393104 75304ae3 movt     r3, #0xa075
a0393108 0030d3e5 ldrb     r3, [r3]
a039310c 010053e3 cmp      r3, #1
a0393110 3300008a bhi      #0xa03931e4
a0393114 283b0ae3 movw     r3, #0xab28
a0393118 70314ae3 movt     r3, #0xa170
a039311c 002093e5 ldr      r2, [r3]
a0393120 c03004e3 movw     r3, #0x40c0
a0393124 70314ae3 movt     r3, #0xa170
a0393128 003093e5 ldr      r3, [r3]
a039312c 032082e0 add      r2, r2, r3
a0393130 c03c02e3 movw     r3, #0x2cc0
a0393134 70314ae3 movt     r3, #0xa170
a0393138 1430d3e5 ldrb     r3, [r3, #0x14]
a039313c 7330afe6 sxtb     r3, r3
a0393140 032082e0 add      r2, r2, r3
a0393144 b03a07e3 movw     r3, #0x7ab0
a0393148 75304ae3 movt     r3, #0xa075
a039314c 0030d3e5 ldrb     r3, [r3]
a0393150 7330afe6 sxtb     r3, r3
a0393154 033082e0 add      r3, r2, r3
a0393158 60308de5 str      r3, [sp, #0x60]
a039315c 203b0ae3 movw     r3, #0xab20
a0393160 70314ae3 movt     r3, #0xa170
a0393164 b030d3e1 ldrh     r3, [r3]
a0393168 013083e2 add      r3, r3, #1
a039316c c330a0e1 asr      r3, r3, #1
a0393170 60209de5 ldr      r2, [sp, #0x60]
a0393174 023063e0 rsb      r3, r3, r2
a0393178 60308de5 str      r3, [sp, #0x60]
a039317c 503c02e3 movw     r3, #0x2c50
a0393180 70314ae3 movt     r3, #0xa170
a0393184 0030d3e5 ldrb     r3, [r3]
a0393188 0320a0e1 mov      r2, r3
a039318c 60309de5 ldr      r3, [sp, #0x60]
a0393190 033062e0 rsb      r3, r2, r3
a0393194 60308de5 str      r3, [sp, #0x60]
a0393198 043304e3 movw     r3, #0x4304
a039319c 70314ae3 movt     r3, #0xa170
a03931a0 002093e5 ldr      r2, [r3]
a03931a4 a43e0ae3 movw     r3, #0xaea4
a03931a8 70314ae3 movt     r3, #0xa170
a03931ac 003093e5 ldr      r3, [r3]
a03931b0 022063e0 rsb      r2, r3, r2
a03931b4 c03004e3 movw     r3, #0x40c0
a03931b8 70314ae3 movt     r3, #0xa170
a03931bc 003093e5 ldr      r3, [r3]
a03931c0 023063e0 rsb      r3, r3, r2
a03931c4 a320a0e1 lsr      r2, r3, #1
a03931c8 60309de5 ldr      r3, [sp, #0x60]
a03931cc 033082e0 add      r3, r2, r3
a03931d0 60308de5 str      r3, [sp, #0x60]
a03931d4 60309de5 ldr      r3, [sp, #0x60]
a03931d8 013043e2 sub      r3, r3, #1
a03931dc 60308de5 str      r3, [sp, #0x60]
a03931e0 2b0000ea b        #0xa0393294
a03931e4 2c3b0ae3 movw     r3, #0xab2c
a03931e8 70314ae3 movt     r3, #0xa170
a03931ec 002093e5 ldr      r2, [r3]
a03931f0 c03004e3 movw     r3, #0x40c0
a03931f4 70314ae3 movt     r3, #0xa170
a03931f8 003093e5 ldr      r3, [r3]
a03931fc 032082e0 add      r2, r2, r3
a0393200 c03c02e3 movw     r3, #0x2cc0
a0393204 70314ae3 movt     r3, #0xa170
a0393208 1430d3e5 ldrb     r3, [r3, #0x14]
a039320c 7330afe6 sxtb     r3, r3
a0393210 032082e0 add      r2, r2, r3
a0393214 b03a07e3 movw     r3, #0x7ab0
a0393218 75304ae3 movt     r3, #0xa075
a039321c 0030d3e5 ldrb     r3, [r3]
a0393220 7330afe6 sxtb     r3, r3
a0393224 033082e0 add      r3, r2, r3
a0393228 60308de5 str      r3, [sp, #0x60]
a039322c 203b0ae3 movw     r3, #0xab20
a0393230 70314ae3 movt     r3, #0xa170
a0393234 b030d3e1 ldrh     r3, [r3]
a0393238 013083e2 add      r3, r3, #1
a039323c c330a0e1 asr      r3, r3, #1
a0393240 60209de5 ldr      r2, [sp, #0x60]
a0393244 023063e0 rsb      r3, r3, r2
a0393248 60308de5 str      r3, [sp, #0x60]
a039324c 043304e3 movw     r3, #0x4304
a0393250 70314ae3 movt     r3, #0xa170
a0393254 002093e5 ldr      r2, [r3]
a0393258 a43e0ae3 movw     r3, #0xaea4
a039325c 70314ae3 movt     r3, #0xa170
a0393260 003093e5 ldr      r3, [r3]
a0393264 022063e0 rsb      r2, r3, r2
a0393268 c03004e3 movw     r3, #0x40c0
a039326c 70314ae3 movt     r3, #0xa170
a0393270 003093e5 ldr      r3, [r3]
a0393274 023063e0 rsb      r3, r3, r2
a0393278 a320a0e1 lsr      r2, r3, #1
a039327c 60309de5 ldr      r3, [sp, #0x60]
a0393280 033082e0 add      r3, r2, r3
a0393284 60308de5 str      r3, [sp, #0x60]
a0393288 60309de5 ldr      r3, [sp, #0x60]
a039328c 013043e2 sub      r3, r3, #1
a0393290 60308de5 str      r3, [sp, #0x60]
a0393294 60309de5 ldr      r3, [sp, #0x60]
a0393298 000053e3 cmp      r3, #0
a039329c 060000aa bge      #0xa03932bc
a03932a0 003d02e3 movw     r3, #0x2d00
a03932a4 70314ae3 movt     r3, #0xa170
a03932a8 102293e5 ldr      r2, [r3, #0x210]
a03932ac 60309de5 ldr      r3, [sp, #0x60]
a03932b0 033082e0 add      r3, r2, r3
a03932b4 60308de5 str      r3, [sp, #0x60]
a03932b8 0b0000ea b        #0xa03932ec
a03932bc 60209de5 ldr      r2, [sp, #0x60]
a03932c0 003d02e3 movw     r3, #0x2d00
a03932c4 70314ae3 movt     r3, #0xa170
a03932c8 103293e5 ldr      r3, [r3, #0x210]
a03932cc 030052e1 cmp      r2, r3
a03932d0 0500003a blo      #0xa03932ec
a03932d4 60209de5 ldr      r2, [sp, #0x60]
a03932d8 003d02e3 movw     r3, #0x2d00
a03932dc 70314ae3 movt     r3, #0xa170
a03932e0 103293e5 ldr      r3, [r3, #0x210]
a03932e4 023063e0 rsb      r3, r3, r2
a03932e8 60308de5 str      r3, [sp, #0x60]
a03932ec 60209de5 ldr      r2, [sp, #0x60]
a03932f0 64309de5 ldr      r3, [sp, #0x64]
a03932f4 030052e1 cmp      r2, r3
a03932f8 050000da ble      #0xa0393314
a03932fc 60209de5 ldr      r2, [sp, #0x60]
a0393300 64309de5 ldr      r3, [sp, #0x64]
a0393304 023063e0 rsb      r3, r3, r2
a0393308 013083e2 add      r3, r3, #1
a039330c 68308de5 str      r3, [sp, #0x68]
a0393310 0d0000ea b        #0xa039334c
a0393314 60209de5 ldr      r2, [sp, #0x60]
a0393318 64309de5 ldr      r3, [sp, #0x64]
a039331c 030052e1 cmp      r2, r3
a0393320 090000aa bge      #0xa039334c
a0393324 60209de5 ldr      r2, [sp, #0x60]
a0393328 64309de5 ldr      r3, [sp, #0x64]
a039332c 023063e0 rsb      r3, r3, r2
a0393330 0320a0e1 mov      r2, r3
a0393334 003d02e3 movw     r3, #0x2d00
a0393338 70314ae3 movt     r3, #0xa170
a039333c 103293e5 ldr      r3, [r3, #0x210]
a0393340 033082e0 add      r3, r2, r3
a0393344 013083e2 add      r3, r3, #1
a0393348 68308de5 str      r3, [sp, #0x68]
a039334c 68309de5 ldr      r3, [sp, #0x68]
a0393350 000053e3 cmp      r3, #0
a0393354 3c00001a bne      #0xa039344c
a0393358 0130a0e3 mov      r3, #1
a039335c 68308de5 str      r3, [sp, #0x68]
a0393360 390000ea b        #0xa039344c
a0393364 383b0ae3 movw     r3, #0xab38
a0393368 70314ae3 movt     r3, #0xa170
a039336c 003093e5 ldr      r3, [r3]
a0393370 60308de5 str      r3, [sp, #0x60]
a0393374 60309de5 ldr      r3, [sp, #0x60]
a0393378 000053e3 cmp      r3, #0
a039337c 060000aa bge      #0xa039339c
a0393380 003d02e3 movw     r3, #0x2d00
a0393384 70314ae3 movt     r3, #0xa170
a0393388 102293e5 ldr      r2, [r3, #0x210]
a039338c 60309de5 ldr      r3, [sp, #0x60]
a0393390 033082e0 add      r3, r2, r3
a0393394 60308de5 str      r3, [sp, #0x60]
a0393398 0b0000ea b        #0xa03933cc
a039339c 60209de5 ldr      r2, [sp, #0x60]
a03933a0 003d02e3 movw     r3, #0x2d00
a03933a4 70314ae3 movt     r3, #0xa170
a03933a8 103293e5 ldr      r3, [r3, #0x210]
a03933ac 030052e1 cmp      r2, r3
a03933b0 0500003a blo      #0xa03933cc
a03933b4 60209de5 ldr      r2, [sp, #0x60]
a03933b8 003d02e3 movw     r3, #0x2d00
a03933bc 70314ae3 movt     r3, #0xa170
a03933c0 103293e5 ldr      r3, [r3, #0x210]
a03933c4 023063e0 rsb      r3, r3, r2
a03933c8 60308de5 str      r3, [sp, #0x60]
a03933cc 60209de5 ldr      r2, [sp, #0x60]
a03933d0 e83e0ae3 movw     r3, #0xaee8
a03933d4 70314ae3 movt     r3, #0xa170
a03933d8 002083e5 str      r2, [r3]
a03933dc 2c3f0ae3 movw     r3, #0xaf2c
a03933e0 70314ae3 movt     r3, #0xa170
a03933e4 003093e5 ldr      r3, [r3]
a03933e8 64209de5 ldr      r2, [sp, #0x64]
a03933ec 033082e0 add      r3, r2, r3
a03933f0 6c308de5 str      r3, [sp, #0x6c]
a03933f4 6c309de5 ldr      r3, [sp, #0x6c]
a03933f8 000053e3 cmp      r3, #0
a03933fc 060000aa bge      #0xa039341c
a0393400 003d02e3 movw     r3, #0x2d00
a0393404 70314ae3 movt     r3, #0xa170
a0393408 102293e5 ldr      r2, [r3, #0x210]
a039340c 6c309de5 ldr      r3, [sp, #0x6c]
a0393410 033082e0 add      r3, r2, r3
a0393414 6c308de5 str      r3, [sp, #0x6c]
a0393418 0b0000ea b        #0xa039344c
a039341c 6c209de5 ldr      r2, [sp, #0x6c]
a0393420 003d02e3 movw     r3, #0x2d00
a0393424 70314ae3 movt     r3, #0xa170
a0393428 103293e5 ldr      r3, [r3, #0x210]
a039342c 030052e1 cmp      r2, r3
a0393430 0500003a blo      #0xa039344c
a0393434 6c209de5 ldr      r2, [sp, #0x6c]
a0393438 003d02e3 movw     r3, #0x2d00
a039343c 70314ae3 movt     r3, #0xa170
a0393440 103293e5 ldr      r3, [r3, #0x210]
a0393444 023063e0 rsb      r3, r3, r2
a0393448 6c308de5 str      r3, [sp, #0x6c]
a039344c 543b0ae3 movw     r3, #0xab54
a0393450 70314ae3 movt     r3, #0xa170
a0393454 0020a0e3 mov      r2, #0
a0393458 002083e5 str      r2, [r3]
a039345c 60209de5 ldr      r2, [sp, #0x60]
a0393460 64309de5 ldr      r3, [sp, #0x64]
a0393464 030052e1 cmp      r2, r3
a0393468 560000aa bge      #0xa03935c8
a039346c 64209de5 ldr      r2, [sp, #0x64]
a0393470 403b0ae3 movw     r3, #0xab40
a0393474 70314ae3 movt     r3, #0xa170
a0393478 002083e5 str      r2, [r3]
a039347c 1e0000ea b        #0xa03934fc
a0393480 403b0ae3 movw     r3, #0xab40
a0393484 70314ae3 movt     r3, #0xa170
a0393488 003093e5 ldr      r3, [r3]
a039348c 002d02e3 movw     r2, #0x2d00
a0393490 70214ae3 movt     r2, #0xa170
a0393494 113e83e2 add      r3, r3, #0x110
a0393498 023083e2 add      r3, r3, #2
a039349c 031192e7 ldr      r1, [r2, r3, lsl #2]
a03934a0 403b0ae3 movw     r3, #0xab40
a03934a4 70314ae3 movt     r3, #0xa170
a03934a8 003093e5 ldr      r3, [r3]
a03934ac 002d02e3 movw     r2, #0x2d00
a03934b0 70214ae3 movt     r2, #0xa170
a03934b4 ab3f83e2 add      r3, r3, #0x2ac
a03934b8 013083e2 add      r3, r3, #1
a03934bc 033192e7 ldr      r3, [r2, r3, lsl #2]
a03934c0 012063e0 rsb      r2, r3, r1
a03934c4 543b0ae3 movw     r3, #0xab54
a03934c8 70314ae3 movt     r3, #0xa170
a03934cc 003093e5 ldr      r3, [r3]
a03934d0 032082e0 add      r2, r2, r3
a03934d4 543b0ae3 movw     r3, #0xab54
a03934d8 70314ae3 movt     r3, #0xa170
a03934dc 002083e5 str      r2, [r3]
a03934e0 403b0ae3 movw     r3, #0xab40
a03934e4 70314ae3 movt     r3, #0xa170
a03934e8 003093e5 ldr      r3, [r3]
a03934ec 012083e2 add      r2, r3, #1
a03934f0 403b0ae3 movw     r3, #0xab40
a03934f4 70314ae3 movt     r3, #0xa170
a03934f8 002083e5 str      r2, [r3]
a03934fc 003d02e3 movw     r3, #0x2d00
a0393500 70314ae3 movt     r3, #0xa170
a0393504 102293e5 ldr      r2, [r3, #0x210]
a0393508 403b0ae3 movw     r3, #0xab40
a039350c 70314ae3 movt     r3, #0xa170
a0393510 003093e5 ldr      r3, [r3]
a0393514 030052e1 cmp      r2, r3
a0393518 d8ffff8a bhi      #0xa0393480
a039351c 403b0ae3 movw     r3, #0xab40
a0393520 70314ae3 movt     r3, #0xa170
a0393524 0020a0e3 mov      r2, #0
a0393528 002083e5 str      r2, [r3]
a039352c 1e0000ea b        #0xa03935ac
a0393530 403b0ae3 movw     r3, #0xab40
a0393534 70314ae3 movt     r3, #0xa170
a0393538 003093e5 ldr      r3, [r3]
a039353c 002d02e3 movw     r2, #0x2d00
a0393540 70214ae3 movt     r2, #0xa170
a0393544 113e83e2 add      r3, r3, #0x110
a0393548 023083e2 add      r3, r3, #2
a039354c 031192e7 ldr      r1, [r2, r3, lsl #2]
a0393550 403b0ae3 movw     r3, #0xab40
a0393554 70314ae3 movt     r3, #0xa170
a0393558 003093e5 ldr      r3, [r3]
a039355c 002d02e3 movw     r2, #0x2d00
a0393560 70214ae3 movt     r2, #0xa170
a0393564 ab3f83e2 add      r3, r3, #0x2ac
a0393568 013083e2 add      r3, r3, #1
a039356c 033192e7 ldr      r3, [r2, r3, lsl #2]
a0393570 012063e0 rsb      r2, r3, r1
a0393574 543b0ae3 movw     r3, #0xab54
a0393578 70314ae3 movt     r3, #0xa170
a039357c 003093e5 ldr      r3, [r3]
a0393580 032082e0 add      r2, r2, r3
a0393584 543b0ae3 movw     r3, #0xab54
a0393588 70314ae3 movt     r3, #0xa170
a039358c 002083e5 str      r2, [r3]
a0393590 403b0ae3 movw     r3, #0xab40
a0393594 70314ae3 movt     r3, #0xa170
a0393598 003093e5 ldr      r3, [r3]
a039359c 012083e2 add      r2, r3, #1
a03935a0 403b0ae3 movw     r3, #0xab40
a03935a4 70314ae3 movt     r3, #0xa170
a03935a8 002083e5 str      r2, [r3]
a03935ac 60209de5 ldr      r2, [sp, #0x60]
a03935b0 403b0ae3 movw     r3, #0xab40
a03935b4 70314ae3 movt     r3, #0xa170
a03935b8 003093e5 ldr      r3, [r3]
a03935bc 030052e1 cmp      r2, r3
a03935c0 daffff2a bhs      #0xa0393530
a03935c4 290000ea b        #0xa0393670
a03935c8 64209de5 ldr      r2, [sp, #0x64]
a03935cc 403b0ae3 movw     r3, #0xab40
a03935d0 70314ae3 movt     r3, #0xa170
a03935d4 002083e5 str      r2, [r3]
a03935d8 1e0000ea b        #0xa0393658
a03935dc 403b0ae3 movw     r3, #0xab40
a03935e0 70314ae3 movt     r3, #0xa170
a03935e4 003093e5 ldr      r3, [r3]
a03935e8 002d02e3 movw     r2, #0x2d00
a03935ec 70214ae3 movt     r2, #0xa170
a03935f0 113e83e2 add      r3, r3, #0x110
a03935f4 023083e2 add      r3, r3, #2
a03935f8 031192e7 ldr      r1, [r2, r3, lsl #2]
a03935fc 403b0ae3 movw     r3, #0xab40
a0393600 70314ae3 movt     r3, #0xa170
a0393604 003093e5 ldr      r3, [r3]
a0393608 002d02e3 movw     r2, #0x2d00
a039360c 70214ae3 movt     r2, #0xa170
a0393610 ab3f83e2 add      r3, r3, #0x2ac
a0393614 013083e2 add      r3, r3, #1
a0393618 033192e7 ldr      r3, [r2, r3, lsl #2]
a039361c 012063e0 rsb      r2, r3, r1
a0393620 543b0ae3 movw     r3, #0xab54
a0393624 70314ae3 movt     r3, #0xa170
a0393628 003093e5 ldr      r3, [r3]
a039362c 032082e0 add      r2, r2, r3
a0393630 543b0ae3 movw     r3, #0xab54
a0393634 70314ae3 movt     r3, #0xa170
a0393638 002083e5 str      r2, [r3]
a039363c 403b0ae3 movw     r3, #0xab40
a0393640 70314ae3 movt     r3, #0xa170
a0393644 003093e5 ldr      r3, [r3]
a0393648 012083e2 add      r2, r3, #1
a039364c 403b0ae3 movw     r3, #0xab40
a0393650 70314ae3 movt     r3, #0xa170
a0393654 002083e5 str      r2, [r3]
a0393658 60209de5 ldr      r2, [sp, #0x60]
a039365c 403b0ae3 movw     r3, #0xab40
a0393660 70314ae3 movt     r3, #0xa170
a0393664 003093e5 ldr      r3, [r3]
a0393668 030052e1 cmp      r2, r3
a039366c daffff2a bhs      #0xa03935dc
a0393670 543b0ae3 movw     r3, #0xab54
a0393674 70314ae3 movt     r3, #0xa170
a0393678 003093e5 ldr      r3, [r3]
a039367c 000053e3 cmp      r3, #0
a0393680 020000ba blt      #0xa0393690
a0393684 0130a0e3 mov      r3, #1
a0393688 5c308de5 str      r3, [sp, #0x5c]
a039368c 080000ea b        #0xa03936b4
a0393690 0030e0e3 mvn      r3, #0
a0393694 5c308de5 str      r3, [sp, #0x5c]
a0393698 543b0ae3 movw     r3, #0xab54
a039369c 70314ae3 movt     r3, #0xa170
a03936a0 003093e5 ldr      r3, [r3]
a03936a4 002063e2 rsb      r2, r3, #0
a03936a8 543b0ae3 movw     r3, #0xab54
a03936ac 70314ae3 movt     r3, #0xa170
a03936b0 002083e5 str      r2, [r3]
a03936b4 543b0ae3 movw     r3, #0xab54
a03936b8 70314ae3 movt     r3, #0xa170
a03936bc 003093e5 ldr      r3, [r3]
a03936c0 0320a0e1 mov      r2, r3
a03936c4 c23fa0e1 asr      r3, r2, #0x1f
a03936c8 a11a07e3 movw     r1, #0x7aa1
a03936cc 75104ae3 movt     r1, #0xa075
a03936d0 0010d1e5 ldrb     r1, [r1]
a03936d4 7110afe6 sxtb     r1, r1
a03936d8 081041e2 sub      r1, r1, #8
a03936dc 20c041e2 sub      ip, r1, #0x20
a03936e0 200061e2 rsb      r0, r1, #0x20
a03936e4 1371a0e1 lsl      r7, r3, r1
a03936e8 127c87e1 orr      r7, r7, r2, lsl ip
a03936ec 327087e1 orr      r7, r7, r2, lsr r0
a03936f0 1261a0e1 lsl      r6, r2, r1
a03936f4 443004e3 movw     r3, #0x4044
a03936f8 70314ae3 movt     r3, #0xa170
a03936fc 0930d3e5 ldrb     r3, [r3, #9]
a0393700 0334a0e1 lsl      r3, r3, #8
a0393704 00308de5 str      r3, [sp]
a0393708 0200a0e3 mov      r0, #2
a039370c 0620a0e1 mov      r2, r6
a0393710 0730a0e1 mov      r3, r7
a0393714 bdc4ffeb bl       #0xa0384a10
a0393718 0020a0e1 mov      r2, r0
a039371c 583b0ae3 movw     r3, #0xab58
a0393720 70314ae3 movt     r3, #0xa170
a0393724 002083e5 str      r2, [r3]
a0393728 583b0ae3 movw     r3, #0xab58
a039372c 70314ae3 movt     r3, #0xa170
a0393730 003093e5 ldr      r3, [r3]
a0393734 5c209de5 ldr      r2, [sp, #0x5c]
a0393738 920302e0 mul      r2, r2, r3
a039373c 583b0ae3 movw     r3, #0xab58
a0393740 70314ae3 movt     r3, #0xa170
a0393744 002083e5 str      r2, [r3]
a0393748 cc3504e3 movw     r3, #0x45cc
a039374c 70314ae3 movt     r3, #0xa170
a0393750 002093e5 ldr      r2, [r3]
a0393754 a13a07e3 movw     r3, #0x7aa1
a0393758 75304ae3 movt     r3, #0xa075
a039375c 0030d3e5 ldrb     r3, [r3]
a0393760 7330afe6 sxtb     r3, r3
a0393764 1233a0e1 lsl      r3, r2, r3
a0393768 903a07ee vmov     s15, r3
a039376c e70bf8ee vcvt.f64.s32 d16, s15
a0393770 e81bdfed vldr     d17, [pc, #0x3a0]
a0393774 a10b60ee vmul.f64 d16, d16, d17
a0393778 e81bdfed vldr     d17, [pc, #0x3a0]
a039377c a10bc0ee vdiv.f64 d16, d16, d17
a0393780 e07bfdee vcvt.s32.f64 s15, d16
a0393784 902a17ee vmov     r2, s15
a0393788 d03504e3 movw     r3, #0x45d0
a039378c 70314ae3 movt     r3, #0xa170
a0393790 002083e5 str      r2, [r3]
a0393794 d03504e3 movw     r3, #0x45d0
a0393798 70314ae3 movt     r3, #0xa170
a039379c 003093e5 ldr      r3, [r3]
a03937a0 0300a0e1 mov      r0, r3
a03937a4 d1c3ffeb bl       #0xa03846f0
a03937a8 383b0ae3 movw     r3, #0xab38
a03937ac 70314ae3 movt     r3, #0xa170
a03937b0 006093e5 ldr      r6, [r3]
a03937b4 583b0ae3 movw     r3, #0xab58
a03937b8 70314ae3 movt     r3, #0xa170
a03937bc 001093e5 ldr      r1, [r3]
a03937c0 003d02e3 movw     r3, #0x2d00
a03937c4 70314ae3 movt     r3, #0xa170
a03937c8 013a83e2 add      r3, r3, #0x1000
a03937cc 403393e5 ldr      r3, [r3, #0x340]
a03937d0 113d83e2 add      r3, r3, #0x440
a03937d4 083083e2 add      r3, r3, #8
a03937d8 0321a0e1 lsl      r2, r3, #2
a03937dc 003d02e3 movw     r3, #0x2d00
a03937e0 70314ae3 movt     r3, #0xa170
a03937e4 033082e0 add      r3, r2, r3
a03937e8 0200a0e3 mov      r0, #2
a03937ec 0320a0e1 mov      r2, r3
a03937f0 c6c3ffeb bl       #0xa0384710
a03937f4 0010a0e1 mov      r1, r0
a03937f8 002d02e3 movw     r2, #0x2d00
a03937fc 70214ae3 movt     r2, #0xa170
a0393800 113d86e2 add      r3, r6, #0x440
a0393804 083083e2 add      r3, r3, #8
a0393808 031182e7 str      r1, [r2, r3, lsl #2]
a039380c 383b0ae3 movw     r3, #0xab38
a0393810 70314ae3 movt     r3, #0xa170
a0393814 003093e5 ldr      r3, [r3]
a0393818 002d02e3 movw     r2, #0x2d00
a039381c 70214ae3 movt     r2, #0xa170
a0393820 113d83e2 add      r3, r3, #0x440
a0393824 083083e2 add      r3, r3, #8
a0393828 032192e7 ldr      r2, [r2, r3, lsl #2]
a039382c a03a07e3 movw     r3, #0x7aa0
a0393830 75304ae3 movt     r3, #0xa075
a0393834 0030d3e5 ldrb     r3, [r3]
a0393838 7330afe6 sxtb     r3, r3
a039383c 930203e0 mul      r3, r3, r2
a0393840 903a07ee vmov     s15, r3
a0393844 e71bf8ee vcvt.f64.s32 d17, s15
a0393848 a83a07e3 movw     r3, #0x7aa8
a039384c 75304ae3 movt     r3, #0xa075
a0393850 000bd3ed vldr     d16, [r3]
a0393854 a01b61ee vmul.f64 d17, d17, d16
a0393858 a13a07e3 movw     r3, #0x7aa1
a039385c 75304ae3 movt     r3, #0xa075
a0393860 0030d3e5 ldrb     r3, [r3]
a0393864 7330afe6 sxtb     r3, r3
a0393868 0120a0e3 mov      r2, #1
a039386c 1233a0e1 lsl      r3, r2, r3
a0393870 903a07ee vmov     s15, r3
a0393874 e70bf8ee vcvt.f64.s32 d16, s15
a0393878 a01bc1ee vdiv.f64 d17, d17, d16
a039387c c03c02e3 movw     r3, #0x2cc0
a0393880 70314ae3 movt     r3, #0xa170
a0393884 0d30d3e5 ldrb     r3, [r3, #0xd]
a0393888 7330afe6 sxtb     r3, r3
a039388c 903a07ee vmov     s15, r3
a0393890 e70bf8ee vcvt.f64.s32 d16, s15
a0393894 a00b61ee vmul.f64 d16, d17, d16
a0393898 e03504e3 movw     r3, #0x45e0
a039389c 70314ae3 movt     r3, #0xa170
a03938a0 000bc3ed vstr     d16, [r3]
a03938a4 da3504e3 movw     r3, #0x45da
a03938a8 70314ae3 movt     r3, #0xa170
a03938ac 0030d3e5 ldrb     r3, [r3]
a03938b0 000053e3 cmp      r3, #0
a03938b4 a602001a bne      #0xa0394354
a03938b8 0030a0e3 mov      r3, #0
a03938bc 4c308de5 str      r3, [sp, #0x4c]
a03938c0 f52106e3 movw     r2, #0x61f5
a03938c4 b72340e3 movt     r2, #0x3b7
a03938c8 713809e3 movw     r3, #0x9871
a03938cc 6c3f43e3 movt     r3, #0x3f6c
a03938d0 f024cde1 strd     r2, r3, [sp, #0x40]
a03938d4 543b0ae3 movw     r3, #0xab54
a03938d8 70314ae3 movt     r3, #0xa170
a03938dc 0020a0e3 mov      r2, #0
a03938e0 002083e5 str      r2, [r3]
a03938e4 6c209de5 ldr      r2, [sp, #0x6c]
a03938e8 64309de5 ldr      r3, [sp, #0x64]
a03938ec 030052e1 cmp      r2, r3
a03938f0 560000aa bge      #0xa0393a50
a03938f4 64209de5 ldr      r2, [sp, #0x64]
a03938f8 403b0ae3 movw     r3, #0xab40
a03938fc 70314ae3 movt     r3, #0xa170
a0393900 002083e5 str      r2, [r3]
a0393904 1e0000ea b        #0xa0393984
a0393908 403b0ae3 movw     r3, #0xab40
a039390c 70314ae3 movt     r3, #0xa170
a0393910 003093e5 ldr      r3, [r3]
a0393914 002d02e3 movw     r2, #0x2d00
a0393918 70214ae3 movt     r2, #0xa170
a039391c 113e83e2 add      r3, r3, #0x110
a0393920 023083e2 add      r3, r3, #2
a0393924 031192e7 ldr      r1, [r2, r3, lsl #2]
a0393928 403b0ae3 movw     r3, #0xab40
a039392c 70314ae3 movt     r3, #0xa170
a0393930 003093e5 ldr      r3, [r3]
a0393934 002d02e3 movw     r2, #0x2d00
a0393938 70214ae3 movt     r2, #0xa170
a039393c ab3f83e2 add      r3, r3, #0x2ac
a0393940 013083e2 add      r3, r3, #1
a0393944 033192e7 ldr      r3, [r2, r3, lsl #2]
a0393948 012063e0 rsb      r2, r3, r1
a039394c 543b0ae3 movw     r3, #0xab54
a0393950 70314ae3 movt     r3, #0xa170
a0393954 003093e5 ldr      r3, [r3]
a0393958 032082e0 add      r2, r2, r3
a039395c 543b0ae3 movw     r3, #0xab54
a0393960 70314ae3 movt     r3, #0xa170
a0393964 002083e5 str      r2, [r3]
a0393968 403b0ae3 movw     r3, #0xab40
a039396c 70314ae3 movt     r3, #0xa170
a0393970 003093e5 ldr      r3, [r3]
a0393974 012083e2 add      r2, r3, #1
a0393978 403b0ae3 movw     r3, #0xab40
a039397c 70314ae3 movt     r3, #0xa170
a0393980 002083e5 str      r2, [r3]
a0393984 003d02e3 movw     r3, #0x2d00
a0393988 70314ae3 movt     r3, #0xa170
a039398c 102293e5 ldr      r2, [r3, #0x210]
a0393990 403b0ae3 movw     r3, #0xab40
a0393994 70314ae3 movt     r3, #0xa170
a0393998 003093e5 ldr      r3, [r3]
a039399c 030052e1 cmp      r2, r3
a03939a0 d8ffff8a bhi      #0xa0393908
a03939a4 403b0ae3 movw     r3, #0xab40
a03939a8 70314ae3 movt     r3, #0xa170
a03939ac 0020a0e3 mov      r2, #0
a03939b0 002083e5 str      r2, [r3]
a03939b4 1e0000ea b        #0xa0393a34
a03939b8 403b0ae3 movw     r3, #0xab40
a03939bc 70314ae3 movt     r3, #0xa170
a03939c0 003093e5 ldr      r3, [r3]
a03939c4 002d02e3 movw     r2, #0x2d00
a03939c8 70214ae3 movt     r2, #0xa170
a03939cc 113e83e2 add      r3, r3, #0x110
a03939d0 023083e2 add      r3, r3, #2
a03939d4 031192e7 ldr      r1, [r2, r3, lsl #2]
a03939d8 403b0ae3 movw     r3, #0xab40
a03939dc 70314ae3 movt     r3, #0xa170
a03939e0 003093e5 ldr      r3, [r3]
a03939e4 002d02e3 movw     r2, #0x2d00
a03939e8 70214ae3 movt     r2, #0xa170
a03939ec ab3f83e2 add      r3, r3, #0x2ac
a03939f0 013083e2 add      r3, r3, #1
a03939f4 033192e7 ldr      r3, [r2, r3, lsl #2]
a03939f8 012063e0 rsb      r2, r3, r1
a03939fc 543b0ae3 movw     r3, #0xab54
a0393a00 70314ae3 movt     r3, #0xa170
a0393a04 003093e5 ldr      r3, [r3]
a0393a08 032082e0 add      r2, r2, r3
a0393a0c 543b0ae3 movw     r3, #0xab54
a0393a10 70314ae3 movt     r3, #0xa170
a0393a14 002083e5 str      r2, [r3]
a0393a18 403b0ae3 movw     r3, #0xab40
a0393a1c 70314ae3 movt     r3, #0xa170
a0393a20 003093e5 ldr      r3, [r3]
a0393a24 012083e2 add      r2, r3, #1
a0393a28 403b0ae3 movw     r3, #0xab40
a0393a2c 70314ae3 movt     r3, #0xa170
a0393a30 002083e5 str      r2, [r3]
a0393a34 6c209de5 ldr      r2, [sp, #0x6c]
a0393a38 403b0ae3 movw     r3, #0xab40
a0393a3c 70314ae3 movt     r3, #0xa170
a0393a40 003093e5 ldr      r3, [r3]
a0393a44 030052e1 cmp      r2, r3
a0393a48 daffff2a bhs      #0xa03939b8
a0393a4c 290000ea b        #0xa0393af8
a0393a50 64209de5 ldr      r2, [sp, #0x64]
a0393a54 403b0ae3 movw     r3, #0xab40
a0393a58 70314ae3 movt     r3, #0xa170
a0393a5c 002083e5 str      r2, [r3]
a0393a60 1e0000ea b        #0xa0393ae0
a0393a64 403b0ae3 movw     r3, #0xab40
a0393a68 70314ae3 movt     r3, #0xa170
a0393a6c 003093e5 ldr      r3, [r3]
a0393a70 002d02e3 movw     r2, #0x2d00
a0393a74 70214ae3 movt     r2, #0xa170
a0393a78 113e83e2 add      r3, r3, #0x110
a0393a7c 023083e2 add      r3, r3, #2
a0393a80 031192e7 ldr      r1, [r2, r3, lsl #2]
a0393a84 403b0ae3 movw     r3, #0xab40
a0393a88 70314ae3 movt     r3, #0xa170
a0393a8c 003093e5 ldr      r3, [r3]
a0393a90 002d02e3 movw     r2, #0x2d00
a0393a94 70214ae3 movt     r2, #0xa170
a0393a98 ab3f83e2 add      r3, r3, #0x2ac
a0393a9c 013083e2 add      r3, r3, #1
a0393aa0 033192e7 ldr      r3, [r2, r3, lsl #2]
a0393aa4 012063e0 rsb      r2, r3, r1
a0393aa8 543b0ae3 movw     r3, #0xab54
a0393aac 70314ae3 movt     r3, #0xa170
a0393ab0 003093e5 ldr      r3, [r3]
a0393ab4 032082e0 add      r2, r2, r3
a0393ab8 543b0ae3 movw     r3, #0xab54
a0393abc 70314ae3 movt     r3, #0xa170
a0393ac0 002083e5 str      r2, [r3]
a0393ac4 403b0ae3 movw     r3, #0xab40
a0393ac8 70314ae3 movt     r3, #0xa170
a0393acc 003093e5 ldr      r3, [r3]
a0393ad0 012083e2 add      r2, r3, #1
a0393ad4 403b0ae3 movw     r3, #0xab40
a0393ad8 70314ae3 movt     r3, #0xa170
a0393adc 002083e5 str      r2, [r3]
a0393ae0 6c209de5 ldr      r2, [sp, #0x6c]
a0393ae4 403b0ae3 movw     r3, #0xab40
a0393ae8 70314ae3 movt     r3, #0xa170
a0393aec 003093e5 ldr      r3, [r3]
a0393af0 030052e1 cmp      r2, r3
a0393af4 daffff2a bhs      #0xa0393a64
a0393af8 543b0ae3 movw     r3, #0xab54
a0393afc 70314ae3 movt     r3, #0xa170
a0393b00 003093e5 ldr      r3, [r3]
a0393b04 000053e3 cmp      r3, #0
a0393b08 080000ba blt      #0xa0393b30
a0393b0c 0130a0e3 mov      r3, #1
a0393b10 5c308de5 str      r3, [sp, #0x5c]
a0393b14 0e0000ea b        #0xa0393b54
a0393b18 182d4454 strbpl   r2, [r4], #-0xd18
a0393b1c fb210940 strdmi   r2, r3, [sb], -fp
a0393b20 00000000 andeq    r0, r0, r0
a0393b24 00806640 rsbmi    r8, r6, r0
a0393b28 9a999999 ldmibls  sb, {r1, r3, r4, r7, r8, fp, ip, pc}
a0393b2c 9999993f svclo    #0x999999
a0393b30 0030e0e3 mvn      r3, #0
a0393b34 5c308de5 str      r3, [sp, #0x5c]
a0393b38 543b0ae3 movw     r3, #0xab54
a0393b3c 70314ae3 movt     r3, #0xa170
a0393b40 003093e5 ldr      r3, [r3]
a0393b44 002063e2 rsb      r2, r3, #0
a0393b48 543b0ae3 movw     r3, #0xab54
a0393b4c 70314ae3 movt     r3, #0xa170
a0393b50 002083e5 str      r2, [r3]
a0393b54 543b0ae3 movw     r3, #0xab54
a0393b58 70314ae3 movt     r3, #0xa170
a0393b5c 003093e5 ldr      r3, [r3]
a0393b60 0320a0e1 mov      r2, r3
a0393b64 c23fa0e1 asr      r3, r2, #0x1f
a0393b68 a11a07e3 movw     r1, #0x7aa1
a0393b6c 75104ae3 movt     r1, #0xa075
a0393b70 0010d1e5 ldrb     r1, [r1]
a0393b74 7110afe6 sxtb     r1, r1
a0393b78 081041e2 sub      r1, r1, #8
a0393b7c 20c041e2 sub      ip, r1, #0x20
a0393b80 200061e2 rsb      r0, r1, #0x20
a0393b84 1351a0e1 lsl      r5, r3, r1
a0393b88 125c85e1 orr      r5, r5, r2, lsl ip
a0393b8c 325085e1 orr      r5, r5, r2, lsr r0
a0393b90 1241a0e1 lsl      r4, r2, r1
a0393b94 443004e3 movw     r3, #0x4044
a0393b98 70314ae3 movt     r3, #0xa170
a0393b9c 0930d3e5 ldrb     r3, [r3, #9]
a0393ba0 0334a0e1 lsl      r3, r3, #8
a0393ba4 00308de5 str      r3, [sp]
a0393ba8 0200a0e3 mov      r0, #2
a0393bac 0420a0e1 mov      r2, r4
a0393bb0 0530a0e1 mov      r3, r5
a0393bb4 95c3ffeb bl       #0xa0384a10
a0393bb8 4c008de5 str      r0, [sp, #0x4c]
a0393bbc 4c309de5 ldr      r3, [sp, #0x4c]
a0393bc0 5c209de5 ldr      r2, [sp, #0x5c]
a0393bc4 920303e0 mul      r3, r2, r3
a0393bc8 4c308de5 str      r3, [sp, #0x4c]
a0393bcc 003d02e3 movw     r3, #0x2d00
a0393bd0 70314ae3 movt     r3, #0xa170
a0393bd4 013a83e2 add      r3, r3, #0x1000
a0393bd8 403393e5 ldr      r3, [r3, #0x340]
a0393bdc 113d83e2 add      r3, r3, #0x440
a0393be0 083083e2 add      r3, r3, #8
a0393be4 0321a0e1 lsl      r2, r3, #2
a0393be8 003d02e3 movw     r3, #0x2d00
a0393bec 70314ae3 movt     r3, #0xa170
a0393bf0 033082e0 add      r3, r2, r3
a0393bf4 0200a0e3 mov      r0, #2
a0393bf8 4c109de5 ldr      r1, [sp, #0x4c]
a0393bfc 0320a0e1 mov      r2, r3
a0393c00 c2c2ffeb bl       #0xa0384710
a0393c04 0020a0e1 mov      r2, r0
a0393c08 383f0ae3 movw     r3, #0xaf38
a0393c0c 70314ae3 movt     r3, #0xa170
a0393c10 002083e5 str      r2, [r3]
a0393c14 a03a07e3 movw     r3, #0x7aa0
a0393c18 75304ae3 movt     r3, #0xa075
a0393c1c 0030d3e5 ldrb     r3, [r3]
a0393c20 7320afe6 sxtb     r2, r3
a0393c24 383f0ae3 movw     r3, #0xaf38
a0393c28 70314ae3 movt     r3, #0xa170
a0393c2c 003093e5 ldr      r3, [r3]
a0393c30 930203e0 mul      r3, r3, r2
a0393c34 903a07ee vmov     s15, r3
a0393c38 e71bf8ee vcvt.f64.s32 d17, s15
a0393c3c a83a07e3 movw     r3, #0x7aa8
a0393c40 75304ae3 movt     r3, #0xa075
a0393c44 000bd3ed vldr     d16, [r3]
a0393c48 a01b61ee vmul.f64 d17, d17, d16
a0393c4c a13a07e3 movw     r3, #0x7aa1
a0393c50 75304ae3 movt     r3, #0xa075
a0393c54 0030d3e5 ldrb     r3, [r3]
a0393c58 7330afe6 sxtb     r3, r3
a0393c5c 0120a0e3 mov      r2, #1
a0393c60 1233a0e1 lsl      r3, r2, r3
a0393c64 903a07ee vmov     s15, r3
a0393c68 e70bf8ee vcvt.f64.s32 d16, s15
a0393c6c a01bc1ee vdiv.f64 d17, d17, d16
a0393c70 c03c02e3 movw     r3, #0x2cc0
a0393c74 70314ae3 movt     r3, #0xa170
a0393c78 0d30d3e5 ldrb     r3, [r3, #0xd]
a0393c7c 7330afe6 sxtb     r3, r3
a0393c80 903a07ee vmov     s15, r3
a0393c84 e70bf8ee vcvt.f64.s32 d16, s15
a0393c88 a00b61ee vmul.f64 d16, d17, d16
a0393c8c 403f0ae3 movw     r3, #0xaf40
a0393c90 70314ae3 movt     r3, #0xa170
a0393c94 000bc3ed vstr     d16, [r3]
a0393c98 403f0ae3 movw     r3, #0xaf40
a0393c9c 70314ae3 movt     r3, #0xa170
a0393ca0 001bd3ed vldr     d17, [r3]
a0393ca4 683f0ae3 movw     r3, #0xaf68
a0393ca8 70314ae3 movt     r3, #0xa170
a0393cac 000bd3ed vldr     d16, [r3]
a0393cb0 e00b71ee vsub.f64 d16, d17, d16
a0393cb4 503f0ae3 movw     r3, #0xaf50
a0393cb8 70314ae3 movt     r3, #0xa170
a0393cbc 000bc3ed vstr     d16, [r3]
a0393cc0 503f0ae3 movw     r3, #0xaf50
a0393cc4 70314ae3 movt     r3, #0xa170
a0393cc8 001bd3ed vldr     d17, [r3]
a0393ccc 783f0ae3 movw     r3, #0xaf78
a0393cd0 70314ae3 movt     r3, #0xa170
a0393cd4 000bd3ed vldr     d16, [r3]
a0393cd8 e00b71ee vsub.f64 d16, d17, d16
a0393cdc 703f0ae3 movw     r3, #0xaf70
a0393ce0 70314ae3 movt     r3, #0xa170
a0393ce4 000bc3ed vstr     d16, [r3]
a0393ce8 503f0ae3 movw     r3, #0xaf50
a0393cec 70314ae3 movt     r3, #0xa170
a0393cf0 d000c3e1 ldrd     r0, r1, [r3]
a0393cf4 783f0ae3 movw     r3, #0xaf78
a0393cf8 70314ae3 movt     r3, #0xa170
a0393cfc f000c3e1 strd     r0, r1, [r3]
a0393d00 403f0ae3 movw     r3, #0xaf40
a0393d04 70314ae3 movt     r3, #0xa170
a0393d08 001bd3ed vldr     d17, [r3]
a0393d0c 483f0ae3 movw     r3, #0xaf48
a0393d10 70314ae3 movt     r3, #0xa170
a0393d14 000bd3ed vldr     d16, [r3]
a0393d18 e00b71ee vsub.f64 d16, d17, d16
a0393d1c 583f0ae3 movw     r3, #0xaf58
a0393d20 70314ae3 movt     r3, #0xa170
a0393d24 000bc3ed vstr     d16, [r3]
a0393d28 403f0ae3 movw     r3, #0xaf40
a0393d2c 70314ae3 movt     r3, #0xa170
a0393d30 d000c3e1 ldrd     r0, r1, [r3]
a0393d34 483f0ae3 movw     r3, #0xaf48
a0393d38 70314ae3 movt     r3, #0xa170
a0393d3c f000c3e1 strd     r0, r1, [r3]
a0393d40 383f0ae3 movw     r3, #0xaf38
a0393d44 70314ae3 movt     r3, #0xa170
a0393d48 003093e5 ldr      r3, [r3]
a0393d4c 000053e3 cmp      r3, #0
a0393d50 020000ba blt      #0xa0393d60
a0393d54 0130a0e3 mov      r3, #1
a0393d58 54308de5 str      r3, [sp, #0x54]
a0393d5c 010000ea b        #0xa0393d68
a0393d60 0030e0e3 mvn      r3, #0
a0393d64 54308de5 str      r3, [sp, #0x54]
a0393d68 003d02e3 movw     r3, #0x2d00
a0393d6c 70314ae3 movt     r3, #0xa170
a0393d70 013a83e2 add      r3, r3, #0x1000
a0393d74 403393e5 ldr      r3, [r3, #0x340]
a0393d78 002d02e3 movw     r2, #0x2d00
a0393d7c 70214ae3 movt     r2, #0xa170
a0393d80 113d83e2 add      r3, r3, #0x440
a0393d84 083083e2 add      r3, r3, #8
a0393d88 033192e7 ldr      r3, [r2, r3, lsl #2]
a0393d8c 000053e3 cmp      r3, #0
a0393d90 040000ba blt      #0xa0393da8
a0393d94 643b07e3 movw     r3, #0x7b64
a0393d98 75304ae3 movt     r3, #0xa075
a0393d9c 0120a0e3 mov      r2, #1
a0393da0 002083e5 str      r2, [r3]
a0393da4 030000ea b        #0xa0393db8
a0393da8 643b07e3 movw     r3, #0x7b64
a0393dac 75304ae3 movt     r3, #0xa075
a0393db0 0020e0e3 mvn      r2, #0
a0393db4 002083e5 str      r2, [r3]
a0393db8 603f0ae3 movw     r3, #0xaf60
a0393dbc 70314ae3 movt     r3, #0xa170
a0393dc0 0000a0e3 mov      r0, #0
a0393dc4 0010a0e3 mov      r1, #0
a0393dc8 f000c3e1 strd     r0, r1, [r3]
a0393dcc 643b07e3 movw     r3, #0x7b64
a0393dd0 75304ae3 movt     r3, #0xa075
a0393dd4 003093e5 ldr      r3, [r3]
a0393dd8 54209de5 ldr      r2, [sp, #0x54]
a0393ddc 920303e0 mul      r3, r2, r3
a0393de0 010073e3 cmn      r3, #1
a0393de4 2d00001a bne      #0xa0393ea0
a0393de8 303f0ae3 movw     r3, #0xaf30
a0393dec 70314ae3 movt     r3, #0xa170
a0393df0 003093e5 ldr      r3, [r3]
a0393df4 012043e2 sub      r2, r3, #1
a0393df8 303f0ae3 movw     r3, #0xaf30
a0393dfc 70314ae3 movt     r3, #0xa170
a0393e00 002083e5 str      r2, [r3]
a0393e04 303f0ae3 movw     r3, #0xaf30
a0393e08 70314ae3 movt     r3, #0xa170
a0393e0c 003093e5 ldr      r3, [r3]
a0393e10 280073e3 cmn      r3, #0x28
a0393e14 030000aa bge      #0xa0393e28
a0393e18 303f0ae3 movw     r3, #0xaf30
a0393e1c 70314ae3 movt     r3, #0xa170
a0393e20 2720e0e3 mvn      r2, #0x27
a0393e24 002083e5 str      r2, [r3]
a0393e28 303f0ae3 movw     r3, #0xaf30
a0393e2c 70314ae3 movt     r3, #0xa170
a0393e30 003093e5 ldr      r3, [r3]
a0393e34 903a07ee vmov     s15, r3
a0393e38 e70bf8ee vcvt.f64.s32 d16, s15
a0393e3c c71b5fed vldr     d17, [pc, #-0x31c]
a0393e40 a10b60ee vmul.f64 d16, d16, d17
a0393e44 e07bf7ee vcvt.f32.f64 s15, d16
a0393e48 343f0ae3 movw     r3, #0xaf34
a0393e4c 70314ae3 movt     r3, #0xa170
a0393e50 007ac3ed vstr     s15, [r3]
a0393e54 cc3a07e3 movw     r3, #0x7acc
a0393e58 75304ae3 movt     r3, #0xa075
a0393e5c 007a93ed vldr     s14, [r3]
a0393e60 343f0ae3 movw     r3, #0xaf34
a0393e64 70314ae3 movt     r3, #0xa170
a0393e68 007ad3ed vldr     s15, [r3]
a0393e6c 277a77ee vadd.f32 s15, s14, s15
a0393e70 343f0ae3 movw     r3, #0xaf34
a0393e74 70314ae3 movt     r3, #0xa170
a0393e78 007ac3ed vstr     s15, [r3]
a0393e7c 813f0ae3 movw     r3, #0xaf81
a0393e80 70314ae3 movt     r3, #0xa170
a0393e84 0020a0e3 mov      r2, #0
a0393e88 0020c3e5 strb     r2, [r3]
a0393e8c 843f0ae3 movw     r3, #0xaf84
a0393e90 70314ae3 movt     r3, #0xa170
a0393e94 0020a0e3 mov      r2, #0
a0393e98 002083e5 str      r2, [r3]
a0393e9c 220100ea b        #0xa039432c
a0393ea0 583f0ae3 movw     r3, #0xaf58
a0393ea4 70314ae3 movt     r3, #0xa170
a0393ea8 000bd3ed vldr     d16, [r3]
a0393eac c00bf5ee vcmpe.f64 d16, #0
a0393eb0 10faf1ee vmrs     apsr_nzcv, fpscr
a0393eb4 3b0000ba blt      #0xa0393fa8
a0393eb8 100bdded vldr     d16, [sp, #0x40]
a0393ebc 601bf1ee vneg.f64 d17, d16
a0393ec0 703f0ae3 movw     r3, #0xaf70
a0393ec4 70314ae3 movt     r3, #0xa170
a0393ec8 000bd3ed vldr     d16, [r3]
a0393ecc e01bf4ee vcmpe.f64 d17, d16
a0393ed0 10faf1ee vmrs     apsr_nzcv, fpscr
a0393ed4 1d0000da ble      #0xa0393f50
a0393ed8 813f0ae3 movw     r3, #0xaf81
a0393edc 70314ae3 movt     r3, #0xa170
a0393ee0 0030d3e5 ldrb     r3, [r3]
a0393ee4 000053e3 cmp      r3, #0
a0393ee8 6800001a bne      #0xa0394090
a0393eec 303f0ae3 movw     r3, #0xaf30
a0393ef0 70314ae3 movt     r3, #0xa170
a0393ef4 003093e5 ldr      r3, [r3]
a0393ef8 052043e2 sub      r2, r3, #5
a0393efc 303f0ae3 movw     r3, #0xaf30
a0393f00 70314ae3 movt     r3, #0xa170
a0393f04 002083e5 str      r2, [r3]
a0393f08 303f0ae3 movw     r3, #0xaf30
a0393f0c 70314ae3 movt     r3, #0xa170
a0393f10 003093e5 ldr      r3, [r3]
a0393f14 280073e3 cmn      r3, #0x28
a0393f18 030000aa bge      #0xa0393f2c
a0393f1c 303f0ae3 movw     r3, #0xaf30
a0393f20 70314ae3 movt     r3, #0xa170
a0393f24 2720e0e3 mvn      r2, #0x27
a0393f28 002083e5 str      r2, [r3]
a0393f2c 813f0ae3 movw     r3, #0xaf81
a0393f30 70314ae3 movt     r3, #0xa170
a0393f34 0120a0e3 mov      r2, #1
a0393f38 0020c3e5 strb     r2, [r3]
a0393f3c 843f0ae3 movw     r3, #0xaf84
a0393f40 70314ae3 movt     r3, #0xa170
a0393f44 0020a0e3 mov      r2, #0
a0393f48 002083e5 str      r2, [r3]
a0393f4c 4f0000ea b        #0xa0394090
a0393f50 813f0ae3 movw     r3, #0xaf81
a0393f54 70314ae3 movt     r3, #0xa170
a0393f58 0030d3e5 ldrb     r3, [r3]
a0393f5c 000053e3 cmp      r3, #0
a0393f60 4a00001a bne      #0xa0394090
a0393f64 843f0ae3 movw     r3, #0xaf84
a0393f68 70314ae3 movt     r3, #0xa170
a0393f6c 003093e5 ldr      r3, [r3]
a0393f70 012083e2 add      r2, r3, #1
a0393f74 843f0ae3 movw     r3, #0xaf84
a0393f78 70314ae3 movt     r3, #0xa170
a0393f7c 002083e5 str      r2, [r3]
a0393f80 843f0ae3 movw     r3, #0xaf84
a0393f84 70314ae3 movt     r3, #0xa170
a0393f88 003093e5 ldr      r3, [r3]
a0393f8c 0a0053e3 cmp      r3, #0xa
a0393f90 3e00009a bls      #0xa0394090
a0393f94 813f0ae3 movw     r3, #0xaf81
a0393f98 70314ae3 movt     r3, #0xa170
a0393f9c 0120a0e3 mov      r2, #1
a0393fa0 0020c3e5 strb     r2, [r3]
a0393fa4 390000ea b        #0xa0394090
a0393fa8 703f0ae3 movw     r3, #0xaf70
a0393fac 70314ae3 movt     r3, #0xa170
a0393fb0 001bd3ed vldr     d17, [r3]
a0393fb4 100bdded vldr     d16, [sp, #0x40]
a0393fb8 e01bf4ee vcmpe.f64 d17, d16
a0393fbc 10faf1ee vmrs     apsr_nzcv, fpscr
a0393fc0 1d0000da ble      #0xa039403c
a0393fc4 813f0ae3 movw     r3, #0xaf81
a0393fc8 70314ae3 movt     r3, #0xa170
a0393fcc 0030d3e5 ldrb     r3, [r3]
a0393fd0 000053e3 cmp      r3, #0
a0393fd4 2d00001a bne      #0xa0394090
a0393fd8 303f0ae3 movw     r3, #0xaf30
a0393fdc 70314ae3 movt     r3, #0xa170
a0393fe0 003093e5 ldr      r3, [r3]
a0393fe4 052043e2 sub      r2, r3, #5
a0393fe8 303f0ae3 movw     r3, #0xaf30
a0393fec 70314ae3 movt     r3, #0xa170
a0393ff0 002083e5 str      r2, [r3]
a0393ff4 303f0ae3 movw     r3, #0xaf30
a0393ff8 70314ae3 movt     r3, #0xa170
a0393ffc 003093e5 ldr      r3, [r3]
a0394000 280073e3 cmn      r3, #0x28
a0394004 030000aa bge      #0xa0394018
a0394008 303f0ae3 movw     r3, #0xaf30
a039400c 70314ae3 movt     r3, #0xa170
a0394010 2720e0e3 mvn      r2, #0x27
a0394014 002083e5 str      r2, [r3]
a0394018 813f0ae3 movw     r3, #0xaf81
a039401c 70314ae3 movt     r3, #0xa170
a0394020 0120a0e3 mov      r2, #1
a0394024 0020c3e5 strb     r2, [r3]
a0394028 843f0ae3 movw     r3, #0xaf84
a039402c 70314ae3 movt     r3, #0xa170
a0394030 0020a0e3 mov      r2, #0
a0394034 002083e5 str      r2, [r3]
a0394038 140000ea b        #0xa0394090
a039403c 813f0ae3 movw     r3, #0xaf81
a0394040 70314ae3 movt     r3, #0xa170
a0394044 0030d3e5 ldrb     r3, [r3]
a0394048 000053e3 cmp      r3, #0
a039404c 0f00001a bne      #0xa0394090
a0394050 843f0ae3 movw     r3, #0xaf84
a0394054 70314ae3 movt     r3, #0xa170
a0394058 003093e5 ldr      r3, [r3]
a039405c 012083e2 add      r2, r3, #1
a0394060 843f0ae3 movw     r3, #0xaf84
a0394064 70314ae3 movt     r3, #0xa170
a0394068 002083e5 str      r2, [r3]
a039406c 843f0ae3 movw     r3, #0xaf84
a0394070 70314ae3 movt     r3, #0xa170
a0394074 003093e5 ldr      r3, [r3]
a0394078 0a0053e3 cmp      r3, #0xa
a039407c 0300009a bls      #0xa0394090
a0394080 813f0ae3 movw     r3, #0xaf81
a0394084 70314ae3 movt     r3, #0xa170
a0394088 0120a0e3 mov      r2, #1
a039408c 0020c3e5 strb     r2, [r3]
a0394090 e03504e3 movw     r3, #0x45e0
a0394094 70314ae3 movt     r3, #0xa170
a0394098 000bd3ed vldr     d16, [r3]
a039409c c00bf5ee vcmpe.f64 d16, #0
a03940a0 10faf1ee vmrs     apsr_nzcv, fpscr
a03940a4 4c0000ba blt      #0xa03941dc
a03940a8 ec3a07e3 movw     r3, #0x7aec
a03940ac 75304ae3 movt     r3, #0xa075
a03940b0 007ad3ed vldr     s15, [r3]
a03940b4 e71af7ee vcvt.f64.f32 d17, s15
a03940b8 100bdded vldr     d16, [sp, #0x40]
a03940bc a01b61ee vmul.f64 d17, d17, d16
a03940c0 e03504e3 movw     r3, #0x45e0
a03940c4 70314ae3 movt     r3, #0xa170
a03940c8 000bd3ed vldr     d16, [r3]
a03940cc e01bf4ee vcmpe.f64 d17, d16
a03940d0 10faf1ee vmrs     apsr_nzcv, fpscr
a03940d4 400000da ble      #0xa03941dc
a03940d8 813f0ae3 movw     r3, #0xaf81
a03940dc 70314ae3 movt     r3, #0xa170
a03940e0 0030d3e5 ldrb     r3, [r3]
a03940e4 000053e3 cmp      r3, #0
a03940e8 3b00000a beq      #0xa03941dc
a03940ec 843f0ae3 movw     r3, #0xaf84
a03940f0 70314ae3 movt     r3, #0xa170
a03940f4 003093e5 ldr      r3, [r3]
a03940f8 0a0053e3 cmp      r3, #0xa
a03940fc 0f00009a bls      #0xa0394140
a0394100 303f0ae3 movw     r3, #0xaf30
a0394104 70314ae3 movt     r3, #0xa170
a0394108 003093e5 ldr      r3, [r3]
a039410c 052083e2 add      r2, r3, #5
a0394110 303f0ae3 movw     r3, #0xaf30
a0394114 70314ae3 movt     r3, #0xa170
a0394118 002083e5 str      r2, [r3]
a039411c 303f0ae3 movw     r3, #0xaf30
a0394120 70314ae3 movt     r3, #0xa170
a0394124 003093e5 ldr      r3, [r3]
a0394128 000053e3 cmp      r3, #0
a039412c 030000da ble      #0xa0394140
a0394130 303f0ae3 movw     r3, #0xaf30
a0394134 70314ae3 movt     r3, #0xa170
a0394138 0020a0e3 mov      r2, #0
a039413c 002083e5 str      r2, [r3]
a0394140 303f0ae3 movw     r3, #0xaf30
a0394144 70314ae3 movt     r3, #0xa170
a0394148 003093e5 ldr      r3, [r3]
a039414c 000053e3 cmp      r3, #0
a0394150 0b0000aa bge      #0xa0394184
a0394154 303f0ae3 movw     r3, #0xaf30
a0394158 70314ae3 movt     r3, #0xa170
a039415c 003093e5 ldr      r3, [r3]
a0394160 903a07ee vmov     s15, r3
a0394164 e70bf8ee vcvt.f64.s32 d16, s15
a0394168 d41bdfed vldr     d17, [pc, #0x350]
a039416c a10b60ee vmul.f64 d16, d16, d17
a0394170 e07bf7ee vcvt.f32.f64 s15, d16
a0394174 343f0ae3 movw     r3, #0xaf34
a0394178 70314ae3 movt     r3, #0xa170
a039417c 007ac3ed vstr     s15, [r3]
a0394180 030000ea b        #0xa0394194
a0394184 343f0ae3 movw     r3, #0xaf34
a0394188 70314ae3 movt     r3, #0xa170
a039418c 0020a0e3 mov      r2, #0
a0394190 002083e5 str      r2, [r3]
a0394194 cc3a07e3 movw     r3, #0x7acc
a0394198 75304ae3 movt     r3, #0xa075
a039419c 007a93ed vldr     s14, [r3]
a03941a0 343f0ae3 movw     r3, #0xaf34
a03941a4 70314ae3 movt     r3, #0xa170
a03941a8 007ad3ed vldr     s15, [r3]
a03941ac 277a77ee vadd.f32 s15, s14, s15
a03941b0 343f0ae3 movw     r3, #0xaf34
a03941b4 70314ae3 movt     r3, #0xa170
a03941b8 007ac3ed vstr     s15, [r3]
a03941bc 813f0ae3 movw     r3, #0xaf81
a03941c0 70314ae3 movt     r3, #0xa170
a03941c4 0020a0e3 mov      r2, #0
a03941c8 0020c3e5 strb     r2, [r3]
a03941cc 843f0ae3 movw     r3, #0xaf84
a03941d0 70314ae3 movt     r3, #0xa170
a03941d4 0020a0e3 mov      r2, #0
a03941d8 002083e5 str      r2, [r3]
a03941dc e03504e3 movw     r3, #0x45e0
a03941e0 70314ae3 movt     r3, #0xa170
a03941e4 000bd3ed vldr     d16, [r3]
a03941e8 c00bf5ee vcmpe.f64 d16, #0
a03941ec 10faf1ee vmrs     apsr_nzcv, fpscr
a03941f0 4d00005a bpl      #0xa039432c
a03941f4 ec3a07e3 movw     r3, #0x7aec
a03941f8 75304ae3 movt     r3, #0xa075
a03941fc 007ad3ed vldr     s15, [r3]
a0394200 677af1ee vneg.f32 s15, s15
a0394204 e71af7ee vcvt.f64.f32 d17, s15
a0394208 100bdded vldr     d16, [sp, #0x40]
a039420c a01b61ee vmul.f64 d17, d17, d16
a0394210 e03504e3 movw     r3, #0x45e0
a0394214 70314ae3 movt     r3, #0xa170
a0394218 000bd3ed vldr     d16, [r3]
a039421c e01bf4ee vcmpe.f64 d17, d16
a0394220 10faf1ee vmrs     apsr_nzcv, fpscr
a0394224 4000005a bpl      #0xa039432c
a0394228 813f0ae3 movw     r3, #0xaf81
a039422c 70314ae3 movt     r3, #0xa170
a0394230 0030d3e5 ldrb     r3, [r3]
a0394234 000053e3 cmp      r3, #0
a0394238 3b00000a beq      #0xa039432c
a039423c 843f0ae3 movw     r3, #0xaf84
a0394240 70314ae3 movt     r3, #0xa170
a0394244 003093e5 ldr      r3, [r3]
a0394248 0a0053e3 cmp      r3, #0xa
a039424c 0f00009a bls      #0xa0394290
a0394250 303f0ae3 movw     r3, #0xaf30
a0394254 70314ae3 movt     r3, #0xa170
a0394258 003093e5 ldr      r3, [r3]
a039425c 052083e2 add      r2, r3, #5
a0394260 303f0ae3 movw     r3, #0xaf30
a0394264 70314ae3 movt     r3, #0xa170
a0394268 002083e5 str      r2, [r3]
a039426c 303f0ae3 movw     r3, #0xaf30
a0394270 70314ae3 movt     r3, #0xa170
a0394274 003093e5 ldr      r3, [r3]
a0394278 000053e3 cmp      r3, #0
a039427c 030000da ble      #0xa0394290
a0394280 303f0ae3 movw     r3, #0xaf30
a0394284 70314ae3 movt     r3, #0xa170
a0394288 0020a0e3 mov      r2, #0
a039428c 002083e5 str      r2, [r3]
a0394290 303f0ae3 movw     r3, #0xaf30
a0394294 70314ae3 movt     r3, #0xa170
a0394298 003093e5 ldr      r3, [r3]
a039429c 000053e3 cmp      r3, #0
a03942a0 0b0000aa bge      #0xa03942d4
a03942a4 303f0ae3 movw     r3, #0xaf30
a03942a8 70314ae3 movt     r3, #0xa170
a03942ac 003093e5 ldr      r3, [r3]
a03942b0 903a07ee vmov     s15, r3
a03942b4 e70bf8ee vcvt.f64.s32 d16, s15
a03942b8 801bdfed vldr     d17, [pc, #0x200]
a03942bc a10b60ee vmul.f64 d16, d16, d17
a03942c0 e07bf7ee vcvt.f32.f64 s15, d16
a03942c4 343f0ae3 movw     r3, #0xaf34
a03942c8 70314ae3 movt     r3, #0xa170
a03942cc 007ac3ed vstr     s15, [r3]
a03942d0 030000ea b        #0xa03942e4
a03942d4 343f0ae3 movw     r3, #0xaf34
a03942d8 70314ae3 movt     r3, #0xa170
a03942dc 0020a0e3 mov      r2, #0
a03942e0 002083e5 str      r2, [r3]
a03942e4 cc3a07e3 movw     r3, #0x7acc
a03942e8 75304ae3 movt     r3, #0xa075
a03942ec 007a93ed vldr     s14, [r3]
a03942f0 343f0ae3 movw     r3, #0xaf34
a03942f4 70314ae3 movt     r3, #0xa170
a03942f8 007ad3ed vldr     s15, [r3]
a03942fc 277a77ee vadd.f32 s15, s14, s15
a0394300 343f0ae3 movw     r3, #0xaf34
a0394304 70314ae3 movt     r3, #0xa170
a0394308 007ac3ed vstr     s15, [r3]
a039430c 813f0ae3 movw     r3, #0xaf81
a0394310 70314ae3 movt     r3, #0xa170
a0394314 0020a0e3 mov      r2, #0
a0394318 0020c3e5 strb     r2, [r3]
a039431c 843f0ae3 movw     r3, #0xaf84
a0394320 70314ae3 movt     r3, #0xa170
a0394324 0020a0e3 mov      r2, #0
a0394328 002083e5 str      r2, [r3]
a039432c 343f0ae3 movw     r3, #0xaf34
a0394330 70314ae3 movt     r3, #0xa170
a0394334 007ad3ed vldr     s15, [r3]
a0394338 c07af5ee vcmpe.f32 s15, #0
a039433c 10faf1ee vmrs     apsr_nzcv, fpscr
a0394340 0300005a bpl      #0xa0394354
a0394344 343f0ae3 movw     r3, #0xaf34
a0394348 70314ae3 movt     r3, #0xa170
a039434c 0020a0e3 mov      r2, #0
a0394350 002083e5 str      r2, [r3]
a0394354 f83a07e3 movw     r3, #0x7af8
a0394358 75304ae3 movt     r3, #0xa075
a039435c b830d3e1 ldrh     r3, [r3, #8]
a0394360 000053e3 cmp      r3, #0
a0394364 1500000a beq      #0xa03943c0
a0394368 e03504e3 movw     r3, #0x45e0
a039436c 70314ae3 movt     r3, #0xa170
a0394370 000bd3ed vldr     d16, [r3]
a0394374 531bdfed vldr     d17, [pc, #0x14c]
a0394378 a10b60ee vmul.f64 d16, d16, d17
a039437c 531bdfed vldr     d17, [pc, #0x14c]
a0394380 a10bc0ee vdiv.f64 d16, d16, d17
a0394384 c83004e3 movw     r3, #0x40c8
a0394388 70314ae3 movt     r3, #0xa170
a039438c d021c3e1 ldrd     r2, r3, [r3, #0x10]
a0394390 2284a0e1 lsr      r8, r2, #8
a0394394 038c88e1 orr      r8, r8, r3, lsl #24
a0394398 2394a0e1 lsr      sb, r3, #8
a039439c f080cde1 strd     r8, sb, [sp]
a03943a0 58309de5 ldr      r3, [sp, #0x58]
a03943a4 08308de5 str      r3, [sp, #8]
a03943a8 68309de5 ldr      r3, [sp, #0x68]
a03943ac 0c308de5 str      r3, [sp, #0xc]
a03943b0 1c0b00e3 movw     r0, #0xb1c
a03943b4 60004ae3 movt     r0, #0xa060
a03943b8 302b53ec vmov     r2, r3, d16
a03943bc 4a4bfceb bl       #0xa02a70ec
a03943c0 383b0ae3 movw     r3, #0xab38
a03943c4 70314ae3 movt     r3, #0xa170
a03943c8 003093e5 ldr      r3, [r3]
a03943cc 0320a0e1 mov      r2, r3
a03943d0 003d02e3 movw     r3, #0x2d00
a03943d4 70314ae3 movt     r3, #0xa170
a03943d8 013a83e2 add      r3, r3, #0x1000
a03943dc 402383e5 str      r2, [r3, #0x340]
a03943e0 cc3504e3 movw     r3, #0x45cc
a03943e4 70314ae3 movt     r3, #0xa170
a03943e8 003093e5 ldr      r3, [r3]
a03943ec 903a07ee vmov     s15, r3
a03943f0 e70bf8ee vcvt.f64.s32 d16, s15
a03943f4 351bdfed vldr     d17, [pc, #0xd4]
a03943f8 a10b60ee vmul.f64 d16, d16, d17
a03943fc 311bdfed vldr     d17, [pc, #0xc4]
a0394400 a10bc0ee vdiv.f64 d16, d16, d17
a0394404 0e0bcded vstr     d16, [sp, #0x38]
a0394408 2a3f0ae3 movw     r3, #0xaf2a
a039440c 70314ae3 movt     r3, #0xa170
a0394410 0030d3e5 ldrb     r3, [r3]
a0394414 000053e3 cmp      r3, #0
a0394418 0400001a bne      #0xa0394430
a039441c 293f0ae3 movw     r3, #0xaf29
a0394420 70314ae3 movt     r3, #0xa170
a0394424 0030d3e5 ldrb     r3, [r3]
a0394428 000053e3 cmp      r3, #0
a039442c 0500000a beq      #0xa0394448
a0394430 e03504e3 movw     r3, #0x45e0
a0394434 70314ae3 movt     r3, #0xa170
a0394438 0000a0e3 mov      r0, #0
a039443c 0010a0e3 mov      r1, #0
a0394440 f000c3e1 strd     r0, r1, [r3]
a0394444 380000ea b        #0xa039452c
a0394448 a43a07e3 movw     r3, #0x7aa4
a039444c 75304ae3 movt     r3, #0xa075
a0394450 007ad3ed vldr     s15, [r3]
a0394454 c07af5ee vcmpe.f32 s15, #0
a0394458 10faf1ee vmrs     apsr_nzcv, fpscr
a039445c 200000da ble      #0xa03944e4
a0394460 a43a07e3 movw     r3, #0x7aa4
a0394464 75304ae3 movt     r3, #0xa075
a0394468 007ad3ed vldr     s15, [r3]
a039446c a77a77ee vadd.f32 s15, s15, s15
a0394470 e70af7ee vcvt.f64.f32 d16, s15
a0394474 151bdfed vldr     d17, [pc, #0x54]
a0394478 a11b60ee vmul.f64 d17, d16, d17
a039447c 603b0ae3 movw     r3, #0xab60
a0394480 70314ae3 movt     r3, #0xa170
a0394484 003093e5 ldr      r3, [r3]
a0394488 903a07ee vmov     s15, r3
a039448c 670bf8ee vcvt.f64.u32 d16, s15
a0394490 a00b61ee vmul.f64 d16, d17, d16
a0394494 0f1bdfed vldr     d17, [pc, #0x3c]
a0394498 a10bc0ee vdiv.f64 d16, d16, d17
a039449c 600bb0ee vmov.f64 d0, d16
a03944a0 48be05fa blx      #0xa0503dc8
a03944a4 401bf0ee vmov.f64 d17, d0
a03944a8 0e0bdded vldr     d16, [sp, #0x38]
a03944ac a00b61ee vmul.f64 d16, d17, d16
a03944b0 e03504e3 movw     r3, #0x45e0
a03944b4 70314ae3 movt     r3, #0xa170
a03944b8 000bc3ed vstr     d16, [r3]
a03944bc 1a0000ea b        #0xa039452c
a03944c0 9a999999 ldmibls  sb, {r1, r3, r4, r7, r8, fp, ip, pc}
a03944c4 9999993f svclo    #0x999999
a03944c8 00000000 andeq    r0, r0, r0
a03944cc 00806640 rsbmi    r8, r6, r0
a03944d0 182d4454 strbpl   r2, [r4], #-0xd18
a03944d4 fb210940 strdmi   r2, r3, [sb], -fp
a03944d8 00000000 andeq    r0, r0, r0
a03944dc 00408f40 addmi    r4, pc, r0
a03944e0 cdccf6c2 rscsgt   ip, r6, #0xcd00
a03944e4 a43a07e3 movw     r3, #0x7aa4
a03944e8 75304ae3 movt     r3, #0xa075
a03944ec 007ad3ed vldr     s15, [r3]
a03944f0 067a1fed vldr     s14, [pc, #-0x18]
a03944f4 477af4ee vcmp.f32 s15, s14
a03944f8 10faf1ee vmrs     apsr_nzcv, fpscr
a03944fc 0a00000a beq      #0xa039452c
a0394500 a43a07e3 movw     r3, #0x7aa4
a0394504 75304ae3 movt     r3, #0xa075
a0394508 007ad3ed vldr     s15, [r3]
a039450c e70af7ee vcvt.f64.f32 d16, s15
a0394510 e41bdfed vldr     d17, [pc, #0x390]
a0394514 a10b60ee vmul.f64 d16, d16, d17
a0394518 e41bdfed vldr     d17, [pc, #0x390]
a039451c a10bc0ee vdiv.f64 d16, d16, d17
a0394520 e03504e3 movw     r3, #0x45e0
a0394524 70314ae3 movt     r3, #0xa170
a0394528 000bc3ed vstr     d16, [r3]
a039452c d93504e3 movw     r3, #0x45d9
a0394530 70314ae3 movt     r3, #0xa170
a0394534 0030d3e5 ldrb     r3, [r3]
a0394538 000053e3 cmp      r3, #0
a039453c 0400001a bne      #0xa0394554
a0394540 dc3504e3 movw     r3, #0x45dc
a0394544 70314ae3 movt     r3, #0xa170
a0394548 0030d3e5 ldrb     r3, [r3]
a039454c 000053e3 cmp      r3, #0
a0394550 4f00000a beq      #0xa0394694
a0394554 f83a07e3 movw     r3, #0x7af8
a0394558 75304ae3 movt     r3, #0xa075
a039455c b831d3e1 ldrh     r3, [r3, #0x18]
a0394560 000053e3 cmp      r3, #0
a0394564 4a00001a bne      #0xa0394694
a0394568 b93f0ae3 movw     r3, #0xafb9
a039456c 70314ae3 movt     r3, #0xa170
a0394570 0030d3e5 ldrb     r3, [r3]
a0394574 000053e3 cmp      r3, #0
a0394578 3500001a bne      #0xa0394654
a039457c ba3f0ae3 movw     r3, #0xafba
a0394580 70314ae3 movt     r3, #0xa170
a0394584 0030d3e5 ldrb     r3, [r3]
a0394588 000053e3 cmp      r3, #0
a039458c 3000000a beq      #0xa0394654
a0394590 da3504e3 movw     r3, #0x45da
a0394594 70314ae3 movt     r3, #0xa170
a0394598 0030d3e5 ldrb     r3, [r3]
a039459c 000053e3 cmp      r3, #0
a03945a0 1d00000a beq      #0xa039461c
a03945a4 a23a07e3 movw     r3, #0x7aa2
a03945a8 75304ae3 movt     r3, #0xa075
a03945ac 0030d3e5 ldrb     r3, [r3]
a03945b0 000053e3 cmp      r3, #0
a03945b4 1800000a beq      #0xa039461c
a03945b8 b13a07e3 movw     r3, #0x7ab1
a03945bc 75304ae3 movt     r3, #0xa075
a03945c0 0030d3e5 ldrb     r3, [r3]
a03945c4 033043e2 sub      r3, r3, #3
a03945c8 7320efe6 uxtb     r2, r3
a03945cc 513a07e3 movw     r3, #0x7a51
a03945d0 75304ae3 movt     r3, #0xa075
a03945d4 0030d3e5 ldrb     r3, [r3]
a03945d8 030052e1 cmp      r2, r3
a03945dc 0e00009a bls      #0xa039461c
a03945e0 513a07e3 movw     r3, #0x7a51
a03945e4 75304ae3 movt     r3, #0xa075
a03945e8 0030d3e5 ldrb     r3, [r3]
a03945ec 013083e2 add      r3, r3, #1
a03945f0 7320efe6 uxtb     r2, r3
a03945f4 513a07e3 movw     r3, #0x7a51
a03945f8 75304ae3 movt     r3, #0xa075
a03945fc 0020c3e5 strb     r2, [r3]
a0394600 513a07e3 movw     r3, #0x7a51
a0394604 75304ae3 movt     r3, #0xa075
a0394608 0030d3e5 ldrb     r3, [r3]
a039460c 7320efe6 uxtb     r2, r3
a0394610 2b3204e3 movw     r3, #0x422b
a0394614 70314ae3 movt     r3, #0xa170
a0394618 0020c3e5 strb     r2, [r3]
a039461c 283204e3 movw     r3, #0x4228
a0394620 70314ae3 movt     r3, #0xa170
a0394624 0030d3e5 ldrb     r3, [r3]
a0394628 7320afe6 sxtb     r2, r3
a039462c 2b3204e3 movw     r3, #0x422b
a0394630 70314ae3 movt     r3, #0xa170
a0394634 0030d3e5 ldrb     r3, [r3]
a0394638 7330afe6 sxtb     r3, r3
a039463c 2c0b00e3 movw     r0, #0xb2c
a0394640 60004ae3 movt     r0, #0xa060
a0394644 0210a0e1 mov      r1, r2
a0394648 0320a0e1 mov      r2, r3
a039464c a64afceb bl       #0xa02a70ec
a0394650 0f0000ea b        #0xa0394694
a0394654 f83a07e3 movw     r3, #0x7af8
a0394658 75304ae3 movt     r3, #0xa075
a039465c b234d3e1 ldrh     r3, [r3, #0x42]
a0394660 000053e3 cmp      r3, #0
a0394664 0200001a bne      #0xa0394674
a0394668 000704e3 movw     r0, #0x4700
a039466c 70014ae3 movt     r0, #0xa170
a0394670 f4e8ffeb bl       #0xa038ea48
a0394674 f83a07e3 movw     r3, #0x7af8
a0394678 75304ae3 movt     r3, #0xa075
a039467c b434d3e1 ldrh     r3, [r3, #0x44]
a0394680 000053e3 cmp      r3, #0
a0394684 0200001a bne      #0xa0394694
a0394688 000704e3 movw     r0, #0x4700
a039468c 70014ae3 movt     r0, #0xa170
a0394690 96f5ffeb bl       #0xa0391cf0
a0394694 da3504e3 movw     r3, #0x45da
a0394698 70314ae3 movt     r3, #0xa170
a039469c 0030d3e5 ldrb     r3, [r3]
a03946a0 000053e3 cmp      r3, #0
a03946a4 1500001a bne      #0xa0394700
a03946a8 803f0ae3 movw     r3, #0xaf80
a03946ac 70314ae3 movt     r3, #0xa170
a03946b0 0030d3e5 ldrb     r3, [r3]
a03946b4 000053e3 cmp      r3, #0
a03946b8 0a00000a beq      #0xa03946e8
a03946bc 343f0ae3 movw     r3, #0xaf34
a03946c0 70314ae3 movt     r3, #0xa170
a03946c4 007ad3ed vldr     s15, [r3]
a03946c8 e71af7ee vcvt.f64.f32 d17, s15
a03946cc e03504e3 movw     r3, #0x45e0
a03946d0 70314ae3 movt     r3, #0xa170
a03946d4 000bd3ed vldr     d16, [r3]
a03946d8 a00b61ee vmul.f64 d16, d17, d16
a03946dc e03504e3 movw     r3, #0x45e0
a03946e0 70314ae3 movt     r3, #0xa170
a03946e4 000bc3ed vstr     d16, [r3]
a03946e8 e03504e3 movw     r3, #0x45e0
a03946ec 70314ae3 movt     r3, #0xa170
a03946f0 d000c3e1 ldrd     r0, r1, [r3]
a03946f4 683f0ae3 movw     r3, #0xaf68
a03946f8 70314ae3 movt     r3, #0xa170
a03946fc f000c3e1 strd     r0, r1, [r3]
a0394700 58c2ffeb bl       #0xa0385068
a0394704 e03504e3 movw     r3, #0x45e0
a0394708 70314ae3 movt     r3, #0xa170
a039470c 000bd3ed vldr     d16, [r3]
a0394710 2c308de2 add      r3, sp, #0x2c
a0394714 0300a0e1 mov      r0, r3
a0394718 600bb0ee vmov.f64 d0, d16
a039471c 1915fdeb bl       #0xa02d9b88
a0394720 da3504e3 movw     r3, #0x45da
a0394724 70314ae3 movt     r3, #0xa170
a0394728 0030d3e5 ldrb     r3, [r3]
a039472c 000053e3 cmp      r3, #0
a0394730 6000000a beq      #0xa03948b8
a0394734 2c308de2 add      r3, sp, #0x2c
a0394738 0300a0e1 mov      r0, r3
a039473c 0010a0e3 mov      r1, #0
a0394740 8716fdeb bl       #0xa02da164
a0394744 0030a0e1 mov      r3, r0
a0394748 000053e3 cmp      r3, #0
a039474c 1101001a bne      #0xa0394b98
a0394750 0f30a0e3 mov      r3, #0xf
a0394754 30308de5 str      r3, [sp, #0x30]
a0394758 2c308de2 add      r3, sp, #0x2c
a039475c 0300a0e1 mov      r0, r3
a0394760 6b17fdeb bl       #0xa02da514
a0394764 f83a07e3 movw     r3, #0x7af8
a0394768 75304ae3 movt     r3, #0xa075
a039476c b633d3e1 ldrh     r3, [r3, #0x36]
a0394770 000053e3 cmp      r3, #0
a0394774 0701000a beq      #0xa0394b98
a0394778 0030a0e3 mov      r3, #0
a039477c 30308de5 str      r3, [sp, #0x30]
a0394780 2c308de2 add      r3, sp, #0x2c
a0394784 0300a0e1 mov      r0, r3
a0394788 ec1504e3 movw     r1, #0x45ec
a039478c 70114ae3 movt     r1, #0xa170
a0394790 f7f9fdeb bl       #0xa0312f74
a0394794 ec3504e3 movw     r3, #0x45ec
a0394798 70314ae3 movt     r3, #0xa170
a039479c 0430d3e5 ldrb     r3, [r3, #4]
a03947a0 0390a0e1 mov      sb, r3
a03947a4 ec3504e3 movw     r3, #0x45ec
a03947a8 70314ae3 movt     r3, #0xa170
a03947ac 0530d3e5 ldrb     r3, [r3, #5]
a03947b0 0380a0e1 mov      r8, r3
a03947b4 ec3504e3 movw     r3, #0x45ec
a03947b8 70314ae3 movt     r3, #0xa170
a03947bc 0630d3e5 ldrb     r3, [r3, #6]
a03947c0 0370a0e1 mov      r7, r3
a03947c4 ec3504e3 movw     r3, #0x45ec
a03947c8 70314ae3 movt     r3, #0xa170
a03947cc 0730d3e5 ldrb     r3, [r3, #7]
a03947d0 0360a0e1 mov      r6, r3
a03947d4 ec3504e3 movw     r3, #0x45ec
a03947d8 70314ae3 movt     r3, #0xa170
a03947dc 104093e5 ldr      r4, [r3, #0x10]
a03947e0 ec3504e3 movw     r3, #0x45ec
a03947e4 70314ae3 movt     r3, #0xa170
a03947e8 103093e5 ldr      r3, [r3, #0x10]
a03947ec 0300a0e1 mov      r0, r3
a03947f0 cb3c04eb bl       #0xa04a3b24
a03947f4 0050a0e1 mov      r5, r0
a03947f8 ec3504e3 movw     r3, #0x45ec
a03947fc 70314ae3 movt     r3, #0xa170
a0394800 103093e5 ldr      r3, [r3, #0x10]
a0394804 b030d3e1 ldrh     r3, [r3]
a0394808 73e0bfe6 sxth     lr, r3
a039480c ec3504e3 movw     r3, #0x45ec
a0394810 70314ae3 movt     r3, #0xa170
a0394814 103093e5 ldr      r3, [r3, #0x10]
a0394818 023083e2 add      r3, r3, #2
a039481c b030d3e1 ldrh     r3, [r3]
a0394820 73c0bfe6 sxth     ip, r3
a0394824 ec3504e3 movw     r3, #0x45ec
a0394828 70314ae3 movt     r3, #0xa170
a039482c 143093e5 ldr      r3, [r3, #0x14]
a0394830 b030d3e1 ldrh     r3, [r3]
a0394834 7300bfe6 sxth     r0, r3
a0394838 003704e3 movw     r3, #0x4700
a039483c 70314ae3 movt     r3, #0xa170
a0394840 b030d3e1 ldrh     r3, [r3]
a0394844 7310bfe6 sxth     r1, r3
a0394848 003704e3 movw     r3, #0x4700
a039484c 70314ae3 movt     r3, #0xa170
a0394850 b430d3e1 ldrh     r3, [r3, #4]
a0394854 7320bfe6 sxth     r2, r3
a0394858 003704e3 movw     r3, #0x4700
a039485c 70314ae3 movt     r3, #0xa170
a0394860 b230d3e1 ldrh     r3, [r3, #2]
a0394864 7330bfe6 sxth     r3, r3
a0394868 00608de5 str      r6, [sp]
a039486c 04408de5 str      r4, [sp, #4]
a0394870 08508de5 str      r5, [sp, #8]
a0394874 0ce08de5 str      lr, [sp, #0xc]
a0394878 10c08de5 str      ip, [sp, #0x10]
a039487c 14008de5 str      r0, [sp, #0x14]
a0394880 18108de5 str      r1, [sp, #0x18]
a0394884 1c208de5 str      r2, [sp, #0x1c]
a0394888 20308de5 str      r3, [sp, #0x20]
a039488c 780b00e3 movw     r0, #0xb78
a0394890 60004ae3 movt     r0, #0xa060
a0394894 0910a0e1 mov      r1, sb
a0394898 0820a0e1 mov      r2, r8
a039489c 0730a0e1 mov      r3, r7
a03948a0 114afceb bl       #0xa02a70ec
a03948a4 bb0000ea b        #0xa0394b98
a03948a8 182d4454 strbpl   r2, [r4], #-0xd18
a03948ac fb210940 strdmi   r2, r3, [sb], -fp
a03948b0 00000000 andeq    r0, r0, r0
a03948b4 00806640 rsbmi    r8, r6, r0
a03948b8 1b3b0ae3 movw     r3, #0xab1b
a03948bc 70314ae3 movt     r3, #0xa170
a03948c0 0020d3e5 ldrb     r2, [r3]
a03948c4 1e3b0ae3 movw     r3, #0xab1e
a03948c8 70314ae3 movt     r3, #0xa170
a03948cc 0020c3e5 strb     r2, [r3]
a03948d0 802304e3 movw     r2, #0x4380
a03948d4 70214ae3 movt     r2, #0xa170
a03948d8 483304e3 movw     r3, #0x4348
a03948dc 70314ae3 movt     r3, #0xa170
a03948e0 02c0a0e1 mov      ip, r2
a03948e4 03e0a0e1 mov      lr, r3
a03948e8 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a03948ec 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a03948f0 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a03948f4 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a03948f8 0f00bee8 ldm      lr!, {r0, r1, r2, r3}
a03948fc 0f00ace8 stm      ip!, {r0, r1, r2, r3}
a0394900 03009ee8 ldm      lr, {r0, r1}
a0394904 03008ce8 stm      ip, {r0, r1}
a0394908 f02304e3 movw     r2, #0x43f0
a039490c 70214ae3 movt     r2, #0xa170
a0394910 003404e3 movw     r3, #0x4400
a0394914 70314ae3 movt     r3, #0xa170
a0394918 02c0a0e1 mov      ip, r2
a039491c 143083e2 add      r3, r3, #0x14
a0394920 0f0093e8 ldm      r3, {r0, r1, r2, r3}
a0394924 0f008ce8 stm      ip, {r0, r1, r2, r3}
a0394928 a82404e3 movw     r2, #0x44a8
a039492c 70214ae3 movt     r2, #0xa170
a0394930 003404e3 movw     r3, #0x4400
a0394934 70314ae3 movt     r3, #0xa170
a0394938 0210a0e1 mov      r1, r2
a039493c 0320a0e1 mov      r2, r3
a0394940 a830a0e3 mov      r3, #0xa8
a0394944 0100a0e1 mov      r0, r1
a0394948 0210a0e1 mov      r1, r2
a039494c 0320a0e1 mov      r2, r3
a0394950 4a1ffceb bl       #0xa029c680
a0394954 2c308de2 add      r3, sp, #0x2c
a0394958 0300a0e1 mov      r0, r3
a039495c 0010a0e3 mov      r1, #0
a0394960 ff15fdeb bl       #0xa02da164
a0394964 0030a0e1 mov      r3, r0
a0394968 000053e3 cmp      r3, #0
a039496c 8900001a bne      #0xa0394b98
a0394970 0f30a0e3 mov      r3, #0xf
a0394974 30308de5 str      r3, [sp, #0x30]
a0394978 2c308de2 add      r3, sp, #0x2c
a039497c 0300a0e1 mov      r0, r3
a0394980 e316fdeb bl       #0xa02da514
a0394984 0030a0e3 mov      r3, #0
a0394988 30308de5 str      r3, [sp, #0x30]
a039498c 2c308de2 add      r3, sp, #0x2c
a0394990 0300a0e1 mov      r0, r3
a0394994 ec1504e3 movw     r1, #0x45ec
a0394998 70114ae3 movt     r1, #0xa170
a039499c 74f9fdeb bl       #0xa0312f74
a03949a0 ec3504e3 movw     r3, #0x45ec
a03949a4 70314ae3 movt     r3, #0xa170
a03949a8 002093e5 ldr      r2, [r3]
a03949ac 103304e3 movw     r3, #0x4310
a03949b0 70314ae3 movt     r3, #0xa170
a03949b4 242083e5 str      r2, [r3, #0x24]
a03949b8 ec3504e3 movw     r3, #0x45ec
a03949bc 70314ae3 movt     r3, #0xa170
a03949c0 0420d3e5 ldrb     r2, [r3, #4]
a03949c4 103304e3 movw     r3, #0x4310
a03949c8 70314ae3 movt     r3, #0xa170
a03949cc 2820c3e5 strb     r2, [r3, #0x28]
a03949d0 ec3504e3 movw     r3, #0x45ec
a03949d4 70314ae3 movt     r3, #0xa170
a03949d8 0520d3e5 ldrb     r2, [r3, #5]
a03949dc 103304e3 movw     r3, #0x4310
a03949e0 70314ae3 movt     r3, #0xa170
a03949e4 2920c3e5 strb     r2, [r3, #0x29]
a03949e8 ec3504e3 movw     r3, #0x45ec
a03949ec 70314ae3 movt     r3, #0xa170
a03949f0 0620d3e5 ldrb     r2, [r3, #6]
a03949f4 103304e3 movw     r3, #0x4310
a03949f8 70314ae3 movt     r3, #0xa170
a03949fc 2a20c3e5 strb     r2, [r3, #0x2a]
a0394a00 ec3504e3 movw     r3, #0x45ec
a0394a04 70314ae3 movt     r3, #0xa170
a0394a08 0720d3e5 ldrb     r2, [r3, #7]
a0394a0c 103304e3 movw     r3, #0x4310
a0394a10 70314ae3 movt     r3, #0xa170
a0394a14 2b20c3e5 strb     r2, [r3, #0x2b]
a0394a18 ec3504e3 movw     r3, #0x45ec
a0394a1c 70314ae3 movt     r3, #0xa170
a0394a20 103093e5 ldr      r3, [r3, #0x10]
a0394a24 0300a0e1 mov      r0, r3
a0394a28 3d3c04eb bl       #0xa04a3b24
a0394a2c 0020a0e1 mov      r2, r0
a0394a30 103304e3 movw     r3, #0x4310
a0394a34 70314ae3 movt     r3, #0xa170
a0394a38 2c2083e5 str      r2, [r3, #0x2c]
a0394a3c ec3504e3 movw     r3, #0x45ec
a0394a40 70314ae3 movt     r3, #0xa170
a0394a44 143093e5 ldr      r3, [r3, #0x14]
a0394a48 0300a0e1 mov      r0, r3
a0394a4c 343c04eb bl       #0xa04a3b24
a0394a50 0020a0e1 mov      r2, r0
a0394a54 103304e3 movw     r3, #0x4310
a0394a58 70314ae3 movt     r3, #0xa170
a0394a5c 302083e5 str      r2, [r3, #0x30]
a0394a60 ec3504e3 movw     r3, #0x45ec
a0394a64 70314ae3 movt     r3, #0xa170
a0394a68 0b20d3e5 ldrb     r2, [r3, #0xb]
a0394a6c 103304e3 movw     r3, #0x4310
a0394a70 70314ae3 movt     r3, #0xa170
a0394a74 3420c3e5 strb     r2, [r3, #0x34]
a0394a78 ec3504e3 movw     r3, #0x45ec
a0394a7c 70314ae3 movt     r3, #0xa170
a0394a80 0c20d3e5 ldrb     r2, [r3, #0xc]
a0394a84 103304e3 movw     r3, #0x4310
a0394a88 70314ae3 movt     r3, #0xa170
a0394a8c 3520c3e5 strb     r2, [r3, #0x35]
a0394a90 ec3504e3 movw     r3, #0x45ec
a0394a94 70314ae3 movt     r3, #0xa170
a0394a98 003093e5 ldr      r3, [r3]
a0394a9c 000053e3 cmp      r3, #0
a0394aa0 0300000a beq      #0xa0394ab4
a0394aa4 b83f0ae3 movw     r3, #0xafb8
a0394aa8 70314ae3 movt     r3, #0xa170
a0394aac 0120a0e3 mov      r2, #1
a0394ab0 0020c3e5 strb     r2, [r3]
a0394ab4 f83a07e3 movw     r3, #0x7af8
a0394ab8 75304ae3 movt     r3, #0xa075
a0394abc b633d3e1 ldrh     r3, [r3, #0x36]
a0394ac0 000053e3 cmp      r3, #0
a0394ac4 3300000a beq      #0xa0394b98
a0394ac8 ec3504e3 movw     r3, #0x45ec
a0394acc 70314ae3 movt     r3, #0xa170
a0394ad0 0430d3e5 ldrb     r3, [r3, #4]
a0394ad4 0380a0e1 mov      r8, r3
a0394ad8 ec3504e3 movw     r3, #0x45ec
a0394adc 70314ae3 movt     r3, #0xa170
a0394ae0 0530d3e5 ldrb     r3, [r3, #5]
a0394ae4 0370a0e1 mov      r7, r3
a0394ae8 ec3504e3 movw     r3, #0x45ec
a0394aec 70314ae3 movt     r3, #0xa170
a0394af0 0630d3e5 ldrb     r3, [r3, #6]
a0394af4 0360a0e1 mov      r6, r3
a0394af8 ec3504e3 movw     r3, #0x45ec
a0394afc 70314ae3 movt     r3, #0xa170
a0394b00 0730d3e5 ldrb     r3, [r3, #7]
a0394b04 0350a0e1 mov      r5, r3
a0394b08 ec3504e3 movw     r3, #0x45ec
a0394b0c 70314ae3 movt     r3, #0xa170
a0394b10 104093e5 ldr      r4, [r3, #0x10]
a0394b14 ec3504e3 movw     r3, #0x45ec
a0394b18 70314ae3 movt     r3, #0xa170
a0394b1c 103093e5 ldr      r3, [r3, #0x10]
a0394b20 0300a0e1 mov      r0, r3
a0394b24 fe3b04eb bl       #0xa04a3b24
a0394b28 ec3504e3 movw     r3, #0x45ec
a0394b2c 70314ae3 movt     r3, #0xa170
a0394b30 103093e5 ldr      r3, [r3, #0x10]
a0394b34 b030d3e1 ldrh     r3, [r3]
a0394b38 7310bfe6 sxth     r1, r3
a0394b3c ec3504e3 movw     r3, #0x45ec
a0394b40 70314ae3 movt     r3, #0xa170
a0394b44 103093e5 ldr      r3, [r3, #0x10]
a0394b48 023083e2 add      r3, r3, #2
a0394b4c b030d3e1 ldrh     r3, [r3]
a0394b50 7320bfe6 sxth     r2, r3
a0394b54 ec3504e3 movw     r3, #0x45ec
a0394b58 70314ae3 movt     r3, #0xa170
a0394b5c 143093e5 ldr      r3, [r3, #0x14]
a0394b60 b030d3e1 ldrh     r3, [r3]
a0394b64 7330bfe6 sxth     r3, r3
a0394b68 00508de5 str      r5, [sp]
a0394b6c 04408de5 str      r4, [sp, #4]
a0394b70 08008de5 str      r0, [sp, #8]
a0394b74 0c108de5 str      r1, [sp, #0xc]
a0394b78 10208de5 str      r2, [sp, #0x10]
a0394b7c 14308de5 str      r3, [sp, #0x14]
a0394b80 c40b00e3 movw     r0, #0xbc4
a0394b84 60004ae3 movt     r0, #0xa060
a0394b88 0810a0e1 mov      r1, r8
a0394b8c 0720a0e1 mov      r2, r7
a0394b90 0630a0e1 mov      r3, r6
a0394b94 5449fceb bl       #0xa02a70ec
a0394b98 74d08de2 add      sp, sp, #0x74
a0394b9c f083bde8 pop      {r4, r5, r6, r7, r8, sb, pc}
