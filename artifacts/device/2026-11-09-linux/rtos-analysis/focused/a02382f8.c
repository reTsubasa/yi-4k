/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 videoanal_register_callback(int param_1,undefined4 param_2)

{
  int *piVar1;
  undefined4 uVar2;
  int iVar3;
  undefined1 *puVar4;
  undefined4 uVar5;
  
  if (param_1 == 1) {
    uVar5 = 0x2000004;
  }
  else {
    uVar5 = 0x2000008;
    if (param_1 != 2) {
      uVar5 = 0x2000009;
    }
  }
  matched_FUN_a03bc46c(DAT_a0238390,0xffffffff);
  uVar2 = DAT_a0238390;
  iVar3 = 0;
  puVar4 = &DAT_a14307b8;
  do {
    piVar1 = (int *)(puVar4 + 0x1dc);
    puVar4 = puVar4 + 8;
    if (*piVar1 == 0) {
      iVar3 = (iVar3 + 0x3b) * 8;
      *(undefined4 *)(&DAT_a14307bc + iVar3) = param_2;
      *(undefined4 *)(iVar3 + -0x5ebcf840) = uVar5;
      matched_thunk_FUN_a03c3c5c(uVar2);
      return 0;
    }
    iVar3 = iVar3 + 1;
  } while (iVar3 != 0x10);
  matched_thunk_FUN_a03c3c5c(DAT_a0238390);
  return 0xffffffff;
}

