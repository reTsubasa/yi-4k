/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int console_audit_a0231fc8(void)

{
  int iVar1;
  undefined4 local_20;
  undefined4 local_1c;
  undefined4 local_18;
  undefined4 local_14;
  
  local_20 = 0;
  local_1c = 0;
  local_18 = 0;
  local_14 = 0;
  FUN_a02a70ec(s__I__USB_UART___06d___s___Applib___a05a05b8,0x1e2,s_ApplibUsbUart_Start_a05a077c);
  if (DAT_a142f9c0 == 1) {
    FUN_a02a70ec(s__s_E__USB_UART___06d___s___AppLi_a05a05ec,DAT_a06f3084,0x1e6,
                 s_ApplibUsbUart_Start_a05a077c);
    return 0;
  }
  matched_FUN_a022f07c();
  iVar1 = matched_FUN_a022f168(4);
  if (iVar1 < 0) {
    FUN_a02a70ec(s__s_E__USB_UART___06d___s___Appli_a05a063c,DAT_a06f3084,0x1ef,
                 s_ApplibUsbUart_Start_a05a077c);
    iVar1 = -1;
  }
  else {
    local_20 = CONCAT31(local_20._1_3_,4);
    local_18 = 0x46;
    local_1c = 0x3000;
    iVar1 = matched_FUN_a04b35b0(&local_20);
    if (iVar1 < 0) {
      FUN_a02a70ec(s__s_E__USB_UART___06d___s___Appli_a05a068c,DAT_a06f3084,0x1fa,
                   s_ApplibUsbUart_Start_a05a077c);
      iVar1 = -2;
    }
    else {
      iVar1 = console_audit_a023166c();
      if (iVar1 < 0) {
        FUN_a02a70ec(s__s_E__USB_UART___06d___s___Appli_a05a06dc,DAT_a06f3084,0x201,
                     s_ApplibUsbUart_Start_a05a077c);
        iVar1 = -3;
      }
      else {
        iVar1 = matched_FUN_a04b2bd8(1);
        if (iVar1 < 0) {
          FUN_a02a70ec(s__s_E__USB_UART___06d___s___Appli_a05a0724,DAT_a06f3084,0x213,
                       s_ApplibUsbUart_Start_a05a077c);
          iVar1 = -4;
        }
        else {
          DAT_a142f9c0 = 1;
          DAT_a06e63fc = 1;
        }
      }
    }
  }
  return iVar1;
}

