/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 app_shell_read_callback(undefined4 param_1,undefined4 param_2,uint param_3)

{
  undefined4 uVar1;
  
  if ((DAT_a1445460 == '\0') && (DAT_a1445468 != '\0')) {
    return 0;
  }
  if (4999 < param_3) {
    param_3 = 5000;
  }
  uVar1 = matched_FUN_a048eab8(0,param_1,param_2,param_3);
  return uVar1;
}

