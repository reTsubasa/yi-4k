/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


uint warp_calculate(char *param_1,int *param_2)

{
  char cVar1;
  char cVar2;
  byte bVar3;
  char cVar4;
  bool bVar5;
  int iVar6;
  undefined4 uVar7;
  int iVar8;
  undefined4 extraout_r1;
  undefined4 extraout_r1_00;
  undefined4 extraout_r1_01;
  undefined4 extraout_r1_02;
  undefined4 extraout_r1_03;
  int iVar9;
  int iVar10;
  uint uVar11;
  int iVar12;
  uint unaff_r8;
  undefined4 *puVar13;
  undefined4 *puVar14;
  uint uVar15;
  uint uVar16;
  int iVar17;
  bool bVar18;
  uint in_fpscr;
  double dVar19;
  double dVar20;
  undefined4 local_74;
  int local_70;
  int local_6c;
  char local_68;
  char local_67;
  undefined2 local_64;
  undefined2 local_62;
  undefined2 local_60;
  undefined2 local_5e;
  undefined2 local_5c;
  undefined2 local_5a;
  undefined2 local_58;
  undefined2 local_56;
  undefined4 local_54;
  int local_50;
  undefined4 local_4c;
  int local_48;
  int *local_44;
  int local_40;
  int local_3c;
  undefined4 local_38;
  int local_34;
  
  local_70 = 0;
  local_6c = 0;
  local_44 = (int *)0x0;
  local_40 = 0;
  local_3c = 0;
  local_38 = 0;
  local_34 = 0;
  local_54 = 0;
  local_50 = 0;
  local_4c = 0;
  local_48 = 0;
  bVar5 = false;
  if (*param_2 != 0) {
    if (param_2[2] != 0x20140701 && param_2[2] != 0x20130101) {
      FUN_a02a70ec(s_Error__Warp_Version_0x_X____0x_X_a05e68cc);
      return 0xffffffff;
    }
    bVar5 = false;
    if ((uint)(param_2[3] + -1 << (param_2[5] & 0xffU)) < (uint)param_2[9]) {
      FUN_a02a70ec(s_Error___HorGridNum__d___1____Til_a05d1f1c,param_2[3],1 << (param_2[5] & 0xffU))
      ;
      return 0xffffffff;
    }
    iVar8 = param_2[4];
    if ((uint)(iVar8 + -1 << (param_2[6] & 0xffU)) < (uint)param_2[10]) {
      FUN_a02a70ec(s_Error___VerGridNum__d___1____Til_a05d1f5c,iVar8,1 << (param_2[6] & 0xffU),
                   param_2[10]);
      return 0xffffffff;
    }
    if (param_2[0xf] == 0) {
      FUN_a02a70ec(s_Error__Calib_pWarp_is_NULL_a05e68f4);
      return 0xffffffff;
    }
    dVar19 = *(double *)(param_2 + 0x2e);
    unaff_r8 = 0;
    in_fpscr = in_fpscr & 0xfffffff;
    if ((dVar19 != 0.0) && (*param_1 == '\x01')) {
      bVar5 = true;
      FUN_a02a70ec(s_Error__Theta____f_Still_mode_sho_a05e6910,iVar8,SUB84(dVar19,0),
                   (int)((ulonglong)dVar19 >> 0x20));
      param_2[0x2e] = 0;
      param_2[0x2f] = 0;
    }
    if ((param_2[1] & 0x100U) == 0) {
      uVar11 = param_2[0x10];
      uVar16 = param_2[7];
      if (uVar11 < uVar16) {
        bVar18 = false;
      }
      else {
        bVar18 = (uint)param_2[8] <= (uint)param_2[0x11];
      }
      cVar1 = (char)param_2[0xb];
      unaff_r8 = (uint)*(byte *)((int)param_2 + 0x2d);
      uVar15 = (uint)*(byte *)((int)param_2 + 0x2f);
      cVar2 = *(char *)((int)param_2 + 0x2e);
      bVar3 = *(byte *)((int)param_2 + 0x53);
      cVar4 = *(char *)((int)param_2 + 0x52);
      if (cVar4 == '\0' ||
          (bVar3 == 0 ||
          ((char)param_2[0x14] == '\0' ||
          (*(byte *)((int)param_2 + 0x51) == 0 ||
          (cVar2 == '\0' || (uVar15 == 0 || (cVar1 == '\0' || unaff_r8 == 0))))))) {
        FUN_a02a70ec(s_Error__Factors_of_Calib_sample_r_a05d2010);
        return 0xffffffff;
      }
      iVar10 = param_2[9];
      iVar8 = matched_FUN_a0506418(param_2[0x12] * (uint)*(byte *)((int)param_2 + 0x51));
      iVar6 = matched_FUN_a0506418(iVar10 * unaff_r8,cVar1);
      if (iVar6 + uVar16 < iVar8 + uVar11) {
        iVar12 = param_2[10];
        iVar9 = param_2[8];
LAB_a0311b5c:
        FUN_a02a70ec(s_Error__WARP_Calib_vin_geo_x__d__y_a05e6958,uVar16,iVar9,iVar10,iVar12,cVar1,
                     unaff_r8,cVar2,uVar15);
        FUN_a02a70ec(s_current_vin_geo_x__d__y__d__w__d_a05d20b8,param_2[0x10],param_2[0x11],
                     param_2[0x12],param_2[0x13],(char)param_2[0x14],
                     *(undefined1 *)((int)param_2 + 0x51),*(undefined1 *)((int)param_2 + 0x52),
                     *(undefined1 *)((int)param_2 + 0x53));
        return 0xffffffff;
      }
      bVar18 = (bool)(bVar18 ^ 1);
      iVar8 = matched_FUN_a0506418((param_2[0x13] + -1) * (uint)bVar3,cVar4);
      iVar12 = param_2[10];
      iVar17 = param_2[0x11];
      iVar6 = matched_FUN_a0506418((iVar12 + -1) * uVar15,cVar2);
      iVar9 = param_2[8];
      if ((uint)(iVar6 + iVar9) < (uint)(iVar8 + iVar17)) {
        bVar18 = true;
      }
      if (bVar18) goto LAB_a0311b5c;
    }
  }
  uVar11 = param_2[0x15];
  uVar16 = param_2[0x16];
  if (uVar11 != 0) {
    unaff_r8 = uVar11;
  }
  if (uVar11 == 0) {
    unaff_r8 = param_2[0x12];
  }
  if (uVar16 == 0) {
    uVar16 = param_2[0x13];
  }
  if ((unaff_r8 < (uint)(param_2[0x19] + param_2[0x17])) ||
     (uVar16 < (uint)(param_2[0x1a] + param_2[0x18]))) {
    FUN_a02a70ec(s_Error__Dummy_window_x__d__y__d__w_a05d2104);
    FUN_a02a70ec(s_vin_>R2R_window_w__d__h__d_a05d2138,unaff_r8,uVar16);
  }
  else if ((param_2[0x1b] == 0) || (param_2[0x1c] == 0)) {
    FUN_a02a70ec(s_Error__Invalid_CfaWinDim__d___d_a05d215c);
  }
  else {
    if ((param_2[0x21] != 0) && (param_2[0x22] != 0)) {
      if (DAT_a14c063d != '\0') {
        FUN_a02a70ec(s_AmbaDSP_ImgCalcWarpCompensation__a05e69d8);
        FUN_a02a70ec(s_Pipe__d__Algo__d__Func__d__Ctx___a05d1c30,*param_1,param_1[1],param_1[2],
                     param_1[3],*(undefined4 *)(param_1 + 4),param_1[8]);
        FUN_a02a70ec(s_AMBA_DSP_IMG_WARP_CALC_INFO_s__a05e69fc);
        FUN_a02a70ec(s_WarpEnb____d_a05e6a1c,*param_2);
        FUN_a02a70ec(s_Control____d_a05e63e0,param_2[1]);
        FUN_a02a70ec(s_theta____f_a05e6a30,extraout_r1,param_2[0x2e],param_2[0x2f]);
        if (*param_2 != 0) {
          FUN_a02a70ec(s_CalibWarpInfo__a05e6cfc);
          FUN_a02a70ec(s_Version___0x_x_a05d22c8,param_2[2]);
          FUN_a02a70ec(s_HorGridNum____d_a05d22e8,param_2[3]);
          FUN_a02a70ec(s_VerGridNum____d_a05d2304,param_2[4]);
          FUN_a02a70ec(s_TileWidthExp____d_a05d2320,param_2[5]);
          FUN_a02a70ec(s_TileHeightExp____d_a05d233c,param_2[6]);
          FUN_a02a70ec(s_VinSensorGeo__a05e3628 + 4);
          FUN_a02a70ec(s_StartX____d_a05d2358,param_2[7]);
          FUN_a02a70ec(s_StartY____d_a05d2374,param_2[8]);
          FUN_a02a70ec(s_Width____d_a05d2390,param_2[9]);
          FUN_a02a70ec(s_Height____d_a05d23ac,param_2[10]);
          FUN_a02a70ec(s_HSubSample__a05d23c8);
          FUN_a02a70ec(s_FactorNum____d_a05d23e4,(char)param_2[0xb]);
          FUN_a02a70ec(s_FactorDen____d_a05d2404,*(undefined1 *)((int)param_2 + 0x2d));
          FUN_a02a70ec(s_VSubSample__a05d2424);
          FUN_a02a70ec(s_FactorNum____d_a05d23e4,*(undefined1 *)((int)param_2 + 0x2e));
          FUN_a02a70ec(s_FactorDen____d_a05d2404,*(undefined1 *)((int)param_2 + 0x2f));
          FUN_a02a70ec(s_pWarp___0x_x_a05e6d10,param_2[0xf]);
          if (0 < param_2[4]) {
            iVar8 = 0;
            do {
              iVar9 = param_2[0xf];
              iVar10 = iVar8 * param_2[3];
              iVar8 = iVar8 + 1;
              iVar6 = iVar10 * 4;
              iVar10 = (iVar10 + param_2[3] + 0x3ffffffe) * 4;
              FUN_a02a70ec(s_CalibWarpInfo_pWarp___d___d____d_a05e6d28,
                           (int)*(short *)(iVar9 + iVar6),(int)*(short *)(iVar9 + iVar6 + 2),
                           (int)*(short *)(iVar9 + iVar6 + 4),(int)*(short *)(iVar9 + iVar6 + 4 + 2)
                           ,(int)*(short *)(iVar9 + iVar10),(int)*(short *)(iVar9 + iVar10 + 2),
                           (int)*(short *)(iVar9 + iVar10 + 4),
                           (int)*(short *)(iVar9 + iVar10 + 4 + 2));
            } while (iVar8 < param_2[4]);
          }
        }
        dVar19 = DAT_a0312118;
        FUN_a02a70ec(s_VinSensorGeo__a05e3628 + 8);
        FUN_a02a70ec(s_StartX____d_a05d2358 + 4,param_2[0x10]);
        FUN_a02a70ec(s_StartY____d_a05d2374 + 4,param_2[0x11]);
        FUN_a02a70ec(s_Width____d_a05d2390 + 4,param_2[0x12]);
        FUN_a02a70ec(s_Height____d_a05d23ac + 4,param_2[0x13]);
        FUN_a02a70ec(s_HSubSample__a05d23c8 + 4);
        FUN_a02a70ec(s_FactorNum____d_a05d23e4 + 4,(char)param_2[0x14]);
        FUN_a02a70ec(s_FactorDen____d_a05d2404 + 4,*(undefined1 *)((int)param_2 + 0x51));
        FUN_a02a70ec(s_VSubSample__a05d2424 + 4);
        FUN_a02a70ec(s_FactorNum____d_a05d23e4 + 4,*(undefined1 *)((int)param_2 + 0x52));
        FUN_a02a70ec(s_FactorDen____d_a05d2404 + 4,*(undefined1 *)((int)param_2 + 0x53));
        FUN_a02a70ec(s_R2rOutWinDim_Width____d_a05e6a40,param_2[0x15]);
        FUN_a02a70ec(s_R2rOutWinDim_Height____d_a05e6a60,param_2[0x16]);
        FUN_a02a70ec(s_DmyWinGeo_StartX____d_a05e6a80,param_2[0x17]);
        FUN_a02a70ec(s_DmyWinGeo_StartY____d_a05e6a9c,param_2[0x18]);
        FUN_a02a70ec(s_DmyWinGeo_Width____d_a05e6ab8,param_2[0x19]);
        FUN_a02a70ec(s_DmyWinGeo_Height____d_a05e6ad4,param_2[0x1a]);
        FUN_a02a70ec(s_CfaWinDim_Width____d_a05e6af0,param_2[0x1b]);
        FUN_a02a70ec(s_CfaWinDim_Height____d_a05e6b0c,param_2[0x1c]);
        dVar20 = (double)VectorUnsignedToFloat(param_2[0x1d],(byte)(in_fpscr >> 0x16) & 3);
        FUN_a02a70ec(s_ActWinCrop_LeftTopX____f_a05e6b28,extraout_r1_00,SUB84(dVar20 * dVar19,0),
                     (int)((ulonglong)(dVar20 * dVar19) >> 0x20));
        dVar20 = (double)VectorUnsignedToFloat(param_2[0x1e],(byte)(in_fpscr >> 0x16) & 3);
        FUN_a02a70ec(s_ActWinCrop_LeftTopY____f_a05e6b48,extraout_r1_01,SUB84(dVar20 * dVar19,0),
                     (int)((ulonglong)(dVar20 * dVar19) >> 0x20));
        dVar20 = (double)VectorUnsignedToFloat(param_2[0x1f],(byte)(in_fpscr >> 0x16) & 3);
        FUN_a02a70ec(s_ActWinCrop_RightBotX____f_a05e6b68,extraout_r1_02,SUB84(dVar20 * dVar19,0),
                     (int)((ulonglong)(dVar20 * dVar19) >> 0x20));
        dVar20 = (double)VectorUnsignedToFloat(param_2[0x20],(byte)(in_fpscr >> 0x16) & 3);
        FUN_a02a70ec(s_ActWinCrop_RightBotY____f_a05e6b88,extraout_r1_03,SUB84(dVar20 * dVar19,0),
                     (int)((ulonglong)(dVar20 * dVar19) >> 0x20));
        FUN_a02a70ec(s_MainWinDim_Width____d_a05e6ba8,param_2[0x21]);
        FUN_a02a70ec(s_MainWinDim_Height____d_a05e6bc4,param_2[0x22]);
        FUN_a02a70ec(s_PrevWinDim_0__Width____d_a05e6be0,param_2[0x23]);
        FUN_a02a70ec(s_PrevWinDim_0__Height____d_a05e6c00,param_2[0x24]);
        FUN_a02a70ec(s_PrevWinDim_1__Width____d_a05e6c20,param_2[0x25]);
        FUN_a02a70ec(s_PrevWinDim_1__Height____d_a05e6c40,param_2[0x26]);
        FUN_a02a70ec(s_ScreennailDim_Width____d_a05e6c60,param_2[0x27]);
        FUN_a02a70ec(s_ScreennailDim_Height____d_a05e6c80,param_2[0x28]);
        FUN_a02a70ec(s_ThumbnailDim_Width____d_a05e6ca0,param_2[0x29]);
        FUN_a02a70ec(s_ThumbnailDim_Height____d_a05e6cc0,param_2[0x2a]);
        FUN_a02a70ec(s_HorSkewPhaseInc____d_a05e6ce0,param_2[0x2b]);
      }
      local_68 = *param_1;
      local_67 = param_1[3];
      uVar11 = FUN_a0308880(&local_68,&local_74);
      if ((int)uVar11 < 0) {
        FUN_a02a70ec(s_Warning__Cannot_get_context_mute_a05d0f84);
      }
      else {
        matched_FUN_a03bc46c(local_74,0);
        if (*param_1 == '\0') {
          FUN_a0308754(&local_68,&local_70);
          local_50 = local_70 + 0x41104;
          local_40 = local_70 + 0x47600;
          local_34 = local_70 + 0x2f04;
          local_48 = local_70 + 0x41154;
          iVar8 = local_70 + 0x2f18;
          puVar13 = (undefined4 *)(local_70 + 0x56378);
          puVar14 = (undefined4 *)(local_70 + 0x5637c);
        }
        else {
          if (*param_1 != '\x01') {
            uVar11 = 0xffffffff;
            FUN_a02a70ec(s_Warning__AmbaDSP_ImgCalcWarpComp_a05e6d74);
            matched_thunk_FUN_a03c3c5c(local_74);
            goto LAB_a0312088;
          }
          FUN_a0308754(&local_68,&local_6c);
          local_34 = local_6c + 0x52a7c;
          local_50 = local_6c + 0x60884;
          local_48 = local_6c + 0x608d4;
          iVar8 = local_6c + 0x52a90;
          puVar13 = (undefined4 *)(local_6c + 0x772d8);
          puVar14 = (undefined4 *)(local_6c + 0x772dc);
          local_3c = local_6c + 0x68560;
        }
        local_44 = param_2;
        if (*param_1 == '\x01') {
          if (param_1[1] == '\x01') {
            uVar7 = 2;
          }
          else if (param_1[1] == '\x02') {
            uVar7 = 3;
          }
          else {
            FUN_a02a70ec(s__Warn__unsupport_mode_a05d2544);
            uVar7 = 2;
          }
          local_64 = 0;
          local_58 = (undefined2)local_44[0x19];
          local_62 = 0;
          local_60 = (undefined2)local_44[0x21];
          local_5e = (undefined2)local_44[0x22];
          local_5c = (undefined2)local_44[0x17];
          local_5a = (undefined2)local_44[0x18];
          local_56 = (undefined2)local_44[0x1a];
          if (param_1[2] == '\x02') {
            local_38 = matched_FUN_a02ced58(uVar7,&local_64,&local_5c);
          }
          else {
            local_38 = matched_FUN_a02cece4();
          }
        }
        uVar11 = FUN_a032cf38(param_1,&local_44,&local_54);
        if (uVar11 == 0) {
          matched_FUN_a029c680(iVar8,param_2,0xc0);
          *puVar13 = local_54;
          *puVar14 = local_4c;
        }
        matched_thunk_FUN_a03c3c5c(local_74);
      }
LAB_a0312088:
      if (bVar5) {
        uVar11 = uVar11 | 0x10000000;
      }
      return uVar11;
    }
    FUN_a02a70ec(s_Error__Invalid_MainWinDim__d___d_a05e69b4);
  }
  return 0xffffffff;
}

