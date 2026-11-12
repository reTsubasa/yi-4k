/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int shell_app_dispatch(int param_1,int param_2,code *param_3)

{
  undefined2 uVar1;
  undefined2 uVar2;
  int iVar3;
  uint uVar4;
  undefined4 uVar5;
  uint uVar6;
  int iVar7;
  char *pcVar8;
  char cVar9;
  undefined4 uVar10;
  uint uVar11;
  undefined4 uVar12;
  undefined1 auStack_1c [4];
  
  if (param_1 < 2) {
LAB_a01a5014:
    iVar3 = (*param_3)(s_App_test_command_list__msg_key_j_a0567060);
    return iVar3;
  }
  uVar10 = *(undefined4 *)(param_2 + 4);
  iVar3 = matched_FUN_a04f9744(uVar10,s__W__REC_CONNECTED_CAM___06d___s__a0534110 + 0x5c);
  if (iVar3 == 0) {
    if (param_1 == 2) {
      iVar3 = (*param_3)(s_Usage__t_app_msg_<msg>_<param1>_<_a056686c);
      return iVar3;
    }
    uVar10 = matched_FUN_a04fb328(*(undefined4 *)(param_2 + 8),auStack_1c,0);
    uVar12 = matched_FUN_a04fb328(*(undefined4 *)(param_2 + 0xc),auStack_1c,0);
    uVar5 = matched_FUN_a04fb328(*(undefined4 *)(param_2 + 0x10),auStack_1c,0);
    iVar3 = matched_thunk_FUN_a01e653c(uVar10,uVar12,uVar5);
    return iVar3;
  }
  iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566898);
  if (iVar3 != 0) {
    iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566df4);
    if (iVar3 == 0) {
      if (3 < param_1) {
        uVar10 = *(undefined4 *)(param_2 + 0xc);
        iVar3 = matched_FUN_a04f9744(uVar10,s__I__CAM_TOUCH___06d___s__Slide_d_a05471ac + 0x30);
        if (iVar3 == 0) {
          uVar6 = 1;
        }
        else {
          iVar3 = matched_FUN_a04f9744(uVar10,s_AmbaDSP_WaitYuvGenDone__d___d__t_a05c824c + 0x24);
          if (iVar3 != 0) goto LAB_a01a50c4;
          uVar6 = 0;
        }
        uVar10 = *(undefined4 *)(param_2 + 8);
        iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a05670cc);
        if (iVar3 == 0) {
          uVar4 = 0x200;
        }
        else {
          iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566e48);
          if (iVar3 != 0) goto LAB_a01a50c4;
          uVar4 = 0x300;
        }
        iVar3 = matched_thunk_FUN_a01e653c(uVar6 | uVar4 | 0xe8020000,0,0);
        if (iVar3 != -2) {
          return iVar3;
        }
      }
