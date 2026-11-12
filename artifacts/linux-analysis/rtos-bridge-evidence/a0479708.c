/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0479708, name: FUN_a0479708.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_a0479708(undefined4 param_1)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  
  if (_DAT_a1a30f1c == 0) {
    _DAT_a1a30f1c = FUN_a03c4e94(0,0x20000001,1);
  }
  iVar1 = FUN_a03cd2d8(0x401);
  if (iVar1 == 0) {
    FUN_a02a70ec(s__s__fail_to_create_pArg_a06264a8,s_AmpNetUtility_luExecNoResponse_a0626508);
    uVar3 = 0xffffffff;
  }
  else {
    FUN_a04f8dec(iVar1,0,0x401);
    iVar2 = FUN_a04f99f0(param_1);
    if (iVar2 + 1 < 0x400) {
      FUN_a029c680(iVar1,param_1);
      iVar2 = FUN_a03c4f40(_DAT_a1a30f1c,2,iVar1,iVar2 + 2,0,0,0);
      if (iVar2 == 0) {
        uVar3 = 0;
      }
      else {
        uVar3 = 0xffffffff;
        FUN_a02a70ec(s__s__fail_to_do_AmbaIPC_ClientCal_a06264e0,
                     s_AmpNetUtility_luExecNoResponse_a0626508);
      }
    }
    else {
      uVar3 = 0xffffffff;
      FUN_a02a70ec(s__s__sh_cmd_too_long__d__Max__d_a06264c0,
                   s_AmpNetUtility_luExecNoResponse_a0626508,iVar2 + 1,0x400);
    }
    FUN_a03cd264(iVar1);
  }
  return uVar3;
}

