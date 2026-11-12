/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 app_log_open_file(undefined1 *param_1)

{
  longlong lVar1;
  int iVar2;
  int iVar3;
  undefined4 uVar4;
  int local_3c;
  int local_38;
  uint local_34;
  int local_30;
  
  if (param_1 == (undefined1 *)0x0) {
    return 0xffffffff;
  }
  iVar2 = app_log_status();
  if (iVar2 < 1) {
    FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Save_l_a055fde8,DAT_a06f3084,0x1607,
                 s_AppUtil_DumpLog2FileOpen_a055e8f0);
    uVar4 = 0xffffffff;
  }
  else {
    print_close_log_output();
    iVar2 = matched_analyst_fs_fopen(param_1,s__d__d_raw_a0576b54 + 8);
    if (iVar2 == 0) {
      uVar4 = 0xfffffffd;
    }
    else {
      iVar3 = matched_thunk_FUN_a033a3e0(*param_1,&local_3c);
      if (iVar3 < 0) {
        FUN_a02a70ec(s__s_E__APP_UTIL___06d___s__Cannot_a055fe18,DAT_a06f3084,0x1610,
                     s_AppUtil_DumpLog2FileOpen_a055e8f0,*param_1);
        uVar4 = 0xfffffffe;
      }
      else {
        lVar1 = (ulonglong)local_34 * (ulonglong)(uint)(local_38 * local_30);
        FUN_a02a70ec(s__I__APP_UTIL___06d___s___Drive_s_a055fe60,0x1617,
                     s_AppUtil_DumpLog2FileOpen_a055e8f0,local_30 * local_3c,
                     (ulonglong)local_34 * (ulonglong)(uint)(local_30 * local_3c),
                     (ulonglong)local_34 * (ulonglong)(uint)(local_30 * (local_3c - local_38)),lVar1
                    );
        matched_FUN_a02a6aa8((int)lVar1,(int)((ulonglong)lVar1 >> 0x20));
        print_set_file_callback(app_log_write_and_flush,iVar2);
        matched_FUN_a02a6ba0(app_log_close_file);
        matched_FUN_a0196f88();
        uVar4 = 0;
      }
    }
  }
  return uVar4;
}

