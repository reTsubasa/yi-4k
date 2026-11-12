/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa02478f4, name: FUN_a02478f4.
 * Types and names may be inferred. Runtime validation not performed. */


void FUN_a02478f4(undefined4 param_1,undefined4 *param_2)

{
  uint uVar1;
  uint uVar2;
  uint *puVar3;
  undefined1 auStack_c0 [159];
  undefined1 local_21;
  
  FUN_a04f93c4(auStack_c0,0xa0,s_Short_Line___d_a062fe68 + 0x10,0xdb);
  uVar2 = 0;
  local_21 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_GetStatus_Svc_a05a808c,auStack_c0);
  puVar3 = (uint *)param_2[1];
  uVar1 = (uint)DAT_a1443d18;
  if (uVar1 != 1) {
    if (uVar1 == 0) goto LAB_a0247978;
    if (uVar1 != 2) {
      FUN_a04f93c4(auStack_c0,0xa0,s__d__unmapped_status__d_a05a809c,0xea,uVar1);
      local_21 = 0;
      FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                   s_GetStatus_Svc_a05a808c,auStack_c0);
      goto LAB_a0247978;
    }
  }
  uVar2 = uVar1;
LAB_a0247978:
  *puVar3 = uVar2;
  *param_2 = 4;
  param_2[3] = 0;
  param_2[2] = 0;
  FUN_a04f93c4(auStack_c0,0xa0,s_Short_Line___d_a062fe68 + 0x10,0xf3);
  local_21 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_GetStatus_Svc_a05a808c,auStack_c0);
  return;
}

