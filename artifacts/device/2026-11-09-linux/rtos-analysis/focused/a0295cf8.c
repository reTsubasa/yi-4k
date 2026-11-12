/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Removing unreachable block (ram,0xa0295f84) */
/* WARNING: Removing unreachable block (ram,0xa0295f64) */
/* WARNING: Removing unreachable block (ram,0xa0295f20) */
/* WARNING: Removing unreachable block (ram,0xa0295ef4) */
/* WARNING: Removing unreachable block (ram,0xa0295ec4) */
/* WARNING: Removing unreachable block (ram,0xa0295e78) */
/* WARNING: Removing unreachable block (ram,0xa0295d44) */
/* WARNING: Removing unreachable block (ram,0xa0295d3c) */
/* WARNING: Removing unreachable block (ram,0xa0295d48) */
/* WARNING: Removing unreachable block (ram,0xa0295ea4) */
/* WARNING: Removing unreachable block (ram,0xa0295ed0) */
/* WARNING: Removing unreachable block (ram,0xa0295f14) */
/* WARNING: Removing unreachable block (ram,0xa0295f44) */
/* WARNING: Removing unreachable block (ram,0xa0295f70) */
/* WARNING: Removing unreachable block (ram,0xa0295fac) */

void rtos_mmu_mapping_initializer(void)

{
  DAT_a14453b0 = &DAT_a0000000;
  DAT_a14453b4 = 0;
  DAT_a14453bc = 0x1060f;
  DAT_a14453b8 = 0x100000;
  DAT_a14453c0 = matched_rtos_reset_vector;
  DAT_a14453d4 = 0x69b000;
  DAT_a14453c8 = 0x54f000;
  DAT_a14453cc = 0x1060f;
  DAT_a14453e4 = 0x64f000;
  DAT_a14453dc = 0x1060f;
  DAT_a14453d8 = 0x187000;
  DAT_a14453e8 = 0x4c000;
  DAT_a14453ec = 0x11603;
  DAT_a14453d0 = &DAT_a069b000;
  DAT_a14453e0 = &DAT_a064f000;
  DAT_a14453f4 = 0x824f68;
  DAT_a14453f8 = 0x122d098;
  DAT_a14453f0 = &DAT_a0824f68;
  DAT_a14453fc = 0x1060f;
  DAT_a1445404 = 0x1b00000;
  DAT_a1445408 = 0x600000;
  DAT_a1445400 = 0xa1b00000;
  DAT_a144540c = 0x11601;
  DAT_a1445414 = 0x3100000;
  DAT_a1445418 = 0x38f00000;
  DAT_a1445410 = 0xa3100000;
  DAT_a144541c = 0x1060d;
  DAT_a1445424 = 0x2100000;
  DAT_a1445420 = 0xa2100000;
  DAT_a14453c4 = 0x100000;
  DAT_a1445428 = 0x1000000;
  DAT_a1445434 = 0x100000;
  DAT_a1445440 = 0xdc000000;
  DAT_a1445444 = 0x3c000000;
  DAT_a144542c = 0x11601;
  DAT_a1445430 = 0xffff0000;
  DAT_a144543c = 0x1060f;
  DAT_a1445438 = 0x4000;
  DAT_a1445448 = 0x4000000;
  DAT_a144544c = 0x1160d;
  return;
}

