/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0231538, name: matched_FUN_a0231538.
 * Types and names may be inferred. Runtime validation not performed. */


void matched_FUN_a0231538(void)

{
  int iVar1;
  undefined4 local_41c;
  undefined1 auStack_418 [1024];
  
  matched_FUN_a04f8dec(auStack_418,0,0x400);
  FUN_a02a70ec(s__I__USB_UART___06d___s__start_a059fe5c,0x69,s_AppCdcAcmd_Task_a059fdd4);
LAB_a0231590:
  do {
    if (DAT_a06e63fc != 1) {
LAB_a0231608:
      matched_FUN_a03bc4e8(&DAT_a142f7d8,1);
      FUN_a02a70ec(s__I__USB_UART___06d___s__end_a059fe40,0x84,s_AppCdcAcmd_Task_a059fdd4);
      return;
    }
    iVar1 = matched_FUN_a04b3dc8();
    if (iVar1 != 1) {
LAB_a0231588:
      matched_analyst_task_sleep(DAT_a06e63f4);
      goto LAB_a0231590;
    }
    local_41c = 0;
    matched_FUN_a0232518(DAT_a06e6414,0x72);
    iVar1 = matched_FUN_a023297c(DAT_a06e6414,auStack_418,DAT_a06e63f8,100);
    if (iVar1 < 1) {
      matched_FUN_a023273c(DAT_a06e6414,0x72,&local_41c);
      goto LAB_a0231588;
    }
    iVar1 = matched_FUN_a04b3de8(auStack_418);
    matched_FUN_a023273c(DAT_a06e6414,0x72);
    if (iVar1 != 0xd) {
      if (iVar1 == 0) goto LAB_a0231588;
      goto LAB_a0231608;
    }
    FUN_a02a70ec(s__s_E__USB_UART___06d___s__Bulk_S_a059fe7c,DAT_a06f3084,0x71,
                 s_AppCdcAcmd_Task_a059fdd4,0xd);
  } while( true );
}

