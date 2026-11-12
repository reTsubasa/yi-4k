/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int eis_rotation_filter(undefined4 param_1,int param_2,int *param_3)

{
  uint in_fpscr;
  int iVar1;
  double dVar2;
  int local_8;
  int local_4;
  
  if (DAT_a170af88 == '\0') {
    local_4 = (*param_3 * 99) / 100 + (param_2 * DAT_a0757b54) / 100;
  }
  else {
    dVar2 = (double)VectorSignedToFloat(DAT_a0757ad4 << (uint)DAT_a0757aa1,
                                        (byte)(in_fpscr >> 0x16) & 3);
    iVar1 = VectorFloatToSigned((dVar2 * DAT_a0384a00) / DAT_a0384a08,3);
    if (((param_2 < 0) || (iVar1 / 100 <= param_2)) &&
       ((-1 < param_2 || (param_2 <= -(iVar1 / 100))))) {
      DAT_a170af89 = 0;
    }
    else {
      DAT_a170af89 = DAT_a170af89 + 1;
    }
    if (DAT_a0757ad8 < DAT_a170af89) {
      DAT_a170af89 = DAT_a0757ad8;
      local_4 = (DAT_a0757adc * *param_3) / 100 + (param_2 * DAT_a0757b54) / 100;
    }
    else {
      local_4 = (*param_3 * 99) / 100 + (param_2 * DAT_a0757b54) / 100;
    }
  }
  local_8 = local_4;
  if (DAT_a170afec < local_4) {
    local_8 = DAT_a170afec;
  }
  else if (-local_4 != DAT_a170afec && local_4 <= -DAT_a170afec) {
    local_8 = -DAT_a170afec;
  }
  return local_8;
}

