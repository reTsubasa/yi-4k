/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void app_shell_init(void)

{
  int iVar1;
  undefined4 local_34;
  undefined4 local_30;
  undefined4 uStack_2c;
  undefined4 uStack_28;
  undefined4 uStack_24;
  undefined4 local_20;
  undefined4 uStack_1c;
  undefined4 uStack_18;
  undefined4 uStack_14;
  
  local_34 = 0;
  local_30 = DAT_a055b6fc;
  uStack_2c = DAT_a055b700;
  uStack_28 = DAT_a055b704;
  uStack_24 = DAT_a055b708;
  local_20 = DAT_a055b70c;
  uStack_1c = DAT_a055b710;
  uStack_18 = DAT_a055b714;
  uStack_14 = DAT_a055b718;
  iVar1 = matched_FUN_a029a7d8(&DAT_a0fd7114,&local_20,&local_34,0x8000,0x20);
  if (iVar1 != 0) {
    FUN_a02a70ec(s_AmpUtil_GetAlignedPool_fail__a055b748);
  }
  FUN_a029dc38(&local_30);
  if (*(char *)(DAT_a078b608 + 5) != '\0') {
    matched_FUN_a029de40(app_shell_read_callback,app_shell_write_callback);
  }
  FUN_a02a70ec(s_AmbaShell_Started_a055b768);
  return;
}

