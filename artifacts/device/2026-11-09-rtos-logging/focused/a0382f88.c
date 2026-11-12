/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Removing unreachable block (ram,0xa0383110) */
/* WARNING: Removing unreachable block (ram,0xa0383124) */
/* WARNING: Removing unreachable block (ram,0xa0383138) */
/* WARNING: Removing unreachable block (ram,0xa0383158) */

undefined4 eis_enable(void)

{
  undefined4 local_c;
  
  local_c = 0;
  FUN_a02a70ec(s_____AmbaImgEisCtrl_Enable_starts_a05ffa84);
  FUN_a02a70ec(s_EisObj_Enable__d_a05ffaac,DAT_a1704044);
  FUN_a02a70ec(s_EisObj_EnableCmd__d_a05ffac0,DAT_a170404b);
  DAT_a1704049 = '\x02';
  FUN_a02a70ec(s_EisObj_StabilizerType__d_a05ffad4,2);
  FUN_a02a70ec(s_EisObj_MeEnable__d_a05ffaf0,DAT_a1704048);
  matched_FUN_a04f8dec(&DAT_a1704310,0,0x38);
  DAT_a170afba = 0;
  DAT_a170afb9 = 0;
  DAT_a170afb8 = 0;
  DAT_a1702cbb = 0;
  DAT_a1702cba = 0;
  DAT_a1702cb9 = 0;
  if (DAT_a1704044 == '\0') {
    if (DAT_a170404b == '\0') {
      DAT_a17045a4 = 0;
      FUN_a02a70ec(s_FlgEisDzEffect__d_a05ffb04,DAT_a0757a5c);
      FUN_a02a70ec(s_________AmbaImageMainEis_SetRang_a05ffb18);
      matched_FUN_a037f3d0(1);
    }
    if (DAT_a1704049 == '\x02') {
      if (DAT_a170404b == '\0') {
        DAT_a170404b = '\x01';
        DAT_a1704234 = 5;
        DAT_a1704238 = 5;
        DAT_a170423c = 0;
        if (DAT_a1704048 == '\0') {
          matched_FUN_a037e218();
        }
      }
      FUN_a02a70ec(s_EisEnableDlyCnt__d_a05ffb44,DAT_a1702cac);
      if (DAT_a1702cac == 0) {
        DAT_a1704234 = 10;
        DAT_a1704238 = 10;
        DAT_a17042f0 = 1;
        DAT_a1704044 = '\x01';
        FUN_a02a70ec(s_____AmbaImageMainEis_RangeUpdate_a05ffb58);
        matched_FUN_a03812e0();
        DAT_a17042f2 = 1;
        DAT_a1704045 = 1;
        DAT_a17042f3 = 1;
        DAT_a1704046 = 1;
        DAT_a1704047 = 1;
        DAT_a170404b = '\0';
      }
      else {
        FUN_a02a70ec(s_EisObj_EnablePref__d_a05ffb84,DAT_a170404e);
        FUN_a02a70ec(s_EisObj_RscEnablePref__d_a05ffb9c,DAT_a170404f);
        if ((DAT_a170404e == '\0') && (DAT_a170404f == '\0')) {
          DAT_a170404e = '\x01';
          DAT_a170404f = '\x01';
        }
      }
    }
  }
  else {
    local_c = 0xffffffff;
  }
  FUN_a02a70ec(s_____AmbaImgEisCtrl_Enable_finish_a05ffbb4);
  return local_c;
}

