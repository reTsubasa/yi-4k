/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 matched_FUN_a0187414(void)

{
  undefined4 uVar1;
  
  DAT_a1a30f20 = &DAT_a078a878;
  DAT_a1a30f28 = &DAT_a078af80;
  DAT_a13c8798 = 4;
  if (PTR_matched_FUN_a047a2a0_a078a87c == (undefined *)0x0) {
    return 0xffffffff;
  }
                    /* WARNING: Could not recover jumptable at 0xa0187478. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  uVar1 = (*(code *)PTR_matched_FUN_a047a2a0_a078a87c)(4);
  return uVar1;
}

