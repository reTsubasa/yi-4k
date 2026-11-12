/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa01a18f8, name: FUN_a01a18f8.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Type propagation algorithm not settling */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* WARNING: Restarted to delay deadcode elimination for space: ram */

uint FUN_a01a18f8(int param_1,int param_2,code *param_3)

{
  code *pcVar1;
  byte bVar2;
  undefined1 uVar3;
  undefined1 uVar4;
  undefined1 uVar5;
  undefined2 uVar6;
  int iVar7;
  uint uVar8;
  int iVar9;
  int iVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  char *pcVar13;
  undefined4 *puVar14;
  undefined4 *puVar15;
  uint uVar16;
  undefined4 uVar17;
  uint in_fpscr;
  undefined4 extraout_s1;
  float fVar18;
  float fVar19;
  undefined8 uVar20;
  undefined2 local_120c;
  undefined1 local_1208;
  undefined1 local_1207;
  undefined4 local_11fc;
  undefined4 *local_11f8;
  int local_11f4;
  int local_11f0;
  undefined4 local_11ec;
  undefined4 local_11e8;
  undefined4 local_11e4;
  undefined4 auStack_118c [31];
  undefined4 local_1110;
  undefined4 local_110c;
  undefined4 local_1108;
  undefined4 local_1104;
  undefined4 local_1100;
  undefined4 uStack_10fc;
  float local_10f8;
  float local_10f4;
  undefined4 local_10f0;
  undefined4 local_10ec;
  undefined4 local_10e8;
  undefined1 local_10c4;
  undefined2 local_107e;
  undefined2 local_107c;
  undefined2 local_1076;
  undefined2 local_1074;
  undefined1 auStack_1030 [4100];
  
  if (param_1 < 3) goto LAB_a01a19dc;
  uVar17 = *(undefined4 *)(param_2 + 8);
  iVar7 = FUN_a04f9744(uVar17,s_chg_res_a0564664);
  if (iVar7 == 0) {
    uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
    if (DAT_a0fb334c == '\x05') {
      FUN_a02a70ec(s_____vf_____a056466c);
      thunk_FUN_a01e653c(0xf0010301,uVar17,0);
      return 0;
    }
    if (DAT_a0fb334c == '\x01' && (DAT_a1055cd8 & 0x38) == 0) {
      FUN_a02a70ec(s_error_current_status_is_recordin_a053d524);
      return 0;
    }
    FUN_a02a70ec(s_____other_state_____a0564678);
    *(char *)(_DAT_a1055cd4 + 4) = (char)uVar17;
    thunk_FUN_a01e653c(0xf0010301,uVar17,0);
    return 0;
  }
  iVar7 = FUN_a04f9744(uVar17,s_chg_LCD_a056468c);
  if (iVar7 == 0) {
    if (param_1 == 3) {
      FUN_a02a70ec(s_Usage__t_app_test_chg_LCD__LCDpa_a0564694);
      FUN_a02a70ec(s_The_LCDpanelIdx_list__a05646bc);
      FUN_a02a70ec(s_0__LCD_WDF9648W__default__a05646d8);
      FUN_a02a70ec(s_1__LCD_T30P61_a05646f8);
      FUN_a02a70ec(s_2__LCD_T20P52_a056470c);
      return 0;
    }
    uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
    if (uVar8 < 3) {
      thunk_FUN_a01e653c(0xf001031f,uVar8,0);
      return 0;
    }
    FUN_a02a70ec(s_The_LCDpanelIdx_is_not_available_a0564720,uVar8);
    return 0;
  }
  iVar7 = FUN_a04f9744(uVar17,s_chg_quality_a0564744);
  if (iVar7 == 0) {
    if (DAT_a0fb334c == '\x05') {
      FUN_a02a70ec(s_____vf_____a056466c);
    }
    else if (DAT_a0fb334c == '\x01' && (DAT_a1055cd8 & 0x38) == 0) {
      FUN_a02a70ec(s_error_current_status_is_recordin_a053d524);
      return 0;
    }
    if (param_1 == 3) {
      FUN_a02a70ec(s_please_input_param_a0564780);
      return 0;
    }
    uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
    if (uVar8 < 3) {
      thunk_FUN_a01e653c(0xf0010302,uVar8,0);
      return 0;
    }
    FUN_a02a70ec(s_please_input_quality_0_sfine_1_f_a0564750,uVar8);
    return 0;
  }
  iVar7 = FUN_a04f9744(uVar17,s_chg_split_a0564794);
  if (iVar7 != 0) {
    iVar7 = FUN_a04f9744(uVar17,s_chg_stamp_a056481c);
    if (iVar7 == 0) {
      if (param_1 == 3) {
        uVar8 = 0;
      }
      else {
        uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
        if (3 < uVar8) {
          FUN_a02a70ec(s_invalide_input_param__please_inp_a0564828);
          return 0;
        }
        if (param_1 != 4) {
          thunk_FUN_a01e653c(0xf0ff0139,0,0);
          FUN_a02a70ec(s______stop_vf_a056486c);
        }
      }
      FUN_a02a70ec(s___chg_stamp____d_a056487c,uVar8);
      if ((DAT_a1055cd8 & 0x38) == 8) {
        *(char *)(_DAT_a1055cd4 + 0x25) = (char)uVar8;
      }
      else if ((DAT_a1055cd8 & 0x38) == 0) {
        *(char *)(_DAT_a1055cd4 + 0xf) = (char)uVar8;
      }
LAB_a01a1b50:
      FUN_a018c6d8();
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,&DAT_a0564890);
    if (iVar7 == 0) {
      if (param_1 == 3) {
        FUN_a02a70ec(s_please_input_param_0_ntsc_1_pal_a0564898);
        return 0;
      }
      iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
      if (iVar7 == 0) {
        *(undefined1 *)(_DAT_a1055cd4 + 0x60) = 0;
        FUN_a0225e78();
        return 0;
      }
      if (iVar7 == 1) {
        *(undefined1 *)(_DAT_a1055cd4 + 0x60) = 1;
        FUN_a0225e78(1);
        return 0;
      }
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_chg_mode_a05648b8);
    if (iVar7 == 0) {
      uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
      thunk_FUN_a01e653c(0xf001030d,uVar17,0);
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,&DAT_a05648c4);
    if (iVar7 == 0) {
      FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
      FUN_a0191394();
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_Enable_Svc_a05a83e8 + 8);
    if (iVar7 == 0) {
      FUN_a02a70ec(s__s_______________>_t_app_test_vf_a05648cc,DAT_a06f3088);
      thunk_FUN_a01e653c(0xf0ff0139,0,0);
      thunk_FUN_a03c0b20(1);
      thunk_FUN_a01e653c(0xf001030d,1,0);
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_save_osd_a05648f4);
    if (iVar7 == 0) {
      FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
      FUN_a0203308();
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_convclut_a0564900);
    if (iVar7 == 0) {
      FUN_a0181da8();
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_set_freq_a0564a98 + 4);
    if (iVar7 == 0) {
      FUN_a02a70ec(s__________System_Freq_____________a056490c);
      uVar17 = FUN_a0499f3c();
      FUN_a02a70ec(s_Cortex___d_a056493c,uVar17);
      uVar17 = FUN_a0499f80();
      FUN_a02a70ec(s_DDR___d_a0564948,uVar17);
      uVar17 = FUN_a0499fc0();
      FUN_a02a70ec(s_IDSP___d_a0564954,uVar17);
      uVar17 = FUN_a0499ef8();
      FUN_a02a70ec(s_Core___d_a0564960,uVar17);
      uVar17 = FUN_a049a0cc();
      FUN_a02a70ec(s_Audio___d_a056496c,uVar17);
      uVar17 = FUN_a049a110();
      FUN_a02a70ec(s_AXI___d_a0564978,uVar17);
      uVar17 = FUN_a049a150();
      FUN_a02a70ec(s_AHB___d_a0564984,uVar17);
      uVar17 = FUN_a049a190();
      FUN_a02a70ec(s_APB___d_a0564990,uVar17);
      FUN_a02a70ec(s__________Peripheral_Freq_________a056499c);
      uVar17 = FUN_a049a004();
      FUN_a02a70ec(s_VoutLCD___d_a05649cc,uVar17);
      uVar17 = FUN_a049a048();
      FUN_a02a70ec(s_VoutTv___d_a05649d8,uVar17);
      uVar17 = FUN_a049a088();
      FUN_a02a70ec(s_Sensor___d_a05649e4,uVar17);
      FUN_a02a70ec(s__________________________________a055bf70);
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_brcshow_a05649f0);
    if (iVar7 == 0) {
      if (_DAT_a13c82d8 != 0) {
        FUN_a0471168(_DAT_a13c82d8,&local_1110);
        FUN_a02a70ec(s__VideoEnc__Pri___Total_Frames__d_a05649f8,local_1110,local_110c,auStack_1030,
                     local_1108,local_1104);
      }
      if (_DAT_a13c8210 != 0) {
        FUN_a0471168(_DAT_a13c8210,&local_1110);
        FUN_a02a70ec(s__VideoEnc__Sec___Total_Frames__d_a0564a44,local_1110,local_110c,auStack_1030,
                     local_1108,local_1104);
      }
      iVar7 = FUN_a04f9744(*(undefined4 *)(param_2 + 0xc),
                           s_CDC_ACM_Multi_class_reset_a0638028 + 0x14);
      if (iVar7 == 0) {
        if (_DAT_a13c82d8 != 0) {
          FUN_a04711e0();
        }
        if (_DAT_a13c8210 != 0) {
          FUN_a04711e0();
        }
      }
      return 0;
    }
    iVar7 = FUN_a04f9744(uVar17,s_extenc_a0564a90);
    if (iVar7 == 0) {
      uVar17 = *(undefined4 *)(param_2 + 0xc);
      iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_on_a05ccae0 + 0xc);
      if (iVar7 == 0) {
        FUN_a0211908(1);
        return 0;
      }
      iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_off_a05ccaf0 + 0xc);
      if (iVar7 == 0) {
        FUN_a0211908();
        return 0;
      }
      iVar7 = FUN_a04f9744(uVar17,s_set_freq_a0564a98);
      if (iVar7 == 0) {
        uVar6 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
        FUN_a0211958(uVar6);
        return 0;
      }
      iVar7 = FUN_a04f9744(uVar17,&DAT_a0564aa4);
      if (iVar7 == 0) {
        FUN_a0211934();
        return 0;
      }
    }
    else {
      iVar7 = FUN_a04f9744(uVar17,s_texttrack_a0564aa8);
      if (iVar7 == 0) {
        uVar17 = *(undefined4 *)(param_2 + 0xc);
        iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_on_a05ccae0 + 0xc);
        if (iVar7 == 0) {
          FUN_a01f4924(1);
          return 0;
        }
        iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_off_a05ccaf0 + 0xc);
        if (iVar7 == 0) {
          FUN_a01f4924();
          return 0;
        }
        iVar7 = FUN_a04f9744(uVar17,&DAT_a0564aa4);
        if (iVar7 == 0) {
          FUN_a01f4970();
          return 0;
        }
      }
      else {
        iVar7 = FUN_a04f9744(uVar17,s_exif_GPS_a0564ab4);
        if (iVar7 == 0) {
          local_11f8 = (undefined4 *)&local_1208;
          local_1208 = 0;
          local_1110 = (undefined1 *)DAT_a05643c0;
          local_110c = DAT_a05643c4;
          local_1108 = DAT_a05643c8;
          local_1104 = DAT_a05643cc;
          local_1207 = 0x4e;
          local_1100 = DAT_a05643d0;
          uStack_10fc = _DAT_a05643d4;
          local_11fc._3_1_ = 0;
          local_11fc._0_3_ = 0x20201;
          FUN_a01f170c(&local_11fc);
          local_11f8 = &local_1110;
          local_11fc = CONCAT13(local_11fc._3_1_,0x180502);
          FUN_a01f170c(&local_11fc);
          return 0;
        }
        iVar7 = FUN_a04f9744(uVar17,&DAT_a0564ac0);
        if (iVar7 == 0) {
          uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
          FUN_a02a70ec(s_set_wake_up_in__d_sec_a0564ac8,uVar17);
          FUN_a049a3e4(uVar17);
          FUN_a049a440();
          return 0;
        }
        iVar7 = FUN_a04f9744(uVar17,&DAT_a059d500);
        if (iVar7 == 0) {
          if (param_1 != 3) {
            iVar7 = FUN_a04f9744(*(undefined4 *)(param_2 + 0xc),
                                 s_DSP_changed_to_IDLE_mode_a05c73c4 + 0x14);
            if (iVar7 != 0) {
              FUN_a01881f4(&local_1110);
              FUN_a01a1790(param_1,param_2,param_3);
              return 0;
            }
            if (param_1 != 4) {
              _DAT_a0fd25c0 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
              if (_DAT_a0fd25c0 == 1) {
                uVar3 = 3;
              }
              else {
                uVar3 = 1;
              }
              *(undefined1 *)(_DAT_a1055cd4 + 2) = uVar3;
              FUN_a018c6d8();
              return 0;
            }
          }
          FUN_a02a70ec(s_Usage__t_app_test_enc_mode__vide_a0564ae0);
          return 0;
        }
        iVar7 = FUN_a04f9744(uVar17,s_video_tlapse_a0564b18);
        if (iVar7 == 0) {
          if (param_1 != 3) {
            uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
            if (uVar8 == 500) {
              uVar8 = 1;
            }
            else if (uVar8 != 4) {
              if ((int)uVar8 < 5) {
                if (2 < uVar8) goto LAB_a01a23a4;
              }
              else if ((uVar8 != 10) && (uVar8 != 0x3c)) {
LAB_a01a23a4:
                FUN_a02a70ec(s_Usage__t_app_test_video_tlapse___a0564b44);
                return 0;
              }
            }
            FUN_a02a70ec(s_Set_video_timelapse___ds_a0564b28,uVar8);
            *(char *)(_DAT_a1055cd4 + 10) = (char)uVar8;
            FUN_a018c6d8();
            return 0;
          }
        }
        else {
          iVar7 = FUN_a04f9744(uVar17,s_audio_liveview_a0564b84);
          if (iVar7 == 0) {
            if (param_1 != 3) {
              iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
              if (((iVar7 == 0) && (iVar9 = FUN_a020fefc(), iVar9 != 0)) &&
                 (*(char *)(_DAT_a1055cd4 + 10) != '\0')) {
                FUN_a0211308();
              }
              uVar8 = (uint)DAT_a1055cd8;
              if ((DAT_a1055cd8 & 0x38) == 0) {
                FUN_a021e218();
                FUN_a021e658();
                FUN_a020ffb4(iVar7);
                FUN_a021d998();
                FUN_a021e1a0();
                return uVar8 & 0x38;
              }
              FUN_a0213908();
              FUN_a02139b0();
              FUN_a0213a0c();
              FUN_a020ffb4(iVar7);
              FUN_a02134fc();
              FUN_a021387c();
              return 0;
            }
          }
          else {
            iVar7 = FUN_a04f9744(uVar17,s_gui_ani_a0564b94);
            if (iVar7 == 0) {
              if (param_1 == 3) {
                (*param_3)(s_Usage__t_app_test_gui_ani_<optio_a0564bac);
                return 0;
              }
              uVar17 = *(undefined4 *)(param_2 + 0xc);
              iVar7 = FUN_a04f9744(uVar17,s__Applib___StillEnc__<QvFreeBuf>_s_a0590184 + 0x20);
              if (iVar7 != 0) {
                iVar7 = FUN_a04f9744(uVar17,s_set_dly_a0564b9c);
                if (iVar7 == 0) {
                  DAT_a06cd284 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                  FUN_a02a70ec(s_dly___d_a0564ba4,DAT_a06cd284);
                  return 0;
                }
                return 0;
              }
              iVar7 = 0x32;
              FUN_a0201dc8(3,0x25,0x4a);
              do {
                iVar7 = iVar7 + 10;
                FUN_a02020d0(3,0x25,iVar7,200,0);
                FUN_a02022c8(3,0x25);
                FUN_a02027b0(3);
                FUN_a03c0b20(DAT_a06cd284);
              } while (iVar7 != 0x226);
              return 0;
            }
            iVar7 = FUN_a04f9744(uVar17,&DAT_a0564bf4);
            if (iVar7 == 0) {
              if (param_1 != 3) {
                FUN_a01cbd24();
                if ((_DAT_a1258220 == 0) &&
                   (iVar7 = FUN_a03bc6dc(&DAT_a0fd7114,&DAT_a1258220,0x500000,100), iVar7 != 0)) {
                  FUN_a02a70ec(s__sAmbaKAL_BytePoolAllocate_faile_a0564bfc,DAT_a06f3080,0x783);
                  return 0;
                }
                uVar17 = *(undefined4 *)(param_2 + 0xc);
                iVar7 = FUN_a04f9744(uVar17,&DAT_a0564c2c);
                if (iVar7 == 0) {
                  if (param_1 == 4) {
                    (*param_3)(s_Usage__t_app_test_beep_play_<pat_a0564cdc);
                    return 0;
                  }
                  FUN_a04f8dec(&local_11fc,0,0x1c);
                  FUN_a04f8dec(&local_1110,0,0x50);
                  FUN_a02a70ec(s__I__APP_BEEP___06d___s__beep_fil_a056b724 + 0x18,
                               *(undefined4 *)(param_2 + 0x10));
                  iVar7 = _DAT_a1258220;
                  local_11f8 = (undefined4 *)CONCAT31(local_11f8._1_3_,2);
                  iVar9 = FUN_a03d5af0(&local_1110);
                  if (iVar9 != 0) {
                    FUN_a02a70ec(s__s__Can_t_get_file_descriptor__a0564c34,
                                 s_dt_app_test_a05643d7 + 1);
                    return 0;
                  }
                  uVar17 = *(undefined4 *)(param_2 + 0x10);
                  local_10c4 = 0;
                  FUN_a04f9900(&local_1110,uVar17);
                  iVar9 = FUN_a03d6f4c(uVar17);
                  if (iVar9 != 0) {
                    FUN_a02a70ec(s_File_is_already_opened__a0564c54);
                    return 0;
                  }
                  uVar20 = FUN_a03d8610(&local_1110);
                  iVar9 = (int)uVar20;
                  if (iVar9 == 0) {
                    return 0;
                  }
                  iVar10 = FUN_a03d62a0(iVar9,(int)((ulonglong)uVar20 >> 0x20),0,0,2);
                  if (iVar10 != 0) {
                    FUN_a02a70ec(s__sAmpCFS_fseek_failed_____line____a0564c6c,DAT_a06f3080,0x7a8);
                    return 0;
                  }
                  uVar20 = FUN_a03d652c(iVar9);
                  uVar17 = (undefined4)uVar20;
                  iVar10 = FUN_a03d62a0(iVar9,(int)((ulonglong)uVar20 >> 0x20),0,0,0);
                  if (iVar10 != 0) {
                    FUN_a02a70ec(s__sAmpCFS_fseek_failed_____line____a0564c6c,DAT_a06f3080,0x7ae);
                    return 0;
                  }
                  iVar10 = FUN_a03d5d6c(iVar7,uVar17,1,iVar9);
                  if (iVar10 == 0) {
                    FUN_a02a70ec(s__sAmpCFS_fread_failed_____line____a0564c90,DAT_a06f3080,0x7b3);
                    return 0;
                  }
                  iVar9 = FUN_a03d5b54(iVar9);
                  if (iVar9 == 0) {
                    local_11f4 = iVar7;
                    local_11e4 = 2;
                    local_11e8 = 48000;
                    local_11ec = uVar17;
                    FUN_a01cc034(local_11fc,local_11f8,iVar7,local_11f0,uVar17,48000,2);
                    return 0;
                  }
                  FUN_a02a70ec(s__sAmpCFS_fclose_failed_____line__a0564cb4,DAT_a06f3080,0x7b8);
                  return 0;
                }
                iVar7 = FUN_a04f9744(uVar17,s_set_vol_a0564d04);
                if (iVar7 == 0) {
                  if (param_1 == 4) {
                    (*param_3)(s_Usage__t_app_test_beep_set_vol_<_a0564d40);
                    return 0;
                  }
                  uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                  if (uVar8 < 0x80) {
                    FUN_a02a70ec(s_Set_beep_volume____d_a0564d0c,uVar8);
                    thunk_FUN_a045478c(uVar8);
                    return 0;
                  }
                  FUN_a02a70ec(s_Error__vol_should_be_0_127_a0564d24);
                  return 0;
                }
              }
              (*param_3)(s_Usage__t_app_test_beep_<option>_O_a0564d68);
              return 0;
            }
            iVar7 = FUN_a04f9744(uVar17,s_onoff_a0564dac);
            if (iVar7 == 0) {
              if (param_1 == 3) {
                (*param_3)(s_Usage__t_app_test_onoff__0_1___t_a0564db4);
                (*param_3)(s_current_pref_setting__0x_x_a0564df8,
                           *(undefined4 *)(_DAT_a1055cd4 + 0x84));
                return 0xffffffff;
              }
              iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
              if (iVar7 == 0) {
                *(undefined4 *)(_DAT_a1055cd4 + 0x84) = 0;
              }
              else {
                if (param_1 == 4) {
                  uVar16 = 10;
                  uVar8 = 5;
                }
                else {
                  uVar16 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                  uVar16 = uVar16 & 0xff;
                  if (param_1 == 5) {
                    uVar8 = 5;
                  }
                  else {
                    uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                    uVar8 = uVar8 & 0xff;
                  }
                }
                *(uint *)(_DAT_a1055cd4 + 0x84) = uVar16 | uVar8 << 8;
              }
              goto LAB_a01a1b50;
            }
            iVar7 = FUN_a04f9744(uVar17,s_dual_stream_a0564e14);
            if (iVar7 == 0) {
              if (param_1 == 3) {
                (*param_3)(s_Usage__t_app_test_dual_stream__1_a0564e20);
                return 0;
              }
              uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
              thunk_FUN_a01e653c(0xf0010305,uVar17,0);
              return 0;
            }
            iVar7 = FUN_a04f9744(uVar17,&DAT_a054f6c0);
            if (iVar7 == 0) {
              uVar17 = *(undefined4 *)(param_2 + 0xc);
              iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_on_a05ccae0 + 0xc);
              if (iVar7 == 0) {
                FUN_a02a70ec(s__s_______________>_t_app_test_vf_a0564e48,DAT_a06f3088);
                thunk_FUN_a01e653c(0xf0ff0138,0,0);
                return 0;
              }
              iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_off_a05ccaf0 + 0xc);
              if (iVar7 == 0) {
                FUN_a02a70ec(s__s_______________>_t_app_test_vf_a05648cc,DAT_a06f3088);
                thunk_FUN_a01e653c(0xf0ff0139,0,0);
                return 0;
              }
              iVar7 = FUN_a04f9744(uVar17,&DAT_a0564aa4);
              if (iVar7 == 0) {
                FUN_a02a70ec(s__s_______________>_t_app_test_vf_a0564e70,DAT_a06f3088);
                thunk_FUN_a01e653c(0xf0ff013a,0,0);
                return 0;
              }
            }
            else {
              iVar7 = FUN_a04f9744(uVar17,&DAT_a055f954);
              if (iVar7 == 0) {
                uVar17 = *(undefined4 *)(param_2 + 0xc);
                iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_on_a05ccae0 + 0xc);
                if (iVar7 == 0) {
                  *(undefined1 *)(_DAT_a1055cd4 + 0xd) = 1;
                  FUN_a018c6d8();
                  return 0;
                }
                iVar7 = FUN_a04f9744(uVar17,s_dsp_dec_cmd_off_a05ccaf0 + 0xc);
                if (iVar7 == 0) {
                  *(undefined1 *)(_DAT_a1055cd4 + 0xd) = 0;
                  FUN_a018c6d8();
                  return 0;
                }
                iVar7 = FUN_a04f9744(uVar17,&DAT_a0564e98);
                if (iVar7 == 0) {
                  (*param_3)(s_UserSetting_>VideoPref_StreamTyp_a0564ea0,
                             *(undefined1 *)(_DAT_a1055cd4 + 0xd));
                  return 0;
                }
              }
              else {
                iVar7 = FUN_a04f9744(uVar17,s__Cmplx___bitrate__dKbps__>__dKbp_a0601ca4 + 0x30);
                if (iVar7 == 0) {
                  thunk_FUN_a01e653c(0xf0ff013c,0,0);
                  return 0;
                }
                iVar7 = FUN_a04f9744(uVar17,&DAT_a0564ec8);
                if (iVar7 == 0) {
                  uVar17 = *(undefined4 *)(param_2 + 0xc);
                  iVar7 = FUN_a04f9744(uVar17,&DAT_a0564ecc);
                  if (iVar7 == 0) {
                    FUN_a021f7c0();
                    FUN_a021e464();
                    FUN_a0244c48(2);
                    FUN_a0479708(s_killall_AmbaRTSPServer_a0564ed0);
                    FUN_a0479708(s__usr_bin_AmbaRTSPServer___en_aud_a0564ee8);
                    return 0;
                  }
                  iVar7 = FUN_a04f9744(uVar17,s_ca_warp_v_a05d5ee8 + 8);
                  if (iVar7 == 0) {
                    FUN_a021f7c0(1);
                    FUN_a021e464();
                    FUN_a0244c48(1);
                    FUN_a0479708(s_killall_AmbaRTSPServer_a0564ed0);
                    FUN_a0479708(s__usr_bin_AmbaRTSPServer_a0564f18);
                    return 0;
                  }
                  iVar7 = FUN_a04f9744(uVar17,&DAT_a0564e98);
                  if (iVar7 == 0) {
                    iVar7 = FUN_a021fb38();
                    pcVar13 = &DAT_a0564638;
                    if (iVar7 != 0) {
                      pcVar13 = s_Video_only_a056462c;
                    }
                    (*param_3)(s_rec_mode____s_a0564f30,pcVar13);
                    iVar7 = FUN_a0211934();
                    if (iVar7 == 0) {
                      pcVar13 = s__I__MISC_POWEROFF___06d___s__Low_a052fc24 + 0x28;
                    }
                    else {
                      pcVar13 = s_dbgthd__thread_mask____Set_dsp_l_a05cee14 + 100;
                    }
                    (*param_3)(s_text____s_a0564f40,pcVar13);
                    uVar8 = FUN_a0244cc8();
                    (*param_3)(s_net_stream_mode___a0564f50);
                    if ((uVar8 & 1) == 0) {
                      pcVar13 = s__I__MISC_POWEROFF___06d___s__Low_a052fc24 + 0x28;
                    }
                    else {
                      pcVar13 = s_dbgthd__thread_mask____Set_dsp_l_a05cee14 + 100;
                    }
                    (*param_3)(s_video__s_a0564f64,pcVar13);
                    if ((uVar8 & 2) == 0) {
                      pcVar13 = s__I__MISC_POWEROFF___06d___s__Low_a052fc24 + 0x28;
                    }
                    else {
                      pcVar13 = s_dbgthd__thread_mask____Set_dsp_l_a05cee14 + 100;
                    }
                    (*param_3)(s_audio__s_a0564f74,pcVar13);
                    if ((uVar8 & 4) == 0) {
                      pcVar13 = s__I__MISC_POWEROFF___06d___s__Low_a052fc24 + 0x28;
                    }
                    else {
                      pcVar13 = s_dbgthd__thread_mask____Set_dsp_l_a05cee14 + 100;
                    }
                    (*param_3)(s_text__s_a0564f84,pcVar13);
                    return 0;
                  }
                }
                else {
                  iVar7 = FUN_a04f9744(uVar17,&DAT_a05529e4);
                  if (iVar7 == 0) {
                    FUN_a04f8dec(&local_1110,0,0xc);
                    uVar17 = *(undefined4 *)(param_2 + 0xc);
                    iVar7 = FUN_a04f9744(uVar17,s_ctl_init_a057cde8 + 4);
                    if (iVar7 == 0) {
                      FUN_a02a70ec(s__s_______________>_t_app_test_id_a0564f94,DAT_a06f3088);
                      FUN_a02496dc();
                    }
                    else {
                      local_1108 = FUN_a04f9744(uVar17,&DAT_a0564fbc);
                      if (local_1108 == 0) {
                        FUN_a02a70ec(s__s_______________>_t_app_test_id_a0564fc0,DAT_a06f3088);
                        if (4 < param_1) {
                          local_1110 = (undefined1 *)0xa105821c;
                          local_110c = 0x200000;
                          FUN_a02499fc(*(undefined4 *)(param_2 + 0x10),&local_1110);
                          return 0;
                        }
                      }
                      else {
                        iVar7 = FUN_a04f9744(uVar17,&DAT_a0552bf4);
                        if (iVar7 == 0) {
                          FUN_a02a70ec(s__s_______________>_t_app_test_id_a0564fe8,DAT_a06f3088);
                          if (5 < param_1) {
                            uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                            if (uVar8 < 3) {
                              local_1110 = (undefined1 *)0xa105821c;
                              local_110c = 0x200000;
                              local_1108 = iVar7;
                              FUN_a0249b7c(*(undefined4 *)(param_2 + 0x14),uVar8 & 0xff,&local_1110)
                              ;
                              FUN_a02a70ec(s__sDataBuf_RetDataSize____d_a0565010,DAT_a06f3088,
                                           local_1108);
                              return 0;
                            }
                            FUN_a02a70ec(s_num_should_be_0_2_a056502c);
                          }
                        }
                        else {
                          iVar7 = FUN_a04f9744(uVar17,s_uninit_a0565040);
                          if (iVar7 == 0) {
                            FUN_a02a70ec(s__s_______________>_t_app_test_id_a0565048,DAT_a06f3088);
                            FUN_a0249448();
                            return 0;
                          }
                        }
                      }
                      (*param_3)(s_Usage__t_app_test_idr_<option>_T_a0565a90);
                    }
                    return 0;
                  }
                  iVar7 = FUN_a04f9744(uVar17,&DAT_a0565074);
                  if (iVar7 == 0) {
                    FUN_a04f8dec(&local_1110,0,0x3c);
                    uVar17 = *(undefined4 *)(param_2 + 0xc);
                    iVar7 = FUN_a04f9744(uVar17,&DAT_a0565078);
                    if (iVar7 == 0) {
                      if (4 < param_1) {
                        iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                        if (0 < iVar7) {
                          local_1110 = (undefined1 *)0x1;
                          FUN_a04f93c4(&local_1104,0x30,s_C__DCIM_100MEDIA_AMBA_04d_MP4_a0565080);
                          FUN_a0244cd8(&local_1110,0);
                          return 0;
                        }
                        FUN_a02a70ec(s_num_should_be_larger_than_0_a05650a0);
                      }
                    }
                    else {
                      iVar7 = FUN_a04f9744(uVar17,&DAT_a0564c2c);
                      if (iVar7 == 0) {
                        local_1110 = (undefined1 *)0x2;
                        FUN_a0244cd8(&local_1110);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_factory_burnin_test_stop_a056bf64 + 0x14);
                      if (iVar7 == 0) {
                        local_1110 = (undefined1 *)0x3;
                        FUN_a0244cd8(&local_1110);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_pause_a05650bc);
                      if (iVar7 == 0) {
                        local_1110 = (undefined1 *)0x5;
                        FUN_a0244cd8(&local_1110);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_resume_a05650c4);
                      if (iVar7 == 0) {
                        local_1110 = (undefined1 *)0x6;
                        FUN_a0244cd8(&local_1110);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,&DAT_a05650cc);
                      if (iVar7 == 0 && 4 < param_1) {
                        local_1110 = (undefined1 *)0x2;
                        FUN_a04f93c4(&local_1104,0x30,s_Create_SYS_ID___s_a0635564 + 0x10,
                                     *(undefined4 *)(param_2 + 0x10));
                        iVar7 = FUN_a0244cd8(&local_1110,0);
                        if (iVar7 != 0) {
                          FUN_a02a70ec(s__t_app__<t_app_test_np>_AppLibNe_a05650d4);
                        }
                        FUN_a02a70ec(s__t_app__online_playback_feed_nex_a0565114,&local_1104);
                        return 0;
                      }
                    }
                    (*param_3)(s_Usage__t_app_np_<option>_Test_op_a0565b40);
                    return 0;
                  }
                  iVar7 = FUN_a04f9744(uVar17,s_ae_meter_a0565140);
                  if (iVar7 == 0) {
                    uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                    FUN_a03b0ce0(0xb03,0,&local_1110,0);
                    local_1108._0_3_ = CONCAT12((char)uVar17,(undefined2)local_1108);
                    FUN_a02a70ec(s__t_app__change_meter_to__d__0_AE_a056514c,uVar17);
                    FUN_a03b0ce0(0xb02,0,&local_1110,0);
                    return 0;
                  }
                  iVar7 = FUN_a04f9744(uVar17,s_sharepv_a05651a0);
                  if (iVar7 != 0) {
                    iVar7 = FUN_a04f9744(uVar17,s_awb_setting_a05652bc);
                    if (iVar7 == 0) {
                      uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                      uVar11 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                      FUN_a03b0ce0(0xb0d,0,&local_1110,0);
                      local_110c._0_2_ = CONCAT11((char)uVar11,(char)uVar17);
                      FUN_a03b0ce0(0xb0c,0,&local_1110,0);
                      FUN_a02a70ec(s__t_app__change_awb_mode_to__d__m_a05652c8,uVar17,uVar11);
                      return 0;
                    }
                    iVar7 = FUN_a04f9744(uVar17,s_chg_preview_a05652f8);
                    if (iVar7 == 0) {
                      iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                      if (iVar7 == 1) {
                        DAT_a0fbc1b2 = 1;
                        thunk_FUN_a01e653c(0xf0010301,0x11,0);
                        pcVar13 = s_photo_preview_a056463c;
                      }
                      else {
                        DAT_a0fbc1b2 = 0;
                        thunk_FUN_a01e653c(0xf0010301,*(undefined1 *)(_DAT_a1055cd4 + 4),0);
                        pcVar13 = s_video_preview_a056464c;
                        if (iVar7 != 0) {
                          pcVar13 = s_photo_preview_a056463c;
                        }
                      }
                      FUN_a02a70ec(s__s_t_app__you_are_now_in__s_a0565304,DAT_a06f3084,pcVar13);
                      return 0;
                    }
                    iVar7 = FUN_a04f9744(uVar17,s_max_iso_setting_a0565660 + 4);
                    if (iVar7 == 0) {
                      uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                      FUN_a03b0ce0(0xb03,0,&local_1110,0);
                      local_10f8 = (float)CONCAT22(local_10f8._2_2_,(short)uVar17);
                      FUN_a02a70ec(s__t_app__change_iso_to__d_a0565324,uVar17);
                      FUN_a03b0ce0(0xb02,0,&local_1110,0);
                      return 0;
                    }
                    iVar7 = FUN_a04f9744(uVar17,s_max_shutter_setting_a0565510 + 4);
                    if (iVar7 == 0) {
                      uVar6 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                      bVar2 = DAT_a1055cfa;
                      *(undefined2 *)(_DAT_a1055cd4 + 0x8c) = uVar6;
                      if (bVar2 < 2) {
                        (*_DAT_a0fb3364)(0x7b,uVar6,0);
                        return 0;
                      }
                    }
                    else {
                      iVar7 = FUN_a04f9744(uVar17,s_scene_setting_a0565340);
                      if (iVar7 == 0) {
                        uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        uVar11 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                        local_1110 = (undefined1 *)((uint)local_1110 & 0xffffff00);
                        local_110c = uVar17;
                        FUN_a03b0ce0(0xb51,0,&local_1110,0);
                        local_1108 = uVar11;
                        FUN_a02a70ec(s__t_app__mode____d__change_scene_t_a0565350,uVar17,uVar11);
                        FUN_a03b0ce0(0xb50,0,&local_1110,0);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_crop_file_a0565378);
                      if (iVar7 == 0) {
                        uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                        uVar11 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x18));
                        FUN_a04f8dec(&local_11fc,0,0x40);
                        FUN_a04f8dec(&local_1110,0,0x40);
                        FUN_a04f9900(&local_11fc,*(undefined4 *)(param_2 + 0xc));
                        FUN_a04f9900(&local_1110,*(undefined4 *)(param_2 + 0x10));
                        FUN_a02a70ec(s__t_app__crop_file__s__from__dms_t_a0565384,&local_11fc,uVar17
                                     ,uVar11,&local_1110);
                        FUN_a01ed960(uVar17,uVar11,&local_11fc,&local_1110);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_video_rot_a05653c0);
                      if (iVar7 == 0) {
                        iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        *(char *)(_DAT_a1055cd4 + 0x7e) = (char)iVar7;
                        if (iVar7 == 5) {
                          DAT_a1055d8e = 1;
                        }
                        else if (iVar7 == 0) {
                          DAT_a1055d8e = 0;
                        }
                        else {
                          FUN_a02a70ec(s_Just_supply_180_rotation_a05653cc);
                        }
                        thunk_FUN_a01e653c(0xf001031f,0xff,0);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_MCTF_off_a05653e8);
                      if (iVar7 == 0) {
                        iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        FUN_a02c6378();
                        pcVar13 = s_dsp_dec_cmd_on_a05ccae0;
                        if (iVar7 == 1) {
                          pcVar13 = s_dsp_dec_cmd_off_a05ccaf0;
                        }
                        FUN_a02a70ec(s__t_app__turn__s_MCTF_a05653f4,pcVar13 + 0xc);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_sensor_flip_a056540c);
                      if (iVar7 == 0) {
                        iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        if (iVar7 == 1) {
                          FUN_a02a70ec(s__t_app__set_sensor_flip__s_a0565418,
                                       s_dsp_dec_cmd_on_a05ccae0 + 0xc);
                          pcVar13 = s_dsp_dec_cmd_on_a05ccae0 + 0xc;
                        }
                        else {
                          FUN_a02a70ec(s__t_app__set_sensor_flip__s_a0565418,
                                       s_dsp_dec_cmd_off_a05ccaf0 + 0xc);
                          pcVar13 = s_dsp_dec_cmd_on_a05ccae0 + 0xc;
                          if (iVar7 < 1) {
                            pcVar13 = s_dsp_dec_cmd_off_a05ccaf0 + 0xc;
                          }
                        }
                        FUN_a014cfdc(pcVar13,1);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_EIS_enable_a0565434);
                      if (iVar7 == 0) {
                        uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        (*_DAT_a0fb3364)(0x76,uVar17,0);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_SS_enable_a0565440);
                      if (iVar7 == 0) {
                        iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        FUN_a021f854();
                        iVar9 = FUN_a0225b38();
                        FUN_a03b0ce0(0xb03,0,&local_1110,0);
                        if (iVar7 == 1) {
                          iVar7 = FUN_a0506418(*(undefined4 *)(iVar9 + 0x10),
                                               *(undefined4 *)(iVar9 + 0xc));
                          if (iVar7 - 0x1fU < 0xa8) {
                            local_1110 = (undefined1 *)CONCAT13(1,(undefined3)local_1110);
                            local_110c = local_110c & 0xffffff00;
                          }
                          else {
                            local_1110 = (undefined1 *)((uint)local_1110 & 0xffffff);
                          }
                          FUN_a03b0ce0(0xb02,0,&local_1110,0);
                          pcVar13 = s_dsp_dec_cmd_on_a05ccae0;
                        }
                        else {
                          local_1110 = (undefined1 *)((uint)local_1110 & 0xffffff);
                          FUN_a03b0ce0(0xb02,0,&local_1110,0);
                          pcVar13 = s_dsp_dec_cmd_off_a05ccaf0;
                        }
                        FUN_a02a70ec(s__t_app__set_SS__s_a056544c,pcVar13 + 0xc);
                        return 0;
                      }
                      iVar7 = FUN_a04f9744(uVar17,s_OSD_rotate_a0565460);
                      if (iVar7 == 0) {
                        uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        FUN_a0201a08(4,uVar8 & 0xffff);
                        FUN_a0201a08(2,uVar8 & 0xffff);
                        FUN_a02027b0(2);
                        FUN_a02027b0(4);
                        if (uVar8 == 0xb4) {
                          DAT_a1055d8e = 1;
                        }
                        else if (uVar8 == 0) {
                          DAT_a1055d8e = 0;
                        }
                        iVar7 = FUN_a04f9744(*(undefined4 *)(param_2 + 0xc),
                                             s_sd_card_status_a055051c + 8);
                        if (iVar7 == 0) {
                          uVar17 = FUN_a0201a34(2);
                          FUN_a02a70ec(s__t_app__set_OSD_rotate_to__d_deg_a056546c,uVar17);
                          return 0;
                        }
                      }
                      else {
                        iVar7 = FUN_a04f9744(uVar17,s_single_ituner_a0565490);
                        if (iVar7 == 0) {
                          uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                          FUN_a02195f0(uVar8 & 0xff);
                          pcVar13 = s_Disable_a053c5d0;
                          if (uVar8 == 1) {
                            pcVar13 = s_BPC_Page__d_not_Enable_a057d2f4 + 0x10;
                          }
                          FUN_a02a70ec(s__t_app___s_dump_iTuner_file_in_S_a05654a0,pcVar13);
                          return 0;
                        }
                        iVar7 = FUN_a04f9744(uVar17,s_b_shutter_setting_a05654d0);
                        if (iVar7 == 0) {
                          uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                          fVar19 = (float)VectorSignedToFloat(uVar17,(byte)(in_fpscr >> 0x16) & 3);
                          uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                          fVar18 = (float)VectorSignedToFloat(uVar17,(byte)(in_fpscr >> 0x16) & 3);
                          FUN_a03b0ce0(0xa51,0,1,&local_1110);
                          uVar17 = VectorFloatToUnsigned(fVar18 * DAT_a01a415c,3);
                          local_1100 = CONCAT22(local_1100._2_2_,(short)uVar17);
                          local_10f8 = fVar19;
                          local_10f4 = fVar18;
                          FUN_a02a70ec(s__t_app__set_b_shutter_to__f_s__i_a05654e4,uVar17,
                                       SUB84((double)fVar19,0),
                                       (int)((ulonglong)(double)fVar19 >> 0x20),
                                       (double)(fVar18 * DAT_a01a415c));
                          FUN_a03b0ce0(0xa50,0,1,&local_1110);
                          return 0;
                        }
                        iVar7 = FUN_a04f9744(uVar17,s_max_shutter_setting_a0565510);
                        if (iVar7 == 0) {
                          uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                          FUN_a03b0ce0(0xb00,0,&local_1110,0);
                          local_107e = (undefined2)uVar17;
                          local_107c = local_107e;
                          local_1076 = local_107e;
                          local_1074 = local_107e;
                          FUN_a03b0ce0(0xb01,0,&local_1110,0);
                          FUN_a02a70ec(s__t_app__fix_max_shutter_to__d_a0565524,uVar17);
                          return 0;
                        }
                        iVar7 = FUN_a04f9744(uVar17,s_enable_rawcap_a0565544);
                        if (iVar7 == 0) {
                          uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                          thunk_FUN_a01e653c(0xf0ff0139,0,0);
                          thunk_FUN_a01e653c(0xf0010329,uVar17,0);
                          thunk_FUN_a01e653c(0xf001030d,uVar17,0);
                          return 0;
                        }
                        iVar7 = FUN_a04f9744(uVar17,s_slow_motion_a0565554);
                        if (iVar7 == 0) {
                          uVar3 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                          pcVar1 = _DAT_a0fb3364;
                          *(undefined1 *)(_DAT_a1055cd4 + 0xa4) = uVar3;
                          (*pcVar1)(0x82,uVar3,0);
                          return 0;
                        }
                        iVar7 = FUN_a04f9744(uVar17,s_enable_CFA_a0565560);
                        if (iVar7 == 0) {
                          uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                          iVar7 = FUN_a04f9744(*(undefined4 *)(param_2 + 0xc),
                                               s__I__MOVIE_RECOVERY_FUNC___06d____a052f068 + 0x38);
                          if (iVar7 == 0) {
                            uVar12 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                            uVar11 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                          }
                          else {
                            uVar11 = 0;
                            uVar12 = 0;
                          }
                          FUN_a02219a4(uVar17,uVar12,uVar11);
                          return 0;
                        }
                        iVar7 = FUN_a04f9744(uVar17,s_set_EIS_range_a056556c);
                        if (iVar7 != 0) {
                          iVar7 = FUN_a04f9744(uVar17,s_app_status_a05502e4);
                          if (iVar7 == 0) {
                            FUN_a02a70ec(s_dewarp_support____d_a056557c,DAT_a1055e74);
                            FUN_a02a70ec(s_eis_support____d_a0565590,DAT_a1055e75);
                            FUN_a02a70ec(s_support_auto_low_light____d_a05655a4,DAT_a1055cff);
                            FUN_a02a70ec(s_video_rotated____d_a05655c0,DAT_a1055d8e);
                            FUN_a02a70ec(s_ev_support____d_a05655d4,DAT_a1055e76);
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_show_temp_a05655e4);
                          if (iVar7 == 0) {
                            FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_dbg_dsp_event_a05655f0);
                          if (iVar7 == 0) {
                            if (param_1 == 3) {
                              (*param_3)(s_Usage__t_app_test_dbg_dsp_event___a0565618);
                              return 0;
                            }
                            _DAT_a1456c78 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            (*param_3)(s_AmbaDSP_EventDbg____d_a0565600,_DAT_a1456c78);
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_sd_slow_write_a0565640);
                          if (iVar7 == 0) {
                            DAT_a078b17c = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_show_bs_buffer_a0565650);
                          if (iVar7 == 0) {
                            DAT_a078a7dc = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_max_iso_setting_a0565660);
                          if (iVar7 == 0) {
                            iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                            FUN_a03b0ce0(0xb53,0,&local_1110,0);
                            FUN_a03b0ce0(0xb07,0,&local_11fc,0);
                            if (iVar7 == 1) {
                              local_10ec = uVar17;
                              local_10e8 = uVar17;
                            }
                            else if (iVar7 == 0) {
                              uVar11 = FUN_a0506690(uVar17,100);
                              uVar20 = VectorSignedToFloat(uVar11,(byte)(in_fpscr >> 0x16) & 3);
                              uVar11 = FUN_a0504018((int)uVar20);
                              uVar11 = VectorFloatToSigned(((double)CONCAT44(extraout_s1,uVar11) /
                                                           DAT_a01a37f0) * 6.0,3);
                              local_120c = (undefined2)uVar11;
                              puVar14 = &local_11fc;
                              do {
                                *(undefined2 *)(puVar14 + 2) = local_120c;
                                puVar15 = (undefined4 *)((int)puVar14 + 0xe);
                                *(undefined2 *)((int)puVar14 + 10) = local_120c;
                                *(undefined2 *)(puVar14 + 3) = local_120c;
                                *(undefined2 *)puVar15 = local_120c;
                                *(undefined2 *)(puVar14 + 0x1e) = 0;
                                *(undefined2 *)((int)puVar14 + 0x7a) = 0;
                                *(undefined2 *)(puVar14 + 0x1f) = 0;
                                *(undefined2 *)((int)puVar14 + 0x7e) = 0;
                                puVar14 = puVar15;
                              } while (puVar15 != auStack_118c);
                            }
                            FUN_a02a70ec(s__t_app__mode____d__change_iso_in_a0565670,iVar7,uVar17);
                            FUN_a03b0ce0(0xb06,0,&local_11fc,0);
                            FUN_a03b0ce0(0xb52,0,&local_1110,0);
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_dynamic_brc_a056569c);
                          if (iVar7 == 0) {
                            if (param_1 < 7) {
                              (*param_3)(s_Usage__t_app_test_dynamic_brc__0_a0565748);
                              return 0;
                            }
                            iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            uVar17 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
                            uVar11 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x14));
                            uVar12 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x18));
                            (*param_3)(s_stream_id____d_a05656a8,iVar7);
                            (*param_3)(s_MaxBitRate____d_a05656b8,uVar17);
                            (*param_3)(s_AvgBitRate____d_a05656cc,uVar11);
                            (*param_3)(s_MinBitRate____d_a05656e0,uVar12);
                            local_11fc = 0;
                            if (iVar7 == 0) {
                              local_11fc = _DAT_a13c826c;
                            }
                            else if (iVar7 == 1) {
                              local_11fc = _DAT_a13c828c;
                            }
                            else {
                              (*param_3)(s_Stream_id_error__a05656f4);
                            }
                            if (local_11fc == 0) {
                              (*param_3)(s_BrcHdlr_is_NULL_a0565718);
                              (*param_3)(s_BrcHdlrPri_update_failed__a056572c);
                              return 0;
                            }
                            local_10f8 = (float)uVar11;
                            local_10f4 = (float)uVar12;
                            local_10f0 = uVar17;
                            FUN_a039836c(&local_1110,&local_11fc);
                            (*param_3)(s_Brc_updated__a0565708);
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_cache_dbg_a05657a0);
                          if (iVar7 == 0) {
                            if (param_1 == 3) {
                              (*param_3)(s_Usage__t_app_test_cache_dbg__1_0_a05657bc);
                              return 0;
                            }
                            _DAT_a1a3a6d4 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                            (*param_3)(s_cache_debug__d_a05657ac,_DAT_a1a3a6d4);
                            return 0;
                          }
                          iVar7 = FUN_a04f9744(uVar17,s_audio_effect_a05657e0);
                          if (iVar7 == 0) {
                            if (4 < param_1) {
                              uVar17 = *(undefined4 *)(param_2 + 0xc);
                              iVar7 = FUN_a04f9744(uVar17,s_No_such_channel_a062297c + 8);
                              if (iVar7 == 0) {
                                FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                                FUN_a020ff78();
                                return 0;
                              }
                              iVar7 = FUN_a04f9744(uVar17,s_channel_config_a05657f0);
                              if (iVar7 == 0) {
                                FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                                FUN_a020ff98();
                                return 0;
                              }
                              return 0;
                            }
                          }
                          else {
                            iVar7 = FUN_a04f9744(uVar17,s_usb_host_a0565800);
                            if (iVar7 == 0) {
                              uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                              (*param_3)(s_USB_Host_support__d_a056580c,uVar8);
                              FUN_a0471ba8(uVar8 & 0xff);
                              return 0;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_pb_zoom_a0565824);
                            if (iVar7 == 0) {
                              if (param_1 < 6) {
                                (*param_3)(s_Usage__t_app_test_pb_zoom__x___y_a0565848);
                                return 0;
                              }
                              uVar17 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                              uVar11 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                              uVar12 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                              (*param_3)(s_x____d__y____d__factor____d_a056582c,uVar17,uVar11,uVar12
                                        );
                              return 0;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_Test_1x_dzoom_a059d2e4 + 8);
                            if (iVar7 == 0) {
                              FUN_a04f8dec(&local_1208,0,0xc);
                              FUN_a02da030(&local_1208,&local_1110);
                              if (param_1 < 7) {
                                (*param_3)(s_Usage__t_app_test_dzoom__factorX_a05658a4);
                                (*param_3)(s_Current_Zoom_a05658f0);
                                (*param_3)(s_WarpWinInfo_DzoomInfo_ZoomX____d_a0565900,local_1110);
                                (*param_3)(s_WarpWinInfo_DzoomInfo_ZoomY____d_a0565928,local_110c);
                                (*param_3)(s_WarpWinInfo_DzoomInfo_ShiftX_____a0565950,local_1108);
                                (*param_3)(s_WarpWinInfo_DzoomInfo_ShiftY_____a0565978,local_1104);
                                return 0;
                              }
                              iVar7 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                              iVar9 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                              iVar10 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                              local_11f0 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x18));
                              if (iVar7 < 1) {
                                (*param_3)(s_ZoomX_should_be_1___n_a0565874);
                              }
                              else {
                                local_11fc = iVar7 << 0x10;
                                if (0 < iVar9) {
                                  local_11f8 = (undefined4 *)(iVar9 << 0x10);
                                  if (iVar7 == 1) {
                                    local_11f4 = 0;
                                  }
                                  else {
                                    local_11f4 = iVar10 << 0x10;
                                  }
                                  if (iVar9 == 1) {
                                    local_11f0 = 0;
                                  }
                                  else {
                                    local_11f0 = local_11f0 << 0x10;
                                  }
                                  FUN_a02d9900(&local_1208,&local_11fc);
                                  FUN_a02da164(&local_1208,0);
                                  thunk_FUN_a0312460(&local_1208);
                                  return 0;
                                }
                                (*param_3)(s_ZoomY_should_be_1___n_a056588c);
                              }
                              return 0xfffffffe;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_set_de_a05659a0);
                            if (iVar7 == 0) {
                              uVar3 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                              FUN_a03b0ce0(0xb59,0,&local_1110,0);
                              local_1110 = (undefined1 *)CONCAT31(local_1110._1_3_,uVar3);
                              FUN_a02a70ec(s__KEVIN__set_digital_effect__d_a05659a8,uVar3);
                              FUN_a03b0ce0(0xb58,0,(uint)local_1110 & 0xff,0);
                              return 0;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_set_wb_a05659c8);
                            if (iVar7 == 0) {
                              if (param_1 < 5) {
                                FUN_a02a70ec(s__t_app__Usage___t_app_test_set_w_a05659f4);
                                return 0;
                              }
                              iVar7 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
                              uVar17 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
                              uVar11 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x14));
                              uVar12 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x18));
                              if (iVar7 == 1) {
                                FUN_a03b0ce0(0xa61,0,1,&local_1110);
                                FUN_a02a70ec(s__t_app__current__s_WB_R__d__G__d_a0565ba8,
                                             s_still_a056465c,local_1110,local_110c,local_1108);
                                pcVar13 = s_still_a056465c;
                              }
                              else {
                                FUN_a03b0ce0(0xa61,0,0,&local_1110);
                                FUN_a02a70ec(s__t_app__current__s_WB_R__d__G__d_a0565ba8,
                                             s__I__PB_MULTI_FUNC___06d___s__PB__a05314c4 + 0x2c,
                                             local_1110,local_110c,local_1108);
                                pcVar13 = s__I__PB_MULTI_FUNC___06d___s__PB__a05314c4 + 0x2c;
                              }
                              local_1110 = (undefined1 *)uVar17;
                              local_110c = uVar11;
                              local_1108 = uVar12;
                              FUN_a02a70ec(s__t_app__set__s_WB_R__d__G__d__B__a05659d0,pcVar13,
                                           uVar17,uVar11,uVar12);
                              FUN_a03b0ce0(0xa60,0,iVar7 == 1,&local_1110);
                              return 0;
                            }
                            local_11fc = FUN_a04f9744(uVar17,s_set_flat_color_a0565a44);
                            if (local_11fc == 0) {
                              local_11f8 = (undefined4 *)local_11fc;
                              iVar7 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
                              FUN_a03b0ce0(0xa01,0,&local_11fc,0);
                              local_11fc._0_2_ = CONCAT11(1,(byte)local_11fc);
                              FUN_a03b0ce0(0xb0d,0,&local_1110,0);
                              if (iVar7 == 1) {
                                local_110c = CONCAT22(local_110c._2_2_,0x104);
                                local_11fc._0_2_ = (ushort)(byte)local_11fc;
                                FUN_a03b0ce0(0xa00,0,&local_11fc,0);
                                FUN_a01cb1ec(0,1,0,1);
                                FUN_a03b0ce0(0xb58,0,1,0);
                                FUN_a03b0ce0(0xb0c,0,&local_1110,0);
                                pcVar13 = s_dbgthd__thread_mask____Set_dsp_l_a05cee14 + 100;
                              }
                              else {
                                local_110c = (uint)local_110c._2_2_ << 0x10;
                                FUN_a03b0ce0(0xa00,0,&local_11fc,0);
                                FUN_a01cb1ec(0,iVar7,0,1);
                                FUN_a03b0ce0(0xb58,0,iVar7,0);
                                FUN_a03b0ce0(0xb0c,0,&local_1110,0);
                                pcVar13 = s__I__MISC_POWEROFF___06d___s__Low_a052fc24 + 0x28;
                              }
                              FUN_a02a70ec(s__t_app___s_flat_color_a0565a54,pcVar13);
                              return 0;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_adj_custom_a0565a6c);
                            if (iVar7 == 0) {
                              FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
                              FUN_a01c8cd8();
                              FUN_a01c7cd4(0);
                              return 0;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_set_qv_a0565a78);
                            if (iVar7 == 0) {
                              iVar7 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
                              if (iVar7 == 1) {
                                FUN_a02a70ec(s__t_app__set_LCD_quickview_to__s_a0565bd0,
                                             s_FDT_ERR_BADVERSION_a060f374 + 0x10);
                                uVar17 = FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
                                *(undefined4 *)(_DAT_a1055cd4 + 0x20) = uVar17;
                                FUN_a02a70ec(s__t_app__quickview_delay__d_ms_a0565bf0,uVar17);
                                return 0;
                              }
                              FUN_a02a70ec(s__t_app__set_LCD_quickview_to__s_a0565bd0,
                                           s__I__PS___06d___s__Power_OFF_a052f660 + 0x18);
                              *(undefined4 *)(_DAT_a1055cd4 + 0x20) = 0;
                              return 0;
                            }
                            iVar7 = FUN_a04f9744(uVar17,s_set_piv_tile_a0565a80);
                            if (iVar7 == 0) {
                              uVar3 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                              uVar4 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                              uVar5 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                              FUN_a04680dc(uVar3,uVar4,uVar5);
                              return 0;
                            }
                          }
                          goto LAB_a01a19dc;
                        }
                        FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                        FUN_a03977dc();
                        FUN_a021f7d4(0);
                        uVar8 = (uint)DAT_a1055cd8;
                        if ((DAT_a1055cd8 & 0x38) == 0) {
                          FUN_a021e218();
                          FUN_a021e658();
                          FUN_a021d998();
                          FUN_a021e1a0();
                          return uVar8 & 0x38;
                        }
                        if ((uVar8 & 0x38) == 8) {
                          FUN_a021e218();
                          FUN_a021e658();
                          FUN_a02134fc();
                          FUN_a021387c();
                          return 0;
                        }
                      }
                    }
                    return 0;
                  }
                  if (param_1 != 3) {
                    uVar17 = *(undefined4 *)(param_2 + 0xc);
                    iVar7 = FUN_a04f9744(uVar17,s_ctl_init_a057cde8 + 4);
                    if (iVar7 == 0) {
                      FUN_a04f8dec(&local_1110,0,0x18);
                      FUN_a02484e8(&local_1110);
                      local_1110 = &DAT_a0fd7114;
                      if (param_1 < 6) {
                        local_1100 = 0x1e0000;
                      }
                      else {
                        uVar6 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                        local_1100 = CONCAT22(local_1100._2_2_,uVar6);
                        uVar6 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                        local_1100 = CONCAT22(uVar6,(undefined2)local_1100);
                      }
                      iVar7 = FUN_a0248530(&local_1110);
                      if (iVar7 == 0) {
                        FUN_a02a70ec(s__sApplibNetSharePreview_Init_don_a05651d8,DAT_a06f3088);
                        return 0;
                      }
                      FUN_a02a70ec(s__sFail_to_do_ApplibNetSharePrevi_a05651a8,DAT_a06f3088,iVar7);
                      return 0xffffffff;
                    }
                    iVar7 = FUN_a04f9744(uVar17,&DAT_a059a8b0);
                    if (iVar7 == 0) {
                      iVar7 = FUN_a02480c8();
                      if (iVar7 == 0) {
                        FUN_a02a70ec(s__sApplibNetSharePreview_Enable_d_a0565234,DAT_a06f3088);
                        return 0;
                      }
                      FUN_a02a70ec(s__sFail_to_do_ApplibNetSharePrevi_a0565200,DAT_a06f3088,iVar7);
                      return 0xffffffff;
                    }
                    iVar7 = FUN_a04f9744(uVar17,&DAT_a056525c);
                    if (iVar7 == 0) {
                      iVar7 = FUN_a0248314();
                      if (iVar7 == 0) {
                        FUN_a02a70ec(s__sApplibNetSharePreview_Disable_d_a0565294,DAT_a06f3088);
                        return 0;
                      }
                      FUN_a02a70ec(s__sFail_to_do_ApplibNetSharePrevi_a0565260,DAT_a06f3088,iVar7);
                      return 0xffffffff;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
LAB_a01a19dc:
    (*param_3)(s_Usage__t_app_test_<option>_Test_o_a0565c10);
    uVar8 = (*param_3)(s_dynamic_brc__0_pri___1__sec___Ma_a056613c);
    return uVar8;
  }
  if (param_1 == 3) {
    FUN_a02a70ec(s_input_split_param____d_a05647a0);
    uVar8 = 0;
  }
  else {
    uVar8 = FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
    FUN_a02a70ec(s_input_split_param____d_a05647a0,uVar8);
    if ((int)uVar8 < 0x101) {
      if (((int)uVar8 < 0xff) && (4 < uVar8)) {
LAB_a01a1c9c:
        FUN_a02a70ec(s_please_input_param__0_off_1_1G_2_a05647b8);
        return 0;
      }
    }
    else if (((uVar8 != 0x300) && (uVar8 != 0xff00)) && (uVar8 != 0x200)) goto LAB_a01a1c9c;
  }
  FUN_a021f7ac(uVar8);
  return 0;
}

