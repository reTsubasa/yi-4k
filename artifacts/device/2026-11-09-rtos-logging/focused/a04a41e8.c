/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Removing unreachable block (ram,0xa04a434c) */
/* WARNING: Removing unreachable block (ram,0xa04a43f0) */
/* WARNING: Removing unreachable block (ram,0xa04a4370) */
/* WARNING: Removing unreachable block (ram,0xa04a4388) */
/* WARNING: Removing unreachable block (ram,0xa04a4390) */
/* WARNING: Removing unreachable block (ram,0xa04a43b4) */
/* WARNING: Removing unreachable block (ram,0xa04a43bc) */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void rtos_mmu_init(void)

{
  byte bVar1;
  int iVar2;
  undefined4 in_r3;
  uint uVar3;
  undefined4 uVar4;
  int iVar5;
  undefined4 *puVar6;
  undefined4 *puVar7;
  int iVar8;
  uint uVar9;
  undefined4 in_cr4;
  undefined4 in_cr5;
  undefined4 in_cr6;
  undefined4 in_cr7;
  undefined4 in_cr8;
  
  uVar9 = coproc_movefrom_Control();
  matched_FUN_a04f8dec(DAT_a04a43f8,0,0x4000,in_r3,in_r3);
  matched_FUN_a04f8dec(0xa0b98000,0,0x1000);
  if (DAT_a06f22f0 != (code *)0x0) {
    (*DAT_a06f22f0)();
  }
  iVar2 = DAT_a06f22f8;
  bVar1 = DAT_a078c0f9 & 0xdf;
  _DAT_a078c0f8 = CONCAT11(bVar1 | (DAT_a06f22fc & 1) << 5,DAT_a078c0f8);
  if ((DAT_a06f22f4 != 0) && (0 < DAT_a06f22f8)) {
    iVar8 = 0;
    iVar5 = DAT_a06f22f4;
    do {
      iVar8 = iVar8 + 1;
      rtos_build_mapping_descriptors(iVar5);
      iVar5 = iVar5 + 0x10;
    } while (iVar8 != iVar2);
  }
  puVar6 = &DAT_a078c0fc;
  do {
    puVar7 = puVar6 + 4;
    rtos_build_mapping_descriptors(puVar6);
    puVar6 = puVar7;
  } while (puVar7 != (undefined4 *)0xa078c13c);
  DataMemoryBarrier(0xf);
  matched_FUN_a04a22cc(DAT_a04a43f8,0x4000);
  matched_FUN_a04a22cc(0xa0b98000,0x1000);
  if ((uVar9 & 1) == 0) {
    coproc_moveto_Invalidate_Entire_Instruction(0);
    coprocessor_moveto(0xf,0,0,0,in_cr8,in_cr5);
    matched_FUN_a04a1ee4();
    coprocessor_moveto(0xf,0,0,0,in_cr8,in_cr6);
  }
  else {
    coproc_moveto_Invalidate_Entire_Instruction(0);
    coprocessor_moveto(0xf,0,0,0,in_cr8,in_cr5);
    matched_FUN_a04a1f1c();
    coprocessor_moveto(0xf,0,0,0,in_cr8,in_cr6);
  }
  coprocessor_moveto(0xf,0,0,DAT_a04a43f8,in_cr7,in_cr8);
  uVar3 = coprocessor_movefromRt(0xf,0,0,in_cr7,in_cr4);
  if ((uVar3 & 2) == 0) {
    uVar3 = uVar3 & 0xfffff000;
  }
  else {
    uVar3 = uVar3 & 0xffff0000 | DAT_a04a43f8 & 0xffff;
  }
  coproc_moveto_Translation_table_base_0(uVar3);
  if ((uVar9 & 1) == 0) {
    uVar4 = 1;
  }
  else {
    uVar4 = 0x31;
  }
  coproc_moveto_Domain_Access_Control(uVar4);
  DataSynchronizationBarrier(0xf);
  InstructionSynchronizationBarrier(0xf);
  if ((uVar9 & 4) != 0) {
    matched_FUN_a04a1f1c();
    coproc_moveto_Control(uVar9 & 0xfffffffb);
  }
  do {
  } while( true );
}

