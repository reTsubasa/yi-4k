/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa01bd5a4, name: matched_FUN_a01bd5a4.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Restarted to delay deadcode elimination for space: ram */

void matched_FUN_a01bd5a4(void)

{
  uint uVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  int iVar6;
  uint uVar7;
  int iVar8;
  byte bVar9;
  char *pcVar10;
  uint uVar11;
  uint local_38;
  uint local_34;
  uint local_30;
  undefined4 local_2c;
  
  local_38 = 0;
  local_34 = 0;
  local_30 = 0;
  local_2c = 0;
  uVar2 = matched_FUN_a01e66e8();
  iVar3 = matched_FUN_a02980e0();
  matched_FUN_a04f8dec(&DAT_a1055cd8,0,0x368);
  DAT_a1055cf0 = 0xff;
  matched_FUN_a0222d54();
  matched_FUN_a0192404();
  matched_FUN_a01e57d8();
  matched_FUN_a01e6834();
  matched_FUN_a01a6030();
  matched_FUN_a01ace50();
  matched_FUN_a01bcb08(iVar3);
  iVar4 = matched_FUN_a02980e0();
  if (iVar4 != 5) {
    matched_FUN_a023cecc(DAT_a13a23e4,1);
    DAT_a1055cee = DAT_a1055cee & 0xfd;
    matched_FUN_a0246e78(DAT_a13a23e4);
    iVar4 = matched_FUN_a02980e0();
    if (iVar4 == 6) {
      uVar5 = 0x1a;
    }
    else {
      uVar5 = 0xe;
    }
    matched_FUN_a0297920(uVar5);
    matched_FUN_a01e6acc(2,&LAB_a01bde60);
    FUN_a02a70ec(s_Hibernation_creatting__disable_b_a05716f4);
  }
  matched_FUN_a0298008();
  matched_FUN_a0298020();
  iVar4 = matched_FUN_a02c1148(0x18,2,&DAT_a1265b30);
  if (iVar4 == 0) {
    matched_FUN_a02c11b0(0x18,&LAB_a01bd584);
  }
  if (iVar3 == 5) {
    iVar4 = 1;
  }
  else {
    iVar4 = 2;
  }
  FUN_a02a70ec(s__FW_HANDLER_______>_Step__d__a0571724);
LAB_a01bd704:
  do {
    while( true ) {
      while( true ) {
        while( true ) {
          do {
            iVar6 = matched_FUN_a03bc56c(uVar2,&local_38,0xffffffff);
            uVar1 = local_30;
            uVar11 = local_34;
            uVar7 = local_38;
          } while (iVar6 != 0);
          if (local_38 == 0xe8030101) goto LAB_a01bd9cc;
          if (0xe8030101 < local_38) break;
          if (local_38 < 0x9802000a) {
            if (local_38 < 0x98020000) {
              if (local_38 == 0x38010002) {
                FUN_a02a70ec(s__HMSG_STORAGE_IDLE___d__d_a05718e4,local_34,local_30);
                if (iVar4 == 2) {
                  FUN_a02a70ec(s_fw_update_stage_2__do_nothing_HM_a0571900);
                }
                else if (uVar1 == 1) {
                  FUN_a02a70ec(s__HMSG_STORAGE_IDLE__on_message_a0571934);
                }
                else {
                  iVar6 = matched_FUN_a02231e0();
                  if (iVar6 == 0) {
                    uVar7 = matched_FUN_a0222de8(uVar11 & 0xff);
                    FUN_a02a70ec(s__HMSG_STORAGE_IDLE__chk_insertin_a0571954,uVar7,DAT_a1055cf0);
                    uVar11 = (uint)DAT_a1055cf0;
                    if (uVar11 == uVar7) {
                      DAT_a1055cf0 = 0xff;
                      matched_FUN_a02231b8(0xff);
                      matched_FUN_a0223744(uVar11,0);
                      iVar6 = matched_FUN_a02237cc();
                      uVar5 = matched_FUN_a0223274();
                      FUN_a02a70ec(s__HMSG_STORAGE_IDLE__ReturnValue__a05719a0,iVar6,uVar5);
                      if ((iVar6 < 0) || (iVar8 = matched_FUN_a0223274(), iVar8 <= iVar6)) {
                        uVar7 = matched_FUN_a022328c();
                        if ((uVar11 == uVar7) &&
                           (FUN_a02a70ec(s__HMSG_STORAGE_IDLE___PrimarySlot_a05719d4,uVar11),
                           uVar11 == 2)) {
                          DAT_a1055e79 = 0;
                          DAT_a1055d08 = DAT_a1055d08 & 0xfb;
                          DAT_a1055e7b = 1;
                          FUN_a0299a6c(matched_FUN_a01bd55c);
                        }
                      }
                      else {
                        matched_FUN_a0223854(iVar6);
                      }
                    }
                    else {
                      FUN_a02a70ec(s__App___Handler__<Entry>_The_stor_a05719f8,uVar7,uVar11);
                      DAT_a1055cf0 = 0xff;
                    }
                  }
                  else {
                    FUN_a02a70ec(s__HMSG_STORAGE_IDLE__wait_card_in_a0571a5c);
                    matched_thunk_FUN_a01e656c(0x38010002,uVar11,0);
                  }
                }
              }
              else if (local_38 < 0x38010003) {
                if (local_38 == 0x38010001) {
                  DAT_a1055cf0 = matched_FUN_a0222de8(local_34 & 0xff);
                  matched_FUN_a0223744(DAT_a1055cf0,1);
                }
              }
              else if (local_38 == 0x58000001) {
                matched_FUN_a0482ef4(0x2b);
                matched_FUN_a0225424(0);
                matched_analyst_task_sleep();
              }
              else if (local_38 == 0x98018003) {
                if (iVar4 == 2 && local_30 == 2) {
                  FUN_a02a70ec(s_fw_update_stage_2__do_nothing_AS_a05717e0);
                }
                else {
                  if (((uint)(local_30 == 2) & local_34 >> 0x1f) != 0) {
                    matched_thunk_FUN_a01e656c(0xf0010340,0x10c,0);
                  }
                  FUN_a02a70ec(s_ASYNC_MGR_MSG_CARD_INSERT_DONE<__a0571820,uVar11,uVar1);
                }
              }
            }
            else {
              matched_FUN_a01e6bdc(local_34);
            }
          }
          else if (local_38 == 0xe001001e) {
            FUN_a02a70ec(s_HMSG_USER_F0_BUTTON_>>_sigle_cli_a0571af0);
          }
          else if (local_38 < 0xe001001f) {
            if (local_38 == 0xe001000a) {
              FUN_a02a70ec(s_HMSG_USER_POWER_BUTTON_>>_pwoero_a0571b7c);
            }
          }
          else {
            if (local_38 == 0xe8030001) goto LAB_a01bd9cc;
            if (local_38 == 0xe8030002) goto LAB_a01bd948;
          }
        }
        if (local_38 == 0xe8030302) goto LAB_a01bd948;
        if (local_38 < 0xe8030303) break;
        if (local_38 == 0xf001031f) {
          if (local_34 != 0xff) {
            matched_FUN_a0225364();
            matched_FUN_a018654c(0,uVar11);
            matched_FUN_a0225384(0);
            matched_FUN_a0186500(uVar11);
          }
        }
        else if (local_38 < 0xf0010320) {
          if (local_38 == 0xf0010001) {
            FUN_a02a70ec(s__App___Handler__<Entry>_Exit_han_a0571abc);
            matched_FUN_a01bd0ec();
            return;
          }
          if (local_38 == 0xf0010002) {
            FUN_a02a70ec(s__s_App___Handler__<Entry>_HMSG_S_a0571a88,DAT_a06f308c);
            matched_FUN_a01e5d44();
          }
        }
        else if (local_38 == 0xf0010332) {
          FUN_a02a70ec(s_HMSG_USER_POWER_BUTTON_LONG_PRES_a0571b14);
          if (iVar4 == 1 && DAT_a1445c14 == 0) {
            FUN_a02a70ec(s_Clear_AmbaNVM_EraseBldMagicCode_a0571b38);
            FUN_a02a70ec(s_Clear_FwUpdaterUtil_ClearBootTim_a0571b58);
            matched_FUN_a0298008();
            matched_FUN_a0298020();
            matched_FUN_a048743c();
            matched_analyst_task_sleep(1000);
            matched_FUN_a049a3cc();
            matched_FUN_a049a440();
          }
        }
        else if (local_38 == 0xf0010340) {
          matched_FUN_a01bd0f4(local_34,(local_30 & 0xffff) >> 8,local_30 & 0xff,iVar3);
        }
      }
      if (local_38 == 0xe8030201) break;
      if (local_38 < 0xe8030202) goto LAB_a01bdc18;
      if (local_38 == 0xe8030202) goto LAB_a01bd948;
      if (local_38 == 0xe8030301) break;
    }
LAB_a01bd9cc:
    if (local_38 == 0xe8030001) {
      pcVar10 = s_HMSG_NAND0_CARD_INSERT_a0561a80;
    }
    else if (local_38 == 0xe8030101) {
      pcVar10 = s_HMSG_NAND1_CARD_INSERT_a0561a98;
    }
    else if (local_38 == 0xe8030201) {
      pcVar10 = s_HMSG_SD0_CARD_INSERT_a0561ab0;
    }
    else if (local_38 == 0xe8030301) {
      pcVar10 = s__I__REC_CONNECTED_CAM___06d___s__a0533e80 + 0x38;
    }
    else {
      pcVar10 = (char *)0x0;
    }
    FUN_a02a70ec(s___s___d__d_a0571744,pcVar10,local_34);
    if ((iVar4 == 2) && (local_38 == 0xe8030201)) {
      FUN_a02a70ec(s_fw_update_stage_2__do_nothing__s_a0571750,pcVar10);
      goto LAB_a01bd704;
    }
    bVar9 = DAT_a1055cdf & 0x80;
  } while ((DAT_a1055cdf & 0x80) != 0);
  uVar5 = matched_FUN_a0222d84(uVar11);
  iVar6 = matched_FUN_a0223250();
  if ((iVar6 == -1) || (uVar7 = matched_FUN_a0223250(), uVar7 < uVar11)) {
    if (DAT_a1055cf0 == 0xff) {
      FUN_a02a70ec(s___s_no_active_slot_or_no_busy_sl_a0571790,pcVar10);
      matched_FUN_a01e5978(uVar11);
      goto LAB_a01bd704;
    }
  }
  else if (DAT_a1055cf0 == 0xff) {
    FUN_a02a70ec(s___s_remove_block___card_insert_a05717c0,pcVar10);
    matched_FUN_a0223788(uVar5,bVar9);
    matched_FUN_a01e5978(uVar11);
    goto LAB_a01bd704;
  }
  FUN_a02a70ec(s___s_app_busy_or_slot_busy_a0571774,pcVar10);
  matched_FUN_a0223788(uVar5,1);
  goto LAB_a01bd704;
LAB_a01bdc18:
  if (local_38 == 0xe8030102) {
LAB_a01bd948:
    FUN_a02a70ec(s_HMSG_SD0_CARD_REMOVE_a0571848);
    if ((iVar4 == 2) && (local_38 == 0xe8030202)) {
      FUN_a02a70ec(s_fw_update_stage_2__do_nothing_HM_a0571860);
    }
    else if ((DAT_a1055cdf & 0x80) == 0) {
      iVar6 = matched_FUN_a02230dc(uVar11);
      if (DAT_a1055cf0 == uVar11) {
        FUN_a02a70ec(s__App___Handler__<Entry>_Remove_s_a0571894);
        DAT_a1055cf0 = 0xff;
        iVar6 = matched_FUN_a02237cc();
        if ((-1 < iVar6) && (iVar8 = matched_FUN_a0223274(), iVar6 < iVar8)) {
          matched_FUN_a0223854(iVar6);
        }
      }
      else if (iVar6 == 0) {
        iVar6 = matched_FUN_a022328c();
        if (DAT_a1055cf0 == 0xff) {
          if (iVar6 != -1) {
            uVar5 = matched_FUN_a0222d84();
            matched_FUN_a0223788(uVar5,0);
            matched_FUN_a01e5978(iVar6);
          }
          local_38 = 0xf0010201;
        }
        else {
          if (iVar6 != -1) {
            uVar5 = matched_FUN_a0222d84();
            matched_FUN_a0223788(uVar5,1);
          }
          local_38 = 0xf0010101;
        }
      }
      if (iVar4 == 1 && uVar7 == 0xe8030202) {
        matched_FUN_a0299ab8();
      }
    }
  }
  goto LAB_a01bd704;
}

