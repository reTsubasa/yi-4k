/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03cae84, name: matched_FUN_a03cae84.
 * Types and names may be inferred. Runtime validation not performed. */


void matched_FUN_a03cae84(int param_1)

{
  int *piVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  uint uVar6;
  undefined4 *puVar7;
  int iVar8;
  int iVar9;
  uint local_3c [6];
  
  iVar8 = param_1 + 0x44;
  local_3c[1] = 0;
  local_3c[2] = 0;
  local_3c[3] = 0;
  local_3c[4] = 0;
  local_3c[2] = matched_FUN_a03cd2d8(DAT_a14452e4);
  do {
    iVar2 = matched_FUN_a03bc4ac(iVar8,5,1,local_3c,0xffffffff);
    if (iVar2 != 0) {
      FUN_a02a70ec(s_SVC_THREAD_FUN_Event_Flag_Take_E_a060e3f0,iVar2);
      break;
    }
    if ((local_3c[0] & 4) != 0) {
      matched_FUN_a03cd264(local_3c[2]);
      iVar8 = matched_FUN_a03bc4e8(iVar8,8);
      if (iVar8 == 0) {
        return;
      }
      FUN_a02a70ec(s_Set_Thread_Finish_Flag_Error__st_a060e488);
      return;
    }
    puVar7 = (undefined4 *)(param_1 + 0x350);
    matched_FUN_a03bc46c(param_1 + 0x10,0xffffffff);
    matched_FUN_a029c680(puVar7,*(undefined4 *)(param_1 + 0x33c),*(int *)(param_1 + 0x340) + 0x4c);
    iVar2 = matched_FUN_a03bc4e8(iVar8,2);
    if (iVar2 != 0) {
      FUN_a02a70ec(s_SVC_THREAD_FUN_Event_Flag_Give_E_a060e428);
    }
    if (0 < *(int *)(param_1 + 0x348)) {
      iVar9 = 0;
      iVar2 = param_1;
      do {
        piVar1 = (int *)(iVar2 + 0x170);
        iVar2 = iVar2 + 0x3c;
        if (*piVar1 == 0) {
          uVar3 = *(undefined4 *)(param_1 + 0x354);
          uVar4 = *(undefined4 *)(param_1 + 0x358);
          uVar5 = *(undefined4 *)(param_1 + 0x35c);
          iVar9 = param_1 + iVar9 * 0x3c;
          iVar2 = iVar9 + 0x15c;
          *(undefined4 *)(iVar9 + 0x15c) = *puVar7;
          *(undefined4 *)(iVar9 + 0x160) = uVar3;
          *(undefined4 *)(iVar9 + 0x164) = uVar4;
          *(undefined4 *)(iVar9 + 0x168) = uVar5;
          uVar3 = *(undefined4 *)(param_1 + 0x364);
          uVar4 = *(undefined4 *)(param_1 + 0x368);
          uVar5 = *(undefined4 *)(param_1 + 0x36c);
          *(undefined4 *)(iVar9 + 0x16c) = *(undefined4 *)(param_1 + 0x360);
          *(undefined4 *)(iVar9 + 0x170) = uVar3;
          *(undefined4 *)(iVar9 + 0x174) = uVar4;
          *(undefined4 *)(iVar9 + 0x178) = uVar5;
          uVar3 = *(undefined4 *)(param_1 + 0x374);
          uVar4 = *(undefined4 *)(param_1 + 0x378);
          uVar5 = *(undefined4 *)(param_1 + 0x37c);
          *(undefined4 *)(iVar9 + 0x17c) = *(undefined4 *)(param_1 + 0x370);
          *(undefined4 *)(iVar9 + 0x180) = uVar3;
          *(undefined4 *)(iVar9 + 0x184) = uVar4;
          *(undefined4 *)(iVar9 + 0x188) = uVar5;
          uVar3 = *(undefined4 *)(param_1 + 900);
          uVar4 = *(undefined4 *)(param_1 + 0x388);
          *(undefined4 *)(iVar9 + 0x18c) = *(undefined4 *)(param_1 + 0x380);
          *(undefined4 *)(iVar9 + 400) = uVar3;
          *(undefined4 *)(iVar9 + 0x194) = uVar4;
          *(int *)(iVar9 + 0x170) = param_1;
          if (iVar2 != 0) {
            *(undefined4 *)(param_1 + 0x378) = *DAT_a062acb4;
            matched_FUN_a03c89d0
                      (puVar7,*(undefined4 *)
                               (*(int *)(param_1 + 0x34c) + *(int *)(param_1 + 0x398) * 8 + -4));
            uVar6 = (uint)(*(int *)(param_1 + 0x398) <= *(int *)(param_1 + 0x348));
            if (*(int *)(param_1 + 0x398) < 1) {
              uVar6 = 0;
            }
            if (uVar6 == 0) {
              local_3c[4] = 2;
              local_3c[3] = uVar6;
              matched_FUN_a03cadcc(param_1 + 0x38c,iVar2,local_3c + 1);
            }
            else {
              matched_FUN_a04f8dec(local_3c[2],0,DAT_a14452e4);
              (**(code **)(*(int *)(param_1 + 0x34c) + (*(int *)(param_1 + 0x398) + 0x1fffffff) * 8)
              )(param_1 + 0x39c,local_3c + 1);
              matched_FUN_a03cadcc(param_1 + 0x38c,iVar2,local_3c + 1);
            }
            goto LAB_a03caf70;
          }
          break;
        }
        iVar9 = iVar9 + 1;
      } while (iVar9 != 8);
      FUN_a02a70ec(s_ERROR___reached_AIPC_CLIENT_NR_M_a060e460);
    }
LAB_a03caf70:
    matched_thunk_FUN_a03c3c5c(param_1 + 0x10);
  } while (*(int *)(param_1 + 0x344) == 1);
  matched_FUN_a03cd264(local_3c[2]);
  return;
}

