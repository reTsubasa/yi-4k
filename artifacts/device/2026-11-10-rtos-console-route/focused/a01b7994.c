/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void console_audit_a01b7994(void)

{
  int iVar1;
  char *pcVar2;
  int iVar3;
  undefined4 local_424;
  undefined4 local_420;
  int local_41c;
  char acStack_418 [1028];
  
  matched_FUN_a04f8dec(acStack_418,0,0x400);
  local_424 = 0;
  local_420 = 0;
  local_41c = 0;
joined_r0xa01b79d8:
  do {
    if (DAT_a1265430 == 0) {
      return;
    }
    iVar3 = 0;
    pcVar2 = acStack_418;
    do {
      iVar1 = matched_FUN_a0231f68(1,pcVar2,0xffffffff);
      if (iVar1 < 1) {
        FUN_a02a70ec(s__s_E__NET_CAR___06d___s__recv_ua_a056fce8,DAT_a06f3084,0x144,
                     s_NetCar_CliTaskEntry_a0570348);
        goto joined_r0xa01b79d8;
      }
    } while ((*pcVar2 != '\0') && (iVar3 = iVar3 + 1, pcVar2 = pcVar2 + 1, iVar3 != 0x400));
    local_41c = iVar3;
    iVar3 = matched_FUN_a03bc77c(DAT_a13a23e4,&local_424,iVar3,0x20);
    if (iVar3 < 0) {
      FUN_a02a70ec(s__s_E__NET_CAR___06d___s__malloc_f_a056fcb8,DAT_a06f3084,0x140,
                   s_NetCar_CliTaskEntry_a0570348);
    }
    else {
      matched_FUN_a029c680(local_424,acStack_418,local_41c);
      matched_FUN_a03bc598(DAT_a01b7ab8,&local_424,0xffffffff);
    }
  } while( true );
}

