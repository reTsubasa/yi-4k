/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 syslog_set_enabled(int param_1)

{
  int iVar1;
  
  if ((DAT_a06f30ac == '\0') || (iVar1 = matched_FUN_a03bc46c(&DAT_a06f30b0,0xffffffff), iVar1 != 0)
     ) {
    return 0xffffffff;
  }
  if (param_1 == 0) {
    DAT_a06f30ac = 1;
  }
  else {
    DAT_a06f30ac = 2;
  }
  matched_thunk_FUN_a03c3c5c(DAT_a02a7650);
  return 0;
}

