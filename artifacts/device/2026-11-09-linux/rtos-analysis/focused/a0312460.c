/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


uint warp_set(char *param_1)

{
  uint uVar1;
  uint uVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  byte *pbVar9;
  int *piVar10;
  int iVar11;
  undefined4 local_8c;
  int local_88;
  int local_84;
  int local_80;
  char local_7c;
  char local_7b;
  undefined1 auStack_78 [8];
  undefined4 local_70;
  undefined4 local_6c;
  
  local_88 = 0;
  local_84 = 0;
  local_80 = 0;
  if ((DAT_a14bf0e4 & 4) != 0) {
    FUN_a02a70ec(s_AmbaDSP_ImgSetWarpCompensation__a05e6db8);
    FUN_a02a70ec(s_Pipe__d__Algo__d__Func__d__Ctx___a05d1c30,*param_1,param_1[1],param_1[2],
                 param_1[3],*(undefined4 *)(param_1 + 4),param_1[8]);
  }
  local_7c = *param_1;
  local_7b = param_1[3];
  uVar1 = FUN_a0308880(&local_7c,&local_8c);
  if ((int)uVar1 < 0) {
    FUN_a02a70ec(s_Warning__Cannot_get_context_mute_a05d0f84);
    return uVar1;
  }
  matched_FUN_a03bc46c(local_8c,0);
  if (*param_1 == '\0') {
    FUN_a0308754(&local_7c,&local_88);
    iVar7 = local_88 + 0x41104;
    iVar4 = local_88 + 0x47600;
    iVar8 = local_88 + 0x41154;
    if (*(int *)(param_1 + 4) == 0xf) {
      uVar1 = (uint)*(byte *)(local_88 + 0x56392);
      if (uVar1 < *(byte *)(local_88 + 0x4088a)) {
        uVar1 = uVar1 + (*(uint *)(local_88 + 0x38) & 0xff);
      }
      local_80 = uVar1 - *(byte *)(local_88 + 0x4088a);
      iVar5 = *(int *)(local_88 + (local_80 + 0x35d92) * 4 + 4);
    }
    else {
      FUN_a03089ac(*(int *)(param_1 + 4),&local_7c,&local_80);
      iVar5 = *(int *)(local_88 + (local_80 + 0x35d92) * 4 + 4);
      *(char *)(local_88 + 0x56392) = (char)local_80;
    }
    iVar6 = iVar5 + 0xd060;
    iVar5 = iVar5 + 0xe860;
    cVar3 = *param_1;
    piVar10 = (int *)(local_88 + 0x5637c);
    pbVar9 = (byte *)(local_88 + 0x5cf70);
    iVar11 = 0;
    if (cVar3 == '\0') goto LAB_a03126e4;
LAB_a0312530:
    if (cVar3 != '\x01') {
      uVar1 = 0xffffffff;
      goto LAB_a0312774;
    }
    matched_FUN_a029c680(iVar6,iVar11,0x1800);
    matched_FUN_a029c680(iVar5,iVar11 + 0x1800,0x1800);
    *(int *)(iVar7 + 8) = iVar6;
    *(int *)(iVar7 + 0xc) = iVar5;
    iVar4 = matched_FUN_a0308b8c();
    if (iVar4 == 0) {
LAB_a03127f0:
      uVar1 = 0;
      matched_FUN_a04a22cc(iVar6,0x1800);
      matched_FUN_a04a22cc(iVar5,0x1800);
      if ((*(uint *)(param_1 + 4) & 0xf) != 0xf) {
        uVar1 = FUN_a02bd9f0(*(uint *)(param_1 + 4),0,iVar7);
      }
    }
    else {
      matched_FUN_a029c680(auStack_78,iVar7,0x50);
      matched_FUN_a04a22cc(local_70,0x1800);
      matched_FUN_a04a22cc(local_6c,0x1800);
      if ((*(uint *)(param_1 + 4) & 0xf) == 0xf) {
        uVar1 = 0;
      }
      else {
        uVar1 = FUN_a02bd9f0(*(uint *)(param_1 + 4),0,auStack_78);
      }
    }
  }
  else {
    if (*param_1 != '\x01') {
      FUN_a02a70ec(s_Warning__AmbaDSP_ImgSetWarpCompe_a05e6dd8);
      matched_thunk_FUN_a03c3c5c(local_8c);
      return 0xffffffff;
    }
    FUN_a0308754(&local_7c,&local_84);
    iVar4 = 0;
    piVar10 = (int *)(local_84 + 0x772dc);
    pbVar9 = (byte *)(local_84 + 0x772e4);
    cVar3 = *param_1;
    iVar11 = local_84 + 0x68560;
    iVar6 = local_84 + 0x15480;
    iVar5 = local_84 + 0x16c80;
    iVar7 = local_84 + 0x60884;
    iVar8 = local_84 + 0x608d4;
    if (cVar3 != '\0') goto LAB_a0312530;
LAB_a03126e4:
    uVar1 = 0;
    matched_FUN_a029c680(iVar6,iVar4,0x1800);
    matched_FUN_a029c680(iVar5,iVar4 + 0x1800,0x1800);
    *(int *)(iVar7 + 8) = iVar6;
    *(int *)(iVar7 + 0xc) = iVar5;
    iVar4 = matched_FUN_a0308b8c();
    if (iVar4 == 0) goto LAB_a03127f0;
    matched_FUN_a029c680(auStack_78,iVar7,0x50);
    matched_FUN_a04a22cc(local_70,0x1800);
    matched_FUN_a04a22cc(local_6c,0x1800);
    if ((*(uint *)(param_1 + 4) & 0xf) != 0xf) {
      uVar1 = FUN_a02bd9f0(*(uint *)(param_1 + 4),0,auStack_78);
    }
  }
  *pbVar9 = *pbVar9 | 4;
  if ((*piVar10 != 0) && ((*(uint *)(param_1 + 4) & 0xf) != 0xf)) {
    uVar2 = FUN_a02bc3f8(*(uint *)(param_1 + 4),iVar8);
    uVar1 = uVar1 | uVar2;
  }
LAB_a0312774:
  matched_thunk_FUN_a03c3c5c(local_8c);
  return uVar1;
}

