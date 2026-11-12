/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int shell_exec_direct(int param_1)

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
  int iStack_2a8;
  int iStack_2a0;
  undefined4 uStack_298;
  undefined2 uStack_294;
  undefined1 uStack_292;
  char acStack_291 [4];
  char acStack_28d [2];
  undefined1 uStack_28b;
  undefined2 uStack_28a;
  undefined1 uStack_288;
  undefined1 uStack_287;
  undefined1 uStack_286;
  undefined1 uStack_285;
  undefined1 uStack_284;
  undefined4 uStack_283;
  undefined2 uStack_27f;
  undefined1 uStack_27d;
  undefined4 uStack_27c;
  undefined2 uStack_278;
  undefined1 uStack_276;
  undefined4 uStack_275;
  undefined1 uStack_271;
  undefined1 uStack_270;
  undefined1 uStack_26f;
  undefined4 uStack_26e;
  undefined1 uStack_26a;
  undefined1 uStack_269;
  undefined1 uStack_268;
  char acStack_260 [4];
  undefined2 uStack_25c;
  undefined1 uStack_25a;
  undefined4 uStack_259;
  undefined1 uStack_255;
  undefined1 uStack_254;
  undefined1 uStack_253;
  undefined4 uStack_252;
  undefined1 uStack_24e;
  undefined1 uStack_24d;
  undefined1 uStack_24c;
  char acStack_244 [4];
  undefined2 uStack_240;
  undefined1 uStack_23e;
  undefined4 uStack_23d;
  undefined1 uStack_239;
  undefined1 uStack_238;
  undefined1 uStack_237;
  undefined4 uStack_236;
  undefined1 uStack_232;
  undefined1 uStack_231;
  undefined1 uStack_230;
  undefined1 auStack_228 [256];
  undefined1 auStack_128 [260];
  
  matched_FUN_a04f8dec(auStack_228,0,0x100);
  matched_FUN_a04f8dec(auStack_128,0,0x100);
  if (param_1 == 0) {
    return -1;
  }
  matched_FUN_a04f8dec(&uStack_298,0,0x70);
  uStack_298 = 0x206669;
  acStack_291[0] = s_then_a05ae3b0[0];
  acStack_291[1] = s_then_a05ae3b0[1];
  acStack_291[2] = s_then_a05ae3b0[2];
  acStack_291[3] = s_then_a05ae3b0[3];
  puVar11 = &uStack_298;
  uStack_283 = DAT_a05ae3c0;
  uStack_27c = DAT_a05ae3c8;
  uStack_27f = DAT_a05ae3c4;
  uStack_278 = (undefined2)DAT_a05ae3cc;
  iVar12 = 0;
  uStack_275 = DAT_a05ae3d0;
  uStack_288 = DAT_a05ae3ba;
  uStack_28a = DAT_a05ae3b8;
  acStack_28d[0] = s_then_a05ae3b0[4];
  acStack_28d[1] = s_then_a05ae3b0[5];
  iVar9 = 0;
  uStack_26e = DAT_a05ae3d8;
  iVar6 = 0;
  uStack_294 = 0;
  uStack_292 = 0;
  iStack_2a0 = 0;
  uStack_28b = 0;
  uStack_287 = 0;
  uStack_286 = 0;
  uStack_285 = 0;
  uStack_284 = 0;
  uStack_27d = 0;
  uStack_276 = 0;
  uStack_271 = 0;
  uStack_270 = 0;
  uStack_26f = 0;
  uStack_269 = 0;
  acStack_260[0] = s_until_a05ae460[0];
  acStack_260[1] = s_until_a05ae460[1];
  acStack_260[2] = s_until_a05ae460[2];
  acStack_260[3] = s_until_a05ae460[3];
  uStack_25c = (undefined2)ram0xa05ae464;
  uStack_26a = DAT_a05ae3dc;
  uStack_259 = DAT_a05ae3d0;
  uStack_24e = DAT_a05ae3dc;
  uStack_232 = DAT_a05ae3dc;
  iVar14 = 0;
  uStack_252 = DAT_a05ae3d8;
  iVar8 = 0;
  uStack_25a = (undefined1)((uint)ram0xa05ae464 >> 0x10);
  uVar13 = 0;
  uStack_268 = 0;
  acStack_244[0] = s_while_a05ae468[0];
  acStack_244[1] = s_while_a05ae468[1];
  acStack_244[2] = s_while_a05ae468[2];
  acStack_244[3] = s_while_a05ae468[3];
  uStack_255 = 0;
  uStack_254 = 0;
  uStack_23d = DAT_a05ae3d0;
  uStack_24d = 0;
  uStack_24c = 0;
  uStack_236 = DAT_a05ae3d8;
  uStack_240 = (undefined2)ram0xa05ae46c;
  uStack_239 = 0;
  uStack_238 = 0;
  uStack_231 = 0;
  uStack_253 = 0;
  uStack_237 = 0;
  uStack_23e = (undefined1)((uint)ram0xa05ae46c >> 0x10);
  iStack_2a8 = 0;
  uStack_230 = 0;
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
      if (iStack_2a8 == 0) {
        iVar5 = matched_FUN_a04f9ea4(param_1,&uStack_283);
        if (iVar5 != 0) {
          iVar5 = iVar5 - param_1;
          iStack_2a0 = matched_FUN_a04f99f0(&uStack_283);
          iVar12 = iVar5 + -1;
          iStack_2a0 = iStack_2a0 + iVar5;
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
      uVar13 = iStack_2a8 + 1U & 0xff;
    }
    iStack_2a8 = iStack_2a8 + 1;
    puVar11 = puVar11 + 7;
  } while (iStack_2a8 != 4);
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
    iVar6 = matched_FUN_a029cb84(param_1 + iStack_2a0);
  }
LAB_a029d0c0:
  return iVar6;
}

