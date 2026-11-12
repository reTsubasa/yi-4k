/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 FUN_a02c5fd8(undefined4 *param_1,uint param_2,undefined4 param_3)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  uint uVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  
  if (DAT_a1456be1 != '\0') {
    FUN_a02a70ec(s__s__s___d_a05c6bf8,DAT_a06f3084,s_AmbaDSP_LiveviewEisConfig_a05c7294,0x887);
  }
  iVar1 = DAT_a06f3380;
  puVar5 = DAT_a02c61d0;
  if (DAT_a1458328 == param_2) {
    puVar6 = &DAT_a06990e0;
  }
  else {
    if (param_2 == 0) {
      puVar6 = &DAT_a06990e0;
      *(undefined4 *)(DAT_a06f3380 + 0x58) = 0;
      *(undefined4 *)(iVar1 + 0x28) = 0;
      DAT_a0699160 = 0;
    }
    else {
      puVar6 = DAT_a02c61d0 + -0x20;
      uVar3 = rtos_virtual_to_physical();
      iVar2 = DAT_a06f3380;
      *(undefined4 *)(iVar1 + 0x58) = uVar3;
      DAT_a1457fd8 = 0;
      *(undefined4 *)(iVar2 + 0x28) = param_3;
      *puVar5 = 0;
    }
    DAT_a1458328 = (byte)param_2;
  }
  if (param_1 == (undefined4 *)0x0) {
    puVar6[0x20] = 0;
  }
  else {
    uVar4 = (uint)DAT_a1457fd8;
    puVar6[uVar4 * 0x10] = *param_1;
    puVar5 = puVar6 + uVar4 * 0x10;
    puVar5[1] = param_1[1];
    puVar5[2] = param_1[2];
    puVar5[3] = param_1[3];
    puVar5[8] = param_1[8];
    *(undefined2 *)((int)puVar5 + 0x1e) = *(undefined2 *)((int)param_1 + 0x1e);
    *(undefined2 *)(puVar5 + 7) = *(undefined2 *)(param_1 + 7);
    *(undefined2 *)(puVar5 + 6) = *(undefined2 *)(param_1 + 6);
    *(undefined2 *)((int)puVar5 + 0x1a) = *(undefined2 *)((int)param_1 + 0x1a);
    puVar5[4] = param_1[4];
    puVar5[5] = param_1[5];
    iVar1 = DAT_a06f340c;
    if (param_1[9] == 0) {
      puVar5[9] = 0;
    }
    else {
      *(undefined4 *)(DAT_a06f340c + 4) = param_1[9];
      *(undefined1 *)(iVar1 + 0x30) = *(undefined1 *)(param_1 + 10);
      *(undefined1 *)(iVar1 + 0x31) = *(undefined1 *)((int)param_1 + 0x29);
      *(undefined1 *)(iVar1 + 0x32) = *(undefined1 *)((int)param_1 + 0x2a);
      *(undefined1 *)(iVar1 + 0x33) = *(undefined1 *)((int)param_1 + 0x2b);
      uVar3 = rtos_virtual_to_physical(param_1[0xb]);
      iVar2 = DAT_a06f340c;
      *(undefined4 *)(iVar1 + 8) = uVar3;
      uVar3 = rtos_virtual_to_physical(param_1[0xc]);
      iVar1 = DAT_a06f340c;
      *(undefined4 *)(iVar2 + 0xc) = uVar3;
      *(undefined1 *)(iVar1 + 0x37) = *(undefined1 *)(param_1 + 0xd);
      *(undefined1 *)(iVar1 + 0x38) = *(undefined1 *)((int)param_1 + 0x35);
      uVar3 = rtos_virtual_to_physical(iVar1);
      puVar5[9] = uVar3;
    }
    uVar3 = rtos_virtual_to_physical(puVar5);
    puVar6[0x20] = uVar3;
    DAT_a1457fd8 = DAT_a1457fd8 + 1;
    if (1 < DAT_a1457fd8) {
      DAT_a1457fd8 = 0;
    }
  }
  return 0;
}

