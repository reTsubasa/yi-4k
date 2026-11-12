/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void eis_rotation_grid_coordinator(void)

{
  byte bVar1;
  undefined1 uVar2;
  undefined1 uVar3;
  undefined1 uVar4;
  undefined1 uVar5;
  short *psVar6;
  undefined4 uVar7;
  uint uVar8;
  int iVar9;
  uint in_fpscr;
  undefined4 extraout_s1;
  double dVar10;
  double dVar11;
  double dVar12;
  undefined4 local_64;
  undefined4 local_60;
  undefined4 local_5c;
  double local_58;
  undefined4 local_50;
  undefined4 uStack_4c;
  int local_44;
  uint local_40;
  int local_3c;
  int local_38;
  int local_34;
  uint local_30;
  uint local_2c;
  int local_28;
  uint local_24;
  
  local_5c = 0;
  local_60 = 0;
  local_64 = 0x100;
  if ((((DAT_a17045d7 == '\0') && (DAT_a17045d9 == '\0')) && (DAT_a17045dc == '\0')) &&
     (DAT_a17045dd == '\0')) {
    DAT_a17045d5 = '\0';
  }
  else {
    DAT_a17045d5 = '\x01';
  }
  dVar10 = DAT_a170af48;
  dVar11 = DAT_a170af78;
  if ((DAT_a17045d4 == '\0') && (DAT_a17045d5 != '\0')) {
    _DAT_a17045e0 = 0.0;
    if (DAT_a17045d7 != '\0') {
      local_40 = DAT_a170ab24 >> 8;
      if (DAT_a170404d < 2) {
        local_38 = DAT_a1704270;
      }
      else {
        local_38 = matched_FUN_a0506690((uint)(DAT_a170404d >> 1) + DAT_a1704270,DAT_a170404d);
        local_40 = matched_FUN_a0506690(local_40,DAT_a170404d);
      }
      iVar9 = DAT_a170ab28;
      if ('\0' < DAT_a17045ac) {
        iVar9 = DAT_a170ab2c;
      }
      local_2c = iVar9 + local_38;
      if (DAT_a17045da == '\0') {
        if (DAT_a0757aca == '\0') {
          local_2c = DAT_a170aee8 + 1;
        }
        else {
          local_2c = local_2c + 1;
          DAT_a0757aca = '\0';
        }
      }
      else if (DAT_a0757ac8 < 2) {
        local_2c = ((uint)((DAT_a1704304 - DAT_a170aea4) - DAT_a17040c0) >> 1) +
                   ((DAT_a170ab28 + DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
                   ((int)(DAT_a170ab20 + 1) >> 1)) + (uint)DAT_a1702c50 * -2;
      }
      else {
        local_2c = ((uint)((DAT_a1704304 - DAT_a170aea4) - DAT_a17040c0) >> 1) +
                   ((DAT_a170ab30 + DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
                   ((int)(DAT_a170ab20 + 1) >> 1));
      }
      if ((int)local_2c < 0) {
        local_2c = DAT_a1702f10 + local_2c;
      }
      else if (DAT_a1702f10 <= local_2c) {
        local_2c = local_2c - DAT_a1702f10;
      }
      if (DAT_a17045da == '\0') {
        local_30 = DAT_a170ab38;
        if ((int)DAT_a170ab38 < 0) {
          local_30 = DAT_a1702f10 + DAT_a170ab38;
        }
        else if (DAT_a1702f10 <= DAT_a170ab38) {
          local_30 = DAT_a170ab38 - DAT_a1702f10;
        }
        DAT_a170aee8 = local_30;
        local_24 = local_2c + DAT_a170af2c;
        if ((int)local_24 < 0) {
          local_24 = DAT_a1702f10 + local_24;
        }
        else if (DAT_a1702f10 <= local_24) {
          local_24 = local_24 - DAT_a1702f10;
        }
      }
      else {
        if (DAT_a0757ac8 < 2) {
          iVar9 = ((uint)((DAT_a1704304 - DAT_a170aea4) - DAT_a17040c0) >> 1) +
                  (((DAT_a170ab28 + DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
                   ((int)(DAT_a170ab20 + 1) >> 1)) - (uint)DAT_a1702c50);
        }
        else {
          iVar9 = ((uint)((DAT_a1704304 - DAT_a170aea4) - DAT_a17040c0) >> 1) +
                  ((DAT_a170ab2c + DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
                  ((int)(DAT_a170ab20 + 1) >> 1));
        }
        local_30 = iVar9 - 1;
        if ((int)local_30 < 0) {
          local_30 = DAT_a1702f10 + local_30;
        }
        else if (DAT_a1702f10 <= local_30) {
          local_30 = local_30 - DAT_a1702f10;
        }
        if ((int)local_2c < (int)local_30) {
          local_28 = (local_30 - local_2c) + 1;
        }
        else if ((int)local_30 < (int)local_2c) {
          local_28 = (local_30 - local_2c) + DAT_a1702f10 + 1;
        }
        if (local_28 == 0) {
          local_28 = 1;
        }
      }
      DAT_a170ab54 = 0;
      if ((int)local_30 < (int)local_2c) {
        for (DAT_a170ab40 = local_2c; DAT_a170ab40 < DAT_a1702f10; DAT_a170ab40 = DAT_a170ab40 + 1)
        {
          DAT_a170ab54 = (*(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x112) * 4) -
                         *(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x2ad) * 4)) + DAT_a170ab54;
        }
        for (DAT_a170ab40 = 0; DAT_a170ab40 <= local_30; DAT_a170ab40 = DAT_a170ab40 + 1) {
          DAT_a170ab54 = (*(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x112) * 4) -
                         *(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x2ad) * 4)) + DAT_a170ab54;
        }
      }
      else {
        for (DAT_a170ab40 = local_2c; DAT_a170ab40 <= local_30; DAT_a170ab40 = DAT_a170ab40 + 1) {
          DAT_a170ab54 = (*(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x112) * 4) -
                         *(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x2ad) * 4)) + DAT_a170ab54;
        }
      }
      if ((int)DAT_a170ab54 < 0) {
        local_34 = -1;
        DAT_a170ab54 = -DAT_a170ab54;
      }
      else {
        local_34 = 1;
      }
      uVar8 = (int)(char)DAT_a0757aa1 - 8;
      iVar9 = matched_FUN_a0384a10
                        (2,uVar8,DAT_a170ab54 << (uVar8 & 0xff),
                         ((int)DAT_a170ab54 >> 0x1f) << (uVar8 & 0xff) |
                         DAT_a170ab54 << ((int)(char)DAT_a0757aa1 - 0x28U & 0xff) |
                         DAT_a170ab54 >> (0x20 - uVar8 & 0xff),(uint)DAT_a170404d << 8);
      DAT_a170ab58 = local_34 * iVar9;
      dVar10 = (double)VectorSignedToFloat(DAT_a17045cc << (uint)DAT_a0757aa1,
                                           (byte)(in_fpscr >> 0x16) & 3);
      DAT_a17045d0 = VectorFloatToSigned((dVar10 * DAT_a0393b18) / DAT_a0393b20,3);
      matched_FUN_a03846f0(DAT_a17045d0);
      uVar8 = DAT_a170ab38;
      uVar7 = eis_rotation_filter(2,DAT_a170ab58,&DAT_a1702d00 + (DAT_a1704040 + 0x448) * 4);
      *(undefined4 *)(&DAT_a1702d00 + (uVar8 + 0x448) * 4) = uVar7;
      dVar11 = (double)VectorSignedToFloat((int)DAT_a0757aa0 *
                                           *(int *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x448) * 4),
                                           (byte)(in_fpscr >> 0x16) & 3);
      dVar10 = (double)VectorSignedToFloat(1 << (uint)DAT_a0757aa1,(byte)(in_fpscr >> 0x16) & 3);
      _DAT_a17045e0 = (double)VectorSignedToFloat((int)DAT_a1702ccd,(byte)(in_fpscr >> 0x16) & 3);
      _DAT_a17045e0 = ((dVar11 * DAT_a0757aa8) / dVar10) * _DAT_a17045e0;
      DAT_a170af78 = (double)CONCAT44(DAT_a170af78._4_4_,DAT_a170af78._0_4_);
      DAT_a170af48 = (double)CONCAT44(DAT_a170af48._4_4_,DAT_a170af48._0_4_);
      if (DAT_a17045da == '\0') {
        local_44 = 0;
        local_50 = 0x3b761f5;
        uStack_4c = 0x3f6c9871;
        DAT_a170ab54 = 0;
        if ((int)local_24 < (int)local_2c) {
          for (DAT_a170ab40 = local_2c; DAT_a170ab40 < DAT_a1702f10; DAT_a170ab40 = DAT_a170ab40 + 1
              ) {
            DAT_a170ab54 = (*(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x112) * 4) -
                           *(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x2ad) * 4)) + DAT_a170ab54;
          }
          for (DAT_a170ab40 = 0; DAT_a170ab40 <= local_24; DAT_a170ab40 = DAT_a170ab40 + 1) {
            DAT_a170ab54 = (*(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x112) * 4) -
                           *(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x2ad) * 4)) + DAT_a170ab54;
          }
        }
        else {
          for (DAT_a170ab40 = local_2c; DAT_a170ab40 <= local_24; DAT_a170ab40 = DAT_a170ab40 + 1) {
            DAT_a170ab54 = (*(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x112) * 4) -
                           *(int *)(&DAT_a1702d00 + (DAT_a170ab40 + 0x2ad) * 4)) + DAT_a170ab54;
          }
        }
        if ((int)DAT_a170ab54 < 0) {
          local_34 = -1;
          DAT_a170ab54 = -DAT_a170ab54;
        }
        else {
          local_34 = 1;
        }
        uVar8 = (int)(char)DAT_a0757aa1 - 8;
        local_44 = matched_FUN_a0384a10
                             (2,uVar8,DAT_a170ab54 << (uVar8 & 0xff),
                              ((int)DAT_a170ab54 >> 0x1f) << (uVar8 & 0xff) |
                              DAT_a170ab54 << ((int)(char)DAT_a0757aa1 - 0x28U & 0xff) |
                              DAT_a170ab54 >> (0x20 - uVar8 & 0xff),(uint)DAT_a170404d << 8);
        local_44 = local_34 * local_44;
        DAT_a170af38 = eis_rotation_filter(2,local_44,&DAT_a1702d00 + (DAT_a1704040 + 0x448) * 4);
        dVar12 = (double)VectorSignedToFloat(DAT_a170af38 * DAT_a0757aa0,
                                             (byte)(in_fpscr >> 0x16) & 3);
        dVar10 = (double)VectorSignedToFloat(1 << (uint)DAT_a0757aa1,(byte)(in_fpscr >> 0x16) & 3);
        dVar11 = (double)VectorSignedToFloat((int)DAT_a1702ccd,(byte)(in_fpscr >> 0x16) & 3);
        DAT_a170af40 = ((dVar12 * DAT_a0757aa8) / dVar10) * dVar11;
        DAT_a170af50 = DAT_a170af40 - (double)CONCAT44(DAT_a170af68._4_4_,(undefined4)DAT_a170af68);
        DAT_a170af70 = DAT_a170af50 - (double)CONCAT44(DAT_a170af78._4_4_,DAT_a170af78._0_4_);
        DAT_a170af58 = DAT_a170af40 - (double)CONCAT44(DAT_a170af48._4_4_,DAT_a170af48._0_4_);
        if (DAT_a170af38 < 0) {
          local_3c = -1;
        }
        else {
          local_3c = 1;
        }
        if (*(int *)(&DAT_a1702d00 + (DAT_a1704040 + 0x448) * 4) < 0) {
          DAT_a0757b64 = -1;
        }
        else {
          DAT_a0757b64 = 1;
        }
        uVar7 = 0;
        DAT_a170af60 = 0;
        DAT_a170af64 = 0;
        if (local_3c * DAT_a0757b64 == -1) {
          DAT_a170af30 = DAT_a170af30 + -1;
          if (DAT_a170af30 < -0x28) {
            DAT_a170af30 = -0x28;
          }
          dVar10 = (double)VectorSignedToFloat(DAT_a170af30,(byte)(in_fpscr >> 0x16) & 3);
          DAT_a170af34 = DAT_a0757acc + (float)(dVar10 * DAT_a0393b28);
          DAT_a170af81 = '\0';
          DAT_a170af84 = 0;
        }
        else {
          if (NAN(DAT_a170af58)) {
            dVar10 = (double)CONCAT44(uStack_4c,local_50);
            uVar8 = in_fpscr & 0xfffffff | (uint)(DAT_a170af70 < dVar10) << 0x1f |
                    (uint)(DAT_a170af70 == dVar10) << 0x1e;
            bVar1 = (byte)(uVar8 >> 0x18);
            if ((bool)(bVar1 >> 6 & 1) || (bool)(bVar1 >> 7) != (NAN(DAT_a170af70) || NAN(dVar10)))
            {
              if ((DAT_a170af81 == '\0') && (DAT_a170af84 = DAT_a170af84 + 1, 10 < DAT_a170af84)) {
                DAT_a170af81 = '\x01';
              }
            }
            else if (DAT_a170af81 == '\0') {
              DAT_a170af30 = DAT_a170af30 + -5;
              if (DAT_a170af30 < -0x28) {
                DAT_a170af30 = -0x28;
              }
              DAT_a170af81 = '\x01';
              DAT_a170af84 = 0;
            }
          }
          else {
            dVar10 = -(double)CONCAT44(uStack_4c,local_50);
            uVar8 = in_fpscr & 0xfffffff | (uint)(dVar10 < DAT_a170af70) << 0x1f |
                    (uint)(dVar10 == DAT_a170af70) << 0x1e;
            bVar1 = (byte)(uVar8 >> 0x18);
            if ((bool)(bVar1 >> 6 & 1) || (bool)(bVar1 >> 7) != (NAN(dVar10) || NAN(DAT_a170af70)))
            {
              if ((DAT_a170af81 == '\0') && (DAT_a170af84 = DAT_a170af84 + 1, 10 < DAT_a170af84)) {
                DAT_a170af81 = '\x01';
              }
            }
            else if (DAT_a170af81 == '\0') {
              DAT_a170af30 = DAT_a170af30 + -5;
              if (DAT_a170af30 < -0x28) {
                DAT_a170af30 = -0x28;
              }
              DAT_a170af81 = '\x01';
              DAT_a170af84 = 0;
            }
          }
          in_fpscr = uVar8 & 0xfffffff | (uint)(_DAT_a17045e0 < 0.0) << 0x1f;
          if (SUB41(in_fpscr >> 0x1f,0) == NAN(_DAT_a17045e0)) {
            dVar10 = (double)DAT_a0757aec * (double)CONCAT44(uStack_4c,local_50);
            in_fpscr = uVar8 & 0xfffffff | (uint)(dVar10 < _DAT_a17045e0) << 0x1f |
                       (uint)(dVar10 == _DAT_a17045e0) << 0x1e;
            bVar1 = (byte)(in_fpscr >> 0x18);
            if ((!(bool)(bVar1 >> 6 & 1) &&
                 (bool)(bVar1 >> 7) == (NAN(dVar10) || NAN(_DAT_a17045e0))) &&
               (DAT_a170af81 != '\0')) {
              if ((10 < DAT_a170af84) && (DAT_a170af30 = DAT_a170af30 + 5, 0 < DAT_a170af30)) {
                DAT_a170af30 = 0;
              }
              if (DAT_a170af30 < 0) {
                dVar10 = (double)VectorSignedToFloat(DAT_a170af30,(byte)(in_fpscr >> 0x16) & 3);
                DAT_a170af34 = (float)(dVar10 * DAT_a03944c0);
              }
              else {
                DAT_a170af34 = 0.0;
              }
              DAT_a170af34 = DAT_a0757acc + DAT_a170af34;
              DAT_a170af81 = '\0';
              DAT_a170af84 = 0;
            }
          }
          in_fpscr = in_fpscr & 0xfffffff;
          if (((_DAT_a17045e0 < 0.0) &&
              ((double)-DAT_a0757aec * (double)CONCAT44(uStack_4c,local_50) < _DAT_a17045e0)) &&
             (DAT_a170af81 != '\0')) {
            if ((10 < DAT_a170af84) && (DAT_a170af30 = DAT_a170af30 + 5, 0 < DAT_a170af30)) {
              DAT_a170af30 = 0;
            }
            if (DAT_a170af30 < 0) {
              dVar10 = (double)VectorSignedToFloat(DAT_a170af30,(byte)(in_fpscr >> 0x16) & 3);
              DAT_a170af34 = (float)(dVar10 * DAT_a03944c0);
            }
            else {
              DAT_a170af34 = 0.0;
            }
            DAT_a170af34 = DAT_a0757acc + DAT_a170af34;
            DAT_a170af81 = '\0';
            DAT_a170af84 = 0;
          }
        }
        in_fpscr = in_fpscr & 0xfffffff;
        DAT_a170af78 = DAT_a170af50;
        DAT_a170af48 = DAT_a170af40;
        if (DAT_a170af34 < 0.0) {
          DAT_a170af34 = 0.0;
        }
      }
      if (DAT_a0757b00 != 0) {
        dVar10 = (_DAT_a17045e0 * DAT_a03944c8) / DAT_a03944d0;
        FUN_a02a70ec(s___1_2f__d__d__d_a0600b1c,uVar7,SUB84(dVar10,0),
                     (int)((ulonglong)dVar10 >> 0x20),DAT_a17040d8 >> 8 | DAT_a17040dc << 0x18,
                     DAT_a17040dc >> 8,local_38,local_28);
      }
      DAT_a1704040 = DAT_a170ab38;
      dVar10 = (double)VectorSignedToFloat(DAT_a17045cc,(byte)(in_fpscr >> 0x16) & 3);
      local_58 = (dVar10 * DAT_a03944d0) / DAT_a03944c8;
      if ((DAT_a170af2a == '\0') && (DAT_a170af29 == '\0')) {
        uVar8 = in_fpscr & 0xfffffff | (uint)(DAT_a0757aa4 < 0.0) << 0x1f |
                (uint)(DAT_a0757aa4 == 0.0) << 0x1e;
        bVar1 = (byte)(uVar8 >> 0x18);
        if ((bool)(bVar1 >> 6 & 1) || (bool)(bVar1 >> 7) != NAN(DAT_a0757aa4)) {
          if (DAT_a0757aa4 != DAT_a03944e0) {
            _DAT_a17045e0 = ((double)DAT_a0757aa4 * DAT_a03948a8) / DAT_a03948b0;
          }
        }
        else {
          dVar10 = (double)VectorUnsignedToFloat(DAT_a170ab60,(byte)(uVar8 >> 0x16) & 3);
          uVar7 = matched_FUN_a0503dc8
                            (SUB84(((double)(DAT_a0757aa4 + DAT_a0757aa4) * DAT_a03944d0 * dVar10) /
                                   DAT_a03944d8,0));
          _DAT_a17045e0 = (double)CONCAT44(extraout_s1,uVar7) * local_58;
        }
      }
      else {
        _DAT_a17045e0 = 0.0;
      }
    }
    if (((DAT_a17045d9 != '\0') || (DAT_a17045dc != '\0')) && (DAT_a0757b10 == 0)) {
      if ((DAT_a170afb9 == '\0') && (DAT_a170afba != '\0')) {
        if (((DAT_a17045da != '\0') && (DAT_a0757aa2 != '\0')) &&
           (DAT_a0757a51 < (byte)(DAT_a0757ab1 - 3U))) {
          DAT_a0757a51 = DAT_a0757a51 + 1;
          DAT_a170422b = DAT_a0757a51;
        }
        FUN_a02a70ec(s_Mov_XY_not_ready_for_generating_w_a0600b2c,(int)DAT_a1704228,
                     (int)(char)DAT_a170422b);
      }
      else {
        if (DAT_a0757b3a == 0) {
          eis_calibration_xy_grid(&DAT_a1704700);
        }
        if (DAT_a0757b3c == 0) {
          eis_row_dependent_warp(&DAT_a1704700);
        }
      }
    }
    if (DAT_a17045da == '\0') {
      if (DAT_a170af80 != '\0') {
        _DAT_a17045e0 = (double)DAT_a170af34 * _DAT_a17045e0;
      }
      DAT_a170af68._0_4_ = _DAT_a17045e0;
      DAT_a170af68._4_4_ = DAT_a17045e4;
    }
    matched_FUN_a0385068();
    FUN_a02d9b88(SUB84(_DAT_a17045e0,0),&local_64);
    if (DAT_a17045da == '\0') {
      DAT_a170ab1e = DAT_a170ab1b;
      DAT_a1704380 = DAT_a1704348;
      DAT_a1704384 = DAT_a170434c;
      DAT_a1704388 = DAT_a1704350;
      DAT_a170438c = DAT_a1704354;
      DAT_a1704390 = DAT_a1704358;
      DAT_a1704394 = DAT_a170435c;
      DAT_a1704398 = DAT_a1704360;
      DAT_a170439c = DAT_a1704364;
      DAT_a17043a0 = DAT_a1704368;
      DAT_a17043a4 = DAT_a170436c;
      DAT_a17043a8 = DAT_a1704370;
      DAT_a17043ac = DAT_a1704374;
      DAT_a17043b0 = DAT_a1704378;
      DAT_a17043b4 = DAT_a170437c;
      DAT_a17043f0 = DAT_a1704414;
      DAT_a17043f4 = DAT_a1704418;
      DAT_a17043f8 = DAT_a170441c;
      DAT_a17043fc = DAT_a1704420;
      matched_FUN_a029c680(&DAT_a17044a8,&DAT_a1704400,0xa8);
      iVar9 = FUN_a02da164(&local_64,0);
      dVar10 = DAT_a170af48;
      dVar11 = DAT_a170af78;
      if (iVar9 == 0) {
        local_60 = 0xf;
        matched_thunk_FUN_a0312460(&local_64);
        local_60 = 0;
        FUN_a0312f74(&local_64,&DAT_a17045ec);
        DAT_a1704334 = DAT_a17045ec;
        DAT_a1704338 = DAT_a17045f0;
        DAT_a1704339 = DAT_a17045f1;
        DAT_a170433a = DAT_a17045f2;
        DAT_a170433b = DAT_a17045f3;
        DAT_a170433c = rtos_virtual_to_physical(DAT_a17045fc);
        DAT_a1704340 = rtos_virtual_to_physical(DAT_a1704600);
        psVar6 = DAT_a17045fc;
        uVar5 = DAT_a17045f3;
        uVar4 = DAT_a17045f2;
        uVar3 = DAT_a17045f1;
        uVar2 = DAT_a17045f0;
        DAT_a1704344 = DAT_a17045f7;
        DAT_a1704345 = DAT_a17045f8;
        if (DAT_a17045ec != 0) {
          DAT_a170afb8 = 1;
        }
        dVar10 = DAT_a170af48;
        dVar11 = DAT_a170af78;
        if (DAT_a0757b2e != 0) {
          uVar7 = rtos_virtual_to_physical(DAT_a17045fc);
          FUN_a02a70ec(s_Warp_cmd_in_shared_memory___d__d_a0600bc4,uVar2,uVar3,uVar4,uVar5,psVar6,
                       uVar7,(int)*DAT_a17045fc,(int)DAT_a17045fc[1],(int)*DAT_a1704600);
          dVar10 = DAT_a170af48;
          dVar11 = DAT_a170af78;
        }
      }
    }
    else {
      iVar9 = FUN_a02da164(&local_64,0);
      dVar10 = DAT_a170af48;
      dVar11 = DAT_a170af78;
      if (iVar9 == 0) {
        local_60 = 0xf;
        matched_thunk_FUN_a0312460(&local_64);
        dVar10 = DAT_a170af48;
        dVar11 = DAT_a170af78;
        if (DAT_a0757b2e != 0) {
          local_60 = 0;
          FUN_a0312f74(&local_64,&DAT_a17045ec);
          psVar6 = DAT_a17045fc;
          uVar5 = DAT_a17045f3;
          uVar4 = DAT_a17045f2;
          uVar3 = DAT_a17045f1;
          uVar2 = DAT_a17045f0;
          uVar7 = rtos_virtual_to_physical(DAT_a17045fc);
          FUN_a02a70ec(s_Warp_cmd_in_shared_memory___d__d_a0600b78,uVar2,uVar3,uVar4,uVar5,psVar6,
                       uVar7,(int)*DAT_a17045fc,(int)DAT_a17045fc[1],(int)*DAT_a1704600,
                       (int)DAT_a1704700,(int)DAT_a1704704,(int)DAT_a1704702);
          dVar10 = DAT_a170af48;
          dVar11 = DAT_a170af78;
        }
      }
    }
  }
  DAT_a170af78._4_4_ = (undefined4)((ulonglong)dVar11 >> 0x20);
  DAT_a170af78._0_4_ = SUB84(dVar11,0);
  DAT_a170af48._4_4_ = (undefined4)((ulonglong)dVar10 >> 0x20);
  DAT_a170af48._0_4_ = SUB84(dVar10,0);
  return;
}

