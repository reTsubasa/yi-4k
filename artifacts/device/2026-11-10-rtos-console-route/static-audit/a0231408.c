/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa0231408, name: matched_FUN_a0231408.
 * Types and names may be inferred. Runtime validation not performed. */


void matched_FUN_a0231408(void)

{
  int iVar1;
  undefined8 uVar2;
  undefined4 local_214;
  undefined1 auStack_210 [516];
  
  local_214 = 0;
  uVar2 = matched_FUN_a04f8dec(auStack_210,0,0x200);
joined_r0xa0231440:
  do {
    if (DAT_a06e63fc != 1) {
LAB_a0231464:
      matched_FUN_a03bc4e8(&DAT_a142f7d8,2);
      FUN_a02a70ec(s__I__USB_UART___06d___s__end_a059fe40,0xa6,s_AppCdcAcmd_RcvTask_a059fde4);
      return;
    }
    iVar1 = matched_FUN_a04b3dc8((int)uVar2,(int)((ulonglong)uVar2 >> 0x20));
    if (iVar1 == 1) {
      matched_FUN_a04f8dec(auStack_210,0,0x200);
      uVar2 = matched_FUN_a04b3e44(auStack_210,0x200,&local_214);
      iVar1 = (int)uVar2;
      if (iVar1 != 0 && iVar1 != 0xd) {
        FUN_a02a70ec(s__s_E__USB_UART___06d___s__Bulk_R_a059fe0c,DAT_a06f3084,0x92,
                     s_AppCdcAcmd_RcvTask_a059fde4,iVar1);
        goto LAB_a0231464;
      }
      if ((iVar1 != 0xd) && (uVar2 = CONCAT44(0x77,DAT_a06e6410), -1 < DAT_a06e6410)) {
        matched_FUN_a0232518();
        matched_FUN_a0232bf0(DAT_a06e6410,auStack_210,local_214,1000);
        uVar2 = matched_FUN_a023273c(DAT_a06e6410,0x77);
      }
      goto joined_r0xa0231440;
    }
    uVar2 = matched_analyst_task_sleep(100);
  } while( true );
}

