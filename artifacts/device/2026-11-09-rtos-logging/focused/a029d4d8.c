/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void shell_command_worker(void)

{
  int iVar1;
  uint uVar2;
  int iVar3;
  uint local_c;
  
  iVar1 = DAT_a029d5ac;
  do {
    while( true ) {
      while( true ) {
        matched_FUN_a03bc4ac(DAT_a029d5b0,3,0,&local_c,0xffffffff);
        if ((local_c & 2) == 0) break;
        shell_script_interpreter(s_c__autoexec_ash_a05ae4a8);
        matched_FUN_a03bc4f0(DAT_a029d5b0,2);
      }
      if ((local_c & 1) == 0) break;
      uVar2 = matched_FUN_a04f99f0(DAT_a029d5ac);
      if ((uVar2 < 5) ||
         (iVar3 = matched_FUN_a04f9744(iVar1 + (uVar2 - 4),&DAT_a05ae4b8), iVar3 != 0)) {
        FUN_a029ccb8(DAT_a029d5ac);
      }
      else {
        shell_script_interpreter(DAT_a029d5ac);
      }
      matched_FUN_a03bc4f0(DAT_a029d5b0,1);
      matched_FUN_a03bc4e8(DAT_a029d5b0,0x10);
    }
    FUN_a02a70ec(s_ActualFlag_error___0x_08X_a05ae4c0);
    matched_FUN_a03bc4f0(DAT_a029d5b0,3);
  } while( true );
}

