/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 rtos_build_mapping_descriptors(uint *param_1)

{
  uint uVar1;
  uint uVar2;
  int iVar3;
  uint *puVar4;
  uint uVar5;
  uint *puVar6;
  int iVar7;
  int iVar8;
  uint *puVar9;
  uint uVar10;
  byte bVar11;
  uint *puVar12;
  uint uVar13;
  uint uVar14;
  uint uVar15;
  uint uVar16;
  uint *puVar17;
  int iVar18;
  uint uVar19;
  int iVar20;
  int iVar21;
  uint uVar22;
  uint uVar23;
  uint *local_58;
  int local_48;
  uint *local_30;
  undefined4 local_2c;
  
  iVar3 = DAT_a04a3ffc;
  bVar11 = (byte)param_1[3] & 3;
  if (bVar11 == 1) {
    uVar15 = (uint)(byte)param_1[3];
    uVar10 = (*(byte *)((int)param_1 + 0xd) & 0xf) >> 1;
    uVar16 = (uint)*(byte *)((int)param_1 + 0xe);
    uVar14 = *param_1 >> 0x14;
    uVar1 = (*param_1 + param_1[2]) - 1 >> 0x14;
    uVar10 = uVar15 & 4 | 2 | uVar15 & 8 | uVar15 & 0x10 | (ushort)param_1[3] & 0x1e0 |
             (uVar10 & 3) << 10 | ((*(byte *)((int)param_1 + 0xd) & 0x7f) >> 4) << 0xc |
             ((int)uVar10 >> 2) << 0xf | (uVar16 & 1) << 0x10 | ((uVar16 & 3) >> 1) << 0x11 |
             ((uVar16 & 0xf) >> 3) << 0x13;
    uVar15 = param_1[1] >> 0x14;
    if (uVar14 <= uVar1) {
      puVar17 = (uint *)(DAT_a04a3ffc + uVar14 * 4);
      do {
        uVar14 = uVar14 + 1;
        *puVar17 = uVar10;
        *(ushort *)((int)puVar17 + 2) = (ushort)(uVar10 >> 0x10) | (ushort)(uVar15 << 4);
        matched_FUN_a04a2568(puVar17,4);
        uVar15 = uVar15 + 1 & 0xfff;
        puVar17 = puVar17 + 1;
      } while (uVar14 <= uVar1);
    }
    return 0;
  }
  if (bVar11 == 2) {
    uVar22 = *param_1;
    uVar15 = (*(byte *)((int)param_1 + 0xd) & 0xf) >> 1;
    bVar11 = (byte)param_1[3];
    uVar14 = uVar22 >> 0x14;
    uVar16 = (uVar22 + param_1[2]) - 1;
    uVar1 = uVar16 >> 0x14;
    uVar10 = (uint)*(ushort *)((int)param_1 + 6);
    local_2c = (uint)CONCAT11((byte)(((int)uVar15 >> 2) << 1) |
                              (byte)((*(byte *)((int)param_1 + 0xe) & 1) << 2) |
                              (byte)(((*(byte *)((int)param_1 + 0xe) & 3) >> 1) << 3) |
                              *(byte *)((int)param_1 + 0xd) & 0x70 |
                              (byte)(((bVar11 & 0x1f) >> 4) << 7),
                              bVar11 & 4 | 1 | bVar11 & 8 | (byte)((uVar15 & 3) << 4));
    if (uVar14 <= uVar1) {
      iVar20 = DAT_a04a3ffc + uVar14 * 4;
      bVar11 = *(byte *)(DAT_a04a3ffc + uVar14 * 4) & 3;
      if (bVar11 != 2) {
        uVar22 = (uVar22 & 0xfffff) >> 0x10;
        iVar21 = (uVar14 + 0x3ff004) * 0x400;
        uVar16 = (uVar16 & 0xfffff) >> 0x10;
        iVar8 = uVar14 * 4 - iVar20;
        puVar6 = (uint *)(DAT_a04a3ffc + iVar21 + 0x403000);
        puVar17 = (uint *)(iVar21 + 0xa0b98000);
        uVar15 = uVar14;
        do {
          if (bVar11 == 1) {
            local_30 = (uint *)(*(uint *)(iVar3 + uVar15 * 4) & 0xfffffc00);
            if (uVar15 != uVar14) goto LAB_a04a39c0;
LAB_a04a3a84:
            uVar5 = uVar22;
            iVar21 = uVar22 * 4;
            if (uVar15 != uVar1) {
              iVar7 = 0x10;
              uVar19 = 0xf;
              puVar4 = local_30 + uVar22;
LAB_a04a3aa8:
              iVar7 = (iVar7 - uVar5) * 0x40;
              goto LAB_a04a39d8;
            }
LAB_a04a3ae8:
            puVar4 = (uint *)((int)local_30 + iVar21);
            if (uVar5 <= uVar16) {
              iVar7 = uVar16 + 1;
              uVar19 = uVar16;
              goto LAB_a04a3aa8;
            }
            iVar7 = ((uVar16 + 1) - uVar5) * 0x40;
          }
          else {
            if (uVar15 < 0xffe) {
              local_30 = puVar6;
              matched_FUN_a04f8dec(puVar6,0,0x400);
              matched_FUN_a04a22cc(&local_30,0x400);
            }
            else {
              local_30 = puVar17;
            }
            *(byte *)(iVar3 + uVar15 * 4) = *(byte *)(iVar3 + uVar15 * 4) & 0xfc | 1;
            *(byte *)(iVar3 + uVar15 * 4) =
                 *(byte *)(iVar3 + uVar15 * 4) & 0xf7 | *(byte *)((int)param_1 + 0xe) & 8;
            *(ushort *)(iVar3 + uVar15 * 4) =
                 *(ushort *)(iVar3 + uVar15 * 4) & 0xfe1f | (ushort)param_1[3] & 0x1e0;
            *(uint *)(iVar3 + uVar15 * 4) =
                 *(uint *)(iVar3 + uVar15 * 4) & 0x3ff | (uint)local_30 & 0xfffffc00;
            matched_FUN_a04a2568(iVar20,4);
            if (uVar15 == uVar14) goto LAB_a04a3a84;
LAB_a04a39c0:
            uVar5 = 0;
            if (uVar15 == uVar1) {
              iVar21 = 0;
              goto LAB_a04a3ae8;
            }
            iVar7 = 0x400;
            iVar21 = 0;
            uVar19 = 0xf;
            puVar4 = local_30;
LAB_a04a39d8:
            iVar18 = uVar5 - uVar10;
            do {
              puVar9 = puVar4 + 0x10;
              puVar12 = puVar4;
              do {
                puVar4 = puVar12 + 1;
                *puVar12 = local_2c;
                *(short *)((int)puVar12 + 2) = (short)uVar10;
                puVar12 = puVar4;
              } while (puVar4 != puVar9);
              uVar10 = uVar10 + 1;
            } while (iVar18 + uVar10 <= uVar19);
            puVar4 = (uint *)((int)local_30 + iVar21);
          }
          uVar15 = uVar15 + 1;
          matched_FUN_a04a2568(puVar4,iVar7);
          if (uVar1 < uVar15) {
            return 0;
          }
          puVar17 = puVar17 + 0x100;
          puVar6 = puVar6 + 0x100;
          bVar11 = *(byte *)(iVar3 + uVar15 * 4) & 3;
          iVar20 = iVar3 + iVar20 + iVar8 + 4;
        } while (bVar11 != 2);
      }
    }
    return 0;
  }
  if (bVar11 != 3) {
    return 0xffffffff;
  }
  bVar11 = (byte)param_1[3];
  uVar10 = *param_1;
  uVar16 = (*(byte *)((int)param_1 + 0xd) & 0xf) >> 1;
  uVar22 = (uVar10 + param_1[2]) - 1;
  uVar14 = uVar22 >> 0x14;
  uVar1 = uVar10 >> 0x14;
  iVar20 = ((*(byte *)((int)param_1 + 0xd) & 0x7f) >> 4) << 6;
  uVar15 = param_1[1] >> 0xc;
  local_2c = (uint)CONCAT11((byte)((uint)iVar20 >> 8) | (byte)(((int)uVar16 >> 2) << 1) |
                            (byte)((*(byte *)((int)param_1 + 0xe) & 1) << 2) |
                            (byte)(((*(byte *)((int)param_1 + 0xe) & 3) >> 1) << 3),
                            (byte)((bVar11 & 0x1f) >> 4) | 2 | bVar11 & 4 | bVar11 & 8 |
                            (byte)((uVar16 & 3) << 4) | (byte)iVar20);
  if (uVar1 <= uVar14) {
    iVar20 = DAT_a04a3ffc + uVar1 * 4;
    bVar11 = *(byte *)(DAT_a04a3ffc + uVar1 * 4) & 3;
    if (bVar11 != 2) {
      uVar16 = (uVar10 & 0xfffff) >> 0xc;
      iVar21 = (uVar1 + 0x3ff004) * 0x400;
      uVar22 = (uVar22 & 0xfffff) >> 0xc;
      local_58 = (uint *)(DAT_a04a3ffc + iVar21 + 0x403000);
      puVar17 = (uint *)(iVar21 + -0x5f468000);
      iVar21 = uVar1 * 4 - iVar20;
      uVar10 = uVar1;
      do {
        if (bVar11 == 1) {
          local_30 = (uint *)(*(uint *)(iVar3 + uVar10 * 4) & 0xfffffc00);
          local_30 = (uint *)rtos_phys_to_virtual(local_30);
          matched_FUN_a04a2568(local_30,4);
        }
        else {
          if (uVar10 < 0xffe) {
            local_30 = local_58;
            matched_FUN_a04f8dec(local_58,0,0x400);
            matched_FUN_a04a22cc(&local_30,0x400);
          }
          else {
            local_30 = puVar17;
          }
          *(byte *)(iVar3 + uVar10 * 4) = *(byte *)(iVar3 + uVar10 * 4) & 0xfc | 1;
          *(byte *)(iVar3 + uVar10 * 4) =
               *(byte *)(iVar3 + uVar10 * 4) & 0xf7 | *(byte *)((int)param_1 + 0xe) & 8;
          *(ushort *)(iVar3 + uVar10 * 4) =
               *(ushort *)(iVar3 + uVar10 * 4) & 0xfe1f | (ushort)param_1[3] & 0x1e0;
          uVar5 = rtos_virtual_to_physical(local_30);
          *(uint *)(iVar3 + uVar10 * 4) = *(uint *)(iVar3 + uVar10 * 4) & 0x3ff | uVar5 & 0xfffffc00
          ;
          matched_FUN_a04a2568(iVar20,4);
        }
        if (uVar10 == uVar1) {
          uVar5 = uVar16;
          local_48 = uVar16 * 4;
          if (uVar10 == uVar14) goto LAB_a04a3f70;
          iVar8 = 0x100;
          uVar19 = 0xff;
          puVar6 = local_30 + uVar16;
LAB_a04a3f58:
          iVar8 = (iVar8 - uVar5) * 4;
LAB_a04a3e44:
          uVar23 = uVar15;
          uVar13 = uVar15;
          do {
            uVar23 = uVar23 + 1;
            uVar2 = uVar13 << 0xc;
            uVar13 = (uVar13 & 0xfffff) + 1;
            *puVar6 = local_2c & 0xfff | uVar2;
            puVar6 = puVar6 + 1;
          } while ((uVar23 - uVar15) + uVar5 <= uVar19);
          puVar6 = (uint *)((int)local_30 + local_48);
          uVar15 = uVar23;
        }
        else {
          if (uVar10 != uVar14) {
            iVar8 = 0x400;
            uVar19 = 0xff;
            uVar5 = 0;
            local_48 = 0;
            puVar6 = local_30;
            goto LAB_a04a3e44;
          }
          local_48 = 0;
          uVar5 = 0;
LAB_a04a3f70:
          puVar6 = (uint *)((int)local_30 + local_48);
          if (uVar5 <= uVar22) {
            iVar8 = uVar22 + 1;
            uVar19 = uVar22;
            goto LAB_a04a3f58;
          }
          iVar8 = ((uVar22 + 1) - uVar5) * 4;
        }
        matched_FUN_a04a2568(puVar6,iVar8);
        uVar10 = uVar10 + 1;
        if (uVar14 < uVar10) {
          return 0;
        }
        puVar17 = puVar17 + 0x100;
        bVar11 = *(byte *)(iVar3 + uVar10 * 4) & 3;
        iVar20 = iVar3 + iVar20 + iVar21 + 4;
        local_58 = local_58 + 0x100;
      } while (bVar11 != 2);
    }
  }
  return 0;
}

