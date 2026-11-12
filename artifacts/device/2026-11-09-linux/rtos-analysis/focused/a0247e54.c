/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 sharepreview_register(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  undefined4 local_d0;
  undefined4 *local_cc;
  undefined1 auStack_c8 [159];
  undefined1 local_29;
  
  local_d0 = 0;
  local_cc = (undefined4 *)0x0;
  DAT_a1443d40 = matched_FUN_a03cd2d8(param_2);
  matched_FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_AMOUNT__a05a81cc,0xff,4);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  local_d0 = 3;
  local_cc = (undefined4 *)matched_FUN_a03cd2d8(0x18);
  matched_FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_GETSHAR_a05a81f8,0x103,1);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  local_cc[1] = 0;
  *local_cc = sharepreview_get_meminfo;
  matched_FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_ENABLE__a05a8224,0x108,2);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  local_cc[2] = sharepreview_enable;
  local_cc[3] = 0;
  matched_FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_GETSTAT_a05a8248,0x10d,3);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  uVar1 = DAT_a1443d40;
  local_cc[4] = sharepreview_get_status;
  local_cc[5] = 0;
  matched_FUN_a03caab4
            (0x1000000c,1,s_APPLIB_RPC_SVC_SHAREPREVIEW_a05a8270,param_1,uVar1,param_2,&local_d0,1);
  matched_FUN_a03cd264(local_cc);
  return 0;
}

