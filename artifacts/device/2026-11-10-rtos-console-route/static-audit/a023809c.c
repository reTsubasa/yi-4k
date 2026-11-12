/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void console_audit_a023809c(void)

{
  undefined4 *puVar1;
  int *piVar2;
  undefined1 *puVar3;
  int iVar4;
  undefined1 *puVar5;
  int local_34 [10];
  
  puVar3 = DAT_a0238154;
  local_34[0] = 0;
  local_34[1] = 0;
  local_34[2] = 0;
  local_34[3] = 0;
  local_34[4] = 0;
  local_34[5] = 0;
  local_34[6] = 0;
  local_34[7] = 0;
  local_34[8] = 0;
  do {
    while (iVar4 = matched_FUN_a03bc56c(DAT_a0238158,local_34,0xffffffff), iVar4 != 0) {
      matched_analyst_task_sleep(1);
    }
    puVar5 = &DAT_a14307b8;
    matched_FUN_a03bc46c(DAT_a023815c,0xffffffff);
LAB_a023810c:
    do {
      puVar1 = (undefined4 *)(puVar5 + 0x1dc);
      if ((code *)*puVar1 != (code *)0x0) {
        piVar2 = (int *)(puVar5 + 0x1e0);
        if (*piVar2 == local_34[0]) {
          puVar5 = puVar5 + 8;
          (*(code *)*puVar1)(*piVar2,local_34 + 3);
          if (puVar5 == puVar3) break;
          goto LAB_a023810c;
        }
      }
      puVar5 = puVar5 + 8;
    } while (puVar5 != puVar3);
    matched_thunk_FUN_a03c3c5c(DAT_a023815c);
  } while( true );
}

