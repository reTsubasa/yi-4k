/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 eis_debug_dispatch(undefined4 param_1,float *param_2,float *param_3)

{
  char cVar1;
  short sVar2;
  undefined4 uVar3;
  int iVar4;
  undefined4 extraout_r1;
  undefined4 extraout_r1_00;
  undefined1 *puVar5;
  undefined4 uVar6;
  uint uVar7;
  uint uVar8;
  undefined4 uVar9;
  short local_70;
  undefined1 auStack_5c [24];
  float local_44;
  float local_40;
  float local_30;
  undefined1 local_2c;
  undefined1 local_2b;
  undefined1 local_2a;
  undefined1 local_29;
  undefined4 local_24;
  byte local_1e;
  undefined1 local_1d;
  undefined4 local_1c;
  undefined4 local_18;
  undefined2 local_14;
  byte local_11;
  
  switch(param_1) {
  case 0:
    param_1 = matched_FUN_a0382ba0();
    break;
  case 1:
    param_1 = matched_FUN_a0382f88();
    break;
  case 2:
    matched_FUN_a0382ba0();
    FUN_a02a70ec(s_____EnableEis_____a0600c94);
    eis_controller_init();
    eis_mode_rowtime_init();
    param_1 = matched_FUN_a0382f88();
    break;
  case 3:
    DAT_a0757a68 = VectorFloatToUnsigned(*param_2,3);
    param_1 = FUN_a02a70ec(s_EIS_Enable_RSC__d_a0600ca8,DAT_a0757a68);
    break;
  case 4:
    param_1 = matched_FUN_a03833b0((int)*param_2);
    break;
  case 5:
    param_1 = matched_FUN_a0383568();
    break;
  case 6:
    uVar6 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar6;
    if ((byte)local_70 == '\x01') {
      FUN_a02a70ec(s_Before__GyroInfo_GyroXPolar__d_a0600cbc,(int)DAT_a1702ccb);
      local_70._0_1_ = (byte)(int)*param_3;
      DAT_a1702ccb = (byte)local_70;
      param_1 = FUN_a02a70ec(s_After__GyroInfo_GyroXPolar__d_a0600cdc,(int)(char)(byte)local_70);
    }
    else {
      uVar6 = VectorFloatToUnsigned(*param_2,3);
      local_70._0_1_ = (byte)uVar6;
      if ((byte)local_70 == '\x02') {
        FUN_a02a70ec(s_Before__GyroInfo_GyroYPolar__d_a0600cfc,(int)DAT_a1702ccc);
        local_70._0_1_ = (byte)(int)*param_3;
        DAT_a1702ccc = (byte)local_70;
        param_1 = FUN_a02a70ec(s_After__GyroInfo_GyroYPolar__d_a0600d1c,(int)(char)(byte)local_70);
      }
      else {
        uVar6 = VectorFloatToUnsigned(*param_2,3);
        local_70._0_1_ = (byte)uVar6;
        if ((byte)local_70 == '\x03') {
          FUN_a02a70ec(s_Before__GyroInfo_GyroZPolar__d_a0600d3c,(int)DAT_a1702ccd);
          local_70._0_1_ = (byte)(int)*param_3;
          DAT_a1702ccd = (byte)local_70;
          param_1 = FUN_a02a70ec(s_After__GyroInfo_GyroZPolar__d_a0600d5c,(int)(char)(byte)local_70)
          ;
        }
      }
    }
    break;
  case 7:
    local_70._0_1_ = (byte)(int)*param_2;
    DAT_a17045ad = (byte)local_70;
    param_1 = FUN_a02a70ec(s_DlyMsSet__d_a0600d7c,(int)(char)(byte)local_70);
    break;
  case 8:
    image_command_dispatch(0xb03,0,&DAT_a1702c54,0);
    param_1 = FUN_a02a70ec(s_SlowShutter__d_a0600d88,DAT_a1702c57);
    break;
  default:
    param_1 = FUN_a02a70ec(s_invalid_t_cmd_id____a06016b0);
    break;
  case 0xb:
    matched_FUN_a03aaaf0(0,&local_2c);
    FUN_a02a70ec(s_current_AAA_algo_is___d__d__d__d_a0600d98,local_2c,local_2b,local_2a,local_29);
    local_2c = 0;
    matched_FUN_a03ab424(0,&local_2c);
    image_command_dispatch(0xa51,0,0,auStack_5c);
    local_44 = *param_2 / DAT_a0395b80;
    local_40 = *param_3 / DAT_a0395b84;
    param_1 = image_command_dispatch(0xa50,0,0,auStack_5c);
    break;
  case 0xc:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170ab14 = (byte)local_70;
    DAT_a0757ab4 = *param_3;
    param_1 = FUN_a02a70ec(s_FlgManualExposureTime__d_ManualS_a0600dbc,uVar7 & 0xff,
                           SUB84((double)DAT_a0757ab4,0),
                           (int)((ulonglong)(double)DAT_a0757ab4 >> 0x20));
    break;
  case 0xd:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a17045d9 = (byte)local_70;
    uVar8 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar8;
    DAT_a17045d8 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnEisXyUsingWarp__d__EnEisPerspe_a0600dec,uVar7 & 0xff,uVar8 & 0xff);
    break;
  case 0xe:
    DAT_a0757aa4 = *param_2;
    DAT_a17045cc = (int)*param_3;
    break;
  case 0xf:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a17045d7 = (byte)local_70;
    uVar8 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar8;
    DAT_a17045d4 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnEisRotationCorrect__d__FlgNorm_a0600e1c,uVar7 & 0xff,uVar8 & 0xff);
    break;
  case 0x10:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a0757a51 = (byte)local_70;
    DAT_a170422b = DAT_a170422a - (byte)local_70;
    if (DAT_a170422b < '\0') {
      DAT_a170422b = DAT_a170422b + DAT_a1702c50;
    }
    FUN_a02a70ec(s_EIS_WARP_UPDATE_ADV_TIME__d__Eis_a0600e50,uVar7 & 0xff,(int)DAT_a170422b);
    param_1 = FUN_a02a70ec(s_EisUpdateEndTime1__d__EisUpdateE_a0600e88,(int)DAT_a1704228,
                           (int)DAT_a1704229);
    break;
  case 0x11:
    local_70._0_1_ = (byte)(int)*param_2;
    cVar1 = (byte)local_70;
    DAT_a0757ab0 = (byte)local_70;
    local_70._0_1_ = (byte)(int)*param_3;
    DAT_a17045e8 = (byte)local_70;
    DAT_a0757ad0 = 0;
    param_1 = FUN_a02a70ec(s_ExtraGyroPhaseDelay__d_ExtraRSCP_a0600f78,(int)cVar1,
                           (int)(char)(byte)local_70);
    break;
  case 0x12:
    _DAT_a17045e0 = ((double)*param_2 * DAT_a0396170) / DAT_a0396178;
    break;
  case 0x13:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a17045db = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnEisXy2ndCompensation__d_a0600fa8,uVar7 & 0xff);
    break;
  case 0x14:
    DAT_a0757a70 = VectorFloatToUnsigned(*param_2,3);
    DAT_a0757a74 = DAT_a0757a70;
    param_1 = FUN_a02a70ec(s_MaxEisRangePerct_MinEisRangePerc_a0600fc4,DAT_a0757a70);
    break;
  case 0x15:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70 = (short)uVar7;
    DAT_a0757b48 = local_70;
    DAT_a0757a54 = ((uVar7 & 0xffff) * DAT_a0757a58 * 0x100) / 10000;
    param_1 = FUN_a02a70ec(s_EisFocalLength__d__VideoFocalVal_a0600fec,DAT_a0757a58,uVar7 & 0xffff,
                           DAT_a0757a54);
    break;
  case 0x16:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    if ((uVar7 & 0xffff) == 1) {
      param_1 = matched_FUN_a037e218();
    }
    else {
      uVar7 = VectorFloatToUnsigned(*param_2,3);
      if ((uVar7 & 0xffff) == 2) {
        param_1 = matched_FUN_a037e288();
      }
    }
    break;
  case 0x17:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a17045dc = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnEisLbcUsingWarp__d_a060102c,uVar7 & 0xff);
    break;
  case 0x18:
    local_70 = (short)(int)*param_2;
    sVar2 = local_70;
    local_70 = (short)(int)*param_3;
    param_1 = matched_FUN_a038e98c((int)sVar2,(int)local_70);
    break;
  case 0x19:
    uVar9 = matched_FUN_a0308b8c();
    uVar6 = DAT_a17045fc;
    uVar3 = rtos_virtual_to_physical(DAT_a17045fc);
    FUN_a02a70ec(s_AmbaDSP_ImgIsSupportVirtualMemor_a0601044,uVar9,uVar6,uVar3);
    iVar4 = matched_FUN_a0308b8c();
    if (iVar4 == 0) {
      puVar5 = &DAT_70118000;
    }
    else {
      puVar5 = &DAT_e8118000;
    }
    param_1 = FUN_a02a70ec(s_DEBUG_PORT_EN__x_a0601080,puVar5);
    break;
  case 0x1a:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a17045dd = (byte)local_70;
    uVar8 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar8;
    DAT_a17045de = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnEisLDcUsingWarp__d__EnEisLDcUs_a0601094,uVar7 & 0xff,uVar8 & 0xff);
    break;
  case 0x1e:
    DAT_a0757b4c = *param_2;
    DAT_a0757b50 = *param_3;
    param_1 = FUN_a02a70ec(s_AMvScaleFactor__1_4f__FMvScaleFa_a06010c8,param_2,
                           SUB84((double)DAT_a0757b4c,0),
                           (int)((ulonglong)(double)DAT_a0757b4c >> 0x20),(double)DAT_a0757b50);
    break;
  case 0x1f:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170aef8 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_FlagEnhanceTurboOnce__d_a06010f4,uVar7 & 0xff);
    break;
  case 0x20:
    uVar6 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar6;
    DAT_a1702cba = (byte)local_70;
    uVar6 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar6;
    DAT_a1702cbb = (byte)local_70;
    break;
  case 0x50:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170af8e = (byte)local_70;
    DAT_a170af90 = 0;
    DAT_a0757af0 = 1;
    uVar6 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar6;
    DAT_a170af94 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_FlagAutoTest__d_a060110c,uVar7 & 0xff);
    break;
  case 0x51:
    DAT_a0757b44 = (int)*param_2;
    param_1 = FUN_a02a70ec(s_TimeShift____d_a060111c,DAT_a0757b44);
    break;
  case 0x52:
    DAT_a0757ac4 = (int)*param_2;
    param_1 = FUN_a02a70ec(s_RscScale____d_a060112c,DAT_a0757ac4);
    break;
  case 0x53:
    break;
  case 0x54:
    if (DAT_a17045da == '\0') {
      uVar7 = VectorFloatToUnsigned(*param_2,3);
      local_70._0_1_ = (byte)uVar7;
      DAT_a170af2a = (byte)local_70;
      param_1 = FUN_a02a70ec(s_TestEISOff0____d_a0601150,uVar7 & 0xff);
    }
    else {
      uVar7 = VectorFloatToUnsigned(*param_2,3);
      local_70._0_1_ = (byte)uVar7;
      DAT_a170af29 = (byte)local_70;
      param_1 = FUN_a02a70ec(s_TestEISOff5____d_a060113c,uVar7 & 0xff);
    }
    break;
  case 0x55:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    DAT_a17042e0 = (uVar7 & 0xffff) << 8;
    uVar7 = VectorFloatToUnsigned(*param_3,3);
    DAT_a17042e8 = (uVar7 & 0xffff) << 8;
    param_1 = FUN_a02a70ec(s_TestLimX__d__d_a0601164,DAT_a17042e0,DAT_a17042e8);
    break;
  case 0x56:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    DAT_a17042e4 = (uVar7 & 0xffff) << 8;
    uVar7 = VectorFloatToUnsigned(*param_3,3);
    DAT_a17042ec = (uVar7 & 0xffff) << 8;
    param_1 = FUN_a02a70ec(s_TestLimY__d__d_a0601174,DAT_a17042e4,DAT_a17042ec);
    break;
  case 0x57:
    DAT_a170aeec = (int)*param_2;
    param_1 = FUN_a02a70ec(s_RscModify____d_a0601184,DAT_a170aeec);
    break;
  case 0x58:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170af80 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_FlagRotationStrength____d_a0601194,uVar7 & 0xff);
    break;
  case 0x5b:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a0757ab8 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_WarpDenoiseShiftX____d_WarpDenoi_a06011b0,DAT_a170ab74,uVar7 & 0xff);
    break;
  case 0x5c:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170af8d = (byte)local_70;
    param_1 = FUN_a02a70ec(s_LogStyle____d_a06011e0,uVar7 & 0xff);
    break;
  case 0x5d:
    DAT_a0757aec = *param_2;
    param_1 = FUN_a02a70ec(s_TimesDifRAThres____f_a06011f0,param_2,SUB84((double)DAT_a0757aec,0),
                           (int)((ulonglong)(double)DAT_a0757aec >> 0x20));
    break;
  case 0x5e:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170af88 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnZCenterForceAI____d_a0601208,uVar7 & 0xff);
    break;
  case 0x5f:
    DAT_a0757ad4 = (int)*param_2;
    param_1 = FUN_a02a70ec(s_DefZThresDegree____d_a0601220,DAT_a0757ad4);
    break;
  case 0x60:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a0757ad8 = (byte)local_70;
    DAT_a0757adc = (int)*param_3;
    param_1 = FUN_a02a70ec(s_DefUnderZThresCount____d_FastZCe_a0601238,uVar7 & 0xff,DAT_a0757adc);
    break;
  case 100:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_14 = (undefined2)uVar7;
    if ((uVar7 & 0xffff) < 0x25) {
      uVar6 = VectorFloatToUnsigned(*param_3,3);
      local_70 = (short)uVar6;
      (&DAT_a0757af8)[uVar7 & 0xffff] = local_70;
    }
    else {
      param_1 = FUN_a02a70ec(s_wrong_debug_flag_id____a06012cc);
    }
    break;
  case 0x65:
    local_30 = *param_3;
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    param_1 = (*(code *)DAT_a1a355a4[7])(uVar7 & 0xffff,&local_30,0);
    break;
  case 0x66:
    *(undefined2 *)param_3 = (&DAT_a0757af8)[*(ushort *)param_2];
    break;
  case 0x67:
    local_18 = VectorFloatToUnsigned(*param_2,3);
    local_1c = VectorFloatToUnsigned(*param_3,3);
    uVar6 = matched_FUN_a037d738(local_18,local_1c,1);
    param_1 = FUN_a02a70ec(s_Calc_rotation_crop_factor____d___a06012e4,uVar6,local_18,local_1c);
    break;
  case 0x68:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a170af8a = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnXYCenterForceAI____d_a060126c,uVar7 & 0xff);
    break;
  case 0x69:
    DAT_a0757ae0 = (int)*param_2;
    param_1 = FUN_a02a70ec(s_DefXYThresMov____d_a0601284,DAT_a0757ae0);
    break;
  case 0x6a:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a0757ae4 = (byte)local_70;
    DAT_a0757ae8 = (int)*param_3;
    param_1 = FUN_a02a70ec(s_DefUnderXYThresCount____d_FastXY_a0601298,uVar7 & 0xff,DAT_a0757ae8);
    break;
  case 200:
    FUN_a02a70ec(s_EnEisRotationCorrect____d__FlgNo_a0601320,DAT_a17045d7,DAT_a17045d4);
    FUN_a02a70ec(s_EnEisInMode5____d__EnEisXyUsingW_a0601358,DAT_a17045da,DAT_a17045d9,DAT_a17045d8)
    ;
    FUN_a02a70ec(s_EnEisXy2ndCompensation____d_a060139c,DAT_a17045db);
    FUN_a02a70ec(s_EnEisLbcUsingWarp____d_a06013b8,DAT_a17045dc);
    FUN_a02a70ec(s_EnEisLDcUsingWarp____d__EnEisLDc_a06013d0,DAT_a17045dd,DAT_a17045de);
    FUN_a02a70ec(s_MaxEisRangePerct___MinEisRangePe_a0601408,DAT_a0757a70);
    FUN_a02a70ec(s_RotateFreq____f__EisAngleLimit___a0601434,extraout_r1,
                 SUB84((double)DAT_a0757aa4,0),(int)((ulonglong)(double)DAT_a0757aa4 >> 0x20),
                 DAT_a17045cc);
    FUN_a02a70ec(s_EIS_UPDATE_ADV_TIME____d__EisUpd_a0601458,DAT_a0757a50,(int)DAT_a1704228,
                 (int)DAT_a1704229);
    FUN_a02a70ec(s_EIS_WARP_UPDATE_ADV_TIME____d__E_a06014a4,DAT_a0757a51,(int)DAT_a170422b);
    FUN_a02a70ec(s_ExtraGyroPhaseDelay____d_a06014e0,(int)DAT_a0757ab0);
    FUN_a02a70ec(s_EisFocalLength____d__VideoFocalV_a06014fc,DAT_a0757a58,DAT_a0757b48,DAT_a0757a54)
    ;
    FUN_a02a70ec(s_FlgManualExposureTime____d_Manua_a0601544,DAT_a170ab14,
                 SUB84((double)DAT_a0757ab4,0),(int)((ulonglong)(double)DAT_a0757ab4 >> 0x20));
    FUN_a02a70ec(s_AMvScaleFactor____1_4f__FMvScale_a0601578,extraout_r1_00,
                 SUB84((double)DAT_a0757b4c,0),(int)((ulonglong)(double)DAT_a0757b4c >> 0x20),
                 (double)DAT_a0757b50);
    FUN_a02a70ec(s_WarpDenoiseShiftX____d_WarpDenoi_a06011b0,DAT_a170ab74,DAT_a0757ab8);
    FUN_a02a70ec(s_EnXYCenterForceAI____d_EnZCenter_a06015a8,DAT_a170af8a,DAT_a170af88);
    FUN_a02a70ec(s_FlagSensorVertFlip____d_FlagInit_a06015d8,DAT_a1702cb9,DAT_a1702cba,DAT_a1702cbb)
    ;
    param_1 = FUN_a02a70ec(s_GyroInfo_GyroPolar____d__d__d_a0601628,(int)DAT_a1702ccb,
                           (int)DAT_a1702ccc,(int)DAT_a1702ccd);
    break;
  case 0xc9:
    if (*DAT_a1a355a4 != 0) {
      (*(code *)*DAT_a1a355a4)(&DAT_a1702cc0);
    }
    param_1 = FUN_a02a70ec(s_IMU_device_info___d__d__d__d__d_a0601648,DAT_a1702cc0,DAT_a1702ce4,
                           (int)((uint)DAT_a1702cde + (uint)DAT_a1702ce0) >> 1,(int)DAT_a1702cd4,
                           DAT_a1702cd6);
    break;
  case 0xca:
    if (DAT_a1a355a4[2] != 0) {
      (*(code *)DAT_a1a355a4[2])(1,&DAT_a1702c30);
    }
    param_1 = FUN_a02a70ec(s_GyroX__d__GyroY__d__GyroZ__d_a0601668,DAT_a1702c30,DAT_a1702c32,
                           DAT_a1702c34);
    break;
  case 0xcb:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    local_1d = (byte)local_70;
    uVar8 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar8;
    local_1e = (byte)local_70;
    if (DAT_a1a355a4[3] != 0) {
      (*(code *)DAT_a1a355a4[3])(uVar7 & 0xff,0,&DAT_a170ba44,uVar8 & 0xff);
    }
    param_1 = FUN_a02a70ec(s_Addr_0x_x__a0601688,local_1d);
    for (local_11 = 0; local_11 < local_1e; local_11 = local_11 + 1) {
      param_1 = FUN_a02a70ec(s_Reg__d___d_a0601694,local_11,
                             *(undefined2 *)(&DAT_a170ba44 + (uint)local_11 * 2));
    }
    break;
  case 0xcc:
    if (DAT_a1a355a4[4] != 0) {
      uVar7 = VectorFloatToUnsigned(*param_2,3);
      uVar8 = VectorFloatToUnsigned(*param_3,3);
      param_1 = (*(code *)DAT_a1a355a4[4])(uVar7 & 0xffff,0,uVar8 & 0xffff);
    }
    break;
  case 0xfe:
    uVar6 = VectorFloatToUnsigned(*param_2,3);
    uVar9 = VectorFloatToUnsigned(*param_3,3);
    param_1 = matched_FUN_a0394ba8(uVar6,uVar9);
    break;
  case 0xff:
    local_24 = 0xb514c59;
    param_1 = FUN_a02a70ec(s_Eis_rev__0x_x_a06016a0,0xb514c59);
    break;
  case 500:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a17045d9 = (byte)local_70;
    DAT_a17045da = (byte)local_70;
    param_1 = FUN_a02a70ec(s_EnEisInMode5__d__EnEisXyUsingWar_a0600eb4,uVar7 & 0xff,uVar7 & 0xff);
    break;
  case 0x1f5:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    DAT_a0757ab1 = (byte)local_70;
    param_1 = FUN_a02a70ec(s_GyroDelayMode5__d_a0600edc,uVar7 & 0xff);
    break;
  case 0x1f6:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    local_70._0_1_ = (byte)uVar7;
    cVar1 = (byte)local_70;
    DAT_a0757a50 = (byte)local_70;
    DAT_a1704228 = (byte)local_70;
    DAT_a1704229 = DAT_a1702c50;
    uVar6 = VectorFloatToUnsigned(*param_3,3);
    local_70._0_1_ = (byte)uVar6;
    DAT_a0757a51 = (byte)local_70;
    DAT_a170422b = (byte)local_70;
    FUN_a02a70ec(s_EIS_UPDATE_ADV_TIME__d__EisUpdat_a0600ef0,uVar7 & 0xff,(int)cVar1,
                 (int)DAT_a1702c50);
    FUN_a02a70ec(s_EIS_WARP_UPDATE_ADV_TIME__d__Eis_a0600e50,DAT_a0757a51,(int)DAT_a170422b);
    param_1 = FUN_a02a70ec(s_FlgWarpTaskTimeCtrl__d_a0600f34,DAT_a0757aa2);
    break;
  case 0x1f7:
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    matched_FUN_a02c1bfc(uVar7 & 0xffff);
    uVar7 = VectorFloatToUnsigned(*param_2,3);
    param_1 = FUN_a02a70ec(s_set_AmbaDSP_LiveviewSetSec2Extra_a0600f4c,uVar7 & 0xffff);
  }
  return param_1;
}

