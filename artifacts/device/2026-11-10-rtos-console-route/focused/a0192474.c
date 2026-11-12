/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 console_audit_a0192474(int param_1)

{
  char cVar1;
  int *local_14 [2];
  
  matched_FUN_a01881f4(local_14);
  if (param_1 != 0) {
    matched_FUN_a04b2bd8(0);
    cVar1 = *(char *)(DAT_a1055cd4 + 0x77);
    if (cVar1 == '\0') {
      matched_FUN_a022f3c8(1);
      matched_FUN_a022f364();
      matched_FUN_a017575c();
      matched_FUN_a022f4b4();
      DAT_a105604c = cVar1;
    }
    else if (cVar1 == '\x01') {
      matched_FUN_a0231038(1);
      matched_FUN_a0231058();
      DAT_a105604c = cVar1;
    }
    else if (cVar1 == '\x02') {
      FUN_a02a70ec(s__sHMSG_USB_DETECT_CONNECT__USB_U_a055f1f4,DAT_a06f3084);
      console_audit_a0231fc8();
      matched_FUN_a02965c0(1);
      DAT_a105604c = cVar1;
    }
    else if (cVar1 == '\x03') {
      FUN_a02a70ec(s__I__APP_UTIL___06d___s__USB_mode_a055f220,0x54e,
                   s_AppUtil_UsbChargeCheckingSet_a055ebd8);
      (*(code *)local_14[0][10])(0xf0ff0139,0,0);
      FUN_a02a70ec(s__I__APP_UTIL___06d___s__USB_mode_a055f25c,0x550,
                   s_AppUtil_UsbChargeCheckingSet_a055ebd8);
      console_audit_a0233608();
      DAT_a105604c = cVar1;
    }
    else {
      FUN_a02a70ec(s__I__APP_UTIL___06d___s__USB_mode_a055f298,0x556,
                   s_AppUtil_UsbChargeCheckingSet_a055ebd8,cVar1);
    }
    DAT_a1056040 = 1;
    return 0;
  }
  if (DAT_a105604c == '\0') {
    if (*local_14[0] == DAT_a069b008) {
      matched_FUN_a022f3c8(0);
      (*(code *)local_14[0][10])(0xf0010315,0,0);
    }
    else {
      matched_FUN_a022f3c8(0);
      matched_FUN_a022f55c();
      matched_FUN_a01758b0();
    }
  }
  else if (DAT_a105604c == '\x01') {
    matched_FUN_a0231038(0);
    if (*local_14[0] == DAT_a069b038) {
      (*(code *)local_14[0][10])(0xf0010315,0,0);
    }
    else {
      matched_FUN_a0231384();
    }
  }
  else if (DAT_a105604c == '\x02') {
    FUN_a02a70ec(s__I__APP_UTIL___06d___s__USB_mode_a055f2c8,0x578,
                 s_AppUtil_UsbChargeCheckingSet_a055ebd8);
    matched_thunk_FUN_a0231a1c();
    matched_FUN_a02965c0(0);
  }
  else if (DAT_a105604c == '\x03') {
    matched_FUN_a0233938();
  }
  else {
    FUN_a02a70ec(s__I__APP_UTIL___06d___s__USB_mode_a055f298,0x582,
                 s_AppUtil_UsbChargeCheckingSet_a055ebd8,*(undefined1 *)(DAT_a1055cd4 + 0x77));
  }
  DAT_a1056040 = 0;
  matched_FUN_a04b2e68(0,0);
  return 0;
}

