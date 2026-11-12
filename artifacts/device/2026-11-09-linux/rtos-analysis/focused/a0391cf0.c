/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void eis_row_dependent_warp(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  int iVar5;
  int iVar6;
  uint uVar7;
  int iVar8;
  int iVar9;
  int local_2c;
  char local_26;
  char local_25;
  int local_24;
  int local_20;
  uint local_1c;
  uint local_18;
  uint local_14;
  uint local_10;
  int local_c;
  
  iVar3 = DAT_a1704650;
  iVar2 = DAT_a170464c;
  if (DAT_a0757ac8 < 2) {
    local_2c = (((DAT_a170ab28 + DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
                ((int)(DAT_a170ab20 + 1) >> 1)) - (uint)DAT_a1702c50) + (int)DAT_a17045e8;
  }
  else {
    local_2c = ((DAT_a170ab2c + DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
               ((int)(DAT_a170ab20 + 1) >> 1)) + (int)DAT_a17045e8;
  }
  uVar7 = (DAT_a1704304 - DAT_a170aea4) - DAT_a17040c0;
  if ((DAT_a1702c50 != 0) && (uVar7 <= DAT_a1702c50)) {
    uVar7 = uVar7 + DAT_a170aeec;
    local_20 = 0;
    DAT_a170aff0 = 0;
    for (local_10 = 1; local_14 = uVar7, local_10 < uVar7 + 1; local_10 = local_10 + 1) {
      local_18 = (local_10 - 1) + local_2c;
      if ((int)local_18 < 0) {
        local_18 = DAT_a1702f10 + local_18;
      }
      if (DAT_a1702f10 - 1U < local_18) {
        local_18 = local_18 - DAT_a1702f10;
      }
      if (local_10 == 1) {
        DAT_a170aeb0 = local_18;
      }
      if (local_10 == uVar7) {
        DAT_a170aeb4 = local_18;
      }
      local_20 = local_20 +
                 (*(int *)(&DAT_a1702d00 + local_18 * 4) -
                 *(int *)(&DAT_a1702d00 + (local_18 + 0x19b) * 4));
      if (local_20 < 0) {
        local_25 = -1;
        local_24 = -local_20;
      }
      else {
        local_25 = '\x01';
        local_24 = local_20;
      }
      DAT_a17042d8 = matched_FUN_a037bcd8(0,local_24,0x100);
      if (local_25 == -1) {
        DAT_a17042d8 = -DAT_a17042d8;
      }
      DAT_a17042d8 = (DAT_a0757a86 * DAT_a17042d8) / 100;
      (&DAT_a170aff0)[local_10] = DAT_a17042d8 << 8;
      if (DAT_a1704226 == -1) {
        uVar4 = matched_FUN_a0506690((&DAT_a170aff0)[local_10],DAT_a1704224);
        (&DAT_a170aff0)[local_10] = uVar4;
      }
      else {
        (&DAT_a170aff0)[local_10] = (int)(&DAT_a170aff0)[local_10] >> DAT_a1704226;
      }
    }
    while (local_14 = local_14 + 1, (int)local_14 < 100) {
      (&DAT_a170aff0)[local_14] = (&DAT_a170aff0)[uVar7];
    }
    if (DAT_a1702ccb == -1) {
      for (local_14 = 0; (int)local_14 < 100; local_14 = local_14 + 1) {
        (&DAT_a170aff0)[local_14] = -(&DAT_a170aff0)[local_14];
      }
    }
    local_20 = 0;
    DAT_a170b180 = 0;
    for (local_10 = 1; local_14 = uVar7, local_10 < uVar7 + 1; local_10 = local_10 + 1) {
      local_1c = (local_10 - 1) + local_2c;
      if ((int)local_1c < 0) {
        local_1c = DAT_a1702f10 + local_1c;
      }
      if (DAT_a1702f10 - 1U < local_1c) {
        local_1c = local_1c - DAT_a1702f10;
      }
      local_20 = local_20 +
                 (*(int *)(&DAT_a1702d00 + (local_1c + 0x89) * 4) -
                 *(int *)(&DAT_a1702d00 + (local_1c + 0x224) * 4));
      if (local_20 < 0) {
        local_26 = -1;
        local_24 = -local_20;
      }
      else {
        local_26 = '\x01';
        local_24 = local_20;
      }
      DAT_a17042dc = matched_FUN_a037bcd8(1,local_24,0x100);
      if (local_26 == -1) {
        DAT_a17042dc = -DAT_a17042dc;
      }
      DAT_a17042dc = (DAT_a0757a87 * DAT_a17042dc) / 100;
      (&DAT_a170b180)[local_10] = DAT_a17042dc << 8;
      if (DAT_a1704227 == -1) {
        uVar4 = matched_FUN_a0506690((&DAT_a170b180)[local_10],DAT_a1704225);
        (&DAT_a170b180)[local_10] = uVar4;
      }
      else {
        (&DAT_a170b180)[local_10] = (int)(&DAT_a170b180)[local_10] >> DAT_a1704227;
      }
    }
    while (local_14 = local_14 + 1, (int)local_14 < 100) {
      (&DAT_a170b180)[local_14] = (&DAT_a170b180)[uVar7];
    }
    if (DAT_a1702ccc == -1) {
      for (local_14 = 0; (int)local_14 < 100; local_14 = local_14 + 1) {
        (&DAT_a170b180)[local_14] = -(&DAT_a170b180)[local_14];
      }
    }
    iVar5 = matched_FUN_a0506418(DAT_a1704260,uVar7);
    iVar1 = 1 << (DAT_a1704658 & 0xff);
    DAT_a170ab84 = 0;
    for (local_10 = 1; (int)local_10 < iVar3; local_10 = local_10 + 1) {
      iVar8 = iVar1 * local_10 + 1;
      iVar6 = matched_FUN_a0506418(iVar8,iVar5);
      iVar9 = (&DAT_a170aff0)[iVar6];
      iVar6 = matched_FUN_a0506690
                        ((iVar8 - iVar5 * iVar6) * ((&DAT_a170aff0)[iVar6 + 1] - iVar9),iVar5);
      (&DAT_a170ab84)[local_10] = iVar6 + iVar9;
    }
    DAT_a170ad14 = 0;
    for (local_10 = 1; (int)local_10 < iVar3; local_10 = local_10 + 1) {
      iVar8 = iVar1 * local_10 + 1;
      iVar6 = matched_FUN_a0506418(iVar8,iVar5);
      iVar9 = (&DAT_a170b180)[iVar6];
      iVar6 = matched_FUN_a0506690
                        ((iVar8 - iVar5 * iVar6) * ((&DAT_a170b180)[iVar6 + 1] - iVar9),iVar5);
      (&DAT_a170ad14)[local_10] = iVar6 + iVar9;
    }
    DAT_a170ba2c = DAT_a17042a0 >> 8;
    if (DAT_a170ba2c < 0) {
      DAT_a170ba34 = DAT_a17042b0 + DAT_a17042c0;
      DAT_a170ba3c = DAT_a17042b8 + DAT_a17042c8 + DAT_a170ba2c;
    }
    else {
      DAT_a170ba34 = (DAT_a17042b0 + DAT_a17042c0) - DAT_a170ba2c;
      DAT_a170ba3c = DAT_a17042b8 + DAT_a17042c8;
    }
    for (local_10 = 1; (int)local_10 < iVar3; local_10 = local_10 + 1) {
      if (DAT_a170ba34 < (int)(&DAT_a170ab84)[local_10] >> 8) {
        (&DAT_a170ab84)[local_10] = DAT_a170ba34 << 8;
      }
      else if ((int)(&DAT_a170ab84)[local_10] >> 8 < -DAT_a170ba3c) {
        (&DAT_a170ab84)[local_10] = DAT_a170ba3c * -0x100;
      }
    }
    DAT_a170ba30 = DAT_a17042a4 >> 8;
    if (DAT_a170ba30 < 0) {
      DAT_a170ba38 = DAT_a17042b4 + DAT_a17042c4;
      DAT_a170ba40 = DAT_a17042bc + DAT_a17042cc + DAT_a170ba30;
    }
    else {
      DAT_a170ba38 = (DAT_a17042b4 + DAT_a17042c4) - DAT_a170ba30;
      DAT_a170ba40 = DAT_a17042bc + DAT_a17042cc;
    }
    for (local_10 = 1; (int)local_10 < iVar3; local_10 = local_10 + 1) {
      if (DAT_a170ba38 < (int)(&DAT_a170ad14)[local_10] >> 8) {
        (&DAT_a170ad14)[local_10] = DAT_a170ba38 << 8;
      }
      else if ((int)(&DAT_a170ad14)[local_10] >> 8 < -DAT_a170ba40) {
        (&DAT_a170ad14)[local_10] = DAT_a170ba40 * -0x100;
      }
    }
    for (local_c = 0; local_c < iVar3; local_c = local_c + 1) {
      for (local_10 = 0; (int)local_10 < iVar2; local_10 = local_10 + 1) {
        *(short *)(param_1 + (iVar2 * local_c + local_10) * 4) =
             *(short *)(param_1 + (iVar2 * local_c + local_10) * 4) +
             (short)((int)(&DAT_a170ab84)[local_c] >> 0xc) * (short)DAT_a0757ac4;
        *(short *)(param_1 + (iVar2 * local_c + local_10) * 4 + 2) =
             *(short *)(param_1 + (iVar2 * local_c + local_10) * 4 + 2) +
             (short)((int)(&DAT_a170ad14)[local_c] >> 0xc) * (short)DAT_a0757ac4;
        if (DAT_a170af29 != '\0') {
          *(undefined2 *)(param_1 + (iVar2 * local_c + local_10) * 4) = 0;
          *(undefined2 *)(param_1 + (iVar2 * local_c + local_10) * 4 + 2) = 0;
        }
      }
    }
  }
  return;
}

