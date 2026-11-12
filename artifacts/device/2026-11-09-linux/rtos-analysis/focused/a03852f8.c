/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void eis_per_frame(void)

{
  uint uVar1;
  byte bVar2;
  int iVar3;
  uint in_fpscr;
  undefined4 uVar4;
  undefined4 extraout_s1;
  double dVar5;
  undefined4 local_2c;
  undefined4 local_28;
  undefined4 local_24;
  undefined4 local_20;
  undefined4 uStack_1c;
  int local_14;
  int local_10;
  int local_c;
  
  local_c = 0;
  if ((DAT_a1702cbc != '\0') && (DAT_a170afba != '\0')) {
    if ((DAT_a170afb9 == '\0') && (DAT_a0757af8 != 0)) {
      FUN_a02a70ec(s_warning__1st_translation_Y_not_r_a05ffd68);
    }
    local_24 = 0;
    local_28 = 0;
    local_2c = 0x100;
    local_10 = matched_FUN_a048e3f8();
    local_14 = local_10 - DAT_a1704304;
    if (DAT_a17045d4 == '\0') {
      if ((DAT_a0757b0e == 0) && (DAT_a0757b34 == 0)) {
        if (DAT_a17045da != '\0') {
          matched_FUN_a037efa8();
        }
        eis_rotation_grid_coordinator();
      }
    }
    else {
      local_20 = 0x4ae74487;
      uStack_1c = 0x3fb65718;
      uVar1 = in_fpscr & 0xfffffff | (uint)(DAT_a0757aa4 < 0.0) << 0x1f |
              (uint)(DAT_a0757aa4 == 0.0) << 0x1e;
      bVar2 = (byte)(uVar1 >> 0x18);
      if ((bool)(bVar2 >> 6 & 1) || (bool)(bVar2 >> 7) != NAN(DAT_a0757aa4)) {
        if (DAT_a0757aa4 != DAT_a0385778) {
          DAT_a170b348 = ((double)DAT_a0757aa4 * DAT_a0385760) / DAT_a0385770;
        }
      }
      else {
        dVar5 = (double)VectorUnsignedToFloat(local_10,(byte)(uVar1 >> 0x16) & 3);
        uVar4 = matched_FUN_a0503dc8
                          (SUB84(((double)(DAT_a0757aa4 + DAT_a0757aa4) * DAT_a0385760 * dVar5) /
                                 DAT_a0385768,0));
        DAT_a170b348 = (double)CONCAT44(extraout_s1,uVar4) * (double)CONCAT44(uStack_1c,local_20);
      }
      if (DAT_a170b348 != (double)CONCAT44(DAT_a170b350._4_4_,(undefined4)DAT_a170b350)) {
        FUN_a02d9b88(SUB84(DAT_a170b348,0),&local_2c);
        FUN_a02da164(&local_2c,0);
      }
      DAT_a170b350._0_4_ = DAT_a170b348._0_4_;
      DAT_a170b350._4_4_ = DAT_a170b348._4_4_;
      matched_thunk_FUN_a0312460(&local_2c);
    }
    local_c = matched_FUN_a048e3f8();
    local_c = local_c - local_10;
    if ((((DAT_a170afba != '\0') && (DAT_a17045da != '\0')) && (DAT_a0757ab1 != 0)) &&
       (iVar3 = matched_FUN_a048e3f8(), (uint)DAT_a0757ab1 <= (uint)(iVar3 - DAT_a170ab5c))) {
      uVar4 = matched_FUN_a048e3f8();
      FUN_a02a70ec(s_Eis_Warp_calculation_not_in_time_a05ffda4,uVar4,DAT_a0757ab1);
    }
    if (DAT_a0757afa != 0) {
      if (DAT_a17045da == '\0') {
        FUN_a02a70ec(s_Do_EisPerFrame___d__d___d__d___4_a05ffe08,local_14,(int)DAT_a170422b,
                     (int)DAT_a1704228,local_c,DAT_a170441c >> 0x10,DAT_a1704420 >> 0x10);
      }
      else {
        FUN_a02a70ec(s_Do_EisPerFrame___d__d__d___d___4_a05ffdd8,(int)DAT_a1704228,local_14,
                     (int)DAT_a170422b,local_c,DAT_a170441c >> 0x10,DAT_a1704420 >> 0x10);
      }
    }
  }
  return;
}

