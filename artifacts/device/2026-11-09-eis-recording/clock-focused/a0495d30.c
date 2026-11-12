/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 matched_FUN_a0495d30(uint param_1,int *param_2)

{
  uint uVar1;
  undefined1 uVar2;
  int iVar3;
  undefined4 uVar4;
  int *piVar5;
  int iVar6;
  int iVar7;
  
  uVar2 = (&DAT_a078b700)[param_1 * 0x1c];
  iVar7 = (&DAT_a078b708)[param_1 * 7];
  if (param_1 < 8) {
    matched_FUN_a049758c(uVar2);
    iVar3 = DAT_a062aca0;
    uVar1 = 1 << (param_1 * 4 & 0xff);
    *(uint *)(DAT_a062aca0 + 0x30) = *(uint *)(DAT_a062aca0 + 0x30) & ~uVar1;
    if ((param_2 != (int *)0x0) && (*param_2 != 0)) {
      matched_FUN_a04f8d24(&DAT_a078b70c + param_1 * 7,param_2,0x10);
      if (param_1 == 7) {
        matched_FUN_a049755c(uVar2);
      }
      iVar6 = param_2[1];
      if ((iVar6 == 0) || (param_2[2] != 0)) {
        matched_FUN_a049755c(uVar2);
        iVar6 = param_2[1];
      }
      piVar5 = *(int **)(&DAT_a062aca4 + param_1 * 4);
      piVar5[1] = iVar7 * iVar6;
      *piVar5 = *param_2 * iVar7;
      *(uint *)(iVar3 + 0x30) = uVar1 | *(uint *)(iVar3 + 0x30);
      return 0;
    }
    uVar4 = 0;
    *(undefined4 *)(&DAT_a078b710 + param_1 * 0x1c) = 0;
    (&DAT_a078b70c)[param_1 * 7] = 0;
  }
  else {
    uVar4 = 0xffffffff;
  }
  return uVar4;
}

