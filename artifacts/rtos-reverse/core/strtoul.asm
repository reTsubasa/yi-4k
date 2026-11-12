; SHA256 c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141
; strtoul, mode=Thumb; selected range, not guaranteed function boundary
a04fb328  30b4       push      {r4, r5}
a04fb32a  41f25004   movw      r4, #0x1050
a04fb32e  0d46       mov       r5, r1
a04fb330  caf28204   movt      r4, #0xa082
a04fb334  1346       mov       r3, r2
a04fb336  0146       mov       r1, r0
a04fb338  2a46       mov       r2, r5
a04fb33a  2068       ldr       r0, [r4]
a04fb33c  30bc       pop       {r4, r5}
a04fb33e  fff74fbf   b.w       #0xa04fb1e0
a04fb342  00bf       nop       
