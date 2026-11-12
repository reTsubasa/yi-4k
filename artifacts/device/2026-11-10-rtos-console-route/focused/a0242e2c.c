/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void console_audit_a0242e2c(void)

{
  bool bVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int iVar4;
  undefined4 uVar5;
  undefined4 local_60;
  undefined4 local_5c;
  undefined4 local_58;
  undefined4 local_54;
  undefined4 local_50;
  undefined4 local_4c;
  undefined4 local_48;
  uint local_44;
  undefined4 local_40;
  undefined4 local_3c;
  undefined4 local_38;
  undefined4 local_34;
  undefined4 local_30;
  undefined4 local_2c;
  
  local_48 = 0;
  local_44 = 0;
  local_40 = 0;
  local_3c = 0;
  local_38 = 0;
  local_34 = 0;
  local_30 = 0;
  local_2c = 0;
  local_60 = 0;
  local_5c = 0;
  local_58 = 0;
  local_54 = 0;
  local_50 = 0;
  local_4c = 0;
  do {
    iVar4 = matched_FUN_a03bc56c(DAT_a024374c,&local_48,1000);
    uVar3 = local_3c;
    uVar2 = local_40;
    uVar5 = local_48;
    if (iVar4 == 0) {
      if (local_44 == 0x403) {
        matched_FUN_a023f090(&local_48);
      }
      else if (local_44 < 0x404) {
        if (local_44 == 0x101) {
          local_58 = local_40;
          local_54 = local_38;
          local_50 = local_30;
          local_4c = local_2c;
          matched_FUN_a03bc46c(DAT_a0243750,0xffffffff);
          DAT_a143b4c4 = uVar5;
          DAT_a143b4c8 = &DAT_a143b478;
          DAT_a143b478 = local_58;
          DAT_a143b47c = local_54;
          DAT_a143b480 = local_50;
          DAT_a143b484 = local_4c;
          matched_thunk_FUN_a03c3c5c(DAT_a0243750);
          local_5c = uVar2;
          local_60 = local_48;
          matched_FUN_a0199988(0);
          uVar5 = 0xd8010000;
        }
        else {
          if (local_44 < 0x102) {
            if (local_44 == 5) {
              iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
              bVar1 = iVar4 == 0;
              uVar5 = 0xd8000005;
            }
            else if (local_44 < 6) {
              if (local_44 == 2) {
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                uVar5 = 0xd8000001;
                bVar1 = iVar4 == 0;
              }
              else if (local_44 < 3) {
                if (local_44 != 1) goto joined_r0xa0243190;
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                uVar5 = 0xd8000000;
                bVar1 = iVar4 == 0;
              }
              else {
                if (local_44 == 3) {
                  uVar5 = 0xd8000002;
                  goto LAB_a0242fa8;
                }
                if (local_44 != 4) goto joined_r0xa0243190;
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd8000004;
              }
            }
            else if (local_44 == 9) {
              iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
              uVar5 = 0xd8000003;
              bVar1 = iVar4 == 0;
            }
            else {
              if (9 < local_44) {
                if (local_44 == 0xb) {
                  uVar5 = 0xd800000b;
                }
                else {
                  if (local_44 != 0xd) goto joined_r0xa0243190;
                  uVar5 = 0xd8090002;
                }
                goto LAB_a0242fa8;
              }
              if (local_44 == 6) {
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd8000006;
              }
              else {
                if (local_44 != 8) goto joined_r0xa0243190;
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd8000008;
              }
            }
            goto LAB_a0242ee4;
          }
          if (local_44 == 0x202) {
            uVar5 = 0xd8020001;
          }
          else if (local_44 < 0x203) {
            if (local_44 == 0x104) {
              uVar5 = 0xd8010003;
            }
            else if (local_44 < 0x105) {
              if (local_44 == 0x102) {
                FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5528,0x9a5,
                             s_AppLibNetControl_MgrTask_a05a27f0);
                matched_FUN_a023d2e0();
                matched_FUN_a03bc46c(DAT_a0243750,0xffffffff);
                DAT_a143b4c4 = 0;
                matched_thunk_FUN_a03c3c5c(DAT_a0243750);
                matched_FUN_a0199988(0);
                uVar5 = 0xd8010001;
              }
              else {
                if (local_44 != 0x103) goto joined_r0xa0243190;
                uVar5 = 0xd8010002;
              }
            }
            else {
              if (local_44 == 0x105) {
                matched_FUN_a0240f74(&local_48);
                goto LAB_a0242eec;
              }
              if (local_44 != 0x201) goto joined_r0xa0243190;
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a555c,0x9b2,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              uVar5 = 0xd8020000;
            }
          }
          else if (local_44 == 0x302) {
            FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5898,0xa18,
                         s_AppLibNetControl_MgrTask_a05a27f0);
            uVar5 = 0xd8030001;
          }
          else {
            if (local_44 < 0x303) {
              if (local_44 == 0x203) {
                uVar5 = 0xd8020002;
                goto LAB_a0242fa8;
              }
              if (local_44 != 0x301) goto joined_r0xa0243190;
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5590,0x9d6,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
              bVar1 = iVar4 == 0;
              uVar5 = 0xd8030000;
            }
            else if (local_44 == 0x401) {
              iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
              bVar1 = iVar4 == 0;
              uVar5 = 0xd8060000;
            }
            else {
              if (local_44 != 0x402) goto joined_r0xa0243190;
              iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
              bVar1 = iVar4 == 0;
              uVar5 = 0xd8060001;
            }
LAB_a0242ee4:
            if (!bVar1) goto LAB_a0242eec;
          }
        }
LAB_a0242fa8:
        matched_thunk_FUN_a01e656c(uVar5,local_60,local_5c);
      }
      else {
        if (local_44 == 0x1000003) {
          iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
          bVar1 = iVar4 == 0;
          FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5848,0xa0f,
                       s_AppLibNetControl_MgrTask_a05a27f0,bVar1);
          uVar5 = 0xd809000d;
          goto LAB_a0242ee4;
        }
        if (0x1000003 < local_44) {
          if (local_44 == 0x100000e) {
            FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a577c,0xa00,
                         s_AppLibNetControl_MgrTask_a05a27f0);
            uVar5 = 0xd8090006;
          }
          else if (local_44 < 0x100000f) {
            if (local_44 == 0x100000b) {
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a55c4,0x9dc,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
              bVar1 = iVar4 == 0;
              uVar5 = 0xd8090001;
              goto LAB_a0242ee4;
            }
            if (local_44 < 0x100000c) {
              if (local_44 == 0x1000004) {
                FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5638,0x9e8,
                             s_AppLibNetControl_MgrTask_a05a27f0);
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd809000a;
                goto LAB_a0242ee4;
              }
              if (local_44 != 0x1000008) goto joined_r0xa0243190;
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5700,0x9f8,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              uVar5 = 0xd809000b;
            }
            else {
              if (local_44 == 0x100000c) {
                FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a56c0,0x9f2,
                             s_AppLibNetControl_MgrTask_a05a27f0);
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd8090003;
                goto LAB_a0242ee4;
              }
              if (local_44 != 0x100000d) goto joined_r0xa0243190;
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a573c,0x9fc,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              uVar5 = 0xd8090005;
            }
          }
          else if (local_44 == 0x100001b) {
            FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a57fc,0xa08,
                         s_AppLibNetControl_MgrTask_a05a27f0);
            uVar5 = 0xd809000c;
          }
          else {
            if (0x100001b < local_44) {
              if (local_44 == 0x100001e) {
                FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a55f8,0x9e2,
                             s_AppLibNetControl_MgrTask_a05a27f0);
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd8090011;
              }
              else {
                if (local_44 != 0x100001f) goto joined_r0xa0243190;
                FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5924,0xa60,
                             s_AppLibNetControl_MgrTask_a05a27f0);
                iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
                bVar1 = iVar4 == 0;
                uVar5 = 0xd8090017;
              }
              goto LAB_a0242ee4;
            }
            if (local_44 == 0x1000016) {
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a5674,0x9ee,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              uVar5 = 0xd8090009;
            }
            else {
              if (local_44 != 0x1000019) goto joined_r0xa0243190;
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a57bc,0xa04,
                           s_AppLibNetControl_MgrTask_a05a27f0);
              uVar5 = 0xd8090007;
            }
          }
          goto LAB_a0242fa8;
        }
        if (local_44 == 0x507) {
          matched_FUN_a0241cfc(&local_48);
        }
        else if (local_44 < 0x508) {
          if (local_44 < 0x505) {
            if (0x501 < local_44) goto LAB_a02433f0;
            if (local_44 == 0x501) {
              iVar4 = matched_FUN_a023f2a4(&local_48);
              bVar1 = iVar4 == 0;
              FUN_a02a70ec(s__I__APPLIBNET_CONTROL___06d___s__a05a58d4,0xa32,
                           s_AppLibNetControl_MgrTask_a05a27f0,iVar4,bVar1);
              uVar5 = 0xd8060002;
              goto LAB_a0242ee4;
            }
            goto joined_r0xa0243190;
          }
          if (local_44 == 0x505) {
            matched_FUN_a024123c(&local_48);
          }
          else {
            if (local_44 != 0x506) goto joined_r0xa0243190;
            matched_FUN_a024170c(&local_48);
          }
        }
        else if (local_44 == 0x701) {
          matched_FUN_a0242a6c(&local_48);
        }
        else {
          if (local_44 < 0x702) {
            if (local_44 - 0x601 < 6) goto LAB_a02433f0;
          }
          else {
            if (local_44 == 0x801) {
LAB_a02433f0:
              matched_FUN_a023ff7c(&local_48);
              goto LAB_a0242eec;
            }
            if (local_44 == 0x802) {
              uVar5 = 0xd8090019;
              goto LAB_a0242fa8;
            }
          }
joined_r0xa0243190:
          if (0xfffffff < local_44) {
            iVar4 = matched_FUN_a023f47c(&local_48,&local_60,&local_5c);
            bVar1 = iVar4 == 0;
            uVar5 = 0xd8090000;
            goto LAB_a0242ee4;
          }
          FUN_a02a70ec(s__s_AppLib___NetControl__<MgrTask_a05a5960,DAT_a06f3080);
          matched_FUN_a03bc46c(DAT_a0243750,0xffffffff);
          DAT_a143b4c8 = &DAT_a143b478;
          local_58 = DAT_a143b478;
          local_54 = DAT_a143b47c;
          local_50 = DAT_a143b480;
          local_4c = DAT_a143b484;
          matched_thunk_FUN_a03c3c5c(DAT_a0243750);
          matched_FUN_a023ef80(local_44,uVar3,&local_58,0xffffffe9);
        }
      }
    }
LAB_a0242eec:
    matched_FUN_a0242d04();
  } while( true );
}

