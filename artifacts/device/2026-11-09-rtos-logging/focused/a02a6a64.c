/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4
print_set_save_log_flag(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = matched_FUN_a03bc46c(DAT_a02a6aa4,0xffffffff,param_3,param_4,param_4);
  if (iVar1 == 0) {
    DAT_a144b7c8 = param_1;
    matched_thunk_FUN_a03c3c5c(DAT_a02a6aa4);
    uVar2 = 0;
  }
  else {
    uVar2 = 0xffffffff;
  }
  return uVar2;
}

