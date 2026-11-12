/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void print_flush_log_buffer(int *param_1,uint *param_2,int param_3,undefined4 param_4)

{
  uint uVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  uint uVar5;
  code *pcVar6;
  uint uVar7;
  int iVar8;
  bool bVar9;
  
  uVar1 = param_2[4];
  uVar3 = param_2[2];
LAB_a02a6534:
  do {
    bVar9 = uVar3 == uVar1;
    uVar1 = uVar3;
    if (bVar9) {
      return;
    }
    while ((param_1[0x12] != 0 && (*param_1 != 0))) {
      iVar2 = matched_FUN_a048e63c();
      if ((param_3 == 0) || ((uint)param_1[0x14] <= (uint)(iVar2 - param_1[0x10]))) {
        param_1[0x10] = iVar2;
        uVar1 = param_2[2];
        uVar3 = param_2[4];
        iVar8 = param_1[0x11];
        uVar5 = param_1[0x13];
        uVar7 = param_1[0x16];
        iVar2 = param_1[0x17];
        if (uVar1 <= uVar3) {
          uVar1 = *param_2;
        }
        iVar4 = uVar1 - uVar3;
        uVar1 = iVar4 + iVar8;
        if (uVar5 < (uint)(iVar4 + iVar8)) {
          iVar4 = uVar5 - iVar8;
          uVar1 = uVar5;
        }
        bVar9 = iVar2 == 0;
        pcVar6 = (code *)param_1[1];
        if (iVar2 == 0) {
          bVar9 = uVar7 <= uVar1;
        }
        if (bVar9 && (iVar2 != 0 || uVar1 != uVar7)) {
          iVar4 = uVar7 - iVar8;
        }
        if (iVar4 != 0 && pcVar6 != (code *)0x0) {
          iVar2 = (*pcVar6)(param_2[1] + uVar3,iVar4,*param_1,pcVar6,param_4);
          if (0 < iVar2) {
            param_1[0x11] = param_1[0x11] + iVar2;
            uVar1 = iVar2 + param_2[4];
            param_2[4] = uVar1;
            uVar3 = param_2[2];
            if (*param_2 <= uVar1) {
              uVar1 = 0;
              param_2[4] = 0;
            }
            goto LAB_a02a6534;
          }
          if (iVar2 != 0) goto LAB_a02a6574;
        }
        if ((code *)param_1[2] != (code *)0x0) {
          (*(code *)param_1[2])(*param_1);
          *param_1 = 0;
          param_1[2] = 0;
          param_1[1] = 0;
          param_1[0x12] = 0;
        }
      }
LAB_a02a6574:
      uVar1 = param_2[2];
      if (uVar1 == param_2[4]) {
        return;
      }
    }
    param_2[4] = uVar1;
    uVar3 = uVar1;
  } while( true );
}

