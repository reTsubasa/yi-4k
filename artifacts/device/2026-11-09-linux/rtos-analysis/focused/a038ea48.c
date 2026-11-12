/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void eis_calibration_xy_grid(short *param_1)

{
  ushort uVar1;
  ushort uVar2;
  uint uVar3;
  uint uVar4;
  undefined2 uVar5;
  short sVar6;
  int iVar7;
  int local_24;
  int local_20;
  int local_18;
  int local_14;
  short local_10;
  short local_e;
  ushort local_c;
  ushort local_a;
  
  uVar4 = DAT_a1704650;
  uVar3 = DAT_a170464c;
  uVar1 = (ushort)DAT_a170464c;
  uVar2 = (ushort)DAT_a1704650;
  iVar7 = DAT_a170441c >> 0x10;
  if (iVar7 < 0) {
    iVar7 = -iVar7;
  }
  DAT_a170ab6c = (short)iVar7;
  iVar7 = DAT_a1704420 >> 0x10;
  if (iVar7 < 0) {
    iVar7 = -iVar7;
  }
  DAT_a170ab6e = (short)iVar7;
  if (DAT_a17045d8 == '\0') {
    for (local_c = 0; local_c < uVar2; local_c = local_c + 1) {
      for (local_a = 0; local_a < uVar1; local_a = local_a + 1) {
        if (DAT_a17045d9 != '\0') {
          param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] =
               (short)(DAT_a1704420 >> 0xc);
        }
        if (DAT_a17045dc != '\0') {
          param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] =
               param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] +
               *(short *)(&DAT_a170685e + ((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 4);
        }
        if (DAT_a17045dd != '\0') {
          if (DAT_a17045de == '\x01') {
            param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] =
                 param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] +
                 *(short *)(local_20 + ((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 4 + 2);
          }
          else if (DAT_a17045de == '\0') {
            param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] =
                 param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2 + 1] +
                 *(short *)(&DAT_a17089ba + ((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 4);
          }
        }
        if (DAT_a17045d9 != '\0') {
          param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] =
               (short)(DAT_a170441c >> 0xc);
        }
        if (DAT_a17045dc != '\0') {
          param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] =
               param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] +
               *(short *)(&DAT_a170685c + ((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 4);
        }
        if (DAT_a17045dd != '\0') {
          if (DAT_a17045de == '\x01') {
            param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] =
                 param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] +
                 *(short *)(local_24 + ((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 4);
          }
          else if (DAT_a17045de == '\0') {
            param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] =
                 param_1[((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 2] +
                 *(short *)(&DAT_a17089b8 + ((uVar3 & 0xffff) * (uint)local_c + (uint)local_a) * 4);
          }
        }
      }
    }
    if (DAT_a0757b04 != 0) {
      FUN_a02a70ec(s_DiffTime____d__Warp_0_0_____d__d_a0600af8,DAT_a170422c,(int)*param_1,
                   (int)param_1[1]);
    }
    DAT_a170ba28 = DAT_a170ba28 + DAT_a0757b60;
    if (DAT_a170ba28 < 0xfa) {
      if (DAT_a170ba28 < -0xf9) {
        DAT_a0757b60 = 10;
      }
    }
    else {
      DAT_a0757b60 = -10;
    }
    DAT_a170ba2a = DAT_a170ba2a + DAT_a0757b62;
    if (DAT_a170ba2a < 0xfa) {
      if (DAT_a170ba2a < -0xf9) {
        DAT_a0757b62 = 10;
      }
    }
    else {
      DAT_a0757b62 = -10;
    }
  }
  else {
    DAT_a170ab6c = (short)((uint)DAT_a170441c >> 0x10);
    DAT_a170ab6e = (short)((uint)DAT_a1704420 >> 0x10);
    if (DAT_a170441c < 0) {
      DAT_a170ab70 = -1;
      DAT_a170ab6c = -DAT_a170ab6c;
      local_e = matched_FUN_a0506690((int)DAT_a170ab6c,(int)DAT_a0701cc6);
    }
    else {
      DAT_a170ab70 = 1;
      local_e = matched_FUN_a0506690((int)DAT_a170ab6c,(int)DAT_a0701cc6);
    }
    if (DAT_a170ab6e < 0) {
      DAT_a170ab72 = -1;
      DAT_a170ab6e = -DAT_a170ab6e;
      local_10 = matched_FUN_a0506690((int)DAT_a170ab6e,(int)DAT_a0701cc6);
    }
    else {
      DAT_a170ab72 = 1;
      local_10 = matched_FUN_a0506690((int)DAT_a170ab6e,(int)DAT_a0701cc6);
    }
    if (DAT_a0701cc2 < local_e) {
      local_e = DAT_a0701cc2;
      DAT_a170ab6c = DAT_a0701cc2 * DAT_a0701cc6;
    }
    if (DAT_a0701cc4 < local_10) {
      local_10 = DAT_a0701cc4;
      DAT_a170ab6e = DAT_a0701cc4 * DAT_a0701cc6;
    }
    DAT_a170ab72 = -DAT_a170ab72;
    DAT_a170ab70 = -DAT_a170ab70;
    if ((DAT_a170ab70 < 1) || (DAT_a170ab72 < 1)) {
      if ((DAT_a170ab70 < 1) || (-1 < DAT_a170ab72)) {
        if ((DAT_a170ab70 < 0) && (0 < DAT_a170ab72)) {
          for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
            for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 (int)DAT_a0701cc4 + (int)local_10) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a1702220 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 (int)DAT_a0701cc4 + (int)local_10) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a17024a4 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 (int)DAT_a0701cc4 + (int)local_10) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a1702728 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 (int)DAT_a0701cc4 + (int)local_10) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a17029ac + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
            }
          }
          for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
            for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
              sVar6 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                                 (int)*(short *)(&DAT_a1702220 +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                                 (int)*(short *)(&DAT_a17024a4 +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2] = sVar6;
              sVar6 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                                 (int)*(short *)(&DAT_a1702728 +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                                 (int)*(short *)(&DAT_a17029ac +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2 + 1] = sVar6;
            }
          }
        }
        else {
          for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
            for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 ((int)DAT_a0701cc4 - (int)local_10)) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a1702220 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 ((int)DAT_a0701cc4 - (int)local_10)) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a0701cc8 +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a17024a4 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 ((int)DAT_a0701cc4 - (int)local_10)) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  ((int)DAT_a0701cc2 - (int)local_e) +
                                                 ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a1702728 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
              uVar5 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 ((int)DAT_a0701cc4 - (int)local_10)) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                                 (int)*(short *)(&DAT_a072cb8c +
                                                ((uVar4 & 0xffff) *
                                                 (uVar3 & 0xffff) *
                                                 ((DAT_a0701cc4 * 2 + 1) *
                                                  (((int)DAT_a0701cc2 - (int)local_e) + -1) +
                                                 ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                                 local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              *(undefined2 *)(&DAT_a17029ac + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
            }
          }
          for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
            for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
              sVar6 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                                 (int)*(short *)(&DAT_a1702220 +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                                 (int)*(short *)(&DAT_a17024a4 +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2] = sVar6;
              sVar6 = matched_FUN_a0506690
                                (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                                 (int)*(short *)(&DAT_a1702728 +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                                 ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                                 (int)*(short *)(&DAT_a17029ac +
                                                (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                                 (int)DAT_a0701cc6);
              param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2 + 1] = sVar6;
            }
          }
        }
      }
      else {
        for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
          for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
            uVar5 = matched_FUN_a0506690
                              (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                               (int)*(short *)(&DAT_a0701cc8 +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e) +
                                               ((int)DAT_a0701cc4 - (int)local_10)) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                               ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                               (int)*(short *)(&DAT_a0701cc8 +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e) +
                                               ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2),
                               (int)DAT_a0701cc6);
            *(undefined2 *)(&DAT_a1702220 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
            uVar5 = matched_FUN_a0506690
                              (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                               (int)*(short *)(&DAT_a0701cc8 +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                               ((int)DAT_a0701cc4 - (int)local_10)) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                               ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                               (int)*(short *)(&DAT_a0701cc8 +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                               ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2),
                               (int)DAT_a0701cc6);
            *(undefined2 *)(&DAT_a17024a4 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
            uVar5 = matched_FUN_a0506690
                              (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                               (int)*(short *)(&DAT_a072cb8c +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e) +
                                               ((int)DAT_a0701cc4 - (int)local_10)) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                               ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                               (int)*(short *)(&DAT_a072cb8c +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e) +
                                               ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2),
                               (int)DAT_a0701cc6);
            *(undefined2 *)(&DAT_a1702728 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
            uVar5 = matched_FUN_a0506690
                              (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                               (int)*(short *)(&DAT_a072cb8c +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                               ((int)DAT_a0701cc4 - (int)local_10)) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                               ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                               (int)*(short *)(&DAT_a072cb8c +
                                              ((uVar4 & 0xffff) *
                                               (uVar3 & 0xffff) *
                                               ((DAT_a0701cc4 * 2 + 1) *
                                                ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                               ((int)DAT_a0701cc4 - (int)local_10) + -1) +
                                               local_18 * (uVar3 & 0xffff) + local_14) * 2),
                               (int)DAT_a0701cc6);
            *(undefined2 *)(&DAT_a17029ac + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
          }
        }
        for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
          for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
            sVar6 = matched_FUN_a0506690
                              (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                               (int)*(short *)(&DAT_a1702220 +
                                              (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                               ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                               (int)*(short *)(&DAT_a17024a4 +
                                              (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                               (int)DAT_a0701cc6);
            param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2] = sVar6;
            sVar6 = matched_FUN_a0506690
                              (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                               (int)*(short *)(&DAT_a1702728 +
                                              (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                               ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                               (int)*(short *)(&DAT_a17029ac +
                                              (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                               (int)DAT_a0701cc6);
            param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2 + 1] = sVar6;
          }
        }
      }
    }
    else {
      for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
        for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
          uVar5 = matched_FUN_a0506690
                            (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                             (int)*(short *)(&DAT_a0701cc8 +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e) +
                                             (int)DAT_a0701cc4 + (int)local_10) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                             ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                             (int)*(short *)(&DAT_a0701cc8 +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e) +
                                             (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2),
                             (int)DAT_a0701cc6);
          *(undefined2 *)(&DAT_a1702220 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
          uVar5 = matched_FUN_a0506690
                            (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                             (int)*(short *)(&DAT_a0701cc8 +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                             (int)DAT_a0701cc4 + (int)local_10) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                             ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                             (int)*(short *)(&DAT_a0701cc8 +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                             (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2),
                             (int)DAT_a0701cc6);
          *(undefined2 *)(&DAT_a17024a4 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
          uVar5 = matched_FUN_a0506690
                            (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                             (int)*(short *)(&DAT_a072cb8c +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e) +
                                             (int)DAT_a0701cc4 + (int)local_10) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                             ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                             (int)*(short *)(&DAT_a072cb8c +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e) +
                                             (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2),
                             (int)DAT_a0701cc6);
          *(undefined2 *)(&DAT_a1702728 + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
          uVar5 = matched_FUN_a0506690
                            (((int)DAT_a0701cc6 * (local_10 + 1) - (int)DAT_a170ab6e) *
                             (int)*(short *)(&DAT_a072cb8c +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                             (int)DAT_a0701cc4 + (int)local_10) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                             ((int)DAT_a170ab6e - (int)DAT_a0701cc6 * (int)local_10) *
                             (int)*(short *)(&DAT_a072cb8c +
                                            ((uVar4 & 0xffff) *
                                             (uVar3 & 0xffff) *
                                             ((DAT_a0701cc4 * 2 + 1) *
                                              ((int)DAT_a0701cc2 + (int)local_e + 1) +
                                             (int)DAT_a0701cc4 + (int)local_10 + 1) +
                                             local_18 * (uVar3 & 0xffff) + local_14) * 2),
                             (int)DAT_a0701cc6);
          *(undefined2 *)(&DAT_a17029ac + (local_18 * (uVar3 & 0xffff) + local_14) * 2) = uVar5;
        }
      }
      for (local_18 = 0; local_18 < (int)(uVar4 & 0xffff); local_18 = local_18 + 1) {
        for (local_14 = 0; local_14 < (int)(uVar3 & 0xffff); local_14 = local_14 + 1) {
          sVar6 = matched_FUN_a0506690
                            (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                             (int)*(short *)(&DAT_a1702220 +
                                            (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                             ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                             (int)*(short *)(&DAT_a17024a4 +
                                            (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                             (int)DAT_a0701cc6);
          param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2] = sVar6;
          sVar6 = matched_FUN_a0506690
                            (((int)DAT_a0701cc6 * (local_e + 1) - (int)DAT_a170ab6c) *
                             (int)*(short *)(&DAT_a1702728 +
                                            (local_18 * (uVar3 & 0xffff) + local_14) * 2) +
                             ((int)DAT_a170ab6c - (int)DAT_a0701cc6 * (int)local_e) *
                             (int)*(short *)(&DAT_a17029ac +
                                            (local_18 * (uVar3 & 0xffff) + local_14) * 2),
                             (int)DAT_a0701cc6);
          param_1[(local_18 * (uVar3 & 0xffff) + local_14) * 2 + 1] = sVar6;
        }
      }
    }
  }
  return;
}

