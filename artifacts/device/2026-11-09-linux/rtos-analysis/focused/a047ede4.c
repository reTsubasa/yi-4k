/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 gyro_read_indirect_candidate(int param_1,short *param_2)

{
  short sVar1;
  undefined1 uVar2;
  short sVar3;
  short sVar4;
  undefined1 auStack_11 [5];
  
  if (param_1 == 1) {
    auStack_11[0] = 0x8c;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,7,auStack_11,&DAT_a1a35610,1000);
    if (_DAT_a1a355b0 == 0x100) {
      sVar3 = CONCAT11(DAT_a1a35612,DAT_a1a35611);
      *param_2 = sVar3;
      sVar4 = CONCAT11(DAT_a1a35614,DAT_a1a35613);
      param_2[1] = sVar4;
    }
    else {
      sVar4 = CONCAT11(DAT_a1a35612,DAT_a1a35611);
      param_2[1] = sVar4;
      sVar3 = CONCAT11(DAT_a1a35614,DAT_a1a35613);
      *param_2 = sVar3;
    }
  }
  else {
    if (param_1 == 2) {
      auStack_11[0] = 0x8c;
      matched_FUN_a048e12c(1,&DAT_a078b0b0,0x10,auStack_11,&DAT_a1a35610,1000);
      uVar2 = DAT_a1a35619;
      if ((DAT_a1a355d4 == 1) && (DAT_a1a355d6 == 0)) {
        sVar3 = CONCAT11(DAT_a1a35618,DAT_a1a35617);
        param_2[4] = sVar3;
        sVar4 = CONCAT11(DAT_a1a3561a,DAT_a1a35619);
        param_2[5] = sVar4;
      }
      else {
        sVar4 = CONCAT11(DAT_a1a35618,DAT_a1a35617);
        param_2[5] = sVar4;
        sVar3 = CONCAT11(DAT_a1a3561a,uVar2);
        param_2[4] = sVar3;
      }
      sVar1 = CONCAT11(DAT_a1a3561c,DAT_a1a3561b);
      param_2[6] = sVar1;
      param_2[4] = sVar3 + DAT_a1a355e8;
      param_2[5] = sVar4 + DAT_a1a355e8;
      param_2[6] = sVar1 + DAT_a1a355e8;
      return 0;
    }
    if (param_1 != 3) {
      return 0;
    }
    auStack_11[0] = 0x8c;
    matched_FUN_a048e12c(1,&DAT_a078b0b0,0x17,auStack_11,&DAT_a1a35610,1000);
    sVar4 = CONCAT11(DAT_a1a35626,DAT_a1a35625);
    param_2[3] = sVar4;
    param_2[3] = sVar4 + DAT_a1a355e8;
    uVar2 = DAT_a1a35619;
    if ((DAT_a1a355d4 == 1) && (DAT_a1a355d6 == 0)) {
      sVar3 = CONCAT11(DAT_a1a35618,DAT_a1a35617);
      param_2[4] = sVar3;
      sVar4 = CONCAT11(DAT_a1a3561a,DAT_a1a35619);
      param_2[5] = sVar4;
    }
    else {
      sVar4 = CONCAT11(DAT_a1a35618,DAT_a1a35617);
      param_2[5] = sVar4;
      sVar3 = CONCAT11(DAT_a1a3561a,uVar2);
      param_2[4] = sVar3;
    }
    sVar1 = CONCAT11(DAT_a1a3561c,DAT_a1a3561b);
    param_2[6] = sVar1;
    param_2[4] = sVar3 + DAT_a1a355e8;
    param_2[5] = sVar4 + DAT_a1a355e8;
    param_2[6] = sVar1 + DAT_a1a355e8;
    if (_DAT_a1a355b0 == 0x100) {
      sVar3 = CONCAT11(DAT_a1a35612,DAT_a1a35611);
      *param_2 = sVar3;
      sVar4 = CONCAT11(DAT_a1a35614,DAT_a1a35613);
      param_2[1] = sVar4;
    }
    else {
      sVar4 = CONCAT11(DAT_a1a35612,DAT_a1a35611);
      param_2[1] = sVar4;
      sVar3 = CONCAT11(DAT_a1a35614,DAT_a1a35613);
      *param_2 = sVar3;
    }
  }
  sVar1 = _DAT_a1a35615;
  param_2[2] = _DAT_a1a35615;
  *param_2 = sVar3 + DAT_a1a355e8;
  param_2[1] = sVar4 + DAT_a1a355e8;
  param_2[2] = sVar1 + DAT_a1a355e8;
  return 0;
}

