/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 app_log_rotate_files(void)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = app_log_status();
  if (iVar1 < 1) {
    FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Save_l_a055fde8,DAT_a06f3084,0x166b,
                 s_AppUtil_RtosLogFileRename_a055e91c);
    return 0xffffffff;
  }
  iVar1 = file_stat_status_probe(s_b__RtosActive_log_a055fea8);
  if (iVar1 == 1) {
    FUN_a02a70ec(s__I__APP_UTIL___06d___s__the_file_a055fee4,0x167b,
                 s_AppUtil_RtosLogFileRename_a055e91c,s_b__RtosActive_log_a055fea8);
    return 1;
  }
  iVar1 = file_stat_status_probe(s_b__RtosOlder_log_a055febc);
  uVar2 = 1;
  if (iVar1 != 1) {
    iVar1 = file_stat_status_probe(s_b__RtosOldest_log_a055fed0);
    uVar2 = 1;
    if (iVar1 != 1) {
      uVar2 = matched_thunk_FUN_a033a50c(s_b__RtosOldest_log_a055fed0);
    }
    matched_thunk_FUN_a033a558(s_b__RtosOlder_log_a055febc,s_b__RtosOldest_log_a055fed0);
  }
  matched_thunk_FUN_a033a558(s_b__RtosActive_log_a055fea8,s_b__RtosOlder_log_a055febc);
  return uVar2;
}

