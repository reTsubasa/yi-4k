/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Restarted to delay deadcode elimination for space: ram */

undefined4 matched_FUN_a029cb84(uint param_1)

{
  uint uVar1;
  int iVar2;
  int iVar3;
  char *pcVar4;
  int iVar5;
  undefined4 uVar6;
  
  if (param_1 == 0) {
    return 0xffffffff;
  }
  uVar1 = matched_FUN_a04fb00c(param_1,s_std__basic_istream<char,_std::ch_a0643414 + 0x30);
  if (param_1 < uVar1 || uVar1 == 0) {
    return 0xffffffff;
  }
  iVar2 = matched_FUN_a04fb00c(0,s_1_____awb_no_whites____d___6d____a05fc8e8 + 0x30);
  if (iVar2 != 0) {
    DAT_a14466a4 = matched_analyst_fs_fopen(iVar2,s__d__d_raw_a0576b54 + 8);
    DAT_a06f3068 = (code *)&DAT_a029c6dc;
  }
  iVar2 = matched_FUN_a04f99f0(uVar1);
  if (iVar2 < 0) {
    uVar6 = 0xffffffff;
  }
  else {
    iVar5 = 0;
    pcVar4 = (char *)(uVar1 - 1);
    iVar3 = 0;
    uVar6 = 0xffffffff;
    do {
      pcVar4 = pcVar4 + 1;
      iVar5 = iVar5 + 1;
      if (*pcVar4 == ';' || (int)pcVar4 - uVar1 == iVar2) {
        *pcVar4 = '\0';
        uVar6 = FUN_a029c974(uVar1 + iVar3);
        iVar3 = iVar5;
      }
    } while (iVar5 <= iVar2);
  }
  if (DAT_a14466a4 != 0) {
    matched_analyst_fs_fclose();
    DAT_a06f3068 = matched_FUN_a02a72a8;
    DAT_a14466a4 = 0;
  }
  return uVar6;
}

