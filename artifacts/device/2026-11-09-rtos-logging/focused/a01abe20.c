/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


undefined4 ants_save_log_handler(int param_1,undefined4 *param_2,code *param_3)

{
  int iVar1;
  undefined4 uVar2;
  
  if (param_1 < 1) {
LAB_a01abeac:
    (*param_3)(s_save_log_on_off__a056a92c);
    return 0xffffffff;
  }
  uVar2 = *param_2;
  iVar1 = matched_FUN_a04f9744(uVar2,s_dsp_dec_cmd_on_a05ccad8 + 0xc);
  if (iVar1 == 0) {
    *(undefined1 *)(DAT_a1055cd4 + 0xa3) = 1;
  }
  else {
    iVar1 = matched_FUN_a04f9744(uVar2,s_dsp_dec_cmd_off_a05ccae8 + 0xc);
    if (iVar1 != 0) goto LAB_a01abeac;
    *(undefined1 *)(DAT_a1055cd4 + 0xa3) = 0;
  }
  matched_FUN_a018c6d8();
  (*param_3)(s_save_log__s_done__a056a940,*param_2);
  return 0;
}

