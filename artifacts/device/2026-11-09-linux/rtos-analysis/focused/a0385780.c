/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

uint eis_gyro_sample_processing(uint param_1)

{
  char cVar1;
  uint uVar2;
  int extraout_r1;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint *puVar6;
  int iVar7;
  bool bVar8;
  uint in_fpscr;
  int iVar9;
  int iVar10;
  float fVar11;
  double dVar12;
  double dVar13;
  double dVar14;
  double dVar15;
  double dVar16;
  undefined8 uVar17;
  ushort local_130;
  undefined1 auStack_b0 [24];
  float local_98;
  float local_94;
  float local_84;
  undefined2 local_7e;
  undefined1 local_7c [8];
  uint local_74 [4];
  int local_64;
  int local_60;
  uint local_5c;
  uint local_58;
  uint local_54;
  uint local_50;
  undefined4 *local_4c;
  char local_45;
  int local_44;
  int local_40;
  int local_3c;
  int local_38;
  uint local_34;
  char local_2d;
  int local_2c;
  
  local_74[0] = 0;
  local_74[1] = 0;
  local_74[2] = 0;
  local_40 = 0;
  local_44 = 0;
  if (DAT_a1702cbc == '\0') {
    return param_1;
  }
  if (DAT_a0757b32 != 0) {
    if ((DAT_a0757b32 & 1) != 0) {
      *(undefined4 *)(DAT_a062dc8c + 600) = 1;
      *(undefined4 *)(DAT_a062dc8c + 600) = 0;
      DAT_a170b358 = *(int *)(DAT_a062dc8c + 0x254);
    }
    if ((DAT_a0757b32 & 2) != 0) {
      *(undefined4 *)(DAT_a062dc8c + 600) = 1;
      *(undefined4 *)(DAT_a062dc8c + 600) = 0;
      DAT_a170b358 = *(int *)(DAT_a062dc8c + 0x254);
    }
    if ((DAT_a0757b32 & 4) != 0) {
      DAT_a170b358 = *(int *)(DAT_a062dc8c + 0x254);
      *(undefined4 *)(DAT_a062dc8c + 600) = 1;
      *(undefined4 *)(DAT_a062dc8c + 600) = 0;
      DAT_a170b35c = *(int *)(DAT_a062dc8c + 0x254);
      FUN_a02a70ec(s_EIS_main_task_interval____6d___1_a05ffe38,DAT_a170b358 - DAT_a170b35c,
                   DAT_a170b358,DAT_a170b35c,DAT_a170422c);
    }
    if ((DAT_a0757b32 & 8) != 0) {
      DAT_a170b358 = *(int *)(DAT_a062dc8c + 0x254);
      *(undefined4 *)(DAT_a062dc8c + 600) = 1;
      *(undefined4 *)(DAT_a062dc8c + 600) = 0;
      DAT_a170b35c = *(int *)(DAT_a062dc8c + 0x254);
      if (35999 < (uint)(DAT_a170b358 - DAT_a170b35c)) {
        FUN_a02a70ec(s__sEIS_main_task_interval____6d___a05ffe74,DAT_a06f3080,
                     DAT_a170b358 - DAT_a170b35c,DAT_a170b358,DAT_a170b35c,DAT_a170422c);
      }
    }
  }
  local_74[1] = 0;
  local_74[0] = CONCAT22((short)(((local_74[0] >> 0x18) << 0x10) >> 8),0x100);
  DAT_a1702c40 = matched_FUN_a048e3f8();
  if (DAT_a1702c44 == '\0') {
    if (DAT_a1702c40 - DAT_a1702c48 < (uint)DAT_a1702ce2) {
      uVar2 = matched_analyst_task_sleep(DAT_a1702ce2);
      return uVar2;
    }
    if ((*(int *)(DAT_a1a355a4 + 4) == 0) ||
       (uVar2 = (**(code **)(DAT_a1a355a4 + 4))(), uVar2 == 0xffffffff)) {
      DAT_a170404c = 1;
      uVar2 = matched_FUN_a0382ba0();
      return uVar2;
    }
    DAT_a1702c44 = 1;
    return uVar2;
  }
  DAT_a170ab3c = DAT_a170ab38;
  DAT_a170ab38 = DAT_a1702f14;
  DAT_a170ab80 = DAT_a1702f14;
  if ((DAT_a0757b22 == 0) && (*(int *)(DAT_a1a355a4 + 8) != 0)) {
    (**(code **)(DAT_a1a355a4 + 8))(1,&DAT_a1702c30);
  }
  *(uint *)(&DAT_a1702d00 + DAT_a170ab38 * 4) = (uint)DAT_a1702c30;
  *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x89) * 4) = (uint)DAT_a1702c32;
  if ((DAT_a1702cd1 == '\x01') || (DAT_a1702cd1 == '\x02')) {
    *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x112) * 4) = (uint)DAT_a1702c34;
  }
  if ((DAT_a0757b20 != 0) &&
     ((DAT_a0757b24 == 0 || (matched_FUN_a0506674(DAT_a170ab60,DAT_a0757b24), extraout_r1 == 0)))) {
    if ((DAT_a0757b20 & 1) != 0) {
      FUN_a02a70ec(s_GyroData___8u___8u___8u___5u_a05ffeb4,DAT_a1702c30,DAT_a1702c32,DAT_a1702c34,
                   DAT_a1702c36);
    }
    if ((DAT_a0757b20 & 2) != 0) {
      FUN_a02a70ec(s_GyroData___8u___8u___8u_a05ffed4,
                   *(undefined4 *)(&DAT_a1702d00 + DAT_a170ab38 * 4),
                   *(undefined4 *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x89) * 4),
                   *(undefined4 *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x112) * 4));
    }
    if ((DAT_a0757b20 & 4) != 0) {
      FUN_a02a70ec(s_GyroBias___8u___8u___8u_a05ffeec,
                   *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x19b) * 4) >> 8,
                   *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x224) * 4) >> 8,
                   *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x2ad) * 4) >> 8);
    }
  }
  DAT_a170ab60 = DAT_a1702c40;
  if ((((uint)DAT_a1702c50 * 3) / 2 < (uint)(DAT_a17042fc - DAT_a1704304)) && (DAT_a0757b08 != 0)) {
    FUN_a02a70ec(s__sVinTime_error___d__d_a05fff04,DAT_a06f3084,DAT_a17042fc,DAT_a1704304);
  }
  DAT_a1704304 = DAT_a17042fc;
  if ((((uint)DAT_a1702c50 * 3) / 2 < (uint)(DAT_a1704300 - DAT_a1704308)) && (DAT_a0757b08 != 0)) {
    FUN_a02a70ec(s__sVinTime1_error___d__d_a05fff1c,DAT_a06f3080,DAT_a1704300,DAT_a1704308);
  }
  DAT_a1704308 = DAT_a1704300;
  if (((DAT_a170ab14 != '\0') && (DAT_a0757ab2 <= DAT_a170ab60)) && (DAT_a170ab5c != DAT_a1704304))
  {
    image_command_dispatch(0xa51,0,0,auStack_b0);
    in_fpscr = in_fpscr & 0xfffffff;
    if (DAT_a0757ab4 != DAT_a170b360) {
      DAT_a170b360 = DAT_a0757ab4;
      matched_FUN_a03aaaf0(0,local_7c);
      local_7c[0] = 0;
      matched_FUN_a03ab424(0,local_7c);
      local_94 = (local_98 / DAT_a0757ab4) * local_94;
      local_98 = DAT_a0757ab4;
      image_command_dispatch(0xa50,0,0,auStack_b0);
    }
  }
  DAT_a1702f14 = DAT_a1702f14 + 1;
  if (DAT_a1702f14 == DAT_a1702f10) {
    DAT_a1702f14 = 0;
  }
  *(int *)(&DAT_a1702d00 + DAT_a170ab38 * 4) = *(int *)(&DAT_a1702d00 + DAT_a170ab38 * 4) << 8;
  *(int *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x89) * 4) =
       *(int *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x89) * 4) << 8;
  if ((DAT_a1702cd1 == '\x01') || (DAT_a1702cd1 == '\x02')) {
    *(int *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x112) * 4) =
         *(int *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x112) * 4) << 8;
  }
  if (DAT_a1704234 != DAT_a17045c0) {
    FUN_a02a70ec(s_BiasAdjustBitShift_changes_from___a05fff38,DAT_a17045c0,DAT_a1704234);
    DAT_a17045c0 = DAT_a1704234;
    if (DAT_a1704234 == 10) {
      DAT_a17040cc = DAT_a17040cc << 10 | DAT_a17040c8 >> 0x16;
      DAT_a17040c8 = DAT_a17040c8 << 10;
      DAT_a17040d4 = DAT_a17040d4 << 10 | DAT_a17040d0 >> 0x16;
      DAT_a17040d0 = DAT_a17040d0 << 10;
      DAT_a17040dc = DAT_a17040dc << (DAT_a1704238 & 0xff) |
                     DAT_a17040d8 << (DAT_a1704238 - 0x20 & 0xff) |
                     DAT_a17040d8 >> (0x20 - DAT_a1704238 & 0xff);
      DAT_a17040d8 = DAT_a17040d8 << (DAT_a1704238 & 0xff);
      DAT_a170afba = 1;
    }
  }
  if (DAT_a1704234 == 10) {
    uVar2 = DAT_a17040c8 >> 10 | DAT_a17040cc << 0x16;
    bVar8 = DAT_a17040c8 < uVar2;
    uVar2 = DAT_a17040c8 - uVar2;
    uVar4 = *(uint *)(&DAT_a1702d00 + DAT_a170ab38 * 4);
    DAT_a17040c8 = uVar2 + uVar4;
    DAT_a17040cc = (DAT_a17040cc - ((DAT_a17040cc >> 10) + (uint)bVar8)) + ((int)uVar4 >> 0x1f) +
                   (uint)CARRY4(uVar2,uVar4);
    uVar2 = DAT_a17040d0 >> 10 | DAT_a17040d4 << 0x16;
    bVar8 = DAT_a17040d0 < uVar2;
    uVar2 = DAT_a17040d0 - uVar2;
    uVar4 = *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x89) * 4);
    DAT_a17040d0 = uVar2 + uVar4;
    DAT_a17040d4 = (DAT_a17040d4 - ((DAT_a17040d4 >> 10) + (uint)bVar8)) + ((int)uVar4 >> 0x1f) +
                   (uint)CARRY4(uVar2,uVar4);
    *(uint *)(&DAT_a1702d00 + (DAT_a1702f14 + 0x19b) * 4) =
         DAT_a17040c8 >> 10 | DAT_a17040cc * 0x400000;
    uVar2 = DAT_a17040d0 >> (DAT_a1704234 & 0xff) | DAT_a17040d4 << (0x20 - DAT_a1704234 & 0xff) |
            DAT_a17040d4 >> (DAT_a1704234 - 0x20 & 0xff);
    *(uint *)(&DAT_a1702d00 + (DAT_a1702f14 + 0x224) * 4) = uVar2;
  }
  else {
    uVar2 = DAT_a17040c8 << (DAT_a1704234 & 0xff);
    uVar4 = uVar2 - DAT_a17040c8;
    uVar3 = *(uint *)(&DAT_a1702d00 + DAT_a170ab38 * 4);
    uVar2 = ((int)uVar3 >> 0x1f) +
            ((DAT_a17040cc << (DAT_a1704234 & 0xff) | DAT_a17040c8 << (DAT_a1704234 - 0x20 & 0xff) |
             DAT_a17040c8 >> (0x20 - DAT_a1704234 & 0xff)) - (DAT_a17040cc + (uVar2 < DAT_a17040c8))
            ) + (uint)CARRY4(uVar3,uVar4);
    DAT_a17040c8 = uVar3 + uVar4 >> (DAT_a1704234 & 0xff) | uVar2 << (0x20 - DAT_a1704234 & 0xff) |
                   uVar2 >> (DAT_a1704234 - 0x20 & 0xff);
    DAT_a17040cc = uVar2 >> (DAT_a1704234 & 0xff);
    uVar2 = DAT_a17040d0 << (DAT_a1704234 & 0xff);
    uVar4 = uVar2 - DAT_a17040d0;
    uVar3 = *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x89) * 4);
    uVar2 = ((int)uVar3 >> 0x1f) +
            ((DAT_a17040d4 << (DAT_a1704234 & 0xff) | DAT_a17040d0 << (DAT_a1704234 - 0x20 & 0xff) |
             DAT_a17040d0 >> (0x20 - DAT_a1704234 & 0xff)) - (DAT_a17040d4 + (uVar2 < DAT_a17040d0))
            ) + (uint)CARRY4(uVar3,uVar4);
    DAT_a17040d0 = uVar3 + uVar4 >> (DAT_a1704234 & 0xff) | uVar2 << (0x20 - DAT_a1704234 & 0xff) |
                   uVar2 >> (DAT_a1704234 - 0x20 & 0xff);
    DAT_a17040d4 = uVar2 >> (DAT_a1704234 & 0xff);
    *(uint *)(&DAT_a1702d00 + (DAT_a1702f14 + 0x19b) * 4) = DAT_a17040c8;
    uVar2 = DAT_a17040d0;
    *(uint *)(&DAT_a1702d00 + (DAT_a1702f14 + 0x224) * 4) = DAT_a17040d0;
  }
  if (((DAT_a1702cd1 == '\x01') || (DAT_a1702cd1 == '\x02')) && (DAT_a0757b30 == 0)) {
    if (DAT_a1704234 == 10) {
      uVar2 = DAT_a17040d8 >> (DAT_a1704238 & 0xff) | DAT_a17040dc << (0x20 - DAT_a1704238 & 0xff) |
              DAT_a17040dc >> (DAT_a1704238 - 0x20 & 0xff);
      bVar8 = DAT_a17040d8 < uVar2;
      uVar2 = DAT_a17040d8 - uVar2;
      uVar4 = *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x112) * 4);
      DAT_a17040d8 = uVar2 + uVar4;
      DAT_a17040dc = (DAT_a17040dc - ((DAT_a17040dc >> (DAT_a1704238 & 0xff)) + (uint)bVar8)) +
                     ((int)uVar4 >> 0x1f) + (uint)CARRY4(uVar2,uVar4);
      uVar2 = DAT_a17040d8 >> (DAT_a1704238 & 0xff) | DAT_a17040dc << (0x20 - DAT_a1704238 & 0xff) |
              DAT_a17040dc >> (DAT_a1704238 - 0x20 & 0xff);
      *(uint *)(&DAT_a1702d00 + (DAT_a1702f14 + 0x2ad) * 4) = uVar2;
    }
    else {
      uVar2 = DAT_a17040d8 << (DAT_a1704238 & 0xff);
      uVar4 = uVar2 - DAT_a17040d8;
      uVar5 = *(uint *)(&DAT_a1702d00 + (DAT_a170ab38 + 0x112) * 4);
      uVar3 = ((DAT_a17040dc << (DAT_a1704238 & 0xff) | DAT_a17040d8 << (DAT_a1704238 - 0x20 & 0xff)
               | DAT_a17040d8 >> (0x20 - DAT_a1704238 & 0xff)) -
              (DAT_a17040dc + (uVar2 < DAT_a17040d8))) + ((int)uVar5 >> 0x1f) +
              (uint)CARRY4(uVar4,uVar5);
      uVar2 = uVar4 + uVar5 >> (DAT_a1704238 & 0xff) | uVar3 << (0x20 - DAT_a1704238 & 0xff) |
              uVar3 >> (DAT_a1704238 - 0x20 & 0xff);
      DAT_a17040dc = uVar3 >> (DAT_a1704238 & 0xff);
      DAT_a17040d8 = uVar2;
      *(uint *)(&DAT_a1702d00 + (DAT_a1702f14 + 0x2ad) * 4) = uVar2;
    }
  }
  if (DAT_a170b364 < DAT_a1702f10) {
    DAT_a170b364 = DAT_a170b364 + 1;
    return uVar2;
  }
  DAT_a170ab15 = DAT_a1704044;
  DAT_a170ab16 = DAT_a1704045;
  DAT_a170ab17 = DAT_a1704046;
  DAT_a170ab19 = DAT_a1704048;
  if (DAT_a170ab5c != DAT_a1704304) {
    DAT_a170b366 = 0;
    DAT_a170ab30 = DAT_a170ab2c;
    DAT_a170ab2c = DAT_a170ab28;
    DAT_a170ab28 = DAT_a170ab38;
    if (DAT_a0757ad0 < 10) {
      FUN_a02a70ec(s_EOF_change____Index____d_a05fff64,DAT_a170ab38);
      DAT_a0757ad0 = DAT_a0757ad0 + 1;
    }
    if (DAT_a0757ac8 < 2) {
      DAT_a0757ac8 = DAT_a0757ac8 + 1;
    }
    DAT_a170aea4 = DAT_a170ab5c;
    DAT_a170ab5c = DAT_a1704304;
    if (DAT_a17045da != '\0') {
      DAT_a170afb9 = 0;
      DAT_a170afb8 = '\0';
      DAT_a170ab1b = 0;
    }
    uVar2 = matched_FUN_a0383a68();
    local_7e = 4;
    if (*(int *)(DAT_a1a30f20 + 0x28) != 0) {
      uVar2 = (**(code **)(DAT_a1a30f20 + 0x28))(4,&local_84);
    }
    uVar4 = VectorFloatToUnsigned(local_84 * DAT_a0386ec8,3);
    local_130 = (ushort)uVar4;
    DAT_a170ab20 = local_130;
    if (1 < DAT_a0757a8c) {
      if (DAT_a1702c50 < 0x1f) {
        if ((((uVar4 & 0xffff) - 0xf < 2) || ((uVar4 & 0xffff) - 0xb < 2)) ||
           ((uVar4 & 0xffff) - 7 < 2)) {
          DAT_a0757ab0 = -5;
          DAT_a17045e8 = '\x01';
        }
        else if (((uVar4 & 0xffff) - 0xd < 2) || ((uVar4 & 0xffff) - 9 < 2)) {
          DAT_a0757ab0 = -4;
          DAT_a17045e8 = '\x01';
        }
        else if ((uVar4 & 0xffff) - 5 < 2) {
          DAT_a0757ab0 = -3;
          DAT_a17045e8 = '\x01';
        }
        else {
          DAT_a0757ab0 = -2;
          DAT_a17045e8 = '\0';
        }
      }
      else {
        if ((((uVar4 & 0xffff) - 0xd < 2) || ((uVar4 & 0xffff) - 9 < 2)) ||
           ((uVar4 & 0xffff) - 5 < 2)) {
          DAT_a0757ab0 = -5;
        }
        else {
          if (((1 < (uVar4 & 0xffff) - 0xf) && (1 < (uVar4 & 0xffff) - 0xb)) &&
             (1 < (uVar4 & 0xffff) - 7)) {
            DAT_a0757ab0 = -2;
            DAT_a17045e8 = '\0';
            goto LAB_a0386eec;
          }
          DAT_a0757ab0 = -4;
        }
        DAT_a17045e8 = '\x01';
      }
    }
LAB_a0386eec:
    DAT_a170ab18 = DAT_a1704047;
    if (*(int *)((&DAT_a1a30f20)[(byte)local_7e & 3] + 0x18) != 0) {
      uVar2 = (**(code **)((&DAT_a1a30f20)[(byte)local_7e & 3] + 0x18))(local_7e,&DAT_a1704128);
    }
    dVar16 = (double)VectorUnsignedToFloat(DAT_a170418c,(byte)(in_fpscr >> 0x16) & 3);
    dVar12 = (double)VectorUnsignedToFloat
                               ((DAT_a1704188 + 1) * DAT_a1704190,(byte)(in_fpscr >> 0x16) & 3);
    uVar4 = VectorFloatToUnsigned(dVar16 / dVar12 + DAT_a0387158,3);
    local_130 = (ushort)uVar4;
    DAT_a170b366 = local_130;
    if (DAT_a1702c88 != local_130) {
      DAT_a1702c88 = local_130;
      iVar9 = VectorFloatToUnsigned(DAT_a1704140 * DAT_a0387160,3);
      DAT_a17040c0 = (iVar9 * (DAT_a1704134 - DAT_a170440c) + 500000U) / 1000000;
      uVar2 = matched_FUN_a0506690(0x3e800,uVar4 & 0xffff);
      if (DAT_a17045da == '\0') {
        DAT_a1704228 = DAT_a170422a - DAT_a0757a50;
        if (DAT_a17045ac == '\0') {
          DAT_a1704229 = DAT_a1702c50;
        }
        else {
          DAT_a1704229 = DAT_a170422a;
        }
        DAT_a170422b = DAT_a170422a - DAT_a0757a51;
        if ((char)DAT_a1704228 < '\0') {
          DAT_a1704228 = DAT_a1704228 + DAT_a1702c50;
        }
        if ((char)DAT_a1704229 < '\x01') {
          DAT_a1704229 = DAT_a1704229 + DAT_a1702c50;
        }
        if (DAT_a170422b < '\0') {
          DAT_a170422b = DAT_a170422b + DAT_a1702c50;
        }
      }
      else {
        DAT_a1704228 = DAT_a0757a50;
        DAT_a1704229 = DAT_a1702c50;
        DAT_a170422b = DAT_a0757a51;
      }
      DAT_a170b368 = '\x01';
      DAT_a170ab68 = (uint)DAT_a1702c50 - (uint)DAT_a170b369;
      DAT_a170ab24 = uVar2;
    }
    if ((DAT_a170b368 != '\0') || (DAT_a170b36a != '\0')) {
      uVar2 = matched_FUN_a0506418((uint)DAT_a1702c50 * DAT_a0757a54 * DAT_a1702ca4,DAT_a1704298);
      DAT_a1702c94 = uVar2 >> 8;
      uVar2 = matched_FUN_a0506418((uint)DAT_a1702c50 * DAT_a0757a54 * DAT_a1702ca8,DAT_a170429c);
      DAT_a1702c98 = uVar2 >> 8;
    }
    DAT_a0757ac0 = (uint)DAT_a170ab1a + DAT_a170aee0 + -1;
    DAT_a170ab1a = 0;
    DAT_a170aee0 = 0;
    DAT_a170b36c = 0;
    DAT_a170b370 = 0;
    DAT_a170b374 = 0;
    DAT_a170b378 = 0;
    DAT_a170ab48 = 0;
    DAT_a170ab44 = 0;
    DAT_a170b380 = 0;
    DAT_a170b37c = 0;
  }
  DAT_a170422c = DAT_a170ab60 - DAT_a170ab5c;
  DAT_a1704230 = DAT_a170ab60 - DAT_a1704308;
  if (DAT_a170404d + DAT_a170b384 < DAT_a170ab60) {
    if (DAT_a0757b08 != 0) {
      uVar2 = FUN_a02a70ec(s____Time_shift_>__d___d__DiffTime_a05fff84,DAT_a170404d,
                           DAT_a170ab60 - DAT_a170b384,DAT_a170422c);
    }
    DAT_a170b388 = ((char)DAT_a170ab60 - (DAT_a170404d + (char)DAT_a170b384)) + DAT_a170b388;
    DAT_a170b38c = DAT_a170422c;
  }
  else if (DAT_a170ab60 < DAT_a170404d + DAT_a170b384) {
    if (DAT_a0757b08 != 0) {
      uVar2 = FUN_a02a70ec(s__s___Time_shift_<__d_(_d)_DiffTi_a05fffac,DAT_a06f3084,DAT_a170404d,
                           DAT_a170ab60 - DAT_a170b384,DAT_a170422c);
    }
    if (DAT_a170b388 != '\0') {
      DAT_a170b388 = DAT_a170b388 + -1;
    }
    if (DAT_a170b388 != '\0') {
      if (DAT_a0757b0c != 0) {
        uVar2 = FUN_a02a70ec(s_____Gyro_sample_loss____d___Diff_a05fffd8,DAT_a170b388,DAT_a170b38c);
      }
      DAT_a170b388 = '\0';
    }
  }
  DAT_a170b384 = DAT_a170ab60;
  if (DAT_a17045da == '\0') {
    uVar2 = matched_FUN_a02c61d4(&DAT_a170afc8,0);
    if ((DAT_a170afe8 == 0xffffffff) || (DAT_a170afe8 == 0xdeadbeef)) {
      if ((DAT_a0757b16 & 2) != 0) {
        uVar2 = FUN_a02a70ec(s_current_UpdateInfo_ArmSysTime__0_a0600228,DAT_a170afe8,DAT_a170b394);
      }
    }
    else {
      if ((uint)((int)((uint)DAT_a1702c50 * 3) >> 1) < DAT_a1702c40 - DAT_a170b390) {
        if (DAT_a0757af8 != 0) {
          FUN_a02a70ec(s_ArmSysTim_was_not_updated__dms__f_a0600014,DAT_a1702c40 - DAT_a170b390,
                       DAT_a1702c50);
        }
      }
      else if ((DAT_a1702c40 - DAT_a170b390 < (uint)(DAT_a1702c50 >> 1)) && (DAT_a0757af8 != 0)) {
        FUN_a02a70ec(s__sDuplicated_ArmSysTim_update__d_a0600044,DAT_a06f3080,
                     DAT_a1702c40 - DAT_a170b390,DAT_a1702c50);
      }
      DAT_a170afb9 = 0;
      DAT_a170afb8 = '\0';
      DAT_a170afc0 = DAT_a170afe8 & 0xff;
      DAT_a170afc4 = (ushort)DAT_a170afe8 & 0x100;
      if ((DAT_a0757b16 & 1) != 0) {
        FUN_a02a70ec(s______update_ArmSysTim___0x_x_pre_a0600078,DAT_a170afe8,DAT_a170b394,
                     DAT_a170422c);
      }
      if (((DAT_a17045d7 == '\0') && (DAT_a17045d9 == '\0')) && (DAT_a17045dc == '\0')) {
        DAT_a17045d5 = '\0';
      }
      else {
        DAT_a17045d5 = '\x01';
      }
      if (((DAT_a170afc4 == 0) && (DAT_a17045d4 == '\0')) &&
         ((DAT_a17045d5 != '\0' && (DAT_a0757af8 != 0)))) {
        FUN_a02a70ec(s__EIS__Warp_content_not_ready_las_a06000cc,DAT_a170afc0,0,DAT_a0757a51,
                     (int)DAT_a170422b);
      }
      if ((DAT_a0757af8 & 2) != 0) {
        FUN_a02a70ec(s_Spf_ArmSysTim___d__Spf_0___d___A_a0600130,(&DAT_a170af98)[DAT_a170afc0],
                     DAT_a170af98,DAT_a170afc0,(int)(char)DAT_a1704228 + DAT_a170afc0 * DAT_a170404d
                     ,DAT_a170afc4,DAT_a170aee4,DAT_a170aefc);
      }
      if ((DAT_a0757af8 != 0) &&
         ((uint)((int)((uint)DAT_a1702c50 * 3) >> 1) < (uint)(byte)(&DAT_a170af98)[DAT_a170afc0])) {
        FUN_a02a70ec(s__sError_here__Spf_ArmSysTim___d___a060018c,DAT_a06f3080,
                     (&DAT_a170af98)[DAT_a170afc0],DAT_a170af98,DAT_a170afc0,
                     (int)(char)DAT_a1704228 + DAT_a170afc0 * DAT_a170404d,DAT_a170aee4,DAT_a170aefc
                    );
      }
      DAT_a170afe8 = 0xdeadbeef;
      uVar2 = matched_FUN_a02c61d4(&DAT_a170afc8,1);
      DAT_a170b390 = DAT_a1702c40;
      if (DAT_a170b398 != '\0') {
        DAT_a170b39c = DAT_a170afc0;
        DAT_a17042a0 = (&DAT_a170b3a4)[DAT_a170afc0 * 6] - DAT_a17042d0;
        DAT_a17042a4 = (&DAT_a170b3a8)[DAT_a170afc0 * 6] - DAT_a17042d4;
        if (((0 < DAT_a17042a4) && ((int)(&DAT_a170b3b4)[DAT_a170afc0 * 6] < 0)) ||
           ((DAT_a17042a4 < 0 && (0 < (int)(&DAT_a170b3b4)[DAT_a170afc0 * 6])))) {
          if (DAT_a1702cb9 == '\0') {
            FUN_a02a70ec(s_sensor_vflip_detected____d__d_a06001e8,DAT_a17042a4,
                         (&DAT_a170b3b4)[DAT_a170afc0 * 6]);
          }
          DAT_a1702cb9 = '\x01';
        }
        if ((DAT_a1702cb9 != '\0') || (DAT_a1702cba != '\0')) {
          DAT_a17042a4 = -DAT_a17042a4;
        }
        uVar2 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a03882f0) + 0.5,3);
        DAT_a170b9a0 = (byte)((((uint)DAT_a17045c4 + (DAT_a17042a4 >> 0x10) + DAT_a17040c4) * uVar2)
                             / 1000000);
        if (DAT_a0757b18 != 0) {
          uVar2 = FUN_a02a70ec(s_EisOffsetInfo_MovX__d__d___d__a0600208,DAT_a17042a0,DAT_a17042a0,
                               DAT_a170b39c);
        }
        if (DAT_a170b9a0 < DAT_a170b9a1) {
          DAT_a170b9a0 = DAT_a170b9a1;
        }
        DAT_a170ab64 = DAT_a170b9a0 + DAT_a17040c0;
        if (DAT_a1704226 == -1) {
          DAT_a17042a0 = (uint)DAT_a1704224 * DAT_a17042a0;
        }
        else {
          DAT_a17042a0 = DAT_a17042a0 << DAT_a1704226;
        }
        if (DAT_a1704227 == 0xff) {
          DAT_a17042a4 = (uint)DAT_a1704225 * DAT_a17042a4;
        }
        else {
          DAT_a17042a4 = DAT_a17042a4 << DAT_a1704227;
        }
        DAT_a170aee4 = (&DAT_a170b3ac)[DAT_a170b39c * 6];
        DAT_a170aefc = (&DAT_a170b3b0)[DAT_a170b39c * 6];
        if (DAT_a17045da == '\0') {
          uVar2 = matched_FUN_a0506418(DAT_a170ab24 * DAT_a1704264,DAT_a1704134);
          DAT_a170af2c = (((uint)DAT_a0757a50 + (uint)DAT_a170b9a0 + uVar2 / 0x200 + DAT_a17040c0) -
                         (int)(char)DAT_a170422a) - (DAT_a170ab20 + 1) / 2;
          if (DAT_a170af2c < 0x19) {
            if (DAT_a170af2c < 0x10) {
              local_2c = 0x10;
            }
            else {
              local_2c = DAT_a170af2c;
            }
          }
          else {
            local_2c = 0x18;
          }
          dVar12 = (double)VectorSignedToFloat(local_2c + -0x10,(byte)(in_fpscr >> 0x16) & 3);
          DAT_a0757acc = (float)(1.0 - (dVar12 * DAT_a0388650) / 8.0);
        }
      }
    }
    DAT_a170b394 = DAT_a170afe8;
  }
  DAT_a170ab1c = 0;
  if ((DAT_a170ab15 == '\0') && (DAT_a170ab19 != '\0')) {
    DAT_a170ab1c = 2;
  }
  if (((DAT_a170ab15 != '\0') && (DAT_a170ab16 != '\0')) || (DAT_a170ab1c != 0)) {
    if (((DAT_a17045da == '\0') || (DAT_a170422c < (uint)(int)(char)DAT_a1704228)) ||
       ((uint)(int)(char)DAT_a1704229 < DAT_a170422c)) {
      if ((((char)DAT_a1704228 < (char)DAT_a1704229) &&
          ((uint)(int)(char)DAT_a1704228 <= DAT_a170422c)) &&
         (DAT_a170422c <= (uint)(int)(char)DAT_a1704229)) {
        DAT_a170ab1c = DAT_a170ab1c | 1;
        DAT_a170ab1b = DAT_a170ab1b + 1;
        DAT_a170b9a2 = '\0';
        if (DAT_a17045ac < '\x01') {
          DAT_a170ab34 = DAT_a170ab28;
        }
        else {
          DAT_a170ab34 = DAT_a170ab2c;
        }
      }
      else if (((char)DAT_a1704229 < (char)DAT_a1704228) &&
              (((uint)(int)(char)DAT_a1704228 <= DAT_a170422c ||
               (DAT_a170422c <= (uint)(int)(char)DAT_a1704229)))) {
        if (DAT_a170422c < (uint)(int)(char)DAT_a1704228) {
          if (DAT_a170422c <= (uint)(int)(char)DAT_a1704229) {
            DAT_a170ab1c = DAT_a170ab1c | 1;
            DAT_a170ab1b = DAT_a170ab1b + 1;
            DAT_a170b9a2 = '\0';
            DAT_a170ab34 = DAT_a170ab2c;
          }
        }
        else {
          DAT_a170ab1c = DAT_a170ab1c | 1;
          DAT_a170ab1b = DAT_a170ab1b + 1;
          DAT_a170b9a2 = '\0';
          DAT_a170ab34 = DAT_a170ab28;
        }
      }
      else {
        DAT_a170b9a2 = DAT_a170b9a2 + '\x01';
        DAT_a170ab1b = 0;
        DAT_a170ab1e = '\0';
      }
    }
    else {
      DAT_a170ab1c = DAT_a170ab1c | 1;
      DAT_a170ab1b = DAT_a170ab1b + 1;
      DAT_a170b9a2 = '\0';
      if (DAT_a17045ac < '\x01') {
        DAT_a170ab34 = DAT_a170ab28;
      }
      else {
        DAT_a170ab34 = DAT_a170ab2c;
      }
    }
    if ((0x3f < DAT_a170ab1b) && (DAT_a170ab1b = 0x40, (DAT_a0757b2c & 1) != 0)) {
      uVar2 = FUN_a02a70ec(s_UpdateEisStatusDo_exceeds_max_nu_a0600270,0x40);
    }
    if ((DAT_a0757b2c & 2) != 0) {
      uVar2 = FUN_a02a70ec(s_UpdateEisStatusDo__d__DiffTime___a060029c,DAT_a170ab1b,DAT_a170422c,
                           (int)(char)DAT_a1704228,(int)(char)DAT_a1704229);
    }
  }
  if ((DAT_a170ab1c & 1) == 0) {
    if (DAT_a170b9a2 == '\x01') {
      DAT_a1702f20 = DAT_a170ab3c;
    }
  }
  else {
    local_45 = (DAT_a170ab1c & 2) != 0;
    if (DAT_a170ab1b == 1) {
      DAT_a1702f1c = DAT_a170b9a4;
      DAT_a170b9a4 = DAT_a170ab38;
      if (DAT_a0757b40 == 0) {
        if (DAT_a1704227 == 0xff) {
          iVar10 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a0388e6c) + 0.5,3);
          iVar7 = (uint)DAT_a17045c4 + DAT_a17040c4;
          iVar9 = matched_FUN_a0506690(DAT_a17042a4,DAT_a1704225);
          DAT_a1704270 = (uint)((iVar7 + (iVar9 >> 0x10)) * iVar10) / 1000000 + DAT_a17040c0 +
                         (int)DAT_a1702cd4 + (int)DAT_a0757ab0;
        }
        else {
          iVar9 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a0388e6c) + 0.5,3);
          DAT_a1704270 = (((uint)DAT_a17045c4 + DAT_a17040c4 +
                          (DAT_a17042a4 >> (DAT_a1704227 + 0x10 & 0xff))) * iVar9) / 1000000 +
                         DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0;
        }
      }
      else if (DAT_a1704227 == 0xff) {
        iVar10 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a0388658) + 0.5,3);
        iVar7 = (uint)DAT_a17045c4 + DAT_a17040c4;
        iVar9 = matched_FUN_a0506690(DAT_a17042a4,DAT_a1704225);
        DAT_a1704270 = (uint)((iVar7 - (iVar9 >> 0x10)) * iVar10) / 1000000 + DAT_a17040c0 +
                       (int)DAT_a1702cd4 + (int)DAT_a0757ab0;
      }
      else {
        iVar9 = VectorFloatToUnsigned((double)(DAT_a1704140 * DAT_a0388e6c) + 0.5,3);
        DAT_a1704270 = ((((uint)DAT_a17045c4 + DAT_a17040c4) -
                        (DAT_a17042a4 >> (DAT_a1704227 + 0x10 & 0xff))) * iVar9) / 1000000 +
                       DAT_a17040c0 + (int)DAT_a1702cd4 + (int)DAT_a0757ab0;
      }
      if (DAT_a0757b14 != 0) {
        FUN_a02a70ec(s_GyroSampleOffset__d___d___Exposu_a06002c8,
                     DAT_a1704270 - (uint)(DAT_a170ab20 >> 1),DAT_a1704270,DAT_a170ab20);
      }
      DAT_a1704270 = DAT_a1704270 - ((int)(DAT_a170ab20 + 1) >> 1);
      if (DAT_a17045da == '\0') {
        if ('\0' < DAT_a17045ac) {
          DAT_a1704270 = DAT_a1704270 - DAT_a17045ac;
        }
      }
      else {
        DAT_a1704270 = (uint)DAT_a1702c50 * -2 + DAT_a1704270;
      }
      if ((int)DAT_a1702f1c < DAT_a1702f20) {
        iVar9 = DAT_a1702f20 - DAT_a1702f1c;
      }
      else {
        iVar9 = (DAT_a1702f20 + DAT_a1702f10) - DAT_a1702f1c;
      }
      DAT_a170b9a8 = iVar9 + 1;
      DAT_a170b9ac = (DAT_a17042a0 >> 8) * (int)DAT_a1702ccb;
      DAT_a170b9b0 = (DAT_a17042a4 >> 8) * (int)DAT_a1702ccc;
      for (DAT_a170ab40 = 0; DAT_a170ab40 < DAT_a170b9a8; DAT_a170ab40 = DAT_a170ab40 + 1) {
        DAT_a170ab4c = DAT_a1702f1c + DAT_a170ab40;
        if (DAT_a1702f10 <= DAT_a170ab4c) {
          DAT_a170ab4c = DAT_a170ab4c - DAT_a1702f10;
        }
        *(int *)(&DAT_a1702d00 + (DAT_a170ab4c + 0x336) * 4) = DAT_a170b9ac;
        *(int *)(&DAT_a1702d00 + (DAT_a170ab4c + 0x3bf) * 4) = DAT_a170b9b0;
      }
      DAT_a170af04 = DAT_a170aee4;
    }
    else if ((DAT_a17045d9 != '\0') && (1 < DAT_a170ab1b)) goto LAB_a038b318;
    iVar9 = DAT_a1704264;
    matched_FUN_a037c5a4
              (&DAT_a1702d00,DAT_a170ab34,DAT_a170ab38,DAT_a170ab20,&DAT_a170b9ac,DAT_a170ab18,
               DAT_a1704134,DAT_a1704264,&DAT_a17042a0,&DAT_a17042a8,local_45,DAT_a170ab24);
    DAT_a170afb9 = 1;
    if (DAT_a170ab74 != 0) {
      if ((DAT_a17042a0 < 1) || (1 << (DAT_a170ab74 + 0xf & 0xff) <= DAT_a17042a0)) {
        if ((DAT_a17042a0 < 0) && (-1 << (DAT_a170ab74 + 0xf & 0xff) < DAT_a17042a0)) {
          DAT_a17042a0 = 0;
        }
      }
      else {
        DAT_a17042a0 = 0;
      }
    }
    if (DAT_a0757ab8 != 0) {
      if ((DAT_a17042a4 < 1) || (1 << (DAT_a0757ab8 + 0xf & 0xff) <= DAT_a17042a4)) {
        if ((DAT_a17042a4 < 0) && (-1 << (DAT_a0757ab8 + 0xf & 0xff) < DAT_a17042a4)) {
          DAT_a17042a4 = 0;
        }
      }
      else {
        DAT_a17042a4 = 0;
      }
    }
    if (DAT_a170ab1b == 1) {
      matched_FUN_a0384ac4();
    }
    uVar2 = matched_FUN_a0384b94();
    if (DAT_a170af2a != '\0') {
      DAT_a17042a0 = 0;
      DAT_a17042a4 = 0;
    }
    if (local_45 == '\0') {
      if (DAT_a1702ccb == -1) {
        DAT_a17042a0 = -DAT_a17042a0;
        DAT_a17042a8 = -DAT_a17042a8;
        DAT_a170b9ac = -DAT_a170b9ac;
      }
      if (DAT_a1702ccc == -1) {
        DAT_a17042a4 = -DAT_a17042a4;
        DAT_a170b9b0 = -DAT_a170b9b0;
        if (DAT_a170ab18 == '\0') {
          DAT_a17042ac = -DAT_a17042ac;
        }
      }
      if (DAT_a17045da == '\0') {
        warp_get(local_74,&DAT_a1704640);
        FUN_a02da030(local_74,&DAT_a1704564);
        DAT_a0757a7c = matched_FUN_a0506f38(0,DAT_a17045a0,DAT_a1704598 - DAT_a1704590,0);
        DAT_a0757a78 = matched_FUN_a0506f38(0,DAT_a170459c,DAT_a1704594 - DAT_a170458c,0);
        FUN_a02da0e8(local_74,&DAT_a1704400);
        DAT_a1704414 = DAT_a1704564;
        DAT_a1704418 = DAT_a1704568;
        DAT_a1704424 = DAT_a17046c4;
        DAT_a1704428 = DAT_a17046c8;
        DAT_a1704454 = DAT_a17045b0;
        DAT_a1704458 = DAT_a17045b4;
        DAT_a170445c = DAT_a17045b8;
        DAT_a1704460 = DAT_a17045bc;
        if (DAT_a170ab17 == '\0') {
          DAT_a17042ac = 0;
          DAT_a17042a8 = 0;
        }
        if (DAT_a1704226 == -1) {
          DAT_a170441c = matched_FUN_a0506690(DAT_a17042a0,DAT_a1704224);
          DAT_a170444c = matched_FUN_a0506690(DAT_a17042a8,DAT_a1704224);
        }
        else {
          DAT_a170441c = DAT_a17042a0 >> DAT_a1704226;
          DAT_a170444c = DAT_a17042a8 >> DAT_a1704226;
        }
        DAT_a170aeb8 = DAT_a170441c;
        if (DAT_a0757b12 != 0) {
          DAT_a170444c = (uint)DAT_a0757b12;
        }
        DAT_a1704450 = 0;
        if (DAT_a1704227 == 0xff) {
          DAT_a1704420 = matched_FUN_a0506690(DAT_a17042a4,DAT_a1704225);
        }
        else {
          DAT_a1704420 = DAT_a17042a4 >> DAT_a1704227;
        }
        DAT_a170aebc = DAT_a1704420;
        if (DAT_a0757a64 != 0) {
          DAT_a170b9b4 = DAT_a170441c;
          DAT_a170b9b8 = DAT_a1704420;
        }
        DAT_a170441c = DAT_a170b9b4;
        DAT_a1704420 = DAT_a170b9b8;
        if (DAT_a0757a6c == 0) {
          DAT_a170441c = DAT_a170b9bc;
          DAT_a1704420 = DAT_a170b9c0;
          DAT_a170b9bc = DAT_a0757b58 * 0x10000 + DAT_a170b9bc;
          DAT_a170b9c0 = DAT_a0757b5c * 0x10000 + DAT_a170b9c0;
          if ((int)DAT_a170b9bc < 0x640001) {
            if ((int)DAT_a170b9bc < -0x640000) {
              DAT_a0757b58 = 1;
            }
          }
          else {
            DAT_a0757b58 = -1;
          }
          if ((int)DAT_a170b9c0 < 0x320001) {
            if ((int)DAT_a170b9c0 < -0x320000) {
              DAT_a0757b5c = 1;
            }
          }
          else {
            DAT_a0757b5c = -1;
          }
        }
        if ((DAT_a0757b1c != 0) && (DAT_a170ab1b == 1)) {
          FUN_a02a70ec(s_______________pCalcWinInfo_______a06002f4);
          FUN_a02a70ec(s_pCalcWinInfo_VinSensorGeo_StartX_a0600320,DAT_a1704400);
          FUN_a02a70ec(s_pCalcWinInfo_VinSensorGeo_StartY_a0600348,DAT_a1704404);
          FUN_a02a70ec(s_pCalcWinInfo_VinSensorGeo_Width___a0600370,DAT_a1704408);
          FUN_a02a70ec(s_pCalcWinInfo_VinSensorGeo_Height_a0600398,DAT_a170440c);
          FUN_a02a70ec(s_pCalcWinInfo_DzoomInfo_ZoomX___0_a06003c0,DAT_a1704414);
          FUN_a02a70ec(s_pCalcWinInfo_DzoomInfo_ZoomY___0_a06003e8,DAT_a1704418);
          FUN_a02a70ec(s_pCalcWinInfo_DzoomInfo_ShiftX_____a0600410,DAT_a170441c);
          FUN_a02a70ec(s_pCalcWinInfo_DzoomInfo_ShiftY_____a0600438,DAT_a1704420);
          FUN_a02a70ec(s_pCalcWinInfo_OutWinInfo_MainWinD_a060045c,DAT_a1704424);
          FUN_a02a70ec(s_pCalcWinInfo_OutWinInfo_MainWinD_a060048c,DAT_a1704428);
          FUN_a02a70ec(s_pCalcWinInfo_EisInfo_HorSkewPhas_a06004bc,DAT_a170444c);
          FUN_a02a70ec(s_pCalcWinInfo_EisInfo_VerSkewPhas_a06004e8,DAT_a1704450);
          FUN_a02a70ec(s_pCalcWinInfo_DmyRange_Left____d_a0600514,DAT_a1704454);
          FUN_a02a70ec(s_pCalcWinInfo_DmyRange_Right____d_a0600538,DAT_a1704458);
          FUN_a02a70ec(s_pCalcWinInfo_DmyRange_Top____d_a060055c,DAT_a170445c);
          FUN_a02a70ec(s_pCalcWinInfo_DmyRange_Bottom_____a060057c,DAT_a1704460);
        }
        if ((DAT_a17045d7 == '\0') && (DAT_a17045d9 == '\0')) {
          DAT_a1704464 = 0;
        }
        else {
          DAT_a1704464 = 1;
        }
        DAT_a1704468 = 0;
        DAT_a170446c = 0;
        if (((DAT_a17045db & 1) != 0) && (DAT_a170ab1e != '\0')) {
          DAT_a1704468 = 1;
          DAT_a170446c = DAT_a17043fc;
        }
        FUN_a02d9c84(local_74,&DAT_a1704400);
        FUN_a02d9900(local_74,DAT_a0388e70);
        if ((DAT_a0757b1c != 0) && (DAT_a170ab1b == 1)) {
          FUN_a02a70ec(s_______________pCalcWinInfo_______a06002f4);
          FUN_a02a70ec(s_pCalcWinInfo_ActWinCrop_LeftTopX_a06005a0,DAT_a1704488);
          FUN_a02a70ec(s_pCalcWinInfo_ActWinCrop_LeftTopY_a06005c8,DAT_a170448c);
          FUN_a02a70ec(s_pCalcWinInfo_ActWinCrop_RightBot_a06005f0,DAT_a1704490);
          FUN_a02a70ec(s_pCalcWinInfo_ActWinCrop_RightBot_a0600618,DAT_a1704494);
          FUN_a02a70ec(s_pCalcWinInfo_DmyWinGeo_StartX_____a0600640,DAT_a1704470);
          FUN_a02a70ec(s_pCalcWinInfo_DmyWinGeo_StartY_____a0600664,DAT_a1704474);
          FUN_a02a70ec(s_pCalcWinInfo_DmyWinGeo_Width_____a0600688,DAT_a1704478);
          FUN_a02a70ec(s_pCalcWinInfo_DmyWinGeo_Height_____a06006ac,DAT_a170447c);
        }
        if (DAT_a0757b3c == 0) {
          DAT_a1704320 = 0;
        }
        else {
          DAT_a1704320 = DAT_a170444c;
        }
        if (DAT_a170ab18 == '\0') {
          DAT_a1704324 = matched_FUN_a0506f38(0,DAT_a17040bc,DAT_a1704598 - DAT_a1704590,0);
        }
        else {
          DAT_a1704324 = DAT_a0757a7c;
        }
        _DAT_a1704328 = CONCAT22((short)DAT_a1704474,(short)DAT_a1704470);
        _DAT_a170432c = 0;
        DAT_a1704330 = DAT_a170ab1b - 1;
        (&DAT_a170b3a0)[(DAT_a170ab1b - 1) * 6] = DAT_a170422c;
        (&DAT_a170b3a4)[(DAT_a170ab1b - 1) * 6] = DAT_a1704488;
        (&DAT_a170b3a8)[(DAT_a170ab1b - 1) * 6] = DAT_a170448c;
        (&DAT_a170b3ac)[(DAT_a170ab1b - 1) * 6] = DAT_a170aeac;
        (&DAT_a170b3b0)[(DAT_a170ab1b - 1) * 6] = DAT_a170af00;
        (&DAT_a170b3b4)[(DAT_a170ab1b - 1) * 6] = DAT_a1704420;
        if (DAT_a0757b1a != 0) {
          FUN_a02a70ec(s_update_eis_status_do____d__d__d___a06006d0,DAT_a170ab1b,DAT_a170ab1d,
                       DAT_a170422c,(int)(char)DAT_a1704228,(int)(char)DAT_a1704229);
        }
        if (DAT_a170b398 == '\0') {
          DAT_a170b398 = '\x01';
        }
        DAT_a1704348 = DAT_a1704488 + DAT_a1704470 * -0x10000;
        DAT_a170434c = DAT_a170448c + DAT_a1704474 * -0x10000;
        DAT_a1704350 = DAT_a1704490 + DAT_a1704470 * -0x10000;
        DAT_a1704354 = DAT_a1704494 + DAT_a1704474 * -0x10000;
        DAT_a1704358 = DAT_a1704320;
        DAT_a170435c = DAT_a1704324;
        DAT_a1704360 = _DAT_a1704328;
        DAT_a1704364 = _DAT_a170432c;
        DAT_a1704368 = DAT_a1704330;
        DAT_a170436c = DAT_a1704334;
        DAT_a1704370 = _DAT_a1704338;
        DAT_a1704374 = DAT_a170433c;
        DAT_a1704378 = DAT_a1704340;
        DAT_a170437c = _DAT_a1704344;
        DAT_a1704314 = DAT_a170434c;
        DAT_a170431c = DAT_a1704354;
        if (DAT_a1704464 == 1) {
          DAT_a17043bc = DAT_a170449c + DAT_a1704474 * -0x10000;
          DAT_a17043c4 = DAT_a17044a4 + DAT_a1704474 * -0x10000;
          DAT_a17043c8 = DAT_a1704320;
          DAT_a17043cc = DAT_a1704324;
          DAT_a17043d0 = _DAT_a1704328;
          DAT_a17043d4 = _DAT_a170432c;
          DAT_a17043d8 = DAT_a1704330;
          DAT_a17043dc = DAT_a1704334;
          DAT_a17043e0 = _DAT_a1704338;
          DAT_a17043e4 = DAT_a170433c;
          DAT_a17043e8 = DAT_a1704340;
          DAT_a17043ec = _DAT_a1704344;
          DAT_a1704314 = DAT_a17043bc;
          DAT_a170431c = DAT_a17043c4;
          DAT_a17043b8 = DAT_a1704348;
          DAT_a17043c0 = DAT_a1704350;
          if (((DAT_a17045db & 2) != 0) && (DAT_a170ab1e != '\0')) {
            DAT_a170b9c4 = DAT_a170434c - DAT_a1704384;
            DAT_a170b9c8 = _DAT_a1704328 >> 0x10;
            if (DAT_a170434c < DAT_a1704384) {
              DAT_a170b9c8 = DAT_a170b9c8 - 2;
              DAT_a170b9c4 = DAT_a170b9c4 + 0x20000;
            }
            DAT_a1704314 = DAT_a17043bc + DAT_a170b9c4;
            DAT_a170431c = DAT_a17043c4 + DAT_a170b9c4;
            _DAT_a1704328 = CONCAT22((short)DAT_a170b9c8,DAT_a1704328);
          }
        }
        DAT_a1704310 = DAT_a1704348;
        DAT_a1704318 = DAT_a1704350;
        if (DAT_a17045d9 != '\0') {
          DAT_a1704310 = DAT_a170458c + DAT_a1704574 * -0x10000 + DAT_a170b9cc;
          DAT_a1704314 = DAT_a1704590 + DAT_a1704578 * -0x10000;
          DAT_a1704318 = DAT_a1704594 + DAT_a1704574 * -0x10000 + DAT_a170b9d0;
          DAT_a170431c = DAT_a1704598 + DAT_a1704578 * -0x10000;
          if (DAT_a1704464 == 1) {
            DAT_a1704314 = 0;
            DAT_a170431c = DAT_a1704580 << 0x10;
          }
          _DAT_a1704328 = CONCAT22((short)DAT_a1704578 + (short)DAT_a170b9c8,(short)DAT_a1704574);
          DAT_a1704320 = 0;
        }
        if (DAT_a170afb8 == '\0') {
          DAT_a1704334 = 0;
        }
        else {
          DAT_a1704330 = DAT_a1704330 | 0x100;
          if (DAT_a0757b06 != 0) {
            DAT_a1704334 = 0;
          }
        }
        if ((DAT_a0757afc == 1) && (DAT_a170ab1b == 1)) {
          uVar2 = FUN_a02a70ec(s_actual_win___d__d__d__d___d__d___a06006f8,DAT_a1704310 >> 0x10,
                               DAT_a1704314 >> 0x10,DAT_a1704318 - DAT_a1704310 >> 0x10,
                               DAT_a170431c - DAT_a1704314 >> 0x10,_DAT_a1704328 & 0xffff,
                               DAT_a170432a,_DAT_a170432c & 0xffff,DAT_a170432e,DAT_a1704320,
                               (int)DAT_a170441c >> 0x10,(int)DAT_a1704420 >> 0x10,
                               (int)DAT_a170b9cc >> 0x10,(int)DAT_a170b9d0 >> 0x10,
                               (int)DAT_a170b9c8 >> 0x10,DAT_a17042d0 >> 0x10,DAT_a17042d4 >> 0x10);
        }
        else if ((DAT_a0757afc == 2) && (DAT_a170ab1b == 1)) {
          fVar11 = (float)VectorUnsignedToFloat(DAT_a170434c,(byte)(in_fpscr >> 0x16) & 3);
          uVar2 = FUN_a02a70ec(s_actual_win___10d__10d__4_2f___10_a060073c,DAT_a1704348,DAT_a170434c
                               ,DAT_a1704418,(double)(fVar11 / DAT_a038abbc),DAT_a1704350,
                               DAT_a1704354,_DAT_a1704328 & 0xffff,DAT_a170432a,
                               _DAT_a170432c & 0xffff,DAT_a170432e,DAT_a1704320,DAT_a170441c,
                               DAT_a1704420,(int)DAT_a170b9cc >> 0x10,(int)DAT_a170b9d0 >> 0x10,
                               (int)DAT_a170b9c8 >> 0x10,DAT_a1704414,DAT_a1704418);
        }
        else if ((DAT_a0757afc == 3) && (DAT_a170ab1e != '\0')) {
          uVar2 = FUN_a02a70ec(s_actual_win___d__d__d__d___d__d___a0600798,DAT_a1704310 >> 0x10,
                               DAT_a1704314 >> 0x10,DAT_a1704318 - DAT_a1704310 >> 0x10,
                               DAT_a170431c - DAT_a1704314 >> 0x10,_DAT_a1704328 & 0xffff,
                               DAT_a170432a,_DAT_a170432c & 0xffff,DAT_a170432e,DAT_a1704320,
                               (int)DAT_a170441c >> 0x10,(int)DAT_a1704420 >> 0x10,
                               DAT_a170b9cc >> 0x10,DAT_a170b9d0 >> 0x10,DAT_a170b9c8,DAT_a170b9c4,
                               DAT_a17042d0 >> 0x10,DAT_a17042d4 >> 0x10,DAT_a170ab1e,DAT_a170ab1b,
                               DAT_a170434c - DAT_a1704384,DAT_a1704398._2_2_);
        }
        else if ((DAT_a0757afc == 4) && (DAT_a170ab1e != '\0')) {
          dVar12 = (double)VectorUnsignedToFloat(DAT_a1704314,(byte)(in_fpscr >> 0x16) & 3);
          dVar16 = (double)VectorUnsignedToFloat(DAT_a170448c,(byte)(in_fpscr >> 0x16) & 3);
          dVar13 = (double)VectorUnsignedToFloat(DAT_a170449c,(byte)(in_fpscr >> 0x16) & 3);
          dVar14 = (double)VectorUnsignedToFloat(DAT_a170434c,(byte)(in_fpscr >> 0x16) & 3);
          dVar15 = (double)VectorUnsignedToFloat(DAT_a1704384,(byte)(in_fpscr >> 0x16) & 3);
          uVar2 = FUN_a02a70ec(s_actual_win___8x___4_4f__4_4f__4__a0600808,DAT_a1704310,
                               SUB84(dVar12 / DAT_a038adb8,0),
                               (int)((ulonglong)(dVar12 / DAT_a038adb8) >> 0x20),
                               dVar16 / DAT_a038adb8,dVar13 / DAT_a038adb8,dVar14 / DAT_a038adb8,
                               dVar15 / DAT_a038adb8,DAT_a1704318 - DAT_a1704310 >> 0x10,
                               DAT_a170431c - DAT_a1704314 >> 0x10,_DAT_a1704328 & 0xffff,
                               DAT_a170432a,_DAT_a170432c & 0xffff,DAT_a170432e,DAT_a1704320,
                               DAT_a1704420,DAT_a170446c,DAT_a17042d0,DAT_a17042d4,DAT_a170ab1e,
                               DAT_a170ab1b);
        }
        else if ((DAT_a0757afc == 5) && (DAT_a170ab1e != '\0')) {
          dVar12 = (double)VectorUnsignedToFloat(DAT_a1704314,(byte)(in_fpscr >> 0x16) & 3);
          dVar16 = (double)VectorUnsignedToFloat(DAT_a170431c,(byte)(in_fpscr >> 0x16) & 3);
          dVar13 = (double)VectorUnsignedToFloat(DAT_a170448c,(byte)(in_fpscr >> 0x16) & 3);
          dVar14 = (double)VectorUnsignedToFloat(DAT_a170449c,(byte)(in_fpscr >> 0x16) & 3);
          dVar15 = (double)VectorUnsignedToFloat(DAT_a17044a4,(byte)(in_fpscr >> 0x16) & 3);
          VectorUnsignedToFloat(DAT_a1704534,(byte)(in_fpscr >> 0x16) & 3);
          VectorUnsignedToFloat(DAT_a1704544,(byte)(in_fpscr >> 0x16) & 3);
          VectorUnsignedToFloat(DAT_a170454c,(byte)(in_fpscr >> 0x16) & 3);
          VectorUnsignedToFloat(DAT_a170434c,(byte)(in_fpscr >> 0x16) & 3);
          VectorUnsignedToFloat(DAT_a1704384,(byte)(in_fpscr >> 0x16) & 3);
          uVar2 = FUN_a02a70ec(s__8x___4_4f__4_4f__3d____4_4f__4__a0600874,DAT_a1704310,
                               SUB84(dVar12 / DAT_a038adb8,0),
                               (int)((ulonglong)(dVar12 / DAT_a038adb8) >> 0x20),
                               dVar16 / DAT_a038adb8,DAT_a170432a,iVar9,dVar13 / DAT_a038adb8,
                               dVar14 / DAT_a038adb8,dVar15 / DAT_a038adb8,DAT_a1704474);
        }
        else {
          uVar2 = DAT_a1704340;
          if ((DAT_a0757afc == 6) && (DAT_a170ab1e != '\0')) {
            dVar12 = (double)VectorUnsignedToFloat(DAT_a1704314,(byte)(in_fpscr >> 0x16) & 3);
            dVar16 = (double)VectorUnsignedToFloat(DAT_a170431c,(byte)(in_fpscr >> 0x16) & 3);
            dVar13 = (double)VectorUnsignedToFloat(DAT_a17043bc,(byte)(in_fpscr >> 0x16) & 3);
            dVar14 = (double)VectorUnsignedToFloat(DAT_a17043c4,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a170448c,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a170449c,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a17044a4,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a1704534,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a1704544,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a170454c,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a170434c,(byte)(in_fpscr >> 0x16) & 3);
            VectorUnsignedToFloat(DAT_a1704384,(byte)(in_fpscr >> 0x16) & 3);
            uVar2 = FUN_a02a70ec(s___4_4f__4_4f__3d____4_4f__4_4f___a06008f0,DAT_a1704420,
                                 SUB84(dVar12 / DAT_a038adb8,0),
                                 (int)((ulonglong)(dVar12 / DAT_a038adb8) >> 0x20),
                                 dVar16 / DAT_a038adb8,DAT_a170432a,iVar9,dVar13 / DAT_a038adb8,
                                 dVar14 / DAT_a038adb8,DAT_a17043d0 >> 0x10);
          }
        }
        if ((DAT_a17045da == '\0') && (DAT_a0757b34 == 0)) {
          uVar2 = FUN_a02c5fd8(&DAT_a1704310,1,DAT_a1704550);
        }
        else if (DAT_a0757b34 == 0x7b) {
          uVar2 = FUN_a02c5fd8(0,1,DAT_a1704550);
        }
      }
      else {
        if (DAT_a1704226 == -1) {
          uVar2 = matched_FUN_a0506690(DAT_a17042a0,DAT_a1704224);
          DAT_a170441c = uVar2;
        }
        else {
          DAT_a170441c = DAT_a17042a0 >> DAT_a1704226;
        }
        if (DAT_a1704227 == 0xff) {
          uVar2 = matched_FUN_a0506690(DAT_a17042a4,DAT_a1704225);
          DAT_a1704420 = uVar2;
        }
        else {
          DAT_a1704420 = DAT_a17042a4 >> DAT_a1704227;
        }
      }
    }
  }
