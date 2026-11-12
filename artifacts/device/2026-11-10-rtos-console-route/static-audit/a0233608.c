/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int console_audit_a0233608(void)

{
  int iVar1;
  undefined4 local_40;
  undefined4 local_3c;
  undefined4 local_38;
  undefined4 local_34;
  code *local_30;
  undefined1 *local_2c;
  undefined1 *local_28;
  undefined1 *local_24;
  
  local_40 = 0;
  local_3c = 0;
  local_38 = 0;
  local_34 = 0;
  FUN_a02a70ec(s_USB_UVC__Applib___Usb_UVC__Start_a05a0cc0);
  if (DAT_a142fb6c == 1) {
    FUN_a02a70ec(s_USB_UVC__AppLib___UsbUvc__AppCdc_a05a0ce4);
    return 0;
  }
  matched_FUN_a022f07c();
  iVar1 = matched_FUN_a022f168(5);
  if (iVar1 < 0) {
    FUN_a02a70ec(s_USB_UVC__Applib___Usb_Uvc__AppLi_a05a0d20);
    iVar1 = -1;
  }
  else {
    local_40 = CONCAT31(local_40._1_3_,9);
    local_38 = 0x46;
    local_3c = 0x3000;
    iVar1 = matched_FUN_a04b35b0(&local_40);
    if (iVar1 < 0) {
      FUN_a02a70ec(s_USB_UVC__Applib___Usb_Uvc__AmbaU_a05a0d5c);
      iVar1 = -2;
    }
    else {
      local_30 = console_audit_a0233340;
      local_2c = &LAB_a02332c4;
      local_28 = &LAB_a023316c;
      local_24 = &LAB_a0232e74;
      DAT_a142fb50 = 0;
      DAT_a142fa2c = 0;
      if (DAT_a142fa6c == 0) {
        iVar1 = matched_FUN_a029a7d8(DAT_a13a23e4,&DAT_a142fa10,&DAT_a142fa0c,0x1000,0x20);
        if (iVar1 == 0) {
          iVar1 = matched_FUN_a03bc77c(DAT_a13a23e4,&DAT_a142fb70,0x100000,0x20);
          if (iVar1 == 0) {
            iVar1 = matched_FUN_a03bc77c(DAT_a13a23e4,&DAT_a142fb64,0x100000,0x20);
            if (iVar1 == 0) {
              iVar1 = matched_FUN_a03bc77c(DAT_a13a23e4,&DAT_a142fb54,0xa00,0x20);
              if (iVar1 == 0) {
                iVar1 = matched_FUN_a03bc534(&DAT_a142fa30,DAT_a142fb58,0x14,0x80);
                if (iVar1 == 0) {
                  iVar1 = matched_analyst_task_create
                                    (&DAT_a142fa6c,s_UVCD_send_thread_a05a0e64,100,
                                     matched_FUN_a0232e90,0,DAT_a142fa10,0x1000,1);
                  if (iVar1 == 0) {
                    matched_FUN_a04b6128(&local_30);
                    FUN_a02a70ec(s_uvc_shell_initialized__a05a0e98,s_AppUvcd_ResourceCreate_a05a0960
                                );
                  }
                  else {
                    FUN_a02a70ec(s__Error___s_____s__a05a0d98,s_AppUvcd_ResourceCreate_a05a0960,
                                 s_can_not_create_uvc_send_thread_a05a0e78);
                  }
                }
                else {
                  FUN_a02a70ec(s__Error___s_____s__a05a0d98,s_AppUvcd_ResourceCreate_a05a0960,
                               s_can_not_create_uvc_message_queue_a05a0e40);
                }
              }
              else {
                FUN_a02a70ec(s__Error___s_____s__a05a0d98,s_AppUvcd_ResourceCreate_a05a0960,
                             s_can_not_create_uvc_message_queue_a05a0e18);
              }
            }
            else {
              FUN_a02a70ec(s__Error___s_____s__a05a0d98,s_AppUvcd_ResourceCreate_a05a0960,
                           s_can_not_create_uvc_data_buffer_a05a0df8);
            }
          }
          else {
            FUN_a02a70ec(s__Error___s_____s__a05a0d98,s_AppUvcd_ResourceCreate_a05a0960,
                         s_can_not_create_uvc_send_buffer_a05a0dd8);
          }
        }
        else {
          FUN_a02a70ec(s__Error___s_____s__a05a0d98,s_AppUvcd_ResourceCreate_a05a0960,
                       s_can_not_create_stack_for_uvc_sen_a05a0dac);
        }
      }
      else {
        FUN_a02a70ec(s__Error___s____uvc_send_thread_is_a05a0eb0,s_AppUvcd_ResourceCreate_a05a0960);
      }
      iVar1 = matched_FUN_a04b2bd8(1);
      if (iVar1 < 0) {
        FUN_a02a70ec(s_USB_UVC__Applib___Usb_Uvc__AppLi_a05a0edc);
        iVar1 = -4;
      }
      else {
        DAT_a142fb6c = 1;
      }
    }
  }
  return iVar1;
}

