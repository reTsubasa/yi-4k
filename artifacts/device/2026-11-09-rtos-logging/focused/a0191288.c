/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4
app_log_write_and_flush(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  undefined4 uVar1;
  
  uVar1 = matched_analyst_fs_fwrite(param_1,1,param_2,param_3,param_4);
  matched_thunk_FUN_a033a3b0(param_3);
  return uVar1;
}

