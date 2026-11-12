/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa019ce8c, name: FUN_a019ce8c.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_a019ce8c(void)

{
  int iVar1;
  int iVar2;
  int local_20 [5];
  
  local_20[0] = 0;
  local_20[1] = 0;
  local_20[2] = 0;
  local_20[3] = 0;
  iVar1 = FUN_a019449c(s_c__console_enable_script_a05618a4);
  iVar2 = FUN_a019449c(s_c__save_log_enable_script_a0542fc0);
  if (iVar1 != 0) {
    FUN_a0197424(1);
  }
  if (iVar2 != 0) {
    FUN_a0197644(1);
  }
  FUN_a02a708c(local_20);
  if (((local_20[0] == 1) && (DAT_a1055e7f == 1)) && (_DAT_a105623c == 0)) {
    _DAT_a105623c = (uint)DAT_a1055e7f;
    FUN_a0479708(s__usr_local_share_script_start_te_a05618c0);
  }
  return;
}

