/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 shell_imgproc_handler(undefined4 param_1,int param_2,code *param_3)

{
  undefined1 uVar1;
  char cVar2;
  undefined1 uVar3;
  undefined2 uVar4;
  int iVar5;
  uint uVar6;
  undefined4 uVar7;
  uint in_fpscr;
  float fVar8;
  float fVar9;
  double dVar10;
  uint local_1b8;
  uint local_1b4;
  undefined4 local_1b0;
  undefined4 local_1ac;
  undefined4 local_1a8;
  uint local_1a4;
  undefined4 local_1a0;
  undefined4 local_19c;
  float local_194;
  float local_190;
  
  uVar7 = *(undefined4 *)(param_2 + 4);
  iVar5 = matched_FUN_a04f9744(uVar7,s__chno_a0574688);
  if (iVar5 == 0) {
    DAT_a06d36a8 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
  }
  else {
    iVar5 = matched_FUN_a04f9744(uVar7,s__mebias_a0574690);
    if (iVar5 == 0) {
      uVar7 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
      fVar8 = (float)matched_FUN_a01c8d00();
      (*param_3)(s__AppLib___ImgProcTest__Target_____a0574698,uVar7,(int)fVar8);
      return 0;
    }
    iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a05746c8);
    if (iVar5 == 0) {
      local_1ac = (float)iVar5;
      image_command_dispatch(0xe5,&local_1ac,0,0);
      (*param_3)(s__AppLib___ImgProcTest______Amba_I_a05746d0,local_1ac);
      return 0;
    }
    iVar5 = matched_FUN_a04f9744(uVar7,s__setmode_a0574714);
    if (iVar5 == 0) {
      uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
      local_1b0 = (float)CONCAT31(local_1b0._1_3_,uVar1);
      uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
      local_1ac = (float)CONCAT31(local_1ac._1_3_,uVar1);
      image_command_dispatch(0xc00,&local_1b0,&local_1ac,0);
      return 0;
    }
    iVar5 = matched_FUN_a04f9744(uVar7,s__getmode_a0574720);
    if (iVar5 == 0) {
      image_command_dispatch(0xc01,&local_1b0,&local_1ac);
      (*param_3)(s__AppLib___ImgProcTest_______Curr_a057472c,(uint)local_1b0 & 0xff,
                 (uint)local_1ac & 0xff);
    }
    else {
      iVar5 = matched_FUN_a04f9744(uVar7,s__get3astatus_a057476c);
      if (iVar5 == 0) {
        local_1b0 = (float)((uint)local_1b0 & 0xff000000);
        local_1ac = (float)((uint)local_1ac & 0xff000000);
        image_command_dispatch(0xa11,0,&local_1b0,&local_1ac);
        (*param_3)(s__AppLib___ImgProcTest_______Vide_a057477c,(uint)local_1b0 & 0xff,
                   local_1b0._1_1_,local_1b0._2_1_);
        (*param_3)(s__AppLib___ImgProcTest_______Stil_a05747b4,(uint)local_1ac & 0xff,
                   local_1ac._1_1_,local_1ac._2_1_);
      }
      else {
        iVar5 = matched_FUN_a04f9744(uVar7,s__set3astatus_a05747ec);
        if (iVar5 == 0) {
          image_command_dispatch(0xa11,0,&local_1b0,&local_1ac);
          iVar5 = matched_FUN_a04f9744
                            (*(undefined4 *)(param_2 + 8),
                             s__I__PB_MULTI_FUNC___06d___s__PB__a05314c4 + 0x2c);
          if (iVar5 == 0) {
            uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
            local_1b0 = (float)CONCAT31(local_1b0._1_3_,uVar1);
            uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
            local_1b0._0_2_ = CONCAT11(uVar1,(undefined1)local_1b0);
            uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
            local_1b0._0_3_ = CONCAT12(uVar1,(undefined2)local_1b0);
          }
          else {
            uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
            local_1ac = (float)CONCAT31(local_1ac._1_3_,uVar1);
            uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
            local_1ac._0_2_ = CONCAT11(uVar1,(byte)local_1ac);
            uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
            local_1ac._0_3_ = CONCAT12(uVar1,(ushort)local_1ac);
          }
          image_command_dispatch(0xa10,0,&local_1b0,&local_1ac);
        }
        else {
          uVar6 = matched_FUN_a04f9744(uVar7,&DAT_a05747fc);
          if (uVar6 == 0) {
            local_1b8 = uVar6;
            local_1b4 = uVar6;
            local_1b0 = (float)uVar6;
            local_1ac = (float)uVar6;
            local_1a8 = uVar6;
            image_command_dispatch(0xa01,0,&local_1ac,0);
            uVar7 = *(undefined4 *)(param_2 + 8);
            iVar5 = matched_FUN_a04f9744(uVar7,s_dsp_dec_cmd_on_a05ccad8 + 0xc);
            if (iVar5 == 0) {
              local_1ac = 2.3694278e-38;
            }
            else {
              iVar5 = matched_FUN_a04f9744(uVar7,s_dsp_dec_cmd_off_a05ccae8 + 0xc);
              if (iVar5 == 0) {
                uVar7 = *(undefined4 *)(param_2 + 0xc);
                iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574800);
                if (iVar5 == 0) {
                  local_1ac = (float)((uint)local_1ac & 0xffffff00);
                }
                iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574804);
                if (iVar5 == 0) {
                  local_1ac = (float)((uint)local_1ac & 0xffffff);
                }
                iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574808);
                if (iVar5 == 0) {
                  local_1ac._0_2_ = (ushort)(byte)local_1ac;
                }
                iVar5 = matched_FUN_a04f9744(uVar7,s_api__on_off____Print_api_call_a05ce4e0 + 0x24);
                if (iVar5 == 0) {
                  local_1ac = 0.0;
                }
              }
              else {
                iVar5 = matched_FUN_a04f9744
                                  (uVar7,s__I__REC_CONNECTED_CAM___06d___s__a0535d8c + 0x2c);
                if (iVar5 == 0) {
                  image_command_dispatch(0xe4,&local_1b8,&local_1b4,&local_1b0);
                  (*param_3)(s__AppLib___ImgProcTest______Amba_A_a057480c,local_1b8);
                  (*param_3)(s__AppLib___ImgProcTest______Amba_A_a0574848,local_1b4);
                  (*param_3)(s__AppLib___ImgProcTest______Amba_A_a0574884,local_1b0);
                }
                else {
                  (*param_3)(s__AppLib___ImgProcTest______AeOp___a05748c0,(uint)local_1ac & 0xff,
                             local_1ac._1_1_,local_1ac._2_1_,(uint)local_1ac >> 0x18);
                }
              }
            }
          }
          else {
            iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a057490c);
            if (iVar5 == 0) {
              image_command_dispatch(0xa26,param_1,param_2);
              return 0;
            }
            iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574910);
            if (iVar5 == 0) {
              image_command_dispatch(0xa27,param_1,param_2,0);
              return 0;
            }
            iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574918);
            if (iVar5 == 0) {
              dVar10 = (double)matched_FUN_a04f7e98(*(undefined4 *)(param_2 + 0xc));
              local_1b0 = (float)dVar10;
              dVar10 = (double)matched_FUN_a04f7e98(*(undefined4 *)(param_2 + 0x10));
              local_1ac = (float)dVar10;
              uVar7 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
              image_command_dispatch(0x10ff,uVar7,&local_1b0,&local_1ac);
              return 0;
            }
            uVar6 = matched_FUN_a04f9744(uVar7,&DAT_a0574920);
            if (uVar6 != 0) {
              iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574924);
              if (iVar5 == 0) {
                image_command_dispatch(0xa28,param_1,param_2);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a057492c);
              if (iVar5 == 0) {
                image_command_dispatch(0xa29,param_1,param_2);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574930);
              if (iVar5 == 0) {
                if (**(char **)(param_2 + 8) == '\0') {
                  image_command_dispatch(0xa2a,param_1,param_2);
                  return 0;
                }
                DAT_a12874b8 = matched_FUN_a04f7ea0();
                matched_FUN_a01cb1ec(0,DAT_a12874b8,0,1);
                image_command_dispatch(0xb58,0,DAT_a12874b8,0);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,s__exif_a0574934);
              if (iVar5 == 0) {
                DAT_a12874c4 = 0;
                DAT_a12874c0 = 1;
                DAT_a12874bc = iVar5;
                matched_FUN_a03afce0(&DAT_a12874bc);
                matched_FUN_a03afc80(0,&DAT_a12874c8);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,s__wb_sim_a057493c);
              if (iVar5 == 0) {
                image_command_dispatch(0xb14,0,&local_1ac,0);
                (*param_3)(s_LumaIdx____d_a0574944,(uint)local_1ac & 0xffff);
                (*param_3)(s_OutDoorIdx____d_a0574954,local_1ac._2_2_);
                (*param_3)(s_HighLightIdx____d_a0574964,local_1a8 & 0xffff);
                (*param_3)(s_LowLightIdx____d_a0574978,local_1a8._2_2_);
                (*param_3)(s_AwbRatio_0_____d_a057498c,local_1a4);
                (*param_3)(s_AwbRatio_1_____d_a05749a0,local_1a0);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,s__exif_dbg_a05749b4);
              if (iVar5 == 0) {
                if (**(char **)(param_2 + 8) != '\0') {
                  uVar1 = matched_FUN_a04f7ea0();
                  local_1ac = (float)CONCAT31(local_1ac._1_3_,uVar1);
                  image_command_dispatch(0xe2,&local_1ac,0,0);
                }
                image_command_dispatch(0xe3,&local_1ac,0,0);
                (*param_3)(s_Current_EXIF_Debug_Flg___d_a05749c0,(uint)local_1ac & 0xff);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a05749dc);
              if (iVar5 == 0) {
                cVar2 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
                uVar7 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                dVar10 = (double)VectorSignedToFloat(uVar7,(byte)(in_fpscr >> 0x16) & 3);
                fVar8 = (float)(dVar10 / DAT_a01c98a8);
                uVar7 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                dVar10 = (double)VectorSignedToFloat(uVar7,(byte)(in_fpscr >> 0x16) & 3);
                dVar10 = dVar10 / DAT_a01c98b0;
                fVar9 = (float)dVar10;
                uVar7 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                (*param_3)(s_Mode____d__ShtTime____d_us__AgcG_a05749e0,cVar2,
                           (int)(fVar8 * DAT_a01c98b8),(int)dVar10,uVar7);
                local_1a0 = uVar7;
                local_194 = fVar8;
                local_190 = fVar9;
                if (cVar2 == '\0') {
                  uVar4 = image_command_dispatch(0xb17,0,0,&local_1ac);
                  local_19c = CONCAT22(local_19c._2_2_,uVar4);
                  image_command_dispatch(0xa50,0,0,&local_1ac);
                  return 0;
                }
                uVar4 = image_command_dispatch(0xb17,0,1,&local_1ac);
                local_19c = CONCAT22(local_19c._2_2_,uVar4);
                image_command_dispatch(0xa50,0,1,&local_1ac);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,&DAT_a0574a18);
              if (iVar5 == 0) {
                local_1ac = (float)DAT_a05744b4;
                local_1a8 = DAT_a05744b8;
                local_1a4 = DAT_a05744bc;
                local_1a0 = DAT_a05744c0;
                local_19c = DAT_a05744c4;
                cVar2 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
                image_command_dispatch(0xa61,0,cVar2 != '\0',&local_1ac);
                uVar6 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
                local_1ac = (float)(uVar6 & 0xffff);
                local_1a8 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
                local_1a8 = local_1a8 & 0xffff;
                local_1a4 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x14));
                local_1a4 = local_1a4 & 0xffff;
                (*param_3)(s_Mode____d__GainR____5d__GainG_____a0574a20,cVar2,local_1ac,local_1a8,
                           local_1a4);
                image_command_dispatch(0xa60,0,cVar2 != '\0',&local_1ac);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,s__evbias_a0574a54);
              if (iVar5 == 0) {
                uVar4 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
                image_command_dispatch(0xb03,0,&local_1ac,0);
                local_1a0 = CONCAT22(local_1a0._2_2_,uVar4);
                image_command_dispatch(0xb02,0,&local_1ac,0);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,s__sharp_a0574a5c);
              if (iVar5 == 0) {
                matched_FUN_a04f8dec(&local_1ac,0,0xc);
                uVar4 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
                image_command_dispatch(0xb5e,0,&local_1ac,uVar4);
                return 0;
              }
              iVar5 = matched_FUN_a04f9744(uVar7,s__slowshutter_a0574a64);
              if (iVar5 != 0) {
                (*param_3)(s_Usage__t_imgproc__ver__3a__on_of_a0574a74);
                return 0;
              }
              cVar2 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 8));
              uVar1 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0xc));
              uVar3 = matched_FUN_a04f7ea0(*(undefined4 *)(param_2 + 0x10));
              image_command_dispatch(0xb03,0,&local_1ac,0);
              if (cVar2 == '\0') {
                local_1ac = (float)CONCAT13(uVar1,(uint3)local_1ac);
                local_1a8 = CONCAT31(local_1a8._1_3_,uVar3);
              }
              else {
                local_1a8 = CONCAT13(uVar3,CONCAT12(uVar1,(undefined2)local_1a8));
              }
              image_command_dispatch(0xb02,0,&local_1ac,0);
              return 0;
            }
            local_1ac = (float)uVar6;
            local_1a8 = uVar6;
            image_command_dispatch(0xa01,0,&local_1ac,0);
            uVar7 = *(undefined4 *)(param_2 + 8);
            iVar5 = matched_FUN_a04f9744(uVar7,s_dsp_dec_cmd_on_a05ccad8 + 0xc);
            if (iVar5 == 0) {
              local_1ac._0_3_ = CONCAT12(1,(ushort)local_1ac);
            }
            else {
              iVar5 = matched_FUN_a04f9744(uVar7,s_dsp_dec_cmd_off_a05ccae8 + 0xc);
              if (iVar5 == 0) {
                local_1ac._0_3_ = (uint3)(ushort)local_1ac;
              }
            }
          }
          image_command_dispatch(0xa00,0,&local_1ac,0);
        }
      }
    }
  }
  return 0;
}

