/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 rtos_mapping_cacheability_check(uint param_1)

{
  int iVar1;
  uint uVar2;
  uint *puVar3;
  int iVar4;
  
  puVar3 = &DAT_a078c0fc;
  do {
    if ((*puVar3 <= param_1) && (param_1 < *puVar3 + puVar3[2])) {
      uVar2 = (*(byte *)((int)puVar3 + 0xd) & 0x7f) >> 4;
      if (uVar2 < 4) {
        if ((puVar3[3] & 8) != 0) {
          return 0;
        }
      }
      else if (uVar2 != 4) {
        return 0;
      }
    }
    puVar3 = puVar3 + 4;
  } while (puVar3 != (uint *)0xa078c13c);
  if ((DAT_a06f22f4 != 0) && (0 < DAT_a06f22f8)) {
    iVar4 = 0;
    iVar1 = DAT_a06f22f4;
    do {
      uVar2 = *(uint *)(DAT_a06f22f4 + iVar4 * 0x10);
      iVar4 = iVar4 + 1;
      if ((uVar2 <= param_1) && (param_1 < uVar2 + *(int *)(iVar1 + 8))) {
        uVar2 = (*(byte *)(iVar1 + 0xd) & 0x7f) >> 4;
        if (uVar2 < 4) {
          if ((*(byte *)(iVar1 + 0xc) & 8) != 0) {
            return 0;
          }
        }
        else if (uVar2 != 4) {
          return 0;
        }
      }
      iVar1 = iVar1 + 0x10;
    } while (iVar4 != DAT_a06f22f8);
  }
  return 0xffffffff;
}

