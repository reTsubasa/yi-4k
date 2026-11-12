/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 app_log_copy_file(undefined4 param_1,undefined4 param_2)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  uint local_74;
  undefined1 auStack_70 [76];
  undefined1 local_24;
  
  local_74 = 0;
  matched_FUN_a03d5af0(auStack_70);
  local_24 = 0;
  matched_FUN_a04f9900(auStack_70,param_1);
  iVar1 = matched_FUN_a03d8610(auStack_70);
  matched_FUN_a03d5af0(auStack_70);
  local_24 = 2;
  matched_FUN_a04f9900(auStack_70,param_2);
  iVar2 = matched_FUN_a03d8610(auStack_70);
  if (iVar1 == 0 || iVar2 == 0) {
    FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Cannot_a055fc30,DAT_a06f3084,0x15a1,
                 s_AppUtil_CopyFile_a055e89c,param_1,param_2);
    uVar5 = 0xffffffff;
    if (iVar1 == 0) goto LAB_a0196e74;
  }
  else {
    iVar3 = matched_analyst_pool_alloc(DAT_a13a23e4,&local_74,0x1020,100);
    if (iVar3 == 0) {
      iVar3 = (local_74 & 0xffffffe0) + 0x20;
      matched_FUN_a04f8dec(iVar3,0,0x1000);
      do {
        iVar4 = matched_FUN_a03d5d6c(iVar3,1,0x1000,iVar1);
        if (iVar4 == 0) {
          iVar3 = matched_FUN_a03d66e8(iVar1);
          uVar5 = 0;
          if (iVar3 != 1) goto LAB_a0196f0c;
          goto LAB_a0196e68;
        }
        iVar4 = matched_FUN_a03d5fe0(iVar3,1,iVar4,iVar2);
      } while (iVar4 != 0);
      uVar5 = 0xffffffff;
      matched_FUN_a03d66e8(iVar1);
LAB_a0196f0c:
      FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Failed_a055fc68,DAT_a06f3084,0x15b3,
                   s_AppUtil_CopyFile_a055e89c,param_1,param_2);
    }
    else {
LAB_a0196e68:
      uVar5 = 0;
    }
  }
  matched_FUN_a03d5b54(iVar1);
LAB_a0196e74:
  if (iVar2 != 0) {
    matched_FUN_a03d68bc(iVar2);
    matched_FUN_a03d5b54(iVar2);
  }
  if (local_74 != 0) {
    matched_analyst_pool_free();
  }
  return uVar5;
}

