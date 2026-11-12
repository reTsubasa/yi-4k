/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03bc77c, name: matched_FUN_a03bc77c.
 * Types and names may be inferred. Runtime validation not performed. */


int matched_FUN_a03bc77c(undefined4 param_1,int *param_2,int param_3,int param_4)

{
  int iVar1;
  int extraout_r1;
  int iVar2;
  
  iVar1 = matched_FUN_a03c3448(param_1,param_2,param_3 + param_4,0,param_4);
  if (iVar1 == 0) {
    iVar2 = *param_2;
    if ((param_4 != 0) && (matched_FUN_a0506674(iVar2,param_4), extraout_r1 != 0)) {
      iVar2 = (param_4 + iVar2) - extraout_r1;
    }
    param_2[1] = iVar2;
  }
  return iVar1;
}

