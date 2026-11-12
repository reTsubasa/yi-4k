/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void image_eof(uint param_1)

{
  if (DAT_a1704300 < param_1) {
    DAT_a1702c51 = (char)param_1 - (char)DAT_a1704300;
  }
  DAT_a17042fc = param_1;
  if ((DAT_a0757b28 & 4) != 0) {
    FUN_a02a70ec(s_EofTime__d__FrameReadOutTime__d_a05fe79c,param_1,DAT_a1702c51);
  }
  return;
}

