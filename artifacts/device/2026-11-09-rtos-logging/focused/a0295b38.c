/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void ambalink_boot_config_init(void)

{
  DAT_a14452b0 = 0x1019;
  DAT_a14452b4 = 0x23283041;
  DAT_a14452b8 = 0xdc000000;
  DAT_a14452c0 = 0x3ca00000;
  DAT_a14452bc = 0x3600000;
  DAT_a14452c4 = rtos_phys_to_virtual(0x3ca08000);
  DAT_a14452cc = 0x3ca00000;
  DAT_a14452d0 = 0xdc000000;
  DAT_a1445318 = 0xdc440000;
  DAT_a14452d4 = 0xdc400000;
  DAT_a14452d8 = 0xdc40a000;
  DAT_a1445300 = 0xdc416000;
  DAT_a1445304 = 0x20000;
  DAT_a14452e4 = 0x770;
  DAT_a14452e8 = 0xdc414000;
  DAT_a14452f0 = 0xdc415000;
  DAT_a14452f8 = 0xdc436000;
  DAT_a14452fc = 0xdc437000;
  DAT_a1445308 = 0xdc450000;
  DAT_a1445310 = 0xdc950000;
  DAT_a144530c = 0x500000;
  DAT_a1445320 = s_root__dev_mtdblock5_rootfstype_s_a06f22a4;
  DAT_a1445334 = 0x40000000;
  DAT_a1445338 = s_81__82__83__84__85__86__87__88_a06f2280;
  DAT_a144531c = 0;
  DAT_a1445328 = 0;
  DAT_a144532c = 0;
  DAT_a14452dc = 0x800;
  DAT_a14452e0 = 0x800;
  DAT_a14452ec = 0x1000;
  DAT_a14452f4 = 0x1000;
  DAT_a1445314 = 0x1000;
  DAT_a1445344 = 0x1000;
  DAT_a14452c8 = 0x8000;
  DAT_a144533c = 2;
  DAT_a1445340 = 0x41;
  DAT_a1445348 = 1;
  DAT_a144534c = 0x32;
  DAT_a1445350 = 0x1000;
  DAT_a144535c = 0x1000;
  DAT_a1445374 = 0x1000;
  DAT_a144538c = 0x1000;
  DAT_a14453a4 = 0x8000;
  DAT_a1445354 = 1;
  DAT_a1445358 = 0x32;
  DAT_a1445360 = 1;
  DAT_a144536c = 1;
  DAT_a1445378 = 1;
  DAT_a1445384 = 1;
  DAT_a1445390 = 1;
  DAT_a1445394 = 0x41;
  DAT_a144539c = 1;
  DAT_a14453a8 = 1;
  DAT_a1445364 = 0x3c;
  DAT_a1445370 = 0x46;
  DAT_a144537c = 0x84;
  DAT_a1445380 = 0x4000;
  DAT_a1445388 = 0x50;
  DAT_a14453a0 = 0xff;
  DAT_a1445368 = 0x2000;
  DAT_a1445398 = 0x2000;
  return;
}