LAB_a038b318:
  if (DAT_a17045da == '\0') {
    if ((((((DAT_a170ab15 == '\0') || (DAT_a170ab17 == '\0')) || (DAT_a170ab18 == '\0')) ||
         ((DAT_a0757a64 == 0 || (DAT_a0757a68 == 0)))) || (DAT_a0757b36 != 0)) ||
       (DAT_a170af2a != '\0')) {
      if (((DAT_a170ab15 != '\0') && (DAT_a170ab18 != '\0')) &&
         ((DAT_a0757a64 != 0 &&
          (((DAT_a0757b36 == 0 && (DAT_a170af2a == '\0')) && (DAT_a170b9d4 == '\0')))))) {
        DAT_a170b9d4 = '\x01';
        if (DAT_a170b370 < 0) {
          uVar2 = matched_FUN_a0383d80(0xffffffff,0xffffffff,0xff,0);
        }
        else {
          uVar2 = matched_FUN_a0383d80(0,0,0xff,0);
        }
      }
    }
    else {
      DAT_a170b9d4 = '\0';
      DAT_a170ab1a = DAT_a170ab1a + 1;
      if ((DAT_a170422c < DAT_a170ab64) || (DAT_a170ab68 < DAT_a170422c)) {
        DAT_a170ab1a = 0;
        DAT_a170aee0 = DAT_a170aee0 + 1;
      }
      if ((DAT_a170ab1a != 0) && (DAT_a170afe4 == 0)) {
        if (DAT_a170ab1a == 1) {
          DAT_a170af08 = DAT_a170aee4;
          DAT_a170af0c = DAT_a170aefc;
          DAT_a170b9d5 = 0;
          DAT_a170b9d8 = DAT_a17042a0 >> 8;
          if (DAT_a1702ccb == -1) {
            DAT_a170b9d8 = -DAT_a170b9d8;
          }
          iVar9 = matched_FUN_a0308b8c();
          if (iVar9 == 0) {
            local_4c = (undefined4 *)&DAT_70118000;
          }
          else {
            local_4c = (undefined4 *)&DAT_e8118000;
          }
          *local_4c = 0x2110;
          iVar9 = matched_FUN_a0308b8c();
          if (iVar9 == 0) {
            puVar6 = (uint *)&DAT_70110020;
          }
          else {
            puVar6 = (uint *)&DAT_e8110020;
          }
          local_50 = *puVar6 & 0xffff;
          iVar9 = matched_FUN_a0308b8c();
          if (iVar9 == 0) {
            puVar6 = (uint *)&DAT_7011001c;
          }
          else {
            puVar6 = (uint *)&DAT_e811001c;
          }
          local_54 = *puVar6 & 0xffff;
          *local_4c = 0x2120;
          iVar9 = matched_FUN_a0308b8c();
          if (iVar9 == 0) {
            puVar6 = (uint *)&DAT_70110020;
          }
          else {
            puVar6 = (uint *)&DAT_e8110020;
          }
          local_58 = *puVar6 & 0xffff;
          iVar9 = matched_FUN_a0308b8c();
          if (iVar9 == 0) {
            puVar6 = (uint *)&DAT_7011001c;
          }
          else {
            puVar6 = (uint *)&DAT_e811001c;
          }
          local_5c = *puVar6 & 0xffff;
          local_50 = local_50 & 0xffff;
          local_58 = local_58 & 0xffff;
          if (local_50 == 0) {
            DAT_a0757a60 = 100;
          }
          else {
            DAT_a0757a60 = matched_FUN_a0506690(local_58 * 100,local_50);
          }
        }
        if (DAT_a170404d < 2) {
          DAT_a170b9e0 = ((int)DAT_a1702cd4 + DAT_a170ab38 + (int)DAT_a0757ab0) -
                         ((int)(DAT_a170ab20 + 1) >> 1);
        }
        else {
          iVar9 = matched_FUN_a0506690
                            ((((int)DAT_a1702cd4 + (int)DAT_a0757ab0) -
                             ((int)(DAT_a170ab20 + 1) >> 1)) + (uint)(DAT_a170404d >> 1),
                             DAT_a170404d);
          DAT_a170b9e0 = iVar9 + DAT_a170ab38;
        }
        DAT_a170b9e0 = (int)DAT_a17045e8 + DAT_a170b9e0;
        DAT_a170af28 = ((DAT_a1702cd4 + DAT_a0757ab0) - (char)((int)(DAT_a170ab20 + 1) >> 1)) +
                       DAT_a17045e8;
        if (DAT_a170af28 < '\x01') {
          DAT_a170af28 = '\0';
        }
        if ((int)DAT_a170ab38 < (int)DAT_a170b9e0) {
          DAT_a170b9e0 = DAT_a170ab38;
        }
        else if ((int)DAT_a170b9e0 < 0) {
          DAT_a170b9e0 = DAT_a1702f10 + DAT_a170b9e0;
        }
        if (DAT_a0757ad0 < 10) {
          FUN_a02a70ec(s_AdjLastPtr____d_Index____d_a0600960,DAT_a170b9e0,DAT_a170ab38);
        }
        if (DAT_a170aef8 == '\x01') {
          if (DAT_a170b9d5 == 0) {
            local_2d = '\0';
            local_34 = 0;
            DAT_a170af18 = 0;
            if (DAT_a0757ad0 < 10) {
              FUN_a02a70ec(s_RscPreStartPtr__d_RscPreLastPtr__a0600980,DAT_a170af0c,DAT_a170af08);
            }
            cVar1 = (char)DAT_a170af08;
            if (DAT_a170af08 < DAT_a170af0c) {
              if ((DAT_a170af0c < DAT_a170b9e0) || (DAT_a170b9e0 <= DAT_a170af08)) {
                DAT_a170ab4c = 0;
              }
              else {
                local_2d = (char)DAT_a170b9e0 - cVar1;
                for (local_38 = 0; local_38 < local_2d + -1; local_38 = local_38 + 1) {
                  local_34 = DAT_a170af08 + local_38 + 1;
                  if (DAT_a1702f10 <= local_34) {
                    local_34 = local_34 - DAT_a1702f10;
                  }
                  DAT_a170af18 = (*(int *)(&DAT_a1702d00 + local_34 * 4) -
                                 *(int *)(&DAT_a1702d00 + (local_34 + 0x19b) * 4)) + DAT_a170af18;
                }
                iVar7 = *(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4);
                iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4);
                iVar9 = matched_FUN_a0506690(DAT_a170af18,DAT_a0757acb);
                DAT_a170ab4c = (iVar7 - iVar10) + iVar9;
              }
            }
            else if ((DAT_a170af0c < DAT_a170b9e0) && (DAT_a170b9e0 <= DAT_a170af08)) {
              DAT_a170ab4c = 0;
            }
            else {
              if (DAT_a170b9e0 < DAT_a170af08) {
                local_60 = DAT_a1702f10 + DAT_a170b9e0;
                local_2d = (char)local_60 - cVar1;
              }
              else {
                local_2d = (char)DAT_a170b9e0 - cVar1;
              }
              for (local_38 = 0; local_38 < local_2d + -1; local_38 = local_38 + 1) {
                local_34 = DAT_a170af08 + local_38 + 1;
                if (DAT_a1702f10 <= local_34) {
                  local_34 = local_34 - DAT_a1702f10;
                }
                DAT_a170af18 = (*(int *)(&DAT_a1702d00 + local_34 * 4) -
                               *(int *)(&DAT_a1702d00 + (local_34 + 0x19b) * 4)) + DAT_a170af18;
              }
              iVar7 = *(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4);
              iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4);
              iVar9 = matched_FUN_a0506690(DAT_a170af18,DAT_a0757acb);
              DAT_a170ab4c = (iVar7 - iVar10) + iVar9;
            }
          }
          else if (DAT_a170b9d5 < DAT_a0757acb) {
            if ((int)(uint)DAT_a170b9d5 < (int)DAT_a170af28) {
              DAT_a170af20 = 0;
            }
            else {
              local_3c = DAT_a170b9e0 - (int)DAT_a170af28;
              if (local_3c < 0) {
                local_3c = DAT_a1702f10 + local_3c;
              }
              DAT_a170af20 = (*(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4) -
                             *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4)) +
                             (*(int *)(&DAT_a1702d00 + (local_3c + 0x19b) * 4) -
                             *(int *)(&DAT_a1702d00 + local_3c * 4));
            }
            if (DAT_a170af08 < DAT_a170af0c) {
              if ((DAT_a170af0c < DAT_a170b9e0) || (DAT_a170b9e0 <= DAT_a170af08)) {
                DAT_a170ab4c = 0;
              }
              else {
                iVar7 = *(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4);
                iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4);
                iVar9 = matched_FUN_a0506690(DAT_a170af18,DAT_a0757acb);
                DAT_a170ab4c = (iVar7 - iVar10) + iVar9 + DAT_a170af20;
              }
            }
            else if ((DAT_a170af0c < DAT_a170b9e0) && (DAT_a170b9e0 <= DAT_a170af08)) {
              DAT_a170ab4c = 0;
            }
            else {
              iVar7 = *(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4);
              iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4);
              iVar9 = matched_FUN_a0506690(DAT_a170af18,DAT_a0757acb);
              DAT_a170ab4c = (iVar7 - iVar10) + iVar9 + DAT_a170af20;
            }
          }
          else {
            if ((int)(uint)DAT_a170b9d5 < (int)DAT_a170af28) {
              DAT_a170af20 = 0;
            }
            else {
              local_3c = DAT_a170b9e0 - (int)DAT_a170af28;
              if (local_3c < 0) {
                local_3c = DAT_a1702f10 + local_3c;
              }
              DAT_a170af20 = (*(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4) -
                             *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4)) +
                             (*(int *)(&DAT_a1702d00 + (local_3c + 0x19b) * 4) -
                             *(int *)(&DAT_a1702d00 + local_3c * 4));
            }
            if (DAT_a170af08 < DAT_a170af0c) {
              if ((DAT_a170af0c < DAT_a170b9e0) || (DAT_a170b9e0 <= DAT_a170af08)) {
                DAT_a170ab4c = 0;
              }
              else {
                DAT_a170ab4c = (*(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4) -
                               *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4)) + DAT_a170af20;
              }
            }
            else if ((DAT_a170af0c < DAT_a170b9e0) && (DAT_a170b9e0 <= DAT_a170af08)) {
              DAT_a170ab4c = 0;
            }
            else {
              DAT_a170ab4c = (*(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4) -
                             *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4)) + DAT_a170af20;
            }
          }
        }
        else {
          DAT_a170ab4c = *(int *)(&DAT_a1702d00 + DAT_a170b9e0 * 4) -
                         *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x19b) * 4);
        }
        DAT_a170aef0 = DAT_a170b9e0;
        DAT_a170af10 = DAT_a170ab4c;
        if ((DAT_a170ab44 == 0) || (DAT_a170b9e4 == 0)) {
          DAT_a170ab44 = matched_FUN_a037bcd8(0,DAT_a170ab4c,DAT_a170ab24);
          DAT_a170b9e4 = DAT_a170ab4c;
          DAT_a170b9ec = DAT_a170ab44;
        }
        else {
          DAT_a170b9e8 = '\x01';
          if ((int)DAT_a170ab4c < 0) {
            DAT_a170b9e8 = -1;
          }
          DAT_a170b9ec = (DAT_a170ab44 ^ (int)DAT_a170ab44 >> 0x1f) - ((int)DAT_a170ab44 >> 0x1f);
          uVar2 = DAT_a170ab4c;
          if ((int)DAT_a170ab4c < 0) {
            uVar2 = -DAT_a170ab4c;
          }
          uVar4 = DAT_a170b9e4;
          if ((int)DAT_a170b9e4 < 0) {
            uVar4 = -DAT_a170b9e4;
          }
          iVar9 = matched_FUN_a0506f38
                            ((int)((ulonglong)uVar2 * (ulonglong)DAT_a170b9ec),
                             uVar2 * ((int)DAT_a170b9ec >> 0x1f) +
                             DAT_a170b9ec * ((int)uVar2 >> 0x1f) +
                             (int)((ulonglong)uVar2 * (ulonglong)DAT_a170b9ec >> 0x20),uVar4,
                             (int)uVar4 >> 0x1f);
          DAT_a170b9ec = DAT_a170b9e8 * iVar9;
        }
        DAT_a170aef4 = DAT_a170b9ec;
        DAT_a170b9ec = (int)((int)DAT_a0757a86 * DAT_a170b9ec) / 100;
        DAT_a170b9f4 = matched_FUN_a0506690(DAT_a1704264 * DAT_a170b9ec,DAT_a1704134);
        if (DAT_a170b9d8 < 0) {
          DAT_a170b9fc = DAT_a17042b0 + DAT_a17042c0;
          DAT_a170ba04 = DAT_a17042b8 + DAT_a17042c8 + DAT_a170b9d8;
        }
        else {
          DAT_a170b9fc = (DAT_a17042b0 + DAT_a17042c0) - DAT_a170b9d8;
          DAT_a170ba04 = DAT_a17042b8 + DAT_a17042c8;
        }
        if (DAT_a170b9fc < (int)DAT_a170b9f4) {
          DAT_a170b9f4 = DAT_a170b9fc;
        }
        else if ((int)DAT_a170b9f4 < -DAT_a170ba04) {
          DAT_a170b9f4 = -DAT_a170ba04;
        }
        if (DAT_a1704226 == -1) {
          DAT_a170b9f4 = matched_FUN_a0506690(DAT_a170b9f4,DAT_a1704224);
        }
        else {
          DAT_a170b9f4 = (int)DAT_a170b9f4 >> DAT_a1704226;
        }
        DAT_a170b9f4 = matched_FUN_a0506690(DAT_a170b9f4 << 8,DAT_a1704264);
        DAT_a170b9e8 = '\x01';
        if ((int)DAT_a170b9f4 < 0) {
          DAT_a170b9f4 = -DAT_a170b9f4;
          DAT_a170b9e8 = -1;
        }
        DAT_a170b9f4 = matched_FUN_a0506f38
                                 ((int)((ulonglong)DAT_a170424c * (ulonglong)DAT_a170b9f4),
                                  DAT_a170424c * ((int)DAT_a170b9f4 >> 0x1f) +
                                  (int)((ulonglong)DAT_a170424c * (ulonglong)DAT_a170b9f4 >> 0x20),
                                  DAT_a1704250,0);
        if (DAT_a170b9e8 == -1) {
          DAT_a170b9f4 = -DAT_a170b9f4;
        }
        if (DAT_a1702ccb == -1) {
          DAT_a170b9f4 = -DAT_a170b9f4;
        }
        if (DAT_a1702cb0 != 0) {
          DAT_a170b9f4 = -DAT_a170b9f4;
        }
        DAT_a170ba0c = DAT_a170b37c;
        DAT_a170ba10 = DAT_a170b380;
        if (DAT_a0757ad0 < 10) {
          FUN_a02a70ec(s_PrevVSreg_0___d_PrevVSreg_1___d_a06009a4,DAT_a170b37c,DAT_a170b380);
        }
        uVar2 = matched_FUN_a0384454(DAT_a170b9f4,&DAT_a170b37c);
        if (uVar2 == 0) {
          if (DAT_a170aef8 == '\x01') {
            if (DAT_a170b9d5 == 0) {
              local_2d = '\0';
              local_34 = 0;
              DAT_a170af1c = 0;
              cVar1 = (char)DAT_a170af08;
              if (DAT_a170af08 < DAT_a170af0c) {
                if ((DAT_a170af0c < DAT_a170b9e0) || (DAT_a170b9e0 <= DAT_a170af08)) {
                  DAT_a170ab50 = 0;
                }
                else {
                  local_2d = (char)DAT_a170b9e0 - cVar1;
                  for (local_38 = 0; local_38 < local_2d + -1; local_38 = local_38 + 1) {
                    local_34 = DAT_a170af08 + local_38 + 1;
                    if (DAT_a1702f10 <= local_34) {
                      local_34 = local_34 - DAT_a1702f10;
                    }
                    DAT_a170af1c = (*(int *)(&DAT_a1702d00 + (local_34 + 0x89) * 4) -
                                   *(int *)(&DAT_a1702d00 + (local_34 + 0x224) * 4)) + DAT_a170af1c;
                  }
                  iVar7 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4);
                  iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4);
                  iVar9 = matched_FUN_a0506690(DAT_a170af1c,DAT_a0757acb);
                  DAT_a170ab50 = (iVar7 - iVar10) + iVar9;
                }
              }
              else if ((DAT_a170af0c < DAT_a170b9e0) && (DAT_a170b9e0 <= DAT_a170af08)) {
                DAT_a170ab50 = 0;
              }
              else {
                if (DAT_a170b9e0 < DAT_a170af08) {
                  local_60 = DAT_a1702f10 + DAT_a170b9e0;
                  local_2d = (char)local_60 - cVar1;
                }
                else {
                  local_2d = (char)DAT_a170b9e0 - cVar1;
                }
                for (local_38 = 0; local_38 < local_2d + -1; local_38 = local_38 + 1) {
                  local_34 = DAT_a170af08 + local_38 + 1;
                  if (DAT_a1702f10 <= local_34) {
                    local_34 = local_34 - DAT_a1702f10;
                  }
                  DAT_a170af1c = (*(int *)(&DAT_a1702d00 + (local_34 + 0x89) * 4) -
                                 *(int *)(&DAT_a1702d00 + (local_34 + 0x224) * 4)) + DAT_a170af1c;
                }
                iVar7 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4);
                iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4);
                iVar9 = matched_FUN_a0506690(DAT_a170af1c,DAT_a0757acb);
                DAT_a170ab50 = (iVar7 - iVar10) + iVar9;
              }
            }
            else if (DAT_a170b9d5 < DAT_a0757acb) {
              if ((int)(uint)DAT_a170b9d5 < (int)DAT_a170af28) {
                DAT_a170af24 = 0;
              }
              else {
                local_3c = DAT_a170b9e0 - (int)DAT_a170af28;
                if (local_3c < 0) {
                  local_3c = DAT_a1702f10 + local_3c;
                }
                DAT_a170af24 = (*(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4) -
                               *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4)) +
                               (*(int *)(&DAT_a1702d00 + (local_3c + 0x224) * 4) -
                               *(int *)(&DAT_a1702d00 + (local_3c + 0x89) * 4));
              }
              if (DAT_a170af08 < DAT_a170af0c) {
                if ((DAT_a170af0c < DAT_a170b9e0) || (DAT_a170b9e0 <= DAT_a170af08)) {
                  DAT_a170ab50 = 0;
                }
                else {
                  iVar7 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4);
                  iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4);
                  iVar9 = matched_FUN_a0506690(DAT_a170af1c,DAT_a0757acb);
                  DAT_a170ab50 = (iVar7 - iVar10) + iVar9 + DAT_a170af24;
                }
              }
              else if ((DAT_a170af0c < DAT_a170b9e0) && (DAT_a170b9e0 <= DAT_a170af08)) {
                DAT_a170ab50 = 0;
              }
              else {
                iVar7 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4);
                iVar10 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4);
                iVar9 = matched_FUN_a0506690(DAT_a170af1c,DAT_a0757acb);
                DAT_a170ab50 = (iVar7 - iVar10) + iVar9 + DAT_a170af24;
              }
            }
            else {
              if ((int)(uint)DAT_a170b9d5 < (int)DAT_a170af28) {
                DAT_a170af24 = 0;
              }
              else {
                local_3c = DAT_a170b9e0 - (int)DAT_a170af28;
                if (local_3c < 0) {
                  local_3c = DAT_a1702f10 + local_3c;
                }
                DAT_a170af24 = (*(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4) -
                               *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4)) +
                               (*(int *)(&DAT_a1702d00 + (local_3c + 0x224) * 4) -
                               *(int *)(&DAT_a1702d00 + (local_3c + 0x89) * 4));
              }
              if (DAT_a170af08 < DAT_a170af0c) {
                if ((DAT_a170af0c < DAT_a170b9e0) || (DAT_a170b9e0 <= DAT_a170af08)) {
                  DAT_a170ab50 = 0;
                }
                else {
                  DAT_a170ab50 = (*(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4) -
                                 *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4)) +
                                 DAT_a170af24;
                }
              }
              else if ((DAT_a170af0c < DAT_a170b9e0) && (DAT_a170b9e0 <= DAT_a170af08)) {
                DAT_a170ab50 = 0;
              }
              else {
                DAT_a170ab50 = (*(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4) -
                               *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4)) + DAT_a170af24;
              }
            }
          }
          else {
            DAT_a170ab50 = *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x89) * 4) -
                           *(int *)(&DAT_a1702d00 + (DAT_a170b9e0 + 0x224) * 4);
          }
          DAT_a170af14 = DAT_a170ab50;
          DAT_a170b9d5 = DAT_a170b9d5 + 1;
          if ((DAT_a170ab48 == 0) || (DAT_a170ba14 == 0)) {
            DAT_a170ab48 = matched_FUN_a037bcd8(1,DAT_a170ab50,DAT_a170ab24);
            DAT_a170ba14 = DAT_a170ab50;
            DAT_a170b9f0 = DAT_a170ab48;
          }
          else {
            DAT_a170b9e8 = '\x01';
            if ((int)DAT_a170ab50 < 0) {
              DAT_a170b9e8 = -1;
            }
            DAT_a170b9f0 = (DAT_a170ab48 ^ (int)DAT_a170ab48 >> 0x1f) - ((int)DAT_a170ab48 >> 0x1f);
            uVar2 = DAT_a170ab50;
            if ((int)DAT_a170ab50 < 0) {
              uVar2 = -DAT_a170ab50;
            }
            uVar4 = DAT_a170ba14;
            if ((int)DAT_a170ba14 < 0) {
              uVar4 = -DAT_a170ba14;
            }
            iVar9 = matched_FUN_a0506f38
                              ((int)((ulonglong)uVar2 * (ulonglong)DAT_a170b9f0),
                               uVar2 * ((int)DAT_a170b9f0 >> 0x1f) +
                               DAT_a170b9f0 * ((int)uVar2 >> 0x1f) +
                               (int)((ulonglong)uVar2 * (ulonglong)DAT_a170b9f0 >> 0x20),uVar4,
                               (int)uVar4 >> 0x1f);
            DAT_a170b9f0 = DAT_a170b9e8 * iVar9;
          }
          DAT_a170b9f0 = (int)((int)DAT_a0757a87 * DAT_a170b9f0) / 100;
          DAT_a170b9f8 = matched_FUN_a0506690(DAT_a1704264 * DAT_a170b9f0,DAT_a1704134);
          if (DAT_a17042c4 < DAT_a170b9f8) {
            DAT_a170b9f8 = DAT_a17042c4;
          }
          else if (DAT_a170b9f8 < -DAT_a17042cc) {
            DAT_a170b9f8 = -DAT_a17042cc;
          }
          if (DAT_a1704227 == 0xff) {
            DAT_a170b9f8 = matched_FUN_a0506690(DAT_a170b9f8,DAT_a1704225);
          }
          else {
            DAT_a170b9f8 = DAT_a170b9f8 >> DAT_a1704227;
          }
          DAT_a170b9f8 = matched_FUN_a0506690(DAT_a170b9f8 << 8,DAT_a1704264);
          if (DAT_a1702ccc == -1) {
            DAT_a170b9f8 = -DAT_a170b9f8;
          }
          if (((DAT_a1702cb4 != 0) || (DAT_a1702cb9 != '\0')) || (DAT_a1702cbb != '\0')) {
            DAT_a170b9f8 = -DAT_a170b9f8;
          }
          DAT_a170ba18 = DAT_a170b37c == 0;
          local_64 = (&DAT_a170b37c)[(byte)DAT_a170ba18] - (&DAT_a170ba0c)[(byte)DAT_a170ba18];
          iVar9 = matched_FUN_a0506690
                            ((local_40 + local_64) * (DAT_a170b370 - DAT_a170b36c),DAT_a17045a8);
          DAT_a170b370 = iVar9 + DAT_a170b36c;
          DAT_a170b9a8 = DAT_a170b9f8 - DAT_a170b370;
          DAT_a170b9e8 = '\x01';
          if ((int)DAT_a170b9a8 < 0) {
            DAT_a170b9e8 = -1;
            DAT_a170b9a8 = -DAT_a170b9a8;
          }
          uVar17 = matched_FUN_a0506f38
                             (DAT_a170b9a8 << 0x16,
                              ((int)DAT_a170b9a8 >> 0x1f) << 0x16 | DAT_a170b9a8 >> 10,DAT_a1704248,
                              0);
          DAT_a170ba1c = matched_FUN_a0506f38
                                   ((int)uVar17,(int)((ulonglong)uVar17 >> 0x20),DAT_a17045a8,
                                    DAT_a17045a8 >> 0x1f);
          if (DAT_a170b9e8 == -1) {
            DAT_a170ba1c = -DAT_a170ba1c;
          }
          iVar9 = matched_FUN_a0506690
                            ((local_44 + local_64) * (DAT_a170b378 - DAT_a170b374),DAT_a17045a8);
          DAT_a170b378 = iVar9 + DAT_a170b374;
          DAT_a170b9a8 = DAT_a170b9f8 - DAT_a170b378;
          DAT_a170b9e8 = '\x01';
          if ((int)DAT_a170b9a8 < 0) {
            DAT_a170b9e8 = -1;
            DAT_a170b9a8 = -DAT_a170b9a8;
          }
          uVar17 = matched_FUN_a0506f38
                             (DAT_a170b9a8 << 0x16,
                              ((int)DAT_a170b9a8 >> 0x1f) << 0x16 | DAT_a170b9a8 >> 10,DAT_a1704248,
                              0);
          DAT_a170ba20 = matched_FUN_a0506f38
                                   ((int)uVar17,(int)((ulonglong)uVar17 >> 0x20),DAT_a17045a8,
                                    DAT_a17045a8 >> 0x1f);
          if (DAT_a170b9e8 == -1) {
            DAT_a170ba20 = -DAT_a170ba20;
          }
          uVar2 = matched_FUN_a0383d80(DAT_a170ba1c,DAT_a170ba20,DAT_a170ab1a,DAT_a170ba18);
          local_74[3] = uVar2;
          if (uVar2 == 0) {
            DAT_a170b36c = DAT_a170b370;
            DAT_a170b370 = DAT_a170b9f8;
            local_40 = 0;
            DAT_a170b374 = DAT_a170b378;
            DAT_a170b378 = DAT_a170b9f8;
            local_44 = 0;
          }
          else if (uVar2 == 0xffffffff) {
            local_40 = local_40 + local_64;
            local_44 = local_44 + local_64;
          }
          else if (uVar2 == 0xfffffffd) {
            DAT_a170b36c = DAT_a170b370;
            DAT_a170b370 = DAT_a170b9f8;
            local_40 = 0;
            local_44 = local_44 + local_64;
          }
        }
      }
    }
  }
  if (DAT_a0757b32 != 0) {
    DAT_a170ba24 = *(int *)(DAT_a062dc8c + 0x254);
    if ((DAT_a0757b32 & 1) != 0) {
      uVar2 = FUN_a02a70ec(s_EIS_main_task____6d___10d__10d____a06009c8,DAT_a170ba24 - DAT_a170b358,
                           DAT_a170b358,DAT_a170ba24,DAT_a170422c);
    }
    if (((DAT_a0757b32 & 2) != 0) && (23999 < (uint)(DAT_a170ba24 - DAT_a170b358))) {
      uVar2 = FUN_a02a70ec(s__sEIS_main_task____6d___10d__10d_a06009fc,DAT_a06f3080,
                           DAT_a170ba24 - DAT_a170b358,DAT_a170b358,DAT_a170ba24,DAT_a170422c);
    }
  }
  return uVar2;
}

