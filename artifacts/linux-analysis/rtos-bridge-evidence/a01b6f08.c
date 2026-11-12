/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa01b6f08, name: FUN_a01b6f08.
 * Types and names may be inferred. Runtime validation not performed. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_a01b6f08(void)

{
  undefined4 *puVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  int iVar5;
  uint uVar6;
  int iVar7;
  undefined4 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 *puVar11;
  undefined4 *puVar12;
  undefined4 *puVar13;
  undefined4 *puVar14;
  bool bVar15;
  undefined4 local_98;
  undefined4 local_94;
  undefined4 local_90;
  undefined4 local_8c;
  undefined4 local_88;
  undefined4 local_84;
  int local_80 [2];
  int local_78;
  uint local_74;
  uint local_70;
  int local_6c;
  undefined1 auStack_68 [68];
  
  local_8c = 0;
  local_88 = 0;
  local_84 = 0;
  FUN_a04f8dec(local_80,0,0x58);
  iVar4 = FUN_a0479708(s__usr_local_share_script_xcserver_a056f560);
  if (iVar4 != 0) {
    FUN_a02a70ec(s__CC__ERROR__s<_s>_Start_linux_da_a056f588,DAT_a06f3080,
                 s_CCServer_RunLoop_a056fb28);
  }
  _DAT_a1264c20 = FUN_a048e63c();
LAB_a01b6fdc:
  if (_DAT_a12650d0 == 1) goto LAB_a01b7078;
LAB_a01b6fe8:
  iVar4 = FUN_a03bc56c(0xa1264c24,&local_8c,100);
  if (iVar4 == 0) {
    FUN_a01b6bb4(local_8c,local_88,local_84);
  }
  do {
    iVar5 = FUN_a01b5de8(local_80,0x58,1,0);
    uVar3 = local_70;
    iVar2 = local_78;
    iVar7 = local_80[0];
    bVar15 = iVar5 == 0x58;
    iVar4 = iVar5 + -0x58;
    if (!bVar15) {
      iVar4 = iVar5;
    }
    if ((!bVar15 && iVar5 != 0) && iVar4 < 0 == (bVar15 && SBORROW4(iVar5,0x58))) {
      FUN_a02a70ec(s__CC__ERROR__s<_s>_pre_read_IPC_m_a056f5b8,DAT_a06f3080,
                   s_CCServer_RunLoop_a056fb28,iVar5);
      goto LAB_a01b6fdc;
    }
    if (iVar5 < 1) goto LAB_a01b6fdc;
    if (local_74 == 0) {
      uVar6 = FUN_a01b5d4c();
      if ((uVar3 + 1) * 0x58 <= uVar6) {
        uVar6 = 0;
        iVar4 = 0;
        do {
          iVar5 = FUN_a01b5de8(local_80,0x58,1,1);
          if (iVar5 == 0x58) {
            if ((((local_74 == uVar6) && (local_78 == iVar2)) && (local_70 == uVar3)) &&
               (local_80[0] == iVar7)) {
              puVar1 = _DAT_a126523c;
              if (local_6c != 0) {
                FUN_a029c680((int)_DAT_a126523c + iVar4,auStack_68);
                iVar4 = iVar4 + local_6c;
                puVar1 = _DAT_a126523c;
              }
            }
            else {
              FUN_a02a70ec(s__CC__ERROR__s<_s>_read_IPC_messa_a056f678,DAT_a06f3080,
                           s_CCServer_RunLoop_a056fb28,local_80[0],local_74,local_70,iVar7,0,uVar3);
              puVar1 = _DAT_a126523c;
            }
          }
          else {
            FUN_a02a70ec(s__CC__ERROR__s<_s>_read_IPC_messa_a056f640,DAT_a06f3080,
                         s_CCServer_RunLoop_a056fb28,iVar5);
            puVar1 = _DAT_a126523c;
          }
          uVar6 = uVar6 + 1;
          _DAT_a126523c = puVar1;
        } while (uVar6 <= uVar3);
        if (iVar4 == 0) {
          switch(iVar7) {
          case -0x777a0000:
            goto switchD_a01b718c_caseD_88860000;
          default:
            goto switchD_a01b718c_caseD_88860001;
          case -0x7779fffe:
            goto switchD_a01b7440_caseD_88860002;
          case -0x7779fffd:
            goto switchD_a01b7440_caseD_88860003;
          case -0x7779fffc:
            goto switchD_a01b718c_caseD_88860004;
          case -0x7779fffb:
            goto switchD_a01b7440_caseD_88860005;
          case -0x7779fffa:
            goto switchD_a01b718c_caseD_88860006;
          }
        }
        local_98 = 0;
        local_94 = 0;
        local_90 = 0;
        switch(iVar7) {
        case -0x777a0000:
switchD_a01b718c_caseD_88860000:
          local_90 = 0;
          _DAT_a1264c1c = 1;
          local_98 = local_90;
          local_94 = local_90;
          FUN_a02a70ec(s__CC__DEBUG__s<_s>_IPC_linux_daem_a056f6d0,DAT_a06f3084,
                       s_CCServer_OnIPCMessage_a056fb98);
          break;
        default:
switchD_a01b718c_caseD_88860001:
          local_90 = 0;
          local_98 = local_90;
          local_94 = local_90;
          FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_unkno_a056f970,DAT_a06f3080,
                       s_CCServer_OnIPCMessage_a056fb98,iVar7);
          break;
        case -0x7779fffe:
          if (iVar4 == 0x24) {
            puVar11 = puVar1;
            puVar13 = (undefined4 *)&DAT_a1265248;
            do {
              puVar12 = puVar11 + 4;
              uVar8 = puVar11[1];
              uVar9 = puVar11[2];
              puVar14 = puVar13 + 4;
              uVar10 = puVar11[3];
              *puVar13 = *puVar11;
              puVar13[1] = uVar8;
              puVar13[2] = uVar9;
              puVar13[3] = uVar10;
              puVar11 = puVar12;
              puVar13 = puVar14;
            } while (puVar12 != puVar1 + 8);
            *puVar14 = *puVar12;
            if (_DAT_a1265268 == 0) {
              FUN_a01b64d0(1);
              FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_conne_a056f6fc,DAT_a06f3080,
                           s_CCServer_OnIPCMessage_a056fb98,&DAT_a1265248);
            }
            else {
              FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_conne_a056f738,DAT_a06f3080,
                           s_CCServer_OnIPCMessage_a056fb98);
            }
            _DAT_a12650d0 = 0;
          }
          else {
switchD_a01b7440_caseD_88860002:
            local_90 = 0;
            local_98 = local_90;
            local_94 = local_90;
            FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_conne_a056f770,DAT_a06f3080,
                         s_CCServer_OnIPCMessage_a056fb98,iVar4);
          }
          break;
        case -0x7779fffd:
          if (puVar1 == (undefined4 *)0x0) {
switchD_a01b7440_caseD_88860003:
            local_90 = 0;
            local_98 = local_90;
            local_94 = local_90;
            FUN_a02a70ec(s__CC__ERROR__s<_s>_IPC_WiFi_disco_a056f7b4,DAT_a06f3080,
                         s_CCServer_OnIPCMessage_a056fb98);
          }
          else if (iVar4 == 0xc) {
            local_98 = *puVar1;
            _DAT_a12650d0 = 0;
            FUN_a01b64d0(0);
            local_94 = puVar1[1];
            local_90 = puVar1[2];
            thunk_FUN_a01e656c(0xd809001a,local_94,local_90,&local_8c);
            FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_disco_a056f82c,DAT_a06f3080,
                         s_CCServer_OnIPCMessage_a056fb98,local_98);
          }
          else {
            FUN_a02a70ec(s__CC__ERROR__s<_s>_IPC_WiFi_disco_a056f7ec,DAT_a06f3080,
                         s_CCServer_OnIPCMessage_a056fb98,iVar4);
          }
          break;
        case -0x7779fffc:
