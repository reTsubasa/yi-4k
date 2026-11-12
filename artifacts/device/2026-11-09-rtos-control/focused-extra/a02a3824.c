/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 shell_sleep(int param_1,undefined4 *param_2,code *param_3)

{
  int iVar1;
  undefined4 uVar2;
  undefined *puVar3;
  int iVar4;
  
  if (param_1 == 1) {
    (*param_3)(s_Usage___s__ms__a05b01c4,*param_2);
    return 0;
  }
  iVar1 = matched_FUN_a04fb328(param_2[1],0,0);
  uVar2 = matched_FUN_a03c13b0();
  puVar3 = (undefined *)matched_FUN_a03c0d4c();
  if (((puVar3 == (undefined *)0x0) || (iVar4 = matched_FUN_a03c0d08(), iVar4 != 0)) ||
     (puVar3 == &DAT_a1796c34)) {
    matched_FUN_a03c1428(uVar2);
    return 0x13;
  }
  if (iVar1 == 0) {
    matched_FUN_a03c1428(uVar2);
    return 0;
  }
  *(undefined4 *)(puVar3 + 0x88) = 0;
  *(undefined4 *)(puVar3 + 0x30) = 4;
  DAT_a1796780 = DAT_a1796780 + 1;
  *(undefined4 *)(puVar3 + 0x38) = 1;
  *(int *)(puVar3 + 0x4c) = iVar1;
  matched_FUN_a03c1428(uVar2);
  matched_FUN_a03c1d5c(puVar3);
  return *(undefined4 *)(puVar3 + 0x88);
}