LAB_a01a50c4:
      iVar3 = (*param_3)(s_Usage__t_app_jack_<jack>_<event>_a0566dfc);
      return iVar3;
    }
    iVar3 = matched_FUN_a04f9744(uVar10,s__I__PB_MULTI_FUNC___06d___s__Han_a05311f0 + 0x38);
    if (iVar3 == 0) {
      iVar3 = app_test_dispatch(param_1,param_2,param_3);
      return iVar3;
    }
    iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566e4c);
    if (iVar3 == 0) {
      FUN_a02a70ec(s____________MEMORY_POOL_STATISTIC_a0566e50);
      FUN_a02a70ec(s_HEAP___Available_size____10d_byt_a0566e7c,DAT_a0fd711c,DAT_a0fd711c >> 0x14);
      FUN_a02a70ec(s_NON_HEAP___Available_size____10d_a0566eb8,DAT_a0fe7228,DAT_a0fe7228 >> 0x14);
      return 0;
    }
    iVar3 = matched_FUN_a04f9744(uVar10,s_sensor_a0566ef4);
    if (iVar3 == 0) {
      iVar3 = matched_FUN_a01a46d0(param_1,param_2);
      return iVar3;
    }
    iVar3 = matched_FUN_a04f9744(uVar10,s_aucodec_a0566efc);
    if (iVar3 == 0) {
      if (param_1 == 2) {
        FUN_a02a70ec(s_Worng_Setting_for_audio_CODEC_I__a0566fdc);
        FUN_a02a70ec(s_eg__t_svc_aucodec_setoutput_0_0x_a056700c);
        FUN_a02a70ec(s_eg__t_svc_aucodec_setinput_0_0x1_a0567030);
        return 0;
      }
      uVar10 = *(undefined4 *)(param_2 + 8);
      iVar3 = matched_FUN_a04f9744(uVar10,s_setoutput_a0566f04);
      if (iVar3 == 0) {
        iVar3 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
        uVar6 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
        (**(code **)((&DAT_a1a3105c)[iVar3] + 0xc))(uVar6 & 0xff);
        (*param_3)(s_<AUCODEC>_Set_audio__d_CODEC_out_a0566f10,iVar3,uVar6);
        return 0;
      }
      iVar3 = matched_FUN_a04f9744(uVar10,s_setinput_a0566f44);
      if (iVar3 == 0) {
        iVar3 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
        uVar6 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
        (**(code **)((&DAT_a1a3105c)[iVar3] + 0x10))(uVar6 & 0xff);
        (*param_3)(s_<AUCODEC>_Set_audio__d_CODEC_inp_a0566f50,iVar3,uVar6);
        return 0;
      }
      iVar3 = matched_FUN_a04f9744(uVar10,s_close_native_channel_and_abort_p_a063e9f8 + 0x2c);
      if (iVar3 == 0) {
        iVar3 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
        uVar1 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
        uVar2 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x14));
        iVar3 = (**(code **)((&DAT_a1a3105c)[iVar3] + 0x20))(uVar1,uVar2);
        if (iVar3 != 0) {
          (*param_3)(s_<AUCODEC>_AmbaAudio_CodecWrite__N_a0566f84);
          return 0;
        }
      }
      else {
        iVar3 = matched_FUN_a04f9744(uVar10,s_partition_last_page_read_a062b004 + 0x14);
        if (iVar3 == 0) {
          iVar3 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0xc));
          uVar6 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x10));
          iVar7 = matched_FUN_a04f7ea8(*(undefined4 *)(param_2 + 0x14));
          if (iVar7 != 0) {
            uVar4 = uVar6;
            do {
              uVar10 = (**(code **)((&DAT_a1a3105c)[iVar3] + 0x24))(uVar4 & 0xffff);
              uVar11 = uVar4 + 1;
              (*param_3)(s_<AUCODEC>_AmbaAudio_CodecRead__0_a0566fa8,iVar3,uVar4,uVar10);
              uVar4 = uVar11;
            } while (uVar11 != uVar6 + iVar7);
          }
        }
      }
      return 0;
    }
    iVar3 = matched_FUN_a04f9744(uVar10,s_powersaving_a0567054);
    if (iVar3 == 0) {
      matched_thunk_FUN_a01e653c(0xf001031a,0,0);
      return 0;
    }
    goto LAB_a01a5014;
  }
  if (param_1 == 2) goto LAB_a01a5104;
  uVar10 = *(undefined4 *)(param_2 + 8);
  iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0564ac4);
  uVar6 = 0;
  if (iVar3 == 0) {
LAB_a01a54dc:
    iVar3 = matched_thunk_FUN_a01e653c(uVar6 | 0xe0010000,0,0);
  }
  else {
    iVar3 = matched_FUN_a04f9744(uVar10,s_up_rel_a05669f0);
    if (iVar3 == 0) {
      iVar3 = matched_thunk_FUN_a01e653c(0xe0010800,0,0);
    }
    else {
      iVar3 = matched_FUN_a04f9744(uVar10,s_SelfCaptureCountdown_a05360e0 + 0x10);
      if (iVar3 == 0) {
        iVar3 = matched_thunk_FUN_a01e653c(0xe0010001,0,0);
      }
      else {
        iVar3 = matched_FUN_a04f9744(uVar10,s_down_rel_a05669f8);
        if (iVar3 == 0) {
          iVar3 = matched_thunk_FUN_a01e653c(0xe0010801,0,0);
        }
        else {
          iVar3 = matched_FUN_a04f9744(uVar10,s_Vignette_Core_Error__current_win_a05e623c + 0x38);
          if (iVar3 == 0) {
            iVar3 = matched_thunk_FUN_a01e653c(0xe0010002,0,0);
          }
          else {
            iVar3 = matched_FUN_a04f9744(uVar10,s_left_rel_a0566a04);
            if (iVar3 == 0) {
              uVar6 = 0x802;
              goto LAB_a01a578c;
            }
            iVar3 = matched_FUN_a04f9744(uVar10,s_right_a0566a10);
            if (iVar3 == 0) {
              iVar3 = matched_thunk_FUN_a01e653c(0xe0010003,0,0);
            }
            else {
              iVar3 = matched_FUN_a04f9744(uVar10,s_right_rel_a0566a18);
              if (iVar3 == 0) {
                iVar3 = matched_thunk_FUN_a01e653c(0xe0010803,0,0);
              }
              else {
                iVar3 = matched_FUN_a04f9744(uVar10,s_zoomin_a0566a24);
                if (iVar3 == 0) {
                  iVar3 = matched_thunk_FUN_a01e653c(0xe0010008,0,0);
                }
                else {
                  iVar3 = matched_FUN_a04f9744(uVar10,s_zoomin_rel_a0566a2c);
                  if (iVar3 == 0) {
                    iVar3 = matched_thunk_FUN_a01e653c(0xe0010808,0,0);
                  }
                  else {
                    iVar3 = matched_FUN_a04f9744(uVar10,s_zoomout_a0566a38);
                    if (iVar3 == 0) {
                      iVar3 = matched_thunk_FUN_a01e653c(0xe0010009,0,0);
                    }
                    else {
                      iVar3 = matched_FUN_a04f9744(uVar10,s_zoomout_rel_a0566a40);
                      if (iVar3 == 0) {
                        iVar3 = matched_thunk_FUN_a01e653c(0xe0010809,0,0);
                      }
                      else {
                        iVar3 = matched_FUN_a04f9744
                                          (uVar10,s_invalid_literal_lengths_set_a0571eac + 0x18);
                        if (iVar3 == 0) {
                          iVar3 = matched_thunk_FUN_a01e653c(0xe0010011,0,0);
                        }
                        else {
                          iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566a4c);
                          if (iVar3 == 0) {
                            iVar3 = matched_thunk_FUN_a01e653c(0xe0010022,0,0);
                          }
                          else {
                            iVar3 = matched_FUN_a04f9744(uVar10,s_focus_a0566a50);
                            if (iVar3 == 0) {
                              iVar3 = matched_thunk_FUN_a01e653c(0xe001000d,0,0);
                            }
                            else {
                              iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566a58);
                              if (iVar3 == 0) {
                                uVar6 = 0x1f;
LAB_a01a578c:
                                iVar3 = matched_thunk_FUN_a01e653c(uVar6 | 0xe0010000,0,0);
                              }
                              else {
                                iVar3 = matched_FUN_a04f9744
                                                  (uVar10,
                                                  s__Cmplx___bitrate__dKbps__>__dKbp_a0601ca4 + 0x30
                                                  );
                                if (iVar3 == 0) {
                                  return 0;
                                }
                                iVar3 = matched_FUN_a04f9744(uVar10,s_poweroff_a0566a5c);
                                if (iVar3 == 0) {
                                  iVar3 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                                  if (iVar3 == 0) {
                                    pcVar8 = s_dsp_dec_cmd_off_a05ccae8 + 0xc;
                                  }
                                  else if (iVar3 == 3) {
                                    pcVar8 = s_3_minutes_a054dfcc;
                                  }
                                  else if (iVar3 == 5) {
                                    pcVar8 = s_5_minutes_a054de68;
                                  }
                                  else {
                                    if (iVar3 != 10) {
                                      FUN_a02a70ec(s_<save_poweroff>_invalid_param____a0566a68,
                                                   *(undefined4 *)(param_2 + 0xc));
                                      return 0;
                                    }
                                    pcVar8 = s_10_minutes_a054dfd8;
                                  }
                                  iVar3 = matched_FUN_a014f0d0(pcVar8,1);
                                  if (iVar3 == 0) {
                                    FUN_a02a70ec(s_<save_poweroff>_successfuly___s_a0566a8c,
                                                 *(undefined4 *)(param_2 + 0xc));
                                    return 0;
                                  }
                                  FUN_a02a70ec(s_<save_poweroff>_failed___d_a0566aac,iVar3);
                                }
                                else {
                                  iVar3 = matched_FUN_a04f9744(uVar10,s_psexit_a0566ac8);
                                  if (iVar3 == 0) {
                                    *(undefined1 *)(DAT_a1055cd4 + 0x7a) = 0;
                                    iVar3 = matched_FUN_a0105024();
                                  }
                                  else {
                                    iVar3 = matched_FUN_a04f9744(uVar10,s_focus_rel_a0566ad0);
                                    if (iVar3 != 0) {
                                      iVar3 = matched_FUN_a04f9744
                                                        (uVar10,
                                                  s__IS__d__SS_Convert_shutter_a060c5a0 + 0x14);
                                      if (iVar3 == 0) {
                                        FUN_a02a70ec(s__s_______________>_shutter_to_st_a0566adc,
                                                     DAT_a06f3088,param_1);
                                        if (param_1 == 3) {
                                          FUN_a02a70ec(s__sinvalid_pa_ram_______________>_a0566b0c,
                                                       DAT_a06f3088);
                                          return 0;
                                        }
                                        uVar6 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc))
                                        ;
                                        if (uVar6 == 5) {
                                          *(undefined1 *)(DAT_a1055cd4 + 0x1f) = 3;
                                          uVar6 = 0;
                                        }
                                        else {
                                          *(undefined1 *)(DAT_a1055cd4 + 0x1f) = 0;
                                        }
                                        *(byte *)(DAT_a1055cd4 + 0x1c) =
                                             *(byte *)(DAT_a1055cd4 + 0x1c) & 199 |
                                             (byte)((uVar6 & 7) << 3);
                                        matched_FUN_a0213b5c(uVar6);
                                        uVar6 = 0xe;
                                        goto LAB_a01a578c;
                                      }
                                      iVar3 = matched_FUN_a04f9744(uVar10,s_fac_test_a0566b58);
                                      uVar12 = DAT_a06f3088;
                                      if (iVar3 == 0) {
                                        if (param_1 < 5) {
                                          FUN_a02a70ec(s__s_______________>_factory_fosd_p_a0566b64,
                                                       DAT_a06f3088);
                                          return 0;
                                        }
                                        uVar10 = matched_FUN_a04f7ea0
                                                           (*(undefined4 *)(param_2 + 0x10));
                                        FUN_a02a70ec(s__s_______________>_factory_fosd__a0566b90,
                                                     uVar12,uVar10);
                                        uVar12 = *(undefined4 *)(param_2 + 0xc);
                                        uVar10 = matched_FUN_a04f7ea0
                                                           (*(undefined4 *)(param_2 + 0x10));
                                        matched_thunk_FUN_a01e653c(0xd8070001,uVar12,uVar10);
                                        return 0;
                                      }
                                      iVar3 = matched_FUN_a04f9744(uVar10,s_shutter_stamp_a0566bc0);
                                      if (iVar3 == 0) {
                                        uVar6 = 0;
                                        if ((param_1 == 3) ||
                                           (uVar6 = matched_FUN_a04f7ea0
                                                              (*(undefined4 *)(param_2 + 0xc)),
                                           uVar6 < 4)) {
                                          *(char *)(DAT_a1055cd4 + 0x25) = (char)uVar6;
                                        }
LAB_a01a58ac:
                                        *(byte *)(DAT_a1055cd4 + 0x1c) =
                                             *(byte *)(DAT_a1055cd4 + 0x1c) & 199;
                                        matched_FUN_a0213b5c(0);
                                        uVar6 = 0xe;
                                        goto LAB_a01a578c;
                                      }
                                      iVar3 = matched_FUN_a04f9744
                                                        (uVar10,s_shutter_precise_a0566bd0);
                                      if (iVar3 == 0) {
                                        FUN_a02a70ec(s___shutter__precise___a0566be0);
                                        *(byte *)(DAT_a1055cd4 + 0x1c) =
                                             *(byte *)(DAT_a1055cd4 + 0x1c) & 199;
                                        matched_FUN_a0213b5c(0);
LAB_a01a5abc:
                                        iVar3 = matched_thunk_FUN_a01e653c(0xe001000e,0,0);
                                        goto LAB_a01a54cc;
                                      }
                                      iVar3 = matched_FUN_a04f9744
                                                        (uVar10,s_shutter_precise_selftimer_a0566bf8
                                                        );
                                      if (iVar3 == 0) {
                                        if (param_1 != 3) {
                                          uVar10 = matched_FUN_a04f7ea0
                                                             (*(undefined4 *)(param_2 + 0xc));
                                          FUN_a02a70ec(s___shutter__precise_selftimer___a0566c14);
                                          switch(uVar10) {
                                          case 0:
                                          case 3:
                                          case 5:
                                          case 10:
                                          case 0xf:
                                            goto switchD_a01a59e4_caseD_0;
                                          default:
                                            goto LAB_a01a58ac;
                                          }
                                        }
                                        uVar10 = 0;
                                        FUN_a02a70ec(s___shutter__precise_selftimer___a0566c14);
switchD_a01a59e4_caseD_0:
                                        *(char *)(DAT_a1055cd4 + 0x1f) = (char)uVar10;
                                        goto LAB_a01a58ac;
                                      }
                                      iVar3 = matched_FUN_a04f9744(uVar10,s_shutter_pes_a0566c34);
                                      if (iVar3 == 0) {
                                        if (param_1 == 3) {
                                          uVar6 = 0;
                                          FUN_a02a70ec(s___shutter__pes___a0566c40);
LAB_a01a5a5c:
                                          *(short *)(DAT_a1055cd4 + 0x26) = (short)uVar6;
                                        }
                                        else {
                                          uVar6 = matched_FUN_a04f7ea0
                                                            (*(undefined4 *)(param_2 + 0xc));
                                          FUN_a02a70ec(s___shutter__pes___a0566c40);
                                          if (uVar6 == 0x78) goto LAB_a01a5a5c;
                                          if ((int)uVar6 < 0x79) {
                                            if (uVar6 != 10) {
                                              if ((int)uVar6 < 0xb) {
                                                if (uVar6 < 3) goto LAB_a01a5a5c;
                                              }
                                              else if ((uVar6 == 0x14) || (uVar6 == 0x3c))
                                              goto LAB_a01a5a5c;
                                              goto LAB_a01a5a6c;
                                            }
                                            goto LAB_a01a5a5c;
                                          }
                                          if (uVar6 == 0x4b0) goto LAB_a01a5a5c;
                                          if ((int)uVar6 < 0x4b1) {
                                            if ((uVar6 == 0xf0) || (uVar6 == 600))
                                            goto LAB_a01a5a5c;
                                          }
                                          else if ((uVar6 == 0x1c20) ||
                                                  ((uVar6 == 0xffff || (uVar6 == 0xe10))))
                                          goto LAB_a01a5a5c;
                                        }
LAB_a01a5a6c:
                                        cVar9 = '\x01';
                                      }
                                      else {
                                        iVar3 = matched_FUN_a04f9744
                                                          (uVar10,s_shutter_burst_a0566c54);
                                        if (iVar3 != 0) {
                                          iVar3 = matched_FUN_a04f9744
                                                            (uVar10,s_shutter_piv_a0566c78);
                                          if (iVar3 == 0) {
                                            FUN_a02a70ec(s_shutter__no_stop___a0566c84);
                                            goto LAB_a01a5abc;
                                          }
                                          iVar3 = matched_FUN_a04f9744
                                                            (uVar10,s_shutter_rel_a0566c98);
                                          if (iVar3 == 0) {
                                            iVar3 = matched_thunk_FUN_a01e653c(0xe001080e,0,0);
                                          }
                                          else {
                                            iVar3 = matched_FUN_a04f9744
                                                              (uVar10,s_start_video_record_a053af8c
                                                                      + 0xc);
                                            if (iVar3 == 0) {
                                              if (param_1 == 3) {
                                                FUN_a02a70ec(
                                                  s_default_param_please_input_0_2_4_a0566d04);
                                              }
                                              else {
                                                uVar6 = matched_FUN_a04f7ea0
                                                                  (*(undefined4 *)(param_2 + 0xc));
                                                FUN_a02a70ec(s_input_timelapse_is__d_a0566ca4,uVar6)
                                                ;
                                                if (uVar6 == 4) {
LAB_a01a5bf0:
                                                  FUN_a02a70ec(s____input_tim_elapse_is__d_a0566cbc,
                                                               uVar6);
                                                  matched_FUN_a021f784(uVar6);
                                                  matched_FUN_a0220fa0(0);
                                                }
                                                else {
                                                  if ((int)uVar6 < 5) {
                                                    if (uVar6 < 3) goto LAB_a01a5bf0;
                                                  }
                                                  else if ((uVar6 == 10) || (uVar6 == 0x3c))
                                                  goto LAB_a01a5bf0;
                                                  FUN_a02a70ec(
                                                  s_invalid_param__please_input_0_2__a0566cd8);
                                                }
                                                if (param_1 != 4) {
                                                  uVar10 = matched_FUN_a04f7ea0
                                                                     (*(undefined4 *)
                                                                       (param_2 + 0x10));
                                                  FUN_a02a70ec(s_int_put_recordpiv____d_a0566d30,
                                                               uVar10);
                                                  if (uVar6 != 0) {
                                                    uVar10 = 0;
                                                  }
                                                  matched_FUN_a0220fa0(uVar10);
                                                }
                                              }
                                              uVar6 = 0xc;
                                              goto LAB_a01a578c;
                                            }
                                            iVar3 = matched_FUN_a04f9744
                                                              (uVar10,
                                                  s_DSP_changed_to_IDLE_mode_a05c73bc + 0x14);
                                            if (iVar3 == 0) {
                                              iVar3 = matched_thunk_FUN_a01e653c(0xe001000f,0,0);
                                            }
                                            else {
                                              iVar3 = matched_FUN_a04f9744(uVar10,s_power_a0566d48);
                                              if (iVar3 == 0) {
                                                iVar3 = matched_FUN_a019cf5c(6);
                                              }
                                              else {
                                                iVar3 = matched_FUN_a04f9744
                                                                  (uVar10,s_autopf_a0566d50);
                                                if (iVar3 == 0) {
                                                  *(undefined2 *)(DAT_a1055cd4 + 0x78) = 0x3c;
                                                  return 0;
                                                }
                                                iVar3 = matched_FUN_a04f9744
                                                                  (uVar10,s_power_rel_a0566d58);
                                                if (iVar3 != 0) {
                                                  iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a055cd20)
                                                  ;
                                                  if (iVar3 != 0) {
                                                    iVar3 = matched_FUN_a04f9744
                                                                      (uVar10,s_start_wifi_a0566d64)
                                                    ;
                                                    if (iVar3 == 0) {
                                                      pcVar8 = (char *)matched_FUN_a04f866c(0x1000);
                                                      uVar5 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._12_4_
                                                  ;
                                                  uVar12 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._8_4_;
                                                  uVar10 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._4_4_;
                                                  if (pcVar8 == (char *)0x0) {
                                                    return -1;
                                                  }
                                                  if (param_1 == 3) {
                                                    *(undefined4 *)pcVar8 =
                                                         s__usr_local_share_script_wifi_xy__a0566d70
                                                         ._0_4_;
                                                    *(undefined4 *)(pcVar8 + 4) = uVar10;
                                                    *(undefined4 *)(pcVar8 + 8) = uVar12;
                                                    *(undefined4 *)(pcVar8 + 0xc) = uVar5;
                                                    uVar5 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._28_4_
                                                  ;
                                                  uVar12 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._24_4_
                                                  ;
                                                  uVar10 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._20_4_
                                                  ;
                                                  *(undefined4 *)(pcVar8 + 0x10) =
                                                       s__usr_local_share_script_wifi_xy__a0566d70.
                                                       _16_4_;
                                                  *(undefined4 *)(pcVar8 + 0x14) = uVar10;
                                                  *(undefined4 *)(pcVar8 + 0x18) = uVar12;
                                                  *(undefined4 *)(pcVar8 + 0x1c) = uVar5;
                                                  uVar12 = ram0xa0566d98;
                                                  uVar10 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._36_4_
                                                  ;
                                                  *(undefined4 *)(pcVar8 + 0x20) =
                                                       s__usr_local_share_script_wifi_xy__a0566d70.
                                                       _32_4_;
                                                  *(undefined4 *)(pcVar8 + 0x24) = uVar10;
                                                  pcVar8[0x28] = (char)uVar12;
                                                  }
                                                  else {
                                                    *(undefined4 *)pcVar8 =
                                                         s__usr_local_share_script_wifi_xy__a0566d70
                                                         ._0_4_;
                                                    *(undefined4 *)(pcVar8 + 4) = uVar10;
                                                    *(undefined4 *)(pcVar8 + 8) = uVar12;
                                                    *(undefined4 *)(pcVar8 + 0xc) = uVar5;
                                                    uVar5 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._28_4_
                                                  ;
                                                  uVar12 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._24_4_
                                                  ;
                                                  uVar10 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._20_4_
                                                  ;
                                                  *(undefined4 *)(pcVar8 + 0x10) =
                                                       s__usr_local_share_script_wifi_xy__a0566d70.
                                                       _16_4_;
                                                  *(undefined4 *)(pcVar8 + 0x14) = uVar10;
                                                  *(undefined4 *)(pcVar8 + 0x18) = uVar12;
                                                  *(undefined4 *)(pcVar8 + 0x1c) = uVar5;
                                                  uVar12 = ram0xa0566d98;
                                                  uVar10 = 
                                                  s__usr_local_share_script_wifi_xy__a0566d70._36_4_
                                                  ;
                                                  *(undefined4 *)(pcVar8 + 0x20) =
                                                       s__usr_local_share_script_wifi_xy__a0566d70.
                                                       _32_4_;
                                                  *(undefined4 *)(pcVar8 + 0x24) = uVar10;
                                                  pcVar8[0x28] = (char)uVar12;
                                                  iVar3 = matched_FUN_a04f9744
                                                                    (*(undefined4 *)(param_2 + 0xc),
                                                                     s_sta_ssid_a05504b0 + 4);
                                                  if (iVar3 == 0) {
                                                    uVar12 = *(undefined4 *)(param_2 + 0x10);
                                                    uVar6 = matched_FUN_a04f99f0(uVar12);
                                                    uVar10 = s_sta_ssid_a05504b0._4_4_;
                                                    if (uVar6 < 0x20) {
                                                      pcVar8[0x28] = ' ';
                                                      pcVar8[0x2d] = ' ';
                                                      *(undefined4 *)(pcVar8 + 0x29) = uVar10;
                                                      matched_FUN_a04f9900(pcVar8 + 0x2e,uVar12);
                                                    }
                                                  }
                                                  uVar10 = *(undefined4 *)(param_2 + 0x14);
                                                  iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566d9c)
                                                  ;
                                                  if (iVar3 == 0) {
                                                    iVar3 = matched_FUN_a04f99f0(pcVar8);
                                                    pcVar8[iVar3] = ' ';
                                                    matched_FUN_a04f9900(pcVar8 + iVar3 + 1,uVar10);
                                                  }
                                                  iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a05670c4)
                                                  ;
                                                  if (iVar3 == 0) {
                                                    iVar3 = matched_FUN_a04f99f0(pcVar8);
                                                    pcVar8[iVar3] = ' ';
                                                    matched_FUN_a04f9900(pcVar8 + iVar3 + 1,uVar10);
                                                  }
                                                  }
                                                  FUN_a02a70ec(s__s_s_a0566da0,DAT_a06f3088,pcVar8);
                                                  matched_FUN_a0479708(pcVar8);
                                                  matched_FUN_a04f867c(pcVar8);
                                                  return 0;
                                                  }
                                                  iVar3 = matched_FUN_a04f9744
                                                                    (uVar10,s_stop_wifi_a0566da8);
                                                  if (iVar3 == 0) {
                                                    matched_FUN_a0479708
                                                              (
                                                  s__usr_local_share_script_wifi_sto_a0566db4);
                                                  return 0;
                                                  }
                                                  iVar3 = matched_FUN_a04f9744(uVar10,&DAT_a0566ddc)
                                                  ;
                                                  if (iVar3 == 0) {
                                                    if (param_1 == 4) {
                                                      matched_FUN_a04f7ea0
                                                                (*(undefined4 *)(param_2 + 0xc));
                                                      matched_FUN_a01a4f08();
                                                      return 0;
                                                    }
                                                    (*param_3)(s__USAGE___s__0_1__a0566de0,uVar10);
                                                    return -1;
                                                  }
                                                  goto LAB_a01a5104;
                                                  }
                                                  uVar6 = 0x18;
                                                  goto LAB_a01a54dc;
                                                }
                                                iVar3 = matched_thunk_FUN_a01e653c(0xe001080a,0,0);
                                              }
                                            }
                                          }
                                          goto LAB_a01a54cc;
                                        }
                                        if (param_1 == 3) {
                                          uVar6 = 0;
LAB_a01a5b64:
                                          *(char *)(DAT_a1055cd4 + 0x1d) = (char)uVar6;
                                          matched_FUN_a0213c0c(uVar6);
                                        }
                                        else {
                                          uVar6 = matched_FUN_a04f7ea0
                                                            (*(undefined4 *)(param_2 + 0xc));
                                          if (uVar6 < 3) goto LAB_a01a5b64;
                                        }
                                        FUN_a02a70ec(s___shutter__burst___a0566c64);
                                        cVar9 = '\x02';
                                      }
                                      *(byte *)(DAT_a1055cd4 + 0x1c) =
                                           *(byte *)(DAT_a1055cd4 + 0x1c) & 199 | cVar9 << 3;
                                      matched_FUN_a0213b5c(cVar9);
                                      uVar6 = 0xe;
                                      goto LAB_a01a578c;
                                    }
                                    iVar3 = matched_thunk_FUN_a01e653c(0xe001080d,0,0);
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
LAB_a01a54cc:
  if (iVar3 != -2) {
    return iVar3;
  }
LAB_a01a5104:
  iVar3 = (*param_3)(s_Usage__t_app_key_<key>_Key_list__a056689c);
  return iVar3;
}

