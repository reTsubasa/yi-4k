/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa029c974, name: FUN_a029c974.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4 FUN_a029c974(int param_1)

{
  char cVar1;
  bool bVar2;
  char *pcVar3;
  bool bVar4;
  undefined4 uVar5;
  int iVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  undefined4 *puVar11;
  code *pcVar12;
  int iVar13;
  undefined1 *puVar14;
  char *pcVar15;
  char *local_a0;
  int local_9c [32];
  
  if (param_1 == 0) {
    return 0xffffffff;
  }
  local_a0 = (char *)matched_FUN_a04fb00c(param_1,&DAT_a05ae3e8);
  if (local_a0 == (char *)0x0) {
    return 0;
  }
  cVar1 = *local_a0;
  if (cVar1 == '#') {
    uVar5 = 0;
  }
  else {
    puVar11 = &DAT_a06f2ea0;
    do {
      iVar6 = matched_FUN_a04f9744(local_a0,*puVar11);
      if (iVar6 == 0) {
        pcVar12 = (code *)puVar11[1];
        if (pcVar12 != (code *)0x0) {
          iVar6 = matched_FUN_a04fb00c(0,&DAT_a05a6c90);
          if ((iVar6 == 0) || (iVar7 = matched_FUN_a04f99f0(), iVar7 < 1)) {
            iVar8 = 1;
          }
          else {
            iVar8 = 1;
            bVar2 = false;
            iVar10 = 0;
            do {
              cVar1 = *(char *)(iVar6 + iVar10);
              puVar14 = (undefined1 *)(iVar6 + iVar10);
              if (cVar1 == ' ' || cVar1 == '\t') {
                iVar13 = iVar10 + 1;
                bVar4 = false;
                if (bVar2) {
                  *puVar14 = 0;
                }
              }
              else if (cVar1 == '\'') {
                iVar13 = iVar10 + 1;
                local_9c[iVar8 + -1] = (int)puVar14;
                if (iVar13 < iVar7) {
                  pcVar15 = (char *)(iVar6 + iVar13);
                  iVar9 = iVar13;
                  if (*(char *)(iVar6 + iVar13) != '\'') {
                    pcVar3 = (char *)(iVar6 + iVar10 + 2);
                    do {
                      pcVar15 = pcVar3;
                      iVar9 = iVar9 + 1;
                      if (iVar7 <= iVar9) goto LAB_a029caec;
                      pcVar3 = pcVar15 + 1;
                    } while (*pcVar15 != '\'');
                  }
                  bVar4 = false;
                  local_9c[iVar8 + -1] = iVar6 + iVar13;
                  iVar13 = iVar9 + 1;
                  *pcVar15 = '\0';
                }
                else {
LAB_a029caec:
                  bVar4 = true;
                }
                iVar8 = iVar8 + 1;
              }
              else {
                if (!bVar2) {
                  local_9c[iVar8 + -1] = (int)puVar14;
                  iVar8 = iVar8 + 1;
                }
                iVar13 = iVar10 + 1;
                bVar4 = true;
              }
              bVar2 = bVar4;
              iVar10 = iVar13;
            } while (iVar13 < iVar7 && iVar8 < 0x20);
          }
          DAT_a14466a8 = (*pcVar12)(iVar8,&local_a0,DAT_a06f3068);
          return DAT_a14466a8;
        }
        break;
      }
      puVar11 = (undefined4 *)puVar11[2];
    } while (puVar11 != (undefined4 *)0x0);
    if (cVar1 != '\0') {
      (*DAT_a06f3068)(s__s__command_not_found_a05ae3ec,local_a0);
    }
    uVar5 = 0xffffffff;
  }
  return uVar5;
}

