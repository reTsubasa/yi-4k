/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 app_poweroff_sequence(undefined4 param_1)

{
  int iVar1;
  uint uVar2;
  undefined4 uVar3;
  uint uVar4;
  
  switch(param_1) {
  case 0:
    matched_FUN_a0298008();
    matched_FUN_a0298020();
    return 0;
  default:
    return 0;
  case 3:
    DAT_a069b1cc = DAT_a069b1cc & 0xffffffef;
    return 0;
  case 4:
    break;
  case 5:
    if ((DAT_a069b1cc & 4) != 0) {
      return 0;
    }
    DAT_a069b1cc = DAT_a069b1cc | 0x14;
    matched_FUN_a01b6a00(0x15130002,0,0);
    DAT_a0fb306c = matched_FUN_a048e63c();
    if (DAT_a1055e80 == '\0') {
      matched_thunk_FUN_a01ad778(1);
    }
    matched_FUN_a01e6acc(1,matched_FUN_a01058a8);
    matched_FUN_a0197994(0);
    FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Wif_a052fb5c,0x5c,s_misc_poweroff_app_ready_a052fc84
                );
    matched_FUN_a012f804();
    FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Dum_a052fb8c,0x5e,s_misc_poweroff_app_ready_a052fc84
                );
    print_close_log_output();
    FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Dum_a052fbc0,0x60,s_misc_poweroff_app_ready_a052fc84
                );
    matched_FUN_a0197994(1);
    FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Cop_a052fbf0,100,s_misc_poweroff_app_ready_a052fc84)
    ;
    app_log_copy_to_sd(1);
    FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Low_a052fc24,0x66,s_misc_poweroff_app_ready_a052fc84
                );
    matched_FUN_a047f878();
    FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Fil_a052fc54,0x68,s_misc_poweroff_app_ready_a052fc84
                );
    matched_FUN_a01e5950();
    return 0;
  }
  matched_FUN_a0197994(2);
  FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Wai_a052faf8,0x80,s_misc_poweroff_sequence_a052fa98);
  iVar1 = matched_FUN_a01ad708(1);
  if (0 < iVar1) {
    uVar4 = iVar1 / 0xc0 + 0x96;
    uVar2 = matched_FUN_a048e63c(iVar1 * 0x2aaaaaab);
    if (DAT_a0fb306c < uVar2) {
      if (uVar4 < uVar2 - DAT_a0fb306c) goto LAB_a0105ad0;
      iVar1 = uVar4 - (uVar2 - DAT_a0fb306c);
    }
    else {
      iVar1 = 0;
    }
    matched_analyst_task_sleep(iVar1);
  }
LAB_a0105ad0:
  matched_FUN_a012f38c(0);
  FUN_a02a70ec(s__I__MISC_POWEROFF___06d___s__Pow_a052fb30,0x8e,s_misc_poweroff_sequence_a052fa98);
  matched_FUN_a049a3cc();
  if (*(uint *)(DAT_a1055cd4 + 0x84) != 0) {
    matched_FUN_a049a3e4((*(uint *)(DAT_a1055cd4 + 0x84) & 0xffff) >> 8);
  }
  uVar3 = matched_FUN_a049a440();
  return uVar3;
}

