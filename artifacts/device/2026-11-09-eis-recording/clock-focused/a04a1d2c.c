/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void matched_FUN_a04a1d2c(void)

{
  undefined4 local_18;
  undefined4 local_14;
  
  rtos_mmu_init(1);
  matched_FUN_a04a4558(24000000,0);
  matched_FUN_a04974a0();
  matched_FUN_a0187e78();
  DAT_a07895e0 = 1;
  matched_FUN_a04a2568(&DAT_a07895e0,4);
  do {
  } while (DAT_a07895e0 != 0x504d53);
  matched_FUN_a0495c7c();
  DAT_a1a3a528 = 0;
  local_18 = 1000;
  local_14 = 1000;
  matched_FUN_a0495d30(7,&local_18);
  matched_FUN_a048f410();
  return;
}

