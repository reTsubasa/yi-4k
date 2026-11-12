/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void sharepreview_enable(int *param_1,undefined4 *param_2)

{
  undefined4 uVar1;
  undefined4 *puVar2;
  undefined1 auStack_b8 [159];
  undefined1 local_19;
  
  matched_FUN_a04f93c4(auStack_b8,0xa0,s_Short_Line___d_a062fe68 + 0x10,0xc3);
  local_19 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_Enable_Svc_a05a83e8,auStack_b8);
  puVar2 = (undefined4 *)param_2[1];
  if (*param_1 == 0) {
    uVar1 = sharepreview_disable_internal();
  }
  else {
    uVar1 = sharepreview_enable_internal();
  }
  *puVar2 = uVar1;
  *param_2 = 4;
  param_2[3] = 0;
  param_2[2] = 0;
  matched_FUN_a04f93c4(auStack_b8,0xa0,s_Short_Line___d_a062fe68 + 0x10,0xd2);
  local_19 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_Enable_Svc_a05a83e8,auStack_b8);
  return;
}

