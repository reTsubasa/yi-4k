/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 matched_FUN_a0495c7c(void)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  uint uVar4;
  uint *puVar5;
  undefined4 local_28;
  uint local_24;
  
  local_28 = 0x10002;
  local_24 = 0;
  uVar2 = matched_FUN_a04a4b68();
  iVar1 = DAT_a062aca0;
  puVar5 = DAT_a0495d2c;
  *(undefined4 *)(DAT_a062aca0 + 0x30) = 0x44444444;
  uVar3 = 0;
  do {
    *puVar5 = uVar2 / 1000000;
    uVar4 = uVar3 + 1;
    *(uint *)(iVar1 + 0x30) = *(uint *)(iVar1 + 0x30) & ~(1 << ((uVar3 & 0x3f) << 2));
    matched_FUN_a0481608(uVar3 & 0xff);
    uVar3 = puVar5[-2];
    matched_FUN_a049758c((char)uVar3);
    local_24 = puVar5[-1];
    matched_FUN_a04975bc((char)uVar3,&local_28);
    uVar3 = uVar4;
    puVar5 = puVar5 + 7;
  } while (uVar4 != 8);
  return 0;
}

