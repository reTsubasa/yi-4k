/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 sharepreview_frame_callback(undefined4 param_1,int param_2)

{
  undefined4 uVar1;
  
  DAT_a1443d1c = DAT_a1443d1c + 1;
  if (((*(short *)(param_2 + 0x12) == DAT_a1443d34) && (*(short *)(param_2 + 0x14) == DAT_a1443d36))
     && (DAT_a1443d1c == DAT_a1443d32)) {
    uVar1 = sharepreview_copy_and_reset_counter(param_2);
    return uVar1;
  }
  return 0;
}

