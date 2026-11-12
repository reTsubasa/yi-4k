/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_a02a70ec(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 uVar3;
  int iVar4;
  int iVar5;
  uint uVar6;
  int iVar7;
  undefined4 in_cr0;
  undefined4 *local_58 [2];
  undefined4 local_50;
  undefined2 local_4c;
  undefined1 local_4a;
  undefined1 local_49;
  undefined4 uStack_c;
  undefined4 uStack_8;
  undefined4 uStack_4;
  
  uStack_c = param_2;
  uStack_8 = param_3;
  uStack_4 = param_4;
  iVar2 = matched_FUN_a03bc46c(&DAT_a144b8e0,0xffffffff);
  if (iVar2 == 0) {
    if (((DAT_a144d998 != 0) || (DAT_a144d9a4 == 0)) || (DAT_a144b7c8 != 0)) {
      local_58[0] = DAT_a05b14d8;
      local_58[1] = (undefined4 *)DAT_a05b14dc;
      uVar6 = coproc_movefrom_Identification_registers(5,in_cr0);
      local_50 = DAT_a05b14f0;
      local_4c = CONCAT11(local_4c._1_1_,(char)DAT_a05b14f4);
      if (DAT_a144d9a0 == 0) {
        iVar2 = 6;
        iVar4 = 5;
        iVar5 = 4;
      }
      else {
        uVar3 = matched_FUN_a048e63c();
        iVar2 = matched_FUN_a04f93c4(&local_4c,0x28,s___08u__a05b14f8,uVar3);
        iVar5 = matched_FUN_a04f93c4
                          ((int)local_58 + iVar2 + 0xc,0x28,&DAT_a05b1500,local_58[uVar6 & 3]);
        iVar5 = iVar2 + 4 + iVar5;
        iVar4 = iVar5 + 1;
        iVar2 = iVar5 + 2;
      }
      iVar7 = 0;
      *(undefined1 *)((int)local_58 + iVar5 + 8) = 0x20;
      *(undefined1 *)((int)local_58 + iVar4 + 8) = 0;
      matched_FUN_a02a67e0(iVar2,&local_50);
      local_58[0] = &uStack_c;
      matched_FUN_a02a6898(param_1,local_58[0]);
      local_50 = DAT_a05b14f0;
      local_49 = 0;
      local_4c = (undefined2)ram0xa05a24f8;
      local_4a = (undefined1)((uint)ram0xa05a24f8 >> 0x10);
      matched_FUN_a02a67e0(6,&local_50);
      uVar1 = DAT_a144b988;
      uVar3 = DAT_a02a72a0;
      if (DAT_a144d994 != 0x7ff) {
        iVar7 = DAT_a144d994 + 1;
      }
      *(int *)(DAT_a02a729c + 0x1b4) = iVar7;
      (&DAT_a144b994)[iVar7] = uVar1;
      matched_FUN_a03bc4e8(uVar3,1);
    }
    matched_thunk_FUN_a03c3c5c(DAT_a02a72a4);
    uVar3 = 0;
  }
  else {
    uVar3 = 0xffffffff;
  }
  return uVar3;
}

