/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0476bb4, name: FUN_a0476bb4.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_a0476bb4(int *param_1,undefined4 *param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 local_30;
  undefined4 *local_2c;
  undefined4 local_28;
  undefined4 *local_24;
  
  local_30 = 0;
  local_2c = (undefined4 *)0x0;
  if ((DAT_a1a30be4 == '\0') && (iVar1 = FUN_a04761f4(), iVar1 < 0)) {
    return iVar1;
  }
  if (param_2 != (undefined4 *)0x0 && param_1 != (int *)0x0) {
    if (*param_1 == 0) {
      if (_DAT_a1a30bfc != (undefined4 *)0x0) {
        return -6;
      }
      if (DAT_a1a30be4 != '\x01') {
        return -1;
      }
      iVar1 = FUN_a0473b30(_DAT_a1a30be8);
      if (iVar1 < 0) {
        return iVar1;
      }
      iVar2 = FUN_a0473b44(&local_30,&local_2c,8,0x20);
      iVar1 = _DAT_a1a30bdc;
      if (iVar2 < 0) {
        return iVar2;
      }
      *local_2c = 0;
      param_2[1] = local_2c;
      *param_2 = 0;
      iVar3 = param_1[5];
      _DAT_a1a30bfc = local_2c;
      _DAT_a1a30bf0 = _DAT_a1a30bf0 + -8;
      _DAT_a1a30bd8 = local_30;
      iVar2 = FUN_a0478014(_DAT_a1a30be8,iVar1 + iVar3,param_1 + 4);
      _DAT_a1a30bf0 = _DAT_a1a30bf0 - (iVar1 + iVar3);
      if (iVar2 < 0) {
        FUN_a02a70ec(s__s__d__Fail_to_init_the_Ble_Netw_a0625ae4,
                     s_AmpNetCtrl_CreateInstance_a0625314,0x42f);
        return iVar2;
      }
      return iVar2;
    }
    if (*param_1 == 1) {
      if (DAT_a06f22a0 == 0) {
        return -4;
      }
      if (_DAT_a1a30c18 != (undefined4 *)0x0) {
        return -6;
      }
      _DAT_a1a30c14 = FUN_a03cd2d8(param_1[2]);
      if (_DAT_a1a30c14 == 0) {
        FUN_a02a70ec(s__s__d__Fail_to_allocate_the_heap_a0625628,
                     s_AmpNetCtrl_CreateInstance_a0625314,0x442);
        return -1;
      }
      local_28 = 2;
      local_24 = (undefined4 *)FUN_a03cd2d8(0x10);
      local_24[1] = 1;
      iVar1 = _DAT_a1a30c14;
      *local_24 = &LAB_a0477b48;
      local_24[3] = 1;
      local_24[2] = &LAB_a0477b9c;
      iVar1 = FUN_a03caab4(0x10000005,1,s_LINK_RPC_SVC_NETCTRL_a0625b10,param_1[1],iVar1,param_1[2],
                           &local_28,1);
      if (iVar1 != 0) {
        FUN_a02a70ec(s__s__d__AmbaIPC_SvcRegister_fail__a0625b28,
                     s_AmpNetCtrl_CreateInstance_a0625314,0x450,iVar1);
        FUN_a03cd264(local_24);
        return iVar1;
      }
      FUN_a03cd264(local_24);
      iVar1 = FUN_a0479708(s__usr_bin_remoteapi_cmd_daemon_a0625b54);
      if (iVar1 < 0) {
        FUN_a02a70ec(s__s__d__Fail_to_initialize_the_cm_a0625b74,
                     s_AmpNetCtrl_CreateInstance_a0625314,0x458,iVar1);
        return iVar1;
      }
      _DAT_a1a30c10 = FUN_a03c4e94(0,0x20000005,1);
      if (_DAT_a1a30c10 == 0) {
        FUN_a02a70ec(s__s__d__AmbaIPC_ClientCreate_fail_a0625748,
                     s_AmpNetCtrl_CreateInstance_a0625314,0x45e);
      }
      else if (DAT_a1a30be4 == '\x01') {
        iVar1 = FUN_a0473b30(_DAT_a1a30be8);
        if (iVar1 < 0) {
          return iVar1;
        }
        iVar1 = FUN_a0473b44(&local_30,&local_2c,8,0x20);
        if (iVar1 < 0) {
          return iVar1;
        }
        _DAT_a1a30bf0 = _DAT_a1a30bf0 + -8;
        *local_2c = 0;
        _DAT_a1a30c18 = local_2c;
        _DAT_a1a30bcc = local_30;
        param_2[1] = local_2c;
        *param_2 = 1;
        return iVar1;
      }
      return -1;
    }
  }
  return -3;
}

