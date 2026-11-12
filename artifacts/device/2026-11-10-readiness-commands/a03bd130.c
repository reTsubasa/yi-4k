/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03bd130, name: matched_FUN_a03bd130.
 * Types and names may be inferred. Runtime validation not performed. */


int * matched_FUN_a03bd130(int param_1,uint param_2)

{
  byte bVar1;
  bool bVar2;
  undefined4 uVar3;
  int iVar4;
  int *piVar5;
  int *piVar6;
  int *piVar7;
  int iVar8;
  uint uVar9;
  
  uVar3 = matched_FUN_a03c13b0();
  if (param_2 < *(uint *)(param_1 + 8)) {
    piVar6 = *(int **)(param_1 + 0x14);
    bVar1 = 0;
    uVar9 = 0;
    iVar8 = *(int *)(param_1 + 0xc) + 1;
    piVar7 = piVar6;
LAB_a03bd1d4:
    do {
      if (piVar6[1] == -0x1112) {
        piVar5 = (int *)*piVar6;
        bVar2 = (bool)(bVar1 ^ 1);
        if (piVar6 == piVar7) {
          bVar2 = false;
        }
        if (bVar2) {
          piVar7 = piVar6;
        }
        uVar9 = (int)piVar5 + (-8 - (int)piVar6);
        if (param_2 <= uVar9) break;
        if (piVar5[1] == -0x1112) {
          *piVar6 = *piVar5;
          if (*(int **)(param_1 + 0x14) == piVar5) {
            *(int **)(param_1 + 0x14) = piVar6;
          }
          *(int *)(param_1 + 0xc) = *(int *)(param_1 + 0xc) + -1;
          bVar1 = 1;
          uVar9 = 0;
          goto LAB_a03bd17c;
        }
        piVar6 = (int *)*piVar5;
        if (iVar8 != 0) {
          iVar8 = iVar8 + -1;
          bVar1 = 1;
          uVar9 = 0;
          goto LAB_a03bd17c;
        }
        bVar1 = 1;
        uVar9 = 0;
      }
      else {
        piVar6 = (int *)*piVar6;
LAB_a03bd17c:
        if (iVar8 != 0) {
          iVar8 = iVar8 + -1;
        }
      }
      matched_FUN_a03c1428(uVar3);
      uVar3 = matched_FUN_a03c13b0();
      iVar4 = matched_FUN_a03c0d4c();
      if (*(int *)(param_1 + 0x20) != iVar4) {
        piVar6 = *(int **)(param_1 + 0x14);
        *(int *)(param_1 + 0x20) = iVar4;
        piVar7 = (int *)*piVar6;
        iVar8 = *(int *)(param_1 + 0xc) + 1;
        if (piVar6[1] == -0x1112) {
          uVar9 = (int)piVar7 + (-8 - (int)piVar6);
          if ((param_2 <= uVar9) || (piVar7[1] == -0x1112)) {
            piVar7 = piVar6;
            if (iVar8 == 0) break;
            goto LAB_a03bd1d4;
          }
          piVar7 = (int *)*piVar7;
        }
        *(int **)(param_1 + 0x14) = piVar7;
        piVar6 = piVar7;
      }
    } while (iVar8 != 0);
    if (uVar9 == 0) {
      *(int **)(param_1 + 0x14) = piVar7;
      matched_FUN_a03c1428(uVar3);
      return (int *)0x0;
    }
    if (0x13 < uVar9 - param_2) {
      iVar8 = (int)piVar6 + param_2 + 8;
      *(int *)((int)piVar6 + param_2 + 8) = *piVar6;
      *(undefined4 *)(iVar8 + 4) = 0xffffeeee;
      *(int *)(param_1 + 0xc) = *(int *)(param_1 + 0xc) + 1;
      *piVar6 = iVar8;
      uVar9 = param_2;
    }
    piVar6[1] = param_1;
    *(uint *)(param_1 + 8) = (*(int *)(param_1 + 8) + -8) - uVar9;
    if (piVar6 == piVar7) {
      piVar7 = (int *)*piVar6;
    }
    *(int **)(param_1 + 0x14) = piVar7;
    matched_FUN_a03c1428(uVar3);
    piVar6 = piVar6 + 2;
  }
  else {
    matched_FUN_a03c1428();
    piVar6 = (int *)0x0;
  }
  return piVar6;
}

