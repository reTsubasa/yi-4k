/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0247e54, name: FUN_a0247e54.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_a0247e54(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  undefined4 local_d0;
  undefined4 *local_cc;
  undefined1 auStack_c8 [159];
  undefined1 local_29;
  
  local_d0 = 0;
  local_cc = (undefined4 *)0x0;
  _DAT_a1443d40 = FUN_a03cd2d8(param_2);
  FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_AMOUNT__a05a81cc,0xff,4);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  local_d0 = 3;
  local_cc = (undefined4 *)FUN_a03cd2d8(0x18);
  FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_GETSHAR_a05a81f8,0x103,1);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  local_cc[1] = 0;
  *local_cc = FUN_a0247a20;
  FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_ENABLE__a05a8224,0x108,2);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  local_cc[2] = FUN_a024840c;
  local_cc[3] = 0;
  FUN_a04f93c4(auStack_c8,0xa0,s__d__RT_SHAREPREVIEW_FUNC_GETSTAT_a05a8248,0x10d,3);
  local_29 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s_SvcInit_a05a81f0,auStack_c8);
  uVar1 = _DAT_a1443d40;
  local_cc[4] = FUN_a02478f4;
  local_cc[5] = 0;
  FUN_a03caab4(0x1000000c,1,s_APPLIB_RPC_SVC_SHAREPREVIEW_a05a8270,param_1,uVar1,param_2,&local_d0,1
              );
  FUN_a03cd264(local_cc);
  return 0;
}

