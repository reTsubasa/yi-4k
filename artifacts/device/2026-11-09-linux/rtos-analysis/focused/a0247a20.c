/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void sharepreview_get_meminfo(undefined4 param_1,undefined4 *param_2)

{
  undefined4 uVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  undefined1 auStack_b8 [159];
  undefined1 local_19;
  
  matched_FUN_a04f93c4(auStack_b8,0xa0,s_Short_Line___d_a062fe68 + 0x10,0xa3);
  local_19 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_GetMemInfo_Svc_a05a80b4,auStack_b8);
  puVar4 = (undefined4 *)param_2[1];
  if (DAT_a1443d18 == '\0') {
    matched_FUN_a04f8dec(puVar4,0,0x18);
  }
  else {
    *puVar4 = DAT_a1443d44;
    uVar2 = rtos_virtual_to_physical();
    uVar1 = DAT_a1443d3c;
    uVar3 = DAT_a1443d38;
    puVar4[1] = uVar2;
    puVar4[2] = uVar1;
    puVar4[3] = uVar3;
    uVar3 = rtos_virtual_to_physical(uVar3);
    puVar4[4] = uVar3;
    puVar4[5] = DAT_a1443d48;
    FUN_a02a70ec(s__ShareInfo_VirAddr__0x_x_a05a80c4,*puVar4);
    FUN_a02a70ec(s__ShareInfo_PhyAddr__0x_x_a05a80e4,puVar4[1]);
    FUN_a02a70ec(s__ReaderInfo_VirAddr__0x_x_a05a8104,puVar4[3]);
    FUN_a02a70ec(s__ReaderInfo_PhyAddr__0x_x_a05a8124,puVar4[4]);
  }
  *param_2 = 0x18;
  param_2[3] = 0;
  param_2[2] = 0;
  matched_FUN_a04f93c4(auStack_b8,0xa0,s_Short_Line___d_a062fe68 + 0x10,0xba);
  local_19 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_GetMemInfo_Svc_a05a80b4,auStack_b8);
  return;
}

