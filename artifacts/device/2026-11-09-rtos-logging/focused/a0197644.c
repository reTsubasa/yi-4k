/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void app_set_save_log(int param_1)

{
  char *pcVar1;
  int iVar2;
  int local_20 [5];
  
  local_20[0] = 0;
  local_20[1] = 0;
  local_20[2] = 0;
  local_20[3] = 0;
  iVar2 = app_log_status();
  if (param_1 == iVar2) {
    pcVar1 = s__I__VOICE_CMD___06d___s__VoiceCm_a056dddc;
    if (param_1 == 0) {
      pcVar1 = s__I__VOICE_CMD___06d___s__VoiceCm_a056deac;
    }
    FUN_a02a70ec(s__sAppUtil_SetSaveLog_already__s_a05600cc,DAT_a06f3080,pcVar1 + 0x38);
    return;
  }
  if (iVar2 == 1) {
    print_set_save_log_flag(0);
    FUN_a02a70ec(s__sAppUtil_SetSaveLog_disabled_a05600ac,DAT_a06f3080);
    return;
  }
  matched_FUN_a02a708c(local_20);
  if ((local_20[0] == 0) && (local_20[3] == 0)) {
    print_set_console_callback();
    FUN_a02a70ec(s__sAppUtil_SetSaveLog_only_a056006c,DAT_a06f3080);
  }
  else {
    FUN_a02a70ec(s__sAppUtil_SetSaveLog_with_dmesg_o_a0560088,DAT_a06f3080);
  }
  print_set_save_log_flag(1);
  app_log_rotate_files();
  app_log_open_file(s_b__RtosActive_log_a055fea8);
  return;
}

