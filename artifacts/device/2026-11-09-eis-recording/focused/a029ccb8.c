/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_a029ccb8(int param_1)

{
  char cVar1;
  uint uVar2;
  uint uVar3;
  char *pcVar4;
  int iVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  undefined4 *puVar11;
  int iVar12;
  uint uVar13;
  int iVar14;
  int local_2a8;
  int local_2a0;
  undefined4 local_298;
  undefined2 local_294;
  undefined1 local_292;
  char local_291 [4];
  char local_28d [2];
  undefined1 local_28b;
  undefined2 local_28a;
  undefined1 local_288;
  undefined1 local_287;
  undefined1 local_286;
  undefined1 local_285;
  undefined1 local_284;
  undefined4 local_283;
  undefined2 local_27f;
  undefined1 local_27d;
  undefined4 local_27c;
  undefined2 local_278;
  undefined1 local_276;
  undefined4 local_275;
  undefined1 local_271;
  undefined1 local_270;
  undefined1 local_26f;
  undefined4 local_26e;
  undefined1 local_26a;
  undefined1 local_269;
  undefined1 local_268;
  char local_260 [4];
  undefined2 uStack_25c;
  undefined1 local_25a;
  undefined4 local_259;
  undefined1 local_255;
  undefined1 local_254;
  undefined1 local_253;
  undefined4 local_252;
  undefined1 local_24e;
  undefined1 local_24d;
  undefined1 local_24c;
  char local_244 [4];
  undefined2 uStack_240;
  undefined1 local_23e;
  undefined4 local_23d;
  undefined1 local_239;
  undefined1 local_238;
  undefined1 local_237;
  undefined4 local_236;
  undefined1 local_232;
  undefined1 local_231;
  undefined1 local_230;
  undefined1 auStack_228 [256];
  undefined1 auStack_128 [260];
  
  matched_FUN_a04f8dec(auStack_228,0,0x100);
  matched_FUN_a04f8dec(auStack_128,0,0x100);
  if (param_1 == 0) {
    return -1;
  }
  matched_FUN_a04f8dec(&local_298,0,0x70);
  local_298 = 0x206669;
  local_291[0] = s_then_a05ae3b0[0];
  local_291[1] = s_then_a05ae3b0[1];
  local_291[2] = s_then_a05ae3b0[2];
  local_291[3] = s_then_a05ae3b0[3];
  puVar11 = &local_298;
  local_283 = DAT_a05ae3c0;
  local_27c = DAT_a05ae3c8;
  local_27f = DAT_a05ae3c4;
  local_278 = (undefined2)DAT_a05ae3cc;
  iVar12 = 0;
  local_275 = DAT_a05ae3d0;
  local_288 = DAT_a05ae3ba;
  local_28a = DAT_a05ae3b8;
  local_28d[0] = s_then_a05ae3b0[4];
  local_28d[1] = s_then_a05ae3b0[5];
  iVar9 = 0;
  local_26e = DAT_a05ae3d8;
  iVar6 = 0;
  local_294 = 0;
  local_292 = 0;
  local_2a0 = 0;
  local_28b = 0;
  local_287 = 0;
  local_286 = 0;
  local_285 = 0;
  local_284 = 0;
  local_27d = 0;
  local_276 = 0;
  local_271 = 0;
  local_270 = 0;
  local_26f = 0;
  local_269 = 0;
  local_260[0] = s_until_a05ae460[0];
  local_260[1] = s_until_a05ae460[1];
  local_260[2] = s_until_a05ae460[2];
  local_260[3] = s_until_a05ae460[3];
  uStack_25c = (undefined2)ram0xa05ae464;
  local_26a = DAT_a05ae3dc;
  local_259 = DAT_a05ae3d0;
  local_24e = DAT_a05ae3dc;
  local_232 = DAT_a05ae3dc;
  iVar14 = 0;
  local_252 = DAT_a05ae3d8;
  iVar8 = 0;
  local_25a = (undefined1)((uint)ram0xa05ae464 >> 0x10);
  uVar13 = 0;
  local_268 = 0;
  local_244[0] = s_while_a05ae468[0];
  local_244[1] = s_while_a05ae468[1];
  local_244[2] = s_while_a05ae468[2];
  local_244[3] = s_while_a05ae468[3];
  local_255 = 0;
  local_254 = 0;
  local_23d = DAT_a05ae3d0;
  local_24d = 0;
  local_24c = 0;
  local_236 = DAT_a05ae3d8;
  uStack_240 = (undefined2)ram0xa05ae46c;
  local_239 = 0;
  local_238 = 0;
  local_231 = 0;
  local_253 = 0;
  local_237 = 0;
  local_23e = (undefined1)((uint)ram0xa05ae46c >> 0x10);
  local_2a8 = 0;
  local_230 = 0;
  do {
    uVar2 = matched_FUN_a04f9ea4(param_1,puVar11);
    if (uVar2 != 0) {
      uVar13 = matched_FUN_a04f9ea4(param_1,(int)puVar11 + 7);
      uVar3 = matched_FUN_a04f9ea4(param_1,(int)puVar11 + 0xe);
      if (uVar3 <= uVar2 || (uVar3 <= uVar13 || (uVar13 <= uVar2 || (uVar3 == 0 || uVar13 == 0))))
      goto LAB_a029d2f0;
      iVar10 = uVar13 - param_1;
      iVar14 = matched_FUN_a04f99f0(puVar11);
      iVar6 = iVar10 + -1;
      iVar14 = iVar14 + (uVar2 - param_1);
      if (iVar6 < iVar14) goto LAB_a029d2f0;
      if (*(char *)(param_1 + iVar6) == ';') {
        iVar8 = 1;
      }
      else {
        if (*(char *)(param_1 + iVar6) != ' ') goto LAB_a029d2f0;
        pcVar4 = (char *)(param_1 + iVar6);
        iVar9 = 0;
        while( true ) {
          iVar6 = iVar6 + -1;
          iVar8 = iVar9 + 1;
          if (iVar6 < iVar14) break;
          pcVar4 = pcVar4 + -1;
          if (*pcVar4 == ';') {
            iVar8 = iVar9 + 2;
            break;
          }
          iVar9 = iVar8;
          if (*pcVar4 != ' ') goto LAB_a029d2f0;
        }
        if (iVar8 == 0) goto LAB_a029d2f0;
      }
      iVar9 = matched_FUN_a04f99f0((int)puVar11 + 7);
      iVar8 = iVar10 - iVar8;
      iVar9 = iVar9 + iVar10;
      iVar6 = (uVar3 - param_1) + -1;
      if (iVar6 < iVar9) goto LAB_a029d2f0;
      if (*(char *)(param_1 + iVar6) == ';') {
        iVar10 = 1;
      }
      else {
        if (*(char *)(param_1 + iVar6) != ' ') goto LAB_a029d2f0;
        pcVar4 = (char *)(param_1 + iVar6);
        iVar5 = 0;
        while( true ) {
          iVar6 = iVar6 + -1;
          iVar10 = iVar5 + 1;
          if (iVar6 < iVar9) break;
          pcVar4 = pcVar4 + -1;
          if (*pcVar4 == ';') {
            iVar10 = iVar5 + 2;
            break;
          }
          iVar5 = iVar10;
          if (*pcVar4 != ' ') goto LAB_a029d2f0;
        }
        if (iVar10 == 0) goto LAB_a029d2f0;
      }
      iVar10 = (uVar3 - param_1) - iVar10;
      iVar6 = iVar10;
      if (local_2a8 == 0) {
        iVar5 = matched_FUN_a04f9ea4(param_1,&local_283);
        if (iVar5 != 0) {
          iVar5 = iVar5 - param_1;
          local_2a0 = matched_FUN_a04f99f0(&local_283);
          iVar12 = iVar5 + -1;
          local_2a0 = local_2a0 + iVar5;
          if (iVar12 < iVar9) goto LAB_a029d2f0;
          if (*(char *)(param_1 + iVar12) == ';') {
            iVar6 = 1;
          }
          else {
            if (*(char *)(param_1 + iVar12) != ' ') goto LAB_a029d2f0;
            pcVar4 = (char *)(param_1 + iVar12);
            iVar7 = 0;
            while( true ) {
              iVar12 = iVar12 + -1;
              iVar6 = iVar7 + 1;
              if (iVar12 < iVar9) break;
              pcVar4 = pcVar4 + -1;
              if (*pcVar4 == ';') {
                iVar6 = iVar7 + 2;
                break;
              }
              iVar7 = iVar6;
              if (*pcVar4 != ' ') goto LAB_a029d2f0;
            }
            if (iVar6 == 0) goto LAB_a029d2f0;
          }
          iVar6 = iVar5 - iVar6;
          iVar12 = iVar10;
        }
      }
      uVar13 = local_2a8 + 1U & 0xff;
    }
    local_2a8 = local_2a8 + 1;
    puVar11 = puVar11 + 7;
  } while (local_2a8 != 4);
  if (uVar13 == 0) {
    iVar6 = matched_FUN_a029cb84(param_1);
    return iVar6;
  }
  if (uVar13 == 5) {
LAB_a029d2f0:
    (*DAT_a06f3068)(s_The_input_string_can_not_be_reco_a05ae404);
    return -1;
  }
  iVar14 = param_1 + iVar14;
  *(undefined1 *)(param_1 + iVar8) = 0;
  *(undefined1 *)(param_1 + iVar6) = 0;
  if ((iVar14 == 0) || (iVar6 = matched_FUN_a04f99f0(iVar14), iVar6 < 2)) {
LAB_a029d098:
    switch(uVar13) {
    case 1:
switchD_a029d0a0_caseD_1:
      iVar6 = matched_FUN_a029cb84(auStack_228);
      break;
    case 2:
switchD_a029d0a0_caseD_2:
      iVar6 = matched_FUN_a04fb328(iVar14,0,0);
      goto LAB_a029d1b4;
    case 3:
      goto switchD_a029d0a0_caseD_3;
    case 4:
      goto switchD_a029d0a0_caseD_4;
    default:
      goto switchD_a029d070_default;
    }
  }
  else {
    iVar10 = 0;
    iVar8 = -1;
    do {
      cVar1 = *(char *)(iVar14 + iVar10);
      if (cVar1 == '$') {
        if (*(char *)(iVar14 + iVar10 + 1) != '?') goto LAB_a029d098;
        iVar10 = iVar10 + 1;
        iVar8 = 0;
      }
      else if (cVar1 != ' ' && cVar1 != ';') goto LAB_a029d098;
      iVar10 = iVar10 + 1;
    } while (iVar10 < iVar6 + -1);
    switch(uVar13) {
    case 1:
      if (iVar8 != 0) goto switchD_a029d0a0_caseD_1;
      iVar6 = DAT_a14466a8;
      break;
    case 2:
      if (iVar8 != 0) goto switchD_a029d0a0_caseD_2;
      iVar6 = DAT_a14466a8;
LAB_a029d1b4:
      if (0 < iVar6) {
        iVar12 = 0;
        do {
          (*DAT_a06f3068)(s_Loop__d_a05ae454,iVar12);
          matched_FUN_a04f9900(auStack_128,param_1 + iVar9);
          iVar12 = iVar12 + 1;
          iVar14 = matched_FUN_a029cb84(auStack_128);
        } while (iVar12 != iVar6);
        return iVar14;
      }
switchD_a029d070_default:
      return 0;
    case 3:
      if (iVar8 == 0) {
        if (DAT_a14466a8 == 0) {
          return 0;
        }
        do {
          matched_FUN_a04f9900(auStack_128,param_1 + iVar9);
          iVar6 = matched_FUN_a029cb84(auStack_128);
        } while (iVar6 != 0);
        return 0;
      }
switchD_a029d0a0_caseD_3:
      iVar6 = 0;
      matched_FUN_a04f9900(auStack_228,iVar14);
      while( true ) {
        iVar12 = matched_FUN_a029cb84(auStack_228);
        if (iVar12 == 0) break;
        matched_FUN_a04f9900(auStack_128,param_1 + iVar9);
        iVar6 = matched_FUN_a029cb84(auStack_128);
        matched_FUN_a04f9900(auStack_228,iVar14);
      }
      goto LAB_a029d0c0;
    case 4:
      if (iVar8 == 0) {
        if (DAT_a14466a8 != 0) {
          return DAT_a14466a8;
        }
        do {
          matched_FUN_a04f9900(auStack_128,param_1 + iVar9);
          iVar6 = matched_FUN_a029cb84(auStack_128);
        } while (iVar6 == 0);
        return iVar6;
      }
switchD_a029d0a0_caseD_4:
      iVar6 = 0;
      matched_FUN_a04f9900(auStack_228,iVar14);
      while( true ) {
        iVar12 = matched_FUN_a029cb84(auStack_228);
        if (iVar12 != 0) break;
        matched_FUN_a04f9900(auStack_128,param_1 + iVar9);
        iVar6 = matched_FUN_a029cb84(auStack_128);
        matched_FUN_a04f9900(auStack_228,iVar14);
      }
      goto LAB_a029d0c0;
    default:
      goto switchD_a029d070_default;
    }
  }
  if (iVar6 == 0) {
    iVar6 = matched_FUN_a029cb84(param_1 + iVar9);
  }
  else if (0 < iVar12) {
    *(undefined1 *)(param_1 + iVar12) = 0;
    iVar6 = matched_FUN_a029cb84(param_1 + local_2a0);
  }
LAB_a029d0c0:
  return iVar6;
}

