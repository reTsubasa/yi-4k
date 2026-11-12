/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int sharepreview_enable_internal(void)

{
  int iVar1;
  char local_b0 [4];
  char acStack_ac [4];
  char acStack_a8 [4];
  char acStack_a4 [4];
  char local_a0 [4];
  char acStack_9c [4];
  char acStack_98 [4];
  char acStack_94 [4];
  undefined3 local_90;
  char cStack_8d;
  char acStack_8c [4];
  char acStack_88 [4];
  char acStack_84 [4];
  char local_80 [4];
  char acStack_7c [4];
  char acStack_78 [4];
  undefined2 local_74;
  char local_11;
  
  iVar1 = videoanal_is_initialized();
  if (iVar1 == 0) {
    local_b0[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0];
    local_b0[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[1];
    local_b0[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[2];
    local_b0[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[3];
    acStack_ac[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[4];
    acStack_ac[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[5];
    acStack_ac[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[6];
    acStack_ac[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[7];
    acStack_a8[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[8];
    acStack_a8[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[9];
    acStack_a8[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[10];
    acStack_a8[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xb];
    acStack_a4[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xc];
    acStack_a4[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xd];
    acStack_a4[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xe];
    acStack_a4[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0xf];
    local_a0[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x10];
    local_a0[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x11];
    local_a0[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x12];
    local_a0[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x13];
    acStack_9c[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x14];
    acStack_9c[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x15];
    acStack_9c[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x16];
    acStack_9c[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x17];
    acStack_98[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x18];
    acStack_98[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x19];
    acStack_98[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1a];
    acStack_98[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1b];
    acStack_94[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1c];
    acStack_94[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1d];
    acStack_94[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1e];
    acStack_94[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x1f];
    local_90._0_1_ = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x20];
    local_90._1_1_ = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x21];
    local_90._2_1_ = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x22];
    cStack_8d = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x23];
    acStack_8c[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x24];
    acStack_8c[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x25];
    acStack_8c[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x26];
    acStack_8c[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x27];
    acStack_88[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x28];
    acStack_88[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x29];
    acStack_88[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2a];
    acStack_88[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2b];
    acStack_84[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2c];
    acStack_84[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2d];
    acStack_84[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2e];
    acStack_84[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x2f];
    local_80[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x30];
    local_80[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x31];
    local_80[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x32];
    local_80[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x33];
    acStack_7c[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x34];
    acStack_7c[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x35];
    acStack_7c[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x36];
    acStack_7c[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x37];
    acStack_78[0] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x38];
    acStack_78[1] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x39];
    acStack_78[2] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x3a];
    acStack_78[3] = s_AppLibVideoAnal_FrmHdlr_is_not_i_a05a82bc[0x3b];
    local_74 = (undefined2)ram0xa05a82f8;
    local_11 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s_BPC_Page__d_not_Enable_a057d2f4 + 0x10,local_b0);
    iVar1 = -1;
  }
  else if (DAT_a1443d18 == '\0') {
    local_b0[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0];
    local_b0[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[1];
    local_b0[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[2];
    local_b0[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[3];
    acStack_ac[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[4];
    acStack_ac[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[5];
    acStack_ac[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[6];
    acStack_ac[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[7];
    acStack_a8[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[8];
    acStack_a8[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[9];
    acStack_a8[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[10];
    acStack_a8[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0xb];
    acStack_a4[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0xc];
    acStack_a4[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0xd];
    acStack_a4[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0xe];
    acStack_a4[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0xf];
    local_a0[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x10];
    local_a0[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x11];
    local_a0[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x12];
    local_a0[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x13];
    acStack_9c[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x14];
    acStack_9c[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x15];
    acStack_9c[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x16];
    acStack_9c[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x17];
    acStack_98[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x18];
    acStack_98[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x19];
    acStack_98[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x1a];
    acStack_98[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x1b];
    acStack_94[0] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x1c];
    acStack_94[1] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x1d];
    acStack_94[2] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x1e];
    acStack_94[3] = s_ApplibNet_SharePreview_is_not_in_a05a82fc[0x1f];
    local_90 = (undefined3)ram0xa05a831c;
    local_11 = DAT_a1443d18;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s_BPC_Page__d_not_Enable_a057d2f4 + 0x10,local_b0);
    iVar1 = -2;
  }
  else if (DAT_a1443d18 == '\x02') {
    matched_FUN_a04f93c4(local_b0,0xa0,s_ApplibNet_SharePreview_is_alread_a05a8320,2);
    local_11 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s_BPC_Page__d_not_Enable_a057d2f4 + 0x10,local_b0);
    iVar1 = -3;
  }
  else if (DAT_a1443d32 == 0) {
    matched_FUN_a04f93c4(local_b0,0xa0,s_Invalid_UpdatePeriod__u__a05a8350,0);
    local_11 = 0;
    FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                 s_BPC_Page__d_not_Enable_a057d2f4 + 0x10,local_b0);
    iVar1 = -4;
  }
  else {
    DAT_a1443d1c = 0;
    iVar1 = videoanal_register_callback((undefined1)DAT_a1443d30,sharepreview_frame_callback);
    if (iVar1 == 0) {
      DAT_a1443d18 = '\x02';
    }
    else {
      matched_FUN_a04f93c4(local_b0,0xa0,s_AppLibVideoAnal_FrmHdlr_Register_a05a836c,iVar1);
      local_11 = 0;
      FUN_a02a70ec(s__s_s_<_s>__s_a05a8060,DAT_a06f3080,s__AppLib___NetSharePreview__a05a8070,
                   s_BPC_Page__d_not_Enable_a057d2f4 + 0x10,local_b0);
    }
    FUN_a02a70ec(s_ApplibNetSharePreview_Enable_Ok_a05a8398);
  }
  return iVar1;
}

