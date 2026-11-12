/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


uint rtos_virtual_to_physical(uint param_1)

{
  uint uVar1;
  int iVar2;
  uint *puVar3;
  int iVar4;
  
  puVar3 = &DAT_a078c0fc;
  do {
    uVar1 = *puVar3;
    if ((uVar1 <= param_1) && (param_1 < uVar1 + puVar3[2])) {
      return (param_1 + puVar3[1]) - uVar1;
    }
    puVar3 = puVar3 + 4;
  } while (puVar3 != (uint *)0xa078c13c);
  if (DAT_a06f22f4 == 0) {
    return param_1;
  }
  if (DAT_a06f22f8 < 1) {
    return param_1;
  }
  iVar4 = 0;
  iVar2 = DAT_a06f22f4;
  while( true ) {
    uVar1 = *(uint *)(DAT_a06f22f4 + iVar4 * 0x10);
    iVar4 = iVar4 + 1;
    if ((uVar1 <= param_1) && (param_1 < uVar1 + *(int *)(iVar2 + 8))) break;
    iVar2 = iVar2 + 0x10;
    if (iVar4 == DAT_a06f22f8) {
      return param_1;
    }
  }
  return (param_1 + *(int *)(iVar2 + 4)) - uVar1;
}

