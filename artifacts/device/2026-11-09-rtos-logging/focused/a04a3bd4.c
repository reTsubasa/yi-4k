/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


uint rtos_phys_to_virtual(uint param_1)

{
  uint uVar1;
  int iVar2;
  int *piVar3;
  
  piVar3 = &DAT_a078c0fc;
  do {
    uVar1 = piVar3[1];
    if ((uVar1 <= param_1) && (param_1 < uVar1 + piVar3[2])) {
      return (param_1 + *piVar3) - uVar1;
    }
    piVar3 = piVar3 + 4;
  } while (piVar3 != (int *)0xa078c13c);
  if (DAT_a06f22f4 == (int *)0x0) {
    return param_1;
  }
  if (DAT_a06f22f8 < 1) {
    return param_1;
  }
  iVar2 = 0;
  piVar3 = DAT_a06f22f4;
  while( true ) {
    uVar1 = piVar3[1];
    iVar2 = iVar2 + 1;
    if ((uVar1 <= param_1) && (param_1 < uVar1 + piVar3[2])) break;
    piVar3 = piVar3 + 4;
    if (iVar2 == DAT_a06f22f8) {
      return param_1;
    }
  }
  return (param_1 + *piVar3) - uVar1;
}

