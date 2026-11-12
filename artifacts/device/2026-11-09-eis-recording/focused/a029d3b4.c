/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 shell_script_interpreter(undefined4 param_1)

{
  char cVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  int iVar5;
  char *pcVar6;
  int iVar7;
  char local_120 [256];
  
  iVar2 = matched_analyst_fs_fopen(param_1,&DAT_a0541ae0);
  if (iVar2 == 0) {
    uVar4 = 0xffffffff;
  }
  else {
    iVar7 = 1;
    matched_FUN_a04f8dec(local_120,0,0x100);
    iVar5 = 0;
    pcVar6 = local_120;
    while (iVar3 = matched_analyst_fs_fread(pcVar6,1,1,iVar2), iVar3 != 0) {
      if (0xff < iVar5) {
        (*DAT_a06f3068)(s_Error__script_line__d__exceeds_m_a05ae470,iVar7);
        matched_analyst_fs_fclose(iVar2);
        return 0xffffffff;
      }
      cVar1 = local_120[iVar5];
      if (cVar1 == '\n' || (cVar1 == '\0' || cVar1 == '\r')) {
        local_120[iVar5] = '\0';
        if (cVar1 == '\n') {
          iVar7 = iVar7 + 1;
        }
        FUN_a029ccb8(local_120);
        matched_FUN_a04f8dec(local_120,0,0x100);
        iVar5 = 0;
        pcVar6 = local_120;
      }
      else if (cVar1 == '\t') {
        local_120[iVar5] = ' ';
      }
      else {
        pcVar6 = local_120 + iVar5 + 1;
        iVar5 = iVar5 + 1;
      }
    }
    matched_analyst_fs_fclose(iVar2);
    uVar4 = 0;
  }
  return uVar4;
}

