/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03c4500, name: matched_FUN_a03c4500.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4
matched_FUN_a03c4500
          (int *param_1,int *param_2,int *param_3,int *param_4,int *param_5,int *param_6,
          int *param_7,int *param_8,int *param_9)

{
  if ((param_1 == (int *)0x0) || (*param_1 != 0x54485244)) {
    return 0xe;
  }
  matched_FUN_a03c13b0();
  if (param_2 != (int *)0x0) {
    *param_2 = param_1[10];
  }
  if (param_3 != (int *)0x0) {
    *param_3 = param_1[0xc];
  }
  if (param_4 != (int *)0x0) {
    *param_4 = param_1[1];
  }
  if (param_5 != (int *)0x0) {
    *param_5 = param_1[0x2c];
  }
  if (param_6 != (int *)0x0) {
    *param_6 = param_1[0x2d];
  }
  if (param_7 != (int *)0x0) {
    *param_7 = param_1[6];
  }
  if (param_8 != (int *)0x0) {
    *param_8 = param_1[0x23];
  }
  if (param_9 != (int *)0x0) {
    *param_9 = param_1[0x1d];
  }
  matched_FUN_a03c1428();
  return 0;
}

