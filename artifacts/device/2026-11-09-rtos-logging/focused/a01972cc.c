/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int app_log_copy_to_sd(int param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  int iVar1;
  
  iVar1 = app_log_status();
  if (iVar1 < 1) {
    FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Save_l_a055fde8,DAT_a06f3084,0x1687,
                 s_AppUtil_RtosLogFileCopyToSD_a055ebf8,param_4);
    return -1;
  }
  iVar1 = file_exists_probe(s_b__RtosActive_log_a055fea8);
  if (iVar1 == 1) {
    if (param_1 != 0) {
      FUN_a02a70ec(s__I__APP_UTIL___06d___s__copy_log_a055ff14,0x168e,
                   s_AppUtil_RtosLogFileCopyToSD_a055ebf8,s_b__RtosActive_log_a055fea8,param_4);
      app_log_copy_file(s_b__RtosActive_log_a055fea8,s_c__RtosActive_log_a055ff40);
      return 1;
    }
    matched_thunk_FUN_a033a50c(s_c__RtosActive_log_a055ff40);
  }
  else if (param_1 != 0) {
    return iVar1;
  }
  iVar1 = file_exists_probe(s_b__RtosOlder_log_a055febc);
  if (iVar1 == 1) {
    FUN_a02a70ec(s__I__APP_UTIL___06d___s__copy_log_a055ff14,0x1698,
                 s_AppUtil_RtosLogFileCopyToSD_a055ebf8,s_b__RtosOlder_log_a055febc,param_4);
    app_log_copy_file(s_b__RtosOlder_log_a055febc,s_c__RtosOlder_log_a055ff54);
  }
  iVar1 = file_exists_probe(s_b__RtosOldest_log_a055fed0);
  if (iVar1 == 1) {
    FUN_a02a70ec(s__I__APP_UTIL___06d___s__copy_log_a055ff14,0x169e,
                 s_AppUtil_RtosLogFileCopyToSD_a055ebf8,s_b__RtosOldest_log_a055fed0);
    app_log_copy_file(s_b__RtosOldest_log_a055fed0,s_c__RtosOldest_log_a055ff68);
    return 1;
  }
  return iVar1;
}

