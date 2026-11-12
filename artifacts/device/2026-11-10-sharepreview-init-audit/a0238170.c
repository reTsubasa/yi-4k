/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0238170, name: matched_FUN_a0238170.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4 matched_FUN_a0238170(void)

{
  int iVar1;
  undefined4 uVar2;
  
  if (DAT_a14307b8 == '\0') {
    matched_FUN_a04f8dec(&DAT_a143074c,0,0x6c);
    FUN_a02a70ec(s__AppLib___VideoAnal__<FrmHdlr_In_a05a1024);
    iVar1 = matched_FUN_a03bc534(&DAT_a14308c8,&DAT_a1430904,0x24,4);
    if (iVar1 == 0) {
      FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a1058,DAT_a06f3084);
      iVar1 = matched_FUN_a03bc458(&DAT_a1430894);
      if (iVar1 == 0) {
        FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a10d4,DAT_a06f3084);
        FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a1110,DAT_a06f3084,0x88,0x8000);
        iVar1 = matched_analyst_task_create
                          (&DAT_a14307bc,s_VA_frame_hdlr_a05a115c,0x88,matched_FUN_a023809c,0,
                           &DAT_a1430a14,0x8000,1);
        if (iVar1 == 0) {
          FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a11ac,DAT_a06f3084);
          DAT_a14307b8 = '\x01';
          matched_thunk_FUN_a01e656c(0xb0010001,0,0);
          FUN_a02a70ec(s__AppLib___VideoAnal__<FrmHdlr_In_a05a11e8);
          uVar2 = 0;
        }
        else {
          FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a121c,DAT_a06f3080,iVar1);
          uVar2 = 0xffffffff;
        }
      }
      else {
        FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a116c,DAT_a06f3080,iVar1);
        uVar2 = 0xffffffff;
      }
    }
    else {
      FUN_a02a70ec(s__s_AppLib___VideoAnal__<FrmHdlr__a05a1094,DAT_a06f3080);
      uVar2 = 0xffffffff;
    }
  }
  else {
    uVar2 = 0xffffffff;
  }
  return uVar2;
}

