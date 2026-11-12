/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void eis_controller_init(void)

{
  uint in_fpscr;
  double dVar1;
  double dVar2;
  
  FUN_a02a70ec(s_____AmbaImgEisCtrl_Init_starts___a05fe940);
  if (DAT_a170b310 == '\0') {
    DAT_a170b310 = '\x01';
    DAT_a17042f8 = 0x10000;
    DAT_a1702c4c = 0x10000;
    if (*DAT_a1a355a4 != 0) {
      (*(code *)*DAT_a1a355a4)(&DAT_a1702cc0);
    }
    if ((DAT_a1702cc0 != '\0') &&
       (DAT_a0757a54 = ((uint)DAT_a0757b48 * DAT_a0757a58 * 0x100) / 10000, DAT_a1702cc0 != '\x02'))
    {
      dVar1 = (double)VectorUnsignedToFloat((1 << DAT_a1702cd3) << 7,(byte)(in_fpscr >> 0x16) & 3);
      dVar2 = (double)VectorUnsignedToFloat
                                ((int)((uint)DAT_a1702cde + (uint)DAT_a1702ce0) >> 1,
                                 (byte)(in_fpscr >> 0x16) & 3);
      DAT_a1702ca4 = VectorFloatToUnsigned(((dVar1 * DAT_a037dbf8) / dVar2) / DAT_a037dc00,3);
      DAT_a1702ca8 = DAT_a1702ca4;
      FUN_a02a70ec(s_MaxBias__d_a05fe964,1 << DAT_a1702cd3);
      FUN_a02a70ec(s_FocalValue__d_a05fe970,DAT_a0757a54);
      FUN_a02a70ec(s_EisMv_MaxAngX__d_a05fe980,DAT_a1702ca4);
      FUN_a02a70ec(s_EisMv_MaxAngY__d_a05fe994,DAT_a1702ca8);
    }
  }
  FUN_a02a70ec(s_____AmbaImgEisCtrl_Init_finish___a05fe9a8);
  return;
}

