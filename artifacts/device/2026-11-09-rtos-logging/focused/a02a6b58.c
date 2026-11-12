/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 print_set_file_callback(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = matched_FUN_a03bc46c(DAT_a02a6b9c,0xffffffff);
  if (iVar1 == 0) {
    DAT_a144b780 = param_2;
    DAT_a144b784 = param_1;
    matched_thunk_FUN_a03c3c5c(DAT_a02a6b9c);
    uVar2 = 0;
  }
  else {
    uVar2 = 0xffffffff;
  }
  return uVar2;
}

