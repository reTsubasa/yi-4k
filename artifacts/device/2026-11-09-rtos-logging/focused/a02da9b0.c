/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int shell_syslog_handler(int param_1,int param_2)

{
  int iVar1;
  uint uVar2;
  int iVar3;
  uint uVar4;
  char *pcVar5;
  undefined4 uVar6;
  int iVar7;
  int iVar8;
  uint uStack_2c;
  uint uStack_28;
  uint uStack_24;
  uint uStack_20;
  uint uStack_1c;
  
  if (param_1 < 2) {
LAB_a02dab1c:
    iVar1 = -1;
  }
  else {
    uVar6 = *(undefined4 *)(param_2 + 4);
    iVar1 = matched_FUN_a04f9744(uVar6,s_dsp_dec_cmd_on_a05ccad8 + 0xc);
    if (iVar1 == 0) {
      iVar1 = syslog_set_enabled(1);
    }
    else {
      iVar1 = matched_FUN_a04f9744(uVar6,s_dsp_dec_cmd_off_a05ccae8 + 0xc);
      if (iVar1 == 0) {
        iVar1 = syslog_set_enabled();
      }
      else {
        iVar1 = matched_FUN_a04f9744(uVar6,s_flush_a059c1c4);
        if (iVar1 != 0) {
          uVar2 = matched_FUN_a04f9744(uVar6,s_t_imgproc__awb__video___show_vid_a05fcedc + 0x28);
          if (uVar2 == 0) {
            uStack_2c = uVar2;
            uStack_28 = uVar2;
            uStack_24 = uVar2;
            uStack_20 = uVar2;
            uStack_1c = uVar2;
            iVar1 = syslog_get_info(&uStack_2c);
            if (iVar1 == 0) {
              FUN_a02a70ec(&DAT_a05a6c90);
              FUN_a02a70ec(s_System_Log_Information_a05cc7ac);
              FUN_a02a70ec(s__________________________________a0566710);
              FUN_a02a70ec(s_SysLog_Base___0x_X_a05cc7c4,uStack_2c);
              FUN_a02a70ec(s_SysLog_Limit___0x_X_a05cc7dc,uStack_24);
              FUN_a02a70ec(s_SysLog_Ptr___0x_X_a05cc7f4,uStack_28);
              FUN_a02a70ec(s_SysLog_Size___0x_X_a05cc80c,uStack_20);
              if ((uStack_1c & 0xff) == 1) {
                pcVar5 = s_dbgthd__thread_mask____Set_dsp_l_a05cee0c + 100;
              }
              else {
                pcVar5 = s__I__MISC_POWEROFF___06d___s__Low_a052fc24 + 0x28;
              }
              FUN_a02a70ec(s_SysLog_State____s_a05cc824,pcVar5);
              FUN_a02a70ec(&DAT_a05a6c90);
              return 0;
            }
            goto LAB_a02dab20;
          }
          iVar1 = matched_FUN_a04f9744(uVar6,s_reg_dump_a056a384 + 4);
          if (iVar1 == 0) {
            if ((param_1 != 2) && (iVar1 = *(int *)(param_2 + 8), iVar1 != 0)) {
              iVar3 = syslog_get_info(&uStack_2c);
              if (iVar3 == 0) {
                uVar2 = uStack_1c & 0xff;
                syslog_set_enabled();
                iVar3 = matched_analyst_fs_fopen(iVar1,s__d__d_raw_a0576b54 + 8);
                if (iVar3 != 0) {
                  if (uStack_20 == 0x20000) {
                    iVar7 = uStack_24 - uStack_28;
                    iVar8 = 0x20000 - iVar7;
                    iVar1 = matched_analyst_fs_fwrite(uStack_28,1,iVar7,iVar3);
                    if (iVar7 != iVar1) {
                      FUN_a02a70ec(s_write_SysLog_buffer_size_0x_X_is_a05cc84c,iVar1,iVar7);
                    }
                    if ((iVar8 != 0) &&
                       (iVar1 = matched_analyst_fs_fwrite(uStack_2c,1,iVar8,iVar3), iVar8 != iVar1))
                    {
                      FUN_a02a70ec(s_write_SysLog_buffer_size_0x_X_is_a05cc87c,iVar1,iVar8);
                    }
                  }
                  else {
                    uVar4 = matched_analyst_fs_fwrite(uStack_2c,1,uStack_20,iVar3);
                    if (uStack_20 != uVar4) {
                      FUN_a02a70ec(s_write_SysLog_buffer_size_0x_X_is_a05cc84c,uVar4,0);
                    }
                  }
                  matched_analyst_fs_fclose(iVar3);
                  syslog_set_enabled(uVar2);
                  FUN_a02a70ec(s_Dump_system_log__s_a05cc8b0,*(undefined4 *)(param_2 + 8));
                  return 0;
                }
                FUN_a02a70ec(s_Can_not_create__s_a05cc838,iVar1);
                syslog_set_enabled(uVar2);
              }
              else {
                FUN_a02a70ec(s_Dump_System_log_fail___a05cc794);
              }
            }
            FUN_a02a70ec(s_Dump_system_log_fail___a05cc8c4);
          }
          else {
            iVar1 = matched_FUN_a04f9744(uVar6,&DAT_a0564e98);
            if (iVar1 == 0) {
              FUN_a02da82c();
              return 0;
            }
          }
          goto LAB_a02dab1c;
        }
        iVar1 = matched_FUN_a02a7654();
      }
    }
    if (iVar1 == 0) {
      return 0;
    }
  }
LAB_a02dab20:
  FUN_a02a70ec(&DAT_a05a6c90);
  FUN_a02a70ec(s_System_Log_Usage_a05cc8dc);
  FUN_a02a70ec(s__________________________________a0566710);
  FUN_a02a70ec(s_on_off___enable_disable_write_de_a05cc8f0);
  FUN_a02a70ec(s_flush___Flush_SysLog_setting_a05cc930);
  FUN_a02a70ec(s_info___Show_SysLog_s_information_a05cc954);
  FUN_a02a70ec(s_dump__Path____Save_SysLog_s_buff_a05cc980);
  FUN_a02a70ec(s_show___Print_SysLog_s_buffer_to_c_a05cc9b0);
  FUN_a02a70ec(&DAT_a05a6c90);
  return iVar1;
}

