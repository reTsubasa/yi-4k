/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void console_audit_a029c6dc
               (undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  int iVar1;
  int iVar2;
  undefined4 uStack_c;
  undefined4 uStack_8;
  undefined4 uStack_4;
  
  uStack_c = param_2;
  uStack_8 = param_3;
  uStack_4 = param_4;
  iVar2 = matched_FUN_a04ffa84(0xa085bba0,param_1,&uStack_c);
  iVar1 = DAT_a14466a4;
  *(undefined1 *)(iVar2 + -0x5f7a4460) = 0;
  if (iVar1 == 0) {
    matched_FUN_a02a7368(0xa085bba0,iVar2 + 1);
    return;
  }
  matched_analyst_fs_fwrite(0xa085bba0,1);
  return;
}

