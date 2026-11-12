/* Device 1.10.7 Ghidra pseudocode; names/types inferred, not original source. */


bool file_exists_probe(char *param_1)

{
  bool bVar1;
  int iVar2;
  undefined4 local_28;
  undefined4 local_24;
  undefined4 local_20;
  undefined4 local_1c;
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
  if (param_1 == (char *)0x0) {
    return false;
  }
  if (*param_1 == '\0') {
    bVar1 = false;
  }
  else {
    iVar2 = matched_FUN_a032e194(param_1,&local_28);
    bVar1 = iVar2 == 0;
  }
  return bVar1;
}

