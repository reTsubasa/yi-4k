/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 matched_FUN_a02c61d4(undefined4 *param_1,int param_2)

{
  int iVar1;
  
  if (param_1 != (undefined4 *)0x0) {
    if (*(int *)(DAT_a06f3380 + 0x58) != 0) {
      iVar1 = rtos_phys_to_virtual();
      if (param_2 == 0) {
        *param_1 = *(undefined4 *)(iVar1 + 0x10);
        param_1[1] = *(undefined4 *)(iVar1 + 0x20);
        param_1[2] = *(undefined4 *)(iVar1 + 0x24);
        param_1[3] = *(undefined4 *)(iVar1 + 0x28);
        param_1[4] = *(undefined4 *)(iVar1 + 0x2c);
        param_1[5] = *(undefined4 *)(iVar1 + 0x30);
        param_1[6] = *(undefined4 *)(iVar1 + 0x34);
        param_1[7] = *(undefined4 *)(iVar1 + 0x38);
        param_1[8] = *(undefined4 *)(iVar1 + 0x3c);
        return 0;
      }
      *(undefined4 *)(iVar1 + 0x3c) = param_1[8];
      return 0;
    }
  }
  return 0;
}

