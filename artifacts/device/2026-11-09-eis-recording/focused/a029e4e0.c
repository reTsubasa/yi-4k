/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 FUN_a029e4e0(int param_1,undefined4 *param_2,code *param_3)

{
  char cVar1;
  int iVar2;
  undefined4 uVar3;
  int iVar4;
  int iVar5;
  char *pcVar6;
  char *pcVar7;
  char *pcVar8;
  char acStack_121 [261];
  
  iVar2 = matched_FUN_a029de9c();
  if (param_1 < 2) {
    (*param_3)(s_Usage___s__path__a05aea80,*param_2);
    return 0xffffffff;
  }
  pcVar6 = (char *)param_2[1];
  cVar1 = pcVar6[1];
  if (*pcVar6 == '.') {
    if (cVar1 == '\0') {
      return 0;
    }
    if (cVar1 != '.') goto LAB_a029e518;
    if ((pcVar6[2] == '\0') && (*(char *)(iVar2 + 3) == '\0')) {
      return 0;
    }
  }
  else {
LAB_a029e518:
    if (cVar1 == ':') {
      matched_FUN_a04f9900(acStack_121 + 1);
      goto LAB_a029e5c4;
    }
  }
  uVar3 = matched_FUN_a029de9c();
  matched_FUN_a04f9900(acStack_121 + 1,uVar3);
  iVar4 = matched_FUN_a04f99f0(acStack_121 + 1);
  if (iVar4 != 3 && acStack_121[iVar4] == '\\') {
    acStack_121[iVar4] = '\0';
  }
  iVar4 = matched_thunk_FUN_a0339e28(acStack_121 + 1);
  if (iVar4 < 0) {
    (*param_3)(s_cwd___s__is_offline__a05aea14,uVar3);
    return 0xffffd8f1;
  }
  matched_FUN_a04f9900(acStack_121 + 1,iVar2);
  iVar4 = matched_FUN_a04f99f0(acStack_121 + 1);
  uVar3 = param_2[1];
  iVar5 = matched_FUN_a04f99f0(uVar3);
  if (0xff < (uint)(iVar5 + iVar4)) {
    (*param_3)(s_Path__s__s_is_too_long_a05aea94,acStack_121 + 1,uVar3);
    return 0xffffffff;
  }
  matched_FUN_a029c680(acStack_121 + iVar4 + 1,uVar3,iVar5 + 1);
LAB_a029e5c4:
  iVar4 = matched_thunk_FUN_a0339e28(acStack_121 + 1);
  if (*(char *)param_2[1] == ':' || iVar4 < 0) {
    uVar3 = matched_thunk_FUN_a033a1b4();
    (*param_3)(s_Cannot_change_working_directory_t_a05aeaac,acStack_121 + 1,uVar3);
    uVar3 = 0xffffffff;
  }
  else {
    matched_FUN_a04f9900(iVar2,acStack_121 + 1);
    pcVar6 = (char *)param_2[1];
    if (((*pcVar6 == '.') && (pcVar6[1] == '.')) && (pcVar6[2] == '\0')) {
      iVar4 = matched_FUN_a04f99f0(iVar2);
      pcVar6 = (char *)(iVar2 + iVar4);
      if (*(char *)(iVar2 + iVar4) != '\\') {
        pcVar7 = pcVar6 + 1;
        pcVar8 = (char *)(iVar2 + iVar4 + -1);
        do {
          pcVar6 = pcVar8;
          pcVar7 = pcVar7 + -1;
          *pcVar7 = '\0';
          iVar4 = iVar4 + -1;
          pcVar8 = pcVar6 + -1;
        } while (*pcVar6 != '\\');
      }
      *pcVar6 = '\0';
      pcVar8 = (char *)(iVar2 + iVar4 + -1);
      pcVar6 = pcVar8;
      if (*(char *)(iVar2 + iVar4 + -1) != '\\') {
        iVar4 = (iVar4 + -2) - (int)pcVar8;
        do {
          *pcVar6 = '\0';
          pcVar6 = pcVar6 + iVar2 + iVar4;
          pcVar8 = pcVar8 + -1;
        } while (*pcVar8 != '\\');
      }
      *pcVar6 = '\0';
    }
    iVar4 = matched_FUN_a04f99f0(iVar2);
    if (*(char *)(iVar2 + iVar4 + -1) == '\\') {
      return 0;
    }
    uVar3 = 0;
    *(undefined1 *)(iVar2 + iVar4) = 0x5c;
    *(undefined1 *)(iVar2 + iVar4 + 1) = 0;
  }
  return uVar3;
}

