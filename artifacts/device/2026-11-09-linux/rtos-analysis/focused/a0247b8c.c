/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 sharepreview_update_buffer(int param_1)

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
    matched_FUN_a04f93c4(auStack_c8,0xa0,s_invalid_img__p__a05a8144,0);
    local_29 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s_UpdateBuffer_a05a8154,auStack_c8);
    return 0xffffffff;
  }
  matched_analyst_dcache_flush(DAT_a1443d38,8);
  iVar2 = *(int *)(DAT_a1443d38 + 4);
  iVar5 = *(int *)(DAT_a1443d44 + 4) + 1;
  if (iVar5 < 4) {
    if (iVar2 != iVar5) {
      iVar2 = *(int *)(DAT_a1443d44 + 4);
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
  iVar3 = DAT_a1443d44;
  puVar7 = auStack_c8;
  iVar4 = (uint)*(ushort *)(param_1 + 0x14) * (uint)*(ushort *)(param_1 + 0x10);
  uVar6 = *(undefined4 *)(DAT_a1443d44 + iVar2 * 4 + 0x2c);
  matched_FUN_a04f93c4(puVar7,0xa0,s_size_y___u__write_to__p__d__a05a817c,iVar4,uVar6,iVar5,puVar7);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_UpdateBuffer_a05a8154,puVar7);
  matched_analyst_dcache_invalidate(*(undefined4 *)(param_1 + 4),iVar4);
  matched_FUN_a029c680(uVar6,*(undefined4 *)(param_1 + 4),iVar4);
  matched_analyst_dcache_clean(uVar6,iVar4);
  iVar1 = DAT_a1443d44;
  iVar3 = iVar3 + iVar2 * 0xc;
  *(int *)(iVar3 + 0x10) = iVar4;
  *(undefined2 *)(iVar3 + 8) = *(undefined2 *)(param_1 + 0x10);
  *(undefined2 *)(iVar3 + 10) = *(undefined2 *)(param_1 + 0x12);
  *(undefined2 *)(iVar3 + 0xc) = *(undefined2 *)(param_1 + 0x14);
  *(int *)(iVar1 + 4) = iVar5;
  matched_analyst_dcache_clean(iVar1,0x38);
  return 0;
}

