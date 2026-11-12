/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa029a7d8, name: matched_FUN_a029a7d8.
 * Types and names may be inferred. Runtime validation not performed. */


void matched_FUN_a029a7d8(undefined4 param_1,int *param_2,uint *param_3,int param_4,uint param_5)

{
  int iVar1;
  
  if (param_5 < 0x20) {
    iVar1 = 0x40;
    param_5 = 0x20;
  }
  else {
    iVar1 = param_5 << 1;
  }
  iVar1 = matched_analyst_pool_alloc(param_1,param_3,iVar1 + param_4,500);
  if (iVar1 == 0) {
    *param_2 = (*param_3 & ~(param_5 - 1)) + param_5;
  }
  return;
}

