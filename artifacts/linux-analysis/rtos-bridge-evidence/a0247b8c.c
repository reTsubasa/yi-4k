/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0247b8c, name: FUN_a0247b8c.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_a0247b8c(int param_1)

{
  int iVar1;
  int iVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  undefined4 uVar6;
  undefined1 *puVar7;
  undefined1 auStack_c8 [159];
  undefined1 local_29;
  
  if (param_1 == 0) {
    FUN_a04f93c4(auStack_c8,0xa0,s_invalid_img__p__a05a8144,0);
    local_29 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s_UpdateBuffer_a05a8154,auStack_c8);
    return 0xffffffff;
  }
  FUN_a04987f0(_DAT_a1443d38,8);
  iVar2 = *(int *)(_DAT_a1443d38 + 4);
  iVar5 = *(int *)(_DAT_a1443d44 + 4) + 1;
  if (iVar5 < 4) {
    if (iVar2 != iVar5) {
      iVar2 = *(int *)(_DAT_a1443d44 + 4);
      goto LAB_a0247be4;
    }
    iVar5 = iVar2 + 1;
    if (iVar5 != 4) goto LAB_a0247be4;
  }
  else if (iVar2 == 1) {
    iVar5 = 2;
    goto LAB_a0247be4;
  }
  iVar5 = 1;
  iVar2 = 0;
LAB_a0247be4:
  FUN_a02a70ec(s_active___u__reading___u_a05a8164);
  iVar3 = _DAT_a1443d44;
  puVar7 = auStack_c8;
  iVar4 = (uint)*(ushort *)(param_1 + 0x14) * (uint)*(ushort *)(param_1 + 0x10);
  uVar6 = *(undefined4 *)(_DAT_a1443d44 + iVar2 * 4 + 0x2c);
  FUN_a04f93c4(puVar7,0xa0,s_size_y___u__write_to__p__d__a05a817c,iVar4,uVar6,iVar5,puVar7);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_UpdateBuffer_a05a8154,puVar7);
  FUN_a049878c(*(undefined4 *)(param_1 + 4),iVar4);
  FUN_a029c680(uVar6,*(undefined4 *)(param_1 + 4),iVar4);
  FUN_a0498728(uVar6,iVar4);
  iVar1 = _DAT_a1443d44;
  iVar3 = iVar3 + iVar2 * 0xc;
  *(int *)(iVar3 + 0x10) = iVar4;
  *(undefined2 *)(iVar3 + 8) = *(undefined2 *)(param_1 + 0x10);
  *(undefined2 *)(iVar3 + 10) = *(undefined2 *)(param_1 + 0x12);
  *(undefined2 *)(iVar3 + 0xc) = *(undefined2 *)(param_1 + 0x14);
  *(int *)(iVar1 + 4) = iVar5;
  FUN_a0498728(iVar1,0x38);
  return 0;
}

