/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0476380, name: FUN_a0476380.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_a0476380(void)

{
  int iVar1;
  undefined4 local_18;
  undefined4 *local_14;
  
  _DAT_a1a30bf4 = FUN_a03cd2d8(0x1000);
  if (_DAT_a1a30bf4 == 0) {
    FUN_a02a70ec(s__s__d__Fail_to_allocate_the_heap_a0625628,s_AmpNetCtrl_LnxCmdInit_a06253cc,0x191)
    ;
    iVar1 = -1;
  }
  else {
    local_18 = 1;
    local_14 = (undefined4 *)FUN_a03cd2d8(8);
    local_14[1] = 0;
    iVar1 = _DAT_a1a30bf4;
    *local_14 = &LAB_a0477a44;
    iVar1 = FUN_a03caab4(0x1000000b,1,s_LINK_RPC_SVC_LNXCMDHNDLR_a0625660,0x59,iVar1,0x1000,
                         &local_18,1);
    if (iVar1 != 0) {
      FUN_a02a70ec(s__s__d__Fail_to_AmbaIPC_SvcRegist_a062567c,s_AmpNetCtrl_LnxCmdInit_a06253cc,
                   0x19a,iVar1);
      FUN_a03cd264(local_14);
      return iVar1;
    }
    FUN_a03cd264(local_14);
    if (_DAT_a1a30be0 == 0) {
      iVar1 = FUN_a0479708(s__usr_bin_remoteapi_syssvc_daemon_a06256ac);
      if (iVar1 < 0) {
        FUN_a02a70ec(s__s__d__Fail_to_initialize_the_sy_a06256d0,iVar1);
        return iVar1;
      }
      _DAT_a1a30be0 = 1;
    }
    else {
      FUN_a02a70ec(s_The_server_of_linux_command_has_b_a0625714);
      iVar1 = 0;
    }
    _DAT_a1a30c1c = FUN_a03c4e94(0,0x20000006,1);
    if (_DAT_a1a30c1c == 0) {
      FUN_a02a70ec(s__s__d__AmbaIPC_ClientCreate_fail_a0625748,s_AmpNetCtrl_LnxCmdInit_a06253cc,
                   0x1ae);
      iVar1 = -1;
    }
  }
  return iVar1;
}

