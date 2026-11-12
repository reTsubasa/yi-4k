/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa03caab4, name: matched_FUN_a03caab4.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4
matched_FUN_a03caab4
          (int param_1,int param_2,int param_3,undefined4 param_4,undefined4 param_5,
          undefined4 param_6,int *param_7,int param_8)

{
  int *piVar1;
  int *piVar2;
  int iVar3;
  undefined4 *puVar4;
  
  puVar4 = DAT_a0789608;
  if ((int **)DAT_a0789608 != &DAT_a0789608) {
    do {
      if ((param_1 == puVar4[-0x1e]) && (param_2 == puVar4[-0x1d])) {
        if (puVar4 + -0x1e != (int *)0x0) {
          FUN_a02a70ec(s_Prog__d_has_been_resgistered_alr_a060e328,param_1);
          return 1;
        }
        break;
      }
      puVar4 = (undefined4 *)*puVar4;
    } while ((int **)puVar4 != &DAT_a0789608);
  }
  piVar2 = (int *)matched_FUN_a03cd2d8(DAT_a14452e4 + 0x39c);
  matched_FUN_a04f8dec(piVar2,0,0x39c);
  *piVar2 = param_1;
  piVar2[1] = param_2;
  piVar2[0x20] = param_3;
  piVar2[0xd1] = param_8;
  piVar2[0xd2] = *param_7;
  iVar3 = matched_FUN_a03cd2d8(*param_7 << 3);
  piVar2[0xd3] = iVar3;
  matched_FUN_a029c680(iVar3,param_7[1],*param_7 << 3);
  matched_FUN_a03c87a0(piVar2 + 2,piVar2,matched_FUN_a03ca870);
  DAT_a0789608[1] = (int)(piVar2 + 0x1e);
  piVar1 = piVar2 + 0x1e;
  piVar2[0x1e] = (int)DAT_a0789608;
  DAT_a0789608 = piVar1;
  piVar2[0x1f] = (int)&DAT_a0789608;
  if (param_8 == 0) {
    return 0;
  }
  matched_analyst_task_create
            (piVar2 + 0x21,param_3,param_4,matched_FUN_a03cae84,piVar2,param_5,param_6,1);
  return 0;
}

