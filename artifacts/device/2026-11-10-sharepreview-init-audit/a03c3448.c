/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03c3448, name: matched_FUN_a03c3448.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4 matched_FUN_a03c3448(int *param_1,int *param_2,uint param_3,int param_4)

{
  undefined4 uVar1;
  int iVar2;
  int iVar3;
  undefined *puVar4;
  uint uVar5;
  int iVar6;
  undefined4 uVar7;
  
  if (param_1 == (int *)0x0) {
    return 2;
  }
  if (*param_1 != 0x42595445) {
    return 2;
  }
  if (param_2 == (int *)0x0) {
    return 3;
  }
  if ((param_3 == 0) || ((uint)param_1[7] < param_3)) {
    return 5;
  }
  if ((param_4 != 0) && (iVar3 = matched_FUN_a03c0d08(), iVar3 != 0)) {
    return 4;
  }
  puVar4 = (undefined *)matched_FUN_a03c0d4c();
  if ((puVar4 == &DAT_a1796c34) ||
     ((iVar3 = matched_FUN_a03c0d08(), iVar3 != 0 &&
      (uVar5 = matched_FUN_a03c0d08(), uVar5 < 0xf0f0f0f0)))) {
    return 0x13;
  }
  uVar5 = param_3 + 3 & 0xfffffffc;
  uVar1 = matched_FUN_a03c13b0();
  iVar3 = matched_FUN_a03c0d4c();
  do {
    param_1[8] = iVar3;
    matched_FUN_a03c1428(uVar1);
    iVar2 = matched_FUN_a03bd130(param_1,uVar5);
    uVar1 = matched_FUN_a03c13b0();
    if (iVar2 != 0) {
      uVar7 = 0;
      *param_2 = iVar2;
      goto LAB_a03bcd8c;
    }
  } while (param_1[8] != iVar3);
  if (param_4 != 0) {
    *(int **)(iVar3 + 0x70) = param_1;
    *(int **)(iVar3 + 0x80) = param_2;
    *(uint *)(iVar3 + 0x7c) = uVar5;
    *(code **)(iVar3 + 0x6c) = matched_FUN_a03bce34;
    iVar2 = param_1[10];
    param_1[10] = iVar2 + 1;
    if (iVar2 == 0) {
      param_1[9] = iVar3;
      *(int *)(iVar3 + 0x74) = iVar3;
      *(int *)(iVar3 + 0x78) = iVar3;
    }
    else {
      iVar6 = param_1[9];
      *(int *)(iVar3 + 0x74) = iVar6;
      iVar2 = *(int *)(iVar6 + 0x78);
      *(int *)(iVar3 + 0x78) = iVar2;
      *(int *)(iVar2 + 0x74) = iVar3;
      *(int *)(iVar6 + 0x78) = iVar3;
    }
    *(undefined4 *)(iVar3 + 0x30) = 9;
    *(undefined4 *)(iVar3 + 0x38) = 1;
    *(int *)(iVar3 + 0x4c) = param_4;
    DAT_a1796780 = DAT_a1796780 + 1;
    matched_FUN_a03c1428();
    matched_FUN_a03c1d5c(iVar3);
    return *(undefined4 *)(iVar3 + 0x88);
  }
  uVar7 = 0x10;
LAB_a03bcd8c:
  matched_FUN_a03c1428(uVar1);
  return uVar7;
}

