/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


void print_worker(void)

{
  code *pcVar1;
  int iVar2;
  int iVar3;
  int extraout_r1;
  bool bVar4;
  undefined1 auStack_2c [8];
  
  do {
    do {
      matched_FUN_a03bc4ac(DAT_a02a67d0,1,1,auStack_2c,500);
      iVar2 = matched_FUN_a03bc46c(DAT_a02a67d4,0);
      if (iVar2 == 0) {
        if (DAT_a144b984 != 0) {
          print_flush_console_buffer();
        }
        matched_thunk_FUN_a03c3c5c(DAT_a02a67d4);
      }
      iVar2 = matched_FUN_a03bc46c(DAT_a02a67d8,0);
      if (iVar2 == 0) {
        if (DAT_a02a67dc != 0) {
          print_flush_log_buffer(&DAT_a144b780,DAT_a02a67dc,1);
        }
        matched_thunk_FUN_a03c3c5c(DAT_a02a67d8);
      }
      iVar2 = matched_FUN_a02a7ed0();
    } while ((0 < iVar2) && (iVar2 <= DAT_a144d9a8));
    matched_FUN_a02a80c0();
    while (iVar3 = matched_FUN_a02a8078(DAT_a144d9a8), DAT_a144d9ac <= iVar3) {
      if (DAT_a144d99c != 0) {
        iVar3 = matched_FUN_a02a8094(DAT_a144d9a8,0xa0a620a0);
        pcVar1 = DAT_a144b97c;
        if (*(char *)(iVar3 + -0x5f59df60) == '\n') {
          iVar3 = iVar3 + -1;
        }
        bVar4 = DAT_a144b97c != (code *)0x0;
        *(undefined1 *)(iVar3 + -0x5f59df60) = 0xd;
        *(undefined1 *)(iVar3 + -0x5f59df5f) = 0;
        if (bVar4) {
          (*pcVar1)(iVar3 + 1,0xa0a620a0);
        }
      }
      iVar3 = matched_FUN_a02a8078(DAT_a144d9a8);
      DAT_a144d9ac = iVar3 + 1;
      matched_FUN_a0506924(DAT_a144d9a8 + 1,iVar2);
      DAT_a144d9a8 = extraout_r1;
      matched_FUN_a02a80c0(extraout_r1);
    }
  } while( true );
}

