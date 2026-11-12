/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 app_log_status(void)

{
  int iVar1;
  undefined4 local_c;
  
  local_c = 0;
  iVar1 = matched_FUN_a02a6b10();
  if (iVar1 < 0) {
    FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Get_lo_a055fb30,DAT_a06f3084,0x1583,
                 s_AppUtil_GetSaveLogStatus_a055eb04);
    local_c = 0xffffffff;
  }
  return local_c;
}