switchD_a01b718c_caseD_88860004:
          local_90 = 0;
          local_98 = local_90;
          local_94 = local_90;
          FUN_a01b64d0(0);
          thunk_FUN_a01e656c(0xd8090016,0x6000a,0);
          FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_lose_c_a056f864,DAT_a06f3080,
                       s_CCServer_OnIPCMessage_a056fb98);
          break;
        case -0x7779fffb:
          if (puVar1 == (undefined4 *)0x0) {
switchD_a01b7440_caseD_88860005:
            local_90 = 0;
            local_98 = local_90;
            local_94 = local_90;
            FUN_a02a70ec(s__CC__ERROR__s<_s>_IPC_car_comman_a056f8a0,DAT_a06f3080,
                         s_CCServer_OnIPCMessage_a056fb98);
          }
          else if (iVar4 == 0) {
            FUN_a02a70ec(s__CC__ERROR__s<_s>_IPC_car_comman_a056f8d4,DAT_a06f3080,
                         s_CCServer_OnIPCMessage_a056fb98,0);
          }
          else {
            iVar7 = FUN_a0196738(s_msg_id_a0536194,&local_98,puVar1);
            if (iVar7 == 0) {
              DAT_a06ce134 = local_98;
              _DAT_a1265070 = iVar4;
              FUN_a04f93c4(0xa1264c70,0x400,puVar1);
              FUN_a0242a28(&DAT_a1265118,0xa1264c70);
            }
            else {
              FUN_a02a70ec(s__CC__ERROR__s<_s>_IPC_car_comman_a056f908,DAT_a06f3080,
                           s_CCServer_OnIPCMessage_a056fb98,puVar1);
            }
          }
          break;
        case -0x7779fffa:
switchD_a01b718c_caseD_88860006:
          local_90 = 0;
          _DAT_a12650d0 = 0;
          _DAT_a1264c1c = 0;
          _DAT_a1265128 = 0;
          _DAT_a126508c = 0;
          DAT_a06ce134 = 0xffffffff;
          local_98 = local_90;
          local_94 = local_90;
          FUN_a01b64d0(0);
          puVar1 = DAT_a01b75b4;
          _DAT_a1265248 = 0;
          *DAT_a01b75b4 = 0;
          puVar1[1] = 0;
          puVar1[2] = 0;
          puVar1[3] = 0;
          puVar1[4] = 0;
          puVar1[5] = 0;
          puVar1[6] = 0;
          puVar1[7] = 0;
          FUN_a04f8dec(0xa1264c70,0,0x418);
          FUN_a01b63c8(0);
          FUN_a01b644c(0);
          FUN_a02a70ec(s__CC__ERROR__s<_s>_CCServer_Linux_a056f93c,DAT_a06f3080,
                       s_CCServer_OnIPCMessage_a056fb98);
        }
      }
      goto LAB_a01b6fdc;
    }
    FUN_a02a70ec(s__CC__ERROR__s<_s>_pre_read_IPC_m_a056f5f4,DAT_a06f3080,
                 s_CCServer_RunLoop_a056fb28,local_80[0],local_74,local_70);
    if (_DAT_a12650d0 != 1) goto LAB_a01b6fe8;
LAB_a01b7078:
    thunk_FUN_a03c0b20(100);
  } while( true );
}

