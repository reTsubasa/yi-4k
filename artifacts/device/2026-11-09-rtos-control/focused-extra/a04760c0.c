/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 lnxcmd_status_callback(char *param_1)

{
  undefined1 uVar1;
  undefined4 uVar2;
  
  if (DAT_a1a30c04 == (code *)0x0) {
    FUN_a02a70ec(s__s__d__the_callback_for_receivin_a06254a0,s_AmpNetCtrl_LnxCmd_RecvStatus_a06251dc
                 ,0x75);
    return 0;
  }
  uVar1 = 0;
  if (*param_1 != '\0') {
    if (*param_1 == '\x01') {
      uVar1 = 1;
    }
    else {
      uVar1 = 2;
    }
  }
                    /* WARNING: Could not recover jumptable at 0xa04760ec. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  uVar2 = (*DAT_a1a30c04)(uVar1);
  return uVar2;
}

