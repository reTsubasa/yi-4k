/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 sharepreview_default_config(undefined4 *param_1)

{
  *(undefined2 *)((int)param_1 + 0x16) = 0x2f0;
  *(undefined2 *)(param_1 + 5) = 0x400;
  param_1[1] = 0xb4;
  param_1[2] = 0x2000;
  *param_1 = 0;
  *(undefined2 *)((int)param_1 + 0x12) = 0;
  *(undefined2 *)(param_1 + 4) = 2;
  param_1[3] = 2;
  return 0;
}

