/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4
print_set_console_callback
          (undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  int iVar1;
  
  iVar1 = matched_FUN_a03bc46c(&DAT_a144b948,0xffffffff,param_3,param_4,param_4);
  if (iVar1 == 0x1c) {
    return 0xffffffff;
  }
  DAT_a144b97c = param_1;
  matched_thunk_FUN_a03c3c5c(&DAT_a144b948);
  return 0;
}

