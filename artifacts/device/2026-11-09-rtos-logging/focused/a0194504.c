/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


bool file_stat_status_probe(char *param_1)

{
  int iVar1;
  undefined4 local_28;
  undefined4 local_24;
  int local_20;
  int local_1c;
  undefined4 local_18;
  undefined4 local_14;
  undefined4 local_10;
  undefined4 local_c;
  
  local_28 = 0;
  local_24 = 0;
  local_20 = 0;
  local_1c = 0;
  local_18 = 0;
  local_14 = 0;
  local_10 = 0;
  local_c = 0;
  if (((param_1 == (char *)0x0) || (*param_1 == '\0')) ||
     (iVar1 = matched_FUN_a032e194(param_1,&local_28), iVar1 != 0)) {
    return true;
  }
  return local_20 == 0 && local_1c == 0;
}

