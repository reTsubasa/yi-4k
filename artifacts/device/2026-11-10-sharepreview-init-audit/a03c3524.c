/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03c3524, name: matched_FUN_a03c3524.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4
matched_FUN_a03c3524
          (undefined4 *param_1,undefined4 param_2,undefined4 *param_3,uint param_4,int param_5)

{
  undefined *puVar1;
  int iVar2;
  uint uVar3;
  int *piVar4;
  undefined4 unaff_r4;
  undefined4 unaff_r5;
  undefined4 unaff_r6;
  undefined4 *puVar5;
  undefined4 unaff_r7;
  undefined4 unaff_lr;
  bool bVar6;
  
  if (param_1 != (undefined4 *)0x0 && param_5 == 0x34) {
    matched_FUN_a03c13b0();
    DAT_a1796780 = DAT_a1796780 + 1;
    matched_FUN_a03c1428();
    iVar2 = 0;
    puVar5 = DAT_a17962d4;
    if (DAT_a17962b4 != 0) {
      do {
        if (param_1 == puVar5) {
          matched_FUN_a03c13b0();
          DAT_a1796780 = DAT_a1796780 + -1;
          matched_FUN_a03c1428();
          matched_FUN_a03c16e4();
          return 2;
        }
        iVar2 = iVar2 + 1;
        puVar5 = (undefined4 *)puVar5[0xb];
      } while (iVar2 != DAT_a17962b4);
    }
    matched_FUN_a03c13b0();
    DAT_a1796780 = DAT_a1796780 + -1;
    matched_FUN_a03c1428();
    matched_FUN_a03c16e4();
    if (param_1 != puVar5) {
      if (param_3 == (undefined4 *)0x0) {
        return 3;
      }
      if (param_4 < 100) {
        return 5;
      }
      puVar1 = (undefined *)matched_FUN_a03c0d4c();
      if ((puVar1 == &DAT_a1796c34) ||
         ((iVar2 = matched_FUN_a03c0d08(), iVar2 != 0 &&
          (uVar3 = matched_FUN_a03c0d08(), uVar3 < 0xf0f0f0f0)))) {
        return 0x13;
      }
      matched_FUN_a04f8dec
                (param_1,0,0x34,param_4,param_4,unaff_r4,unaff_r5,unaff_r6,unaff_r7,unaff_lr);
      param_4 = param_4 & 0xfffffffc;
      param_1[7] = param_4;
      param_1[1] = param_2;
      param_1[6] = param_3;
      param_1[4] = param_3;
      param_1[5] = param_3;
      param_1[2] = param_4 - 8;
      param_1[3] = 2;
      *(undefined4 **)((int)param_3 + (param_4 - 4)) = param_1;
      piVar4 = (int *)((int)param_3 + (param_4 - 8));
      *piVar4 = (int)param_3;
      param_3[1] = 0xffffeeee;
      *param_3 = piVar4;
      param_1[8] = 0;
      matched_FUN_a03c13b0();
      *param_1 = 0x42595445;
      puVar5 = DAT_a17962d4;
      bVar6 = DAT_a17962b4 == 0;
      DAT_a17962b4 = DAT_a17962b4 + 1;
      if (bVar6) {
        param_1[0xb] = param_1;
        param_1[0xc] = param_1;
        DAT_a17962d4 = param_1;
      }
      else {
        iVar2 = DAT_a17962d4[0xc];
        DAT_a17962d4[0xc] = param_1;
        *(undefined4 **)(iVar2 + 0x2c) = param_1;
        param_1[0xc] = iVar2;
        param_1[0xb] = puVar5;
      }
      matched_FUN_a03c1428();
      return 0;
    }
  }
  return 2;
}

