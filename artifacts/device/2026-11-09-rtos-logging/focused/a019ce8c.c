/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void app_debug_marker_check(void)

{
  int iVar1;
  int iVar2;
  int local_20 [5];
  
  local_20[0] = 0;
  local_20[1] = 0;
  local_20[2] = 0;
  local_20[3] = 0;
  iVar1 = file_exists_probe(s_c__console_enable_script_a05618a4);
  iVar2 = file_exists_probe(s_c__save_log_enable_script_a0542fc0);
  if (iVar1 != 0) {
    app_set_console_output(1);
  }
  if (iVar2 != 0) {
    app_set_save_log(1);
  }
  matched_FUN_a02a708c(local_20);
  if (((local_20[0] == 1) && (DAT_a1055e7f == 1)) && (DAT_a105623c == 0)) {
    DAT_a105623c = (uint)DAT_a1055e7f;
    matched_FUN_a0479708(s__usr_local_share_script_start_te_a05618c0);
  }
  return;
}

