/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 print_close_log_output(void)

{
  int iVar1;
  undefined4 uVar2;
  int local_2090 [2];
  code *local_2088;
  undefined1 auStack_2030 [8220];
  
  matched_FUN_a04f8dec(auStack_2030,0,0x2018);
  matched_FUN_a04f8dec(local_2090,0,0x60);
  iVar1 = matched_FUN_a03bc46c(DAT_a02a6cd0,0xffffffff);
  if (iVar1 == 0) {
    matched_FUN_a029c680(auStack_2030,DAT_a02a6cd4,0x2018);
    matched_FUN_a029c680(local_2090,&DAT_a144b780,0x60);
    DAT_a144b780 = iVar1;
    DAT_a144b784 = iVar1;
    DAT_a144b788 = iVar1;
    matched_thunk_FUN_a03c3c5c(DAT_a02a6cd0);
    iVar1 = matched_FUN_a03bc46c(&DAT_a144b78c,0xffffffff);
    if (iVar1 == 0) {
      print_flush_log_buffer(local_2090,auStack_2030,0);
      matched_thunk_FUN_a03c3c5c(&DAT_a144b78c);
    }
    uVar2 = 0;
    if ((local_2088 != (code *)0x0) && (local_2090[0] != 0)) {
      (*local_2088)();
    }
  }
  else {
    uVar2 = 0xffffffff;
  }
  return uVar2;
}

