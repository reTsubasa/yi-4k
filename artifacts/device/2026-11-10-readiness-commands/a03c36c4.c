/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03c36c4, name: matched_FUN_a03c36c4.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4
matched_FUN_a03c36c4
          (int *param_1,int *param_2,int *param_3,int *param_4,int *param_5,int *param_6,
          int *param_7)

{
  if ((param_1 == (int *)0x0) || (*param_1 != 0x42595445)) {
    return 2;
  }
  matched_FUN_a03c13b0();
  if (param_2 != (int *)0x0) {
    *param_2 = param_1[1];
  }
  if (param_3 != (int *)0x0) {
    *param_3 = param_1[2];
  }
  if (param_4 != (int *)0x0) {
    *param_4 = param_1[3];
  }
  if (param_5 != (int *)0x0) {
    *param_5 = param_1[9];
  }
  if (param_6 != (int *)0x0) {
    *param_6 = param_1[10];
  }
  if (param_7 != (int *)0x0) {
    *param_7 = param_1[0xb];
  }
  matched_FUN_a03c1428();
  return 0;
}

