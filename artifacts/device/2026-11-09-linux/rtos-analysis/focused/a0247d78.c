/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 sharepreview_copy_and_reset_counter(undefined4 param_1)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  undefined1 auStack_b0 [159];
  undefined1 local_11;
  
  iVar1 = matched_FUN_a048e63c();
  uVar2 = sharepreview_update_buffer(param_1);
  iVar3 = matched_FUN_a048e63c();
  matched_FUN_a04f93c4(auStack_b0,0xa0,s_ApplibNetSharePreview_UpdateBuff_a05a8198,iVar3 - iVar1);
  local_11 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3084,s__AppLib___NetSharePreview__a05a8070,
               s__USB_HDLR__DEBUG__s____d__Ca_Dis_a05b7204 + 0x30,auStack_b0);
  DAT_a1443d1c = 0;
  return uVar2;
}

