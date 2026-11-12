/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 syslog_get_info(undefined4 *param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar3;
  
  if ((DAT_a06f30ac == '\0' || param_1 == (undefined4 *)0x0) ||
     (iVar3 = matched_FUN_a03bc46c(&DAT_a06f30b0,0xffffffff), iVar3 != 0)) {
    return 0xffffffff;
  }
  matched_FUN_a04f8dec(param_1,0,0x14);
  uVar1 = DAT_a02a7900;
  *param_1 = DAT_a06f309c;
  uVar2 = DAT_a06f30a0;
  param_1[2] = DAT_a06f30a4;
  param_1[1] = uVar2;
  param_1[3] = DAT_a06f30a8;
  if (DAT_a06f30ac == '\x02') {
    *(undefined1 *)(param_1 + 4) = 1;
  }
  else {
    *(undefined1 *)(param_1 + 4) = 0;
  }
  matched_thunk_FUN_a03c3c5c(uVar1);
  return 0;
}

