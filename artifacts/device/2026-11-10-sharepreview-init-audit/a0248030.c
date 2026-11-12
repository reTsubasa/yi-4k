/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0248030, name: matched_FUN_a0248030.
 * Types and names may be inferred. Runtime validation not performed. */


int matched_FUN_a0248030(void)

{
  int iVar1;
  undefined1 auStack_b0 [159];
  undefined1 local_11;
  
  iVar1 = matched_FUN_a0238394((undefined1)DAT_a1443d30,&LAB_a0247e04);
  if (iVar1 == 0) {
    DAT_a1443d18 = 1;
    return 0;
  }
  matched_FUN_a04f93c4(auStack_b0,0xa0,s_AppLibVideoAnal_FrmHdlr_UnRegist_a05a828c,iVar1);
  local_11 = 0;
  FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
               s_Disable_a053c5d0,auStack_b0);
  return iVar1;
}

