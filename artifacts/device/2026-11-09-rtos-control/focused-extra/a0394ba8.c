/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int eis_debug_shortcuts(int param_1,int param_2)

{
  if (param_1 == 2) {
    if (param_2 == 0) {
      DAT_a0757b0c = 0;
    }
    else {
      DAT_a0757b0c = 1;
      param_1 = FUN_a02a70ec(s__EIS_debug__enable_gyro_sample_l_a0600c24);
    }
  }
  else if (param_1 == 3) {
    if (param_2 == 0) {
      DAT_a0757b08 = 0;
    }
    else {
      DAT_a0757b08 = 1;
      param_1 = FUN_a02a70ec(s__EIS_debug__enable_1ms_task_chec_a0600c50);
    }
  }
  else if (param_1 == 1) {
    if (param_2 == 0) {
      DAT_a0757af8 = 0;
    }
    else {
      DAT_a0757af8 = 1;
      param_1 = FUN_a02a70ec(s__EIS_debug__enable_frame_check_a0600c04);
    }
  }
  else {
    param_1 = FUN_a02a70ec(s__sInvalid_EIS_debug_item_____a0600c74,DAT_a06f3080);
  }
  return param_1;
}

