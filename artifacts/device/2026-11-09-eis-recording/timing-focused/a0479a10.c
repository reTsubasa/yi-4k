/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 matched_FUN_a0479a10(undefined4 param_1,float *param_2)

{
  int iVar1;
  uint in_fpscr;
  float fVar2;
  float fVar3;
  
  fVar3 = (float)VectorUnsignedToFloat(DAT_a1a31034,(byte)(in_fpscr >> 0x16) & 3);
  fVar3 = DAT_a1a30f48 / fVar3;
  iVar1 = matched_FUN_a0506418(DAT_a1a31038,DAT_a1a3103c);
  fVar2 = (float)VectorUnsignedToFloat
                           ((DAT_a1a31054 * iVar1 + iVar1) - DAT_a1a31058,
                            (byte)(in_fpscr >> 0x16) & 3);
  *param_2 = fVar3 * fVar2;
  return 0;
}

