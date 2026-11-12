/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0244b54, name: FUN_a0244b54.
 * Types and names may be inferred. Runtime validation not performed. */


int FUN_a0244b54(void)

{
  int iVar1;
  undefined4 extraout_r2;
  undefined4 uVar2;
  undefined4 extraout_r2_00;
  undefined4 in_r3;
  
  if (DAT_a1443d11 != '\0') {
    return 0;
  }
  iVar1 = FUN_a021fb38();
  if ((iVar1 == 0) && ((DAT_a06e6451 & 2) != 0)) {
    iVar1 = FUN_a0479708(s__usr_bin_AmbaRTSPServer___en_aud_a0564ee8);
    uVar2 = extraout_r2_00;
  }
  else {
    iVar1 = FUN_a0479708(s__usr_bin_AmbaRTSPServer_a0564f18);
    uVar2 = extraout_r2;
  }
  if (iVar1 == 0) {
    DAT_a1443d11 = 1;
    return 0;
  }
  FUN_a02a70ec(s__s_AppLib___NetFifo__<StartRTSPS_a05a6520,DAT_a06f3080,uVar2,&DAT_a06f307c,in_r3);
  return iVar1;
}

