/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 shell_savebin(int param_1,undefined4 *param_2,code *param_3)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  undefined1 auStack_118 [256];
  
  if (param_1 == 5) {
    if (*(char *)(param_2[1] + 1) == ':') {
      matched_FUN_a04f9b38(auStack_118,param_2[1],0x100);
      iVar1 = matched_FUN_a04fb328(param_2[2],0,0);
      uVar5 = param_2[3];
      iVar2 = matched_FUN_a04f9744(uVar5,s_crypto_a06372e8 + 4);
      if (iVar2 == 0) {
        iVar2 = matched_FUN_a04fb328(param_2[4],0,0);
        iVar2 = (1 - iVar1) + iVar2;
      }
      else {
        iVar2 = matched_FUN_a04f9744(uVar5,s___________________still_normal_a05f45a0 + 0x20);
        if (iVar2 != 0) {
          (*param_3)(s_unknown_syntax__a05b0260);
          return 0xfffffffc;
        }
        iVar2 = matched_FUN_a04fb328(param_2[4],0,0);
      }
      iVar3 = matched_analyst_fs_fopen(auStack_118,s__d__d_raw_a0576b54 + 8);
      iVar4 = 0;
      if (((iVar3 == 0) || (iVar4 = matched_analyst_fs_fwrite(iVar1,1,iVar2,iVar3), iVar2 != iVar4))
         || (iVar4 = matched_analyst_fs_fclose(iVar3), iVar4 < 0)) {
        uVar5 = matched_thunk_FUN_a033a1b4(iVar4);
        (*param_3)(s__s____s__err__d__a05afc88,*param_2,auStack_118,uVar5);
        uVar5 = 0xfffffffb;
      }
      else {
        uVar5 = 0;
      }
    }
    else {
      (*param_3)(s_no_drive_assigned_a05afc54);
      uVar5 = 0xfffffffe;
    }
  }
  else {
    (*param_3)(s_Usage___s__filename___From__to_l_a05b0234,*param_2);
    uVar5 = 0xffffffff;
  }
  return uVar5;
}

