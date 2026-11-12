/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: ram */

undefined4
gyro_get_info(undefined4 *param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  undefined4 uVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  undefined4 *puVar5;
  bool bVar6;
  
  if (DAT_a1a35630 == '\0') {
    DAT_a1a35630 = '\x01';
    matched_FUN_a04f8dec(&DAT_a1a355ac,0,0x3e,&DAT_a1a35630,param_4);
    _DAT_a1a355b0 = CONCAT11(1,DAT_a1a355b0);
    DAT_a1a355b9 = 0xff;
    DAT_a1a355da = 0xff;
    DAT_a1a355b7 = 1;
    DAT_a1a355b8 = 1;
    DAT_a1a355db = 1;
    if (_DAT_a1a355b0 == 0x100) {
      DAT_a1a355d4 = 1;
    }
    else {
      DAT_a1a355d6 = 1;
    }
    DAT_a1a355ac._0_1_ = 3;
    DAT_a1a355c6 = 0x8a3c;
    uRama1a355dc = CONCAT22(0x87ae,(undefined2)uRama1a355dc);
    DAT_a1a355e8 = 0x8000;
    DAT_a1a355ba = 1;
    DAT_a1a355bb = 1;
    DAT_a1a355bd = 2;
    DAT_a1a355ca = 0x87;
    _DAT_a1a355cc = 0x7f;
    _DAT_a1a355c8 = 0x75c4;
    DAT_a1a355be = 0x1e;
    DAT_a1a355ce = 100;
    DAT_a1a355d0._0_2_ = 0xfa;
    DAT_a1a355c4 = 8000;
    DAT_a1a355c2 = 8000;
    DAT_a1a355bf = 0x10;
    DAT_a1a355c0 = 3;
    _DAT_a1a355e4 = CONCAT22(DAT_a1a355e4_2,0x3e14);
    _DAT_a1a355e0 = 0x41ec7852;
    FUN_a02a70ec(s__sLevelShift____d_a0628908,DAT_a06f3080,0x8000);
  }
  puVar5 = &DAT_a1a355ac;
  do {
    puVar4 = param_1;
    uVar1 = puVar5[1];
    uVar2 = puVar5[2];
    uVar3 = puVar5[3];
    bVar6 = puVar5 != (undefined4 *)&DAT_a1a355cc;
    *puVar4 = *puVar5;
    puVar4[1] = uVar1;
    puVar4[2] = uVar2;
    puVar4[3] = uVar3;
    uVar2 = _DAT_a1a355e4;
    uVar1 = _DAT_a1a355e0;
    param_1 = puVar4 + 4;
    puVar5 = puVar5 + 4;
  } while (bVar6);
  puVar4[4] = uRama1a355dc;
  puVar4[5] = uVar1;
  puVar4[6] = uVar2;
  *(undefined2 *)(puVar4 + 7) = DAT_a1a355e8;
  return 0;
}

