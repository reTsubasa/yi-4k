a0295b38 f84f2de9 push {r3, r4, r5, r6, r7, r8, sb, sl, fp, lr}
a0295b3c 005000e3 movw r5, #0
a0295b40 005c4de3 movt r5, #0xdc00
a0295b44 0209a0e3 mov r0, #0x8000
a0295b48 066285e2 add r6, r5, #0x60000000
a0295b4c b04205e3 movw r4, #0x52b0
a0295b50 413003e3 movw r3, #0x3041
a0295b54 a00046e3 movt r0, #0x60a0
a0295b58 44414ae3 movt r4, #0xa144
a0295b5c 0a6686e2 add r6, r6, #0xa00000
a0295b60 191001e3 movw r1, #0x1019
a0295b64 283342e3 movt r3, #0x2328
a0295b68 3626a0e3 mov r2, #0x3600000
a0295b6c 000085e0 add r0, r5, r0
a0295b70 2a0084e8 stm r4, {r1, r3, r5}
a0295b74 017585e2 add r7, r5, #0x400000
a0295b78 11b785e2 add fp, r5, #0x440000
a0295b7c 106084e5 str r6, [r4, #0x10]
a0295b80 0aaa87e2 add sl, r7, #0xa000
a0295b84 0288a0e3 mov r8, #0x20000
a0295b88 0c2084e5 str r2, [r4, #0xc]
a0295b8c 103808eb bl #0xa04a3bd4
a0295b90 412885e2 add r2, r5, #0x410000
a0295b94 431885e2 add r1, r5, #0x430000
a0295b98 069a82e2 add sb, r2, #0x6000
a0295b9c 1c6084e5 str r6, [r4, #0x1c]
a0295ba0 140084e5 str r0, [r4, #0x14]
a0295ba4 776ea0e3 mov r6, #0x770
a0295ba8 010982e2 add r0, r2, #0x4000
a0295bac 205084e5 str r5, [r4, #0x20]
a0295bb0 052a82e2 add r2, r2, #0x5000
a0295bb4 071a81e2 add r1, r1, #0x7000
a0295bb8 68b084e5 str fp, [r4, #0x68]
a0295bbc a4e202e3 movw lr, #0x22a4
a0295bc0 247084e5 str r7, [r4, #0x24]
a0295bc4 0aba4be2 sub fp, fp, #0xa000
a0295bc8 457885e2 add r7, r5, #0x450000
a0295bcc 80c202e3 movw ip, #0x2280
a0295bd0 955885e2 add r5, r5, #0x950000
a0295bd4 3c3305e3 movw r3, #0x533c
a0295bd8 44314ae3 movt r3, #0xa144
a0295bdc 6fe04ae3 movt lr, #0xa06f
a0295be0 6fc04ae3 movt ip, #0xa06f
a0295be4 28a084e5 str sl, [r4, #0x28]
a0295be8 509084e5 str sb, [r4, #0x50]
a0295bec 05a6a0e3 mov sl, #0x500000
a0295bf0 0191a0e3 mov sb, #0x40000000
a0295bf4 548084e5 str r8, [r4, #0x54]
a0295bf8 346084e5 str r6, [r4, #0x34]
a0295bfc 0289a0e3 mov r8, #0x8000
a0295c00 0060a0e3 mov r6, #0
a0295c04 380084e5 str r0, [r4, #0x38]
a0295c08 402084e5 str r2, [r4, #0x40]
a0295c0c 020ba0e3 mov r0, #0x800
a0295c10 012aa0e3 mov r2, #0x1000
a0295c14 48b084e5 str fp, [r4, #0x48]
a0295c18 4c1084e5 str r1, [r4, #0x4c]
a0295c1c 02b0a0e3 mov fp, #2
a0295c20 4110a0e3 mov r1, #0x41
a0295c24 587084e5 str r7, [r4, #0x58]
a0295c28 605084e5 str r5, [r4, #0x60]
a0295c2c 0170a0e3 mov r7, #1
a0295c30 3250a0e3 mov r5, #0x32
a0295c34 5ca084e5 str sl, [r4, #0x5c]
a0295c38 70e084e5 str lr, [r4, #0x70]
a0295c3c 3ca0a0e3 mov sl, #0x3c
a0295c40 849084e5 str sb, [r4, #0x84]
a0295c44 46e0a0e3 mov lr, #0x46
a0295c48 88c084e5 str ip, [r4, #0x88]
a0295c4c 8490a0e3 mov sb, #0x84
a0295c50 6c6084e5 str r6, [r4, #0x6c]
a0295c54 01c9a0e3 mov ip, #0x4000
a0295c58 786084e5 str r6, [r4, #0x78]
a0295c5c 7c6084e5 str r6, [r4, #0x7c]
a0295c60 ff60a0e3 mov r6, #0xff
a0295c64 2c0084e5 str r0, [r4, #0x2c]
a0295c68 300084e5 str r0, [r4, #0x30]
a0295c6c 020aa0e3 mov r0, #0x2000
a0295c70 3c2084e5 str r2, [r4, #0x3c]
a0295c74 442084e5 str r2, [r4, #0x44]
a0295c78 642084e5 str r2, [r4, #0x64]
a0295c7c 082083e5 str r2, [r3, #8]
a0295c80 188084e5 str r8, [r4, #0x18]
a0295c84 00b083e5 str fp, [r3]
a0295c88 041083e5 str r1, [r3, #4]
a0295c8c 0c7083e5 str r7, [r3, #0xc]
a0295c90 105083e5 str r5, [r3, #0x10]
a0295c94 142083e5 str r2, [r3, #0x14]
a0295c98 202083e5 str r2, [r3, #0x20]
a0295c9c 382083e5 str r2, [r3, #0x38]
a0295ca0 502083e5 str r2, [r3, #0x50]
a0295ca4 5020a0e3 mov r2, #0x50
a0295ca8 688083e5 str r8, [r3, #0x68]
a0295cac 187083e5 str r7, [r3, #0x18]
a0295cb0 1c5083e5 str r5, [r3, #0x1c]
a0295cb4 247083e5 str r7, [r3, #0x24]
a0295cb8 307083e5 str r7, [r3, #0x30]
a0295cbc 3c7083e5 str r7, [r3, #0x3c]
a0295cc0 487083e5 str r7, [r3, #0x48]
a0295cc4 547083e5 str r7, [r3, #0x54]
a0295cc8 581083e5 str r1, [r3, #0x58]
a0295ccc 607083e5 str r7, [r3, #0x60]
a0295cd0 6c7083e5 str r7, [r3, #0x6c]
a0295cd4 28a083e5 str sl, [r3, #0x28]
a0295cd8 34e083e5 str lr, [r3, #0x34]
a0295cdc 409083e5 str sb, [r3, #0x40]
a0295ce0 44c083e5 str ip, [r3, #0x44]
a0295ce4 4c2083e5 str r2, [r3, #0x4c]
a0295ce8 646083e5 str r6, [r3, #0x64]
a0295cec 2c0083e5 str r0, [r3, #0x2c]
a0295cf0 5c0083e5 str r0, [r3, #0x5c]
a0295cf4 f88fbde8 pop {r3, r4, r5, r6, r7, r8, sb, sl, fp, pc}
