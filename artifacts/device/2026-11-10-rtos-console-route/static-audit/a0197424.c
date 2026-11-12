/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0197424, name: matched_FUN_a0197424.
 * Types and names may be inferred. Runtime validation not performed. */


void matched_FUN_a0197424(int param_1)

{
  char *pcVar1;
  int iVar2;
  int local_20 [5];
  
  local_20[0] = 0;
  local_20[1] = 0;
  local_20[2] = 0;
  local_20[3] = 0;
  matched_FUN_a02a708c(local_20);
  if (local_20[0] == param_1) {
    pcVar1 = s__I__VOICE_CMD___06d___s__VoiceCm_a056deac;
    if (local_20[0] != 0) {
      pcVar1 = s__I__VOICE_CMD___06d___s__VoiceCm_a056dddc;
    }
    FUN_a02a70ec(s__sAppUtil_SetDmesg_already__s_a055ffe0,DAT_a06f3080,pcVar1 + 0x38);
    return;
  }
  if (local_20[0] == 1) {
    local_20[0] = 0;
    matched_FUN_a02a702c(local_20);
    FUN_a02a70ec(s__sAppUtil_SetDmesg_disabled_a055ffc0,DAT_a06f3080);
    return;
  }
  local_20[0] = 1;
  iVar2 = matched_FUN_a02a6ff0();
  if (iVar2 == 0) {
    matched_FUN_a02a6fb0(&LAB_a0296600);
    FUN_a02a70ec(s__sAppUtil_SetDmesg_with_save_log_a055ff7c,DAT_a06f3080);
  }
  else {
    FUN_a02a70ec(s__sAppUtil_SetDmesg_only_a055ffa4,DAT_a06f3080);
  }
  matched_FUN_a02a702c(local_20);
  matched_FUN_a029de40(&LAB_a0296618,&LAB_a0296600);
  return;
}

