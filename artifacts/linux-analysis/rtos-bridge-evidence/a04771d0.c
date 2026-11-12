/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa04771d0, name: FUN_a04771d0.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_a04771d0(int *param_1,undefined4 *param_2)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 *local_30;
  undefined4 local_2c;
  undefined4 local_28;
  undefined4 *local_24;
  
  local_30 = (undefined4 *)0x0;
  local_2c = 0;
  if ((DAT_a1a30be4 == '\0') && (iVar2 = FUN_a04761f4(), iVar2 < 0)) {
    return iVar2;
  }
  if ((param_2 == (undefined4 *)0x0 || param_1 == (int *)0x0) || (*param_1 != 1)) {
    iVar2 = -3;
  }
  else if (DAT_a06f22a0 == 0) {
    iVar2 = -4;
  }
  else if (_DAT_a1a30c0c == (undefined4 *)0x0) {
    _DAT_a1a30c00 = FUN_a03cd2d8(param_1[8]);
    local_28 = 2;
    local_24 = (undefined4 *)FUN_a03cd2d8(0x10);
    local_24[1] = 1;
    uVar1 = _DAT_a1a30c00;
    *local_24 = &LAB_a0477780;
    local_24[3] = 1;
    local_24[2] = &LAB_a0477950;
    iVar2 = FUN_a03caab4(0x10000006,1,s_LINK_RPC_SVC_DATANOTIFY_a0625bf4,param_1[7],uVar1,param_1[8]
                         ,&local_28,1);
    if (iVar2 != 0) {
      FUN_a02a70ec(s__s__d__AmbaIPC_SvcRegister_fail__a0625b28,
                   s_AmpNetCtrl_DataSvc_CreateInstanc_a0625210,0x629);
    }
    FUN_a03cd264(local_24);
    _DAT_a1a30bf8 = FUN_a03c4e94(0,0x20000007,1);
    if (_DAT_a1a30bf8 == 0) {
      FUN_a02a70ec(s__s__d__AmbaIPC_ClientCreate_fail_a0625748,
                   s_AmpNetCtrl_DataSvc_CreateInstanc_a0625210,0x630);
    }
    if (DAT_a1a30be4 == '\x01') {
      iVar2 = FUN_a0473b30(_DAT_a1a30be8);
      if ((-1 < iVar2) && (iVar2 = FUN_a0473b44(&local_2c,&local_30,8,0x20), -1 < iVar2)) {
        *local_30 = 0;
        _DAT_a1a30bf0 = _DAT_a1a30bf0 + -8;
        param_2[1] = local_30;
        *param_2 = 1;
        _DAT_a1a30c0c = local_30;
        _DAT_a1a30bd4 = local_2c;
        iVar2 = FUN_a0479708(s__usr_bin_remoteapi_data_daemon_a0625c0c);
        if (iVar2 < 0) {
          FUN_a02a70ec(s__s__d__Fail_to_initialize_the_da_a0625c2c,iVar2);
        }
      }
    }
    else {
      iVar2 = -1;
    }
  }
  else {
    iVar2 = -6;
  }
  return iVar2;
}

