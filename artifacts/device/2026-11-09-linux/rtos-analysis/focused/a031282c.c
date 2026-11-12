/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


int warp_get(char *param_1,int param_2)

{
  int iVar1;
  undefined4 local_28;
  int local_24;
  int local_20;
  char local_1c;
  char local_1b;
  
  local_24 = 0;
  local_20 = 0;
  if (param_2 == 0) {
    FUN_a02a70ec(s_Warning__pWarpCalcInfo_is_empty__a05e6e1c);
    return -1;
  }
  local_1c = *param_1;
  local_1b = param_1[3];
  iVar1 = FUN_a0308880(&local_1c,&local_28);
  if (iVar1 < 0) {
    FUN_a02a70ec(s_Warning__Cannot_get_context_mute_a05d0f84);
    return iVar1;
  }
  matched_FUN_a03bc46c(local_28,0);
  if (*param_1 == '\0') {
    FUN_a0308754(&local_1c,&local_24);
    iVar1 = local_24 + 0x2f18;
  }
  else {
    if (*param_1 != '\x01') {
      FUN_a02a70ec(s_Warning__AmbaDSP_ImgGetWarpCompe_a05e6e40);
      matched_thunk_FUN_a03c3c5c(local_28);
      return -1;
    }
    FUN_a0308754(&local_1c,&local_20);
    iVar1 = local_20 + 0x52a90;
  }
  matched_FUN_a029c680(param_2,iVar1,0xc0);
  matched_thunk_FUN_a03c3c5c(local_28);
  return 0;
}

