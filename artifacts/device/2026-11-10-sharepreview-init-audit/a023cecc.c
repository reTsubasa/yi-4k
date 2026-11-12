/* Ghidra-generated pseudocode, not original source.
 * Entry: 0xa023cecc, name: matched_FUN_a023cecc.
 * Types and names may be inferred. Runtime validation not performed. */


undefined4 matched_FUN_a023cecc(int param_1,int param_2)

{
  int iVar1;
  undefined4 uVar2;
  
  if (param_1 == 0) {
    FUN_a02a70ec(s__s_AppLib___NetBase__<InitAmbaLi_a05a25f8,DAT_a06f3080);
    uVar2 = 0xffffffff;
  }
  else {
    FUN_a02a70ec(s__s_AppLib___NetBase__<InitAmbaLi_a05a264c,DAT_a06f3084);
    DAT_a17e0144 = matched_FUN_a023cca4;
    DAT_a1796f5c = &LAB_a023cd80;
    DAT_a1445324 = param_1;
    matched_FUN_a03cd46c();
    matched_FUN_a03cd3b4();
    matched_thunk_FUN_a03cf31c(10000);
    iVar1 = matched_FUN_a029a7d8(DAT_a13a23e4,&DAT_a143af98,&DAT_a143af94,0x800,0x20);
    if (iVar1 < 0) {
      FUN_a02a70ec(s__s_AppLib___NetBase__<InitAmbaLi_a05a2684,DAT_a06f3080);
      uVar2 = 0xffffffff;
    }
    else {
      matched_analyst_task_create
                (&DAT_a143af9c,s_HookDefaultUserRPCTask_a05a26c4,0x32,matched_FUN_a023c0bc,
                 param_2 == 1,DAT_a143af98,0x800,1);
      iVar1 = matched_FUN_a03c44d8(&DAT_a143af9c,&LAB_a023cc54);
      uVar2 = 0;
      if (iVar1 != 0) {
        FUN_a02a70ec(s__s_AppLib___NetBase__<InitAmbaLi_a05a26dc,DAT_a06f3080);
        uVar2 = 0;
      }
    }
  }
  return uVar2;
}

