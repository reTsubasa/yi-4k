/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 console_audit_a023166c(void)

{
  int iVar1;
  undefined4 uVar2;
  
  FUN_a02a70ec(s__I__USB_UART___06d___s__Entering_a059feb0,0xbb,s_AppCdcAcmd_Start_a059fdf8);
  DAT_a06e6410 = matched_FUN_a023229c(DAT_a06e63f8 + 10);
  if (DAT_a06e6410 == 0) {
    DAT_a06e6414 = matched_FUN_a023229c(DAT_a06e63f8 + 10);
    if (DAT_a06e6410 == 0) {
      if (DAT_a142f8d8 == 0) {
        iVar1 = matched_FUN_a029a7d8(DAT_a13a23e4,&DAT_a142f8d8,&DAT_a142f9c4,0x1000,0x20);
        if (iVar1 != 0) {
          uVar2 = 0xfffffffd;
          FUN_a02a70ec(s__s_E__USB_UART___06d___s___AppLi_a059ff94,DAT_a06f3084,0xd3,
                       s_AppCdcAcmd_Start_a059fdf8,iVar1);
          goto LAB_a0231868;
        }
      }
      if (DAT_a142f9b4 == 0) {
        iVar1 = matched_FUN_a029a7d8(DAT_a13a23e4,&DAT_a142f9b4,&DAT_a142f9bc,0x1000,0x20);
        if (iVar1 != 0) {
          uVar2 = 0xfffffffc;
          FUN_a02a70ec(s__s_E__USB_UART___06d___s___AppLi_a059ff94,DAT_a06f3084,0xe2,
                       s_AppCdcAcmd_Start_a059fdf8,iVar1);
          goto LAB_a0231868;
        }
      }
      if ((DAT_a142f7d8 == 0) && (iVar1 = matched_FUN_a03bc49c(), iVar1 != 0)) {
        uVar2 = 0xfffffffb;
        FUN_a02a70ec(s__s_E__USB_UART___06d___s__creat_U_a059ffe4,DAT_a06f3084,0xed,
                     s_AppCdcAcmd_Start_a059fdf8,iVar1);
      }
      else {
        DAT_a06e63fc = 1;
        matched_FUN_a03bc4e8(&DAT_a142f7d8,4);
        iVar1 = matched_analyst_task_create
                          (&DAT_a142f8dc,s_CDC_ACM_TASK_a05a0024,0xff,matched_FUN_a0231538,0,
                           DAT_a142f8d8,0x1000,1);
        if (iVar1 == 0) {
          iVar1 = matched_analyst_task_create
                            (&DAT_a142f800,s_CDC_ACM_RCV_TASK_a05a006c,0xa0,matched_FUN_a0231408,0,
                             DAT_a142f9b4,0x1000,1);
          if (iVar1 == 0) {
            if (DAT_a142f9b8 == '\0') {
              matched_FUN_a01b8c20();
            }
            FUN_a02a70ec(s__I__USB_UART___06d___s___________a05a00bc,0x110,
                         s_AppCdcAcmd_Start_a059fdf8);
            FUN_a02a70ec(s__I__USB_UART___06d___s__switch_t_a05a0104,0x111,
                         s_AppCdcAcmd_Start_a059fdf8);
            FUN_a02a70ec(s__I__USB_UART___06d___s__Broken_S_a05a0134,0x112,
                         s_AppCdcAcmd_Start_a059fdf8);
            FUN_a02a70ec(s__I__USB_UART___06d___s___________a05a00bc,0x113,
                         s_AppCdcAcmd_Start_a059fdf8);
            return 0;
          }
          uVar2 = 0xfffffff9;
          FUN_a02a70ec(s__s_E__USB_UART___06d___s__creat_U_a05a0080,DAT_a06f3084,0x107,
                       s_AppCdcAcmd_Start_a059fdf8,iVar1);
        }
        else {
          uVar2 = 0xfffffffa;
          FUN_a02a70ec(s__s_E__USB_UART___06d___s__creat_U_a05a0034,DAT_a06f3084,0xfc,
                       s_AppCdcAcmd_Start_a059fdf8,iVar1);
        }
      }
    }
    else {
      uVar2 = 0xfffffffe;
      FUN_a02a70ec(s__s_E__USB_UART___06d___s___AppLi_a059ff3c,DAT_a06f3084,0xc4,
                   s_AppCdcAcmd_Start_a059fdf8,0);
    }
  }
  else {
    uVar2 = 0xffffffff;
    FUN_a02a70ec(s__s_E__USB_UART___06d___s___AppLi_a059fee4,DAT_a06f3084,0xbe,
                 s_AppCdcAcmd_Start_a059fdf8,DAT_a06e6410);
  }
LAB_a0231868:
  FUN_a02a70ec(s__s_E__USB_UART___06d___s__AppCdc_a05a0164,DAT_a06f3084,0x116,
               s_AppCdcAcmd_Start_a059fdf8,uVar2);
  return uVar2;
}

