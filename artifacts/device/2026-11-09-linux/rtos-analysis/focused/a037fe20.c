/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 eis_mode_rowtime_init(void)

{
  char cVar1;
  uint uVar2;
  uint in_fpscr;
  int iVar3;
  undefined4 uVar4;
  double dVar5;
  double dVar6;
  undefined1 auStack_f8 [194];
  undefined2 local_36;
  undefined4 local_34;
  undefined4 local_30;
  undefined4 local_2c;
  byte local_25;
  undefined4 local_24;
  char local_1d;
  int local_1c;
  undefined4 local_18;
  int local_14;
  uint local_10;
  uint local_c;
  
  local_18 = 0;
  local_2c = 0;
  local_30 = 0;
  local_34 = 0x100;
  local_36 = 4;
  matched_FUN_a04f8dec(auStack_f8,0,0xc0);
  FUN_a02a70ec(s_____AmbaImgEisCtrl_ModeInit_star_a05ff18c);
  if (*(int *)((&DAT_a1a30f20)[(byte)local_36 & 3] + 0x20) != 0) {
    (**(code **)((&DAT_a1a30f20)[(byte)local_36 & 3] + 0x20))(local_36,&DAT_a1704050);
  }
  FUN_a02da030(&local_34,&DAT_a1704564);
  if (*(int *)((&DAT_a1a30f20)[(byte)local_36 & 3] + 0x18) != 0) {
    (**(code **)((&DAT_a1a30f20)[(byte)local_36 & 3] + 0x18))(local_36,&DAT_a1704128);
  }
  warp_get(&local_34,auStack_f8);
  FUN_a02da0e8(&local_34,&DAT_a1704400);
  iVar3 = VectorFloatToUnsigned(DAT_a1704050 * DAT_a0380190,3);
  DAT_a17040a8 = iVar3 << 8;
  iVar3 = VectorFloatToUnsigned(DAT_a1704054 * DAT_a0380190,3);
  DAT_a17040ac = iVar3 << 8;
  if (DAT_a0757a70 < DAT_a0757a74) {
    DAT_a0757a70 = DAT_a0757a74;
  }
  dVar6 = (double)VectorUnsignedToFloat(DAT_a170418c,(byte)(in_fpscr >> 0x16) & 3);
  dVar5 = (double)VectorUnsignedToFloat
                            ((DAT_a1704188 + 1) * DAT_a1704190,(byte)(in_fpscr >> 0x16) & 3);
  DAT_a17040b4 = VectorFloatToUnsigned(dVar6 / dVar5 + DAT_a0380188,3);
  cVar1 = matched_FUN_a0506418(1000,DAT_a17040b4);
  DAT_a1702c50 = cVar1 + 1;
  FUN_a02a70ec(s_FrameRatePerSec__d_a05ff1b4,DAT_a17040b4);
  FUN_a02a70ec(s_CurrFrameTime__d_a05ff1c8,DAT_a1702c50);
  DAT_a17040b8 = DAT_a170459c;
  DAT_a17040bc = DAT_a17045a0;
  if (DAT_a170415a == DAT_a170415d) {
    local_c = (uint)DAT_a170415a;
    local_10 = (uint)CONCAT11(DAT_a1704159,DAT_a170415c);
  }
  else {
    local_c = (uint)DAT_a170415d * (uint)DAT_a170415a;
    local_10 = (uint)DAT_a170415d * (uint)DAT_a1704159 * 0x100 |
               (uint)DAT_a170415a * (uint)DAT_a170415c;
  }
  FUN_a02a70ec(s_SamplingScale____d__SamplingRati_a05ff1dc,local_c,local_10);
  DAT_a1704220 = local_c << 0x10 | local_10;
  DAT_a1704224 = matched_FUN_a0506418(DAT_a170415a,DAT_a1704159);
  DAT_a1704225 = matched_FUN_a0506418(DAT_a170415d,DAT_a170415c);
  DAT_a1704298 = ((uint)DAT_a1704224 * DAT_a17040a8) / 100;
  DAT_a170429c = ((uint)DAT_a1704225 * DAT_a17040ac) / 100;
  if (DAT_a1702cc0 != '\0') {
    iVar3 = VectorFloatToUnsigned(DAT_a1704140 * DAT_a03801b4,3);
    DAT_a17040c0 = (iVar3 * (DAT_a1704134 - DAT_a170440c) + 500000U) / 1000000;
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_FrameLe_a05ff204,DAT_a1704134);
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_OutputI_a05ff234,DAT_a1704170);
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_InputIn_a05ff268,DAT_a1704156);
    uVar4 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a03801b4) + 0.5,3);
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_RowTime_a05ff2a8,uVar4);
    FUN_a02a70ec(s_VerticalBlankTime__d_a05ff2e0,DAT_a17040c0);
    if (DAT_a1702cb8 == '\0') {
      DAT_a1702cb8 = '\x01';
      local_1c = matched_FUN_a0506690(1000,DAT_a0757a90);
      local_1c = local_1c << 2;
      FUN_a02a70ec(s_____MemAllocate_______a05ff2f8);
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + local_14 * 4) = 0;
      }
      DAT_a1702f10 = local_1c;
      DAT_a1702f14 = 0;
      DAT_a1702f18 = 0;
      DAT_a1702f1c = 0;
      DAT_a1702f20 = 0;
      if (DAT_a0380194 == 0) {
        FUN_a02a70ec(s__________Chan_1__Memory_create_f_a05ff33c);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x89) * 4) = 0;
      }
      DAT_a1703134 = local_1c;
      DAT_a1703138 = 0;
      DAT_a170313c = 0;
      DAT_a1703140 = 0;
      DAT_a1703144 = 0;
      if (DAT_a0380198 == 0) {
        FUN_a02a70ec(s__________Chan_2__Memory_create_f_a05ff368);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x112) * 4) = 0;
      }
      DAT_a1703358 = local_1c;
      DAT_a170335c = 0;
      DAT_a1703360 = 0;
      DAT_a1703364 = 0;
      DAT_a1703368 = 0;
      if (DAT_a038019c == 0) {
        FUN_a02a70ec(s__________Chan_3__Memory_create_f_a05ff394);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x19b) * 4) = 0;
      }
      DAT_a170357c = local_1c;
      DAT_a1703580 = 0;
      DAT_a1703584 = 0;
      DAT_a1703588 = 0;
      DAT_a170358c = 0;
      if (DAT_a03801a0 == 0) {
        FUN_a02a70ec(s__________Chan_4__Memory_create_f_a05ff3c0);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x224) * 4) = 0;
      }
      DAT_a17037a0 = local_1c;
      DAT_a17037a4 = 0;
      DAT_a17037a8 = 0;
      DAT_a17037ac = 0;
      DAT_a17037b0 = 0;
      if (DAT_a03801a4 == 0) {
        FUN_a02a70ec(s__________Chan_5__Memory_create_f_a05ff3ec);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x2ad) * 4) = 0;
      }
      DAT_a17039c4 = local_1c;
      DAT_a17039c8 = 0;
      DAT_a17039cc = 0;
      DAT_a17039d0 = 0;
      DAT_a17039d4 = 0;
      if (DAT_a03801a8 == 0) {
        FUN_a02a70ec(s__________Chan_6__Memory_create_f_a05ff418);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x336) * 4) = 0;
      }
      DAT_a1703be8 = local_1c;
      DAT_a1703bec = 0;
      DAT_a1703bf0 = 0;
      DAT_a1703bf4 = 0;
      DAT_a1703bf8 = 0;
      if (DAT_a03801ac == 0) {
        FUN_a02a70ec(s__________Chan_7__Memory_create_f_a05ff444);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x3bf) * 4) = 0;
      }
      DAT_a1703e0c = local_1c;
      DAT_a1703e10 = 0;
      DAT_a1703e14 = 0;
      DAT_a1703e18 = 0;
      DAT_a1703e1c = 0;
      if (DAT_a03801b0 == 0) {
        FUN_a02a70ec(s__________Chan_8__Memory_create_f_a05ff470);
        return 0xffffffff;
      }
      for (local_14 = 0; local_14 < 0x84; local_14 = local_14 + 1) {
        *(undefined4 *)(&DAT_a1702d00 + (local_14 + 0x448) * 4) = 0;
      }
      DAT_a1704030 = local_1c;
      DAT_a1704034 = 0;
      DAT_a1704038 = 0;
      DAT_a170403c = 0;
      DAT_a1704040 = 0;
      FUN_a02a70ec(s_____AmbaImageMainEis_GyroLogInit_a05ff49c);
      matched_FUN_a0394ba0();
      FUN_a02a70ec(s_____AmbaImageMainEis_GyroLogInit_a05ff4c8);
      matched_FUN_a037f55c();
      matched_FUN_a037f8bc();
      DAT_a170336c = DAT_a17040f8;
      DAT_a1703590 = DAT_a1704100;
      DAT_a17037b4 = DAT_a1704108;
    }
    DAT_a1702c94 = matched_FUN_a0506418
                             ((uint)DAT_a1702c50 * DAT_a0757a54 * DAT_a1702ca4,DAT_a1704298);
    FUN_a02a70ec(s_EisMv_MaxAngX__d_a05fe980,DAT_a1702ca4);
    FUN_a02a70ec(s_EisMv_MaxPixX__d_a05ff4f4,DAT_a1702c94);
    DAT_a1702c94 = DAT_a1702c94 >> 8;
    DAT_a1702c98 = matched_FUN_a0506418
                             ((uint)DAT_a1702c50 * DAT_a0757a54 * DAT_a1702ca8,DAT_a170429c);
    FUN_a02a70ec(s_EisMv_MaxAngY__d_a05fe994,DAT_a1702ca8);
    FUN_a02a70ec(s_EisMv_MaxPixY__d_a05ff508,DAT_a1702c98);
    DAT_a1702c98 = DAT_a1702c98 >> 8;
    DAT_a17045c4 = 0;
    FUN_a02a70ec(s_pCalcWinInfo_VinSensorGeo_StartY_a05ff51c,DAT_a1704404);
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_InputIn_a05ff540,(int)DAT_a1704152);
    iVar3 = VectorFloatToUnsigned(DAT_a1704140 * DAT_a0380fc8,3);
    DAT_a17045ac = (char)((iVar3 * (DAT_a1704134 - DAT_a170440c) + 500000U) / 1000000) - 2;
    if (DAT_a17045da != '\0') {
      DAT_a17045ac = 0;
    }
    if (DAT_a17045ad == 0) {
      if ((char)DAT_a17045ac < '\0') {
        DAT_a17045ac = 0;
      }
      else if (DAT_a17040c0 < 3) {
        DAT_a17045ac = 0;
      }
    }
    else {
      DAT_a17045ac = DAT_a17045ad & 0x7f;
    }
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_FrameLe_a05ff204,DAT_a1704134);
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_OutputI_a05ff580,DAT_a170417a);
    FUN_a02a70ec(s_EisSensorStatus_ModeInfo_OutputI_a05ff234,DAT_a1704170);
    FUN_a02a70ec(s_VinSensorGeo__Width__d__Height___a05ff5c0,DAT_a1704408,DAT_a170440c,DAT_a1704400,
                 DAT_a1704404);
    FUN_a02a70ec(s_CapStartY__d_a05ff5f8,DAT_a17045c4);
    FUN_a02a70ec(s__sDlyMs__d_a05ff608,DAT_a06f3090,(int)(char)DAT_a17045ac);
    if (DAT_a17045ac == 0) {
      DAT_a170422a = 0xfe;
    }
    else {
      DAT_a170422a = DAT_a17045ac;
    }
    DAT_a1704258 = 0;
    DAT_a1704254 = 0;
    DAT_a1702c88 = 0;
    if (DAT_a17045da == '\0') {
      matched_FUN_a02c1c14(0);
    }
    else {
      matched_FUN_a02c1c14(DAT_a0757ab1);
      FUN_a02a70ec(s_Set_ucode_gyro_delay____dms_a05ff614,DAT_a0757ab1);
    }
  }
  DAT_a1704260 = DAT_a170440c;
  iVar3 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a0380fc8) + 0.5,3);
  local_1d = (char)((iVar3 * (((uint)DAT_a1704156 - (uint)DAT_a17045c4) - DAT_a170440c)) / 1000000);
  DAT_a17045ae = (DAT_a1702c50 - local_1d) + -5;
  local_24 = matched_FUN_a049a0cc();
  FUN_a02a70ec(s_AudioClkPerSecond__d_a05ff630,local_24);
  local_24 = matched_FUN_a0506418(1000000000,local_24);
  DAT_a1704550 = 0;
  if ((char)DAT_a17045ac < '\x01') {
    if ((char)DAT_a17045ac < '\0') {
      uVar2 = matched_FUN_a0506418((char)DAT_a17045ac * -1000000,local_24);
      DAT_a1704550 = uVar2 | 0x80000000;
    }
  }
  else {
    local_25 = DAT_a17045ac;
    DAT_a1704550 = matched_FUN_a0506418((char)DAT_a17045ac * 1000000,local_24);
  }
  DAT_a17045a4 = 0;
  FUN_a02a70ec(s_____AmbaImgEisCtrl_ModeInit_fini_a05ff648);
  return local_18;
}

